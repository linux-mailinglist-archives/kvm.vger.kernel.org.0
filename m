Return-Path: <kvm+bounces-4900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B8E5E81974C
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 04:48:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 755E6287BBD
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 03:48:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72FE21863B;
	Wed, 20 Dec 2023 03:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iiwNxq9S"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BA91168C3
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 03:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703044032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7+JDn1KJzJATgI5zfmEFBJrCFOmZkPUddhQTthC2QFc=;
	b=iiwNxq9SFMESWRA5pG0M+S95N7DAAvx+DHKyjjOYriOntCM6YWSSTWpQTyJcHmdbAEKw1Q
	2/qQtJ1ZquIuJ77jucZR+pI/4hnRkqYB1Ns+3McDLRbjyE3k9gX84PHJ7dEV68QwT6f6jq
	ZIu3VCx9bxHpW3HtEjSNqjQGVlrJFTs=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-o6n9Si4jP_KIc_EZ9qS6QQ-1; Tue, 19 Dec 2023 22:47:11 -0500
X-MC-Unique: o6n9Si4jP_KIc_EZ9qS6QQ-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3bb6f239119so267258b6e.2
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 19:47:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703044030; x=1703648830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7+JDn1KJzJATgI5zfmEFBJrCFOmZkPUddhQTthC2QFc=;
        b=H+bktcUHxwBCP/IF2VDVHOmIcX5ZOgzSxMdXTDNm8b6pTFx4EUDAsJU7tPZDd2FpJo
         2r0E0NnpwFwwJMrtC7tF7XRu5Egq6+mx5ZaqSx7FojLG6tWEKy7VeBxO91ZB/WqVuFB4
         pkTNXHg7sEGxXpMKkL9Iv3NJYtRFPHlz4A4+P0PtNhqg4gsZJqzYwlhR/FrXTn6vluXy
         HCWnw+eXu4xlb39JVWnptUZmuJ+9FLOkYq/ZLPiOZDZtUcmqzgr1901Rjgnp7fEvSEqg
         DsB2E9/xWLhZs2W1tcExHL9lUj5my5tFTZGhD6osLasyRXr0dEnRaCpIAZanYM9LAp1B
         XjjA==
X-Gm-Message-State: AOJu0YzIcvATur0JiRNWLVeLBWAI3KtJB/+U6c0UtZ0TOFZXjsiLyaRY
	RF/hewW8RDBelGp7dhhaEyqVj1fWluXrBaAwR2EIHvkBiiakBLMNsw/wp6atSBLMxFNJptw7zcS
	5/j76HAKr3iXmKFF1N3zcMkstJgCG
X-Received: by 2002:a05:6808:16a3:b0:3b8:b063:5d75 with SMTP id bb35-20020a05680816a300b003b8b0635d75mr19240109oib.92.1703044029955;
        Tue, 19 Dec 2023 19:47:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEjc78+yw+xCGEIAPfx0ZKd6JVwAwXS+dRnEknTKLfywa1GFI4mcMh1fsZ51KK4vW8KtASd61JsUKG4h1Ooauk=
X-Received: by 2002:a05:6808:16a3:b0:3b8:b063:5d75 with SMTP id
 bb35-20020a05680816a300b003b8b0635d75mr19240092oib.92.1703044029759; Tue, 19
 Dec 2023 19:47:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-10-dtatulea@nvidia.com>
In-Reply-To: <20231219180858.120898-10-dtatulea@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 20 Dec 2023 11:46:57 +0800
Message-ID: <CACGkMEu-UOBojsNa_f_XWe6mQJfA+TGdP=ZNTS7bUqky_zdp+w@mail.gmail.com>
Subject: Re: [PATCH vhost v4 09/15] vdpa/mlx5: Allow modifying multiple vq
 fields in one modify command
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Eugenio Perez Martin <eperezma@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, virtualization@lists.linux-foundation.org, 
	Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 20, 2023 at 2:10=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> Add a bitmask variable that tracks hw vq field changes that
> are supposed to be modified on next hw vq change command.
>
> This will be useful to set multiple vq fields when resuming the vq.
>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


