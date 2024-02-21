Return-Path: <kvm+bounces-9340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DD1785E8D8
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 21:12:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A10041C21903
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 20:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C71D28663A;
	Wed, 21 Feb 2024 20:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="cAXwq2SG";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="nz1QP1mg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FF883CB2
	for <kvm@vger.kernel.org>; Wed, 21 Feb 2024 20:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708546361; cv=fail; b=Qz5QmuToZitYj5dVhy0VIj1UJQwAEORi4cAENekCV5rTIUztHR00ZfBQrJtNXUZaWpyyWhTrUKQXsne2wWV87vKr6tDV9Sy8vh+nJFXjzhmin5w9Lj5HGjERkhdnhlaCBJFAv/P+AlkUgTFTX2/0sUXEydMcgm7lgceA24SDKeI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708546361; c=relaxed/simple;
	bh=lmBiWA8ztoDYlhTX6KncAqKYZ17jXsNu1b00PEB0c0E=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=Xj883ONRX8iysZxmzeytTl90JmiDLn1IPMeEl20+4yjsNvtjnvxxtZnvb3t9nr6zQLJ/5aqRKyEQJ48W3OVV/dsIa9TTxNDZnDOh2lJjvzEi4NppyZOeBOegIBGRsL7FV4eo/TWPRsF69zRI1XwdAMiHwZ7hkDi+xU+hItgJBBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=cAXwq2SG; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=nz1QP1mg; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41LJdeNN020272;
	Wed, 21 Feb 2024 11:52:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=proofpoint20171006; bh=bmUyuOBXws/
	zmvcz37ltw9NpOTuOoXtQY8alsPjiSDU=; b=cAXwq2SGcI7um8PB0tKPtWaYhJu
	J8QXbRgFwPwNkunQeggxk46OVNfHUXSRrDuoYyfH86PsNuTCu1+sCvhUd9qh063B
	TjR2V4COv8hXOUCnUW2koBQqJvcHAWUqwUrnrpDLn7IZRu/m242P3ZAABNh/nYQA
	ismVQKpDTkYS7PKp9WG772mCg+Ogz9VeNZJvftJQwJlWaYSrep98GPIJna66hFXp
	8XGujOIQ5Sf8PCnTWL2nGAJRqU68roxAc51Qt3qffl9Tu7wnEt6/zATFk1FDm6z/
	NzqTRJwRoFRXDRX6CplOmk+73+OeyRCNGdJ0W+dG7qeq1it6KbaNFvz96cQ==
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3wd21wu6r2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Feb 2024 11:52:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cSLLLeHxiq7dd5LuMoEsFxQqp/2hASkF7qFQg1D5WGcaMZybiI727KtYBPcixhUafpmQ+XmuCSIWYYag60JHEiGn2nLfy2kEKrXdpC2d4EQmzYM4JywxDa6W3QD6Ww8HJHd318C+CoDMIujisAUuPz/rnQ19XxjHjX1HPhZwCpnH3JDy/vFn2/df2kFTfel3mgIEyDplv6qItAvUKBgJ//78QZ5GO1MqoD0v63VMu8gAvuKL8KS385+0rjD+KOnkxZnrGFoR0awEk5Q/B1EM67vJMv1WFGt+xJgxyj3kF4Fz01BWpmvi6m2J7tOzDB6XiIm/giQIu4320E700fjxGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bmUyuOBXws/zmvcz37ltw9NpOTuOoXtQY8alsPjiSDU=;
 b=PegLoYjKlP6xFIzbSWQXqO8NNFxnW3/M3FbfgEQCirhkJZZiAe/aP+v/aL5FY+3rkqe4VXxvq8B02C3OfnQRz8LJTFCT1JOOzRjTwfvBsdyN2hnw7i31plVObTMSFSWPiGuvrcbd7hVA9eltbCxBFEE4Mv14q3yUXfqLG2hmTCMaw3vCSawkmWjrn2fIaF/6Sfu53DtDaHtBDudKqmaLt4QZQBGkHbkOutZq5Yw3LO85SSXOC2H7QR7PORtckg/m89+ks3L+nQmPx8pQtpSurfsqWxy+isfE0uwHaJiCiBekkl0WvzPoXVBF5McQoidKw5XSIcPo/uoe1aEIb7iYKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bmUyuOBXws/zmvcz37ltw9NpOTuOoXtQY8alsPjiSDU=;
 b=nz1QP1mgYmhc/MBB4km/p1U8uflD25qXpfSU883fAUXDG6/TBCrC4Grr/GvqP7V77tVrQGlGlFM6w5RRmE+ZTUWKmX84lqj8a0g8M4RFSaYKGaLJfbKz9PE9i36hBaUz2KpIbtZVRZs+NGQhtYx33EWSwRojufRjL5b5l6IgteDWuczv5eNhcxWLe8RJKNXWwxCD0uG+DhcoQxzenXspqqPnfhVtvIwnJtkf6wqi/rN3ZcMdYz5uzUwaE7UjRhPN+555SNteSEcTZ8YFaWTcn3HlmigishSs4u5NnppV68DiObvRRYdRNHSVExYvzd2NAXVnZsMzJ03trkrKzdu9rg==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by LV8PR02MB10213.namprd02.prod.outlook.com (2603:10b6:408:207::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Wed, 21 Feb
 2024 19:52:15 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::4a9b:daa2:2dff:4a60]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::4a9b:daa2:2dff:4a60%3]) with mapi id 15.20.7292.036; Wed, 21 Feb 2024
 19:52:15 +0000
