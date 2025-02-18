Return-Path: <kvm+bounces-38487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E127A3AAFE
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:34:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 701F27A48E3
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 763AC1D618A;
	Tue, 18 Feb 2025 21:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QWwzzH98";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hu6+Lah7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A7B286297;
	Tue, 18 Feb 2025 21:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739914453; cv=fail; b=swHu6TS9nIMP23m8/CP3Ue8VppOhJwnmn8A0TgIuJ/W97CXnhy6QihgGWzR/Ke43bBFYAlyLl0hKPI7kw0kavHsVvEgKhRe+4Q8BuQmLX9n0aupauUhSoHgprRpCT3T8suo7jBOGJ3bmetBolIGlxMbPliN+aaU3HhwlHAdADMg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739914453; c=relaxed/simple;
	bh=jUFNfQwvNHk0SCckCgAvbQVBVzYkYP1UQXAxIpBdPVA=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=ufhcyrFzwjBDsAMXdb9Cn5sdoUQRd4nHHM91+nWemvQF5M2G+y3/fTuPuHwTLAmq2EwYkom1RYAa1P4ZiX6sXU6UrH1nVzzQQVDnSGLspV5p1UagMPr/CRH01Cfb0Ik6wbmcMApxp0ZearXLZL8bKOllvaiFIr6CQxLWwnHCi3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QWwzzH98; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hu6+Lah7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51ILMdNP023059;
	Tue, 18 Feb 2025 21:33:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2023-11-20; bh=Pw1DCZxtUrlTjvuc
	kscFKQGWALxRSsoneBc4GQuIJmc=; b=QWwzzH980xdApeo8YhT2rB0OFG384ZYS
	u/RezavB1JaIMjeI8wMEZ/8lNzL5omvI3y18mQ0v76KvPZorJ7nygLvp3f4Q9JN9
	eMJJZ/wv7EuvlArqWfCIvnet0R1tgj+Z3iQc4/b+Hv5FcIjefRWJX2YZI1sy9jj7
	V7Gk34KhTmPtmNOt092xvmN6vtXkLoZOI0LGPrDt4LGnDecRz7hlVn2l+bYFwssc
	bF34l/fbZ1V8Re+dJUWTM12SIrKEXmUxkWYsPSK8EPDDIl/LOyXdFNQu1S+8f9/G
	hjx12sQ+83Q2ENHrHESlfWOOkuPklA/tbf3N57h+3Sc9YyZ6yXLHnA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00prafa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:33:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51ILAp1C012061;
	Tue, 18 Feb 2025 21:33:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w0b1mr3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:33:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=umaOMyVD4r59QmPk6+ZuEzmeQiNcSYILGzdfnvuoxqAlaBFOz1TsvLttLhBFtGBJX/d3d7w5tUoav/7HtTZwOmoNkid1U+XzgpBvR7oCG5OPvv1PPZIk9vj7ByiswDCqBWdHTO/9CbuGCsaiFJfPicxd+pbtcZlrjM/alv6zfSt9DuBSXEkvRqPKC742Yum5SPW1rgpV3wjhehcXf1SIEAX/rR13Z6/KGOwKdBnvHeKHLfgoGmIrdcOVt1cDUYTWJfK+BNxZb7WVgAQDUZLEUOPf/rWg2gFfydaZWM/zuWZn7Ejmu1NjxEbKgsj/VVGCf1z6HBY74RddmfnzeL18dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pw1DCZxtUrlTjvuckscFKQGWALxRSsoneBc4GQuIJmc=;
 b=yeLt3kAKg89D0Qhtmf3lnJ20a4ffIb69OnYlCoOOdyiwAPL+4An/6CPQuXpt0xsHGswzk4FQ+UL0Nn0NrPCGRqZJkIp0HNMMQ0VBn//2HtV+jzEGCPX4G3jzEyjTZSFBZQDxSZzOzDTeF1P0D0brMZhkb8cC9BuBBJ1fMJVaCGsEKXB+wDDLfRKgiDw47ZfTRCRq09DLRjowIU7GiscuXLb9S4aDFOWPHdHjG7kQECp70U697T/lrmpw6W5ixsRpinKPKTrHuJa21QZxLHWJdtiTH5r0Y+IV2EnWW5IAt5RKAGCQcVsoTVyBRFKi5TNkQ7QNkf6U4mFEfOIS5FdzCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pw1DCZxtUrlTjvuckscFKQGWALxRSsoneBc4GQuIJmc=;
 b=hu6+Lah7rhidAeePG8KkMZtjnw1zApxUCCYUSnDi39cTfvlGxExY2D6ZyzADmB3poZBOUH3vDITpgAi9JW1cB1iSjD52QLqyhAX7HQ9EFvT7vx3BnkVnCqYw7usLKiRubaEF7uLhx6fqDGsiyUMkCoxCm/L9yT1cFji5anqDyuY=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA0PR10MB7275.namprd10.prod.outlook.com (2603:10b6:208:3de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Tue, 18 Feb
 2025 21:33:38 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%2]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 21:33:38 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, x86@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        maz@kernel.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        zhenglifeng1@huawei.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: [PATCH v10 00/11] arm64: support poll_idle()
