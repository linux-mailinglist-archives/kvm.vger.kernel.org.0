Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C78B7B2215
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 18:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjI1QSd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 12:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjI1QSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 12:18:32 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE67CD6
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:18:30 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59f53027158so206323007b3.0
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 09:18:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695917910; x=1696522710; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lx0LHhoF1CLP/2ScaDiDyGhwP/K44aOA2tVMQdFRAvg=;
        b=ZkWHApip3fZtvhYlbxd81vwFXcSfz5e/UGLfhTIyfFiphJ/HkNLZnUUjjPAJSoQ0g3
         U3zMB8XHo2sGyDSzRGlpUxyYRrI5uA5jn02Zozp2q8AxZswiKlJVt8Q7te+JN0HpsX6H
         1MQSPTfa2peejJGulY6V4CwEtmOjPv6vuiHv1qwl7rgh36td6V/32bPoN/Hwis58Rq9V
         yCNfU20inPw050lKpCk5v392FGNukdOe0DE8F/fYnJmMPclRdknHtqagtEbmwj4vCXvk
         ttEXYXMMdWcP/J+UkFzEiDHpEYHnxVtDqCRwlkQ2sKg2aLWXC4C9vgGEiqFaM6RIbbI0
         N64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695917910; x=1696522710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lx0LHhoF1CLP/2ScaDiDyGhwP/K44aOA2tVMQdFRAvg=;
        b=i4k08QYKvexMbDI8wXGJV9R3b38mjE2IsNtKwfxWuOMgWZzs/yit6ieaqnVjoqtqMv
         qx8macOblh3ZNwKkhIXKJt7AwF44MKhhlWOYt0GW89JiWHgHk0HUTAW5z36PgaULr7dt
         SHl1x+IdLVemKhQ2d49Df15a5Bbap/g9ZlMZ2m5MHnVRp76v8se8HD9ijJ1LICuZU4kH
         +ynGBrFLVjt5ximiGKY4fVLt5IYHcIXtNMP0OoObF9dMuXAyqoS/CrtCY+AZ1e99apnT
         vwwaQEEdAQVYGALRVKRse9iqeuJFDFD+IAvV2gTQTjwG/M1s6Pnkv3xaquenTkEj1ABP
         0Zfg==
X-Gm-Message-State: AOJu0YxbshWGpF+2po+8Ce4Hajrrvp6et0MggmIIhi1+TLLhUmR8hhfg
        0QRncR7doOGV3C57ys2pIW92Q3Jlgcw=
X-Google-Smtp-Source: AGHT+IH8ZewFxNVrH8u/ZhVOsOCiRR3+vCKX9N+TblHtoR4BkJwWdMGuokmyWJcqmK8xQ4ZRKfcujxc0k1k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ca52:0:b0:59b:e669:c944 with SMTP id
 y18-20020a81ca52000000b0059be669c944mr29551ywk.3.1695917909968; Thu, 28 Sep
 2023 09:18:29 -0700 (PDT)
Date:   Thu, 28 Sep 2023 09:18:28 -0700
In-Reply-To: <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
Mime-Version: 1.0
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
 <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com> <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
Message-ID: <ZRWnVDMKNezAzr2m@google.com>
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock periodically
From:   Sean Christopherson <seanjc@google.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     Joe Jin <joe.jin@oracle.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023, Dongli Zhang wrote:
> Hi Joe,
> 
> On 9/26/23 17:29, Joe Jin wrote:
> > On 9/26/23 4:06 PM, Dongli Zhang wrote:
> >> This is to minimize the kvmclock drift during CPU hotplug (or when the
> >> master clock and pvclock_vcpu_time_info are updated).

Updated by who?

> >> Since kvmclock and raw monotonic (clocksource_tsc) use different
> >> equation/mult/shift to convert the tsc to nanosecond, there may be clock
> >> drift issue during CPU hotplug (when the master clock is updated).

Based on #4, I assume you mean "vCPU hotplug from the host", but from this and
the above it's not clear if this means "vCPU hotplug from the host", "pCPU hotplug
in the host", or "CPU hotplug in the guest".

> >> 1. The guest boots and all vcpus have the same 'pvclock_vcpu_time_info'
> >> (suppose the master clock is used).
> >>
> >> 2. Since the master clock is never updated, the periodic kvmclock_sync_work
> >> does not update the values in 'pvclock_vcpu_time_info'.
> >>
> >> 3. Suppose a very long period has passed (e.g., 30-day).
> >>
> >> 4. The user adds another vcpu. Both master clock and
> >> 'pvclock_vcpu_time_info' are updated, based on the raw monotonic.

So why can't KVM simply force a KVM_REQ_MASTERCLOCK_UPDATE request when a vCPU
is added?  I'm missing why this needs a persistent, periodic refresh.

> >> @@ -157,6 +157,9 @@ module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
> >>  static bool __read_mostly kvmclock_periodic_sync = true;
> >>  module_param(kvmclock_periodic_sync, bool, S_IRUGO);
> >>  
> >> +unsigned int __read_mostly masterclock_sync_period;
> >> +module_param(masterclock_sync_period, uint, 0444);
> > 
> > Can the mode be 0644 and allow it be changed at runtime?
> 
> It can be RW.
> 
> So far I just copy from kvmclock_periodic_sync as most code are from the
> mechanism of kvmclock_periodic_sync.
> 
> static bool __read_mostly kvmclock_periodic_sync = true;
> module_param(kvmclock_periodic_sync, bool, S_IRUGO);

Unless there's a very good reason for making it writable, I vote to keep it RO
to simplify the code.

> >>  /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
> >>  static u32 __read_mostly tsc_tolerance_ppm = 250;
> >>  module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
> >> @@ -3298,6 +3301,31 @@ static void kvmclock_sync_fn(struct work_struct *work)
> >>  					KVMCLOCK_SYNC_PERIOD);
> >>  }
> >>  
> >> +static void masterclock_sync_fn(struct work_struct *work)
> >> +{
> >> +	unsigned long i;
> >> +	struct delayed_work *dwork = to_delayed_work(work);
> >> +	struct kvm_arch *ka = container_of(dwork, struct kvm_arch,
> >> +					   masterclock_sync_work);
> >> +	struct kvm *kvm = container_of(ka, struct kvm, arch);
> >> +	struct kvm_vcpu *vcpu;
> >> +
> >> +	if (!masterclock_sync_period)

This function should never be called if masterclock_sync_period=0.  The param
is RO and so kvm_arch_vcpu_postcreate() shouldn't create the work in the first
place.

> >> +		return;
> >> +
> >> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> >> +		/*
> >> +		 * It is not required to kick the vcpu because it is not
> >> +		 * expected to update the master clock immediately.
> >> +		 */

This comment needs to explain *why* it's ok for vCPUs to lazily handle the
masterclock update.  Saying "it is not expected" doesn't help understand who/what
expects anything, or why.

> >> +		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
> >> +	}
> >> +
> >> +	schedule_delayed_work(&ka->masterclock_sync_work,
> >> +			      masterclock_sync_period * HZ);
> >> +}
