Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7041D46F357
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhLISw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhLISw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:52:58 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B17FC061746;
        Thu,  9 Dec 2021 10:49:24 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id g14so21854362edb.8;
        Thu, 09 Dec 2021 10:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aVerTt1lvjM7lpSOGB2Y8LmgVv7pAypt/Vj253p8lGs=;
        b=pgcl0l4Exa9OoP72xAzHrQNzDpgp00QxKpLGMlmb4iby3joQL1mvwxIlVpfpabxLiV
         C7SOyYVNaCJ364S1pgPSbKgsM0dAyGLxHpFwX7UobwJrpufvZIX+wEu9spsTDJPMLTC0
         EPnSv4MmWguBbXoeLi+5GLPyS3Egbc7rH3ARu8sXqVQC43MUDpesBBshw8Y8gtfE8P3U
         B+nrb/3g6TtRLo2XyBBxQ3EZL6+AwqV4hIQ644jMqX9MNI+Zu1ddClSDNSpKIFgjsrJe
         YKG43ZWJBI16ryXW5mW7E0YJ6WENFk5zU6mBpxACchAXpZ/hY2y0cIjxyGwfHL3tcE+3
         Qmdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aVerTt1lvjM7lpSOGB2Y8LmgVv7pAypt/Vj253p8lGs=;
        b=lX+nE4hQe5C0ufwczBoELhihdmO7qiEiRJClRwqXcgtxz6LQTEUxaZoVKsE9wpy7tG
         HvmwBB6DzxS5reH3RCwBVF3U+yL+1W3oomDCDKV9J9z7xMUb6YEzkY3ozFQG0PWUOlij
         zQBOVmy1Bw2WiwY8pKedlvpmhD3AbyF5V6CJXgeEOEt2SbT+wnPIgEOXsYv7zcvzSqMt
         aL3n799snL4CaPlgPqwe6GX4pm8KYlJxGnoRIy4+FcERpwFU0Fumw+TUOiiGhk78jZf/
         HTsMQ3PWpnWkziu7jdczKhj5JPgx6ochQhU6mmAzGEsGZkeu+h8h6sLRRAik1ppVjV/f
         FlTg==
X-Gm-Message-State: AOAM532pExdg95S2hr3cVHjA6LBbzjXmxrc39Z30rw1hJLcu2fJc7uRi
        XLzW4Uk5fz8L9pmE/ElUKC0=
X-Google-Smtp-Source: ABdhPJz/VX+fYdOPqgVAXgpW/lpVNtos7JXqz5nT6UshEQkO6cmsREJnkaq14A4ZtfsIVUGbsNTe1g==
X-Received: by 2002:a50:e683:: with SMTP id z3mr31666795edm.206.1639075759964;
        Thu, 09 Dec 2021 10:49:19 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id lv19sm307518ejb.54.2021.12.09.10.49.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 10:49:19 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8ca78cd6-12ad-56c4-ad73-e88757364ba9@redhat.com>
Date:   Thu, 9 Dec 2021 19:49:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 1/6] KVM: x86/pmu: Setup pmc->eventsel for fixed PMCs
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20211130074221.93635-1-likexu@tencent.com>
 <20211130074221.93635-2-likexu@tencent.com>
 <CALMp9eT05nb56b16KkybvGSTYMhkRusQnNL4aWFU8tsets0O2w@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CALMp9eT05nb56b16KkybvGSTYMhkRusQnNL4aWFU8tsets0O2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/21 20:57, Jim Mattson wrote:
>> +
>> +       for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
>> +               pmc = &pmu->fixed_counters[i];
>> +               event = fixed_pmc_events[array_index_nospec(i, size)];
> How do we know that i < size? For example, Ice Lake supports 4 fixed
> counters, but fixed_pmc_events only has three entries.

We don't, and it's a preexisting bug in intel_pmu_refresh.  Either we hack around it like

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 1b7456b2177b..6f03c8bf1bc2 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -500,8 +500,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
  		pmu->nr_arch_fixed_counters = 0;
  	} else {
  		pmu->nr_arch_fixed_counters =
-			min_t(int, edx.split.num_counters_fixed,
-			      x86_pmu.num_counters_fixed);
+			min3(ARRAY_SIZE(fixed_pmc_events),
+			     (size_t) edx.split.num_counters_fixed,
+			     (size_t) x86_pmu.num_counters_fixed);
  		edx.split.bit_width_fixed = min_t(int,
  			edx.split.bit_width_fixed, x86_pmu.bit_width_fixed);
  		pmu->counter_bitmask[KVM_PMC_FIXED] =

or we modify find_fixed_event and its caller to support PERF_TYPE_RAW
counters, and then add support for the IceLake TOPDOWN.SLOTS fixed
counter.

What's your preference?

Paolo