Date: Tue, 18 Feb 2025 13:33:26 -0800
Message-Id: <20250218213337.377987-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0007.namprd16.prod.outlook.com (2603:10b6:907::20)
 To CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA0PR10MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: 039032fe-1672-48c4-d3d0-08dd5063e811
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lLzxt55yrRnzuxhx3O4J5dPBulGHDhIb4/aefoa7Y/vdJ0jUOPM2MG9ZFbbP?=
 =?us-ascii?Q?jCf2kNdT89n2p/y+gihXPZnePptuGd2+Wpdk2TNlQUyx68JNNWBvR092g+po?=
 =?us-ascii?Q?8g/knNAP9JL9HIBj7C9CmzO3s7Amq6rlMQH/oeo3ecJ0FAotgAjOq5IX4dvq?=
 =?us-ascii?Q?WOt0Zt/nMpr87oDA3tAyaU7vJmmybkQz032P7fQklQ5MbeOVy4jX3giyk4Vr?=
 =?us-ascii?Q?TfMJNkQGSKYlrkruunCldUd8C/dWNFz1qqI/WqSzOOovkMfVLjLOSBzNcVe2?=
 =?us-ascii?Q?OVrm9UbX1cX/uEm1oQ2phIdqr8Dlemnu6epwVK8i/oWE5UbFbscKv/EQoFNC?=
 =?us-ascii?Q?up40XdYiVKpe5DRiHfzVkUha7SX7lUQ3h/iehv2q3wJpdBK4TPKK6R2ZGfbc?=
 =?us-ascii?Q?ujFgEiaT9XBgJr/K+iEgjUS+IzvubIQ3615gnmF0KH749kNK4XJiY9U5+hu/?=
 =?us-ascii?Q?uMDOkxUJPIwJFiFyBLYVOJ119qnmSSJkA2F6/jgItbYU76xrLh9ssV6mi5Ih?=
 =?us-ascii?Q?uTlIJ4qTpSFjjQm9TyS5cQe2yhiwu6ULVAw397nMluGcYQLj0BAmfw+l6O/O?=
 =?us-ascii?Q?8tViv9RoQ71Zg3+AjZQ2ZCyOiK8uwwLKpDIIiWGOrVl2YFokrbhb4SB4F9E5?=
 =?us-ascii?Q?xuJ+NJByfhK6sAgTMk6CrA5wXH7NfYFtm120Bi6UQ3bNW99LmanAdugiAhoR?=
 =?us-ascii?Q?B5yPdJ9qBfhU2y5SCairUlREo1fcyfXGfmombDsYrcnfUb3B9zr5Sr1kRnIQ?=
 =?us-ascii?Q?SSNloIUJXUdJOwVkRpFvg8lZBzl+H3849rDPNptps+pvIVkkkmG9Lnn6h2jz?=
 =?us-ascii?Q?hKiEd3Do0I4IqdMJi2yJDPfuiHlskIm8AH5Oe6k5weSebyfaKUW11c5yZSe2?=
 =?us-ascii?Q?9I7qE8pw9XNCh4XtsMrQG9Y/72PTVZUNhYeX5kI5Hmbl4b9sU8XN6o/+Lmdx?=
 =?us-ascii?Q?K98jEPyb5Fzh8azMqVv4QPB8qFe9EbQBBkIVr16qE+2g58BOtePtjEo6f3mt?=
 =?us-ascii?Q?cvPNY4zweMZqKRqbcHk+JFovrtWCnxZvRpDhes6fZCqA/JPsd8JBCk+jSM4H?=
 =?us-ascii?Q?auxJ2JIYEyKWg+E7XFpeD/8dTGbjtffnDGa604a/01NFKbE2+JiwONMgLEgJ?=
 =?us-ascii?Q?A1BS28vnjjblcjhdP5mlyoTVhrlFPoMMSU1Pfwp2/SbOWwKsi4Fn5MUlmcOz?=
 =?us-ascii?Q?F5DymP4pkv10XDYNQiSIhu8Fw04Mhqq0Km3u0dLBV2eZ/x2BWAAyD3m+YLc5?=
 =?us-ascii?Q?7026xJFBmEyEQvxvdjACQb1CeiM7BbqH5bQPeYKKEVu99xCk9CBd35cBWw/+?=
 =?us-ascii?Q?W4b22brCbwgJ/pZUs46kkDimZ+uhH8eyR2+si3ICS7nYf7sLZcH3LFFzVtZ8?=
 =?us-ascii?Q?JBb0RP0y4HtvttwfIFgrPpaM14B3yhzV0Uo6X1WhRF0Cql0hPA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?61BlN6qmQUMFiSQEzDfBOEZsWfscKnA7ZDgBmFu+S8ASbWwBZ1Wp0HrmP3hs?=
 =?us-ascii?Q?OLtGeqG3Y7Ochn9f5Lz8ccPx266hU5qY9JTUwwGwVJhQMjqyvB3289gIT15O?=
 =?us-ascii?Q?w/sXcjw49bo2/24MiEGwashSVSDWILo0C3ficvg1Shy7fCqMLWD6rdua4Q9M?=
 =?us-ascii?Q?PEGCFUb25RMA5PoDI68JTOrx3aqY6o7Psw34tTQk6wM4ui3s8FAUBGvYvmM+?=
 =?us-ascii?Q?xtuSvAIOIZ6cmnkqEgyVgWy5m48GyRnBPPCsrFNCbFGBY8QBSofY10783l90?=
 =?us-ascii?Q?cYUBybGgGVSx1NujZfptltIiCR8mxDhYfSoJfrj866qMP7o8qhabi2JOQVpP?=
 =?us-ascii?Q?OntHSLwQtgqlIhVKsU1eGWbzZTiS//a767Vo+FhUE3Hpk+TJTU7kqnF/eGCP?=
 =?us-ascii?Q?mQDZkHqcRv1N8Ta1wkeShD7WvVEncm+j/t0Xp1fZ6/2q9LFkJx/8NQzd2Sp3?=
 =?us-ascii?Q?qbqRxehRIwIht+1yx76qIZgFPA+v+cX5K6RJwPe0vMtCPum/ueKxiIX37qrc?=
 =?us-ascii?Q?qD7cBXYy7xEAYqJQIm/DnAbXS8EJ7LKHftgxpW7yNa+GmzsfVtAtN9rxhc/j?=
 =?us-ascii?Q?rZCBwRlgf61/tgby4Yoltreph1WlfuCuPuP1O0H+id2JFyI5k74ZCAEqmtVr?=
 =?us-ascii?Q?X5Woj36XJt614Tglq+NnTeVEsSTcP+FtQ9tkR476w9nWT/7vfS1ElWr80jPv?=
 =?us-ascii?Q?sCUq3+g1jqc2a3sVSx43pvJFw484lkHEcWDu9QVPeKvhmzYEB9Irsmg58Idx?=
 =?us-ascii?Q?HQURcLFMPxgjYNDLLaVuAENh4NsIunjeU1jIOJZBwRScK8U9BwlY8XiRrkar?=
 =?us-ascii?Q?71FCbAIoSAUqlijp27PZsYV98hKs5cM93osuLrC+SiDjzSRRTpxDAej5ZVfZ?=
 =?us-ascii?Q?lwqmEJjNHXFOayP6PvD9GJhWQWcmM4s/miSfhEG1HeDWsV5tyEhBvNP93rNu?=
 =?us-ascii?Q?z7CDgpixpAzENnuZd2CQPAiHU28M9NFwVg0kIi4iCMvnhuj3jadK5xiTa0N8?=
 =?us-ascii?Q?4WsVvr6lIqzzBHeS8qVrbSmVvk0L8DRmq9dAJds6W0U0ZSUDlbqPJ0RnzL2L?=
 =?us-ascii?Q?5BdL2MRiuv9fsnl1NV7NvMJzuu/s7N93FfDDhglMhs3DrVccCyIJrOrMv64B?=
 =?us-ascii?Q?FZAScyROawZWcxRLMqjPlFjv9KtI8OVTvinmBUeKwntqVVQWbxv+hEVaCd9f?=
 =?us-ascii?Q?TFbCMkE0aKN0gZ51BSbUqlGHT30wtl/eSdg6u1WVRZuRJTpp9POOoCzl0DMf?=
 =?us-ascii?Q?XrvFTr31T7beErFMdoIO/QIb8NWFGUwuiqb0Ut5Zdzqjeyy4OrAOmNI5OI7T?=
 =?us-ascii?Q?yinGfXB9cvulb7/NqD6RDnTOE1tAz+a14R/7BfMYizUPswkurmTBpeDsx0DH?=
 =?us-ascii?Q?cI2U5Q5Z/OJ6UzfiXMzBZX2ilwtKSbH0HB5ozEiKbWyU37ECBqmN2+qTAT6l?=
 =?us-ascii?Q?2ysryvGdsBUdCsQoNrrGZ+SyGyBgAtBc8IWC+O/AS4UkzEcXou5NWswxn2hi?=
 =?us-ascii?Q?WxNb3k3Y8wx16IWWSaZBfGQMHzuGJugN27iJ7CqOC7+1AYC9eeqvRVvygFtx?=
 =?us-ascii?Q?cMTW/ynHgcsiHGX1ykLdvX6uRItxmSw7FRd4xiKXljuE4Y4t7RBkS2IP5QaM?=
 =?us-ascii?Q?JA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IiXyIlTe1oEUOcb4ss9yyozBL7HLfQpAWyuBCo9yFA7ZjPYt0scGHJ13B14+XEazcUndi30RWJ3nspJZPIT0JxAm5ZykWV1j+CpI1kzFRk/iJeM1aOspGktJQfChQtxjRmVxANhWo1ezNOuvV/bvCUE4LRDIColm6N7YZFzXRwzVRlyLFe+DQuTiRHpnrU/d5WtpNYHl70rmms5eUwzr1ffIhlF+AFcKG5VeIbVjqv3LNCWQOy54lyfBcJJ9ZpqfO/SWIk/gDUjd/HE82B+dTxWknG5M7qLUn7bwatT17gPqLIrPwCXOZVMA3ipA+Pd8UDgMt9Wsds3Ql14XV1HmIx32HcjS8lwjc+Fl3DZ5Am1KmqIEGSt+e3K1iSE8JH1RA85jXdska+yUjJ5qQUO3ZIO+XBGTJSsXQjxq7r3USNFbymuUcOGTS+CyRenMJNRobJJuUenwk3wGMBupnfo+kQHrrjIDtywP10Mf4e69WwTqb67+ZNHiKgmeiI9N2dh05LkDmlAxmalywFZ87QC3CRXckTIoM3rSpWVficVqMPcbAAUUegcG+Kk+neLumGPN/Wg0q0mPaUAqm5CzlmkEUDTYokTJtK9xp0z1svMrgPQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 039032fe-1672-48c4-d3d0-08dd5063e811
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 21:33:38.3608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZlXlT8utdYGUxiZXMSZYrZnUj4yqeYA1FRgb3EtW+KRANnd5qr6WbpY57uudnHfN43f5FaG4NoDtXG7ub/3Q5kMBOr8UrJqq22KyIMssvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_10,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502180144
X-Proofpoint-ORIG-GUID: f7b9_NF3MdBdBF_b9CH2Zir5EkC_fI6d
X-Proofpoint-GUID: f7b9_NF3MdBdBF_b9CH2Zir5EkC_fI6d

