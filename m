Return-Path: <kvm+bounces-49557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1000CAD9A49
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 07:59:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4CF6189B8A7
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 05:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 748181DF99C;
	Sat, 14 Jun 2025 05:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pXupPLby";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RR9gh2IX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81242E11B1;
	Sat, 14 Jun 2025 05:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749880745; cv=fail; b=s+ToAs+LejXt4WxWPly/FnZ1iZdp5OUiGSMS62syNvYNUPaS3TIC6GXAzACbbtiQY3jBl1iLR8WKqaa5+v/1cAg2FkFCaMXyI7kRvd49oZ7k9ifyFwEaAAOzyCzqigQzET+DamYI/CPxqmhn6lI/Fmh7ycuBXE4UU7SeikuULWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749880745; c=relaxed/simple;
	bh=5AmyAzeDaaGezUqoqlG22rfjbjae5XUQRaJ2JaosPBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Quy8Y8sle1HWAQR+b31y3Qskp/A1yPByHXh1GaXNnhtnTSW41jvOAzzqSSBcnQuLt2B6wV+KUQZiajxSyX+kM+YkYsqX4w0EKtPZscZMUaVCCDCOGHNyQ5nBycxubIZjr/pHkyzeSLb0i9mkiOYwom/xbTJMHlA9ADB7esBbnyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pXupPLby; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RR9gh2IX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55E4nWRh001025;
	Sat, 14 Jun 2025 05:58:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4FyY4ahlnyy9kuvGN3
	6wfF8GCh8BHFXBs9jrwNDareQ=; b=pXupPLbyrOuKi5dGwsFLmlimC3/ho7YKEJ
	/HlG9NTzHLM1DAkjd8Eqb6yXnkp11y2uNcCOluZh6C/hnUE+SaP2TRCE/GNR7Krk
	wJJr+kbixO6K1uT6MI+HkTj+U2hO+bQF109+/wsj7MGDEMZY0MuxeGIr+Mkpj1c6
	STIRJjsNoVycQh7Bs5ubvUfokQl1s7I6bwueCQaB3g9XCy6rWmdF2YGCNO/CiB1G
	uSOphOXQjBQfrSyP9wQ54Lg2E1fold0Sf7gHIMt7wFwkrgOqJd60naHFEvcNP7ML
	PVOWzXNkoc/5AOLfgeN9LEChHt1Z7R3JvFzyzfQXbA5KaE/DL/HA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 478ygf03pu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Jun 2025 05:58:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55E1XxWq000884;
	Sat, 14 Jun 2025 05:58:41 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 478yh6baqs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Jun 2025 05:58:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wb9kMkCcyrSM6zAjG2lmZ/eiHqQF/gJaZngcNaALBpbIJ6mLFFgYqkrfTy7SUEycFvXjr4NHQ/cDjHS1HLmq3FTgMElRrobX5V+w39lkvhSsQHykFsEFOzaCGtrJbra4rhsR6/2zPBAINLMLJdmfeM8aQ/p7vRxgGR9v0XPYR79FooytUInvQfFsIp10XldXvSkT6NH1z8ydqnCsXbstGqst83YzM/BFhCyNDO6H7h3y1vEcyEzixnP2Osqe6bfFaRpigIhLWcQcR8fAZVmF7UgFzj7Hxv4KKxxLkiV8l178X5dD+jO0d9Kp+rbquJS198mGENcjfgG+JzYJUbr59Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FyY4ahlnyy9kuvGN36wfF8GCh8BHFXBs9jrwNDareQ=;
 b=Q8+up8Rp+B3HFUhdlMWuOwPSs/e6bnmADdwwn+qfDhIIPdCl8dPYc+qEHYQmE0YrQ8KL6CrM4Y7vcRHKF9vU+IwUhIoWTF0t9rHbh1JUyyfQaXTamM0vJ60BQOFcKdmaVrUX9hkv/AL8B2xfv77FWAcunHbdp04tttREnIkgcwKS4LPTXlxAx9dr6z6mZfkubBD6LzcIrGvtGfPiSYSFjd6hi1pYj6nVJ4pr1qZF8iUxJY5fDIZ0vzGYoBRGAEVg9fVQa7OqlCNb9O7WdadxBvLtAIdqK3n9cTFNAAkxinPLN28OCo+c9U/sumNTaMRwKz5YUO76soYf6XMDxu8ylw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FyY4ahlnyy9kuvGN36wfF8GCh8BHFXBs9jrwNDareQ=;
 b=RR9gh2IX9R7TjQMuHfvMtsxTqj8/FM1jEphTmLaO+Hz7bYu9hdOrFiqe/3U5804TpWza2L4UxuLVp3foK1qQIxtDOnSBl/w6ucYydDcREMvfqLiNanS71JMfMYVXdWLdCaGwY0uyaC3dvUTaIv/igSWGrSHcRFxpumgMP0HS0ws=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by CH3PR10MB6689.namprd10.prod.outlook.com (2603:10b6:610:153::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Sat, 14 Jun
 2025 05:58:37 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%4]) with mapi id 15.20.8835.018; Sat, 14 Jun 2025
 05:58:36 +0000
