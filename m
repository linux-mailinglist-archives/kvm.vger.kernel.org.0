Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF0D44D334
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 09:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhKKIb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 03:31:57 -0500
Received: from mga14.intel.com ([192.55.52.115]:31653 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232257AbhKKIb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 03:31:56 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="233119652"
X-IronPort-AV: E=Sophos;i="5.87,225,1631602800"; 
   d="scan'208";a="233119652"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 00:29:08 -0800
X-IronPort-AV: E=Sophos;i="5.87,225,1631602800"; 
   d="scan'208";a="504341359"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 00:29:03 -0800
Message-ID: <7733a5fe-6284-fe1d-a09d-cc22be8b3887@intel.com>
Date:   Thu, 11 Nov 2021 16:29:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.3.0
Subject: Re: [RFC PATCH v2 22/69] KVM: x86: Add vm_type to differentiate
 legacy VMs from protected VMs
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "erdemaktas@google.com" <erdemaktas@google.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <8eb87cd52a89d957af03f93a9ece5634426a7757.1625186503.git.isaku.yamahata@intel.com>
 <e2270f66-abd8-db17-c3bd-b6d9459624ec@redhat.com>
 <YO356ni0SjPsLsSo@google.com>
 <5689dc7e-b0e0-1733-f00f-66dc7b62b960@intel.com>
 <055d924e-2117-247f-8339-7487153e284b@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <055d924e-2117-247f-8339-7487153e284b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/2021 3:28 PM, Paolo Bonzini wrote:
> On 11/11/21 04:28, Xiaoyao Li wrote:
>>>
>>> Heh, because kvm_dev_ioctl_create_vm() takes an "unsigned long" for 
>>> the type and
>>> it felt wrong to store it as something else.  Storing it as a smaller 
>>> field should
>>> be fine, I highly doubt we'll get to 256 types anytime soon :-)
>>
>> It's the bit position. We can get only 8 types with u8 actually.
> 
> Every architecture defines the meaning, and for x86 we can say it's not 
> a bit position.

Sorry, I find I was wrong. The types are not bit position but value.

KVM_CAP_VM_TYPES reports the supported vm types using bitmap that bit n 
represents type value n.

> Paolo
> 

