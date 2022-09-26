Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E82CE5EACDC
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 18:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiIZQpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 12:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbiIZQom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 12:44:42 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2814B8F942;
        Mon, 26 Sep 2022 08:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664206384; x=1695742384;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=s2ixcDGsgVH2oP8fgOU+5xAp1ma1xlCPXEg7wczWzJY=;
  b=KaD+eXxTOGh6P/tCJrxfv4yMGrLcJttzmNQAVklupCeDzsU0Bo93/n62
   bJz7ZJ92Adou0LOJtcwBloSNrcM7g5+0GSznzBQJzammzNBKjUrBD+g21
   IslO/+F73YmY6tc0c7bbWoXHUFBp7iUWCLBdoW5Ve76amZgiJ5JpXdmR0
   MYzw8zdWeikD/OJjMz+ro5L10bukxPHy4OSOsZdfQpoMLWhkwk88knADh
   vDs5EHJj8MiX1eUo4CIHtTs+yM9vQOteXxjzrKvUde10g7Ez559GPCxs4
   DmJkC7k/rnKc7IH1mwa9T5vygMJ/kdsQ9Trhd2W1dsp1EZobdXW1NbVZS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="284177128"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="284177128"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 08:33:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="796374711"
X-IronPort-AV: E=Sophos;i="5.93,346,1654585200"; 
   d="scan'208";a="796374711"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga005.jf.intel.com with ESMTP; 26 Sep 2022 08:33:02 -0700
Received: from [10.252.214.241] (kliang2-mobl1.ccr.corp.intel.com [10.252.214.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 1AAB1580BE1;
        Mon, 26 Sep 2022 08:33:01 -0700 (PDT)
Message-ID: <4320bb19-b206-97b6-4eae-093c9d815ba0@linux.intel.com>
Date:   Mon, 26 Sep 2022 11:32:59 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
 <20220921164521.2858932-3-xiaoyao.li@intel.com>
 <175b518c-d202-644e-a3a7-67e877852548@linux.intel.com>
 <DS0PR11MB6373C84139621DC447D3F466DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Subject: Re: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
In-Reply-To: <DS0PR11MB6373C84139621DC447D3F466DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-09-22 8:58 a.m., Wang, Wei W wrote:
> On Thursday, September 22, 2022 8:34 PM, Liang, Kan wrote:
>>> To solve the problem, introduce and export pt_get_curr_event() for KVM
>>> to get current pt event.
>>
>> I don't think the current pt event is created by KVM. IIUC, the patch basically
>> expose the event created by the other user to KVM. That doesn't sounds
>> correct.
> 
> Yes, that's the host PT event running on the current CPU. Not created by KVM.
> 
>>
>> I think it should be perf's responsibility to decide which events should be
>> disabled, and which MSRs should be switched. Because only perf can see all the
>> events. The users should only see the events they created.
> 
> For other pmu cases, yes. For PT, its management is simpler than other pmu
> resources and PT PMU is much simpler. It doesn't have a scheduler to manage
> events.
>

Right, but I think we'd better to create a simpler scheduler (just for
two events) in the PT driver, since you have two co-existing PT events
now, one is from the host and the other is from the guest. I don't think
it's KVM's responsibility to schedule events.

So I think the process should be something as below.

- Let KVM create a PT event if the guest request one.
- In VM-entry, just invoke the perf_event_enable_local(guest).
  The PT driver should schedule out the host event or whatever events
and schedule in the guest event.
- In VM-exit, just invoke the perf_event_disable_local(guest).
  The PT driver should schedule in the host event or whatever events and
schedule out the guest event.

I still don't think we want to expose the host event.

Thanks,
Kan

> I think the usage here is similar to the CPU thread scheduling case. When we have
> CPUs isolated from the CPU scheduler, i.e. no scheduler for those CPUs, basically
> we rely on users to ping tasks to those CPUs (e.g. taskset).
> 
> For the commit log, probably we don't need those KVM details here. Simplify a bit:
> 
> Add a function to expose the current running PT event to users. One usage is in KVM,
> it needs to get and disable the running host PT event before VMEnter to the guest and
> resumes the event after VMexit to host.