Hi,

This patchset adds support for polling in idle on arm64 via poll_idle()
and adds the requisite support to acpi-idle and cpuidle-haltpoll.

v10 is a respin of v9 with the timed wait barrier logic 
(smp_cond_load_relaxed_timewait()) moved out into a separate
series [0]. (The barrier patches could also do with some eyes.)


Why poll in idle?
==

The benefit of polling in idle is to reduce the cost (and latency)
of remote wakeups. When enabled, these can be done just by setting the
need-resched bit, eliding the IPI, and the cost of handling the
interrupt on the receiver.

Comparing sched-pipe performance on a guest VM:

# perf stat -r 5 --cpu 4,5 -e task-clock,cycles,instructions \
   -e sched:sched_wake_idle_without_ipi perf bench sched pipe -l 1000000 --cpu 4

# without polling in idle

 Performance counter stats for 'CPU(s) 4,5' (5 runs):

         25,229.57 msec task-clock                       #    2.000 CPUs utilized               ( +-  7.75% )
    45,821,250,284      cycles                           #    1.816 GHz                         ( +- 10.07% )
    26,557,496,665      instructions                     #    0.58  insn per cycle              ( +-  0.21% )
                 0      sched:sched_wake_idle_without_ipi #    0.000 /sec

            12.615 +- 0.977 seconds time elapsed  ( +-  7.75% )


