Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A4B30C2E6
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 16:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbhBBPDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 10:03:19 -0500
Received: from mga17.intel.com ([192.55.52.151]:5162 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234938AbhBBPDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 10:03:12 -0500
IronPort-SDR: 0tS82fhxbbW+yhCrZraqK1Ilv0Q4c2RSfGeYyJwTrmbrEw0/xq1ClTw6cH4t1KZteOR6SBC21I
 zh18TnryHtiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="160630491"
X-IronPort-AV: E=Sophos;i="5.79,395,1602572400"; 
   d="scan'208";a="160630491"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 07:02:24 -0800
IronPort-SDR: Uk16hOdv++iDDB6vBp3X4IW1QopUSrgThIjgkSnakOTR0EjLHHYyA3Hti03a7tzpvWAKkI8ZeN
 BtIPyQZudnLA==
X-IronPort-AV: E=Sophos;i="5.79,395,1602572400"; 
   d="scan'208";a="370732514"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.29.197]) ([10.255.29.197])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 07:02:22 -0800
Subject: Re: [PATCH v2 1/3] KVM: X86: Rename DR6_INIT to DR6_ACTIVE_LOW
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210202090433.13441-1-chenyi.qiang@intel.com>
 <20210202090433.13441-2-chenyi.qiang@intel.com>
 <3db069ba-b4e0-1288-ec79-66ac44938682@redhat.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <6678520f-e69e-6116-88c9-e9d6cd450934@intel.com>
Date:   Tue, 2 Feb 2021 23:02:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <3db069ba-b4e0-1288-ec79-66ac44938682@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/2021 10:49 PM, Paolo Bonzini wrote:
> On 02/02/21 10:04, Chenyi Qiang wrote:
>>
>>  #define DR6_FIXED_1    0xfffe0ff0
>> -#define DR6_INIT    0xffff0ff0
>> +/*
>> + * DR6_ACTIVE_LOW is actual the result of DR6_FIXED_1 | ACTIVE_LOW_BITS.
>> + * We can regard all the current FIXED_1 bits as active_low bits even
>> + * though in no case they will be turned into 0. But if they are defined
>> + * in the future, it will require no code change.
>> + * At the same time, it can be served as the init/reset value for DR6.
>> + */
>> +#define DR6_ACTIVE_LOW    0xffff0ff0
>>  #define DR6_VOLATILE    0x0001e00f
>>
> 
> Committed with some changes in the wording of the comment.
> 
> Also, DR6_FIXED_1 is (DR6_ACTIVE_LOW & ~DR6_VOLATILE).

Maybe we can add BUILD_BUG_ON() to make sure the correctness?

> Paolo
> 

