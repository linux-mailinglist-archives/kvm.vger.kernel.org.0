Return-Path: <kvm+bounces-544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 566F37E0C05
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 00:12:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A7B928202F
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 23:12:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C0B25101;
	Fri,  3 Nov 2023 23:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3gVAx73U"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4EE250F1
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 23:12:19 +0000 (UTC)
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B530D52
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 16:12:18 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1cc385e90a9so20313115ad.1
        for <kvm@vger.kernel.org>; Fri, 03 Nov 2023 16:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699053137; x=1699657937; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kWpNJzpcviJ8HN4AR4VYrTNI3mSogXEyInh9qBThUzw=;
        b=3gVAx73UHIgdqnkgpSXTaffpSMJfpHm942IWhx3UizBYlrunpz1OsrmfugEwdqwtOd
         z2ckacnFPzGbJIob5uBi0q+sTwuzYm8alNflVKINsT1FUl/Ub/P7ZCNDRPqI7+5A2474
         +9JvPHxHqLX3jLSwFIf/6cMlNTLFJnjV5ZAcbfwUQxm6ApJ2EN/NuJ3w6KU5WLhjIdle
         eca+NOSGyvgGUMcbf431VictHWyq5zWoebR2995bgMj1CXJdYsrT+2ycE1ttPanr43t2
         ootP0/JQuyzzHa9Niv9D4fgK8oqeMWSZWDaSQNP1ctyGcgjKE++tjOor7xoJ0HDsIq9Q
         Op3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699053137; x=1699657937;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kWpNJzpcviJ8HN4AR4VYrTNI3mSogXEyInh9qBThUzw=;
        b=Mtrb4xEe8rluyQ1yWqYW25ut/zrPg9zXw5ZivcLwSRbB6RG3GAqowgIj09lDxv0f3C
         R3IGHjUAUL+K4ajgXorfcdEoUvNIDepQPXSUaojZidd8nUeWBBliCXr5Qp8qqzpQEX2v
         0bHrd5Ppb6bkD6qjfZoETuvSTQhNi8vbWVYUzg+NAviSfuR7+LsteT6bIKG4cfUnDcfk
         71ZGCF1a64LtISta8D8q9qjrQIQbk8S8KBs8oJiqhJdI5w2XhSkdR+2Y3E7u7VjZVHCD
         +qL0E5cusIGTtl4cmykldM+ibSZ65l21ng/jUzGodNd2OPbp1l2IBZroHHaxtp4Qy0RM
         9IsQ==
X-Gm-Message-State: AOJu0Yyfq4FiHMYaDJHVqX6BWDYnAMigy07B+Zr2sh9bW+HXOvSIYiwh
	THwBqdNB+berXLlCL7rOqScewI0eCq0=
X-Google-Smtp-Source: AGHT+IFSO9Ge1yBsJBn5l1J8siOSY/aVOAMFxvQrCCJE97w9Asv0vaEXbHVWsg9syCa1FdKi2anFw4FJ3H0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ac8e:b0:1cc:30cf:eae6 with SMTP id
 h14-20020a170902ac8e00b001cc30cfeae6mr365192plr.10.1699053137621; Fri, 03 Nov
 2023 16:12:17 -0700 (PDT)
Date: Fri, 3 Nov 2023 16:12:16 -0700
In-Reply-To: <8c6f06ae-d1d3-40ea-9bed-8ca949eaff5f@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231002095740.1472907-1-paul@xen.org> <20231002095740.1472907-6-paul@xen.org>
 <ZUGScpSFlojjloQk@google.com> <8c6f06ae-d1d3-40ea-9bed-8ca949eaff5f@xen.org>
Message-ID: <ZUV-UG-Tm6HREWi2@google.com>
Subject: Re: [PATCH v7 05/11] KVM: pfncache: allow a cache to be activated
 with a fixed (userspace) HVA
From: Sean Christopherson <seanjc@google.com>
To: paul@xen.org
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 02, 2023, Paul Durrant wrote:
> On 31/10/2023 23:49, Sean Christopherson wrote:
> > On Mon, Oct 02, 2023, Paul Durrant wrote:
> > > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > > index 6f4737d5046a..d49946ee7ae3 100644
> > > --- a/include/linux/kvm_types.h
> > > +++ b/include/linux/kvm_types.h
> > > @@ -64,7 +64,7 @@ struct gfn_to_hva_cache {
> > >   struct gfn_to_pfn_cache {
> > >   	u64 generation;
> > > -	gpa_t gpa;
> > > +	u64 addr;
> > 
> > Holy moly, we have unions for exactly this reason.
> > 
> > 	union {
> > 		gpa_t gpa;
> > 		unsigned long addr;
> > 	};
> > 
> > But that's also weird and silly because it's basically the exact same thing as
> > "uhva".  If "uhva" stores the full address instead of the page-aligned address,
> > then I don't see a need for unionizing the gpa and uhva.
> 
> Ok, I think that'll be more invasive but I'll see how it looks.

Invasive is fine.  Not ideal, but fine.  If the resulting code is a mess, then
that's a problem, but churn in and of itself isn't awful if the end result is a
net positive.

> > kvm_xen_vcpu_get_attr() should darn well explicitly check that the gpc stores
> > the correct type and not bleed ABI into the gfn_to_pfn_cache implementation.
> 
> I guess if we leave gpa alone and make it INVALID_GPA for caches initialized
> using an HVA then that can be checked. Is that what you mean here?

Yep, that should work.

