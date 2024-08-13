Return-Path: <kvm+bounces-24059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E2675950C9E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 20:57:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99DAE282AAF
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 18:57:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 468D01A3BD8;
	Tue, 13 Aug 2024 18:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EHMX18Nh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sMY0FBB2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8941A2C17;
	Tue, 13 Aug 2024 18:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723575457; cv=fail; b=YiSvs6AUr7Y4OYe6KZmt1xMa2RtQixXvzGV6YbxHBMhlHBjdZRXmEgwc7o8W5iK8+NCsJW+sQ78WShEuQi4wg9oegcq3Bfss6KvEr9ZV+EuEAvCNRaWGiU7shXHdEClwFmM+1gnWgt7UmMqO27hKSYVqKmJ8lpX1yPAMmiohBcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723575457; c=relaxed/simple;
	bh=ub44650WOJEW4vIg5n0zVecb/KCsx04LlNYG3qj/mGo=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=HvgvYeauLkxeARHBZqKCdVYLqJSCuxoiPxpSRYXXGJQEUPFQjyGZ8DAuKO8M6jfuyf+/NOTIrSaL1X9/7T58NINWZ2f2MFrP3SR7IfhSjPyom9F3bTJuAy19h2McHE177G4xZSf+Xl8EEWlptj/sXCrdVXVnSOwfELG7KFNg3DU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EHMX18Nh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sMY0FBB2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47DGBUhv002857;
	Tue, 13 Aug 2024 18:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	references:from:to:cc:subject:in-reply-to:date:message-id
	:content-type:mime-version; s=corp-2023-11-20; bh=zUm/BzFUrwuTF2
	iOxVmelYHHkSWwzNjHBmAVpxgagjE=; b=EHMX18NhG6D0tOC8hLLYRKEpYSSH3i
	UmvUj+vQwQb1H7GB2Ze/nV4E1/IVZ/Z8AQILiJhKXax+q4u2kQCBDPlMjqSRIcnZ
	kqv6W+tCnNNsxqxsAJ063IxjjGKUaD14nrrXB+kyxqjYcpLp90QnocuxMZqRGIRQ
	q7RqwvFz+eTa7FCHNoMrcGUyo3sQJS7j55Tk14x2znPR7FKXEFBXRZUPTI+Nsk6M
	KTfcYAMS2a7X+FLTxlpx+JJTpE9AKd2ZTIGGGrQJi4chkAg16sqvxn3/WUGId0Ir
	7Fhqvpu8Xolfyx21zNtKA0SbY9LxQxmTGpebDwAEgYVizSXCFM/B5zkw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40x0rtpru5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 18:56:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47DHbOEj017686;
	Tue, 13 Aug 2024 18:56:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn9uvrp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 18:56:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ayVgOkHhJdD2Ag8qzPoPrKQX/06lFeWeQAGG4t5i9fiFKWaUhc7/U5BPBUYKdQAs/gEHqteHj7p1hBKVXbOjZ/ZQOe0VO0ZNoTQtYu5p2ZUOB2oL6dX09LVh52wrC6RTFNHfJ9Lnm2p4NcV/DE/5mpHbCBRkf2ZqWb/3Zad11djTrW4lg77t2Ac2eTd5/6Wh8TUPEVYpMgcylq7P3FdLkFBuABvZ8SBhTl2TxziRATWkbSsVVmq/1ilgsGN9YLu3VfRXubt8gj9hyED5Mrpc9AuNDWsc2tgIEosQCWTltig7jEHB9wznQApBJLam4vZpU7FFt76SWQG32fSsHxN3LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUm/BzFUrwuTF2iOxVmelYHHkSWwzNjHBmAVpxgagjE=;
 b=LBZjTH535FrIgpg8Czje95ftevq7fCzfhbMCTp6PZrSAn1X0+AV3hJY3bh/j8FeHUTMQ+Ht8UfEQ66t0KTtD7zdcdlfvMcZMBCF0GCterXBXiFL09EiBqn0Yc6ALSp1IDlqavEWFTxQicUcGDGL5l6OlyCocUh0JcG0RlHOQRoUnzA3ZwArSZPgHDivD6YnCglNLb/T3iVql0TruqMQBtxgiLoMq+oEwAJW6YaIk5cREop6K3sep+4mmjtDazrjZkfe0ENRV3qfRDbqQ7lGH2XBm8hNjE7GCnW3Wb06CNPRXa6dej10KKvVGk3VvODhjHURveCd7ObkSh11ti0U+Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUm/BzFUrwuTF2iOxVmelYHHkSWwzNjHBmAVpxgagjE=;
 b=sMY0FBB2OhYetwxI4p0QG6AuphCYPkv8Y8nIUD3/E9mbOeyjcghMmKJ2UHSY141bdSf61Smvyk3f51e+xl/3a5QSx1QAVwXxBtj6J2X5acIgknn4Dz9fll5GLqk6uZuRt9kQ8CBWB5TTWzEbOamz4PYjrgxcrfytDdDb3EAuJg4=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH4PR10MB8098.namprd10.prod.outlook.com (2603:10b6:610:238::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15; Tue, 13 Aug
 2024 18:56:44 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 18:56:44 +0000
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-7-ankur.a.arora@oracle.com>
 <5ba1e9b9bba7cafcd3cc831ff5f2407d81409632.camel@amazon.com>
 <87ikwors8p.fsf@oracle.com>
 <104d0ec31cb45477e27273e089402d4205ee4042.camel@amazon.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Okanovic, Haris" <harisokn@amazon.com>
Cc: "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mark.rutland@arm.com"
 <mark.rutland@arm.com>,
        "boris.ostrovsky@oracle.com"
 <boris.ostrovsky@oracle.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "wanpengli@tencent.com"
 <wanpengli@tencent.com>,
        "cl@gentwo.org" <cl@gentwo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "mingo@redhat.com"
 <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "misono.tomohiro@fujitsu.com"
 <misono.tomohiro@fujitsu.com>,
        "daniel.lezcano@linaro.org"
 <daniel.lezcano@linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "lenb@kernel.org" <lenb@kernel.org>,
        "will@kernel.org" <will@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org"
 <peterz@infradead.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org"
 <linux-pm@vger.kernel.org>,
        "bp@alien8.de" <bp@alien8.de>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "rafael@kernel.org"
 <rafael@kernel.org>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>
Subject: Re: [PATCH v6 09/10] arm64: support cpuidle-haltpoll
In-reply-to: <104d0ec31cb45477e27273e089402d4205ee4042.camel@amazon.com>
Date: Tue, 13 Aug 2024 11:56:42 -0700
Message-ID: <87frr8qmj9.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0019.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::24) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH4PR10MB8098:EE_
X-MS-Office365-Filtering-Correlation-Id: f7875ee1-dd0e-4e5b-9c29-08dcbbc9ac92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0eLaUZdFb/9WfMLvVPlLThGmd1UetxyZxCPMJLD8Ttd9gVFRhtNGND0dy6JM?=
 =?us-ascii?Q?jwwe5jkz1/EHeMyev9NHSR+F4CfShW4dho2mKlMq4N84U4aAbwdm5Vs+NgMY?=
 =?us-ascii?Q?ngGQ+Id7CDGYCbbswWBi3mkufSFd+lPMiGrl4W8HjmBPSSyXPDlksEYToEZK?=
 =?us-ascii?Q?uu0KCJFLl0beKHrt2aIOKAU771PYjwdhhx1YjNGzIsV9Mn9OYTfz72Wg2UUp?=
 =?us-ascii?Q?N0UfSXM1kIetids4Eh0ipVjJllKmVg5mAfReVn1kZcgYE/4QNlfrvFGrihXO?=
 =?us-ascii?Q?011LXWIGJsA1cW5epWe1jHi5E+ZTIZrvXF06s93uX5TRZXOYz7JGlv76gROl?=
 =?us-ascii?Q?h372TyFpN6UFBfHfQhpF9vj1zafZhYzvLS2jceqGqrNKgrKnaPN7A+JQw6Pe?=
 =?us-ascii?Q?DRGecDtjg5VkvMvj6mCwkWHjXnsFmFvaF+Zd707xolP9eq3RjTc5zAFo0c5X?=
 =?us-ascii?Q?tp3j8e80be8DUblUeohCq11UszPObohmCIo5Vxe+67plKj4mEawBf+gbMpbq?=
 =?us-ascii?Q?g81U0n+O91XiDNzfcJFBE3Lmw4FeuldLlIG4iRA9GPhSLddTbbjeyMGRDeoX?=
 =?us-ascii?Q?3mWQ+UjBXwMgbQ291bnwnBvKltsAA3iVCXJvMk5J0x3X4GAavLHVM1vXpWPu?=
 =?us-ascii?Q?uFwno5I3EQmqakfwcNdzBcN5hC9qQ1ynN/w2EAk/Bknh47eAEVPYjXp0C8eq?=
 =?us-ascii?Q?8XGUPu2pVdg2M6FWYi4a9V27iV7CSYFxXUzr0NL0BBE1Qgvk+jdyS8ehJwKv?=
 =?us-ascii?Q?Zw/gScEpWe0m6jDj6Pc3kLjhcfs6Vt9O++usxjHfM0RR4O7Vme4XFHgHqjsm?=
 =?us-ascii?Q?EtKWIK2VL2ONaWVUxKyQO1vYNm+KM6UH6rMTsxcKRChH9BVPOwM/eMhG+Yc+?=
 =?us-ascii?Q?nPDWjWDbUxnpNUblV6hHdjgems2NCOwXNFabCJFkktN++J+bM/4KTbTlHCPZ?=
 =?us-ascii?Q?RVLgQxLDTSJ5hnhEKOWSL+hGHnSFE90si9GlF5aBlTv+6KIm49Vw/CT5dxxs?=
 =?us-ascii?Q?nwpigSzyndH68OkFFgNMFrHJZTn23KIhM/j021Czm0YVH54bdmeQqLM2zImU?=
 =?us-ascii?Q?brN6t8JWoAOBMzT4AjuBNWKxugDasp9T82YVyECTO46yEz83WanNnTMfI1wu?=
 =?us-ascii?Q?EYt97X/s57TP+5rwUledmfP8UPWlgklSkXfj62V72cNUyR3+i0AHE3xdHEC5?=
 =?us-ascii?Q?LReVajynSGG3zRjku2VVJNd9CJiuihTncuMmQ8NUV9vMqoL7nPc9n0xDkkCr?=
 =?us-ascii?Q?vB0a0dcQbgQReC+8yV5/yliUTmJScJuBuf3ETnJih2Xb+ucNoNjwbKTgKO4e?=
 =?us-ascii?Q?tmAACcGCele6WYdbouANq5bxbWdnhjnIQZz9kjs/APtJwA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eJ4/mcl4ffLMpfuVc33Gm/NpfuELLmZHqy3AiubtMHkGZ5c8QoRMLUvvLnPR?=
 =?us-ascii?Q?hzG9WeJviQBvwmflbrYKWGiS/yNzkagLwOKuNeMY6NCbQBkaAwIMfc3w65pZ?=
 =?us-ascii?Q?3gVQ09e9kFo2zDjMVNhj4n0guR7ftne+T/CSMnks0X1cNc4/QH/bFa4ngb7a?=
 =?us-ascii?Q?aYDBsNR9iNTM6Hjm8wrsPhV+sHQWmlnEsvRC8lJV5gBq37bnkm7e1Pxn7dQF?=
 =?us-ascii?Q?uzDVZ+3Trsr4rKKuKqf1svEUm13tdVVrSIJ67QWhSg4Atb06NxY78u2HQnMJ?=
 =?us-ascii?Q?qW7/HVZqhJc32nWPXVSNTnHt7njs01om2297p1Bu17L+UQYPK6iwDe2hdoDo?=
 =?us-ascii?Q?GmBxqBoZOHAeU+JQRhzz/r2ecRl48HAl5L66JfQSU0cgBK0l671PGcTZ8XXw?=
 =?us-ascii?Q?anKjpzWJXV/zao+/L2j0oLRGyyowQQNI+xL3j2yrwXw4WlvjerLlSOpoVueJ?=
 =?us-ascii?Q?7UtuHXhIPIRSsTxzeBIBUA1kSYqWHvN0iwD+G8Ycy+WYAcc/Kp9z5t8+jnYp?=
 =?us-ascii?Q?9DX3J9C+hYPS7QW60GCtIsB81/t+/z6R7uXgMRoV9X9ERaYqfL3vhedWxJE4?=
 =?us-ascii?Q?NcpiPeegO3Dw66s5y+SIjpfB4vgHXpHRykwj5Vttml5AmImZ3bW0w56d3YHx?=
 =?us-ascii?Q?hF4dUbu+rsfY+GJKJttjNCnKI+ZKyuom134RA1VPtlt0bC+jitpXt6cY95ea?=
 =?us-ascii?Q?6LIrtbAsEWM03YSlqkuqI1xvf7DIWH9x9OWTrsUkfXtArD5QglKwnyeRuqEZ?=
 =?us-ascii?Q?zvutgUhcmLMRcj2OD5PFSYxgqHuzo++pwVRcpDV/JQ6tozIP8e31fHPdC5AI?=
 =?us-ascii?Q?09oy9LNMNH6RiCSO0BEmDHX6ATRHxGk91ChMw99snO1QrA5mnKeAK+n2dv65?=
 =?us-ascii?Q?PJorXvDgPJOTp7oD02Dnfho49PMe7m4JGav1PZS1G3PVOB6AYc7HitP1Tvtp?=
 =?us-ascii?Q?UxX1MU7B6bZrR6UXm3fLffizIB65A49tdJLq0+pjcOLQV+3Jw3u8bIME7qzo?=
 =?us-ascii?Q?CjuIoClBb6hoQRfT4DXKCAxIMupTQy/nPwjL/g8R6UwKjdkh8AamDnslekqc?=
 =?us-ascii?Q?jIhgsvjWBuCEYVm3j2Sx3ZJeBy3QGmX8oQvLEjca/Mma4PB5QlSJExFLVNaq?=
 =?us-ascii?Q?Kh7Par3sKCdowsgMuArF5LX15It++EJbiJTZ0dt+jy/GEIm74XyzVfr7hujd?=
 =?us-ascii?Q?uTwuOy4A0ahkl0DTYiSt0+CT+5d/Hv+TlrUILzE1tGt4AKPe6VOtYrpBaA0g?=
 =?us-ascii?Q?tOPR0tIzI56R8pdObG5VnOKzMdzlzqgTwfwuCSYzhYKN+IjnMUTdqbGtvqXo?=
 =?us-ascii?Q?/3/HlJFnRFxoDW49tkv1y/ym6QYA5Ire4tstUdT9MBjI6+IY2TrufAy08/Zh?=
 =?us-ascii?Q?g3+1lrs0C4qJMI8+8DGeQJ+PtNhLIZOy+C74YOWJ8pO2pD0OcGX1Dk7MJ18q?=
 =?us-ascii?Q?F1qOBvmOiXcd7D3fix8q+ox2ogVmP8ektVJhed2Ft2BE/CGojlJP04ucECfx?=
 =?us-ascii?Q?WGY3b2eWXfczDOhMwCsAnxq+EDW1kJk/q+IkXfHfvghlORL/5v+sTfM+m+Im?=
 =?us-ascii?Q?tbr4dRttJ17e8bpBWP9UpCdFAJbyjrfKxAiMdN5qOuicyVyMaxBRWaoN3efX?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PLgvfDCbrc0LsnYnXqckBeNHm3UTyHYjzqTxdH5TCcGBS+CWTfxB4oDSga+Vbl2VkZcy815KY6Ygyxd6r/FFOC8uIW1pW555wzSuQIgVfL9+h9MH+iVLbBkEB++qYVpWtuwuFqCMRxMBHeqq7PQx3IfUQ2aYJv90fq0I275nZ8tCQL3Z0hzmvktb3l9ZbYXdbGVw9GdEnlzNOvY41VO2yfhgkzKQfOurOn+GJTKSiRAmQN7aTLpz6uY3uWLHK77OOvA6L59WVBszJz76LgOwyD8ZQanhxzkUM44cSPiz5IKQPEavz7OjduS2HkqhCy17XZxEke6WNpR4GWyYr6j2iIocaDFmhBoT3nERxC4aFIHLRnJP/LmweqduBbQ4PmdGeYE/sZdZfYd+KJmHbDqQGlo8gUCHjXYawrFTPnHsMOWbTZgjYpdPHReU6URgVjOCFZH/S6PQ4AYTOZJO5/yfwTNi5ESEYs6wE3zF8+3f16zaxxpJQ2RYWmzW+l45cAJJfZUHalixEyRMDF8uZo+l39Gfa5GjevYLr4Nvu8vEMrPXiyJgk6equlIFhZ6agrR+JM+TSqQESchrx3O8bL5+SM/4nQtCgZw8kD7HlYTY+pE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7875ee1-dd0e-4e5b-9c29-08dcbbc9ac92
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 18:56:43.9860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gvjc74iDnYRe00h34xw1WkR4Hx68rZPA8Bmwr2r5qTSHYL0zKObVmjwbANson3bDJAdxjNGW5cbaAaWa1o5ySeBkRsF9hzGPdKy9Kq5v+mg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8098
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-13_09,2024-08-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408130136
X-Proofpoint-ORIG-GUID: G4Lf250YB64WqJ2Er2vcTvlCOzqsvs1P
X-Proofpoint-GUID: G4Lf250YB64WqJ2Er2vcTvlCOzqsvs1P


