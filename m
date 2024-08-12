Return-Path: <kvm+bounces-23890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 083B094F9AB
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:37:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 896731F22BD6
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEE231990A5;
	Mon, 12 Aug 2024 22:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cDqWVUtu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DGP/e4re"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672B0198A15;
	Mon, 12 Aug 2024 22:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502227; cv=fail; b=E+7i9Nc5k0yafe2zlxB3Br7LGMTs9KTeJF2uBoiZAUfI7CwazhPmKiXAHScVIchXZ5pRVWRDd6FqntUS7CY5zYhm17idQo0L4Aizo8uGLz7JwfHvBY9frRtjjC27KeFrXhSB6ZvuMHnL3MT2pMUT7V1lva7Hk8PXQ5SIoAjwZsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502227; c=relaxed/simple;
	bh=H1agAs1VwR7iC3YNAYgEiAr47n8s7hbOjunpouSJQyI=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=r+LvQ8sFxpkIi2tR8CRJj2XlCIHR/G2zyOti8x4ZQ90Q61wWYkp5R0boC0ys31wkafqAi3KdIAuFVY+N32UsVh3Xtu9c9I4YTpBMX6M97XJYmUBKTJuRRrD7m10/gBEQNJFRwSdiCIPP4fp5ZrsbZV58q4npQAD61voA4uteAy4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cDqWVUtu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DGP/e4re; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7JMx011553;
	Mon, 12 Aug 2024 22:35:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	references:from:to:cc:subject:in-reply-to:date:message-id
	:content-type:mime-version; s=corp-2023-11-20; bh=GaI8Jw0ZxvFJQh
	99DgtSj0eHYVe7+vdNe2levskh+bs=; b=cDqWVUtunJtTUaYOWfRtult83Utkfp
	EI6g6QKUVFKijQOiKqfz2wgtfL6vvvPsq2SoTfV3fTHwY4PqodvxNG8ParLYCE/Y
	Ios6WzSbThtyDB6tEfnudlPN+FCbAIz18R1TTSfakhYtHFsHQOMROA0ZhOwahjqp
	vLgOOb+pcswjcNG7hMsMo3wIlJd9bRDfVZ1gQ2tKP0R7aFwa4g/28ct7VXj97tzZ
	gMlBRcKZZ+GdJoy4gOW6Giv0iqHed5noivZPPS1RqWJXG0Ak7sXEpcMAuEj6XulZ
	jwimPuLoUbYRyK9gWFjL0ILp0pw7uTf8j3dJegiKtapWot/kibZSdf0w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wyttcrqh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:35:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CKKwr2021105;
	Mon, 12 Aug 2024 22:35:57 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxne9dj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:35:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ALzwHE/8POIyA99ZpDSOLsBs8MqgLyZeiG2sUyQDdrAcpqeJlzkN1Z7f/DXgs1yLX+Nv0iqadB5VKScNkmLEzhW2jSBBOw3wKtFUKnoet6M9IRPIDbwfUrVv6olcS9KTfWIxJGl1eN8itdnsamnuh1RA3SzAJfkMUfWl7zbLpkXfnzbfDLAEm/KIe01+zO186ST1xqTI8OICHjA5h5OS6mC9t0CtTUbyThXTnMKgUKtc5ESxF8O/rNPc83//hCAEcIovdphpPQAllvcIvzvsiJw5JcQfy3QGkq6Mpyqo8IZWt/4bbkW/87kepiMuq0PifrcqqAfHIVSZs9qdKLfzgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GaI8Jw0ZxvFJQh99DgtSj0eHYVe7+vdNe2levskh+bs=;
 b=mxmDSu0vStvNGmMpiYuMBoxWpxf6TdNDNoZiOYSWpbsj4GqcFX9MPshAhNBxbFoCPULyXgY6auV2doxDB2xzkzIgBAQlF0yYk5VFGTIXaBj2olwbz6G4UH0EJPr29xF0GcZssci0cDQnL5AYEl+jVtRZW3HrlZ/0NuxW0knzqQ2QdGg+ebZ1j/nSsB2p7er7t3PU4P8l6Szdr/41OWR2z5tWqb5vp9kkVSiTlJa2M2g63lxYVnEZlKqV6lBmnn9C2iMHsK6vxTRx4ntk28Jymd0Nrz+MFmwPh7qCgjpF7iJreFgJF1wDlo33mS0o4mjS3nqjiT4vfj49sKizE871Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GaI8Jw0ZxvFJQh99DgtSj0eHYVe7+vdNe2levskh+bs=;
 b=DGP/e4reJmE4hs/EZCnOWvmAV9wqaK0KC25AIRsIXGeQRMr9vNfVX5b/LtouxIfeVb88qmi+fr04j0PynHPxQlPQezrTfJHKjiWRwVFSDHErxiFSJZIaVBl1hi+D3cJeS1bNvtlQOwON6PbJZ6YtQCwDEJInNh8Z7lHAyAuZK9o=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 SJ0PR10MB5718.namprd10.prod.outlook.com (2603:10b6:a03:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.13; Mon, 12 Aug
 2024 22:35:54 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%4]) with mapi id 15.20.7875.012; Mon, 12 Aug 2024
 22:35:53 +0000
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726201332.626395-2-ankur.a.arora@oracle.com>
 <29534bd1-1628-e0fb-eb81-6b789133ff43@gentwo.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com,
        misono.tomohiro@fujitsu.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v6 01/10] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
