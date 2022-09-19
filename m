Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3041E5BD17B
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 17:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiISPzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 11:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiISPzV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 11:55:21 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905B5E0F6;
        Mon, 19 Sep 2022 08:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663602919; x=1695138919;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=/RZXgUps2cAXRsr5swlx+LTN2mlpIuZ511tKlfnJhwY=;
  b=NoTAIBv+JqnfSaNRAUaIw/xl3n0lMdoGU5AZApiGfUenb6dWaJIgdkFb
   7WWa3CTGClogFeZRVMIHw5BDrh/n3u2xFoQDLUxRegs972cJG89WMUWcA
   5IdJezvtYfAhlIUWqmE41CVZlFhfhw2lBkVfoSMVC7djEhapthPiAwWdb
   fsk/E5mrIkBiwkcJ74NaKJP4MqI8dQRfp58b/5uwruyRk18YI/1UWtiTu
   X5iCFJadOGkrQ60R8EkJdzP32tPX3XOyWMtpeW0JaELK/dPplXEu1yVtY
   BSpGaa7GnK9MFsBrBJM2wC8fuv0+xZYF3+04ywZ6ezneUvacx35DNuGS3
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="385725817"
X-IronPort-AV: E=Sophos;i="5.93,328,1654585200"; 
   d="scan'208";a="385725817"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 08:55:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,328,1654585200"; 
   d="scan'208";a="651727338"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga001.jf.intel.com with ESMTP; 19 Sep 2022 08:55:18 -0700
Received: from [10.252.210.144] (kliang2-mobl1.ccr.corp.intel.com [10.252.210.144])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 430BB580A31;
        Mon, 19 Sep 2022 08:55:17 -0700 (PDT)
Message-ID: <0a5fdd6d-2207-d44f-2854-ec5882d557e7@linux.intel.com>
Date:   Mon, 19 Sep 2022 11:55:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Liang, Kan" <kan.liang@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
Cc:     "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <CY5PR11MB6365897E8E6D0B590A298FA0DC769@CY5PR11MB6365.namprd11.prod.outlook.com>
 <815586ac-1eaa-5e38-1e08-492c29d0729d@intel.com>
 <CY5PR11MB63659EBEAEA0E64812E96111DC469@CY5PR11MB6365.namprd11.prod.outlook.com>
 <f7cfb391-c38b-84d2-b2fe-5e289d82862c@linux.intel.com>
 <CY5PR11MB6365676799EBF86B3931D336DC499@CY5PR11MB6365.namprd11.prod.outlook.com>
 <ef391316-cde5-3cda-ff0d-980e8ecc9aef@linux.intel.com>
 <CY5PR11MB636535BE57F8CC07B1B2770DDC499@CY5PR11MB6365.namprd11.prod.outlook.com>
 <4c6a5663-778e-a509-638c-92cfd5315274@linux.intel.com>
 <CY5PR11MB6365EE3B1C4BCED02A1E40D8DC489@CY5PR11MB6365.namprd11.prod.outlook.com>
 <da8fe1d8-8cce-7378-18e8-41fd7009ff8d@linux.intel.com>
 <DS0PR11MB63739F4DA17F30B3162837B9DC4D9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <b3d3fd4c-b191-c4e4-ac95-c46f944c65d6@linux.intel.com>
 <DS0PR11MB6373ACD91938CE70EBADA831DC4D9@DS0PR11MB6373.namprd11.prod.outlook.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Subject: Re: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
In-Reply-To: <DS0PR11MB6373ACD91938CE70EBADA831DC4D9@DS0PR11MB6373.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-09-19 11:22 a.m., Wang, Wei W wrote:
> On Monday, September 19, 2022 10:41 PM, Liang, Kan wrote:
>> Another fake event? We have to specially handle it in the perf code. I don't
>> think it's a clean way for perf.
> 
> We can check the patch later. I think it should be clean, like the LBR side.

I doubt. Perf already specially handles the fake LBR event in several
places from the core code to the LBR code. It also occupy a reserved
bit. If there is another choice, I don't think we want to go that way.

> 
>>
>>> - on VMEnter:
>>>   -- perf_disable_event_local(host_event);
>>>   -- perf_enable_event_local(guest_event);
>>> - on VMExit:
>>>   -- perf_disable_event_local(guest_event);
>>>   -- perf_enable_event_local(host_event);
>>
>> Why we cannot use the same way as the perf core driver to switch the MSRs in
>> the VMCS?
> 
> The current MSR switching list from VMCS isn’t fast,
> should be the last resort when really necessary.
> 

It's a documented way in the SDM. I believe there must be some reason
Intel introduces it. Since it's an documented (or recommended) way, I
think we'd better use it if possible.

Since both the PT and the core driver needs to switch MSRs during VMCS,
it's better to use the same way (function) to handle them.

Thanks,
Kan

>>
>> You just need one generic function, perf_guest_get_msrs(), for both PT and
>> core driver. If you have to disable PT explicitly before VMCS, I think you can do
>> it in the PT specific perf_guest_get_msrs().
> 
> The disable is done via " Clear IA32_RTIT_CTL" VMExit control.
> It can ensure PT disabled in time on VMExit, so no need to go through perf_guest_get_msrs.
> 




