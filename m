Return-Path: <kvm+bounces-72956-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UG/jGzsCqmm9JQEAu9opvQ
	(envelope-from <kvm+bounces-72956-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:22:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DCCC8218DFD
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 23:22:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6094630205C7
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 22:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CCA33630BD;
	Thu,  5 Mar 2026 22:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="15wpX1T1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810043537FE
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 22:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772749367; cv=pass; b=rHGh0aaRROl3lg0htjAy4mJKco3E+uAulZoGCGV/WNDRQjUcr/yrZwRTbNHPLChyE0OiobTIzkM5VktInOkkUPDgFbfKjQoeMmMjUHpsybq+VkeOeqqE7EUl1uPG5md6aXcHOYyrhoVTA0RoCj6T5m6aA7nf1uFnNMvFIABvCis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772749367; c=relaxed/simple;
	bh=VcKD9Xbo82EN/un3rpfZj7CWX9JGNQtmXmERmrC6bew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lgsYoOytafIQuFE/2LFL7vbnWHSE7rGzTPcbikR4dVFFYKj52CTemUoXGBd5PwEBbGEeKa4z3MWacOD0GvUpkejkXXdgI9Es1CYGJ6YNYhroa/lkjFhDVwlDF0oDuZz72YcWdjJAobl7sGY9a18C/LRH07585N9R+XuwGBqiHEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=15wpX1T1; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-661175cbdceso3825a12.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 14:22:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772749365; cv=none;
        d=google.com; s=arc-20240605;
        b=BYsoubKl5fmWjCiIHkBo39WirdimeJ/pTrB7k4/JS4RobexBSMqj4sRQPeq7Yy0hjH
         sQ5hPRWjcfmMLDuYm+sij6DRmU94ut+pCbUcMSJ7ls8MxnKNlhsZyRFWg8LsVZOvRR48
         SaAI0eLqslUJZUwmFrcHjQF8iQOpa2CjV9MLYl84J2G1i/sglPKGsAJUZ+4Bm2gmupo6
         S4wkOSX0aCNkQB0VyAEfc/GiXqR4LhSYKo0HZnK8DpxCDHut6qQgD2EubTeLD6fPqpOf
         BjUwUTwbHC4Xc6FanOnxrITArBeW8qvGUkV0mlGLDPuruI4Ryr9966AzekqsvTq0qoxs
         71LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yi5FpkF6YYDX4JGfkcCVyuvsb0KRvbcv5i2l1v3X2vY=;
        fh=4CdBWbf1EVyX7w+1Ym+x2+a3Qm6e/EVQRUh4IHFu7vU=;
        b=V/f/Pj7v+eFMXAvOAokUs7l/rsDP+UxfIdx2XV6nRgrHeBVpryTMAy2NpN4nXN6orf
         vDSg9GA0o2I8e5//tRXGL75UMNLosaCrlnYakIovDPZ7hsgFe1Ki1sZ+rFJR/x/VtWB4
         L2q2LctS8hgI784Qk5KnUSCdcta0q2WnJmyhjlBdDqlqXIqUdb8oUWY9D7i/T3pnZQkF
         xXbkNDe9cRsK2otm76pkDDoFAH6cUbyt+ma3Z0BA4NjPDOrPczp7YIPHqf5ySDLmb1RT
         /XeAa3siA1+YyDurLsfOHG6zS4fRmtY0i1MJntOzSEVAAN8e2Mqm/ColUHj57QrPK/VB
         OV0Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772749365; x=1773354165; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yi5FpkF6YYDX4JGfkcCVyuvsb0KRvbcv5i2l1v3X2vY=;
        b=15wpX1T1geQlMlNcFn10vmj3uhwkeKNPUCywAHEU/e/0rmWxVl7DjgLudFNQZCQ0rB
         gQhBc6PyqjLVuKxjLukLXyukYnhCbCuYNQuT/suEARA1IjW0EwNVPP0LavwbYr8mtvtl
         Utax2RAsiHvffUYpcMIfBVQBLuambS/9GrrI/es44iyMFMYnDzEbGwFM5IoNVa5+9udF
         YMj3iE5GPYgqE82wHL8UrylK4WemguCntGaDR9rsXpUeHwQwQ2TcT1IWHASDF/u3KPOh
         nZJ7re0SotbhbONt5Sdpvwkjj6Rq5kagwCvdJF+vyVy3dxxr3hs6rcqCE9oSKSI43GZ3
         G3YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772749365; x=1773354165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yi5FpkF6YYDX4JGfkcCVyuvsb0KRvbcv5i2l1v3X2vY=;
        b=A4ipfZyIfUIMVJal75xC61Gh31rQuhNDOL4/nvA5eZOeWXc/h8WhIbbYLm5rBBz843
         8+FJiHTub7XwuqFQhPE5Oom5xS9dIRTFID5TTJI1wsjFYMN1CXqgcIAe/6zP8p7jUk2n
         SR5kCp5Z9CPx+lhT4etlFb8qb1jrztwiyob15Ws5eg7yxpeHYmTYMNuFw7yT3IQM0hWp
         3oFJzNQps4J0J4rJ53r6ZVAIEFjuW2H2/rKRA+Nxv8ZJ5NdtrNeNNcxnbxIdLjqd9Stk
         5WsN1uGfY102ggWBSvckVZZA9UFTFgU/JPtjitxwSM2bYMvabWdtfTMwDWQgW+chGr0L
         Juew==
X-Forwarded-Encrypted: i=1; AJvYcCUNHpEcudwvmwqJOd+zeiCpernbAJU569IMwppVr3gYGfCS8JaigddllvVvgTXA1oCm8V0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFVcbDS6NZAJAHjwt/+nKBnQR+sCmDv1DNCDQ0JvzK577/PDse
	Y83zQClmzyR8Z1QO3efHm3rNGYpZR+YAnWGSCrtjXBo4wFJssk9Px1v24/ZbLw+KSEmA7+0Pg3+
	6i4QhI/pc3vsdOPze3C926DDiht8u13da/5/aiPsT
X-Gm-Gg: ATEYQzwkc0VI/qU8e0DHGv2NwFWP16SuwT+UvrcBQVGxkIckehFzW8l3h9F/dtXkQSu
	D5ZeJ1Qds5SMK3acI1GE+3ev6PYf+dOC/IbvhSA8rXoxBzHIGj5LARfun4wQaGMGNuasHdKTu/l
	VoVkrgAJq4nn/dNrCN4Dgm6bUpV5+QSEa1avC6iWetwTmZc8I9n5s6MQmertNJPOB7Xs8ky8m6J
	w2Xss3DymlOL9txKq/SvNAMut2kak/s+SMTXGrsZFXssWYze0jDuL7B4gyiMzHgNa7kvAaXNieG
	/BSOi1w=
X-Received: by 2002:a05:6402:2755:b0:661:169e:acd3 with SMTP id
 4fb4d7f45d1cf-66194dae11cmr5299a12.9.1772749364455; Thu, 05 Mar 2026 14:22:44
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250804064405.4802-1-thijs@raymakers.nl> <ac94394405bf7e878c8ff0acf87db922dc4af48c.camel@infradead.org>
In-Reply-To: <ac94394405bf7e878c8ff0acf87db922dc4af48c.camel@infradead.org>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 5 Mar 2026 14:22:32 -0800
X-Gm-Features: AaiRm52C2_eyPwgEA5BW-CwzQ1jb8cy-Wu2D4tx6pUyRrgZuI8_suYh12JHLoSY
Message-ID: <CALMp9eTSb3YrLRxnSbYQmAsK1SKA3Job6z2VjUWcKpPOGbWvRw@mail.gmail.com>
Subject: Re: [PATCH v3] KVM: x86: use array_index_nospec with indices that
 come from guest
To: David Woodhouse <dwmw2@infradead.org>
Cc: Thijs Raymakers <thijs@raymakers.nl>, kvm@vger.kernel.org, 
	"Orazgaliyeva, Anel" <anelkz@amazon.de>, stable <stable@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DCCC8218DFD
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	NEURAL_HAM(-0.00)[-1.000];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-72956-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Action: no action

On Thu, Mar 5, 2026 at 12:31=E2=80=AFPM David Woodhouse <dwmw2@infradead.or=
g> wrote:
>
> On Mon, 2025-08-04 at 08:44 +0200, Thijs Raymakers wrote:
> > min and dest_id are guest-controlled indices. Using array_index_nospec(=
)
> > after the bounds checks clamps these values to mitigate speculative exe=
cution
> > side-channels.
> >
>
> (commit c87bd4dd43a6)
>
> Is this sufficient in the __pv_send_ipi() case?
>
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -852,6 +852,8 @@ static int __pv_send_ipi(unsigned long *ipi_bitmap,=
 struct kvm_apic_map *map,
> >       if (min > map->max_apic_id)
> >               return 0;
> >
> > +     min =3D array_index_nospec(min, map->max_apic_id + 1);
> > +
> >       for_each_set_bit(i, ipi_bitmap,
> >               min((u32)BITS_PER_LONG, (map->max_apic_id - min + 1))) {
> >               if (map->phys_map[min + i]) {
>                         vcpu =3D map->phys_map[min + i]->vcpu;
>                         count +=3D kvm_apic_set_irq(vcpu, irq, NULL);
>                 }
>         }
>
> Do we need to protect [min + i] in the loop, rather than just [min]?
>
> The end condition for the for_each_set_bit() loop does mean that it
> won't actually execute past max_apic_id but is that sufficient to
> protect against *speculative* execution?
>
> I have a variant of this which uses array_index_nospec(min+i, ...)
> *inside* the loop.

Heh. Me too!

