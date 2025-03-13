Return-Path: <kvm+bounces-40986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2496AA60202
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 21:11:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D25C119C4CA4
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 20:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 599AB1F4C8A;
	Thu, 13 Mar 2025 20:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="NOetNZS6";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="BcKBZ1eU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AC21F2B87;
	Thu, 13 Mar 2025 20:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741896637; cv=fail; b=QSIvrDvo5TlffNySdQHat2UA7+7mgvuY56a9tblFe59ZiOpbehSGOGTHIfvRXl2kQGqbqv6MWY8ZXvHMFj7Q/AZpIHASDY7QaVpmLKlKM1ht5MZXdMDdeQuiP7W0M2pBvyCTBWT+8L6Ux4ejOi5i9D/bxkuous5oR+6L/BYkXes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741896637; c=relaxed/simple;
	bh=2QISCcSKSGvWXGHvc2wgQMfh0zIHz4uMO4K8NC0AIDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tezbL9ns0DnPV9NQPin4quPYEZS6dErfa6HVYFj+6+0Lw0O5pusRNn+ODsMCAnZjIbDssWblU/SdLh3kNAXW9JyjB2budgqMou4svlP6fwi2xdkB98M+4R7TAvPFHf+PWzCfxZO/ruxIgI1KwIchuaj7HCI25S2CQUQWyTNPqF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=NOetNZS6; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=BcKBZ1eU; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DEat7c008984;
	Thu, 13 Mar 2025 13:10:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=P3NNEQV/ZYzP7aunVREwhYEegl6ZEhDmStofic64f
	co=; b=NOetNZS6c4F8tqZQ/W21JpN8s/GjazA22lAvaUIUVr464cIXYwT85zvBp
	ScqEKFbZ3cAJZsG8xX1HLQ0PputOPWkwOxITqK4iwsn0xndo2+XZGgXQtdeXZMTd
	hrsOQTqNSKmPtNdQ5dPWNteDYmYO+YOuxZ2sU3VmwBnYwppjGgBUNulM+BwdKT8J
	boSLThoQQ+gTb53MPZNsKKoGbFO+t7iSrNzbMyJopJWcX7PgVYFRK9LOuNtOvMI8
	iRwAAjAM1xojGsTjLE/DNssNCOJ8waC59cPfbUvVNaGQG0WduKrOTTHv/sTHQ4RG
	JGqWvpItEM2yQwQCJNuGKobPBOygA==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17013074.outbound.protection.outlook.com [40.93.6.74])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45au9gp93j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 13 Mar 2025 13:09:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c1llvjvpClUa4cNMZMD8xQUSTB1rJVFOPd6ZnxzhGZk4W6pDO5cR0dZ75pt8xf2bKbfV8ChW3llpCoIekAMQI5kL+udFjQeVSw+aXaJ6I76JYcW4tBBkvwbSJvm+ccLjiHvnUFqnsqMiNf/OJdRrNkrfWwLL6V3LKQLEyVJK8m2ZPPJyyp2coVUYr0Eo4UVLQZcub8J8JjD3sWOsUjdxD8HBCeEGtYPjg84LMI/5bTmGRMeb7fSepQI8DzAkfN5KnKhiYGBXwkkjSq91HWcAYrIyjvWBEyqKUZIFMi/ZMpPJ4+j6g2rKoxMntf7RaHHCA/w8z+GbTFNv5A1UaV8q7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P3NNEQV/ZYzP7aunVREwhYEegl6ZEhDmStofic64fco=;
 b=ekABYmJvwRpB3ZKHe22GYMRt4EpcI90wU1CR7Qh7+6Gu8tSzSqa3FbjHufvr11d7ltlTWLRBmpD9Vz0GZ4S/1mrmw5H6TajZ5JIatzoa8JEvBuMTy3w1YxYstWel3lhSztjZI0GewnpzpOtQWUuLYyRUGkdZq9fCPAidSutdocrhbDRLVIK6FspalOTWnlCFNSBv+OggmIyxoGItc7nSrSTtHjrvdN9SbPqxMrhBggZ+9H5if2HBVmogMsnUkN2GNc2X+th/6+xs+7TLTNhbK2WascjMPYxml/Ihs/7IPQJO6C5SIeDSGtXEfjlHoK3Gd/uYl7qLFAtqK+1yqlgiFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3NNEQV/ZYzP7aunVREwhYEegl6ZEhDmStofic64fco=;
 b=BcKBZ1eUKSe7N7ir2MwfIstM8kxY7b3fCuuGn2ASO9UfodrI5LZR/VSDB2e9nua9Scis7T1sW0l9ZQH+OqWjWsJVdPJxEfidk0Sp5WlNmEZiznwDutjyoW5ucLke/ttslOZ1B3xUC/Qm6Yu6Fmj6ouHUm78Ade36vllg5x2/lIsqVuQS8isbTkQiZlcIh/Mai+skvJHLAcxtIOfTv9r4EPGXN4Pa0pUGpdVuBEYJgCgY83u/T0hH5JRRJdNm11TD2IL/wP0Tu/4k5g7lM0BNxwHKUl81Tw6GbBcbu2YJ2iR1qLaCPb4rkBPmEksvFJmaAxnKAhcU1WBEVukEkkc7MA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB9384.namprd02.prod.outlook.com
 (2603:10b6:510:280::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 20:09:57 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8534.028; Thu, 13 Mar 2025
 20:09:57 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Nikolay Borisov <nik.borisov@suse.com>
Subject: [RFC PATCH 01/18] KVM: VMX: Remove EPT_VIOLATIONS_ACC_*_BIT defines
Date: Thu, 13 Mar 2025 13:36:40 -0700
Message-ID: <20250313203702.575156-2-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR02CA0007.namprd02.prod.outlook.com
 (2603:10b6:510:2d0::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|PH0PR02MB9384:EE_
X-MS-Office365-Filtering-Correlation-Id: 771f44dc-dfda-4a31-f4e9-08dd626b071c
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sqkA8L1ESbIKWe2eKVOObGwwDOUv1wEVGrfEMejgd7o0N1UCdgIghb9TVWWy?=
 =?us-ascii?Q?YnnX3pq2uje3qXKEGBPtzggneWKoRyIklMpOljvq5G7lTIGMG5jrDfmMcGqq?=
 =?us-ascii?Q?UYm2Bg3GkUxe+LQkTPtHSGg9FjyUlT+lghGOtgGns5kLaFKataL//2oR0RUu?=
 =?us-ascii?Q?ammwqj7Zgp+bJoEKs8EEUqQtz7IcTFOmBwnLAyuDQCi1qQl1Ku7BjoBmRTRv?=
 =?us-ascii?Q?10oPR3+UN4VafvLPfo8Ywzo9yhJQphsg5fDydkAyQVNKZ5fUh8UhWChmk2dG?=
 =?us-ascii?Q?40bqn+ZP6xYOQLcyFaeSDFztnHeBcfJmjOmlMHEPYkSQ5zWPf7hPQC0FJ0vV?=
 =?us-ascii?Q?fAoqbmHpeKhtYUrEdtvvyV0nsTM1oNOmU4gVeF/kWD3Y1IQS+j/ZphIHeNZ4?=
 =?us-ascii?Q?eyY4g6xPAEJyDpQYGQRcq5iGxefvXwsZGafX+7p8h86Pro3gwAssWH88LIw9?=
 =?us-ascii?Q?KxjuNDGajXVC5eg10Phj43pLSC/H+kgIsMng+WKiFFdRBLsqnaQ+fHNt0eLZ?=
 =?us-ascii?Q?/x2ovHmC73QBC0AWcMpWlcPJeGawj8rknLASKkHQJVM7Ul4aMqLp3Sroe69W?=
 =?us-ascii?Q?wQrL7hYZ6973M1eRL+xQtcZFTR/hsNyKmSyXWCv9oTlglDj+0Cc71AM2uLwc?=
 =?us-ascii?Q?Gw3RXE8xcCGPam4lmQzPgNhOJQuxfSDgKzSYVQ0MYMhNmkBU74EyU0eqoV24?=
 =?us-ascii?Q?oztKE7s0K2kSSg2/XYnx7NaIf+FTSqVu4SkifLDU+AC0gF14dq54Bq6RgZGU?=
 =?us-ascii?Q?dY+AyfmbSn09PSBzNRj2s4WjBfRXYefX7INwBI+uRE1QeJSWhL5CJ7mKT7ii?=
 =?us-ascii?Q?85ww6cK3cJCfXGJgvcI7m8OVNEIHGrzq4gqjxQp4wK/KOTEav5HFQe0nqn1r?=
 =?us-ascii?Q?JMrh6ln5XpwwkUtj4rJ1nVktycAeaeljmYfcb38sV2qLSCybY6icFk81dAPA?=
 =?us-ascii?Q?o38i01IWVvkPbJmU6XEnx2F2Ki4AWBDKebNFPOrAapxzNUaLq2GtaOdqoRLH?=
 =?us-ascii?Q?uoJ3UkKIoHuWgM4FvIUBrW6OeoOOo+rWR5JtgIUvJfU2wu+im+SNCUeSRHU8?=
 =?us-ascii?Q?TeDtjyKLEtgpQxbCi2SdBO/Qsl354bbRiuFgTHq8jck5Dfv4W4WWqqS3Cb19?=
 =?us-ascii?Q?nZYeB07RqzPN72Q2sPGFWTUbKWPpT3XzUVNKcP3t+yFMOssDfUXY8Y3zxyyV?=
 =?us-ascii?Q?I1B4eagXVycR9Dt1dKC21BpEkkWKRFucoC3Yb72HNQxi7Z6MjJrCC79ObKkg?=
 =?us-ascii?Q?bh4oV808IwmQshuYK5oIcPfu9Cm67eW4dtavD83x/xGEZzTS+KkDtIU0Qp0C?=
 =?us-ascii?Q?IYYrV1SHoVjePhMWXOus0kgRHy8ohztre0hfVvGsOwA5+3BxEmwNwlElw1jk?=
 =?us-ascii?Q?7pTvliQrx9WTUr6VBXJzbAeaucv6LVCPrtxHKK697ub4dYrzYuzxyt7hCsBC?=
 =?us-ascii?Q?iPbT08N3xHnU67Q1APAZrz4UbVIn2y6natfZoQLA/61O7Q8rVnmS/Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3WuTBsG53aNKyf4v2HjKGxyL33EJ2GV/bpbkZndHKZ0L0cAPc/o+DoACLAS3?=
 =?us-ascii?Q?FwQIXMkt0SS47RIP0UkI1Q/G9n548tNvSymdIDSASYjXhqyEIN2YPlqmntQE?=
 =?us-ascii?Q?W+bclXUO1Cg2lCx9sNmuJyVcaoZpQsXdsKV9bC2LrnU3SI38aNNiYhUEbY7i?=
 =?us-ascii?Q?PyyHQQjwb+ucfQ1W9vPInA7P+wvcJZJAd0hAwsLdYcI4UqryMCMrG72aNP32?=
 =?us-ascii?Q?8+BHE1LoiR+7x/fjWryvuFgabOKUO2ak2x9e2WkZqSDzPA6gVkc+jkoTSweD?=
 =?us-ascii?Q?gCwsRYpdylmPGeZj/L4SCsBGg24rERGjOvfBflpH1TDRa7EV+kj+U25HT3rO?=
 =?us-ascii?Q?4FsP3jwOwheGmS8k9a/8eKAMTxaamNl/SVdwMRVdocYWJl6lKUq8SQA0dXwx?=
 =?us-ascii?Q?gadNouD+1e65nSue2fZTbwxq0pBIMntOUc5iyh2WJw3d+RzIuzUSXXyzRz+y?=
 =?us-ascii?Q?0PvIEzUmDqT6HSd7y+qVrSJAl8eF5WJ3OY5bNLTH6D5RlC8ySNNAoFuvRTmZ?=
 =?us-ascii?Q?Ry7vXmIWD55Sl/Onp8W1aYnl8sqLUvVr+sQRSYjxq1pgJUXxmkOqlp6wc6DG?=
 =?us-ascii?Q?dEv5UDXJeEVhnJJVVf5bnQPirehfmADq4ehPxC3EL+fvb+TaaiJhy84UNMEk?=
 =?us-ascii?Q?GNfrtIY+TjcR0R6w41ylBrsuzC3udnR5lJgYmtUop7VK0Nkq4rPvPGNRKaSS?=
 =?us-ascii?Q?Kns0KcIi/jbW68borTY9xVzN+gU9rPmhZzUxvQkvEimv1omfgY/Vo463vz4U?=
 =?us-ascii?Q?FhiqdtLV6cT0uCSvy1b9608ll2XEuqTXU+dj1FBFSHTdqRIRzm+Ih715ZS0s?=
 =?us-ascii?Q?iR0pO+xITVusLMpwNImpi24K67jVZ7YPPNL+67VJ3Z59apb+zt+fqozW5qko?=
 =?us-ascii?Q?xCx55CvmGDg6A3FJN5OayM3VXb6Ygpen2KUlN3DbLPtIVMSCdGM/rLmL2rw/?=
 =?us-ascii?Q?1GZSDDNKd+3835pOcV6r0oYFWXWUwKd5P6VKg2Mp4vW74s2iZdlmu7zZxkBc?=
 =?us-ascii?Q?zvd1i2qVIoPwRGIrnSQKqmCO39s1HcezPM7YgqjG58r3MvYFQ3oHfJ+qo6il?=
 =?us-ascii?Q?mcccs9fW09jDyOUG4452nAkuCjptp9s+wcwUrLKF9xfbqzs6EncJgODkyqb7?=
 =?us-ascii?Q?zyfBb7hwijCPTKFT3lYy9CtYwFORqEX7WTNtNurg/FDWK8zS9sIAtqmlg6gA?=
 =?us-ascii?Q?YayUT63NdO6jgxdGgXypkIHVZ9QO61Rt4DvAmNKDvTAGWa0zYet2GfyG98iX?=
 =?us-ascii?Q?Xm6SORWLvs7OUXyX1S5WB1CwbkfWtHkst8PpdKfeoW96ne3QFTN6CI5EWaUX?=
 =?us-ascii?Q?24eLZJjFBn3iLq71PROeJqSsGDl6ci5nw2/rlmIyth0osKoiSkdWqjib2+Yi?=
 =?us-ascii?Q?trvrwdeUigJueUS4O5rMOZXDDyK+VeLkLokRrlz/JQSv1owBaUQYMTpYNyrU?=
 =?us-ascii?Q?++ldwC493P5l23LvEgoufROqJOcULxVvinUx1abSBcDn/7uIlWR8Xx9gfRf7?=
 =?us-ascii?Q?ds23thpSIpw3gt9dDFyLXKddKVriM0AWT/P3cf5WSHzW1M+rzjqoYxS86Yu1?=
 =?us-ascii?Q?GnIwVxyI+ZhRCXnHRXJqJnQr8e0X65Ht2DBu26TrY1foSzEP2hDWdqUR+qrF?=
 =?us-ascii?Q?sA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 771f44dc-dfda-4a31-f4e9-08dd626b071c
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 20:09:57.8233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MMu1ujG7mxbmlLUCNAvHFaCaQZmNr9wXUutZLeHNl/exV+TNtXAyRPcA3X/1R/kE9GuK36UKfqYRIMDIm0X2UJOGEoB+RdRZR4HQ0uFQ6XA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB9384
X-Proofpoint-GUID: Yz1QXNWVByguJgNDtL-pFGppzhI-khj3
X-Proofpoint-ORIG-GUID: Yz1QXNWVByguJgNDtL-pFGppzhI-khj3
X-Authority-Analysis: v=2.4 cv=WMl/XmsR c=1 sm=1 tr=0 ts=67d33b97 cx=c_pps a=4/dVwHrG2xlZHl48ITU9gw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Vs1iUdzkB0EA:10
 a=H5OGdu5hBBwA:10 a=0kUYKlekyDsA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8 a=4ETNj7wtWLrgxawaAZ8A:9 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_09,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

From: Nikolay Borisov <nik.borisov@suse.com>

Those defines are only used in the definition of the various
EPT_VIOLATIONS_ACC_* macros which are then used to extract respective
bits from vmexit error qualifications. Remove the _BIT defines and
redefine the _ACC ones via BIT() macro. No functional changes.

Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
Link: https://lore.kernel.org/r/20250227000705.3199706-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
(cherry picked from commit fa6c8fc2d2673dcaf7333bc35eb759ab7c39b81f)
(cherry picked from commit b55fd5c48d3ec1dbf566937a377817b390ec0768)

---
 arch/x86/include/asm/vmx.h | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index f7fd4369b821..aabc223c6498 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -580,18 +580,13 @@ enum vm_entry_failure_code {
 /*
  * Exit Qualifications for EPT Violations
  */
-#define EPT_VIOLATION_ACC_READ_BIT	0
-#define EPT_VIOLATION_ACC_WRITE_BIT	1
-#define EPT_VIOLATION_ACC_INSTR_BIT	2
 #define EPT_VIOLATION_RWX_SHIFT		3
-#define EPT_VIOLATION_GVA_IS_VALID_BIT	7
-#define EPT_VIOLATION_GVA_TRANSLATED_BIT 8
-#define EPT_VIOLATION_ACC_READ		(1 << EPT_VIOLATION_ACC_READ_BIT)
-#define EPT_VIOLATION_ACC_WRITE		(1 << EPT_VIOLATION_ACC_WRITE_BIT)
-#define EPT_VIOLATION_ACC_INSTR		(1 << EPT_VIOLATION_ACC_INSTR_BIT)
+#define EPT_VIOLATION_ACC_READ		BIT(0)
+#define EPT_VIOLATION_ACC_WRITE		BIT(1)
+#define EPT_VIOLATION_ACC_INSTR		BIT(2)
 #define EPT_VIOLATION_RWX_MASK		(VMX_EPT_RWX_MASK << EPT_VIOLATION_RWX_SHIFT)
-#define EPT_VIOLATION_GVA_IS_VALID	(1 << EPT_VIOLATION_GVA_IS_VALID_BIT)
-#define EPT_VIOLATION_GVA_TRANSLATED	(1 << EPT_VIOLATION_GVA_TRANSLATED_BIT)
+#define EPT_VIOLATION_GVA_IS_VALID	BIT(7)
+#define EPT_VIOLATION_GVA_TRANSLATED	BIT(8)
 
 /*
  * Exit Qualifications for NOTIFY VM EXIT
-- 
2.43.0


