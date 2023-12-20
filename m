Return-Path: <kvm+bounces-4927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F252A819FD4
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 14:32:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C0341F22F06
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 13:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF9A347A2;
	Wed, 20 Dec 2023 13:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fw/7IhDR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DD52D633
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 13:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703079159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VMzfUMpfCRySKV14r2ACq/M+O86IvQcMgWeUukBTaDE=;
	b=Fw/7IhDRA+57AMeTrk8LZo5kM3Rg7Lf/+v5HcPuYUrxY/HH5nFJn485jT+9qpo399TlduM
	nLHet7/U2fHlaXbz7vy0JjMaOT9attxDnyAuWzeRk3LkPywjopWt7oVRcGHlsSPYcezfEX
	3dAf5MKcvtnpxDRULIJ9tNim6yl+GyU=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-679-rAzNkMExOZ-OFZxYcuzcJg-1; Wed, 20 Dec 2023 08:32:37 -0500
X-MC-Unique: rAzNkMExOZ-OFZxYcuzcJg-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-5cf4696e202so76885357b3.2
        for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 05:32:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703079157; x=1703683957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VMzfUMpfCRySKV14r2ACq/M+O86IvQcMgWeUukBTaDE=;
        b=GHgJVCa48ARdv/5GcN8wvkeHjBxo33A4AjeCRzhvkq9cm/oVYTPekwpAZnK73FDlg0
         WcnC6WhT5AGkhOX3Jnlddhu84/kNhMhPT0zhW7Pe8N/9Pv6d9rXIDhgvAbr1nq3pTGjY
         7uAdhMRyzLAHw4jkKWakGUzJbTCupAYote1Q2xYLvIsGtPpXU52Zr1i0dSVD1kZU0yOF
         mpgmTfIlNpWuHnqebGifCQH70Tn0njGESw7UDQ32Wp9J4ULtAnbwJPVf9F7XAN3eRJGC
         zG9aEpMMCTkIewLyYzZqfKSOPZuBh8b72nUueSw5A/n/Zb3swNFXp6yBF8paYJUrKkuP
         XhwQ==
X-Gm-Message-State: AOJu0Yyn71Z73imoaB6qFsclCV/Rzaz6+q1Q7HJYnx6QDACsDymfzinr
	jJ7t5OWxDDGIi5R7zmau23vzA4EMM4K0wu3IZNDGscUETdW3pNTUsEVywi6MAbZ70GwGrhw9XrK
	3t+YXvhLAmOC4u8Azx1G6ChB3PTeL
X-Received: by 2002:a81:7104:0:b0:5d7:9515:6ae3 with SMTP id m4-20020a817104000000b005d795156ae3mr14296460ywc.33.1703079157224;
        Wed, 20 Dec 2023 05:32:37 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHBizLEtuC1w25WSPAQRdmgfmzbhlgoBE+Ri28WemJThaBvVsn/cvQCI5dtZtYAosoVwA/ga7C8ipUzBYNV8OQ=
X-Received: by 2002:a81:7104:0:b0:5d7:9515:6ae3 with SMTP id
 m4-20020a817104000000b005d795156ae3mr14296452ywc.33.1703079157026; Wed, 20
 Dec 2023 05:32:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219180858.120898-1-dtatulea@nvidia.com> <20231219180858.120898-3-dtatulea@nvidia.com>
 <CACGkMEv7xQkZYJAgAUK6C3oUrZ9vuUJdTKRzihXcNPb-iWdpJw@mail.gmail.com> <CACGkMEsaaDGi63__YrvsTC1HqgTaEWHvGokK1bJS5+m1XYM-6w@mail.gmail.com>
In-Reply-To: <CACGkMEsaaDGi63__YrvsTC1HqgTaEWHvGokK1bJS5+m1XYM-6w@mail.gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 20 Dec 2023 14:32:01 +0100
Message-ID: <CAJaqyWdoaj8a7q1KrGqWmkYvAw_R_p0utcWvDvkyVm1nUOAxrA@mail.gmail.com>
Subject: Re: [PATCH vhost v4 02/15] vdpa: Add VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND
 flag
To: Jason Wang <jasowang@redhat.com>
Cc: Dragos Tatulea <dtatulea@nvidia.com>, "Michael S . Tsirkin" <mst@redhat.com>, 
	Si-Wei Liu <si-wei.liu@oracle.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, virtualization@lists.linux-foundation.org, 
	Gal Pressman <gal@nvidia.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 20, 2023 at 5:06=E2=80=AFAM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Wed, Dec 20, 2023 at 11:46=E2=80=AFAM Jason Wang <jasowang@redhat.com>=
 wrote:
> >
> > On Wed, Dec 20, 2023 at 2:09=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia=
.com> wrote:
> > >
> > > The virtio spec doesn't allow changing virtqueue addresses after
> > > DRIVER_OK. Some devices do support this operation when the device is
> > > suspended. The VHOST_BACKEND_F_CHANGEABLE_VQ_ADDR_IN_SUSPEND flag
> > > advertises this support as a backend features.
> >
> > There's an ongoing effort in virtio spec to introduce the suspend state=
.
> >
> > So I wonder if it's better to just allow such behaviour?
>
> Actually I mean, allow drivers to modify the parameters during suspend
> without a new feature.
>

That would be ideal, but how do userland checks if it can suspend +
change properties + resume?

The only way that comes to my mind is to make sure all parents return
error if userland tries to do it, and then fallback in userland. I'm
ok with that, but I'm not sure if the current master & previous kernel
has a coherent behavior. Do they return error? Or return success
without changing address / vq state?


