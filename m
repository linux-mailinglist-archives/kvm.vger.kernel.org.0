Return-Path: <kvm+bounces-4903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 85315819754
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 04:49:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A04CE1C256B5
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 03:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08D5D1F602;
	Wed, 20 Dec 2023 03:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C155imKb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A7D1E516
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 03:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703044041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jXT8y9tlblfV00CjChE7U+F283GXLav1fpyYasxi31k=;
	b=C155imKbgXEld49gV7jEG0Mhb17lCG8A+4+doNr8c5ceS/KVKyoFaNgJlJPx3ZjF5P6YmL
	zE4xUwx0RM5hZoObn0rlPZlsFtT63l8Y4itPauMTxGkD2l2BpvFEgslOMqICcE5gBmKCut
	wF/bOq9WkyjzydW4qPXFqUyGxOpijII=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-YMt3nmXTOquRKcbrI1YeSQ-1; Tue, 19 Dec 2023 22:47:19 -0500
X-MC-Unique: YMt3nmXTOquRKcbrI1YeSQ-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-591bd047351so3946940eaf.0
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 19:47:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703044038; x=1703648838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jXT8y9tlblfV00CjChE7U+F283GXLav1fpyYasxi31k=;
        b=b6+44rfzadZdFomxtN7frYyAU/yEoOhipsFJmOQYj8SGGQR2bOphP2FCjnW86LLa9O
         vsd9Mlib5S+cDgvRi9fXpCmkzurVpsOB+whnGo47MJRKrdKbzuq2uQ2k9JxDCQh/DEXe
         LBEQqUN/RFYypvm5QV31Y3I5wO68jZOkl/M6PkfI1pVesao4KJzCGrJfbOXfl/uhkFke
         y28vsJ/HVqzdScktD3RGvc9tldnCPKXNI/Z3J9XGw1EFsCtlmys6y0gZbxTHMAaBdIKi
         r6GsBY878aYYjK/PFnv4hbNC5qp4tmTmsSRBI4TEx4AzVSe2NtiCdpMOGpDfG/1Aq/zY
         /g4g==
X-Gm-Message-State: AOJu0YzEQcRjzzWgkkoKHWXBB+yHkyt02FxyKTGC2PvQNn4D7cyh0W1I
	Zt8g0r6DsuAs6JGiORvG1KgslHEVkhfIQd19F0Lui7SWLJ0mqPWXQooM9mV3Jn9FDlhKRQ2bVH+
	6emS7evAKbL/YQyWRSSoy0l7ltkH23UrYCh4+xG4=
X-Received: by 2002:a05:6359:6a6:b0:170:406d:42e7 with SMTP id ei38-20020a05635906a600b00170406d42e7mr18126791rwb.39.1703044038231;
        Tue, 19 Dec 2023 19:47:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEZ0zz4zEAWU43T+4oCW+F/doXzW3xC/zXGOAN1e58DPokWZLVU/waMdMYVR9sY2LCmHpV9lPtvyLyHoo9xicM=
X-Received: by 2002:a05:6359:6a6:b0:170:406d:42e7 with SMTP id
 ei38-20020a05635906a600b00170406d42e7mr18126783rwb.39.1703044037924; Tue, 19
 Dec 2023 19:47:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-14-dtatulea@nvidia.com>
In-Reply-To: <20231219180858.120898-14-dtatulea@nvidia.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 20 Dec 2023 11:47:05 +0800
Message-ID: <CACGkMEtbGurh-HUb3eDcH74y7YDnvd06K8=MvRHj+4NLyaJ3Ag@mail.gmail.com>
Subject: Re: [PATCH vhost v4 13/15] vdpa/mlx5: Use vq suspend/resume during .set_map
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
> Instead of tearing down and setting up vq resources, use vq
> suspend/resume during .set_map to speed things up a bit.
>
> The vq mr is updated with the new mapping while the vqs are suspended.
>
> If the device doesn't support resumable vqs, do the old teardown and
> setup dance.
>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Acked-by: Eugenio P=C3=A9rez <eperezma@redhat.com>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> ---

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


