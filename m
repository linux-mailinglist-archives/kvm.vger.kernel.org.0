Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20043750A8
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 10:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbhEFIWz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 04:22:55 -0400
Received: from mga17.intel.com ([192.55.52.151]:60650 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231929AbhEFIWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 04:22:54 -0400
IronPort-SDR: 1AYIDNJYwzVJ0GwmzHlRR8JU/vqAt9LNYZ78odr9tUkjmIIOSSPzkZU/bSFlHElMOTWjV6gU9P
 dMNGLFs12VmQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="178648757"
X-IronPort-AV: E=Sophos;i="5.82,277,1613462400"; 
   d="scan'208";a="178648757"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 01:21:55 -0700
IronPort-SDR: g4z8m5QE4qwcF+Fi8aDyO6fsSg088sGEKtuoi//CNTD35nw6DY7h/kNzF7+McYg/KBQADXdWgk
 0YHw8Say7oIA==
X-IronPort-AV: E=Sophos;i="5.82,277,1613462400"; 
   d="scan'208";a="430425641"
Received: from unknown (HELO [10.238.0.151]) ([10.238.0.151])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 01:21:53 -0700
Subject: Re: [PATCH v2 1/3] KVM: X86: Rename DR6_INIT to DR6_ACTIVE_LOW
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210202090433.13441-1-chenyi.qiang@intel.com>
 <20210202090433.13441-2-chenyi.qiang@intel.com>
 <3db069ba-b4e0-1288-ec79-66ac44938682@redhat.com>
 <6678520f-e69e-6116-88c9-e9d6cd450934@intel.com>
 <ea9eaa84-999b-82cb-ef40-66fde361704d@redhat.com>
 <dc22f0a2-97c5-d54d-a521-c02f802c2229@intel.com>
 <3d7455a7-dca7-3c60-0c34-3a3ab8f7f1fb@redhat.com>
From:   Chenyi Qiang <chenyi.qiang@intel.com>
Message-ID: <f8d6f502-e870-b374-afc4-62fd49dd5571@intel.com>
Date:   Thu, 6 May 2021 16:21:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <3d7455a7-dca7-3c60-0c34-3a3ab8f7f1fb@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/2/2021 5:01 PM, Paolo Bonzini wrote:
> On 02/04/21 10:53, Xiaoyao Li wrote:
>>>
>>
>> Hi Paolo,
>>
>> Fenghua's bare metal support is in tip tree now.
>> https://lore.kernel.org/lkml/20210322135325.682257-1-fenghua.yu@intel.com/
>>
>> Will the rest KVM patches get into 5.13 together?
> 
> Yes, they will.
> 
> Thanks for the notice!
> 

Hi Paolo,

I notice the patch 1 is merged but the remaining patch 2 and 3 are not 
included yet. The bare metal support is merged. Will the rest KVM parts 
be in 5.13 as well?

> Paolo
> 
