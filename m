Return-Path: <kvm+bounces-27509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E42698698F
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:26:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C6CF2844A6
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 23:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A582D1A7269;
	Wed, 25 Sep 2024 23:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fLTaC9F+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fZMWTfbI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86B11A38FC;
	Wed, 25 Sep 2024 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727306735; cv=fail; b=qpQFghy5ouj/KYlgs8gM8VsOImK+MH8rXs/s7WKq48c1mH2hYzwkbDdJKqb2RBabv2a+jBWxn96oi0OE0t+xuO6bV1VLF0UtPdWx0+tad+hmG2Lu4XEub6oU1SzC/7n2rgRl0TlkEiAz2r70gED1jChty4VhWZ1iS0PugxZIzW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727306735; c=relaxed/simple;
	bh=Dvjt3eCBRep3bUPqXObiTVB7aYKpZUEyGrwLFUZIsbQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ie7ttTvHMfOMxogp40muTvYBDBmtSTxAB3kuumRlFgWPk+nV49c9Yu0xy0wnN6K24In3OMkA0paXiPU/6ZOfdmVN9GNWRu/L4wIPGtAZ+gtSedVbaFfm6bp06uHqhWqkxGIZUyMPw+P5XVLXBfFLtsBfK/zQV7CmpWuj8kwLNjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fLTaC9F+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fZMWTfbI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48PLnNPW028932;
	Wed, 25 Sep 2024 23:24:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=f0X4wMl3YPhGfRvYRntnxnU7wDqzq2ggNFPG5RkSv6E=; b=
	fLTaC9F+8D21GMI7aIxa4sMTOtWya8W1zFsiz6HryB/tH1X1v5zX3vbxxms9f1Ph
	d5GlBP7eYLvn+5MatFT7BgDn7Onkafw+bhhRFbCSuJVUtIsL7fdPyL9iX/aIYVFf
	AaUBn7TYVSAtDsSoKEDApUxUArOTcFb7vKCVF8BBTEruURVDvqDnbklFdGIFakCI
	KUhOd9hYevidoGghIEd4xtt/0SgX0GGn5S5Evm7/tm1ayQ/5U0Lsk9fJ7G6E/vQD
	905v91obLAc5/ZobGaFspXEz2mgXFDa8ERx1kQ1a5XH+RL9drxsyBf7g2dPN44N+
	60Jy/38QWSA61QA8+Mg6nA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41sp1akkun-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48PM9nVH031194;
	Wed, 25 Sep 2024 23:24:38 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41tkc7x25k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l3Yn47E63sKZ45PZhYQWqJa7Sf6OpWwTG6R3JUayNPa1DlRBRLOh0Klyde1t3M5WEbsC73nDT/rx3nbme4E8+nOidy9C2sRnuk5/NZcyNo5O0Vv7TfeWsIjfMxIALeKrjxc04ZF5NtSEIpWIocZa51czBlvrkf0hs6b/9THi7q9iWT5EF7c0gnPhF8DQVXJFOIXjgYFy8Tqr8nIOE9C0G4dA6+jXI4xTB3ZokCOoz5IwOhpcxJUOcDmIPTT+d0zDNByTGpMJ+xRx7O41MD2D1hB/C/eeSw9BOG+ngpAyK6zVks3sQ3rToUfP8UrgA57UyOx/vywX1Ch2t2xAuoM5Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0X4wMl3YPhGfRvYRntnxnU7wDqzq2ggNFPG5RkSv6E=;
 b=DNoURymr6rg2oCQ+PgduGR8KpjtA+petRAF1IQ+KDSyvJSXr9Hxb6ma70uAWHJUluJuLdQYGYQKJUJuF6id8fOkYUeqX1HzvY/moOoxZOvyMUqY+ly9fgCSIlzTDE2Dabrn4V4VQzC1qUkL+HU8gpq523HpDN2UFgw9KfNMRxcgnW5DwnOscPIcZbpJvFVaJ7+n4wL5u7MaMpXpWjFF06UAujAWKvHWbQ8B+16uaG4Za0GddQai42G19hZm0R2ZHo32MdRHjx3k0kxRPmrpeY7I/5MPrDtG2syQzFms809PWklGQCWt63Q4y22slNeHaODnwfjTe2mAS2OPo05HqFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0X4wMl3YPhGfRvYRntnxnU7wDqzq2ggNFPG5RkSv6E=;
 b=fZMWTfbIrmQit2DBJKErn/B+hlnMD33UfcaPk9vzlcAt5S1qWZBN4pLrI7rrq6Pulg1SJNodcncHnoBGBLZp6s2+NWHhLFbMQ1kb2bHFL0sdPLO/1MYQ9M8SWKc5SsehnilYpOVopiDhdoU5L1XTeL7sJGBLxGENR+hQkkLcHAo=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 PH0PR10MB7008.namprd10.prod.outlook.com (2603:10b6:510:287::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.13; Wed, 25 Sep
 2024 23:24:35 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%5]) with mapi id 15.20.8005.010; Wed, 25 Sep 2024
 23:24:35 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: [PATCH v8 03/11] Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig
