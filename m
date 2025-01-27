Return-Path: <kvm+bounces-36696-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEF06A1FFCD
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B971164CDC
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D69C1D79A5;
	Mon, 27 Jan 2025 21:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CPkc/2Dx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="EoGLkqIE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8551A18FDD2
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013501; cv=fail; b=sA2ejMBPiQth1eV3+OZSwRQ+9IjrmSxg7UM4TBLJjEZNMwNyjPuiCIC/ZnYEDvMRbAWzyZFUbgDE5Bi3lY8gKAMgy00d/kwlughrJtPJSSn1kNtCJJGtjWrKyNL5uYEWuZm0Wxx3/SCnT1wAii8Xgz8YMC0R0VoMMXZkEZDH9RQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013501; c=relaxed/simple;
	bh=SV6ViL8xPtTJJuEh+x1c+lz8W+mwHx10EkWbVaf9s14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M4sjD27AbOTMMiJHBm7VzXyqhBtbJOTxJ1caZGF1OdnVdH1cUkqlRytoBCxudZjxMKdVChS1YJoMwJ8la2V1cDZEnnTGT5l4KUC6pOyeH8YGtUZUIFQP0HAL101vJmYQxRKKiYdlWow3WWwhErc9OjqOJdZGUOygUKZn/ffYIcw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CPkc/2Dx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=EoGLkqIE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50RL0r9Q024672;
	Mon, 27 Jan 2025 21:31:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=5anNKywY+1Gwgr8+RChwjIgkuGE9CFcg28ydEzK5lgs=; b=
	CPkc/2Dx8q6+x06LWretT4c606hLZvUjc5x6sLHUHcGotZeYFL/48CPzSxYtcm9r
	wdZFMPnWKs1QlduEVVCCtmn583rOrzWqcJEC2GqsKiy4GQDP3xU0+G3J81r/N6CO
	8LgDeEhIUl1/M71is9wvR8wA3hSXIYH+yGdmvhLTeRkDfIcy2Jyw9Fnpq4Jr29eV
	yFqxM0ctvEdfuQ93zr8Iay6ojCkvJ/j5R3rq365yowPwssk5jMdOSUai+/rAy8cp
	ZugagCe039G4nszmgZpaiC2i/+1qPKK8IGIkHJMQokKuXIvFD0orQzJRd4zm9Dz8
	IrxZP9XBhFlFhMeSJj9sig==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44ehpc825n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:31:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50RLFbju003407;
	Mon, 27 Jan 2025 21:31:25 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44cpd7k1b1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:31:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T+RtGgo8hXD6P64IJw5tcVvScfGlq8OZmPCKoP05/V3+dHf62965X33PhALzsueHFD7n3RLvFFKrmBHrTtVnaD3Fx0m2iw06Bk0H3tV6A2bj64Icnf1psPK6qbX0In5Pi5fgmwL2G88AyOwOM37PHxvrey53iugztg0TNMy+WcBJmGcnd2eUOFqu2j8y5lcR/E3Q6sdM2AkrUcZ+2DY6v/tFuSJ/INz5AJ6mZPfKTQ1V/IGr5xmOdILSHfC2a45tdHLMNZxTSedhBWLWnTM7phX8D/j/AzWsMhDLPdpxSqHhZ1bWPY+hxp0MK3QZtyd6pGTtlOaHYyO7aHq21QIfcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5anNKywY+1Gwgr8+RChwjIgkuGE9CFcg28ydEzK5lgs=;
 b=bTDLCARcLzWuREu6In1mJAu8/GbVayKpNZfl+qrCXilXlVnRsmFpikOHeMyjL3xTtGzGuvMJPKae52b92BqgAfqDbcdWoKGd3U3XF04r2fMWf05yqqhTMI6N2X/I39eZc5MV0aXKX9t1XEQwarRJACkgPfAgYKZ/TAXrse7N8zLFvoD05mGmOSeSCaFhcei25QWua8mt8rtcResKeJ7/0OAu336KhzF13Hy/hkumKWR6MpSIFUHpq7uc16metsQtZEVOULKhKhuWr/r1qbER1FF5aRCzYfL3Lt8WJJ1tWSEoF3ca1surIACR6+aXbnI4PrHloUXdABpQS+CIRHRIMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5anNKywY+1Gwgr8+RChwjIgkuGE9CFcg28ydEzK5lgs=;
 b=EoGLkqIEiU71IlfxmVEoUkkqnx4kLAqMwv9wUNDWyKS0VaI+x7evkAzaFLn/ycHf97zm+AivCBaoTNQPrKaxlpoZdG8Ix/vK1Ysp8ORGVnjsxVIgxo9CAZEmq3298cFJJ1w3Knn6XPdZdjaktKyaz/mKIxhHxvSbFLUZtZ1AMb0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.23; Mon, 27 Jan
 2025 21:31:24 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 21:31:24 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v6 1/6] system/physmem: handle hugetlb correctly in qemu_ram_remap()
