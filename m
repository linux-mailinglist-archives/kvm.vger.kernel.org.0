Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8522136493B
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 19:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbhDSRxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 13:53:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51289 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234295AbhDSRxu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Apr 2021 13:53:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618854799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=62i2YV3V/yVGPdncThtFG8X/AbkDXM0A7Kv9Bazf/uo=;
        b=Sdh5ttImlHIdQBjEkggsLW6nO40UYR0lUSEHnSap6foiWZFajMUFbex+MYyHsj1hK56fB/
        L/ANdZhqqtQ/VHuCv2ziDKes4hLBAqlUT8OPOEP/AUnwbUCFZXNFm7rZVVmqhTf+HQYPyN
        9y56gytYt/8DszeBHKpcysEG+jtgVK0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-ts_dq__AOv-BRorw-Pyssw-1; Mon, 19 Apr 2021 13:53:16 -0400
X-MC-Unique: ts_dq__AOv-BRorw-Pyssw-1
Received: by mail-ed1-f72.google.com with SMTP id bf25-20020a0564021a59b0290385169cebf8so4210374edb.8
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 10:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=62i2YV3V/yVGPdncThtFG8X/AbkDXM0A7Kv9Bazf/uo=;
        b=iW1q9JPBVqdEjffZ8fQHKrbZQ7JE5cwxnY18YNubv/DmLybSmRmS529oM4ONQ6WCSg
         I6XrCVt/pLLFRRCmhgg/MxfdCeT/e5CgEGSuX0qN6H20Yz9O1JYbVLCJTvJr/ZMq/4Gy
         q/uo5nmhXmwhUSg8hTrVzDuxQZKKHFssEAzBe4KPMc4bfBu5qRGz1dTA5z+PBwtMuEjE
         cw6XDkn5VEgBGxEhqmHW2sgbdmxsxyy8VbqfSV07WRr2LYoOa9R/72v97YnphmQLHP5f
         oQfYqwJzMrpTlJA28jTK3xvS44LJivaABq0EjHty4bwaV3US13ZaybLso+q3d01lHAqu
         ehKw==
X-Gm-Message-State: AOAM5306HOZk74afa6KbPlQUcPC2ttrRerxs8fUAdQORI+llhJCajBL4
        5+3hxVygA0XZt4Gg8wXLgoC03PYyd+MuKP0NdjpI8GJeosFNcxM/50xA7o2FNzTqhYAm9uXkzuT
        t2V2SXQuPAerR
X-Received: by 2002:a05:6402:35c8:: with SMTP id z8mr2439792edc.210.1618854795147;
        Mon, 19 Apr 2021 10:53:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwmULpLHe1bTKW6mRIESzPd/w8nTH4zxg9T7Fxjbok5VIY92xFFkgR/udKEuyHQMOb3fWevDw==
X-Received: by 2002:a05:6402:35c8:: with SMTP id z8mr2439784edc.210.1618854794998;
        Mon, 19 Apr 2021 10:53:14 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id d18sm13833764edv.1.2021.04.19.10.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 10:53:14 -0700 (PDT)
Date:   Mon, 19 Apr 2021 19:53:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests 6/8] arm/arm64: setup: Consolidate memory
 layout assumptions
Message-ID: <20210419175311.holo5jd3c2lje7q3@gator.home>
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-7-drjones@redhat.com>
 <aab892dc-6ef9-cfb5-7057-88ef7c692bba@arm.com>
 <20210415172526.msfseu2qwwb4jquc@kamzik.brq.redhat.com>
 <49591da9-9d78-cdd8-3587-d535c148de31@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49591da9-9d78-cdd8-3587-d535c148de31@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021 at 04:56:33PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 4/15/21 6:25 PM, Andrew Jones wrote:
> > On Thu, Apr 15, 2021 at 05:59:19PM +0100, Alexandru Elisei wrote:
> >> Hi Drew,
> >>
> >> On 4/7/21 7:59 PM, Andrew Jones wrote:
> >>> Keep as much memory layout assumptions as possible in init::start
> >>> and a single setup function. This prepares us for calling setup()
> >>> from different start functions which have been linked with different
> >>> linker scripts. To do this, stacktop is only referenced from
> >>> init::start, making freemem_start a parameter to setup(). We also
> >>> split mem_init() into three parts, one that populates the mem regions
> >>> per the DT, one that populates the mem regions per assumptions,
> >>> and one that does the mem init. The concept of a primary region
> >>> is dropped, but we add a sanity check for the absence of memory
> >>> holes, because we don't know how to deal with them yet.
> >>>
> >>> Signed-off-by: Andrew Jones <drjones@redhat.com>
> >>> ---
> >>>  arm/cstart.S        |   4 +-
> >>>  arm/cstart64.S      |   2 +
> >>>  arm/flat.lds        |  23 ++++++
> >>>  lib/arm/asm/setup.h |   8 +--
> >>>  lib/arm/mmu.c       |   2 -
> >>>  lib/arm/setup.c     | 165 ++++++++++++++++++++++++--------------------
> >>>  6 files changed, 123 insertions(+), 81 deletions(-)
> >>>
> >>> diff --git a/arm/cstart.S b/arm/cstart.S
> >>> index 731f841695ce..14444124c43f 100644
> >>> --- a/arm/cstart.S
> >>> +++ b/arm/cstart.S
> >>> @@ -80,7 +80,9 @@ start:
> >>>  
> >>>  	/* complete setup */
> >>>  	pop	{r0-r1}
> >>> -	bl	setup
> >>> +	mov	r1, #0
> >> Doesn't that mean that for arm, the second argument to setup() will be 0 instead
> >> of stacktop?
> > The second argument is 64-bit, but we assume the upper 32 are zero.
> 
> I didn't realize that phys_addr_t is 64bit.
> 
> According to ARM IHI 0042F, page 15:
> 
> "A double-word sized type is passed in two consecutive registers (e.g., r0 and r1,
> or r2 and r3). The content of the registers is as if the value had been loaded
> from memory representation with a single LDM instruction."
> 
> I think r3 should be zeroed, not r1. r2 and r3 represent the 64bit value. arm is
> little endian, so the least significant 32bits will be in r2 and the most
> significant bits will be in r3.

Thanks for this. It looks like I managed to mess it up two ways. The
registers must be r2,r3 and r3 has the high bits. I'll fix it for v2.

Thanks,
drew

