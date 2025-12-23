Return-Path: <kvm+bounces-66595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 29E6ACD819F
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:09:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7FECB3094D9F
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BA362F1FCF;
	Tue, 23 Dec 2025 05:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="gFKAuqqf";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="r56UEMG2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CDB2F6164
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 05:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466309; cv=fail; b=RzmrWPTXnnpZL5fOb0pEKHdL0aeUMcWuVlKM2isMW7x64FepGuWT11d5SnU5jAFaV1VTXxu5Qfz5mVjWcGeLRQ0/PHVzhxKKHYpzJWIfef8VJiAVieMQEF73HyjWYiZPlSPVz4L1Qv5epELOFvNT0uKIHKZSnyAaGRNmPy6FhNA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466309; c=relaxed/simple;
	bh=hNVgX2gBUXUW+m5WJmbzvIfT9ciXxwdFUs/RewOPVRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LIlh3eDLrrxoY7bjl6e3Qqt1fgDREIzjZsva8M5Pfog51slCrYGcyUBVpPCcPqtH4vO9cpWIAwWlZXrkgJ3sIA+v3Pu5WJc3sXs3xUVsWzO0PM9OPPpda3UYLwg9WLdDWO8USd9+51bq9B7F73AtsHn1BxU/Q3vNPwnutyXnnRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=gFKAuqqf; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=r56UEMG2; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN1Loab733160;
	Mon, 22 Dec 2025 21:05:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=CZdD1LIi92Hnc30afDdZU8oM6avXjWyR+gOyhOJxO
	ps=; b=gFKAuqqf29LUvDAl2IgqszLF1f7gaviSRq/9Goqn1pTX2D/5XeKViqJak
	9TdOgqogCLEg8zH3wYQT3ghaDNjRDZwRxgYhb9OQYj18RVERfFYIaI8qm8KP+Szy
	KREaho1TeAk/UJ417u1rWnf7bsySK14sLHEHSClNEnES/h+KuJ2H6xNXe4IkNkHN
	VT4lMeity0/WWjZPCYbrxnQbaChL8+5TuRmGoZzgd3Mj0/JSaOMa6Sn/Ig1Des/t
	xtdWm4CVSSF7KEM9tsrQRhEwJLfc7M+H1piFam5p+RAfDEDxRyIi7i3+KVFq2LSN
	xu0fui3/rjiqSRd1pTbGsgG4iy+tw==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020112.outbound.protection.outlook.com [52.101.201.112])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5t77cxqc-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:05:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d4z4eTT0XmaYTXE1bncPjJ0gnzmVJwxNWA8zGO2qMDe0Cg7/82KT3X7QeuvW2Na8Z12lrA5I9JHtK30LMoSVfUnPW+mJLbYVzpxKKNuQ/1VD7HsEIxhrIm5KW/o950SbUPjhyiIGs6fu+nEwrMq0pmqGoRpv/FnjKwgN93YTjS9esFi7lSD/t8OIo4mPitl35uBfN+BiZvGa9YrNHiegoHW/V3e1L9xazf8eyvB+ebV7UqEyT+Qq/d/qxCAqp+y2kiTvE46bfJgEk0tkVXSIWCTSWeS/9tAIje7ucxUc6dfhrSfEkf0w1lmprNrkCMVzhNXhXJshLibrgpzlvILY+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CZdD1LIi92Hnc30afDdZU8oM6avXjWyR+gOyhOJxOps=;
 b=G0Hy7vxyyN9jkXxFTe9qtO6GsSBzajDldh7R48OLIjcNFJ432hytz70zm7IAWv57EMtKucBkdHpi7nvgc7QPCU3pV3tr+x/iSDW4XqnqmRNoWixdwzbsOmTpKI2cIdfLu8KOLNpgiOaRU9nTn9omyrXXsOXwL7qr2zFILLFihywSN23Axdj1mXrFze5JFaozu+iWfV1BvJk7jHnmX1SFKem0qFMHD4LfwLqULJydX2Xf7VD2vAvlUFGcmycRJuQNXLB5VESVUzmUteS6/tFUC/hvRIUmft0U7YmG62NaDW7QVkwfilPFjdXBs4IzXW2NVb4OLPNLNnI7zeYWTE3LXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CZdD1LIi92Hnc30afDdZU8oM6avXjWyR+gOyhOJxOps=;
 b=r56UEMG2sicGsrURs7Apc4ql7tyDD13Par6PiR8ueuOrPfRfY8TfotGt5RxyRg81krpBuiZv/c4oU/Hil95X0ZWYQ6IFvUnqV8lzbsVoEf5BALVnLRuVWt1JOGoAwSHEn90ahMAlyfRb13J8RWrfBePHyJKmZZ2T4vkBtdr14M/TAKkcukeUtbM6Dz7qrtwZTlR/mTJTrl2h5+vPhblxCqgRqig5WHaiRZCl0KN4Icazojcp1PxkfUhbIJcQzkPR4oGOUa1fXFDpSGoScqtpRQoIo4MrLJhrjN/PwxZMiJPzI3vLpu5mSif5hOJoNPEXMPhQl0b5TgZ6PY6G0E1c+Q==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by PH0PR02MB8488.namprd02.prod.outlook.com
 (2603:10b6:510:105::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Tue, 23 Dec
 2025 05:05:01 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:05:01 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 06/10] x86/vmx: update EPT access paddr tests for MBEC support
