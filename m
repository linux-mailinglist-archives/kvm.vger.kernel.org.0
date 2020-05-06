Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDB31C6E1A
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 12:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgEFKLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 06:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728314AbgEFKLW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 06:11:22 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC73C061A0F
        for <kvm@vger.kernel.org>; Wed,  6 May 2020 03:11:22 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u16so1937417wmc.5
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 03:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CZGxVEINRFfXco4KoTv4rMN52n6V3TJRcAbrE28fW9I=;
        b=gV9RfLluzH10SNhxg/ntUX82VqQaIDxo5hreeCRlMY9MSi58DD1Rdv8yrkNnxMUNdc
         lqqVgDIDm3KKLgwIIfqxX9p7vAryeLm1fKw2t1OPaSbqw8YrMfm1wrFSJ7BawFFe5mII
         XVVAXr9hAmR1dSQMhxBFiMv+jFhDF5JgqnK8YOlezXRMvHPp7CiEqnjwQJeUJc8TTebd
         xyl4YYbHvzEgaYk8eLDwc8AsaW5okMx3l4dFvMInLPONGXPKs4yAL1bV1he8DCSqr8sv
         7DlRNJpYJsXkdlD8kNP0c6Uo5Q58EVfFd0/sng6OXjXzWFH9lZOn8SHyFXSXYRRuDR80
         Esfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CZGxVEINRFfXco4KoTv4rMN52n6V3TJRcAbrE28fW9I=;
        b=SFSq6SO6hiB/zhV6E0jlcqNPyl6OG044RfwVx6f199WNaN7UXetk6ncxZXomNJi/J6
         aFUA6W0RyioE2ySk6Y8ClGodjgFeHAx9o7yXuVYcQscr6ckg7rPc2um1y5A7TFttbHhx
         to5pNi4W5uG5Hb8e5aWdiLWL5dcCF5YJxG4396o69EZ75VNj4qTNkovdINX8hnmihdYe
         /GXxzEE+t5uMID0cNUeGRQPTWiIZihgNE/myHWUycTDoS17GRWYQaiFWlRK1K7cfJYph
         ZTjrEL+zUEFetrzbAA/36hpoR6KPdXRw8xB+69AVaBpHZXlSVDpAJMP6mMEx/loxIEbE
         jeGw==
X-Gm-Message-State: AGi0PuZZZe8Fialsa/3DQxOCp0YP5OzwlRk9vEa/eoZWh6crt5P591bL
        z5JG0Zn51535/oUlT5Dgz8QPtA==
X-Google-Smtp-Source: APiQypID1DXJTOWcDNEDu4jVNP7gVAm/OBszOGtJjHaEN3aiIon6FlVQi2/8ZdUD+TQYi0xLYGD29A==
X-Received: by 2002:a7b:ce88:: with SMTP id q8mr3737522wmj.161.1588759880879;
        Wed, 06 May 2020 03:11:20 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:109:355c:447d:ad3d:ac5c])
        by smtp.gmail.com with ESMTPSA id q8sm2109623wrp.58.2020.05.06.03.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 03:11:19 -0700 (PDT)
Date:   Wed, 6 May 2020 11:11:15 +0100
From:   Andrew Scull <ascull@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 05/26] arm64: Document SW reserved PTE/PMD bits in
 Stage-2 descriptors
Message-ID: <20200506101115.GF237572@google.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-6-maz@kernel.org>
 <20200505155916.GB237572@google.com>
 <8b399c95ca1393e63cc1077ede8a45f6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b399c95ca1393e63cc1077ede8a45f6@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 06, 2020 at 10:39:59AM +0100, Marc Zyngier wrote:
> Hi Andrew,
> 
> On 2020-05-05 16:59, Andrew Scull wrote:
> > On Wed, Apr 22, 2020 at 01:00:29PM +0100, Marc Zyngier wrote:
> > > Advertise bits [58:55] as reserved for SW in the S2 descriptors.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/pgtable-hwdef.h | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/arch/arm64/include/asm/pgtable-hwdef.h
> > > b/arch/arm64/include/asm/pgtable-hwdef.h
> > > index 6bf5e650da788..7eab0d23cdb52 100644
> > > --- a/arch/arm64/include/asm/pgtable-hwdef.h
> > > +++ b/arch/arm64/include/asm/pgtable-hwdef.h
> > > @@ -177,10 +177,12 @@
> > >  #define PTE_S2_RDONLY		(_AT(pteval_t, 1) << 6)   /* HAP[2:1] */
> > >  #define PTE_S2_RDWR		(_AT(pteval_t, 3) << 6)   /* HAP[2:1] */
> > >  #define PTE_S2_XN		(_AT(pteval_t, 2) << 53)  /* XN[1:0] */
> > > +#define PTE_S2_SW_RESVD		(_AT(pteval_t, 15) << 55) /* Reserved for
> > > SW */
> > > 
> > >  #define PMD_S2_RDONLY		(_AT(pmdval_t, 1) << 6)   /* HAP[2:1] */
> > >  #define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
> > >  #define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
> > > +#define PMD_S2_SW_RESVD		(_AT(pmdval_t, 15) << 55) /* Reserved for
> > > SW */
> > > 
> > >  #define PUD_S2_RDONLY		(_AT(pudval_t, 1) << 6)   /* HAP[2:1] */
> > >  #define PUD_S2_RDWR		(_AT(pudval_t, 3) << 6)   /* HAP[2:1] */
> > > --
> > > 2.26.1
> > > 
> > > _______________________________________________
> > > kvmarm mailing list
> > > kvmarm@lists.cs.columbia.edu
> > > https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> > 
> > This is consistent with "Attribute fields in stage 1 VMSAv8-64 Block and
> > Page descriptors"
> 
> Do you mean "stage 2" instead? The reserved bits are the same, but I want
> to be sure we have looked at the same thing (ARM DDI 0487F.a, D5-2603).

My turn for the copy-paste bug, yes "Attribute fields in stage 2
VMSAv8-64 Block and Page descriptors". And conviniently the same bits
are reserved for SW in both.
