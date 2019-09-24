Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA5BBC89A
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 15:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389496AbfIXNKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 09:10:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34788 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730009AbfIXNKg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 09:10:36 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 381CA46288
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 13:10:36 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id t11so548482wrq.19
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 06:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q0MJSSKSV6Cq9kr0Fbr8b6Bqd4XX1IZh6fNcOtMVgFA=;
        b=E6vh3kbiIShMK8YpjLEWt0dqqe+kwLrJAJ+eu8+wiCx0my8M51WxFQKQbzfF8oq5JS
         V2o6T65zGF/r69VQ6yJ58FbM4yKmDeUgF3+lqjFrisqhCVvT0o0gn9jjQmsLEkCmOmHx
         YM8Y5mepvRtum51AP4ekK2lMHvjny4qbPylaRp6x5mVSWVdJrTYq1UBXBXGgvuEPVZOS
         KlJHrd6t+ZDlb9CTli+Hcgdv2tJHhp4zc2LZ7UHtNUVoQ2xW5Lx2xSAOLcDFB/bdpQqV
         CypZbR0DITaD+3E1d242atJybhDYAdjvvLp4QAVsN3UPRTCipFefv+ojgtLRtVJqVRIY
         EdpA==
X-Gm-Message-State: APjAAAWhxQiS9C9mNjrsNudF7wdCxUkAU6HZE1HRwpB0fPMK9fQ337sJ
        2Y7LgmiQl2Qr2gsKKqSU0x40s5mTMkhWsuZ3t9yc26BsNugtr+8IozV7ut0HUg3BlEf0+zMfuyl
        G86dGcCYSY6M/
X-Received: by 2002:a7b:cbc5:: with SMTP id n5mr2857058wmi.31.1569330634633;
        Tue, 24 Sep 2019 06:10:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwT50WNRh9TiZTaR+GDMyzI/HA/Ucnwa1fcbZCxIjKtaggqpyZFT6A1MN41iIYAAfZYqHmqfA==
X-Received: by 2002:a7b:cbc5:: with SMTP id n5mr2857028wmi.31.1569330634348;
        Tue, 24 Sep 2019 06:10:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id j26sm3660988wrd.2.2019.09.24.06.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 06:10:33 -0700 (PDT)
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine
 type
To:     Sergio Lopez <slp@redhat.com>, qemu-devel@nongnu.org
Cc:     mst@redhat.com, imammedo@redhat.com, marcel.apfelbaum@gmail.com,
        rth@twiddle.net, ehabkost@redhat.com, philmd@redhat.com,
        lersek@redhat.com, kraxel@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-8-slp@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com>
Date:   Tue, 24 Sep 2019 15:10:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924124433.96810-8-slp@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/19 14:44, Sergio Lopez wrote:
> +Microvm is a machine type inspired by both NEMU and Firecracker, and
> +constructed after the machine model implemented by the latter.

I would say it's inspired by Firecracker only.  The NEMU virt machine
had virtio-pci and ACPI.

> +It's main purpose is providing users a minimalist machine type free
> +from the burden of legacy compatibility,

I think this is too strong, especially if you keep the PIC and PIT. :)
Maybe just "It's a minimalist machine type without PCI support designed
for short-lived guests".

> +serving as a stepping stone
> +for future projects aiming at improving boot times, reducing the
> +attack surface and slimming down QEMU's footprint.

"Microvm also establishes a baseline for benchmarking QEMU and operating
systems, since it is optimized for both boot time and footprint".

> +The microvm machine type supports the following devices:
> +
> + - ISA bus
> + - i8259 PIC
> + - LAPIC (implicit if using KVM)
> + - IOAPIC (defaults to kernel_irqchip_split = true)
> + - i8254 PIT

Do we need the PIT?  And perhaps the PIC even?

Paolo

> + - MC146818 RTC (optional)
> + - kvmclock (if using KVM)
> + - fw_cfg
> + - One ISA serial port (optional)
> + - Up to eight virtio-mmio devices (configured by the user)
> +

