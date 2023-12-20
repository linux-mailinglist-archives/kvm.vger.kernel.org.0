Return-Path: <kvm+bounces-4958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7878E81A440
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 17:18:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3494628B52C
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0214C634;
	Wed, 20 Dec 2023 16:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aAYeNCKu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E224C61C
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703088754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vEaUEcnajrqgltfyosH4+omdF/fMexYhj4bOk+VvvgM=;
	b=aAYeNCKuFX0LtNZanY07NyIxH4iv+eNmZ4oc7aUEAz48jU/L3OTGNT5IDuaG2ffxGWJpXH
	m09PokzsUDXGLJg6oLyvBtHGu2vWNFcKOpCyXS5/g7Dr0DvUjONN0p47/NOk9o21ui4C5v
	0GfSZtMhMvpxzeudYHRYJjk2c6+RYfA=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-447-Snx2XDB8PcyTAULu-JMAZA-1; Wed, 20 Dec 2023 11:12:32 -0500
X-MC-Unique: Snx2XDB8PcyTAULu-JMAZA-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-5d10f5bf5d9so52743497b3.3
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 08:12:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703088752; x=1703693552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vEaUEcnajrqgltfyosH4+omdF/fMexYhj4bOk+VvvgM=;
        b=ImBsyGnGN0yNib52o04mJz+Lp3I7IvhgBQhFm7x3JKi+LMwMy+iBoHkyauDNHxaZWL
         Q9rXbkIyGPrsxvDv17BH4vRe+z/s3G7Jo/2YKwU87UWuK5Ws+fRoCleR9RvJ+JIeOFWv
         1Sfe4jkEE2BPUqmkzutkyNJZObkMItgi0znNDOAYLwrAoljx5tr2qGIwGzcrseq0yfbz
         4dn1t2PA7Pqz+yyP20+iTiaUhOJBmhqGdCp2TZu94UNHYCssUKBJVIsDHRc4Zkz5GNmL
         LSxkLToWIN2OJFqiQBIcQSqgaG3IJYqD7WVqb1XBdLuou3vN1RBH7bTNIBeOn0B50MFN
         KOMg==
X-Gm-Message-State: AOJu0YxdfAm7ukaqMJRTHU+BNUPHreUfH64bL23jSXXkXqYXtC/fpwy1
	+bzcI+nbYJ8OryM0+Rn4wSeRdSTsKcypqcx4K+2QO3Peb95lhP5fBzjJFhPRAf27LFAEQz/uiI/
	AuacV4ZWFUDVdOVbFmw+P9n6WifYh
X-Received: by 2002:a25:b28c:0:b0:dbd:ae7b:fa8 with SMTP id k12-20020a25b28c000000b00dbdae7b0fa8mr579092ybj.89.1703088752254;
        Wed, 20 Dec 2023 08:12:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHHWUzQ5gSLWTlGDWQ2EyGysa9J4p1aJm/bZyTvMiHKlVwkL61HZXv/dGZYlfl74NKZqaTdvxihWh9dq51N+XM=
X-Received: by 2002:a25:b28c:0:b0:dbd:ae7b:fa8 with SMTP id
 k12-20020a25b28c000000b00dbdae7b0fa8mr579074ybj.89.1703088752028; Wed, 20 Dec
 2023 08:12:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-5-dtatulea@nvidia.com>
In-Reply-To: <20231219180858.120898-5-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 20 Dec 2023 17:11:55 +0100
Message-ID: <CAJaqyWeZK5WmZRnUv4+MF=A1ALsx_OOcWHXDV1EquwpBhTkVJQ@mail.gmail.com>
Subject: Re: [PATCH vhost v4 04/15] vdpa: Accept VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND
 backend feature
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, virtualization@lists.linux-foundation.org, 
	Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 19, 2023 at 7:09=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> If userland sets this feature, allow it.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Suggested-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

> ---
>  drivers/vhost/vdpa.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index da7ec77cdaff..2250fcd90e5b 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -749,6 +749,7 @@ static long vhost_vdpa_unlocked_ioctl(struct file *fi=
lep,
>                                  BIT_ULL(VHOST_BACKEND_F_IOTLB_PERSIST) |
>                                  BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
>                                  BIT_ULL(VHOST_BACKEND_F_RESUME) |
> +                                BIT_ULL(VHOST_BACKEND_F_CHANGEABLE_VQ_AD=
DR_IN_SUSPEND) |
>                                  BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRI=
VER_OK)))
>                         return -EOPNOTSUPP;
>                 if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
> --
> 2.43.0
>


