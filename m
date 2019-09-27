Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 340E7C08DC
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 17:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfI0PrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 11:47:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41728 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfI0PrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 11:47:02 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CC7AF5859E
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 15:47:01 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id t11so1261717wro.10
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 08:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=RbzgPZXdKzO0rf0w8jOBPiPgU1tPZXuYbMyJvwrRVFY=;
        b=o0aAmE4HxHYX8odkSmtuDUbANj6HcOatYXqn7gB1azPxaTZ4+kIPNAV3YQOnVn0Ekh
         ykySK9KNyAw0mUwIEZvrr+Vx+AMxbAD9CscSJrvFEj1lCe/qZSAwdeGBkLOSjMu6Eper
         cdLsqLWPLyK56iwbVVyDEp75RkKhaOViw8QvR9YDCXw8hViWpY0oA971LkFhNhQJ3VDI
         6Diu9SnJcnBJkdvPgPCeUDHyNeeupn25/3FDnHLaj+zq7gA8FL+1KB0KaunhsRuHroKg
         vDn59JVpIl/LXSpiZtKZ1zzXAk+OCU6UYgkpSxVR5K2kAXorks7PggsqElKIS8gNiyoI
         /CbA==
X-Gm-Message-State: APjAAAVqSVqnVkBiBB/z2c3tXDSSIB5h1Xx+NIkBVSP9QxcH5QjafCI9
        hbcGbIolHu+oNPvBzAzxptQ6EBtLsI3Yn+HdGsOquMDhX/BtHdiGm6FNnBXxzgsJgODlDa8e/Pr
        UlK7arjldlxOk
X-Received: by 2002:adf:f64f:: with SMTP id x15mr3685223wrp.25.1569599220581;
        Fri, 27 Sep 2019 08:47:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwV2hIJPTLwMifp9E8etqyv2v4dxQd3WntnR1V8UD6XEWbOYW0MjKOgrdTKMtuC2jZVRBTEMg==
X-Received: by 2002:adf:f64f:: with SMTP id x15mr3685202wrp.25.1569599220345;
        Fri, 27 Sep 2019 08:47:00 -0700 (PDT)
Received: from vitty.brq.redhat.com ([95.82.135.182])
        by smtp.gmail.com with ESMTPSA id c10sm4684680wrf.58.2019.09.27.08.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 08:46:59 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Eric Hankland <ehankland@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH] kvm: x86: Add Intel PMU MSRs to msrs_to_save[]
In-Reply-To: <20190927152608.GC25513@linux.intel.com>
References: <8907173e-9f27-6769-09fc-0b82c22d6352@oracle.com> <CALMp9eSkognb2hJSuENK+5PSgE8sYzQP=4ioERge6ZaFg1=PEA@mail.gmail.com> <cb7c570c-389c-2e96-ba46-555218ba60ed@oracle.com> <CALMp9eQULvr5wKt1Aw3MR+tbeNgvA_4p__6n1YTkWjMHCaEmLw@mail.gmail.com> <CALMp9eS1fUVcnVHhty60fUgk3-NuvELMOUFqQmqPLE-Nqy0dFQ@mail.gmail.com> <56e7fad0-d577-41db-0b81-363975dc2ca7@redhat.com> <87ftkh6e19.fsf@vitty.brq.redhat.com> <6e6f46fe-6e11-c5e3-d80c-327f77b91907@redhat.com> <87d0fl6bv4.fsf@vitty.brq.redhat.com> <19db28c0-375a-7bc0-7151-db566ae85de6@redhat.com> <20190927152608.GC25513@linux.intel.com>
Date:   Fri, 27 Sep 2019 17:46:58 +0200
Message-ID: <87a7ap68st.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Fri, Sep 27, 2019 at 05:19:25PM +0200, Paolo Bonzini wrote:
>> On 27/09/19 16:40, Vitaly Kuznetsov wrote:
>> > Paolo Bonzini <pbonzini@redhat.com> writes:
>> > 
>> >> On 27/09/19 15:53, Vitaly Kuznetsov wrote:
>> >>> Paolo Bonzini <pbonzini@redhat.com> writes:
>> >>>
>> >>>> Queued, thanks.
>> >>>
>> >>> I'm sorry for late feedback but this commit seems to be causing
>> >>> selftests failures for me, e.g.:
>> >>>
>> >>> # ./x86_64/state_test 
>> >>> Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
>> >>> Guest physical address width detected: 46
>> >>> ==== Test Assertion Failure ====
>> >>>   lib/x86_64/processor.c:1089: r == nmsrs
>> >>>   pid=14431 tid=14431 - Argument list too long
>> >>>      1	0x000000000040a55f: vcpu_save_state at processor.c:1088 (discriminator 3)
>> >>>      2	0x00000000004010e3: main at state_test.c:171 (discriminator 4)
>> >>>      3	0x00007f881eb453d4: ?? ??:0
>> >>>      4	0x0000000000401287: _start at ??:?
>> >>>   Unexpected result from KVM_GET_MSRS, r: 36 (failed at 194)
>
> That "failed at %x" print line should really be updated to make it clear
> that it's printing hex...
>

Yea, I also wasn't sure and had to look in the code. Will send a patch
if no one beats me to it.

>> >>> Is this something known already or should I investigate?
>> >>
>> >> No, I didn't know about it, it works here.
>> >>
>> > 
>> > Ok, this is a bit weird :-) '194' is 'MSR_ARCH_PERFMON_EVENTSEL0 +
>> > 14'. In intel_pmu_refresh() nr_arch_gp_counters is set to '8', however,
>> > rdmsr_safe() for this MSR passes in kvm_init_msr_list() (but it fails
>> > for 0x18e..0x193!) so it stay in the list. get_gp_pmc(), however, checks
>> > it against nr_arch_gp_counters and returns a failure.
>> 
>> Huh, 194h apparently is a "FLEX_RATIO" MSR.  I agree that PMU MSRs need
>> to be checked against CPUID before allowing them.
>
> My vote would be to programmatically generate the MSRs using CPUID and the
> base MSR, as opposed to dumping them into the list and cross-referencing
> them against CPUID.  E.g. there should also be some form of check that the
> architectural PMUs are even supported.

Yes. The problem appears to be that msrs_to_save[] and emulated_msrs[]
are global and for the MSRs in question we check
kvm_find_cpuid_entry(vcpu, 0xa, ) to find out how many of them are
available so this can be different for different VMs (and even vCPUs :-)
However,

"KVM_GET_MSR_INDEX_LIST returns the guest msrs that are supported.  The list
varies by kvm version and host processor, but does not change otherwise."

So it seems that PMU MSRs just can't be there. Revert?

-- 
Vitaly
