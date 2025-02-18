Return-Path: <kvm+bounces-38491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 080A2A3AB17
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:36:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C05AC188E03C
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B8C41D5AAE;
	Tue, 18 Feb 2025 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="V9pFlj9s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UQHOZ1Gq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86CC11DD88F;
	Tue, 18 Feb 2025 21:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739914468; cv=fail; b=f+TwBknN33uJYB5zaUCChnT8Ij74tmIPpA/V7u86V4MiyE3V8HzwkhZiGWo8FRtxxNnrjUtIRzew9u7tM/jb4XnpTlIu82yyrwJrQk12o5pE3jTTrlg5ga4Dt+JotIyxwGdGsZ34gRwgRB5fg9+/ca+c4MVbYEj4gnGOy9R/iH8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739914468; c=relaxed/simple;
	bh=xg/rM5g1sCS5WGCAWBAfdy5os/KEQrgB/DFEuYtLpOc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AkHHzWPYqFCex1bWzQkT3pC7TrEO9Vr++prY0yDpYuvf1gClgIn7ER4bs0BKM2z2RhqsvBtPnDuCSsktqJ8LA7TlOKS8oAy4lusLnzOdx2KenC2lpzds3Xedqij4+7odP+uE5oZKmikCtBAGd646E+bl3n3lWac/00++W6b0aFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=V9pFlj9s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UQHOZ1Gq; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51ILMZad022656;
	Tue, 18 Feb 2025 21:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Lt0EosLm7JJhwTyzR2QyszGWOAYOzuTR259tKrpg690=; b=
	V9pFlj9snK9/78BVzfbGPQvg+7vj2M1U4Zn6Jz6WOa2nKU/f8r6bjALbWfHYWFM6
	YCK1PAjY+dzhwoPQPgxdHzOV3wuIbHa93tRp2S+DbrQPaV1pvBgY4EEgg12muxKL
	0UamZ5HB3tM4mHW/ncHOJsqrSN7ALXNWVhO2nAa81ZBFnbEWOtHvPQctAb/tjlRQ
	cDnUW5KXX6EKm/2l+3qV5uOUuVed7JWRAfbFhqOjGSunbAlSPCTa3CemTaDeofwk
	FbGf55RLbTJnr/VmtS4FieEqLP/zCVrnRqsPw+virPrsT35PmjNISllhUvEP4w/4
	Uuu4LV0j9YspBDPy36pBhQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00kgaaa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:34:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51IL6UrB009637;
	Tue, 18 Feb 2025 21:34:02 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w09bmx9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:34:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WB0RP2nwJbWI0Do32RZqmatmAK0wNu57mOME8u1AlGGZiOqEKm2upC3irUe4r5jTNF9Z0je8NBu+V6zPtMyek3tBzkX/I/TUFh1Lml7a9wzSGM8cChBDAaMpMfSxf2Md7ESuCicWN2P6c4A+VRlAGYH//IaN2E6kIIoS9R8AWxsQpj4cppO5ZfCW3xmAFUPFFdYgQ+ZuwN5ilR5MVYxC1sfb3bnIIYM2NFUo1dpFNCajjF1UWw9UfOWhJF2cT99c+EzkyVzFJrypzZqNbXKTV7y3Z2TXjCThW5Ym3SxqY9fQyXehJx5XuYgCI5sqY6Ij+mADsncuEpAxSx3DUp7LSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lt0EosLm7JJhwTyzR2QyszGWOAYOzuTR259tKrpg690=;
 b=JJ7zPiH8YmAMr2tfpqh6l2vfQjiiT9/vaJeebZrEZFJaRoeX2k4rigrMVeSJ//XBnLXRSX21OlYdRkzEBcUVO/NB2S9TISkH9msZUFUK2UJx2yDDMyZUTfaMJaP7NVqTETJMp/9AGM/r1Xz75vGDgSlNC+jkLuZquakWX5cwDwCSa+yEXB1ty4eISpfAfT3e9Ezuqse20SKoIcGWVLOCmF2Vy2J8QQLZZmmT1qVhG/8DKiEC0FTu2ljxTMgDcpF6OW9ExEBSjNhhVPLHl3QyPeYt8w0L16tJG0+C2CkfIjodpFlIkInhhZh/wChCpjmPLxoT3HIgoWphi4W/+o88gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lt0EosLm7JJhwTyzR2QyszGWOAYOzuTR259tKrpg690=;
 b=UQHOZ1GqFqCTkAPl6mhkdQv9ODSk0MIO4mVF3S6BXJ7tXQkkBE219+lsiVpydYck78yxqGXwEZwDH+mzy9t5eksNHXVc5jQ/JrTmo0ERwGnlIfZWZ/QvWxxR6teL+hiFigfb/jIB4pFBE/Fd7txfV6cV0umxuv6t5AgiVa+fMMQ=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA0PR10MB7275.namprd10.prod.outlook.com (2603:10b6:208:3de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Tue, 18 Feb
 2025 21:33:58 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%2]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 21:33:58 +0000
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
Subject: [PATCH v10 09/11] cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
Date: Tue, 18 Feb 2025 13:33:35 -0800
Message-Id: <20250218213337.377987-10-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250218213337.377987-1-ankur.a.arora@oracle.com>
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0066.namprd04.prod.outlook.com
 (2603:10b6:303:6b::11) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA0PR10MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: d4ce0371-2990-4347-8a8f-08dd5063f417
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AuWge/AS/7XEYpkIYMg+r/b4ztORt1a0VAgH/t+scxHSlJ4tSPHL5IxWC2wh?=
 =?us-ascii?Q?iYsJ16PFsuMURxD6jKdDdeim6rfaRxj8J2l2UpAMrkgorZh9T55l1RvMoEJg?=
 =?us-ascii?Q?yvN5LtRQ4W4kxu4fZqwmQLlauvCymEHLKKHh4qea9pxI8vkWGDJzQ8DzUAZN?=
 =?us-ascii?Q?XK9op+gsFlWkgOfB9xOkpcuw5nQmTIvMzYPYz4g9dt5vqOskcYt9M3e6A3zB?=
 =?us-ascii?Q?MWk0mr145Z0piZqFmkkSvZm+ZSILQjx262c7XMCM68MGo16oMgsolE/0LJ9y?=
 =?us-ascii?Q?RR3WxXQwGFX+wZkwAfAI/nYaJozTtrK4urK3Zcqp1sOAvDNPOdlHqtfEFHLm?=
 =?us-ascii?Q?DHX/0KnPxqSAIVCN+XvsIDJZWHOp4N++YlahLfbOauoEmq6/9axkTbnSap5q?=
 =?us-ascii?Q?iQd4Gu7Y0m+X4P9mXSD+wEVDrCNUDyvfGzQqq4+zo3FmK9YBZmkJilWP0seS?=
 =?us-ascii?Q?3tjlcgU2CTuxkJ8xYRtKog8YAwEbpFORrOtEPq4lqYo4gFYl1GpsG9oQACdk?=
 =?us-ascii?Q?SkZbDx2t1lp81vMIO2vpAbk4pVArwvD2u6IVhrOIS09SOfM3L9HsXGeHyedb?=
 =?us-ascii?Q?CXxAn1Lzc9Dn8pne0wSBmfhhz6/83rhPhLSPh4MVpGgXiQCIqOxIF+ovL/WL?=
 =?us-ascii?Q?IhNG7q1CWTPtL2uDA3qQztbNGKMMfq/6IMurnaTDCSQM4GozvFhy2PAsPZiq?=
 =?us-ascii?Q?wtOSZ3kIWJOZ97LbTdS4ylcQKGPLX+C1WXcTws/1Vfe5HX/zU6LabGRC85We?=
 =?us-ascii?Q?qtLct8kcc9xpe3EqFcZ0lJ9W53SRbajte9azE5TI2fXi35tb/zzKeM4vQkaa?=
 =?us-ascii?Q?gi5uNfGeXf/7UYNJA3bZAu3cDxw/88SOz/d+L90ZDIsiqHBtumMbD78ZQOiu?=
 =?us-ascii?Q?qlYh78yn6Lkc2vPrYv7tdIhg6d0LF8pt0f6UeTmnBWkXnGURsv2x7AtkwRE9?=
 =?us-ascii?Q?hd36v1U6/LRPio5XbFLLmnu5s4SKL12creLCqccdgveR9zxTQp3VdjeAiOv4?=
 =?us-ascii?Q?lOwbv4RVSRMufY2lgUIXKot8UgQi4ld0rPGPaPlYH1MdW/JGn5PK/hsUWwEw?=
 =?us-ascii?Q?nNPb3uVKkppTNpzk3kohpa8kih+V3P4MjUHlmtTbLRRS3dRbKuE2dAbZb6OO?=
 =?us-ascii?Q?AyibJsoUjnnwKtUiz4WqfJJsmTMB9/4CwvIzpieWyTpNZskvLXa4x65JKwqP?=
 =?us-ascii?Q?yxxduSQMpMRSrZ87afcbYDlSLmEHV6e1UwscRUOiy7TEJXb96HFYfUydlu3b?=
 =?us-ascii?Q?E9rjgTu7FRqwXF835ktvsS8n2K94FJ0UqA+EhWdME8ZZNOVAmZVCJUy0Z4YO?=
 =?us-ascii?Q?O4eGpYeWAe2RUd9Bs4st4dchoWIK6dKGjmRQcVpt9L7t9ZrHGKi+Ju4qD5tr?=
 =?us-ascii?Q?atXGzny+upqFj3WzzIMRH4VLOZYF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hW4yaFkPt3uass1WEsCrP+//7lQQXALBPEEioBI2vm+euQVdJcNN03239QXF?=
 =?us-ascii?Q?JUyfwQ+MSSMh8Cx/kqLndfOm/be+sPVMNEJFWOAj4yW8pYazwCBsf8JD/nXm?=
 =?us-ascii?Q?wjCKYNiVfY/uUnIs5SzVrB1q0ERjtyOfoGgla2CxE3P7x6mWar8HKfPe+ouL?=
 =?us-ascii?Q?+90WRI5Y2BmHYq5piK/5l9g0ZAvWBMkNnrFVlmpi9dr4oGs4b4qcdknNbUFa?=
 =?us-ascii?Q?BqfuOdLeSh52ZbRoGJrzD2LEQbCwBmcSQEuXjXUMr5ioNJ4B1T368ehiXVhc?=
 =?us-ascii?Q?I/6EYdjb7uetH7aiIGAdgOalT+NDCfgrlLRhSAI5j6kvM3zvPg2bczPvtFQG?=
 =?us-ascii?Q?RF++vncXbYPU9snA5yLHe+b8Oyy7Xqhu3M7GGb5BMnhZy4Q0YZ8oEg1aOfAZ?=
 =?us-ascii?Q?PW8AQbR5ZvzxtNpd2sEYGKmSz6oC1ul8RFR3IwDE66l1Cjgm4TXYRH5aS21v?=
 =?us-ascii?Q?+kaKgROqV2NlfcCkV9ziYwrDNYYO7B8WxxX2BWAl2Lg3Qz42860Ys7tu/Z7H?=
 =?us-ascii?Q?11J2oQMIPHXEpYtRkKGTSk8puQnXOp19eLQs7HG6HhE7GUFYRrkV9CebOwNg?=
 =?us-ascii?Q?ABPJVJvmNFILiwtHRmV6D8JpTMhj5DYAbtFvgt9rMg001q5Kw4HFAkdt5lW3?=
 =?us-ascii?Q?DJbW7cUObCUZviNYbAnbihVKzR0XOyPHGUYhe63sVYCPzTXvAP6hwxi3samE?=
 =?us-ascii?Q?sgOPmDlQ4HI+BwXa8j8s7BvqAx+l6nJ7PzdcezX9ODinus3vzubVzgqFhDxz?=
 =?us-ascii?Q?lI0+2rV+SwQqKMKg56xOKGmHa8awwaUkVDrbwAuFd7AM4vsGE1o+9b04C/IA?=
 =?us-ascii?Q?kepCWcq/jxHqvtcihBuNbxdhuOzVhz8MMp6wmdJ8JsxJbM9gmVjJwzm16KIP?=
 =?us-ascii?Q?Rj3BUcO8Jr+fqZsKNsJdAgqjt2k44oCxqkS1MlmO0cr5uQYR23BJY7e8g+d5?=
 =?us-ascii?Q?B7o57fvG5QISzKbZ72kPNMeybpIDxvE+/QkGhrpvjmgpK2Nvi5Ridor9lyUh?=
 =?us-ascii?Q?1Di1C4YCVhUnkle77zJagqwgfTzKUfZJUjQYNAbCcaHn+XaJygP5tmZGFIIo?=
 =?us-ascii?Q?KNBRNq6nXn0GvOYz5en+GcwXhsnh74LS265PTpf/w2swMD6cF06r7xGPBqbg?=
 =?us-ascii?Q?6w1PJqiEmZgkdqti6MWENG3XTGA5cOOz+HzSRhDuTDXLAgoWG/eBUy77pMsO?=
 =?us-ascii?Q?R5nOzED4S3YT14abk2M0PNHh/FmeQC0kX0Wn3a7Wwk7wVyCJrcMxCEKZac+8?=
 =?us-ascii?Q?SYca9xMsgfu09Srr4XrVHg0fitrhujNAXY3ktj+sIFhy2p6Rp5jbRiCkQk3l?=
 =?us-ascii?Q?sT/WTijOa0tIFx6wMRWZMywwhO4juqeYl3Ew+6DV8uSiNwFWxfzxeICAllTe?=
 =?us-ascii?Q?4tT8ltf1ALUEU2l7jHeiavQFbP4WwGPPY3DnMkp45yrswjdho1v9YsEH9f9C?=
 =?us-ascii?Q?8Nqlp1wU3mhAFZpwts4v/vdfuU//nvlLnM56BcHG/Y4wJOgkmKw+mlh+ReHw?=
 =?us-ascii?Q?jE2ESOVPy0a42C12b/Mar0XTqR1qj5T2UwUCo490y0WZKiHE2RMLZn47KtnD?=
 =?us-ascii?Q?YU2tzDF0HR9jzI93bE9E+WB6ZGt1hGGVJ79bszVlvi81dIyA4HF/mux/O15f?=
 =?us-ascii?Q?yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZOk1cJuyN+TFwCHYDbtu0DABCKVUmsKqFcEwRwOmqmuXp2TLpnMFkC8q04K0LORMwI4zg30zSgaTb9qr4VaEFMhiLeaZqDhS9xTlUPBMKu/F9xf01UpWh9v5fCiqHcLMAMb4lxhnGkrKz/AE+jLuJSwpdBtfvVp7JgBFZTbi8V5zmqbnmWYxMkr3MOCWZ26wpU4FIyvUa6hmvHzz2HjFBtQm8LZaq4GedUovKwl+5xIX3IjQV0649o3IFZdGCnQ4qadCCPtzpYoS/xLExSszK+K7g/HqDa29yd27/Olm863lKuWkagiB4FgSJL/9nGQ81yLLOEHYDWKQVvUZOR1uZLq9fPsrP+jd+JeErf7Ue+4EyVNhhhF/wMbgsUYWba5BcZhYgmbm+zQfJd+gYLGwT17tMEObXei3VSkzArdx1AEm/4BGwrpA+CO3qIaIwTJXw9AtMlIdTaJHS7bgAEUDvO0v1j8p1uwGCYSOq3775Mq48XilfM6BLKOD4I6n0fnnzy0HbjZBKE/5ei1ztG8i4mpA06iSRsDpB8VnkibvOOt/7eWNZhbhW5NXO7aVBof25d6Letm5RclNPvaxyGEz5bVb6qptTy8q9TNPJOtMrQU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ce0371-2990-4347-8a8f-08dd5063f417
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 21:33:58.4810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcpNwTDSdswgult/vV7/5Z8iGO1PpC58zvLoYgyluiKLZno3217Lm8wT64WSupYoOlCAxEe5dxSDN5iSrUTA3P5856BJuz2EZpjF4kABdTo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_10,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502180144
X-Proofpoint-ORIG-GUID: 0DrHwGjOtsKjE6sezEpFc-FVNSqCEti0
X-Proofpoint-GUID: 0DrHwGjOtsKjE6sezEpFc-FVNSqCEti0

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
index e826b990fe50..d7f538f28daa 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -847,6 +847,7 @@ config KVM_GUEST
 
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


