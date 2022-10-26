Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5654760E096
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 14:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbiJZMZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 08:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiJZMZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 08:25:49 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E8342AF8
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 05:25:46 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id b18so21557818ljr.13
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 05:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=N7pE9DDfhRLpLEXalXxynGwTI7Cu+4sadnoLGaVkfW0=;
        b=m9JYnj3EfalQ0PQJ5AQ4joVmuV4YD6+iN/RgZtZJkEfjlVE4XwxYLtXLDxyX8QfqlB
         H3RyFSbTobVZZSYvN+g6CLM12r7bjOKUx9fGETzsxvxBa+c2202LLfukD9NXucuOEpr4
         f3NRJUJ0eLaxlygVGTkMuRYAQbsexKDZcUquRbJ7Rn33fcfPTZZlu7Ea74hhoVVWiuG/
         YdICpTqVyNHxRnL/A0QWEsbBXWthmquic2zp9CUtLFi9R9KQ0siKDhWDe5IAC82iVdUs
         lq/YRy+ReWICeyGZ3kA3zdr62tJjrME3AoS891Q9F9tzVYjSeyzN5jgjLWNJVDLyCYwP
         tZ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N7pE9DDfhRLpLEXalXxynGwTI7Cu+4sadnoLGaVkfW0=;
        b=Md85PvH7P086R8BvTu/53pzCezoBNBC/7ozb5EbsSFrCqfG2fwtGZ1vLeo/7YJy/qT
         Cs/C9vvNXKOIDHq3F2cwHoLm+awCbNfVALd6vVTD4GaBH2uZQ49gaobmlyeHH1vObz90
         cnDro+hmxSUvYHXHcdLFGV+z5Yx/QurW9ANx0XaIwMSpghQY552xPj2aROUFjf6hVlmt
         WkLVxbp9f6hoL3THEHTa8CIMMCvyrytw554JVyvJvvrcuxVpoJGe/RN+5qhMt08ixtNN
         PVVvC0LgT2glect7Dh+6HcUllWYdo7PPlo1gmTlm+sdKWTuRqfLyiVbuiWlnlKbYYPtz
         506Q==
X-Gm-Message-State: ACrzQf3bFYX1KfRVU3UEYl1nBtCkQIoYdY3Gp46cLRnIa9TC3o5IYnvE
        TTe75AsTNgzsZ0YKMkBMSSC/P5R4Ryt7bdnikNfA5xvURuwZI70hCz4=
X-Google-Smtp-Source: AMsMyM4fjH88hcKhA9oUARmgyXCpi1btkrPkTMY5o6s8c3ALiCA8paqm9yBcH48SGJxNwUBFcW2/0zd0auSQRXfNstg=
X-Received: by 2002:a2e:b0e6:0:b0:26e:4dd:16f5 with SMTP id
 h6-20020a2eb0e6000000b0026e04dd16f5mr15182373ljl.268.1666787144961; Wed, 26
 Oct 2022 05:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c2ba5205ebe680bc@google.com>
In-Reply-To: <000000000000c2ba5205ebe680bc@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 26 Oct 2022 05:25:33 -0700
Message-ID: <CACT4Y+be9iD66uAfnjDW+skos1b1-0vvoc1GxS9_OS0vfCmCRQ@mail.gmail.com>
Subject: Re: [syzbot] WARNING in vcpu_enter_guest (2)
To:     syzbot <syzbot+dbef12497aa912c8e7ba@syzkaller.appspotmail.com>
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com, seanjc@google.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 25 Oct 2022 at 19:08, syzbot
<syzbot+dbef12497aa912c8e7ba@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    4dc12f37a8e9 Merge tag 'platform-drivers-x86-v6.1-2' of gi..
> git tree:       upstream
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=113363d2880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a66c6c673fb555e8
> dashboard link: https://syzkaller.appspot.com/bug?extid=dbef12497aa912c8e7ba
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=132e84fc880000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10a872f2880000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/7858e54948b9/disk-4dc12f37.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f37bd48d06dc/vmlinux-4dc12f37.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/98114f50afb3/bzImage-4dc12f37.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+dbef12497aa912c8e7ba@syzkaller.appspotmail.com

This will be fixed by the following commit, right?

#syz fix:
KVM: x86: Exempt pending triple fault from event injection sanity check

https://lore.kernel.org/all/20220930230008.1636044-1-seanjc@google.com/

> kvm: KVM_SET_TSS_ADDR need to be called before entering vcpu
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 3603 at arch/x86/kvm/x86.c:10047 kvm_check_and_inject_events arch/x86/kvm/x86.c:10047 [inline]
> WARNING: CPU: 0 PID: 3603 at arch/x86/kvm/x86.c:10047 vcpu_enter_guest+0x92c/0x5a10 arch/x86/kvm/x86.c:10649
> Modules linked in:
> CPU: 0 PID: 3603 Comm: syz-executor122 Not tainted 6.1.0-rc2-syzkaller-00070-g4dc12f37a8e9 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
> RIP: 0010:kvm_check_and_inject_events arch/x86/kvm/x86.c:10047 [inline]
> RIP: 0010:vcpu_enter_guest+0x92c/0x5a10 arch/x86/kvm/x86.c:10649
> Code: c0 74 06 0f 8e d2 4f 00 00 45 0f b6 b4 24 e8 08 00 00 31 ff 44 89 f6 e8 72 db 6a 00 45 84 f6 0f 84 d4 41 00 00 e8 d4 de 6a 00 <0f> 0b e9 1e 11 00 00 e8 c8 de 6a 00 be 08 00 00 00 4c 89 ff e8 4b
> RSP: 0018:ffffc90003d3fb60 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff888023d8ba80 RSI: ffffffff8111bdac RDI: 0000000000000001
> RBP: ffffc90003d3fc80 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000001 R11: 000000000008c07e R12: ffff88801c784000
> R13: 0000000000000000 R14: 0000000000000001 R15: ffff88801c784038
> FS:  0000555556d6e300(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fffcf8d4d68 CR3: 000000007b6d6000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  vcpu_run arch/x86/kvm/x86.c:10951 [inline]
>  kvm_arch_vcpu_ioctl_run+0xa5e/0x2b30 arch/x86/kvm/x86.c:11172
>  kvm_vcpu_ioctl+0x570/0xfc0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4065
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:870 [inline]
>  __se_sys_ioctl fs/ioctl.c:856 [inline]
>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f6a646982b9
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffcf8d6828 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6a646982b9
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 00007f6a6465bd10 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6a6465bda0
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
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
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000c2ba5205ebe680bc%40google.com.
