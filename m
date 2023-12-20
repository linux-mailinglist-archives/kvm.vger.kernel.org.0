Return-Path: <kvm+bounces-4955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FCA481A41A
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 17:15:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16CE32899F9
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34AAC48CC9;
	Wed, 20 Dec 2023 16:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b1U/fhYu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02344779A
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 16:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703088692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hr8MPAJHFdPTjh5Rq/GtMEvXBHCwBjyrhMG94FUnKkw=;
	b=b1U/fhYu66uCQGwBIxKR5dd4lM1bDK8nHBTzpH6CnJ1Axu9GQLGc0EFmHl96qelgym9j9O
	ypG1aVle8c8xbB+zsesiM/ohC0E/Rwc3QT5fGaX8sz4XCGzELpNwa2rsfuLB+pK9jFG4JH
	+4Sp3z7pImnc4HoJ/W68o85kiu3ca/M=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-Tzmhi71aPjC3omAFgubmTA-1; Wed, 20 Dec 2023 11:11:31 -0500
X-MC-Unique: Tzmhi71aPjC3omAFgubmTA-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-5e76b663ef3so42056207b3.1
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 08:11:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703088690; x=1703693490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hr8MPAJHFdPTjh5Rq/GtMEvXBHCwBjyrhMG94FUnKkw=;
        b=UPEgq9C1NGrR2scuTMTNzKJ0HdZmhka6sHhW/B40LZJ8BZFcLe6EUY85QsTI8dtq/b
         JAV+/YXy5zH49bI/cMj+6U5o43vA9nrt54vMkD0m5bbnxto6pDezyhgmsZSwEkUm/IRA
         lZyzVXTxtWSH7S5Iia/81aza6F0ajM9qu7OuS3/AvOwvZ7w/ao7Aw8avOPgucPGEhW4N
         pfai8hZih29xLt30h741Hm7d1dVBvFOuyB7BiI/bsHswhWqya6NQPQmtPOmxrK2CwnjW
         HTehhEXEKh9jE0N5fakt9N1h7Iz+Bg9g0//+2QdBm0W3/v3dEzS+MIsMsC3C/EkrGoF9
         wp9w==
X-Gm-Message-State: AOJu0YzMdLQIO2/EzUHtsVgcoLovt2O3Gu2CVmq7nQiaArYCCTi5i5bW
	ODo+dx3kmkUR1i0rG66QCqd4+6OyNeF1r0yq4mBS6cr612k4VjPyN/kEuII/gBc5c8LAD+mqDc+
	+DVi4F7bG00b1BZYKnyUvf6SKw8QP
X-Received: by 2002:a0d:c101:0:b0:5e2:51da:c3c7 with SMTP id c1-20020a0dc101000000b005e251dac3c7mr10305121ywd.21.1703088690311;
        Wed, 20 Dec 2023 08:11:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH1/3P9BihNppwPcI9ZwmYIdbokvO4vu2D8gVryyj+uidHmGZ7fPxQNOeaB6BK51iRQjk9CdAWw+/VME/gOfzI=
X-Received: by 2002:a0d:c101:0:b0:5e2:51da:c3c7 with SMTP id
 c1-20020a0dc101000000b005e251dac3c7mr10305113ywd.21.1703088690077; Wed, 20
 Dec 2023 08:11:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-4-dtatulea@nvidia.com>
In-Reply-To: <20231219180858.120898-4-dtatulea@nvidia.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 20 Dec 2023 17:10:54 +0100
Message-ID: <CAJaqyWf7cVQ0VC2uLQPeP1B4XYCCQupKFcRFhpEge40=ci17zQ@mail.gmail.com>
Subject: Re: [PATCH vhost v4 03/15] vdpa: Add VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND
 flag
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
> The virtio spec doesn't allow changing virtqueue state after
> DRIVER_OK. Some devices do support this operation when the device is
> suspended. The VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND flag
> advertises this support as a backend features.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Suggested-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
>  include/uapi/linux/vhost_types.h | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/include/uapi/linux/vhost_types.h b/include/uapi/linux/vhost_=
types.h
> index aacd067afc89..848dadc95ca1 100644
> --- a/include/uapi/linux/vhost_types.h
> +++ b/include/uapi/linux/vhost_types.h
> @@ -196,5 +196,9 @@ struct vhost_vdpa_iova_range {
>   * and is in state DRIVER_OK.
>   */
>  #define VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND  0x9
> +/* Device supports changing virtqueue state when device is suspended
> + * and is in state DRIVER_OK.
> + */
> +#define VHOST_BACKEND_F_CHANGEABLE_VQ_STATE_IN_SUSPEND  0x10

Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

It would be great to find a shorter ID but I'm very bad at naming :(.
Maybe it is ok to drop the _BACKEND_ word? I'm ok with carrying the
acked-by if so.

Thanks!

>
>  #endif
> --
> 2.43.0
>