Okanovic, Haris <harisokn@amazon.com> writes:

> On Mon, 2024-07-29 at 11:02 -0700, Ankur Arora wrote:
>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>>
>>
>>
>> Okanovic, Haris <harisokn@amazon.com> writes:
>>
>> > On Fri, 2024-07-26 at 13:21 -0700, Ankur Arora wrote:
>> > > CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
>> > >
>> > >
>> > >
>> > > Add architectural support for cpuidle-haltpoll driver by defining
>> > > arch_haltpoll_*().
>> > >
>> > > Also define ARCH_CPUIDLE_HALTPOLL to allow cpuidle-haltpoll to be
>> > > selected, and given that we have an optimized polling mechanism
>> > > in smp_cond_load*(), select ARCH_HAS_OPTIMIZED_POLL.
>> > >
>> > > smp_cond_load*() are implemented via LDXR, WFE, with LDXR loading
>> > > a memory region in exclusive state and the WFE waiting for any
>> > > stores to it.
>> > >
>> > > In the edge case -- no CPU stores to the waited region and there's no
>> > > interrupt -- the event-stream will provide the terminating condition
>> > > ensuring we don't wait forever, but because the event-stream runs at
>> > > a fixed frequency (configured at 10kHz) we might spend more time in
>> > > the polling stage than specified by cpuidle_poll_time().
>> > >
>> > > This would only happen in the last iteration, since overshooting the
>> > > poll_limit means the governor moves out of the polling stage.
>> > >
>> > > Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> > > ---
>> > >  arch/arm64/Kconfig                        | 10 ++++++++++
>> > >  arch/arm64/include/asm/cpuidle_haltpoll.h |  9 +++++++++
>> > >  arch/arm64/kernel/cpuidle.c               | 23 +++++++++++++++++++++++
>> > >  3 files changed, 42 insertions(+)
>> > >  create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h
>> > >
>> > > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> > > index 5d91259ee7b5..cf1c6681eb0a 100644
>> > > --- a/arch/arm64/Kconfig
>> > > +++ b/arch/arm64/Kconfig
>> > > @@ -35,6 +35,7 @@ config ARM64
>> > >         select ARCH_HAS_MEMBARRIER_SYNC_CORE
>> > >         select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
>> > >         select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>> > > +       select ARCH_HAS_OPTIMIZED_POLL
>> > >         select ARCH_HAS_PTE_DEVMAP
>> > >         select ARCH_HAS_PTE_SPECIAL
>> > >         select ARCH_HAS_HW_PTE_YOUNG
>> > > @@ -2376,6 +2377,15 @@ config ARCH_HIBERNATION_HEADER
>> > >  config ARCH_SUSPEND_POSSIBLE
>> > >         def_bool y
>> > >
>> > > +config ARCH_CPUIDLE_HALTPOLL
>> > > +       bool "Enable selection of the cpuidle-haltpoll driver"
>> > > +       default n
>> > > +       help
>> > > +         cpuidle-haltpoll allows for adaptive polling based on
>> > > +         current load before entering the idle state.
>> > > +
>> > > +         Some virtualized workloads benefit from using it.
>> > > +
>> > >  endmenu # "Power management options"
>> > >
>> > >  menu "CPU Power Management"
>> > > diff --git a/arch/arm64/include/asm/cpuidle_haltpoll.h b/arch/arm64/include/asm/cpuidle_haltpoll.h
>> > > new file mode 100644
>> > > index 000000000000..65f289407a6c
>> > > --- /dev/null
>> > > +++ b/arch/arm64/include/asm/cpuidle_haltpoll.h
>> > > @@ -0,0 +1,9 @@
>> > > +/* SPDX-License-Identifier: GPL-2.0 */
>> > > +#ifndef _ARCH_HALTPOLL_H
>> > > +#define _ARCH_HALTPOLL_H
>> > > +
>> > > +static inline void arch_haltpoll_enable(unsigned int cpu) { }
>> > > +static inline void arch_haltpoll_disable(unsigned int cpu) { }
>> > > +
>> > > +bool arch_haltpoll_want(bool force);
>> > > +#endif
>> > > diff --git a/arch/arm64/kernel/cpuidle.c b/arch/arm64/kernel/cpuidle.c
>> > > index f372295207fb..334df82a0eac 100644
>> > > --- a/arch/arm64/kernel/cpuidle.c
>> > > +++ b/arch/arm64/kernel/cpuidle.c
>> > > @@ -72,3 +72,26 @@ __cpuidle int acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
>> > >                                              lpi->index, state);
>> > >  }
>> > >  #endif
>> > > +
>> > > +#if IS_ENABLED(CONFIG_HALTPOLL_CPUIDLE)
>> > > +
>> > > +#include <asm/cpuidle_haltpoll.h>
>> > > +
>> > > +bool arch_haltpoll_want(bool force)
>> > > +{
>> > > +       /*
>> > > +        * Enabling haltpoll requires two things:
>> > > +        *
>> > > +        * - Event stream support to provide a terminating condition to the
>> > > +        *   WFE in the poll loop.
>> > > +        *
>> > > +        * - KVM support for arch_haltpoll_enable(), arch_haltpoll_enable().
>> >
>> > typo: "arch_haltpoll_enable" and "arch_haltpoll_enable"
>> >
>> > > +        *
>> > > +        * Given that the second is missing, allow haltpoll to only be force
>> > > +        * loaded.
>> > > +        */
>> > > +       return (arch_timer_evtstrm_available() && false) || force;
>> >
>> > This should always evaluate false without force. Perhaps you meant
>> > something like this?
>> >
>> > ```
>> > -       return (arch_timer_evtstrm_available() && false) || force;
>> > +       return arch_timer_evtstrm_available() || force;
>> > ```
>>
>> No. This was intentional. As I meniton in the comment above, right now
>> the KVM support is missing. Which means that the guest has no way to
>> tell the host to not poll as part of host haltpoll.
>>
>> Until that is available, only allow force loading.
>
> I see, arm64's kvm is missing the poll control mechanism.
>
> I'll follow-up your changes with a patch for AWS Graviton; still seeing
> the same performance gains.

Excellent. Could you Cc me when you send out your changes?

> Tested-by: Haris Okanovic <harisokn@amazon.com>

Thanks!

--
ankur

