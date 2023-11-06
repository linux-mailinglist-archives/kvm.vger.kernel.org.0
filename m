Return-Path: <kvm+bounces-777-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FA127E28A2
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 16:26:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D151EB20C39
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 15:26:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6C928E0D;
	Mon,  6 Nov 2023 15:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hy5SrHpU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB99628DCA
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 15:26:32 +0000 (UTC)
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97538107
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 07:26:31 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 41be03b00d2f7-5b980391d7cso2578987a12.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 07:26:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699284391; x=1699889191; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x4LpEv+pwTjdcAwF4xpHM37cbtA1PVwPNrLsJCgrL6w=;
        b=Hy5SrHpU6ePJYqtbTSD1DD575oeBmoUHJBdto4yxZMquOSLgbQi32K5rSCWluvGWgm
         HWMCwQPDsurvzgqC6Jt8PecIkbnKYEAznR8A9wFu13xFRfKk9FBAwUxb3Vrg/O4zu/ij
         PZe/8IKFrUHBEtDnpoMZXxUdSoky5trp7i5fPPd892TsxS9R5GzYHv77Aq8UpGuksc/l
         ZedyLtAvWdH8JvJhT9zXsNViOwof8h2wlGeAU2YtbO6xWrYz/M6IaX4YY/me9ICvxrVu
         nBKKV0nqgn94DBuKagVU/2WCAuCeHFXOdDY+w9j7cbssso8MSdKgO1THQ4FuvjN2VUOJ
         rynA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699284391; x=1699889191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x4LpEv+pwTjdcAwF4xpHM37cbtA1PVwPNrLsJCgrL6w=;
        b=HyXq3LIGADrq1hNBbUQgO/jVHVH0NbMDwTXy0fpREc077cf+xhxOxcBoSTtM4tJ5FI
         Ufb1R65xCPUvsIYIQK24WYLMeUfvvfPCwbgQCCoWwvCTNor/HlCZRRU81O6roHDDrrhE
         7HwqNtT0m/DO0lPuv2nyijguEpRjmab5J6M8c411mE1aB6PuF36HspuSQbzMbN9bMV0F
         R6ij4Ao5yBHVtDOx05y0/41rnJc15rlTTRNxB8ezeQbrxvkJEViBWdZWmNxtg4nBrxE+
         8qvfSCGpFvrPlp4UXuBhCp1UGliaPXDhd5drVCPUpcP8DInC+Eq3Hx1PYrXIIoZ6QhSn
         4h6g==
X-Gm-Message-State: AOJu0YwP9x9ZHAo804k1pyhLJqFvbX+AbrQ9oS9QsChHlma6inn5ykJw
	GmdWeUQTkjG4rt8FAP+zISx9G35HPjbEUsifiFQ=
X-Google-Smtp-Source: AGHT+IHneaGbT3C6gj2FjJc2jLmhWR8Zp1CCaLiP6VFe6pRtSFgtNJLd4OfSAHBhhT0X9wtKmfoQIrPkKcM7VPhtP9U=
X-Received: by 2002:a17:90a:f198:b0:27d:60b1:4f2c with SMTP id
 bv24-20020a17090af19800b0027d60b14f2cmr22602053pjb.4.1699284390916; Mon, 06
 Nov 2023 07:26:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231021134015.1119597-1-daan.j.demeyer@gmail.com>
 <ZTlSPbh2GnhOKExO@redhat.com> <CAO8sHcnh1mqaEchGSwYaFr7+LTau9yQRt_4zVJGrFsroWik3ew@mail.gmail.com>
In-Reply-To: <CAO8sHcnh1mqaEchGSwYaFr7+LTau9yQRt_4zVJGrFsroWik3ew@mail.gmail.com>
From: Daan De Meyer <daan.j.demeyer@gmail.com>
Date: Mon, 6 Nov 2023 16:26:19 +0100
Message-ID: <CAO8sHcmFqcHs=F7GTUj=Avn_K91q5sw97nLKEco=2kpCsMyCxg@mail.gmail.com>
Subject: Re: [PATCH] Add class property to configure KVM device node to use
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ping

Daan

On Sat, 28 Oct 2023 at 14:07, Daan De Meyer <daan.j.demeyer@gmail.com> wrot=
e:
>
> Anything else needed before this patch can be merged?
>
> Cheers,
>
> Daan
>
> On Wed, 25 Oct 2023 at 19:37, Daniel P. Berrang=C3=A9 <berrange@redhat.co=
m> wrote:
> >
> > On Sat, Oct 21, 2023 at 03:40:15PM +0200, Daan De Meyer wrote:
> > > This allows passing the KVM device node to use as a file
> > > descriptor via /dev/fdset/XX. Passing the device node to
> > > use as a file descriptor allows running qemu unprivileged
> > > even when the user running qemu is not in the kvm group
> > > on distributions where access to /dev/kvm is gated behind
> > > membership of the kvm group (as long as the process invoking
> > > qemu is able to open /dev/kvm and passes the file descriptor
> > > to qemu).
> > >
> > > Signed-off-by: Daan De Meyer <daan.j.demeyer@gmail.com>
> > > ---
> > >  accel/kvm/kvm-all.c      | 25 ++++++++++++++++++++++++-
> > >  include/sysemu/kvm_int.h |  1 +
> > >  qemu-options.hx          |  8 +++++++-
> > >  3 files changed, 32 insertions(+), 2 deletions(-)
> >
> > Reviewed-by: Daniel P. Berrang=C3=A9 <berrange@redhat.com>
> >
> >
> > With regards,
> > Daniel
> > --
> > |: https://berrange.com      -o-    https://www.flickr.com/photos/dberr=
ange :|
> > |: https://libvirt.org         -o-            https://fstop138.berrange=
.com :|
> > |: https://entangle-photo.org    -o-    https://www.instagram.com/dberr=
ange :|
> >

