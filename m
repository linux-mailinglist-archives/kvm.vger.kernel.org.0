Return-Path: <kvm+bounces-2995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FF8E7FF901
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 19:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C0AB81C20EBD
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:03:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA9BF59147;
	Thu, 30 Nov 2023 18:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X8eJ9qTU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8EF197
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701367425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EXAA0SWAfHXtZ1ioopeEEFz3kDipZ0RHppWNUXlv9bg=;
	b=X8eJ9qTUNsz42MVnlZgUaaKMPdo4vz8V3S/8M3DtMvDszZPi0wtYjCI9iyJBiDWfZnrHfJ
	Lu7qqcmUMd4HNOaQtbSCYocLJJB2S3OuM2laljwiFD3UZiY+w/66sPfhvp6N+uSBzjSiRF
	lLg9Y+Fs97jC+SDGYPG9/yelSfdIPPc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-pGQAyQUTObqQkAZLPPTP3Q-1; Thu, 30 Nov 2023 13:03:43 -0500
X-MC-Unique: pGQAyQUTObqQkAZLPPTP3Q-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-a01991968f5so127946066b.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 10:03:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701367422; x=1701972222;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EXAA0SWAfHXtZ1ioopeEEFz3kDipZ0RHppWNUXlv9bg=;
        b=MbfsTlClwOA9lP6BXlr7sUpSOpnrHflVwv/LXYzLeSrKAB9FBua5pyCKLb+CAXWCad
         36lBB6bEZj5dUSqU/KGJeZyd5M8qWcBCwoxcqT/uA3rHFDN6vfWH05KJJppGanEcBRCu
         eKmG4oS3jaXPKs2H0OUrCTvvaFZICqxx40YHDGUFvyzTGD7VsMe7qW7m7/1/5TDnuyg8
         XYEh2mPt3LZxO+Ue53nquA+cJWLLBoXBFU8xfOc8RoouRK6iSiTS1USDRFu7Vb3m73SO
         CJ9+YO/NdXIJk8JyQ2GmX5KZJqfWwANpwdSl7yALEjtzbfL/4F19+Lki+XTfO7CKJ3JE
         XTOA==
X-Gm-Message-State: AOJu0YzOrkdwP9p24xrHdPMfvI0x8VsLCwWDhKncJBnnkQqJlhIFxYG0
	9L4zS7fep/8tf+bH8pRU0oTLYWFNTt7jB66kDOJv4fNKGITnSw2L90q5U+dkNT+Tl4YJ16R8P0G
	qcXpuC4KN/NMWKqvJzh6V
X-Received: by 2002:a50:d7c5:0:b0:54c:47cc:caf5 with SMTP id m5-20020a50d7c5000000b0054c47cccaf5mr8605edj.59.1701367067587;
        Thu, 30 Nov 2023 09:57:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGtc0eXLlwnLg30p/WJ6AWxa2PJaUXZoOYAwEip1wk4a2f/JyUmPPCTF24oDqoOPtL76C+mdA==
X-Received: by 2002:adf:f148:0:b0:332:c9c3:2cd3 with SMTP id y8-20020adff148000000b00332c9c32cd3mr4045wro.47.1701365355975;
        Thu, 30 Nov 2023 09:29:15 -0800 (PST)
Received: from starship ([5.28.147.32])
        by smtp.gmail.com with ESMTPSA id h1-20020a2eb0e1000000b002c9c0a59627sm190249ljl.41.2023.11.30.09.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 09:29:15 -0800 (PST)
Message-ID: <90cb8be18da40c62f6acbf2bee19ec046e122e49.camel@redhat.com>
Subject: Re: [PATCH v7 05/26] x86/fpu/xstate: Introduce fpu_guest_cfg for
 guest FPU configuration
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	 <kvm@vger.kernel.org>, "Yang, Weijiang" <weijiang.yang@intel.com>, 
	"pbonzini@redhat.com"
	 <pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, 
	"linux-kernel@vger.kernel.org"
	 <linux-kernel@vger.kernel.org>, "Hansen, Dave" <dave.hansen@intel.com>
Cc: "john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	 <peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>
Date: Thu, 30 Nov 2023 19:29:13 +0200
In-Reply-To: <742a95cece1998673aa360be10036c82c0c535ec.camel@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-6-weijiang.yang@intel.com>
	 <742a95cece1998673aa360be10036c82c0c535ec.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2023-11-28 at 14:58 +0000, Edgecombe, Rick P wrote:
> On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
> > +       /*
> > +        * Set guest's __user_state_size to fpu_user_cfg.default_size
> > so that
> > +        * existing uAPIs can still work.
> > +        */
> > +       fpu->guest_perm.__user_state_size =
> > fpu_user_cfg.default_size;


> 
> It seems like an appropriate value, but where does this come into play
> exactly for guest FPUs?

It is used because permission API is used for guest fpu state as well (for user features),
and it affects two things:

1. If permission is not asked, then KVM will fail to resize the FPU state to match guest CPUID.
2. It will affect output size of the KVM_GET_XSAVE2 ioctl, which outputs buffer similar to
other FPU state buffers exposed to userspace (like one saved on signal stack, or one obtained via ptrace).


Best regards,
	Maxim Levitsky


