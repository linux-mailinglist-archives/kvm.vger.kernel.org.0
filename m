Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868B759F021
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 02:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbiHXAQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 20:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiHXAQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 20:16:25 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3708DE1
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 17:16:23 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id c24so13607010pgg.11
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 17:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=hcfEp+dYBdEKW+6uFA3n79gHDSD/E9Yv3lIEobD8YWQ=;
        b=Sb3Pt5pkzFSREsYhzBZPaeo5hkzyEmcD8iVaEcpoZhGzaGN2vWUyA3Y6L38dYmtAx1
         Pujuti7YG1sR+FxuwybfPMcx16hvfBGKWR0zfr6IGN+aE/iLdUIB+fHc1O8E3YTU2gR0
         2SMDzN1cJLGe8vRHVQfv6tBmcXjGZjfGVv+XB0R+dAX22vh90ygG3yls4GCsve5Y+Nn/
         Ws6tzRpVlweFXM4WiAVcJQepA61GmnY6OU4GyxyDE/jEKHSE4ZvqsVRqsMKa8JCyz++6
         je9D87J8xbD3gnFPvryNrbqCrYETTN+BPlMLFB48UyYEjd/Cj9qQSGbEe8J9fCDyT0L2
         rBgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=hcfEp+dYBdEKW+6uFA3n79gHDSD/E9Yv3lIEobD8YWQ=;
        b=0tx2fiOJoJTbQB76tBDVaJDjESEKIavPvP/qFWLh8Q8KYW7s2kQ+Ywdjejn9dqjMNI
         ZmNNoh7kyK/xAkBGpxfezKmpPhZNX9diKfJ3pt4zMRYYqlogdFtjD+7yW86E9uCPesTI
         XCq9vh/XZshE/FRtmJa903kLZELI64NTihishmLY9UcqBAykExOfAa/agBKtx8lppOsm
         SGIpOC1TBZRVbuvk1yBu90+KOtdvhUVlXY5pH2GxakdhiQQUuKXnOwrn0mv957vbRrvN
         naiXczVETeLCYrj5Xv2yZXfriny6LdDtfHUby7tiYxFTdrBDUyKH0EfLZOGXae+MO0P3
         4wcQ==
X-Gm-Message-State: ACgBeo21g6O/bCx0J5ZJoHcV1dnWDVYSVTfXz91yvMgTfqNDFIr0Q1TN
        D49i/NZW5Z/0qI/SY/68khUC9wUZNaLvIw==
X-Google-Smtp-Source: AA6agR5ond+1oeUeB1tNu4zplHOG1IXeVCU/Tk/fynhXxKo9X0D2W1OITp55ilmQQv+QfWO1fWf3uw==
X-Received: by 2002:a05:6a02:284:b0:429:cd1d:aa1b with SMTP id bk4-20020a056a02028400b00429cd1daa1bmr22565477pgb.396.1661300183198;
        Tue, 23 Aug 2022 17:16:23 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n2-20020a622702000000b0052e7f103138sm11283572pfn.38.2022.08.23.17.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 17:16:22 -0700 (PDT)
Date:   Wed, 24 Aug 2022 00:16:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     =?utf-8?B?546L5rW35byb?= <wanghaichi@tju.edu.cn>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
Subject: Re: WARNING: kmalloc bug in kvm_page_track_create_memslot
Message-ID: <YwVt0kkkb9XNOozo@google.com>
References: <APQAVgBhFMDqJKhR5OIMSKrh.1.1661173385472.Hmail.3014218099@tju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <APQAVgBhFMDqJKhR5OIMSKrh.1.1661173385472.Hmail.3014218099@tju.edu.cn>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 22, 2022, 王海弛 wrote:
> The full log crash log are as follows:(also in the attach, crash.report)
> -----------------------------------------
> WARNING: CPU: 1 PID: 19519 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
> Modules linked in:
> CPU: 1 PID: 19519 Comm: syz-executor.0 Not tainted 5.15.0-rc5+ #6
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
> Code: 01 00 00 00 4c 89 e7 e8 7d 58 0d 00 49 89 c5 e9 69 ff ff ff e8 40 c5 d0 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 2f c5 d0 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 16
> RSP: 0018:ffffc90003907830 EFLAGS: 00010216
> RAX: 0000000000031766 RBX: 0000000000000000 RCX: 0000000000040000
> RDX: ffffc90003941000 RSI: ffff88802b6c8000 RDI: 0000000000000002
> RBP: 0000000000400dc0 R08: ffffffff81a68e11 R09: 000000007fffffff
> R10: 0000000000000007 R11: ffffed1026b86541 R12: 00000000a0000000
> R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
> FS:  00007f526e4c7700(0000) GS:ffff888135c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f9614442020 CR3: 0000000021c3c000 CR4: 0000000000752ee0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> PKRU: 55555554
> Call Trace:
>  kvmalloc include/linux/mm.h:805 [inline]
>  kvmalloc_array include/linux/mm.h:823 [inline]
>  kvcalloc include/linux/mm.h:828 [inline]
>  kvm_page_track_create_memslot+0x50/0x110 arch/x86/kvm/mmu/page_track.c:39
>  kvm_alloc_memslot_metadata arch/x86/kvm/x86.c:11501 [inline]
>  kvm_arch_prepare_memory_region+0x339/0x600 arch/x86/kvm/x86.c:11538
>  kvm_set_memslot+0x16e/0x19f0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1592
>  __kvm_set_memory_region+0xc30/0x13d0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1755
>  kvm_set_memory_region+0x29/0x40 arch/x86/kvm/../../../virt/kvm/kvm_main.c:1776
>  kvm_vm_ioctl_set_memory_region arch/x86/kvm/../../../virt/kvm/kvm_main.c:1788 [inline]
>  kvm_vm_ioctl+0x507/0x23a0 arch/x86/kvm/../../../virt/kvm/kvm_main.c:4363
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:874 [inline]
>  __se_sys_ioctl fs/ioctl.c:860 [inline]
>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae

This was fixed back in v5.18 by commit 37b2a6510a48 ("KVM: use __vcalloc for very
large allocations").
