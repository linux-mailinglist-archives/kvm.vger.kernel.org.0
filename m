Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5137A4692ED
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 10:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241467AbhLFJwE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 04:52:04 -0500
Received: from mga17.intel.com ([192.55.52.151]:26269 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241417AbhLFJwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 04:52:04 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10189"; a="217970449"
X-IronPort-AV: E=Sophos;i="5.87,291,1631602800"; 
   d="scan'208";a="217970449"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 01:48:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,291,1631602800"; 
   d="scan'208";a="460774930"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga003.jf.intel.com with ESMTP; 06 Dec 2021 01:48:33 -0800
Message-ID: <fe75d1fea273ef4f50f9e656f650a215276675f0.camel@linux.intel.com>
Subject: Re: [kvm-unit-tests PATCH] x86/vmx: Deprecate
 VMX_VMCS_ENUM.MAX_INDEX check in vmread/vmwrite test
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     seanjc@google.com, pbonzini@redhat.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, yu.c.zhang@linux.intel.com,
        robert.hu@intel.com
Date:   Mon, 06 Dec 2021 17:48:32 +0800
In-Reply-To: <1637306107-92967-1-git-send-email-robert.hu@linux.intel.com>
References: <1637306107-92967-1-git-send-email-robert.hu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping...
Thanks.
On Fri, 2021-11-19 at 15:15 +0800, Robert Hoo wrote:
> From: Yu Zhang <yu.c.zhang@linux.intel.com>
> 
> The actual value of vmcs12.vmcs_enum is set by QEMU, with hard code,
> while the expected value in this test is got from literally
> traversing
> vmcs12 fields. They probably mismatch, depends on KVM version and
> QEMU
> version used. It doesn't mean QEMU or KVM is buggy.
> 
> We deprecate this failure report, as we "don't see any point in
> fighting
> too hard with QEMU."[1]
> We keep its log here as hint.
> 
> [1] https://lore.kernel.org/kvm/YZWqJwUrF2Id9hM2@google.com/
> 
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> ---
>  x86/vmx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/x86/vmx.c b/x86/vmx.c
> index 7a2f7a3..7e191dd 100644
> --- a/x86/vmx.c
> +++ b/x86/vmx.c
> @@ -379,8 +379,7 @@ static void test_vmwrite_vmread(void)
>  	vmcs_enum_max = (rdmsr(MSR_IA32_VMX_VMCS_ENUM) &
> VMCS_FIELD_INDEX_MASK)
>  			>> VMCS_FIELD_INDEX_SHIFT;
>  	max_index = find_vmcs_max_index();
> -	report(vmcs_enum_max == max_index,
> -	       "VMX_VMCS_ENUM.MAX_INDEX expected: %x, actual: %x",
> +	printf("VMX_VMCS_ENUM.MAX_INDEX expected: %x, actual: %x\n",
>  	       max_index, vmcs_enum_max);
>  
>  	assert(!vmcs_clear(vmcs));

