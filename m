Return-Path: <kvm+bounces-26020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4992096FA3A
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 19:57:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6111C1C24151
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 17:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095E71D45ED;
	Fri,  6 Sep 2024 17:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="orSE0ume";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="kqvCpUUm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4DD1C86FB;
	Fri,  6 Sep 2024 17:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725645452; cv=fail; b=JMXu9n8wls94p3hNYvM0qRpXegqSPAsNEVVyZCAB6i9H5rNzPnGGI/6d7GL6Yf/lWp0QF5bWk0GZl3BwizmfBrCe4ipZd8OLvBbCEtAuu2Ajb50RX5hlVSyfFkg0WOGoP8P3PuXnpRYfOXGQbf96qv7+tIC8TONhX0RGc3bSn/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725645452; c=relaxed/simple;
	bh=gXEGD9HheNg5u+JosjwXftoDDNJlQlLtKcvziKs4KSc=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=NxAZb8jIGXmz9WNWZo7Ic19EU/6mgdIJLqoYDZBCWH9msrr7cvYvifMgRMDe14CG+0tQHtB0dc1FFxoWDlgz1Du/sSzjLSzy4yx0P87cZj22Q3vNoAjgSg08g1AHZbdErS47+5LQ3mKs1ovcElmSu/0RUY9YzZNJUFvHdxaFjw8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=orSE0ume; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=kqvCpUUm; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 486GpWjw031374;
	Fri, 6 Sep 2024 10:57:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=proofpoint20171006; bh=gX
	EGD9HheNg5u+JosjwXftoDDNJlQlLtKcvziKs4KSc=; b=orSE0umeTRd28eXewt
	MM8cwHcTwbUTRsuX6k0hZf+6OzpNVAKYRimoO0rVdqo88GmY3P9Pq081uIdW+aFW
	0Hxoma8feQpOho0t9kNn9tf+wBY0VDf7YBoNRAvGK6BjgD0bBUtL+F2EqMZ3+Mjd
	/NuuyKT7zfAVLwO+OwbdsskycKkzd6kDtipMJbzshpBjPUyi+EBn4zXO2C44mZMg
	WCoPfjgxdiRXqc2A02nlD7lz15mclYsvQ53yEA21GyGUy2yo2ejBWF5FiqKnXblk
	SEYWtkd2E9Gbll6r+ASrqEO/FVT7669AHeGoxSxaqkoDN9AUw5aoI1um3rV0j7BL
	DPwg==
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 41fhygah9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Sep 2024 10:57:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M66VsMrFxYE7h9nb0V8yUaUCHjAtOa2uqw7KJwW6Qbwgjn7a031i/KFyxnC0ArnNlyTVHFsO/5F7kiv9dR8CLTcxUW5cN7PbH+c3vl6tx9zKkxDJNLFQ57Ow1rZbPAhFQCNh5RNbRqQHZETSoseS1rPFtxL04QaitSzJHMNtrlKVRc/me0AEWbXJ8urCAH1KqCSBawUqlzuo8xMVDBRjW/Ix5dEAjugWAvYSrZif8Y/8SlaU+MecX3DOlHLVOJR2zfCNBDnR1fn69OGuL+yuX8unyoc0prsdd/U6rs3EVyFPpMB/ZVGdBu4HdJgh3bapI6xeBu/ntUuSJygjg3uKxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gXEGD9HheNg5u+JosjwXftoDDNJlQlLtKcvziKs4KSc=;
 b=O7nl7uesJC9XJtvX7FkTK3Ln7Wnc/M19Cd6fLNhy19J5R6FUv+0zOI8+RFbsAUvwiLK2eBE+0ghP0LnZPfRfd/GJoYYFkgTaa7bUi5bpYacobLFLziQF2Qm5Gj/QbqJhmur5tSIw1n18KTuv7uWfeVmljMWxzzuTFLAOGZCWhSUNNrRm6Nm5CgtCQOtq8o2rYulMRVM7U/iajGauGqni+As5iC9B39XMrDpPjHhZ0zsHjArpjHRDBHe3Pbyke7mfjj42LaXtwQnhsTCwZ5vITz0TMd1Nb4lKoLuqE7Fy95SHmXDha0y/yuH2LxgHGhydmfLeeO8TFLTnGdbUt8B8aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gXEGD9HheNg5u+JosjwXftoDDNJlQlLtKcvziKs4KSc=;
 b=kqvCpUUmeRzgQ462PqLo/SwS8ttGBPfW/PG268nqtQNpiBZKvVUjagCXpjoyVgPqNFmPlnoo9Df9HLsc0QcsDTWHsB24v8v4nQ9Rbm14zmbR4buMxEqqJhoBxgdAHclIOTwZFEjb9xUONfD8v1g1I3sN4hw6YfWn8oZ2SN1bpPGxYH/JyMyEySODiKNFhc5oc7PQzkxlKrHBgCWZtMyeFXefp1q10drCw62NVYzHNiPpS0HlQewUpfnXqOCrbe7bLb0lusTTHjns+4nnowL6EzxYb3R/qPElR5hN143P5auBsqhgqBPNJbj308ZOhkZyk4VZCFBsiBaHpqraU8VvXw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ2PR02MB10313.namprd02.prod.outlook.com
 (2603:10b6:a03:56a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Fri, 6 Sep
 2024 17:57:18 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.7918.020; Fri, 6 Sep 2024
 17:57:17 +0000
From: Jon Kohler <jon@nutanix.com>
To: "kvm @ vger . kernel . org" <kvm@vger.kernel.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Fenghua Yu
	<fenghua.yu@intel.com>,
        "kyung.min.park@intel.com"
	<kyung.min.park@intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: KVM: x86: __wait_lapic_expire silently using TPAUSE C0.2
Thread-Topic: KVM: x86: __wait_lapic_expire silently using TPAUSE C0.2
Thread-Index: AQHbAIY2g0QiFTB5pkCH5OGhEgcyaA==
Date: Fri, 6 Sep 2024 17:57:17 +0000
Message-ID: <DA40912C-CACC-4273-95B8-60AC67DFE317@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|SJ2PR02MB10313:EE_
x-ms-office365-filtering-correlation-id: b8965b0a-8003-4d8d-a983-08dcce9d5913
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?MBSGqv2VQ1JbFO+KGaLUHG+JyESs2dwys03OKNCN6d+YiY+c3Fb6y3jM18H3?=
 =?us-ascii?Q?GkNmzhb2rs4ichnL+tWxt8OaZ6QZbFFGXC99BuJFPsWJVHKMmvI6wXwVmDBN?=
 =?us-ascii?Q?8JrQ51VzPCsjgd38ClKfAKDH3R3JNxkhxi86i0V5/q/2YYiM1GXMVSVy5wit?=
 =?us-ascii?Q?d0dIGlpTNRXJSjvcvwqakOr6idKTFWdtpGZb8qPXK65jYU1+1YKQ7VpbEn2I?=
 =?us-ascii?Q?VUrQFm5/8dfEhLFrHwy44CLmeCGr4yEZe/zZSF4o6pnAzCGG2hQHtV5vCVb0?=
 =?us-ascii?Q?Lc86iXvPXzGiy/fkr8+aqjIpKpGPFIQTa1PFn7HdFfNybtCYGE78+4TQqRRS?=
 =?us-ascii?Q?X3nZdbi+VABkHtmgToPW9FZ/4Q2OSU4zavvf6Uf+xFaLttrEBaxxUkOAMi8G?=
 =?us-ascii?Q?7DCMpioEyHq+vujbWZJctgMYIVsPHsTCO5OEQJuYh8sjMyZFfnCwxCNGPQfp?=
 =?us-ascii?Q?y3L826Ttkfpfwe6Ah74z32aTd4JclXVK8B/O1t1R4b+eIGvLAxHwgJPDhJur?=
 =?us-ascii?Q?Skrxg+/4noPuNwqiLMEw02+Zt7IcwouXBIp61Uw9cViPCSxn6vGLBgUFRRMh?=
 =?us-ascii?Q?xvWeBnGpDClweJyWXhRjVL6W/MgHmBzNSkNXLMdjzH4N5oBsZHrgCSejQZPK?=
 =?us-ascii?Q?WyEBBqL8mHPmMZ/t/8+Be2Gd7aS0dYDK56/3uZHE0C5g4oGYXdBk9l/ai8Tl?=
 =?us-ascii?Q?aL842wXZxmr20eYo+6lvqZ9h/WSEgUZb6VYSFMmsaUez0VqHVTksorttAJ5X?=
 =?us-ascii?Q?DOhooTUuCq/ygPsHzJgW37NElbpk4fN6b8/LlpzCjGCAeKmrJQo/V26oN8+a?=
 =?us-ascii?Q?pB6EOMOTa/QRn5oUUK8cPwNBFJ2vT6fsjPwp58udLR0RVCnC5hTTtjKU+h2X?=
 =?us-ascii?Q?TnzSytjwWSXLdiLL0JKXFLqNxsV71gmS5ZqIiNsGYJP92rBDVmTjWabmg4HA?=
 =?us-ascii?Q?OOaaugb+IndWvB7aukB94cVnD418BXlOiIUk+ihqRX2ImBplyjfd84QNK3+d?=
 =?us-ascii?Q?ruwJ4eLUDdz/vqkDwqQ1fOs3zmJvEwIysEB0NcZtTR+w3YmfS05BVgt9RBTo?=
 =?us-ascii?Q?zq5JJ47O72/Nt6Lk1vynl3Xqp6xVked18sDR9C2kd4ijRD1/7o9K+7f7rnL0?=
 =?us-ascii?Q?6yQpm8wSyjEnvB+CY0OGUw/CSlXVtZ29/TG+lK78DO/SkhAzWznS7kMdu5vh?=
 =?us-ascii?Q?3i/Ts3aNp3EjWCvEXGlei9cxFHosYbjMRhTqaNxYZUebgfThyz6EA6TyjqgH?=
 =?us-ascii?Q?Gnxq/FyZtDh5rxh+jDQldyRR6RylMGhWt4TV52WN93gRgsBGnIiTk5yTuabS?=
 =?us-ascii?Q?n1F9ra66Niz8HiXg7qZuqe/3B0aDgIV1L3RVlP+IR6N/1wQ9m24DtXPOQrSZ?=
 =?us-ascii?Q?7QK+Ftk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?5lSzaySfbxuAb4LM6IBxiP/Hbh6QxgVG21V4KO8PNuyFbWM0cP21pzQPq6tU?=
 =?us-ascii?Q?DupS3/v3mNN7eqaNQwFK6c3TtFPEugksyPHZS9Vf/tDkFoD2WDxXCYqLqzbV?=
 =?us-ascii?Q?s/UVCEhGD5RQOk2JkR/RRCvtJmkEEcO8QgI/827qiH6MOVfscF0YAVxGZy8w?=
 =?us-ascii?Q?JtViIR/UtsV7v3El3Fv12o0g/8nmfdfwQZe+YUaoqMDA3SNqtuWhDbhUgaVE?=
 =?us-ascii?Q?c/Et1aswbwo8KISuXV7jIh9YN2LTc0ARUnrPAFVmuZWDQdiScLJJ+WSrS+4D?=
 =?us-ascii?Q?6RBAOYZFZUcWkA9y/0U20W4R2PAy1epPAbGpwX46rEB6b82LF4x2f8PeSPq5?=
 =?us-ascii?Q?OdH1w+P9SWjF0ZbJLdUF/af5KAbRMFJIbJlqpuXsia9pyem5NB9FfFctCtm0?=
 =?us-ascii?Q?+mnPVYiWKsx/aM9hCHkXmcmqTkz9h/mWBeV1iiJ6xPpUH5GrzI8SKRswaCEJ?=
 =?us-ascii?Q?83+S9D2S2bK9FNbpLzWjtwk5gCeD9SIN2qirfPAXTENI8QliDxygodhAod7a?=
 =?us-ascii?Q?5bMtSLQN0SuOAZhmP9AZnoSN2t8egqvGzbRc2KvPPffKVVWKlDRLhJVNHwjL?=
 =?us-ascii?Q?NE7WJ0B7RcchkiPigSyhF0VMYAN4ckh7XYM6MKO2MgWmpJjgqYkjKPxzxCxO?=
 =?us-ascii?Q?UFNS0NC8x2vfWdyhGIu/fD4EwA6wRiGO6dfIrFpbWWOM535NrLZ+6FdG5aON?=
 =?us-ascii?Q?bEabsfXj5zg0r04owwdKpjpnS3iEZ2fEyRTgq/4Po4SHJNuChvRf0AN3DOeZ?=
 =?us-ascii?Q?gjtfWa6E5CW3WMEwkp3ArRH1rQDRQ7uL98/UCtlCxaRjqMPrjk46Bj/elIo0?=
 =?us-ascii?Q?EEvJVtbnJVmVl8SaUjAol0EGNBjlI4OCIS77mV1P+oc9451SZ9rl3evBz+Ex?=
 =?us-ascii?Q?WWQI6bM7kYEzEPervUCsycV7438Fhvm8VehP4gDRl6IYbou56k5/D588elNW?=
 =?us-ascii?Q?OFYIkeGljV5GmT13vTDy1ZHOv05bw55Vptja1v7Z/nIWW+TRRy4unj2LQxG9?=
 =?us-ascii?Q?W8+J1/SdCl0150fYh6+xsqc0Hhim6CnVDRFy7JXgYzo9KtMWU3sSbB75vj3R?=
 =?us-ascii?Q?qawxSawu9idgIq19iPx2q3O+iTD9VCznRxZDECB0Bx5UzNtF6f2vZHXHHXAS?=
 =?us-ascii?Q?Ug3XlfjI84PtoQUJFFnrAgH0I60Zku2RInGAwz+DwwT+bubPqsq0ANygdUcr?=
 =?us-ascii?Q?Uo4zU9Msg1q/H4tbMyxusFhp7CHK9XlHarXnMZ2T5DR+4VJeX2Cpg19RpfU7?=
 =?us-ascii?Q?b4jzGwn6UYRXcsgp8U/Y//IionY5PXV6GIR/2H8AypdmeLQD8YVFyvAWD+IC?=
 =?us-ascii?Q?x8OvjJfyKUqQSo59q9ZfngH9dFW38YWuNx3XjNEtV9/z4L9zSoQ+kKKIUqXK?=
 =?us-ascii?Q?Y6mLXFoYtWvuwja2+QlPTnI6E0UkDSqkQ8CE5IdggdTCWTH8+tBES82ak3vP?=
 =?us-ascii?Q?pubbm2gh3Xa+3taPPTGC/sfOHPzNnEHRvWW7EdevgdW/DcXHoBp/mLP4/Kez?=
 =?us-ascii?Q?1Ux4fBUc//nBKjMb5M3YgXh3ABFBLhAsn5ougx9y/z/0UmwXprG/i4anS/ez?=
 =?us-ascii?Q?qIZmE5LUboQL0DQg1kCORjlN7mrOuU0m3Y3Gfjn6NkIMltmm7FQBrXSUqfBk?=
 =?us-ascii?Q?kNgazMn6YaDfJhNrpUq96Y2iuRnaKjMyEFWREbO+waROeMQb1C/9qN9vUrq2?=
 =?us-ascii?Q?uvpvVw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CD8C5FD9A2C89A4EBF7E2688EAF13A55@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8965b0a-8003-4d8d-a983-08dcce9d5913
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2024 17:57:17.8897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 28CqNwxyOhNsWHeAGAWMY70QgS75WjpoYDIkFzGP8e5+hvG5Wn8zLzYRoNWe8rnIzUP6CL/PLcG6l8Q0W2ikpgPibKoopAYWWYVCJkvQLsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR02MB10313
X-Proofpoint-ORIG-GUID: QWqhF0gcg0R3cLyhjle_pQABZ5l7dOCa
X-Proofpoint-GUID: QWqhF0gcg0R3cLyhjle_pQABZ5l7dOCa
X-Authority-Analysis: v=2.4 cv=IMdQCRvG c=1 sm=1 tr=0 ts=66db4281 cx=c_pps a=6DIaztarb0XTwjBPIWoXxQ==:117 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=EaEq8P2WXUwA:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10 a=mZzvAnUHAAAA:8
 a=QyXUC8HyAAAA:8 a=_WAGrjdAQ1fWy_vJYWcA:9 a=CjuIK1q_8ugA:10 a=yTybTzTuyxIA:10 a=JqqaxZ1qutMA:10 a=w6T7mXiJl8tt_o6XwsEi:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_03,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Reason: safe

Reaching out to report an observation and get some advice.

Comments in __wait_lapic_expire introduced on [1] are no longer=20
completely accurate, as __delay() will not call delay_tsc on systems
that support WAITPKG, such as Intel Sapphire Rapids and higher.
Instead, such systems will have their delay_fn configured to do
delay_halt, which calls delay_halt_fn in a loop until the amount of
cycles has passed. This was introduced on [2].

delay_halt_fn uses __tpause() with TPAUSE_C02_STATE, which is the power
optimized version of tpause, which according to documentation [3] is
a slower wakeup latency and higher power savings, with an added benefit
of being more SMT yield friendly.

For datacenter, latency sensitive workloads, this is problematic as
the call to kvm_wait_lapic_expire happens directly prior to reentry
through vmx_vcpu_enter_exit, which is the exact wrong place for slow
wakeup latency.

Intel has a nice paper [4] that talks about TPAUSE in the context of
getting better power utilization using DPDK polling, which has a bunch
of neat measurements, facts, and figures.=20

One stands out, according to Intel's paper in figure 5, TPAUSE
has 3.7 times the exit latency coming out of C0.2 when compared to=20
C0.1, but it only saves ~15% power when comparing these two states.

Using TPAUSE_C02_STATE seems like the wrong behavior given the spirit
of kvm_wait_lapic_expire seems to be to delay ever so slightly and then
jump back into the guest as soon as that delay is over. If we're going
to have TPAUSE in the critical path, I *think* it should be using
TPAUSE_C01_STATE; however, there is no way to signal that at all.

Side note:
It's worth noting also that the delay_halt call does not do the same
things that delay_tsc does, which calls preempt_{enable|disable}() a
until the delay period if over. I'm not sure one way or the other if
this is the behavior we wanted in kvm_wait_lapic_expire in the first
place, so I'll reserve judgement.

So, with all of that said, there are a few things that could be done,
and I'm definitely open to ideas:
1. Update delay_halt_tpause to use TPAUSE_C01_STATE unilaterally, which
anecdotally seems inline with the spirit of how AMD implemented
MWAITX, which uses the same delay_halt loop, and calls mwaitx with
MWAITX_DISABLE_CSTATES.=20
2. Provide system level configurability to delay.c to optionally use
C01 as a config knob, maybe a compile leve setting? That way distros
aiming at low energy deployments could use that, but otherwise
default is low latency instead?
3. Provide some different delay API that KVM could call, indicating it
wants low wakeup latency delays, if hardware supports it?
4. Pull this code into kvm code directly (boooooo?) and manage it
directly instead of using delay.c (boooooo?)
5. Something else?

[1] b6aa57c69cb ("KVM: lapic: Convert guest TSC to host time domain if nece=
ssary")=20
[2] cec5f268cd0 ("x86/delay: Introduce TPAUSE delay")=20
[3] https://www.felixcloutier.com/x86/tpause
[4] https://www.intel.com/content/www/us/en/content-details/751859/power-ma=
nagement-user-wait-instructions-power-saving-for-dpdk-pmd-polling-workloads=
-technology-guide.html=

