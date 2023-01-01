Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D452065A93D
	for <lists+kvm@lfdr.de>; Sun,  1 Jan 2023 08:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjAAHhk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Jan 2023 02:37:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjAAHhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Jan 2023 02:37:38 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6453A60C3;
        Sat, 31 Dec 2022 23:37:37 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id u4-20020a17090a518400b00223f7eba2c4so25534163pjh.5;
        Sat, 31 Dec 2022 23:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MWEjzEKMcmAbvxrRrbtXpBikge1S3ux2aaGfJM/CGG8=;
        b=XdIjmK43cqk1mzlCRNkZuxHLLQKxmz/csAj4EjfvTPRHslw05qnS/roYQwp2c+8gkk
         SBrMkrrlF+wMivNPFlXX23nfW2nPcA2vyhr1zPAUczjsTKhzSULcPny6Fcv4NO4h1pyr
         4ZfFvS7+CcwAmUliZmdJYxApAU/afGNPwQyAZBHCLF8FWihGsUnulXEVWj98zLClD3cT
         RTARotrhz2sPHTsaL1Sxudpc89lQytmtt1qm9oMs6FLqlHR7gDXjVNEUwdEowXV6TwNU
         vrnlLQuE4KI7EN5QBLVw4Ac2NQNvXtMI4meiJPEE1BVLyB6S2oysQ1MNve6sLo1yJJ9u
         RI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MWEjzEKMcmAbvxrRrbtXpBikge1S3ux2aaGfJM/CGG8=;
        b=XzgDSbOekBOmo4r76vNmMeg9zp1xE05mV4EFN1kgVUPa4kpHd6EiPyi1tnv7pNwYN+
         rzkdk+d9aVmOxfXjVd0qLRxHa3cZb1XQNxpi0e54zQo4/m+35Z/ryVPNQtMrs42jXn8+
         EdSfpIg1hhC7XgD3W6QvuuPnShHGNlWDWhVMJ5aj2CPABYfanxKy2GwlFHbaIkDZl5oA
         xlNA2P11D3JSaja3pyYtD6RMewFaRsV5S0Rs+9+BP8xfrQUNuxuRJlLth1r7mKMgmbKr
         hXmvOTP25GkmRY4ZHkFTzId0+BVr/f8fgOJybqyw5v8UOHNybmNz2euUlV5SfKM/TwMW
         nNlw==
X-Gm-Message-State: AFqh2krQMK2ky9UCc7/wld4L+TJrk/G+600XOmEakTG8b+oXUg2jdP3W
        KVbCru9xxck+f/C3gERXcdo=
X-Google-Smtp-Source: AMrXdXt1t+EOG2ITGN8Df8z6C9zc7KW2F6DlvplBoxaBDIcy0sJFehT1daOtV6MttiJhjUsWrSPuWQ==
X-Received: by 2002:a17:902:ed84:b0:189:6bda:e98f with SMTP id e4-20020a170902ed8400b001896bdae98fmr36043517plj.58.1672558656690;
        Sat, 31 Dec 2022 23:37:36 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001745662d568sm17838326plf.278.2022.12.31.23.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Dec 2022 23:37:35 -0800 (PST)
Date:   Sun, 1 Jan 2023 16:37:29 +0900
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     kernel test robot <oliver.sang@intel.com>
Cc:     Vlastimil Babka <vbabka@suse.cz>, oe-lkp@lists.linux.dev,
        lkp@intel.com, Mike Rapoport <rppt@linux.ibm.com>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Subject: supervisor write access in kernel mode in
 __pv_queued_spin_unlock_slowpath
Message-ID: <Y7E4OZUmvI97tTw7@hyeyoo>
References: <202212312021.bc1efe86-oliver.sang@intel.com>
 <Y7EtNNzfxuiX/VEg@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7EtNNzfxuiX/VEg@hyeyoo>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Sun, Jan 01, 2023 at 03:50:28PM +0900, Hyeonggon Yoo wrote:
