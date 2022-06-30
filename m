Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5758656107E
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 07:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiF3FNj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 01:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiF3FNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 01:13:37 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011151CB2E
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 22:13:36 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id v126so13246795pgv.11
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 22:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RZrtmGtqOzVbyFoVlOZv26WUA/FMjlC1LhRQ7xIxlHI=;
        b=rPFz34RXlZuSuiCo0NF/TcM8GlENwkWaOJ87lVaSaVrem9325R3UILRC1DuW+UuuiN
         c7u4eC160mcm2bCwLJQm0SkB6a+Ednu70UutO6aA4FAoVUwhJKq17RsX6GTygMWYZJSL
         9JmEsr/3CHLxmOULQg/x5VzqA/KrWFQOFBhjmf7z6mlV60m3qY/kfBdW8ls0mE+1z7QM
         BxeHT93fPH6Jzz21cqlSZOd5HDPc6xgFq1FV26NPe5bxPdDRNDHvQ/ovd1AFVX5jpyv0
         vK/OZknmALsvWqaOMbxhkbEuT5UAMsNUvQEvCXTWtpUbxjR0TYUhtQK1MDz5NZd4hzsZ
         5C5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RZrtmGtqOzVbyFoVlOZv26WUA/FMjlC1LhRQ7xIxlHI=;
        b=mfTxamVPfrdPiTM3JbWRVVdYjKz+feaqJkJE/vc1n5P4c6lDNPtm7dejZXKbJC+jQ0
         e71l4051eyHlWpi8SfK2UPqmwFIWU8FkFkl1/CX+L17htlpjOXUIhOT/VyJzerCLpobA
         Zg9ledWLFbkZKkPyuXTq3DhRDNA5riODPpmE6W8xzhRi2+8sgg/kSX0uXBzN54KFumKY
         FnIpfAjQizrqMfQzGmGKQk3S6fRAfx4XOvym2HB++jsLgEL3a2Q39zTHkm8tvwpGjzIv
         Vm3S5SIita2xrUlA8M8Bj2wpryvZcbrDPUgT6fch7MErt8hP0xhL2+uBwYXxouiaFPg3
         US3w==
X-Gm-Message-State: AJIora98V36r8WvLYvoFEujfctGTviDXXgwHG+S1liC+PmEkJUWLcZHb
        3oiAKXzlhHETmFkhNcS+8HzQMg==
X-Google-Smtp-Source: AGRyM1tLQ1jl+4+uFcKFdRGWcnZjtzTVHuA5XhgWsV7njKpyFglTi6QxsdOObgijkx/l9l/DWHtfBQ==
X-Received: by 2002:a63:d951:0:b0:411:4723:acea with SMTP id e17-20020a63d951000000b004114723aceamr6125285pgj.411.1656566016302;
        Wed, 29 Jun 2022 22:13:36 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id s7-20020a17090302c700b00168e83eda56sm12373534plk.3.2022.06.29.22.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 22:13:35 -0700 (PDT)
Date:   Wed, 29 Jun 2022 22:13:31 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com,
        Andrew Jones <andrew.jones@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v2 19/23] arm64: Use code from the gnu-efi
 when booting with EFI
Message-ID: <Yr0w+69mgp/nDXr2@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-20-nikos.nikoleris@arm.com>
 <YrJHDBeTGgd+dpDP@google.com>
 <3c501902-ba3d-209e-b563-a20547c3fe26@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c501902-ba3d-209e-b563-a20547c3fe26@arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ni Nikos,

