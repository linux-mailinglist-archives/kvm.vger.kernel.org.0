Return-Path: <kvm+bounces-40872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D342A5EB1B
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 650173B2848
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 05:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BF9B1FAC4A;
	Thu, 13 Mar 2025 05:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EiUnOdWX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sIQiBBDB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FD01F91E3
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741843370; cv=fail; b=Kdr3KO2+35XswHx1+jP81SsU7jIjaotV1Ob6hWO/Rjb+6zJyOFpjy1mukeS5HojVy3gY06xK7zuJL64wMl4xIPhT4nHfjDrtm1FN6HBwgwJuvCgprAK342tl32t3U+7lEbjtdsdG6mT7cwWrUZVAeRYlsB2lZ+wO5R3+s5aeiCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741843370; c=relaxed/simple;
	bh=dvHyv0cZFtxy8xHH2BYbH3lu5IpmWIk/STtUYJ6fWfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NrmW5uXCMJkrK7jeMlj9k1pTQ3Bt+A5pl7UK6cBHATW7C8NzDIavaYqWgYLhvYDgu9xICBttXyk3PLEUJ/f5RfDJ+UIle7kp85G0035SrVE1qZQ6nEUJ7I7YFlowP8+QwBXD0w1AozJyvlA+5onzlARun/HB/YCo1cZQw+Fte1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EiUnOdWX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sIQiBBDB; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3tkuN011499;
	Thu, 13 Mar 2025 05:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=0/MHOLNF8xYhRI2n3JY2gUGqgYW8aASMA044TZvicgk=; b=
	EiUnOdWXL0uCadVdN0BOoTwQp7frKwhJHReZ3szkqp5NB2czRtaPq0lnAYX3Eaj1
	h4JX9+Y7rbUKOwj1KGtLCIrbCI9JmtScv+e8t0ivqGWkKh4YUlCAGoxz/MuKUBJu
	nsCKqPEuB3f07OeTmXmpLu4xldOjpRIIa4SRPbPidXXLV4Rj4f9+cg1yL4gPuciA
	G0ODH1wnAzLKjbh1yUBjtx9ROnd35Is8U4xLGF4e955JuUfPTqlUpaYXdklBQgyE
	dd2jjveCqZxX+TWbS3qBMivJjVeWGwoQXoJr9XVbPftrnBnd997tK7pyP9HlZ3Ph
	rGbPXi/t7exkcImbr4XM3Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4hbedy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52D43sND012355;
	Thu, 13 Mar 2025 05:22:35 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2043.outbound.protection.outlook.com [104.47.58.43])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45atn272pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eiVSBzc3/t+cc0bTWJR00I4z5bWyOwqU1EgWG5zuXJCtoWDpWb4z1fUn7p+K6L5AqwOV/Uqafdcsvif4anT6Hyw77ukHehpJSMXRlI6CnmPMe3G+kiWpitXwWrlUrO6e4COP531ryCxjW9NCzoUZNP52uc37uuDoxAx1j+lUrmFGOhejhyEH+A4NJpO9hGthw44pvfPG4LUYWhGNkwE0TfUPKmjCmw2yLA21In52rxi0CSwo5LiDjQyPC1uSEkgXycImBaP9f6FE7GhSZjv+rKpVUWCQgJ0H1CbBJFK2dDDrBr/UFCdbwKAGNKj50QK8XG6MRoLXUcJR6JXmJXv0+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/MHOLNF8xYhRI2n3JY2gUGqgYW8aASMA044TZvicgk=;
 b=rbheR9KJ1IT5+lMOyJ6rwHo+FIsmSg0+7CaYtrpuH0Xegivp+DW850iIG9/1eKOTbWwo1uFKt4W+X6V2ZTmqvaa970zBo0bs9JwB30mYgzLtVTN2zbXpEs9kLg1TtK55P+hwEs5DI0BSXczZ4AzOs4rp0mGmlat6MwGIdp9QJ9gaZRU1hmdB0WBjqfj6R7wa0yJIRlEca3sGmmpmu6nu8ZMvbD2GHM3ax69KTGST5Mdq6aDAduFIS0bFQ/YMcgUWoPRHy4VFOw0KEFSapFvhLwn5uu12fHPkFR/h25om1aRscRqZtI76IzIw0hUDBGtntH5HccJKUXrgoRjzL4xBRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/MHOLNF8xYhRI2n3JY2gUGqgYW8aASMA044TZvicgk=;
 b=sIQiBBDBLukldiuIH9DIms1eljYKZiF3hBvNfFch4mDQhmyz1Qdd0E/K//EFlOTeTx3d9SFe0KEkiIxqD7qPZNoLcjxFJxChXomKTdtg7JKqYHPPN8uBgZXUx3UO2tlx74+Bko1dk4d+uy+HhMYjzXPJNcPr8JnGIT4MkeRGv/Y=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6724.namprd10.prod.outlook.com (2603:10b6:208:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Thu, 13 Mar
 2025 05:22:33 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 05:22:33 +0000
