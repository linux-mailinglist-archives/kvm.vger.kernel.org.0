Return-Path: <kvm+bounces-25579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 15465966C9D
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:37:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C12E9285AD6
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 22:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA3FC1C2DA2;
	Fri, 30 Aug 2024 22:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AJssfwVj";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ha8lQxB9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4117C1C2318;
	Fri, 30 Aug 2024 22:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725057418; cv=fail; b=loBZ47m2WGhbFsgs8YXgtd8F7K92xPxxx+A7iZQ7p6nOgIoPoZy1G+WUXTlxc2iE78X8u+Ee5d7vsmgBI33C9xKeSaPrgxZ+NGYM4cj0FXZ+jOL0b9WRWNhPNC4dnIjFPGeAloZvakm/zb41ZUR8wekm3bClG2K+ttb4+feb4Ng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725057418; c=relaxed/simple;
	bh=MvyEx4JVXVdvnMRbxku06bh+8Q6gUurTpu9R0bkwpDU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hnABC2dYEx4Xa4GgGi2qlaibvkn84kpvrMlxbt5bwF6F7Vv4vMtvcSKlDD4QxbQze95y6mpH5AeII0oXoejARcQHakdXjj8yFaVyKj/ac1NM6dBUQ3w4K70yTEmXc0uaOw8NzCYOLA1YmOTPu3uWPdPvLDpq39YhtlvO7vm7hzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AJssfwVj; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ha8lQxB9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47UMNAKL030649;
	Fri, 30 Aug 2024 22:36:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=rumBJ123mj0AOjrTxzTEs5lY7DqFY8qwAn61RRWrZgM=; b=
	AJssfwVjjLDf25M+uT2wt0R1cHtVHq9ZVI6OAjv65jZ/we2IitS1uo7ap4z5x3Vs
	6/19Ogi1cQzp3dVsugSQZyL3PSzfWiH6hRLlZ220htYSJLPMwWE4LBWqNbR9dLig
	xpK8Gjo3I6Oev9bUEF8SJfy9+HZCH5mQqTo6sXDigKgNtb3dIkQY4oZFjflv2pQm
	g46i1deINZeDcj6VC4k30j6Qyl4HJTg+ghKSD+YLEGvnPUtf7G2QpPITc/P7T097
	LQs1j+eTdLGjeLeE+b029wH55PTAodKtBFSulaC2Wza4CeNftRY70DfzT908rSjI
	DPR9RSG24SymT5Qom1N42A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pugyr9f-11
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:36:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47UMDwMs016875;
	Fri, 30 Aug 2024 22:28:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 418a5wya2f-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:28:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TOEOmoB1a16Xli0MveJFv6uy2Sm4sRPjco7NK4zytyBPA/rRDGb469bYdLZyZk0sigNX0rUQzi8hD/0CkVeSrUJnjYdU292ESV6LO0wT/kVZG8sSrsHRKNa/5te1fsAOTmv/FEdMn29xOP/qIEXxBr2cqe1yY+/Cwj621DbkfW4uzEkTQrlQOAp/jBsvEZnLSyzCtdeMpDiPKn/Vn6aXZSIYqUNly2m6fPMKnowLyJrBZBcz2IZFDlTeCE5FMVvfxar5lDCMCxGGeXzfnKf1NuTuRcJ8KdwS8XGOwW2tDGF32HqB6/IwdJe3cAMeOu1PJVIY2ESFXjtT7XDnhIxTRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rumBJ123mj0AOjrTxzTEs5lY7DqFY8qwAn61RRWrZgM=;
 b=W06ItfAeQvfnSzRmaV8Ctv095sKOk3ZlRMGrQVovAuq6uHOGHx26wsQKYUKKBez67rpRGr1z0VL5wdMo6C/pUVcKHM836jft05D55kgewHNgULRu5pOHiEwcyykf6g0ecCKq9WfA2XUJzfBGZV4G8183gzDlH195/omIAy4rJBKeMf24LBVkcIGbmd8ee5R4bzHJwsM8diDWyoq9X0RKlyDsIJYvrT2lnenJsCDuIyl8c3I1d2aHL1CpmUh7zhOIiK5AcEg3ZjMFU04meP+khuUGUERRatFAMMlTJ7OvzpLuIEmPikY1pZPtBHpzIn8+tgvAAm/K3gVj5IjlwvHRWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rumBJ123mj0AOjrTxzTEs5lY7DqFY8qwAn61RRWrZgM=;
 b=Ha8lQxB9FgdQid95/LhcCx2d77b7qRumAykiBATSHLcr0J0dVGh6BxmDmvA4kLHQ8wm7r86HwFigQ+IE2hvawgLXUBUI4DVWX+xMCr52jw3dqMudX9ZGNyHstmLBf/3Xr0ltkZ39nJ3nPwqzrKpNZ5aaYlpK97rkpofduME3CBg=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 22:28:51 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7918.020; Fri, 30 Aug 2024
 22:28:51 +0000
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
Subject: [PATCH v7 02/10] cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
Date: Fri, 30 Aug 2024 15:28:36 -0700
Message-Id: <20240830222844.1601170-3-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: a07cac0f-eeed-4e7c-7e58-08dcc9431fb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l1ivSVzqI6lf4e/jX5273I+gP2G6Af8n5zwD3LF2lj1aIkPHz3iU7Y0m9P3Q?=
 =?us-ascii?Q?x6H2WTOBjMqNf6sGys9F4re4Q94L62dvTbRSHvsIHpFH5RzkiwthO9SN4qKm?=
 =?us-ascii?Q?ayZ+DsOkHZB5K9CIc2Y8Yst96iUeANk8JH/DJJoG+dq4MdneEhlF5vUONyen?=
 =?us-ascii?Q?GXDpMzoonnSs1o9bkzo8ZEiV57V7GTMMqgTWiJVChQNdvXJNx/JxKg6sc0vm?=
 =?us-ascii?Q?FPa2Vr/rwEYdIj8EPNUdf3ZkraxM+xChyywLIKKzZSvt6q9VmdAiStEb3ZJL?=
 =?us-ascii?Q?cDvh+nCjs8JmnrKGv7XNyWw9Hds7PdQpqCIWRolwK0Pe2hFrdi2klwxJv5NG?=
 =?us-ascii?Q?pcGlE8T5MnPk1H0z2f75b6HaqdoMu8nh0jsfSVjNzfYxu8qJ/BhS/Gx+iddM?=
 =?us-ascii?Q?+Cyqu5K+eO8qPk0cW5XOyw55r8bFmA1T/G9dyR6wdA5lclUqwFgXg14Oy2Z6?=
 =?us-ascii?Q?GIxp5zLRM/wMWtEIV1iSGC+XQv+CvqXSJFb4/c+vPqrEjJeCI7E87SbJNeE8?=
 =?us-ascii?Q?9F+08Cjou7iawzgXo+ZtVER3+Z/Vmz6cVxGs+ZzNIrwzSCnA4BHh57/pBY7g?=
 =?us-ascii?Q?OVNNCSqJSWiStK4ozTmPSCD9lDwR8orbEMBGwpppZ5I89R08+l2+70YLzXjp?=
 =?us-ascii?Q?YRyBGWXtwcWJFpIFxR6gNlvshmicADLDMnptSH/pPuddzJgfpqcj36fLUCsI?=
 =?us-ascii?Q?eDT3iCmJLEfSv/fPwa1dSUYfi34ZE1wmQvlzsFzV5LtrussqPj2WByrc+3DE?=
 =?us-ascii?Q?Pix8zMC5a0ejJ/QQF6pjGqJEk5ryoxgBFJz0X+kp/QPvERsVdeSipUtt4W3f?=
 =?us-ascii?Q?HjgAzRE3GPOvgByYIyLs2k7Hbe7nRESFGWb1oGllRrneNZHklv5xsWzjtTmU?=
 =?us-ascii?Q?bYLPG9ND9UaJyOKCOe0Dmbmx/8EyPwK6qEasXi7Y5D+GMfkA2GfxZUMqDkCK?=
 =?us-ascii?Q?bORl+ztIr4XgG2MF8+nzNmvkBl8qk/JmN1EOhtauI0O5DKqxjljhRgVZ+CmC?=
 =?us-ascii?Q?ZFj3RslxYdkRSAiw8+IZWCp/wahNHEWPHx18VfixaKzAuKZbWdd2AV9/Qi+4?=
 =?us-ascii?Q?w7DpeOTxnDkCcmNa73xiLc5KWnMJ1AunB/63TC+uhfSmIQSV2ABlqLc8iVvC?=
 =?us-ascii?Q?R6KUmpkNUX9koRIYpzT5P+V9LEpUvyIdB4RuRcVkjGoMeC70TeEYVnPmojHF?=
 =?us-ascii?Q?bu3cnqwLO+Pl8b4Lhxs3z+XkisV7p4wmKCX53NVZ/k7q67VkH48mL3/HqFeU?=
 =?us-ascii?Q?4n44HLuQgdDL+6xLORKmIhBEaUROem7K6j/AJzsOXFumpmz6obVciazghq95?=
 =?us-ascii?Q?oAy6pWE1LRqQ31qMO/7gTMHgmUlHky/MTh35Fxjus4vBbg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8G3ilbNV0Ox7BbXJqbskLjsWqkL+6wqPxUFAMT0eNkf3onI1iKOl7gmfJ9AL?=
 =?us-ascii?Q?wfXF4ppvqfp90KK8gBi5hXwWyzcqwxsD18MoqK+T4GRW2XplQ/+RHqdRe/Nn?=
 =?us-ascii?Q?gpwBd1f98fwHYuEtn1G2GLFqdYzOm+Uz/yjPd0nRUPugvKQCZBSltP3L5UzP?=
 =?us-ascii?Q?I4pRLLdNC5VGA2y0CBNR7FKmSWKlIbIg/cS6GCypm7waF8IVVDbjDR8sT3uM?=
 =?us-ascii?Q?ZiNMHjTDz64rDsUhar8/nw4ph5S4EznkLC4n4Rv81zxlUkvqJZV4c5/jMcrk?=
 =?us-ascii?Q?SegaJXEH+ZINBWTQBkGL05SlCv2C6xxVHfRO7LVGM0uX4YAnt1PWTWMfuMXS?=
 =?us-ascii?Q?Yy4864lRYe1jIrJS4VhALYWFZtkVyQHdRRuheMsbQJ1Y0MYSUfQwrslqUvyE?=
 =?us-ascii?Q?iIok6+fTdjyf7iWZwS0E9Nj3SMJfonfUpuj5ne6lfMgSHmNLdGnUhL9hJcQL?=
 =?us-ascii?Q?sORhINa41UuW2q6mGExP1Ar3mphc/pG8UE5UyHBYAAFv7tBe8PP246OKWI9G?=
 =?us-ascii?Q?g1jqidpfzgZkXRhQdYPmtj2dCJg1LqctlJtD2nruAcNgJ17EDjpKDb4LB6eQ?=
 =?us-ascii?Q?ZBldKEhy5wSc3b4ODn5/OhSng7iRYzCxFC8NhW3OCG1Hzf+DmvGUZughlBQp?=
 =?us-ascii?Q?TRPVHWqCOEZ7g05+8eDirpOYv5ow2Hz0A3tl1xG9MvL3U/BBidaewlLM8PIX?=
 =?us-ascii?Q?k+KV9wUV2vrN84SuabcVoLw2EwVz5DL5trTAtOhgQE9x1qzsJ/yAx3f8bTEV?=
 =?us-ascii?Q?v23aTtoMRcDn9BJqOrAxHeSC+ePKrTFBTKnN06ZVmnV0V4iTZ8Z9Rcs9caYB?=
 =?us-ascii?Q?Sz5tjBwoIkDgv5bGUKakjzgVfEe6aWoGeqrWJoDje0pLjymh4WdZvJh3wJE8?=
 =?us-ascii?Q?yZQgLh/5BrBAP0sTi13FwE8a3tB2YQSSkwXv+5T209zKt71m+928D6oxl4s5?=
 =?us-ascii?Q?3B9+6yw5IcN/e0zF6v28mZA6HnIJRNDPZSD4y5EuubaFxHXbSHUrOMLDPdyJ?=
 =?us-ascii?Q?VXkdLywk0TwbQKWZVv0iC3Vxl/VnX6w/6CVMnPKhfg5VDFGOY0ujqsGGeoW7?=
 =?us-ascii?Q?RqzXq18Mp2vxtCZj1SyJ5jnf6+k8+7RDuqnRXQ27TyXABj1JqjFX6/39Gq7G?=
 =?us-ascii?Q?ywUjZ/f4O0lxHd3hv2XX9BlfoIp4Id4LEb5NwrfDVnvsAfrKZ2sX1BtOyx66?=
 =?us-ascii?Q?Z878bBn/zr8LfSKrKSDOqAkIdyXSAMmgPuFJB6JrdbhkhNU16MiYD3Ai2+ON?=
 =?us-ascii?Q?NKADCTiE50TjeUovlWP8A1H6bqq6FxU1ADxVgq6YpwZ74YAA14mtZYjrb5U2?=
 =?us-ascii?Q?VO0gHh0wlOhAiKRiEtVbmqEWMmWLpeSSEFyOUkDm+HpvveHmK2yQOi1xgUYc?=
 =?us-ascii?Q?caeiOXYoNemHherXLeynpb09XV2+fzuuoPBD1I+e31sug+peL26moIQp/pkY?=
 =?us-ascii?Q?Cymf8Mhh27ux1JVpiS67V50mmdejlNhWAPpXMqzeUcv5j6W5c9gQRcMIxmbi?=
 =?us-ascii?Q?76RMK7DDkXCAEWqkkEq878rzFzFRtOQCdlsccu4mbtye3F120ufNBCxtxyf5?=
 =?us-ascii?Q?59Wdg/4llr4SGZyRV1mV1v8pzJRH/MpDSu1KhFQdmIB+GCdFP8eHMnPxpJuo?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6aT0dVhVGYjStRN7kOiEyCEM8dDFT903yp6qRCfVDQ3thG5Qdmi3jD5PiR4mpNndk4UgDlTb7KkP07KHCVEZhcvYKQNZmIRRPPV8eEPeDBferATPrUUWFkbzy+3UqXDn6WYzmdOdAFbau5mstpuQNALqYPUlMCZEX6pKW5SNrPdAymZ5QWkcUDgOj99HUejXHS6jA4o8/kgMMf2PBi/ZxaIfXeq/DLbNtCBkMfQ8dyomifzfVkS2QKb816ncHbQzvVUgzguv03H1rbEE2NzAVZHYNqvKtRPr24B5qNXTFRBoqTzCerOFIH9o7p70CKg/x2JGuF9YHz6ItKgPyA7zDMVfHocTpYoP7aLgqt8NTzyB+jDSob1gq1DbzqarNzXNuN/yRfivuv5uZt5AECGYRv8Ozj8kqAkl5/rw2w0oDOKtXDqbfRMunFRY9tqm+JiSb1uvPxjbTNXJvYvHs8SYh4578xm3V1KWTtAd/rB0GWcdOSrVxkRqjx1CoVGde49D/iyrsq5l+NaatRp40dLwrNHrOup/22lVGtZuFTnWAhm2La+Qb99NZ/j3HLQPnKBuI0d6D9s68njfnoM4rQ/rZKfKqcyy5UV5fQyQ9fFZhK8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a07cac0f-eeed-4e7c-7e58-08dcc9431fb5
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 22:28:51.3700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DckVOwz9quvV90ELhBJith+ksxF5N9VvSSde5SoZ1SOfrihKK525mZFa5HN3Vja3xPkI4XUJnkQJ1tArbxV0v1DE8qfHbbRClN51c6dnprE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_12,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408300174
X-Proofpoint-GUID: 8gCfYSgDybX_XU2oGZnpes6XVUqabu7C
X-Proofpoint-ORIG-GUID: 8gCfYSgDybX_XU2oGZnpes6XVUqabu7C

