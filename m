Return-Path: <kvm+bounces-23311-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ECA6948902
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 07:42:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DDB5284A0B
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 05:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9B731BBBD8;
	Tue,  6 Aug 2024 05:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ULFVtddM";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="FZUdNMS6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998D64A0F;
	Tue,  6 Aug 2024 05:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722922926; cv=fail; b=OSdGp89mdIBHCDqyF2POwgVglpWhMLPbLZD3CSZamTIEMwg5jpdfWQep4j/jC8FGR668gG4GbwssxotOuDh0NXoaabJRlakQsEN+Jo5KQ2Q0aMgv0J6jL6uWaPqom9N95C/v3QMP8hNldmXqCtCy5xOCZZO55Z/vwpyhb8LG7cA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722922926; c=relaxed/simple;
	bh=Dv7iQmjs+EFKq2FCHbAQOUJ1K/FohApb1mxkhvzgw48=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GaHG2jjvgh0n0pbLlY2E0F2qTYc2GiOFzont0j9Y0fcBYH9OVoM8FKs+3suIt5ObkhWQur8O8cq0gOgnnqmXviDklMcuVJX0odfB3W8DMi/5m+d1KIFK5WK2ftXMUV2v7wST+F0hkj5l1wcAE82l/b2E3g8FcwFl8z9y0BXDRZo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ULFVtddM; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=FZUdNMS6; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 475MU4DR014313;
	Mon, 5 Aug 2024 22:41:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=eDI9Ia9qi9jAFhzHzfH38ekmpBBnDR7Q+oNA1Y3ZM
	kA=; b=ULFVtddMKhKVJcaLj1Hod7NBsPqxf8gV2scwYSIVfX0WN6yJHdSHmVrzn
	lbUQVUl4Xvumkh+Lq4O13h4+br0HUoNBMWnOAyFldi4lCeT34a2XOfyU6NZ9vWr8
	X87JSOGuxk7jEH+eXhAKPpEiEcI2L9WK+LiJX5ICuEyTvc8fJtTxLXMOLvMQFrax
	rEaOuXY6L9uTLfiXOdBfANWCyfwniiscgA9cEgt5aQDH4cCAjP/qV5vWFsXmZbXg
	YIY44zaCYisRd7cZxsQ9Y1/bws+g7ch0uLzbNt2o4lJFPaoOSai6qhnTkwKK3vzf
	phnfCrC9srxXG8fnuVLHrevAwE4Sg==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazlp17010006.outbound.protection.outlook.com [40.93.1.6])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 40skmdcwsj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Aug 2024 22:41:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rGx6yaoEehrUWNaPBZ9g0KKBM1Dk4zqi7sZdVGdxG+clpmxfmJ8sEK0+kkReh7lCWv9pNzzkY7cl83D1voahqSlQm7BgcsmrV5aprnTygcuaBOsuO03pn49YMXp0GLRYRf8+8G5wvfehH2j9aQvk+wi7akLrJEtRBIIKei202EZtlss9Yu1YkD2GWrA6K2CQ4D6I5dRPv1JMr5mXrzeqCnZY5YYxG69PAV4hJfgf/Tu9OyYH5ZoR528scqCWe2NfIjw94SufgfsGBp1fuspeaNmldfp3uvgJIAiSko8Vv5PizuygvJatO5A8MFYFeDJcfzsjGphOOQsq+nEJF4SGBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDI9Ia9qi9jAFhzHzfH38ekmpBBnDR7Q+oNA1Y3ZMkA=;
 b=UgKKxeV91nVBGPdvlHWaVwRQnqyYmRA7clAEyM6u3uuL0lGMBM3Wopo3FuSUuu8MQ5ApJ+WILaOjhxU1yPIPiZrmeN1vI7HG0sdm99rgaT6DvqdURtJhzREGgKxNiT94+bsussKPFAfy2g9u9mzFY6kb/18Tm1JwEBfYQilyQiM1vYUZsC1r4JucEnRmtJImNIMoR8tYccSrIPyqDZ8N8wBAKMCPtXF9wWC5E9YQ6ZWngOL/iQQ1vux+mQmTqbjHXDZuZe1J3BrzGmobadoga0cV7U7OxDtfyh/rhaU3xjpJ3syafXO3B8eP+5JeHz9Q2DLtFWTbpULO2mahf/G7ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eDI9Ia9qi9jAFhzHzfH38ekmpBBnDR7Q+oNA1Y3ZMkA=;
 b=FZUdNMS6gOQqNTMLw3cFjGLkrVjaiSbm5GlgrVVF41FOXAzI3moLJOuCVXZx2CDDzWmhjptdVwQr+l+I7wVAwvBJy5EAj9TFzubTBi1D23j6t0Q68iMNC+uI/XQtnmAi3+Gh6vNI3pyhZiLeFpayeEzhBhbR2VsKVcaDZa2Pcd4flmmsjYqR/9Kzawwpeb5U7vmpOC8yviLGJtL7ZAwIlKKBV9BWlEIpCx3nZZ4lw9I3AejjVI1haSxV46oV/eAnw79clN3qcWyRPgj+N1Uxw5lSGOSuU2fAC6TwvTgAQp6hbYrChHMFiOtTCdcwWwEyEdPKsxa0FGzlnf51KKALYw==
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by SJ2PR02MB10316.namprd02.prod.outlook.com (2603:10b6:a03:56c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21; Tue, 6 Aug
 2024 05:41:35 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::b78d:8753:23a8:cc78]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::b78d:8753:23a8:cc78%4]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 05:41:35 +0000