On Mon, Jun 27, 2022 at 06:10:20PM +0100, Nikos Nikoleris wrote:
> Hi Ricardo,
> 
> Thanks for this, let me go through the idea I had. Please let me know if I
> am missing something.
> 
> On 21/06/2022 23:32, Ricardo Koller wrote:
> > On Fri, May 06, 2022 at 09:56:01PM +0100, Nikos Nikoleris wrote:
> > > arm/efi/crt0-efi-aarch64.S defines the header and the handover
> > > sequence from EFI to a efi_main. This change includes the whole file
> > > in arm/cstart64.S when we compile with EFI support.
> > > 
> > > In addition, we change the handover code in arm/efi/crt0-efi-aarch64.S
> > > to align the stack pointer. This alignment is necessary because we
> > > make assumptions about cpu0's stack alignment and most importantly we
> > > place its thread_info at the bottom of this stack.
> > > 
> > > Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> > > ---
> > >   arm/cstart64.S             |  6 ++++++
> > >   arm/efi/crt0-efi-aarch64.S | 17 +++++++++++++++--
> > >   2 files changed, 21 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > > index 55b41ea..08cf02f 100644
> > > --- a/arm/cstart64.S
> > > +++ b/arm/cstart64.S
> > > @@ -15,6 +15,10 @@
> > >   #include <asm/thread_info.h>
> > >   #include <asm/sysreg.h>
> > > +#ifdef CONFIG_EFI
> > > +#include "efi/crt0-efi-aarch64.S"
> > > +#else
> > > +
> > >   .macro zero_range, tmp1, tmp2
> > >   9998:	cmp	\tmp1, \tmp2
> > >   	b.eq	9997f
> > > @@ -107,6 +111,8 @@ start:
> > >   	bl	exit
> > >   	b	halt
> > > +#endif
> > > +
> > >   .text
> > >   /*
> > > diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
> > > index d50e78d..11a062d 100644
> > > --- a/arm/efi/crt0-efi-aarch64.S
> > > +++ b/arm/efi/crt0-efi-aarch64.S
> > > @@ -111,10 +111,19 @@ section_table:
> > >   	.align		12
> > >   _start:
> > > -	stp		x29, x30, [sp, #-32]!
> > > +	stp		x29, x30, [sp, #-16]!
> > 
> > Is this and the "ldp x29, x30, [sp], #16" change below needed?
> > why is #-32 not good?
> > 
> 
> The stack is full-descending. Here we make space for x29 and x30 in the
> stack (16bytes) and save the two registers
> 

Got it, was thinking mainly in terms of optimizing for less changes.
But I see your point; plus it makes the restoring simpler.

> > > +
> > > +	// Align sp; this is necessary due to way we store cpu0's thread_info
> > 
> > /* */ comment style
> > 
> 
> ack
> 
> > >   	mov		x29, sp
> > > +	and		x29, x29, #THREAD_MASK
> > > +	mov		x30, sp
> > > +	mov		sp, x29
> > > +	str		x30, [sp, #-32]!
> > > +
> 
> Here we're making space in the stack for the old sp (x30), x0 and x1 but we
> have to also ensure that the sp is aligned (32bytes). The we store x30.
> 
> (As a side note, I could also change this to
> 
> +	str		x30, [sp, #-16]!
> 
> and change the next stp to do pre-incrementing mode. This might make things
> simpler.)

Definitely, it would look like two regular pushes.

> 
> > > +	mov             x29, sp
> > >   	stp		x0, x1, [sp, #16]
> > > +
> 
> Here, we use the space we made before to store x0 and x1.
> 
> I think, the stack now should look like:
> 
>        |   ...  |
>        |   x30  |
>        |   x29  |

possibly some more extra space due to #THREAD_MASK

>        |   x1   |
>        |   x0   |
>        |   pad  |
> sp ->  | old_sp |

Thanks for this!

> 
> 
> > >   	mov		x2, x0
> > >   	mov		x3, x1
> > >   	adr		x0, ImageBase
> > > @@ -126,5 +135,9 @@ _start:
> > >   	ldp		x0, x1, [sp, #16]
> > >   	bl		efi_main
> > > -0:	ldp		x29, x30, [sp], #32
> > > +	// Restore sp
> > 
> > /* */ comment style
> 
> ack
> 
> > 
> > > +	ldr		x30, [sp]
> 
> I think this should have been:
> 
> +	ldr		x30, [sp], #32
> 
> Restore x30 from the current sp and free up space in the stack (all
> 32bytes).
> 

Now I get it. That's not needed actually, as you are restoring sp from
old_sp below to this address:

          |   ...  |
          |   x30  |
sp ->     |   x29  |

(old_sp was the sp after pushing x29,x30)

> > 
> > I'm not able to understand this. Is this ldr restoring the value pushed
> > with "str x30, [sp, #-32]!" above? in that case, shouldn't this be at
> > [sp - 32]? But, given that this code is unreachable when efi_main is
> > called, do you even need to restore the sp?
> > 
> > > +	mov             sp, x30
> > > +
> > > +0:	ldp		x29, x30, [sp], #16
> 
> Then, this restores x29 and x30 and frees up the the corresponding space in
> the stack.
> 
> 
> I am not sure we shouldn't get to this point and I wanted to properly save
> and restore the register state. I haven't really found what's the right/best
> way to exit from an EFI app and I wanted to allow for graceful return from
> this point. But I am happy to change all this.

Yes, let's keep it just in case.

> 
> Thanks,
> 
> Nikos
> 
> > >   	ret
> > > -- 
> > > 2.25.1
> > > 

Thanks!
Ricardo
