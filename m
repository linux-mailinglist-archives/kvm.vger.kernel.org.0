Return-Path: <kvm+bounces-5092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 638BB81BC5A
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 17:52:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D16001F22B4A
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 16:52:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C59B55822C;
	Thu, 21 Dec 2023 16:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NONTj3wk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63003539FC
	for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 16:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703177516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aHqJPJAOf0GL5IdgO/S47p+QBIRa9U0yIstdvJdBIFM=;
	b=NONTj3wkxD20tvGLPsLw7p5br8h9ZjRVp12zslGBnyI7q9wHTWBJd0jiD0fDRvMPBzCZPT
	rUKIFOKYMuUpKW1k5p1Xl5Oz09SrbJnB249by0bWuHEelKDSyG8lzrxet+nbupD2kOBA7k
	+ynJgQ+gAaT3K0Iz+ixHYYoovi6bYjk=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-XMAmcGsdP_WIS1s5eanpig-1; Thu, 21 Dec 2023 11:51:54 -0500
X-MC-Unique: XMAmcGsdP_WIS1s5eanpig-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-a233627e8a5so51159266b.1
        for <kvm@vger.kernel.org>; Thu, 21 Dec 2023 08:51:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703177513; x=1703782313;
        h=content-transfer-encoding:mime-version:user-agent:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aHqJPJAOf0GL5IdgO/S47p+QBIRa9U0yIstdvJdBIFM=;
        b=pSbgHc3t58nhWyWTf1SA4/BDaxU0drOR2RCk/rIxxLkzF0yhibvGdFXAQue9iVmZAM
         J67leW6CKlCGTVPG3696IWpkbCi8yum0ugAyTwwdi+S46UQkkhJ2+iU331AvG8TyiNG7
         sLi+pvbH80AJgi7V//RqnJShF+UZAdAy41/2oAhVE1dXVhT/7Wgw8MrTY5lGPEyB42wq
         1AL9bLyJ4cNZEMXwPkD8Mmv7Fae8MjNduEzEHYXjjT+Fxo4UHRmZaGfxFnfZIaWfOfy8
         oyygkFsXuDrEAbiN1pJaCHNbiwK/F6JhGlqwfAhGRMB+pt7pRE49X0IGN1DxWxRBGsQ/
         EfvQ==
X-Gm-Message-State: AOJu0YwoxehUtZE77JF8rZPmcLFoJECRJox0M92jNgWBX/6vNeqH6zuO
	7FKq5ttMgXbE2VlG/zwkKNCx2LeYrPW4uHLF3axvoE4i2+UR8l5NCUZkj4bWK9EKLey4bvqY10p
	97zeRPCYB9WnJ5wvj4l+awFTgY3xEAmjOIiuyTriFTL4EKi8lVVZlQHlDgYAZ3+bT2h2BV3U2Fn
	tWYow1
X-Received: by 2002:a17:907:60ce:b0:a26:9347:3742 with SMTP id hv14-20020a17090760ce00b00a2693473742mr68877ejc.44.1703177512902;
        Thu, 21 Dec 2023 08:51:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFft57U0e/9Bbycl0J1udwfBv2uk6W7Jgh5m0CH7woXCnHBBgMq4T2llOxzQf9+QluN0hQA1w==
X-Received: by 2002:a17:907:60ce:b0:a26:9347:3742 with SMTP id hv14-20020a17090760ce00b00a2693473742mr68862ejc.44.1703177512444;
        Thu, 21 Dec 2023 08:51:52 -0800 (PST)
Received: from starship ([77.137.131.62])
        by smtp.gmail.com with ESMTPSA id mf17-20020a1709071a5100b00a26aa5c5a60sm642425ejc.19.2023.12.21.08.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Dec 2023 08:51:52 -0800 (PST)
Message-ID: <20c9c21619aa44363c2c7503db1581cb816a1c0f.camel@redhat.com>
Subject: RFC: NTP adjustments interfere with KVM emulation of TSC deadline
 timers
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>,  Marc Zyngier <maz@kernel.org>, Thomas Gleixner
 <tglx@linutronix.de>, Vitaly Kuznetsov <vkuznets@redhat.com>
Date: Thu, 21 Dec 2023 18:51:50 +0200
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


Hi!

Recently I was tasked with triage of the failures of 'vmx_preemption_timer' 
that happen in our kernel CI pipeline.


The test usually fails because L2 observes TSC after the 
preemption timer deadline, before the VM exit happens.

This happens because KVM emulates nested preemption timer with HR timers, 
so it converts the preemption timer value to nanoseconds, taking in account
tsc scaling and host tsc frequency, and sets HR timer.

HR timer however as I found out the hard way is bound to CLOCK_MONOTONIC, 
and thus its rate can be adjusted by NTP, which means that it can run slower or 
faster than KVM expects, which can result in the interrupt arriving earlier,
or late, which is what is happening.

This is how you can reproduce it on an Intel machine:


1. stop the NTP daemon: 
      sudo systemctl stop chronyd.service
2. introduce a small error in the system time:
      sudo date -s "$(date)"

3. start NTP daemon:
      sudo chronyd -d -n  (for debug) or start the systemd service again

4. run the vmx_preemption_timer test a few times until it fails:


I did some research and it looks like I am not the first to encounter this:

From the ARM side there was an attempt to support CLOCK_MONOTONIC_RAW with
timer subsystem which was even merged but then reverted due to issues:

https://lore.kernel.org/all/1452879670-16133-3-git-send-email-marc.zyngier@arm.com/T/#u

It looks like this issue was later worked around in the ARM code:


commit 1c5631c73fc2261a5df64a72c155cb53dcdc0c45
Author: Marc Zyngier <maz@kernel.org>
Date:   Wed Apr 6 09:37:22 2016 +0100

    KVM: arm/arm64: Handle forward time correction gracefully
    
    On a host that runs NTP, corrections can have a direct impact on
    the background timer that we program on the behalf of a vcpu.
    
    In particular, NTP performing a forward correction will result in
    a timer expiring sooner than expected from a guest point of view.
    Not a big deal, we kick the vcpu anyway.
    
    But on wake-up, the vcpu thread is going to perform a check to
    find out whether or not it should block. And at that point, the
    timer check is going to say "timer has not expired yet, go back
    to sleep". This results in the timer event being lost forever.
    
    There are multiple ways to handle this. One would be record that
    the timer has expired and let kvm_cpu_has_pending_timer return
    true in that case, but that would be fairly invasive. Another is
    to check for the "short sleep" condition in the hrtimer callback,
    and restart the timer for the remaining time when the condition
    is detected.
    
    This patch implements the latter, with a bit of refactoring in
    order to avoid too much code duplication.
    
    Cc: <stable@vger.kernel.org>
    Reported-by: Alexander Graf <agraf@suse.de>
    Reviewed-by: Alexander Graf <agraf@suse.de>
    Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
    Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>


So to solve this issue there are two options:


1. Have another go at implementing support for CLOCK_MONOTONIC_RAW timers. 
   I don't know if that is feasible and I would be very happy to hear a feedback from you.

2. Also work this around in KVM. KVM does listen to changes in the timekeeping system
  (kernel calls its update_pvclock_gtod), and it even notes rates of both regular and raw clocks.

  When starting a HR timer I can adjust its period for the difference in rates, which will in most
  cases produce more correct result that what we have now, but will still fail if the rate
  is changed at the same time the timer is started or before it expires.
  
  Or I can also restart the timer, although that might cause more harm than
  good to the accuracy.


What do you think?


Best regards,
	Maxim Levitsky