From: Shivam Kumar <shivam.kumar1@nutanix.com>
To: maz@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, catalin.marinas@arm.com,
        aravind.retnakaran@nutanix.com, carl.waldspurger@nutanix.com,
        david.vrabel@nutanix.com, david@redhat.com, will@kernel.org
Cc: kvm@vger.kernel.org, Shivam Kumar <shivam.kumar1@nutanix.com>
Subject: [PATCH v10 0/3] Per-vCPU dirty quota-based throttling
Date: Wed, 21 Feb 2024 19:51:22 +0000
Message-Id: <20240221195125.102479-1-shivam.kumar1@nutanix.com>
X-Mailer: git-send-email 2.22.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:510:23c::27) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|LV8PR02MB10213:EE_
X-MS-Office365-Filtering-Correlation-Id: 8290914b-e30e-433f-e108-08dc33169a8a
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	1qpvZAb//M6gWmKoj8S+fZv73EJoBpC0cnXihqN+WFgJWUruqjlogGoPswAMVX5TmY+RIfTsydZ8lNMu88qEbiG699JLXuJ2FvhvpvAKkoZPSjiNJb5TCJkvIkgSHU1qHJdxnt3BsMK1+8srmowE7dzDiZWhKOJYX53ojz/ZMghoYbOj/9oUfdrzn+cYzvAwSi2lt95zOwtgqXxMCmTrwUL0+G7XOlhq3FVxoeaxOW+son7qCNadknz8Md5cYLoYLkl2X8ZCrhCS5Rx66a8N294TpEpNZPikAzyWjKPFQTG1caqI05QLSn8jioyV5s+75phA5qA09IWH01KCXT51aMdDES6AvhGpzZNRCEpcDO1CqCZ8HHiJ6BjYbubghMPV6jNgQ9oq7wYrIJDr9FfqI3Y3BSSNHYZbJVSQlQxO3PmjlYRzUSJD4qcMfW50iw0G6QcbuKQcU3gD0mP0JEtWw+BAAORAnqRGp+SneqUIhYw2l5Ucr615V3oRiK28ma/Mp5+9UXexY5+bXfywVcOU5X5hOczi++lhx1fJxELuoT+uqxje5t/sUHQsTLp1z8grypKum+GXnuBIZPt6MGXnmIqMc951fMKv99trag8jBDWWoGBKLqrx1T1EAIqOi3qX
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38350700005)(921011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?mhSBRFTKhPWoltton6S9rxvSS5rsOS+HTonRYu+XCWnFiGqqqXSt2/r7Dvxj?=
 =?us-ascii?Q?8zPx8dEzltZTULhICRfc7IzlrDdXF1wb2sT1TEOATkzU3UQpclPztfXFihgg?=
 =?us-ascii?Q?jwmNlCpDJYKWpL5knI7ZXZiScEkGCg3HIurmM9a00dWhjNRHHtU89x8OG7wu?=
 =?us-ascii?Q?wNOp0Vr8dgE1TEf36F5UjQBZ2AchkFjHGxwxPGCL+GQ5xZAHsw23fnvWqat3?=
 =?us-ascii?Q?Ce+yrLoFgxkBnlKYLoMiNPq9OEd4j2b+TwpuBZuDVrKU3ZFriwP6V8mvwXV+?=
 =?us-ascii?Q?h4uBlmyhtGZjnY0DJGdRqm1KKyaehDxNHfEQEsXuCQuxXreMGW99NZ3NTudc?=
 =?us-ascii?Q?F1zV3zfPbytb/WtTgEtWSidf+EaaHB2zeHCEyvW5+XMFJN+Sg6b4RtLkhihn?=
 =?us-ascii?Q?vCxDVX2B319Te7WiJSxaEzXh3EUtnWyShsK5zpkFQ8gxdG4GrCYfFSIXpe5a?=
 =?us-ascii?Q?E0LoiKYuW9XqdK9ChRTra3zZ+OqJgewoxdlfRuwmRDryBt7BDDhpoeMjSsDk?=
 =?us-ascii?Q?u5AewfLfeGKUN4LtScsu3gRpIaNAGOpBnf0hzYDHXlbkmrRCapFpg6ZLO/KW?=
 =?us-ascii?Q?q46UH3tFQ/Dn6OCeOLeX3a28wcVdT7tG5juoj+QXQv0wO60wmJvCCA1kOaMx?=
 =?us-ascii?Q?JYQvj8lk8nkv6osb3gG0nAPiQb6BxPqhfS6EP7b7kimUQ4Cv9Bc5jTbUYxia?=
 =?us-ascii?Q?viocZuZJH+M3FHbFYA4VX5nX7LPfHtMtWxiwVIJNn1HgUMpAztxvQFA8qmHy?=
 =?us-ascii?Q?F82oxF6//l1No0L2Xy0tBVn7JW5HOmmQEMpBuBE/UZOuLb3l7bmQmLcTj9k7?=
 =?us-ascii?Q?Xh3zPiB2Hhfw8JkSJ9HFi5dISqaQEwliTX9yMYSOlUV/XCc/uO2ilA6RB7fj?=
 =?us-ascii?Q?TTbECcHkSnJCZY0+UhdDdBKkIuStMoLf4+YB9YWI3v0NtQE0r+3nrEMisWPd?=
 =?us-ascii?Q?JliM/UNc38mPrw4qhT9wpgQHoK1gVgpV3+ShwcWoc/Cdfiixph//JUuEq/aJ?=
 =?us-ascii?Q?u/etmy30CSBzL4G/slpNQcenRgpbJc27Cs8218/qXzmqVFvIMnA/BiKSskUv?=
 =?us-ascii?Q?jLwfHxrD/ogS4KdrEmYscYfK368dyyDABD01o2yBpr09aEwOmtbmY3hs/IGG?=
 =?us-ascii?Q?MlHS6Wx0O9seB1gM0/zgY63Lv9Qb3lUFdDrCvgnw5lu2N6psPyMcoy8NBSW8?=
 =?us-ascii?Q?RuTVAPmDER/dCEELMGjM/QwWkYt2Vjl2gjkjOpC3bYiBi4aRGSr96g/9HxEf?=
 =?us-ascii?Q?hm8/4df+RXMBd6hXA8DwmTbg85QzmnTqkcI5EhM5ePIAy55lQ0V05jEs865O?=
 =?us-ascii?Q?PrHUDCfS73BqThPBgs89meDewpFE0e+YKb9/EEy+YEHM9p18wrvvoEDRMR3a?=
 =?us-ascii?Q?yiN7UXEz7A8c+WHFQlO8R4m1zEPBDMtEQq7oL6H21Qf9vy+ySRv7OO6vmu3R?=
 =?us-ascii?Q?oJG4c5488TodDN6V3IqcxDEPGPfHIilq65+YqkmpDey3+NIcAjHB7cMLPlWQ?=
 =?us-ascii?Q?W65LsnIARxNNGQPNa6s4gc/KaP1zHLGPclhMgP+st0nhOea1MT9BOOIYvk9c?=
 =?us-ascii?Q?N5l+jd0B6JWVbCT6kHMiwpKx6k2D9JWTZw3GS6ztN2v2T/Qr64h8MX2fX+kj?=
 =?us-ascii?Q?Qg=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8290914b-e30e-433f-e108-08dc33169a8a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 19:52:15.6228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e+LLAhX1SydoGJPZyZ4sicjzu/GXT3SwU5kVSqcmmqAFVklO3YqJ21oTjDYcrpnz5pZqzNVW9q3P03xMDS/uU8rl60/06WiJ2b3djOAmbiA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR02MB10213
X-Proofpoint-GUID: hWsDjjBDBdAeBrgTVfm9G94_VRaJ7iye
X-Proofpoint-ORIG-GUID: hWsDjjBDBdAeBrgTVfm9G94_VRaJ7iye
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-21_07,2024-02-21_02,2023-05-22_02
X-Proofpoint-Spam-Reason: safe

This patchset introduces a new mechanism (dirty-quota-based
throttling) to throttle the rate at which memory pages can be dirtied.
This is done by setting a limit on the number of bytes  that each vCPU
is allowed to dirty at a time, until it is allocated additional quota.

This new throttling mechanism is exposed to userspace through a new
KVM capability, KVM_CAP_DIRTY_QUOTA. If this capability is enabled by
userspace, each vCPU will exit to userspace (with exit reason
KVM_EXIT_DIRTY_QUOTA_EXHAUSTED) as soon as its dirty quota is
exhausted (in other words, a given vCPU will exit to userspace as soon
as it has dirtied as many bytes as the limit set for it). When the
vCPU exits to userspace, userspace may increase the dirty quota of the
vCPU (after optionally sleeping for an appropriate period of time) so
that it can continue dirtying more memory.

Dirty-quota-based throttling is a very effective choice for live
migration, for the following reasons:

1. With dirty-quota-based throttling, we can precisely set the amount
of memory we can afford to dirty for the migration to converge (and
within reasonable time). This behaviour is much more effective than
the current state-of-the-art auto-converge mechanism that implements
time-based throttling (making vCPUs sleep for some time to throttle
dirtying), since some workloads can dirty a huge amount of memory even
if its vCPUs are given a very small interval to run, thus causing
migrations to take longer and possibly failing to converge.

2. While the current auto-converge mechanism makes the whole VM sleep
to throttle memory dirtying, we can selectively throttle vCPUs with
dirty-quota-based throttling (i.e. only causing vCPUs that are
dirtying more than a threshold to sleep). Furthermore, if we choose
very small intervals to compute and enforce dirty quota, we can
achieve micro-stunning (i.e. stunning the vCPUs precisely when they
are dirtying the memory). Both of these behaviors help the
dirty-quota-based scheme to throttle only those vCPUs that are
dirtying memory, and only when they are dirtying the memory. Hence,
while the current auto-converge scheme is prone to throttling reads
and writes equally, dirty-quota-based throttling has minimal impact on
read performance.

3. Dirty-quota-based throttling can adapt quickly to changes in
network bandwidth if it is enforced in very small intervals.  In other
words, we can consider the current available network bandwidth when
computing an appropriate dirty quota for the next interval.

The benefits of dirty-quota-based throttling are not limited to live
migration.  The dirty-quota mechanism can also be leveraged to
support other use cases that would benefit from effective throttling
of memory writes.  The update_dirty_quota hook in the implementation
can be used outside the context of live migration, but note that such
alternative uses must also write-protect the memory.

We have evaluated dirty-quota-based throttling using two key metrics:
A. Live migration performance (time to migrate)
B. Guest performance during live migration

We have used a synthetic workload that dirties memory sequentially in
a loop. It is characterised by three variables m, n and l. A given
instance of this workload (m=x,n=y,l=z) is a workload dirtying x GB of
memory with y threads at a rate of z GBps. In the following table, b
is network bandwidth configured for the live migration, t_curr is the
total time to migrate with the current throttling logic and t_dq is
the total time to migrate with dirty-quota-based throttling.

    A. Live migration performance

+--------+----+----------+----------+---------------+----------+----------+
| m (GB) |  n | l (GBps) | b (MBps) |    t_curr (s) | t_dq (s) | Diff (%) |
+--------+----+----------+----------+---------------+----------+----------+
|      8 |  2 |     8.00 |      640 |         60.38 |    15.22 |     74.8 |
|     16 |  4 |     1.26 |      640 |         75.99 |    32.22 |     57.6 |
|     32 |  6 |     0.10 |      640 |         49.81 |    49.80 |      0.0 |
|     48 |  8 |     2.20 |      640 |        287.78 |   115.65 |     59.8 |
|     32 |  6 |    32.00 |      640 |        364.30 |    84.26 |     76.9 |
|      8 |  2 |     8.00 |      128 |        452.91 |    94.99 |     79.0 |
|    512 | 32 |     0.10 |      640 |        868.94 |   841.92 |      3.1 |
|     16 |  4 |     1.26 |       64 |       1538.94 |   426.21 |     72.3 |
|     32 |  6 |     1.80 |     1024 |       1406.80 |   452.82 |     67.8 |
|    512 | 32 |     7.20 |      640 |       4561.30 |   906.60 |     80.1 |
|    128 | 16 |     3.50 |      128 |       7009.98 |  1689.61 |     75.9 |
|     16 |  4 |    16.00 |       64 | "Unconverged" |   461.47 |      N/A |
|     32 |  6 |    32.00 |      128 | "Unconverged" |   454.27 |      N/A |
|    512 | 32 |   512.00 |      640 | "Unconverged" |   917.37 |      N/A |
|    128 | 16 |   128.00 |      128 | "Unconverged" |  1946.00 |      N/A |
+--------+----+----------+----------+---------------+----------+----------+

    B. Guest performance:

+=====================+===================+===================+==========+
|        Case         | Guest Runtime (%) | Guest Runtime (%) | Diff (%) |
+=====================+===================+===================+==========+
|                     | (Current)         | (Dirty Quota)     |          |
+---------------------+-------------------+-------------------+----------+
| Write-intensive     | 26.4              | 35.3              |     33.7 |
+---------------------+-------------------+-------------------+----------+
| Read-write-balanced | 40.6              | 70.8              |     74.4 |
+---------------------+-------------------+-------------------+----------+
| Read-intensive      | 63.1              | 81.8              |     29.6 |
+---------------------+-------------------+-------------------+----------+

Guest Runtime (in percentage) in the above table is the percentage of
time a guest vCPU is actually running, averaged across all vCPUs of
the guest. For B, we have run variants of the afore-mentioned
synthetic workload dirtying memory sequentially in a loop on some
threads and just reading memory sequentially on the other threads. We
have also conducted similar experiments with more realistic benchmarks
/ workloads e.g. redis, and obtained similar results.

Dirty-quota-based throttling was presented in KVM Forum 2021. Please
find the details here:
https://kvmforum2021.sched.com/event/ke4A/dirty-quota-based-vm-live-migration-auto-converge-manish-mishra-shivam-kumar-nutanix-india

The current v10 patchset includes the following changes over v9:

1. Use vma_pagesize as the dirty granularity for updating dirty quota
on arm64.
2. Do not update dirty quota for instances where the hypervisor is
writing into guest memory. Accounting for these instances in vCPUs'
dirty quota is unfair to the vCPUs. Also, some of these instances,
such as record_steal_time, frequently try to redundantly mark the same
set of pages dirty again and again. To avoid these distortions, we had
previously relied on checking the dirty bitmap to avoid redundantly
updating quotas. Since we have now decoupled dirty-quota-based
throttling from the live-migration dirty-tracking path, we have
resolved this issue by simply avoiding the mis-accounting caused by
these hypervisor-induced writes to guest memory.  Through extensive
experiments, we have verified that this new approach is approximately
as effective as the prior approach that relied on checking the dirty
bitmap.

v1:
https://lore.kernel.org/kvm/20211114145721.209219-1-shivam.kumar1@xxxxxxxxxxx/
v2: https://lore.kernel.org/kvm/Ydx2EW6U3fpJoJF0@xxxxxxxxxx/T/
v3: https://lore.kernel.org/kvm/YkT1kzWidaRFdQQh@xxxxxxxxxx/T/
v4:
https://lore.kernel.org/all/20220521202937.184189-1-shivam.kumar1@xxxxxxxxxxx/
v5: https://lore.kernel.org/all/202209130532.2BJwW65L-lkp@xxxxxxxxx/T/
v6:
https://lore.kernel.org/all/20220915101049.187325-1-shivam.kumar1@xxxxxxxxxxx/
v7:
https://lore.kernel.org/all/a64d9818-c68d-1e33-5783-414e9a9bdbd1@xxxxxxxxxxx/t/
v8:
https://lore.kernel.org/all/20230225204758.17726-1-shivam.kumar1@nutanix.com/
v9:
https://lore.kernel.org/kvm/20230504144328.139462-1-shivam.kumar1@nutanix.com/

Thanks,
Shivam

Shivam Kumar (3):
  KVM: Implement dirty quota-based throttling of vcpus
  KVM: x86: Dirty quota-based throttling of vcpus
  KVM: arm64: Dirty quota-based throttling of vcpus

 Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
 arch/arm64/kvm/Kconfig         |  1 +
 arch/arm64/kvm/arm.c           |  5 +++++
 arch/arm64/kvm/mmu.c           |  1 +
 arch/x86/kvm/Kconfig           |  1 +
 arch/x86/kvm/mmu/mmu.c         |  6 +++++-
 arch/x86/kvm/mmu/spte.c        |  1 +
 arch/x86/kvm/vmx/vmx.c         |  3 +++
 arch/x86/kvm/x86.c             |  6 +++++-
 include/linux/kvm_host.h       |  9 +++++++++
 include/uapi/linux/kvm.h       |  8 ++++++++
 tools/include/uapi/linux/kvm.h |  1 +
 virt/kvm/Kconfig               |  3 +++
 virt/kvm/kvm_main.c            | 27 +++++++++++++++++++++++++++
 14 files changed, 87 insertions(+), 2 deletions(-)

-- 
2.22.3