> On Sat, Dec 31, 2022 at 11:26:25PM +0800, kernel test robot wrote:
> > 
> > Greeting,
> > 
> > FYI, we noticed kernel_BUG_at_include/linux/mm.h due to commit (built with gcc-11):
> > 
> > commit: 0af8489b0216fa1dd83e264bef8063f2632633d7 ("mm, slub: remove percpu slabs with CONFIG_SLUB_TINY")
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > 
> > [test failed on linux-next/master c76083fac3bae1a87ae3d005b5cb1cbc761e31d5]
> > 
> > in testcase: rcutorture
> > version: 
> > with following parameters:
> > 
> > 	runtime: 300s
> > 	test: default
> > 	torture_type: tasks-tracing
> > 
> > test-description: rcutorture is rcutorture kernel module load/unload test.
> > test-url: https://www.kernel.org/doc/Documentation/RCU/torture.txt
> > 
> > 
> > on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> > 
> > caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> > 
> > 
> > If you fix the issue, kindly add following tag
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Link: https://lore.kernel.org/oe-lkp/202212312021.bc1efe86-oliver.sang@intel.com
> > 
> > 
> 
> <snip>
> 
> > 
> > 
> > To reproduce:
> > 
> >         # build kernel
> > 	cd linux
> > 	cp config-6.1.0-rc2-00014-g0af8489b0216 .config
> > 	make HOSTCC=gcc-11 CC=gcc-11 ARCH=i386 olddefconfig prepare modules_prepare bzImage modules
> > 	make HOSTCC=gcc-11 CC=gcc-11 ARCH=i386 INSTALL_MOD_PATH=<mod-install-dir> modules_install
> > 	cd <mod-install-dir>
> > 	find lib/ | cpio -o -H newc --quiet | gzip > modules.cgz
> > 
> > 
> >         git clone https://github.com/intel/lkp-tests.git
> >         cd lkp-tests
> >         bin/lkp qemu -k <bzImage> -m modules.cgz job-script # job-script is attached in this email
> > 
> >         # if come across any failure that blocks the test,
> >         # please remove ~/.lkp and /lkp dir to run from a clean state.
> 
> 
> I was unable to reproduce in the same way as described above
> because some files referenced in job-script couldn't be downloaded from
> download.01.org/0day :(
> 
> So I just built rcutorture module as builtin
> and I got weird spinlock bug on commit: 0af8489b0216
> ("mm, slub: remove percpu slabs with CONFIG_SLUB_TINY")

(+Cc KVM/Paravirt experts)

> full dmesg added as attachment
> 
> [ 1387.564837][   T57] BUG: unable to handle page fault for address: c108f5f4
> [ 1387.566649][   T57] #PF: supervisor write access in kernel mode
> [ 1387.567965][   T57] #PF: error_code(0x0003) - permissions violation
> [ 1387.569439][   T57] *pde = 010001e1 
> [ 1387.570276][   T57] Oops: 0003 [#1] SMP
> [ 1387.571149][   T57] CPU: 2 PID: 57 Comm: rcu_torture_rea Tainted: G S                 6.1.0-rc2-00010-g0af8489b0216 #2130 63d19ac2b985fca570c354d8750f489755de37ed
> [ 1387.574673][   T57] EIP: kvm_kick_cpu+0x54/0x90
> [ 1387.575802][   T57] Code: 2f c5 01 8b 04 9d e0 d4 4e c4 83 15 14 7b 2f c5 00 83 05 08 6d 2f c5 01 0f b7 0c 30 b8 05 00 00 00 83 15 0c 6d 2f c5 00 31 db <0f> 01 c1 83 05 10 6d 2f c5 01 8b 5d f8 8b 75 fc 83 15 14 6d 2f c5
> [ 1387.580456][   T57] EAX: 00000005 EBX: 00000000 ECX: 00000003 EDX: c108f5a0
> [ 1387.582071][   T57] ESI: c5153580 EDI: 00000046 EBP: c69cddf8 ESP: c69cddf0
> [ 1387.583775][   T57] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010046
> [ 1387.585643][   T57] CR0: 80050033 CR2: c108f5f4 CR3: 0776b000 CR4: 00350e90
> [ 1387.587492][   T57] Call Trace:
> [ 1387.588365][   T57]  __pv_queued_spin_unlock_slowpath+0x66/0x110
> [ 1387.589898][   T57]  __pv_queued_spin_unlock+0x4b/0x60
> [ 1387.591040][   T57]  __raw_callee_save___pv_queued_spin_unlock+0x9/0x10
> [ 1387.592771][   T57]  do_raw_spin_unlock+0x49/0xa0
> [ 1387.593805][   T57]  _raw_spin_unlock_irqrestore+0x53/0xd0
> [ 1387.594927][   T57]  swake_up_one+0x4f/0x70
> [ 1387.595739][   T57]  __rcu_report_exp_rnp+0x26b/0x470
> [ 1387.596730][   T57]  rcu_report_exp_cpu_mult+0x82/0x2f0
> [ 1387.597770][   T57]  rcu_qs+0xac/0x160
> [ 1387.598503][   T57]  rcu_note_context_switch+0x31/0x1e0
> [ 1387.599460][   T57]  __schedule+0xc5/0x770
> [ 1387.600195][   T57]  __cond_resched+0x7a/0x100
> [ 1387.600996][   T57]  stutter_wait+0x9e/0x2c0
> [ 1387.601956][   T57]  rcu_torture_reader+0x162/0x3e0
> [ 1387.603048][   T57]  ? rcu_torture_reader+0x3e0/0x3e0
> [ 1387.604269][   T57]  ? __kthread_parkme+0xab/0xf0
> [ 1387.605420][   T57]  kthread+0x167/0x1d0
> [ 1387.606383][   T57]  ? rcu_torture_read_exit_child+0xa0/0xa0
> [ 1387.607516][   T57]  ? kthread_exit+0x50/0x50
> [ 1387.608517][   T57]  ret_from_fork+0x19/0x24
> [ 1387.609548][   T57] Modules linked in:
> [ 1387.610187][   T57] CR2: 00000000c108f5f4
> [ 1387.610873][   T57] ---[ end trace 0000000000000000 ]---
> [ 1387.611829][   T57] EIP: kvm_kick_cpu+0x54/0x90
> [ 1387.612653][   T57] Code: 2f c5 01 8b 04 9d e0 d4 4e c4 83 15 14 7b 2f c5 00 83 05 08 6d 2f c5 01 0f b7 0c 30 b8 05 00 00 00 83 15 0c 6d 2f c5 00 31 db <0f> 01 c1 83 05 10 6d 2f c5 01 8b 5d f8 8b 75 fc 83 15 14 6d 2f c5
> [ 1387.616715][   T57] EAX: 00000005 EBX: 00000000 ECX: 00000003 EDX: c108f5a0
> [ 1387.618242][   T57] ESI: c5153580 EDI: 00000046 EBP: c69cddf8 ESP: c69cddf0
> [ 1387.619912][   T57] DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068 EFLAGS: 00010046
> [ 1387.621666][   T57] CR0: 80050033 CR2: c108f5f4 CR3: 0776b000 CR4: 00350e90
> [ 1387.623128][   T57] Kernel panic - not syncing: Fatal exception
> [ 1389.285045][   T57] Shutting down cpus with NMI
> [ 1389.297949][   T57] Kernel Offset: disabled
> [ 1389.299174][   T57] ---[ end Kernel panic - not syncing: Fatal exception ]---

