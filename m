Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11443A0548
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 16:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfH1OsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 10:48:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56008 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbfH1OsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 10:48:02 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E21C2A973;
        Wed, 28 Aug 2019 14:48:02 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 74DFA6060D;
        Wed, 28 Aug 2019 14:48:00 +0000 (UTC)
Date:   Wed, 28 Aug 2019 16:47:57 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, rkrcmar@redhat.com, maz@kernel.org,
        vladimir.murzin@arm.com, andre.przywara@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 03/16] lib: arm/arm64: Add missing
 include for alloc_page.h in pgtable.h
Message-ID: <20190828144757.q7utxtnzehmv2duk@kamzik.brq.redhat.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
 <1566999511-24916-4-git-send-email-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566999511-24916-4-git-send-email-alexandru.elisei@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Wed, 28 Aug 2019 14:48:02 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 02:38:18PM +0100, Alexandru Elisei wrote:
> pgtable.h is used only by mmu.c, where it is included after alloc_page.h.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/asm/pgtable.h   | 1 +
>  lib/arm64/asm/pgtable.h | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
> index 241dff69b38a..b01c34348321 100644
> --- a/lib/arm/asm/pgtable.h
> +++ b/lib/arm/asm/pgtable.h
> @@ -13,6 +13,7 @@
>   *
>   * This work is licensed under the terms of the GNU GPL, version 2.
>   */
> +#include <alloc_page.h>
>  
>  /*
>   * We can convert va <=> pa page table addresses with simple casts
> diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
> index ee0a2c88cc18..e9dd49155564 100644
> --- a/lib/arm64/asm/pgtable.h
> +++ b/lib/arm64/asm/pgtable.h
> @@ -14,6 +14,7 @@
>   * This work is licensed under the terms of the GNU GPL, version 2.
>   */
>  #include <alloc.h>
> +#include <alloc_page.h>
>  #include <asm/setup.h>
>  #include <asm/page.h>
>  #include <asm/pgtable-hwdef.h>
> -- 
> 2.7.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
