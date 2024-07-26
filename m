Return-Path: <kvm+bounces-22356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09ED093D9B0
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 22:23:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B6F21F24507
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:23:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80C3114E2E2;
	Fri, 26 Jul 2024 20:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CXo+gWso";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tq/xRtqm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD0D149C6C;
	Fri, 26 Jul 2024 20:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722025347; cv=fail; b=LaQXifCnlj1ycw1a5sWL0hWTVJJCPUFik9x2mqidti7K5IAM5VEaMc8xEKRiguukb5SOmToIzkW0XuGbc4OM0x3WLlVmFp8BrnjM8rnKfDZBaqS/uSCGDQpI9fh/lqRIyHsDX1WsIBVHXw2zN16KROlpvcOe3WtKLR51ZqYVj9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722025347; c=relaxed/simple;
	bh=MTDPoygB9rdHRUHDLY7oP4om2dlj0IbFTqqKjixmjfw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dLXLQI/+IPos55ZjOLEgZ4F4ljeCcX2jBF0a7zAYedSBPVY4G0/rinV8CwKg7gQ+qibMMqncVSSeRr2pIWtDQg62AtPU3y3M3iLIJbkQOJrixK0i6eajs0bs/5H+itZCQOJ0KUFWJyIpfJ/MbdGyTSDzpCh68el5o+N4z3IVgeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CXo+gWso; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tq/xRtqm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46QI4F2q013735;
	Fri, 26 Jul 2024 20:21:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=zRnxNCfl74MxuSNGsro7Z4dqMVSHezXxO0enoFHozAs=; b=
	CXo+gWsopexKwHmv4REhUv7osl5FT3W5A2VreKLXWw7DbwuzII4uXjYVJB2LXHLw
	JR9VovoaLap02yyFAM41dvH75xjnSvT5rULo2kUUlb8FIunGdrOoPsbSW+0GlGy0
	qH5Tv8z+/x3rDd5DbNFxeVNBFLa9xlxlRlYO2Bi/0y0IxEdnZAY0Esf0yLgB7sYa
	iVt7KLsSQNAji1/3oIHvJLl8/DC9dxGVbUT8xFBjuljRLSLYNbPE5xFZ8jLDuLKU
	/y34t5jNq7ZGV/ZR+iMmddglomX8dBZ63VKt4wSeKsH2iCCm9Y3JXXF4TK80reaW
	4secm3jXH1Bfluoy6iLnXw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40k7yuvj6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:21:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46QJGGUk038916;
	Fri, 26 Jul 2024 20:21:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2040.outbound.protection.outlook.com [104.47.55.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h26s48n1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:21:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m+3xVHBNg8z4T0mlnpQ94lxWFHGlEFccfJ1mkQUw5/MXQLKu/4cdFSfgxksjUY4e6o2+0zbaaTkNNJon/R7uido/Nvup3vpBhpCXQrfOzHYmzT7PbNm0Q3wdwwO/5jTk5IGm8X7rF1HupBmNWTYgDiGEWgSoYOAJ1utjfVPYppchaxIGspkd87OljIrH5u0O47LPH+im3kQkPHpv5WLbu5sTfs8NM3pCdplbWlpQC2dtXtZGLqAlJcYIZ1IuCAUQ6SLwO5PBWi47AGUBsMf4s/kTLELft2fL6fyDJeQRgHNkA9RIEWzKOVdyPmVz+GKsw09icrx9wEZBXl8Z3/z2hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zRnxNCfl74MxuSNGsro7Z4dqMVSHezXxO0enoFHozAs=;
 b=NHRw5sUFeg2gLV9VI8HoFSN7gjw2PDAWDJRTov/rXFbEVZUXZ0urY3P7XntAi9RKl9Y0A+ZQmuxBwhTGcWXLQeyqsVja2G5juY8n5vaZA08Q+RJUSVjzgwwtNJZDFUa+ZfWq2e6gX6dF+teyQ6+rtBNS4BDWB3tFGFfEcAQbvYiPraEKXX6KwoHitYiQqb/IVWXchcx4XFCYivAx01pcynYU+nb16qJFyhvcGB4rYKSuLO2bz6IMEnTJCODS6nnVpe9Tek59wPIZCIrda5CNe0dHCQ7yI7kTMq8TjbSHFW2bplOBkgpAtF2KgE04SqAU6uCrNwjzduAaMxHsw12RUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRnxNCfl74MxuSNGsro7Z4dqMVSHezXxO0enoFHozAs=;
 b=tq/xRtqmaM8WpV4jN+LXy6W50BeXHz6+7G6ZPAy3Qy2jNCx9aVQh1Ko7ktSKxTkJZBhodrQlopreTpHcf2gAUaumpIM2iOW6i1SlIbOJRiy7e1TXwJfW61G4VMQyjNJNcmxmQYiTCPYTo7imlGG0q9NtlbbenBVR0zb5vPWmUE0=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH0PR10MB5178.namprd10.prod.outlook.com (2603:10b6:610:dd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Fri, 26 Jul
 2024 20:21:47 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 20:21:47 +0000
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
Subject: [PATCH v6 06/10] cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
Date: Fri, 26 Jul 2024 13:21:30 -0700
Message-Id: <20240726202134.627514-4-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240726202134.627514-1-ankur.a.arora@oracle.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0189.namprd03.prod.outlook.com
 (2603:10b6:303:b8::14) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH0PR10MB5178:EE_
X-MS-Office365-Filtering-Correlation-Id: 650e67f6-3b72-4846-3a8e-08dcadb092ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IT2m5N0RJ3FhRvqMwzvEzWESz1UzuGrUpaBqZTeFjw6Fl9LzueRlDPri6Io+?=
 =?us-ascii?Q?MVTkAZaaR4Pe3FqliCI9rR/hDli2Ig6Ls5+jFk7QtGcBZw6jV9qPgjIciZxq?=
 =?us-ascii?Q?PsKekM9AsdSdG8AUAhqxB2FGIsAHPdC5Ax9RRJ+GPxNS84rziGgWDmI6WVho?=
 =?us-ascii?Q?X7GbD7gwjlQ0kPxFurQpEQbe3TENvDrht46aI8xWehn5qJiEBuJ1B0qhDGGU?=
 =?us-ascii?Q?9fWMbY9qvz4uqpOyTwXzs+hVlSwSAmTiLhVExJhvQpzkEZALJhbP2D2xoScZ?=
 =?us-ascii?Q?cjYUAO+gptwfxXdvoBNjHWyg0LANsO9trsUAgYS2B32tbvGzowLYQo3nnEi5?=
 =?us-ascii?Q?cDrd211yFCkHPOsNKYzG54+Ypvz3B9xfmR7X3k3Aw+/JXZAnOUTLNvUJcfzi?=
 =?us-ascii?Q?NIvy2UfWDjAOU3N7+VrOw+Jo8sorPqY/KbY1BXFCtcaFfYU+xFQ+vwQjAqDU?=
 =?us-ascii?Q?bzC3zhfM1sukZywSzl71FHtf7Tk/3kHljMCENrP6eNa8pyxA2EtMOoL0EEjy?=
 =?us-ascii?Q?LgW3jhQ0EYTmX8vpegqVxJCYx4u2dsuwfB8HYFCc5BnqU2zKlMSyPKtf7R7y?=
 =?us-ascii?Q?2m3Ms3uo21algimaOFhBVi7fEmUu+K4Wc9ubkFa4akDP90zj/6eawJn5hVgv?=
 =?us-ascii?Q?SVAXffMQLmn1aBPV6UeYblZUAabX7WxGEpq0MZmW04elcVnR0POLMCnBn3y5?=
 =?us-ascii?Q?JNX2gEZHHJfDZ9+YxQ9ChDNfFPi+iYUVYWRY+DV/QStGxUGh3925WfBqTIvv?=
 =?us-ascii?Q?X++8SlhTD6nQd6Za8nZQJHNl5FKBwVuyLa/ej22WCgqVwIA03gfCNjug+xg+?=
 =?us-ascii?Q?cXeFDVbF2WlQ2eb/4ZljQ2Qm+dnxuV2LizJo4u/ynFSuN8uGMlUcOvRrCCBP?=
 =?us-ascii?Q?3sR4jRLbZQ0M2UQr0+WQdcH9PKuvQtW6/Qj+NdjnqaFeHB3EFCRb3nVsfEXv?=
 =?us-ascii?Q?tX0Wc6EnAkoDIeDVUXyj/+nCKZqdXr0XP+ITiztklMll/4WkRdQ6pE4hsS5g?=
 =?us-ascii?Q?VhddWuxNOQxkaWKVomj7kFBWJ8kloG3CpIBQXADP39hz+UxS0LGFlGzilq5s?=
 =?us-ascii?Q?avicCXlOMDqQdCC1Gs9/hU2lgFO8R+XlRd2+lpSiV5Lx3SLttVPBy/HRUTdZ?=
 =?us-ascii?Q?XFJvtjthQcrhLljQ8u1hk7awUrHR0nbSk7DQt//o8ddPcMizULbl9I/UYcPJ?=
 =?us-ascii?Q?dnq+JWBZnsduPVQqkb5DGP99SrRMI11MC9u2lwGVSNFM/Uv5pSSNh/Gneoh3?=
 =?us-ascii?Q?PUforr5VgNUFcHOrJ4zb1Kx3bNpjPu6P0eQgyGVpLazZ/FVvimEqHQ5F1pdb?=
 =?us-ascii?Q?0EKMQS5yckQYc0Hj1ArOBN/nnb2DG+vVUNxhMWwQOL/pYg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0bq2e0HNCtvV7XMWn8/veVKbdpLYcSIKLp/eaZqTMzOW8Z3SQ2iHunoqR3ER?=
 =?us-ascii?Q?tTL78UWIbGEt5eanRJxRzRIHLw5smp4ojMXTPvpu25B8K2ZQe9OELqBAHaYK?=
 =?us-ascii?Q?/5hIENy9HbvfETphW6aDY8LyvuBPy1mHtE5XHdjpRnd54TjL+uBEHCXT3PqC?=
 =?us-ascii?Q?PSdkU7wlkrY6gPGoeEl7PCrB5LnJARAggDHbMxNEYr7jLdwVS291LSNEFRMi?=
 =?us-ascii?Q?6rJIEWKDdQ90jJrRClN2iSaqpA/A5eMxeSUThMskpP/pXQHFV6AQUwGzlxXw?=
 =?us-ascii?Q?PrRtL016ZUcfrSQ8kjxuOiAzPVKHCmrtmUKZzhgX0IrYlO2fmqEeyTWw7VfS?=
 =?us-ascii?Q?HogHYBjYA8SGp+Yh00PB1X+OVXwIlFQ5Ek5SjhsCuyEx/IQKNaHZt1rQLvuR?=
 =?us-ascii?Q?v3Mg7fQwIB7cFo1rCy1JSgtOe2H5LNjSVeckwqVF34/s+AB76Ypvejtp83f8?=
 =?us-ascii?Q?yNSaKxZXAeb9G082yMLPfjcv6+KpONam+SRWt1Cc1Ysh/4lon7N6mQWwvrfs?=
 =?us-ascii?Q?+RXL2onsepJ7If37P84tmuBi/BI+IPKy7Z9LY692CB0NRn8+mQZTji6+6oon?=
 =?us-ascii?Q?3yMHXVy+1+W0ubj/NymTbFstVW4cGOEbpdLMLY/MH4bD6GmlbMWRT4L5X7LZ?=
 =?us-ascii?Q?qsW+QKLgjFwIfgY9h3fGaJLYQlwjEVkMHxXCTHbfrkQqf128rtl5oK5SpZzt?=
 =?us-ascii?Q?AiVCM5sizE9WFu1Tuv406wWSTyz1iO2dGH6jbycOZ0wrt0nYjdQs8bdu0PnZ?=
 =?us-ascii?Q?DJ2lMiCciDcUC1YhJh8EMPnX4Y/VrxV4PtLJm/8tr6FOxQs0k8J6UwCxlpjb?=
 =?us-ascii?Q?Ka/P4iyqhImQ+s7E+jklkTLlm4IcarFKOWFvQnTXIHPJ4KaLGxCADdpZEE5y?=
 =?us-ascii?Q?Lc+PmTAxlakBE7I8OChctpSPsl6xv9d2k5aXNjTYMopWA4m7wOWtYFhr3m0Z?=
 =?us-ascii?Q?3rJBrhdZ2qNxBiC3Flj7K/PtJRyAkE4+muuDQG/3w3TBFhOwBMyfCrUTz+3t?=
 =?us-ascii?Q?pIcAK4LeBf0fLAIinKgxL/ID9NwIChOhbEjNa9CtNl23xMnDmvXeQdMNIbwt?=
 =?us-ascii?Q?vK3t4VxSf3gpBAdcpil0Fx41IITz+hzduYgxONoHfdHmtPNZlobSqTpg4tUl?=
 =?us-ascii?Q?MZrhI0gg8WxWSrh88cx8gux+TBYdniomv65m3cDwDlUmUEcCEs7xM/IhRIA+?=
 =?us-ascii?Q?6tyFbuEq4qixKuqPR9yLXi7JqkNNv9fjIpMOFuyr8Z1uH3M/6nDaQWB4frYE?=
 =?us-ascii?Q?2HPFDcZoF+6A6JnN7lrjp6dSLnOK3u9XuoCNotD5aMZGF78xm/lVe1UUf4Dr?=
 =?us-ascii?Q?nrCvIsftExOltgJ9GHQppCIzqtMMN9eIILBfwrR32hVVnHXv0MBRFL0F+d9+?=
 =?us-ascii?Q?WsVy1acEo09vaEFBkSUJ591UdfozRqYALVdxH0yuH2kXJsjTbixrJ3mOHYEd?=
 =?us-ascii?Q?1qYzvl6FxhNId1Zbfa1YbdZCjcglNnZkqHCAB55RwSI07fNa3ob9e6aRVb4D?=
 =?us-ascii?Q?t4Ulm/eZ+JthI+xo/Z5W4ckDsmUXY3W6iLbbuqpOxgcQMz7SEQVrJl9xsNxp?=
 =?us-ascii?Q?wfiR8ACMqpYHKI1drXRsk8tb2iE+UmzsYRg02SHib924dXEs+ualnR1JvS+t?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/oJRIMp8gPyaBM+E3sIHWqhHdimkkXRETzHSPB81H3sDbqMm12S9dP/W+H28Hozg+rY1zgOaiCl0vyaPvtLl9k1pMcenuoVS/tn4vG2KwC++2kd86UcJP2xHwA6c0XOg0XcSi3inhLwHtyRDoFl+o+BnU/QrE2QwF5AUUcdaiCSQS9VnNF6CRi/iNcS5+WN32dGxQ0lRZrDxKLNBCJLAXYF9DurYMkKqtfzixMqDKvaoHCwkFzsh7FGVgNzNsBiPynmsF7e3msoYw0ZmYv/RyejeTHMBmjgCEh/K81++1fjuieX10qssJhlg/6z4RiKoMGi0SuaGNFyU5wIDbCpx6K431Xu4cESIJAPiAiLdcpDF0QiGQvRMuPg4Al3Z/k3wOVfzVDCiRaM/wJOHEQLNGc9ESDqp/v6gw+K+NWsX/EDdkbzZz51/BVRuIMjmQjiqcivxNytZZjUesoFHmkRB80KYnFb2uXSlJ3Qh59MMwgOpHktc9rHnbfPu+/jGCmLnlPn/4IVATqzQqcC79kEfE0gNJ749/ktqDYTv8u0DIzdWyIhvxpltzeZoMZIZPrQF6vV0gY0A0pO0mW59tsiavtmYm7UUH5GpwMJSveG+LTg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 650e67f6-3b72-4846-3a8e-08dcadb092ca
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 20:21:46.9828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L4l9ZWUvOEWU2f55lVlS/accVqdSP9UoIHdhQLFxZCNLGgaLOzvy8ZV7xTQbu8cKXEX0pw8sas6yY9RSxV627gT1+quBSIs3pZdoGOOCyRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_12,2024-07-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407260138
X-Proofpoint-GUID: eKAoemIe3o6_eW6aUdclPUpK4JLmd77k
X-Proofpoint-ORIG-GUID: eKAoemIe3o6_eW6aUdclPUpK4JLmd77k

The cpuidle-haltpoll driver and its namesake governor are selected
under KVM_GUEST on X86. KVM_GUEST in-turn selects ARCH_CPUIDLE_HALTPOLL
and defines the requisite arch_haltpoll_{enable,disable}() functions.

So remove the explicit dependence of HALTPOLL_CPUIDLE on KVM_GUEST,
and instead use ARCH_CPUIDLE_HALTPOLL as proxy for architectural
support for haltpoll.

Also change "halt poll" to "haltpoll" in one of the summary clauses,
since the second form is used everywhere else.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/Kconfig        | 1 +
 drivers/cpuidle/Kconfig | 5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index efe59741dc47..153535e6f55d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -838,6 +838,7 @@ config KVM_GUEST
 
 config ARCH_CPUIDLE_HALTPOLL
 	def_bool n
+	depends on KVM_GUEST
 	prompt "Disable host haltpoll when loading haltpoll driver"
 	help
 	  If virtualized under KVM, disable host haltpoll.
diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index 75f6e176bbc8..c1bebadf22bc 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -35,7 +35,6 @@ config CPU_IDLE_GOV_TEO
 
 config CPU_IDLE_GOV_HALTPOLL
 	bool "Haltpoll governor (for virtualized systems)"
-	depends on KVM_GUEST
 	help
 	  This governor implements haltpoll idle state selection, to be
 	  used in conjunction with the haltpoll cpuidle driver, allowing
@@ -72,8 +71,8 @@ source "drivers/cpuidle/Kconfig.riscv"
 endmenu
 
 config HALTPOLL_CPUIDLE
-	tristate "Halt poll cpuidle driver"
-	depends on X86 && KVM_GUEST && ARCH_HAS_OPTIMIZED_POLL
+	tristate "Haltpoll cpuidle driver"
+	depends on ARCH_CPUIDLE_HALTPOLL && ARCH_HAS_OPTIMIZED_POLL
 	select CPU_IDLE_GOV_HALTPOLL
 	default y
 	help
-- 
2.43.5


