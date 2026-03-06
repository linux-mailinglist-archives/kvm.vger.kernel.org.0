Return-Path: <kvm+bounces-73181-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SERjEIZfq2mmcQEAu9opvQ
	(envelope-from <kvm+bounces-73181-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 00:13:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D38CE2288D7
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 00:13:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4D7A7304C48A
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 23:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2698436DA19;
	Fri,  6 Mar 2026 23:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3aIJ1uZ1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160DE3537DA
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 23:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772838758; cv=pass; b=bmrRf1wcQLKCyXXHBxLA4ZEYu2N3K/e9u0C9m8o7KU/fVyMh6wSAR8xnWxcUIOhUdCIjv5xJXglQPWVVupeY94hU5H3sfT5GAndhenFuYBoWmsrumB6JUI3gWBJRc4yizv+aC/jqrzj5lhX8DsJaowRhs3yp/xrvkg8zwSL3HW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772838758; c=relaxed/simple;
	bh=MyXRdnAt/Vun8k4yz1dB+RY0hxaeX7xucuNFoDYyZqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e1Xk1xDWtSiHAfiXcFOAS+ULICPP1jVvnTFfl1Pyrq+uC2xS+v98zmN5tjD5ijeQDPEp1kg6qE2GyXTlXKvYrDONATDgQmdKd9Hls00asKPXrFHJbFyL2h8qLgCQUUX1bfq+96oES25+J6VyR7n5qJauBhBbP3AmBAsS+xuUmFw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3aIJ1uZ1; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-661ce258878so3818a12.0
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 15:12:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772838755; cv=none;
        d=google.com; s=arc-20240605;
        b=e1yI6A/frAgQPNeMqCwWvOHjmwT3Cczpg7WeUhVr0i3uR80Rej9zI6csCpJ5xl8Of8
         yLzCDy5setTepqnfb9zQ6Yp11Cnxoa1+OxR/CrQJzNWwzaY9/Jw15xbE0YUOgtTiIlvW
         XUWVZEcgFHsTXhCZtLfVtjauYkYpIpP0bEsBdMXlblZyT9gVqg6i/indpzmNPDYIQ1jv
         ll093Q+dhFiHOrrsOuMNfebXyI3oTnHMbCn9dnzu9NvOPAyK1/n0X1lbYUhSRqMV1O2Q
         0vUVEIUrq8cj9PTJCNXd3aGIFudqyWu+AckEDUW7kNGaipsf7DDL0wbIwmsWOntxRdTI
         nKJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MyXRdnAt/Vun8k4yz1dB+RY0hxaeX7xucuNFoDYyZqc=;
        fh=wo1n3g1FsKoJvNBh2G6iB2tiTOvSWoDZ6nFgqZq2Ngc=;
        b=jeT7TVLUR4lKrZqfkLJQuJROITttZUJpJc2lb+dbWBtm++o+R8YVt1y8x2og10yfMD
         8GCV2myoluiAXGlDFXK+WaLKfcJwbF2Tn/m6bkzpWzGnOYT28SDE/AnWPjIm+a448tnz
         6RMVzrO8rjOA9r1ldwAfH1D29sz6RztlRoSItVQgMPmAS2LvV+NGSmYJDK6j7t4qG13q
         mRJ0KhL/iZBJRmsmEKp5xCozVHPDFj7i8Rzl+NrmWNRW7eOEELH5XIK6gda8gNl1sGtA
         +H8Dn7qfmAKGWkWmyF4qkyAbthPdWlu3LBZ/YZOUXvz1tKsMWo1qxCmTL9mEoruA1ZfX
         McRw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772838755; x=1773443555; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MyXRdnAt/Vun8k4yz1dB+RY0hxaeX7xucuNFoDYyZqc=;
        b=3aIJ1uZ1SQe/U0yN+MWHVIgxlPe1xHoEkr8WQORNgCInfpFiZ/zDmGyxwRgFomZMiz
         u+902gWCRT4x6Ko9e4IXxaNHUxWQDM6frmYso/EG12T8ZhpHcP6cv2vSzDzTXdWmKtMt
         F1N7isBRW39Gb7UkOAtyurdTKCAj+eQR4kiJVh1bj1xKCHEK0tnNyr9d1xOv6JmLnhcm
         AvsFzPQwzKYv4slcv56jD9Cbe+sjU54SIMCBJ/oy/TiBOMacbj4e9n8gfEoAYIyUEckM
         51VnyOIvaTCt3z/4E+gWZk63SjqI9EzfE8MDulDgZkuPRwAidCtk0m4/+L3gPRbs5l9E
         gzag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772838755; x=1773443555;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MyXRdnAt/Vun8k4yz1dB+RY0hxaeX7xucuNFoDYyZqc=;
        b=bAoO954yWDWi/kUTn1fKfWBBioamt2x7AezUi5F1/L2ipY4kCf5ycvOS0YTjvFB0si
         bVZf3zbYx3av4ckyY8XF8Qbm+Xs1JQFMy7wDhfeqi/yn3rd8811Sv3Ag8ey02yRN7g5l
         MQpQFhRy5GHwBZQm7B+D5NxUyvB9CFYZPZsnyn9b/rNJkmVu+0gelPAfbXkdw1jYSPqq
         6kuw07uaS923dVWnX7ne+mIWaeulikvU8nYyCAEaJsWHqvLrZ861PlfCVJKaUFnVMkID
         EIEaufgrMMLUhBBIEu5Vq34TwkMilAojxsrIWe+uGsOUg6F4CiJyXl2gW+E1fEy+f8RK
         SX3w==
X-Forwarded-Encrypted: i=1; AJvYcCUMLJHJNKuPaHAx5oWJDzCyf5kPTgh+EPFJtnppPSKCOpjMi6KMzL4egtMESHOnddo+37g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcgt6FiuNyyDcK8IV741y+rna5ORLTpsaA4qoOARNzuKMZjpo7
	G+EYCTHqOrSMOkXKwGDELXaC0dLyYR5rRRCrSS4wKO4HsbNJvqAfBq/DWjDn9kYSGdvICseOg0x
	ucWm0BNfA7bsWDvVPZ0IwLNAdAWTAc8N95ZuDZxK6
X-Gm-Gg: ATEYQzz4xQ1NbVMYJ9zR39drIoGf4Mcs/aNEgieb5GN+n9OfMd34oO2J1pIyLzdW4Uq
	QqujWNfio/LQqBDPs2vFpN7eia4nhBiNjAv0Vlbvx1lDMY4DhaWii4leLuDvp6LsEgbt4Bgxl5c
	zQHawqf6xljgNpFuflRoHf0A866NVUHqt0ZXGpXng9b7S+2ol/UE2KlN2qweaX2OuBckCyCQkBk
	4tBKaCCt7zVSJO6YzVPrpfmcijIgvfZ5YtIZke2zOGzn50XdsICk6KyZeZNHQrl0GKSU0yaHM/R
	pq/8j4w=
X-Received: by 2002:aa7:dbd3:0:b0:65f:7040:22b1 with SMTP id
 4fb4d7f45d1cf-661e7da4cf3mr12265a12.14.1772838755088; Fri, 06 Mar 2026
 15:12:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306210900.1933788-1-yosry@kernel.org> <20260306210900.1933788-2-yosry@kernel.org>
 <CALMp9eRWwPwUSyQmizy8i2tF1CVO4iLY6x0vX1OoPUiRdCm4NQ@mail.gmail.com> <CAO9r8zOhaDeYWq_6TNdPGyEE323o_8xsWTozGdro9Oni8310kA@mail.gmail.com>
In-Reply-To: <CAO9r8zOhaDeYWq_6TNdPGyEE323o_8xsWTozGdro9Oni8310kA@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 6 Mar 2026 15:12:23 -0800
X-Gm-Features: AaiRm53kiFkToGDcgC52oWqdA4VVW8o-nIE63PrBjBL7Ufa6hJ5DdCMWT0ICffA
Message-ID: <CALMp9eScswzFak+PMOcaDXM-W+cXtkG7fQ=jadq__+5JeqYcTQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: SVM: Use maxphyaddr in emulator RAX check for VMRUN/VMLOAD/VMSAVE
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D38CE2288D7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73181-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.957];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 2:37=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> On Fri, Mar 6, 2026 at 2:27=E2=80=AFPM Jim Mattson <jmattson@google.com> =
wrote:
> >
> > On Fri, Mar 6, 2026 at 1:09=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> w=
rote:
> > >
> > > Architecturally, VMRUN/VMLOAD/VMSAVE should generate a #GP if the
> > > physical address in RAX is not supported. check_svme_pa() hardcodes t=
his
> > > to checking that bits 63-48 are not set. This is incorrect on HW
> > > supporting 52 bits of physical address space, so use maxphyaddr inste=
ad.
> > >
> > > Note that the host's maxphyaddr is used, not the guest, because the
> > > emulator path for VMLOAD/VMSAVE is generally used when virtual
> > > VMLOAD/VMSAVE is enabled AND a #NPF is generated. If a #NPF is not
> > > generated, the CPU will inject a #GP based on the host's maxphyaddr. =
 So
