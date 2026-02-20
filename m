Return-Path: <kvm+bounces-71402-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6OILM3symGleCgMAu9opvQ
	(envelope-from <kvm+bounces-71402-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 11:07:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 85EBC166A78
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 11:07:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E4B51302960F
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 10:07:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B7BA337BBC;
	Fri, 20 Feb 2026 10:07:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D98931B10B;
	Fri, 20 Feb 2026 10:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771582062; cv=none; b=O5yjSA6o9yDknHemnWo6a83qSrv5OE3twIqnO7cQ5Qw0kfTx2xZ4fAS4a/RS5zlBB0f4aF9otmU0tVxMOgDcUZptAU33oyfDO0/dmEpTDACJN95pt1qHCJYjWkzCY/dtS0VqMMOM7qpCbng6SHmSFnu5gWW7JSQbQ6VveVR+65Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771582062; c=relaxed/simple;
	bh=dqcTIDASLwjYCRqOiN1LbO1jTNkrivLooM/JqzFVLQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rYwCHlOFg4X1yDrPa7XXZfMQCAmmyM/enMcbt3X8RmFt6PfCc9rddwfHQoHSH0OROAR9efbRQA1nKqPpydltiwzHplgMFahXB9bts8Hy8SfZdDTSODm++YOyTkd5gQjbK65RBIxLGzHZ6jUQHL3pJUnA/dqaCkrnAEE6Vg3NRxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BF51339;
	Fri, 20 Feb 2026 02:07:32 -0800 (PST)
Received: from [10.1.196.46] (e134344.arm.com [10.1.196.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7BFBC3F62B;
	Fri, 20 Feb 2026 02:07:31 -0800 (PST)
Message-ID: <5857f3a0-999a-46ed-a36f-d2b02d04274a@arm.com>
Date: Fri, 20 Feb 2026 10:07:29 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: Reinette Chatre <reinette.chatre@intel.com>,
 Babu Moger <babu.moger@amd.com>, "Moger, Babu" <bmoger@amd.com>,
 corbet@lwn.net, tony.luck@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, akpm@linux-foundation.org,
 pawan.kumar.gupta@linux.intel.com, pmladek@suse.com,
 feng.tang@linux.alibaba.com, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, lirongqing@baidu.com, bhelgaas@google.com,
 seanjc@google.com, xin@zytor.com, manali.shukla@amd.com,
 dapeng1.mi@linux.intel.com, chang.seok.bae@intel.com,
 mario.limonciello@amd.com, naveen@kernel.org, elena.reshetova@intel.com,
 thomas.lendacky@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peternewman@google.com,
 eranian@google.com, gautham.shenoy@amd.com
References: <cover.1769029977.git.babu.moger@amd.com>
 <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029977.git.babu.moger@amd.com>
 <eb4b7b12-7674-4a1e-925d-2cec8c3f43d2@intel.com>
 <f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com>
 <9b02dfc6-b97c-4695-b765-8cb34a617efb@intel.com>
 <3a7c17c0-bb51-4aad-a705-d8d1853ea68a@amd.com>
 <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
From: Ben Horgan <ben.horgan@arm.com>
Content-Language: en-US
In-Reply-To: <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[arm.com : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71402-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[45];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ben.horgan@arm.com,kvm@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.967];
	MID_RHS_MATCH_FROM(0.00)[];
	R_DKIM_NA(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 85EBC166A78
X-Rspamd-Action: no action

Hi Reinette, Babu,

On 2/12/26 03:51, Reinette Chatre wrote:
> Hi Babu,
> 
> On 2/11/26 1:18 PM, Babu Moger wrote:
>> On 2/11/26 10:54, Reinette Chatre wrote:
>>> On 2/10/26 5:07 PM, Moger, Babu wrote:
>>>> On 2/9/2026 12:44 PM, Reinette Chatre wrote:
>>>>> On 1/21/26 1:12 PM, Babu Moger wrote:
>>>>>> On AMD systems, the existing MBA feature allows the user to set a bandwidth
>>>>>> limit for each QOS domain. However, multiple QOS domains share system
>>>>>> memory bandwidth as a resource. In order to ensure that system memory
>>>>>> bandwidth is not over-utilized, user must statically partition the
>>>>>> available system bandwidth between the active QOS domains. This typically
>>>>> How do you define "active" QoS Domain?
>>>> Some domains may not have any CPUs associated with that CLOSID. Active meant, I'm referring to domains that have CPUs assigned to the CLOSID.
>>> To confirm, is this then specific to assigning CPUs to resource groups via
>>> the cpus/cpus_list files? This refers to how a user needs to partition
>>> available bandwidth so I am still trying to understand the message here since
>>> users still need to do this even when CPUs are not assigned to resource
>>> groups.
>>>
>> It is not specific to CPU assignment. It applies to task assignment also.
>>  
>> For example:  We have 4 domains;
>>
>> # cat schemata
>>   MB:0=8192;1=8192;2=8192;3=8192
>>
>> If this group has the CPUs assigned to only first two domains. Then the group has only two active domains. Then we will only update the first two domains. The MB values in other domains does not matter.
> 
> I see, thank you. As I understand an "active QoS domain" is something only user
> space can designate. It may be possible for resctrl to get a sense of which QoS domains
> are "active" when only CPUs are assigned to a resource group but when it comes to task
> assignment it is user space that controls where tasks belonging to a group can be
> scheduled and thus which QoS domains are "active" or not. 
> 
>>
>> #echo "MB:0=8;1=8" > schemata
>>
>> # cat schemata
>>   MB:0=8;1=8;2=8192;3=8192
>>
>> The combined bandwidth can go up to 16(8+8) units. Each unit is 1/8 GB.
>>
>> With GMBA, we can set the combined limit higher level and total bandwidth will not exceed GMBA limit.
> 
> Thank you for the confirmation.
> 
>>
>>>>>> results in system memory being under-utilized since not all QOS domains are
>>>>>> using their full bandwidth Allocation.
>>>>>>
>>>>>> AMD PQoS Global Bandwidth Enforcement(GLBE) provides a mechanism
>>>>>> for software to specify bandwidth limits for groups of threads that span
>>>>>> multiple QoS Domains. This collection of QOS domains is referred to as GLBE
>>>>>> control domain. The GLBE ceiling sets a maximum limit on a memory bandwidth
>>>>>> in GLBE control domain. Bandwidth is shared by all threads in a Class of
>>>>>> Service(COS) across every QoS domain managed by the GLBE control domain.
>>>>> How does this bandwidth allocation limit impact existing MBA? For example, if a
>>>>> system has two domains (A and B) that user space separately sets MBA
>>>>> allocations for while also placing both domains within a "GLBE control domain"
>>>>> with a different allocation, does the individual MBA allocations still matter?
>>>> Yes. Both ceilings are enforced at their respective levels.
>>>> The MBA ceiling is applied at the QoS domain level.
>>>> The GLBE ceiling is applied at the GLBE control  domain level.
>>>> If the MBA ceiling exceeds the GLBE ceiling, the effective MBA limit will be capped by the GLBE ceiling.
>>> It sounds as though MBA and GMBA/GLBE operates within the same parameters wrt
>>> the limits but in examples in this series they have different limits. For example,
>>> in the documentation patch [1] there is this:
>>>
>>>   # cat schemata
>>>      GMB:0=2048;1=2048;2=2048;3=2048
>>>      MB:0=4096;1=4096;2=4096;3=4096
>>>      L3:0=ffff;1=ffff;2=ffff;3=ffff
>>>
>>> followed up with what it will look like in new generation [2]:
>>>
>>>     GMB:0=4096;1=4096;2=4096;3=4096
>>>      MB:0=8192;1=8192;2=8192;3=8192
>>>       L3:0=ffff;1=ffff;2=ffff;3=ffff
>>>
>>> In both examples the per-domain MB ceiling is higher than the global GMB ceiling. With
>>> above showing defaults and you state "If the MBA ceiling exceeds the GLBE ceiling,
>>> the effective MBA limit will be capped by the GLBE ceiling." - does this mean that
>>> MB ceiling can never be higher than GMB ceiling as shown in the examples?
>>
>> That is correct.  There is one more information here.   The MB unit is in 1/8 GB and GMB unit is 1GB.  I have added that in documentation in patch 4.
> 
> ah - right. I did not take the different units into account.
> 
>>
>> The GMB limit defaults to max value 4096 (bit 12 set) when the new group is created.  Meaning GMB limit does not apply by default.
>>
>> When setting the limits, it should be set to same value in all the domains in GMB control domain.  Having different value in each domain results in unexpected behavior.
>>
>>>
>>> Another question, when setting aside possible differences between MB and GMB.
>>>
>>> I am trying to understand how user may expect to interact with these interfaces ...
>>>
>>> Consider the starting state example as below where the MB and GMB ceilings are the
>>> same:
>>>
>>>    # cat schemata
>>>    GMB:0=2048;1=2048;2=2048;3=2048
>>>    MB:0=2048;1=2048;2=2048;3=2048
>>>
>>> Would something like below be accurate? Specifically, showing how the GMB limit impacts the
>>> MB limit:
>>>       # echo "GMB:0=8;2=8" > schemata
>>>    # cat schemata
>>>    GMB:0=8;1=2048;2=8;3=2048
>>>    MB:0=8;1=2048;2=8;3=2048
>>
>> Yes. That is correct.  It will cap the MB setting to  8.   Note that we are talking about unit differences to make it simple.
> 
> Thank you for confirming.
> 
>>
>>
>>> ... and then when user space resets GMB the MB can reset like ...
>>>
>>>    # echo "GMB:0=2048;2=2048" > schemata
>>>    # cat schemata
>>>    GMB:0=2048;1=2048;2=2048;3=2048
>>>    MB:0=2048;1=2048;2=2048;3=2048
>>>
>>> if I understand correctly this will only apply if the MB limit was never set so
>>> another scenario may be to keep a previous MB setting after a GMB change:
>>>
>>>    # cat schemata
>>>    GMB:0=2048;1=2048;2=2048;3=2048
>>>    MB:0=8;1=2048;2=8;3=2048
>>>
>>>    # echo "GMB:0=8;2=8" > schemata
>>>    # cat schemata
>>>    GMB:0=8;1=2048;2=8;3=2048
>>>    MB:0=8;1=2048;2=8;3=2048
>>>
>>>    # echo "GMB:0=2048;2=2048" > schemata
>>>    # cat schemata
>>>    GMB:0=2048;1=2048;2=2048;3=2048
>>>    MB:0=8;1=2048;2=8;3=2048
>>>
>>> What would be most intuitive way for user to interact with the interfaces?
>>
>> I see that you are trying to display the effective behaviors above.
> 
> Indeed. My goal is to get an idea how user space may interact with the new interfaces and
> what would be a reasonable expectation from resctrl be during these interactions.
> 
>>
>> Please keep in mind that MB and GMB units differ. I recommend showing only the values the user has explicitly configured, rather than the effective settings, as displaying both may cause confusion.
> 
> hmmm ... this may be subjective. Could you please elaborate how presenting the effective 
> settings may cause confusion?
> 
>>
>> We also need to track the previous settings so we can revert to the earlier value when needed. The best approach is to document this behavior clearly.
> 
> Yes, this will require resctrl to maintain more state.
> 
> Documenting behavior is an option but I think we should first consider if there are things
> resctrl can do to make the interface intuitive to use.
> 
>>>>>>  From the description it sounds as though there is a new "memory bandwidth
>>>>> ceiling/limit" that seems to imply that MBA allocations are limited by
>>>>> GMBA allocations while the proposed user interface present them as independent.
>>>>>
>>>>> If there is indeed some dependency here ... while MBA and GMBA CLOSID are
>>>>> enumerated separately, under which scenario will GMBA and MBA support different
>>>>> CLOSID? As I mentioned in [1] from user space perspective "memory bandwidth"
>>>> I can see the following scenarios where MBA and GMBA can operate independently:
>>>> 1. If the GMBA limit is set to ‘unlimited’, then MBA functions as an independent CLOS.
>>>> 2. If the MBA limit is set to ‘unlimited’, then GMBA functions as an independent CLOS.
>>>> I hope this clarifies your question.
>>> No. When enumerating the features the number of CLOSID supported by each is
>>> enumerated separately. That means GMBA and MBA may support different number of CLOSID.
>>> My question is: "under which scenario will GMBA and MBA support different CLOSID?"
>> No. There is not such scenario.
>>>
>>> Because of a possible difference in number of CLOSIDs it seems the feature supports possible
>>> scenarios where some resource groups can support global AND per-domain limits while other
>>> resource groups can just support global or just support per-domain limits. Is this correct?
>>
>> System can support up to 16 CLOSIDs. All of them support all the features LLC, MB, GMB, SMBA.   Yes. We have separate enumeration for  each feature.  Are you suggesting to change it ?
> 
> It is not a concern to have different CLOSIDs between resources that are actually different,
> for example, having LLC or MB support different number of CLOSIDs. Having the possibility to
> allocate the *same* resource (memory bandwidth) with varying number of CLOSIDs does present a
> challenge though. Would it be possible to have a snippet in the spec that explicitly states
> that MB and GMB will always enumerate with the same number of CLOSIDs? 
> 
> Please see below where I will try to support this request more clearly and you can decide if
> it is reasonable.
>   
>>>>> can be seen as a single "resource" that can be allocated differently based on
>>>>> the various schemata associated with that resource. This currently has a
>>>>> dependency on the various schemata supporting the same number of CLOSID which
>>>>> may be something that we can reconsider?
>>>> After reviewing the new proposal again, I’m still unsure how all the pieces will fit together. MBA and GMBA share the same scope and have inter-dependencies. Without the full implementation details, it’s difficult for me to provide meaningful feedback on new approach.
>>> The new approach is not final so please provide feedback to help improve it so
>>> that the features you are enabling can be supported well.
>>
>> Yes, I am trying. I noticed that the proposal appears to affect how the schemata information is displayed(in info directory). It seems to introduce additional resource information. I don't see any harm in displaying it if it benefits certain architecture.
> 
> It benefits all architectures.
> 
> There are two parts to the current proposals.
> 
> Part 1: Generic schema description
> I believe there is consensus on this approach. This is actually something that is long
> overdue and something like this would have been a great to have with the initial AMD
> enabling. With the generic schema description forming part of resctrl the user can learn
> from resctrl how to interact with the schemata file instead of relying on external information
> and documentation.
> 
> For example, on an Intel system that uses percentage based proportional allocation for memory
> bandwidth the new resctrl files will display:
> info/MB/resource_schemata/MB/type:scalar linear
> info/MB/resource_schemata/MB/unit:all
> info/MB/resource_schemata/MB/scale:1
> info/MB/resource_schemata/MB/resolution:100
> info/MB/resource_schemata/MB/tolerance:0
> info/MB/resource_schemata/MB/max:100
> info/MB/resource_schemata/MB/min:10
> 
> 
> On an AMD system that uses absolute allocation with 1/8 GBps steps the files will display:
> info/MB/resource_schemata/MB/type:scalar linear
> info/MB/resource_schemata/MB/unit:GBps
> info/MB/resource_schemata/MB/scale:1
> info/MB/resource_schemata/MB/resolution:8
> info/MB/resource_schemata/MB/tolerance:0
> info/MB/resource_schemata/MB/max:2048
> info/MB/resource_schemata/MB/min:1
> 
> Having such interface will be helpful today. Users do not need to first figure out
> whether they are on an AMD or Intel system, and then read the docs to learn the AMD units,
> before interacting with resctrl. resctrl will be the generic interface it intends to be.
> 
> Part 2: Supporting multiple controls for a single resource
> This is a new feature on which there also appears to be consensus that is needed by MPAM and
> Intel RDT where it is possible to use different controls for the same resource. For example,
> there can be a minimum and maximum control associated with the memory bandwidth resource.
> 
> For example, 
> info/
>  └─ MB/
>      └─ resource_schemata/
>          ├─ MB/
>          ├─ MB_MIN/
>          ├─ MB_MAX/
>          ┆
> 
> 
> Here is where the big question comes in for GLBE - is this actually a new resource
> for which resctrl needs to add interfaces to manage its allocation, or is it instead 
> an additional control associated with the existing memory bandwith resource?
> 
> For me things are actually pointing to GLBE not being a new resource but instead being
> a new control for the existing memory bandwidth resource.
> 
> I understand that for a PoC it is simplest to add support for GLBE as a new resource as is
> done in this series but when considering it as an actual unique resource does not seem
> appropriate since resctrl already has a "memory bandwidth" resource. User space expects
> to find all the resources that it can allocate in info/ - I do not think it is correct
> to have two separate directories/resources for memory bandwidth here.
> 
> What if, instead, it looks something like:
> 
> info/
> └── MB/
>     └── resource_schemata/
>         ├── GMB/
>         │   ├── max:4096
>         │   ├── min:1
>         │   ├── resolution:1
>         │   ├── scale:1
>         │   ├── tolerance:0
>         │   ├── type:scalar linear
>         │   └── unit:GBps
>         └── MB/
>             ├── max:8192
>             ├── min:1
>             ├── resolution:8
>             ├── scale:1
>             ├── tolerance:0
>             ├── type:scalar linear
>             └── unit:GBps
> 
> With an interface like above GMB is just another control/schema used to allocate the
> existing memory bandwidth resource. With the planned files it is possible to express the
> different maximums and units used by the MB and GMB schema. Users no longer need to
> dig for the unit information in the docs, it is available in the interface.
> 
> Doing something like this does depend on GLBE supporting the same number of CLOSIDs
> as MB, which seems to be how this will be implemented. If there is indeed a confirmation
> of this from AMD architecture then we can do something like this in resctrl.

I haven't fully understood what GLBE is but in MPAM we have an optional
feature in MSC (MPAM devices) called partid narrowing. For some MSC
there are limited controls and the incoming partid is mapped to an
effective partid using a mapping. This mapping is software controllable.
Dave (with Shaopeng and Zeng) has a proposal to use this to use partid
bits as pmg bits, [1]. This usage would have to be opt-in as it changes
the number of closid/rmid that MPAM presents to resctrl. If however, the
user doesn't use that scheme then the controls could be presented as
controls for groups of closid in resctrl. Is this similar/usable with
the same interface as GLBE or have I misunderstood?

[1]
https://lore.kernel.org/linux-arm-kernel/20241212154000.330467-1-Dave.Martin@arm.com/

> 
> There is a "part 3" to the proposals that attempts to address the new requirement where
> some of the controls allocate at a different scope while also requiring monitoring at
> that new scope. After learning more about GLBE this does not seem relevant to GLBE but is
> something to return to for the "MPAM CPU-less" work. We could already prepare for this
> by adding the new "scope" schema property though. 
> 
> 
> Reinette
> 
>>
>> Thanks
>>
>> Babu
>>
>>
>>>
>>> Reinette
>>>
>>> [1] https://lore.kernel.org/lkml/d58f70592a4ce89e744e7378e49d5a36be3fd05e.1769029977.git.babu.moger@amd.com/
>>> [2] https://lore.kernel.org/lkml/e0c79c53-489d-47bf-89b9-f1bb709316c6@amd.com/
>>>
> 
> 


Thanks,

Ben


