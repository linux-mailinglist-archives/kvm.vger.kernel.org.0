Return-Path: <kvm+bounces-68870-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GFx9J7P8cWmvZwAAu9opvQ
	(envelope-from <kvm+bounces-68870-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:32:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E2E08654A5
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:32:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 75A31564B65
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 10:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4749731195B;
	Thu, 22 Jan 2026 10:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uuvxs9DU";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VhP5PZ1z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36562F3C34
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 10:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769077365; cv=pass; b=mxmxSXPCrLgoxTkUF0g/Mg7cyY9XGxuSQwPQ/EyEvdEqwWNjZt1Y+gx3IWdTcieqZ5+TXDfYRiO0zHbpkjMXh/mfbsBx/4wYk38hRNOB2n1vIbxIwl6OL22uGGTLl+Y2pBXk/i+dtjEYhoDdL0twcxXPZpfc5b89v/VeQrURWPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769077365; c=relaxed/simple;
	bh=ezjGRqnwh8UBX/MyJADTM84jfekKwYTF3SiVD/emT8s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ACx3d9mbbnE4irG30/q2IpvYezzgMUluCXzKtB+o9bJigY1mcgXz5jZy54IDBc05o3nw+JkgjH4tOJdKv1xfcV8CF0sJsYJw/mcNg6y7bmUkYkSZkK5m/x0PFl29s4nE+UKKiJZUJimP3OiO/IHpPKxloFfk6AvAfBEjXagEAJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uuvxs9DU; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VhP5PZ1z; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769077362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ezjGRqnwh8UBX/MyJADTM84jfekKwYTF3SiVD/emT8s=;
	b=Uuvxs9DUghnR2wU6gywLkwfSc+YkURpXj7+2rCqhgtTYTntaHuWYR8LMejFboTtsYQQVEs
	wFJONRb4XiU/huEPL+qG4yn1SfpsZTE+Tv7MVxQRZ8yNzuR4MrO4nVJlyiuYIFr7LKx/WF
	DcK+mxDMEFaSfxxE/RrCBiysMq98h6U=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-TkqKDDkwOjehBn77cm6u_Q-1; Thu, 22 Jan 2026 05:22:41 -0500
X-MC-Unique: TkqKDDkwOjehBn77cm6u_Q-1
X-Mimecast-MFC-AGG-ID: TkqKDDkwOjehBn77cm6u_Q_1769077360
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c5859a38213so472719a12.3
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 02:22:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769077360; cv=none;
        d=google.com; s=arc-20240605;
        b=ZNeQ/b3kcVTTZXLeKrlVWS/6fXfHw0t8luvfZT4hzdq9qP8ElV9sW7NP4UAlBDPvHD
         PfKs3L98zlNFdQAWXBGju6GoveeR4xPZYpVCf1PDZCkWezmKQV1d2ur876Nct9V/ok7q
         ilF3VwPsn8gq5Pbwk6WA0ieNU1L3BqZRL9nUO8vOAbdRrSPB5TdFrUnoq4+LVn5cvEwl
         CkNjBZ1uvARz4dHdrzoK+v1JRQItVMW5rBeZNWcU9X0OhHoD7FXaA1pGiWWsEaA0wLyw
         7+AztXWU34HEgVXx/kQ46R+7U4LJQtY/YCFm7mzWQWBN2KnrjJXNG3RaPe15tC6957BR
         ZTNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ezjGRqnwh8UBX/MyJADTM84jfekKwYTF3SiVD/emT8s=;
        fh=hdySV8s+hYE+CjCaG4kDvog1STBlUa4lwgtW5oiDESI=;
        b=N2JbchE+8ODI551GX4II/vfRblQT0+KEvSqKOUaTlfWoYhWIR3jOkwIcQ+fRNIc/NT
         PFnoTNpUrooNmSjXVY7RT/6Ap18GVwmGrz8brx8CF+0Q2xBfBPIX7yFcFxvrV8qjBlaU
         3WFLH0gy0VQoo1q9nmf5icTEYX6qC0pjkFxECBlziahlvPtNr+sjhP8hz55chczoyeur
         kktRQzqCRPElBq2hHDv4aRNb9svFEQOlDERACJEXMGUKeoigzxarFy0BtLpSeD7dmy1J
         2B7ThDg5ZhVdMkQW1DmSVzv9k/Kq6WGzsnm4Q7GlAPLbTURQRbkwGzPh9uRTS8Kr3OsT
         ctCg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769077360; x=1769682160; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezjGRqnwh8UBX/MyJADTM84jfekKwYTF3SiVD/emT8s=;
        b=VhP5PZ1zgZErBvngT6ks1Yt1z6Te2YL6VCkp+K7Oa4ySjtRVKeHBYaJOuD5m8Q2uNk
         S2PSP3xAPK2O82HtCHKHY2BlTAYBvOT43M227gUAQ2Oxvy9+D2cM2GJIfRHMNvTQqarY
         m+2ymjz0I9qU5qow3HFl1AoFRdhoR6tjZGkPP+70wrnu6qBSqNLUiHaTjhx+zvvCaysj
         TllrxEXCZyeL0eMyFOMvwtxR//NVIAyCPJ+027keJpNFoGqHvf2F89KVJzTTDQnEmC38
         IcnBZgMZmxnVEZlQoGOl9nu6+7hCN0sGuGQR8ezu+A1adfw5oSxwnxsxS+zkBP+O4X6N
         LVuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769077360; x=1769682160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ezjGRqnwh8UBX/MyJADTM84jfekKwYTF3SiVD/emT8s=;
        b=L4xEcmoUMYlizZHAJJbh0HdQSnB3Mk0+hp5AURs3SdFYETh3nvT5OVhNfVISntv8nn
         cfCcWdi+L1Nt1riMkW+AGeL6fv/SNCfunRsVdlz3RohAj79TmspEOvVMhMxV8EcGezRt
         AVnXyQwqhyN3W2k1nE1F0KQrzKfAWB1bVP6OIDY2aJ8FI6utA4xOQ/v6qGX/FZ3a7Ov3
         BuAq71Z9Ixmh0OADnNE2Bm20zW9PnfrJ9vgOzngoCX7W/EtVr05ypoaKzx4A8DLEvvCF
         1EDngpkPH/Qg4/hZ8Hw1qX+FPLsXSCZANVl0L34MWL8C71RIQslsttVln4PU39ZLVQ+1
         CidQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkIp+A5Yiqb+q+IFyw9mEkR7Z6Yy45cNCTTL2oNV5yX8NhjN1k5gUGLBmKRgHCao7NHfA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo2X/sG7tVsDj3pYCvdqtN7pf7xgz1hzVS60ojwhuflnI36oaQ
	R6XwDUhFHBgpE+24uxW10fGQOMccVbQjRO5513kMi1EnqQrkoIzmUbrKhH9MZIEOhkbmp4DMkBU
	s4j0K8VDoXpZNtuEGtVsgP32V8YRdtv8UOzRajFraowI9dqAGtkePCLfcqS5DUEPuE6eC9089Hn
	NUWzI743SXuS6b8z3f2xY29W5Rsxyd3Xo/ar1XXRQ=
X-Gm-Gg: AZuq6aIlQdnH/irrwatN3S1ZH3uqHb0WEevSCoeXZ3cDnHV0j8Jq7OmAdqZMNHlkDbL
	FoDt+rmelCUJglNV0hGzhx7XXoSh33LpJ+NzhOKhP1PvC5zunAS+/OXsyhzxBJm7vprncmUmVZB
	2a5cfKqZBYPdjb3mH6YVG8zNTuD664fHhARc1cl+EeqHFaf9D/pddoNg0odG7r/SHqf1Sf5E1e4
	zTh8lxC7DEyq8MLcknscTJZwA==
X-Received: by 2002:a05:6a20:258d:b0:38d:f8e6:fc9c with SMTP id adf61e73a8af0-38e45e74cc0mr8748296637.69.1769077359804;
        Thu, 22 Jan 2026 02:22:39 -0800 (PST)
X-Received: by 2002:a05:6a20:258d:b0:38d:f8e6:fc9c with SMTP id
 adf61e73a8af0-38e45e74cc0mr8748267637.69.1769077359366; Thu, 22 Jan 2026
 02:22:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <CAMxuvaz8hm1dc6XdsbK99Ng5sOBNxwWg_-UJdBhyptwgUYjcrw@mail.gmail.com>
 <CAJSP0QVQNExn01ipcu4KTQJrmnXGVmvFyKzXe5m9P3_jQwJ6cA@mail.gmail.com>
 <CAJSP0QW4bMO8-iYODO_6oaDn44efPeV6e00AfD5A42pQ9d+REQ@mail.gmail.com> <aXH4PpkC4AtccsOE@redhat.com>
In-Reply-To: <aXH4PpkC4AtccsOE@redhat.com>
From: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Date: Thu, 22 Jan 2026 14:22:28 +0400
X-Gm-Features: AZwV_QgYEFY_8Rekw5y_i2n3QwOvUQb0Z0m14eEZj4MAt05iu2O89z-ReaZSpP0
Message-ID: <CAMxuvaw04pDNzHyw5+Qcv_KfrhDTiyp+MNxpECp+HfTa5iLOGw@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, Thomas Huth <thuth@redhat.com>, 
	qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Matias Ezequiel Vara Larsen <mvaralar@redhat.com>, Kevin Wolf <kwolf@redhat.com>, 
	German Maglione <gmaglione@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>, 
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Alex Bennee <alex.bennee@linaro.org>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, John Levon <john.levon@nutanix.com>, 
	Thanos Makatos <thanos.makatos@nutanix.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68870-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,redhat.com,nongnu.org,vger.kernel.org,gmx.de,linaro.org,ilande.co.uk,nutanix.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[marcandre.lureau@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: E2E08654A5
X-Rspamd-Action: no action

Hi

On Thu, Jan 22, 2026 at 2:14=E2=80=AFPM Daniel P. Berrang=C3=A9 <berrange@r=
edhat.com> wrote:
>
> On Tue, Jan 20, 2026 at 04:42:38PM -0500, Stefan Hajnoczi wrote:
> > Hi Marc-Andr=C3=A9,
> > I haven't seen discussion about the project ideas you posted, so I'll
> > try to kick it off here for the mkosi idea here.
> >
> > Thomas: Would you like to co-mentor the following project with
> > Marc-Andr=C3=A9? Also, do you have any concerns about the project idea =
from
> > the maintainer perspective?
> >
> > =3D=3D=3D Reproducible Test Image Building with mkosi =3D=3D=3D
>
> > This project proposes using mkosi to build minimal, reproducible test
> > images directly from distribution packages. mkosi is a tool for
> > building clean OS images from distribution packages, with excellent
> > support for Fedora and other distributions. It should be able to
> > produces deterministic outputs.
>
> Aside from what I mentioned already, the other issue I anticipate
> with mkosi is the mismatch between what hardware QEMU needs to be
> able to cover, vs what hardware the distros actually support.
>
> Fedora in particular is pretty narrow in its coverage. Debian is
> considerably broader.
>
> Neither will support all the QEMU targets, let alone all the
> machine types within the target.


That's right, the goal here is not to cover all possible images though.

I picked Fedora here as an example, because it is the best supported
distribution in mkosi.


>
>
> While there is value in testing a full blown OS image, IMHO,
> for most of what we need it is considerable overkill, and
> thus makes functional tests slower than they would otherwise
> need to be.

mkosi can produce initrd images, which can be small enough and
customizable. Although I lack the details of what is possible, this is
part of the project research.

Imho, building all images from scratch cannot be sustainable.


