Return-Path: <kvm+bounces-27508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E38E5986990
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:26:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08A401C22A52
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 23:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6671A726C;
	Wed, 25 Sep 2024 23:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VUqxm7+u";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aTgBld22"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCDA71A38F2;
	Wed, 25 Sep 2024 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727306734; cv=fail; b=RZNifPcCjZl8QoXzwCHBrsPVjDi3NBvO7YS9z34MbwPkTIuBznZOZevZIEunTeXk+BXrgjXBRUagjJVeCl9C5vSbM2o5+XSGN9fLNJhTT462bqHBm4rIPk6TGJn/0c3YdflTbkZcONchKZxtEtCQyJsc4uc4OJxal+W3H8W9lKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727306734; c=relaxed/simple;
	bh=DNK6XVE+FzE3bj2MQnnY55y8voszKiXo6alHM+hQeZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D9dHLH9odsG6VAtfAhPthaOfWMTbfwtOjimfDlVxzxSaBZw/YkITwjM8JkY+3YPtoWBBAl8xYswEUbtBqudlHp8RTwWLwwT31i7DaYG2wESJZJ4fupqd5JOF1Hi/+8pPAPbhBbf7Y59J65zwtifm4IDO4q5pZEE8YMj7c/CJhug=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VUqxm7+u; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aTgBld22; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48PLnWPG024761;
	Wed, 25 Sep 2024 23:24:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=Ct41YzkAvMC8w2J1TAKyBcOHPAoVVS1pNFrZqsC0dqs=; b=
	VUqxm7+uPkMqJwogSkW1T99VoWmUEydXQzOmsdQguoqHb6UTOyUt79ZmQAeR7lyb
	4ReIukHC3vY7qpovoXmR+mzJaHcONDJjj4c7tiNzeX3L34Esy5+npLR9M44nLGLV
	hWK1VlxjxVBU9cUS2uaL9FlU53LJAlFbqxXbbOBtyY331erx9g5ZoWf2ETQJUiyC
	iF/IP2r9FJQhY0GiKzyELjkk+WP9wvB4LayA5PNKa6Uj1opppEz5QH5+DKRA9ZTn
	jHaOpZYeTwc+SJRS2CR10rVKgYv7UJ/S09xRVb2edB5RhebWJyNgYexne3/vYTS9
	xcSygNU6XNp0NRCsybUiIw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41snrt970n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48PMpuRJ032835;
	Wed, 25 Sep 2024 23:24:35 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41smkhnpff-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oYGx8r5Htk7GEOpFYrH0Zx2dcRDf7Eyc39f5kD/BdlCIyJF4zWAlZ6rIHalFsPIuGWb5UEsqij8XblUfJve/yBwhFyhptIetQQ03sNC5qN2TGhPec4dWD+xE7BQFB4860ABska4FdL9pAVVN3kc44UQCU2aNbWNLrtFG2OY61TM51kf7dVnL7pasLsLSyLHQ5S9Ojo1chXj3EtfV8DzY8SH6UMjIq5YW83gfaW6WGQUywk3NKx/G76rLAJptYSdO4h/tz14jwHDFGsnDVeyqRRpl79erGmTSPfNSBGtZSv6B7YwImQE8spz94Gywm1bR7pdCb+QPR9i+oEsY7Zp+UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ct41YzkAvMC8w2J1TAKyBcOHPAoVVS1pNFrZqsC0dqs=;
 b=sQrIuFJfu2yQTZtEVrpNRewcGvTRdhF/8GNABw4Umvv/RBVW8Sxkw3bTs5NgP6EIYyh1kjCiLxhdjJr2EpcLnufqaRH1oRmWd07wWLgnUjPA8T7asTyTeZekBwVKHK/DBPVcls05RktLKzcRVTwMVxvbUSPHs7G5aAa5wHzuvV342fQH1bnfu0s36ctwFD2m+3jE+DRBuvlqpmnDewhGhfZj6r2J78aRfCyap8azfYyN2CNEZ5PnqphqqK33WqdTTUQKqujJahyu7LhgpOm3BD94PDttgHEJG2LYxCZysTCpHmEbtQTM4aOoyPaV3Ux56MkcxHVrWA8KXU83l2LVuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ct41YzkAvMC8w2J1TAKyBcOHPAoVVS1pNFrZqsC0dqs=;
 b=aTgBld22KJjdFxJdA+olbeHDf6sBpxmfBZQg46dL07oyIg7iqq6IddDr0QFZQuIizwuL2vAFCWWu4Wzo38rlTbQR/F/rg1SfnuXWZiNc78/mZGIchxduIO1mu0+ycWENslk/F6DGII/S5fxhm+SRQeR0p6/0FtmeMf1UtV3Cxfg=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 PH0PR10MB7008.namprd10.prod.outlook.com (2603:10b6:510:287::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.13; Wed, 25 Sep
 2024 23:24:31 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%5]) with mapi id 15.20.8005.010; Wed, 25 Sep 2024
 23:24:31 +0000
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
Subject: [PATCH v8 02/11] cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
Date: Wed, 25 Sep 2024 16:24:16 -0700
Message-Id: <20240925232425.2763385-3-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0134.namprd04.prod.outlook.com
 (2603:10b6:303:84::19) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|PH0PR10MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: e83aaf0b-2da7-430f-c81d-08dcddb934f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8c/XQdMnuB9n5gn5hyBIwg7+esOnDJ1bYR39ECW6kzQGHnyRVTjhuoWlHNIF?=
 =?us-ascii?Q?ge691ogqg2kjf8ZFd9saIq/gCZ1iRTzvlhIH8ZBDUVeTcGgd7eGulD1UkL1L?=
 =?us-ascii?Q?/6ZW6YVYnFSnttcRvRXEozWPCsx3xNt79Z7atXpaUidgSuWnpSH8G0AN4cTH?=
 =?us-ascii?Q?jRqIm5FZlXczD7Op09bg6K9wwmylYEEzBkdi48MBfv+MYZiW/T9clFGUNiAa?=
 =?us-ascii?Q?QIMAousYhJ9G6G8wEBgFy9E5tsVPCqf9wAuj0yWfrSZhJVQqkXTiuCdgfg8W?=
 =?us-ascii?Q?GqNF7sIk+gDfOCuOantMKxAOq443yzt7d/COwmTgbS0KWdud5Bg6Kw9hjD3s?=
 =?us-ascii?Q?z7meL3eaOwN433xdN3hzEgN07WPVa9jEcgSxDYp8OIow4xxJ8zhmgHVVjRwZ?=
 =?us-ascii?Q?ax7crVXUem8tM0j/qb0PArl9dQZrWAbkRIGZQcvDho18C+KJPA/x5JR/ZuDc?=
 =?us-ascii?Q?GVY1hs5S7XGTeFzKClfKxYKwjWSNEvdpTVhvBM+/yTfq4nsUNv+KM+hIEKGw?=
 =?us-ascii?Q?MprDJQpMWFo52/NYdps1atfUc665MdRLEZOZASA1FOwW3OBuhjHf4mOujCRK?=
 =?us-ascii?Q?XpXNy6+CER0+k4dRkjBD/oV1CCLe8UF9hNpbBcYS+rwdysj6wz4lgzul989+?=
 =?us-ascii?Q?EZYwB6dcniikbUq2jTtIBiPZPC5/XeZjNJoXL20DZAOLNSXDNS1eYSzdzhg9?=
 =?us-ascii?Q?DMFV7yqCT9pdpOUdtUMhJKvIj9Wrl7a+FYYJtxx8wADuvDL56Q+tqfnfhwWy?=
 =?us-ascii?Q?7xnpTV1sS1M0CM1h5e0zkuypfPyhaQsHmTDwgg0WwR3E5Zx0tks6/dtZIe0H?=
 =?us-ascii?Q?ZnZ2rsdUZ8ekiXW4zsalMKKMNTS/hL9ttr4jSeN/5K4rF5UCGNxZkhI42e6V?=
 =?us-ascii?Q?hQ0cBPlQ7W7+VTh7BN/VgpIcxYDwsuOoH5AXSHwqb4dljMGiLdWfkulzdOyB?=
 =?us-ascii?Q?tcMUuElPIALSHm0S7BPbgmBBP+Mcv0YWPknQqT4ZxxxHvh16FHAzSzz3pAnP?=
 =?us-ascii?Q?QuFr7FIWj5su7pdyeYcjS8cZEI6xWVMD1T6k8R7Lhf7TbLR6HbTtanUjKGIw?=
 =?us-ascii?Q?CI2Y7mViTHMyodE4zdQIbzsTNej5tz89wKPQnFuU5ZBCxD4PmsVOQTMeT6LQ?=
 =?us-ascii?Q?IhIHAg8Hy5KZEj9y3s3IVwusHoEDubVQQtoYILMRjfS9VbXMSnX3ONwsXHz+?=
 =?us-ascii?Q?f5xYCmJ72tWm27WHP3H7IPF3NX4E0U3yh79am2BRnrMQws+EGJMudzbY+6OB?=
 =?us-ascii?Q?zk6cUfImocQeCsRInojwBIPU+fYFB1cDLLbWc/T3pA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2FN+Oq2cz39iQBz4bwQ9qEPOeHJZAA3JOpYzHHx8NkW6oea+k76obfyByYhH?=
 =?us-ascii?Q?izo1jSaYtCsOmvSYWFu7Oum3STZ0gF9zYCSS25RAeY5/aYKonNjmBuukdKDJ?=
 =?us-ascii?Q?yVufZpN+QmgnbjFBbKeS2Qde4ii6eiYoH4tmIpjiImLMwnuD0v/GE9DcCYGs?=
 =?us-ascii?Q?A2XvAVhyCM0gD5UjAUjzIJsaGKTOGXjhC5jKL68WeL6W+3R48DGgarVI/m/r?=
 =?us-ascii?Q?ECxTY+C9nTJvJM5rgEwInMw2GWumwiZurRd2D/En2id3IDNDNv/CoMLk6Zoy?=
 =?us-ascii?Q?u+trVSs1WZi4RdcL3nDJ7vkq5TE3bWOPBIWSWTmjcxnXSwQx6cYdkpkDwaZq?=
 =?us-ascii?Q?bOOqUbr7xprQ1I2A9ghfLth5EY71NQja5cTjW3plDaTbr2EFanpED5HSZBkB?=
 =?us-ascii?Q?B/vXCzUxnKCYMfysJ2qrK1XK7fT1mKo9LpKqONlYK/eVrMIj/oOj+7QsyKHo?=
 =?us-ascii?Q?k9xy3SomkzoOO+uk442ehM5v1vTpip8RhXLg7Q6ByNLbT+P6HLm6muCMcRaj?=
 =?us-ascii?Q?/kcBzWFqDgML14dI4fg82WPm05Tk9CB9+OAdOUGilymtwUht4nq7zBjvyASe?=
 =?us-ascii?Q?0ylH73Rr6K52Yp1FXCT6fqWQl7PsJoF4+Qi/MKdIXP59H6Cd8rRsIuDPVUW/?=
 =?us-ascii?Q?aP54p5Fr3cyjOYefuqzCD7YkyQmkNnf+orUW/5ePtQmEL9dvk8xs+nezswId?=
 =?us-ascii?Q?QGreZfDtInpeKDBiZwFlj0Dy8maIe8WtQe2l0Pl6egWVCAR0IBf23Jur2QMM?=
 =?us-ascii?Q?7jwEQy0r3Aazy+3vMmJPW7+2FbxQyPxeHypnFurwHoSSFY99hqS+bUlj82yS?=
 =?us-ascii?Q?l/erYzDFw2h/ANUqFmpD3okjbOEDXJ0ZWzGAjx4V/6sfOMIFn478qn10dq1P?=
 =?us-ascii?Q?w8egAacRG1JweEtx7EmJJYPpr3w1ir9UmZMyWpzu6sHKvNkUyjENeuLAdCma?=
 =?us-ascii?Q?z5NYrOQ/qPPy7yjIklwdaflSfrKkTK0BuAawIeoNnOKIo88NWn/W7TclgfQ6?=
 =?us-ascii?Q?4CzZnxblL8Jobw6OD+mpnNeyCAZrmUQljnrIxhh/ZEH3Avieq6ys8G/rfUg4?=
 =?us-ascii?Q?cwiemloUql7XWnx5fWYU7qNqDdkWRP+0Yi3URwaiQEm2jrKazpp7NylCrjyr?=
 =?us-ascii?Q?CSyYxIvJdPkyOWAoJdQrgxtcjxqaf9f2D8+0gxkuxe+sMKfP+GMrhBoAK3q2?=
 =?us-ascii?Q?QDCgk5s5A2nXHAvpY/0/dJYP3BlrXWJ7zgTIB1zWsHpelh57ry6P3wUe9SNS?=
 =?us-ascii?Q?rR6iBuOQsbl0GC+kj9tnyPXel5Z/6yGkZzI5JVywsCnUUZA/5wJiEHc5KGUP?=
 =?us-ascii?Q?YhHsXH+hKkLvr1ihYDNQbaRFLyRERKSRaevCeuM1cLlJFmT5rvpVPRfp7RJa?=
 =?us-ascii?Q?LW0eNsLK3whReiR20j1DSXhMO7FcHvKts32flXN5m3cJ0Xbk58jI4X81EvGI?=
 =?us-ascii?Q?nezivZFa5aoIRv0E71rf+9UbcU3v9kEM4l8npOYEbALYxE0OqRig/fJW4toB?=
 =?us-ascii?Q?KV+/j80ZKzwvNGwTggtP25t6YtRtCHZvVrCNEQvUg63X2/O4VGNGItnD7UjD?=
 =?us-ascii?Q?iyIsYXx3dqoFiIEnK+IFBfsgpyegZ3S9KzRmBo/BZyfq5CZaCvLHDsBXnntP?=
 =?us-ascii?Q?Tw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5Mqa/Sl5tO1NGxK4sUbjYETOSnzXxWoZhFEtMCjgDEM4J1GpHF7/3O+rTkFF6LRBXT9mZQs7SQIUVVg85RNoi2lSm0BeyijLhIz0rKLI3xxnL2qiF9rniZEIjmhY8NRlnl6RW28RGuojVhxhrj+KLteEJr1lPl8XXC75Wm3Z/RbbYhUK3CHkgNU4zjeE64gQwXFDBWjUXf99VHaItyCPlhODVyBU9DkgEEUImEyHw3hZtSlfNaO89qayDEBg+4Hc9SNWN9I+y9Qn5z+s9Zy+dlXKE2L08wp2Kqskd8hRJ0LSPostr0fc14XFoCy03uNBl6j7rBnEKGpaV/NNcSd8lzsdwEtmRz0JosD4qiYSq7HCL/BZuluLbimNdVUza10bec7KUShicVsgzRhUeaopxXP+1NTCGpvzUkY4nXU2HsFkj2A1PHAz/AOtdbeV0PQ1WN8iqyrOdTKf52gem51ImHPhhWZlmbgveucruChz+86xt5tiQ69DluArGp2B/g1KM+k+uGBBxubnaEyEBs8z90S/iDNKojuDlfw9NiF25IwB4KNIucHh2KcX2U7EhwyuOfq9q2FwF4vaDoniQyUJVqd/fzEkj2L5Fox1bdFvm5g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e83aaf0b-2da7-430f-c81d-08dcddb934f7
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 23:24:30.8669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h7umd7nKsGnXQFOCH8N3BSi5TlZVzWpmXUi+YelaKUyf7zGjXXjZhyskC4dPK1ztRFKdcFrbYfl8g82mrMU/rlgBX0jrosqU2VRPt/7YJe0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7008
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-25_14,2024-09-25_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409250164
X-Proofpoint-GUID: R15o7r0RjoIQQ5HHe6I-U3VOibnUvFEa
X-Proofpoint-ORIG-GUID: R15o7r0RjoIQQ5HHe6I-U3VOibnUvFEa

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
index 2852fcd82cbd..555871e7e3b2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -378,7 +378,7 @@ config ARCH_MAY_HAVE_PC_FDC
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


