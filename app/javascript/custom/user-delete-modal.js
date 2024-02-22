document.addEventListener('turbo:load', () => {
    // アカウント削除用のモーダルウィンドウを表示
    const show_user_delete = document.getElementById('user-delete-button');
    show_user_delete.addEventListener('click', () => {
      const modal = document.getElementById('user-delete-modal-window');
      modal.classList.add('is-active');
    }); 
    
    // ×ボタンでモーダルウィンドウを閉じる
    const close_delete = document.getElementById('close-user-delete');
    close_delete.addEventListener('click', () => {
      const modal = document.getElementById('user-delete-modal-window');
      modal.classList.remove('is-active');
    });

    // いいえボタンでモーダルウィンドウを閉じる
    const close_cancel = document.getElementById('cancel-user-delete');
    close_cancel.addEventListener('click', () => {
      const modal = document.getElementById('user-delete-modal-window');
      modal.classList.remove('is-active');
    });
  });