From: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To: "chao.gao@intel.com" <chao.gao@intel.com>,
        "seanjc@google.com"
	<seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Vitaly Kuznetsov
	<vkuznets@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jon Kohler <jon@nutanix.com>
Subject: Re: [RFC PATCH] KVM: x86: hyper-v: Inhibit APICv with VP Assist on
 SPR/EMR
Thread-Topic: [RFC PATCH] KVM: x86: hyper-v: Inhibit APICv with VP Assist on
 SPR/EMR
Thread-Index: AQHa58K9o5DlcBq5LE2KclYd6qm517IZtwYA
Date: Tue, 6 Aug 2024 05:41:35 +0000
Message-ID: <57F9FA8F-0B80-497E-932E-45510FF41559@nutanix.com>
References: <20240806053701.138337-1-eiichi.tsukata@nutanix.com>
In-Reply-To: <20240806053701.138337-1-eiichi.tsukata@nutanix.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR02MB8041:EE_|SJ2PR02MB10316:EE_
x-ms-office365-filtering-correlation-id: 6de2cba7-682f-4ccc-8492-08dcb5da6f2a
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018|921020;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?j7EasmKttX3L1LSj22H2ALM9dniKA3Ska2Htu2PCTkXOvtWSUY90y5uG0SyM?=
 =?us-ascii?Q?mVhh+yLdjHk8sRclIyfNz8eWEzIEeyDi+R+oQJPwK8rExYCB4Q4d0eWTAr7g?=
 =?us-ascii?Q?uR5T8OmlCWp/Y1Sh2LMn3hX5OF34rY56mhiqHV7wGV5cAUWd5gQHx9ps9Fas?=
 =?us-ascii?Q?OFndGhhcn8UPM9sR21KwFqkFVzv5NUBX6tz8i+scSBa1RpaOQw3aohQRul7q?=
 =?us-ascii?Q?25G88YOMoJKOT1H/M2+5nrQoB+hGmTtlZcjJdy1O0QKhhuD2/JFno+vrKOlV?=
 =?us-ascii?Q?HrB8mvVTv4bwMYVYgX/v3h+e46Yk24gK9EIAw14OHHtgBWX55SnF0Y0Qa4S1?=
 =?us-ascii?Q?SRt5wpoGwB1/Ol0FGCeKLKijMfWQ9eNNcjQL9/wWECKIs3ITnNgZq0uTafzc?=
 =?us-ascii?Q?tjXYM5uaASZuPQI3vtZ5BJY6nOzD13lyAMwUhkxUbuT5ANM/fnBNXyK6jpPw?=
 =?us-ascii?Q?VnJSPX0NNK/6dvFv05HlJ2D2Cti3EkhX3bZjtFq00a7FdFH6+l6tUUB3fcls?=
 =?us-ascii?Q?sZVG12VBAAxw6wO7WfqWgRPVrg7kESEGlVwAUFsZq7IbiVj7OSmxy2pdgX7P?=
 =?us-ascii?Q?U0kXnLzsJZqVk1VweLNrY317JTNjb0Epvu4A/c6VhGfgEJdkPvbOVQaDdL4C?=
 =?us-ascii?Q?I4FiV09cAH7+iJ+rfOfR5h2LZ/VtZYYmR+0NB3wIzzyBi5zBjAoN8CZVdFpW?=
 =?us-ascii?Q?1a9azPlZLHyuZ4DoKeGiNpMFUEnz2AivLE0EvPH8G2dFyXg9O26QqeoPt5hN?=
 =?us-ascii?Q?AXuMpgYbcNOWctiOPBhQyrZFHq+0M/VowWLegtOK7Tqtk89B5yuvaLNwmOhM?=
 =?us-ascii?Q?uiblx8+zG5UmUyRDAXbeSGnYqgTJZu89ZkCFu/2nJf2N2hShbYJ6RIKbtDBS?=
 =?us-ascii?Q?/XBfe7Ae3tXHVnyBT9C5N/v1sUi6gLu5KcEQmvK9Z83fHkKg+/uTChbNd4Q8?=
 =?us-ascii?Q?52fOulKn15Bdj3u3mOykMkTgBRX7njI7J3nyjTfuuXKr+MpHz040IgyLIxc4?=
 =?us-ascii?Q?S1zF2jn60d9ONeRPvt5IFpZt6FjHTZXpmwquaEgtC3bEuash/hkUv1OPDQOc?=
 =?us-ascii?Q?+xlCcuGZCp0aBaRmrI3qRpWxO69bpH2FhOwJnZuIKiXokEByYoIhey2rRGRj?=
 =?us-ascii?Q?PK/qGPuPyV8pUBp7y+COFuThsOOxuad0QZ8OjKa6tRTPJcbv24Ge7NgpPP+m?=
 =?us-ascii?Q?9yHV8HHUrBayJvTjLzjO7g63L+BhRyniYWTl/jOfIwnuwh8Dc1WAJvfBFvAD?=
 =?us-ascii?Q?WNjytF1XO9DTSRhx+n1p6Q875zpsip/NHVDJWoBFFkJcJcU6oXPBZC3uGP4r?=
 =?us-ascii?Q?Qso4L1gB6dapGcTx8LJpKbQrtlw5fMWkNGMTs5YWY9KCGxMeZLVZkAalRq1f?=
 =?us-ascii?Q?RdAGMvbM61fVQkfFk6pRq54+jUrH?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018)(921020);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?1KVThEicMKlcINrzn5bza7wDogunp7TRDTbX71D1S1z7/0+Ui4h8avTgiwDK?=
 =?us-ascii?Q?vU5cWDroQtveKQ3WTHKI38lV7PFSD1zV7s96dSZmaxyJcz6zT1br/vWfSIXp?=
 =?us-ascii?Q?fYpxJBW40JtLiP1EON7bGAQ6sxsQ/5L3mKjo+M5HR2l0Qbp6X3Esc8J8DER5?=
 =?us-ascii?Q?Rp1caljkr2rDOmaGqjstnXuVc0ls5IWI8e9pGZe6LY1uyFtbg29Y09f4f5Jv?=
 =?us-ascii?Q?YS5nL5SDnXmETascxB33OJoRU41BcHle8NPHyoaQ9G2uvFk1BiusCSgTQcoP?=
 =?us-ascii?Q?zvMHcjBoHwqOJ1EGzkO1ivPJaxLzSjCrjZ0ONyZKCSYVtUFNChIDBlathaDt?=
 =?us-ascii?Q?x8eQCd8V2IN9/Jl6nzpirDRvnME1I7LLQDM6dWRq2Wr+HqW09c5ZL5GqyfMj?=
 =?us-ascii?Q?Zj2eLWQoq8EBWnF/QMGaPXdQJNWgtFAREV/WQRFeiP86aMZ52UPkYRaFjH/t?=
 =?us-ascii?Q?rNi8yIgQL8ONcefByCruZTiBMODkDzsQfKJ7W0lYKF2MtrcaR6krvOH49qYR?=
 =?us-ascii?Q?o8A/EvR7icWtraYmYumwhbpB37WETxJoqs/tzHHhU/c16KSiq+w/ifchTWA2?=
 =?us-ascii?Q?PGY0Emq1c7tVFzlZEImdP6r/VQwZKaAtckNHd4ig8iLKYM3apPUFATLmu6cJ?=
 =?us-ascii?Q?JYxIIhVWDswja0pOl6+D8IXjfiamNqPuSPybkPdrEn3gnjLn/FKcuX+/WNPN?=
 =?us-ascii?Q?+8ia5rf1nhml4eWNwRMITHCDHFqwSeNPr1WNVCQ5QaF7cBj0KwnrdwSDOr+m?=
 =?us-ascii?Q?Kyh3Skw52dFrrOLXn2KtJP3LAzQTqyRjQPOYunK2+oyu8ZT53rawijwrfRU6?=
 =?us-ascii?Q?CLJUuMZl8ofmYEMcU4HD6LPo2cItKwFJYhpWFs3qlYTCuKP0pKsD0hXa+dAl?=
 =?us-ascii?Q?Bkyj1aKe9Lb+887hY56Gkg5WdqgrbBV1uYeOr3/Bz1OtOdd1Ge38DRf2cAoy?=
 =?us-ascii?Q?ePz/GGwOeudxFZZZLTzk1HjVBsYzfO+i+KneVrMMGQ4vaXqCY4VWL5jhjYzs?=
 =?us-ascii?Q?q0tRn+5AALGYENz6OGivH6oxca9xr0kvICLOqW+dwuDPlulWDJAYjsg/oXC+?=
 =?us-ascii?Q?b25OXMNlgv8vyOEJXXAvMV614ZRKp0pG02p78knk4D96cc3yhg5vbmkTHtOv?=
 =?us-ascii?Q?lKW5nX2o6i5zP+JO37JgMEZTNuLsym/IPSJ8sICPyuNe8v21HJeafjSbAZpT?=
 =?us-ascii?Q?W68s1iGOXTTRysuVWrHxE/w276ZiVxssRj3YoB55TFS76wVA7BJwSvYZx0CV?=
 =?us-ascii?Q?8UIHz52uu+LlBlldgQyBh6xnAybjmtjtKw4HEWgpyip4Ct8KjR8+cF0j2VLW?=
 =?us-ascii?Q?ldzHZmngaIaBgWwK6pbBlR48VUf7EnPytk0ynLYI9AjqXsZA6wHixtF2r1Np?=
 =?us-ascii?Q?zpumd2CWlkT+lbs7SksdQS8juc2anQPl2VHAPwhdNJKfBcFlEDmAENDIC6Fr?=
 =?us-ascii?Q?zlCYxybZhHsjoiJIbdQJQYJARbkqj+A3NnLzC+ydfyJm5dEwBTlraqDMl9go?=
 =?us-ascii?Q?+wqOm8VxoH6LiWFroIYtC52t/c85mck4SIDPLUCz35UNVpPA/Zs4gFB+X3xa?=
 =?us-ascii?Q?OiPxHeHDIwHUVdNDGN/bmxYDwIvfFIwGqrPWLcYu1uiTsjXOCaqFT+pu8yM/?=
 =?us-ascii?Q?bw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E19F4FAB093DA4F80FC4ED426F6F352@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6de2cba7-682f-4ccc-8492-08dcb5da6f2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2024 05:41:35.1975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: atT/vvKhqkBC3MCS3AltZxfUM5rXb1eX1fk3KkB6oF0y7wEJa8pdoLqkAZF1iMaFCoP31qSwJIRp+vohM3wz40eQoZLImD5xsidLa+0uaU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB10316
