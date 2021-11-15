Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF3E4508B1
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 16:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236469AbhKOPkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 10:40:45 -0500
Received: from mga12.intel.com ([192.55.52.136]:8095 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236388AbhKOPkl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 10:40:41 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="213495059"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="213495059"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 07:37:44 -0800
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="505960388"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.29.112]) ([10.255.29.112])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 07:37:40 -0800
Message-ID: <ad843332-7669-7791-5379-753a73bb70ab@intel.com>
Date:   Mon, 15 Nov 2021 23:37:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [PATCH 01/11] KVM: x86: Introduce vm_type to differentiate normal
 VMs from confidential VMs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
 <20211112153733.2767561-2-xiaoyao.li@intel.com> <YY6aqVkHNEfEp990@google.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <YY6aqVkHNEfEp990@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/13/2021 12:47 AM, Sean Christopherson wrote:
> On Fri, Nov 12, 2021, Xiaoyao Li wrote:
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> Unlike normal VMs, confidential VMs (Intel TDX and AMD SEV-ES) don't
>> allow some operations (e.g., memory read/write, register state acces, etc).
>>
>> Introduce vm_type to track the type of the VM. Further, different policy
>> can be made based on vm_type.
>>
>> Define KVM_X86_NORMAL_VM for normal VM as default and define
>> KVM_X86_TDX_VM for Intel TDX VM.
> 
> I still don't like the "normal" terminology, I would much prefer we use "auto"
> or "default".
> 
> https://lkml.kernel.org/r/YQsjQ5aJokV1HZ8N@google.com
> 

Apparently I missed this. I'll use KVM_X86_DEFAULT_VM in next submission 
if no better option appears.

