Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E68B7D4A12
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 10:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232926AbjJXIb1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 04:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbjJXIbT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 04:31:19 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05AB99;
        Tue, 24 Oct 2023 01:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698136278; x=1729672278;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Y9bhOX1BQs9M2uCnq/v6ta+fLdlpc+OpMNlbNlpw8M0=;
  b=HAGRKFcqqbd5pVxxF6+RiL0Vusk21OCGwWQBGkO0Fm/fFRYIYoThIRqk
   rXWIlQoA/AJv0YcpBBqsNqv1GO0q/3fZJt56Y7admlYSO5EzZS8pXkjY2
   AU7/SP4oJRQ1cwxagkXqBT0BsxRUilExIGpFgLqlTIQgxdx1mrcfuawda
   +b+1jpMh1WC8Vxmsdi9+4OFW7vHDNvNS0CAv/Vti/TH/plw1d7jhQLvS+
   OAFkNuC0x9AgBzwxN1bpNutCSC+pbGA86nXypxjzOFlwP8xyJV+Dir25u
   UxRThcULj6/F1BnzlLa3XxFtKJsy49B5kxH94KutTLjg4PUdsvN7Wes8m
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="453470878"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="453470878"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 01:31:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="758394704"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="758394704"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.9.167]) ([10.238.9.167])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 01:31:14 -0700
Message-ID: <b60c5dbd-9a69-6244-ea88-bea70bca8ee7@linux.intel.com>
Date:   Tue, 24 Oct 2023 16:31:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v11 00/16] LAM and LASS KVM Enabling
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        David.Laight@ACULAB.COM, robert.hu@linux.intel.com,
        guang.zeng@intel.com
References: <20230913124227.12574-1-binbin.wu@linux.intel.com>
 <169810442917.2499338.3440694989716170017.b4-ty@google.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <169810442917.2499338.3440694989716170017.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/24/2023 7:43 AM, Sean Christopherson wrote:
> On Wed, 13 Sep 2023 20:42:11 +0800, Binbin Wu wrote:
>> This patch series includes KVM enabling patches for Linear-address masking
>> (LAM) v11 and Linear Address Space Separation (LASS) v3 since the two features
>> have overlapping prep work and concepts. Sent as a single series to reduce the
>> probability of conflicts.
>>
>> The patch series is organized as follows:
>> - Patch 1-4: Common prep work for both LAM and LASS.
>> - Patch 5-13: LAM part.
>> - Patch 14-16: LASS part.
>>
>> [...]
> Applied to kvm-x86 lam (for 6.8)!  I skipped the LASS patches, including patch 2
> (the branch targets patch).  I kept the IMPLICIT emulator flag even thought it's
> not strictly needed as it's a nice way to document non-existent code.
>
> I massaged a few changelogs and fixed the KVM_X86_OP_OPTIONAL() issue, but
> otherwise I don't think I made any code changes (it's been a long day :-) ).
> Please take a look to make sure it all looks good.
Hi Sean,
Thanks for changelogs massage and the KVM_X86_OP_OPTIONAL() issue fix.
The LAM patches were applied as expected.


>
> Thanks!
>
> [01/16] KVM: x86: Consolidate flags for __linearize()
>          https://github.com/kvm-x86/linux/commit/81c940395b14
> [02/16] KVM: x86: Use a new flag for branch targets
>          (no commit info)
> [03/16] KVM: x86: Add an emulation flag for implicit system access
>          https://github.com/kvm-x86/linux/commit/90532843aebf
> [04/16] KVM: x86: Add X86EMUL_F_INVLPG and pass it in em_invlpg()
>          https://github.com/kvm-x86/linux/commit/34b4ed7c1eaf
> [05/16] KVM: x86/mmu: Drop non-PA bits when getting GFN for guest's PGD
>          https://github.com/kvm-x86/linux/commit/8b83853c5c98
> [06/16] KVM: x86: Add & use kvm_vcpu_is_legal_cr3() to check CR3's legality
>          https://github.com/kvm-x86/linux/commit/82ba7169837e
> [07/16] KVM: x86: Remove kvm_vcpu_is_illegal_gpa()
>          https://github.com/kvm-x86/linux/commit/95df55ee42fe
> [08/16] KVM: x86: Introduce get_untagged_addr() in kvm_x86_ops and call it in emulator
>          https://github.com/kvm-x86/linux/commit/7a747b6c84a1
> [09/16] KVM: x86: Untag address for vmexit handlers when LAM applicable
>          https://github.com/kvm-x86/linux/commit/ef99001b30a8
> [10/16] KVM: x86: Virtualize LAM for supervisor pointer
>          https://github.com/kvm-x86/linux/commit/4daea9a5183f
> [11/16] KVM: x86: Virtualize LAM for user pointer
>          https://github.com/kvm-x86/linux/commit/0cadc474eff0
> [12/16] KVM: x86: Advertise and enable LAM (user and supervisor)
>          https://github.com/kvm-x86/linux/commit/6ef90ee226f1
> [13/16] KVM: x86: Use KVM-governed feature framework to track "LAM enabled"
>          https://github.com/kvm-x86/linux/commit/b291db540763
> [14/16] KVM: emulator: Add emulation of LASS violation checks on linear address
>          (no commit info)
> [15/16] KVM: VMX: Virtualize LASS
>          (no commit info)
> [16/16] KVM: x86: Advertise LASS CPUID to user space
>          (no commit info)
>
> --
> https://github.com/kvm-x86/linux/tree/next

