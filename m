Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 865ADDF1F8
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2019 17:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729810AbfJUPrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Oct 2019 11:47:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52362 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727607AbfJUPrs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Oct 2019 11:47:48 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C9514FCCE
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 15:47:47 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id y10so2446289wma.0
        for <kvm@vger.kernel.org>; Mon, 21 Oct 2019 08:47:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IdRJ4BH/aQVHwNKIuGlBWKR4kleLNRr2Y1pJAlN4vqM=;
        b=pkdgE1qTz57KhYwUh2iq5K3cR0sjdUj4xNZfofDYTEweyxMsAOmBRt4nHFg7HVoE0p
         Q5jnv7jiIMtRdypd7gBd6BiVEo3F+Rxgrmy/nAMFYjzRrJMELzaX1bdhvUw+x3C9scK8
         5y5CdUZ4Nz2hud0YgrY5o61PwJDIRl0+kq9vEI9PA1AkJzeefxM+Zd6/Rr4AmRl3OptF
         3OxhkvAGhx9cpKq0FaeuaXtuQ5c9/qS2iB0285Aq9AxXqD+VU+qOO9hYTdXnO8VfAkpv
         mDb42MOwaM9z5sCeQdIDX8PcAx7jVbR0HHf+6xAZa/a67axaFFPeCJp8vLTkJRIsShX1
         Kn2w==
X-Gm-Message-State: APjAAAUvSETc0Pi71w9mhys3zY6HRmaBjvSwleG2wiBroTeDd+Mv1HJl
        ec0L3arKFE8jvjSTF9CTHbzoJ2xEvFCkNS2nXQYCVXaZMLBXz9d0z311Kwam9Q7gubzUzHE3sU5
        v9AJz1cg2nyFk
X-Received: by 2002:a5d:430d:: with SMTP id h13mr20127603wrq.163.1571672864587;
        Mon, 21 Oct 2019 08:47:44 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxFxaZnycPFWg3au+seYL9MbCSU1gjWFiYUbmXWI8fSUEZG66GwnEBkJkyz+MgRHjz/dZaFlQ==
X-Received: by 2002:a5d:430d:: with SMTP id h13mr20127568wrq.163.1571672864148;
        Mon, 21 Oct 2019 08:47:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:847b:6afc:17c:89dd? ([2001:b07:6468:f312:847b:6afc:17c:89dd])
        by smtp.gmail.com with ESMTPSA id r13sm24835524wra.74.2019.10.21.08.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 08:47:43 -0700 (PDT)
Subject: Re: KASAN: slab-out-of-bounds Read in handle_vmptrld
To:     syzbot <syzbot+46f1dd7dbbe2bfb98b10@syzkaller.appspotmail.com>,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        will.deacon@arm.com, x86@kernel.org,
        USB list <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <000000000000a9d4f705924cff7a@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ab695e01-10bc-24cc-6b07-c61bb5636227@redhat.com>
