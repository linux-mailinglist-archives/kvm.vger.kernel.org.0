Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8741B8566
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 11:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgDYJw5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 05:52:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60931 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726022AbgDYJw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 05:52:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587808375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iy6NQDz2bvlcDJdi3t6wYpiP8TNlTDnJAJ85f9gUoPw=;
        b=DEnsjTeNKEVrWmoOzJb5W5qr1aunE/vlP2f0aycvTQu6+F2mm4w7ig6lh+wW7cbiNqWRN4
        9HBTSTP0vs+6n5oRUDnDGoqIPBGldyA3vR1hzGu11sEwMZsqMpD0W5lmeyJW521vHojTwo
        5QWgV8IFfkv+bryEsHvKz2thIT2z30o=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-MyZbcvyaPHCg3IIylppmfQ-1; Sat, 25 Apr 2020 05:52:49 -0400
X-MC-Unique: MyZbcvyaPHCg3IIylppmfQ-1
Received: by mail-wr1-f70.google.com with SMTP id e5so6426334wrs.23
        for <kvm@vger.kernel.org>; Sat, 25 Apr 2020 02:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iy6NQDz2bvlcDJdi3t6wYpiP8TNlTDnJAJ85f9gUoPw=;
        b=Lgp/cVG9138JskQ8rT4Hin4Xe4CydoWhJ7BmPIohscnC43mOD/nvKEgKQlDHlUqK91
         I45M7avNRTPk3QSK6tNSR6CoSZyC2hMGhcKr7zdO+duNjmJwEiXw0KvM0xYo0iKdaK+R
         qM1FVghtMOCC0fBRK5TiVhNTTAHb1thXjejzoA6cOs/NUT3ixn1dKc5E3i+PwBK4SVoP
         5NsB5HGXaVuYbLOTuE+BcnMmKTOfkvWyjoiCCdi2RLOgRD8o+FgyNd+jUQMKwRv3dUns
         yPEEp4LLqLCzi6Ho/2JVBvLI8XqfImx39HUGFCRYGOzLL4S5QRu3nvQpntT2ojHTstHH
         Ij4w==
X-Gm-Message-State: AGi0PuZnj0P0HnJ0Ke+TcgpxTM7pKP5PBIUf76KLToreKNGrPg7yZrJf
        mD949hgx3Rt6OM7ruF2T1TyvqdQUJED9js2o0waxjQStZQz3NzvcWrah0poWiUbOIBkhTnwTjPo
        jTMtmj5uTQDjH
X-Received: by 2002:a1c:40c4:: with SMTP id n187mr14678363wma.28.1587808368108;
        Sat, 25 Apr 2020 02:52:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypJ1i6l3HYPsUNNYMgP5vLaP3Jp+6CJeidd7e8baenIOl0PDzANWn6IazIqsDn4jLvfEqaKLTg==
X-Received: by 2002:a1c:40c4:: with SMTP id n187mr14678349wma.28.1587808367849;
        Sat, 25 Apr 2020 02:52:47 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id y63sm6808373wmg.21.2020.04.25.02.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 02:52:47 -0700 (PDT)
Subject: Re: [PATCH] kvm: ioapic: Introduce arch-specific check for lazy
 update EOI mechanism
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, joro@8bytes.org, jon.grimm@amd.com,
        borisvk@bstnet.org
References: <1587704910-78437-1-git-send-email-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b051913a-10f4-81d4-6ef8-19d586db61da@redhat.com>
Date:   Sat, 25 Apr 2020 11:52:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1587704910-78437-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/04/20 07:08, Suravee Suthikulpanit wrote:
> commit f458d039db7e ("kvm: ioapic: Lazy update IOAPIC EOI") introduces
> the following regression on Intel VMX APICv.
> 
> BUG: stack guard page was hit at 000000008f595917 \
> (stack is 00000000bdefe5a4..00000000ae2b06f5)
> kernel stack overflow (double-fault): 0000 [#1] SMP NOPTI
> RIP: 0010:kvm_set_irq+0x51/0x160 [kvm]
> Call Trace:
>  irqfd_resampler_ack+0x32/0x90 [kvm]
>  kvm_notify_acked_irq+0x62/0xd0 [kvm]
>  kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kvm]
>  ioapic_set_irq+0x20e/0x240 [kvm]
>  kvm_ioapic_set_irq+0x5c/0x80 [kvm]
>  kvm_set_irq+0xbb/0x160 [kvm]
>  ? kvm_hv_set_sint+0x20/0x20 [kvm]
>  irqfd_resampler_ack+0x32/0x90 [kvm]
>  kvm_notify_acked_irq+0x62/0xd0 [kvm]
>  kvm_ioapic_update_eoi_one.isra.0+0x30/0x120 [kvm]
>  ioapic_set_irq+0x20e/0x240 [kvm]
>  kvm_ioapic_set_irq+0x5c/0x80 [kvm]
>  kvm_set_irq+0xbb/0x160 [kvm]
>  ? kvm_hv_set_sint+0x20/0x20 [kvm]
> ....
> 
> This is due to the logic always force IOAPIC lazy update EOI mechanism
> when APICv is activated, which is only needed by AMD SVM AVIC.
> 
> Fixes by introducing struct kvm_arch.use_lazy_eoi variable to specify
> whether the architecture needs lazy update EOI support.

You are not explaining why the same infinite loop cannot happen on AMD.
 It seems to me that it is also fixed by adding a check for re-entrancy
in ioapic_lazy_update_eoi.  It's easy to add one since
ioapic_lazy_update_eoi is called with the ioapic->lock taken.

Paolo

