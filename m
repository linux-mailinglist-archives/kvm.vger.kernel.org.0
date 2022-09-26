Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206C55EAF76
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 20:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiIZSS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 14:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbiIZSRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 14:17:55 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10ED659242;
        Mon, 26 Sep 2022 11:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664215736; x=1695751736;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=yiMXo2D5XdjxbB4TqdC1gdLFerYQ27vfPhJye39v01A=;
  b=cFoBOXpote8tcS/dXOX6EEjXmZYlD2Qh28QLkwfGKiDnvojag7kZxkDs
   OyP4Lgxtv1BFyZxMFanMVhxPOj1gTIPD/+8eszSUA0FsmKBHgAvU3sqoz
   CdpOJiPrwYblXeMDECH6gPmKtFUIfTlX+HAmk/eL+9/i0C6XW0/iGj3oN
   e030Nb0+SG5+nMs4HrdUgb0P44d/XcamYcUVaBCGiMrBiDQ3HYDEnKEOO
   EQGUUTkUIWiy6tSXC96Qa/wkGgDHZYCAmEXYSLxVV0YUxCRDebVukgZYy
   u+TWEKSSXaA+NtMw4Ad3KJhq+PYwygDYz385qZ9IAMWEttfVFEuFPkAjV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="302575658"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="302575658"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 11:08:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="689658578"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="689658578"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga004.fm.intel.com with ESMTP; 26 Sep 2022 11:08:54 -0700
Received: from [10.252.214.241] (kliang2-mobl1.ccr.corp.intel.com [10.252.214.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 982B0580BE1;
        Mon, 26 Sep 2022 11:08:52 -0700 (PDT)
Message-ID: <e1327377-8e82-56a2-25e5-2ba91f2eec42@linux.intel.com>
Date:   Mon, 26 Sep 2022 14:08:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     "Wang, Wei W" <wei.w.wang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
 <20220921164521.2858932-3-xiaoyao.li@intel.com>
 <175b518c-d202-644e-a3a7-67e877852548@linux.intel.com>
 <DS0PR11MB6373C84139621DC447D3F466DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Yyxke/IO+AP4EWwT@hirez.programming.kicks-ass.net>
 <DS0PR11MB637346E9F224C5330CDEF3BFDC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <YyxsnAFYMLn2U9BT@hirez.programming.kicks-ass.net>
 <DS0PR11MB63730A85E00683AB7F6F3E26DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <62d4bec1-a0c3-3b01-61bb-f284eede6378@linux.intel.com>
 <CALMp9eTG7EbRv_fnQpDMQ3YUjYANgu=6QwVj_ACgHnK-Mhk39Q@mail.gmail.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Subject: Re: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
In-Reply-To: <CALMp9eTG7EbRv_fnQpDMQ3YUjYANgu=6QwVj_ACgHnK-Mhk39Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-09-26 1:24 p.m., Jim Mattson wrote:
> On Mon, Sep 26, 2022 at 9:55 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>>
>>
>>
>> On 2022-09-22 10:42 a.m., Wang, Wei W wrote:
>>> On Thursday, September 22, 2022 10:10 PM, Peter Zijlstra wrote:
>>>> On Thu, Sep 22, 2022 at 01:59:53PM +0000, Wang, Wei W wrote:
>>>>> On Thursday, September 22, 2022 9:35 PM, Peter Zijlstra
>>>>>> On Thu, Sep 22, 2022 at 12:58:49PM +0000, Wang, Wei W wrote:
>>>>>>
>>>>>>> Add a function to expose the current running PT event to users.
>>>>>>> One usage is in KVM, it needs to get and disable the running host
>>>>>>> PT event before VMEnter to the guest and resumes the event after
>>>> VMexit to host.
>>>>>>
>>>>>> You cannot just kill a host event like that. If there is a host
>>>>>> event, the guest looses out.
>>>>>
>>>>> OK. The intention was to pause the event (that only profiles host
>>>>> info) when switching to guest, and resume when switching back to host.
>>>>
>>>> If the even doesn't profile guest context, then yes. If it does profile guest
>>>> context, you can't.
>>>
>>> Seems better to add this one:
>>
>> If the guest host mode is enabled, I think the PT driver should not
>> allow the perf tool to create a host event with !exclude_guest.
> 
> While I agree that guest events should generally have priority over
> host events, this is not consistent with the way "normal" PMU events
> are handled.
Only when the two events try to access a resource at the same time, we
have to decide whether priority an event or share between events. But I
don't think this is the case here.

From my understanding of the host-guest mode, the host PT event never
traces the guest no matter whether the guest enables PT. So when
VM-entry, there is only a guest PT event or no event. If so, I think the
perf tool should warn the user if they try to create a host event with
!exclude_guest, since the host event never traces a guest.


Thanks,
Kan
