Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F4D5E5ACC
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 07:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiIVFk3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 01:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiIVFk1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 01:40:27 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9046792CC;
        Wed, 21 Sep 2022 22:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663825226; x=1695361226;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BPS+ESxaTVs7XbbUOFDIyCZOlnp1McZ+5nVCjg/VZ/g=;
  b=G99SWonB6UGkBLVAYvojpZvqR924TTpFMPEpNn58CkJoZqQItV8rxLnT
   xhs1W6654nKPmmBoEOBbYKmPiPhN4YBucwAikjX2vUQvKqye+cNGk3JkJ
   i7aRP7Epfb10QjHH4uGanJowapwZKSmo9lia3CfgcbnKJgGW4wbYnNaPd
   xylNcY2sk0GNmFHyzJkbBnG/FVBDMkFk1SwjjMx1DF/KSNU7pYdFk6NUn
   vwbIZ6Snf+/K9X0nfZ/yEmUQckIZ6cgvrTOSQnXQvx9Ibx3nD4DmCIZtW
   91migEinQ4tBJp1mhHcaHXJD40O97Z4H+GLFjBlcWOUfvdl5Y+uM0yFTE
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="301609845"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="301609845"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 22:40:26 -0700
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="615076595"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.28.71]) ([10.255.28.71])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 22:40:22 -0700
Message-ID: <7611e818-9e81-1974-1dfa-330a6380c5da@intel.com>
Date:   Thu, 22 Sep 2022 13:40:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH] kvm/x86: reserve bit
 KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
References: <20220908114146.473630-1-kraxel@redhat.com>
 <YxoBtD+3sgEEiaFF@google.com>
 <20220909050224.rzlt4x7tjrespw3k@sirius.home.kraxel.org>
 <20220921134246.xibospqoktp4wjie@sirius.home.kraxel.org>
 <Yysm8/Nkt6EUI5+k@google.com>
 <CALMp9eRkXPPWbPfm16onV9+ondg0x7_RG5ku7hCpBAODLWpSgw@mail.gmail.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <CALMp9eRkXPPWbPfm16onV9+ondg0x7_RG5ku7hCpBAODLWpSgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/22/2022 12:32 AM, Jim Mattson wrote:
> On Wed, Sep 21, 2022 at 8:00 AM Sean Christopherson <seanjc@google.com> wrote:
>>
>> On Wed, Sep 21, 2022, Gerd Hoffmann wrote:
>>> On Fri, Sep 09, 2022 at 07:02:24AM +0200, Gerd Hoffmann wrote:
>>>> On Thu, Sep 08, 2022 at 02:52:36PM +0000, Sean Christopherson wrote:
>>>>> On Thu, Sep 08, 2022, Gerd Hoffmann wrote:
>>>>>> -#define KVM_HINTS_REALTIME      0
>>>>>> +#define KVM_HINTS_REALTIME                      0
>>>>>> +#define KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID  1
>>>>>
>>>>> Why does KVM need to get involved?  This is purely a userspace problem.
>>>>
>>>> It doesn't.  I only need reserve a hints bit, and the canonical source
>>>> for that happens to live in the kernel.  That's why this patch doesn't
>>>> touch any actual code ;)
>>
>> The issue is that this "hint" effectively breaks other VMMs that already provide
>> an accurate guest.MAXPHYADDR.
> 
> Any VMM that doesn't provide an accurate guest.MAXPHYADDR is broken.

I stand for it as well.

To me, it looks an old QEMU bug and firmware provided a workaround for 
the bug that doesn't trust guest's CPUID.0x80000008. IMHO, (guest) 
firmware should always trust CPUID and error out if MAXPHYADDR reported 
from CPUID is broken to force VMM fixing itself to provide correct CPUID 
info. But letting firmware drop the workaround surely breaks backwards 
compatibility.

> Why do we need a "hint" that the virtual processor works?





