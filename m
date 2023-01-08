Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09226615C5
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 15:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjAHOS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 09:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjAHOSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 09:18:54 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEEDE028
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 06:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673187533; x=1704723533;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=v9YZidXbJFeK3jp0reK7wtHfr+DFZikqo4uF+xlXsHs=;
  b=YpxD+RURUQwzuRkUF7GhlR/bd7TepccQ4yzy4OacxcOkW+Bt6dQPCmpz
   XQj0EYP5KOFKqeGEVSAnb4w3sBo02DmceRdIn6Aq75/3tFwS+jzpw4551
   aRCUKG0CEU9PNc3vQCG5ILsaXmlkNiLq029617a4Ow4a6MH6pfAtBDNQU
   zhhDxNG6RhL525sfYTIAesf1qZDynh50r6j7um+2tkMeODylr3WpsK8tk
   XyO6l4ufwVyai5LiRrkq4NsglYnt5JBdXSqdY6ALAd7dnkvqWX4aK9Sjm
   0g4tpnxSBKQl9pl3gfXMYJ3H4M6iAMDORuYthCOnnhTErkB02I3SPQc1U
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="310518684"
X-IronPort-AV: E=Sophos;i="5.96,310,1665471600"; 
   d="scan'208";a="310518684"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 06:18:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="724916605"
X-IronPort-AV: E=Sophos;i="5.96,310,1665471600"; 
   d="scan'208";a="724916605"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.255.31.16]) ([10.255.31.16])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2023 06:18:50 -0800
Message-ID: <a858b6c8-e23f-9867-c30f-fbdd2f468798@intel.com>
Date:   Sun, 8 Jan 2023 22:18:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.6.1
Subject: Re: [PATCH v3 1/9] KVM: x86: Rename cr4_reserved/rsvd_* variables to
 be more readable
Content-Language: en-US
To:     Robert Hoo <robert.hu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Binbin Wu <binbin.wu@linux.intel.com>, pbonzini@redhat.com,
        kirill.shutemov@linux.intel.com, kvm@vger.kernel.org
References: <20221209044557.1496580-1-robert.hu@linux.intel.com>
 <20221209044557.1496580-2-robert.hu@linux.intel.com>
 <2e395a24-ee7b-e31e-981c-b83e80ac5be1@linux.intel.com>
 <b8f8f8acb6348ad5789fc1df6a6c18b0fa5f91ee.camel@linux.intel.com>
 <Y7i+OW+8p7Ehlh3C@google.com>
 <cbb6c40c1fca5e389c5c3e194c424c28358c0c8e.camel@linux.intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <cbb6c40c1fca5e389c5c3e194c424c28358c0c8e.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/7/2023 9:30 PM, Robert Hoo wrote:
> On Sat, 2023-01-07 at 00:35 +0000, Sean Christopherson wrote:
>> On Thu, Dec 29, 2022, Robert Hoo wrote:
>>> On Wed, 2022-12-28 at 11:37 +0800, Binbin Wu wrote:
>>>> On 12/9/2022 12:45 PM, Robert Hoo wrote:
>>>>> kvm_vcpu_arch::cr4_guest_owned_bits and
>>>>> kvm_vcpu_arch::cr4_guest_rsvd_bits
>>>>> looks confusing. Rename latter to cr4_host_rsvd_bits, because
>>>>> it in
>>>>> fact decribes the effective host reserved cr4 bits from the
>>>>> vcpu's
>>>>> perspective.
>>>>
>>>> IMO, the current name cr4_guest_rsvd_bits is OK becuase it shows
>>>> that these
>>>> bits are reserved bits from the pointview of guest.
>>>
>>> Actually, it's cr4_guest_owned_bits that from the perspective of
>>> guest.
>>
>> No, cr4_guest_owned_bits is KVM's view of things.
> 
> That's all right. Perhaps my expression wasn't very accurate. Perhaps I
> would have said "cr4_guest_owned_bits stands on guest's points, as it
> reads, guest owns these (set) bits". Whereas, "cr4_guest_rsvd_bits"
> doesn't literally as the word reads, its set bits doesn't mean "guest
> reserved these bits" but the opposite, those set bits are reserved by
> host:
>

I think you can interpret guest_rsvd_bits as bits reserved *for* guest 
stead of *by* guest

