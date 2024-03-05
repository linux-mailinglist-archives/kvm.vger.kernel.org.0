Return-Path: <kvm+bounces-10949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EF59871C7F
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 12:00:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0CCD1C23065
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8FA81118D;
	Tue,  5 Mar 2024 10:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="lqk9tpte"
X-Original-To: kvm@vger.kernel.org
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9AD22068;
	Tue,  5 Mar 2024 10:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709636110; cv=none; b=Fa7RE5NDCGyR6n7r5plJf1vl4KpB6yVGcZHReakuZA8JIV02HHn6DDwnjFy/1NKVUcjDgiYkOpSU6PC2Js06ZP0ez6T6z5mu3KHZsECZVJl5JZRAdZbdiJauPapGgRLDWVdbxl8sb3GIGc49LIih6tRZrT+CZW3mlRRU8grZg4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709636110; c=relaxed/simple;
	bh=SL0/jW5AkjXWIIU3Pc2XZYnTvsMBxq0cm3EOzBmVbxE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mkBDjukwNBVl/FCgXNzk1lchUMnU15pGY3kDMiYZph05aIc8cpIVNnoaKLym+UmWhKhWpEXHB/F727By5BUQ3MUlXYFPDwsmNzkOzFqyf9RfcZZ5Zjnh2PYctlMNzolJw7c1b8/PtSbOYCjQfQ9E9HON3xH/s7Wxwmh9oPRWQwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=lqk9tpte; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=EKvznC5nXjPBL3KoybiT7SDRunCs0+c0gV3HBnK/T7A=;
	t=1709636107; x=1710845707; b=lqk9tpteK1fAIn7EtdbJ99uTV+x6QmPABY//OBkS2gt6UtR
	MM1xIPhQwSeyzQq6C8eWp4CDGRYqdho9LWFlN34GMXUxQIF9SdtXPeafZn7rOU3wuYiCYLwa2TF0Q
	TUcXQlI29e/dbHZ1iBsYUXVo64cUJX9uVPNg2mMaS11cMdsmo7ZZujuykuzWR/Of7IHK4co0z0iu1
	cPY5cdQcK6zNPyNoS6Ikk08zrerwNuElv96YMB836xqTaAbEbEBZGpqRNyL3/80V1Hp4AfWbuR2W+
	rCpmyD6wQBvy7CgOYEMNBLgETLnBPajgSaKw1sAwzxl1fO9HPv9L7uevO6hws6uA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97)
	(envelope-from <johannes@sipsolutions.net>)
	id 1rhSRq-00000002iv2-0O5o;
	Tue, 05 Mar 2024 11:55:02 +0100
Message-ID: <d4572433e5294c04ec2cab99cefca10f997f8507.camel@sipsolutions.net>
Subject: Re: [PATCH vhost 1/4] virtio: find_vqs: pass struct instead of
 multi parameters
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
Date: Tue, 05 Mar 2024 11:55:00 +0100
In-Reply-To: <20240304114719.3710-2-xuanzhuo@linux.alibaba.com>
References: <20240304114719.3710-1-xuanzhuo@linux.alibaba.com>
	 <20240304114719.3710-2-xuanzhuo@linux.alibaba.com>
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
> Now, we pass multi parameters to find_vqs. These parameters
> may work for transport or work for vring.
>=20
> And find_vqs has multi implements in many places:
>=20
>  arch/um/drivers/virtio_uml.c

That part looks fine to me.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