ARCH_HAS_CPU_RELAX is defined on architectures that provide an
primitive (via cpu_relax()) that can be used as part of a polling
mechanism -- one that would be cheaper than spinning in a tight
loop.

However, recent changes in poll_idle() mean that a higher level
primitive -- smp_cond_load_relaxed() is used for polling. This would
in-turn use cpu_relax() or an architecture specific implementation.
On ARM64 in particular this turns into a WFE which waits on a store
to a cacheline instead of a busy poll.

Accordingly condition the polling drivers on ARCH_HAS_OPTIMIZED_POLL
instead of ARCH_HAS_CPU_RELAX. While at it, make both intel-idle
and cpuidle-haltpoll explicitly depend on ARCH_HAS_CPU_RELAX.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/Kconfig              | 2 +-
 drivers/acpi/processor_idle.c | 4 ++--
 drivers/cpuidle/Kconfig       | 2 +-
 drivers/cpuidle/Makefile      | 2 +-
 drivers/idle/Kconfig          | 1 +
 include/linux/cpuidle.h       | 2 +-
 6 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 007bab9f2a0e..c1b49d535eb8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -373,7 +373,7 @@ config ARCH_MAY_HAVE_PC_FDC
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config ARCH_HAS_CPU_RELAX
+config ARCH_HAS_OPTIMIZED_POLL
 	def_bool y
 
 config ARCH_HIBERNATION_POSSIBLE
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 831fa4a12159..44096406d65d 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -35,7 +35,7 @@
 #include <asm/cpu.h>
 #endif
 