Date: Mon, 27 Jan 2025 21:31:02 +0000
Message-ID: <20250127213107.3454680-2-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250127213107.3454680-1-william.roche@oracle.com>
References: <20250127213107.3454680-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0288.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::23) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB4614:EE_
X-MS-Office365-Filtering-Correlation-Id: b1aef843-d5c1-408f-0508-08dd3f19f2c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GfZ+jz71KpmWy/IycgJ+5i8ybRU/a/XnWOsZsa93Ufw4u0LFRZmZhzno4YwB?=
 =?us-ascii?Q?KRrrhdrWJWiZiKrUKWqbbotjLlA6neZpY0jebA9Yfs/EImHGyemj0ZuOzYM7?=
 =?us-ascii?Q?y7w9iouJiaxKdn8N4a7EshVydAM1kLkyi3zNc1HynGF839neaHMl6cpeOCLE?=
 =?us-ascii?Q?xHG/qBNzqJA0nAz1mZz5+k4F7AucFDpq73NKLWUICQ+RI0XYhL7WQ/sXpZzK?=
 =?us-ascii?Q?wjQOr4BZd6RnQAZxnos43WjiY6WO8LspqUBL9zTMn4RYYhYrahQqzHaDI/ki?=
 =?us-ascii?Q?uOR1Xl28h17Yx2gtA79qovru/HbUDSrOfQZSdldsRs9xlRqGBtQQSdA5bmgd?=
 =?us-ascii?Q?s+26+cMmWHsvMISZm/iOHyDCce8aOiQpo5/kCma1H6Ejzh40k/2BMZ8Z4jZH?=
 =?us-ascii?Q?dnG0AeSdqUdFlfo/7qoru/Mdi/MEI/JkO9sM2yFssBg/mcCdOmGTXtkOuDOj?=
 =?us-ascii?Q?8moW3tW1mRM7O2kmwLz7eHtAaVv5kWMdjPZ0ZRe7bnPerpnBbCFcIMp5dmCG?=
 =?us-ascii?Q?7Xj+Gdui/OwfYevjBfw7Ed2aEnTIAjRpiJsvfWszPdGjp5LiipRSU+V63HIU?=
 =?us-ascii?Q?BzjP8GLC5oqPrwKkEplBNub3CpK3KORDXMu/D6JohVBsNOj62S03CM4ALuLA?=
 =?us-ascii?Q?YZTCldSJ7vQo7ojvFfCp4ZGn15Zok7rXDuwpu/XXfwv+2r2hdrp1MQwfY8FY?=
 =?us-ascii?Q?7JejCLO7ylj9euNZ30YhHqRbOmmyNfFkzmcn1G0uRiJELbgjK758ZN/n6YDZ?=
 =?us-ascii?Q?ZeS30vWdawKto4jhD62p4ZYnUUGWddU/YdnAheuy0lMQ89wejgAk5uCQAUpZ?=
 =?us-ascii?Q?+sKclArmqdO4pjZCMjTg0g06UPSqNcu+QrVNHJ9NSCnbGkgYNniaIjB6BAn8?=
 =?us-ascii?Q?/xoZrZ+ipEr6wP0e+30xLuOdJCVp6n+NxXciHxLR7pC1v7ss1aSWLZx/Z26f?=
 =?us-ascii?Q?MNvtuH7kAj3gY8MH/GpzXy5D57HxRq4w9hQC6crOrJH1548aBbHLWqVWD1+S?=
 =?us-ascii?Q?m3H0GOo+ukPC2vCqE3XkGU/65KtBvSz6P5mxggLg0n7qYkoYiFz/HHGAStip?=
 =?us-ascii?Q?xIh03kxx3ZbGvXNfI0CnhIHUZtV9ppUwdgb3KX0UOCZ9BasDumrbM4mMLkPN?=
 =?us-ascii?Q?iNrZddAUEaeHvFkDRTnIL3xHQYlUyAzZVWG3vQUPV/rEMYxEd2Tx7EgWdshM?=
 =?us-ascii?Q?BpGsAYW477ZMfti7+CD1xvCwHva+T+BFaUa7ScfXpbrO0qUei3MXIQ5STGt3?=
 =?us-ascii?Q?qPL3bqhRdvXO+ZUAfWr1xdsS03pw5xiiVT7hvrLQpFZPlJiAzcoqwn9ge8rf?=
 =?us-ascii?Q?cFli2wd5ThIdzwj0abDPKtPB3Zv9PG+a5hX1CkRlLUY/OiOnAz8nTeWjV0Tq?=
 =?us-ascii?Q?id5yGpmjo51074iJEyK3QxZbFJQX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cUzIJ9b+Lq+LL8UQn8Od3R/4T7YqX7AocawBPFWs2Jeza5VTnDa6NDanntyM?=
 =?us-ascii?Q?Xaqra4+7wE0HVW2wesB9NxWtKxc92j4H2wx4Pr1+z5Tzx8SJ4KPCNfesYq4f?=
 =?us-ascii?Q?luc6Iy6oBv18vPSkRD7xgWsn4gx0xTRVidy1gHxC2JECeioPtvDjqgydx35q?=
 =?us-ascii?Q?Gjkl7wu6tQ2OjYA3Qw++ZFR/LVlGLAR/zCMMyXWLZVHSM6gKJs5Z1s3TANrE?=
 =?us-ascii?Q?pE0XWmvvunE7QC7qgNsc5AD7436+QJtpztkkquovvo9/L2iewKJy6ULSuEH1?=
 =?us-ascii?Q?PlEN6gXneelTDMFP3kCLu9uZGUkwGbhlXHWvkwOetGsTWDu5maPHv6mayeWT?=
 =?us-ascii?Q?+99rjWxVSc+gl6IcEPugoKmhWfr4u6ixewoSmyOqE8gNG2M77X34u9w6XYFK?=
 =?us-ascii?Q?zheNSxro/nL2Sr/L/sxgmI/rArU2SFzwGFVOKqA/kymIF3lnsjvDWDKijyEb?=
 =?us-ascii?Q?pQ88+PaIs6gUHXObfJFG0uKR7HlSWHxHLqU2DMKxB3SEp49zRK46ISkSjQYw?=
 =?us-ascii?Q?iKDyt8ebvkkaEUjVdRvfMX/XYKzOsEBgoijy90H3jPrAXIwIfX9VHirGVgDZ?=
 =?us-ascii?Q?LfIQ1v9DU+jsv5tJWBdy4OFxSZFz7d2AEdpqpzCNZXBaCmb/SdqpH0uJ2y1F?=
 =?us-ascii?Q?3DZ+zyegZdfv23NMEeyleBOYg5nBhMXjGguHKsaKiKINRmaJGUbDNMf8CILl?=
 =?us-ascii?Q?nNhKuruf4lufApj5mWJ40hYcEPOpkxI0TOEH1LOSlXk41N7USHSF4YZuTR7a?=
 =?us-ascii?Q?ZYQU6LOv5Twk7iG0trBdXzv1BvDGgGT3JJiFBHOKjMHIEqqDUxNCKFNAk1AL?=
 =?us-ascii?Q?9dBFMx3hI/IgOaJ3Gy/hw9edAueRvTQZeHDbYkIpikmB8QkTSVyQsWkd6Ukr?=
 =?us-ascii?Q?00A+u45sQwudB69AnhyrLewDhb8VX6zw2WstXINAfy1OHmx9g6YNBKdllFIe?=
 =?us-ascii?Q?f+SQ2+zDU6GBU2sjv8gpIjAVpjHYK6M/hQ2tR/mGrNy3P6wUVRGTUQiPUs9N?=
 =?us-ascii?Q?FvE+aVVOei+wSOZEejscB/iXUY2tEQ5MUNbXn5Rco6fS0qsycTb3BR9WvIfc?=
 =?us-ascii?Q?gz6OfwcHLls23g4IfcwpFcF1sixTBDQDv3ZoHDIqLPl9iuL1PSGrTAkS5Nmk?=
 =?us-ascii?Q?8mfcyZk85Grv8SJlDAHhaeQukkz7dg1Ccptlt/8g8pwCyXzz7oXRYR6/mKUK?=
 =?us-ascii?Q?CZs0LXX6cGzAKjGAhcgt4Ssp2FEm6svVWJF/pLOv2cH7HGu00E9J7u5yqQ/e?=
 =?us-ascii?Q?+8i+nHAE4OaliNjZVBoHxwNnCeo4s6VRAF/m/YMLTBIotbo1m3wiDdImTdEh?=
 =?us-ascii?Q?XanSC2uJkkHRrG+pL4Il5KetJ78TGCHcxRGq8oOZktTw8fXRQkt1jrqDstnF?=
 =?us-ascii?Q?pjkBuH/2Y88xgosYZyZqQFPe5BoWhTZWeYxlJviJYBvAQLk3ajLotafxTWIA?=
 =?us-ascii?Q?PO270s3ZifBIurcXK8K6n+/mfKnueVN+ki0h6socoei7YljNIXGBDY5q/lDQ?=
 =?us-ascii?Q?OYfmPtvHfCtH6olalW2s3AElPHb59UZxhaNZJYBIdbqV6IIePqMCZFhr31zn?=
 =?us-ascii?Q?8M+i4AwoYp6N03nyqGHhnlM+rmU1s/cSKDqxpC8PCbH0rIM07Lh/7nRGOvuL?=
 =?us-ascii?Q?+g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g8baaf1dtdhIpQXzR4Krua4szPVKSzd9MpDo0CaT/cIUwRbvtwJfyPpg/4ugxDjtUtm/Me96r2ujwS08EFQcgTZEHap+0PCpRV4NtkzpRjyKdJRtoij+Boadfhz7YqMUnsf++9L/fFJ2g76OP8BZNMonAyEsYuUnOx2Q5vIQYOUKZOc6GxUgVxh6Bpq5s4zpLl8KdIAkcl8febn7xLCz+93UIOoqnhGCPA4P8dtZ6sfqvaRSsjiR53ZgpnN8V9bFpLWqjCUKsN9NSxlgJzJaex4dQxiL6PwRr4uJFprWLbEZ2FI789G9Lqr2Nkt4VB+6J542PMcQyqUTN/AraZvKRnwbC6recCpmRwohwL+Su66LoNi3+hLhJzmq7LisyR5cO/HnFgtcIlsLmovx9uot/xPjlYRPuKGjoeu94tXqbQmHHs6Fj1689hZg8Zyw8RTF/Kji8BUA7gt7q3lLaNziH/H/dpQL2Vl7knFgOfmu2B1D8uvQ9kE97LQxHdqLgsSXhM9qK0oL7Kdxzl3Ci1QrvL91qOnZPm3BYQ9b1IGF6BxXIH2ZfAc2qeI1VO5tLErdLx5lycWlcrvvYB9aG+qsulIlCn2b+Qx7qQPs2Ti3xGY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1aef843-d5c1-408f-0508-08dd3f19f2c6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 21:31:23.9219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WcNpoXz2MW0+d4+VM4E1HxubSL/s9LpIYBRlMKpNs3q5CrECK2vSa0A6v9FLX7BXcu9D26cG/y/drp96CPLUN8Th97mJ7/GbQsQAgeFMCHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_10,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501270169
