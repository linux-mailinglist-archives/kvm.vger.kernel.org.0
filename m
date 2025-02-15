Return-Path: <kvm+bounces-38280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 746E8A36ECF
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 15:26:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D96E170E15
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 14:26:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83F1F1D7E52;
	Sat, 15 Feb 2025 14:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="DUWKGwzu"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8808F14F98;
	Sat, 15 Feb 2025 14:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739629602; cv=none; b=WpliESXEgSojY6zvQXLS+sTFvT0YX75GtBkTBEO1jeejgRfzbvFT1IdI0CS4Ii8LCPU2YcREnzlZLHJs4k7P9wutcRPXWgNlIOxNYhE86Y9mPIJnsWmmdggXGik1xejx8l5TMDqEFl3hNQThCfCxkMe/ZmCKhFXtcEoguL361wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739629602; c=relaxed/simple;
	bh=DFut+FK2UpCi7ga43XWIytp2SuGLPekeCyiXPcSaPI8=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=pP6/tUMpbu64qD2lH2gV8g5/qDyeymxfVQhuGZ1x1tzfWRqKX6EkVrh37SpJmkXvbFsRRO/4v6S6xSyGEhBoymaypnuTEmGTA0mSv7M5hV1+btrpmi37UtugKPNO4aaOSIIecDmEA7pDLTeJ2YM96FZVYuh1Rw8AxjP9obzxoAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=DUWKGwzu; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1739629580; x=1740234380; i=markus.elfring@web.de;
	bh=DFut+FK2UpCi7ga43XWIytp2SuGLPekeCyiXPcSaPI8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=DUWKGwzuoNfJ2aWRuBbNtVEwR3nSB6d82Gzvinm38NZYVvRX2Nz8fCmRqkIJVnbk
	 nXzi34KPtW4QJsz3h0UgDnPx0r/Wo4yRti9tclyl82+lzxnKSDNNALQsKIeEKCd/b
	 D7lYuqkPThLIa0xVEummehKJtISNKmdlDaV6GrmgXeMlfUC0TzAPyDk8Yr9uAFOnn
	 HRHIm63E+jZijEjgfhXfj/oeBf4rtR9A0jLR5D1q12ObBOMejbcLDIwPs+NZZRQ2H
	 aSgUeiDHsEl3PQiloeb8Y19eaVUvsOFw9jRVs7B2ir2IyzrFzm6Pa2T9I6wsrSbB9
	 1DVktkLaRc64Z+nEHg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.21]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MyO0u-1tQYuu3Pu0-014p8Z; Sat, 15
 Feb 2025 15:26:20 +0100
Message-ID: <5a401aaa-b6cd-46d4-9fd8-96753599b440@web.de>
Date: Sat, 15 Feb 2025 15:26:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Junnan Wu <junnan01.wu@samsung.com>, Ying Gao <ying01.gao@samsung.com>,
 kvm@vger.kernel.org, netdev@vger.kernel.org, virtualization@lists.linux.dev,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Jason Wang <jasowang@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Paolo Abeni <pabeni@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Simon Horman <horms@kernel.org>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, lei19.wang@samsung.com,
 q1.huang@samsung.com, ying123.xu@samsung.com
