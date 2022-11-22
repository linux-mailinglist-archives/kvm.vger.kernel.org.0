Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF106341E1
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiKVQum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiKVQuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:50:40 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BE76C729;
        Tue, 22 Nov 2022 08:50:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669135839; x=1700671839;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=puqtoUPvntcrMHUyIfxv2XTasYKx66NRxAdTJ/YKsJo=;
  b=B0RO81aP0AKXo6JdOrrYUo70nZJTQ/JsyOuUN3q11s3vvUvevukKQLvs
   bWWB57NQKaAb1M8lLhNQtyHBLs9FsuFmoft0fRqXgfjZhXGmXAzgH9Cy9
   SQcHvR9XR//yIl3KMmFPdTLjz1LEw98GEc7zg2Krg2wYOG/AxvGdsDPmq
   eggR792mCyzNYo5QPQxDAjkDrY45N+6/F7zNRB/geK0ltUAQqki3BdZFV
   rX14B66tOI0F0rtQNxTFCTYGRrtZjR2aKD1VfbQ8rHuvI4b7oCu5/Mp0/
   m9u86vEg17sBHrZ9BevQyISd9dnNeKCLQppwdSDK2IKcJNfmkTX56qahA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="315680098"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="315680098"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 08:50:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="592201627"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="592201627"
Received: from lcano-mobl1.amr.corp.intel.com (HELO [10.255.231.75]) ([10.255.231.75])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 08:50:23 -0800
Message-ID: <f743a4df-f285-3f07-02ef-b908020e0c93@intel.com>
Date:   Tue, 22 Nov 2022 08:50:23 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v7 02/20] x86/virt/tdx: Detect TDX during kernel boot
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <aaee2d5332a97c840ad401ba935842a998a877ec.1668988357.git.kai.huang@intel.com>
 <e758572a-5bb1-092a-10f6-591fb4526997@intel.com>
 <9db9599fba11490cebbe59cbb7c145e9c119ab0f.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <9db9599fba11490cebbe59cbb7c145e9c119ab0f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/22/22 03:28, Huang, Kai wrote:
>>> +	/*
>>> +	 * KeyID 0 is for TME.  MKTME KeyIDs start from 1.  TDX private
>>> +	 * KeyIDs start after the last MKTME KeyID.
>>> +	 */
>>
>> Is the TME key a "MKTME KeyID"?
> 
> I don't think so.  Hardware handles TME KeyID 0 differently from non-0 MKTME
> KeyIDs.  And PCONFIG only accept non-0 KeyIDs.

Let's say we have 4 MKTME hardware bits, we'd have:

   0: TME Key
1->3: MKTME Keys
4->7: TDX Private Keys

First, the MSR values:

> +        * IA32_MKTME_KEYID_PARTIONING:
> +        *   Bit [31:0]:        Number of MKTME KeyIDs.
> +        *   Bit [63:32]:       Number of TDX private KeyIDs.

These would be:

	Bit [ 31:0] = 3
	Bit [63:22] = 4

And in the end the variables:

	tdx_keyid_start would be 4 and tdx_keyid_num would be 4.

Right?

That's a bit wonky for my brain because I guess I know too much about
the internal implementation and how the key space is split up.  I guess
I (wrongly) expected Bit[31:0]==Bit[63:22].



>>> +static void __init clear_tdx(void)
>>> +{
>>> +	tdx_keyid_start = tdx_keyid_num = 0;
>>> +}
>>
>> This is where a comment is needed and can actually help.
>>
>> /*
>>  * tdx_keyid_start/num indicate that TDX is uninitialized.  This
>>  * is used in TDX initialization error paths to take it from
>>  * initialized -> uninitialized.
>>  */
> 
> Just want to point out after removing the !x2apic_enabled() check, the only
> thing need to do here is to detect/record the TDX KeyIDs.
> 
> And the purpose of this TDX boot-time initialization code is to provide
> platform_tdx_enabled() function so that kexec() can use.
> 
> To distinguish boot-time TDX initialization from runtime TDX module
> initialization, how about change the comment to below?
> 
> static void __init clear_tdx(void)
> {
>         /*
>          * tdx_keyid_start and nr_tdx_keyids indicate that TDX is not
>          * enabled by the BIOS.  This is used in TDX boot-time
>          * initializatiton error paths to take it from enabled to not
>          * enabled.
>          */
>         tdx_keyid_start = nr_tdx_keyids = 0;
> }
> 
> [...]

I honestly have no idea what "boot-time TDX initialization" is versus
"runtime TDX module initialization".  This doesn't hel.

> And below is the updated patch.  How does it look to you?

Let's see...

...
> +static u32 tdx_keyid_start __ro_after_init;
> +static u32 nr_tdx_keyids __ro_after_init;
> +
> +static int __init record_keyid_partitioning(void)
> +{
> +       u32 nr_mktme_keyids;
> +       int ret;
> +
> +       /*
> +        * IA32_MKTME_KEYID_PARTIONING:
> +        *   Bit [31:0]:        Number of MKTME KeyIDs.
> +        *   Bit [63:32]:       Number of TDX private KeyIDs.
> +        */
> +       ret = rdmsr_safe(MSR_IA32_MKTME_KEYID_PARTITIONING, &nr_mktme_keyids,
> +                       &nr_tdx_keyids);
> +       if (ret)
> +               return -ENODEV;
> +
> +       if (!nr_tdx_keyids)
> +               return -ENODEV;
> +
> +       /* TDX KeyIDs start after the last MKTME KeyID. */
> +       tdx_keyid_start++;

tdx_keyid_start is uniniitalized here.  So, it'd be 0, then ++'d.

Kai, please take a moment and slow down.  This isn't a race.  I offered
some replacement code here, which you've discarded, missed or ignored
and in the process broken this code.

This approach just wastes reviewer time.  It's not working for me.

I'm going to make a suggestion (aka. a demand): You can post these
patches at most once a week.  You get a whole week to (carefully)
incorporate reviewer feedback, make the patch better, and post a new
version.  Need more time?  Go ahead and take it.  Take as much time as
you want.


