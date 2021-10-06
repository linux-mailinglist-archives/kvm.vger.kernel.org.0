Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41738423AF1
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 11:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbhJFJy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 05:54:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238071AbhJFJyX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 05:54:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633513951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UX+jJIMrW7zppHw65NjBMUn3Ls16NiPQRP3a7uQKNas=;
        b=goxqAZR4OY6ZDDvDFSDJSTeVGGzILL+KCKMkkvp3v2AtBO8M3Tt+z6jY4LqAaSutKN9e/d
        zsH2BUon9rTOGs68xTes5Ua3ecyCqCozHkdS0x1LOFiJy7EC97/4uMKo6PqoUTZFoaszaL
        zfIr9RpqBr9+ZjUHdYS4uTqoqmOTtPM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-1TQuJKCaMx-ILPqY2m2GxQ-1; Wed, 06 Oct 2021 05:52:30 -0400
X-MC-Unique: 1TQuJKCaMx-ILPqY2m2GxQ-1
Received: by mail-ed1-f72.google.com with SMTP id z13-20020aa7c64d000000b003db3a3c396dso1010965edr.9
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 02:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UX+jJIMrW7zppHw65NjBMUn3Ls16NiPQRP3a7uQKNas=;
        b=v8FjOFCWIJFxmQjJ1ecOPsV9gjJ65hOVvFMAre6X7rK8XfsGXJjx3DQtScWTPp6J6Q
         4ALlMk3XQImjFq3ZX2xW1EHJfirXRrakG22dM43PlVJ0PXx/EWuZvysemmUPS19/naq0
         9k0ZFAxadLy/fD93YpdMtwM9eooZ/P3aJIQ0lgoUWnnN/ZXUmIqHy4XnPGish2L0m4da
         7DGn7N2v9E1dNR9f1rbduGtZvDZmsjcEymEvmF0Ra41vY5T0uzWBNgLYygv/opElHWYu
         Rud/wRp6l0Hxbbv/GH5nQIDVOrzLGZB9Rp1u0DfHT5UPMMfVWhpYX/xBMr9f4a+h6iwG
         88yw==
X-Gm-Message-State: AOAM531g+uvtx51iVi5JFn44H/N1BzSp73hmfIwELr1F0Vat+FLCzc49
        BUmfIRKDpkLpqCGos2ZeXF6OMEFGIIbefTKRzSnpTdM8mVc1BZaIqoFgqpW9MyPfg2FTOAulCR3
        X4oUVsFjZsiET
X-Received: by 2002:a50:fc97:: with SMTP id f23mr32904100edq.176.1633513949101;
        Wed, 06 Oct 2021 02:52:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJym1bd3jelNNspsB1i1kHxfPV+2+86hum/hgtp7xNHYC9ga0Z22asV6hE/ZX0V3bZVSD3yHWg==
X-Received: by 2002:a50:fc97:: with SMTP id f23mr32904087edq.176.1633513948990;
        Wed, 06 Oct 2021 02:52:28 -0700 (PDT)
Received: from gator.home (cst2-174-28.cust.vodafone.cz. [31.30.174.28])
        by smtp.gmail.com with ESMTPSA id f10sm9966872edu.70.2021.10.06.02.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 02:52:28 -0700 (PDT)
Date:   Wed, 6 Oct 2021 11:52:26 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        eric.auger@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v4 08/11] KVM: arm64: selftests: Add some tests for GICv2
 in vgic_init
Message-ID: <20211006095226.ph5g5us7kecsyvqp@gator.home>
References: <20211005011921.437353-1-ricarkol@google.com>
 <20211005011921.437353-9-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005011921.437353-9-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 06:19:18PM -0700, Ricardo Koller wrote:
> Add some GICv2 tests: general KVM device tests and DIST/CPUIF overlap
> tests.  Do this by making test_vcpus_then_vgic and test_vgic_then_vcpus
> in vgic_init GIC version agnostic.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  .../testing/selftests/kvm/aarch64/vgic_init.c | 111 +++++++++++++-----
>  1 file changed, 79 insertions(+), 32 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