References: <20250211071922.2311873-3-junnan01.wu@samsung.com>
Subject: Re: [Patch net 2/2] vsock/virtio: Don't reset the created SOCKET
 during suspend to ram
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250211071922.2311873-3-junnan01.wu@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:eobdNOT+A98DE5H8v3OTataNkfwqaINt6wCZsbStgpwjzWbUtAM
 7F3WLjApUwK1qGc4fL+2vZDMIHVxqXXpNSmH7tX6KKyRSAPTN3QZ9BGKpB5tlrygOaBEz0g
 camgspudC9sKlgF4oSNxT0K4DwsQi07hzKOoXSGbiJlO7cd+kMvsghpsaWqkB0eBPm5VAM+
 ZJaTlYE4CbhE0wr/zsRRw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3u/eZlVbUL0=;uCP56s0QJjJfwtaaUKLZEhfJqY9
 2IuXXdu0f4AtavQAK6YUDDgMGHMyrDkkz7bjH9UXBRyqtbD8sWd7OZrCviCw7H3+jO4UROxe4
 fvJxXro3TyYXpyncpCAOmGFfpjekb6C9LEC7u5pbD+muRBHLbiAWDaD5caHgNFu2J8C5YWMzH
 /vnI8pwRRC3Qx3WtUbnGxaxCIS0r5jx1r41ZFqVHybYlAqjPca54Uis9PpmBywBl2gogn0uEM
 6rWRn741IwrvIlPCQ6/cNj74KPYPEuR4u1xg2Mj6jH1h+OwQuCAJQhC2Ix9qkBKNiSWLsfGUq
 cadQvcVdJDrclvvDsCVUGogWtuA9G1TeVSRlmnFMx6lcbJ1z+hm9GUgrQsmtd7uZzZkN581j8
 JHWgLl9U6nf1qZCfqwx0iYNbtbhgrTKkz6+aR/gjrw5BCB3aowGMvu7mjhxnFoXWe+Pk2meJ4
 7fXE9hBQoYT9fKKiMrRZGQebk4xBK2arI7/zUQ1ogK+Kak7NKjJyy38ieA1BSqDlIn/97Tnt9
 ZU2yxiFvmw2ffAhWaE+0iKWdXBFM+P/GTfcDZ5Qa2diAPEcgz/Tf/O/hUWfYuYEUVNaOlGETd
 2WllLp1szJcvLHDFvKaFtzlZJ4A1Ax1IptskxQUEg1GDbEVA/jiq7wmw/uL07bU+Wnf1J1TnZ
 v14UaiLUjYT/jeFa1Byxyz3MTdSqn0XU+4RyALSBNZT4Uw1vvvO8bA0+EYKqyvCC+8fzPYuYr
 vxbVFAAKunx0WGyGCDZbZQyZgzj3osNatk5QE+Cqj3CSC+trquQgepmPlhuENsNkv206UIuO0
 IR6kRVVKXomnzXqF9RCebXqY/NzR7eQFAsLFJUt771mHACA7Ll8tUa+4fbsS4yejbxtSTa0r2
 GlhHS6RGeLaDX78y7BuvM2n2o4gYEePTIUSsxSd/nhSZpISqS9z8bojO5CGufvJPHQD2B/AcV
 +g9R9f7r9q5+GQsH6OZQmtDeC5lHvTw9r48VB0f/RTOFRv0EEuQgRRRbT8RuGIrLeNmP8LSlB
 ThxXdukrdVAAv5a/3OQ1Vgf+FCkUYVNgSDmQaoxjrAgPvN8cu0pTzyMIeZnCxBqZE8+219Iu1
 2dE7WNvjLerFPRhfs7b2kQBbuzuFuqmwm8bdh7jFh/spby3LNdYEJBYkTAMdNIpa580UXKx3f
 ksvNCA0KnOZdAgjeoYxiZcz0NmhN1htkpe5MhbG9dxG9IJNCPE6itMwl32hcG46S4jGIAnLzD
 ncUdPaJnjpBIRYyGzHrYjsJ5KM0F3TqJXLGQxBxk3eYtw/jODoi4QwUKFmvyWbvGEabJl3rTe
 cSKEkJNvJvyFx0qQks19lqtvBNl5WW3a5kBR6JEdWoFiaUJzg1okOGFfuiWleez9AEcgerfA2
 U4nQAj582UGSVCoh5uQdrdDTE7GhtjCVgP5uDIjyued4xo1r30RBCEOwHoJEk51zACLM2vpnT
 Iodat3j1IuCbsqe3w61/JDYmVkkM=

=E2=80=A6
> and it will cause that socket can not be unusable after resume.
=E2=80=A6

I find such a wording confusing.
Can the change description become clearer?

Regards,
Markus