# polling in idle (with haltpoll):

 Performance counter stats for 'CPU(s) 4,5' (5 runs):

         15,131.58 msec task-clock                       #    2.000 CPUs utilized               ( +- 10.00% )
    34,158,188,839      cycles                           #    2.257 GHz                         ( +-  6.91% )
    20,824,950,916      instructions                     #    0.61  insn per cycle              ( +-  0.09% )
         1,983,822      sched:sched_wake_idle_without_ipi #  131.105 K/sec                      ( +-  0.78% )

             7.566 +- 0.756 seconds time elapsed  ( +- 10.00% )

Comparing the two cases, there's a significant drop in both cycles and
instructions executed. And a signficant drop in the wakeup latency.

Tomohiro Misono and Haris Okanovic also report similar latency
improvements on Grace and Graviton systems (for v7) [1] [2].
Haris also tested a modified v9 on top of the split out barrier
primitives.

Lifeng also reports improved context switch latency on a bare-metal
machine with acpi-idle [3].


Series layout
==

 - patches 1-3,

    "cpuidle/poll_state: poll via smp_cond_load_relaxed_timewait()"
    "cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL"
    "Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig"

   switch poll_idle() to using the new barrier interface. Also, do some
   munging of related kconfig options.

 - patches 4-5,

    "arm64: define TIF_POLLING_NRFLAG"
    "arm64: add support for poll_idle()"

   add arm64 support for the polling flag and enable poll_idle()
   support.

 - patches 6, 7-11,

    "ACPI: processor_idle: Support polling state for LPI"

    "cpuidle-haltpoll: define arch_haltpoll_want()"
    "governors/haltpoll: drop kvm_para_available() check"
    "cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL"

    "arm64: idle: export arch_cpu_idle()"
    "arm64: support cpuidle-haltpoll"

    add support for polling via acpi-idle, and cpuidle-haltpoll.


