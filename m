Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED3B36ED17A
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 17:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbjDXPgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 11:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232001AbjDXPgv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 11:36:51 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3E16A63
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 08:36:50 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54f8a3f1961so36736107b3.0
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 08:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682350610; x=1684942610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=INANXHHXp/T8ARGZo4fEReN514gQsMjnO7qhCuE1g7g=;
        b=Jflx0T8GwNA/p4xXj8f1eE7a6UTpXo/APEaT4lbrFHprS/9JQewQ7S7u4yiKPLkFam
         hCelKOxQChH9nGQ3VkaJJ0c+yJVT1K4ehrSMxIx0tSq2Nqj68Ggk1AFIIDubQ0kibppc
         jMvJWzdleaZVufX+CxbrWH4xr6QT3Vf53YkMNENsj13usjdM+eSPT0+XimJ1NJj3dvVS
         wK71Di03ulexBM6nsh0r4v3OU1Uxg4fMCP7gf9GRCpNeudm2CPGB/M2k1cclM4DyeBxu
         POC31sFgrnB5HlxCm/AQoWmaK27d4ECZbNvjp6Bo5al9hmRL6NRP9N2nD6NuRANCljE2
         A3oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682350610; x=1684942610;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=INANXHHXp/T8ARGZo4fEReN514gQsMjnO7qhCuE1g7g=;
        b=gr7TozcfCqr6G9vYoGHjYdPv3bLiAewXofdDFZsWtQYCQJxYo+Jy3Clh6cLbsBSHFN
         wqsvL5fJnIx7DQ9G23lNaT6tHwBL+iHhgSL5/hLLhUVmgylu+otRAcYPwOFqYPfu4VUG
         Ny5G7rX6jccEk+9TA4fbBBE1q3bvbrU1XYPP/SGhcjk5bEEvgWc8NSYunFKZ4GZxbRC/
         03t6rytb0MTWz9Ouk0qsAnZvSV6FNHQ0g1SLav9BjyhUbNc77IY0ZDtZxg1Jvrw7Z8dF
         kCSCV9zGjwaIhPa2Ids0nnwcPVIuQJUFrnzS+TRsOZuSNVnwLZd44Z1b1rUhtixsR8bH
         GXJw==
X-Gm-Message-State: AAQBX9cwFQLPbMpfpOX7IiyCRmikJhXDe8fbr0/Swhdlmc+XrLQ+vQAG
        NPtHc49iFBgpitNGSRDom41S+b/nAwU=
X-Google-Smtp-Source: AKy350auw3H5+6753WYcSjNQqPKVcCAm7OJQMRFqTSnX4CO2SxtEX9IzR5P8QzlGzMHj+NWagReE7zpHHEQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:70c:b0:54e:8b9a:65be with SMTP id
 bs12-20020a05690c070c00b0054e8b9a65bemr6306993ywb.6.1682350610185; Mon, 24
 Apr 2023 08:36:50 -0700 (PDT)
Date:   Mon, 24 Apr 2023 08:36:48 -0700
In-Reply-To: <CACT4Y+Ytpc8zqcyV7xnOJsdz5qoT0mpOE1yZrPZ53D5ZwUrMwA@mail.gmail.com>
Mime-Version: 1.0
References: <000000000000a0bc2b05f9dd7fab@google.com> <ZEMFpqxvOHd2kZiu@google.com>
 <CACT4Y+Ytpc8zqcyV7xnOJsdz5qoT0mpOE1yZrPZ53D5ZwUrMwA@mail.gmail.com>
Message-ID: <ZEaiEISFPbOMbvOG@google.com>
Subject: Re: [syzbot] [kvm?] WARNING in kvm_tdp_mmu_invalidate_all_roots
From:   Sean Christopherson <seanjc@google.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+094a74444165dbcd3a54@syzkaller.appspotmail.com>,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, pbonzini@redhat.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023, Dmitry Vyukov wrote:
> On Fri, 21 Apr 2023 at 23:52, 'Sean Christopherson' via syzkaller-bugs
> <syzkaller-bugs@googlegroups.com> wrote:
> >
> > On Fri, Apr 21, 2023, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> > >
> > > HEAD commit:    d3e1ee0e67e7 Add linux-next specific files for 20230421
> > > git tree:       linux-next
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=16ac3de0280000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=53c789efbcc06cf6
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=094a74444165dbcd3a54
> > > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > >
> > > Unfortunately, I don't have any reproducer for this issue yet.
> > >
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/c558a9e1fe6a/disk-d3e1ee0e.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/2ec100a34c4c/vmlinux-d3e1ee0e.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/1afcd9936dc1/bzImage-d3e1ee0e.xz
> > >
> > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > Reported-by: syzbot+094a74444165dbcd3a54@syzkaller.appspotmail.com
> > >
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 0 PID: 12623 at arch/x86/kvm/mmu/tdp_mmu.c:943 kvm_tdp_mmu_invalidate_all_roots+0x2bd/0x370 arch/x86/kvm/mmu/tdp_mmu.c:943
> > > Modules linked in:
> > > CPU: 0 PID: 12623 Comm: syz-executor.3 Not tainted 6.3.0-rc7-next-20230421-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
> > > RIP: 0010:kvm_tdp_mmu_invalidate_all_roots+0x2bd/0x370 arch/x86/kvm/mmu/tdp_mmu.c:943
> > > Call Trace:
> > >  <TASK>
> > >  kvm_mmu_uninit_tdp_mmu+0x16/0x100 arch/x86/kvm/mmu/tdp_mmu.c:48
> > >  kvm_mmu_uninit_vm+0x6a/0x70 arch/x86/kvm/mmu/mmu.c:6239
> > >  kvm_arch_destroy_vm+0x369/0x490 arch/x86/kvm/x86.c:12465
> > >  kvm_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:1245 [inline]
> > >  kvm_dev_ioctl_create_vm arch/x86/kvm/../../../virt/kvm/kvm_main.c:5017 [inline]
> > >  kvm_dev_ioctl+0x11be/0x1bb0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:5059
> > >  vfs_ioctl fs/ioctl.c:51 [inline]
> > >  __do_sys_ioctl fs/ioctl.c:870 [inline]
> > >  __se_sys_ioctl fs/ioctl.c:856 [inline]
> > >  __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
> > >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> > >  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
> > >  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > Gah, kvm->users_count is elevated when the VM is destroyed if creation fails,
> > but mmu_lock isn't held in that case, and lockdep yells.  This particular bug is
> > effectively a false positive, nothing else holds a reference to the VM.
> >
> > However, syzbot found another bug that _is_ a real problem (hasn't been reported
> > upstream yet for whatever reason).
> 
> It was staged in the moderation queue for manual moderation:
> https://github.com/google/syzkaller/blob/master/docs/syzbot.md#moderation-queue
> 
> here:
> https://groups.google.com/g/syzkaller-upstream-moderation/c/pTGA87FeSIE
> 
> I've pushed it upstream since you say it's worth fixing.

Ah, thanks!  For future reference, does "#syz upstream" also work from our internal
bug tracker, or do I have to wait for the report to hit the moderation queue first?
