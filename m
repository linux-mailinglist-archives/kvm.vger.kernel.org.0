Return-Path: <kvm+bounces-264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 573777DD967
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 00:59:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86ADA1C20D28
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 23:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D8E29CE7;
	Tue, 31 Oct 2023 23:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZLKDBjWB"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42061DFD7
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 23:58:56 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E221DF
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:58:55 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-da07b5e6f75so345635276.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698796735; x=1699401535; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9i9Iv3jiMg/J1qGB5P5psVE2uSLqd7nXP+oyj+C4sSw=;
        b=ZLKDBjWBM/QlML7IUgghULULuNQQrZ67XTste20kFGvnbzJ7Sd4MtgaHIVINXx056j
         BmVcornZLsQUA6+NS9cvzs3L9VDurK2AbLAnOqB0meHhSLbJpoQchu5Jbn/0oFZTLRz0
         1cOvbeBKgk87cnucW/N+nb6u2poqdqnNagG1lSeZ+/fVooDdrpID5a9Pq1yD9eSa7TRr
         BkGv32fcAosWc87mC3XYMna1dCeCPfmPeOcNtfkbYEAjPViFSHxgYTn4IAQZfYbhCu5C
         tc/5EQrlvOiAB5tVbmx7StgB+crtUdz4l+qUm9AlP150Q6KA7bx87IIsHTLp8EgBzmzO
         +Avw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698796735; x=1699401535;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9i9Iv3jiMg/J1qGB5P5psVE2uSLqd7nXP+oyj+C4sSw=;
        b=q6yUBhFOTDpu8PTNRPajlJ/ZURO/fugKZW0YkqJKjLA4FnTOD9cyeT2hHXvREMoCC5
         VKNgrMw2mg8TcvaIQp0kw67LMxnx/JcFyONfLpVHJvfA5x+IUQsOnXYVZ6+0RSk7fSPW
         BnIy48jSS68yvzPlKFp5B03z45cRiAOxCNr3DjKGgBAget+DYH492EtTU1mM8FrNsFZz
         gzbRgHI+U+jqUnYgPXI3b8uo1kET0DIRpdIBFza3vjds3njfI2S3siCawu4IJA4rESbY
         0UHkJUcRy2esnkmwUpm9SdkRaVnc6SQhVaTO5PGM42oRPG3u3rL0WIdFb8996hVnvyLS
         vwQg==
X-Gm-Message-State: AOJu0YwsbGF/+Y3v3GKn6R9dm2VA0ut7RqZJByjj8j8Fdui8SXrL5N7H
	iNYL/mW8YQ3Nm2xsWv8I7cMGhYIEdE8=
X-Google-Smtp-Source: AGHT+IGwTz/89tho+pKVku/Pj8lTv2+bIBWHCYW6TnvufRrdElQbeeQC7ZNZcNYtoG1+pQncgj/bqgALsNs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:264f:0:b0:da3:b467:af07 with SMTP id
 m76-20020a25264f000000b00da3b467af07mr11219ybm.2.1698796734909; Tue, 31 Oct
 2023 16:58:54 -0700 (PDT)
Date: Tue, 31 Oct 2023 16:58:53 -0700
In-Reply-To: <20231002095740.1472907-12-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231002095740.1472907-1-paul@xen.org> <20231002095740.1472907-12-paul@xen.org>
Message-ID: <ZUGUvdlxAoevcgJH@google.com>
Subject: Re: [PATCH v7 11/11] KVM: xen: allow vcpu_info content to be 'safely' copied
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
> If the guest sets an explicit vcpu_info GPA then, for any of the first 32
> vCPUs, the content of the default vcpu_info in the shared_info page must be
> copied into the new location. Because this copy may race with event
> delivery (which updates the 'evtchn_pending_sel' field in vcpu_info) we
> need a way to defer that until the copy is complete.

Nit, add a blank link between paragraphs.

> Happily there is already a shadow of 'evtchn_pending_sel' in kvm_vcpu_xen
> that is used in atomic context if the vcpu_info PFN cache has been
> invalidated so that the update of vcpu_info can be deferred until the
> cache can be refreshed (on vCPU thread's the way back into guest context).
> So let's also use this shadow if the vcpu_info cache has been
> *deactivated*, so that the VMM can safely copy the vcpu_info content and
> then re-activate the cache with the new GPA. To do this, all we need to do
> is stop considering an inactive vcpu_info cache as a hard error in
> kvm_xen_set_evtchn_fast().

Please, please try to write changelogs that adhere to the preferred style.  I
get that the preferred style likely doesn't align with what you're used to, but
the preferred style really doesn't help me get through reviews quicker.

> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index aafc794940e4..e645066217bb 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -1606,9 +1606,6 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
>  		WRITE_ONCE(xe->vcpu_idx, vcpu->vcpu_idx);
>  	}
>  
> -	if (!vcpu->arch.xen.vcpu_info_cache.active)
> -		return -EINVAL;
> -

Hmm, maybe move this check after the "hard" error checks and explicitly do:

		return -EWOULDBLOCK

That way it's much more obvious that this patch is safe.  Alternatively, briefly
explain what happens if the cache is invalid in the changelog.


>  	if (xe->port >= max_evtchn_port(kvm))
>  		return -EINVAL;
>  
> -- 
> 2.39.2
> 