Date: Sat, 14 Jun 2025 06:58:21 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
        David Hildenbrand <david@redhat.com>, Nico Pache <npache@redhat.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/5] mm: Rename __thp_get_unmapped_area to
 mm_get_unmapped_area_aligned
Message-ID: <111e0572-86cb-4de3-9e8b-99e016d46117@lucifer.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-4-peterx@redhat.com>
 <08193194-3217-4c43-923e-c72cdbbd82e7@lucifer.local>
 <aExxy3WUp6gZx24f@x1.local>
 <9733d8cf-edab-4b2b-bf2e-11457ef63dc8@lucifer.local>
 <aEyLXXV_4OR5_ArX@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEyLXXV_4OR5_ArX@x1.local>
X-ClientProxiedBy: LO4P123CA0695.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|CH3PR10MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e58cdd0-26ea-4855-cbac-08ddab087b06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wW6Kd2KAXjZ2+fKbbbeaq3FwYZhGrYtj+8BWNbCc0h/KtLyWcm2vr0Hr3Cmn?=
 =?us-ascii?Q?mKkusn39SUFET0m41DAcHhaMBcjMZ1X9KqlEFncdAvHJmqhIWNwNZT9SAS6a?=
 =?us-ascii?Q?LkzzmSa2JW6zx2ZFs+0JJ5Vr06kKhqX5Mfw03TM0+nlZAeactWb1WVIJBXMZ?=
 =?us-ascii?Q?IVyO7KkCWoB5GJKX9Vuy3bzDra8TyouoCuoFxcliY1BOdB8d7pR+JH/0WqV4?=
 =?us-ascii?Q?+h6eF9VSmsS5GtvWqpMbwtqKDHok5Qn2iaAxSocKi68X6117TkxcsZSozU7c?=
 =?us-ascii?Q?iaE9hocsBEj3cXyRanCkTfoj+pTL+qbwlRiILv+ateLJffy4IBP0+4Mh8WpX?=
 =?us-ascii?Q?rflEy6aYHLjSRIkIL9iMBgWs31SZXiOapY4DK1TO/c0+jSoNHEl0WF3baWIA?=
 =?us-ascii?Q?7p+fri7J2uGWrDt//QJVoKMOy1dLKMHRMkAoMRo0vc9s6qMtbaD+kZSm56fv?=
 =?us-ascii?Q?xlwFPE4a5wDLGDPUCU+R0gajAmHR9HDOVHrD24nchl7pY3I1NfssMgc/Arml?=
 =?us-ascii?Q?NP2cMrzR0DssGkZSqtadXEJhymXd/ku+SjREKFEjiFxiL9kW2xVNM6rkYDGr?=
 =?us-ascii?Q?n14t39t/AWi6utVzEtsRXrwRUgVp7yrIkWoKQDimgDVlDtGtbhjqyH+2Vgqs?=
 =?us-ascii?Q?7Yuw2TsmEX28eg2ny/dXuMDN2Kpqdkp/E5EtpEo3No4SBgN5PwQ+ask6qbRq?=
 =?us-ascii?Q?yoN3R4uswLov7RKav5oes+AeOK5lp/ajovSUAPOKHSpo6QA590CuMpKI3ljB?=
 =?us-ascii?Q?9RuBfwu7oYMm7pEw3nj950tkv8lbxTNmAZ+SdXX91m2vzKd3tIXsLUADISyM?=
 =?us-ascii?Q?Omdxfq1jVVB68fgTlp3pA7dLAFIbWwZ9M2oT/SSA4eVn1X+bdry6K/342UqO?=
 =?us-ascii?Q?jJwenCH46Xi6dryuMx+6Ynj+S0G/WziWKFUMK3VZRNNGbmhveimtUrv12DBO?=
 =?us-ascii?Q?ItLEhjLQh1n5nmFMAyz7KZMLVLJCAz/c6a5XGjZ+6fROndqW+wa9O3y1mENS?=
 =?us-ascii?Q?5arXspg04K+czjW/lULXRRnVhvA4Xx8w6i1djmzK4/AjImUYJq1i2FK2lGve?=
 =?us-ascii?Q?MPU+YnBdBVLDj26Ou3hZCSQ0w9W2t7epEXhmIrnyoXkGZNF5s4Qq/C2hHigR?=
 =?us-ascii?Q?CpyeBpvrchhmlx1jWzQplvx6mZveqN7nTvNvP5ZgSux1dyOZbKahjUw5FfUU?=
 =?us-ascii?Q?cQCvBgqWtAFmocbfGbqLXpsPXmZKHR3y4chd5octNpzeYiehdv8Gmil6o7Hw?=
 =?us-ascii?Q?sY1JEHCV/jwrRwYtQb9Ds2+0ajoFnk2F9/gul6rd1r1V0I5EAkKMPd0Mkbcb?=
 =?us-ascii?Q?0Ozmj2Rb7DLUvbgTs14Z0Pjy/K9eXviG7oct6MqmNqhpvyt8DOACYgTqBCGF?=
 =?us-ascii?Q?lzvZxHFWuivrLWPugsvKmxMC9dz1X+oVjr+6WI4Kt+MJ2dPA/wLRwp6PIkqH?=
 =?us-ascii?Q?jYE0MmAd8GE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3vvfnJe1FYdK1y/8hrewG3m+3sRNVusM0NJeC5c/To9E0kvp4PQLwDuo9H4V?=
 =?us-ascii?Q?/MVWMqBtf8fvMtQWoyLAACoEGWiYLrhpGBlw1AAbg87574T6FfmHbsm+mnxk?=
 =?us-ascii?Q?sqfkApUGRcY7qSMsoTdbuvFZd9aT/sOY2EINcE4qhq1fcgBZIu3WXZ5Wuy0b?=
 =?us-ascii?Q?c9wUX+tk25gLgZT6QLPdd5G59isgZy1Mqu6xZWBcC+BVp5D1bT0qUSPc4BqA?=
 =?us-ascii?Q?rk7iTTu/L0av2W+eMbrshdogZl3LbDH0Z7DYN3FOAXaZirb096EM+CCMpBma?=
 =?us-ascii?Q?WRehTsyv1c+3btqGDEbRE/729G2GkwBNDCFRSFN0mYjRwZRScUBGrn7LqJBz?=
 =?us-ascii?Q?YKhb4goldp7mcRYEgjErCJV2+tBe0uHDBmGzxm4dRDGcPI3wO2A/BLnoVe2x?=
 =?us-ascii?Q?uMCHwD2ez71m21wy0DWbDzsmb1BhJAwigK6tOGWY0H+rDiL664j+T46UBVwv?=
 =?us-ascii?Q?NRawYs96fMzd3zam8jzDnXmFjr1GP0kr57qJsMorPv0gE7rexw3HOssk8guS?=
 =?us-ascii?Q?jrHai/NkNN5ES0TW3lmgZPiiM4G+bXGJAqCrURPTal6oH93IPMBV/e989Gs7?=
 =?us-ascii?Q?mYA2v7zYwk2ICaHlNc0xB5In4AW/RPc6imd+59iYiP53b6lOCa7j4GiIeTrK?=
 =?us-ascii?Q?AFQYaYOIisnGSJWHvz/eFotq3sgnk2YbnfYg29Rg+Uso/qv9Vnm4B9UWw2Nj?=
 =?us-ascii?Q?3g7hzRxjHMDEgij8ItuLMHakhF+DBit2ul4LfrvokOj2Q99p8khTlp2rNSnW?=
 =?us-ascii?Q?ykQUvpyXhsGUGS3SnFezbzcWRT+ChGQDEkO0uYjcXiRUcxVYmfU4yvzVUHlM?=
 =?us-ascii?Q?6SlbAGe46cgmszJRDgx33B3r7PqJGUA0o/0GsyBC8QjfxMEwR671kzTsAGrj?=
 =?us-ascii?Q?VqKJ/tRhH2453xwiSvTZqE+VSzPKpN6iMnQJB/T7NJxzqGT21BvLKpK3wL5K?=
 =?us-ascii?Q?U9TzYCSNJZ8BVCE8eKfX5aKo/6/XQcH+aEmG8jE2P2ORqdHteehcfpnEyngm?=
 =?us-ascii?Q?iOWmk+I9620yX/MbPes7w4Wi00WHNBXmO1n6QIWnG61YVEGLUri8QUuRhAAv?=
 =?us-ascii?Q?WvfHGN5CEyjloosbC8lj0GXBcXgrQp/e4EQGnKxhMG+j/2hsVD+vDORtqd4M?=
 =?us-ascii?Q?rjxvTvau4rh0MyFJ6mJx4AO4e4tuY3CF6rjpt6lkFKO3mqjgvq7A32++AQro?=
 =?us-ascii?Q?mObHmUTTCQFmYXDgUC85F+EOoPpWa8HbfsNvGImFmU1YYsUJjKCB4ddtKoa3?=
 =?us-ascii?Q?urMz26bPZc4QRBkpcFF8P8/ITQaygs+IBPjuPmV5c2WaTTFZBcr7Te0SsJXD?=
 =?us-ascii?Q?oXKr9oMIBOexzyYHrVJi4QU7/+mQs58FcfcFTw/egj+h59T2YRt0XozEduQw?=
 =?us-ascii?Q?C68eEwwZ9ThhqmtPoiWHjqZCcCoID87U/gdwFix8Ed58maL3FCcXl6s6VsaJ?=
 =?us-ascii?Q?Prp0gxJB0fxqLdCYzOSvFs3JrswwPmJquhyVeDPLd66HaxQA8eFh243CNg8L?=
 =?us-ascii?Q?S1L5Fjq/ZQnXQwYXiIyh4U88ySyqNaHhpdS2KepZYFztWG8fyqLkb0/FfF3c?=
 =?us-ascii?Q?w9skwuz0jivcAPDN7HLQ4rUkohASpwyzcLk0kXlfVIPbLkiU2j3YkkeJG5ox?=
 =?us-ascii?Q?hQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qNiPgZbUr+4rihg3/wPvsKnFc9aUAOrucp11GjQin5scsb7CoNOYdw8EHQqRyYwTnxy0JhS8ZyxMblfbgaUB9IGF06kwdcDa5oyEC/ZH38mjqJluPuUkAzlbhuxCnFLVwWtrR7T/lki+EbLaETwpNbtTtvfN4HhdcZE+9qotWq/5n98LgiYu5jZKBRwcyyTyPxdPUdv1j6XgK0tSjKDoPvQsgcGkmfb68tf62cX8XlatUQXCIh63COq4/UYVjhFj2Zs6LsTFiUOyG+oAjVL/hDWMrFQPlc0aP8s+LtEs5uEO6on/4DhpyBFNTKhnW3i22TCuI+HaCYdUONHrmRi1SVvRJQv4Nz7BAx0p5U/P1WQLcDTpkHIoqjzM2E2X4wddHJt4056SXOPbbNgD5S0iebiRiO+9LGFnitJMMKSCiFFn5i9TdSZzC1L3x7irOppXu+k/oVN6zFaCykIuRDfV4rtTnVGgxI0vLxMbYRRjhUuYfxqvh5jZVJvq/n1YbL3zxaDGI2/EuawQ+czz25q7AAwWNr1HrMObn151t2pFixNvZpfuf8n4y7h+8Crg7MWgo6CTeTiMgyiwAgDzNSnu519yJB5lAhkx12bL7JwvT6I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e58cdd0-26ea-4855-cbac-08ddab087b06
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 05:58:36.8888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NLx0eb4tT2NA8GHd1nobYjnZEsw0ABj3sarjZQKuhogpyhGzyce/zv9Iwe53r0Lyrdlxi1Ftq1Qk3UWA0iRXMYZiUzK57iOkRZsXT8TnERs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6689
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-14_02,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506140048
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE0MDA0OCBTYWx0ZWRfX+4yZ8w/F0SMg XqTKVX/kigVB2jIMttpJVU60Zc4eb+YJdVFPJVgVtNcssvxO/GKgOazGxJegma8TfDPqPAFSSCD SvA4s5c1xTvWMBC12cVKG+f5odJNqFbCwJy5eg7eb1uW/jrop9qYDZpB5OYH+v9Hs2NhkiFpncz
 fmdeSRj6ea1UMq65P66z6QOHGOJ4KrQnSM7u0D1Kz3nKEkdmU/bodHocWMkYGAqR9Zx3QCKmHui LqlqEyuJpnhs1TjgbS5Um9m1KcHwHZmqwEGtdq/2A+8FcmL6lhOB3+tl8g2p+HA6AUy2chfA8pK MbA1T/N9Jy7Yx2vCAGQuDXi07pAIpCs9bYdtK/Xq78ZdUztxE0hPTmw6IVX2Qc+L5TZAfYNpC0J
 H4k3/G2sdpdtqVXRt2qi3t2XclN5aV3BvwBv49fp3D2ARaCJhW20SIF8L1afVZzTH9HbvucA
