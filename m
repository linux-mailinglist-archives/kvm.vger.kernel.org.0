Return-Path: <kvm+bounces-10950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9E38871C85
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 12:00:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 857CE2856A7
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:00:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A47C54902;
	Tue,  5 Mar 2024 10:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="YTo0HmCp"
X-Original-To: kvm@vger.kernel.org
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967C322097;
	Tue,  5 Mar 2024 10:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709636155; cv=none; b=N/9DcMScMgcqUloO8SR/0LF8ecRICDC4Qc1wtF1AP8SDdRzcRzHqeTrVTnXETOv3Isw6kLh3dTmVbgERYD32TzJhjfQ1QW1tw8zSG9TfvZC2E4UC9yyExUTseZFkAVIznltwSd1qo2qJMoHcsmf/60z2KlEe2B20XXWhVimJJL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709636155; c=relaxed/simple;
	bh=UsL7Vlx6nSSfyzziAfvlO9l3sL6x0ttJ+Ag/LcsaD8s=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dCrrUu7yt2L3Mi/diMNCkKbSGSndZo+/XRvclvaLRp02pBkFusbaZeCJhNSlzjVXAEAfUynPqq9XrIWAwWL8MrsQsKPOh4qdGMRgid7EVOY7wpRiYDEQSz5zcBXRnGJkPT2VRjzx5pCsapKM/XkZxntWo2090XSL7kHF3cImOd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=YTo0HmCp; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=bMWgURJ3jS8l4Cq9Nb814P898s9DhjQB0FUrf8jQrR4=;
	t=1709636153; x=1710845753; b=YTo0HmCpNbQnU+QokduBRuaDfTvfz+cy2G+hIDgcyfxHS5E
	NRcj4scGqnQGY4sZkG/HhzPt4pYi7os7Gn+QSuNl/tDUpxJAvU5mNSWc3BUdXQBfNQK7GGYCQzYz6
	RLHIO9chSmt9fRw0UI81Iue+/yLnp0Ruvm/mhpTLtyGU3GnfXlq14A0nyOfOrNXyOVyN/HrdFTS+K
	N8RoMYOKxnqk2ybWstRJN7sMcn36ttGKH3qSb0bZdHXGjoQtcq7dHWPF/2YrThEfbmXVIvqYE4x2K
	qbd+S2VK0iCEvZ3GLRKGAEkhN6EIY234LEjltiF+Xv7+1Hd+L8/hchPHDiNUTu9Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97)
	(envelope-from <johannes@sipsolutions.net>)
	id 1rhSSb-00000002iyF-3Thw;
	Tue, 05 Mar 2024 11:55:50 +0100
Message-ID: <22d9f3dc9fc8a05808f03df33bf2d58924fb61e6.camel@sipsolutions.net>
Subject: Re: [PATCH vhost 2/4] virtio: vring_create_virtqueue: pass struct
 instead of multi parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>, virtualization@lists.linux.dev
Cc: Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Hans de Goede <hdegoede@redhat.com>,
 Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>, Vadim
 Pasternak <vadimp@nvidia.com>, Bjorn Andersson <andersson@kernel.org>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, Cornelia Huck
 <cohuck@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,  Eric Farman
 <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,  Alexander Gordeev <agordeev@linux.ibm.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
 <jasowang@redhat.com>, linux-um@lists.infradead.org, 
 platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org, 
 linux-s390@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 05 Mar 2024 11:55:48 +0100
In-Reply-To: <20240304114719.3710-3-xuanzhuo@linux.alibaba.com>
References: <20240304114719.3710-1-xuanzhuo@linux.alibaba.com>
	 <20240304114719.3710-3-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2024-03-04 at 19:47 +0800, Xuan Zhuo wrote:
> Now, we pass multi parameters to vring_create_virtqueue. These parameters
> may from transport or from driver.
>=20
> vring_create_virtqueue is called by many places.
> Every time, we try to add a new parameter, that is difficult.
>=20
> If parameters from the driver, that should directly be passed to vring.
> Then the vring can access the config from driver directly.
>=20
> If parameters from the transport, we squish the parameters to a
> structure. That will be helpful to add new parameter.
>=20
> Because the virtio_uml.c changes the name, so change the "names" inside
> the virtio_vq_config from "const char *const *names" to
> "const char **names".
>=20
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  arch/um/drivers/virtio_uml.c       | 14 +++++---

Looks fine here.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

