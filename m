Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7497D54E5AE
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 17:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377758AbiFPPGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 11:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376920AbiFPPGl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 11:06:41 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E103A5D6;
        Thu, 16 Jun 2022 08:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655392000; x=1686928000;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UOQO1BgPi0swtSFOVIG+xb/IOcTCcMuh8Pcu21YS7Oo=;
  b=N/oeLY/z6Q8iPi9i0ku7rzEBT25WVsig3uiNtb+J2j0fWXV2SG6YWeYb
   54R3GB2ehM9QIaf6MBIKYjUAvvBbCbgooyPSh+mcmK6YTbA64dmZzqEl5
   sCldrWHEv/nXlqT1nMRdwGmzXCINAlZlau5sGM1RjsB5T5UodTzvPQ64A
   o9PTAE11vzA8TrcRbHNe/6djHuHw4gZ25xOcut7KYDcerqXNGLSLwxBlg
   iJGYy/JH/FEokUtj0DDXXgfFQ2h+Q9aRrNPbJ3Udx5Hiomj345t823z4H
   OjIcuaWbN1DasG1KaGLu7UCkEo7i0SjwoW8G76XW+V9kRkp67+w2V0vEh
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259730151"
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="259730151"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 08:06:15 -0700
X-IronPort-AV: E=Sophos;i="5.92,305,1650956400"; 
   d="scan'208";a="641582383"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.249.174.123]) ([10.249.174.123])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 08:06:12 -0700
Message-ID: <56a63604-59fe-45a4-9d13-8ef5d82e736c@intel.com>
Date:   Thu, 16 Jun 2022 23:06:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 00/19] Refresh queued CET virtualization series
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "seanjc@google.com" <seanjc@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <YqsB9upUystxvl+d@hirez.programming.kicks-ass.net>
 <62d4f7f0-e7b2-83ad-a2c7-a90153129da2@redhat.com>
 <Yqs7qjjbqxpw62B/@hirez.programming.kicks-ass.net>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Yqs7qjjbqxpw62B/@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/16/2022 10:18 PM, Peter Zijlstra wrote:
> On Thu, Jun 16, 2022 at 12:21:20PM +0200, Paolo Bonzini wrote:
>> On 6/16/22 12:12, Peter Zijlstra wrote:
>>> Do I understand this right in that a host without X86_KERNEL_IBT cannot
>>> run a guest with X86_KERNEL_IBT on? That seems unfortunate, since that
>>> was exactly what I did while developing the X86_KERNEL_IBT patches.
>>>
>>> I'm thinking that if the hardware supports it, KVM should expose it,
>>> irrespective of the host kernel using it.
>> For IBT in particular, I think all processor state is only loaded and stored
>> at vmentry/vmexit (does not need XSAVES), so it should be feasible.
> That would be the S_CET stuff, yeah, that's VMCS managed. The U_CET
> stuff is all XSAVE though.

Thank you Peter and Paolo!

In this version, I referenced host kernel settings when expose 
X86_KERNEL_IBT to guest.

The reason would be _IF_ host, for whatever reason, disabled the IBT 
feature, exposing the

feature blindly to guest could be risking, e.g., hitting some issues 
host wants to mitigate.

The actual implementation depends on the agreement we got :-)

>
> But funny thing, CPUID doesn't enumerate {U,S}_CET separately. It *does*
> enumerate IBT and SS separately, but for each IBT/SS you have to
> implement both U and S.

Exactly, the CPUID enumeration could be a pain point for the KVM solution.

It makes {U,S}_CET feature control harder for guest.

>
> That was a problem with the first series, which only implemented support
> for U_CET while advertising IBT and SS (very much including S_CET), and
> still is a problem with this series because S_SS is missing while
> advertised.

KVM has problem advertising S_SS alone to guest when  U_CET(both SS and 
IBT) are

not available to guest. I would like to hear the voice from community on 
how to

make the features control straightforward and reasonable. Existing CPUID 
enumeration

cannot advertise {U, S}_SS and {U,S}_IBT well.

>
