Return-Path: <kvm+bounces-5724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACE6A82570E
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 16:48:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB0911C231F4
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 15:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 882EA2E82F;
	Fri,  5 Jan 2024 15:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XhU4Gg2P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958D32E64B;
	Fri,  5 Jan 2024 15:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-28be024282bso1245762a91.3;
        Fri, 05 Jan 2024 07:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704469722; x=1705074522; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oHjuD7i+UA3Qw3m7etGOaevmlRCqaIA5WQMiwQTIlE8=;
        b=XhU4Gg2PcmI7njWY5cFISo4UwEBpJMRQ0RsEl5xZipS4Te9VNzBI//n8OnUHFxdcj4
         aap0nncn6bQYrgoMv8bCTAAiKUgRYOlGvReAoL2GIzBP3wHFiAEJU6qhP4A9p2zr1bkD
         LtvHV2FeTmX+XMwypxncDQ6qXnR1cfommRLTgx4XcgDnFyX9ZUYBY2nTCjptAvXOQhGu
         lNszmqNvqvgGsDVwWYZrFd0JZ5ikY+ny/0KcrBqdHnMjZhIKDp6HxugfdrgANAqmPCLp
         y6VoaFLM6lZ78KetCW1uJrVRDHDIPvkFKiBKQnfGkzzaFD8C3cvea3naiidp8otiHkDa
         JCRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704469722; x=1705074522;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oHjuD7i+UA3Qw3m7etGOaevmlRCqaIA5WQMiwQTIlE8=;
        b=ejEAG5MDjgP17fMHaeF2yxdkn6IFDJpps/oRRDOXs+PM/+WyqUK/XRfhdH5IaRr7D5
         cDg4u1bGARBBHWtRnG3iwAQGUnetOsJwaOYl/6uiFwcUyR/HbiLCxlANdGbZKxj4w+pu
         dLOVK0EU0D/W+fyAUk367yRL2UU4GXxFyo8RQJnijCh05Q0Bt8qS1NCYIwcQL0gUeB7T
         8LsdyFejb7uoL6/6ixR6SrqX9DIVGsFsAgg1qPso52jcX4S4t/0Jtd7ZAXG4u2jn2+mP
         V9HYtLkN/wZmr+B4z71U43gZk+Z9CWzIv5aFGnEEPFtJ52pDelsOmuMNOm3NS2c5fs6f
         QcNw==
X-Gm-Message-State: AOJu0YwuRfM2SQiyUzSMB27ku6mSrGkcy4urld7+yNcwmDexgKdXfJjG
	D8zVcDcfKKGXEljCliiR1Ac=
X-Google-Smtp-Source: AGHT+IG4JLyKQE+gM4c27FKh73op2FHqLSCwte9ikVSJ5ZEE7F/zmt6FTbncQktxxFKJuFQG75IOqA==
X-Received: by 2002:a17:90a:5512:b0:28c:ef1a:db1a with SMTP id b18-20020a17090a551200b0028cef1adb1amr1858002pji.35.1704469721772;
        Fri, 05 Jan 2024 07:48:41 -0800 (PST)
Received: from ?IPv6:2605:59c8:448:b800:82ee:73ff:fe41:9a02? ([2605:59c8:448:b800:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id gj9-20020a17090b108900b0028be4f51d2dsm1420897pjb.5.2024.01.05.07.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 07:48:41 -0800 (PST)
Message-ID: <ec7f36ffdb2a76fe5cac7272da07242b3a6296f4.camel@gmail.com>
Subject: Re: [PATCH net-next 5/6] net: introduce page_frag_cache_drain()
From: Alexander H Duyck <alexander.duyck@gmail.com>
To: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
 kuba@kernel.org,  pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Jason Wang
 <jasowang@redhat.com>, Jeroen de Borst <jeroendb@google.com>, Praveen
 Kaligineedi <pkaligineedi@google.com>, Shailend Chand
 <shailend@google.com>, Eric Dumazet <edumazet@google.com>, Felix Fietkau
 <nbd@nbd.name>, John Crispin <john@phrozen.org>, Sean Wang
 <sean.wang@mediatek.com>, Mark Lee <Mark-MC.Lee@mediatek.com>, Lorenzo
 Bianconi <lorenzo@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Keith
 Busch <kbusch@kernel.org>,  Jens Axboe <axboe@kernel.dk>, Christoph Hellwig
 <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,  Chaitanya Kulkarni
 <kch@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org, 
 kvm@vger.kernel.org, virtualization@lists.linux.dev, linux-mm@kvack.org
Date: Fri, 05 Jan 2024 07:48:39 -0800
In-Reply-To: <20240103095650.25769-6-linyunsheng@huawei.com>
References: <20240103095650.25769-1-linyunsheng@huawei.com>
	 <20240103095650.25769-6-linyunsheng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-01-03 at 17:56 +0800, Yunsheng Lin wrote:
> When draining a page_frag_cache, most user are doing
> the similar steps, so introduce an API to avoid code
> duplication.
>=20
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>


