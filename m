Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091704900CD
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 05:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbiAQE06 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jan 2022 23:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbiAQE05 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jan 2022 23:26:57 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD5CC061574
        for <kvm@vger.kernel.org>; Sun, 16 Jan 2022 20:26:56 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso28998027pjo.5
        for <kvm@vger.kernel.org>; Sun, 16 Jan 2022 20:26:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:organization:subject:in-reply-to
         :content-transfer-encoding;
        bh=a9R+NFSR0asBkn+WpnzkjkH55mHlGYIWxT500OjJjJ0=;
        b=VnCh3YuvC/9CcDwRtRO9UZYNoL1C0iXmyc0G77oxwZgMaT0tCL3EwiCH4qOiyCzYA4
         958p/6G+3UxjEFpiOVXNmZToTGCjd034IagVgjdoFcW1GaOwugN2rrqTk5M/6x9qQUKJ
         Bb7rwpTKHcCxd89EHNcm0f8OKp0ARZS5tLdj/aaJ05yFKZazBwpuKFzEMu7Gyj4x0XVZ
         +8JIGDURrSS7v/jBz+RZMZ012ebt2xfVC7jjA4IY2A0cIvNP5flSs5+0Alb/VtfBE3D2
         0Y6mCzxMzGKF/SeHdhRvKAYJ9bf0VVk5gbUA+VKnsIvmDiu9fdbn+Mxibml83mcdVlq+
         Cnbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=a9R+NFSR0asBkn+WpnzkjkH55mHlGYIWxT500OjJjJ0=;
        b=adCpHiVncryWQih6AQxpRmxdKmmkoQ19gtwW/CcM+kqqv//FrQ4HXUEkdLTJPm3qO+
         QbksVX9DZcpGC9tAyBdsHtUIjyN8TtyedrkbQ4WbskFefBT4F0XbpNZmEY2zb5LPWmMl
         OcdhkhB9gts3ep7oT0FF/t6ImMNvhfX1hB60wd4W06zR30iYGBTl9+iBWAMDVxUZtwJD
         MkXDTu0MpZ3kZ4WrJNc9G0LmXLgPhhYRHl4/YVv9v21emia6f7KQFmdbntqbUkxHFoUl
         DEmcgq28rz5WCvku4n9/BW7YQsO4DYtwmU0LdmXfj0pHkhGs8MW9n9953g3cjThPXTyR
         qFFA==
X-Gm-Message-State: AOAM531qGBgmrd7mQbKd5kP8Mkk1+ywzFD9E/L75UwlZ2i0ukfBSnxAj
        +fatVYhItYNpeNKh8KvnowA=
X-Google-Smtp-Source: ABdhPJx9JqZcOonyS9qNXICZDFRbTGulwQr9mDFz/tggqfOWCc7n1mMxIhCbm4+Nyai0/cByS44TSg==
X-Received: by 2002:a17:902:ce8d:b0:14a:70dc:2050 with SMTP id f13-20020a170902ce8d00b0014a70dc2050mr20824467plg.11.1642393616338;
        Sun, 16 Jan 2022 20:26:56 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z3sm10923570pjq.32.2022.01.16.20.26.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Jan 2022 20:26:55 -0800 (PST)
Message-ID: <453a2a09-5f29-491e-c386-6b23d4244cc2@gmail.com>
Date:   Mon, 17 Jan 2022 12:26:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        kvm list <kvm@vger.kernel.org>
References: <CALMp9eQZa_y3ZN0_xHuB6nW0YU8oO6=5zPEov=DUQYPbzLeQVA@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
Subject: Re: PMU virtualization and AMD erratum 1292
In-Reply-To: <CALMp9eQZa_y3ZN0_xHuB6nW0YU8oO6=5zPEov=DUQYPbzLeQVA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/1/2022 4:02 am, Jim Mattson wrote:
>  From AMD erratum 1292:

I see quite a few errata in AMD's products in terms of PMU counters.

Considering the number of this type of machines in real world,
there is a real need to think about it. Thanks for pointing out.