X-Authority-Analysis: v=2.4 cv=Hox2G1TS c=1 sm=1 tr=0 ts=684d0f91 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=Ikd4Dj_1AAAA:8 a=SRrdq9N9AAAA:8 a=yPCof4ZbAAAA:8 a=7CQSdrXTAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=c8bvGiebDpJy-NImeQoA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:13206
X-Proofpoint-ORIG-GUID: o8zD4SJbHedAoQgIeJMoXjm43ixBkxvU
X-Proofpoint-GUID: o8zD4SJbHedAoQgIeJMoXjm43ixBkxvU

Peter - I think the problem we're having here is that you're making this a
_general_ and _exported_ function that must live up to the standards of such a
function.

But at the same time, for convenience, want it to happen to do what's convenient
for VFIO and THP.

To stop us going around in circles -

I won't accept this patch if it:

a. Returns 0 on errors,
b. Does stuff that is specific to THP, etc.
c. Is located in mm/huge_memory.c when you're saying it's general.

This isn't a case of nits to be sorted out later, these are fundamental issues
that prevent your series from being mergeable.

On Fri, Jun 13, 2025 at 04:34:37PM -0400, Peter Xu wrote:
> On Fri, Jun 13, 2025 at 08:18:42PM +0100, Lorenzo Stoakes wrote:
> > On Fri, Jun 13, 2025 at 02:45:31PM -0400, Peter Xu wrote:
> > > On Fri, Jun 13, 2025 at 04:36:57PM +0100, Lorenzo Stoakes wrote:
> > > > On Fri, Jun 13, 2025 at 09:41:09AM -0400, Peter Xu wrote:
> > > > > This function is pretty handy for any type of VMA to provide a size-aligned
> > > > > VMA address when mmap().  Rename the function and export it.
> > > >
> > > > This isn't a great commit message, 'to provide a size-aligned VMA address when
> > > > mmap()' is super unclear - do you mean 'to provide an unmapped address that is
> > > > also aligned to the specified size'?
> > >
> > > I sincerely don't know the difference, not a native speaker here..
> > > Suggestions welcomed, I can update to whatever both of us agree on.
> >
> > Sure, sorry I don't mean to be pedantic I just think it would be clearer to
> > sort of expand upon this, as the commit message is rather short.
> >
> > I think saying something like this function allows you to locate an
> > unmapped region which is aligned to the specified size should suffice.
>
> I changed the commit message to this:
>
>     This function is pretty handy to locate an unmapped region which is aligned
>     to the specified alignment, meanwhile taking pgoff into considerations.
>
>     Rename the function and export it.  VFIO will be the first candidate to
>     reuse this function in follow up patches to calculate mmap() virtual
>     addresses for MMIO mappings.