X-Proofpoint-GUID: V8hKTBC-w-kZZT3Xaw0YX5nFTWrcoHjo
X-Proofpoint-ORIG-GUID: V8hKTBC-w-kZZT3Xaw0YX5nFTWrcoHjo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_04,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Reason: safe

Hi

This issue has been observed on SPR and EMR but may be reproducible on othe=
r
CPU models.  Appreciate if anyone know further detailed information about t=
he  issue.

Minimized repro is: =20
```
for i in `seq 1 20`  do
 /usr/libexec/qemu-kvm -accel kvm \
  -cpu kvm64,hv-vapic=3Don \
  -hda /path/to/win7-$i.qcow2 -m 4G \
  -smp 1 \    -vnc 127.0.0.1:$i > qemu.$i.log 2>&1 &
done
```

I'd like to note that this issue is observed only when the node runs
*multiple* Windows VMs at once.  i.e.: Running only one Windows VM doesn't
cause the issue.

Moreover, running VMs on a dedicated CPU doesn't cause the issue.
I mean, prepending "taskset" to qemu-kvm like this:

```
for i in `seq 1 20`  do
 taskset $i /usr/libexec/qemu-kvm -accel kvm \
  -cpu kvm64,hv-vapic=3Don \
  -hda /path/to/win7-$i.qcow2 -m 4G \
  -smp 1 \    -vnc 127.0.0.1:$i > qemu.$i.log 2>&1 &
done
```

