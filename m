Return-Path: <kvm+bounces-4899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C196B81974A
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 04:47:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D60C287A16
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 03:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD14D16425;
	Wed, 20 Dec 2023 03:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fGzs/JmH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84BA13ACF
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 03:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703044028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9w+rATDkUtjVeCwGcF601wo/RABwY+YM2dZRh5W8pOM=;
	b=fGzs/JmHb4VQNOWJF8CtyexwLFIWZhHq21jGKhW9Tpmf2u0Bv0CjK2nq/dy19VZ1mvRGU+
	swUh0T/hEqy1k0yH9KM72MuoBzkmjWMSCloGI0zBfp3JRhrPFZcHKXMW5tLFuZhJEVSYU+
	BbSNhT0aF8aVCSF/VFcGx2OjIAmbveI=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-39-s5zQAufEPP6Mip8uP2vDFA-1; Tue, 19 Dec 2023 22:47:06 -0500
X-MC-Unique: s5zQAufEPP6Mip8uP2vDFA-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3b9f111c18dso7269588b6e.0
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 19:47:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703044026; x=1703648826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9w+rATDkUtjVeCwGcF601wo/RABwY+YM2dZRh5W8pOM=;
        b=unwNi1zCGjV1GSZTldFr6Ww1AJ4rBA0f2XOQ/Zw6up73WA2VyEi1JkgT40TeKb0oM0
         fusEjszNLUEH3Lr90NxJucuQuV7W0+4cu3qHvWgoOLMl08fa860kGfYdKzHQ/Q2ypsiD
         gG1SDdGUU55xqlgwJPkX5kHs+mcwAjn4FO2W1i3PrAZdBQaB1dUH+uIqzZhMMz+pO4xH
         DsRNPIFo6A3rI5VE176fKqFgdE+U/yPftdbadEhP3XfXv9QXucQ7h08oZGujcMuU378r
         GNS+37jun0eyI1+kgd+1OgP+N5mwA0OB4d5ztJ6Zm+KuC3uUz3ALSGGgFYO45nS0fMjH
         g4lA==
X-Gm-Message-State: AOJu0YwBnBnxDXhFdl/S0M5KuQ8LXv/mVyX5rEGHsQPL/kKWYeHHnGDv
	F3ATinvkJ/4FXCtkyl2Yi3CPOdErOnKl4RjAwuOMR4Bf2Y6xiSmD6e14swkwPa6Gp9z6sTKYCZI
	nqaElNrXKElKLzwFKKlR1BUc0cAUJ
X-Received: by 2002:a05:6808:f91:b0:3b8:b20d:cecd with SMTP id o17-20020a0568080f9100b003b8b20dcecdmr25104410oiw.32.1703044026074;
        Tue, 19 Dec 2023 19:47:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFN31V4IDc9YdM/jG9vbcC5ujWxgZW0OEmEotp+PSSsAUbfJELk/1CFnUoFJlwk0MWCN004qTKhi5PhO5Y4oo0=
X-Received: by 2002:a05:6808:f91:b0:3b8:b20d:cecd with SMTP id
 o17-20020a0568080f9100b003b8b20dcecdmr25104401oiw.32.1703044025883; Tue, 19
 Dec 2023 19:47:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-7-dtatulea@nvidia.com>
In-Reply-To: <20231219180858.120898-7-dtatulea@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 20 Dec 2023 11:46:53 +0800
Message-ID: <CACGkMEs_kf2y9Khr==zY3RRHffaPRwS51XK33Lgv1eeanQdRpg@mail.gmail.com>
Subject: Re: [PATCH vhost v4 06/15] vdpa: Track device suspended state
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Eugenio Perez Martin <eperezma@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, virtualization@lists.linux-foundation.org, 
	Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 20, 2023 at 2:09=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> Set vdpa device suspended state on successful suspend. Clear it on
> successful resume and reset.
>
> The state will be locked by the vhost_vdpa mutex. The mutex is taken
> during suspend, resume and reset in vhost_vdpa_unlocked_ioctl. The
> exception is vhost_vdpa_open which does a device reset but that should
> be safe because it can only happen before the other ops.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Suggested-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> ---
>  drivers/vhost/vdpa.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index b4e8ddf86485..00b4fa8e89f2 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -59,6 +59,7 @@ struct vhost_vdpa {
>         int in_batch;
>         struct vdpa_iova_range range;
>         u32 batch_asid;
> +       bool suspended;

Any reason why we don't do it in the core vDPA device but here?

Thanks


