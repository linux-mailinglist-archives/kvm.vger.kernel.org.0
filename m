Return-Path: <kvm+bounces-40871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE17A5EB19
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:23:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B465D189D4C8
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 05:23:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F062F8635C;
	Thu, 13 Mar 2025 05:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MnOkguJX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xN1FYV65"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7841F91C5
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741843369; cv=fail; b=HMNf8gkoultE4sD4NK4bqMh9KBNAcUqTu5v6AfpVCiR7+AOdvDSsxjXgLntOZdSlGuhge7ydYOl2DokDn6M0Hm0kJviRSY63OGjgiGipfx9DxNBMwgpHWW9rp+WsB9X8H+RzrROhvlZ07vWP8SNiZwwVKSBbAoMKis3APCd4co0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741843369; c=relaxed/simple;
	bh=RejOUFbxSBrWATdd6Cx43POhDS4hPkh+CQIFcBWGPZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rTS2DxoZWwHC517v9S0GsbxXNLD3e6KdK1RcP7/cUg8XqYSNkiYx0l/hZxFWHux66mLA7p4NW0Az3f+xIV+vCV5iKiw2nhA2f7+aVCwz9Mz70p6Vbt/1zf5tSTshGnIqyxwYZXAciNenRyhTh+Mel/5dEMsVKUDheRfWp4Z6F+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MnOkguJX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xN1FYV65; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3uMfN013592;
	Thu, 13 Mar 2025 05:22:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=krIQnO/UD+DQIJKuGHEwUvgzVTuMUH1FJ+dtD5lIIU8=; b=
	MnOkguJXxtL4o07+QPp41otf54GJcI4HgFUsQlub4gPCjhkbUfT2BOCmGHbj5sQ0
	/MFJM/kLQjjuF7na2o+D+LzW6pjHqmNkto0oxmVF3MZob0UlFq2VXbAjHTVG6Nt8
	+qYisKSWemh1HAxFlZoq1/5sBJ51fqlStkRL74jSs8657DZ6qBPtMILzHsEZHv4Y
	waZJpB7Yo9kNKtnSDiccV/c8p+83xAJ/YsCrO/ADQ0tfCMzyfcbiupKHg97ne2rv
	70/4XXmWlQ3ZJ+JuXtrthWPlleWERsnO3gtBUlPNA4IbYe5jgFF8WBD75uMHuKaU
	KMyjcTpNQOW+KtAK0d36yA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4dudq4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3boGi002306;
	Thu, 13 Mar 2025 05:22:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45atn87qp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DcdRtfxxr31MICZY3CeO2TDt06I9+LCOSOBM3TjqMIjhEvvakUhUeNcVk+PVrcwYGZ5xbupGdfE3ni/GNyuZECUYHKX9S+RB/Tun+B8gfzJbgVXrhDdIj4koCv2soHWcMqOVV+QtOaSNjnyFzJInEaotWgSqx5UEyzLk5JJVlahdIJ8is87mPtQ9SJ8/q+bI2KSO000xuyRfb7taOxcugpdTRchdEDDCdXBB6MgHznJ7WYJQRgYMKo884eaN+Cz6dSxCVfyk0sAciIu+FqR6wHttsDVydN4Admmqngs3fLb1+GuHufOIOX0QLMRpr83ekahsKF3ekapHECcJSXoc0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=krIQnO/UD+DQIJKuGHEwUvgzVTuMUH1FJ+dtD5lIIU8=;
 b=r8EVa/F5QZVi5mru0Yj3cU6znS9+L5ya7bg1HUksOsTvnesCusKJzh3JUj+7vllLHB5QYWuMH6jAINIxtZQ7x+HqoIgEHm1azntOaIiEe+SD3AofvhHFqQU4gqXPVmXKvG6/u1hOGxdao5VXMiepJyafWbxCwrzwEF1vOe+5aCkKUFegdYbCsDrnLWrKmzEglw+CeVSAnMsiEgnRcEGYstn8WmLC2oyq5Jhc9bn5yMG4YA0PanslL8WblS1dqDOZgrc9/utOsp3mBIhXBIXsIb7N/bdCm8QDMo/YvPlXloimaLrjByl84PJmeno/H9HX3+RG72RSZI/DhZNUFcOXIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krIQnO/UD+DQIJKuGHEwUvgzVTuMUH1FJ+dtD5lIIU8=;
 b=xN1FYV658P5sC8w7eda7GrnFdM/JWYGrGjnnA8dwnMZhd6qHy+RKPJpnGYeZVfvvXy8FIvywDM/CZAlV6YdZj75BDdyEFaq0OwNhWSX3mcvFOl7J6vlOkOcbBxlrl2ZwKdxVoK/gyvSxKnYsYGxlWmbFunlK9jkhdWjksb53fEE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6724.namprd10.prod.outlook.com (2603:10b6:208:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Thu, 13 Mar
 2025 05:22:26 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 05:22:26 +0000
From: Mike Christie <michael.christie@oracle.com>
To: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 01/11] nvmet: Remove duplicate uuid_copy
Date: Thu, 13 Mar 2025 00:18:02 -0500
Message-ID: <20250313052222.178524-2-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313052222.178524-1-michael.christie@oracle.com>
References: <20250313052222.178524-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0403.namprd03.prod.outlook.com
 (2603:10b6:610:11b::13) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: a4f6bb1e-ec58-4232-01f8-08dd61ef0ae9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fE+N6tyN5qUZCY1PRgmD+H4JTwRZZDE/vXoh+OdH9OCUzDb/SEQyG8w9zHY/?=
 =?us-ascii?Q?oK0v15XlyJKAe0C7SX/Y0aAYnCkiU+YpcyPiD8GJR5/Z7Jt+UWU+SpO6zQmM?=
 =?us-ascii?Q?8qtebeezERoqnI5vuNJcoFkhALW1wwg9h7+RkdJ5952OWox2y5Edx5PTQxCE?=
 =?us-ascii?Q?VUzIZMkXzoJaUCpBuktSBb6f8uvulioDn9bhTqHLMoiJ5iU3J7hfipVZXAwp?=
 =?us-ascii?Q?XztIkIcflk5+bFGZag3KEmzRMverDECXgVGgNWqTGqxlWipV1RUctfRSGx5F?=
 =?us-ascii?Q?obE6hD+aG5hc4RLR+L35a63S+OzfT9UqAN9QvWD/twpZ9SH41xvmVizotrcK?=
 =?us-ascii?Q?wWrY/NOZo9zn4T2KKctDHx39WNTKp7vtue0JjDql4LeajrPM+6yGmk6tu+Lt?=
 =?us-ascii?Q?B+/eQCNs8H1/pC4G4i9Z/dWiNv2IsbL8s2BPN7TBZ2zBCJkoe99v85WvWcrQ?=
 =?us-ascii?Q?DPTfb9klciygciKP498Ss1gRNRZnhi7wLdQPb5cAqZJzE3RpRNxFHQrgjqfs?=
 =?us-ascii?Q?EaWJ4fDYeSgPdp3zabrgOCmkADC+1aPUOUC9MPBPnFCrbKHI2NHs+DgM+Z4k?=
 =?us-ascii?Q?SMJxFGKB6RRmbhEcfpVTcDya006Y3ZkRCkYvOGcf0lrA8JAa8RuSzFZVKCET?=
 =?us-ascii?Q?onabOroXf/rgvB3nETJ8pllvvx3F7nOoQyaXKqoglEdSqmyUDXuAb2NUIP+n?=
 =?us-ascii?Q?k7GmDIh6+Yq8IR1i1oHjFa4QrFyKUhquxG14crsYV9FpiiFVpja4grA5bssr?=
 =?us-ascii?Q?AvIx9KectEVpzPsLl/+oN1Do8b05FVlF1RHVlKlo5ir9z4A63n9+rhmpd7t4?=
 =?us-ascii?Q?iBkcMwEK9RPSAPrwhPjRK2F8G3cklpdyHgt/AVVtb+CaUwJfYWkmCYawTEQS?=
 =?us-ascii?Q?B7hBIz+7MxGb18HdpbQi0xc6lkZhRR2iXC08dGxJsL4J2a0aszYMJfmtUU+3?=
 =?us-ascii?Q?HtVBdRIFtcz9LQ+uFyz9SX6moijrxDRcZsPLAwR+0d4XKvUkC6Bl8mEk2jpT?=
 =?us-ascii?Q?xe1gmVnbVIOMKE8/FaH5GIXmIh4n8ZFG/VbY2MmmzKKRpayigxbALTthJC9x?=
 =?us-ascii?Q?svjJ0GbFS9pJfsi6OFBD4P36kt/S9trUDj7rtC1OOQTZQnO0h/zV4Gn+2NKD?=
 =?us-ascii?Q?Q4DtuY91lrWGeM5XIPBnYdA6fntKMlOwdyrLAEHaT/TV1rGGgjNJ2YTUH9Um?=
 =?us-ascii?Q?chu4Q0eGgar9yQKgOFfz/pDpwDG03yCsg2Eqkop470nfSUOLbHyrrOtDeG6j?=
 =?us-ascii?Q?lBAgtyLCGFqfm9OI+hEQTpDSqF498pA2WZe1J5SM687uG6g1dY4HYQw8xI09?=
 =?us-ascii?Q?NV447i2Rp/SQf2uwv7/GOMlOoSFsFC6kABuCOyThU6NcRoVRePdEJ8NSHeo+?=
 =?us-ascii?Q?kpzn+UAxZiLuuC1lYv/HSowFgne8/6SC7c+w5z8cjsd44PDTrZia7vvtW7oT?=
 =?us-ascii?Q?ZD6o5q+he8k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vxW5Un+bEQrTcLsIt3O5VE/sojGvqqcdrRtnwHzavuxRo1LkDWNPddbh3GIQ?=
 =?us-ascii?Q?9NiHKP2Ry4mTBf2Fx1bRch7qTJmAP/v+vL7MViWbEYFaIIshuFiaOND13bLF?=
 =?us-ascii?Q?bONW5T0LwB1IF5DiC/pp7NEImH9L80hI9vv0SYqzMtsWNETmvFSGXuCccjMC?=
 =?us-ascii?Q?tui41yHibqHbTcvNOM4O5oJoybSI8OFWxHTFMy17xqvM3IwkP6kVlO1/E7sW?=
 =?us-ascii?Q?VOP0cCjLUeEvJ3qiQPANTChKp/QSsIQ+DV6iRt2rF1MxtgjgTF6vbamnQkb3?=
 =?us-ascii?Q?OaxGwLnw+iJQjCQXtcFXlfE7RgcNmwdQ1q53m4p0U9jEzvRmmhDsr7Kk9Fkg?=
 =?us-ascii?Q?k5g2Ac8EYryQWZn8cwsR1zKSXQ6WFJOIwGPt02oWGEf0ECjzGQdRXcJtc8oy?=
 =?us-ascii?Q?sSHjPhIIYiWnjyh3ITgYuQelBnPINIbfz3ZA87d27A4EaXjoNu2MYy8SOAbk?=
 =?us-ascii?Q?tuOy4CrM9ni5btiIZOPGlCYqQRZbdORxjEj73hl3PLCDYHqi54J29gprKwJN?=
 =?us-ascii?Q?6Jo4LH9WZT/ntxmybTanMP9oJRGs48v3OMECCDg8w8sU5+mpilfLrHP9EepZ?=
 =?us-ascii?Q?XccszwfHB55z7uW/FeNNkNHSv8DCg1LXuxliMupRQnsL49FXqMABGcswEYsD?=
 =?us-ascii?Q?l172510tWQlUaU7JNHvwiYhHHPjM9PUDxW7M0teWdFwbdQocewWtE9NUVGV3?=
 =?us-ascii?Q?Z0ZygWrTeBHb1dFyLO0Ye2zR/ql7ky3sZCc7i44tt9a9s1wXhKgWBXHfUvF9?=
 =?us-ascii?Q?uLCHa4QfdC59ZxP7BAkstrb/iPUbPxqh89gkaB89lMj6aJq0yxCSg7OP4zFt?=
 =?us-ascii?Q?QHqPy+4cLp2UeT9ECBSipZIDtocugSKi6k0/GegOKyHKr9jFwnEC8awOme8o?=
 =?us-ascii?Q?1OnCwcXnn23ARy9ux6xhEHOXOG5r4aYiWDhEoibZ+15ghJTB6LZz1Hdnbhmq?=
 =?us-ascii?Q?nIu8RGmIHVuY4e+SOnTycr+anpzkLAWoG7mFdUDdEs+oKIOdI3Op4VfthhFJ?=
 =?us-ascii?Q?cZOnxWhUGauIlRilKBhfktd/jQKYz2MV24nnjIPt7FManqSEvK5cy+oEx1ex?=
 =?us-ascii?Q?PyLy4X45fPEsg3OJHfo6Q0KjK1r3Ccavg6VXfjCBvS4q+tIIKupZWK26ztcm?=
 =?us-ascii?Q?ytnGWtW78HUzhP6Op2KQIexbjvbzOm+4lH8kzvcwfcE6hrOaSbHELDcLN4zu?=
 =?us-ascii?Q?Gxg5vqE0Rt9o5oD1y0uGGfbCYTrdqAd/gVE7S6RqXC1TQkHqdMwNYFyO+1J5?=
 =?us-ascii?Q?IKOqt9NG2tHZd92fat+KB+yRhBHdlmen/thjlvvtrv1RWiNrkfMPJXirpNBS?=
 =?us-ascii?Q?kvb3pghTY27eGs+obAquqHW6TgmKWsLmg2PVfGZebyIGbRLNjTD4o8tRBxcZ?=
 =?us-ascii?Q?1oTWxELeC1MwlKMIUL6rXBC1eaDKrBxBhOnNuTdzaMBYEkEppSAcO8mb5fnZ?=
 =?us-ascii?Q?E8uDLF1wdAfXgBf0Ctt93EPxy+w7iNdsvMTU2zfTyPJ6l4pglbtRhD+uq0dx?=
 =?us-ascii?Q?LLRRAXc+4SL4biF1N1cBd18hlz1iTevHY/XAiQTnOsJ2BgukHC+NaLmKFt1i?=
 =?us-ascii?Q?laDZOVBmQxzDwxzekE9r9Kucsn94KGw8KM6ObVeZ2WJBV6hVUSO3UMoyVRzU?=
 =?us-ascii?Q?yQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ODFXaVUCTsN8/EetAh57jQCEZkdwgfx7NPQuGvcJOhO4nv7455jeUQc//2Bcs+PGUglYElvD1/uKcD67QwSEVQdgmbT9lqcaPePSnsfkewxyZiFbmAW3tVPfA2D8O+1JDZupUWfzHLkcff291jLPk5nTEG7gKuCONzcpCKvcUA47QV9R2JIgF0P2l+wHmV5VIHNnQ2OJD+ZEpzWtjzYd7zMfm57tdHBsDRWxoZ2oDquPiEfdv372M8l5ZAHbl+9b4O1wkmLJ/7zT5jyxMBDwoePYzFj9JIliw2KI4ho0EGm+P25UkZPxi59J4D7F/5E3Q8LtROqp9RFf1dWpaP5qAwhE4v3/gnAy1H5TCwWM7i4MVyyIEHT0UIks5izL3DEQdlz8fjaxGLN0Jij2/yPcy+EnQtokDUYZvPvZuc6+WMG5asy3TuXGtC/ENHPYTueGrfc3ORHwxYz5t3Vnz76eQruhCpSPV//O8x+GucNZBUyh3ea2Aj/oXPzaIkZN7YVaF0IkXkU4KPX0u3tlI+mo3GX6R8hPm9ypVk32UJxumabOyHtzCB3j6dAfc50k70+u8vo/fVYWpiktsbiiM7uZhoO3Y4c2hwA5QfhdwPOvGys=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4f6bb1e-ec58-4232-01f8-08dd61ef0ae9
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 05:22:26.5475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iOy3n2bt6cy1EImizmBYboeXihmZ4v5C30zZjIC+RL9A840ltaJZuD+Gk5KG7INOrRFqQ7o/oRpmCpnuMtIpT+6aK9fJKIG8oLvivxV+ppA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_02,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503130040
X-Proofpoint-GUID: VOGBr_UJDSFoLoFAypH9ulu0c0UOdrMM
X-Proofpoint-ORIG-GUID: VOGBr_UJDSFoLoFAypH9ulu0c0UOdrMM

We do uuid_copy twice in nvmet_alloc_ctrl so this patch deletes one
of the calls.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/target/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 2e741696f371..f896d1fd3326 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1618,8 +1618,6 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
 	}
 	ctrl->cntlid = ret;
 
-	uuid_copy(&ctrl->hostid, args->hostid);
-
 	/*
 	 * Discovery controllers may use some arbitrary high value
 	 * in order to cleanup stale discovery sessions
-- 
2.43.0


