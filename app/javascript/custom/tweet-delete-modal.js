document.addEventListener('turbo:load', () => {
    // ひとりごと削除用のモーダルウィンドウを表示
    const show_tweet_delete = document.getElementById('tweet-delete-button');
    show_tweet_delete.addEventListener('click', () => {
      const modal = document.getElementById('tweet-delete-modal-window');
      modal.classList.add('is-active');
    }); 
    
    // ×ボタンでモーダルウィンドウを閉じる
    const close_delete = document.getElementById('close-tweet-delete');
    close_delete.addEventListener('click', () => {
      const modal = document.getElementById('tweet-delete-modal-window');
      modal.classList.remove('is-active');
    });

    // いいえボタンでモーダルウィンドウを閉じる
    const close_cancel = document.getElementById('cancel-tweet-delete');
    close_cancel.addEventListener('click', () => {
      const modal = document.getElementById('tweet-delete-modal-window');
      modal.classList.remove('is-active');
    });
  });
