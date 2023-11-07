Return-Path: <kvm+bounces-1043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 848697E4820
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 19:21:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4F04B20E9A
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D83F358B0;
	Tue,  7 Nov 2023 18:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aKG8zra9"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BA1358A5
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 18:20:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0015EED
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 10:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699381258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=smXxEHC6qlO87e+0frCeWNXZAHwYVPXXt7vNEwqbsLE=;
	b=aKG8zra9jvNWyK2Ta6yw637PexgcUL6bhX2Q8JDpdM6Und1/PtK0ST0zjDU6+A+W+u3UxN
	NSOzY9PQiC4rzyEFzS6xpSaQ2LMC8Uy3lBfH7XmYxYMO2lCxyql95keiwydNb7KAxfxgVY
	FYiKZnsWTH/HDsF1LmtERJXPIVCZO3U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-424-Qx08zwEDMPiYnTDe9OeQKg-1; Tue, 07 Nov 2023 13:20:56 -0500
X-MC-Unique: Qx08zwEDMPiYnTDe9OeQKg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-32db43129c6so3153603f8f.1
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 10:20:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699381255; x=1699986055;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=smXxEHC6qlO87e+0frCeWNXZAHwYVPXXt7vNEwqbsLE=;
        b=oE9Vrr6hZKR3Z3VADt9zCp0q0XOZmAYX3+RlmcnqbHQwAf4FkMaUF8V8VOTXyIYMCn
         7GhlpR4Bkclqz/4a0sB/Q0kNJhe5Ge6X/ej6ut+s3U3DabhahSbq1AgWHtjKUUMb6LT2
         DEpxSyUR18kaZ10WSq+Nnvlm4wZ3WlcN+1/yRwEzPwk7h/2ji270vqTOX7IE+R7fvTzT
         B3Sx63aPRAUIQhEGGhCOtIlqSu5N+o8xn57DX/vhYnOQqC/CgT6h36EbE5M6kQ1sKr9v
         ONwDiTjq4Wit18ABuHGm9gJSIJF++jsugT9lf8XGao1BICKyGkmEDKS9YgWpz4DYVk0r
         a+Pg==
X-Gm-Message-State: AOJu0YzhWrNR5KaPiHcFu3ERYeWxRlFdKvEbLyVQRzO9FvCHDdKmLzzk
	WsNAwZgVX7JUBbjCJ3Dw/HOXO9b9NelyBldxan/WTcUzaGvSsCixMdME0wYH4hKk5YV36rV5F3l
	j79yTD2SpNyPa
X-Received: by 2002:a05:6000:1448:b0:32f:bed7:ed82 with SMTP id v8-20020a056000144800b0032fbed7ed82mr9275832wrx.4.1699381255323;
        Tue, 07 Nov 2023 10:20:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEavbVRiNcLNN01xpVm5tUEZsoPOmPbGKEvXSQzqsZ3BGdSaTYjO5tJmrNdh6Gzo7ltTs8CIw==
X-Received: by 2002:a05:6000:1448:b0:32f:bed7:ed82 with SMTP id v8-20020a056000144800b0032fbed7ed82mr9275813wrx.4.1699381254957;
        Tue, 07 Nov 2023 10:20:54 -0800 (PST)
Received: from starship ([89.237.99.95])
        by smtp.gmail.com with ESMTPSA id g16-20020a5d5550000000b0032de6f95fb3sm2961277wrw.40.2023.11.07.10.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 10:20:54 -0800 (PST)
Message-ID: <c077e005c64aa82c7eaf4252f322c4ca29a2d0af.camel@redhat.com>
Subject: Re: [PATCH 6/9] KVM: SVM: Add MSR_IA32_XSS to the GHCB for
 hypervisor kernel
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: John Allen <john.allen@amd.com>, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, weijiang.yang@intel.com,
  rick.p.edgecombe@intel.com, x86@kernel.org, thomas.lendacky@amd.com,
 bp@alien8.de
Date: Tue, 07 Nov 2023 20:20:52 +0200
In-Reply-To: <ZUQvNIE9iU5TqJfw@google.com>
References: <20231010200220.897953-1-john.allen@amd.com>
	 <20231010200220.897953-7-john.allen@amd.com>
	 <5e413e05de559971cdc2d1a9281a8a271590f62b.camel@redhat.com>
	 <ZUQvNIE9iU5TqJfw@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2023-11-02 at 16:22 -0700, Sean Christopherson wrote:
> On Thu, Nov 02, 2023, Maxim Levitsky wrote:
> > On Tue, 2023-10-10 at 20:02 +0000, John Allen wrote:
> > > @@ -3032,6 +3037,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
> > >  		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
> > >  			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
> > >  	}
> > > +
> > > +	if (kvm_caps.supported_xss)
> > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
> > 
> > This is not just a virtualization hole. This allows the guest to set MSR_IA32_XSS
> > to whatever value it wants, and thus it might allow XSAVES to access some host msrs
> > that guest must not be able to access.
> > 
> > AMD might not yet have such msrs, but on Intel side I do see various components
> > like 'HDC State', 'HWP state' and such.
> 
> The approach AMD has taken with SEV-ES+ is to have ucode context switch everything
> that the guest can access.  So, in theory, if/when AMD adds more XCR0/XSS-based
> features, that state will also be context switched.
> 
> Don't get me wrong, I hate this with a passion, but it's not *quite* fatally unsafe,
> just horrific.
> 
> > I understand that this is needed so that #VC handler could read this msr, and
> > trying to read it will cause another #VC which is probably not allowed (I
> > don't know this detail of SEV-ES)
> > 
> > I guess #VC handler should instead use a kernel cached value of this msr
> > instead, or at least KVM should only allow reads and not writes to it.
> 
> Nope, doesn't work.  In addition to automatically context switching state, SEV-ES
> also encrypts the guest state, i.e. KVM *can't* correctly virtualize XSS (or XCR0)
> for the guest, because KVM *can't* load the guest's desired value into hardware.
> 
> The guest can do #VMGEXIT (a.k.a. VMMCALL) all it wants to request a certain XSS
> or XCR0, and there's not a damn thing KVM can do to service the request.
> 

Ah, I understand now. Everything makes sense, and yes, this is really ugly.

Best regards,
	Maxim Levitsky


