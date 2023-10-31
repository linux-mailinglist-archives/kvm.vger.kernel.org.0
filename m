Return-Path: <kvm+bounces-258-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B42057DD942
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 00:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2FFBBB21061
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 23:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC632747F;
	Tue, 31 Oct 2023 23:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3jHmmzrL"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D702562F
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 23:28:19 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC86DB9
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:28:18 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da0c7d27fb0so5523805276.1
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698794898; x=1699399698; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ENayTSofjgkkxALl6xU7QgNf1DeiFgXjZ0+OmHefEsg=;
        b=3jHmmzrLswHkb926usWk6KwFRYAf3dhaV24pvAAqWaCWJkNqNtHIBtTXiPXdsXYZGi
         8IVCnDWgV8ttTywYHW3aJUJH6NgI/dLhyEdEo3+qi0FPQSMYrzDo6E07YF//QluI17aT
         yRsyJ0Og9erOBmWF5SNs8iKJ3tygFQUj8H/8FkvCgUl/Aiyj/GQDRyKa8O/jLJV0+Dsi
         sieh/B/oJPIudYHaVehS3qvF52xcEqsX4EPIeNaZTuU5roJvLrPxY6r8A1Pk33PCZnvj
         zTlHRdzwgRLkyORLr2H5EFpyLCna9HZLv2ZQ+Dw0Qkp0h+edUYiVQ/KoZ/vFPlX93XXW
         kSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698794898; x=1699399698;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ENayTSofjgkkxALl6xU7QgNf1DeiFgXjZ0+OmHefEsg=;
        b=q/A06B1inYNS4gu3Bm3jGro6u//H3v4u7ruZMfyvoUgr121l7PV6kjCMhao2SHcSx7
         Pinf8hJzULk51EcBv0HcweJ0W0uvx1rxJZakz4wlGOWKq/4GkW664k4M+FDu6uYkNL/t
         pNn+82hF0kpfLnQDCYoobNqyY+tWUXt6a+SA0h55n31QCNRYbri9x+4DN4bTrzJRml5v
         OTbeR2A1u06U9zUz1KCiq27gCGX4N1PGBmKJ7ooIC8xt0GVgg7lMq5+7Fje3FgutPc+b
         C+STtB1mffCEQk9tJyPaN6QYyIWNOxG2X314mv/z0kpRtqsSLTMtr8+rI76YhKdUBeTG
         hrRg==
X-Gm-Message-State: AOJu0YznVh7m27ymkeTEHjUdNNWf3+z2PHB5/48UVjk52E1T6NdHTX5j
	0ONFSu/xsAYN+BkBe/mNVWZyUh+OWlg=
X-Google-Smtp-Source: AGHT+IGg02iRvuNDO3zt4sBicsPmDFm2zxMX+TjRPmKchM2JIWMpwwHznBGiE6wu4jxsX/3bRzA5KbG/11I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8706:0:b0:d9a:be7b:283c with SMTP id
 a6-20020a258706000000b00d9abe7b283cmr290002ybl.0.1698794897986; Tue, 31 Oct
 2023 16:28:17 -0700 (PDT)
Date: Tue, 31 Oct 2023 16:28:16 -0700
In-Reply-To: <20231002095740.1472907-3-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231002095740.1472907-1-paul@xen.org> <20231002095740.1472907-3-paul@xen.org>
Message-ID: <ZUGNkCljRm5VXcGg@google.com>
Subject: Re: [PATCH v7 02/11] KVM: pfncache: add a mark-dirty helper
From: Sean Christopherson <seanjc@google.com>
To: Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 02, 2023, Paul Durrant wrote:
> From: Paul Durrant <pdurrant@amazon.com>
> 
> At the moment pages are marked dirty by open-coded calls to
> mark_page_dirty_in_slot(), directly deferefencing the gpa and memslot
> from the cache. After a subsequent patch these may not always be set
> so add a helper now so that caller will protected from the need to know
> about this detail.
> 
> NOTE: Pages are now marked dirty while the cache lock is held. This is
>       to ensure that gpa and memslot are mutually consistent.

This absolutely belongs in a separate patch.  It sounds like a bug fix (haven't
spent the time to figure out if it actually is), and even if it doesn't fix
anything, burying something like this in a "add a helper" patch is just mean.


> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index 0f36acdf577f..b68ed7fa56a2 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -386,6 +386,12 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
>  }
>  EXPORT_SYMBOL_GPL(kvm_gpc_activate);
>  
> +void kvm_gpc_mark_dirty(struct gfn_to_pfn_cache *gpc)
> +{

If there's actually a reason to call mark_page_dirty_in_slot() while holding @gpc's
lock, then this should have a lockdep.  If there's no good reason, then don't move
the invocation.

> +	mark_page_dirty_in_slot(gpc->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
> +}
> +EXPORT_SYMBOL_GPL(kvm_gpc_mark_dirty);

This doesn't need to be exported.  Hrm, none of the exports in this file are
necessary, they likely all got added when we were thinking this stuff would be
used for nVMX.  I think we should remove them, not because I'm worried about
sub-modules doing bad things, but just because we should avoid polluting exported
symbols as much as possible.