Date: Mon, 22 Dec 2025 22:48:46 -0700
Message-ID: <20251223054850.1611618-7-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223054850.1611618-1-jon@nutanix.com>
References: <20251223054850.1611618-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::15) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|PH0PR02MB8488:EE_
X-MS-Office365-Filtering-Correlation-Id: f5caaf42-a211-4f3d-4bfc-08de41e0d351
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b4bdExK6i4SE4ACgXbVOFTep6dObYPDZ6BeCx3KAtOOgofueeQEgtAPgU9RJ?=
 =?us-ascii?Q?6MSQGhLNsPAq5AGzohEa0wtBUCBn1NP0shlo8ZdtUlwRdSELbU6DNbLqHiQg?=
 =?us-ascii?Q?0HS6bk6ye57c9gikAvxL2bnG/rPm8dRVUnTH50SzMfrEqBth+RSco5xVKwiA?=
 =?us-ascii?Q?c3nGskPMo86Qe7GynaNRLqsQu2Txg92LVRkFysm7hSPI7TAQa1Rardk0izmD?=
 =?us-ascii?Q?jUzcxi1cDAB2A49kRI5j5mEu9JuR6OIaTi1gLm7e0zrVJj7W1Seg5qz04pzj?=
 =?us-ascii?Q?CLRQPii5SE7xf/z6LrFMXv9YSYSb5D3VZap2XYUKowGlsfmEbfq7M0rtqPDi?=
 =?us-ascii?Q?sQZpIiS2U2JKqxrq62T446pub5Oq3vThaN6icNLOjsZ1NqJOx5GN/svdRXLP?=
 =?us-ascii?Q?MnY8vmgnLzYxjSb5QaWsziPx34BjrGNOLlW+YjK/YhqQ/eQiHW4314WLgoZE?=
 =?us-ascii?Q?aE6dl3bjX6g/bvQYOGisw8+iWDU8pm7Pqt+QnIH9OD2HT0w5pLM7T6+L24H2?=
 =?us-ascii?Q?qh3UFbm96wJgSS1bzKL0JSYcGOiwY9yBbQYMVi8/7qhsQglhZdZDCjtfllAB?=
 =?us-ascii?Q?jFC58SHPsm6bNBBMOX7VZDd8SNt9WUB49qTGSqq9IP0TPfpoPW15STUZ+ZKk?=
 =?us-ascii?Q?xCryqmuHauOF2phzkYNWcC6D2nihiejEDi/XNK2E/8IUkUl4oe+xHCwmT3jB?=
 =?us-ascii?Q?bV4qe3StYaZrEbJF2noQ2Zd3750WqB80JMI2cXreWdv+XrmB4SUSR0BtgwCs?=
 =?us-ascii?Q?BPy3gG4CWP3u9iNPRAqY4EMZmB6COxA2XdYxAzsrQD+HqGJsI3A8JjosM1di?=
 =?us-ascii?Q?xrSXuWl2a+wQRhj6U3e2tHQsV6Pai/gX/iQdUOYAkESBES3mYR5wkmkC5ccS?=
 =?us-ascii?Q?EFHIqKwC/AlQynwP6dRAf/+c/g+RJ+VLCpg3sdbboQ/tTAuDXuh0HOdZ1WJI?=
 =?us-ascii?Q?GDfsKOV90WPr3V+gzSfEgxAT+Yl5zp2RlUonXCO3Bhs8Nxgzp9o2Wl6UYQHS?=
 =?us-ascii?Q?ES1PM+IsxbKqo594IMosgLa4GiMqicoDqu5rKa8UJfDnh1QNH3YnJyyZdN8T?=
 =?us-ascii?Q?RpxAr+ShlSgVE838o5lblotL6J2zO5IyZTKuIzWC6vs+jXvZ11WRQpieQLDF?=
 =?us-ascii?Q?Zl++pvKfdJU8lrDw9KbKwlqb5kJez+XpQKEbw8XjAgEbP1BNDGHziDg7/0c4?=
 =?us-ascii?Q?oyMqUD0Vcc5+ARYN7b1CIQqrfYW1f2tDlK7HttHsgEWs/6n4PhLjCYd9f+4R?=
 =?us-ascii?Q?oFd+0pBt/zpaWPnXm7kjvWnqc0L6WMAr9/9V8Lh1G5ErDkaUEB7KtdoTgDUb?=
 =?us-ascii?Q?nG9H98vZpgayvdr2dbdf1daRy8DAg9rPk3dOWpfKr5ZdmolKHR4cUCOyPgn2?=
 =?us-ascii?Q?VlGB0p3zV9+daU+1xoUsXTAbWxtfzpuW+mDtFOZOTVrRP5xW7E6GQYg/sJX3?=
 =?us-ascii?Q?zT1U7E0NPm5zCDBbRRFTUPYiPfs4noAdaeZ99lTlfPJgh+fI2pJsC7Tpitrb?=
 =?us-ascii?Q?SJcuve9g5O/jZx5mJjeaADDlkGDyaSip56da?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mtV3B3JAkV50KymsPs2pqBLD66ar506oj0lwOd6sVfeJiGwsiQanxuECAdN0?=
 =?us-ascii?Q?G3fvPxK6mjcQsQ1go6grlRhMPdXMLZLBqy0RIHVk1/27eAdW9/Iicco68O9F?=
 =?us-ascii?Q?Qk5tlVHlz3l1hkEy7hGOUVC04dvwbasYbo7XBgDJxx7xy/PNjJ5cfBkWz4XC?=
 =?us-ascii?Q?LfbvuW541Q5KGJ+AQsczElTQqoRYmGgIfE5tPxiQilzt2Mma7AE0cqURnZZT?=
 =?us-ascii?Q?IYKXQGRaSwfRN+n0rtOX1msxhLblPRUSXgwBVt6HW42cXebwU3cNf5IYxLyw?=
 =?us-ascii?Q?fRoMF1cyjivkbbaANVWcAhMigGmGVpsDNjtpVkv3oV/jLM3JdGsc5XTnZh5/?=
 =?us-ascii?Q?vWDa/CV5DXxmZtO0kgLH5l4EC1BCyQhvKcS67PFf7goOcCXjU9zB33SsmdoW?=
 =?us-ascii?Q?SeA1XhzhzAKl12MgG0GpBAHGBkCsSrlEbQddSYSWp0Ffd4gLALgtkz7NZ06R?=
 =?us-ascii?Q?AS+GBUYturs9KM8QsCjPznnVrGZgXVzdaGhCrDdwx3/jdV9PuJtgtW7zx2u3?=
 =?us-ascii?Q?ICKFcyRndApXfkkoQKJk4YP6WYYYFSUEEWgG8ocER9P6XRFgCRx63jPnA7ic?=
 =?us-ascii?Q?nCtP5yevnQhJTXN9VM/sageGQSe7+GkK3Khz938EiDMxFxAE9y9++xmf3fWa?=
 =?us-ascii?Q?MRUVGe5Zsg4J/o1Gdmlltn4KkZoxpHoRb5lIAjE1Wg+GjQ43BLytZc4EUu6x?=
 =?us-ascii?Q?HuYFQwK+GRFJUljsGrhqwx4equhlFUTGki/yQU0P58fUKUlW5B+ioaw+9Vs5?=
 =?us-ascii?Q?dNoOyGJgNlMetRKfPEaVWX6AKGh3NNX2YsYGStGCLg/XblNsY0ofNYv3vXVi?=
 =?us-ascii?Q?hfqLMO6rOR8IiZK3X9K1DpcIZeUFUVTnVphP1enyXsIxLhn+/ywvml5dTW8I?=
 =?us-ascii?Q?tuIYJE9DNEN+66FtZTj+FRlLoHNNIvvNa3shwz2NJL1OvXORwAtdaEhEP2k1?=
 =?us-ascii?Q?X15uY66++lvK0KFdTrKq1o+P1WIcH/CwZ0B/2DJ+E7IYL9+gOw0aa7P65OLp?=
 =?us-ascii?Q?qWcnDvfvmU7pTn6cQNOlgSrhWmt33tpt7eYOGXO/LW+F/iUzoTdwlymNzakY?=
 =?us-ascii?Q?JByw+oaGLCQzabNrCkOXe3iPVqQTbdR1Mry9h7lMC0hQzj3TJIAdoTgbB8C5?=
 =?us-ascii?Q?aWeW4hGDYnTrhUyCAtrvRXkgZvo9Isk9Vj7am8Nw/ZNAW1O1RvQOPSbS5xW2?=
 =?us-ascii?Q?5tZwCeF/rJ6kcEwg1yIlXsf8z5fVG3AyqWUbnT+EMh4gnBBr9/jKwrHfcKVz?=
 =?us-ascii?Q?u/EzNcmA1ypDrX3a7B58ddPY/pZoOv6DK1b9WhbzD8j3/kj8mbYl5Nlhomhy?=
 =?us-ascii?Q?JyO8Bxd45G1+YaaSnsKiOlQUf0Y22qiuwlxIA1f2kLZ/sKECzYWgJ6ezbkTe?=
 =?us-ascii?Q?fpoF6RjV9SM0Nksbs6i0yN//WvFrQsSQjoe4kUYAVRkxDI7PPS7gS7paMLf5?=
 =?us-ascii?Q?VLxeT8C0HcMqtOqGrLNeKcdDAW9BKOvWI+ipGwHO6CW++gDqmROsl0bdOZvR?=
 =?us-ascii?Q?EdAEGUfUcIdTlTOV25Hrkh7DjmsKqDaqTEDdGnSC0fNzXvjjYxVzisSpqTT7?=
 =?us-ascii?Q?lk0jymf0iWLtWUXMUYUHR7mW1JYKY50hkhbylUYz89EoBmERGGR2YJGbgn94?=
 =?us-ascii?Q?DaLK1MqlFe9s0ZV5hEIBPQBCSyaIsixJD7/uXdmwQT2Vm5YFr7DFi8FAjbn1?=
 =?us-ascii?Q?jaLnxOH4tD1daf4pWLAvPa1rpV4+DD3cc3/AKJ4+gNMjLf0lvPWBUx0vkjM/?=
 =?us-ascii?Q?Sf9nmYjHRIYyTpfS8ivxPYurlnMkYqM=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5caaf42-a211-4f3d-4bfc-08de41e0d351
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:05:00.7617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LDKW79f429CxcSDuW0eGB3eUSNFcbYI0GY1cA4Kv9Wd9LGGapw7V3k8fQMM6KevA8YCZ6jblyUG/GkzPdaiE9k18AMAyOy/VFxkAVeiWRP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8488
X-Proofpoint-ORIG-GUID: Xh5nj7XK0baljeP6xDGzaTZk4oHlrMcW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX1zv7CBg/rc+/
 3DO631ojMAKhX7R+sstdV0Qi5uEHOXwY2jDrVGeN/Gcc0YvpdskUnNunaSZiX2Wrtvu6yU3Rz/p
 julOilRKbdcQC/sM4huDTWvDHdsgconhsylaSGq5+dPTeDSmMapDTQlpFwkzeozV7AvDWY2LuUW
 QQdv/NNDIkkr5H4Qk0aB1M2tCqftt+gklqLMaCE1HUAqd2KmS/2JvIYCcejXpBgXOn3eYkBTapN
 0qDbumhKYRmBdLRePsJHtfbHV4JZKrV7UeuZ4Jt6fQBWzdKhRKsBgIB/zv+Wyc5rLKxSXltDk9T
 XhBvs48TTu+we7ydNkZCCs5kgGbZqrG2w9f26091YFPO5rs308G7CxsimwRcmdLVN27JvJ/MEIH
 cJatozH2gSVRq4Pg+qwKSxBQ84rFTQRIx91RMnN3CTctwPNVkjEB7JBQ+SUxcnlmts3mmk2VamR
 G/MBi/KdNU6Q0Z6qTkg==
