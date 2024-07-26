Return-Path: <kvm+bounces-22353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D3FEA93D9A8
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 22:22:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 622F81F244DC
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F33C4148303;
	Fri, 26 Jul 2024 20:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R3jexl8I";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FFD8++XJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913361CD06;
	Fri, 26 Jul 2024 20:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722025344; cv=fail; b=FnUY9CzM6SjrZiflK1EOw6QyHdS/1IlgrNVcXqfsF46kY2CBvl7czfzy3twUg0leyO9tOubSV6BuoVlCOxKdx06bXLth0QwbyriNFRqyrqz6vIeXdpgSE6NksJprihyG1ldrki1+tLXpbUXUtgwl9e/bjfCjNwLgY/R+j8fu5tk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722025344; c=relaxed/simple;
	bh=dtqWUhhQRnpdtvFhlQCKDOJAkt/QjiEVPXae+BIx068=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HSTWQU0BAsEEYkTs0dUgrcSs1x+p8tZRm2AFEHuw5aqpnCxMa4zUUnWMEUsCxHNflDMK/MNtqpUiZjVnpkIZSkqGAxIiaifzsreEnN9z8EhF76jxFweWeZmfEDRvRZL12F5OkSJ02+bfHIWaGS0XLJRdHFmpTOPgO/5+O2CYUig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R3jexl8I; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FFD8++XJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46QJjnmF018706;
	Fri, 26 Jul 2024 20:21:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=L/RLO7ggk8a9IEwP5MtfZ0+ERZpUQIcc0gGW55jQFC8=; b=
	R3jexl8IIbmE4ZxVOjHDmUL5458LGy8JuYLvuTtff9ZN53wm5FYvdZ/kYWYQsIyN
	Ty8klEIyTnqB65yQcDTP3q3xwe3J1tys6JXK4jCtfrIAmWwWLeEJGBUDvdBV1ei4
	KY2R3Y+x8wzm+ulqeNm6ZJU+hc9gtQZgzJQWFJiwK/mmvzE6imi290qPXdCcE/mo
	Pklhi1dV+aDAhZdKQeQ1BTpxXH5HHsODzOEWelYk3EkGhpo9qTLeZaGk0qwkP0ov
	YVRzZiPkwsWVMFwE7Ygu9gxQMKh7PATjY9rcflXjwDpgshBna63BNzaC0DJDMgjq
	SBgRUR1OI5f3z0ghtpzCVw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hfxppjg8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:21:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46QJAGHf010678;
	Fri, 26 Jul 2024 20:21:45 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40h2848f2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:21:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gw1N8rYb68dU/mSPUKXj3BnzKtt3tQnN6tRjy7QR0HD3vynWgLQ+JSN7K47TSC2bnBwuwTMa/Uj58HLFLPgUl6dS5AS9xtRlEP5WVIW0fZsEc5F+QWKm5zfEYHP5RVdHLxBwfF//y2wRZhMq8c56cHxlsKNpdc2D+YUgNbTnCrHrb65m7gyYfV7L/cLZj3J5YW7oBJ0CeKNM/NqjEVopWM1OBQQKeWi5jdV+wfrr7RdhU3jgwPE0z/bCYeH5gdyhFYvE9nt6S2oXuUGQGvMBda4jEiv6BYu0e/kzQ+wL+sVtdmqpkUTYADvn0LoVaVMWSCbVG5/dJdrSqhlcRT2xbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/RLO7ggk8a9IEwP5MtfZ0+ERZpUQIcc0gGW55jQFC8=;
 b=Gv7dAt0B9D+7kD5DRqIxWWA9Rrczt9ajMNiJcX40lCZN4zdUhjoMFdxsoQm+RIYszDeqDNVaGlGI5jTknWgQkwXFnu1tfHlxOII314q+Tyk5a5hr14nlcbO/3fC/k0LA+k5/ox9Sx4RrO3YDXTtLtmLqfjxnp5A9H+Oa9Vlvt9O4McmIhQivKnWs505ZgDZaAoar4ij7wLkTeS2wGK4EfUx/bopp8c3vy5sL8QPrBGvtECTzouY/LOsKAWRH2xY8vHqycJfHfXprXcoFPw4Pyd/MP/lbxszTjBTn4QqO2ZC71qOO3arbMHzf8SP3Eqe5QNzfB6XKmIMX2O5YE2F/oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/RLO7ggk8a9IEwP5MtfZ0+ERZpUQIcc0gGW55jQFC8=;
 b=FFD8++XJJprwVBacej5vJSZN/4UHllrQX+GkspHHHukScyGrj2gksh2fJUSMQANsJK0P4+yBs1hi0d1KjTO+YyYhtG65BeAq3vEDkvh+w1Mc0lEQI6N1wqS0R5wdtKXxWNiwcLhsUuihYxV8ywVBQ/BCbFpr7/4nGUOmauad/uY=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH0PR10MB5178.namprd10.prod.outlook.com (2603:10b6:610:dd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Fri, 26 Jul
 2024 20:21:41 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 20:21:41 +0000
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
        misono.tomohiro@fujitsu.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 05/10] governors/haltpoll: drop kvm_para_available() check
