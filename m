Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627853877C9
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 13:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241431AbhERLgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 07:36:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:55876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240092AbhERLgw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 07:36:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621337734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BQTshUjjcW4pqAX06J21RyFPaHFDHA+txFlErPh+Rt4=;
        b=NKr2G70lILLfO0B0bL+/coaWJ2XVs7myvstBsdVnqCAfkrathdWyMGEWZg+txUFgmwLvfV
        T3ud77UJ+aSi6UdIAoMXtnKwS12jLPSgFBLmDteBf2rfOIEDesxyJlFaWuSXdBFKMsVXum
        kv6ftPJLuOm0zbY3KPBPT7MB6BnVco4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-s_9_yGlRNdyGR2FSmO9lFA-1; Tue, 18 May 2021 07:35:33 -0400
X-MC-Unique: s_9_yGlRNdyGR2FSmO9lFA-1
Received: by mail-ej1-f71.google.com with SMTP id i23-20020a17090685d7b02903d089ab83fcso2240722ejy.19
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 04:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BQTshUjjcW4pqAX06J21RyFPaHFDHA+txFlErPh+Rt4=;
        b=opwa+QuQy4bxD1vG1z2WBhozmEj6wFfxa2BUGJaphkGw3R8wMO9whOOCqMQvChZxeU
         NLxrPr9tS0J+M6eaDGEx3NpG/nzvk20QHvduAa65JV3tDElhMs8LIrRptbxAMylEV8aB
         i+VBQhZgt13g8Sy4Zb/iF3Ht/Gv5QugYz2/IGWi3bzeE1i/pItGLQgDVrNEYPYW8MhrK
         7+PN+xBpsiM0idHqSRylKyWHAGSN5icn0dUD3H8Da8tuh3DHOTKUUcqBl3pTG9cu4gsp
         trixzKqLD8HDUGCL8My/Pt2tEDFncEtoMl32RLrbye59JPNnGVQpBqLUxnGEzMQIr71B
         HSdg==
X-Gm-Message-State: AOAM533WLXxuhxNiw5l/HL3lyAtRfhBhVz9jPc47TfXt1/7tfKRQnY2X
        1YhXjNRH4Xlw4ROnRDNhHRoaLfUopt39uhziK9CLri2K5u4IfvtgRt2wiQrCk/U8lQOeVYNa5pB
        oU4ZN/aevHBHhIQ+I0/kANEG8io7SYp17DLd/q+FS4b5uKfFUmHlsCcYj1Tn+L5w=
X-Received: by 2002:aa7:d65a:: with SMTP id v26mr3768038edr.185.1621337731937;
        Tue, 18 May 2021 04:35:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjFdz5DW357y0IITFNJvwk6VPl+y05oxRsyWk868tUdCPsmP1v99BjHZYTPrSVuCuBH6QS4g==
X-Received: by 2002:aa7:d65a:: with SMTP id v26mr3768025edr.185.1621337731788;
        Tue, 18 May 2021 04:35:31 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id f7sm10110869ejz.95.2021.05.18.04.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 04:35:31 -0700 (PDT)
Date:   Tue, 18 May 2021 13:35:29 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: Re: [PULL kvm-unit-tests 00/10] arm/arm64: target-efi prep
Message-ID: <20210518113529.4h44wxdcdjoc25v5@gator.home>
References: <20210517143900.747013-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517143900.747013-1-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 17, 2021 at 04:38:50PM +0200, Andrew Jones wrote:
> The patches mostly prepare kvm-unit-tests/arm for targeting EFI
> platforms. The actually EFI support will come in another series,
> but these patches are good for removing assumptions from our memory
> maps and about our PSCI conduit, even if we never merged EFI support.
> 
> Thanks,
> drew
> 
> 
> The following changes since commit 9e7a5929569d61414feefcb1d8024e7685cb7eb3:
> 
>   arm: add eabi version of 64-bit division functions (2021-05-12 15:52:24 +0200)
> 
> are available in the Git repository at:
> 
>   https://gitlab.com/rhdrjones/kvm-unit-tests.git arm/queue
> 
> for you to fetch changes up to bd5bd1577dcc298cafaf0e26d318a628e650b2a7:
> 
>   arm/arm64: psci: Don't assume method is hvc (2021-05-17 16:08:24 +0200)
> 
> ----------------------------------------------------------------
> Alexandru Elisei (1):
>       configure: arm: Replace --vmm with --target
> 
> Andrew Jones (9):
>       arm/arm64: Reorganize cstart assembler
>       arm/arm64: Move setup_vm into setup
>       pci-testdev: ioremap regions
>       arm64: micro-bench: ioremap userspace_emulated_addr
>       arm/arm64: mmu: Stop mapping an assumed IO region
>       arm/arm64: mmu: Remove memory layout assumptions
>       arm/arm64: setup: Consolidate memory layout assumptions
>       chr-testdev: Silently fail init
>       arm/arm64: psci: Don't assume method is hvc
>

I see these patches have now been merged. Thanks Paolo!

Thanks,
drew

