Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F01530D4B
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 12:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbiEWJeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 05:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbiEWJd5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 05:33:57 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5932D483A7
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 02:33:49 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA02111FB;
        Mon, 23 May 2022 02:33:48 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 00E243F73D;
        Mon, 23 May 2022 02:33:47 -0700 (PDT)
Date:   Mon, 23 May 2022 10:34:02 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, kvm@vger.kernel.org
Cc:     Dao Lu <daolu@rivosinc.com>
Subject: Re: [PATCH kvmtool] Fixes: 0febaae00bb6 ("Add asm/kernel.h for
 riscv")
Message-ID: <YotVCkpajnskhQm9@monolith.localdoman>
References: <20220520180946.104214-1-daolu@rivosinc.com>
 <YotUdkD2LIKqhYKq@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YotUdkD2LIKqhYKq@monolith.localdoman>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adding the kvmtool maintainers, I just noticed that they were missing.

On Mon, May 23, 2022 at 10:31:34AM +0100, Alexandru Elisei wrote:
> Hi,
> 
> When I started working on the heterogeneous PMU series, support for the
> riscv architecture wasn't merged in kvmtool, and after riscv was merged I
> missed adding the header file.
> 
> This indeed fixes this compilation error:
> 
> In file included from include/linux/rbtree.h:32,
>                  from include/kvm/devices.h:4,
>                  from include/kvm/pci.h:10,
>                  from include/kvm/vfio.h:6,
>                  from include/kvm/kvm-config.h:5,
>                  from include/kvm/kvm.h:6:
> include/linux/kernel.h:5:10: fatal error: asm/kernel.h: No such file or directory
>     5 | #include "asm/kernel.h"
>       |          ^~~~~~~~~~~~~~
> cc1: all warnings being treated as errors
> compilation terminated.
> make: *** [Makefile:484: builtin-balloon.o] Error 1
> 
> Would be nice to include it in the commit message, so people googling for
> that exact error message can come across this commit.
> 
> On Fri, May 20, 2022 at 11:09:46AM -0700, Dao Lu wrote:
> > Signed-off-by: Dao Lu <daolu@rivosinc.com>
> > ---
> >  riscv/include/asm/kernel.h | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >  create mode 100644 riscv/include/asm/kernel.h
> > 
> > diff --git a/riscv/include/asm/kernel.h b/riscv/include/asm/kernel.h
> > new file mode 100644
> > index 0000000..a2a8d9e
> > --- /dev/null
> > +++ b/riscv/include/asm/kernel.h
> > @@ -0,0 +1,8 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +#ifndef __ASM_KERNEL_H
> > +#define __ASM_KERNEL_H
> > +
> > +#define NR_CPUS	4096
> 
> In arch/riscv/Kconfig I see this:
> 
> config NR_CPUS
> 	int "Maximum number of CPUs (2-32)"
> 	range 2 32
> 	depends on SMP
> 	default "8"
> 
> Would you mind explaining where the 4096 number of CPUs comes from?
> 
> Thanks,
> Alex
> 
> > +
> > +#endif /* __ASM_KERNEL_H */
> > -- 
> > 2.36.0
> > 