X-Proofpoint-GUID: 2Z7u03felJD2kOJCTn3WAIuPWhhvlwqG
X-Proofpoint-ORIG-GUID: 2Z7u03felJD2kOJCTn3WAIuPWhhvlwqG

From: William Roche <william.roche@oracle.com>

The list of hwpoison pages used to remap the memory on reset
is based on the backend real page size.
To correctly handle hugetlb, we must mmap(MAP_FIXED) a complete
hugetlb page; hugetlb pages cannot be partially mapped.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: William Roche <william.roche@oracle.com>
---
 accel/kvm/kvm-all.c       |  2 +-
 include/exec/cpu-common.h |  2 +-
 system/physmem.c          | 38 +++++++++++++++++++++++++++++---------
 3 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c65b790433..f89568bfa3 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1288,7 +1288,7 @@ static void kvm_unpoison_all(void *param)
 
     QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
         QLIST_REMOVE(page, list);
-        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
+        qemu_ram_remap(page->ram_addr);
         g_free(page);
     }
 }
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index b1d76d6985..3771b2130c 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -67,7 +67,7 @@ typedef uintptr_t ram_addr_t;
 
 /* memory API */
 
-void qemu_ram_remap(ram_addr_t addr, ram_addr_t length);
+void qemu_ram_remap(ram_addr_t addr);
 /* This should not be used by devices.  */
 ram_addr_t qemu_ram_addr_from_host(void *ptr);
 ram_addr_t qemu_ram_addr_from_host_nofail(void *ptr);