X-Proofpoint-GUID: Xh5nj7XK0baljeP6xDGzaTZk4oHlrMcW
X-Authority-Analysis: v=2.4 cv=MrxfKmae c=1 sm=1 tr=0 ts=694a22ff cx=c_pps
 a=cE3fiHRxMl4nLvvI2vbFbA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=MassRFkkHcN7-1vSbWoA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Extend all ept_access_test_paddr_* tests to plumb in OP_EXEC_USER for
MBEC support.

Tests pass with both -vmx-mbec and +vmx-mbec.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 x86/vmx_tests.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ce871141..465bcf72 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2969,6 +2969,9 @@ static void ept_access_test_paddr_not_present_ad_disabled(void)
 	ept_access_violation_paddr(0, PT_AD_MASK, OP_READ, EPT_VLT_RD);
 	ept_access_violation_paddr(0, PT_AD_MASK, OP_WRITE, EPT_VLT_RD);
 	ept_access_violation_paddr(0, PT_AD_MASK, OP_EXEC, EPT_VLT_RD);
+
+	if (is_mbec_supported())
+		ept_access_violation_paddr(0, PT_AD_MASK, OP_EXEC_USER, EPT_VLT_RD);
 }
 
 static void ept_access_test_paddr_not_present_ad_enabled(void)