Changelog
==

v10: respin of v9
   - sent out smp_cond_load_relaxed_timeout() separately [0]
     - Dropped from this series:
        "asm-generic: add barrier smp_cond_load_relaxed_timeout()"
        "arm64: barrier: add support for smp_cond_relaxed_timeout()"
        "arm64/delay: move some constants out to a separate header"
        "arm64: support WFET in smp_cond_relaxed_timeout()"

   - reworded some commit messages

v9:
 - reworked the series to address a comment from Catalin Marinas
   about how v8 was abusing semantics of smp_cond_load_relaxed().
 - add poll_idle() support in acpi-idle (Lifeng Zheng)
 - dropped some earlier "Tested-by", "Reviewed-by" due to the
   above rework.

v8: No logic changes. Largely respin of v7, with changes
noted below:

 - move selection of ARCH_HAS_OPTIMIZED_POLL on arm64 to its
   own patch.
   (patch-9 "arm64: select ARCH_HAS_OPTIMIZED_POLL")
   
 - address comments simplifying arm64 support (Will Deacon)
   (patch-11 "arm64: support cpuidle-haltpoll")

v7: No significant logic changes. Mostly a respin of v6.

 - minor cleanup in poll_idle() (Christoph Lameter)
 - fixes conflicts due to code movement in arch/arm64/kernel/cpuidle.c
   (Tomohiro Misono)

