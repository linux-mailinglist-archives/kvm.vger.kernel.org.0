Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA6C7BA875
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 19:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbjJERwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 13:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbjJERw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 13:52:29 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58014A6;
        Thu,  5 Oct 2023 10:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696528348; x=1728064348;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TtiSPYzoUtvmt+GaR6E65uzRaBQ5yy2BuLcs6NWBp9E=;
  b=DxXg2s2XE4921TLu0BvxDtuf5w8psxB+7mJwoitOz/sAw7zwfOEAsnCH
   DtGISsniO9N7eG4ornDYlyCZTkfkaoAbcGL6ijFDKwUu1SoOSEdeG261j
   67WFksSrUlVDEY1q64Nq4ZBWko90AqXMnnJEQCVFEyzvVtFFj7UbPFsiw
   vak5mNPBoYSxo/3kPuD5A8qmGC3RiI5Bl1GZirHPyeJ7cF6G9uXUXEEoY
   cyqEE7ADMaLH2rtHCGjJEiMHbIYYiU3okFQhiY9JDkWx9YomZUI/uB39S
   KOswtAi6uSi+YQCwl4BCjqJZsqXpykpoxS178+S8osaQE/b4s+w4qtHIT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="368648041"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="368648041"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 10:52:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10854"; a="701744560"
X-IronPort-AV: E=Sophos;i="6.03,203,1694761200"; 
   d="scan'208";a="701744560"
Received: from emosbarx-mobl2.amr.corp.intel.com (HELO [10.209.23.184]) ([10.209.23.184])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2023 10:52:01 -0700
Message-ID: <4059e9c6-e85b-085f-b5c5-9da209bbfab2@intel.com>
Date:   Thu, 5 Oct 2023 10:52:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] x86: KVM: Add feature flag for AMD's
 FsGsKernelGsBaseNonSerializing
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20231004002038.907778-1-jmattson@google.com>
 <01009a2a-929e-ce16-6f44-1d314e6bcba5@intel.com>
 <CALMp9eR+Qudg++J_dmY_SGbM_kr=GQcRRcjuUxtm9rfaC_qeXQ@mail.gmail.com>
 <20231004075836.GBZR0bLC/Y09sSSYWw@fat_crate.local>
 <CALMp9eT2qHSig-ptP461GbLSfg86aCRjoxzK9Q7dc6yXSpPn7A@mail.gmail.com>
 <ef665e55-7604-e167-7c49-739c284c248c@intel.com>
 <CALMp9eQL4m6PVVhntG9-RbY6w60pxka2tpCvTi01dQXPJ7QEJA@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <CALMp9eQL4m6PVVhntG9-RbY6w60pxka2tpCvTi01dQXPJ7QEJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/5/23 09:41, Jim Mattson wrote:
>>
>> But I'm struggling to think of cases where Intel has read-only
>> "defeature bits" like this one.  There are certainly things like
>> MSR_IA32_MISC_ENABLE_FAST_STRING that can be toggled, but read-only
>> indicators of a departure from established architecture seems ...
>> suboptimal.
...
> CPUID.(EAX=7,ECX=0):EBX[bit 13] (Haswell) - "Deprecates FPU CS and FPU
> DS values if 1."
> CPUID.(EAX=7,ECX=0):EBX[bit 6] (Skylake) - "FDP_EXCPTN_ONLY. x87 FPU
> Data Pointer updated only on x87 exceptions if 1."

Thanks!

Trying to group these does make sense to me.  I don't think people take
architecture breakage lightly, but I certainly never considered that it
might, for instance, be important enough to create a new VM migration pool.

I'll try to keep an eye out for these.
