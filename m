Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFD8189C74
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 14:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgCRNAn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 09:00:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:23654 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCRNAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Mar 2020 09:00:43 -0400
IronPort-SDR: jRqojb2ANCBUjzfseVWvf/xs5ifkax/o0EHAK/SH9e01IxihjjGJHmLDjO+Rvo1TPxan0ogiC8
 U5G17eXUnXYQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 06:00:42 -0700
IronPort-SDR: hfeXDogKZw0nw4dXkptVOwvMsSqy7xxAHJsbL5WqVpcO1Jtfb/dKhHEZbpBHzyhx4T54rMlMcK
 41hbqV24EaWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,567,1574150400"; 
   d="scan'208";a="238599576"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.29.88]) ([10.255.29.88])
  by orsmga008.jf.intel.com with ESMTP; 18 Mar 2020 06:00:40 -0700
Subject: Re: [PATCH v2] KVM: x86: Remove unnecessary brackets in
 kvm_arch_dev_ioctl()
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200229025212.156388-1-xiaoyao.li@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <a86794df-5a39-31a5-b97b-6a2496431626@intel.com>
Date:   Wed, 18 Mar 2020 21:00:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200229025212.156388-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

hi, Paolo?

On 2/29/2020 10:52 AM, Xiaoyao Li wrote:
> In kvm_arch_dev_ioctl(), the brackets of case KVM_X86_GET_MCE_CAP_SUPPORTED
> accidently encapsulates case KVM_GET_MSR_FEATURE_INDEX_LIST and case
> KVM_GET_MSRS. It doesn't affect functionality but it's misleading.
> 
> Remove unnecessary brackets and opportunistically add a "break" in the
> default path.
> 
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
>   arch/x86/kvm/x86.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5de200663f51..e49f3e735f77 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3464,7 +3464,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
>   		r = 0;
>   		break;
>   	}
> -	case KVM_X86_GET_MCE_CAP_SUPPORTED: {
> +	case KVM_X86_GET_MCE_CAP_SUPPORTED:
>   		r = -EFAULT;
>   		if (copy_to_user(argp, &kvm_mce_cap_supported,
>   				 sizeof(kvm_mce_cap_supported)))
> @@ -3496,9 +3496,9 @@ long kvm_arch_dev_ioctl(struct file *filp,
>   	case KVM_GET_MSRS:
>   		r = msr_io(NULL, argp, do_get_msr_feature, 1);
>   		break;
> -	}
>   	default:
>   		r = -EINVAL;
> +		break;
>   	}
>   out:
>   	return r;
> 

