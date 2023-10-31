Return-Path: <kvm+bounces-259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 530187DD94D
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 00:37:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22E161C20D02
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 23:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A159127EDE;
	Tue, 31 Oct 2023 23:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sv272kgL"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8807F4
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 23:37:10 +0000 (UTC)
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A1DB9
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:37:09 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5a31f85e361so3953568a12.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698795428; x=1699400228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwHYdHsj6Uwfawhe3YKJrgXMDrso8FFgWnxbTx5mjPc=;
        b=sv272kgLIXd+aMp9oEOAjPhiw+fyr1USMGCP4TarM/5D3mO6spRwzZQNJDXXeqCFre
         JF279z+F0Xh+CV/0r4CG8xFPJQaflsCFMuwZsTjMQw5TM28E59DeUho2f/WNucO77I+K
         rUQsaAX4xGdY5z6t48tz9rs3sC2xqn/GJlQRoeV6EzURzP18Y2fAjLJxtbGzanXpyo3Q
         IciN3QoCezTDDEXlMtQYitm0zaPhZgrHvFk4HEn914QLkuCPDxoIuF5auiG0Tg7Qe3Wx
         zGtb92X0AD3wsJ5RZPjOkpZ1CiJ/Ukm8LvqZ14AX6BB//0YRNvckxZsWBG4iP6g1Cx/5
         lkfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698795428; x=1699400228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZwHYdHsj6Uwfawhe3YKJrgXMDrso8FFgWnxbTx5mjPc=;
        b=eXQb5LIOQbKMaKrVvpFXTiV39IoR2ggZoiXiQj8vxeYDDEGK1Tau7dCtHDNE18CEs7
         tBEHl77qVlLWpmNPrbN6fG2WezbS1buzKKc0a3TuXoJSJs++S+8l7gypurbcMpOHcpbG
         rsCPz5utH/emOOeHnVpJ6mb2e1PjBA9v8nmoLB4ufQGE7Rk1M/hMeaaeib4HQD5DDO1r
         mk2EgDseydwp24newXAhNs+rQ2/kF5BWiXnNxgYxyqfuCPzSKzZbsSMInUd7xlHo86BV
         vkWN3TwvxSZQOCUpjVwAjOTRG2kMdTkfCvKKboSTXLkRaj8bMyqrOGgfxjMSnKsJRnXj
         M7nw==
X-Gm-Message-State: AOJu0Ywm4SKR15ANt9YUiQVdBFj9UQRwGWd8ih4CWw75eHE/4ZWtS9YB
	Q5uj2Yuk+H3Xm12uJ0q+ipYqlAP4R8E=
X-Google-Smtp-Source: AGHT+IGszvICnLgFRTXinSium5kgpeGfrV1GQxnH0N3W2FHBUTPitXFJJYcg6VYoCyFzg6goTjXUCucj0hM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7293:b0:1ca:8e79:53b7 with SMTP id
 d19-20020a170902729300b001ca8e7953b7mr235809pll.9.1698795428519; Tue, 31 Oct
 2023 16:37:08 -0700 (PDT)
Date: Tue, 31 Oct 2023 16:37:06 -0700
In-Reply-To: <20231002095740.1472907-4-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231002095740.1472907-1-paul@xen.org> <20231002095740.1472907-4-paul@xen.org>
Message-ID: <ZUGPosqRPNf155sX@google.com>
Subject: Re: [PATCH v7 03/11] KVM: pfncache: add a helper to get the gpa
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
> A subsequent patch will rename this field since it will become overloaded.

Too. Many. Pronouns.

  Add a helper to get the gpa of a gpc cache, as a subsequent patch will
  rename "gpa" to "addr".

> To avoid churn in places that currently retrieve the gpa, add a helper for
> that purpose now.

This is silly.  If this series added any protection against incorrect usage then
I could understand the helper, but this just end up being

	return gpc->addr_is_gpa ? gpc->addr : INVALID_GPA;

which is nasty.  IIUC, there's no WARN because kvm_xen_vcpu_get_attr() doesn't
pre-check that the cache is in the correct mode.  That's a really silly reason
to not harden the rest of KVM.

> diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
> index b68ed7fa56a2..17afbb464a70 100644
> --- a/virt/kvm/pfncache.c
> +++ b/virt/kvm/pfncache.c
> @@ -386,6 +386,12 @@ int kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned long len)
>  }
>  EXPORT_SYMBOL_GPL(kvm_gpc_activate);
>  
> +gpa_t kvm_gpc_gpa(struct gfn_to_pfn_cache *gpc)
> +{
> +	return gpc->gpa;
> +}
> +EXPORT_SYMBOL_GPL(kvm_gpc_gpa);

Any reason not to make this static inline?  Even in the final form, not making
this inlined seems silly.

Belatedly, same question for kvm_gpc_mark_dirty() I suppose.

>  void kvm_gpc_mark_dirty(struct gfn_to_pfn_cache *gpc)
>  {
>  	mark_page_dirty_in_slot(gpc->kvm, gpc->memslot, gpc->gpa >> PAGE_SHIFT);
> -- 
> 2.39.2
> 

