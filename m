Return-Path: <kvm+bounces-27503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E126986983
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:26:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40F141C2362D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 23:26:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBCF81A3AAD;
	Wed, 25 Sep 2024 23:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bpb0r6Um";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Bxq4CdZe"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF571591FC;
	Wed, 25 Sep 2024 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727306734; cv=fail; b=pE+UA0twlqBhcfN8CyrbGrvnxrY1N8Fia6ZpeUZ3g4P4kyonyRMHHcREwzxMPG8X+kSzWg9WEW5JN3UY2tgvWQ/DgUk0fdmsF9QubVU1LBRhYumGLNOmqavHJAynXUpJUyEkf7RKiYqGSc4A7CVdJ9xsEQYEMkZlz64LJxxs6OI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727306734; c=relaxed/simple;
	bh=h+LFmQ5q9LcaGHi0PrPQz7lccrjdn+vfUczNGQ+nieo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O9CkYP1AaiMw2hHuna3Np6T7zaP+IpkU1YYGeSIih0uwoBgmejSW1Zo1YZtpwGjlG12n3gHJxLpq1e68QgniB8pkXfAKxvvMNBWv+3thJwU4bPytpL3ckK9ohJPKJyNEj4eX4UKIU53iD9zmJDOsLRpYhpVNRnjF4bjK2gyMWHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bpb0r6Um; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Bxq4CdZe; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48PLnNVC028926;
	Wed, 25 Sep 2024 23:24:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=rbuyqEwZ9kCiw5l0O3EjN14l2WDqLsKvyF0jfbbj+zc=; b=
	bpb0r6UmOXZ8ypjMGycg+SQjCzXL2wxKVcV5Wx5eo/UarIiGG7xOQkkjuBgStFU5
	jV7S8d5D41b9LFRCJDGInoK7v6myRls3ad1wQj6D2nw8fJDPaqhKnMvn96OR7Wjl
	jjenWIKfwdTWmVeljBmEtBu9jESiBRD0DVIszpO7wxQ//i9Ye88umSJFQ0bqpkjk
	i2LcNbDDqNb1aYR6OKxEIH2j0SrkxYtXD5xMq/KfoJ7SSpF5lHQlJkDTae2iL2hX
	0saGNiP2zb1dJPIv+taeRK8krsZORERolMLb+U3kZH4yxCGTEKxesE75y/irQWaW
	dWpPcu55tnzHsbpQZ9DUuA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41sp1akkuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48PMpuRI032835;
	Wed, 25 Sep 2024 23:24:34 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41smkhnpff-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GFVN2SrJHVthfW+E1/SpBpsSlZuTQ1j2hOIPn9HPFH1788MWQ7F6i2Lsp6JI5/HT5lwykSPhBFoI3noHXbg5+jpE6OknWqqhNnyUO8wpt+lxBWlckK/0Qi8sZAPw/y9NRYdMODY77uwnXNHYeVJTvkaFC0QcyqskaxgN6MvwvnAY60n6cKNNlCpKub4HqirGyYi2lu4+3YllU4CTE8U4qszrZJbswLJNIWZABrmpRkwtKG8dBHZ08EjJ/qploI9mEeEItml6S8gqivJarJF8RVLfhH0ta2PaXU9REWQeV/gPLiLm3oN5ypYhYwrF4jHmDkV/x/YLJ0NTf1n+YWcD1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbuyqEwZ9kCiw5l0O3EjN14l2WDqLsKvyF0jfbbj+zc=;
 b=QCnfWR9zpmxV0Rubh7J+5Of85tzvCXS/OTqYe3tiPcrYq7NXGELUBP+llikF6UeuXQPbtYN/EgfjKWXs+by04hmjLyuu+Ncwl0v/G635ym0WT9GgJbdHVXNteqcNcBmSJAK3zVvHiit5I+mmm+ihSnJesiXhdV/jrqV10BZBS3wURy5iahvH+EZt+FqiNlp0tKOtE1TkNmen+W+yJNOViA2BaY+w+3MKCR8He12J9dtcjS/c2G1K6Kkm1WJOa0bsnJYkq7WFok7i6NYjt1Buwnag+tCVqz6L4FFTn5tT3X9o7bNzBD++FKG0uW40mJVzKz7qh7xxtzE2aODWZMBOAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbuyqEwZ9kCiw5l0O3EjN14l2WDqLsKvyF0jfbbj+zc=;
 b=Bxq4CdZe2QMbH5Xrv5IMmH6YipThPiyFj57FhBE5WMPeauPJdiAqBIfHKYjc+zrP4Fxi8+7jFE2ls7aIeKs0Mu9hC5Oo+sGPU+PvAh3dS7BxvI+85tHbAg/QRUKs34d/9ZG1RXs2ez+H+kUTWiCOPjmuLamwbdTkVCJlNk/TgXc=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 PH0PR10MB7008.namprd10.prod.outlook.com (2603:10b6:510:287::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.13; Wed, 25 Sep
 2024 23:24:30 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%5]) with mapi id 15.20.8005.010; Wed, 25 Sep 2024
 23:24:30 +0000
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
Subject: [PATCH v8 01/11] cpuidle/poll_state: poll via smp_cond_load_relaxed()
Date: Wed, 25 Sep 2024 16:24:15 -0700
Message-Id: <20240925232425.2763385-2-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0140.namprd04.prod.outlook.com
 (2603:10b6:303:84::25) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|PH0PR10MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f0a1dd1-0c59-402b-a1a8-08dcddb93404
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hpne5GUjNew4Z7Ug9NZf25Mw2lAGkwpFoYNKEPHktMal9ZY9g/zV5YBps4hj?=
 =?us-ascii?Q?8Qu2e4MvQGi9OPTrx/BpCNwCYIpTha1Shchl1Llc5DcAM9sNCJOk/OZLp61V?=
 =?us-ascii?Q?vOgJELBRN02yIfWinIoh6ZWE8BZAtAiMqZg+mQLBKrxwgGclbdYPh3RadYd1?=
 =?us-ascii?Q?zAzXsXg7xeI+XEjuYtPZo2qbVHcTSz/b1Ew9W+Ek8qJPw66Jg6jEd/h7mcC8?=
 =?us-ascii?Q?az/j0fub/QunmTx1wIpIZ7KtgsZC/6dqcW+F09SK0wo7dS0oyMIRP6583aI3?=
 =?us-ascii?Q?w+pwU3glsW6LoLdw4zVAAFPScE+Q6l0wkO4/M7/bPXteWI0SufZZNkCiCRTB?=
 =?us-ascii?Q?LsrUqlCYp28OBZIeiQdTt2bfrVpfCaPq+WVSCE7LtBiaXoxA17J50/XzdDyu?=
 =?us-ascii?Q?Hq0zQ4xo0EdXDLRCNGJ9q8QHW9thWkuICiR2Z0eKmVJme4fPeAJCf5gy+Q7u?=
 =?us-ascii?Q?LTNVcJcrTfSy0GMMGtJ6Fcqak+wGnTM6EQ/Xm5lOkhsOdh8+5d8qw0/dyAOa?=
 =?us-ascii?Q?dZLlmD+YzoqsRLSj2TjAQkvpksOaADWDvLEVH8Is/LXy+ENOM0qDP9XVr8nU?=
 =?us-ascii?Q?rLtvnvKEkiVXrn0rDnqfR7dTpWQXA/jMeV6EUTiTU72zjFamEu1NXbauPX17?=
 =?us-ascii?Q?vut8QBihDaJLPSliHXui2dH0vHr6ITufGFIG7fIzE9StCvQv7QqIl233eLmB?=
 =?us-ascii?Q?HGlUwXPYADu2AmNBCCefLVvmfaehnzIDmZIETzZZ6LxQJfi0k9OyV/Z+Y6QT?=
 =?us-ascii?Q?UtqmOXElYkQiQqFhVvgfgTd8jFgHwbPHwxrWZ0LVWMFmLr460pHxm19RC0s0?=
 =?us-ascii?Q?OfrhJ27B4Q5GjDwtCXaMu45r9l4pesrwPTH+oDfk7CMajScH2wZauivD8PST?=
 =?us-ascii?Q?2KvguOMBo6MSu1S/WwfvwnCBIvFbHygXLIefR0OzFxfLisBIuflsSxPTiN5p?=
 =?us-ascii?Q?M+BxQluSqxSQNSDdOWmNNdQtcCric/va/SpcTKDYXegnztBLadUk9foqL/dY?=
 =?us-ascii?Q?hGWIrDh/cbzU1zr/k5U5XoykH+khLvq2+8dOM1kuZd91uLRwkJcUGD7KiDl9?=
 =?us-ascii?Q?eNP/WOx3aA4ZDAwvN9z5MnP4tqiUgHd0ou+h5tm2ZInhby2XNrbGnG6Br8Zj?=
 =?us-ascii?Q?w6SFD2pe3qsJEqtOj//rb3C2cPYGkEV9ymkyHrnzl4fsbrdFzAMu/bJb7SOK?=
 =?us-ascii?Q?5vjKPUOj8mmCKZkS47KDL6YhvoCFdxFKUR34tBTfdiYshajaQA1+6fnGqrNj?=
 =?us-ascii?Q?tGQt13Z+HSzZDWDq2WJ9mUxyWXwOEM0+mIsvr31thQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8h3R3M8qGKSWvmzhYzvSMLKT2Tkymdlf21g8etj6H8yxX9m+nsNtY+pRenDS?=
 =?us-ascii?Q?QrZL5EPxayjUdFu4yZ5nhixikY4EMKmViNosotO4vDotDiUIeCwjKW4DbAI3?=
 =?us-ascii?Q?vP2wsgyXoB+WKi4kTO1DiaaVuBFkkjwLwSnXaqywveYhtw+MdkYtEoegU42X?=
 =?us-ascii?Q?HOAb4FpVd/q2C2jWl7z2HAvDD2eSUuVhbdVgy4qtc0uDTfhYB6g+15DrH86v?=
 =?us-ascii?Q?S/fO+aWA4uix62B1mSV3UuwogEf2q1p6+C0UfcjGyEXM3KuvNUWMTVpXPBBj?=
 =?us-ascii?Q?5iTA29p7h4GahkoejwYQd60jLAOKGzj6XKyxD9z5H2/ENKZ226OGG+rkSaxY?=
 =?us-ascii?Q?/SwswOC9LWo0JzsW8XnEvnERlMjJLZ+XYqArJIFd3tSmoS3TlYa9EkAPLXkK?=
 =?us-ascii?Q?6R4o8S3RQaa8D/0n0mZhnWKZXH/EdGMzjctA4fu+yeB5z5kZZwBNdGdbpb6m?=
 =?us-ascii?Q?l/eD9Sqj4rltzOP3hFxG4xUn2oJBIVWwIAk8wXnwGJ01cdaZ5dRav4tU618O?=
 =?us-ascii?Q?+Uh0L6Te2l1VkUGDmxbK7l29kmHcTwOdKHmQ6liDjaLT3yWlhXTbuUp1mVXv?=
 =?us-ascii?Q?L3hHv6/dWxkoI/7vnbL93WRPgjGCNVggMWCjhom4NQdoyybGFqI5FNVdVYM2?=
 =?us-ascii?Q?k34DnYICHUG6SAcc9Adl+XyjpGk1Fl3NHDjXjhch1T/uKyG4+FrLU2NEC9B1?=
 =?us-ascii?Q?3ORGXrFgQ/Ix6hSUZaRDz9j6Tjf6GNH28/sEIIItWgO+lAMzpYfYVexB88XT?=
 =?us-ascii?Q?FGckRaAz/2nAhwU7qF8MO3Il1YKg1aRhPy7uGfvapQeIdOuEA67q9dCNeyik?=
 =?us-ascii?Q?LU3ubP7NQEVSAQJaSyLPxo21/rZyR1JzZFr6b1AWUAZcCZsrZRQVg0GsDAi/?=
 =?us-ascii?Q?xSLpiB0Z5Buit4cAr/U+yLEs+LeeSRRJgANR+dXAaejGng1Ur02thFOQFmfc?=
 =?us-ascii?Q?f9lgV+eOKA84cy4vas7HqpF5P9oZ9kYD0mGTqora6KDurTo5ERjzAnLFCdVE?=
 =?us-ascii?Q?bXlMHHZIVH9yp9xV9pnRvCUQUThEFbwrtcc1NTP7i9/xho5RRv3iW88/LPX+?=
 =?us-ascii?Q?lzFL7cBebkezQyrMwG5jcLUbplhKPz39ePBWvXb4lU4+n/Wb8fZVhOmVPRc5?=
 =?us-ascii?Q?WjxHno5rkPK1yDDaTD71A5omB6bYll16t/TZFw+qIx3g0PPFui/UYIbcVgdy?=
 =?us-ascii?Q?7UD4p/bqlW3OYJxsGO7NnWr4yloiehPZc+XChJ0gohJV83wZrngoLhLrRsEJ?=
 =?us-ascii?Q?8cM7CV1e3my+3+wwzanVOE8b80GgvouH3YeBn1tw6foFeiENCA1LYuAMwQ06?=
 =?us-ascii?Q?XVCP820h6jnGpUaxOaq1KMKGveSeSTxOW4Cd3igQUJCdqKeaZpnCe8SFB0QC?=
 =?us-ascii?Q?GH+2gN6jQNf71XqQzNLgnKPFUdhH1ueSgyrpkOfARoepWpZNl7YeZgiHFxJ4?=
 =?us-ascii?Q?Jm/2Hs5O+zvYMpyJXvsV4J05VuF25vYgbx4UcC8F/8nwtimY1W3B3egwX95W?=
 =?us-ascii?Q?hsnZPszDRmrrZ/ahkvD53ktsGuB6PO/4iArBuBQGv50rav+LVLsKEAI/A62d?=
 =?us-ascii?Q?O0q+gNRfTvC90atugE0L1C+36c+NTKSMvxpqvF+OLeqRncG37N7o9v6OAOTy?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7rSZEmsKaw/NUg7SS7mK5qwDjxNwNcVZXWuWBQ71Ob5yKvywcmWt9yzJTSwzGULSzQnnTsBAfpS9T9u7tNeJYuJ+SeKY5cW9t/DXxW88swzR/DmEy2c/W0mFDH5mN8t00XhPQgDfchbHQTkIkyME/8XFvJQFV121TOuMdzDYl6yC//YXnv+txSasZRTxmBMES8xVVKGET/AXyypThDDIDjjVe4rdZdrCFfvIGMgefBk82+6/rapBatByFRigLfdp4iWg6TiK+v1URw2dVnryUz1arpOKSCi7OPvnrYc8wUxGH4QAcg2BUd92CDQmSln4hjtNlY19hudjfbxS14Wr8IBooPZd5PdGmrfqc/MTYR+WF+MOHgZcZjEgqzhvukNUFHXI3j2OatKR7E1TyFPa7qYhAczfkf/hTcv3t5nv0/a/ieikBseA3RWxbEr6UTMX9Gb3AWaCNGvBycB8RVzx8PZNdzR/KzF0wwlh8Wwh3AuIXlnEH/VtJ8QZ0krhGsQARR61/ddLghRQwjm9dvOH2AURGk16BXjQNJaeqBAPsdqiJxU8eE76QEmbq2MAg8JpL7jq1PE6aBw35uQxdl4jrI6p0aqdOTdYLzEFBNI0pOI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f0a1dd1-0c59-402b-a1a8-08dcddb93404
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 23:24:29.2626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /4S3IaC1GZbTcHBi8DcrgH7KUAd395xYqHiG4WqP2xs7qxyxVos8M/8Bwlfh0l6ehOolTjfr2D9BifHUdvRuNvb9tO1rs9QIpMInqgJOtGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7008
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-25_14,2024-09-25_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2408220000
 definitions=main-2409250164
X-Proofpoint-ORIG-GUID: OGYJDZ4dxEJd9s9sioHTNniV1czBdFPt
X-Proofpoint-GUID: OGYJDZ4dxEJd9s9sioHTNniV1czBdFPt

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