v6:

 - reordered the patches to keep poll_idle() and ARCH_HAS_OPTIMIZED_POLL
   changes together (comment from Christoph Lameter)
 - threshes out the commit messages a bit more (comments from Christoph
   Lameter, Sudeep Holla)
 - also rework selection of cpuidle-haltpoll. Now selected based
   on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
 - moved back to arch_haltpoll_want() (comment from Joao Martins)
   Also, arch_haltpoll_want() now takes the force parameter and is
   now responsible for the complete selection (or not) of haltpoll.
 - fixes the build breakage on i386
 - fixes the cpuidle-haltpoll module breakage on arm64 (comment from
   Tomohiro Misono, Haris Okanovic)

v5:
 - rework the poll_idle() loop around smp_cond_load_relaxed() (review
   comment from Tomohiro Misono.)
 - also rework selection of cpuidle-haltpoll. Now selected based
   on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
 - arch_haltpoll_supported() (renamed from arch_haltpoll_want()) on
   arm64 now depends on the event-stream being enabled.
 - limit POLL_IDLE_RELAX_COUNT on arm64 (review comment from Haris Okanovic)
 - ARCH_HAS_CPU_RELAX is now renamed to ARCH_HAS_OPTIMIZED_POLL.

v4 changes from v3:
 - change 7/8 per Rafael input: drop the parens and use ret for the final check
 - add 8/8 which renames the guard for building poll_state

v3 changes from v2:
 - fix 1/7 per Petr Mladek - remove ARCH_HAS_CPU_RELAX from arch/x86/Kconfig
 - add Ack-by from Rafael Wysocki on 2/7

v2 changes from v1:
 - added patch 7 where we change cpu_relax with smp_cond_load_relaxed per PeterZ
   (this improves by 50% at least the CPU cycles consumed in the tests above:
   10,716,881,137 now vs 14,503,014,257 before)
 - removed the ifdef from patch 1 per RafaelW


Would appreciate any review comments.

Ankur


[0] https://lore.kernel.org/lkml/20250203214911.898276-1-ankur.a.arora@oracle.com/
[1] https://lore.kernel.org/lkml/TY3PR01MB111481E9B0AF263ACC8EA5D4AE5BA2@TY3PR01MB11148.jpnprd01.prod.outlook.com/
[2] https://lore.kernel.org/lkml/104d0ec31cb45477e27273e089402d4205ee4042.camel@amazon.com/
[3] https://lore.kernel.org/lkml/f8a1f85b-c4bf-4c38-81bf-728f72a4f2fe@huawei.com/

Ankur Arora (6):
  cpuidle/poll_state: poll via smp_cond_load_relaxed_timewait()
  cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
  arm64: add support for poll_idle()
  cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
  arm64: idle: export arch_cpu_idle()
  arm64: support cpuidle-haltpoll

Joao Martins (4):
  Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig
  arm64: define TIF_POLLING_NRFLAG
  cpuidle-haltpoll: define arch_haltpoll_want()
  governors/haltpoll: drop kvm_para_available() check

Lifeng Zheng (1):
  ACPI: processor_idle: Support polling state for LPI

 arch/Kconfig                              |  3 ++
 arch/arm64/Kconfig                        |  7 ++++
 arch/arm64/include/asm/cpuidle_haltpoll.h | 20 +++++++++++
 arch/arm64/include/asm/thread_info.h      |  2 ++
 arch/arm64/kernel/idle.c                  |  1 +
 arch/x86/Kconfig                          |  5 ++-
 arch/x86/include/asm/cpuidle_haltpoll.h   |  1 +
 arch/x86/kernel/kvm.c                     | 13 +++++++
 drivers/acpi/processor_idle.c             | 43 +++++++++++++++++++----
 drivers/cpuidle/Kconfig                   |  5 ++-
 drivers/cpuidle/Makefile                  |  2 +-
 drivers/cpuidle/cpuidle-haltpoll.c        | 12 +------
 drivers/cpuidle/governors/haltpoll.c      |  6 +---
 drivers/cpuidle/poll_state.c              | 27 +++++---------
 drivers/idle/Kconfig                      |  1 +
 include/linux/cpuidle.h                   |  2 +-
 include/linux/cpuidle_haltpoll.h          |  5 +++
 17 files changed, 105 insertions(+), 50 deletions(-)
 create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h

-- 
2.43.5


