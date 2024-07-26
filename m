Return-Path: <kvm+bounces-22350-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E2993D995
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 22:15:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF2C82847DF
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E01713FD66;
	Fri, 26 Jul 2024 20:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CL+SfTfY";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y4IMmHKF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9166947796;
	Fri, 26 Jul 2024 20:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722024899; cv=fail; b=VL06RH7M53N2+ZMBCUjhREbKhqTgNDEB2KU1Om9NoJGXVoInISxUynujcJvI2/Wv9rMrXPzJqGRMRQSlOswEszf1HpdDY+LuP9HkrC+fmp2wF0GqN+ypWza/B5C/BGqpU0BXj2q6PkYj77BwljdipRmzOofJjGppg0kcbi9bq/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722024899; c=relaxed/simple;
	bh=oUCwPSHkqbs8HTpQ7YkFJ+Wx6p6dfqJwH1BigO55Yss=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EFHG8Gu6Z+A2fS8ZePgizTBztMRGhxrnewfyYOswm4jaM38rI0QVUOr1XayewsPhnSw/GhdxDUn9bpKGRkiYcQ7OAx6xck7wLrsbZnYlFwUDP/31EqhbJ5j7rA3W1qyhbvqN59j31iKs+AYRKhrODih72vlK4xZuTfYD1IDkLFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CL+SfTfY; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y4IMmHKF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46QJcB7v005341;
	Fri, 26 Jul 2024 20:14:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=Rbm08n2ELVMR0+299G71Rl4lvAiZTAexxu1pETLxiyA=; b=
	CL+SfTfYzh4BKyuwVw6Bm7tqJRw4/tjUHmu+H9tZf7WdrjLgDMAFFp+vD14xJBcF
	lZRkk0HA5yH/j3q6Ro7nEQHPgmPknkHzNhOfPqEP+Vhgd4wx8YrlwHH4JHhtV8lT
	87QjeiNsd2SeOs0xcjPqhJFQr4LjkPJMU5dicwFjphD15EEDZz9TcMq6Zh/TPLyY
	u4JlSdAZRZ4YR+kTisUMT2HgmIwg2/nPm3L58+FvYUGXv3JssOIFDn2SbfWHrQ08
	6fwR2IZjLlg/m3Uq1XBjK6piTUwSHjN7Dw/IkH/SQOQ+4y3d6YfwGPIHB20oRSDz
	2a18cy7aRvwuNWmqn6MrqQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40k7yuvhrb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:14:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46QIOjJO013515;
	Fri, 26 Jul 2024 20:13:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h2a645qs-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:13:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sdN0O6Zscny2PEeHiWfBYgQOvXo46arzDAmflfapNxlFA/GVkCGAAXHKri3LRC1fc+Q0/75dywkEGe4yL7gS21hmKq5Ewd7L8P0VzSoMrh3ashaoZqM0K0eMOtOPaklygSF0z3JAYJ5cyhdKxnXp2O1qXuh/nVI9i5PvHWn5KbhjY/WEleHYt5S/bHtmSeVxmJh2P7JefDy6Onu4iTynRllCFdabsSeh2wiUMwAYPasryayAChxSX9yJZBjZfM0bJFSknt46muKemOiQYSuVFlJgmpXN8COsfyCQYOTyauRv2/UdrNrx1Y2kaem5AM2Atet/wPD3FaGf+ovPk2joSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rbm08n2ELVMR0+299G71Rl4lvAiZTAexxu1pETLxiyA=;
 b=Z+R1VL/soUAtvg3D5iCihhjr7d+8FIUuEnYfGmUZKvJDwqSufULOUzNNNdHMnCwOEpSGZLNzzunsZ9UgvYZAxXFQCvdKMZey6gdkSalrQiXAYokKim2cqSLjNtlkYDXnt15NG4rv7AdEMME8Rigp0HwAjnvvFcxLGFVC+WfaHcSPfZvdeKMXr7FjTX2+aOEFbPHJsfwDt5J4O6Bix76FKTdlM+hwEryBfiKm36vNQxUmSJjQ9nULDw+Bc3tFldGuKgMiup21VKSkvKJEjQLY1bTwZjJHfHLKvzwdup9Jig7yGA1A4DvInu+eBULh6jwn/QlBWjK9ijk2peYLAgQ13Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rbm08n2ELVMR0+299G71Rl4lvAiZTAexxu1pETLxiyA=;
 b=y4IMmHKF5DyFsD6+xus4/0PFLSVM7CLd2j+BNsVEYn7xkaTqxNuN2wxIAXJTsVibZVkVgh9UqYn1ZEKaM09hqfEz27HBUr4Hww5XXhZd/ChFhWhsk/QH7vzYiYrITrkTlSjdgFmTHI94nksveRqTbaB/Eo8/tz5cnLmubAcBFy0=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH3PR10MB7715.namprd10.prod.outlook.com (2603:10b6:610:1bd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29; Fri, 26 Jul
 2024 20:13:37 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 20:13:37 +0000
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
Subject: [PATCH v6 01/10] cpuidle/poll_state: poll via smp_cond_load_relaxed()
Date: Fri, 26 Jul 2024 13:13:23 -0700
Message-Id: <20240726201332.626395-2-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240726201332.626395-1-ankur.a.arora@oracle.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0072.namprd07.prod.outlook.com
 (2603:10b6:a03:60::49) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH3PR10MB7715:EE_
X-MS-Office365-Filtering-Correlation-Id: c242c406-aec2-4757-cc96-08dcadaf6eeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4ZYVwNd84f/W7+dRgio6ln6P6fzbp8/wHDvGTXfMERHnHYy/W+3FTglj6RJI?=
 =?us-ascii?Q?YT5EL3JFlufj2ryblfiisY5z5ds7YhVPBUEzTIBFuls/hMaTjBAsTgw5sHXI?=
 =?us-ascii?Q?qA8TQPaMuEmsr2/I8/ZUuw8ULo2/OGGksM2m4cf4faPFg9UocjBHOnAOls+H?=
 =?us-ascii?Q?dUiqILKivJtaeJISjv5JMuA0NxgBNTmAwzd8H519yA175Lw56oxBGoUwoSDH?=
 =?us-ascii?Q?ze+zMM2I9KREOXCQBPod2hRSHx3Vn9Jcq8uzLPBGAIQgr7rXimptDudvBLwL?=
 =?us-ascii?Q?tML2pSrWuNDvFSQAANRa8r2HYlf8MQ8x2jEA1a1JIDF7D3LB1blUUVake/PT?=
 =?us-ascii?Q?5wnZwIuTt7l0lJnU2Oe9vXNNvbI5TReTtMXLyg0teVZOhdxFu/G3Oh3zbYgJ?=
 =?us-ascii?Q?VIuytPsGnUZpFcYUMbTwkH4EDhPGTuK3eDq96lkSREtD36+eyXFAJsO1l+T1?=
 =?us-ascii?Q?qASJY27IyAazPlkKGmyOJLdgZA51rGEkXmHDT0Cx1pCLMvKUKvottBm46huN?=
 =?us-ascii?Q?Kyfs+c/evEXNLUKE79lVQlWFUWhM86Ik6SKdcRw3r5btuNd2iUzDuMrvcb3W?=
 =?us-ascii?Q?x/Eq9toooBvV807MljGrsvfIrcNnUMhxbb0oDog7JeGlf9ECSzJljeTBbibk?=
 =?us-ascii?Q?9SZsiMZhqtjUaYEHHjjsb+hMdT4DoDSK00ltxGVhHDoFZSsknUZp6f4yPnDC?=
 =?us-ascii?Q?0lCsr1in+afN/+a0/gqQsZ0l1cXCNS3/H05UEzS23PD/Is8qX1GHkQ4FT6A7?=
 =?us-ascii?Q?mk2EuMj7+EVcxg/BpEkddKxGy7yTrDkOiI57vZ3Y7QDXxkav3i69ekN1QaMB?=
 =?us-ascii?Q?5chhLNHyCSd/Ho3CHCUo1IaxbEL11oRBzYG25Mmymt7z/AhkRgoFZKO5+YQP?=
 =?us-ascii?Q?XSVXnXWNvQ88arJ7ZUla5dovc8hlBFe0F9V15vgp6D38c1SuR/DKe0SkGSWM?=
 =?us-ascii?Q?wntCYW2ydqRq0xe8e2YxSsjD7RxdZG+ByMUBy0jCJ5r/VtcOTdE3YnVSIjWQ?=
 =?us-ascii?Q?syFVgujQ4SIjDKI6no2A5iqd7RfkvxIYkKdsXQLxwNAg/JbK18QGivR7sGTn?=
 =?us-ascii?Q?DFNodjJhctApIXG3E5ld9ll52hgBnskTcA1M/fWsrzbSADb55k8zAT1yJ+iE?=
 =?us-ascii?Q?iptSwYcay6Z9h/I0MTHS7mZG0Zlw0vHi2FTYOMljYNtqEnkuNqmH2nMB+BbX?=
 =?us-ascii?Q?5dB/IaIisEWj1nW0/OeARAE/lXpriZ0rSuAbfcyexU6RIkm00R3ZkexMN/Kn?=
 =?us-ascii?Q?Zq4hLaeL3z6uHRy/ioGlMLkRxz6zUOg6Byt1BTvAU57d/XrnUZr2g+Coj+Dv?=
 =?us-ascii?Q?GDA6GfHTgItN0zOqh/WKx8YQjPEQkjqenMhvBExCGf+giA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LYh2GfkFBp3OtEtMZFBrKiKwTfhtLinoqN/2syp67uABAtdAaPKyEl+wdbwH?=
 =?us-ascii?Q?ZCRAwYAqxnokHrDvitiJdoqHHqjHhPXxM8FJwdqQr4SVxId4/lQh4NJXQwhy?=
 =?us-ascii?Q?fxjhbVKnkjbK8HlDGpsRPjONI5nhTAbWoJKXVBQ2OmT60v6U8JiN1ZmGmI+J?=
 =?us-ascii?Q?WRtzNMikYHfrQiTym5Vyagmr5SxazbTKDSpLzixpDjo0t+nDTi/0M6OsDUPz?=
 =?us-ascii?Q?e9AlKHFuiPjp5MzVQwjmW5HhR6CkinwJyQgFVEwa/YRvXhSwq+2YZiaBUYtN?=
 =?us-ascii?Q?I0l/KabHaUC0A4cywZGaYcjpKrlekUYN/4DRQprDTfZhlTordzJuNa2II8CC?=
 =?us-ascii?Q?Z4Wl7jb/ifjIdfca/S8dax5F+lnBFjkVcMu8HJN8OgsKrCnoJfnxmltyvZ2o?=
 =?us-ascii?Q?7oFkKzBsMrnwcTYJcmTFjzHPJO0aVhNfjLjrf0Y/R3rAko2LLnzdbVP+oE4L?=
 =?us-ascii?Q?e4gd0Vjonf4RXh1iYOYYhH+ZtvkPANfyVEklRA1/ha5V+myf+Wn0VmEtqX+K?=
 =?us-ascii?Q?ueExmngu5rLPUbU1UD36gq4/bte39P6XCow/p8+H/177dU6TUcSocgmghoQp?=
 =?us-ascii?Q?/X8LIODS+7XsqG8OzolOQbDPtiRcLyJ45H6hEJvrnzv7jxrkmpgbt0wBttca?=
 =?us-ascii?Q?30rBJ0cJIsJxCWvzWXkyl7KTGuZ3ztgdmKo6LB7fcR2rbyM6Z7sIu8OSEDkV?=
 =?us-ascii?Q?he77OlvtgGKg9QcDk/eLARgjzfRZ9Xt+J0cM1pAHYjD2hgnNrcT6a+lilwYr?=
 =?us-ascii?Q?cahgYEas5OcBVOZnCwAqu9MqQXU8mLd+uhovG9Tf8fkNV+7mvJhIdD2FpxJ9?=
 =?us-ascii?Q?sWkRf86gb/SvaikZCq5R4Avdw0Sdr5Bz7jZTRx2m3a578oQR7rROvXt6TTiS?=
 =?us-ascii?Q?x3MverJvH3Pnt83HmlqpN6XMx6Buc2bPHSLwwTXLozDpJAJP7UpBTp+Ak/4X?=
 =?us-ascii?Q?E9/kFqRghOh14+gBytMTz39/G7xAMR+hi0Pp86nVQyzbxM5K8BU7T2rLD5iu?=
 =?us-ascii?Q?ZW3Qmf2PzhYpLQ1hBa2eApBN9Z9JT5z2J+Woth4GNjilmf5C2ZBU4wYXuZ3B?=
 =?us-ascii?Q?iebI8HXoBOTTJU4diqYnym+2nSLNUH/zd6YlX7b3uo8S3Edes9/v8TTLfMCB?=
 =?us-ascii?Q?7Ym2GTsJYV+xMrN7Hs8D+h+JzPAgSaXgBNdYas6K7Lge3K7zT12DrqWt/ZLw?=
 =?us-ascii?Q?N2ajVsocNr70Ln9jWV/vWbbPR94JBlzGGWHE30iFVslMMeWp3tZ7CEUzxmNo?=
 =?us-ascii?Q?8AaQ+iV+hfN3Xl8cnHtvdUGqBGbXaGXO1CPr+XgDKuA1yDzYS248J8uSyDev?=
 =?us-ascii?Q?FmQTHM7NdaKcWt4K3UOq2BEgO44OmcbqSQBI8gJTjaWuq3X2GPAbRb9KYLen?=
 =?us-ascii?Q?1xK5cpFGBxWw5AP46HVwJDKPwhNKiITmzxgZkmSl7wlbWp2wX18o4DLJmHG3?=
 =?us-ascii?Q?yzqdIPS5Ts5jifuUMUHDwj1M26M11L4Zd4PwMa/w3j5iAIK+K1RnDzR/pinO?=
 =?us-ascii?Q?IL1rMjlGOCs8ssssMOTDh5LWJuxcC3H94C7AEZ4ynYK+IK7ppwNU5/sMIGQH?=
 =?us-ascii?Q?CU0IW35tJmRy7u6DiT9RqkSvoQaMs/7vYhWeye41/Chq7PjpvvgXxSx0DOvE?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PWuK2tV/Zju8v+Nbi8y6AjAj4s1xG3xKxVrMZ2a8AvfzVt4n9I/wJqUsJfY6wHPodxfHQ5SimGjAOsJ8MT8UnBQgpLC2W8g6+w33wYL/HqglgGWksHkPOkhifUfvKcvFTd3mMgA1Zye4S3pStThG3UPh1Fy5XBF9tbmAAVaMyxbu6Bo5jfWMoXTMrHg9PxtNmXrXhKNkjyX/nNwFDD3Xpfzx90Ea2iNEORxRO8fYu7Jql3d7i4RL3e6223KPh/dMyZU29BGsAs4NrTiglvrzLdGsIM2sgbthnQiYiG50pr7oHQjJMjvJjGMdDbU+COqe0LMD2RRUUmlrVN4XtULk2cQyai2j2QhougoVJQvSoQ+6Vv+747Z2X1a4JmB+btoII7Dd6HoNwl1nA87hZVZwXvbGl/AXqua/mli4cRB1it1XWUeFgbkpFcInHz+3nv3SKqvLM2sGOJ0iEEZQOXpnC8pRdsXEwMCjP8S4b1GoKb2RrdFbp4YPtk4tIRA1z3bAayKiwj6b8v1KDp49sxrFZPTU7J6l+MKffdjPnXiOox/pHvEd2b2fb1OWJxrf8975NFyRV9QxY16pwmcevtJRcWuPUka8ctlNB1vKvtujmrA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c242c406-aec2-4757-cc96-08dcadaf6eeb
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 20:13:37.3405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 55HJWIBgr6sgZrONIwVwxg9cIXZ56ZsPGfGVoC1Lo0MUCQOFr/DfNdWXWrNuE1yJS4ZotfGurfNfZmmfnvGb4w7iTh+6dtfUqyGrcMgp8tI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7715
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_12,2024-07-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407260138
X-Proofpoint-GUID: JpL54Q8T2gI3l8BBXwNZlj62GJ2zXeMK
X-Proofpoint-ORIG-GUID: JpL54Q8T2gI3l8BBXwNZlj62GJ2zXeMK

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
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 drivers/cpuidle/poll_state.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index 9b6d90a72601..532e4ed19e0f 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -21,21 +21,21 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
 
 	raw_local_irq_enable();
 	if (!current_set_polling_and_test()) {
-		unsigned int loop_count = 0;
+		unsigned int loop_count;
 		u64 limit;
 
 		limit = cpuidle_poll_time(drv, dev);
 
 		while (!need_resched()) {
-			cpu_relax();
-			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
-				continue;
-
 			loop_count = 0;
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


