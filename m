Return-Path: <kvm+bounces-29449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B94009AB94A
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 00:02:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74515284CE4
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 22:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0EE61CDA02;
	Tue, 22 Oct 2024 22:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jc2dTkXl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xBqyYlIm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424C4136E21;
	Tue, 22 Oct 2024 22:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729634553; cv=fail; b=PvAtjA+S6H1Bj9J8XxOS+P6PQgrt9ijbrGmHuxZyNd2O7rznn3VteOkIwrAymn8atgvP8GzuDYdgupD/7ExY2f+7vebfzqgRsGmOjwcnofto4+VNvuRGdJvRO6eKbaSpYfbgSFItrNB9W3e1GY2TxaME/R1pf83+Thi3kHrYLHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729634553; c=relaxed/simple;
	bh=YplnEC50SctACTvQFa27dJ1Qz+EeLT2RTfKKv7yvum4=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=Fwc39T4PwqjU6k786WmyRdGcETcOhPpejiB6moa+j8YuyE2wpmoSos7HYLXILs9Tu+H5XeELQzd9MhwAI4S0DKJmynI45GExYlAkId61Fja1L3loA1Mm5ReFE44OSVP+VsWNxRpxA7aM1gemelJW5VrAO7CNrfV4qjSCoKNPCS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Jc2dTkXl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xBqyYlIm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49MLQdns026257;
	Tue, 22 Oct 2024 22:01:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=qiETNU/aOnJqbrljgN
	NriLexfZ7GDOgVZa9miK3MfFg=; b=Jc2dTkXl/W7Zh9AoTlXMaZwI/CNCiu2cC4
	n+swhrIQpWhFrJvB3TyC8/nV14Ntk8W0pZRqPBgomQ6cgrwMk95lswoTgYnpbFha
	NKZYpnHbsNSgtLixfSutaSfq+cDVe1JBfkbeKrzos+piQD+jSTm9xlpa0E8v7gVw
	tuzOtnGNOSqJqNHjk3FZ7u3IPbZBwRXoIcfumd6FhSeEeqDyfwMg5kNO+3wiE21X
	MZTLHf2glvvHggAu3+res58xLyQI9VDfmakqjmVZ6bH3C8jtEmfX7enHhoFRZh+/
	wO69ojRO/dgSW+sG7mjQU78TeY9obKWYCobeLORId0jcIzOgWnYA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c57qesys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 22:01:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49MKC2dk023309;
	Tue, 22 Oct 2024 22:01:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2047.outbound.protection.outlook.com [104.47.58.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42c8ew5psy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 22:01:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wkgpK8myc5C5XvgVLHEVtfOZWTV0/Jyqqwi423ehNZnS/HtimLMUSeYKWw2Cum5ZMZdf0dULC+5ccS6TjyKHrHHJWSviNUvM8gBAh47zmhkNNL7d53AjHSiMI1pESyC+kOJG3eHIwuzWHe4i3p1kF8duDZDPWjcdPr6EaZ891My1kitDhBPhjUdC7ibk+CONyj0kJm/j9r82FC9lcbcAhUbSqxOHRxdnvikA0AAyWn76+kXC6tGOPP+mz4de3fbG11Wl8icNxLXHG6vHchUkK027UJXU8CV9YQ62NgLtWS5GLc1hhXf6vm5rX5axv3xO+RDO4EkjweJ75sNFXHiIFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qiETNU/aOnJqbrljgNNriLexfZ7GDOgVZa9miK3MfFg=;
 b=w9ND8Q7QegToCpt6tQsRWz5G3zBr8I1TozrvJgoPlZQowX8HQsVMbPk5nqavqCLlERNVh9DEetFYtcz0bVtBdP0qEdVegD5lwHmZLbDpxLnlufrT4m43nomV7kwBg1cN/2aLhJKQae1PuGd/Woa2J/GWGHMicG/6U05jcMN1DZJIFMBnXHMQ6LY332JnH9FswF8xU6ehYE1DLqxpvlYOGmukSFu1nzN+fEg3KwDT06fz5xtmkAYf2mxwjsKZbw+XzlQZUDzktqxQpAjYWBxRnsXp+7Q5LD8vtDb3zMPfq+0EQVxq99RXtojnGfrbvA2skroZuvnHJd9O7UrQPmhHog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qiETNU/aOnJqbrljgNNriLexfZ7GDOgVZa9miK3MfFg=;
 b=xBqyYlIm9JMLRDue4ZDhZHP1+ZLc0J6e7amN0hyF6GALm1vOapXXOfXdBfwRDTPT3HyMNJzShyPcBpP4GpcR0gDKPxhmumJOQOSjx/Mtrhw23DSoMi3Sp5CFo2/dnJeJRIS1NzFoz1CcrBdnaj8dxHXyyW5G2dt18Etz1Pb3W0w=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CYXPR10MB7900.namprd10.prod.outlook.com (2603:10b6:930:d7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 22:01:06 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.8069.024; Tue, 22 Oct 2024
 22:01:06 +0000
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <8634kx5yqd.wl-maz@kernel.org> <87plnzpvb6.fsf@oracle.com>
 <86sesv3zvf.wl-maz@kernel.org> <874j5apofp.fsf@oracle.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: Marc Zyngier <maz@kernel.org>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com,
        cl@gentwo.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v8 00/11] Enable haltpoll on arm64
In-reply-to: <874j5apofp.fsf@oracle.com>
Date: Tue, 22 Oct 2024 15:01:03 -0700
Message-ID: <877c9zhk68.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0062.namprd05.prod.outlook.com
 (2603:10b6:a03:74::39) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CYXPR10MB7900:EE_
X-MS-Office365-Filtering-Correlation-Id: 98c397dd-20a9-405f-eae5-08dcf2e5065e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+h83LSbRJE7n/6sl154hr+OvcZAzWZhUN2y6CYHbIZt3w26kwFpeSbCyd6Af?=
 =?us-ascii?Q?nXLlQweXOZRRaWpthNu9Q8CfyCnTxqPJmMWYT1YMPv6Y16SyNzW+N/SD+Yla?=
 =?us-ascii?Q?ECAnluYg5wR1PjeG9BOcNkxr8ooCfuPJfEmlePrHAsfdHHxZ84qtM6RDzmve?=
 =?us-ascii?Q?QHR/H8e8iYaA+84Dtk7P5GEsLs+YlUqtKPc9cs8oVt3WFux13H8ASyoGgcod?=
 =?us-ascii?Q?ixitQe5hul4uCAbXLZJ+hdMSIJqqQ/ZE7jFwIbKhLI3+XsnqgM2znzY5tOPz?=
 =?us-ascii?Q?xqhuCP3gT81hYdWGvG6lx0ozW6tQM/IniJp7YyFcOI6DGaRMo9xv9d+Pxsyj?=
 =?us-ascii?Q?04IAVMZvVxra3ymPC62TLIU7XnJhYG1F2GH4fUU+tXqYEYQE18rkdXG+Kq0c?=
 =?us-ascii?Q?dTOKheKNWmWb8y00X6BpsdMudGE2sOfPXCuyY/09o+EsTXEoInUWMvhtxqy0?=
 =?us-ascii?Q?sxJJ/k3JAPniNRX0h/X9yqostXdsSQNC0T0StQIzmwuNYjDsqFQQV76g3/d+?=
 =?us-ascii?Q?xgZ92CRfsOcq1ae3wj5Ko8osD0MmdLxhgel++/5MgGAKDm3kLp/w/7G66Ioc?=
 =?us-ascii?Q?eDn/44u6wAdTZjJ1LEpXkOO3Iid4Enw4/B1TPXCh9N2PfVaQ61H93yrFuAqe?=
 =?us-ascii?Q?N+iLwwnMB/+8xGtDv0nwMJTQ3WA4ZVNqubffqpReHxbAHh9DePyinFG3ZdSs?=
 =?us-ascii?Q?AjEJaRtx8LOC99YMRBBXIvuf/eF25T/HdtqZNtDGvmE2wYdFM1YPnJ4JxsEV?=
 =?us-ascii?Q?AxCLROxpBvZk0PRbY9KlAJVSFIQ+s2eyDta3K88/UnKwjkqucMS7IjOPHUDY?=
 =?us-ascii?Q?m84O0CE5wZN+wXMKPFMY6DgqWkc5aOAO6die4sKbJVKNCPgCYOJOdMypuyB1?=
 =?us-ascii?Q?T/z1ypPpQMdBv76Pk0iibYeXjOVd/1EJW1yEyhG8lQpsoK3e0frHH+IATU4u?=
 =?us-ascii?Q?Mr2NJY94lzDcKYwRi+ra4+EBt1BGqzegz2kFaoTy4IwLxvv1xR9aE2BdaHaK?=
 =?us-ascii?Q?7nFuRVn5aHC9wjtRiU8MbxbEG0JCe2tcZ8zPaZ/YutWznPN1Toa3X8KUXF+F?=
 =?us-ascii?Q?+U6gYd0H82gOrpyhcJaky3AreRJAVwSy8mPWXCf7fDLv3mptoiyGESjqKrEo?=
 =?us-ascii?Q?Cx60shNXwy7o13EX8obKc06+3yNdiUuJu8TxQVwj2abBfuAiJLY8NnoJFx3x?=
 =?us-ascii?Q?69bymAKu5tXSjjkaE1UqCBrtFKcilmd8Az+90PiqxXley7BiwYVMX5cdfwUt?=
 =?us-ascii?Q?9FfhOINXGdq1m3jn3laDtH4U2xgbPL1F1Cn/ahNNkpJsUasgIhNMcsPrSg1g?=
 =?us-ascii?Q?F2Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?t7ZevnEIxIQVOpg32ZPoMZ+ixasw5IZm1DDJOzYH9PYitFLIooGnovg/5X2R?=
 =?us-ascii?Q?IqEYmJo+t7rHo3LDC9ICEYtDkNejvwi7NvxoBrTP54Y4pJ/RKAN7DFPGquEb?=
 =?us-ascii?Q?DJlyqQoTBfICWz49eKVKG1auhZF8UR30LjvQEv/pkS7BFTOfLrMUU+O3d6xS?=
 =?us-ascii?Q?zHMaj+4jnF0Mxi0qSksKrVvXW/pQNrbcPAvLsGPXTV7lPxh24xKGZKlYLs70?=
 =?us-ascii?Q?rJyx5b4jDEO5UhyvMylPqcFdz4L2SjAA5pXD0o2gtUQ1oNPvZBgSlr1NfAId?=
 =?us-ascii?Q?dsVnyNJbJq7mXTfxdQ3iX2nj7hyy04Ep4rBSor7FPXmcgeAItf9mxDAkHf85?=
 =?us-ascii?Q?gQH6DQBlbgDfh65YuxwELs4CMM0HG8oogCGPQaAFkb3dV3z7ePLPN5fLfxzT?=
 =?us-ascii?Q?C1/w6FOtRyjUIyCYt3tozzFMy9TzpLlrSaDm5qrajdnIGIJYCMP1YSYxqtdP?=
 =?us-ascii?Q?buRosoZSQI72FYSplhSbSxXypS6FVCIa3+dONB/hHNk/SKm7ZJM6IboRa/1b?=
 =?us-ascii?Q?+HY6cN31f8+lAK56gk/9/lEMbtLKXAZM+vYFH9kdA2zdeMfsAmkxkqtnXVZa?=
 =?us-ascii?Q?LV0AD9gYuHAXegmVcbTVF9eNU6pxW85HVl2dyDvBznZaiJHA6QMB0t1Z4SHX?=
 =?us-ascii?Q?0/ZCAjuWdSx5khSeZua8upuSs9qcYREXgj5yAQIcsl2kC++03gG0Jbd3Lvu9?=
 =?us-ascii?Q?CUJWmxPpj6A5l44OaoIQ7h2jbnyuYiZ0Qm3N+6iNlSCRAPkDz35ZM2KEjoa5?=
 =?us-ascii?Q?qyho5IYyexFBghFr6QGMUzXZJ13S2PL0yNguPu/uJdtpLx49N1DFrd8Sgdrc?=
 =?us-ascii?Q?bgip9b2YdvR5qTygErWP1R09ZIR7lA4e6wEpoX17mJw4zVpLaYogCjLjaKyd?=
 =?us-ascii?Q?RhjpSHhyLkzkWK67rbIye4fNFxmcucm6CMvcY/jrk7rjHpUue1p5fUUP4uED?=
 =?us-ascii?Q?xNDx+0AKFyZlq9oTMSgIMFodo4iCfdDhORj6+NDZXz9ddas3dFmo1VzxFfSd?=
 =?us-ascii?Q?j150r6uAwLTfcgeLrud079iJeeKn/zNtwyANnfRKVWx8LNt3Ce98gSWcWjks?=
 =?us-ascii?Q?iVwEFovgpHZQsygwcbN/T26kjppaxcBzUzMTu6kdtRd5rm4rxw+bNOIzl7WW?=
 =?us-ascii?Q?hQT0Z91dr6SEejsAWgAMF3IiXoytoK0SK6XPDbK7KSoeX7FNEmEx4fedWj+g?=
 =?us-ascii?Q?5ScJiGZeUrjr2tuhmisEVMHhqwmv77SVV9UU/WVUjoeyNq5FU3iWRanIRrOJ?=
 =?us-ascii?Q?rv2/+i6bfjc/b4OiX9YelqM0BQfoDdKKFs5ZYqxx6cFVzSMt/AoPoUx6zlDy?=
 =?us-ascii?Q?f3d/rZhFDgmsTsVoi+Og5y2RwcJnQMjYZZIf2DbguqPFVQUMrFTc//yrkNtq?=
 =?us-ascii?Q?gw3OGdoOj0UkPgqRmuW1hGmap+pJoTQDvhKz1PL8aM1vHYXKCyb7nnJR+bdo?=
 =?us-ascii?Q?zHqKvEb/jo3QhMGZUj/Ha4JWfv/pnd/E2uR0c5ElOygdOgw9/ct+KNR8Psaw?=
 =?us-ascii?Q?pie1IkZ1rWd39CdOZ/Jzekz5jV7wZEIa+u69h6R3nj67kiesojQmTysEkLcB?=
 =?us-ascii?Q?XTPwNeePWPa0HfhJTXuoQPJMCoBzUNcBnqM9mEP/wtOzew/iPVEQprzZpFb5?=
 =?us-ascii?Q?Zw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LqJ9H55+HTMMPTQX2kxnwJf9xJ1snrYCf11a7/mRLvmUnEdqFaa6DGcJpAxnRAm5QUW6TjQnrzdnUFaUJS3TAmv/KToV/WTXhwZuMum/UDEA6cekaN7wM7MGMdIgYPjSZ1qMSUeJvJHafZaxtM0I23B+t7FzQjF8UzKUVIv27celSUzIjB/E540KXeIJs9+beoKJYcmxql4E+sr3yvFdM/gn1GCNlQhzhJOH00qFCDVX1Om2IkE/EAPGhUqz3JGKJpT85dA7+773qlPYQbAvSv2S4rLsbQHusaKCnrnHx2o7fkfOqgl0zNROwpCoPmgQTOnqaK/THEezJb5V8jUkDuB+poPLaN1wOBx5DuviUfe75RXecnXY52zMekAOpTjTcKU/cE5j94ak2lp5fRYD3cREcQ8RwsQdNZYOxnVUTDrjTct1GN0a82d/uwlGsB18lHHfTCj54fdXzElJf9DD/QPLafLyho+fOJsHDvUoI2Pc1ZiU/x03aYkGYzKLsOmm87TbNRRphd8Dw54wRy9TX3y08Km8HXWojdFZI8EQpylTM+K8VEV/n3jcFSLnmfOw2F5LyXWFHLYIdEtSsljy9ali5ebNPqHn2YhKU4c95+A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98c397dd-20a9-405f-eae5-08dcf2e5065e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 22:01:05.0572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rhD0i0RYrVLUkKVW2dEHLyc+8ONmrGPy/Zq1pZZQovaNdxa/ItDgmC20pcR2mLeke3CU+qkIQNE8dvPq0HnA2YjRtb52FCAj1eqJm41xRkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7900
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-22_23,2024-10-22_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410220142
X-Proofpoint-ORIG-GUID: UjtUjG4iZ6YgSRbV8IliHeaRdItEjRSd
X-Proofpoint-GUID: UjtUjG4iZ6YgSRbV8IliHeaRdItEjRSd


Ankur Arora <ankur.a.arora@oracle.com> writes:

> Marc Zyngier <maz@kernel.org> writes:
>
>> On Wed, 16 Oct 2024 22:55:09 +0100,
>> Ankur Arora <ankur.a.arora@oracle.com> wrote:
>>>
>>>
>>> Marc Zyngier <maz@kernel.org> writes:
>>>
>>> > On Thu, 26 Sep 2024 00:24:14 +0100,
>>> > Ankur Arora <ankur.a.arora@oracle.com> wrote:
>>> >>
>>> >> This patchset enables the cpuidle-haltpoll driver and its namesake
>>> >> governor on arm64. This is specifically interesting for KVM guests by
>>> >> reducing IPC latencies.
>>> >>
>>> >> Comparing idle switching latencies on an arm64 KVM guest with
>>> >> perf bench sched pipe:
>>> >>
>>> >>                                      usecs/op       %stdev
>>> >>
>>> >>   no haltpoll (baseline)               13.48       +-  5.19%
>>> >>   with haltpoll                         6.84       +- 22.07%
>>> >>
>>> >>
>>> >> No change in performance for a similar test on x86:
>>> >>
>>> >>                                      usecs/op        %stdev
>>> >>
>>> >>   haltpoll w/ cpu_relax() (baseline)     4.75      +-  1.76%
>>> >>   haltpoll w/ smp_cond_load_relaxed()    4.78      +-  2.31%
>>> >>
>>> >> Both sets of tests were on otherwise idle systems with guest VCPUs
>>> >> pinned to specific PCPUs. One reason for the higher stdev on arm64
>>> >> is that trapping of the WFE instruction by the host KVM is contingent
>>> >> on the number of tasks on the runqueue.
>>> >
>>> > Sorry to state the obvious, but if that's the variable trapping of
>>> > WFI/WFE is the cause of your trouble, why don't you simply turn it off
>>> > (see 0b5afe05377d for the details)? Given that you pin your vcpus to
>>> > physical CPUs, there is no need for any trapping.
>>>
>>> Good point. Thanks. That should help reduce the guessing games around
>>> the variance in these tests.
>>
>> I'd be interested to find out whether there is still some benefit in
>> this series once you disable the WFx trapping heuristics.
>
> The benefit of polling in idle is more than just avoiding the cost of
> trapping and re-entering. The other benefit is that remote wakeups
> can now be done just by setting need-resched, instead of sending an
> IPI, and incurring the cost of handling the interrupt on the receiver
> side.
>
> But let me get you some numbers with that.

So, I ran the sched-pipe test with processes on VCPUs 4 and 5 with
kvm-arm.wfi_trap_policy=notrap.

# perf stat -r 5 --cpu 4,5 -e task-clock,cycles,instructions,sched:sched_wake_idle_without_ipi \
  perf bench sched pipe -l 1000000 -c 4

# No haltpoll (and, no TIF_POLLING_NRFLAG):

 Performance counter stats for 'CPU(s) 4,5' (5 runs):

         25,229.57 msec task-clock                       #    2.000 CPUs utilized               ( +-  7.75% )
    45,821,250,284      cycles                           #    1.816 GHz                         ( +- 10.07% )
    26,557,496,665      instructions                     #    0.58  insn per cycle              ( +-  0.21% )
                 0      sched:sched_wake_idle_without_ipi #    0.000 /sec

            12.615 +- 0.977 seconds time elapsed  ( +-  7.75% )


# Haltpoll:

 Performance counter stats for 'CPU(s) 4,5' (5 runs):

         15,131.58 msec task-clock                       #    2.000 CPUs utilized               ( +- 10.00% )
    34,158,188,839      cycles                           #    2.257 GHz                         ( +-  6.91% )
    20,824,950,916      instructions                     #    0.61  insn per cycle              ( +-  0.09% )
         1,983,822      sched:sched_wake_idle_without_ipi #  131.105 K/sec                       ( +-  0.78% )

             7.566 +- 0.756 seconds time elapsed  ( +- 10.00% )

We get a decent boost just because we are executing ~20% fewer
instructions. Not sure how the cpu frequency scaling works in a
VM but we also run at a higher frequency.

--
ankur

