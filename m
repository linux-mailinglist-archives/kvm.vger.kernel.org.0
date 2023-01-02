Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D429E65B06B
	for <lists+kvm@lfdr.de>; Mon,  2 Jan 2023 12:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbjABLSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Jan 2023 06:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbjABLR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Jan 2023 06:17:57 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7916E6314;
        Mon,  2 Jan 2023 03:17:55 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id n4so29314832plp.1;
        Mon, 02 Jan 2023 03:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=USmnyjlfh60UWXXDo3KEHQN3fQ80DREWhYWBDoqJb+s=;
        b=YUpS43LJBjGD9SWdLchBuieNk6L6+T6s9m6rfZEM9AO5kMZiHl0i+vX9uZY6zqL5YU
         H08BRogK3Y6XSRYXbugv+HkvkG/x/YAemsmvmpAXhF+fwBxPUxo+K3uHosREzAXidRj3
         tZkBT7DdYeM3okwftEhHL9zsVUbXcVDWAu04YD4cIFaKlUT57tpY5rG2Dvl9bM+Zjjgi
         eQHZRUeB5PGavjL/8h+GYINd9H/pDxKWTBNPV021DFQUV0410c4k6zFsHwMQMmguG4ml
         a+QZpjsOjxmB4BeYtNGt83BtYWIm7ipHwI2dBeKcnn8TK4Z4qd9GhfXtM2HQnjJOcuf4
         gXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=USmnyjlfh60UWXXDo3KEHQN3fQ80DREWhYWBDoqJb+s=;
        b=yR7jwz3m9HOIUOwHApdk4MQP09jFI51ohdSg2cc4y8dQZUlPgXkPt/+YZakpSrRXgx
         TjKTVyDFC1vGNvODORh9vE1K5I1xc9o/hRHHwSvq0DBRQQf54MxsmNeMBmiGO4JlxVam
         6ub6sH2xUzsLfgG7+6/uz7kZ9gE4uo9OKdcU1Ld7j8xc6h2LzZz4icCC6gIPrDSTckSw
         61nCLmhav232H0DUjjL9m8y593qXuvSR1ERwVu2zWMV3BjfAzcml/MniUAJ/QMfdbJNX
         wqqM568wSmj5ntp+2acn6KLacieiuUvExukDumr3ZwIB0M9+SJxIap0dVghN6128eOnQ
         rqaA==
X-Gm-Message-State: AFqh2krMfJl3M99aHgMSQnhk7W5qfr8J9gTnKOFpY5eLxhykblWgF+tP
        eFJ39D4O+xeWc2HKa/jXXys=
X-Google-Smtp-Source: AMrXdXuZ2v0b5+XpXlToZFB7H1Z5S4DSIjNbEaZDVe6hXFaFtK700ZJUlL4cnIaWRE1BI319ikGupw==
X-Received: by 2002:a17:902:cf0f:b0:188:f5de:8908 with SMTP id i15-20020a170902cf0f00b00188f5de8908mr42886165plg.65.1672658274820;
        Mon, 02 Jan 2023 03:17:54 -0800 (PST)
Received: from hyeyoo ([114.29.91.56])
        by smtp.gmail.com with ESMTPSA id g18-20020a170902869200b00192b23b8451sm5808853plo.108.2023.01.02.03.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 03:17:53 -0800 (PST)
Date:   Mon, 2 Jan 2023 20:17:46 +0900
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kernel test robot <oliver.sang@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>, oe-lkp@lists.linux.dev,
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
Subject: Re: supervisor write access in kernel mode in
 __pv_queued_spin_unlock_slowpath
Message-ID: <Y7K9Wh1mgWR2TiDX@hyeyoo>
References: <202212312021.bc1efe86-oliver.sang@intel.com>
 <Y7EtNNzfxuiX/VEg@hyeyoo>
 <Y7E4OZUmvI97tTw7@hyeyoo>
 <451187de09e9a80f73a0588da65d55d4a8da6552.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <451187de09e9a80f73a0588da65d55d4a8da6552.camel@redhat.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 01, 2023 at 01:08:07PM +0200, Maxim Levitsky wrote:
