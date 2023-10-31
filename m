Return-Path: <kvm+bounces-217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94AF77DD4DB
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:44:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C56231C20C26
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 17:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2D89219EB;
	Tue, 31 Oct 2023 17:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fm7pQUbC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB78210F1
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:44:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2286ADA
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698774275;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vjtWvsFj0am0rYDH+Q7lI+mXlwPeVNGi1NsELi1tHIo=;
	b=Fm7pQUbCf4A5VnP3FPOsz5JNQR7XUgOz3WGwdBrL1MQVUeXeAay++ksXeTjK7jxXSY3eZg
	7T326lnFadtv15hPfbgIjADXe7/qcipEqpw6zZ/RM2rOrPHv8VjE5G6GY7gZjR86619LJw
	DORFPgYCuxnvy32wONVAklNOxDiTQ3w=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-7uOq8koJPimadt0ovXZiCQ-1; Tue, 31 Oct 2023 13:44:24 -0400
X-MC-Unique: 7uOq8koJPimadt0ovXZiCQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5093a1a0adcso280628e87.3
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:44:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698774262; x=1699379062;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vjtWvsFj0am0rYDH+Q7lI+mXlwPeVNGi1NsELi1tHIo=;
        b=mLuIxTlytqI9v9Ca7Q5uLYVniP/IBxePjbjHZf4LZRSbKU9aSCLX17R0wrXpTMICWD
         OYGfcXWRMNtVzpCrMWjdoESX9nOUVsGx1LncJDzhbD/PiGHDMCQg7dpbWV2RFqeY1ymV
         kalxP5NB4siw3lmSrsQMPL6Gsh8E2bxEp+ZS9ZH1mvA+uSEzMtWvTo5GTIDiPtWt4ZH1
         4wXspY+baAjE6CQOXVq1Ku+3eCYvE6A/SluHjvapklOMCfFdB6l+0VBctp4IXQyl42kb
         Otf2oyWIkXPSgAv3JXxuoyZ5JVNZ0X2VpArFjmzHsRBZtnOgKsRKFQQs0VAajnqNtILT
         1MPg==
X-Gm-Message-State: AOJu0YwLtCNqpYEaKT4ja9qlt/oz4lHBMJM8XXYPeFpXfW1DDyCseXwc
	/P4SvUjBeDKIehvm+7Bj7zu4YxukGDrtvCxHSPP/es14tPlRbtGVi23i7b4gDnZOAtQeHHm8vOx
	wWZjX/bwtTXMm
X-Received: by 2002:a05:6512:3b3:b0:507:99d6:95fc with SMTP id v19-20020a05651203b300b0050799d695fcmr9172417lfp.45.1698774262707;
        Tue, 31 Oct 2023 10:44:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFV6sOHpaJ3EyONEX+ohOPSasXf97pDEXBx9ljvLy8uz4xZRam6mOr1a98gGLj4gQyTHZMpA==
X-Received: by 2002:a05:6512:3b3:b0:507:99d6:95fc with SMTP id v19-20020a05651203b300b0050799d695fcmr9172404lfp.45.1698774262513;
        Tue, 31 Oct 2023 10:44:22 -0700 (PDT)
Received: from starship ([89.237.100.246])
        by smtp.gmail.com with ESMTPSA id a8-20020adffac8000000b003296b488961sm1997228wrs.31.2023.10.31.10.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Oct 2023 10:44:22 -0700 (PDT)
Message-ID: <17c85a216c87a2a91bdfd8f34659df1dfb1d8f63.camel@redhat.com>
Subject: Re: [PATCH v6 04/25] x86/fpu/xstate: Introduce kernel dynamic
 xfeature set
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, "Edgecombe, Rick P"
 <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "Christopherson,, Sean"
 <seanjc@google.com>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>, "Hansen, Dave"
 <dave.hansen@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
 "john.allen@amd.com" <john.allen@amd.com>
Date: Tue, 31 Oct 2023 19:44:20 +0200
In-Reply-To: <eea8bf26-1c86-8e2b-9ded-cb0d09c08fcf@intel.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
	 <20230914063325.85503-5-weijiang.yang@intel.com>
	 <f16beeec3fba23a34c426f311239935c5be920ab.camel@intel.com>
	 <eea8bf26-1c86-8e2b-9ded-cb0d09c08fcf@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2023-09-15 at 14:42 +0800, Yang, Weijiang wrote:
> On 9/15/2023 8:24 AM, Edgecombe, Rick P wrote:
> > On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > > +static void __init init_kernel_dynamic_xfeatures(void)
> > > +{
> > > +       unsigned short cid;
> > > +       int i;
> > > +
> > > +       for (i = 0; i < ARRAY_SIZE(xsave_kernel_dynamic_xfeatures);
> > > i++) {
> > > +               cid = xsave_kernel_dynamic_xfeatures[i];
> > > +
> > > +               if (cid && boot_cpu_has(cid))
> > > +                       fpu_kernel_dynamic_xfeatures |= BIT_ULL(i);
> > > +       }
> > > +}
> > > +
> > I think this can be part of the max_features calculation that uses
> > xsave_cpuid_features when you use use a fixed mask like Dave suggested
> > in the other patch.
> 
> Yes, the max_features has already included CET supervisor state bit. After  use
> fixed mask, this function is not needed.
> 
> 
My 0.2 cents are also on having XFEATURE_MASK_KERNEL_DYNAMIC macro instead.

Best regards,
	Maxim Levitsky