@@ -2981,6 +2984,9 @@ static void ept_access_test_paddr_not_present_ad_enabled(void)
 	ept_access_violation_paddr(0, PT_AD_MASK, OP_READ, qual);
 	ept_access_violation_paddr(0, PT_AD_MASK, OP_WRITE, qual);
 	ept_access_violation_paddr(0, PT_AD_MASK, OP_EXEC, qual);
+
+	if (is_mbec_supported())
+		ept_access_violation_paddr(0, PT_AD_MASK, OP_EXEC_USER, qual);
 }
 
 static void ept_access_test_paddr_read_only_ad_disabled(void)
@@ -3008,6 +3014,12 @@ static void ept_access_test_paddr_read_only_ad_disabled(void)
 	ept_access_allowed_paddr(EPT_RA, PT_AD_MASK, OP_READ);
 	ept_access_allowed_paddr(EPT_RA, PT_AD_MASK, OP_WRITE);
 	ept_access_allowed_paddr(EPT_RA, PT_AD_MASK, OP_EXEC);
+
+	if (is_mbec_supported()) {
+		ept_access_violation_paddr(EPT_RA, 0, OP_EXEC_USER, qual);
+		ept_access_allowed_paddr(EPT_RA, PT_ACCESSED_MASK, OP_EXEC_USER);
+		ept_access_allowed_paddr(EPT_RA, PT_AD_MASK, OP_EXEC_USER);
+	}
 }
 
 static void ept_access_test_paddr_read_only_ad_enabled(void)
