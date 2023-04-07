Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3736D6DA9FA
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 10:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbjDGIUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Apr 2023 04:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239780AbjDGIUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Apr 2023 04:20:44 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B26A5CD;
        Fri,  7 Apr 2023 01:20:36 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-62815785926so391171b3a.0;
        Fri, 07 Apr 2023 01:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680855334; x=1683447334;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cSkbBiuLB6EkGYLfjV6DampPuHrUk13biBZcIGQ2peU=;
        b=T6/f2eU7wdDY5hzejW0bh8FXBPnQejv4TxIVXCTTBd85t1J86tAPLrQi3knaBpFhHW
         sUjK2LHxlbiFQRsFlqoRYZsLvJ2kmsMYK6OE6HfbCZKBufTgTcvX5KQ4H6wJk4n6IN8W
         LPmneryxWoaPe+WwJwrarbHXXFQ5kGHrD84noDFKNucsjcYkqTxck0hBDmc2relix8oG
         NZiUsUfJ1LhELnUqjEo0W1emBfSWT5CyTHgF6BDAnYRHnbyzagUdt/KBO6vG9RsjUy7u
         QxB2+lOqATK1znA9j3KTwbdQgzXx8W6geHIsWCLgClpvdKxLbOz2I1qdOuDFGV4YXJnc
         CuJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680855334; x=1683447334;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cSkbBiuLB6EkGYLfjV6DampPuHrUk13biBZcIGQ2peU=;
        b=c/C9ENf3P3mt5jJtxHobzGcCjCoAoiQBjVTgzHpY4lSR9b58ajFrZaqMTz6G+th/A6
         oWTjSn7G7f9V6hCk5GFqTDlz6+uYwcCsWPCxx8sLDdxWx3wfDuYde0x+/lBetNl18v3+
         mt5UmoUneBa/7WCm7941JtnM0zH22WnKE3shDYiUMT4VUtrUx49kAq6X+xHX2NRBh3dS
         ApjAFnMZjFsmHQTcu4rNaWp/Zatmwy75ia1ciROU6GO4GDGX2JwAIpWKeQD6VG/SJ9L5
         IFUT4BOtFAjkZFQYuiGO1LaFAymroLIm+OMkQ6VFBeYHVhjELEN5NB41QxF7qd9U1vdY
         xAmw==
X-Gm-Message-State: AAQBX9d3YLqQ5YPWfCG381ygZ2i2zf8oZjBwRHBoH/xSj7qxFA0/Sa2q
        qrVeB6iawuPLrmbKFs3a5Rg=
X-Google-Smtp-Source: AKy350YTeZLtmCKT91uMeI/t7cVLGXJ0tpxcLySX8dJrCVTDyOTE5GoYaGTydXsbOHeIxJlY2uLhEg==
X-Received: by 2002:a62:84d2:0:b0:622:8a8e:8cf8 with SMTP id k201-20020a6284d2000000b006228a8e8cf8mr1408033pfd.14.1680855334020;
        Fri, 07 Apr 2023 01:15:34 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id fe12-20020a056a002f0c00b0062d942f0ad3sm2506287pfb.51.2023.04.07.01.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Apr 2023 01:15:33 -0700 (PDT)
Message-ID: <509b697f-4e60-94e5-f785-95f7f0a14006@gmail.com>
Date:   Fri, 7 Apr 2023 16:15:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH 5/5] KVM: x86/pmu: Hide guest counter updates from the
 VMRUN instruction
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230310105346.12302-1-likexu@tencent.com>
 <20230310105346.12302-6-likexu@tencent.com> <ZC99f+AO1tZguu1I@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZC99f+AO1tZguu1I@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/4/2023 10:18 am, Sean Christopherson wrote:
> On Fri, Mar 10, 2023, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> When AMD guest is counting (branch) instructions event, its vPMU should
>> first subtract one for any relevant (branch)-instructions enabled counter
>> (when it precedes VMRUN and cannot be preempted) to offset the inevitable
>> plus-one effect of the VMRUN instruction immediately follows.
>>
>> Based on a number of micro observations (also the reason why x86_64/
>> pmu_event_filter_test fails on AMD Zen platforms), each VMRUN will
>> increment all hw-(branch)-instructions counters by 1, even if they are
>> only enabled for guest code. This issue seriously affects the performance
>> understanding of guest developers based on (branch) instruction events.
>>
>> If the current physical register value on the hardware is ~0x0, it triggers
>> an overflow in the guest world right after running VMRUN. Although this
>> cannot be avoided on mainstream released hardware, the resulting PMI
>> (if configured) will not be incorrectly injected into the guest by vPMU,
>> since the delayed injection mechanism for a normal counter overflow
>> depends only on the change of pmc->counter values.
> 
> IIUC, this is saying that KVM may get a spurious PMI, but otherwise nothing bad
> will happen?

Guests will have nothing to lose, except gaining vPMI accuracy under this proposal.

When a host gets an overflow interrupt caused by a VMRUN, it forwards it to KVM.
KVM does not inject it into the VM, but discards it. For those using PMU to 
profiling
the hypervisor itself, they lose an interrupt or a sample on VMRUN context.

> 
>> +static inline bool event_is_branch_instruction(struct kvm_pmc *pmc)
>> +{
>> +	return eventsel_match_perf_hw_id(pmc, PERF_COUNT_HW_INSTRUCTIONS) ||
>> +		eventsel_match_perf_hw_id(pmc,
>> +					  PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
>> +}
>> +
>> +static inline bool quirky_pmc_will_count_vmrun(struct kvm_pmc *pmc)
>> +{
>> +	return event_is_branch_instruction(pmc) && event_is_allowed(pmc) &&
>> +		!static_call(kvm_x86_get_cpl)(pmc->vcpu);
> 
> Wait, really?  VMRUN is counted if and only if it enters to a CPL0 guest?  Can
> someone from AMD confirm this?  I was going to say we should just treat this as
> "normal" behavior, but counting CPL0 but not CPL>0 is definitely quirky.

VMRUN is only counted on a CPL0-target (branch) instruction counter. The VMRUN
is not expected to be counted by the guest counters, regardless of the guest CPL.

This issue makes a guest CPL0-target instruction counter inexplicably increase, 
as if it
would have been under-counted before the virtualization instructions were counted.

Treating the host hypervisor instructions like VMRUN as guest workload instructions
is already an error in itself not "normal" behavior that affects guest accuracy.