From: Mike Christie <michael.christie@oracle.com>
To: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 05/11] nvmet: Add function to print trtype
Date: Thu, 13 Mar 2025 00:18:06 -0500
Message-ID: <20250313052222.178524-6-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313052222.178524-1-michael.christie@oracle.com>
References: <20250313052222.178524-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0045.namprd07.prod.outlook.com
 (2603:10b6:610:5b::19) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: da78177d-c4f9-4712-1fbf-08dd61ef0f04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KA5H3f7mwHkz7322WpCBo+6+5rxNjvpcT5Mupj/DwjLEla2mkfmb6ZiXa5mr?=
 =?us-ascii?Q?o5WuZtTny1qRbwQ7rIyap4kRN4WZVfdZ3IisOSU5wCnwgT3o35ozvdBjJ3NM?=
 =?us-ascii?Q?wRVpR72JcfayJkn6YUbve78K0cnwLug8uB51Dx4uUXcuFLueZISRcwTAHcnI?=
 =?us-ascii?Q?2VHmjtuURw1fwZ9WjzGs6h6LBgWsqy7UUBmPtBPLBQXpiScwqLXLp3O0kBrF?=
 =?us-ascii?Q?X8oM7de4/93+wBp95XuOQ9m+7j3IJCHFtyomGxRZp6GxVHup2CeCrt98uwgS?=
 =?us-ascii?Q?+RBzRBApoJu4NnEfm/Afu0N+6PzNo+I5qxVsrsNLbfXqsWgxuq2u0rl5pSLv?=
 =?us-ascii?Q?bjoIpAJsKGJZqJe1nFehb+ae3bmpbMdVmzNW79xeeXUtpxF1rwd0h59a/kL5?=
 =?us-ascii?Q?LlLYadcUcFzELSJyVENmDJPKuq+BfOOrIDjDIFmMpub0cdMiE0vDJAgjo6rb?=
 =?us-ascii?Q?LGtXbleKg47jzEulQDm/qQzwCRXwLP2YasMPuPi7Ty3VwiEeVLb6LoczG/S5?=
 =?us-ascii?Q?NNZwuglYhYmzy7MkwMK+y1PXIRfyQwDkBSUVG2M2enrCHErrZiRcmIaIm7h7?=
 =?us-ascii?Q?8cume0bp95wa6sC4CW7yV+UkzAHy+AJuXu36Dl8D5AvlaxRwrNkWOF1nKPHZ?=
 =?us-ascii?Q?jWdH/CV5lxzJqAhIzQABLqdpNKaTJQ8ikB1Gg6ZLm7Sl7vXNEZzeUgMZQEcF?=
 =?us-ascii?Q?ntAHHR3BEq8XRfXhdthR4Xh9GJdBAwmI8Gg3W06NCE0a23PvHfThFHP90Sw4?=
 =?us-ascii?Q?M8Or+8DaXrJ4w0kTCUHuZQZhCGBt4DiTkdXo3xj9JRg4iJtBg5CeSb7/DRGa?=
 =?us-ascii?Q?lQskwKZDyBN13h2x2NkgVmZf5tGziLa1gI8bxPSCerKItew/B9wQb7LQll2y?=
 =?us-ascii?Q?UHd+QkwoZF1q7JS4YRXJlo18Z4ujtRZQtKalz092is88nuHkFfNdhB4uSI0F?=
 =?us-ascii?Q?GNUpx/7EkYO+PMSzC3BtWwZOo4ILqRYWDQqFdZVAaXXRVtT9uOzZA+eFE4Qp?=
 =?us-ascii?Q?ZswLh2goGOCVnj5IALT1QjRluII+1MVm6ytOLSWJMz/ZTxMQP1ClJdl/hrxn?=
 =?us-ascii?Q?ZAvFo/C23IoyBPAVLfjYjjgYMWD9HoEDx8RmCELJpIL1TGPscwx+mL7wI0W2?=
 =?us-ascii?Q?QYarnnBI1Ay6T6TOqdkFw45HMA5tKrNJF0cDOY20XoVldynvXWDPXalM1UWt?=
 =?us-ascii?Q?WLu0KJG2dOCju4vnVxVITwa2929UatIkmKjsFrg1zL2PiisAIaXztucIN5WQ?=
 =?us-ascii?Q?BsDTYbjAGBSRc2ayn++BHk82gW2OCTkrG4Cd2Ac6O3cGeBCr7pRxjmWtEO+C?=
 =?us-ascii?Q?AI1XieAvy100RThTQ+tkDqXPjQQrYh3MZyL4FxFovleLNMWfCO9433XhJjw3?=
 =?us-ascii?Q?1Kl+0XtbhFqsFSO40EL+PGMuXCKBPvAoBDyfmCrm8rBYuFyN4PxcyqGwiZYh?=
 =?us-ascii?Q?mmVfY3qAcrU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ERwomIojeL6oZ63/+6cfW27P2J2hKX5vdewM41VM5/2d2v4tI/Q8wVVf84gd?=
 =?us-ascii?Q?/TL+6l9qqOONrAfMUyMKVuF665IrzMS0Ssb3kftxxfRA1dNojkvI68Cgqv27?=
 =?us-ascii?Q?D8Tw5Ao0g3yqtu4FrJSiJCfCN0GcZ6CbXJ+kFFXTk5NV913eH46wYfgOc8Y3?=
 =?us-ascii?Q?WJ7GzQA8LeLMg5CPzkl6ynJXRDFl4LITGbqwz36pfhyMf6gjwczVLeNojkv9?=
 =?us-ascii?Q?LZ4CZoUDVIBXGg0s47bs37WNr4JZkZIv3XFsGqN1VLnUaF2w40QAUltC26sL?=
 =?us-ascii?Q?u1l42p+yWVGwesV09bO0SmorV0l7clemQ071BpigHASM1aTdHRu4w3/UWvHy?=
 =?us-ascii?Q?gZxJs0lRq7Ubbcv5qm2a4kWA8S+4Kzvb5sQemDnswVSJjKVy492aLoVks/I9?=
 =?us-ascii?Q?9yUxlqT7UyThw8Rx58G2laCJmCx8ETRFA42UzKonAd89L/v0oFNSbb2Zp76V?=
 =?us-ascii?Q?BaOYCbaA6bamt49ohu1qpUCVXtsAvDlXnS2nh/342uyP5Q8MAuSH5flNmnO2?=
 =?us-ascii?Q?vf+aw+2oJkKvvFiRa+akalFa8OkMK92t7ufdKvWIR2+dl23XmwsawfzlXkCM?=
 =?us-ascii?Q?LE3ptS0z9WaADUM5fxVa0dLpZjkvq8E6Tb5faC5hdXR1elH6yaMDw9l1Wb0y?=
 =?us-ascii?Q?4BI11Da4BJ89UJqm8xNWSY5kt/75d3ymIVMtk6SSwsHxM/FhgeDr18adhyBD?=
 =?us-ascii?Q?xRsZZYkvUer5uyl23ZYzVC/6PbSKNoLpidjMfVyE7TEHDJVibrH/frhZdFEC?=
 =?us-ascii?Q?tshBy2kKGBdpD5p5pYbKdHiQ76urlDMCynU6wksTJ3i8JGaRUwBVExvQkR0T?=
 =?us-ascii?Q?/LOieDX5Nu+C4U/kWdt0HeaBBJ1htarclaryaUnvREoKJf9IA1rlVxfoIF7/?=
 =?us-ascii?Q?xTjqzpaa9jQ3IUtpV8B20VEXLs9VLkAtJnQ8sGgrFMOb/drN1oorgOyYhiFW?=
 =?us-ascii?Q?og/s8P8mdE2KdsclIrfTm24TXwhY4Atj+I6CAnqAsrH+p0u/g+f3OJ3LmBXF?=
 =?us-ascii?Q?PxjRhwH24z/4yj4pX9fcGsXivevuZeTwmG8BWBRMUQ4y2vC3zm8HkiKaesEr?=
 =?us-ascii?Q?cP0VjHbLzo+npiBJWFOTsfE+K3Lx6k6b86bJWvBWJl87Mh+ApIPOBb+xW/uL?=
 =?us-ascii?Q?fjqYv5i4nhNcQ/zs2lpqTuoKyWCD/vIvZ3omPbfInRUfgZVBXF1BP7wZCp+d?=
 =?us-ascii?Q?A+TVHl1VnW1nwD2ngA9Itn6awlHHEWlJPHhpar/Hqc+k2Jgk4zUntMIdTrOi?=
 =?us-ascii?Q?cOgiJQwGnCg752Fv57cZ5Bc9RuAv/Jk9PaFRUkByT801ZpkvGUUC+NW2r8YB?=
 =?us-ascii?Q?ZrOFP8gZEHwdySWmFTWzdHs+aBvY27ZhMsJcnowcl9Mecv0UCrQjBIqMr9J2?=
 =?us-ascii?Q?oPKxU7cH9zv4PTlYvtFR8QaNW5mMJFf3zzF2QSa4GXVAMr2kqdlRSvcYBRe+?=
 =?us-ascii?Q?8C6vXAiuPGQjMIm9sDDlFBtjZ/LLa8ucQqBNhA5LA5EpPILE0FatxxEDAbyT?=
 =?us-ascii?Q?nLuBnCkXwR8kjIZ4Xy6hKNAmFkRQFy5ymNiil9xEm6HTeTtE+TPFsQ+/bB5M?=
 =?us-ascii?Q?FBrvZo7kCuqOypFvDjjIG1lJIMlWQwIACJHH9OjmTe6tyAiY7z1NMc9WTnj7?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UaMkxERpksyrE9c8TIZUVFH0ROiRtPl6atqhEEQ/jThcO88o6GbNolEcReKJT3Lf1rG5iIJZTOHWSQuSKMvIHWbtNBh7FDHBoJ1/+dvSBnOS8t2OWowVpMR0huWexZ1792TAr8OcsQmlT4Ap4Qf590nWV17FQ8Gy9HFaA61LkAnoNRqizpCaVEpWCaK9nEAAvnyfjQfPRCLPVZGjqVOldLqO3L8YyB5M9wXQpB68VAXVeGLUJ6HXLoC/vZ5Hto1EcJ5Z/OQs7Fwqt/IIxOftNC7uGPqwYumVrRsNdxuU+Zwju4kQTSWcOQZK14eTFvwgRtAZx/V+L+HizEGAmHpPfSRga3sWXmv/aqJlh9w2Skv6puKdNf+qQB4WZDq0p7U4WtqAwwO+bLCDsjubajdrFWBnm5QoJgYxrSgtOAgW7nQ02iqxe7r1+oarpW7G3/NgXVe0+q3MaXZzKtyTCny7J5bqOF7/EpQLUeHkutxxXoFksNybyzQr/ecHzzKiJoouBGmSVWbvuwx3sBB60t9dmUysKdKO7KxQTPonxh9BBkujays8CjjDqcbb74Ll3mWydNv4SqqgkPc9HIWWcjtNkXK3d0RcDilCM3PVIWjG+KY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da78177d-c4f9-4712-1fbf-08dd61ef0f04
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 05:22:33.4466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dZS6l1YeICvjqTnUaWuuywpalOVp4pyvYv4nTJza6Gc5A60zHijKgHSRrIJIPMFurXXdVKtjJiEfS+OiVSZel61oksfrlxNTwx0DuLGUAR4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_02,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503130040
X-Proofpoint-GUID: X1DfEgBCqz3iuRmT0dKysGqV-TLV2gBG
X-Proofpoint-ORIG-GUID: X1DfEgBCqz3iuRmT0dKysGqV-TLV2gBG

