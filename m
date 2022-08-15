Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7561592F5E
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 15:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbiHONGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 09:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiHONGE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 09:06:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DCF19031;
        Mon, 15 Aug 2022 06:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660568764; x=1692104764;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=m2EuSMgDC5x1/7VKkKGbdxtg9/vb5ykdj4i/kmeCnAY=;
  b=GjJ52App2hztcqVIHsAaVntmsVe8zeDm+i9B6AUYlulhDgoQbbmflKfc
   s932u9uW90MbYQxUB030L9XLGivEb9bPLeeO9uyDTdYgiPxf+g15LQCk2
   Fqtg9uZfcFpRjPusRhegdNWajGDoFq1hGeLwCLvSBOD/Hvx3u1kJRS6hi
   kqYjAmKMhBbCgSAVlZeFm9eihVdQCzMMLN4ThTH7pT4bVk6eFcMnTXwNL
   QGPv4wKhNHN3KqZ40sqtcPkQ2MqfaqFkKpxYXZJqEcm654P13UtRSjzL+
   OqQa31B7Z7jzZ21A4iFLQxN1454qIVLKTDlQsUDMTpsA2KNsMG0zL9+Ac
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="317936435"
X-IronPort-AV: E=Sophos;i="5.93,238,1654585200"; 
   d="scan'208";a="317936435"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 06:06:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,238,1654585200"; 
   d="scan'208";a="674825396"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 15 Aug 2022 06:06:03 -0700
Received: from [10.252.214.254] (kliang2-mobl1.ccr.corp.intel.com [10.252.214.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 64857580C50;
        Mon, 15 Aug 2022 06:06:02 -0700 (PDT)
Message-ID: <952632db-b090-ceb9-1467-a6b598ca2b02@linux.intel.com>
Date:   Mon, 15 Aug 2022 09:06:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v2 1/7] perf/x86/core: Update x86_pmu.pebs_capable for
 ICELAKE_{X,D}
To:     Peter Zijlstra <peterz@infradead.org>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220721103549.49543-1-likexu@tencent.com>
 <20220721103549.49543-2-likexu@tencent.com>
 <959fedce-aada-50e4-ce8d-a842d18439fa@redhat.com>
 <YvoSXyy7ojZ9ird/@worktop.programming.kicks-ass.net>
 <94e6c414-38e1-ebd7-0161-34548f0b5aae@gmail.com>
 <YvozNSvcxet0gX6b@worktop.programming.kicks-ass.net>
Content-Language: en-US
From:   "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <YvozNSvcxet0gX6b@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-08-15 7:51 a.m., Peter Zijlstra wrote:
> On Mon, Aug 15, 2022 at 05:43:34PM +0800, Like Xu wrote:
> 
>>> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
>>> index 2db93498ff71..b42c1beb9924 100644
>>> --- a/arch/x86/events/intel/core.c
>>> +++ b/arch/x86/events/intel/core.c
>>> @@ -5933,7 +5933,6 @@ __init int intel_pmu_init(void)
>>>   		x86_pmu.pebs_aliases = NULL;
>>>   		x86_pmu.pebs_prec_dist = true;
>>>   		x86_pmu.lbr_pt_coexist = true;
>>> -		x86_pmu.pebs_capable = ~0ULL;
>>>   		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
>>>   		x86_pmu.flags |= PMU_FL_PEBS_ALL;
>>>   		x86_pmu.get_event_constraints = glp_get_event_constraints;
>>> @@ -6291,7 +6290,6 @@ __init int intel_pmu_init(void)
>>>   		x86_pmu.pebs_aliases = NULL;
>>>   		x86_pmu.pebs_prec_dist = true;
>>>   		x86_pmu.pebs_block = true;
>>> -		x86_pmu.pebs_capable = ~0ULL;
>>>   		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
>>>   		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
>>>   		x86_pmu.flags |= PMU_FL_PEBS_ALL;
>>> @@ -6337,7 +6335,6 @@ __init int intel_pmu_init(void)
>>>   		x86_pmu.pebs_aliases = NULL;
>>>   		x86_pmu.pebs_prec_dist = true;
>>>   		x86_pmu.pebs_block = true;
>>> -		x86_pmu.pebs_capable = ~0ULL;
>>>   		x86_pmu.flags |= PMU_FL_HAS_RSP_1;
>>>   		x86_pmu.flags |= PMU_FL_NO_HT_SHARING;
>>>   		x86_pmu.flags |= PMU_FL_PEBS_ALL;
>>> diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
>>> index ba60427caa6d..e2da643632b9 100644
>>> --- a/arch/x86/events/intel/ds.c
>>> +++ b/arch/x86/events/intel/ds.c
>>> @@ -2258,6 +2258,7 @@ void __init intel_ds_init(void)
>>>   			x86_pmu.drain_pebs = intel_pmu_drain_pebs_icl;
>>>   			x86_pmu.pebs_record_size = sizeof(struct pebs_basic);
>>>   			if (x86_pmu.intel_cap.pebs_baseline) {
>>> +				x86_pmu.pebs_capable = ~0ULL;
>>
>> The two features of "Extended PEBS (about pebs_capable)" and "Adaptive PEBS
>> (about pebs_baseline)"
>> are orthogonal, although the two are often supported together.
> 
> The SDM explicitly states that PEBS Baseline implies Extended PEBS. See
> 3-19.8 (April 22 edition).
> 
> The question is if there is hardware that has Extended PEBS but doesn't
> have Baseline; and I simply don't know and was hoping Kan could find
> out.

Goldmont Plus should be the only platform which supports extended PEBS
but doesn't have Baseline.

> 
> That said; the above patch can be further improved by also removing the
> PMU_FL_PEBS_ALL lines, which is already set by intel_ds_init().

I think we have to keep PMU_FL_PEBS_ALL for the Goldmont Plus. But we
can remove it for SPR and ADL in intel_pmu_init(), since it's already
set in the intel_ds_init() for the Baseline.

Thanks,
Kan
> 
> In general though; the point is, we shouldn't be doing the FMS table
> thing for discoverable features. Having pebs_capable = ~0 and
> PMU_FL_PEBS_ALL on something with BASELINE set is just wrong.
