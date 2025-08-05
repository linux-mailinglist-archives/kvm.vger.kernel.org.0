Return-Path: <kvm+bounces-53967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD4A9B1B000
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 10:08:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A1E93BF46F
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 08:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DD2F246769;
	Tue,  5 Aug 2025 08:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="jXnhIbmc"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7071E868;
	Tue,  5 Aug 2025 08:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754381314; cv=none; b=PpxrYuwBq6OBZosY+Vu1A9t7YCV7o5IYsUmtMiTt+eMDaSHFhORL1aotX78jl6lEQ+b+mz/JU2HWMaFQEv1hQCytOEQ22k4mwF9qA0Z++WuZzsWmKtF4jqp0kNM+FC3505CO5zel3XycYQW3kQ92ZtmVvoBfELtQ3s4rfDSQ1HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754381314; c=relaxed/simple;
	bh=Cf5zX3DlmIEAytbYhV40xHoSLQSNZGosi+ckput3C0Q=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=J5yNtSQY5QalNsChV0yTXIuOHr2utRHktgmOxlNYAEXsg+jDXqyFz4GBV9zG+9q2UjdcaITn38maArjU/tD0SBIN+tNiSljwCFbMOypC8jkBTwWGAH/4JmO735/+pVh19SWdXH61RDwMf2R4earwT8BwImA8Yh5IB5WPohiSgVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=jXnhIbmc; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1754381296; x=1754986096; i=markus.elfring@web.de;
	bh=Cf5zX3DlmIEAytbYhV40xHoSLQSNZGosi+ckput3C0Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=jXnhIbmc4Fo7CjO+ULyOwhLvEKuap66sVIJT6u1Ij4pFtQRAn+Ma9I5lwVsjTYPY
	 z5dsKDi4MeyrJ8pZF9SlzMGFVKPa4XO5LzPw0UHeOBVz+0PNxVZlYNzWtPKjugmrM
	 p41SD/zM2Ftgy4MHEwdFRteoKWy3/H5zFSZRKREw5Iv8C1Oa1e0769vrhMi5uMXAG
	 Ewme0HzPaPY5YSz2Ycol5FqOp2wopaABIoUjD4w481c/uYYpqZ+w12zsEkmA54d4x
	 WiG2tSsc3TBDiJhnt0RhlUpi34YihbM9rpfwQY+rHRYEabZXuK+oeXxksDUmbv/1W
	 zz0qjcaDgtf4XUC1fA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.245]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N2BHw-1ue8zO1P6U-0160Tq; Tue, 05
 Aug 2025 10:08:16 +0200
Message-ID: <c90910d8-a4e4-4238-95e7-9a2d052cf52f@web.de>
Date: Tue, 5 Aug 2025 10:08:11 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Henry Martin <bsdhenryma@tencent.com>, virtualization@lists.linux.dev,
 kvm@vger.kernel.org, netdev@vger.kernel.org
Cc: tcs_robot@tencent.com, LKML <linux-kernel@vger.kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 huntazhang@tencent.com, Jakub Kicinski <kuba@kernel.org>,
 Jason Wang <jasowang@redhat.com>, jitxie@tencent.com, landonsun@tencent.com,
 "Michael S. Tsirkin" <mst@redhat.com>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Stefano Garzarella <sgarzare@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20250805051009.1766587-1-tcs_kernel@tencent.com>
Subject: Re: [PATCH] VSOCK: fix Information Leak in
 virtio_transport_shutdown()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250805051009.1766587-1-tcs_kernel@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:PN7V6S5zSAmhkQy0TjSOPo+L2ivD5X8OWzYIliPIEYcG0Cw0Yft
 nKuFjAUwNgHZa6CfikIcd9DbVnMxk1/J+vh1ameXEcjYTYN6Ldjw0PpRnPRGGvkr3aTBTmN
 W44gUxvKqD76LvcvKiCcnrJLd28+uo3BX0+zNZPy2gN00OOuo35eLJlt8cS+BLXRQlEJwK3
 mSjOCfw5Zqh1Pm+lkY62A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:2NcbyRpYDdE=;etC1pI//OULfYjX2q8PEYgkLL7R
 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
 1Q==

> The `struct virtio_vsock_pkt_info` is declared on the stack but only
> partially initialized (only `op`, `flags`, and `vsk` are set)
=E2=80=A6

See also once more:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.16#n94

Would a summary phrase like =E2=80=9CPrevent information leak in virtio_tr=
ansport_shutdown()=E2=80=9D
be nicer?

Regards,
Markus

