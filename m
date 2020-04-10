Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132C61A446A
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 11:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgDJJU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 05:20:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44312 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgDJJU5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 05:20:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03A9I03u163963;
        Fri, 10 Apr 2020 09:20:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZiMAGX9H6/bxifsNfICnPVI+DpfXz2fXmOgWWDhAIGs=;
 b=URNDPhpqwrILErIj8YR6JA/6KPolE9057heYVoGx1E2KsMSuczEpoH9lc47r5EdeJrDy
 DS/TvyhTAVOaH30H33Hi7f13yysfKCEhjwv+Ms0wuVMQTj2kPWDM2UJALEXv5y4iMAIZ
 7lWTQLOtyfMnxvX1JQa1XPTqmIrz4hPB3rAp53QiGQmj09X6ehMz+j4zk5gGtlkA/+de
 1L1JstrBp5kNCqKqh4COhvntvlhDwx0A5sw9oDNicIw5j6MsY67lEgUEruQC8O6ZrWd0
 UFoxIEvlVvfzx4AfgalJtTinuJqRmMsJz+32ezG3us8mH88H5KNRPk2vEeEeJb/naXzi 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 3091m15qc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 09:20:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03A9HfoA078660;
        Fri, 10 Apr 2020 09:18:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3091mbsyyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 09:18:38 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03A9IZbe025444;
        Fri, 10 Apr 2020 09:18:35 GMT
Received: from [10.159.147.187] (/10.159.147.187)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Apr 2020 02:18:35 -0700
Subject: Re: [RFC PATCH 00/26] Runtime paravirt patching
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com,
        jpoimboe@redhat.com, namit@vmware.com, mhiramat@kernel.org,
        jgross@suse.com, bp@alien8.de, vkuznets@redhat.com,
        pbonzini@redhat.com, boris.ostrovsky@oracle.com,
        mihai.carabas@oracle.com, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
 <20200408120856.GY20713@hirez.programming.kicks-ass.net>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <99d80ba2-9bc9-143f-0f9a-7178c619a2e2@oracle.com>
Date:   Fri, 10 Apr 2020 02:18:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200408120856.GY20713@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004100078
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9586 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-04-08 5:08 a.m., Peter Zijlstra wrote:
> On Tue, Apr 07, 2020 at 10:02:57PM -0700, Ankur Arora wrote:
>> A KVM host (or another hypervisor) might advertise paravirtualized
>> features and optimization hints (ex KVM_HINTS_REALTIME) which might
>> become stale over the lifetime of the guest. For instance, the
>> host might go from being undersubscribed to being oversubscribed
>> (or the other way round) and it would make sense for the guest
>> switch pv-ops based on that.
> 
> So what, the paravirt spinlock stuff works just fine when you're not
> oversubscribed.
> 
>> We keep an interesting subset of pv-ops (pv_lock_ops only for now,
>> but PV-TLB ops are also good candidates)
> 
> The PV-TLB ops also work just fine when not oversubscribed. IIRC
> kvm_flush_tlb_others() is pretty much the same in that case.
> 
>> in .parainstructions.runtime,
>> while discarding the .parainstructions as usual at init. This is then
>> used for switching back and forth between native and paravirt mode.
>> ([1] lists some representative numbers of the increased memory
>> footprint.)
>>
>> Mechanism: the patching itself is done using stop_machine(). That is
>> not ideal -- text_poke_stop_machine() was replaced with INT3+emulation
>> via text_poke_bp(), but I'm using this to address two issues:
>>   1) emulation in text_poke() can only easily handle a small set
>>   of instructions and this is problematic for inlined pv-ops (and see
>>   a possible alternatives use-case below.)
>>   2) paravirt patching might have inter-dependendent ops (ex.
>>   lock.queued_lock_slowpath, lock.queued_lock_unlock are paired and
>>   need to be updated atomically.)
> 
> And then you hope that the spinlock state transfers.. That is that both
> implementations agree what an unlocked spinlock looks like.
> 
> Suppose the native one was a ticket spinlock, where unlocked means 'head
> == tail' while the paravirt one is a test-and-set spinlock, where
> unlocked means 'val == 0'.
> 
> That just happens to not be the case now, but it was for a fair while.
> 
>> The alternative use-case is a runtime version of apply_alternatives()
>> (not posted with this patch-set) that can be used for some safe subset
>> of X86_FEATUREs. This could be useful in conjunction with the ongoing
>> late microcode loading work that Mihai Carabas and others have been
>> working on.
> 
> The whole late-microcode loading stuff is crazy already; you're making
> it take double bonghits.
That's fair. I was talking in a fairly limited sense, ex making static_cpu_has()
catch up with boot_cpu_has() after a microcode update but I should have
specified that.

> 
>> Also, there are points of similarity with the ongoing static_call work
>> which does rewriting of indirect calls.
> 
> Only in so far as that code patching is involved. An analogy would be
> comparing having a beer with shooting dope. They're both 'drugs'.
I meant closer to updating indirect pointers, like static_call_update()
semantics. But of course I don't know static_call code well enough.

> 
>> The difference here is that
>> we need to switch a group of calls atomically and given that
>> some of them can be inlined, need to handle a wider variety of opcodes.
>>
>> To patch safely we need to satisfy these constraints:
>>
>>   - No references to insn sequences under replacement on any kernel stack
>>     once replacement is in progress. Without this constraint we might end
>>     up returning to an address that is in the middle of an instruction.
> 
> Both ftrace and optprobes have that issue, neither of them are quite as
> crazy as this.
I did look at ftrace. Will look at optprobes. Thanks.

> 
>>   - handle inter-dependent ops: as above, lock.queued_lock_unlock(),
>>     lock.queued_lock_slowpath() and the rest of the pv_lock_ops are
>>     a good example.
> 
> While I'm sure this is a fun problem, why are we solving it?
> 
>>   - handle a broader set of insns than CALL and JMP: some pv-ops end up
>>     getting inlined. Alternatives can contain arbitrary instructions.
> 
> So can optprobes.> 
>>   - locking operations can be called from interrupt handlers which means
>>     we cannot trivially use IPIs for flushing.
> 
> Heck, some NMI handlers use locks..
This does handle the NMI locking problem. The solution -- doing it
in the NMI handler was of course pretty ugly.

>> Handling these, necessitates that target pv-ops not be preemptible.
> 
> I don't think that is a correct inferrence.The non-preemptibility requirement was to ensure that any pv-op under
replacement not be under execution after it is patched out.
(Not a concern for pv_lock_ops.)

Ensuring that we don't return to an address in the middle of an instruction
could be done by moving the NOPs in the prefix, but I couldn't think of
any other way to ensure that a function not be under execution.

Thanks
Ankur

>> Once that is a given (for safety these need to be explicitly whitelisted
>> in runtime_patch()), use a state-machine with the primary CPU doing the
>> patching and secondary CPUs in a sync_core() loop.
>>
>> In case we hit an INT3/BP (in NMI or thread-context) we makes forward
>> progress by continuing the patching instead of emulating.
>>
>> One remaining issue is inter-dependent pv-ops which are also executed in
>> the NMI handler -- patching can potentially deadlock in case of multiple
>> NMIs. Handle these by pushing some of this work in the NMI handler where
>> we know it will be uninterrupted.
> 
> I'm just seeing a lot of bonghits without sane rationale. Why is any of
> this important?
> 
