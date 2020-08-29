Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D53B256407
	for <lists+kvm@lfdr.de>; Sat, 29 Aug 2020 03:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgH2Btx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 21:49:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:56499 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgH2Btx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 21:49:53 -0400
IronPort-SDR: 2FqDBL0I2HX3DIQtl7+QKpWv5VgLC5uGCYPky5rhvwafjWf1wC5GTnCfKWEtMOctrR4fuGhB9L
 HHLuebx+JGpQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9727"; a="156032036"
X-IronPort-AV: E=Sophos;i="5.76,365,1592895600"; 
   d="scan'208";a="156032036"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 18:49:52 -0700
IronPort-SDR: ocvihYaTA+edOSIZYPBYdos5/xzUVS6Q06grOqQRho96v4YNP20w7WWJQdWFD5VZijyPQMzgec
 xutJuaK0Qh6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,365,1592895600"; 
   d="scan'208";a="296315937"
Received: from cqiang-mobl.ccr.corp.intel.com (HELO [10.255.28.251]) ([10.255.28.251])
  by orsmga003.jf.intel.com with ESMTP; 28 Aug 2020 18:49:49 -0700
Subject: Re: [PATCH 1/5] KVM: nVMX: Fix VMX controls MSRs setup when nested
 VMX enabled
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
 <20200828085622.8365-2-chenyi.qiang@intel.com>
 <CALMp9eThyqWuduU=JN+w3M3ANeCYN+7=s-gippzyu_GmvgtVGA@mail.gmail.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <534a4ad5-b083-1278-a6ac-4a7e2b6b1600@intel.com>
Date:   Sat, 29 Aug 2020 09:49:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eThyqWuduU=JN+w3M3ANeCYN+7=s-gippzyu_GmvgtVGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/29/2020 1:43 AM, Jim Mattson wrote:
> On Fri, Aug 28, 2020 at 1:54 AM Chenyi Qiang <chenyi.qiang@intel.com> wrote:
>>
>> KVM supports the nested VM_{EXIT, ENTRY}_LOAD_IA32_PERF_GLOBAL_CTRL and
>> VM_{ENTRY_LOAD, EXIT_CLEAR}_BNDCFGS, but they doesn't expose during
>> the setup of nested VMX controls MSR.
>>
> 
> Aren't these features added conditionally in
> nested_vmx_entry_exit_ctls_update() and
> nested_vmx_pmu_entry_exit_ctls_update()?
> 

Yes, but I assume vmcs_config.nested should reflect the global 
capability of VMX MSR. KVM supports these two controls, so should be 
exposed here.
