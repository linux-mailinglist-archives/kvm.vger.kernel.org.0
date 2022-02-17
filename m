Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2084B99E0
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 08:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbiBQHer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 02:34:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbiBQHen (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 02:34:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3AAE2A22AC
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 23:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645083267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c6FNb/hL4W43voQSLwLvNA7AH00yby7ekKu9J1pXf9E=;
        b=JHGWC50mW7YYyONpSgVNrnFFIk0hQUXCfb9fE452A98/9cp+Csapy5U0HBq3Vk2o3lfGQg
        UNKyfvyei7yS14Y0QGNp/YZhpHKZiBS8wdyEI7UJFw2db6I06YsBYE2aNsE950Tb9iPWCV
        xAJx052byHIINBsZGgo1nCdnBtrR2tw=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-Q3dbZfDHNKS8xHDGUfmc5w-1; Thu, 17 Feb 2022 02:34:26 -0500
X-MC-Unique: Q3dbZfDHNKS8xHDGUfmc5w-1
Received: by mail-lj1-f200.google.com with SMTP id c31-20020a2ebf1f000000b0022d87a28911so1906615ljr.1
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 23:34:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c6FNb/hL4W43voQSLwLvNA7AH00yby7ekKu9J1pXf9E=;
        b=vi6CDH+lQVCKCty97Y27KO7yA1lrJOr0tA7ts5uAIswDNi5SPgBdcClaXaPGpq3M+5
         7c+oHCpT4qAtd3SVxr7bMU20kIS5nNexiErT81yTiyNMRSKa2PivUpXQUkvbuHQX3MTl
         AtMZCyUwyZHxnth6VGpxufOzD1tLpNCI4LMIztsmz6xAkArn3rbygJmtVekUXCLc65OX
         4A7XO77k51YwUYal5I4CI6opdPQz7kf9iEzm2Xj7KWPmJBad10kgUgjl0GZbjXQmXuOr
         CzPB6qOrhcqmUUKa3SfStfOc9Kum1APBbMSfvI11BRoJ7x3ZAujlyTlECKJ6CWUgfDlQ
         leGA==
X-Gm-Message-State: AOAM532n8q9+8NYJxAuDZs6LLRj2UMsRRwpQpLWh2LVnKAlAUnVgS+Fj
        +is97DRwFFMt9HjFI8g+fXJnkH8BlgFmKUpZw8COMy0Nlj9cLLC1eoyDrM40DbP23o5lNxB2zWu
        KPmtcQF/GhSUiyEytgW4F3YqRVcsD
X-Received: by 2002:a05:6512:6c4:b0:437:9409:984c with SMTP id u4-20020a05651206c400b004379409984cmr1228081lff.199.1645083264465;
        Wed, 16 Feb 2022 23:34:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzCsXdhjl0wj4TBnHBnfKwMgEHk/ZSnUA2mQPfASqIHy1lxNAnvtj8QYS65ONbXtrbhqgm+OdVIRXU0OIq3mS0=
X-Received: by 2002:a05:6512:6c4:b0:437:9409:984c with SMTP id
 u4-20020a05651206c400b004379409984cmr1228069lff.199.1645083264248; Wed, 16
 Feb 2022 23:34:24 -0800 (PST)
MIME-Version: 1.0
References: <0000000000006f656005d82d24e2@google.com>
In-Reply-To: <0000000000006f656005d82d24e2@google.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 17 Feb 2022 15:34:13 +0800
Message-ID: <CACGkMEsyWBBmx3g613tr97nidHd3-avMyO=WRxS8RpcEk7j2=A@mail.gmail.com>
Subject: Re: [syzbot] WARNING in vhost_dev_cleanup (2)
To:     syzbot <syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com>
Cc:     kvm <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        mst <mst@redhat.com>, netdev <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 17, 2022 at 10:01 AM syzbot
<syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    c5d9ae265b10 Merge tag 'for-linus' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=132e687c700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a78b064590b9f912
> dashboard link: https://syzkaller.appspot.com/bug?extid=1e3ea63db39f2b4440e0
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
>
> WARNING: CPU: 1 PID: 10828 at drivers/vhost/vhost.c:715 vhost_dev_cleanup+0x8b8/0xbc0 drivers/vhost/vhost.c:715
> Modules linked in:
> CPU: 0 PID: 10828 Comm: syz-executor.0 Not tainted 5.17.0-rc4-syzkaller-00051-gc5d9ae265b10 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:vhost_dev_cleanup+0x8b8/0xbc0 drivers/vhost/vhost.c:715

Probably a hint that we are missing a flush.

Looking at vhost_vsock_stop() that is called by vhost_vsock_dev_release():

static int vhost_vsock_stop(struct vhost_vsock *vsock)
{
size_t i;
        int ret;

        mutex_lock(&vsock->dev.mutex);

        ret = vhost_dev_check_owner(&vsock->dev);
        if (ret)
                goto err;

Where it could fail so the device is not actually stopped.

I wonder if this is something related.

Thanks


> Code: c7 85 90 01 00 00 00 00 00 00 e8 53 6e a2 fa 48 89 ef 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f e9 7d d6 ff ff e8 38 6e a2 fa <0f> 0b e9 46 ff ff ff 48 8b 7c 24 10 e8 87 00 ea fa e9 75 f7 ff ff
> RSP: 0018:ffffc9000fe6fa18 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: dffffc0000000000 RCX: 0000000000000000
> RDX: ffff888021b63a00 RSI: ffffffff86d66fe8 RDI: ffff88801cc200b0
> RBP: ffff88801cc20000 R08: 0000000000000001 R09: 0000000000000001
> R10: ffffffff817f1e08 R11: 0000000000000000 R12: ffff88801cc200d0
> R13: ffff88801cc20120 R14: ffff88801cc200d0 R15: 0000000000000002
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2de25000 CR3: 000000004c9cd000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  vhost_vsock_dev_release+0x36e/0x4b0 drivers/vhost/vsock.c:771
>  __fput+0x286/0x9f0 fs/file_table.c:313
>  task_work_run+0xdd/0x1a0 kernel/task_work.c:164
>  exit_task_work include/linux/task_work.h:32 [inline]
>  do_exit+0xb29/0x2a30 kernel/exit.c:806
>  do_group_exit+0xd2/0x2f0 kernel/exit.c:935
>  get_signal+0x45a/0x2490 kernel/signal.c:2863
>  arch_do_signal_or_restart+0x2a9/0x1c40 arch/x86/kernel/signal.c:868
>  handle_signal_work kernel/entry/common.c:148 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>  exit_to_user_mode_prepare+0x17d/0x290 kernel/entry/common.c:207
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
>  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f4027a46481
> Code: Unable to access opcode bytes at RIP 0x7f4027a46457.
> RSP: 002b:00007f402808ba68 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
> RAX: fffffffffffffffc RBX: 00007f402622e700 RCX: 00007f4027a46481
> RDX: 00007f402622e9d0 RSI: 00007f402622e2f0 RDI: 00000000003d0f00
> RBP: 00007f402808bcb0 R08: 00007f402622e700 R09: 00007f402622e700
> R10: 00007f402622e9d0 R11: 0000000000000206 R12: 00007f402808bb1e
> R13: 00007f402808bb1f R14: 00007f402622e300 R15: 0000000000022000
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>

