Return-Path: <kvm+bounces-5472-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E382E8224C5
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C6D5284642
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 22:33:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D016817997;
	Tue,  2 Jan 2024 22:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JuKSpoJN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD301798C
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 22:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704234792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=InpOfT2E7Tqmz/iJUFZq/GV7WFjIogIQCOUR5Q83uaQ=;
	b=JuKSpoJNmV5zsRJpP6hIcYL8OfD2UFUNAcAm6TfFstg0rPEgLOsJT7n22MsTZ6EFA0WIEu
	Z/dYxHcoZblk4bhiPLrSsw1mcQFHVORK2dlcnlzgUVHn3HHnCMTMiO9xbXILEAx4V4q6yJ
	TgDt1M6R+OmOTdRK2ENrfEiZ4ziLwFw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-4wYZJHzIMOGNz2pGka3e1A-1; Tue, 02 Jan 2024 17:33:11 -0500
X-MC-Unique: 4wYZJHzIMOGNz2pGka3e1A-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40d5ab2fbc9so54731405e9.3
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 14:33:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704234790; x=1704839590;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=InpOfT2E7Tqmz/iJUFZq/GV7WFjIogIQCOUR5Q83uaQ=;
        b=PXseqPlIPyNcRu07SPYAtSdbUppw3UNvpLnkcw6RLgz48x+C9Xk4XTrsOPMP4DTUbu
         DhqhXelZzbtXqklAYKuUmhcf0AZPuZLXdObf7lgC6YPXKgI6/ig2B6nCf89BFb0bM5mX
         7D1Z6HNhQbbaxKXijQIaE2SMywwydr+LVCWPjOBP447mwGnJQeZgVxlsRGrd8eeCaaNp
         jMnWdgBYSEv+QZhge5NvMBEQm9/3sdy6ZM6zkKS5XFIwn8P4zgt8tcaE60/RHxyrISXJ
         AWDRf+7MMeT8UpzDECWhp3A+AFN9EQieOKSI45DBpbzlWxpKpc4ZXT2tOC94LUxFxpqi
         u5Dg==
X-Gm-Message-State: AOJu0Yx3sDhSExHWsLpCv6c+QJTXzTi0M46Uuak+2tec+sfccX8MOXit
	jfkbKxVrpTSgVh2/KLJ5Z5dx6leDp0SkYZNlotDViJETQbRUNQCunGniH8JyhFQKbCBhR7d6y3J
	MEcra3Li2Kq9DBsF3pRBc+vGLcVb8
X-Received: by 2002:a05:600c:ce:b0:40d:87c6:5e9c with SMTP id u14-20020a05600c00ce00b0040d87c65e9cmr1987522wmm.181.1704234790133;
        Tue, 02 Jan 2024 14:33:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFoRoaDqBAgyBHODiEey6e4bbsAjQYmWR5eN6/aHsnYO/Lfx5lRPxLMrx6jq8/V3SSd+YzUqQ==
X-Received: by 2002:a05:600c:ce:b0:40d:87c6:5e9c with SMTP id u14-20020a05600c00ce00b0040d87c65e9cmr1987513wmm.181.1704234789917;
        Tue, 02 Jan 2024 14:33:09 -0800 (PST)
Received: from starship ([147.235.223.38])
        by smtp.gmail.com with ESMTPSA id m1-20020a05600c4f4100b0040d5b849f38sm370659wmq.0.2024.01.02.14.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jan 2024 14:33:09 -0800 (PST)
Message-ID: <55f330aee9267a0ab7bb7dfbbd9ca0f41e59eaae.camel@redhat.com>
Subject: Re: [PATCH v8 07/26] x86/fpu/xstate: Warn if kernel dynamic
 xfeatures detected in normal fpstate
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com, 
	pbonzini@redhat.com, dave.hansen@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Wed, 03 Jan 2024 00:33:07 +0200
In-Reply-To: <20231221140239.4349-8-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
	 <20231221140239.4349-8-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-12-21 at 09:02 -0500, Yang Weijiang wrote:
> Kernel dynamic xfeatures now are __ONLY__ enabled for guest fpstate, i.e.,
> never for normal kernel fpstate. The bits are added when guest FPU config
> is initialized. Guest fpstate is allocated with fpstate->is_guest set to
> %true.
> 
> For normal fpstate, the bits should have been removed when initializes
> kernel FPU config settings, WARN_ONCE() if kernel detects normal fpstate
> xfeatures contains kernel dynamic xfeatures before executes xsaves.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/kernel/fpu/xstate.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
> index 3518fb26d06b..83ebf1e1cbb4 100644
> --- a/arch/x86/kernel/fpu/xstate.h
> +++ b/arch/x86/kernel/fpu/xstate.h
> @@ -185,6 +185,9 @@ static inline void os_xsave(struct fpstate *fpstate)
>  	WARN_ON_FPU(!alternatives_patched);
>  	xfd_validate_state(fpstate, mask, false);
>  
> +	WARN_ON_FPU(!fpstate->is_guest &&
> +		    (mask & XFEATURE_MASK_KERNEL_DYNAMIC));
> +
>  	XSTATE_XSAVE(&fpstate->regs.xsave, lmask, hmask, err);
>  
>  	/* We should never fault when copying to a kernel buffer: */

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