Date: Fri, 26 Jul 2024 13:21:29 -0700
Message-Id: <20240726202134.627514-3-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240726202134.627514-1-ankur.a.arora@oracle.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0278.namprd04.prod.outlook.com
 (2603:10b6:303:89::13) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH0PR10MB5178:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e08d501-3332-446f-ccc2-08dcadb08f81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Gs78HvmU6eBSPDAPquMitnJUzMy9S8avDJoDGBGVS3ACDaog0wzYi7C02ou/?=
 =?us-ascii?Q?IhUosChwdJJcCcUnvIDzG2vqvzqE8+reJZfsApgo5IrEtryawOZYgQ2kB0b3?=
 =?us-ascii?Q?bUjJ0xMDz/SmdfkVBHlLDWcT44rf8ykJ8f91uBOmAjSiRjL0JjjNOmZYKZVq?=
 =?us-ascii?Q?Y3xnVHt4RWXl1ns2MeL9iJ9bhjyaJYqdXzLT1tZW7WdfIsHv0czs40ylbsqh?=
 =?us-ascii?Q?Ny5qMTeyWLU6Fr3Vb9i1dQO+SY7RpcIRfZB/X0RhfHIpKXZ/lHEKKrQnoDlb?=
 =?us-ascii?Q?p06GIvu4ntgqm6KxBwBtQQUUpJEOFvnOEUQHHyZzildsl9y30SAzfDRLypP8?=
 =?us-ascii?Q?fPHBY1YZqFMnGLu3gVXU0W8CCc7qeo3cAquoaUVRma7O0vVLETUUIkJHJkcy?=
 =?us-ascii?Q?R1EAeF+B2oUyDcswVA/nvvddWKy32zHQWUHBLBiMu6+A1yhR+GCCxlHnKQtI?=
 =?us-ascii?Q?Uo8ysFkTpYDUnyDdTOqqXgifkBEDFNv8ZHZmXO+z8ikBI0UAH1a0VRQlCKiq?=
 =?us-ascii?Q?qpDynMDhgM2Kw7WTBXe3sovFoqCnr6GBvfQ8+D5Q7BmOEjBoUItg+5ctpw8j?=
 =?us-ascii?Q?bR5Ztm7V6fmH8VNHmyVpnCHY3TCakYxG7uk0yjFFqHbtTWwvcpKLdlCweU07?=
 =?us-ascii?Q?n04xmihIcyYA9qsvLk8IonXmiA7cs/Z3/moL1jIMFiis1DqDOEWylzYzh5Ow?=
 =?us-ascii?Q?yWk8txRJ19Tp1U6ilblYDU962YpdTxYr9z8b4kBSEXYf1vyJ73mY0TFGJDaa?=
 =?us-ascii?Q?1dzh+dqxpWeV5RpemIojAZuDbzCI/Tpi3VF+TB3oLclBNd3Xf3Fb/MVhczjA?=
 =?us-ascii?Q?quwK8FtOchaI82AVDaDpZOq0H0gZlwRA11zQwMRgiVXoHYhSUaSlmLr9+VVA?=
 =?us-ascii?Q?FwP7GVDa39gsYWHcMDPtDhTipisybHxVpOeu9s0xcQCTpZd1myalJWUXiJCq?=
 =?us-ascii?Q?GHTqjtYXatjbCTPfpNOVC2X3ccpJgMVr2uoin6wNB1FRoeoUNvyvGLtHo4J3?=
 =?us-ascii?Q?NToGkonw0/83yjxv3Br9+fc1qsqopbRvUaZRxvu0wi/JpOvYfyVd9l9U9f98?=
 =?us-ascii?Q?rlFm5jDPBPx8atEgsgcsbwVDv9UI4dGsL+WyThejMCCEEJurimJZp3Qq/f6j?=
 =?us-ascii?Q?SkskNHOtVO1UsUtk82s5c7ho0joLa2bo/j0o60G4DhSTEpuG9gYPqeOAh4Lk?=
 =?us-ascii?Q?n+2d7vjLk4s1bqr+SC1hw7LL28yixIVfXzpP1FtYNG/FCvrWr3Zmy9R2X+Po?=
 =?us-ascii?Q?leHOfzgadCDrYdiG0thMzDypri/NOpXCgVtc72h+OGk5nvAbTHhG2fRn1fsi?=
 =?us-ascii?Q?mOJ6Pl3SVQemnYXS/wW5YsJ4fLb4tiXNX9Sb0ewz7aCOTQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FlAPqpTsEDn/93qYgpa5+t0Y2rsJcgrVxTybY1di+ALLzI6HA31vn2arbFmm?=
 =?us-ascii?Q?FyYbqVQFv4ijSriglxKiNK+X6XKZ6jeUypH1yvjCnEM+HfdL9tIPu1gI7x1v?=
 =?us-ascii?Q?BNx6ZCyAzUp6bdbSUjGw774xQVPAUobtT3R4fTyJmuKjUp8/Ucg83OuGGuZb?=
 =?us-ascii?Q?2PYACWTY4BDkOWvMCFvDGSZFUSyzPBcDSkyzPMc/yBLqvH4n4we7LOHgqDOX?=
 =?us-ascii?Q?Qrnn+OLqTeb6jL7AHj9ff92SaOZvcp5dEN1xLbwr5NCCXDKbnSl5h1S+LbQW?=
 =?us-ascii?Q?EExhZVrnjapk98J1qfhOZUkZv92J+9LBif59mufi5zsUjhfJCJuz7cLn3f90?=
 =?us-ascii?Q?puWxIdNwS7TB4IdKaW6GzZNi7swKx8LRHvwniadqBjtX1srZkCE5MXy+SiK2?=
 =?us-ascii?Q?B0aKJwSAjlDg1ZsuaaXHQ/lYmUlGRJBU+LlQBTZaAIWEXsEzNYKye0cKl0s7?=
 =?us-ascii?Q?0tjvg6XHdxexbmli8FDxtg7/St9reTVtB9tbpuzH15bsIg7f7XHpEPiJGX/A?=
 =?us-ascii?Q?EMiWlPMjYKlXs37pfyb8xGmgpL6pQCzo2bsgf2WbhEqQXdprgmxBUIUts2Wy?=
 =?us-ascii?Q?4kQOBhtR5igA0FnSWM8KAvrgGQXzk0s/lHwuCVapeelKMwt0fTbauG3ZvH3C?=
 =?us-ascii?Q?GpdXl6DP3Jj/X9x2fEJEDqrIdSWlxl9J2HZ4sbEnpa78p6Knc6ZF3iZuIVDK?=
 =?us-ascii?Q?OZry1nICRCBCM1RLbyu1lzKp1xyVLmgWKqJhdU5aYxc55UslUdC/6F5SQ1sh?=
 =?us-ascii?Q?IWdmAufEJc2KTeHcaUuetlSHF+iMmtRvGJt/GPWzEPF8uorbJVPdghgZ6Elr?=
 =?us-ascii?Q?7Lae1GnWIiPMOXJrDhNPUG6B56cM8a//O8ZL7LkNRSHTtgc/DrclvbCHhX5r?=
 =?us-ascii?Q?DTNr8qx56sOm9EnFksqbcKkkfyMUuOs7Vi4i2i7FgbnJ2ipl12sYawd5Ce8k?=
 =?us-ascii?Q?N2SowcEZAKyUY6eh2oB1OfF4J4XiY/a7yehLd6qCpcjETj02/Bsz1E9LQTO1?=
 =?us-ascii?Q?XmhTYU/KOnjCHGT2iZeF4Qd/scibdPQxfrZKhlloR4aPK3p4K3/VIgG+wLkx?=
 =?us-ascii?Q?cmubx44f3avAKrarEmz/Uiqj0MLP80AH7be+3/YAQPJwX2lOKDNFhohcgbSE?=
 =?us-ascii?Q?p20kKu41MAUtSEwFjQgF+G/FN2pfD8yJegxZH+FuKHSwjb7j85t2noIHRbyn?=
 =?us-ascii?Q?uVYZh/AtGhNvOY0yAMbHr2/UcoadeOJUFDCsTsBH4UtrtzGMLUFZCHvhVLbH?=
 =?us-ascii?Q?D9KIK6vAJGi54bpSwvnu4O8YaNia8/US1GWJO/Xr+BltAPnGNPKotX1wcyOG?=
 =?us-ascii?Q?GEBz9bfyNff92fwY/uxKYSq56XvWo5Y0Hct2qRh8O8d2LknciCJRhcfJYmhy?=
 =?us-ascii?Q?NpPvbSObziBASv4z7y5CfwM+/bLZaKNjuOGtmrqY4WK7pjKlODHVQF59f7Jf?=
 =?us-ascii?Q?O+FopvUof75ijOfixogQyQ1FjcncCCC9s3+NH9xTUDk+ApX+kUCSeGlJySKQ?=
 =?us-ascii?Q?ggwkGUe9gKhBJbaYNOkXYxDriYMIa8bZblH+4SQvqFA4QOSdvxdK7v7t6Pkz?=
 =?us-ascii?Q?DGHY//Y8VJIU1jYs+7xjBQBu6N+HjwlUry1MoM3WAa+O2ZbSjMXQZx5FCEGd?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Y1IfF5cJdg+EBEriNs23gBTSgd2QZrLOfapIBqE98IDEY1jSMfAsoGNORB4taAgPeopwTCps52Qneib0HdUquXrRDCfrfO8loyGF1sn5rvejqc6eZz2h/ycRoYa7MxhzuykZj+RGvkqHBwKoB+rfBTDlZFOzthC3ZQaBpCWUx3ssXzibrjYA2i3zId38JQwE0zTCOOOrfOlgTHPoR8eQP8FzmNCEjpYbSpsuWNLSBwD0CdvMwXK4bvcKxy3nsVK6ujoPxW/N9BmP1o+F4FnFab/IJFm8sQLiDdBcPk/v+uIzDLU7KpV1Z1gQl1QFxuIpOTHK5V8KBd+kdwlnZniLnwukM2McCoOirhnG41uXeQgsce6JkFTRP1eWRhxK2OUW1RSB/9Zyd+lgcEcAjpTlpyMZzio+GO6FFEgbFQ9XWoyDc5GRT82uXEMclknn64cnAlM9dNi0OW63SkM5WHB244BBZiVvMWUqd0wBNorXg6ZhgNkU9gMQG6gHJLZ8WJjW2KcghSHUHnqo2wDJiB+Xgd0hF95kTh2QJjskRX3O6wKvtZusabT5QB9s5rR9tNcrREYvoFpxoZCCLQaG8XAeseOiYPiHQ3jjexd7++Sjxt0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e08d501-3332-446f-ccc2-08dcadb08f81
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 20:21:41.5308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: stjn/1cn6TEuakpKtXOHqpp/vCsTME99nLvJ/MLZctilw/0YYQkM0LiFP+cfcx1t6H4wL9UHs2XwY/1PVBkGmUumhMPUMUYwEXkl+vbQ8OU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_12,2024-07-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2407260138
X-Proofpoint-GUID: _E5U6SFuPY46d2ADlzHP0uOPI6BcwXmw
X-Proofpoint-ORIG-GUID: _E5U6SFuPY46d2ADlzHP0uOPI6BcwXmw