diff --git a/system/physmem.c b/system/physmem.c
index c76503aea8..3dd2adde73 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2167,17 +2167,35 @@ void qemu_ram_free(RAMBlock *block)
 }
 
 #ifndef _WIN32
-void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
+/*
+ * qemu_ram_remap - remap a single RAM page
+ *
+ * @addr: address in ram_addr_t address space.
+ *
+ * This function will try remapping a single page of guest RAM identified by
+ * @addr, essentially discarding memory to recover from previously poisoned
+ * memory (MCE). The page size depends on the RAMBlock (i.e., hugetlb). @addr
+ * does not have to point at the start of the page.
+ *
+ * This function is only to be used during system resets; it will kill the
+ * VM if remapping failed.
+ */
+void qemu_ram_remap(ram_addr_t addr)
 {
     RAMBlock *block;
-    ram_addr_t offset;
+    uint64_t offset;
     int flags;
     void *area, *vaddr;
     int prot;
+    size_t page_size;
 
     RAMBLOCK_FOREACH(block) {
         offset = addr - block->offset;
         if (offset < block->max_length) {
+            /* Respect the pagesize of our RAMBlock */
+            page_size = qemu_ram_pagesize(block);
+            offset = QEMU_ALIGN_DOWN(offset, page_size);
+
             vaddr = ramblock_ptr(block, offset);
             if (block->flags & RAM_PREALLOC) {
                 ;
@@ -2191,21 +2209,23 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
                 prot = PROT_READ;
                 prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
                 if (block->fd >= 0) {
-                    area = mmap(vaddr, length, prot, flags, block->fd,
+                    area = mmap(vaddr, page_size, prot, flags, block->fd,
                                 offset + block->fd_offset);
                 } else {
                     flags |= MAP_ANONYMOUS;
-                    area = mmap(vaddr, length, prot, flags, -1, 0);
+                    area = mmap(vaddr, page_size, prot, flags, -1, 0);
                 }
                 if (area != vaddr) {
-                    error_report("Could not remap addr: "
-                                 RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
-                                 length, addr);
+                    error_report("Could not remap RAM %s:%" PRIx64 "+%" PRIx64
+                                 " +%zx", block->idstr, offset,
+                                 block->fd_offset, page_size);
                     exit(1);
                 }
-                memory_try_enable_merging(vaddr, length);
-                qemu_ram_setup_dump(vaddr, length);
+                memory_try_enable_merging(vaddr, page_size);
+                qemu_ram_setup_dump(vaddr, page_size);
             }
+
+            break;
         }
     }
 }
-- 
2.43.5


