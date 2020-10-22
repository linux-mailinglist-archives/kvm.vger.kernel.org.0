Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03D702960EA
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 16:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368129AbgJVO2H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 10:28:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:58132 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2444386AbgJVO2H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 10:28:07 -0400
IronPort-SDR: cabjaFh+MSpP+fDOSMP9JWjkN4Zo/EAPx77fa+B8RwLhdXtYgf+hs45jNEDqoEhUpntORO3rn7
 2nhy+HgTMkrQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="164041662"
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="164041662"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 07:28:06 -0700
IronPort-SDR: L+dFQT6cHBy65R4Ul9GHwhWOpLgNkoEKrejKSppdTaOe1P95kFBg18MbCJp34PbbvCvvZ4LMCr
 Lm+NFs0PyrMA==
X-IronPort-AV: E=Sophos;i="5.77,404,1596524400"; 
   d="scan'208";a="533985541"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.254.213.210]) ([10.254.213.210])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2020 07:28:04 -0700
Subject: Re: [PATCH] KVM: X86: Expose KVM_HINTS_REALTIME in
 KVM_GET_SUPPORTED_CPUID
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1603330475-7063-1-git-send-email-wanpengli@tencent.com>
 <cfd9d16f-6ddf-60d5-f73d-bb49ccd4055f@redhat.com>
 <6ad94df6-9ecd-e364-296a-34ba41e938b1@intel.com>
 <31b189e0-503f-157d-7af0-329744ed5369@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <18e7a0c6-faff-8c4c-0830-a0bc02627a36@intel.com>
Date:   Thu, 22 Oct 2020 22:28:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <31b189e0-503f-157d-7af0-329744ed5369@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/22/2020 10:06 PM, Paolo Bonzini wrote:
> On 22/10/20 15:31, Xiaoyao Li wrote:
>>>
>>> It's common for userspace to copy all supported CPUID bits to
>>> KVM_SET_CPUID2, I don't think this is the right behavior for
>>> KVM_HINTS_REALTIME.
>>
>> It reminds of X86_FEATURE_WAITPKG, which is added to supported CPUID
>> recently as a fix but QEMU exposes it to guest only when "-overcommit
>> cpu-pm"
> 
> WAITPKG is not included in KVM_GET_SUPPORTED_CPUID either.  QEMU detects
> it through the MSR_IA32_UMWAIT register.

Doesn't 0abcc8f65cc2 ("KVM: VMX: enable X86_FEATURE_WAITPKG in KVM 
capabilities") add WAITPKG to KVM_GET_SUPPORTED_CPUID?

> Paolo
> 

