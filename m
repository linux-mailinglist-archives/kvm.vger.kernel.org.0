Return-Path: <kvm+bounces-38493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 596E3A3AB16
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:36:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D61D87A4943
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627DE1DE893;
	Tue, 18 Feb 2025 21:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NIZMWMej";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RWj33sxu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38211DE3A5;
	Tue, 18 Feb 2025 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739914471; cv=fail; b=AQV2nxzXPCYoVLZQ+iOVTKdcUARFE7qj1rQjamM1EIRg7V4yFrho2NhABNQ694PDsSSmtUSP1zLuI4BPW6yowTNqxwoXfYY0DDhNiB9TrtruWUTo3SFhBoiDO1cKbb3gECMgo2KZgXfdppRMVEpTcmuTpUVVTwjgsjmjR+2J3x0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739914471; c=relaxed/simple;
	bh=RPGuKgSLS0ZU09VWQwQ2rVvdSj6aWsS0/KLCI0uts9s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BuZ8cWkXHuGotgZVZHtFq0ry+nlV8pmJ315kZ41wPeLRUP8MbSsm4T78GE41E4zY/DQ/IJoyQ0ZxaKxLY2vZZZmaZYqNcqh9lVi8ZjLFEei+FrqLLWas/z8WHC3FkDHMvSPBmt41Ysj+IdNLEGZCdf1t3HSmegchDxG/UNYK3zE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NIZMWMej; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RWj33sxu; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51ILMZw8026594;
	Tue, 18 Feb 2025 21:33:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=DBS2CRO6MNqsL3fxdGxqXADXxTFZ5MkbawxnBnFcnjA=; b=
	NIZMWMejFGk9Vjrm9l1g7s4uluxCpdedePI2IbaX7jTfrtwU0/AKlrKfAqFQu3n3
	KjU0gjQ2jEb8gA3jSehez7wfXaPN0K9mt4RO/zzHOMV00YPJJexFNRfRMhXA7b3W
	drOTCAYcBn68FuL2fcCr8mtLqX/sqgiiV1+2Byc4p4V3nPC8QlNScWKaeuXoD91M
	/XsmKOlbGttTYOXK+yTj494nzkiW2DZ/VvyPEZ293+ueKNsRk5+yKGj12qUSkFSK
	6TmQ/mGmnFNgWniZ+BnxTTnEZOHxAg4ZaOG+Iq4oZyv3O0/6rUreIBWvBgdXCvBM
	uthyZqYaLa2GLPFnthA7TA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00mra1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:33:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51IJt673026248;
	Tue, 18 Feb 2025 21:33:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44w0sn3kpd-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:33:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nQd0Sga1gKsvAvz8HAjl1NgWcNLRjWomade0UgWZeLcX9dJCOmIuaYTjkMt5Im/B/ZqeKhVWoPI4Eb3urPnhWrs2IX9MktvzXfjiX9/88iDM59FM12pGuApJaMsp7u17o6vh4nU6Ygr8Kt4Ew3ZWqkkV9aANHAkWFgH3MstV0usITpbiOYBAPr8L6nd1iy0uiFQAhxUMfD8KprnwM8dvEZFYV11pA0Hx5vI8tZ+O2f8FzLomYC8fDjGn+L+GNu05X7TYn3xbX6UgkpUpmzy6GZtaL40hA6tw4ckFEU1aPmxQG9L15RxDaAyP7iVRJswwSSNmmVp0SWn4A9S0XUgd5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DBS2CRO6MNqsL3fxdGxqXADXxTFZ5MkbawxnBnFcnjA=;
 b=pY3ElQmx+KsJp6Ak6Iizc32tNvDs84zZjHDa4qEXmBHUg4vEDcoYJ8uvSHzM0QdtsOovbLQCSxMGVlB4DOaJCo8PaIba+KRQ8s693LJomuUl9wucX8w/QirmcR0lR9gepHzGiT8hQFTXXiMmw/hP/e2R26nqQT/j8K0dzQeZNEbG6F6WHVf1QLf9aD65aheBBgNU1w0ur0S6jSAOa/c1zEh2qR8F0iuTjXFORtKhfEbocNzAeDtCqYJUQS5ttozK0GTN53sHmiqcgRkkPoE9+EpqtiCSoR3CTr4aXgKE2kRFXi1D6Z5DWBMV71Ei3s9veTk8Ou4zv60agvXM1Pn7WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DBS2CRO6MNqsL3fxdGxqXADXxTFZ5MkbawxnBnFcnjA=;
 b=RWj33sxuofNLrnRjusetuKfzZNK5c3EQUN5i2/h+ewbFMdmcCMUXqIIoTSGUreTNd7biUl7mzS8BOT+40UUTOvtgD9RR2Xv6+RP6QX2ucrt89swakwOLStHq0u5JZ27mBECwB/aV76TGCiuJn9yhuoWpd0VK/+IM7yIUSEhak7k=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA0PR10MB7275.namprd10.prod.outlook.com (2603:10b6:208:3de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Tue, 18 Feb
 2025 21:33:47 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%2]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 21:33:46 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, x86@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        maz@kernel.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        zhenglifeng1@huawei.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: [PATCH v10 04/11] arm64: define TIF_POLLING_NRFLAG
