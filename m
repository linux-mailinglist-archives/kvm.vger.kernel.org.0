Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51281FCC8A
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 13:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgFQLiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 07:38:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22643 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726874AbgFQLiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 07:38:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592393886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oS2sHeOWkDi5/NnXrNwUVCA9Ew0qnl4Cg+hQYeorxVM=;
        b=hi+jKuFXEx7wcmDZxxEWD6G0Vfl0Ama/z523llu6qHix6K94zWGwVdk8TIz+K7KaKmNl+s
        8Spv6CYdFhKuWoq5Cz2LHl7zYgkED1fRpN1VPrA6urIhQ6jxQDw2x8Y+0TwZv08GdOQRg4
        EuFCvfMs9++FCC6CB/NMHOGqZ96XsBs=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-VYmDkj0CO0OdUW794Mk7OA-1; Wed, 17 Jun 2020 07:38:04 -0400
X-MC-Unique: VYmDkj0CO0OdUW794Mk7OA-1
Received: by mail-ej1-f72.google.com with SMTP id gr26so885312ejb.22
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 04:38:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=oS2sHeOWkDi5/NnXrNwUVCA9Ew0qnl4Cg+hQYeorxVM=;
        b=SjWmoiVS7L0hP9vvW0qlBXRGSZht6dh/nXlIAAf7HbopfMfFKs2L/E0zN6iPx4Cus/
         q5t2p1ONxMoxRtIXuCGFlegIiQ6c/KCDkll8lmGWW0NC6yD+00lVugUBr8K0O4Z7nuM4
         XJNFLZt6D8yNn/2XDECPDyYKMsV7XSGgXYVST1YPrf7B17vkLzz3gInUbLG4/T2/bv+0
         MWxuLEfSGCBMYx8wR5eZU1TLRpDiiV5y5XOmGMxuzydcPMVjeqLuX2qPX1b57Qd0BLWw
         XbmMKxsC8k2Ih9o/ufAop2SFD9HCrcc9ih+JbrqsupgjdIDUALY+FPdl3nPRCnjZKE/4
         ExSg==
X-Gm-Message-State: AOAM532nwK2EffsPMyNPHj8xVLAr7SaZLJU7abzQ/9fav+0ddFPgxItu
        3BcUY1OJ/CFIvdeZcAbdatEdCke/yVWyfR7Kfwz1SxCWl+CTRY6Hvo371cfhh6ZmP8pknSL6RnH
        zHHVQCfTfVGdN
X-Received: by 2002:a05:6402:1512:: with SMTP id f18mr7008259edw.101.1592393883360;
        Wed, 17 Jun 2020 04:38:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJArYTpIQqF0kcPvSiZNCMpM4scmG/Pu1RYbyYqnZ4Pb4T9s1BJXq1/3aoKfzT/Ftt5o3QDg==
X-Received: by 2002:a05:6402:1512:: with SMTP id f18mr7008246edw.101.1592393883098;
        Wed, 17 Jun 2020 04:38:03 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id v5sm11829338edl.51.2020.06.17.04.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 04:38:02 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Like Xu <like.xu@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: SVM: drop MSR_IA32_PERF_CAPABILITIES from emulated MSRs
In-Reply-To: <CALMp9eQ1qe4w5FojzgsUHKpD=zXqen_D6bBg4-vfHa03BdomGA@mail.gmail.com>
References: <20200616161427.375651-1-vkuznets@redhat.com> <CALMp9eSWXGQkOOzSrALfZDMj5JHSH=CsK1wKfdj2x2jtV4XJsw@mail.gmail.com> <87366vhscx.fsf@vitty.brq.redhat.com> <CALMp9eQ1qe4w5FojzgsUHKpD=zXqen_D6bBg4-vfHa03BdomGA@mail.gmail.com>
Date:   Wed, 17 Jun 2020 13:38:01 +0200
Message-ID: <87wo45hqhy.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jim Mattson <jmattson@google.com> writes:

> On Tue, Jun 16, 2020 at 9:45 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>>
>> Jim Mattson <jmattson@google.com> writes:
>>
>> > On Tue, Jun 16, 2020 at 9:14 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> >>
>> >> state_test/smm_test selftests are failing on AMD with:
>> >> "Unexpected result from KVM_GET_MSRS, r: 51 (failed MSR was 0x345)"
>> >>
>> >> MSR_IA32_PERF_CAPABILITIES is an emulated MSR indeed but only on Intel,
>> >> make svm_has_emulated_msr() skip it so it is not returned by
>> >> KVM_GET_MSR_INDEX_LIST.
>> >
>> > Do we need to support this MSR under SVM for cross-vendor migration?
>> > Or, have we given up on that?
>>
>> To be honest I'm not sure about the status of cross-vendor migration in
>> general and PMU implications in particular, hope Paolo/Sean can shed
>> some light. In this particular case my shallow understanding is that
>> MSR_IA32_PERF_CAPABILITIES has only one known feature bit which unlocks
>> an MSR range with additional counters. If the feature bit is not set
>> this, I guess, can easily be migrated (basically, let's allow writing
>> '0' there on AMD and return '0' on read). But what if the feature was
>> enabled? We'll have to support the new MSR range and do something with
>> it after migration (run intel_pmu in fully emulated mode?).
>>
>> Anyway, the immediate issue I'm trying to fix here is: whatever is
>> returned by KVM_GET_MSR_INDEX_LIST can be successfully queried with
>> KVM_GET_MSRS as some userspaces count on that.
>
> That's a nice property. Is it documented somewhere?
>

Hm, good question.

Documentation/virt/kvm/api.rst says:

"KVM_GET_MSR_INDEX_LIST returns the guest msrs that are supported.  The list
varies by kvm version and host processor, but does not change otherwise.

[...]

KVM_GET_MSR_FEATURE_INDEX_LIST returns the list of MSRs that can be passed
to the KVM_GET_MSRS system ioctl.  This lets userspace probe host capabilities
and processor features that are exposed via MSRs (e.g., VMX capabilities)."

Side note: MSR_IA32_PERF_CAPABILITIES can be returned by both
KVM_GET_MSR_INDEX_LIST and KVM_GET_MSR_FEATURE_INDEX_LIST as we have it
both as an emulated MSR filtered by kvm_x86_ops.has_emulated_msr() and
a feature msr filtered by kvm_x86_ops.get_msr_feature(). But the later
is a whitelist so MSR_IA32_PERF_CAPABILITIES won't appear on AMD and the
promise "can be passed to the KVM_GET_MSRS" is kept.

For KVM_GET_MSR_INDEX_LIST, the promise is "guest msrs that are
supported" and I'm not exactly sure what this means. Personally, I see
no point in returning MSRs which can't be read with KVM_GET_MSRS (as
this also means the guest can't read them) and KVM selftests seem to
rely on that (vcpu_save_state()) but this is not a documented feature.

> Reviewed-by: Jim Mattson <jmattson@google.com>
>

Thanks!

-- 
Vitaly

