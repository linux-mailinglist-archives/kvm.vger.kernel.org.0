Return-Path: <kvm+bounces-6109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CFA182B5AB
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 21:02:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41C021F23E07
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 20:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AECC56775;
	Thu, 11 Jan 2024 20:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bYEsWHEd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654CC537E4
	for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 20:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705003353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YQwwxKRUEjSXUAuYik8yvl11rO3m+mqgyAXUo3DD30s=;
	b=bYEsWHEdAthB8SSUWbs5VZhDFh1/7aA+AXDw/OTtgIyLD7T0pNsxieR/ibeh8I2uwAMC9X
	OOvalu+UTkc7pPBmpYQWpqTtytBWJWFR2X+6/XP1ZORFLYdutphA/odT+sbjK7wDltYFzC
	fY1SajGf0tE1Zcs/duZl4Xq05srUbb0=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-LWqgtWybPty5uhltg2yqQw-1; Thu, 11 Jan 2024 15:02:32 -0500
X-MC-Unique: LWqgtWybPty5uhltg2yqQw-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6de5c255ce7so2033524a34.0
        for <kvm@vger.kernel.org>; Thu, 11 Jan 2024 12:02:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705003351; x=1705608151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YQwwxKRUEjSXUAuYik8yvl11rO3m+mqgyAXUo3DD30s=;
        b=h1UV8rllxtu7wx2/Feba6Z9pOu4e2o/O3swSgU/LTKHWyN5SsA6BLHhhu4OJiPNaPz
         9eQa/ir2T5WiGYG82dY7b/AYEd3bLJZmKgYUhN1EJHJhrj2EHkbwsO4QBCy282QlElXE
         XVJUZMOpUxEt5TevmIxoNU//3dEJCbK1XvYWEeLNj6MRh22PM91L8ASvyQywehDhxLGn
         QHf3AMl22yGauSnKT4eS4mnsRJTk1ughiPRwwEYfLladruIbP4AzRCXM7a2VRemBMmPB
         pHvkXLTjRU0cF7LlqekI72snItdjellw4bsi/A7rMnLLS3GKT7bp1+iV0sK29wotS5ni
         FEzg==
X-Gm-Message-State: AOJu0YxyyIdEAbbuu9iQ+1nq3zqyANc0rbt8iZVtaY3rSXor6vBX6RSq
	kpAxZDAQif4Uj7zLwiihXhWuBIq5sPEj+K+A5fSoBNRbMbIrJ+sMhGAUAEk2PYZtO9bHa88sZZL
	fRgcGx07Ojt8QrgVwhw5pTdCbAvCiZ0V87I+j
X-Received: by 2002:a05:6830:60d:b0:6dd:e445:343a with SMTP id w13-20020a056830060d00b006dde445343amr361437oti.53.1705003351129;
        Thu, 11 Jan 2024 12:02:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFEX89gfNTm81lC2Thkf3eJddP/I1IjgxceIV72oM8yYWfsbcRAdVZpCSx9qP+mrcPlYSo8Md7WXith8unGJeU=
X-Received: by 2002:a05:6830:60d:b0:6dd:e445:343a with SMTP id
 w13-20020a056830060d00b006dde445343amr361422oti.53.1705003350916; Thu, 11 Jan
 2024 12:02:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240110002340.485595-1-seanjc@google.com> <ZZ42Vs3uAPwBmezn@chao-email>
 <ZZ7FMWuTHOV-_Gn7@google.com> <ZZ9X5anB/HGS8JR6@linux.bj.intel.com> <ZaAWXSvMgIMkxr50@google.com>
In-Reply-To: <ZaAWXSvMgIMkxr50@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 11 Jan 2024 21:02:18 +0100
Message-ID: <CABgObfaByKFKRtLpY1yAJFmcY1WxWcn3tpeVw7Nho+qk0PFUbQ@mail.gmail.com>
Subject: Re: [PATCH] x86/cpu: Add a VMX flag to enumerate 5-level EPT support
 to userspace
To: Sean Christopherson <seanjc@google.com>
Cc: Tao Su <tao1.su@linux.intel.com>, Chao Gao <chao.gao@intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yi Lai <yi1.lai@intel.com>, 
	Xudong Hao <xudong.hao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 11, 2024 at 5:25=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> > It is unusual to assign a huge RAM to guest, but passthrough a device a=
lso may trigger
> > this issue which we have met, i.e. alloc memslot for the 64bit BAR whic=
h can set
> > bits[51:48]. BIOS can control the BAR address, e.g. seabios moved 64bit=
 pci window
> > to end of address space by using advertised physical bits[1].
>
> Drat.  Do you know if these CPUs are going to be productized?  We'll stil=
l need
> something in KVM either way, but whether or not the problems are more or =
less
> limited to funky software setups might influence how we address this.

Wait, we do have an API for guest physical address size. It's
KVM_GET_SUPPORTED_CPUID2: the # of bits is in leaf 0x80000008, bits
0:7 of EAX. In fact that leaf is what firmware uses to place the BARs.
So it just needs to be adjusted for VMX in __do_cpuid_func, and looked
up in selftests.

Paolo