Then the issue doesn't reproduce.

Best,
Eiichi

> On Aug 6, 2024, at 14:37, Eiichi Tsukata <eiichi.tsukata@nutanix.com> wro=
te:
>=20
> Running multiple Windows VMs with VP Assis and APICv causes KVM internal
> error on Spapphire Rpaids and Emerald Rapids as is reported in [1].
> Here Qemu outputs:
>=20
>  KVM internal error. Suberror: 3
>  extra data[0]: 0x000000008000002f
>  extra data[1]: 0x0000000000000020
>  extra data[2]: 0x0000000000000582
>  extra data[3]: 0x0000000000000006
>  RAX=3D0000000000000000 RBX=3D0000000000000000 RCX=3D0000000040000070
>  RDX=3D0000000000000000
>  RSI=3Dfffffa8001e3db60 RDI=3Dfffffa8002bc8aa0 RBP=3Dfffff88005a91670
>  RSP=3Dfffff88005a915c8
>  R8 =3D0000000000000009 R9 =3D000000000000000b R10=3Dfffff8000264b000
>  R11=3Dfffff88005a91750
>  R12=3Dfffff88002e40180 R13=3Dfffffa8001e3dc68 R14=3Dfffffa8001e3dc68
>  R15=3D0000000000000002
>  RIP=3Dfffff8000271722c RFL=3D00000046 [---Z-P-] CPL=3D0 II=3D0 A20=3D1 S=
MM=3D0 HLT=3D0
>  ES =3D002b 0000000000000000 ffffffff 00c0f300 DPL=3D3 DS   [-WA]
>  CS =3D0010 0000000000000000 00000000 00209b00 DPL=3D0 CS64 [-RA]
>  SS =3D0018 0000000000000000 ffffffff 00c09300 DPL=3D0 DS   [-WA]
>  DS =3D002b 0000000000000000 ffffffff 00c0f300 DPL=3D3 DS   [-WA]
>  FS =3D0053 00000000fff9a000 00007c00 0040f300 DPL=3D3 DS   [-WA]
>  GS =3D002b fffff88002e40000 ffffffff 00c0f300 DPL=3D3 DS   [-WA]
>  LDT=3D0000 0000000000000000 ffffffff 00c00000
>  TR =3D0040 fffff88002e44ec0 00000067 00008b00 DPL=3D0 TSS64-busy
>  GDT=3D     fffff88002e4b4c0 0000007f
>  IDT=3D     fffff88002e4b540 00000fff
>  CR0=3D80050031 CR2=3D00000000002e408e CR3=3D000000001c6f5000 CR4=3D00040=
6f8
>  DR0=3D0000000000000000 DR1=3D0000000000000000 DR2=3D0000000000000000
>  DR3=3D0000000000000000
>  DR6=3D00000000fffe07f0 DR7=3D0000000000000400
>  EFER=3D0000000000000d01
>  Code=3D25 a8 4b 00 00 b9 70 00 00 40 0f ba 32 00 72 06 33 c0 8b d0 <0f> =
30
>  5a 58 59 c3 90 90 90 90 90 90 90 90 90 90 90 90 90 90 cc cc cc cc cc cc
>  66 66 0f 1f
>=20
> As is noted in [1], this issue is considered to be a microcode issue
> specific to SPR/EMR.
>=20
> Disable APICv when guest tries to enable VP Assist page only when it's
> running on those problematic CPU models.
>=20
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D218267 [1]
> Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
> ---
> arch/x86/include/asm/kvm_host.h |  8 ++++++++
> arch/x86/kvm/hyperv.c           | 13 +++++++++++++
> arch/x86/kvm/vmx/main.c         |  1 +
> 3 files changed, 22 insertions(+)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 950a03e0181e..9ff687c7326b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1213,6 +1213,13 @@ enum kvm_apicv_inhibit {
> */
> APICV_INHIBIT_REASON_HYPERV,
>=20
> + /*
> + * Using VP Assist and APICv simultaneously on Sapphire Rapids
> + * or Emerald Rapids causes KVM internal error, which is
> + * considered to be a microcode issue.
> + */
> + APICV_INHIBIT_REASON_HYPERV_VP_ASSIST,
> +
> /*
> * APIC acceleration is inhibited because the userspace didn't yet
> * enable the kernel/split irqchip.
> @@ -1285,6 +1292,7 @@ enum kvm_apicv_inhibit {
> #define APICV_INHIBIT_REASONS \
> __APICV_INHIBIT_REASON(DISABLED), \
> __APICV_INHIBIT_REASON(HYPERV), \
> + __APICV_INHIBIT_REASON(HYPERV_VP_ASSIST), \
> __APICV_INHIBIT_REASON(ABSENT), \
> __APICV_INHIBIT_REASON(BLOCKIRQ), \
> __APICV_INHIBIT_REASON(PHYSICAL_ID_ALIASED), \
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 4f0a94346d00..8d5a1f685191 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -36,6 +36,7 @@
>=20
> #include <asm/apicdef.h>
> #include <asm/mshyperv.h>
> +#include <asm/cpu_device_id.h>
> #include <trace/events/kvm.h>
>=20
> #include "trace.h"
> @@ -1550,6 +1551,8 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u3=
2 msr, u64 data, bool host)
> case HV_X64_MSR_VP_ASSIST_PAGE: {
> u64 gfn;
> unsigned long addr;
> + struct kvm *kvm =3D vcpu->kvm;
> + struct cpuinfo_x86 *c =3D &boot_cpu_data;
>=20
> if (!(data & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE)) {
> hv_vcpu->hv_vapic =3D data;
> @@ -1571,6 +1574,16 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u=
32 msr, u64 data, bool host)
> return 1;
> hv_vcpu->hv_vapic =3D data;
> kvm_vcpu_mark_page_dirty(vcpu, gfn);
> +
> + /*
> + * Using VP Assist and APICv simultaneously on Sapphire Rapids
> + * or Emerald Rapids causes KVM internal error, which is
> + * considered to be a microcode issue.
> + */
> + if (c->x86_vfm =3D=3D INTEL_SAPPHIRERAPIDS_X ||
> +    c->x86_vfm =3D=3D INTEL_EMERALDRAPIDS_X)
> + kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_HYPERV_VP_ASSIST);
> +
> if (kvm_lapic_set_pv_eoi(vcpu,
>    gfn_to_gpa(gfn) | KVM_MSR_ENABLED,
>    sizeof(struct hv_vp_assist_page)))
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 0bf35ebe8a1b..a1e7007133a1 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -11,6 +11,7 @@
> (BIT(APICV_INHIBIT_REASON_DISABLED) | \
> BIT(APICV_INHIBIT_REASON_ABSENT) | \
> BIT(APICV_INHIBIT_REASON_HYPERV) | \
> + BIT(APICV_INHIBIT_REASON_HYPERV_VP_ASSIST) | \
> BIT(APICV_INHIBIT_REASON_BLOCKIRQ) | \
> BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) | \
> BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) | \
> --=20
> 2.45.2
>=20


