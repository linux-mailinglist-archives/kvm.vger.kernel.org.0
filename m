Return-Path: <kvm+bounces-25578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AAEE1966C9A
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:37:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A9C91F23F05
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 22:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2ED1C1AD4;
	Fri, 30 Aug 2024 22:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OlA31Yer";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OEjhN7Ku"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D1A1C173E;
	Fri, 30 Aug 2024 22:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725057414; cv=fail; b=G5Ifj2bfRT5pih+bVR6TA5sRFEa46Pvz9nQo8RXlzO+CSHc2eNg9VbMZ7Rrrw/uNAdBAcdKMRsU7RYFUJmUMJN80OVZxnV2jr4WtdwuxWFkxTVsrUkAUSbrwfwb+dM7kj779OpJihDOgVwCc/9qzvAR/p5kqvxlIwCdINtAtNfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725057414; c=relaxed/simple;
	bh=h+LFmQ5q9LcaGHi0PrPQz7lccrjdn+vfUczNGQ+nieo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lCzBc+j0Ctv8UEAcE+7HcuiGLqdVRHY0YzmP2YzstHT1JLi4U00PdvvZvpovNqhWDH7tuSxts+6s/eU5+ZuBSoV2kiQF46BIoW0HkRcV1oJ33NiEtlafu6E0jkDZF8M3MINljrCgD2gLEyhhkwpp6sMuQTP644bzpZxzzUWvVVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OlA31Yer; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OEjhN7Ku; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47UMQJED002403;
	Fri, 30 Aug 2024 22:36:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=rbuyqEwZ9kCiw5l0O3EjN14l2WDqLsKvyF0jfbbj+zc=; b=
	OlA31Yer4jv/6q8s6pW+TgO3yF5SNB11UBX3BTxq9jAJLAUERLsitGTLKn8BecV2
	KZunCqvJ2VHq4DR79rBgM2qxfO3X87XVm7Gv0oDzD+9StD7Lz9X9kHqQgLV5NDhu
	aZEIKiJ//UERCAbU31qKC51udaLfrnZVPC/7VTVJpNeZkqQARJlcVIv51lts1Ufq
	3fcdyW9oBlSFjdTclv5P8mDRL48eMCmqcb5s7KeDS21GfwYzd3wt7uVBHKghHkPN
	2pw6Zasx0KFK+QmDBkL+3gteWIuhuQbfXf8g5/+2NiNe3uVBhQzajMoTmMivyDZG
	A0xYmzZCDCTehAGuR8zKLA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41bfjvgw2s-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:36:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47UMDwMr016875;
	Fri, 30 Aug 2024 22:28:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2045.outbound.protection.outlook.com [104.47.70.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 418a5wya2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:28:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=apb6Rh40/Q9c+PkTICkb55rPkZ0VVRkAHzxhUrR/VPQoa1Bkd8eyIg5QrrxZhNrny/SHyTSgWf1DSkpYAfAybvitDBiuc6fPP2H2dEkG9mK3eCa6HMYDK3plDqlfNHDq0SObKBGLyJhfpfpFY2qMhybXqLbW5QroB/35kugedpCFPaf0Oje7QYSYiWtiKLaXjX6b684eL62WNG9vhCY3YMeF+EJx8akj4uL/ulh6ItnwK1jVWW0y7+RaUOHRyPa89wakklkTGXkq7Ax1DW5pxzcXdZ/ig3dQ9a85frDc5t9yKt0XZMUwf0ne4HghvA4HAaS6/9YPJwanqY+lllB/fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbuyqEwZ9kCiw5l0O3EjN14l2WDqLsKvyF0jfbbj+zc=;
 b=XjF0dj6XrNMgk3eFFJaetiqLoku042lFNOVpCiMCx0gKHifyf4cRiQ5zpMr5xDF5eLlrHllPHziAx5CroUVwk1+Fks/VyBVRi0CJ7V0Y17o7GQ59RLf+PLuFBfRGeQai+dF/5ZNHIlF7baW+aIxIL6a8wnaGe/LQGrb1TN1x+LzuXekI+3afe3NBoUsRzLScKOkfzacWAH2KCfjIfpV3B9XlaBMg2r/axgos+wf/z/qPmawnR5wRIWwwx8vUIAI6h0NAGtkeNIEIQHyNEkVtQClL7Knu7zPkDHs6Kc83wyolOnKaSkFA5606a/lRgWssjMPfzQMJfwVFd2cG5fh4+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbuyqEwZ9kCiw5l0O3EjN14l2WDqLsKvyF0jfbbj+zc=;
 b=OEjhN7KubFH7Mwbjf6nP2xFmM4y3MRnw6ZskIgpvVbRAvse1bAn1I1VDYtiNZ78mYWfGT2f5YVI8O02y60IWnrjkpoZZDHFsjChRvYe93Ss2F1yT/OVSmIeCfYyyWfBgRqv1LlmcnZuKo81ESmA3BqeXCD1K8IaFJqWhql17q5c=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 22:28:49 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7918.020; Fri, 30 Aug 2024
 22:28:49 +0000
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
Subject: [PATCH v7 01/10] cpuidle/poll_state: poll via smp_cond_load_relaxed()
Date: Fri, 30 Aug 2024 15:28:35 -0700
Message-Id: <20240830222844.1601170-2-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::11) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: 14a002e5-2eb4-4f3e-bc10-08dcc9431dc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hk2DJzMSgwHs9cbGXF6tj1VeWdyq7vMQys//7+CH4gWPiOnTOTDtG9iw7w62?=
 =?us-ascii?Q?LcVlz9laVowo/TrMlfDXAjF63htKPmaNWZ9i5Aq/A9o1DAeQyWM4vhG7loGq?=
 =?us-ascii?Q?t8u3/Pz0Ad9p+ADj0YdPug2WLKFyIM17bYNRW4paERcgyC0KxyXL7lLGErSQ?=
 =?us-ascii?Q?2CrSq8PJuOYwUXsQ96AySgHk7GmvntsdoEU99DTX0Xtg9yycDUI0BxZjXS4F?=
 =?us-ascii?Q?312OBNbD9w0h/nunEZHB8WbVIVmq6Fb+j8Oeg8Vn6UVr+Nk58IZ+c781i8OB?=
 =?us-ascii?Q?owIzvrs4+R+NNLEed/DTLjOa7sIHrfKluay5Dr29IHinTfVS0bnqk6tuOtk0?=
 =?us-ascii?Q?mgpnBQMWiI+ZHsFZXoVXXRN7Y2zJTUhUHrF/KiIzvwuQlAB3gKrLmZjZdnhO?=
 =?us-ascii?Q?jkDc0vAbshy5G0VPLzeKR+7XwUBQQ3RLV6SBCSbg05sH7wwXVddtAubLpUqZ?=
 =?us-ascii?Q?j40BOgskcoWWW70sflga8SldLoKLEk7mJD69krd2inH3Kxr8MLxvV+irQnOC?=
 =?us-ascii?Q?vCFmO9aZfrSmsAoAeTy+XkJ5eRFCou6mu91D4WxKS1P0pBQ7O1gS6hpwvIYw?=
 =?us-ascii?Q?ELLq5llMDaegMkeMFBJKmkKTkSjXEWgRyj9SqOxP89cJ2PCBz0wsv0DJE7I9?=
 =?us-ascii?Q?0Bdf8GyW6/7Yt5XY2hbCpXI60wi9MOWOwQm12PDCXokTWYnZmA7+VC8TUqEb?=
 =?us-ascii?Q?R8VddmfHSfMtxzcINIoc7smDaKRcgQnTWGeUVNGQ4fpNqltOIwqvgwF7wkck?=
 =?us-ascii?Q?4TiAAdWA96MvxPkTVyjoo3F8qK5DsY52Kh7iJMouMiN2oJw5OvS/tcfsySPj?=
 =?us-ascii?Q?eP0fN5hEsTWtgxATshPCcor4NvEtnk643ii9QP/JRx+xba//0qkGbOBBRVs+?=
 =?us-ascii?Q?tXFdwlZ/uchxYg0u+bofWn1W0Q4wMLb9sLlRFzfdYdfH3YZcFiSKa/SzybG9?=
 =?us-ascii?Q?1pVveD2nMnAOZHpbrJ2QyiO7ZvGZIc1JtKODF0btVVTo7fAPoq35qh08tLZ3?=
 =?us-ascii?Q?dGP7QKSI+DkBCiwhn3cXmhVl3gwAhEMV9goiJUOalIa886rNro/KL9Hm2+dU?=
 =?us-ascii?Q?aWVMrYc3PGfQfijttTcoH3A/UT7wV77yFXVvnsc6x0QLq/xJNBsI4zaMkwQT?=
 =?us-ascii?Q?TzbnNPqocBiEcHUq3LT7DKTgAMP/x6uUDc0srAivLt1FQ6+7jbIae4K3u+Vv?=
 =?us-ascii?Q?FVbvppDi4BtRzQcOjmKcSih/2ETcF6faDYF1n7yDVe9B850GdVE5OVutuhOz?=
 =?us-ascii?Q?TDe9Ip0ZDtwADLHFyRiaA/8uBoAod3s9Rk3A01b+QBOzekqjyCVMuyK35THN?=
 =?us-ascii?Q?4QTtr429INxE3bVYUsKREujqr88QVyanHKy2RSWVYOCthQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aPDrg388fopXXtA1FqTDNj8Aw5VhLi+ftetaTzEHksGvD99CeV+yUOGMvHtH?=
 =?us-ascii?Q?MvMoOEK2CTNBoZUQ4lOzTWkuqH5acABoBLFRu5IjykPmYhMbLc/2dXmHuq3V?=
 =?us-ascii?Q?ki8scJ/mdjpOw2iqHChDhu9cHjXDRVdH21sDCGXeB7M7Ods3MCrxc/62vMbd?=
 =?us-ascii?Q?XgF9ndoY0WO2UXPb0tYC+TUDkceAdkIitzfuQcr4Ntq0mMPJF59sIw7EEZNy?=
 =?us-ascii?Q?8AtEyFpzFFautxirDVIDxc48CP+tR43O7u+N6YS86Os9uY3zYNmUmaozCXlx?=
 =?us-ascii?Q?Qu7XtoenN2J36Z8hMJ6tDkOdKXFwq4pUlABb0RbGFFOM1KeLSpgETfRaNKc7?=
 =?us-ascii?Q?3ZOz2y5zYY5wbYcnB33At0K08kfT05emQN0j6KleIIznE1Fkf1xDYIf+Wpwi?=
 =?us-ascii?Q?+HYMDIGrp4DpmwJd4+7jvN4tS+ExU7Uy573JTSwbv/XaNdRpLIpgHaK+uuTN?=
 =?us-ascii?Q?rPvPdG/N1TF5yE20mab9xV678dKpl5Cai1Cn/XHW0L2uopHE050GfJrKLd0f?=
 =?us-ascii?Q?u1hgKkDtpHKbGSxzg1G9FEbHqcyYf79ZRX+FsOthGUViCcnsH1++0vTOVMAj?=
 =?us-ascii?Q?jLhDdHOet0NY4QzjQdGz5ICg9QBg4RqlHTGrq7NZsvTdO5IdkFwO1MKuiuxg?=
 =?us-ascii?Q?5nPc6AoXVYr5UDkwcY3suMlsrzOX98qUeUZR6J3j0kPjzyodGOGfkvCw0IjR?=
 =?us-ascii?Q?9uVd8KwhRyyaR3dlbQVb9gKMk5BNiESKDchtiSG3fbKAYRmiKlEfJDNOLloi?=
 =?us-ascii?Q?aP5x92bDGlpYUbhbF3O+eaf6kTpiH5/hT+fmMyK2M0E7cifL5X8/Vdo08u9w?=
 =?us-ascii?Q?AdRbns17AJRYSJ2gg3lv7Gyb45+x6U4PXlgRSuf1HEP9w1KM21b4vuo7geLG?=
 =?us-ascii?Q?HEah0MdIWqWYBK3oc0eCKalverZvNSG8AujkP9i3QFBwl05l5fwZ5rN0JCc6?=
 =?us-ascii?Q?uIO0H1Cs2QWiydxoGGxvwoC5lYmhNLJdBOrkqUObrjScFWCohFrYMfanWohI?=
 =?us-ascii?Q?ogk1PM/krpfbzLV9KLrTtrQ9wshO/ul+nGFE+KmYltghkGqKkvV6xcrIhAnZ?=
 =?us-ascii?Q?agPIE5bYgFWD6xGKPHkn3AhN6N8a47RoKA+W7gCd5nRGIui39rKbrs8Xr9ZE?=
 =?us-ascii?Q?gDy3hffMxUdEMyVzpH09TrNYT1vKiv+4BSPMW3L2CplZh+5+ulj9uOIvk8UU?=
 =?us-ascii?Q?jeI9wjIg6qKe/cL9PW+c29qBtj7NfPkGV+rTpntlC1iMr+81y1DeSjeFwv0M?=
 =?us-ascii?Q?NUbXhdj+psTKMctqy8Gt1p/SPols4Ki31eaKkaDMSw6e1n1+kQknMPgrhhNN?=
 =?us-ascii?Q?/pAyc1/MOlZtf9foEjr1GVoYDevjamB3mo1KBKV4ONlti4bMtTRvrL9+kRpa?=
 =?us-ascii?Q?lOoFoyTQr6FBCBxSYN+J1UxTvmobYg+RGWnLpKXuHHhtxM+ew9OeKGedC7Iv?=
 =?us-ascii?Q?tVvhnc03lqJCePeBMwsTyik44WQ6K6Y2tb++YW65hdXQvzOAYSHe0Kp2vWGW?=
 =?us-ascii?Q?pN81nU7WBnXCVCncUMeUIMifGH9mWgpUnbEhtc4qp1l4MHxVoi9UnFjw3+rT?=
 =?us-ascii?Q?ZQe8FZqxD5vB+CUo4GYQM/ZQENnkrh8QFagfs4nMpXgOAjh8EaxOHNBdSlif?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	47cQkXL89vEFNkXQyf8XstdxNtxoVAJrkPjrx5TACoT4Zt78NJE0TWT3HUqD9RHpORfRCVxsMXQqL315IZGOQW1Uok35LB6ZwBkdeItqZZqZCG1tEfGnOhe2+dNGB6k9wQJvPPzDwJeQpZF5xarRrRkL4jMR/cQ35zmIiDFM/EAso0XEzpdkMzrAfVD1AFhRbgc2F/F+5PUnN4K8t+bfipAh+wNx4iQE7IZyZe0X9HptrfKW95NrrFgTnS2Dq8hknv7X4itQ1bd9PVDh2wxbsFEJk1faaCn6qNkFYRd7h8cPduKPr0ww/Gq+Dabr2iKI3nA63twyp6empP+cf2c9jFqu5zmO1xP4MRCIjeb3BjK5nIGIAPo+Rjf9MqlYwGxL3RkALSFxEtOlgJxC9hxrRbrHG8z5QPhQ8iMOJGy8X0OL2mIm4qItu1uJ5923quFz9Sde7trzCsJ7kmHfYD0w+hiJGPClg1qRtpQSCjoXYhfrGRxxGURYoY7RFIRtMd9yKWn41Jkd8QXSX9wzj1pa9XlqXCdkOq3BYP8XYOHqbXvnfM12Yk1QAXQBkaeuLmJhIjX6xk/a1B99hWSCd9LmttzfOkhfMZHiZDU64JY5YX4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14a002e5-2eb4-4f3e-bc10-08dcc9431dc2
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 22:28:49.6458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I2Usy6InFBD+2RiJ/rm7AfbogHGl3f46pbVXtUKaBrPXuAC9uUiAiiV9ANXQ+xW8rIjBOwTB1b9NTi9jdb5SGb9MFog148eR97hPVXp9QuY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_12,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408300174
X-Proofpoint-GUID: XgrMviXRTQyRaCWpL5k8Cv5LSY-fZY2i
X-Proofpoint-ORIG-GUID: XgrMviXRTQyRaCWpL5k8Cv5LSY-fZY2i