> > > this keeps the behavior consistent.
> > >
> > > If KVM wants to consistently inject a #GP based on the guest's
> > > maxphyaddr, it would need to disabled virtual VMLOAD/VMSAVE and
> > > intercept all VMLOAD/VMSAVE instructions to do the check.
> > >
> > > Also, emulating a smaller maxphyaddr for the guest than the host
> > > generally doesn't work well, so it's not worth handling this.
> >
> > If we're going to throw in the towel on allow_smaller_maxphyaddr, the
> > code should be removed.
> >
> > In any case, the check should logically be against the guest's
> > maxphyaddr, because the VMLOAD/VMSAVE instruction executes in guest
> > context.
>
> Right, but I am trying to have the #GP check for VMLOAD/VMSAVE behave
> consistently with vls=3D1, whether it's done by the hardware or the
> emulator.

Consistency should not be an issue, since VLS cannot be enabled when
the MAXPHYADDRs differ. VLS doesn't work in that scenario.

> >
> > Note that virtual VMLOAD/VMSAVE cannot be used if the guest's
> > maxphyaddr doesn't match the host's maxphyaddr.
>
> Not sure what you mean? Do you mean it wouldn't be correct to use it?
> AFAICT that doesn't prevent it from being enabled.

It is incorrect to use VLS when it doesn't work.

