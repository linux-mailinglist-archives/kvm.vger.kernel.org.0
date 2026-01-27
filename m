Return-Path: <kvm+bounces-69249-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8JO0A4PKeGmNtQEAu9opvQ
	(envelope-from <kvm+bounces-69249-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 15:24:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 548369591C
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 15:24:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A976030DB8EA
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 14:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E23F33B6FC;
	Tue, 27 Jan 2026 14:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TvqUyrcK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D823322FE11
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 14:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769523562; cv=pass; b=W5Q9PCjH7czcVWNwm6SrYY1NdqGiOJZNiXcjECA3RkSh/MK5ELQs5hfc7dvgovtrNg0Aw7EImk8+qwOCptHMkE1BQLfKRglN3Si99lETxRBnBeZ3tpMgZnt6/3V7HdS8MLsKyBZXu8Jdqasrj8Bjq2YztC6glsRc8JIdhIfJ03k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769523562; c=relaxed/simple;
	bh=VKiuTkJYE06Lgz/n80ZUl4qT2rrzEkJRyX893wVmM2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kt/U6hIbSTREotI9fVmTuAg2RZ/RxJSNLDu0AIqxzf52uIPY8zzgnnj8h3dTIVASCmIJ0c4mxlDtjeaUaJzvfwsVCF1mpEM1m71S6rt2jl74I6a7IIr9SHB0S63UhvElEtL9GF/JTg5Yq4yKQ9C4l3VcSHBb29N2g5ZkRyYBu3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TvqUyrcK; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6505d3adc3aso7491713a12.1
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 06:19:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769523559; cv=none;
        d=google.com; s=arc-20240605;
        b=PlmDxR2+kdQph9Nl6Xo90MEjidd+irxxyXy2X1h6366equAad2ITFHgHm17CAzESCr
         CB7C2+IkXFsFqr0AFhka+for0Lve/9uV1fqadUSm6NywfsMKr1iBg2JRrebEjAyuG78J
         wienLd0Q5YHBwWFcO82SN5ZvzCDkWO6n4VyIY+LANnFRfC+30K0mti0avYV2glSTGzNV
         0vQGwAe6dvtvA+eROWAFxSCThwkCqJ8ks/rlB7JcGJlfw2lmhpJjfaEBS7mEmVkvYY1s
         h851bkfVvAFfRId4edYDU4sAZjca4lFJ87Q07UCoGyXEqCeNNIOxfDrlhdefeXseitQT
         4YAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VKiuTkJYE06Lgz/n80ZUl4qT2rrzEkJRyX893wVmM2Y=;
        fh=xohT2DPlfbEXpujyWiyMGgR7inuyCoNS70/09q/N+iE=;
        b=jP0UqXBL7LypkfG2UPPTmETfwLj1vtGHk/ZGrMlO5ZLNB0fkTXahyb0y9SNKwxGP4p
         kZ8YjCGImBSarYWM0TyOsh9sC/5hD181DDgUxUjs3+3VJlvZBqPcVGHxOkQIduXz0WDI
         V6pThfvaeSOkP8fL5TE+vo+4s782/EilFuduJg03tS7R956ANxiMZ/5SABkm2Q8kXCLy
         cuVUxzoGA6do5KFakfx8LQCbc4Qj0SQBJlxANJO971OYDVRdrE0NY8fvVYvtNTC55rFb
         Ky46NxzpQxZnz/yITRz4H3ripftlxSjYPbHv4dyGZYDSh4LO28aYr07HGRu1lsauSteK
         bSxA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769523559; x=1770128359; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VKiuTkJYE06Lgz/n80ZUl4qT2rrzEkJRyX893wVmM2Y=;
        b=TvqUyrcKldZtldY/DhCfo75gQudgs7tl6qoo1ZH8AVjXtcg58A81YzxI2DnIQLar7a
         460uFsTeLHWGwh/qe0uRw7aJEJgdUw+MkHXHqBNhpO3dMw50XxwHJGhfYLdIzNjfoEsf
         Z8HoOtauq3T+rMQye5ECiLGUqe1N1EM/lsi/xQggF7aTFSg0Pp1a54D17TygieFkUvxQ
         JdNCCHjbSK5CTuKQdo8SkPIdigYa5LjoyB6/pxZeIcVfHvdqLcIURy5cBr7+i0ql4ieK
         WYXtImtQ1ELgR0SsIX2Tyr81W0PMtWUtGHeS7u4LR4CAUGXjgJqy1Tawv+954zxTCRFV
         UEzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769523559; x=1770128359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VKiuTkJYE06Lgz/n80ZUl4qT2rrzEkJRyX893wVmM2Y=;
        b=TLS29iJ9S4xEqaUbY2oOsFQ2Plcs6wLxLx+My/itFcsBJbkCD7VF3xHfmuxgo5gJQp
         CN2ujAatKM7OTMEKNKLFq2FsSufINagv0Pg/lHhPB8TjH0u3XrZwZb18S+LV/cnG2wB0
         r2m98Kv9HRIRd05QTC2YlWP5WqC14cf2RESu9AifaF8hY4LrmDX1km+FPPmha0yZBk3N
         X4LFa+nqcTsX8HeqvMHBEYkBq/l01pC6kioWWMKBk2a1+jp39cYwBsEY/cYqw3QRxPLq
         ebgbM2jLubx16XAxz10uyOgfJzIQxZc/af2HMN+ecGJGaiLZSRG2KH3s9WLYPp2RZcFU
         Wl4w==
X-Forwarded-Encrypted: i=1; AJvYcCXJfZpRBqpd38PTeUCMyZj5+uDRqT3CVkW1VQ0+HzcmMSB83/N3kH7W+Eg+ZW8/H2cambE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxdOJAZJFG1s7up7S0uMmnJG7XwrLQXImqUac58AsKJFp63abXN
	LgQZJmh/WEb2eLP26zRHNOlTLx0Q13D2oiWpXKK8a+C+1TpFC2KBCctwvdpzTgIfie6ZzMUjK/M
	LvX8feJzwr30oF7sF2N59sSoHOaAoE7k=
X-Gm-Gg: AZuq6aLYcrfkNbaLZwhf/LsRWoiNZm2RhAX8uD62rrEaDeaAgHw3en01n7S7sTbHmLt
	ASKMUpTF2Q2KcF+CXGvqK33V3RktShjk/xkWrhJrzJ+fjYiRGDNsJe9q93BZNIJU4+4rIJSeFQF
	yWidevzeZqiJT7tNggpzTZxqLrKH97vAXGfR3ZxAAH1waJeICVNxUy2XWj/JTrimMu9COSsAtzn
	bQl403pt0+4otXtrnhA7ySaCM+kKLzR30c4WQmjjDkvlM6xqGT4HRaKPzzz5yPgeWenz+XB8kz/
	XBqv
X-Received: by 2002:a05:6402:13cd:b0:64b:46ce:4706 with SMTP id
 4fb4d7f45d1cf-658a601598dmr1061746a12.1.1769523558946; Tue, 27 Jan 2026
 06:19:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
 <CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com>
 <aXH4PpkC4AtccsOE@redhat.com> <CAMxuvaw04pDNzHyw5+Qcv_KfrhDTiyp+MNxpECp+HfTa5iLOGw@mail.gmail.com>
 <aXH-TlzxZ1gDvPH2@redhat.com> <CAFEAcA_u6QUhs+6-cyYm_qttsDiV2zHbsc-_FbTb8QzWXk6+tw@mail.gmail.com>
 <aXICpFZuNM9GG4Kv@redhat.com> <CAMxuvawgOvQbwoyCzFBLw++JqR0vFbVUhbv1AJWU6VqK1MM_Og@mail.gmail.com>
 <82f74c82-c572-4ab9-b527-11ea287056d1@linaro.org> <CAJ+F1CJtrv9YgDbiekVmDD2yT+6nUe39nLwLsKxvFOtMc1kUGA@mail.gmail.com>
 <CAJSP0QUCQ8LkHEPNPb75XZmo46xxvP3uA373fzAZTwn=bo_bdg@mail.gmail.com> <CAGxU2F4K5mAhwKSLkCk+f17=1FA51WG_XEzhSr_hxNKJTAGi3Q@mail.gmail.com>
In-Reply-To: <CAGxU2F4K5mAhwKSLkCk+f17=1FA51WG_XEzhSr_hxNKJTAGi3Q@mail.gmail.com>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Tue, 27 Jan 2026 09:19:06 -0500
X-Gm-Features: AZwV_Qjy-_kYacMG8ZkkvHrkO0IeQfXdaCNrJ3EiacBY_1YmYMCp9mRdGWf8M4M
Message-ID: <CAJSP0QWw_nvDgMgtzi4jZjQ_q=qSRtpA2rN=_49wfOcRhC4jOQ@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@gmail.com>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>, 
	qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Matias Ezequiel Vara Larsen <mvaralar@redhat.com>, Kevin Wolf <kwolf@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Alex Bennee <alex.bennee@linaro.org>, 
	John Levon <john.levon@nutanix.com>, Thanos Makatos <thanos.makatos@nutanix.com>, 
	=?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69249-lists,kvm=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,linaro.org,redhat.com,nongnu.org,vger.kernel.org,gmx.de,ilande.co.uk,nutanix.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[stefanha@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,qemu.org:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 548369591C
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 3:35=E2=80=AFAM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> On Mon, 26 Jan 2026 at 23:29, Stefan Hajnoczi <stefanha@gmail.com> wrote:
> >
> > Hi Marc-Andr=C3=A9,
> > I would like to submit QEMU's GSoC application in the next day or two.
> > A minimum of 4 project ideas is mentioned in the latest guidelines
> > from Google and we're currently at 3 ideas. Do you want to update the
> > project idea based on the feedback so we can add it to the list?
> > https://wiki.qemu.org/Internships/ProjectIdeas/mkosiTestAssets
>
> Hi Stefan,
> FYI we are going to submit 2 projects for SVSM and 1 for rust-vmm
> (virtio-rtc device) soon.

Great, I'm looking forward to adding them.

Stefan

