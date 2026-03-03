Return-Path: <kvm+bounces-72449-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CC2RFoMmpmnwLAAAu9opvQ
	(envelope-from <kvm+bounces-72449-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:08:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BA9DE1E6FB2
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 01:08:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AD233306FE10
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 00:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D3111531E8;
	Tue,  3 Mar 2026 00:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bQT8TA1t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34724390991
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 00:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772496498; cv=pass; b=RFyjhIOBaIDKj/8UMxFBSTC4gshag7fRMnYiWMHNcR6AQkwizhd+geTfQa6wMo65YpxphLP0Ll5Fvvb8BAtn7sDnGJ12T3CK6cRa6QdfYXnCxpgsksbCoYSDlX1FQVZMqCN5oIWHH+tiu5k82sH+0t847jQi4kI/HcyftVF1N8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772496498; c=relaxed/simple;
	bh=SV8GIdWM/SDN6ViqWIxv72S+7CInW55mYqGDlI1J/oE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BhPO3EM9LhvuEAgnp3DVq+QmiOJIShyLG1HQ/qLPACF6zjl50v8pBvdruMZILj2grQ0etVDV3VZvhzuV2m/n9tkb4cWLbHWRUY53MdRmRFyHDBzG40OrwaLqLs42HiIMi3njdw7ajcArvRDtvTJ1BkgJIuzwmdGoMkM2ReGdv9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bQT8TA1t; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-65fe2d2b744so2154a12.1
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 16:08:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772496495; cv=none;
        d=google.com; s=arc-20240605;
        b=bLiye2uFoSsRWnVIdhmBi0CDHaVJxRCIdPAOX5mMejXMQx+Zc0ZtegsqIj2lM8IYR0
         Kov2UIMXaHAbzjAz18dtvnb60WkTxBHwAOGECaC81AKnbJwNcek+vmK/CabuusrhiPw9
         w180AClaZXICRWs/HN1JFUZmnUHjMtr9o6Z7L8zz6Mdpb3VaLOBjHBHR/2A7iqa3sNKc
         PKqANpNH2FZWP5qp0q/OlJswK6vG8E9gh1fcyC+qBxZM6GjY99/A51eq/TYSt5El/J/+
         A1eoTz7XUCXwR9NJ0MVsVVbBbeaJGxx8kC/+Zo17at4FnU5VAZi8ObYyVVZ5ZGUePZ7a
         8ruA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SV8GIdWM/SDN6ViqWIxv72S+7CInW55mYqGDlI1J/oE=;
        fh=pIWSwaaghjt4ahUl0YW/4ptMaXwzy91EeWcvicxAYFU=;
        b=cqkI5tzYqF4cAsMmqKiA+u6qTRdCTbEE1nJAeG4x7WLb88ob7YbzCuR/FFbAUfXfYH
         3SKRL7fbv7uKjV84h5zlhuwiUyvZZQ+eZ3p3IVepMTIg/j1Ylzw3HMWfjAXGR+4pTTh7
         9/p0vgfzd7bfn2818N7+a/vMCPQ+FkLfBYgsHR/LKwZG+yTMcpb47W84eS9cH7blnCNO
         rYlY+b8+58rtq41bEdGborSfF5PG6SJnugH1zXWltk2KtRsJKlb6x2HEmOKphZXIlGm8
         utkFDeypZeRhdqUJ4e0z1KzoJaHG1++Mts5lQQ8weo4x9rKuvAwdc0Y6t7Zxp3HJcYCI
         jWwg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772496495; x=1773101295; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SV8GIdWM/SDN6ViqWIxv72S+7CInW55mYqGDlI1J/oE=;
        b=bQT8TA1t9wq6uOqgtEAC0sfqjSqnqLS2WcPkJGH+gTVudLUK7EfnuDlwwJjTNJVOJJ
         S2Q+wXdJVqHIrFeqke0hfAE6pF5yamQUFXDcLPcXVAokeMMaPqaLr8exHpC/akrKjlC3
         SVdeDYMngdYhqzZhx2hM8tap1u8J9i4xN/cmWoq3b0MQkY87+y4nQiyqlM6cu2of3Oqt
         YGj23g1nZ/RVhaj6WG0d2yP1uFq2L5ExpAEkyLCFO+YLL6tI1+zV+eWSx3mhbOGTAOs2
         uri1osfi0kfjah7xowPwHDFQvlGYyRm+A5MtsuLeEyGjx2d45DvSupcVIlfPs8gpoSjF
         YCDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772496495; x=1773101295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SV8GIdWM/SDN6ViqWIxv72S+7CInW55mYqGDlI1J/oE=;
        b=O6h7HdH6FTGLeJFzmE9rm9cHpMZdwjPbzZEqBCLDQcZiCWBO5wNVYuy+1lMLz2+VPh
         D/yMYJUOxcPdqMCDFEZgPUqtDv1PFM8CVz/BV9ivwuVLBkWOcyCyPJZswbBqw5Vd2rcT
         64hDlnmUXb3AAR362d6EvfquYaeQTxCKrZRF1SaY2ceQjjfp+dGp9zyslcggLzKrjTmz
         rLwS/fW9INwBcGo0rLfzgVWYCfGgfcfQidwOqI59Tf8cZsKHYWoxx1j6AD47uhelBV7r
         vvPtcEETIMGLqb5gFTDChgGW/HwWpa8gyzUCELW+df3IiJEcBBcHyRW0mEsoJmLLC3iy
         zP+g==
X-Gm-Message-State: AOJu0YxQqOP02XK6jjo/iGkb6M/fVfYjK8npNeMECDIKNyt7fPw2DQ1K
	cKumcx6c/59uc9V5ncH7WIGAKNAV2aF1xKxCRMg8K1Kej1UjJfDPP06vvECGln1P1ihJA+b+JU2
	wymHEe1Ma+BBGyLNlFOKFuTqc+w9WpM0nVcEl6qFLE4Rf3wcHuurgZRJH
X-Gm-Gg: ATEYQzyNpWbFnNy/IbHxQAHHyibMl3ThYbvR1BWwzfm4A2Ny9nxg8bVjLTc+NAtK7dV
	xsSWz/avxm2ffSxYJ+O5iayYiMW7nEbRsbOyfggSja9IXSd8MQLdndNqjIeNGNGE/eF20qTAf4o
	kRyTjagZGp+dysGw3RBpBGY+cmepw2jIyp+HJuFpiqWdfIu9742iGpEBquytKfm7l2MftgrwlFl
	3YUSQdS/9kyUXmLJKWvme/4fUpEASYRARzkvAT+qeco3VxLOoRt22nqhTeS01DIf43+ubYxten+
	C4kRe4U=
X-Received: by 2002:aa7:c752:0:b0:65f:5e6a:8b2e with SMTP id
 4fb4d7f45d1cf-66008e1869cmr287209a12.16.1772496495034; Mon, 02 Mar 2026
 16:08:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260227213849.3653331-1-jmattson@google.com> <CAO9r8zNzhK90=+Pezqbea0aihMEp-dGidcJuXqZQKnmsM2JTDA@mail.gmail.com>
In-Reply-To: <CAO9r8zNzhK90=+Pezqbea0aihMEp-dGidcJuXqZQKnmsM2JTDA@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 2 Mar 2026 16:08:03 -0800
X-Gm-Features: AaiRm52SdQCb90qoYL_V7QphuDEkEHztxKpiBfNKk9rPK9mM33n-RTDsGSu41NM
Message-ID: <CALMp9eRP7-u+6r8-RoVru6PLSPr6fu+EuRgtsNLJE_1EpMJq8Q@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: nVMX: Add retry loop to advanced RTM
 debugging subtest
To: Yosry Ahmed <yosry@kernel.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BA9DE1E6FB2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72449-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 4:55=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Fri, Feb 27, 2026 at 1:39=E2=80=AFPM Jim Mattson <jmattson@google.com>=
 wrote:
> > +#define RTM_RETRIES 30
> > +#define ONE_BILLION 1000000000ul
>
> I think the name would be more descriptive as RTM_DELAY_CYCLES or sth,
RTM_RETRY_DELAY?

> IIUC this will be in the order of 100s of milliseconds. Do we need to
> wait that long between retries? If the CPU is in a state where it will
> always abort RTM, 30 retries will end up taking seconds or 10s of
> seconds, right?

I tried reducing the delay by a factor of 10. At 200 retries, I still
see a 2% skip rate on a Skylake Xeon E5 @ 2GHz. I'd like to get the
skip rate under 1%. But, maybe others don't care as much?

Yes, 30 billion cycles is going to be on the order of 10 seconds.

