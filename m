Return-Path: <kvm+bounces-3936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E892580AAEA
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 18:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 91DCDB20BCA
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 17:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E98E43B788;
	Fri,  8 Dec 2023 17:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Z5AcnlsG"
X-Original-To: kvm@vger.kernel.org
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A0810E3;
	Fri,  8 Dec 2023 09:39:00 -0800 (PST)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20231208173852usoutp02644f7acf23eddbc470befdef92abf0cb~e6-GoGE243046630466usoutp02t;
	Fri,  8 Dec 2023 17:38:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20231208173852usoutp02644f7acf23eddbc470befdef92abf0cb~e6-GoGE243046630466usoutp02t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1702057132;
	bh=eEIbb5/LbC2v8ZbcKnaYgSk0Bzenatz7nIxUzyOWeFk=;
	h=From:To:CC:Subject:Date:In-Reply-To:References:From;
	b=Z5AcnlsG1JjDRock5tdCbe9trJUxrR54K4lh5eg8mYf7s1H8QScZCz7ksbrYZljaf
	 01YRgHxrNw0oWW80SIyT5ZkHRkPtnm/KZE1oKAPooKj1q604jONVmVG8ofJgiQIgGt
	 s10OcirzLXeWXc+uWUs5wWIQUzTXYiIIDkva0rJI=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
	[203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20231208173852uscas1p194354bbe16bbb99fd301237a5a892011~e6-Gb-cNK1114411144uscas1p1U;
	Fri,  8 Dec 2023 17:38:52 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
	ussmges2new.samsung.com (USCPEMTA) with SMTP id 89.75.09760.BA453756; Fri, 
	8 Dec 2023 12:38:52 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
	[203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20231208173851uscas1p2a165e9fee23125b55ca6ed4de29b3bc1~e6-GOClas2597125971uscas1p2I;
	Fri,  8 Dec 2023 17:38:51 +0000 (GMT)
X-AuditID: cbfec36f-7f9ff70000002620-63-657354ab497e
Received: from SSI-EX2.ssi.samsung.com ( [105.128.3.66]) by
	ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id BB.C8.09930.BA453756; Fri, 
	8 Dec 2023 12:38:51 -0500 (EST)
Received: from SSI-EX2.ssi.samsung.com (105.128.2.227) by
	SSI-EX2.ssi.samsung.com (105.128.2.227) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2375.24; Fri, 8 Dec 2023 09:38:51 -0800
Received: from SSI-EX2.ssi.samsung.com ([105.128.2.227]) by
	SSI-EX2.ssi.samsung.com ([105.128.2.227]) with mapi id 15.01.2375.024; Fri,
	8 Dec 2023 09:38:51 -0800
From: Jim Harris <jim.harris@samsung.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Alex Williamson <alex.williamson@redhat.com>, "bhelgaas@google.com"
	<bhelgaas@google.com>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"ben@nvidia.com" <ben@nvidia.com>
Subject: Re: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Thread-Topic: Locking between vfio hot-remove and pci sysfs sriov_numvfs
Thread-Index: AQHaKV4WwNJvmQMe7UuNHg2ttxy7ZbCe+60AgAAHXQCAASslAA==
Date: Fri, 8 Dec 2023 17:38:51 +0000
Message-ID: <ZXNUqoLgKLZLDluH@bgt-140510-bm01.eng.stellus.in>
In-Reply-To: <20231207234810.GN2692119@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-ID: <38AA423198B2BC4A9757BC3DBFED8588@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA02SeUgUYRjG/WZmx3HJmt01fVMMko0waz0qmvKgC9sgMEMKyqjFnVTcXW1H
	uyizTDKP8spysz3UMk00NrQ0UdcstewiRTs1XCo7jNIuK0t3FPa/5/3e5/meHx8fhYv1Ancq
	VpPIajUKlRcpJOrufHuwuCqCY/2GMjHm+78skkmtLUJM2bEYpnu8ETHFZ/Yw9/Xt5CpSbjQn
	ybNTh0n556YeUj5inruJ2CYMUrKq2L2s1jdklzDmyR8m4ZLj/uKC344p6LsgAzlRQC+FZt1t
	IgMJKTFdgeCfpYWYXIjpNAyy/wqnTSOPq0jeVIWgK+uvIz98QdDa8wbxw0UEA6dz8ckISXvD
	WHcVNqldaCl0dHTZEjj9EYH106itQ0Kvh9T8DsSb5FA/dpTk9Rro/1Zm8xAT4aO1BTZYZzoY
	ruaN2/xOdACYcrttZYh2hR93+TKcdoNnVgPGc4ug5HwjzmtXGG94TfJ6HvT/GHLk/YvAePMr
	yesQ0P3k/TjtA5dMH3C+VwSdRVaCz84By+U+24MB3UJBe/bg1KXrYPRkJ+K1B/T0npkqjoOK
	mvQJIGpCJ0BK22b+OBBMf2qwHCTV2WHr7JB0dkg6OySdHZIRCSqRWxLHqaNZLkDD7pNxCjWX
	pImWRcWrzWjiC90bvxV/A/U++yJrRRiFWhFQuJeLs+phPCt2VioOHGS18Tu1SSqWa0UeFOHl
	5uwf3BklpqMViWwcyyaw2uktRjm5p2ANsuXlLSvf+TUFXVgcEph2xOJryaluaJr9ZrXprKHz
	8Kzjylcrnge/FOnZxs/lySH691vUW82kz8WtAdK8F8tzPMtOP5R651TXaAtn7GZMhl5JXNv2
	hkdxG/OuiJY5tAtiXZQofEXJqTrriVtltRVBEossvLyPK12S/EvmaQ5s3OFjCQ2dXymCmYIx
	tfQQdcfApM3T1FeX6MLWDo+UglEy8gKP2KdC6dfwNuvbzK6nkayTr9+A/85sziOy2crdoI87
	PK50907feK53QzI2eH301cqObuMy5QKXt0Un9uczH/SJR4akheod+VtMPcWEwZ3Qe8ee94lp
	ihoUS+rCvAguRuG/ENdyiv850XugsQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWS2cDspLs6pDjV4N95A4tv/3vYLJq3zmS0
	WNKUYXHl3x5GizlTCy3OzjvO5sDmsWBTqUdv8zs2j/f7rrJ5fN4kF8ASxWWTkpqTWZZapG+X
	wJVx+Y9FwTL2ijlTfrM3MH5j7WLk5JAQMJH4fHENWxcjF4eQwCpGiSnH9jJDOB8ZJfo27GaH
	cJYySmx/tocRpIVNQFPi15U1TCC2iICKxIkTZ8CKmAXeMEo8efuFBSQhLOAu0Tz5BCNEkYfE
	zl+NbBC2k8T9r0vAaliAmhu3TgG7g1fAVmLDpH+MENtuMEo8nPKVGSTBKWAksXDiFTCbUUBM
	4vspiM3MAuISt57MZ4J4QkBiyZ7zzBC2qMTLx/+gnlOUuP/9JTtEvY7Egt2f2CBsO4lZP/Yw
	Q9jaEssWvmaGOEJQ4uTMJywQvZISB1fcYJnAKDELybpZSEbNQjJqFpJRs5CMWsDIuopRvLS4
	ODe9otgwL7Vcrzgxt7g0L10vOT93EyMwik//Oxy5g/HorY96hxiZOBgPMUpwMCuJ8Oacz08V
	4k1JrKxKLcqPLyrNSS0+xCjNwaIkznv3gUaqkEB6YklqdmpqQWoRTJaJg1OqgYm7/3JoQIJy
	VPv6w/NOc1k2Z6f8l1DYcnCjRXX6gcdif8tW5bOpOe2pLZBwvNm/2dy/O8u8yrd5Z/tt63UR
	rQubXeYu6GLpYCk6tnrPZbE0hTMTPSoj00Rrl/A+myM0tTX1//x9T1/eDU/SsXqxVYmxTXvJ
	mgvPFBgEbKT5JWO+2xp8e651RuO+1crHh3j3/GtpUXnzmvNDle4VvYZOHf0edq+CHUsXnGoq
	rQi7oPbmI3ty+WWmfVEbL6k1HehIUzP3un9zo3S5ZfvKexqivsyM/cpTZuU28EtPbJ3fW7N4
	qXbkPP233nHGDQ32SU9F3v5YUajqdtldaP7mxU93GSl+rov+HsDV689TcKdbiaU4I9FQi7mo
	OBEA5GDjTFEDAAA=
X-CMS-MailID: 20231208173851uscas1p2a165e9fee23125b55ca6ed4de29b3bc1
CMS-TYPE: 301P
X-CMS-RootMailID: 20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9
References: <CGME20231207223824uscas1p27dd91f0af56cda282cd28046cc981fe9@uscas1p2.samsung.com>
	<ZXJI5+f8bUelVXqu@ubuntu>
	<20231207162148.2631fa58.alex.williamson@redhat.com>
	<20231207234810.GN2692119@nvidia.com>

On Thu, Dec 07, 2023 at 07:48:10PM -0400, Jason Gunthorpe wrote:
>=20
> The mechanism of waiting in remove for userspace is inherently flawed,
> it can never work fully correctly. :( I've hit this many times.
>=20
> Upon remove VFIO should immediately remove itself and leave behind a
> non-functional file descriptor. Userspace should catch up eventually
> and see it is toast.

One nice aspect of the current design is that vfio will leave the BARs
mapped until userspace releases the vfio handle. It avoids some rather
nasty hacks for handling SIGBUS errors in the fast path (i.e. writing
NVMe doorbells) where we cannot try to check for device removal on
every MMIO write. Would your proposal immediately yank the BARs, without
waiting for userspace to respond? This is mostly for my curiosity - SPDK
already has these hacks implemented, so I don't think it would be
affected by this kind of change in behavior.=

