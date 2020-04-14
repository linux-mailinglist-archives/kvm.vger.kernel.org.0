Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5F01A7FD1
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 16:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390915AbgDNObO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 10:31:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48340 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729113AbgDNObI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 10:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586874666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xZmkVkXAW7PlY3ih7mA62QKfHXYAEVe9Qe6KO9vdPhk=;
        b=RfkwAL9c5XUxfdZFIIUp3WTfAIpbgXyQp3Qgsm5BNeBmCxS3gijm6GMpWeqi7zMdMhpKat
        ppMmyJb8RmDmQGTHRTeKBsTQ7QvhdvejP0KwKKal/mjBr4bhz4+JwTOTX1+LW3ez+7RQ8p
        FGa+su3yt2zlGfL2iJADdyD5fMSEZJk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-V7OTpAGSPsmSmeyof_lZlw-1; Tue, 14 Apr 2020 10:31:02 -0400
X-MC-Unique: V7OTpAGSPsmSmeyof_lZlw-1
Received: by mail-wr1-f72.google.com with SMTP id f2so342103wrm.9
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 07:31:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xZmkVkXAW7PlY3ih7mA62QKfHXYAEVe9Qe6KO9vdPhk=;
        b=KHaqV+fJR12nx8eqcMCbhkWLLfvZet1mqGl/iHhtpHXenSH7oT61sx9Po4VM1n4KKz
         EDZfHq+r+mFKLLZLrPCu4GEFtcXSJgpXnn/ESg7ZUBJx/ytcgAS7MeEc147/AiW3QDLZ
         LW514d0IUy9EKynMetW2iAbbe36DwJPDyMTLI3/WCVTcba4xZK4FQpKJXvoTIRkCSMki
         X1ijllbY6ZfpAlp8d6zA8eoUgmaP1CrQMNBhI7Ku8i4u7TF4L3gq/ztHY98QtDKT2UzE
         FnTZtLEX9fPV5G74kdHORGFCG9DH0GD5m1hv2EOs6fr9DC/iveltySRK3DymhziKHiGH
         bitA==
X-Gm-Message-State: AGi0PuZ+DCs45JaoOFbS05z7yYzhLOihRIVdxCNuAe03Ay5x36JuiMgj
        sz1MDlvnlPX6XBneIKv+UDBHnAR5CS/0kL/goL0pt0aZfkjTkpHsdXBpySF83R36s3ki3kn0a72
        KYbNuLQ7HT3CY
X-Received: by 2002:a1c:1b88:: with SMTP id b130mr138753wmb.75.1586874661511;
        Tue, 14 Apr 2020 07:31:01 -0700 (PDT)
X-Google-Smtp-Source: APiQypKfXV3C3rclZA6ZOeRqaxd3IhCdvtd1fxlZcL6oNwDNcKsrB7m3/BlImNL9rzWECgk4aGgfjQ==
X-Received: by 2002:a1c:1b88:: with SMTP id b130mr138730wmb.75.1586874661276;
        Tue, 14 Apr 2020 07:31:01 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h17sm7465876wmm.6.2020.04.14.07.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 07:31:00 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests] ioapic-split: fix hang, run with -smp 4
In-Reply-To: <20200414141147.13028-1-pbonzini@redhat.com>
References: <20200414141147.13028-1-pbonzini@redhat.com>
Date:   Tue, 14 Apr 2020 16:30:59 +0200
Message-ID: <873696yw9o.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> The test_ioapic_physical_destination_mode uses destination id 1, so it
> cannot be run with only one processor.  Fixing that however shows that
> the self-reconfiguration test is broken with split irqchip.  This should
> be fixed in QEMU.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  x86/ioapic.c      | 3 ++-
>  x86/unittests.cfg | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/x86/ioapic.c b/x86/ioapic.c
> index 3106531..ad0b47d 100644
> --- a/x86/ioapic.c
> +++ b/x86/ioapic.c
> @@ -504,11 +504,12 @@ int main(void)
>  	test_ioapic_level_tmr(true);
>  	test_ioapic_edge_tmr(true);
>  
> -	test_ioapic_physical_destination_mode();
>  	if (cpu_count() > 3)
>  		test_ioapic_logical_destination_mode();
>  
>  	if (cpu_count() > 1) {
> +		test_ioapic_physical_destination_mode();
> +
>  		test_ioapic_edge_tmr_smp(false);
>  		test_ioapic_level_tmr_smp(false);
>  		test_ioapic_level_tmr_smp(true);
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index d658bc8..a4df06b 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -33,7 +33,8 @@ arch = x86_64
>  
>  [ioapic-split]
>  file = ioapic.flat
> -extra_params = -cpu qemu64 -machine kernel_irqchip=split
> +smp = 4
> +extra_params = -cpu qemu64,+x2apic -machine kernel_irqchip=split
>  arch = x86_64

Thank you but this particular change causes the test to start failing for me:

timeout -k 1s --foreground 90s /usr/libexec/qemu-kvm --no-reboot -nodefaults -device pc-testdev -device isa-debug-exit,iobase=0xf4,iosize=0x4 -vnc none -serial stdio -device pci-testdev -machine accel=kvm -kernel x86/ioapic.flat -smp 4 -cpu qemu64,+x2apic -machine kernel_irqchip=split # -initrd /tmp/tmp.OcMOvh1e7x
enabling apic
enabling apic
enabling apic
enabling apic
paging enabled
cr0 = 80010011
cr3 = 61d000
cr4 = 20
x2apic enabled
PASS: version register read only test
PASS: id register only bits [24:27] writable
PASS: arbitration register set by id
PASS: arbtration register read only
PASS: edge triggered intr
PASS: level triggered intr
PASS: ioapic simultaneous edge interrupts
PASS: coalesce simultaneous level interrupts
PASS: sequential level interrupts
PASS: retriggered level interrupts without masking
PASS: masked level interrupt
PASS: unmasked level interrupt
PASS: masked level interrupt
PASS: unmasked level interrupt
PASS: retriggered level interrupts with mask
PASS: TMR for ioapic edge interrupts (expected false)
PASS: TMR for ioapic level interrupts (expected false)
PASS: TMR for ioapic level interrupts (expected true)
PASS: TMR for ioapic edge interrupts (expected true)
PASS: ioapic logical destination mode
PASS: ioapic physical destination mode
1001569 iterations before interrupt received
PASS: TMR for ioapic edge interrupts (expected false)
1010633 iterations before interrupt received
PASS: TMR for ioapic level interrupts (expected false)
1022574 iterations before interrupt received
PASS: TMR for ioapic level interrupts (expected true)
1010590 iterations before interrupt received
PASS: TMR for ioapic edge interrupts (expected true)
FAIL: Reconfigure self
SUMMARY: 26 tests, 1 unexpected failures

>  
>  [apic]

-- 
Vitaly

