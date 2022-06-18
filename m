Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17A0655033E
	for <lists+kvm@lfdr.de>; Sat, 18 Jun 2022 08:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiFRGnl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jun 2022 02:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbiFRGnh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 18 Jun 2022 02:43:37 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967684D27A;
        Fri, 17 Jun 2022 23:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655534616; x=1687070616;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=b/bPgMuOM2JzIea1LRQ2sWuY2ZRTgAdYbEiCqQ70a/M=;
  b=cUGx42lZX3fcq+f2xIC2lUpxB4SPwMghCsHRe0Ok+6Knzsg8Om8vjlRA
   eEGPY2mVacZjZ2VETNhTMyhvZkTxGjv8vaJF486QKAMKklJoDlS2duieD
   XcnGE0Cl5FXbhVSQtEho8spRDlC9I0r6HgitEVRbOvs+420q8AmdGugue
   6TBELf+Vd5gVLVeG7b3B+6N0XqTW9zjGRF8UidwEA65RIYh8X5ZIRCDXt
   5QoathSyThFUOVnThBjoeRVknSYuGKsSh+6oIzu5siGVdZ27TpRjRTl2N
   O7moJvwEdojMaR+6r3HPrsP1mplfy2o2pQr2vSyu6F7SQWRSNYS0Zqd3Q
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="278408197"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="278408197"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 23:43:36 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="642320694"
Received: from yangweij-mobl.ccr.corp.intel.com (HELO [10.255.29.153]) ([10.255.29.153])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2022 23:43:33 -0700
Message-ID: <2855f8a9-1f77-0265-f02c-b7d584bd8990@intel.com>
Date:   Sat, 18 Jun 2022 14:43:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 00/19] Refresh queued CET virtualization series
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     seanjc@google.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <YqsB9upUystxvl+d@hirez.programming.kicks-ass.net>
 <62d4f7f0-e7b2-83ad-a2c7-a90153129da2@redhat.com>
 <Yqs7qjjbqxpw62B/@hirez.programming.kicks-ass.net>
 <8a38488d-fb6e-72f9-3529-b098a97d8c97@redhat.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <8a38488d-fb6e-72f9-3529-b098a97d8c97@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/16/2022 11:28 PM, Paolo Bonzini wrote:
> On 6/16/22 16:18, Peter Zijlstra wrote:
>> On Thu, Jun 16, 2022 at 12:21:20PM +0200, Paolo Bonzini wrote:
>>> On 6/16/22 12:12, Peter Zijlstra wrote:
>>>> Do I understand this right in that a host without X86_KERNEL_IBT 
>>>> cannot
>>>> run a guest with X86_KERNEL_IBT on? That seems unfortunate, since that
>>>> was exactly what I did while developing the X86_KERNEL_IBT patches.
>>>>
>>>> I'm thinking that if the hardware supports it, KVM should expose it,
>>>> irrespective of the host kernel using it.
>>>
>>> For IBT in particular, I think all processor state is only loaded 
>>> and stored
>>> at vmentry/vmexit (does not need XSAVES), so it should be feasible.
>>
>> That would be the S_CET stuff, yeah, that's VMCS managed. The U_CET
>> stuff is all XSAVE though.
>
> What matters is whether XFEATURE_MASK_USER_SUPPORTED includes 
> XFEATURE_CET_USER. 

Small correction, XFEATURE_CET_USER belongs to 
XFEATURE_MASK_SUPERVISOR_SUPPORTED, the name is misleading.


> If you build with !X86_KERNEL_IBT, KVM can still rely on the FPU state 
> for U_CET state, and S_CET is saved/restored via the VMCS independent 
> of X86_KERNEL_IBT.

A fundamental question is, should KVM always honor host CET enablement 
before expose the feature to guest? i.e., check X86_KERNEL_IBT and 
X86_SHADOW_STACK.


>
> Paolo
>
>> But funny thing, CPUID doesn't enumerate {U,S}_CET separately. It *does*
>> enumerate IBT and SS separately, but for each IBT/SS you have to
>> implement both U and S.
>>
>> That was a problem with the first series, which only implemented support
>> for U_CET while advertising IBT and SS (very much including S_CET), and
>> still is a problem with this series because S_SS is missing while
>> advertised.
>
