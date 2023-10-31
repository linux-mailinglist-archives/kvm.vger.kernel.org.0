Return-Path: <kvm+bounces-221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BA9167DD4F3
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:46:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B1EEB21065
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B0B422311;
	Tue, 31 Oct 2023 17:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z/qoFaqa"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7212230B
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:45:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC5191
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774345;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cO/Vlwo8YbBBaeYGTje2Kw7g6SOZ7cRjnvIaAY84PaE=;
	b=Z/qoFaqagkMd6TQRoFS+2VArljI5sjCxF6awBMN6lBn8Ellv0C+LFTflH4ZmrtHxdDbXSa
	EPyBxM6ICXNpQuKPDnbEhIXw3xUkqa7Mw5Vzxo1whW3Q9kyzbYRzb+7m48a98+uOqTAQCW
	1vt2R/w2lAwfPH4jQD2GwgVUJP89rGE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-fNI-CYr5OsSwoug1vzY-sg-1; Tue, 31 Oct 2023 13:45:43 -0400
X-MC-Unique: fNI-CYr5OsSwoug1vzY-sg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-32f8371247fso1403604f8f.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:45:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774342; x=1699379142;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cO/Vlwo8YbBBaeYGTje2Kw7g6SOZ7cRjnvIaAY84PaE=;
        b=p/L/t98cOzSaPgANWlVrEdg9XE6ECCk9rCWbY8GbiF2q5fdWECS1vdzVxky+Heeyzb
         fQNedyjpe90cGImFMIOUhDzXpypl521/6o+sPk3XT6ZwGu/7I0zU+30Hl9Z/uKksP5mD
         tng+/J3nnu9foMGCoZEbbSEZH3WfAEXp/qWqD7KWAwrYI0qd8alA5A/QucaOxQMghA7e
         iZ6WF8np8L/9v0Pz0ASE0UVRR5yK7tfGNOEHsDiqmbqz925z4VX/P6JrqUOKOMClTg0f
         3p5E6XihpQg/lXgL6BLePrBWujZ8FTGvIvJnNAyoUc26kW6pJXOHC3t84MSKis5/Lz0c
         YKjA==
X-Gm-Message-State: AOJu0YybiQE2ynBiJslCWrYxKGWGVIkuHOf9MtdXX1hnnOnpKPbmUTYK
	UotWAIcWTRAzMfnmsP21/Djr0zv1pQbsDHMpIZcDodWZi7cEiME0Lx03biJ9nRZIlL+dgobcMVo
	2a4XiLyObMRum
X-Received: by 2002:a5d:5b08:0:b0:32d:bb4a:525c with SMTP id bx8-20020a5d5b08000000b0032dbb4a525cmr15714446wrb.14.1698774342103;
        Tue, 31 Oct 2023 10:45:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHy2h6R3KqjFDxJ6i/qPbHjR5tnvvY3sC6qACoOqxagdoF8k/6p0aXaV1cTogc9EuQUwhR9sg==
X-Received: by 2002:a5d:5b08:0:b0:32d:bb4a:525c with SMTP id bx8-20020a5d5b08000000b0032dbb4a525cmr15714425wrb.14.1698774341870;
        Tue, 31 Oct 2023 10:45:41 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id l4-20020adff484000000b0032f79e55eb8sm1997449wro.16.2023.10.31.10.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:45:41 -0700 (PDT)
Message-ID: <110a791e0f057b52b7395569422100ede192cbbf.camel@redhat.com>
Subject: Re: [PATCH v6 08/25] x86/fpu/xstate: WARN if normal fpstate
 contains kernel dynamic xfeatures
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dave.hansen@intel.com, peterz@infradead.org, chao.gao@intel.com, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 31 Oct 2023 19:45:39 +0200
In-Reply-To: <20230914063325.85503-9-weijiang.yang@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-9-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> fpu_kernel_dynamic_xfeatures now are __ONLY__ enabled by guest kernel and
> used for guest fpstate, i.e., none for normal fpstate. The bits are added
> when guest fpstate is allocated and fpstate->is_guest set to %true.
> 
> For normal fpstate, the bits should have been removed when init system FPU
> settings, WARN_ONCE() if normal fpstate contains kernel dynamic xfeatures
> before xsaves is executed.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kernel/fpu/xstate.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
> index 9c6e3ca05c5c..c2b33a5db53d 100644
> --- a/arch/x86/kernel/fpu/xstate.h
> +++ b/arch/x86/kernel/fpu/xstate.h
> @@ -186,6 +186,9 @@ static inline void os_xsave(struct fpstate *fpstate)
>  	WARN_ON_FPU(!alternatives_patched);
>  	xfd_validate_state(fpstate, mask, false);
>  
> +	WARN_ON_FPU(!fpstate->is_guest &&
> +		    (mask & fpu_kernel_dynamic_xfeatures));
> +
>  	XSTATE_XSAVE(&fpstate->regs.xsave, lmask, hmask, err);
>  
>  	/* We should never fault when copying to a kernel buffer: */

I am not sure about this patch. It's true that now the kernel dynamic features
are for guest only, but in the future I can easily see a kernel dynamic feature
that will also be used in the kernel itself.

Maybe we can add a comment above this warning to say that _currently_ there are
no kernel dynamic features that are enabled for the host kernel.

Best regards,
	Maxim Levitsky





