Return-Path: <kvm+bounces-12-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C50A7DA6D8
	for <lists+kvm@lfdr.de>; Sat, 28 Oct 2023 14:07:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 99398B2151B
	for <lists+kvm@lfdr.de>; Sat, 28 Oct 2023 12:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 372A214F85;
	Sat, 28 Oct 2023 12:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IgM5WohF"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B3323CF
	for <kvm@vger.kernel.org>; Sat, 28 Oct 2023 12:07:18 +0000 (UTC)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DADA7
	for <kvm@vger.kernel.org>; Sat, 28 Oct 2023 05:07:17 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6ba54c3ed97so2923167b3a.2
        for <kvm@vger.kernel.org>; Sat, 28 Oct 2023 05:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698494837; x=1699099637; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SKJvKcyb2RWdDk274b6iPkQC86bAjXYUlIA5aUdbkBo=;
        b=IgM5WohFxh4umDHrDBLnfrp2mNyTVRmx2/sEt/7zOpEMVada5lFIgxt/cSftZguMuu
         wvvJoPtVztHH6c/qoIIdx/9nlVWZHFuikXUo/MvHbzcMr3ETNVrFP2Fe0GizkgCEcBwz
         X9LHtiDS0Mx4Rc4aRko9XH1Vhlkfwo75qtSXJ/yqL5CneM9zK3HGMKJZsuJewaJAC1oC
         KBCq7nR07brSIIZcdwXrVLoBS5ijkyajqN2HfQQMm/gZCa1HKEmlJR33cNAuzEQJ5AQu
         uLFLYxjzsTRhY+mJOMZxe62EVAoQwdGhnvqMUawp3/RbPX/XvX8B6NAJmTsgt+D4h/X7
         t0ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698494837; x=1699099637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SKJvKcyb2RWdDk274b6iPkQC86bAjXYUlIA5aUdbkBo=;
        b=oFF4Y+QzAjOxyM1JZLyvQLeNUhKrmRdpspN1E4t6ETvN4RBayc29vgW5UPeWEhQORq
         2eyzxPCn0DuL3qGGqdTVQVLKSzI5TtsEBp7R3Ta2OhSEWKCna/ayWIah7Fjrnnhske9d
         maVOb9UeDgp9FQxwG5ajOAXyvd7OY9hIYWvMVkAtnuXD1zqtkXUih4RAZx838DfR63y7
         D8QkD8hQMfD4zV/h75RluNTZJ+ZYmRi+ibbuYUR4fCauZYiT2IOG6QF5KHMEx9y0WodW
         iv0bSHFydl/6mvIy4Ig9fcVlW7EdoKb43I1nNeWBDebMUlveDLp5bkxgLO6h6xPpWoj3
         Z7kg==
X-Gm-Message-State: AOJu0Yx+sO8ltal9u0GJpEo3GeAr/+dyU0gbiwIErgQOP8Qy9fsyT2zB
	uElQuGbyXXCwl5p3YiKS4ObIQA7J+FYynLFN7OE=
X-Google-Smtp-Source: AGHT+IEdj5XrMmmITiaCJ/1atu+NuwxiM/2j4rW1PnubHu13oZ74aiFbiLTK1fmTX+M9Q6PFdb17tO0twOE44XNBHk4=
X-Received: by 2002:a05:6a20:748b:b0:17a:de5d:1d7e with SMTP id
 p11-20020a056a20748b00b0017ade5d1d7emr6720018pzd.55.1698494836794; Sat, 28
 Oct 2023 05:07:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231021134015.1119597-1-daan.j.demeyer@gmail.com> <ZTlSPbh2GnhOKExO@redhat.com>
In-Reply-To: <ZTlSPbh2GnhOKExO@redhat.com>
From: Daan De Meyer <daan.j.demeyer@gmail.com>
Date: Sat, 28 Oct 2023 14:07:05 +0200
Message-ID: <CAO8sHcnh1mqaEchGSwYaFr7+LTau9yQRt_4zVJGrFsroWik3ew@mail.gmail.com>
Subject: Re: [PATCH] Add class property to configure KVM device node to use
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Anything else needed before this patch can be merged?

Cheers,

Daan

On Wed, 25 Oct 2023 at 19:37, Daniel P. Berrang=C3=A9 <berrange@redhat.com>=
 wrote:
>
> On Sat, Oct 21, 2023 at 03:40:15PM +0200, Daan De Meyer wrote:
> > This allows passing the KVM device node to use as a file
> > descriptor via /dev/fdset/XX. Passing the device node to
> > use as a file descriptor allows running qemu unprivileged
> > even when the user running qemu is not in the kvm group
> > on distributions where access to /dev/kvm is gated behind
> > membership of the kvm group (as long as the process invoking
> > qemu is able to open /dev/kvm and passes the file descriptor
> > to qemu).
> >
> > Signed-off-by: Daan De Meyer <daan.j.demeyer@gmail.com>
> > ---
> >  accel/kvm/kvm-all.c      | 25 ++++++++++++++++++++++++-
> >  include/sysemu/kvm_int.h |  1 +
> >  qemu-options.hx          |  8 +++++++-
> >  3 files changed, 32 insertions(+), 2 deletions(-)
>
> Reviewed-by: Daniel P. Berrang=C3=A9 <berrange@redhat.com>
>
>
> With regards,
> Daniel
> --
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberran=
ge :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.c=
om :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberran=
ge :|
>

