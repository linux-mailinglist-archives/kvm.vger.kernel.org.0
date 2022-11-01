Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E71B6145BD
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 09:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiKAIcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 04:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiKAIck (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 04:32:40 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968F73B5;
        Tue,  1 Nov 2022 01:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667291559; x=1698827559;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=knn1oLAwfIIL7icxHS5nRNahPFf2tYSjAdO5agJ5DQI=;
  b=eYkGisWxpq8rcOc7PO5rVTZQotzF8wBclcuxUYGbRR6yhi/yw7SgoUby
   L0pJCZD3q1mlRJi5rcKswNCst1v2hLecWX2UaKUJbk/wyvJzPxaZbQ3+N
   Z6ZDLZemuNmnU7ZfT6HVln0+Rn8KIHSmoJSBcX9AF+Gu2GR5ZICxugaNB
   Z1r5BwpEqfj2rNLR9H4QZu6/fT37Y3wxD4ROFCM2wF4hvhONELpYWlRBM
   YVge9TByTb2To3DLFlbG+PlJeVS7BTI5ZoTVi3jNHzP66VPrb2RbriVvQ
   TIFBpXX066uOH8qb8qj7GW9CtDe7cuoEKhDIKuwmIfLMsqQZ0ou0ZiiA/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="310800251"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="310800251"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 01:32:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="723095713"
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="723095713"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Nov 2022 01:32:35 -0700
Message-ID: <955799c72b6b825fcce104771ee7570d826faac5.camel@linux.intel.com>
Subject: Re: [KVM] e923b0537d: kernel-selftests.kvm.rseq_test.fail
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Gavin Shan <gshan@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        kernel test robot <oliver.sang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Andrew Jones <andrew.jones@linux.dev>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        lkp@lists.01.org, lkp@intel.com, xudong.hao@intel.com,
        regressions@lists.linux.dev
Date:   Tue, 01 Nov 2022 16:32:35 +0800
In-Reply-To: <9bfeae26-b4b1-eedb-6cbd-b4f9f1e1cc55@redhat.com>
References: <Yvn60W/JpPO8URLY@xsang-OptiPlex-9020>
         <Yvq9wzXNF4ZnlCdk@google.com>
         <5034abb9-e176-d480-c577-1ec5dd47182b@redhat.com>
         <9bfeae26-b4b1-eedb-6cbd-b4f9f1e1cc55@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-08-16 at 20:02 +1000, Gavin Shan wrote:
> Hi Sean,
> 
> On 8/16/22 3:02 PM, Gavin Shan wrote:
> > On 8/16/22 7:42 AM, Sean Christopherson wrote:
> > > On Mon, Aug 15, 2022, kernel test robot wrote:
> > > > commit: e923b0537d28e15c9d31ce8b38f810b325816903 ("KVM:
> > > > selftests: Fix target thread to be migrated in rseq_test")
> > > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git
> > > >  master
> > > 
> > > ...
> > > 
> > > > # selftests: kvm: rseq_test
> > > > # ==== Test Assertion Failure ====
> > > > #   rseq_test.c:278: i > (NR_TASK_MIGRATIONS / 2)
> > > > #   pid=49599 tid=49599 errno=4 - Interrupted system call
> > > > #      1    0x000000000040265d: main at rseq_test.c:278
> > > > #      2    0x00007fe44eed07fc: ?? ??:0
> > > > #      3    0x00000000004026d9: _start at ??:?
> > > > #   Only performed 23174 KVM_RUNs, task stalled too much?
> > > > #
> > > > not ok 56 selftests: kvm: rseq_test # exit=254
> > > 
> > > ...
> > > 
> > > > # Automatically generated file; DO NOT EDIT.
> > > > # Linux/x86_64 5.19.0-rc6 Kernel Configuration
> > > > #
> > > > CONFIG_CC_VERSION_TEXT="gcc-11 (Debian 11.3.0-3) 11.3.0"
> > > > CONFIG_CC_IS_GCC=y
> > > > CONFIG_GCC_VERSION=110300
> > > > CONFIG_CLANG_VERSION=0
> > > > CONFIG_AS_IS_GNU=y
> > > > CONFIG_AS_VERSION=23800
> > > > CONFIG_LD_IS_BFD=y
> > > > CONFIG_LD_VERSION=23800
> > > > CONFIG_LLD_VERSION=0
> > > 
> > > Assuming 23800 == 2.38, this is a known issue.
> > > 
> > > https://lore.kernel.org/all/20220810104114.6838-1-gshan@redhat.com
> > > 
> > 
> > It's probably different story this time. The assert is triggered
> > because
> > of the following instructions. I would guess the reason is vcpu
> > thread
> > has been running on CPU where we has high CPU load. In this case,
> > the
> > vcpu thread can't be run in time. More specific, the vcpu thread
> > can't
> > be run in the 1 - 10us time window, which is specified by the
> > migration
> > worker (thread).
> > 
> >      TEST_ASSERT(i > (NR_TASK_MIGRATIONS / 2),
> >                  "Only performed %d KVM_RUNs, task stalled too
> > much?\n", i);
> > 
> > I think we need to improve the handshake mechanism between the vcpu
> > thread
> > and migration worker. In current implementation, the handshake is
> > done through
> > the atomic counter. The mechanism is simple enough, but vcpu thread
> > can miss
> > the aforementioned time window. Another issue is the test case much
> > more time
> > than expected to finish.
> > 
> > Sean, if you think it's reasonable, I can figure out something to
> > do:
> > 
> > - Reuse the atomic counter for a full synchronization between these
> > two
> >    threads. Something like below:
> > 
> >    #define RSEQ_TEST_STATE_RUN_VCPU       0     // vcpu_run()
> >    #define RSEQ_TEST_STATE_MIGRATE        1     //
> > sched_setaffinity()
> >    #define RSEQ_TEST_STATE_CHECK          2     // Check
> > rseq.cpu_id and get_cpu()
> > 
> >    The atomic counter is reset to RSEQ_TEST_STATE_RUN_VCPU after
> > RSEQ_TEST_STATE_RUN_VCPU
> > 
> > - Reduce NR_TASK_MIGRATIONS from 100000 to num_of_online_cpus().
> > With this,
> >    less time is needed to finish the test case.
> > 
> 
> I'm able to recreate the issue on my local arm64 system.
> 
> - From the source code, the iteration count is changed from 100000 to
> 1000
> - Only CPU#0 and CPU#1 are exposed in calc_min_max_cpu, meaning other
> CPUs
>    are cleared from @possible_mask
> - Run some CPU bound task on CPU#0 and CPU#1
>    # while true; do taskset -c 0 ./a; done
>    # while true; do taskset -c 1 ./a; done
> - Run 'rseq_test' and hit the issue
>    # ./rseq_test
>    calc_min_max_cpu: nproc=224
>    calc_min_max_cpu: min_cpu=0, max_cpu=1
>    main: Required tests: 1000   Succeeds: 1
>    ==== Test Assertion Failure ====
>      rseq_test.c:280: i > (NR_TASK_MIGRATIONS / 2)
>      pid=9624 tid=9624 errno=4 - Interrupted system call
>         1	0x0000000000401cf3: main at rseq_test.c:280
>         2	0x0000ffffbc64679b: ?? ??:0
>         3	0x0000ffffbc64686b: ?? ??:0
>         4	0x0000000000401def: _start at ??:?
>      Only performed 1 KVM_RUNs, task stalled too much?
> 
I met this as well, and can reproduce this easily on my Cascade-Lake
machine, without heavy workload; before I find this mail.
I'm wondering if it's because vcpu_run() has become much more time
consuming than this test case was defined?

BTW, if we substitute sys_getcpu(&cpu) with vdso_getcpu(), can reduce
the reproduction odds.

> Thanks,
> Gavin
> 
> 

