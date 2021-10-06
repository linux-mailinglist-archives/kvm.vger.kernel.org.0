Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951914240E5
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 17:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239000AbhJFPLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 11:11:23 -0400
Received: from foss.arm.com ([217.140.110.172]:35388 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238124AbhJFPLX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Oct 2021 11:11:23 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0C7056D;
        Wed,  6 Oct 2021 08:09:31 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 401463F66F;
        Wed,  6 Oct 2021 08:09:30 -0700 (PDT)
Date:   Wed, 6 Oct 2021 16:09:27 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, jean-philippe@linaro.org
Subject: Re: [PATCH v1 kvmtool 2/7] vfio/pci.c: Remove double include for
 assert.h
Message-ID: <20211006160927.17d6e1b6@donnerap.cambridge.arm.com>
In-Reply-To: <20210913154413.14322-3-alexandru.elisei@arm.com>
References: <20210913154413.14322-1-alexandru.elisei@arm.com>
 <20210913154413.14322-3-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Sep 2021 16:44:08 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> assert.h is included twice, keep only one instance.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  vfio/pci.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/vfio/pci.c b/vfio/pci.c
> index ea33fd6..10ff99e 100644
> --- a/vfio/pci.c
> +++ b/vfio/pci.c
> @@ -10,8 +10,6 @@
>  #include <sys/resource.h>
>  #include <sys/time.h>
>  
> -#include <assert.h>
> -
>  /* Some distros don't have the define. */
>  #ifndef PCI_CAP_EXP_RC_ENDPOINT_SIZEOF_V1
>  #define PCI_CAP_EXP_RC_ENDPOINT_SIZEOF_V1	12