This is better but doesn't describe what this function does as you're doing
unusual things.

>
> >
> > >
> > > >
> > > > I think you should also specify your motive, renaming and exporting something
> > > > because it seems handy isn't sufficient justifiation.
> > > >
> > > > Also why would we need to export this? What modules might want to use this? I'm
> > > > generally not a huge fan of exporting things unless we strictly have to.
> > >
> > > It's one of the major reasons why I sent this together with the VFIO
> > > patches.  It'll be used in VFIO patches that is in the same series.  I will
> > > mention it in the commit message when repost.
> >
> > OK cool, I've not dug through those as not my area, really it's about
> > having the appropriate justification.
> >
> > I'm always inclined to not want us to export things by default, based on
> > experience of finding 'unusual' uses of various mm interfaces in drivers in
> > the past which have caused problems :)
> >
> > But of course there are situations that warrant it, they just need to be
> > spelled out.
> >
> > >
> > > >
> > > > >
> > > > > About the rename:
> > > > >
> > > > >   - Dropping "THP" because it doesn't really have much to do with THP
> > > > >     internally.
> > > >
> > > > Well the function seems specifically tailored to the THP use. I think you'll
> > > > need to further adjust this.
> > >
> > > Actually.. it is almost exactly what I need so far.  I can justify it below.
> >
> > Yeah, but it's not a general function that gives you an unmapped area that
> > is aligned.
> >
> > It's a 'function that gets you an aligned unmapped area but only for 64-bit
> > kernels and when you are not invoking it from a compat syscall and returns
> > 0 instead of errors'.
> >
> > This doesn't sound general to me?
>
> I still think it's general.  I think it's a general request for any huge
> mappings.  For example, I do not want to enable aggressive VA allocations
> on 32 bits systems because I know it's easier to get overloaded VA address
> space with 32 bits.  It should also apply to all potential users whoever
> wants to use this function by default.

