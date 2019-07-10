Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0CE642E7
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 09:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfGJHch (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 03:32:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:55878 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbfGJHcg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 03:32:36 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jul 2019 00:32:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,473,1557212400"; 
   d="scan'208";a="249387164"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.129.20]) ([10.238.129.20])
  by orsmga001.jf.intel.com with ESMTP; 10 Jul 2019 00:32:34 -0700
Subject: Re: [PATCH 2/5] KVM: cpuid: extract do_cpuid_7_mask and support
 multiple subleafs
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190704140715.31181-1-pbonzini@redhat.com>
 <20190704140715.31181-3-pbonzini@redhat.com>
 <5af77de6-3a18-a3b9-b492-c280ac4310a1@linux.intel.com>
 <d3454d11-97fb-42f2-0a0c-add0456b076c@redhat.com>
From:   Jing Liu <jing2.liu@linux.intel.com>
Message-ID: <752c2473-04d9-8420-a78f-fa677f806aca@linux.intel.com>
Date:   Wed, 10 Jul 2019 15:32:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <d3454d11-97fb-42f2-0a0c-add0456b076c@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/10/2019 2:30 PM, Paolo Bonzini wrote:
> On 08/07/19 09:07, Jing Liu wrote:
>>>
>> And when adding subleaf 1, plan to add codes,
>>
>> case 1:
>>      entry->eax |= kvm_cpuid_7_1_eax_x86_features;
>>      entry->ebx = entry->ecx = entry->edx =0;
>>      break;
>>
>> What do you think?
> 
> This should be "&=", not "|=".  Otherwise yes, that's the idea.
> 

Yes! So let me send out the BFloat16 patch based on your patch set now
or you have merge plan soon?

Thanks,
Jing

> Paolo
> 
