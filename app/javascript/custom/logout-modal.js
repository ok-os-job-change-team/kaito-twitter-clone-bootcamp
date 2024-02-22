document.addEventListener('turbo:load', () => {
    // ログアウト用のモーダルウィンドウを表示
    const show_logout = document.getElementById('logout-button');
    show_logout.addEventListener('click', () => {
      const modal = document.getElementById('logout-modal-window');
      modal.classList.add('is-active');
    });   
    
    // ×ボタンでモーダルウィンドウを閉じる
    const close_delete = document.getElementById('close-modal-delete');
    close_delete.addEventListener('click', () => {
      const modal = document.getElementById('logout-modal-window');
      modal.classList.remove('is-active');
    });

    // いいえボタンでモーダルウィンドウを閉じる
    const close_cancel = document.getElementById('close-modal-cancel');
    close_cancel.addEventListener('click', () => {
      const modal = document.getElementById('logout-modal-window');
      modal.classList.remove('is-active');
    });ß
  });
