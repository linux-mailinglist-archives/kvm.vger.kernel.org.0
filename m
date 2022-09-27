Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881BE5ECA2D
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 18:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbiI0Qyo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 12:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiI0QyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 12:54:21 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7153F1B86BD;
        Tue, 27 Sep 2022 09:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664297577; x=1695833577;
  h=message-id:date:mime-version:to:cc:references:from:
   subject:in-reply-to:content-transfer-encoding;
  bh=5EohTMYLQrkXaT2jLZUdyETCAEaqtVx4zyPwhafHKa0=;
  b=a5mJxHmR3wr6zzQiTcRVdKWaQYwc1zofj8QrK2TgnQrbrpQZ6AysN+Rm
   CaqVIme/3FFE7S1wkFDNWfUjLe/YbwJXk1ZyyUjd8MwlC0iAvecyY63/Z
   yoXEHCaMIrVn41/wD58laQSuUQVdXceZYUDFKi6JPM2h4cIqJTHsrv93M
   Q1Q9c3Bo98ORZOi4VJgZHwe78bJhikAFJwOJG6j2sy7e8JALytsFlT7E/
   vTJspsR37zLAo65FQz1es0bf2cjEAazyMwiOImCwCDMNqFBtRZZvTpgeW
   xAL16DZB735i2UFJ5hK4d89CuqvOxaF7DIL19dRjJwj4i8C7ECN9jV64i
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="302278841"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="302278841"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 09:52:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="572713090"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="572713090"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga003.jf.intel.com with ESMTP; 27 Sep 2022 09:52:40 -0700
Received: from [10.252.215.51] (kliang2-mobl1.ccr.corp.intel.com [10.252.215.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id AE3615808F0;
        Tue, 27 Sep 2022 09:52:38 -0700 (PDT)
Message-ID: <83db7a22-3cf8-9f5c-5530-894c663ee1fb@linux.intel.com>
Date:   Tue, 27 Sep 2022 12:52:37 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     "Wang, Wei W" <wei.w.wang@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
 <e1327377-8e82-56a2-25e5-2ba91f2eec42@linux.intel.com>
 <DS0PR11MB63730CE4DAE000E338F092A0DC559@DS0PR11MB6373.namprd11.prod.outlook.com>
From:   "Liang, Kan" <kan.liang@linux.intel.com>
Subject: Re: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export
 pt_get_curr_event()
In-Reply-To: <DS0PR11MB63730CE4DAE000E338F092A0DC559@DS0PR11MB6373.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022-09-27 10:27 a.m., Wang, Wei W wrote:
> On Tuesday, September 27, 2022 2:09 AM, Liang, Kan wrote:
>> From my understanding of the host-guest mode, the host PT event never
>> traces the guest no matter whether the guest enables PT. So when VM-entry,
>> there is only a guest PT event or no event. If so, I think the perf tool should
>> warn the user if they try to create a host event with !exclude_guest, since the
>> host event never traces a guest.
> 
> Probably not from the perf side. It's actually an issue of the KVM's pt_mode:
> How can KVM prevent host from profiling the guest when in host-guest mode?

I don't think it's KVM's job to prevent host from profiling the guest.
However, the current KVM implementation implicitly disables the guest
profiling from the host. If I understand correct, this patch series just
change it to an explicit way (Just for kernel. Perf tool still doesn't
know about it.). There is no substantial change.

I think it should be PT driver who decide which event should be
scheduled. So the first step is to let the PT driver understand the
host-guest mode. Then if a perf user in the host tries to profile with
!exclude_guest with the host-guest mode, the pt driver can deny the
request. The perf tool than throw a warning, e.g., "The VMM is running
with host-guest mode. Perf cannot profile guest. Please remove the guest
profiling setting or switch to the host-only mode.".

> Just a warning from the perf side wouldn't be enough. I think that's a wrong
> assumption from KVM side. I had a plan to fix this one. Exposing the host event
> can tell KVM if the host is profiling the guest or not (i.e. host-guest is allowed).

I don't think KVM should know such information.

Thanks,
Kan
