Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962AC5BCF4C
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 16:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiISOld (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 10:41:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiISOlX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 10:41:23 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333B9640B;
        Mon, 19 Sep 2022 07:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663598482; x=1695134482;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=sbHYuq6WW6aQl2DNNDbVBEwxRDg0IBx6WAGNTQaIOfU=;
  b=IduUXQFG1500tT4q9pbCmL/pnBxyN7hLRpGzz+m3HP/J5eVo6gAqus3a
   +UfM5VtjHFFR4WYD60IkxBM+Iz3KD9UwAtP2Q2HHu3mNVbRDNsXjlP5yA
   Lp+OmfvpXYHWW07Q+YnVHFY1/bexXdTyVe+cTtKqt8n4poz/GvmkR4Aeo
   aWztI32m9GuiDPYpt3BdgZV/NrgsIN6e/mFj5YnDr/EOAW8Ko3Qk19tPs
   iALZrR/sZb3w5tioshr+C5bmkyCaYkVhzGcSTazX4ucM3WVPeMZmieXtN
   KqZl+fmAfeSsjnTEfIzFYMhKBYfNEmriEIGVDyoLpACSGv9TtGE2bgjuU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="298144579"
X-IronPort-AV: E=Sophos;i="5.93,328,1654585200"; 
   d="scan'208";a="298144579"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 07:41:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,328,1654585200"; 
   d="scan'208";a="760891761"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga001.fm.intel.com with ESMTP; 19 Sep 2022 07:41:21 -0700
Received: from [10.252.210.144] (kliang2-mobl1.ccr.corp.intel.com [10.252.210.144])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id A5E74580B9B;
        Mon, 19 Sep 2022 07:41:19 -0700 (PDT)
Message-ID: <b3d3fd4c-b191-c4e4-ac95-c46f944c65d6@linux.intel.com>
Date:   Mon, 19 Sep 2022 10:41:18 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
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
Content-Language: en-US
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Subject: Re: [RFC PATCH 0/2] KVM: VMX: Fix VM entry failure on
 PT_MODE_HOST_GUEST while host is using PT
In-Reply-To: <DS0PR11MB63739F4DA17F30B3162837B9DC4D9@DS0PR11MB6373.namprd11.prod.outlook.com>
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



On 2022-09-19 9:46 a.m., Wang, Wei W wrote:
> On Friday, September 16, 2022 9:27 PM, Liang, Kan wrote:
>>> Did you mean to handle the PT event in the proposed driver API? Event
>>> status is just one of the things. There are other things if we want to
>>> make it complete for this, e.g. event->oncpu = -1, and eventually seems we will
>> re-implement perf_event_disable_*.
>>>
>>
>> As my understand, perf always check the status first. If it's a stopped or
>> inactivated event, I don't think event->oncpu will be touched. That's why I think
>> the proposed driver API should be acceptable.
> 
> That's the implementation thing. We need to make it architecturally clean though.
> 
>>
>>> Btw, Xiaoyao has made it work with perf_event_disable_local, and don’t have
>> that many changes.
>>> If necessary, we can post the 2nd version out to double check.
>>>
>>
>> I'm not worry about which ways (either perf_event_disable_local() or the
>> proposed PT driver API) are chosen to stop the PT. If the existing perf_event
>> interfaces can meet your requirement, that's perfect.
>>
>> My real concern is the pt_save_msr()/pt_load_msr(). I don't think it's a job for
>> KVM. See atomic_switch_perf_msrs(). It is the perf core driver rather than KVM
>> that tells which MSRs should be saved/restored in VMCS.
>> We should do the same thing for PT. (Actually, I think we already encounter
>> issues with the current KVM-dominated method. KVM saves/restores
>> unnecessary MSRs. Right?)
>>
> 
> Right. It's on my plan to improve the current PT virtualization, and
> planed to be the next step after this fix. The general rule is the same: make KVM a user
> of perf, that is, we leave those save/restore work to be completely done by the
> perf (driver) side, so we will eventually remove the KVM side pt_save/load_msr.
> To be more precise, it will work as below:
> - we will create a guest event, like what we did for lbr virtualization

Another fake event? We have to specially handle it in the perf code. I
don't think it's a clean way for perf.

> - on VMEnter:
>   -- perf_disable_event_local(host_event);
>   -- perf_enable_event_local(guest_event);
> - on VMExit:
>   -- perf_disable_event_local(guest_event);
>   -- perf_enable_event_local(host_event);

Why we cannot use the same way as the perf core driver to switch the
MSRs in the VMCS?

You just need one generic function, perf_guest_get_msrs(), for both PT
and core driver. If you have to disable PT explicitly before VMCS, I
think you can do it in the PT specific perf_guest_get_msrs().

Anyway, that's an improvement for the current code. I don't have a
problem, if you prefer to separate the fix patch and improvement patch.

Thanks,
Kan
> 
>> To do so, I think there may be two ways.
>> - Since MSRs have to be switched for both PT and core drivers, it sounds
>> reasonable to provide a new generic interface in the perf_event. The new
>> interface is to tell KVM which MSRs should be saved/restored. Then KVM can
>> decide to save/restore via VMCS or direct MSR access. I suspect this way
>> requires big change, but it will benefit all the drivers which have similar
>> requirements.
>> - The proposed driver API. The MSRs are saved/restored in the PT driver.
> 
> As shown above, no need for those. We can completely reuse the
> perf side save/restore.
> 
> Thanks,
> Wei