-#define ACPI_IDLE_STATE_START	(IS_ENABLED(CONFIG_ARCH_HAS_CPU_RELAX) ? 1 : 0)
+#define ACPI_IDLE_STATE_START	(IS_ENABLED(CONFIG_ARCH_HAS_OPTIMIZED_POLL) ? 1 : 0)
 
 static unsigned int max_cstate __read_mostly = ACPI_PROCESSOR_MAX_POWER;
 module_param(max_cstate, uint, 0400);
@@ -782,7 +782,7 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
 	if (max_cstate == 0)
 		max_cstate = 1;
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_CPU_RELAX)) {
+	if (IS_ENABLED(CONFIG_ARCH_HAS_OPTIMIZED_POLL)) {
 		cpuidle_poll_state_init(drv);
 		count = 1;
 	} else {
diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index cac5997dca50..75f6e176bbc8 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -73,7 +73,7 @@ endmenu
 
 config HALTPOLL_CPUIDLE
 	tristate "Halt poll cpuidle driver"
-	depends on X86 && KVM_GUEST
+	depends on X86 && KVM_GUEST && ARCH_HAS_OPTIMIZED_POLL
 	select CPU_IDLE_GOV_HALTPOLL
 	default y
 	help
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index d103342b7cfc..f29dfd1525b0 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -7,7 +7,7 @@ obj-y += cpuidle.o driver.o governor.o sysfs.o governors/
 obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
 obj-$(CONFIG_DT_IDLE_STATES)		  += dt_idle_states.o
 obj-$(CONFIG_DT_IDLE_GENPD)		  += dt_idle_genpd.o
-obj-$(CONFIG_ARCH_HAS_CPU_RELAX)	  += poll_state.o
+obj-$(CONFIG_ARCH_HAS_OPTIMIZED_POLL)	  += poll_state.o
 obj-$(CONFIG_HALTPOLL_CPUIDLE)		  += cpuidle-haltpoll.o
 
 ##################################################################################
diff --git a/drivers/idle/Kconfig b/drivers/idle/Kconfig
index 6707d2539fc4..6f9b1d48fede 100644
--- a/drivers/idle/Kconfig
+++ b/drivers/idle/Kconfig
@@ -4,6 +4,7 @@ config INTEL_IDLE
 	depends on CPU_IDLE
 	depends on X86
 	depends on CPU_SUP_INTEL
+	depends on ARCH_HAS_OPTIMIZED_POLL
 	help
 	  Enable intel_idle, a cpuidle driver that includes knowledge of
 	  native Intel hardware idle features.  The acpi_idle driver
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 3183aeb7f5b4..7e7e58a17b07 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -275,7 +275,7 @@ static inline void cpuidle_coupled_parallel_barrier(struct cpuidle_device *dev,
 }
 #endif
 
-#if defined(CONFIG_CPU_IDLE) && defined(CONFIG_ARCH_HAS_CPU_RELAX)
+#if defined(CONFIG_CPU_IDLE) && defined(CONFIG_ARCH_HAS_OPTIMIZED_POLL)
 void cpuidle_poll_state_init(struct cpuidle_driver *drv);
 #else
 static inline void cpuidle_poll_state_init(struct cpuidle_driver *drv) {}
-- 
2.43.5