@@ -3031,6 +3043,12 @@ static void ept_access_test_paddr_read_only_ad_enabled(void)
 	ept_access_violation_paddr(EPT_RA, PT_AD_MASK, OP_READ, qual);
 	ept_access_violation_paddr(EPT_RA, PT_AD_MASK, OP_WRITE, qual);
 	ept_access_violation_paddr(EPT_RA, PT_AD_MASK, OP_EXEC, qual);
+
+	if (is_mbec_supported()) {
+		ept_access_violation_paddr(EPT_RA, 0, OP_EXEC_USER, qual);
+		ept_access_violation_paddr(EPT_RA, PT_ACCESSED_MASK, OP_EXEC_USER, qual);
+		ept_access_violation_paddr(EPT_RA, PT_AD_MASK, OP_EXEC_USER, qual);
+	}
 }
 
 static void ept_access_test_paddr_read_write(void)
@@ -3040,6 +3058,9 @@ static void ept_access_test_paddr_read_write(void)
 	ept_access_allowed_paddr(EPT_RA | EPT_WA, 0, OP_READ);
 	ept_access_allowed_paddr(EPT_RA | EPT_WA, 0, OP_WRITE);
 	ept_access_allowed_paddr(EPT_RA | EPT_WA, 0, OP_EXEC);
