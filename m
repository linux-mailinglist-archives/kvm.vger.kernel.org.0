Return-Path: <kvm+bounces-27506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A77298698A
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:26:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4914B2841A4
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 23:26:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69C631A4B82;
	Wed, 25 Sep 2024 23:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AlgG3I4O";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="etsXHiLu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78FB1A38F9;
	Wed, 25 Sep 2024 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727306734; cv=fail; b=rNY65RxhVToIUI32RzMGVY4NL/lX/rnMJb+MSUZQlRsuQ4offcvF/fAQUKyqeE3q4k+HzTojaLfvtaMRpaXkqrks+7qvvz+Gt17Cfdh275jDTw7bit4DMz/P9tph16mbhdHs1omId3vKPYvohDw/MHXudzVA2NwZCfXrlUd/s6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727306734; c=relaxed/simple;
	bh=ZLsL0I7kpUquRI4Gu1oyEJomlAJfeU7LjobEfUdF/H8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pYfp4gfOWh6cAr7mCuRD1osME0h3je+915c210MwHzoF8Iy5zrc6jqZlwC4PDcx7TsDi+p3oSmlKpXqebvjzCKTUguWUlemS6+xoNs6TDxLr1y2TV6yhTxkfs7uabaip4DX7iIK5+hZDxWb91bcLC/nbJs67QBWB6SOzXv5bmK0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AlgG3I4O; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=etsXHiLu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48PLn1jU009861;
	Wed, 25 Sep 2024 23:24:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=vXiJvRI7fnF7e1p9sgK0zH+kDAbVkIQGw9AK7Ri3GtA=; b=
	AlgG3I4ObtBzRttmLqrlceTqQ8n7DtQJ9PJocLt7lnaU7gPHeaEp9EUIaleyDNba
	5zf97SoEf+39iTu0XB6B/kMmpy0n2TqieoMBvv7gzDSTyKfQ/U03OXFCD6gsNPqK
	MBqt18+UZGFQ7OxykqK90gUr0ASldYB4gR5jF68UWHExTmHDVe6j/Je/o7qnoFna
	j7oxzuFcY2SRKHc/ofZMJfjyONwKpjd0BHR/hYUKVkstYtSOrbuphfa21nVElFA9
	ttAZbaLVFTOKySHObCvC6ojW8Mj3EMmTUGmFopF0XK3k0CHKFoSu4hqpVsnwW2B4
	Xxm66q+/GAoCftR6WuKw5A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41sn2cutbu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48PMMsFC010115;
	Wed, 25 Sep 2024 23:24:40 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41smkb2kfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MiNkFDQK7OtRT0ca+YPnplwcmdjJuHuG3wsh3+bfZ3RshlwIcG3SklsLCfgsSxMu4sWOb7xvYroHvdpu370VTAc2iw7U/41iypxW9esW8zYCDlUlh4bXOMShYANitDZMo6+doZ4prm80QFY2TEceEsNBqkq8SCqyekRCqfEwJUMw/MkHmCA3YrKwq74LqP6WgWkLyv+2GfuGAg+3qKP1/Xdw1hmjxjIOqzYycs61cmEHYmIk1OwBQ9kBn8dK2TOXBqStlC46CTempIBtifwsykKHKZtEqRkN6goKEFeYaXeXfckGCB5EekIoyNvIIaIgHxJSy6/eqdkwzYG6De6ZkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vXiJvRI7fnF7e1p9sgK0zH+kDAbVkIQGw9AK7Ri3GtA=;
 b=tyW3+x14JfTYx0IOaMMhft5VJBU8KkDaInm8Tt6Roh/ZFt5bno2hQbmLGxYFK/K+cJOdxeCU5bGjMGprPhO2Ai1y+c/VBgUsDbBh7K7w5JGo7H2ffwQn0sRpG4XGYm6reMCujYrmnw8WOeShdC4blpLlogwW8C9QwKJjfEFVi2yVMr+LlAMCbp1VAeetiImashhi9JczZW52itLvQ0gLCVYx3vqjlVtiR27RoxwmmSXzpBPo8dRBLX4h3z1suMhIihdx2TqTjQKzPus6J2W/ajcYaKcn4AFuAvDmpvnBVwGCsAJTp0aBqNh95BtPXs56vpGrpnKM6r4x7+gtw1LStQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vXiJvRI7fnF7e1p9sgK0zH+kDAbVkIQGw9AK7Ri3GtA=;
 b=etsXHiLuIri8rckrBCDk2CzhYOe8MpRiuT09xrdMRKxUnRKdfmlg/+dM411Ftd7hPkC7kpiyubf0jL70Tn6jQWj9lpFZOtFhbyg/Q6mbaxmEOL3rnoFtynk/AhHDl8df/kUmiM8mGXMuhHdZVV5L/vd1+JysA3OVlhWJ3oSaXSc=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 PH0PR10MB7008.namprd10.prod.outlook.com (2603:10b6:510:287::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.13; Wed, 25 Sep
 2024 23:24:37 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%5]) with mapi id 15.20.8005.010; Wed, 25 Sep 2024
 23:24:37 +0000
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
Subject: [PATCH v8 04/11] cpuidle-haltpoll: define arch_haltpoll_want()
Date: Wed, 25 Sep 2024 16:24:18 -0700
Message-Id: <20240925232425.2763385-5-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0379.namprd04.prod.outlook.com
 (2603:10b6:303:81::24) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|PH0PR10MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: a994edae-7320-403e-83bc-08dcddb938f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2+He46q/8wWNfB1VvxgZFMLJ7Yo5fSn4jyLkZ4A1EYMnrMrNsFFFxpHVqEog?=
 =?us-ascii?Q?nT++fJbbXtmsarJamNXZ991V0qkFYu7hK/fLyw9OnUDE3KKKaIXZ+FtNXFRj?=
 =?us-ascii?Q?vvwG/1j0WF3P7o5nxDLZa4FPt+ziPXgUfBr76p8pFC5EN0g0dyM0OYCQoM46?=
 =?us-ascii?Q?qOb438rPiwPClFB+Vc6/h2NQ7LfkqpRANAObXsAwUn61HShSksmNhrdy9WYv?=
 =?us-ascii?Q?9vQuEV/sAQ9wocccJYettK2AN9hSLokRRtD+iaP942HNSRQ5LxwFZJm6soOh?=
 =?us-ascii?Q?vysfd+CbqHbOkXdhcJTp0UW3VT9ZxLLpTtfDBt9z7NoSTiAk5zCJVnnWenQC?=
 =?us-ascii?Q?87SMFAh2oV58EBUMolkqKeMC/B+zQ3QQ0+ox/RTYmI5HDNVUVw9iIPRTPN9L?=
 =?us-ascii?Q?cjUn3PxCzoVwQGpP1//Qu+imxXn2ID/mMj9lSJEmaHX6NhVy3qBUu0zKim4P?=
 =?us-ascii?Q?J+JJj2lQ25ltaxKMScdG9Tz0kZSw7MABm7VM9XmCvw9a+etzsGWk5QiV+IdA?=
 =?us-ascii?Q?0dwkIGXHHn5Y+kHiW9EsbZotrFYkrrT3CA5h/s36xNgX7tGwmymIGkDP5kdw?=
 =?us-ascii?Q?cVqmpaQHqCedeVE2yWKk/tE/lWr0YBoaZt5z7e/SvTV5UhmDXAuDyeHIQcdV?=
 =?us-ascii?Q?doNNkSerFYbLE6O83JZm9R58BJZ6ewyefn1WYzLRQLXfGFk3xDRV0/QFbija?=
 =?us-ascii?Q?g5ibztTjkKUZZQzLZVrhx7CRAPvar7YlShetCDKNFfNiDmwlX1KSI8mLxXs5?=
 =?us-ascii?Q?GY7wBv7O1PniXX+lYaJj5jdj/r8ENQFyFs469/B4loUVHONFcJgQuuVyD0GR?=
 =?us-ascii?Q?N7a2YMm2Q2IwJU3hc7DCXyUMXQZx2MG9fZjJ/z6Gb+An2FvRmFevS2LzPpbE?=
 =?us-ascii?Q?e2mDecQul5xo7cB6nWWIJlfohvP8r69hAmYsnwXOx36b08h3q5fBDQNdeXWS?=
 =?us-ascii?Q?J+Np/6rJJTec0SUuYTsxgeak6gJWo8XSekKecpdB1jZY7r7z0RBalaXOTq/J?=
 =?us-ascii?Q?g9/DRwLIWXrb+KKEy/WrWAqubLRDmOBLwlobvNrHHFh4Jg9l0sZnAyjGckek?=
 =?us-ascii?Q?nrUSdEKSqUoRgpX5a6M7pmjZ83/9ezvIzZDRlQMODaAHO8U7P3LrUwfG+Chw?=
 =?us-ascii?Q?jwaLRuzDhTC9Zbgs66YX9ughXIiZUcMq4+INROGPE+RYV/PLo3xPVH6GEBPG?=
 =?us-ascii?Q?EGKkNPItUmfFWXKYW/zPS+KcGANkVUjd8F8Q57098Lsgaf3cCXBsM5XdE1DW?=
 =?us-ascii?Q?ikkr8suIW9MBDJdJ+BxZ0H5kDJHz7cL12Y0S+QGY/A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c1zWa6P0DMqcNpNxygZ2nbPrQxzF/n/FpZS/XOuDA6QrXkvWL+iblP9vk//H?=
 =?us-ascii?Q?zgjKXLkkordRvx1yVofmNchXTmGTRvZoPwh6pPRLN7jFTeZXGAW458epXJxu?=
 =?us-ascii?Q?BNxvTCfuuHI2gkQjdd94ELJKMhGOivfX2z2QqU+ilaGNs8TQ5JesCuFZb+WQ?=
 =?us-ascii?Q?RPwakDjcz3gGyL09S7pUAju8KHNBSQece1inABMTwVQLVAw7FWI3cGPloG5n?=
 =?us-ascii?Q?CvcROBDQMadJ1rcDHutZqAW8kN3DtDbPPJNx7uNfOLfyn1cfvLtZKfvklx5W?=
 =?us-ascii?Q?U0jU7zCjiwBvCqD0JpTWl5RKEXJqnBLXWhmnLoDszOxMjaoiRB790x1eprhI?=
 =?us-ascii?Q?2hjfHxACCfhHmJPGczAkBdcpRbL2fN+KpWci31ib9a3j3nKt9xa4ME6yIFCz?=
 =?us-ascii?Q?tg8mKkvTVLD2YoE0ilCVWro/niYq4NVR+kV1g49tmCmKXW/OfQG9tBdLGKse?=
 =?us-ascii?Q?QAfLy2vjywe+hx9gvu8ngzBuS0QOFdTTb37b2/hv+wi6dy7/uMCKqeX+u6i/?=
 =?us-ascii?Q?wXctFRF+A6G+X3trOFimA5UzT0SJXWlbR2/fs/6Hmd3gXyVETvXk4P48/f0A?=
 =?us-ascii?Q?B0O9NCGUUCLxFEKZmPnHd+RqpnSJNNGvIqhXfBjyv+iJ1h/py7Xeum0r99Gx?=
 =?us-ascii?Q?W8bKKDZdhhOYK4xwhyJ8Yo90Mr8JUMRO5T6rTbqvEqGeC3C81CVubPDyEfKN?=
 =?us-ascii?Q?cV1srHgtOAurAngbEePc5Fh67tJDrkuzj+FMj7AvTol6BfbN60tOkgwjbiM9?=
 =?us-ascii?Q?c7tJexVyknKfjx0d2B3jGig5YuEZdAVD5uPAOb8lmL3LSN3h1CVAah+KfWgz?=
 =?us-ascii?Q?HF/kgaDTbH6QlIaSn3pFL8nyDnZopQyfXSwz9emyy8jXGcfn2OKUTLtp9cXm?=
 =?us-ascii?Q?0kLKN0dghLMw09mFF2Lw/RmxN2HD0kt5IkXQtAWWryuN2LRK6lMJQNlpgM0J?=
 =?us-ascii?Q?zgkxf/Zsi74EwWyas29Pr8tgZ44KvFpCfGHpsRdhfcfKnTFU4J4LBx8vdmdh?=
 =?us-ascii?Q?rwyn1/RXqB62XSR9QHTzwwbmVQ9SgJEruCPwqma1voEhiF3wDD3cSMOihCo3?=
 =?us-ascii?Q?IDRNQsixJ5hwVmS0vF9HT6AJIaZF3808w7aSbH/MebjhJUTVPSjfei2grcdX?=
 =?us-ascii?Q?YZuB/T1ebb1iEVtTqpNjVBEaHLdXxr8cC+6eYCrGNXfziOcURbsXKWne9pNH?=
 =?us-ascii?Q?YN6KryrwzOzQfLrYAmj1TBndEmnlQgGCZllHjodDEY7VXPE62e70uBOXwhgv?=
 =?us-ascii?Q?JsDMp7PQLHiZyHBz1KZUbKneoKXCeUnBCCs8xJ0JZdVmDOt9BoClQ4y+Mbpz?=
 =?us-ascii?Q?U1efZFWki83TALFNPl+Kp2Aoumc9V34UScf6rjsfVhGBg7NoP+S34TkAIrNP?=
 =?us-ascii?Q?e1wnQ7siqe8DDMK0rvoIls8lxbKlHpPN0m7jDbYzB3gPuHZk21PlGM5Yf5xT?=
 =?us-ascii?Q?GSngrdDWRZ+BEyx799mSTcKVHNz8QoKBEnxC3KoLWlOj87RDQqr0wGBy+xS5?=
 =?us-ascii?Q?8onupmpcT7WmLu88yw4mKJeo5Hs0jYbJhzHmAXXIK76tWIhvI2NH5eXTgcSC?=
 =?us-ascii?Q?hqDxnb7KTM2Aq/cdpV/RB4P7/MPS0sLlOel9jbEhsyFGaM6+4Zov0QbfU/tR?=
 =?us-ascii?Q?HQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fEen+LL9hGGlIvZfMmluxYlWVy/+GtSu2VHHSQDPR6tXT3UqVMaGxICYsb8HVanynfLAEwUBjs9G6NQLi1VFuwULVP4Jlcc2g5B0T75wqLrZcTbaE9LDXIDhcpMlN/6RJJbTOscP+EwUfXdvo/FpCX9JKC5bNKSuddbzT9BYVwBdFGT0+qfY3i1lslEjaO2Jiyrek2SnySLDzHZOo1cd299e0VbmZzW9XU4Qu0fE5hlzsHSbs+KrR7WD3QxYcQKhPuXcPgldxfYdM8e933tEOyWUZt9RkBOHkka/tw+TKIhHpPMZOGHQ+W0tnxlveN/Vgs2mKhtO184YjqlSG4GntlDfBLSYha2nzY0idZTYMUrA7hHrFpzO+O6zgXwOGfRmZV13dv+sBnvCBPa2vihapSmEX0cvZYm7ueWFy/isinh26iQhvDIRGYUZqnISjkdpwUDJPMk0d9WLjeDqS2/icn8Sw4ABVzvJ93rRmWAecFm6nwLkoxbO+ehlg+FYA8g6yTG+qjREtEBGNvqJFpPwNZLhwooXLFwfWfu7fY+sjI4dcipjr4DrwmcAy4JwoJVLNLwauYoM4RwlcJmVhJA0mEtT5DSEAXo4F8ire7ivlHM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a994edae-7320-403e-83bc-08dcddb938f2
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 23:24:37.5360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7BVQsWWAjvrYDk2DMAlAJl4jgEa748hnXenfooKYjlG91hIiJURiLP2B/EiQE4YGz1ZxiaPw16L5k/NVd9ylpIwd4COGx4lWZc7SLIvTW1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7008
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-25_14,2024-09-25_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409250164
X-Proofpoint-GUID: KK9I7zk7DLS4dA90WFxBM8VZjcwFjjdA
X-Proofpoint-ORIG-GUID: KK9I7zk7DLS4dA90WFxBM8VZjcwFjjdA