Date: Wed, 25 Sep 2024 16:24:17 -0700
Message-Id: <20240925232425.2763385-4-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0141.namprd04.prod.outlook.com
 (2603:10b6:303:84::26) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|PH0PR10MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d62273d-5421-43b9-8dd6-08dcddb937de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?58Hkb5Z3S1snFzk3D/AhZV5aQZVsyg3irPJm4V9n64eFtd8OqB4Lt9T89Giv?=
 =?us-ascii?Q?SS+7tOuerev+HFMY3qxGSpTwXt1Vtmie8bow+MqQaro2lxyxVq/YFJT9vMQl?=
 =?us-ascii?Q?DAu97H2f/bMaca1Lcp2prj153ewqw93OmYZ2kIkf4qCT+KjgRcSGq6Ypd7q3?=
 =?us-ascii?Q?JVRe6FZ9QX2vd4sdE12rl89LOCXJhTp9Ugn5rqCMuRxTadVVJZHtYcikuSz/?=
 =?us-ascii?Q?LhGiH16Gd1r+y2Hw8ihh7mMqGgLX0KLELHYNIsUoRG5XTvwJnPRL7TXbvcsJ?=
 =?us-ascii?Q?X5C2jCYzso8eLhlRQi/mHVkMmdU19EU6yPLBft7jbRphGoWb9xT3blQlCiJ5?=
 =?us-ascii?Q?vbGDSBl+4KBN0pIKajm3+D2APZ1FfyNgY6/kx+0GUg7sO0Lw4HucjTLZvbap?=
 =?us-ascii?Q?JT0u27gWcvgG1peNRTP7sYUKFqaOiPgRaDDJO34DYE9bJmX/cBG5MMKePlF1?=
 =?us-ascii?Q?DdVMQM6SKLUq79cl0/ys5HxvFAi6ddqH3lSewh1V8QpXNXDWViw7ljIzOgVI?=
 =?us-ascii?Q?c0plSRqYUQzzx4/G4QuGJGRculbjk5aDqQqc1ahlANzfMzD/fW55E3OmM8Z5?=
 =?us-ascii?Q?v5dtpYQ5wGAyk5wuHqOyR4OheKtc68PYRZKLb6RBXAasoLU6+aYJsHSp0BPu?=
 =?us-ascii?Q?Zpnh5y+n8rgxh5bfQ09vbE7kNh9L59Pc+8J0PXBzvUHPaY6ohrBtzH8Fhtq7?=
 =?us-ascii?Q?3mYIGNsg1yjPLN9vxAXm0uQt6Ntdlyk9Umfyosin/23Brx80Y/jdTcJ2Amaz?=
 =?us-ascii?Q?ZwvBcsQAVdivjJ+39Elm8sHUF1UmVV3Zc1OSqqGT16dl7r987F1cZJCoTsyl?=
 =?us-ascii?Q?MKWIxL8GfHWXQehTTcyn5XXXKY5P5AkuSQ450IRC/B5Ocd4SWMcy8sxF8jDC?=
 =?us-ascii?Q?5/24tXjjThibH4xySpISHPqHYAK+mm/nM9C8fxrSFPSLi7ECGdma/8FS7drT?=
 =?us-ascii?Q?SdGGKYQfG5nkm6AEHSeJvxyDf0hOSxrXVTlFWWpjEo2JcAE0lVyenxPlkui8?=
 =?us-ascii?Q?QutWCyvW+i8/YjLlNxG2beg6FbgjoFtmphi1jxmIUzdQZ8n3Z813lOvwRG6M?=
 =?us-ascii?Q?UW8ZqvZWJfWX1x3Wyrov5a3NmFRTPnKb4JzpQVsNYj2rwfy71i3QckqBxhW/?=
 =?us-ascii?Q?UoJY1ZkRG6t6GXQwOQ5tB2GGAvLKCk7VAfiI6IKcWbwxB1VfaCDBwo891AWe?=
 =?us-ascii?Q?PU5c2s+v9Nl1gaPbZ8y8WA8XU5dj8CtJVkyfN6yK/uFI2atyh9GUN5A2Igmt?=
 =?us-ascii?Q?bq6WMPPIs4b5QGgZoqgQt7W9LQ1WSEWY4E5JfxQEUA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t9n/cerADIsZF95NtO7ArRZfCXA8Bf+L+9hjxc/ZHl2qIWTYCcSg2zLTcLxY?=
 =?us-ascii?Q?2eh7ccJ4B8ZEa+uWkHISK9XJt4rgoY+cyYEVIK9nya/8JZOrZofsjoAQYNkf?=
 =?us-ascii?Q?IVqk+vFWuwtESAqs4JylacZ1UqQLLrrI2IjUm6NljDIzQzw2wB4jqnijKbOm?=
 =?us-ascii?Q?Hu6JGlDsTerbYjKCI1/jEU5yCERJtw5EoWRt8AyqUwJeQ4/j79U/GrcC4sij?=
 =?us-ascii?Q?a+MwHkSxbg2saWSpwVHj2Ya7JTFV12nJ9TUBziDdyjQWUvh0LH7YxzASmMRI?=
 =?us-ascii?Q?4NIF2NzyV0YdvvMqzkP/NtgnRM+GS1M7Oy3IfkUvY5TDXposjpDk+mUwFMvd?=
 =?us-ascii?Q?aLcIklxOnZxv9MPecf342bI+ZuK9vmAe9FrwsGoKzvVL3rwlGRjL4fGR5iLQ?=
 =?us-ascii?Q?RTNrKpIbh3pVeI80wH/ZFtMpN8urVWhxr1PVwK3GW9LiYxfLVDYatfZuJPpq?=
 =?us-ascii?Q?Q+FQmk52bNz4TkjP7tQcApuVqBJ90vCSVK5otD3xWX/7zdhZVsOblyzSErBJ?=
 =?us-ascii?Q?P3Wq3yTNLCVbB3UHgQ3IKp7AR91deTsUeKXdqh8apYDKzlaPVCRX1y62BcyG?=
 =?us-ascii?Q?KUZaQJXfUIbysQ4hCUbNToBRZ6w57LEvz34ekhs0kRHZFAOVk8jy0JLgXNgT?=
 =?us-ascii?Q?mDbMtrlEP7enDkf/FePsEA0JBaBilVeNsXMfpWOasaRQkPYdHPVnYsF/y95E?=
 =?us-ascii?Q?KRVJQ9krhG1BAMBDMcEgoEpQ9OgzRq2QD1zK45jbiJiSr5jqyGVVWbfOLwNB?=
 =?us-ascii?Q?MDUUyteYkdeI7eHbN5QWXbJUjQv2pEKwfIPGcs0mj/wIyBeN48WtVbyntQDU?=
 =?us-ascii?Q?efugaKwawuilIZ/Dp/2i7pyrcXb7LPd+V5ZDPN8Cc+EHLnTeBEYmS0+tWgYH?=
 =?us-ascii?Q?n0TBijONV2qc3Cm4YGwdClUQlp0PZdEcZ5BDyj7wQ5NgOcxRu7Tj9XxN1ipr?=
 =?us-ascii?Q?XxtGzuJwCk1gHo0EL6DOyaHY8sEW8cwakuwGY7jtP9Gy9ebKCNMZhz3Se4Jb?=
 =?us-ascii?Q?+woLqMpzVyCt5w/2KCTfirgKidJZAnqqi+Dq/+17XiuuQqVPtOBzbgjjTyfm?=
 =?us-ascii?Q?+90IdxHqKYTRhZxgRlXo+AEQNUXuPUtFwS+ckxeuk1bSM0JxghUMRGG9hY12?=
 =?us-ascii?Q?VeyAkecoiY3fa+BHjYDmct1iEhyBRPvvZZr+15NLdWDtCdUkTyZxkMnpIzfk?=
 =?us-ascii?Q?R50l7UHoRTHzFdXLCsrtHYKw565tETQQalOOjgfs0DQY+QOJ7/wa6pZLUi21?=
 =?us-ascii?Q?K2O/cgGRjkCXdaasQiXKp6i4LOF+ec+5rvtOEyjRVKl8cjvlEoCFT8aFEmWy?=
 =?us-ascii?Q?pavuG+DrUlXCf+nijxxV2RHFxW1ERuAZ7QZJ+p6M7NU46ng6z9TvrIw4yWWU?=
 =?us-ascii?Q?fDw1HvdhjZ0kfjSTRQgz/nA1IrC/TMsjxorhX3QbYHUi4viBSX7pQknbDfHx?=
 =?us-ascii?Q?fClVFrA01NJFwr4LjKu7Q6pr/bdbput4bFCKdYDbgPcAztCVwUTq5d/oMTBQ?=
 =?us-ascii?Q?r0CELcVDogmDvnTCoO1iFpS/iVHnDJq204bW8Nvd/3jyel2J1a24PsKVxxlh?=
 =?us-ascii?Q?kqo7RuCH1N77880xpFRvCQhUjjhjNWtzH2gVtKxjnbtCoIH/yYMbOhabB3B+?=
 =?us-ascii?Q?Lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/OyqXfCC3jJrzIiJCmdPr+k+iYAweg1s1J2ftob/6fy8ieJG5hLo5afEm/3gj4F5RXOpumJ2kS8pBC7LWAoOPqxELbIF6iCVYkbtuvqQnfzxPNK1lfUJwPHxjYL8qS0aCshw3ETXVaYXkXidpmyEfu0DA7QwKQsyPu8DUAXWaThgHg1ZnP1NUg6KLDpYI3r3CtqzMgb3RSznYfUQehIyBG/a9tElCqPIaAgsh/7h4QR5KEukcSNicWXuOWuUYZHK0IF10g7+Yp3deZoL/32t/WfKLLv2NI4hQTWvDc8SmZGabyQp+1Xc9YpK3fSnkNJ4bVHjCi4dEm0XzPq1dfjW5tjGOitBcEtrGTiIxSyku/L1QuYySR5KHtZ89ZZQDixXczXCNvt4hJPO2VqwWLvoLwNtQbQ4rZ07tYwmWpJBMeeTsmm2udtndhbvDVRkCskjhO2KB+/NtDeNvuaYd3YrbmTnMSX0GoBOp6yegxGCBUUxIb+hPvRYEBdgPAGf/oLG4WqyU7xQb3BhzYz/ISbN+56WBYqmF/bUMlJTqTHLteDg6EzdGn3writ96FYqpQ7Xli+P7lq4e5H7UxF0of847+gDGClGpitC89Kfjla3r+0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d62273d-5421-43b9-8dd6-08dcddb937de
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 23:24:35.6990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DfNQy+wlH7M+ipXyGOxnR65grwzJUImPh1CY+DLg7us84Q54adeckL8oF6VoJGlX1FR2RE6PX1Rg6bVgzSJ8mxpnnx2Cwv3Q1lYAay6cRhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7008
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-25_14,2024-09-25_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409250164
X-Proofpoint-ORIG-GUID: ABpAFr3SAWhC1S41HqtlyxxS2iqdle_z
X-Proofpoint-GUID: ABpAFr3SAWhC1S41HqtlyxxS2iqdle_z