> 
> The processor may experience sampling inaccuracies that cause the
> following performance counters to overcount retire-based events.
>   • PMCx0C0 [Retired Instructions]
>   • PMCx0C1 [Retired Uops]
>   • PMCx0C2 [Retired Branch Instructions]
>   • PMCx0C3 [Retired Branch Instructions Mispredicted]
>   • PMCx0C4 [Retired Taken Branch Instructions]
>   • PMCx0C5 [Retired Taken Branch Instructions Mispredicted]
>   • PMCx0C8 [Retired Near Returns]
>   • PMCx0C9 [Retired Near Returns Mispredicted]
>   • PMCx0CA [Retired Indirect Branch Instructions Mispredicted]
> • PMCx0CC [Retired Indirect Branch Instructions]
>   • PMCx0D1 [Retired Conditional Branch Instructions]
>   • PMCx1C7 [Retired Mispredicted Branch Instructions due to Direction Mismatch]
>   • PMCx1D0 [Retired Fused Branch Instructions]
> 
> The recommended workaround is:

Or to set the BIOS Setup Option "IBS hardware workaround."
(not recommended for production due to negative performance impact)

> 
> To count the non-FP affected PMC events correctly:
>   • Use Core::X86::Msr::PERF_CTL2 to count the events, and
>   • Program Core::X86::Msr::PERF_CTL2[43] to 1b, and
>   • Program Core::X86::Msr::PERF_CTL2[20] to 0b.

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 12d8b301065a..6a7638043066 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -18,6 +18,13 @@
  #include "pmu.h"
  #include "svm.h"

+/* AMD erratum 1292 */
+static inline bool cpu_overcount_retire_events(struct kvm_vcpu *vcpu)
+{
+	return guest_cpuid_family(vcpu) == 0x19 &&
+		guest_cpuid_model(vcpu) < 0x10;
+}
+
  enum pmu_type {
  	PMU_TYPE_COUNTER = 0,
  	PMU_TYPE_EVNTSEL,
@@ -252,6 +259,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct 
msr_data *msr_info)
  	struct kvm_pmc *pmc;
  	u32 msr = msr_info->index;
  	u64 data = msr_info->data;
+	u64 reserved_bits = pmu->reserved_bits;

  	/* MSR_PERFCTRn */
  	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_COUNTER);
@@ -264,7 +272,9 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct 
msr_data *msr_info)
  	if (pmc) {
  		if (data == pmc->eventsel)
  			return 0;
-		if (!(data & pmu->reserved_bits)) {
+		if (pmc->idx == 2 && cpu_overcount_retire_events(vcpu))
+			reserved_bits &= ~BIT_ULL(43);
+		if (!(data & reserved_bits)) {
  			reprogram_gp_counter(pmc, data);
  			return 0;
  		}

> 
> It's unfortunate that kvm's PMU virtualization completely circumvents
> any attempt to employ the recommended workaround. Admittedly, bit 43
> is "reserved," and it would be foolish for a hypervisor to let a guest
> set a reserved bit in a host MSR. 

It's easy for KVM to clear the reserved bit PERF_CTL2[43]
for only (AMD Family 19h Models 00h-0Fh) guests.

Obviously, such guests need to be updated and the reserved bit can
be accessed safely. Don't worry about the legacy guest, see below.

> But, even the first recommendation
> is impossible under KVM, because the host's perf subsystem actually
> decides which hardware counter is going to be used, regardless of what
> the guest asks for.

First, the host perf subsystem needs to be patched to implement this workaround.
  (AMD guys have been notified)

The patched host perf will schedule all retire events to counter 2 as long as
the requested event_select and unit_mask are matched in the workaround table.

It works for both host-created perf_events and KVM-created perf_events, so that
all legacy (retire event) guests counters will use the specific host counter 2 and,
the sampling (w/o host counter multiplexing) will be kept accurate.

> 
> Am I the only one bothered by this?
With this workaround, it is easier to trigger multiplexing, which the guest
does not correctly perceive even now.
