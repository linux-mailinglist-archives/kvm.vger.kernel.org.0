Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74B9E66301
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 02:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfGLAmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 20:42:49 -0400
Received: from mga03.intel.com ([134.134.136.65]:7091 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbfGLAmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 20:42:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 17:42:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,480,1557212400"; 
   d="scan'208";a="174309127"
Received: from txu2-mobl.ccr.corp.intel.com (HELO [10.239.196.126]) ([10.239.196.126])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jul 2019 17:42:45 -0700
Subject: Re: [PATCH v6 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     rkrcmar@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, fenghua.yu@intel.com,
        xiaoyao.li@linux.intel.com, jingqi.liu@intel.com
References: <20190621055747.17060-1-tao3.xu@intel.com>
 <20190621055747.17060-3-tao3.xu@intel.com>
 <43814a5e-12bf-ceb5-e4fb-12bbb32cd4cb@redhat.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <fcae19b2-e37e-1a39-1569-f514631913b1@intel.com>
Date:   Fri, 12 Jul 2019 08:42:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <43814a5e-12bf-ceb5-e4fb-12bbb32cd4cb@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/11/2019 9:25 PM, Paolo Bonzini wrote:
> On 21/06/19 07:57, Tao Xu wrote:
>> +	if (guest_cpuid_has(vcpu, X86_FEATURE_WAITPKG))
>> +		atomic_switch_umwait_control_msr(vmx);
>> +
> 
> guest_cpuid_has is slow.  Please replace it with a test on
> secondary_exec_controls_get(vmx).

Thank you paolo, I will improve it.

> 
> Are you going to look into nested virtualization support?  This should
> include only 1) allowing setting the enable bit in secondary execution
> controls, and passing it through in prepare_vmcs02_early; 2) reflecting
> the vmexit in nested_vmx_exit_reflected.
> 

I will add nested support in next version.

> Thanks,
> 
> Paolo
> 