From: Joao Martins <joao.m.martins@oracle.com>

The haltpoll governor is selected either by the cpuidle-haltpoll
driver, or explicitly by the user.
In particular, it is never selected by default since it has the lowest
rating of all governors (menu=20, teo=19, ladder=10/25, haltpoll=9).

So, we can safely forgo the kvm_para_available() check. This also
allows cpuidle-haltpoll to be tested on baremetal.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Acked-by: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 drivers/cpuidle/governors/haltpoll.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/cpuidle/governors/haltpoll.c b/drivers/cpuidle/governors/haltpoll.c
index 663b7f164d20..c8752f793e61 100644
--- a/drivers/cpuidle/governors/haltpoll.c
+++ b/drivers/cpuidle/governors/haltpoll.c
@@ -18,7 +18,6 @@
 #include <linux/tick.h>
 #include <linux/sched.h>
 #include <linux/module.h>
-#include <linux/kvm_para.h>
 #include <trace/events/power.h>
 
 static unsigned int guest_halt_poll_ns __read_mostly = 200000;
@@ -148,10 +147,7 @@ static struct cpuidle_governor haltpoll_governor = {
 
 static int __init init_haltpoll(void)
 {
-	if (kvm_para_available())
-		return cpuidle_register_governor(&haltpoll_governor);
-
-	return 0;
+	return cpuidle_register_governor(&haltpoll_governor);
 }
 
 postcore_initcall(init_haltpoll);
-- 
2.43.5


