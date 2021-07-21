Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B579C3D18E2
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 23:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhGUUhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 16:37:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58862 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230034AbhGUUhN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Jul 2021 16:37:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626902268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xS7zB88wP1Ct8tl3wZJBYvmGfA8uHUm0YRA5Jgo14nI=;
        b=ClAqKbgyO5HD9JCMouZvHML1KjxMxp2XLFa/bDP04Ue+UFTDPznZpzM3YqxaVjmSXERr6K
        8HOlCwinhsPe/gaZsZdSZyKPJDS0d1Pz7w+Uh1rQyAD+xB5U5t3GDTaZz7nJ0MDDIXqLXe
        bg44uv0v5+KN67NyDXmFanq7hgbob4c=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-jy7tl7CINNek5gtlop-z3g-1; Wed, 21 Jul 2021 17:17:47 -0400
X-MC-Unique: jy7tl7CINNek5gtlop-z3g-1
Received: by mail-il1-f197.google.com with SMTP id m15-20020a923f0f0000b02901ee102ac952so2295089ila.8
        for <kvm@vger.kernel.org>; Wed, 21 Jul 2021 14:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xS7zB88wP1Ct8tl3wZJBYvmGfA8uHUm0YRA5Jgo14nI=;
        b=Nv6yvi9/A+Rcl86FjbCeeNWmsZsDmi90Yzcri8Rmwj/URpxC6LUCV6+ihvp5styjxq
         uI2liHB2DCdKSXcMenPPIFNIRl5WxrSzVV3MkEXsYXVqRLZur6pJUIjWU3yPq2M3owny
         5Fd4RasdAawrH6zgI2SPGlhXFPC4RY4h1yWo08/5wXwVQOm04abvURpoUMu0xx2Kh/lm
         uHEa9/u3bVY2x4/bHGVDwz4ip08/6HD6onYKHbL04BW5qS3Bx38rvsuUwguJdxE6P4Pp
         EKt9+aofrO4xMlf0v4je2kzv01fTzN1J2+LJ3h4fmyczRyt7YDeuGoNepqJZuRlwU8hj
         CmaA==
X-Gm-Message-State: AOAM532+EMkMc/3HIh9+4nlrLgZ02P9yduc/lCTTePmnSao0VmtBsCar
        99saM6S1fh90jzrbMe8f+FxWF3/BsOkQWXDbp0ZJQgSZUqReGKze1w5wd2MungtVV4TdS65Xwiy
        Q8SlRFJjSPXHx
X-Received: by 2002:a05:6638:240c:: with SMTP id z12mr32205859jat.41.1626902266820;
        Wed, 21 Jul 2021 14:17:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBlvz5/fIzXCPHPyLAiDDc3sODGKzE5IDkrPThRVZQuX/uKMDGuLWG9b8A3eweAr3W8umHRw==
X-Received: by 2002:a05:6638:240c:: with SMTP id z12mr32205837jat.41.1626902266587;
        Wed, 21 Jul 2021 14:17:46 -0700 (PDT)
Received: from gator ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id w21sm14507636iol.52.2021.07.21.14.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 14:17:45 -0700 (PDT)
Date:   Wed, 21 Jul 2021 23:17:43 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        will@kernel.org
Subject: Re: [PATCH 10/16] KVM: arm64: Add some documentation for the MMIO
 guard feature
Message-ID: <20210721211743.hb2cxghhwl2y22yh@gator>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-11-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-11-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021 at 05:31:53PM +0100, Marc Zyngier wrote:
> Document the hypercalls user for the MMIO guard infrastructure.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  Documentation/virt/kvm/arm/index.rst      |  1 +
>  Documentation/virt/kvm/arm/mmio-guard.rst | 73 +++++++++++++++++++++++
>  2 files changed, 74 insertions(+)
>  create mode 100644 Documentation/virt/kvm/arm/mmio-guard.rst
> 
> diff --git a/Documentation/virt/kvm/arm/index.rst b/Documentation/virt/kvm/arm/index.rst
> index 78a9b670aafe..e77a0ee2e2d4 100644
> --- a/Documentation/virt/kvm/arm/index.rst
> +++ b/Documentation/virt/kvm/arm/index.rst
> @@ -11,3 +11,4 @@ ARM
>     psci
>     pvtime
>     ptp_kvm
> +   mmio-guard
> diff --git a/Documentation/virt/kvm/arm/mmio-guard.rst b/Documentation/virt/kvm/arm/mmio-guard.rst
> new file mode 100644
> index 000000000000..a5563a3e12cc
> --- /dev/null
> +++ b/Documentation/virt/kvm/arm/mmio-guard.rst
> @@ -0,0 +1,73 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +==============
> +KVM MMIO guard
> +==============
> +
> +KVM implements device emulation by handling translation faults to any
> +IPA range that is not contained a memory slot. Such translation fault
                                  ^ in                ^ a

> +is in most cases passed on to userspace (or in rare cases to the host
> +kernel) with the address, size and possibly data of the access for
> +emulation.
> +
> +Should the guest exit with an address that is not one that corresponds
> +to an emulatable device, userspace may take measures that are not the
> +most graceful as far as the guest is concerned (such as terminating it
> +or delivering a fatal exception).
> +
> +There is also an element of trust: by forwarding the request to
> +userspace, the kernel asumes that the guest trusts userspace to do the

assumes
  
> +right thing.
> +
> +The KVM MMIO guard offers a way to mitigate this last point: a guest
> +can request that only certainly regions of the IPA space are valid as

certain

> +MMIO. Only these regions will be handled as an MMIO, and any other
> +will result in an exception being delivered to the guest.
> +
> +This relies on a set of hypercalls defined in the KVM-specific range,
> +using the HVC64 calling convention.
> +
> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO
> +
> +    ==============    ========    ================================
> +    Function ID:      (uint32)    0xC6000002
> +    Arguments:        none
> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
> +                      (uint64)    Protection Granule (PG) size in
> +		                  bytes (r0)
> +    ==============    ========    ================================
> +
> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL
> +
> +    ==============    ========    ==============================
> +    Function ID:      (uint32)    0xC6000003
> +    Arguments:        none
> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
> +                                  RET_SUCCESS(0) (r0)
> +    ==============    ========    ==============================
> +
> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP
> +
> +    ==============    ========    ======================================
> +    Function ID:      (uint32)    0xC6000004
> +    Arguments:        (uint64)    The base of the PG-sized IPA range
> +                                  that is allowed to be accessed as
> +				  MMIO. Must aligned to the PG size (r1)

align

> +                      (uint64)    Index in the MAIR_EL1 register
> +		                  providing the memory attribute that
> +				  is used by the guest (r2)
> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
> +                                  RET_SUCCESS(0) (r0)
> +    ==============    ========    ======================================
> +
> +* ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP
> +
> +    ==============    ========    ======================================
> +    Function ID:      (uint32)    0xC6000004

copy+paste error, should be 0xC6000005

> +    Arguments:        (uint64)    The base of the PG-sized IPA range
> +                                  that is forbidden to be accessed as

is now forbidden

or

was allowed

or just drop that part of the sentence because its covered by the "and
have been previously mapped" part. Something like

PG-sized IPA range aligned to the PG size which has been previously mapped
(r1)

> +				  MMIO. Must aligned to the PG size

align

> +				  and have been previously mapped (r1)
> +    Return Values:    (int64)     NOT_SUPPORTED(-1) on error, or
> +                                  RET_SUCCESS(0) (r0)
> +    ==============    ========    ======================================
> -- 
> 2.30.2
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 

Thanks,
drew

