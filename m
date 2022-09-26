Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3D45EA6DD
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 15:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbiIZNLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 09:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbiIZNKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 09:10:44 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB6168983E
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 04:40:12 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CCF7C1063;
        Mon, 26 Sep 2022 04:02:06 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0DA563F66F;
        Mon, 26 Sep 2022 04:01:58 -0700 (PDT)
Date:   Mon, 26 Sep 2022 12:02:54 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 13/19] arm: page.h: Add missing
 libcflat.h include
Message-ID: <YzGGuxP9schoXL1C@monolith.localdoman>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-14-alexandru.elisei@arm.com>
 <20220920093956.sh4lunjssia376gf@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220920093956.sh4lunjssia376gf@kamzik>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Tue, Sep 20, 2022 at 11:39:56AM +0200, Andrew Jones wrote:
> 
> I guess this should be squashed into one of the early patches in this
> series since we don't have this issue with the current code.

Will do, thanks for the suggestion!

Alex

> 
> Thanks,
> drew
> 
> 
> On Tue, Aug 09, 2022 at 10:15:52AM +0100, Alexandru Elisei wrote:
> > Include libcflat from page.h to avoid error like this one:
> > 
> > /path/to/kvm-unit-tests/lib/asm/page.h:19:9: error: unknown type name ‘u64’
> >    19 | typedef u64 pteval_t;
> >       |         ^~~
> > [..]
> > /path/to/kvm-unit-tests/lib/asm/page.h:47:8: error: unknown type name ‘phys_addr_t’
> >    47 | extern phys_addr_t __virt_to_phys(unsigned long addr);
> >       |        ^~~~~~~~~~~
> >       |                                     ^~~~~~~~~~~
> > [..]
> > /path/to/kvm-unit-tests/lib/asm/page.h:50:47: error: unknown type name ‘size_t’
> >    50 | extern void *__ioremap(phys_addr_t phys_addr, size_t size);
> > 
> > The arm64 version of the header already includes libcflat since commit
> > a2d06852fe59 ("arm64: Add support for configuring the translation
> > granule").
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  lib/arm/asm/page.h | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/lib/arm/asm/page.h b/lib/arm/asm/page.h
> > index 8eb4a883808e..0a46bda018c7 100644
> > --- a/lib/arm/asm/page.h
> > +++ b/lib/arm/asm/page.h
> > @@ -8,6 +8,8 @@
> >  
> >  #include <linux/const.h>
> >  
> > +#include <libcflat.h>
> > +
> >  #define PAGE_SHIFT		12
> >  #define PAGE_SIZE		(_AC(1,UL) << PAGE_SHIFT)
> >  #define PAGE_MASK		(~(PAGE_SIZE-1))
> > -- 
> > 2.37.1
> > 