This is a stretch, you're now assuming alignment must be large enough to be a
problem on 32-bit systems, and you've not mentioned compat syscalls _at all_
here.

Commit 4ef9ad19e176 ("mm: huge_memory: don't force huge page alignment on 32
bit") is what introduced this. It literally references issued encountered in
THP.

>
> I don't think it always needs to do so, if there's an user that, for
> example, want to keep the calculation but still work on 32 bits, we can
> provide yet another helper.  But it's not the case as of now, and I can't
> think of such user.  In this case, I think it's OK we keep this in the
> helper for all existing users, including VFIO.

It's not OK, sorry.

>
> >
> > >
> > > >
> > > > >
> > > > >   - The suffix "_aligned" imply it is a helper to generate aligned virtual
> > > > >     address based on what is specified (which can be not PMD_SIZE).
> > > >
> > > > Ack this is sensible!
> > > >
> > > > >
> > > > > Cc: Zi Yan <ziy@nvidia.com>
> > > > > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > > > > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > > > > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > > > > Cc: Dev Jain <dev.jain@arm.com>
> > > > > Cc: Barry Song <baohua@kernel.org>
> > > > > Signed-off-by: Peter Xu <peterx@redhat.com>
> > > > > ---
> > > > >  include/linux/huge_mm.h | 14 +++++++++++++-
> > > > >  mm/huge_memory.c        |  6 ++++--
> > > > >  2 files changed, 17 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > > > > index 2f190c90192d..706488d92bb6 100644
> > > > > --- a/include/linux/huge_mm.h
> > > > > +++ b/include/linux/huge_mm.h
> > > >
> > > > Why are we keeping everything in huge_mm.h, huge_memory.c if this is being made
> > > > generic?
> > > >
> > > > Surely this should be moved out into mm/mmap.c no?
> > >
> > > No objections, but I suggest a separate discussion and patch submission
> > > when the original function resides in huge_memory.c.  Hope it's ok for you.
> >
> > I like to be as flexible as I can be in review, but I'm afraid I'm going to
> > have to be annoying about this one :)
> >
> > It simply makes no sense to have non-THP stuff in 'the THP file'. Also this
> > makes this a general memory mapping function that should live with the
> > other related code.
> >
> > I don't really think much discussion is required here? You could do this as
> > 2 separate commits if that'd make life easier?
> >
> > Sorry to be a pain here, but I'm really allergic to our having random
> > unrelated things in the wrong files, it's something mm has done rather too
> > much...
>
> I don't understand why the helper is non-THP.  The alignment so far is
> really about huge mappings.  Core mm's HUGE_PFNMAP config option also
> depends on THP at least as of now.
>
> # TODO: Allow to be enabled without THP
> config ARCH_SUPPORTS_HUGE_PFNMAP
> 	def_bool n
> 	depends on TRANSPARENT_HUGEPAGE

