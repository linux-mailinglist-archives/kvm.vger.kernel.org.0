Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 260B69DCCC
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 06:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbfH0Eso (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 00:48:44 -0400
Received: from ozlabs.org ([203.11.71.1]:42203 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbfH0Esn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 00:48:43 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46Hbx52WCgz9s00;
        Tue, 27 Aug 2019 14:48:41 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        Alistair Popple <alistair@popple.id.au>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: [PATCH kernel v2 4/4] powerpc/powernv/ioda: Remove obsolete iommu_table_ops::exchange callbacks
In-Reply-To: <20190826061705.92048-5-aik@ozlabs.ru>
References: <20190826061705.92048-1-aik@ozlabs.ru> <20190826061705.92048-5-aik@ozlabs.ru>
Date:   Tue, 27 Aug 2019 14:48:41 +1000
Message-ID: <87mufv2oye.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexey Kardashevskiy <aik@ozlabs.ru> writes:
> As now we have xchg_no_kill/tce_kill, these are not used anymore so
> remove them.
>
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
>  arch/powerpc/include/asm/iommu.h          | 10 -----
>  arch/powerpc/kernel/iommu.c               | 26 +-----------
>  arch/powerpc/platforms/powernv/pci-ioda.c | 50 -----------------------
>  3 files changed, 1 insertion(+), 85 deletions(-)

This doesn't build:

arch/powerpc/platforms/pseries/iommu.c:652:3: error: 'struct iommu_table_ops' has no member named 'exchange'
  .exchange = tce_exchange_pseries,
   ^~~~~~~~
arch/powerpc/platforms/pseries/iommu.c:652:14: error: initialization of 'int (*)(struct iommu_table *, long int,  long unsigned int *, enum dma_data_direction *, bool)' {aka 'int (*)(struct iommu_table *, long int,  long unsigned int *, enum dma_data_direction *, _Bool)'} from incompatible pointer type 'int (*)(struct iommu_table *, long int,  long unsigned int *, enum dma_data_direction *)' [-Werror=incompatible-pointer-types]
  .exchange = tce_exchange_pseries,
              ^~~~~~~~~~~~~~~~~~~~

cheers