This adds a helper to print the trtype. It will be used by the
configs controller code.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/target/configfs.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index e44ef69dffc2..896ae65e4918 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -329,14 +329,12 @@ static ssize_t nvmet_param_pi_enable_store(struct config_item *item,
 CONFIGFS_ATTR(nvmet_, param_pi_enable);
 #endif
 
-static ssize_t nvmet_addr_trtype_show(struct config_item *item,
-		char *page)
+static ssize_t nvmet_trtype_show(int trtype, char *page)
 {
-	struct nvmet_port *port = to_nvmet_port(item);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(nvmet_transport); i++) {
-		if (port->disc_addr.trtype == nvmet_transport[i].type)
+		if (trtype == nvmet_transport[i].type)
 			return snprintf(page, PAGE_SIZE,
 					"%s\n", nvmet_transport[i].name);
 	}
@@ -344,6 +342,14 @@ static ssize_t nvmet_addr_trtype_show(struct config_item *item,
 	return sprintf(page, "\n");
 }
 
+static ssize_t nvmet_addr_trtype_show(struct config_item *item,
+		char *page)
+{
+	struct nvmet_port *port = to_nvmet_port(item);
+
+	return nvmet_trtype_show(port->disc_addr.trtype, page);
+}
+
 static void nvmet_port_init_tsas_rdma(struct nvmet_port *port)
 {
 	port->disc_addr.tsas.rdma.qptype = NVMF_RDMA_QPTYPE_CONNECTED;
-- 
2.43.0


