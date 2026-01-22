Return-Path: <kvm+bounces-68885-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ML7HA4IUcmksawAAu9opvQ
	(envelope-from <kvm+bounces-68885-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:13:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A0CA667B9
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 13:13:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8926A8EA7E5
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 11:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A16D308F35;
	Thu, 22 Jan 2026 11:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ti1myrTi";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="t2+FUHPS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CC231AF1F
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 11:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769081323; cv=pass; b=SYGJ7Yidsi6VWnqIeKnHVXNQi/Fn2XLYZ0f/LvzJMU0Kqkq3/QckGMGPbCaSthSbILeMCFx95eqxxgwl9gv4nVADY5nr2EGztug4hz3oC8RcIPXY2zSUDZ3CdmILixJNpgheJb+skoEUZUpgsTwVVoj73hC5rEWTykKhtBo60Mg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769081323; c=relaxed/simple;
	bh=MmDSe+oTS8G3U/EqtRz3XriophabAbp8L0k/+VkyN5c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PVH5/ByvnYTu1WsKoNCp73HNwxCq/xqL2NoWsK8+mJdP1yU0M3kb6Nrzfm4AC/nqF68HpviNqw+LojLZ8xVHQgZdKuJileaGVAlDK4HaJ8TcL0rX6vJKZ9hfYybkMcchE9oqcTZ+cs9I2CnZZMkMN3d0pLUiNivUN7PHM56P9jg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ti1myrTi; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=t2+FUHPS; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769081320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MmDSe+oTS8G3U/EqtRz3XriophabAbp8L0k/+VkyN5c=;
	b=Ti1myrTitb2uKlHntcK+kR0YKsWLF3tqNdilgmTElfyx3yfgut8xHZ/ekrexqgNSdBWfZN
	nBAuFiU0zAdK25/JVE6zelxm651o1ZicY/ED4D5te5TWyTjIzUBDFj5s8qmUGe7Ephkq/v
	TVay8GvOSNCEPrQUfqEz7vrEM//GKVw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-MfOvvQXWOiO_NoDt5zpNow-1; Thu, 22 Jan 2026 06:28:39 -0500
X-MC-Unique: MfOvvQXWOiO_NoDt5zpNow-1
X-Mimecast-MFC-AGG-ID: MfOvvQXWOiO_NoDt5zpNow_1769081318
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34cc8bf226cso938792a91.3
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 03:28:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769081318; cv=none;
        d=google.com; s=arc-20240605;
        b=Yn7/CRudLSvcFHuGy00BnBoLhSBWwC2Xi58IYWZBUVRx+m+2xFndAHKQ8WNz+ThOew
         B9ST34jghVMnQ1luoFiDadapO9KavEyVPvYqrmuhbmbfBHLrZ53k+/LLgqLlhZMwrCzS
         PL37o31f0nYuYfsG1Nr4OZhOxff17gz6LhpZN0Y7KMJKn5JmxTd+Xx43HAwocuRIWca8
         WYnxihsOZeHFAZyrE0QyAS0LQxJjPFjoHrlRql86kbynPZRWeLbDB1XrQZ4l6TNvwP3Y
         dzxpH9vpcSlTItS3REvw75FWm4ZRZR9qEERUDm+MXY4FhAZ4diDINawYdTLI2CTRVTfW
         2ulg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MmDSe+oTS8G3U/EqtRz3XriophabAbp8L0k/+VkyN5c=;
        fh=V6ZIR5urEuvoJYJlMA79QxRUrHI9jC8XeQw/DL+u39Y=;
        b=VHlbkiN5BRh+NXyB1RWpXsgEzfpQ0U2Aps9LbzaootSLktS4LttVUP2ot84yPcLvTC
         JOiFz9sPOncgHDRzVE8RncvD0CYt0Fx8UMEVchFYERmM2dFp+YQ+X3yx2LDf9omQVSze
         bq7bsthNGTRmofDNSyxqbpr1Iwle0gN0WAXwtnW+89Ru+2lnOAedka2AhgMIx2653kYZ
         hcMH3U3ulpv9GounGa5yDaaclLA9cczewnKhvLV5YsahqdcGltVz6/dOvm8ng1HK9z8X
         ByDjq+VN6axBLAlfB7qQYDh9Kt90stkFrxcWRDfd2o1LMrLZt7JFpZKccrZDbVbDfbKN
         kOiA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769081318; x=1769686118; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MmDSe+oTS8G3U/EqtRz3XriophabAbp8L0k/+VkyN5c=;
        b=t2+FUHPSIigeNpJztlKkPMJHlYdoRQkW6usXS2EwWYS9JSfMd/6i6ljhnqiXTad8P8
         hNlSOYEsG2hYUcXt3g7fsOGedfuLEFVHrm/yACRiPRjgJJHOhBnuQduseG+4oGQzGw8A
         f+7rb2KJ34aBjiuT6ozlcciE5/MsYIVgbYeiKTs3q4RR4y+xZm4C5brdw2CzhXbLieJX
         sdfWM94Q0DSBr3YTUmQssjw2kwyypRMskv27o/GEjVczkRvcySYDHppFcnR5oGGmOMHD
         4XruJI1JbFTSEMnrnnPtlkTozHNcZx5mhimgvKdn5d0ToKekH0pAQU3t26WfxBHTvxl1
         R3Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769081318; x=1769686118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MmDSe+oTS8G3U/EqtRz3XriophabAbp8L0k/+VkyN5c=;
        b=v6bjqjctM6psmBA4a0cr/qPv1nj/VRXzHz/TiLnVuy7Sl6UJJ9N028fDvAh5VaI89X
         Vp6TqYmhlYXrXKysTktHH0dTySk2dwv83FTfcJLmHANzM+zglsJtqPxlVYty1MqC5/Y/
         TztJSft2G9TMO1fXAYfULJAxYxQdplHbl+28XKst3PTUyOLguLM7TALGnfsuCT+66IAj
         sjeVrbcitLf0lMGp0/HxHYVMlV6LalhEynNbS5tNaO8/n0Gx9Cv2IYWVo2BFXzY79f7n
         7xsERODLcFgIk+oKQmiocUb5oSqj8kn7huZ26Bc+F716wh6t/x6s94rfOh4QP00YwBpA
         GyPw==
X-Forwarded-Encrypted: i=1; AJvYcCUm2p/ihUqP429T9pTpHLg+Sz24kxerWAPEuPTE0QHOYpPFlRAoUstUAsmq//ZmvB7qdi0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4AkgKWFv0lKsVLf6wn5lUEmQnbEk6ejvdA9CY2BRyVFOGCg+8
	8MShEHQMn7CabT+XzlGgHMskIKU/PcTVO5JV2H2XKnvyMktJxC59Yi79HIIbBb1Z7oTMi4Vbb5W
	iW6J9mecjrb5XZpsfO5oYGklMVebhBXrGPYB4SSo7EVbCMPpHVgjLFAisGmj5wDFjYT2isZGQir
	B2uhJEykPfGvlkQExtMcT1eTc5hShP
X-Gm-Gg: AZuq6aISdsce6u/pDKYYZLleMnbML1QAvXCHF3EkIQUdc2JoRr3zCm/aGd/2G8S55Ti
	/wXwYWS+i/6wBA+/YMEhn0SI7UJWwnk/rdCZ/wEnHkK4NnpxlFzLmiwWChvPovTFPZ8YYT1rt9V
	UQZGsCfJNT4I9k4ORkiP72+sVvEoApZvPqCtJ4IemJS/vT/nGYiQlmqCCTY5Qr3crUQjtljRidj
	RWizTfkhNq8zHxXY8FMTDeBwQ==
X-Received: by 2002:a17:90b:1c01:b0:34c:a35d:de16 with SMTP id 98e67ed59e1d1-35272f12a32mr17787869a91.11.1769081318326;
        Thu, 22 Jan 2026 03:28:38 -0800 (PST)
X-Received: by 2002:a17:90b:1c01:b0:34c:a35d:de16 with SMTP id
 98e67ed59e1d1-35272f12a32mr17787852a91.11.1769081317918; Thu, 22 Jan 2026
 03:28:37 -0800 (PST)
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
 <aXICpFZuNM9GG4Kv@redhat.com>
In-Reply-To: <aXICpFZuNM9GG4Kv@redhat.com>
From: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>
Date: Thu, 22 Jan 2026 15:28:24 +0400
X-Gm-Features: AZwV_QjBNh4RvXNqedsRlWfefXm8tdzTXizaBBZojIfu1tbjiEM0taJX8kCTgug
Message-ID: <CAMxuvawgOvQbwoyCzFBLw++JqR0vFbVUhbv1AJWU6VqK1MM_Og@mail.gmail.com>
Subject: Re: Call for GSoC internship project ideas
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>, Stefan Hajnoczi <stefanha@gmail.com>, 
	Thomas Huth <thuth@redhat.com>, qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>, 
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
	TAGGED_FROM(0.00)[bounces-68885-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[linaro.org,gmail.com,redhat.com,nongnu.org,vger.kernel.org,gmx.de,ilande.co.uk,nutanix.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_ALL(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[marcandre.lureau@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 8A0CA667B9
X-Rspamd-Action: no action

Hi

On Thu, Jan 22, 2026 at 2:57=E2=80=AFPM Daniel P. Berrang=C3=A9 <berrange@r=
edhat.com> wrote:
>
> On Thu, Jan 22, 2026 at 10:54:42AM +0000, Peter Maydell wrote:
> > On Thu, 22 Jan 2026 at 10:40, Daniel P. Berrang=C3=A9 <berrange@redhat.=
com> wrote:
> > > Once we have written some scripts that can build gcc, binutils, linux=
,
> > > busybox we've opened the door to be able to support every machine typ=
e
> > > on every target, provided there has been a gcc/binutils/linux port at
> > > some time (which covers practically everything). Adding new machines
> > > becomes cheap then - just a matter of identifying the Linux Kconfig
> > > settings, and everything else stays the same. Adding new targets mean=
s
> > > adding a new binutils build target, which should again we relatively
> > > cheap, and also infrequent. This has potential to be massively more
> > > sustainable than a reliance on distros, and should put us on a pathwa=
y
> > > that would let us cover almost everything we ship.
> >
> > Isn't that essentially reimplementing half of buildroot, or the
> > system image builder that Rob Landley uses to produce toybox
> > test images ?
>
> If we can use existing tools to achieve this, that's fine.
>

Imho, both approaches are complementary. Building images from scratch,
like toybox, to cover esoteric minimal systems. And more complete and
common OSes with mkosi which allows you to have things like python,
mesa, networking, systemd, tpm tools, etc for testing.. We don't want
to build that from scratch, do we?