In-reply-to: <29534bd1-1628-e0fb-eb81-6b789133ff43@gentwo.org>
Date: Mon, 12 Aug 2024 15:35:49 -0700
Message-ID: <87bk1xs722.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0007.prod.exchangelabs.com (2603:10b6:208:10c::20)
 To DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|SJ0PR10MB5718:EE_
X-MS-Office365-Filtering-Correlation-Id: 17c96509-9145-436d-868f-08dcbb1f1f26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7vbdqOoPHZ2nNNvTDbIkoY3b5VOa3LBGvyJGouF6DodhHxMIqyjBLi75/xwb?=
 =?us-ascii?Q?B8d0B9ttQJVEdQQh04uNrTfSAaqKSvIivlLPsFlnOe4WaEr+TJ85xEfENM9r?=
 =?us-ascii?Q?WwdkBKt+UN1LVU6Wv0/lVraCyKiDQl1NYKrxSi453216+X59jCvLAuSvKAB6?=
 =?us-ascii?Q?H8mKTgk+ULMsrJWo5Xjto6LbxJpUU6sV2E2Nq8WwKFbFDHiwxFv5UWbbcpKL?=
 =?us-ascii?Q?ckxscP3qwHuOVy63G+VDw55USru31atSx6zMPzSJf6tsL5JPw/GXsqpivl6d?=
 =?us-ascii?Q?Mp8XkNcIanRoh3hyestmL08Vg04qnnchXgBYE7Q0HPhhs1Cvni/G4xulzQtd?=
 =?us-ascii?Q?cdIYeT16dS0uCvuJgHpuRxE+HJ8ZjynpRKbjfx2Z44Gcd5BndEUEY49CjZRe?=
 =?us-ascii?Q?3Klz21si/e/kuyyxfQkHhJ7PZYU0lFpXQHhO2mPTVZqYniH+WS0Zxb/tHQOT?=
 =?us-ascii?Q?LOg8jfDp9xrO4uvqdYdSueRYclDiTUm4bMnIEYmkAc/AQj5Z33rUOY0mTKJ+?=
 =?us-ascii?Q?6kCwKhas0+wbc8vdURG8/7LLj6JXndjSzOYBy3zxroBGu/VqcLtOI6Pltd5P?=
 =?us-ascii?Q?DxknXhdKtz3i0U6AHEgmZXyRFU/YcTZ+jMnyG4VSxISkp11KbbdsrCOyGih+?=
 =?us-ascii?Q?tJ0MXGUiK1v8Mlk2vdrVpmUB/1ayxCO9okut2y1HONcWfHm0wEqZshnZax6X?=
 =?us-ascii?Q?b52Iy/XkhDJBnbY9dqHS1dIPnhV28hZgffKB0kPnPbOzDHUgAv4YcF0i4xgi?=
 =?us-ascii?Q?6I9nmdAcgTXuhxBPMsDyfAD4q5nv2qb9/eUKizn5sczOd7Ctyi4gelnSPoX2?=
 =?us-ascii?Q?ZYwGr+W9tSRWSHsN8Rq0oyb7PMbtb+dr9ZYeLiD1+Kh35B9IqOnFipW8g2K+?=
 =?us-ascii?Q?rZccNBvyX/WePC1VkNCIVOkBYnHQitWMRIDr5Dy7eSk7B/op/QfAeSMO1K1Q?=
 =?us-ascii?Q?Tr6gIWb//i79rh1/rt778Y51pncBwSUPB5/FY1CF/gTYKU5cNj3FajaMlEiC?=
 =?us-ascii?Q?EoQTpuRI8P2xWvgRDa0CNfk1PnLEWcImPGZroBFwC3YhP/hdhxkx76fF8Gv4?=
 =?us-ascii?Q?61ZwnzVBve6lUWbZLVqaCu5N6jbFd6qnhJCWQCjlv+tptf6xgAPxTArrm5iY?=
 =?us-ascii?Q?wl4xcAQNniXUQv4oMUbmQ2RhObNa4qkHfyvOGzEY5DSeITHpxZoNf6XZtAJ/?=
 =?us-ascii?Q?vVCwDW4fhsg0lpDF7VrRQ5NGZZIr0XlqJ6wZyQN1Rwe8MLWhTII6o+TZ1hHy?=
 =?us-ascii?Q?ZRuRc4TdGQ/21PQF57eZjNVaBQYbuLR/ug2j/bKUYoQMRmqMxWVjd8TiqrDJ?=
 =?us-ascii?Q?w1vtF1LRIPEDiKK4jZtN+kH3+kgTtMJlCAjCDOL0P2xeLA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VqZrgDO4ibt1xZiLzREPS/tB7TDV04tJYDx27teCYmsKBUaonf1A0StQAI7V?=
 =?us-ascii?Q?jEfy1Huq82kUzrbReECyRYKIAF2yZAGL4Wzvls9FUM73TaRX53Qc4CN5gcqK?=
 =?us-ascii?Q?dKNnTMDqh+hvWXz3IKeLDkzBYZveYtown9O78K6usvaOBSU9WSCpe0DSVi+3?=
 =?us-ascii?Q?XLIqCfrG/h697MxBkrgOlrRoASWbx6gUnLClkRn5/FeuRUkWZetT34sV7zNR?=
 =?us-ascii?Q?/p0F1PfFmkZZNVmUjCJgyw6WCnUX/f19+gI9KuoML3sCzN82A8UvJ4RjbyqA?=
 =?us-ascii?Q?v9gZ29NWM0fU9yn6bd0Uha4xJ5BGLLXvStOGrF0CusBa2YzP5hnJ9InDGz9R?=
 =?us-ascii?Q?2lrhz96ZRREGtWTpDQ3bwq6B813hQZSvD3bO24bggUocD6TzBpLHQAcjovvG?=
 =?us-ascii?Q?kTZeFBiXCGO9xef9QnJWafW5lMmyTwvb1tn5yB7mCqMNL64N9XFMF48mZuvb?=
 =?us-ascii?Q?98K52Hj6B20BEJfH0wOB6aw1jJjgYLOCoM85mnPM8cTjy/vTpUCq87t5X5Zw?=
 =?us-ascii?Q?FAE1leIwOhsaQdfb2QZNpdTGPczlXLohgvaXyU/8UysI14V+Jb07ZQc58lny?=
 =?us-ascii?Q?LSFsW7iS02tYMM5oNY7HJ2SgTEPNcR4mDu1ZD8xAnNrIQKqCZgRV8CEzkezH?=
 =?us-ascii?Q?sz1nsQLCMfrdNXQeVj5wQtMbb6v2D4zefkGV5swHEJQU82o2gE0X45chfFf9?=
 =?us-ascii?Q?gqTfN88qmwDsf40+4ddk81NF5w+KjvUuF8LswYixVuWpago7gnCDVbCS9e47?=
 =?us-ascii?Q?o+oioLx0YtvoK9Tb8qGrbzWaoPLbyDm1oY+bmi0q4fbOn57cJ9ab1eYwqR9N?=
 =?us-ascii?Q?gmdXlXO1biZ/jhrR7M6a2TnbovYYRxsGiG/fSGM6ZHnJ/XOuFNLJWo2VDAGu?=
 =?us-ascii?Q?uunPxcVW34J1MQ/R7VZ5sGFQFpqTU08Zhxum7IyAyPxDWvSBkTyT+jyGaPP2?=
 =?us-ascii?Q?3tj0J6imUhSyAzHmttfCgcUvrAGre1Y83I+jkm3Mxfvpj+L1B3QoGpHdPmVL?=
 =?us-ascii?Q?evdXnI3L4yKqUMEOnVpv5/hHJLa87+AWPunD+WDVZe12nY6mbDhPLNmdLCpm?=
 =?us-ascii?Q?yaI8IhlDMzC46TtpktFNXCq+sjOM3yOM+nZORYo2bs4w559Ix+jqyGl2BuH/?=
 =?us-ascii?Q?G/AD903+Pxn9YLOM9Po55R1EOTG3jIkhLkwhvjLiOOsVqtsXrnDaVmgIRa5a?=
 =?us-ascii?Q?GN6Akp7e5aXu2lUqwejsYY9Wz3iVbBh6WGCQSDXVmCpOcGU1+ETx4lVp8Qo7?=
 =?us-ascii?Q?LVGk+Glmvn7DZnUcXPbHhBFP2aAI5ILhhezUtMIUhhVJjjgIMgrg/48fooxG?=
 =?us-ascii?Q?Jr7/wcPktrcRRLtZnbCaBaLKq9XmwiiJEAZwoG33mzQIHyqD9iqmk5pUcReA?=
 =?us-ascii?Q?VgC57JonIqMxL1/wr9HURpqPobyg8+dfv1so6Fqu+II6vMzUlmQNgSS2X825?=
 =?us-ascii?Q?Q4ZmqYU+nakwUOB7Tmqs98okCArrnGsxpai2X5GucXKdmgh1ej59LyLfGjMt?=
 =?us-ascii?Q?Enwco1rj3PMP2BlXPjezW4KHj80CCrVQkzQEntfu/ipW+/Q1dZ5szo7W47Nc?=
 =?us-ascii?Q?uFZpKqx6URubluZIN7IrDzVbfkNBuRSY4hbCbcOS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TdqhuDtyzK1RB0fcIBd7e0UhS2yTMbh/phJ4R1WU4ZwYPx3RiFTyGEO+iH9s0586AJEScxaoD1esBrRe43RvT5SBUDq76ZAOmqh63Q5SOpwSWRLpB77vb3OC8mNFOc0tG062p+ETsfRxk1LnCfCIzwe21xBCVCt1oLsuPo/Pm8RGDeNq7WnekEbgoD5P/iCaQHvn3oHxTaSgrctHv+rtQeyDr+KogPN5GOw7muE4hx31Gbdr/nc5wC+AoZ+1MeP4ZR0frIvVpx1K2p2uckTiNMwiijmysmEpTL1Cn74JPYiZlu/kJQ7YqqFPYd4stJadNIg2MVbjXf6YS1BK0U9pjyfDUuRKaO83HNsKnGZ+2hcm9IhcM/ieuSpMCHEfx24Bq7aqwLaSv78kg3falVR8a06350pjSDWrbp2sQiWW2ORTD9wiT1qFWE9WedvNE3ui0LJPTJ/f33j4AxsxODfMdDSIRjUmrGoPSMWolqPTEAmfP8EGWHeghTacyvIbvCEOQhDQNuyn/tsvtc6TRbKkU3ZqSgdRBcyY6XsD66Ye53hgeekJDePx3u4YOcQPGQu/M/oGx/LBDZt2nNIdm5njjqUKuxo7dBwaRChhG0WOozo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17c96509-9145-436d-868f-08dcbb1f1f26
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 22:35:53.3388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rr4mExY+cVLA27C+/QSnYSLL2673LH+RW010rvqdxmVL1sfioeUKlBDTRlF+ParClvvib2WlPY5D5IHOS/Z2tpvk2nY0r6EFaGn0043Zc9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408120166
X-Proofpoint-ORIG-GUID: Pc4YUPIsgzZ5bKWgeMHRDDDyoGZss9IX
X-Proofpoint-GUID: Pc4YUPIsgzZ5bKWgeMHRDDDyoGZss9IX


Christoph Lameter (Ampere) <cl@gentwo.org> writes:

> On Fri, 26 Jul 2024, Ankur Arora wrote:
>
>> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
>> index 9b6d90a72601..532e4ed19e0f 100644
>> --- a/drivers/cpuidle/poll_state.c
>> +++ b/drivers/cpuidle/poll_state.c
>> @@ -21,21 +21,21 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>>
>> 	raw_local_irq_enable();
>> 	if (!current_set_polling_and_test()) {
>> -		unsigned int loop_count = 0;
>> +		unsigned int loop_count;
>> 		u64 limit;
>
> loop_count is only used in the while loop below. So the declaration could be
> placed below the while.

That's a good idea. Will fix.

>>
>> 		limit = cpuidle_poll_time(drv, dev);
>>
>> 		while (!need_resched()) {
>> -			cpu_relax();
>> -			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
>> -				continue;
>> -
>> 			loop_count = 0;
>> 			if (local_clock_noinstr() - time_start > limit) {
>> 				dev->poll_time_limit = true;
>> 				break;
>> 			}
>
> Looks ok otherwise
>
> Reviewed-by: Christoph Lameter <cl@linux.com>

Thanks for the review.

--
ankur

