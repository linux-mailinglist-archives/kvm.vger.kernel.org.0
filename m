Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E550D2AD225
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 10:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731831AbgKJJKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 04:10:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26251 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729981AbgKJJKN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 04:10:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604999411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+55BzpmQdaW+9dk/S8pTQyoYyuBDmPULs813Spez7Dk=;
        b=fvLEc1XkvSr7jobAFrfrekMZATvGeyU7hc/xpy8g1Q5t/uIFUP/inOx2UDyvsFtss8sPPQ
        KUIYbO1NSyrvXI/BGq/MWqUHAhdelJg00bEyFRu34AHosoJuw/SybW4DYPHIXwy7v0R41Z
        zYfAfZVPw8abc0jzbBzaG6UeIGy8Y0M=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-0Adw_uD6OcedKV-DzOIXMA-1; Tue, 10 Nov 2020 04:10:07 -0500
X-MC-Unique: 0Adw_uD6OcedKV-DzOIXMA-1
Received: by mail-ej1-f70.google.com with SMTP id dx19so4461238ejb.7
        for <kvm@vger.kernel.org>; Tue, 10 Nov 2020 01:10:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+55BzpmQdaW+9dk/S8pTQyoYyuBDmPULs813Spez7Dk=;
        b=h4CtXMkQguxh5dnLrL1OwDsG8QFmGUwuTPYr+KU9gyvWSzucEd2G4XaG3jcvpAqGRi
         iUU7OBhxoAN+Z203t7dI/AMsBAC7Hb35XhrLuFF8afzkh21Qj1cYiuQ5jwf96f78rqIY
         8KSDxHFzgfHkbIRvFxIMb12GmrZv6eC8RNjjRr6XadbLLgFmreMq9I1764+D+ce+q8jn
         NWRtxzEG1WrW+9uoWDAQJrsi+AUzzJ84Ox45Oio5hh9gMt4ZDvsbsF5ORp+Lf1SXo8W9
         A3wJ7znmqi0qaaVJHhk3lyK5zfg49XzmAFHsH9qyRTEHw5bhqAaC2/cfwMcTevIlGYDe
         SYyw==
X-Gm-Message-State: AOAM530eNKRR4uT4SqWCME+Faxw4nwE3H/CuYt4XWWyXxuX7edMmYvar
        MHlxH2NGg0zkKiuG4kM7AcssLXxOKzxNE04yxvhifg/l29FV/Q9ky/EGfGsaBe4In5Ndy9XdhFz
        wHWTjdWwiLC1VHkRF7TDIGX3Fuo+12mVfEc+lW/gB3DHerxuU7XV7TaR+Gslfp//P
X-Received: by 2002:a17:906:4145:: with SMTP id l5mr18623725ejk.317.1604999405830;
        Tue, 10 Nov 2020 01:10:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx/+w8n2wbjnx32/4llcLMexaLP6alYitnqhFSTv2Dgca7bmGE28PeBxrSq2lRzJ92id0/3Sw==
X-Received: by 2002:a17:906:4145:: with SMTP id l5mr18623695ejk.317.1604999405498;
        Tue, 10 Nov 2020 01:10:05 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g25sm9998041ejh.61.2020.11.10.01.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 01:10:04 -0800 (PST)
To:     "Luck, Tony" <tony.luck@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Qian Cai <cai@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tip-commits@vger.kernel.org" 
        <linux-tip-commits@vger.kernel.org>, Boris Petkov <bp@alien8.de>,
        Borislav Petkov <bp@suse.de>, x86 <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20201030190807.GA13884@agluck-desk2.amr.corp.intel.com>
 <160431588828.397.16468104725047768957.tip-bot2@tip-bot2>
 <3f863634cd75824907e8ccf8164548c2ef036f20.camel@redhat.com>
 <bfc274fc27724ea39ecac1e7ac834ed8@intel.com>
 <CALMp9eTFaiYkTnVe8xKzg40E4nZ3rAOii0O06bTy0+oLNjyKhA@mail.gmail.com>
 <a22b5468e1c94906b72c4d8bc83c0f64@intel.com>
 <CALMp9eS+SYmPP3OzdK0-Bs1wSBJ4MU_POZe3i5fi3Fd+FTshYw@mail.gmail.com>
 <bece344ae6944368bf5a9a60e9145bd4@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [tip: ras/core] x86/mce: Enable additional error logging on
 certain Intel CPUs