Date:   Mon, 21 Oct 2019 17:47:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <000000000000a9d4f705924cff7a@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixed now by commit 59bb47985c1d ("mm, sl[aou]b: guarantee natural
alignment for kmalloc(power-of-two)").

Paolo

On 11/09/19 22:38, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    1e3778cb Merge tag 'scsi-fixes' of
> git://git.kernel.org/pu..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15bdfc5e600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b89bb446a3faaba4
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=46f1dd7dbbe2bfb98b10
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1709421a600000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=168fc4b2600000
> 
> The bug was bisected to:
> 
> commit a87f854ddcf7ff7e044d72db0aa6da82f26d69a6
> Author: Neil Armstrong <narmstrong@baylibre.com>
> Date:   Wed Oct 11 15:39:40 2017 +0000
> 
>     ARM64: dts: meson-gx: remove unnecessary uart compatible
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17e78a6e600000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=14178a6e600000
> console output: https://syzkaller.appspot.com/x/log.txt?x=10178a6e600000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+46f1dd7dbbe2bfb98b10@syzkaller.appspotmail.com
> Fixes: a87f854ddcf7 ("ARM64: dts: meson-gx: remove unnecessary uart
> compatible")
> 
> L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646
> and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html
> for details.
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in handle_vmptrld
> arch/x86/kvm/vmx/nested.c:4789 [inline]
> BUG: KASAN: slab-out-of-bounds in handle_vmptrld+0x777/0x800
> arch/x86/kvm/vmx/nested.c:4749
> Read of size 4 at addr ffff888091e10000 by task syz-executor758/10006
> 
> CPU: 1 PID: 10006 Comm: syz-executor758 Not tainted 5.3.0-rc7+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
>  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
>  kasan_report+0x12/0x17 mm/kasan/common.c:618
>  __asan_report_load_n_noabort+0xf/0x20 mm/kasan/generic_report.c:142
>  handle_vmptrld arch/x86/kvm/vmx/nested.c:4789 [inline]
>  handle_vmptrld+0x777/0x800 arch/x86/kvm/vmx/nested.c:4749
>  vmx_handle_exit+0x299/0x15e0 arch/x86/kvm/vmx/vmx.c:5886
>  vcpu_enter_guest+0x1087/0x5e90 arch/x86/kvm/x86.c:8088
>  vcpu_run arch/x86/kvm/x86.c:8152 [inline]
>  kvm_arch_vcpu_ioctl_run+0x464/0x1750 arch/x86/kvm/x86.c:8360
>  kvm_vcpu_ioctl+0x4dc/0xfd0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:2765
>  vfs_ioctl fs/ioctl.c:46 [inline]
>  file_ioctl fs/ioctl.c:509 [inline]
>  do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:696
>  ksys_ioctl+0xab/0xd0 fs/ioctl.c:713
>  __do_sys_ioctl fs/ioctl.c:720 [inline]
>  __se_sys_ioctl fs/ioctl.c:718 [inline]
>  __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:718
>  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x447269
> Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89
> f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01
> f0 ff ff 0f 83 3b d0 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007ffd58df6ad8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007ffd58df6ae0 RCX: 0000000000447269
> RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 0000000000000005
> RBP: 0000000000000000 R08: 0000000020003800 R09: 0000000000400e80
> R10: 00007ffd58df4f20 R11: 0000000000000246 R12: 0000000000404730
> R13: 00000000004047c0 R14: 0000000000000000 R15: 0000000000000000
> 
> Allocated by task 10006:
>  save_stack+0x23/0x90 mm/kasan/common.c:69
>  set_track mm/kasan/common.c:77 [inline]
>  __kasan_kmalloc mm/kasan/common.c:493 [inline]
>  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:466
>  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:507
>  __do_kmalloc mm/slab.c:3655 [inline]
>  __kmalloc+0x163/0x770 mm/slab.c:3664
>  kmalloc include/linux/slab.h:557 [inline]
>  hcd_buffer_alloc+0x1c6/0x260 drivers/usb/core/buffer.c:132
>  usb_alloc_coherent+0x62/0x90 drivers/usb/core/usb.c:910
>  usbdev_mmap+0x1ce/0x790 drivers/usb/core/devio.c:224
>  call_mmap include/linux/fs.h:1875 [inline]
>  mmap_region+0xc35/0x1760 mm/mmap.c:1788
>  do_mmap+0x82e/0x1090 mm/mmap.c:1561
>  do_mmap_pgoff include/linux/mm.h:2374 [inline]
>  vm_mmap_pgoff+0x1c5/0x230 mm/util.c:391
>  ksys_mmap_pgoff+0x4aa/0x630 mm/mmap.c:1611
>  __do_sys_mmap arch/x86/kernel/sys_x86_64.c:100 [inline]
>  __se_sys_mmap arch/x86/kernel/sys_x86_64.c:91 [inline]
>  __x64_sys_mmap+0xe9/0x1b0 arch/x86/kernel/sys_x86_64.c:91
>  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Freed by task 9516:
>  save_stack+0x23/0x90 mm/kasan/common.c:69
>  set_track mm/kasan/common.c:77 [inline]
>  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:455
>  kasan_slab_free+0xe/0x10 mm/kasan/common.c:463
>  __cache_free mm/slab.c:3425 [inline]
>  kfree+0x10a/0x2c0 mm/slab.c:3756
>  tomoyo_init_log+0x15ba/0x2070 security/tomoyo/audit.c:293
>  tomoyo_supervisor+0x33f/0xef0 security/tomoyo/common.c:2095
>  tomoyo_audit_env_log security/tomoyo/environ.c:36 [inline]
>  tomoyo_env_perm+0x18e/0x210 security/tomoyo/environ.c:63
>  tomoyo_environ security/tomoyo/domain.c:670 [inline]
>  tomoyo_find_next_domain+0x1354/0x1f6c security/tomoyo/domain.c:876
>  tomoyo_bprm_check_security security/tomoyo/tomoyo.c:107 [inline]
>  tomoyo_bprm_check_security+0x124/0x1b0 security/tomoyo/tomoyo.c:97
>  security_bprm_check+0x63/0xb0 security/security.c:750
>  search_binary_handler+0x71/0x570 fs/exec.c:1645
>  exec_binprm fs/exec.c:1701 [inline]
>  __do_execve_file.isra.0+0x1333/0x2340 fs/exec.c:1821
>  do_execveat_common fs/exec.c:1868 [inline]
>  do_execve fs/exec.c:1885 [inline]
>  __do_sys_execve fs/exec.c:1961 [inline]
>  __se_sys_execve fs/exec.c:1956 [inline]
>  __x64_sys_execve+0x8f/0xc0 fs/exec.c:1956
>  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> The buggy address belongs to the object at ffff888091e109c0
>  which belongs to the cache kmalloc-8k of size 8192
> The buggy address is located 2496 bytes to the left of
>  8192-byte region [ffff888091e109c0, ffff888091e129c0)
> The buggy address belongs to the page:
> page:ffffea0002478400 refcount:2 mapcount:0 mapping:ffff8880aa4021c0
> index:0x0 compound_mapcount: 0
> flags: 0x1fffc0000010200(slab|head)
> raw: 01fffc0000010200 ffffea000242e608 ffffea0002436708 ffff8880aa4021c0
> raw: 0000000000000000 ffff888091e109c0 0000000200000001 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff888091e0ff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888091e0ff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ffff888091e10000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                    ^
>  ffff888091e10080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888091e10100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see:
> https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches

