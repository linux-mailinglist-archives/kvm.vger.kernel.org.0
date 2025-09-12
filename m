Return-Path: <kvm+bounces-57425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7BC9B5552A
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 18:56:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C66F3ADF1B
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 16:56:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E9BE322DC4;
	Fri, 12 Sep 2025 16:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="DOjZd62z"
X-Original-To: kvm@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A52322C7D;
	Fri, 12 Sep 2025 16:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757696180; cv=none; b=c6JBJ+302/twfoHJjPvktYZLqJOLfMP3QrXOfOBtRt7rPuVpiYCjg3fdyRv0k2sxTw57eOQLeLbSKP8Jg6sKZbuZeIHUZw3CCZUQEQI5eE99tvN+J3OicCHEjm4OPrvNLOdxYPLd9LsL0ah2hBgD5sOH8vsTwalhVKdRQ7NA4UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757696180; c=relaxed/simple;
	bh=p1nlGccDmza9Kem+Uvv8+XHHYiIjv7fhJLA9ZtTdJH8=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=SdrvG1m4blSYBHREARwL1pe7P7uO2IEEtyXVxcPYmk9682Uk5uDFTgRjDENmbNTh7PE/H1aXvJQnYdNSpOcvPHrZeaGWhj5s4zMPcVqSzCM3LIWsupwgy8vDFt+QGvMpdZbRZW7mIGG2vYUujHHqRRyniqSqU4dVTRhhHN+6AQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=DOjZd62z; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1757696161; x=1758300961; i=markus.elfring@web.de;
	bh=m5d0RPUr6Uh5ZPm7qUIZ96lQ3JKNwFxeNWfuB7pbQKE=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=DOjZd62zNccNFjvd+DBDRWytDKUrRtEMogMWO84W/u6t7LXzeOr6VC01ZPMu5So5
	 LgnB0tcq7ZkkvCY4GWrg1aCjsyCbapqZ+9xYKn4L57pT/gRXEGDDe5C6IXxeOy71j
	 Yu86ByVOEp4W71NVcRVymCoR4gkx+F395QbLybnXJxAhQklFbLVeMqpyfGerQjSAP
	 xNxwktz4ptEU6t1XZqoF35HhlIQDw/ln5bW1+7fQ2e+9HXr6u/jIqHYQS3UxZbMip
	 GpooBKhiA1WvmGAXSF/iOYe5udlp3lXpxOVltsS/EQSwIm9lIoCbDh24dCr2wxO6z
	 E3TRttEBufRbxkYOLg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.219]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M7ell-1v2sto2CSr-000MbD; Fri, 12
 Sep 2025 18:56:01 +0200
Message-ID: <321506e9-9721-4b42-8ba8-c5f2eb4d2140@web.de>
Date: Fri, 12 Sep 2025 18:55:58 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Zilin Guan <zilin@seu.edu.cn>, kvm@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Brett Creeley <brett.creeley@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Jianhao Xu <jianhao.xu@seu.edu.cn>, Kevin Tian <kevin.tian@intel.com>,
 Shameer Kolothum <shameerkolothum@gmail.com>,
 Yishai Hadas <yishaih@nvidia.com>
References: <20250912150418.129306-1-zilin@seu.edu.cn>
Subject: Re: [PATCH] vfio/pds: replace bitmap_free with vfree
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250912150418.129306-1-zilin@seu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:5w7Yw8nuyNwXNi77R/ovLXA7zQdrMiYfBEchFv6ogdSqG8OSwXK
 LLTcNs+YzXF32eEjWzMfuoWy4v4zJ8+GuqisE+Q2wjcxekj0hSiEs7IQpC24PbnpxYbx/zN
 d8JkvW7p0qFyGJgyNdT1PyaPuB5o8Qg7R3Bgo8oyJY1iA+Dbo1v99tI1+O9Qt0aKVvrcHJW
 neHIYYDlR372T/zNyoeGQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:E+qoG4Y4nlU=;htGdSywzqJv1IXeTjV2R3r9Pq9y
 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
 a+z4seg=

=E2=80=A6
> This patch fixes the mismatch by =E2=80=A6

* See also:
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst?h=3Dv6.17-rc5#n94

* Would it be helpful to append parentheses to function names?

* How do you think about to add any tags (like =E2=80=9CFixes=E2=80=9D and=
 =E2=80=9CCc=E2=80=9D) accordingly?


Regards,
Markus