Message-ID: <03cfc157-efac-ac4a-2924-d455f29e6ecd@redhat.com>
Date:   Tue, 10 Nov 2020 10:10:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <bece344ae6944368bf5a9a60e9145bd4@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> Maybe no contract ... but a bunch of places (many of them in Intel
> specific code) that check for it

Interestingly, quite a few of them are actually checking for HYPERVISOR 
not because of missing hypervisor features, but rather because 
hypervisors don't have to work around certain errata. :)

Full analysis after my sig, but tl;dr: the only case of using HYPERVISOR 
before using MSRs are in arch/x86/events/intel/cstate.c and 
arch/x86/events/intel/uncore.c.  There are some workarounds in 
drivers/gpu that might fall into a similar bucket.  But as far as MSRs 
go, the way to go  overwhelmingly seems to be {rd,wr}msrl_safe.

Thanks,

Paolo

On 10/11/20 00:36, Luck, Tony wrote:
> arch/x86/events/core.c: if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {

Print a slightly less frightening warning.

> arch/x86/events/intel/core.c:   if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))

Working around KVM's ignore_msrs=1 option (and quite ugly; shows that 
the option shouldn't be enabled by default).

> arch/x86/events/intel/core.c:           int assume = 3 * !boot_cpu_has(X86_FEATURE_HYPERVISOR);

Seems unnecessary.

> arch/x86/events/intel/cstate.c: if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
> arch/x86/events/intel/uncore.c: if (boot_cpu_has(X86_FEATURE_HYPERVISOR))

Too complicated. :)

> arch/x86/kernel/apic/apic.c:    if (boot_cpu_has(X86_FEATURE_HYPERVISOR))

Hypervisors don't have errata.

> arch/x86/kernel/cpu/bugs.c:     if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
> arch/x86/kernel/cpu/bugs.c:     else if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
> arch/x86/kernel/cpu/bugs.c:     if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
> arch/x86/kernel/cpu/bugs.c:     if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
> arch/x86/kernel/cpu/intel.c:    if (boot_cpu_has(X86_FEATURE_HYPERVISOR))

Print different vulnerability status in sysfs.

> arch/x86/kernel/cpu/mshyperv.c: if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
> arch/x86/kernel/cpu/vmware.c: * If !boot_cpu_has(X86_FEATURE_HYPERVISOR), vmware_hypercall_mode
> arch/x86/kernel/cpu/vmware.c:   if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {
> arch/x86/kernel/jailhouse.c:        !boot_cpu_has(X86_FEATURE_HYPERVISOR))
> arch/x86/kernel/kvm.c:  if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
> arch/x86/kernel/paravirt.c:     if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))

Obviously needed before using paravirt features of the hypervisor.

> arch/x86/kernel/tsc.c:  if (boot_cpu_has(X86_FEATURE_HYPERVISOR) ||

Disables ART in VMs.  Probably the idea is that ART does not have an 
offset field similar to the TSC's, but it's not necessary.  Looking at 
the hypervisor-provided CPUID should be enough.

> arch/x86/mm/init_64.c:  if (!boot_cpu_has(X86_FEATURE_HYPERVISOR)) {

Tweaks hotplug heuristics, no MSRs involved.

> drivers/acpi/processor_idle.c:  if (boot_cpu_has(X86_FEATURE_HYPERVISOR))

Avoids pointless hypervisor exit on idle (i.e. just an optimization).

> drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h:       return boot_cpu_has(X86_FEATURE_HYPERVISOR);

Work around SR-IOV bugs.

> drivers/gpu/drm/i915/i915_memcpy.c:         !boot_cpu_has(X86_FEATURE_HYPERVISOR))

Work around KVM deficiency.

> drivers/gpu/drm/radeon/radeon_device.c: return boot_cpu_has(X86_FEATURE_HYPERVISOR);

Work around SR-IOV bugs.

> drivers/visorbus/visorchipset.c:        if (boot_cpu_has(X86_FEATURE_HYPERVISOR)) {

Needed before using paravirt features of the hypervisor.

