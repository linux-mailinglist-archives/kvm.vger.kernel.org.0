Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD5EA2ACAAC
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 02:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgKJBuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 20:50:17 -0500
Received: from mga03.intel.com ([134.134.136.65]:64557 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbgKJBuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 20:50:17 -0500
IronPort-SDR: U18iNfb0axS2VtrXEFn3c92EAsE8OewD0VKY3SvQEgKvYLb0wWqBFZbDgVeDpHI88KWBLgPN9p
 tXUBJr962JeQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="170012865"
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="170012865"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 17:49:53 -0800
IronPort-SDR: iLWfhVeJPwdl5kuGCq5+cXXPjDRZ9x4YsAf2jLwQG0BcO3surBEqJqnh3wHuvDDNi9n2w1eBHV
 V2yd4E+7dGQA==
X-IronPort-AV: E=Sophos;i="5.77,464,1596524400"; 
   d="scan'208";a="541126259"
Received: from likexu-mobl1.ccr.corp.intel.com (HELO [10.238.4.107]) ([10.238.4.107])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2020 17:49:51 -0800
Subject: Re: [PATCH 4/5 v4] KVM: VMX: Fill in conforming vmx_x86_ops via macro
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, qemu-devel@nongnu.org,
        sean.j.christopherson@intel.com, jmattson@google.com
References: <20201110012312.20820-1-krish.sadhukhan@oracle.com>
 <20201110012312.20820-5-krish.sadhukhan@oracle.com>
From:   Like Xu <like.xu@linux.intel.com>
Organization: Intel OTC
Message-ID: <0ef40499-77b8-587a-138d-9b612ae9ae8c@linux.intel.com>
Date:   Tue, 10 Nov 2020 09:49:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201110012312.20820-5-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Krish,

On 2020/11/10 9:23, Krish Sadhukhan wrote:
> @@ -1192,7 +1192,7 @@ void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
>   	}
>   }
>   
> -void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
> +void vmx_prepare_guest_switch(struct kvm_vcpu *vcpu)

What do you think of renaming it to

	void vmx_prepare_switch_for_guest(struct kvm_vcpu *vcpu)；

?

Thanks,
Like Xu

>   {
>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>   	struct vmcs_host_state *host_state;
> 
> @@ -311,7 +311,7 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
>   int allocate_vpid(void);
>   void free_vpid(int vpid);
>   void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
> -void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
> +void vmx_prepare_guest_switch(struct kvm_vcpu *vcpu);
>   void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
>   			unsigned long fs_base, unsigned long gs_base);
>   int vmx_get_cpl(struct kvm_vcpu *vcpu);

