Return-Path: <kvm+bounces-4902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C3707819753
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 04:48:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 031C11C25499
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 03:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889271DFED;
	Wed, 20 Dec 2023 03:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZeIzUDYJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847911D687
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 03:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703044038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QDgKeSnW9WjPiYCNV2h6BRFrU23HWRGExp1tEJfVp+A=;
	b=ZeIzUDYJ6oP7mYq+Vd7WdKNFZ25MvPjCo65FhsAoJncGVZ8GTqVlndxK+F5nKIhZJiNZxY
	T66hKHbIKEfADPNnYr05MRrLuN3yAhIBBshEE5BZyRnFFnsPE+KJ2vFkiPM8BjMiiJgMPd
	DtMwLOJIH25V/D9H84pSVOFQQ4SEH4U=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-ILrl0X1NOVe__I0zi8FSlA-1; Tue, 19 Dec 2023 22:47:15 -0500
X-MC-Unique: ILrl0X1NOVe__I0zi8FSlA-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-28bc9e1f43eso604028a91.0
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 19:47:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703044034; x=1703648834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QDgKeSnW9WjPiYCNV2h6BRFrU23HWRGExp1tEJfVp+A=;
        b=B8mZQT0yg0GF5i47GeVJ96W9G/nPDLADQS+0WVeM6ZOGFvNG9wjcT/rlKxeYE72saL
         ba31I8iTj8ly42pRD0O0pss3Idc/Sppz91FFwk0OqDU3IXNV1RQNK8yylamBylvcszpS
         377IdFxlFrHsv48DfB9pwev5QQI6GIlv7wMIKUx+uSVnGPnUUNIuGRhkDyFqReemOU1F
         iLSQogDmMEdNPi/ifs8/4TuOEurR30Qh6EnhetG6irOaKK40jEDJFED/xyMlUpdBSLJm
         sZXLX/elGb0cMzvDNmbU80NgmAK8UvKPjhZ5tCIEfSYOdezQeMv5k8V/UHIzS2oOnYmN
         4TCQ==
X-Gm-Message-State: AOJu0YxxGx1PoENMsbrCqOKDrv9PIlsjrJbvHma7WLLgQkhCwu9J9XTN
	sJqPTwFPH9I4kRO82ZWhPlqNv3oiMC5MFc+Voug0i/VPryOHnVmWAMXiEVYinG/qoLbcK/G4u81
	s0UcCEfu37gU5pGqpvzDfzE2nFVyo
X-Received: by 2002:a17:90a:e550:b0:28b:6b69:425e with SMTP id ei16-20020a17090ae55000b0028b6b69425emr3250718pjb.34.1703044034771;
        Tue, 19 Dec 2023 19:47:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0dF4xSsJZ5QD3HCGa61B+KNXdkWHm1GNDLBaUm0KZYX0Ya7QIXi6kgXFSx5HjjaDaFnAL8BB6HVPmo69iIiE=
X-Received: by 2002:a17:90a:e550:b0:28b:6b69:425e with SMTP id
 ei16-20020a17090ae55000b0028b6b69425emr3250705pjb.34.1703044034544; Tue, 19
 Dec 2023 19:47:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-13-dtatulea@nvidia.com>
In-Reply-To: <20231219180858.120898-13-dtatulea@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 20 Dec 2023 11:47:03 +0800
Message-ID: <CACGkMEusxhpgdhf5BXPp_r913xQk7Td1bw+-oEJyDFhZFsc7tg@mail.gmail.com>
Subject: Re: [PATCH vhost v4 12/15] vdpa/mlx5: Mark vq state for modification
 in hw vq
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
> .set_vq_state will set the indices and mark the fields to be modified in
> the hw vq.
>
> Advertise that the device supports changing the vq state when the device
> is in DRIVER_OK state and suspended.
>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


