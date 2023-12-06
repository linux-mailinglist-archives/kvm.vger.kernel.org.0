Return-Path: <kvm+bounces-3700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7808807346
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:05:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 699B1281F8E
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 15:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F69E3EA97;
	Wed,  6 Dec 2023 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DMjoiCgp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38EC9A
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 07:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701875104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jJdqQz+j66uuKVQcTJXhfyo35jBHUCQcBJKCdIlZVYk=;
	b=DMjoiCgpgsmTJL3dywwS2Jc3+Ta3b3On4qBamwV1ovSHGGwebnvHFso3GQ5o/vb+LQb8BN
	NBtAC69m6Klq+NgXYtc5KWaH4c6KibDNNqUR29jlsC9hJUt7nZOt8InB4cKld8btt+yRjR
	FprxDw2Ffk0Bbqy4vQl35/CIB41sxR4=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-RiskT-JDNOylJhd0QbjzoQ-1; Wed, 06 Dec 2023 10:04:58 -0500
X-MC-Unique: RiskT-JDNOylJhd0QbjzoQ-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-58e157f489dso7191104eaf.0
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 07:04:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701875097; x=1702479897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJdqQz+j66uuKVQcTJXhfyo35jBHUCQcBJKCdIlZVYk=;
        b=H5HI+RtMQDPt2/2MsTl/zCz0zNCoUMW8wR5knlJkOqBbaBq23GRjiCUXXx8Lcoc3PE
         74KY78K2x3l7v7aD/1HApTiDJ/C1nI9kh/wcTt4eUgku6SMfsCDYvK6E1THBRbmhHhPj
         R3gWEXbEdTMBQGH+vaoxTcl/t0bjcJmNOhCk62h8Uae4SlPYzL3WK1y55S0GmOI/6XzU
         aFfwGBKefpeWkJzVOY9Oyr0wLtsvAIqm1+IvRsuEGaO1oFuMw4zBFgOutuvHXWo8Dnya
         ZbDwSQozwYBjf1RmsesYjibihswf7zeAlk1R2Z5IUGfWIrRIYH7IWF0c/8TNKINakCqf
         U7cA==
X-Gm-Message-State: AOJu0YxLtN4XKks+6TR8DtNA4c9Ny8HknNaFkxgBTIoEfnT9MGO9xYm5
	1A1y91Nrh1RvvcFEYlVWMLhCmYtThg5brEAspI7rVZ2qY6G1Ws6ivI/Uva8qgab4eNImB3Dh0hK
	o6DZrVrI9AxLtJAzHppYRZgwTMyTa
X-Received: by 2002:a05:6358:91e:b0:170:6ed7:3915 with SMTP id r30-20020a056358091e00b001706ed73915mr500577rwi.57.1701875097493;
        Wed, 06 Dec 2023 07:04:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEKMm71528Ga8tz7EfKhVM+4FsTdLZHWMBtOB5p3o/0lcUbNOWGvhMWrtqJTy4cGoHG0lWMn7Grm97sF2VcejQ=
X-Received: by 2002:a05:6358:91e:b0:170:6ed7:3915 with SMTP id
 r30-20020a056358091e00b001706ed73915mr500552rwi.57.1701875097139; Wed, 06 Dec
 2023 07:04:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205222816.1152720-1-michael.roth@amd.com>
 <CABgObfb0YmHuw6v9AGK6FpsYA1F3eV2=4RKaxkmVrp97QCDM3A@mail.gmail.com> <20231206144605.mwphsaggqumiqh3k@amd.com>
In-Reply-To: <20231206144605.mwphsaggqumiqh3k@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 6 Dec 2023 16:04:43 +0100
Message-ID: <CABgObfaF=rJL-V0vBTnNMGFreRD2cJCjkYHxYBFjZktyd+dH8A@mail.gmail.com>
Subject: Re: [PATCH v2 for-8.2?] i386/sev: Avoid SEV-ES crash due to missing
 MSR_EFER_LMA bit
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, Marcelo Tosatti <mtosatti@redhat.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Akihiko Odaki <akihiko.odaki@daynix.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 3:46=E2=80=AFPM Michael Roth <michael.roth@amd.com> =
wrote:
> > There is no need to check cr0_old or sev_es_enabled(); EFER.LMA is
> > simply EFER.LME && CR0.PG.
>
> Yah, I originally had it like that, but svm_set_cr0() in the kernel only
> sets it in vcpu->arch.efer it when setting CR0.PG, so I thought it might
> be safer to be more selective and mirror that handling on the QEMU side
> so we can leave as much of any other sanity checks on kernel/QEMU side
> intact as possible. E.g., if some other bug in the kernel ends up
> unsetting EFER.LMA while paging is still enabled, we'd still notice that
> when passing it back in via KVM_SET_SREGS*.
>
> But agree it's simpler to just always set it based on CR0.PG and EFER.LMA
> and can send a v3 if that's preferred.

Yeah, in this case I think the chance of something breaking is really,
really small.

The behavior of svm_set_cr0() is more due to how the surrounding code
looks like, than anything else.

> > Alternatively, sev_es_enabled() could be an assertion, that is:
> >
> >     if ((env->efer & MSR_EFER_LME) && (env->cr[0] & CR0_PG_MASK) &&
> >        !(env->efer & MSR_EFER_LMA)) {
> >         /* Workaround for... */
> >         assert(sev_es_enabled());
> >         env->efer |=3D MSR_EFER_LMA;
> >     }
> >
> > What do you think?
>
> I'm a little apprehensive about this approach for similar reasons as
> above

I agree on this. I think it's worth in general to have clear
expectations, though. If you think it's worrisome, we can commit it
without assertion now and add it in 9.0.

Paolo


