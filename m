Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3B511A13A
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 03:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfLKCQu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Tue, 10 Dec 2019 21:16:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:7528 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbfLKCQu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 21:16:50 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2019 18:16:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="296085838"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga001.jf.intel.com with ESMTP; 10 Dec 2019 18:16:48 -0800
Received: from fmsmsx153.amr.corp.intel.com (10.18.125.6) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 10 Dec 2019 18:16:36 -0800
Received: from shsmsx103.ccr.corp.intel.com (10.239.4.69) by
 FMSMSX153.amr.corp.intel.com (10.18.125.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 10 Dec 2019 18:16:36 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.90]) by
 SHSMSX103.ccr.corp.intel.com ([169.254.4.29]) with mapi id 14.03.0439.000;
 Wed, 11 Dec 2019 10:16:35 +0800
From:   "Kang, Luwei" <luwei.kang@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Peng <chao.p.peng@linux.intel.com>
Subject: RE: [PATCH 1/2] KVM: VMX: Add non-canonical check on writes to RTIT
 address MSRs
Thread-Topic: [PATCH 1/2] KVM: VMX: Add non-canonical check on writes to
 RTIT address MSRs
Thread-Index: AQHVr7D+eSLLMngHS0yaamPyTS1Jdae0MG+Q
Date:   Wed, 11 Dec 2019 02:16:35 +0000
Message-ID: <82D7661F83C1A047AF7DC287873BF1E17384B7F2@SHSMSX104.ccr.corp.intel.com>
References: <20191210232433.4071-1-sean.j.christopherson@intel.com>
 <20191210232433.4071-2-sean.j.christopherson@intel.com>
In-Reply-To: <20191210232433.4071-2-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODc0ODBiZWMtYjg1MS00MDk4LTkxOTktNzI1ZTkzOGQzZDU0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQ2prZko1YW5wU1JMY3MwZUVoVFJHM01seW4rayt1VnJJR1wvalBJVVZHNk1BMnMwQnlkUzlVNlwvQU1OMm5RQVptIn0=
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Christopherson, Sean J <sean.j.christopherson@intel.com>
> Sent: Wednesday, December 11, 2019 7:25 AM
> To: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Christopherson, Sean J <sean.j.christopherson@intel.com>; Vitaly Kuznetsov <vkuznets@redhat.com>; Wanpeng Li
> <wanpengli@tencent.com>; Jim Mattson <jmattson@google.com>; Joerg Roedel <joro@8bytes.org>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; Chao Peng <chao.p.peng@linux.intel.com>; Kang, Luwei <luwei.kang@intel.com>
> Subject: [PATCH 1/2] KVM: VMX: Add non-canonical check on writes to RTIT address MSRs
> 
> Reject writes to RTIT address MSRs if the data being written is a non-canonical address as the MSRs are subject to canonical checks,
> e.g.
> KVM will trigger an unchecked #GP when loading the values to hardware during pt_guest_enter().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index 51e3b27f90ed..9aa2006dbe04 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2152,6 +2152,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  			(index >= 2 * intel_pt_validate_cap(vmx->pt_desc.caps,
>  					PT_CAP_num_address_ranges)))
>  			return 1;
> +		if (is_noncanonical_address(data, vcpu))
> +			return 1;

Is this for live migrate a VM with 5 level page table to the VM with 4 level page table?

Thanks,
Luwei Kang

>  		if (index % 2)
>  			vmx->pt_desc.guest.addr_b[index / 2] = data;
>  		else
> --
> 2.24.0

