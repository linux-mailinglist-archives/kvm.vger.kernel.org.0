Return-Path: <kvm+bounces-22360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D75493D9BB
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 22:24:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 164BC1F21295
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A36FD1553AF;
	Fri, 26 Jul 2024 20:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="d4GlpcLr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L8nOAh90"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B27B1552E4;
	Fri, 26 Jul 2024 20:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722025353; cv=fail; b=qbvZ+mmPR0ITBQ2biNFK7pIUvryVjPRWuNx+VCzDeFHch4+ytwExhyf4gWS9iK5q4OlZjS2PVVRSFQrvihVyVIJARE0wRPtrjbpT5H0dhbdxBuPlWW57McCGMCn25glI5IRH3Qqu8p5tiBzG08kA/paTO3tYUFfD6F9shf2FWPg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722025353; c=relaxed/simple;
	bh=423Bu8Tb8C43QLyjQ2XTu4Fv/p2H+MdxD2CIU7Mykj4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gin+F5ZBm0qJaeZAdfw9Iz3LSQmyRdgqzVV4WbqxWBR8eKh4b/fEXYpmuW2mDqe6HlHFLJCNs8EPaTCFcmnSjBd5vmthTDFp191NJ+DhoSvemwnp5aCPtP7BDTtM9xrj37Jf1p7WkB91DKtemMOwdi5A6o6yUeeFsNl8zh9HoDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=d4GlpcLr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L8nOAh90; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46QJkOd3010642;
	Fri, 26 Jul 2024 20:22:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=0Y5iQq5AlfaXHODFJbhwAtwyWEbdQAvsaddyAJxEonM=; b=
	d4GlpcLrF0pcmUbCUhvanPUPFWTTBNADkOj8TMOY1XgFbR5w97OfhQw3XSwPIjn6
	PrfRL1c4IzS8o4WBErUcOJS5l7kYt3wIvvewRmvscCfC2qal/fU0mIL7ZA6uIhH6
	qXNKLcFx8rR+HH7BizI96lIr+mDJtYy1XjTRB0XcWerxi8Yz+G36DY0k9mAUf8jH
	5wtzPe9Zr6FTGQcOMOeHdiJ2nYLucAvstAb7x0O9jIvkS+m84ZeSfI2Ni6/Rd6rm
	xu7CRgstTNcyp+Qlvmbs/8fYL16tRA5W5bHt/OGjf/qf94lHjhbGDHS4qq6itlGS
	a9C7pCECFN3yNjGNy5ExSA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hg1161j6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:22:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46QJUlLG022353;
	Fri, 26 Jul 2024 20:22:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40h27sf01v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:22:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1ut5/c3ZGTB35fh+51ysTyI80OV4NLN/vaul8ylTX8vNtRaMS6bOLfjQVZBr4m2Uu1qNZ1Jpi8qKAHS2C1oIlAmaCVoTqJ9xB8lSEBynG4U77ksuTWIbGGcs3mwU5NQ37Ne2Dm3+CCPrrqSGJyhiXfbd3cwZg7J1WGZie8tArsGBIkdRufDq3IVBegCEU08Asm9CG0tEk5OYQam99MeLxy7qsb6rtNp/L84+Cxen6cm6BA+EkG/mmMcou51p4yXhQ4Nq2stWbeMfGCr6NoA3P+T0FzFUdc5lZjhtiqu7s8yhfQb0i6RElATikT3wKhIE37x8396GATXsNsb4Qg/Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Y5iQq5AlfaXHODFJbhwAtwyWEbdQAvsaddyAJxEonM=;
 b=jwitmADPuNkLkW3x/2rMDfbRSAw1XbRRTJAv9dGtTnKLzJfBaoraXg5B2DvmnAOuaNPRDGFsYKn38KcRAnHgi84NznWsUz8AF2gLWQObA2j4yxvThRkmwwjKF7LZTvdZPbOslO9IKp5pwxp8Al8TwfUpldxZAlHp4d0lhQ59LgGi/E5DFtKFSF7u2bXJf2lRUCIt5c0UddJj7oXBS/i70RzieAqrM9YKY3ATBsRq3qDjTlMbrFayDw2EFFWrpoJtbftE3HnBVujVLMjArvi4F/ul0Uijdk7BTIV7Hnqy1+y/PYuDOl9ZF+dMh33kxvt6BDi/9cYmt2hgKb99klAnVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Y5iQq5AlfaXHODFJbhwAtwyWEbdQAvsaddyAJxEonM=;
 b=L8nOAh90ItiNOAf5/k5UbUsWTPKam+pyqN4xRgYLMc7bGsy3vV1GeqlrHih6OgGlkNGOOqV8CBuPqskhJTU16nUW/vBJEjhJqjkByA8lwroUoRxguBLWtatzw5uggdT8675kQTQzQYO2MVCQJxWFcA+V50pfQXEM+l1NfWwRiAA=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA1PR10MB7485.namprd10.prod.outlook.com (2603:10b6:208:451::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Fri, 26 Jul
 2024 20:21:57 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 20:21:57 +0000
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
Subject: [PATCH v6 09/10] arm64: support cpuidle-haltpoll
Date: Fri, 26 Jul 2024 13:21:33 -0700
Message-Id: <20240726202134.627514-7-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240726202134.627514-1-ankur.a.arora@oracle.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0133.namprd04.prod.outlook.com
 (2603:10b6:303:84::18) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA1PR10MB7485:EE_
X-MS-Office365-Filtering-Correlation-Id: 6eca1415-992e-4c09-e687-08dcadb09908
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VVedSUvFUOFwTfPZfK5YY9gvuZl6iOi9QcGwrvdkdni9OAgpUMNSH6WwFoAZ?=
 =?us-ascii?Q?REGL9i6X5R/Q1UUoNhYaxBv5y10uFlIPj5Dvr0mJrA8d89OuU5mpLbP33dWV?=
 =?us-ascii?Q?W+AXYHPsLJkOQ1hH9tbB/ddrXyrYxWbGBBYPxeLY50pjUIgB4Cy7TxOO8PHM?=
 =?us-ascii?Q?K83oMwd6zU11D89z57Z2jq4RZ5xVtx8TR96KyCVzCM4qL2hlT3hWMTmvuoKR?=
 =?us-ascii?Q?4fRGhSVyeINLdr97pRIpGSYz9f8ObrLVJphxxZQrt32GSf/dh+1UWPrmDenM?=
 =?us-ascii?Q?nb9tURc8kRI/S/JIquFEMEmHSQ9SVbuHz3K016Mbn2pKGkslnDtzKna2iSxQ?=
 =?us-ascii?Q?cz9Ay3C9u2v1GXOnCba/Jh9jllJFNxb9ZYXcyDh+nQPmKfr6SZjzQSk32aJz?=
 =?us-ascii?Q?epZkxoAO2RrQ3bty41U3hrmAVkzW/BiKzyE6FcVFUSTByhBcL0EjiqJjUcbP?=
 =?us-ascii?Q?htioYyuAk8JsPfHZUdV8FdpKkUiGjvthj6Q24TSEijcnIRC8iPI9aY6VbhUe?=
 =?us-ascii?Q?eGx+9XFR6HYRSsd24wC1TPDJ0NL8LFc9lL32cKYBRtNV3gq/E+ExnqoHBL27?=
 =?us-ascii?Q?p8tKIHiAIDIsTdPrnyrUzdhtpLjdcLnnOkGlle9yZkerLRzXKTsk7r55sFVT?=
 =?us-ascii?Q?zq9fQRo5iMG9MKmTjwiSrcqwvRip3yGlHHVGSQ7LCUr2JQjtg/dW2FY5RfsP?=
 =?us-ascii?Q?2BajLX9DuCVAIUhB8cboMsI+bCdpqK+L8hDjsRJx8+Gi9fOZF0zIBSsdPBhJ?=
 =?us-ascii?Q?TwmlsbK9RU/9plqIvmR5jl3EJbh+dMQkGKBPybXEYIJ2EgWBVTZF7gfVb6pE?=
 =?us-ascii?Q?NG2KAtFWQnm+yqKMEg9yUCSDV7lRBdz7D/ftDbf5SpKJEC2ldpR4K0CDGgRW?=
 =?us-ascii?Q?K/HNuIoAadaUIMn6XWERItpIjsW8ij6cMM5NdtBB/qIrOoGxhrVgiDyTCrij?=
 =?us-ascii?Q?uFufHIu0k2h+Ru77iLKLlfsSW9i1TB47BYfDA/l4Ql2rDnTos9By+GdsqiYT?=
 =?us-ascii?Q?4mHdAHKAacc6U9QkODBeC5JbJnuk7wudHu+f4U0p1ME8s9F/TxS1fnzJvRHf?=
 =?us-ascii?Q?pJLpTQtTr2XfoF11pUYGxOJIm3KmYUwYMoq9XH9kyiGc9oc/EP+u/vxnpJt+?=
 =?us-ascii?Q?sPmpqtmkktzAOFUaZIOdG+pSDHRhqKfOd6/mPDHFFPbpijjCkzfKBTjHDuqJ?=
 =?us-ascii?Q?vkmFQgUZjpgauuErkPTQO8CxQDSuY9vANLnwgDm+Q5omy6gnK9JDfmN2n81t?=
 =?us-ascii?Q?usG0noyWfLvtJLR7nIBS9ffBe8zfifa0aOeVa//7jiXeFGZNX+v/S1sK3Pdn?=
 =?us-ascii?Q?vVyL4rBw1Mme4nprRwWLZti1mQ9j6A7Y/GShbL3V8yZ05g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4uGGjfQB+7jqx5B31Gu8n0WYjnEim4NsZjEiIlLyBGOreCX+zVu7d5CsECvJ?=
 =?us-ascii?Q?fw2fIOgEc/gkGilq6vpOFQKJXrnVae3vTGZy3BQrjhTcibQTsPCzwy8QMsIZ?=
 =?us-ascii?Q?9KtpycCWM529E8VlRSHBiiLHxKBlGMP3bbFctA+zkCxjUSz0BowbzFIZE8EE?=
 =?us-ascii?Q?97XRsy6+Fl6lFxKC/oceHfIEwqeqlz7XqlvI4+gJ9NZAWL5MVzvE2dnGzsC1?=
 =?us-ascii?Q?mAP/QFwGv/JMi4d9T1jO4js4k6bcaElLQN8bouFdSeLHcASNLe9iLvRxv6ES?=
 =?us-ascii?Q?SKy7E4pstyGQbVwH656TMCa6Hqynr3DdKsbIUfuiKj3eeuuNWbgYXgQXCCw0?=
 =?us-ascii?Q?pAXGTPS+DAmXc4myt5Z2vDhBMpedBfSz4noHBIESiiszcr41849ydckn3yE0?=
 =?us-ascii?Q?YZaeineOOzzBxdunYubiST5tcZ22gzMYurbeWKayE+EPNW9WGGp5kt0Qczbr?=
 =?us-ascii?Q?nQj1WXlPZ3lGHGnoR/VAE3PI0BjPecWgUFmOZiZsw/8NsSiJeEe5RsYT05dE?=
 =?us-ascii?Q?dV4M1MRD46aC9A71lv/YRWjHs6wML4fUFjp4JvMrIVQDUMcRnbM49lDS5PbY?=
 =?us-ascii?Q?z5PcATTWrDeN1pXvAmkd+lzHdLKkGtxT01vCS9XdistbQ6Tbdp6HQpRjx6ds?=
 =?us-ascii?Q?268Km+BoZWPthbgl/6UguyiWOy3R6VzMUc8P7v5AyvMKplDmRhfBxgwoW3Be?=
 =?us-ascii?Q?RMVUQGoTUJtsvtXkG+zTpAShfkSyluQTH4X7XgjgcGrW84aVHi65guD1Ti4S?=
 =?us-ascii?Q?iHrfAx9UuIXvN7dN/8/H9Rf5VZm0laxsFZIEViKkruYfZWFYUDDeOgm6Ij1c?=
 =?us-ascii?Q?B4svaXn6c+9+DtCPgvx0l7CXnBVhl7ya3lkDNdhJNqQZsAAm9FB4/NTFC8hZ?=
 =?us-ascii?Q?ZdSLDlv7LwILdldHsHe42a5xKRB/PHe7njjXzDILNEWkkR3iSdfYybMslV1+?=
 =?us-ascii?Q?HhBzv8YgAzraZ3iPjkuz97Dr68bPDYBK6qUOAMsb97hldh5RCt+r33U3653d?=
 =?us-ascii?Q?3MyWO+z6TB+kVHKdkNIxNfC+83c466hJQzyuORgThbxTBHa8m4YSpZAfwHuu?=
 =?us-ascii?Q?0ZIrUwvMvQeXlQpcakYPKROXTuj7LQGD+gsk2g0IA10P0FUcJwgZTDXQ0Oy8?=
 =?us-ascii?Q?3YWkM+1ig2OZlpNv4D0rQvAx12VbROZOlQ07uUWVlw5/MzKIWuxRVuDD6LdC?=
 =?us-ascii?Q?25+oxqIw9ItyJVQTB7AuMJ7WDTbLzaWGtEtMiXnJGSJPNQ4hvWRc2HLrZqMG?=
 =?us-ascii?Q?IHRcrFUfOl2PSxCa0JrhCrGOz4wVagqoXvVyRrR3jU+7Qs2v58PPpwmKfQbE?=
 =?us-ascii?Q?bVF335aPqGnbfRea9SCQwFweSaMzPJnNZFmfgR3Uc6v8L1tM4nHcLkG8GIDw?=
 =?us-ascii?Q?U0VmEJdLBYYWKvKgxd/kQQ1HyffmkhD+nI+l+GJxGWg82DAO49PeBaitWDyN?=
 =?us-ascii?Q?zFypSo255sqetVr6QJEm1DTHjyCiA4glRjVaxzQaJLid0yaPz+tWWSaujKSG?=
 =?us-ascii?Q?nuOXjO9wEEEhINoNbKAVkXQchcGyengnahlEOlXMaQVc7UNEx0nEb1mf4Zm8?=
 =?us-ascii?Q?5eQlAw0vSh9uKtqAr5mIZlJ8w90uW7I5sQeFs3wsE6WOnaQy0edMd8Y1WLCo?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CYOpyjInU6zrLpoZ/CaJOw/SEfxdYf5FwlzK9dy5kGjPLZP0tYV4azuiG7jBKSgRf8MxCgsPKSqggINHHYfrlPJVSe9bvSlSHIgrYghW5oB5e84gzHqljRAwcIFG4l3VQrSLJJbTTQbGBEswhzQBWH9HAuHwcSfb+I2ZBRrgkG88bmiF4gSr9bshmCfSwPWHoUOrTujGv7j7lrkxf/VtXqS2qJ6J7TBGppSQ4cjZyYTOWbm2FxeQjy+AVaU+ndZ+NsDQ8kStQa0GFFdJ5i57g/dSgq6f6p96M+AfhwvyLmM4KtWQ53NgVr//oARNgnMthh7EhFUki3Soapw5pjEjINlNilqpclQInLLcXmOJvAC9aFnbE9sxqTrhhhTneS93IijQFsfZuGqmvPR5YA+sHp3qKPAGECFvpvQX8jhpqWQ+HirlSzlv2JocUOjrxg4u3sVcVrXdD6ejSU1Iep1DZRtDv9NVwGH55KWIY7aaxnpnP2TtP1KHNaQxPCktF3AbV5/FkHFcawbW3G5TXTCUgeyRiXTaZ3FMKi2tQUNE7b9elrxvBFx6t7eyWKTmNTb/ndR2zZFXUa+nGcGgAcmXfN9EEe6pSUpqRm0umj8tq6o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eca1415-992e-4c09-e687-08dcadb09908
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 20:21:57.4669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bqCinqdqOxU3cAlWs5s2VaDOqVt5zVmyCqlqo5MQ1mMOYmMhKgw1xNMkXGgiCzkr8JlbDtYKrSGhlYrSiLqvDY3TQwvYUt1+RMklz94F+94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7485
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_12,2024-07-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407260138
X-Proofpoint-ORIG-GUID: r3VMDMiEYHbrCo8naZXvtr6jsELcjEH7
X-Proofpoint-GUID: r3VMDMiEYHbrCo8naZXvtr6jsELcjEH7

Add architectural support for cpuidle-haltpoll driver by defining
arch_haltpoll_*().

Also define ARCH_CPUIDLE_HALTPOLL to allow cpuidle-haltpoll to be
selected, and given that we have an optimized polling mechanism
in smp_cond_load*(), select ARCH_HAS_OPTIMIZED_POLL.

smp_cond_load*() are implemented via LDXR, WFE, with LDXR loading
a memory region in exclusive state and the WFE waiting for any
stores to it.

In the edge case -- no CPU stores to the waited region and there's no
interrupt -- the event-stream will provide the terminating condition
ensuring we don't wait forever, but because the event-stream runs at
a fixed frequency (configured at 10kHz) we might spend more time in
the polling stage than specified by cpuidle_poll_time().

This would only happen in the last iteration, since overshooting the
poll_limit means the governor moves out of the polling stage.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/arm64/Kconfig                        | 10 ++++++++++
 arch/arm64/include/asm/cpuidle_haltpoll.h |  9 +++++++++
 arch/arm64/kernel/cpuidle.c               | 23 +++++++++++++++++++++++
 3 files changed, 42 insertions(+)
 create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 5d91259ee7b5..cf1c6681eb0a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -35,6 +35,7 @@ config ARM64
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	select ARCH_HAS_OPTIMIZED_POLL
 	select ARCH_HAS_PTE_DEVMAP
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_HW_PTE_YOUNG
@@ -2376,6 +2377,15 @@ config ARCH_HIBERNATION_HEADER
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 
+config ARCH_CPUIDLE_HALTPOLL
+	bool "Enable selection of the cpuidle-haltpoll driver"
+	default n
+	help
+	  cpuidle-haltpoll allows for adaptive polling based on
+	  current load before entering the idle state.
+
+	  Some virtualized workloads benefit from using it.
+
 endmenu # "Power management options"
 
 menu "CPU Power Management"
diff --git a/arch/arm64/include/asm/cpuidle_haltpoll.h b/arch/arm64/include/asm/cpuidle_haltpoll.h
new file mode 100644
index 000000000000..65f289407a6c
--- /dev/null
+++ b/arch/arm64/include/asm/cpuidle_haltpoll.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ARCH_HALTPOLL_H
+#define _ARCH_HALTPOLL_H
+
+static inline void arch_haltpoll_enable(unsigned int cpu) { }
+static inline void arch_haltpoll_disable(unsigned int cpu) { }
+
+bool arch_haltpoll_want(bool force);
+#endif
diff --git a/arch/arm64/kernel/cpuidle.c b/arch/arm64/kernel/cpuidle.c
index f372295207fb..334df82a0eac 100644
--- a/arch/arm64/kernel/cpuidle.c
+++ b/arch/arm64/kernel/cpuidle.c
@@ -72,3 +72,26 @@ __cpuidle int acpi_processor_ffh_lpi_enter(struct acpi_lpi_state *lpi)
 					     lpi->index, state);
 }
 #endif
+
+#if IS_ENABLED(CONFIG_HALTPOLL_CPUIDLE)
+
+#include <asm/cpuidle_haltpoll.h>
+
+bool arch_haltpoll_want(bool force)
+{
+	/*
+	 * Enabling haltpoll requires two things:
+	 *
+	 * - Event stream support to provide a terminating condition to the
+	 *   WFE in the poll loop.
+	 *
+	 * - KVM support for arch_haltpoll_enable(), arch_haltpoll_enable().
+	 *
+	 * Given that the second is missing, allow haltpoll to only be force
+	 * loaded.
+	 */
+	return (arch_timer_evtstrm_available() && false) || force;
+}
+
+EXPORT_SYMBOL_GPL(arch_haltpoll_want);
+#endif
-- 
2.43.5