From: Joao Martins <joao.m.martins@oracle.com>

ARCH_HAS_OPTIMIZED_POLL gates selection of polling while idle in
poll_idle(). Move the configuration option to arch/Kconfig to allow
non-x86 architectures to select it.

Note that ARCH_HAS_OPTIMIZED_POLL should probably be exclusive with
GENERIC_IDLE_POLL_SETUP (which controls the generic polling logic in
cpu_idle_poll()). However, that would remove boot options
(hlt=, nohlt=). So, leave it untouched for now.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/Kconfig     | 3 +++
 arch/x86/Kconfig | 4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 405c85ab86f2..cee60ddee5cf 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -273,6 +273,9 @@ config HAVE_ARCH_TRACEHOOK
 config HAVE_DMA_CONTIGUOUS
 	bool
 
+config ARCH_HAS_OPTIMIZED_POLL
+	bool
+
 config GENERIC_SMP_IDLE_THREAD
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 555871e7e3b2..272ec653a8cd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -138,6 +138,7 @@ config X86
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANT_GENERAL_HUGETLB
 	select ARCH_WANT_HUGE_PMD_SHARE
+	select ARCH_HAS_OPTIMIZED_POLL
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if X86_64
 	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
@@ -378,9 +379,6 @@ config ARCH_MAY_HAVE_PC_FDC
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config ARCH_HAS_OPTIMIZED_POLL
-	def_bool y
-
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 
-- 
2.43.5


