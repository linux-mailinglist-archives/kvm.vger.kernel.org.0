Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D57853399D
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 11:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbiEYJM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 05:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240991AbiEYJMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 05:12:09 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF9C0B0D2D
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 02:08:05 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 668491FB;
        Wed, 25 May 2022 02:07:50 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 714053F70D;
        Wed, 25 May 2022 02:07:49 -0700 (PDT)
Date:   Wed, 25 May 2022 10:08:01 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Dao Lu <daolu@rivosinc.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        kvm-riscv@lists.infradead.org, apatel@ventanamicro.com
Subject: Re: [PATCH kvmtool v2] Fixes: 0febaae00bb6 ("Add asm/kernel.h for
 riscv")
Message-ID: <Yo3x8U9L9baABVUr@monolith.localdoman>
References: <20220524180030.1848992-1-daolu@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524180030.1848992-1-daolu@rivosinc.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I just noticed this, I think the subject could be improved. The commit id
referenced in the subject is actually "Add cpumask functions", not "Add
asm/kernel.h for riscv".

I think something like this (below) is much more useful for someone doing
git log --oneline to get an idea of what the patch does:

    riscv: Add missing asm/kernel.h header

Feel free to reword it if you can come up with something better.

If you want, you can add the fixes tag above your Signed-off-by:

Fixes: 0febaae00bb6 ("Add cpumask functions")

Thanks,
Alex

On Tue, May 24, 2022 at 11:00:30AM -0700, Dao Lu wrote:
> Fixes the following compilation issue:
> 
> include/linux/kernel.h:5:10: fatal error: asm/kernel.h: No such file
> or directory
>     5 | #include "asm/kernel.h"
> 
> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Dao Lu <daolu@rivosinc.com>
> ---
>  riscv/include/asm/kernel.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
>  create mode 100644 riscv/include/asm/kernel.h
> 
> diff --git a/riscv/include/asm/kernel.h b/riscv/include/asm/kernel.h
> new file mode 100644
> index 0000000..4ab195f
> --- /dev/null
> +++ b/riscv/include/asm/kernel.h
> @@ -0,0 +1,8 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef __ASM_KERNEL_H
> +#define __ASM_KERNEL_H
> +
> +#define NR_CPUS	512
> +
> +#endif /* __ASM_KERNEL_H */
> -- 
> 2.36.0
> 