I really don't understand what your point is? You're naming this
mm_get_unmapped_area_aligned()? No reference to THP or VFIO?

>
> >
> > >
> > > >
> > > > > @@ -339,7 +339,10 @@ unsigned long thp_get_unmapped_area(struct file *filp, unsigned long addr,
> > > > >  unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> > > > >  		unsigned long len, unsigned long pgoff, unsigned long flags,
> > > > >  		vm_flags_t vm_flags);
> > > > > -
> > > > > +unsigned long mm_get_unmapped_area_aligned(struct file *filp,
> > > > > +		unsigned long addr, unsigned long len,
> > > > > +		loff_t off, unsigned long flags, unsigned long size,
> > > > > +		vm_flags_t vm_flags);
> > > >
> > > > I echo Jason's comments about a kdoc and explanation of what this function does.
> > > >
> > > > >  bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
> > > > >  int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
> > > > >  		unsigned int new_order);
> > > > > @@ -543,6 +546,15 @@ thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> > > > >  	return 0;
> > > > >  }
> > > > >
> > > > > +static inline unsigned long
> > > > > +mm_get_unmapped_area_aligned(struct file *filp,
> > > > > +			     unsigned long addr, unsigned long len,
> > > > > +			     loff_t off, unsigned long flags, unsigned long size,
> > > > > +			     vm_flags_t vm_flags)
> > > > > +{
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > >  static inline bool
> > > > >  can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
> > > > >  {
> > > > > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > > > > index 4734de1dc0ae..52f13a70562f 100644
> > > > > --- a/mm/huge_memory.c
> > > > > +++ b/mm/huge_memory.c
> > > > > @@ -1088,7 +1088,7 @@ static inline bool is_transparent_hugepage(const struct folio *folio)
> > > > >  		folio_test_large_rmappable(folio);
> > > > >  }
> > > > >
> > > > > -static unsigned long __thp_get_unmapped_area(struct file *filp,
> > > > > +unsigned long mm_get_unmapped_area_aligned(struct file *filp,
> > > > >  		unsigned long addr, unsigned long len,
> > > > >  		loff_t off, unsigned long flags, unsigned long size,
> > > > >  		vm_flags_t vm_flags)
> > > > > @@ -1132,6 +1132,7 @@ static unsigned long __thp_get_unmapped_area(struct file *filp,
> > > > >  	ret += off_sub;
> > > > >  	return ret;
> > > > >  }
> > > > > +EXPORT_SYMBOL_GPL(mm_get_unmapped_area_aligned);
> > > >
> > > > I'm not convinced about exporting this... shouldn't be export only if we
> > > > explicitly have a user?
> > > >
> > > > I'd rather we didn't unless we needed to.
> > > >
> > > > >
> > > > >  unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> > > > >  		unsigned long len, unsigned long pgoff, unsigned long flags,
> > > > > @@ -1140,7 +1141,8 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
> > > > >  	unsigned long ret;
> > > > >  	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
> > > > >
> > > > > -	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
> > > > > +	ret = mm_get_unmapped_area_aligned(filp, addr, len, off, flags,
> > > > > +					   PMD_SIZE, vm_flags);
> > > > >  	if (ret)
> > > > >  		return ret;
> > > > >
> > > > > --
> > > > > 2.49.0
> > > > >
> > > >
> > > > So, you don't touch the original function but there's stuff there I think we
> > > > need to think about if this is generalised.
> > > >
> > > > E.g.:
> > > >
> > > > 	if (!IS_ENABLED(CONFIG_64BIT) || in_compat_syscall())
> > > > 		return 0;
> > > >
> > > > This still valid?
> > >
> > > Yes.  I want this feature (for VFIO) to not be enabled on 32bits, and not
> > > enabled with compat syscals.
> >
> > OK, but then is this a 'general' function any more?
> >
> > These checks were introduced by commit 4ef9ad19e176 ("mm: huge_memory:
> > don't force huge page alignment on 32 bit") and so are _absolutely
> > specifically_ intended for a THP use-case.
> >
> > And now they _just happen_ to be useful to you but nothing about the
> > function name suggests that this is the case?
> >
> > I mean it seems like you should be doing this check separately in both VFIO
> > and THP code and having the 'general 'function not do this no?
>
> I don't understand, sorry.
>
> If this helper only has two users, the two users want the same check,
> shouldn't we keep the check in the helper, rather than duplicating in the
> two callers?

Because you're making this an exported 'general' function with '_aligned' in the
suffix and your whole patch is about how it's general.

The problem is somebody will use this function thinking it is general, then find
out it's not general it's a 'de-duplicate VFIO and THP' function.

>
> >
> > >
> > > >
> > > > 	/*
> > > > 	 * The failure might be due to length padding. The caller will retry
> > > > 	 * without the padding.
> > > > 	 */
> > > > 	if (IS_ERR_VALUE(ret))
> > > > 		return 0;
> > > >
> > > > This is assuming things the (currently single) caller will do, that is no longer
> > > > an assumption you can make, especially if exported.
> > >
> > > It's part of core function we want from a generic helper.  We want to know
> > > when the va allocation, after padded, would fail due to the padding. Then
> > > the caller can decide what to do next.  It needs to fail here properly.
> >
> > I'm no sure I understand what you mean?
> >
> > It's not just this case, it's basically any error condition results in 0.
> >
> > It's actually quite dangerous, as the get_unmapped_area() functions are
> > meant to return either an error value or the located address _and zero is a
> > valid response_.
>
> Not by default, when you didn't change vm.mmap_min_addr. I don't think it's
> a good idea to be able to return NULL as a virtual address, unless
> extremely necessary.  I don't even know whether Linux can do that now.

It can afaik.

>
> OTOH, it's common too so far to use this retval in get_unmapped_area().
>
> Currently, the mm API is defined as:
>
> 	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
>
> Its retval is unsigned long, and its error is returned by IS_ERR_VALUE().
> That's the current API across the whole mm, and that's why this function
> does it because when used in THP it's easier for retval processing.  Same
> to VFIO, as long as the API didn't change.

This sounds like you agree with me that you're fundamentally breaking this
contract for convenience?

This isn't acceptable for a general function.

>
> I'm OK if any of us wants to refactor this as a whole, but it'll be great
> if you could agree we can do it separately, and also discussed separately.

Sorry these are _fundamental_ issues, not nits or niceties that can be followed
up on.

>
> >
> > So if somebody used this function naively, they'd potentially have a very
> > nasty bug occur when an error arose.
> >
> > If you want to export this, I just don't think we can have this be a thing
> > here.
> >
> > >
> > > >
> > > > Actually you maybe want to abstract the whole of thp_get_unmapped_area_vmflags()
> > > > no? As this has a fallback mode?
> > > >
> > > > 	/*
> > > > 	 * Do not try to align to THP boundary if allocation at the address
> > > > 	 * hint succeeds.
> > > > 	 */
> > > > 	if (ret == addr)
> > > > 		return addr;
> > >
> > > This is not a fallback. This is when user specified a hint address (no
> > > matter with / without MAP_FIXED), if that address works then we should
> > > reuse that address, ignoring the alignment requirement from the driver.
> > > This is exactly the behavior VFIO needs, and this should also be the
> > > suggested behavior for whatever new drivers that would like to start using
> > > this generic helper.
> >
> > I didn't say this was the fallback :) this just happened to be the code
> > underneath my comment. Sorry if that wasn't clear.
> >
> > This is another kinda non-general thing but one that makes more sense. This
> > comment needs updating, however, obviously. You could just delete 'THP' in
> > the comment that'd probalby do it.
>
> Yes, the THP word does not apply anymore.   I'll change it, thanks for
> pointing this out.

Thanks.

>
> >
> > The fallback is in:
> >
> > unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long addr,
> > 		unsigned long len, unsigned long pgoff, unsigned long flags,
> > 		vm_flags_t vm_flags)
> > {
> > 	unsigned long ret;
> > 	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
> >
> > 	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
> > 	if (ret)
> > 		return ret;
> >
> > So here, if ret returns an address, then it's fine we return that.
> >
> > Otherwise, we invoke the below (the fallback):
> >
> > 	return mm_get_unmapped_area_vmflags(current->mm, filp, addr, len, pgoff, flags,
> > 					    vm_flags);
> > }
> >
> > >
> > > >
> > > > What was that about this no longer being relevant to THP? :>)
> > > >
> > > > Are all of these 'return 0' cases expected by any sensible caller? It seems like
> > > > it's a way for thp_get_unmapped_area_vmflags() to recognise when to fall back to
> > > > non-aligned?
> > >
> > > Hope above justfies everything.  It's my intention to reuse everything
> > > here.  If you have any concern on any of the "return 0" cases in the
> > > function being exported, please shoot, we can discuss.
> >
> > Of course, I have some doubts here :)
> >
> > >
> > > Thanks,
> > >
> > > --
> > > Peter Xu
> > >
> >
> > To be clearer perhaps, what I think would work here is:
> >
> > 1. Remove the CONFIG_64BIT, in_compat_syscall() check and place it in THP
> >    and VFIO code separately, as this isn't a general thing.
>
> Commented above.  I still think it should be kept until we have a valid use
> case to not enable it.

