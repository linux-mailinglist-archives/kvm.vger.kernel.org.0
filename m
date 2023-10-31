Return-Path: <kvm+bounces-218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E34197DD4DD
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B6DEB21159
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E423920B14;
	Tue, 31 Oct 2023 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hAqk9KCU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F9C210EC
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:44:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220DBE4
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K9ATk+xEEF9iVCbTQHY9aknrLQ4S9DPQjw7UE6MLIMM=;
	b=hAqk9KCUhwkqSdx94acdxMtKGbhStVWi4tlD4cosNccMtpij80e83uoNlLcc5nKUcIL6Cg
	MDzlLqbU/EX3rs9oj5HX+MR4F3LuUX47BRxVbRnx+C3tDxKXsILcWdQyIE7j6G3DENhcCD
	X4DYx8SICzFypoK5hw5EStGaMd2XM+s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-T3W_R3wrMrmtctmgKTSUmg-1; Tue, 31 Oct 2023 13:44:34 -0400
X-MC-Unique: T3W_R3wrMrmtctmgKTSUmg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4084a9e637eso42395935e9.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774273; x=1699379073;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K9ATk+xEEF9iVCbTQHY9aknrLQ4S9DPQjw7UE6MLIMM=;
        b=OZp/RLUW7aJU+ZZTYZmkdCPoRX7APq6eFuHdhoTy1gmFlvlMqumKcqiKUjtgTPIG28
         7T/xlCPELmWvVmw/kC2bRjcyCcG3uRJ+F+811KThhfYGYXnnJcAhWt0Ug/7VfkAeaAhz
         9Sx/JFkYzgL3YeUyB2HmIhpRiEFymwE6h1aDTnQ6Bf1sdTIb8XcsEiex7apVcMSd9p8E
         /2boPVwU4QNzaFv7GvO4iP0Uy3mOPku+RqRg7KSbqy7fepjLm4mEvRX2TbDIOQLbFeVZ
         YG7TAX4YcPx/64omBPQA+gQoFgDpjk6RLltRX3wyCgyyPGJc0xFjdpiTrYeSVh++39Rk
         E2Kw==
X-Gm-Message-State: AOJu0Ywc58kl8Uc+KxmZuxsCuXNvfpbAFQdOcaBCHqt0mEMfRJbKT+lf
	0xN3AQdiUy4HC6mHk7dAfMR6aum9vY9SiVukj6zj29kGHCE/MKfJF3kBURT19Gu4V/cGYF+anUw
	o5BqgOiwggbVI
X-Received: by 2002:adf:fa88:0:b0:31f:f65f:74ac with SMTP id h8-20020adffa88000000b0031ff65f74acmr8266449wrr.70.1698774273664;
        Tue, 31 Oct 2023 10:44:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeysvPYg4MaZZIdSgqpx65k49R9Wi9ixUa/a8pT03ZkRiB0O0l996DGT5K6AOj66/xKarLLw==
X-Received: by 2002:adf:fa88:0:b0:31f:f65f:74ac with SMTP id h8-20020adffa88000000b0031ff65f74acmr8266441wrr.70.1698774273433;
        Tue, 31 Oct 2023 10:44:33 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id p14-20020adfcc8e000000b0032dbf32bd56sm2015046wrj.37.2023.10.31.10.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:44:33 -0700 (PDT)
Message-ID: <bb2fab66ced849d739ab08cef1772e0c335d64eb.camel@redhat.com>
Subject: Re: [PATCH v6 05/25] x86/fpu/xstate: Remove kernel dynamic
 xfeatures from kernel default_features
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Dave Hansen <dave.hansen@intel.com>, Yang Weijiang
 <weijiang.yang@intel.com>,  seanjc@google.com, pbonzini@redhat.com,
 kvm@vger.kernel.org,  linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, chao.gao@intel.com, rick.p.edgecombe@intel.com, 
	john.allen@amd.com
Date: Tue, 31 Oct 2023 19:44:31 +0200
In-Reply-To: <d8c3888c-4266-d781-5d0a-381a57a9c35c@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-6-weijiang.yang@intel.com>
	 <d8c3888c-4266-d781-5d0a-381a57a9c35c@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-09-14 at 09:22 -0700, Dave Hansen wrote:
> On 9/13/23 23:33, Yang Weijiang wrote:
> > --- a/arch/x86/kernel/fpu/xstate.c
> > +++ b/arch/x86/kernel/fpu/xstate.c
> > @@ -845,6 +845,7 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
> >  	/* Clean out dynamic features from default */
> >  	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
> >  	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> > +	fpu_kernel_cfg.default_features &= ~fpu_kernel_dynamic_xfeatures;
> 
> I'd much rather that this be a closer analog to XFEATURE_MASK_USER_DYNAMIC.
> 
> Please define a XFEATURE_MASK_KERNEL_DYNAMIC value and use it here.
> Don't use a dynamically generated one.
> 

I also think so.

Best regards,
	Maxim Levitsky