+
+	if (is_mbec_supported())
+		ept_access_allowed_paddr(EPT_RA | EPT_WA, 0, OP_EXEC_USER);
 }
 
 static void ept_access_test_paddr_read_write_execute(void)
@@ -3049,6 +3070,9 @@ static void ept_access_test_paddr_read_write_execute(void)
 	ept_access_allowed_paddr(EPT_RA | EPT_WA | EPT_EA, 0, OP_READ);
 	ept_access_allowed_paddr(EPT_RA | EPT_WA | EPT_EA, 0, OP_WRITE);
 	ept_access_allowed_paddr(EPT_RA | EPT_WA | EPT_EA, 0, OP_EXEC);
+
+	if (is_mbec_supported())
+		ept_access_allowed_paddr(EPT_PRESENT, 0, OP_EXEC_USER);
 }
 
 static void ept_access_test_paddr_read_execute_ad_disabled(void)
@@ -3076,6 +3100,15 @@ static void ept_access_test_paddr_read_execute_ad_disabled(void)
 	ept_access_allowed_paddr(EPT_RA | EPT_EA, PT_AD_MASK, OP_READ);
 	ept_access_allowed_paddr(EPT_RA | EPT_EA, PT_AD_MASK, OP_WRITE);
 	ept_access_allowed_paddr(EPT_RA | EPT_EA, PT_AD_MASK, OP_EXEC);
+
+	if (is_mbec_supported()) {
+		ept_access_violation_paddr(EPT_RA | EPT_EA, 0, OP_EXEC_USER,
+					   qual);
+		ept_access_allowed_paddr(EPT_RA | EPT_EA, PT_ACCESSED_MASK,
+					 OP_EXEC_USER);
+		ept_access_allowed_paddr(EPT_RA | EPT_EA, PT_AD_MASK,
+					 OP_EXEC_USER);
+	}
 }
 
 static void ept_access_test_paddr_read_execute_ad_enabled(void)
@@ -3099,6 +3132,15 @@ static void ept_access_test_paddr_read_execute_ad_enabled(void)
 	ept_access_violation_paddr(EPT_RA | EPT_EA, PT_AD_MASK, OP_READ, qual);
 	ept_access_violation_paddr(EPT_RA | EPT_EA, PT_AD_MASK, OP_WRITE, qual);
 	ept_access_violation_paddr(EPT_RA | EPT_EA, PT_AD_MASK, OP_EXEC, qual);
+
+	if (is_mbec_supported()) {
+		ept_access_violation_paddr(EPT_RA | EPT_EA, 0, OP_EXEC_USER,
+					   qual);
+		ept_access_violation_paddr(EPT_RA | EPT_EA, PT_ACCESSED_MASK,
+					   OP_EXEC_USER, qual);
+		ept_access_violation_paddr(EPT_RA | EPT_EA, PT_AD_MASK,
+					   OP_EXEC_USER, qual);
+	}
 }
 
 static void ept_access_test_paddr_not_present_page_fault(void)
-- 
2.43.0