No, this isn't acceptable sorry. I won't accept the patch as-is with this in
place.

>
> >
> > 2. Rather than return 0 in this function, return error codes so it matches
> >    the other mm_get_unmapped_area_*() functions.
>
> Commented above.

No, this isn't acceptable sorry. I won't accept the patch as-is with this in
place.

>
> >
> > 3. Adjust thp_get_unmapped_area_vmflags() to detect the error value from
> >    this function and do the fallback logic in this case. There's no need
> >    for this 0 stuff (and it's possibly broken actually, since _in theory_
> >    you can get unmapped zero).
>
> Please see the discussion in the other thread, where I replied to Jason to
> explain why the fallback might not be what the user always want.
>
> For example, the last patch does try 1G first and if it fails somehow it'll
> try 2M.  It doesn't want to fallback to 4K when 1G alloc fails.

You're misunderstanding me.

I said adjust the THP code to do the fallback. To be super clear I meant:

Change:

 	ret = __thp_get_unmapped_area(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
 	if (ret)
 		return ret;

 	return mm_get_unmapped_area_vmflags(current->mm, filp, addr, len, pgoff, flags,
 					    vm_flags);

To:

	ret = mm_get_unmapped_area_align(filp, addr, len, off, flags, PMD_SIZE, vm_flags);
	if (!IS_ERR_VAL(ret))
		return ret;

 	return mm_get_unmapped_area_vmflags(current->mm, filp, addr, len, pgoff, flags,
 					    vm_flags);

In thp_get_unmapped_area_vmflags().

>
> >
> > 4. (sorry :) move the code to mm/mmap.c
>
> Commented above.  Note: I'm not saying it _can't_ be moved out, but it
> still makes sense to me to be in huge_memory.c.

No, this isn't acceptable sorry. I won't accept the patch as-is with this in
place.

>
> >
> > 5. Obviously address comments from others, most importantly (in my view)
> >    ensuring that there is a good kernel doc comment around the function.
> >
> > 6. Put the justifiation for exporting the function + stuff about VFIO in
> >    the commit message + expand it a little bit as discussed.
>
> Please check if above version works for you.

It's not, you're not explaining at all what this function does. But even if you
did, the function is doing something that isn't at all general.

>
> >
> > 7. Other small stuff raised above (e.g. remove 'THP' comment etc.)
>
> I'll do this.

Well there's this at least :)

>
> >
> > Again, sorry to be a pain, but I think we need to be careful to get this
> > right so we don't leave any footguns for ourselves in the future with
> > 'implicit' stuff.
> >
> > Thanks!
> >
>
> Thanks,
>
> --
> Peter Xu
>

Yeah sorry but you really need to rethink this.

I appreciate you trying to de-duplicate here, but again we truly must have a
high bar for this kind of generalised function, because it's absolutely the kind
of foot-gun that'll come back to bite when somebody sees
mm_get_unmapped_area_aligned() and doesn't realise it's not in any way generic.

And any patch that does that will not show any reference to the zero returns,
etc., it'll not cc any of us, and people will just quietly break their code in
subtle ways.

Thanks!