> On Sun, 2023-01-01 at 16:37 +0900, Hyeonggon Yoo wrote:
> > On Sun, Jan 01, 2023 at 03:50:28PM +0900, Hyeonggon Yoo wrote:
> > > On Sat, Dec 31, 2022 at 11:26:25PM +0800, kernel test robot wrote:
> > > > Greeting,
> > > > 
> > > > FYI, we noticed kernel_BUG_at_include/linux/mm.h due to commit (built with gcc-11):
> > > > 
> > > > commit: 0af8489b0216fa1dd83e264bef8063f2632633d7 ("mm, slub: remove percpu slabs with CONFIG_SLUB_TINY")
> > > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > > > 
> > > > [test failed on linux-next/master c76083fac3bae1a87ae3d005b5cb1cbc761e31d5]
> > > > 
> > > > in testcase: rcutorture
> > > > version: 
> > > > with following parameters:
> > > > 
> > > > 	runtime: 300s
> > > > 	test: default
> > > > 	torture_type: tasks-tracing
> > > > 
> > > > test-description: rcutorture is rcutorture kernel module load/unload test.
> > > > test-url: https://www.kernel.org/doc/Documentation/RCU/torture.txt
> > > > 
> > > > 
> > > > on test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> > > > 
> > > > caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> > > > 
> > > > 
> > > > If you fix the issue, kindly add following tag
> > > > > Reported-by: kernel test robot <oliver.sang@intel.com>
> > > > > Link: https://lore.kernel.org/oe-lkp/202212312021.bc1efe86-oliver.sang@intel.com
> > > 
> > > <snip>
> > > 
> > > > 
> > > > To reproduce:
> > > > 
> > > >         # build kernel
> > > > 	cd linux
> > > > 	cp config-6.1.0-rc2-00014-g0af8489b0216 .config
> > > > 	make HOSTCC=gcc-11 CC=gcc-11 ARCH=i386 olddefconfig prepare modules_prepare bzImage modules
> > > > 	make HOSTCC=gcc-11 CC=gcc-11 ARCH=i386 INSTALL_MOD_PATH=<mod-install-dir> modules_install
> > > > 	cd <mod-install-dir>
> > > > 	find lib/ | cpio -o -H newc --quiet | gzip > modules.cgz
> > > > 
> > > > 
> > > >         git clone https://github.com/intel/lkp-tests.git
> > > >         cd lkp-tests
> > > >         bin/lkp qemu -k <bzImage> -m modules.cgz job-script # job-script is attached in this email
> > > > 
> > > >         # if come across any failure that blocks the test,
> > > >         # please remove ~/.lkp and /lkp dir to run from a clean state.
> > > 
> > > I was unable to reproduce in the same way as described above
> > > because some files referenced in job-script couldn't be downloaded from
> > > download.01.org/0day :(
> > > 
> > > So I just built rcutorture module as builtin
> > > and I got weird spinlock bug on commit: 0af8489b0216
> > > ("mm, slub: remove percpu slabs with CONFIG_SLUB_TINY")
> > 
> > (+Cc KVM/Paravirt experts)
> > 
> > > full dmesg added as attachment
> > > 
> > > [ 1387.564837][   T57] BUG: unable to handle page fault for address: c108f5f4
> > > [ 1387.566649][   T57] #PF: supervisor write access in kernel mode
> > > [ 1387.567965][   T57] #PF: error_code(0x0003) - permissions violation
> > > [ 1387.569439][   T57] *pde = 010001e1 
> > > [ 1387.570276][   T57] Oops: 0003 [#1] SMP
> > > [ 1387.571149][   T57] CPU: 2 PID: 57 Comm: rcu_torture_rea Tainted: G S                 6.1.0-rc2-00010-g0af8489b0216 #2130 63d19ac2b985fca570c354d8750f489755de37ed
> > > [ 1387.574673][   T57] EIP: kvm_kick_cpu+0x54/0x90
> > > [ 1387.575802][   T57] Code: 2f c5 01 8b 04 9d e0 d4 4e c4 83 15 14 7b 2f c5 00 83 05 08 6d 2f c5 01 0f b7 0c 30 b8 05 00 00 00 83 15 0c 6d 2f c5 00 31 db <0f> 01 c1 83 05 10 6d 2f c5 01 8b 5d f8 8b 75 fc 83 15 14 6d 2f c5
> 
> 																				^^^^^^
> Yes this is the unfamous hypercall patching bug....
> 
> > > 
> 
> So what is happening is that Intel and AMD has a *slightly* different instruction reserved for hypercalls
> (paravirt calls from guest to host hypervisor).
> 
> KVM developers made a mistake to be 'nice' to the guests and if the guest uses the wrong hypercall instruction
> the KVM attempts to rewrite it with the right instruction.
> 
> That can fail, because to avoid security issues, KVM uses the exact same security context as the instruction itself
> (it is as if the instruction was defined such as it overwrote itself)
> This means that is the guest memory is marked read-only in the guest paging, then the write will fail and #PF
> will happen on the wrong hypercall instruction.
> 
> Here we have the Intel's instruction (VMCALL, 0f 01 C1), and the host machine is likely AMD which uses VMMCALL instruction
> which is (0F 01 D9)

Oh, right. my host machine is AMD Ryzen and seems I built kernel that does not
correctly support the machine.

> Now any recent Linux guest is supposed to use a right instruction using the alternatives mechanism, but it can if
> the hypervisor passes 'non native' vendor id, like GenunineIntel on AMD machine.

[    0.000000][    T0] KERNEL supported cpus:
[    0.000000][    T0]   Intel GenuineIntel
[    0.000000][    T0]   Vortex Vortex86 SoC
[    0.000000][    T0] CPU: vendor_id 'AuthenticAMD' unknown, using generic init.
[    0.000000][    T0] CPU: Your system may be unstable.
 
> In my testing using named CPU models like you do '-cpu SandyBridge' still passes through host vendor ID (that is the guest
> will see Intel's cpu but with vendor='AutheticAMD') but nobody confirmed me that this is a bug or a feature and I am not
> sure if older qemu versions also did this.
>
> Assuming that your host machine is AMD,
> your best bet to check if my theory is right is to boot the guest without triggering the bug, 
> and check in /proc/cpuinfo if the vendor string is 'GenuineIntel'

Same here. the vendor string is AuthenticAMD no matter if I pass -cpu SandyBridge
or -cpu host.

I didn't even imagine this could happen when using configuration the bot
passed without thinking and running it on CPU with different vendor :)

Thank you for such a kind explanation!

Phew, so this bug was totally unrelated the issue bot reported
and I have no clue why the original bug happened.

-- 
Regards,
Hyeonggon