Date: Tue, 18 Feb 2025 13:33:30 -0800
Message-Id: <20250218213337.377987-5-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250218213337.377987-1-ankur.a.arora@oracle.com>
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P222CA0018.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::23) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA0PR10MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: 126e25d9-b330-4506-33b0-08dd5063ecc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0VQ472KMISHxLb9UpVZTy6KFnLVoO3FwCB26J/K+xmAg4khjieLS+NlMDnkP?=
 =?us-ascii?Q?YMXBHQr+7a9lv91YnAnUBgNy+u99x4sHLfjWMsgFOe2N5quLtn3hx0z5Fckp?=
 =?us-ascii?Q?ZjF16GurkVwN0GZZPx3wo6ZheLisY47v1sNyD1r8xG64IsArULuXr/es7DX5?=
 =?us-ascii?Q?6BRTXb2oDMQUB9JDscWn4WghFCuCwDsXqF8AgVq9565HTc8Qo0He4g47jeAr?=
 =?us-ascii?Q?SmmOqSoetUzjfAfhOXM9YJ4KGmr4jc+WD4WOiG4AYmRiIFqlr3a/tu1rEd/9?=
 =?us-ascii?Q?MdQE9RSwjkni0pegsXufI/tGPMploQ9yAsnD02yNQyWOEnJ6C+0bovQyAu2m?=
 =?us-ascii?Q?HBMYxRAxRcmalYAx3oCXjJvrtM0M3/jgyAuUCPuKJ+8imUlNCAi40PbUMYiB?=
 =?us-ascii?Q?aeHPV+PuqtEkL40Rcz3UbNjGowMNV2s2VqfxN0EMf398WAjsW2tfhL9I0a5H?=
 =?us-ascii?Q?L8loZqCzUc40SR4UEQxN3XIkM9H+eJ5GsxJXodmBD2WsWMkNI2tirrRR81XO?=
 =?us-ascii?Q?Wmn49pEYITgFPsMSa1QwStHnExEhefAF7HIV55JDbZX7CDOpfRvWxwPvVv9U?=
 =?us-ascii?Q?iw+ehhIzov1a/ZLLLibxlW3JIumPq/1vAZEpYiQDIlMGPsELjt1lEHAjglNm?=
 =?us-ascii?Q?7f4R4hgwK0wK4aa1areMODV0OQOw8BNh4O8Vz+/SPmCmHg0BVPMh0Ck+a6pJ?=
 =?us-ascii?Q?mquY0HFU4MlQxrVRFHtn/bQUlwavjY6q8Zo51N1CSlhZOSRg8D0Ymtbv0gzk?=
 =?us-ascii?Q?8xQekC7oX4j55ri0pItOxVBLVgAU2s0m7dl0WJwP+bw5SHdTEqVy/2SuAyE9?=
 =?us-ascii?Q?ocskX9cdhV471FREPXGXLrNo9BPJ/oatcMPz/RsCLu5++Zwg8Gtil1l4PiqG?=
 =?us-ascii?Q?MkC+ismD1VOxqRK7Hk9v6rKmJFM5y3sUCZZvvuYzLUkgkNVhhOP2QDkHv16q?=
 =?us-ascii?Q?EFrjw/Ir73DgMyb8pzHeZuOCr1kw7MgZXKToSPMaGNvD0WlzHdqO1E6CNkRF?=
 =?us-ascii?Q?vjLI+7TgqFUGHhLyqSc05du6tqwZPhVgap+Bc9Z72fT3p5SalSkL4JOecqTN?=
 =?us-ascii?Q?kDPHnAhlD/keM8gm7yg6MgCBrHRKYIqzUE9BrEhPfVf83ze+oGeAyeVp0kIx?=
 =?us-ascii?Q?d8v/9y8M6gG4w3p+M9vG66IyauDFj5qUcEqUa3g7pYjKiFWcpP9tao6DpMM6?=
 =?us-ascii?Q?jM0qAkewKvfUFSVK4rGt50Xv0gSKRdYU/9va7S67j1ATcGUENT4Ty26aM/a+?=
 =?us-ascii?Q?Au2biIeiDOHSfXgZoci+t8VhacxRQ+PUETpeydI+e8qMbUYfgVCktAPjnhQz?=
 =?us-ascii?Q?lx4KxloAguVMXqVhnPeWPGaNbBjdKz1nL/+Msb8x1UanDCa5H2ePTEgt4Rs3?=
 =?us-ascii?Q?b/M9j7AR39DYIjA/C5V4nVFqHezi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?00hvQGqXxb+rX6MJAT4N3cV4lGNQ5zQEM5k5Mp3BSC6ZxhZWxdufgodM8DDl?=
 =?us-ascii?Q?Y0p5lGzK6edHXFz1zDzDn7vdWrhIrTDjOxvr+tWLBtOzpa9XHBcHvnh0Qk/m?=
 =?us-ascii?Q?Oq49v8uLXCJ941XtvXhcgZWj3SQJB1Q46nH1l2FAX+c/rtQbtz1TbA3oU70A?=
 =?us-ascii?Q?hFEOkiZnkPRv81H1N1ev8aAbv2KHNsaaMiLvtPLEviE6tvOb5d1AlYjWjlvx?=
 =?us-ascii?Q?9YsjK//pPan3FaWSnNhHnfpmnaM5EYoo5wVOCBd+/1p+UDXswk2pXKIk7gHF?=
 =?us-ascii?Q?Ca3oiJ6LLuLJCGArKBEKPGbgBfKDLedAk6t4XzjRaU+37vOq9tqMbllFakOy?=
 =?us-ascii?Q?Oq5mNDtXK+uqwOjtv2/5GVAACfK1ki1GSLfl4EAv3OXGOsnYmnzZzD3+Fx1G?=
 =?us-ascii?Q?Gpyeq/5+oyfC/Touwf0z3L1bcKWbuXFggm+EHcAQHmfIujexUceB6pyRR2qc?=
 =?us-ascii?Q?DfCL12B3t+xEqf/AZ4rnksIlhXd0ywxeb/oe3vO20GRtXnz7iP8cyEg9Xya1?=
 =?us-ascii?Q?HBqXISUT1vKGWmK6ErA1kzWnxryx5xID+1eehXZpinEJEnrzUUg+ho4v0IN4?=
 =?us-ascii?Q?WJrlVcw/X38K1D+r9bIzz9Fg8235jlBSyiIP1CXILG5KYrx1Yjdfx8Gh/e6t?=
 =?us-ascii?Q?/Ij/X5938Od67+fqFQxcXM3QsoqEJE/DNc3XO++hKru0nksIbiuTbrXC31rc?=
 =?us-ascii?Q?gmuaEy+lwHXGutyYgPhUeWn3Hl5U4tRWtsOnO4vlzuETuGRririKvVfqhoY2?=
 =?us-ascii?Q?FZGd/Hd4XiLqrXQqsibWCpY2yukLBIM54Vt4VLYMKQkUTIlftfM5og3umTuF?=
 =?us-ascii?Q?fQgbhKIBENMGeiQ6WE+90eQ4xuNyzbIXnzzUVO7QDxFm4ssMZhSTUvIjPtbD?=
 =?us-ascii?Q?2XQaegI2e5Ty11HgQBPfjZnilX9AsEFBaJUcq9KuSPnzDE/CRzt5Opnz2RZl?=
 =?us-ascii?Q?Imviq8gvLjUqt7ueRTpCQUt128/hgFqIGq/C1m2103HXBxl/5aHPiMAUJawu?=
 =?us-ascii?Q?xqJ8qx01rZ/SUhI7zhv1ezifLTq5VeL38X+76+Uy/HP79nXoXd60S/YJ8uUy?=
 =?us-ascii?Q?TKIBeuNfXgwEuBMhXO+QVLVFL0UxUAAwngYe0rsbNiLCTESaNUxmVsaaa3YC?=
 =?us-ascii?Q?W6iYs0kyLWT4TrkQRqchMf7lpW/ysaXpuCwVV3suF3tWEEg04xvwRp9+W2N6?=
 =?us-ascii?Q?3uk/GYyD3KohHkXMT6CTkcisKqr2dcnTWXeHyVfwI8BEeAUhLOnlMXy8flUY?=
 =?us-ascii?Q?4rG10I0hnxl6s/jSThyT/9ZhFuJIuQHEHxCgxvoXvSyFn216csSgRvx7s5+r?=
 =?us-ascii?Q?12MLfYMt+XHF0gALbxj9x9Q18nd27cmCBGVcx1KQ6EDFF4Z7M+JZPUvu3lal?=
 =?us-ascii?Q?/H628auqzjOYMSFNnystohwn0bPytQDiG2Z/1l55DnqgICY2R//OR8Hec0KX?=
 =?us-ascii?Q?L9MOVlzEIVswySRFJ8Jp4OFYjxRA/e9+K++xMInVjX3M6q8H0+hDGGmK6RcE?=
 =?us-ascii?Q?Hi/Ipitz+1zg60pTwVZRRxksSs+DPkB2eH6ykYARQgF9KuxMJZzgOfxk81l5?=
 =?us-ascii?Q?sHz+vNR3IZeVTJwhrGC8fG5LP2XFInLSkOhYlIEsOQC3Jb/sdC7wh+Dw7dqu?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yI2tYLOOIvUyNy8xDO0b/APrddin1eyyc9J2+JdsDjR5BV3KKkJPF6mp1fhpMrimmrbZWIrnh/jEglsrk5/ZS+NblkWB+BBkXl+c5S3WSo880Eu+9zE9EbOVqHgMwc3oBBSWgRDbi8CSgy6OGd1tGxkB2HEdbXkh2zYWd+72eC3NpwY4wzHo9Toe9gAM7Hd9lPuPp5mwW36hhOSyaCgghqnC2uCLVqB2MrEtEDn82QyZ/4cbjdH6aWc36vAPZRB1FYn/YBt6GjFEb7d0f4zwuFbb4C+GvhMwmGWAHc+CdC1vbKq01fVwmWJ/W2Ryx0JRB6fZVtkr7DDOEJNRyEqAAwjluLU05smMEUx59J2BnRcB66LTy8/XIhmm0zuUuSgn0PCyfRLEm+ERE9Pm+28+ctcQCKsO15qiG6dxVGtZYc9vFxWJqhjc47J8g3unWG2f9GfZDAZVJb9yqw1gYp/MZ4TRiQi8CC8Rj0NvOqgqUHhyph8dQSi4U3jHXEZW76ieG4jzB02rVO84wGc8l7kJzp3pZuzEyODWmWC+pnRRD3rICJFjBE3sKKafpOTidLMqLiyJZbczyLYYxpzfXUr2WFoyfBM/1XtPb9PF0nuTqDI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 126e25d9-b330-4506-33b0-08dd5063ecc5
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 21:33:46.2084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i9TSyi49el7fCyi0MvcM4wQ8wxNUaKvpp3/O2DbzFlw/vGEbq7aZ+2//EEQ5etZwogUPKp43eAcg0C3JZbZV5kn7+HcRmV90vnjHno/TM08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_10,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502180140
X-Proofpoint-ORIG-GUID: ytLq-mPUQ4Gyk6MSaRcjZ7QMkEBhWUu8
X-Proofpoint-GUID: ytLq-mPUQ4Gyk6MSaRcjZ7QMkEBhWUu8

From: Joao Martins <joao.m.martins@oracle.com>

Commit 842514849a61 ("arm64: Remove TIF_POLLING_NRFLAG") had removed
TIF_POLLING_NRFLAG because arm64 only supported non-polled idling via
cpu_do_idle().

To support polling in idle via poll_idle() define TIF_POLLING_NRFLAG
which is set while polling.

We reuse the same bit for the definition.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/arm64/include/asm/thread_info.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 1114c1c3300a..5326cd583b01 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -69,6 +69,7 @@ void arch_setup_new_exec(void);
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
 #define TIF_SECCOMP		11	/* syscall secure computing */
 #define TIF_SYSCALL_EMU		12	/* syscall emulation active */
+#define TIF_POLLING_NRFLAG	16	/* set while polling in poll_idle() */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20
@@ -92,6 +93,7 @@ void arch_setup_new_exec(void);
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
+#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_32BIT		(1 << TIF_32BIT)
-- 
2.43.5


