Return-Path: <kvm+bounces-6848-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6470983AF22
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 18:05:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C7A928581D
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 17:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C0F21E86A;
	Wed, 24 Jan 2024 17:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="lUzNe8Zi"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF57B7E777;
	Wed, 24 Jan 2024 17:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706115897; cv=none; b=gqV19nY2Ums5KZ7qY6fX+0rVd3dKpvYvtZDswwMuDAgYzWoSmLiTB4zKUF4maPng4UlKgbw9Gywr3b1JU5SRF7E5vseYvrDqq/16DQHck/yuTFQJAs5CgP0k+e4uAbodkj863ShZn9gJLGtnOedY+0FSatLDEDvLoPNbBr/yokg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706115897; c=relaxed/simple;
	bh=eZik0NQgHnxRTjoOGVz1jiYozSbIVj3TpK7roxu/iQA=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=a6XIrilOIWNpl23bt/VGhkiNDcv/5ZbkJAa6Hxoo6WawTfdVjyL+nKo+c8qCU0pu3cHZhhdFSMIMLldK9Kf0l2a26m/KCzyVE2ATg+DbK1KUqddR9OMpn+Bt/amHhN0IOb78vG2KwjhpqY4Jatpd4SsEgwX+9snzhdNr03YJ9OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=lUzNe8Zi; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1706115865; x=1706720665; i=markus.elfring@web.de;
	bh=eZik0NQgHnxRTjoOGVz1jiYozSbIVj3TpK7roxu/iQA=;
	h=X-UI-Sender-Class:Date:To:Cc:References:Subject:From:
	 In-Reply-To;
	b=lUzNe8ZiAq2MtvUEprmZ7EUvfWha/ciK83fW1jtjO1KG97cq8HD7DEUVcrJ6UMY5
	 Qs4Hwls5hj8t2jZzEw5N0WFMfg/6nUVICxOecQB7277thIoQ9UVHKnvD7SzBynOI7
	 pCp/xfGzh9HsvjxlEvR212xtgwuwNHWwthS5fYHP+Fll0DobrSso+oc3S9k2bvc0z
	 hGROvaEH6gI52kZci6kko+X8kJPZrqsQMAYtGN1xyAToYeyeKiZyN6R89dlfGaLDq
	 3qa/7zQ2CO5cAmpZ/qaicC7/SGIlZTrW4cNlIvsPqhLj3flC+cUuvalspifrIBYwh
	 VdnF1Qjam4AZ3d7NLw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.81.95]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MrwwJ-1qhJAi0Kl3-00nxrY; Wed, 24
 Jan 2024 18:04:25 +0100
Message-ID: <791da036-5c0d-4c96-b252-24726bc7f2f7@web.de>
Date: Wed, 24 Jan 2024 18:04:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Kunwu Chan <chentao@kylinos.cn>, kvm@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kernel-janitors@vger.kernel.org,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20240124093647.479176-1-chentao@kylinos.cn>
Subject: Re: [PATCH] KVM: PPC: code cleanup for kvmppc_book3s_irqprio_deliver
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20240124093647.479176-1-chentao@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:G0go2dhXVu0Sv5YnVpAY+1uRg0zK0HLp5MnOCn5FVZtO4VRVTPf
 k9q/daeBYgsA02NjvmzAn4KOMTlyCurrP5801Mdn4mKysomJU90WRw7ePlw6upIqpTkv7NZ
 hx/J7+hpeY2aNw8FtxcAp9ZkhAB5CRqbr5+4a8zmkttepfuC0gyOPkIB8mqwSrMnlOyi3gS
 ZF2+m+O5P1khKJKI0Qlvg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:1oU2Xjxbha8=;At8CAKPHdhpSpJ4OpBdIp3LKFLr
 vOfrhGBmQDuZg4cInC8Ro6jNNr4L6V730p0jo2gsRI1198t3VOaCBw7A3/PHuI7c+R7fOGhbU
 1ar5VdgTdbK8i7XYXxAl5+Xh40qMGejjJFlbLMIWWSvV8q9MdQDbaIl/1OCrAyYF3WZ7raAmT
 HTLSwwQ5HCG5oHdbcJmJxUxPvyjiGvprh0qpsu8pGzXUHpZunBZyo1oIDpJGpIXMC7h91snfu
 FIHXwHnrsNcILE8MV2e7drcq6hemITAFrMuHn4mBMTsbnwCH3p1wEIMBw6C9c4cIjE1xlrsNQ
 vU8l9J/G0G+p21hquVCSI17cKB3HJESWAA/2BGWVEhkgPCnQp+l83rvWBX3n2ZVBQzSehIEvR
 IOaaNPIGX4dfLTcbsdMHkcFI6CilYiKUwO0HJVutXHKrIT3ZShB6iu6FFQHdgPWGh2cLNnJP5
 nTW4+At2h4n/dUdG7iOTVeJbH7F5P4ZOAdYPbQBJkUfYvgJJuIJXKm5TBvbWN9ESXjaoBHM33
 LXNCxZ54wO+26YV7ju5g4pADhA43EgL+irNEdeg7KUiGmkzG2VDuA0/VkLt1FTdkL/shD0NdW
 CqxzWj4siqs/N07Xet8xHSUpcafqGAwRn7K5irlsLYtTd24BFquP1+lyIhHyHo4tPqHPKV4Bo
 /BTlN4lG7oCQDET9qdcgCOieffkWSqHCu/+gBGX5zcIrIcf4WsJfI2J84Mc/Es+vT0MZEm3Qp
 PebXQtt2Oh4GuwXRoZJGw9RAm80CyY2PqcXhbUbGJp7GXGgQNonDF+e3Y5UDVpOweJsskRiN7
 jv7vTAOcKlT9HtMFpQCcxJskmy/kBO2CQj7OwmFflVIJ4COI6nv+Z3QEGWPdt01Y8pJwXtP+k
 yxnEgDix+ycFKqxEgW00L7TXQIB7tjZVDCTJ4gHNNvIL5TdCkA+TwPr3HNtML7UR+e0QbTGSe
 2TJaAQhtU+C2QwwlhvUcOjK4qOU=

> If there are no plans to enable this part code in the future,

Will the word combination =E2=80=9Ccode part=E2=80=9D become preferred for
a subsequent change description?


> we can remove this dead code.

And omit another blank line accordingly?

Regards,
Markus

