Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF8325720D
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 05:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgHaDQQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Aug 2020 23:16:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:12325 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbgHaDQQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Aug 2020 23:16:16 -0400
IronPort-SDR: ESzTFRpugYU2SxXZdElFv8c1C2YCxwQW7dwfKE4HQ3vBHG/EPGo+EvRnvGbtu/O4vX+TPN6lth
 FpnjyfYyVO7Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9729"; a="156907775"
X-IronPort-AV: E=Sophos;i="5.76,374,1592895600"; 
   d="scan'208";a="156907775"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2020 20:16:15 -0700
IronPort-SDR: wHt5yS4zUxncIxFJ9UJ3TqdAGzxMZwOzgjOE1KllM3VIZVFlH0o7kMFgP6XZbMnhWgPzVztZhf
 OIe1Pz2NlQng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,374,1592895600"; 
   d="scan'208";a="330564381"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.238.2.93]) ([10.238.2.93])
  by orsmga008.jf.intel.com with ESMTP; 30 Aug 2020 20:16:12 -0700
Subject: Re: [PATCH 2/5] KVM: nVMX: Verify the VMX controls MSRs with the
 global capability when setting VMX MSRs
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200828085622.8365-1-chenyi.qiang@intel.com>
 <20200828085622.8365-3-chenyi.qiang@intel.com>
 <CALMp9eTDTeKQrCnYsSsMPF3-0N=GW7QPOQY8xg4oiCcmv8hgYA@mail.gmail.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <d80093d9-3368-adc7-050c-75686cd261ec@intel.com>
Date:   Mon, 31 Aug 2020 11:15:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTDTeKQrCnYsSsMPF3-0N=GW7QPOQY8xg4oiCcmv8hgYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/29/2020 2:23 AM, Jim Mattson wrote:
> On Fri, Aug 28, 2020 at 1:54 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>>
>> When setting the nested VMX MSRs, verify it with the values in
>> vmcs_config.nested_vmx_msrs, which reflects the global capability of
>> VMX controls MSRs.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> 
> You seem to have entirely missed the point of this code, which is to
> prevent userspace from adding features that have previously been
> removed for this vCPU (e.g as a side-effect of KVM_SET_CPUID).
> 

We only have the case that the scope of features set by userspace is 
always reduced, right? If so, we don't need the change here.