From: Joao Martins <joao.m.martins@oracle.com>

While initializing haltpoll we check if KVM supports the
realtime hint and if idle is overridden at boot.

Both of these checks are x86 specific. So, in pursuit of
making cpuidle-haltpoll architecture independent, move these
checks out of common code.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/cpuidle_haltpoll.h |  1 +
 arch/x86/kernel/kvm.c                   | 13 +++++++++++++
 drivers/cpuidle/cpuidle-haltpoll.c      | 12 +-----------
 include/linux/cpuidle_haltpoll.h        |  5 +++++
 4 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/cpuidle_haltpoll.h b/arch/x86/include/asm/cpuidle_haltpoll.h
index c8b39c6716ff..8a0a12769c2e 100644
--- a/arch/x86/include/asm/cpuidle_haltpoll.h
+++ b/arch/x86/include/asm/cpuidle_haltpoll.h
@@ -4,5 +4,6 @@
 
 void arch_haltpoll_enable(unsigned int cpu);
 void arch_haltpoll_disable(unsigned int cpu);
+bool arch_haltpoll_want(bool force);
 
 #endif
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 263f8aed4e2c..63710cb1aa63 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1151,4 +1151,17 @@ void arch_haltpoll_disable(unsigned int cpu)
 	smp_call_function_single(cpu, kvm_enable_host_haltpoll, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
+
+bool arch_haltpoll_want(bool force)
+{
+	/* Do not load haltpoll if idle= is passed */
+	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
+		return false;
+
+	if (!kvm_para_available())
+		return false;
+
+	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
+}
+EXPORT_SYMBOL_GPL(arch_haltpoll_want);
 #endif
diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index bcd03e893a0a..e532aa2bf608 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -15,7 +15,6 @@
 #include <linux/cpuidle.h>
 #include <linux/module.h>
 #include <linux/sched/idle.h>
-#include <linux/kvm_para.h>
 #include <linux/cpuidle_haltpoll.h>
 
 static bool force __read_mostly;
@@ -93,21 +92,12 @@ static void haltpoll_uninit(void)
 	haltpoll_cpuidle_devices = NULL;
 }
 
-static bool haltpoll_want(void)
-{
-	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
-}
-
 static int __init haltpoll_init(void)
 {
 	int ret;
 	struct cpuidle_driver *drv = &haltpoll_driver;
 
-	/* Do not load haltpoll if idle= is passed */
-	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
-		return -ENODEV;
-
-	if (!kvm_para_available() || !haltpoll_want())
+	if (!arch_haltpoll_want(force))
 		return -ENODEV;
 
 	cpuidle_poll_state_init(drv);
diff --git a/include/linux/cpuidle_haltpoll.h b/include/linux/cpuidle_haltpoll.h
index d50c1e0411a2..68eb7a757120 100644
--- a/include/linux/cpuidle_haltpoll.h
+++ b/include/linux/cpuidle_haltpoll.h
@@ -12,5 +12,10 @@ static inline void arch_haltpoll_enable(unsigned int cpu)
 static inline void arch_haltpoll_disable(unsigned int cpu)
 {
 }
+
+static inline bool arch_haltpoll_want(bool force)
+{
+	return false;
+}
 #endif
 #endif
-- 
2.43.5


