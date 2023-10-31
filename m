Return-Path: <kvm+bounces-262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DB347DD95D
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 00:49:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6515B21088
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 23:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A6627479;
	Tue, 31 Oct 2023 23:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WGRwVOPj"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876731D525
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 23:49:10 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD60DA
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:49:09 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5b31e000e97so19576567b3.1
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698796148; x=1699400948; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2LNHoFTQ3VJWlwRzthV25hP0hFBYO6DrUYoMIghO42k=;
        b=WGRwVOPj0lbAoJC34Jpa4EoUm0Ogaw6HBbY9W8SOnwiTBJINN4/gSv7oDnwMlZvq+u
         PMpzEt6iW4jwZfdZqccFe87ikhnP0vFVT2F3JUKmxA+iXB7VwI9SDDVoyI27bpzCSP99
         9bp8mVUgnvYWGqRv++dM2i8OrZHf1yWjrkKa6kxkDxa62iNX0g93cI68BW9DCsothqrl
         sqp7T4ZHo9midCmH/08gCH1Upx+nO+bV/Uup2WhyjxaHraB11VksKm5V9YOiniiz7IuG
         +pzmqWoinwe2JFx6m5QvlyxZseALxcOs9ShFWRLOy0qA/KSytF0PlQ1ZoU11EzVybkv9
         z0vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698796148; x=1699400948;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2LNHoFTQ3VJWlwRzthV25hP0hFBYO6DrUYoMIghO42k=;
        b=ZKT7iKjFBw7f3qAhDJrgzo4UVbxhwAwrhqfY6UPCb7sM0kIi4MUCPb53TkMsy/vCms
         DgX4tTM3i6VHwLK2q18KYU87Y45Lrn+VMgFvmRP1TApSd3dTSJEu2CpbZyZnmU9T+KMl
         oYOfNh/Cl+6BLEA4dIoCrAGwz6dIoZLQ+RxkevuSwKnAlN4bVensUFWcGkr6SmSOc4yI
         ZAvp73qQ3a8BASg1xlVOclziWBPIYM1M/qq1EXpOWDDz72MvUAtYlhsJmaDdfRnDweIs
         saLVyBgTiZ2I5fpx2CbJ9j62yXgokjpKGpwm0hDGWRdNov/wsdWPJ81tMAX15NnGhfVC
         hhGA==
X-Gm-Message-State: AOJu0YyA8e/JqxmlsPwxRkr1sN+r0LLF607xaPa/83ZptkSBzR/lXHDe
	2i1Dl02ZDT8dGKA1CWkN2L/YMOVWg+M=
X-Google-Smtp-Source: AGHT+IFMMXBTUxEcJ82/VuE2Gov3A80kz7vJZDrGFYO1Kznjt1NhqJ9Sh0hqXhm0/QN0ekH8AywEzg4Q8ck=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1083:b0:da0:567d:f819 with SMTP id
 v3-20020a056902108300b00da0567df819mr329941ybu.10.1698796148691; Tue, 31 Oct
 2023 16:49:08 -0700 (PDT)
Date: Tue, 31 Oct 2023 16:49:06 -0700
In-Reply-To: <20231002095740.1472907-6-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231002095740.1472907-1-paul@xen.org> <20231002095740.1472907-6-paul@xen.org>
Message-ID: <ZUGScpSFlojjloQk@google.com>
Subject: Re: [PATCH v7 05/11] KVM: pfncache: allow a cache to be activated
 with a fixed (userspace) HVA
From: Sean Christopherson <seanjc@google.com>
To: Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 02, 2023, Paul Durrant wrote:
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 6f4737d5046a..d49946ee7ae3 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -64,7 +64,7 @@ struct gfn_to_hva_cache {
>  
>  struct gfn_to_pfn_cache {
>  	u64 generation;
> -	gpa_t gpa;
> +	u64 addr;

Holy moly, we have unions for exactly this reason.

	union {
		gpa_t gpa;
		unsigned long addr;
	};

But that's also weird and silly because it's basically the exact same thing as
"uhva".  If "uhva" stores the full address instead of the page-aligned address,
then I don't see a need for unionizing the gpa and uhva.

kvm_xen_vcpu_get_attr() should darn well explicitly check that the gpc stores
the correct type and not bleed ABI into the gfn_to_pfn_cache implementation.

If there's a true need for a union, the helpers should WARN.

> +unsigned long kvm_gpc_hva(struct gfn_to_pfn_cache *gpc)
> +{
> +	return !gpc->addr_is_gpa ? gpc->addr : 0;

'0' is a perfectly valid address.  Yeah, practically speaking '0' can't be used
these days, but we already have KVM_HVA_ERR_BAD.  If y'all want to use the for the
Xen ABI, then so be it.  But the common helpers need to use a sane value.