From: Mihai Carabas <mihai.carabas@oracle.com>

The inner loop in poll_idle() polls up to POLL_IDLE_RELAX_COUNT times,
checking to see if the thread has the TIF_NEED_RESCHED bit set. The
loop exits once the condition is met, or if the poll time limit has
been exceeded.

To minimize the number of instructions executed each iteration, the
time check is done only infrequently (once every POLL_IDLE_RELAX_COUNT
iterations). In addition, each loop iteration executes cpu_relax()
which on certain platforms provides a hint to the pipeline that the
loop is busy-waiting, thus allowing the processor to reduce power
consumption.

However, cpu_relax() is defined optimally only on x86. On arm64, for
instance, it is implemented as a YIELD which only serves a hint to the
CPU that it prioritize a different hardware thread if one is available.
arm64, however, does expose a more optimal polling mechanism via
smp_cond_load_relaxed() which uses LDXR, WFE to wait until a store
to a specified region.

So restructure the loop, folding both checks in smp_cond_load_relaxed().
Also, move the time check to the head of the loop allowing it to exit
straight-away once TIF_NEED_RESCHED is set.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Reviewed-by: Misono Tomohiro <misono.tomohiro@fujitsu.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 drivers/cpuidle/poll_state.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index 9b6d90a72601..fc1204426158 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -21,21 +21,20 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
 
 	raw_local_irq_enable();
 	if (!current_set_polling_and_test()) {
-		unsigned int loop_count = 0;
 		u64 limit;
 
 		limit = cpuidle_poll_time(drv, dev);
 
 		while (!need_resched()) {
-			cpu_relax();
-			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
-				continue;
-
-			loop_count = 0;
+			unsigned int loop_count = 0;
 			if (local_clock_noinstr() - time_start > limit) {
 				dev->poll_time_limit = true;
 				break;
 			}
+
+			smp_cond_load_relaxed(&current_thread_info()->flags,
+					      VAL & _TIF_NEED_RESCHED ||
+					      loop_count++ >= POLL_IDLE_RELAX_COUNT);
 		}
 	}
 	raw_local_irq_disable();
-- 
2.43.5


