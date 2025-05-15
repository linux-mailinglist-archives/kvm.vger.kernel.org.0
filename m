Return-Path: <kvm+bounces-46728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1070BAB90B0
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 22:18:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10AF13B1E43
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 20:17:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08736299933;
	Thu, 15 May 2025 20:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="opAXrQkJ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="geL5LLr0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7612D182B4;
	Thu, 15 May 2025 20:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747340282; cv=fail; b=lUOb9vXujXvkMX9Tshbo6QtwKwfYtonOYDTsbJFvGv6uZJUq/zhtAi1sZzRYCqAybMkM/GIW+NLHvsah/J9z0fmHtvdfiyPk/DxeMLmtXlDB/fjAWERfj/3JkyVCwIJPGKKMVsQ9ywE1YkQp6d7vjPZdGvgxi0yvEk6w/5KMEcc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747340282; c=relaxed/simple;
	bh=MG2G3h96ZTWf1P5z46jyMhyqvfBQrw5Guf3tT/pUlOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ezaZLnbh3bqx4payJzwjAcqRNqp3ar3VcLSJ9jZ4iwp5dyYfULmFBQ34bEWacjgzOubUcyKFdIu6FmXOsilKxf6YWq9Bbd9mcS6mpRwN2bcpAGfvNheP8J8YnsF8ksU2hHysqaSsNeLSeGMnUPmCibkeRzyEMCbrt8/mhfzrlqo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=opAXrQkJ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=geL5LLr0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54FK8e3W007637;
	Thu, 15 May 2025 20:17:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=m6D6Vqa9YAobVfvJ7w
	3lXUGqb/qSSi15jNbSoe4Tj2Q=; b=opAXrQkJ6IOMFvZ053OvKONg9FSX3/IC0C
	CPD2mG0gDfWGj62UFOFPbfSg2IaXworR6QRwrkUOfC7jGvU2MoMH8Y5U3roIeDao
	O9y4Tcr5lMVzi0x3/LMvLCRy/msqKmNkC+upbGToLjN+nl9tTjDSsvwc9t5dc38r
	1EO7UHpD0+qwUSLQOw1sXVPA57x1qPArHwgzw2QVZw7o4r25Giu95CpKWSo0hmVs
	pVfAJHIN4pVHg0Cn2WKgdebf04lOYV+z0P9Ch1PMKLxCDNPMChmRktb+NEM8nvXb
	g3+WLxTDbaI19SBUlsRqaW8F7ehqb5A846k4CsCKCGv2scLQeWLw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46ms7bv0n6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 20:17:45 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54FJq9Hk004630;
	Thu, 15 May 2025 20:17:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mshm1hqw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 20:17:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=owaw9DQqhN1MZn4L9bm8m5mbwYAhGq1FXW6wpsKH7Kwftifj8spPzXpqXSRy+af83kb1NmeCtCmwTzQQxIjVGpWeflVUBHxWi8xlcn5gGlA4d/ACBKS83kX1w3Rk5D0kGu7d7uuIyeDnMl/yfwjY/RAuDtryQTmhxW6YFfXhUezz8CdLSyzq6qjB/5ptAu995nuywcuNaC71tww5VDIsw2tgu60KUhWF1lE4o10oHgdvx6ewrfuwXoQwxccDSzxiZEIOXNO9KV5nnySIDFHaBDJitpDb4+CgX+k/vG6J3zSrLITeEioeqWTlixeCGxB8uKI5YcfpBHxufz70mlWvgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m6D6Vqa9YAobVfvJ7w3lXUGqb/qSSi15jNbSoe4Tj2Q=;
 b=pr6c9QPKCm0ux26bhky6gADCYByzZCE8rluTagesd7LpFJcSGdPx+tXA/1sgyjpGuFrHpI/CtldYGULZGPkVghyGKvo9xoZkXMeSggtLU4qlbP5SjUgpfeDGmUP8q/8xF4bmxmPQ1yavZpnY8Fbg0o8iw9el1weRJD61w+BSSa4NbzL0Wic9xVXR4dg9PlKyPxt/w8knwxZ1RIlgexEZFNEum+4O7jkPy/cTmpsSfE5gneH4+95D/gbyu7mSvEm0nu3NMzfFCsbqtaD9QMV8IYb4Wf1tsmBsvb7JUUcVnA57SZwJSuqGN7+MFZL1gJD5APM3hjGWX3WmpnZVNZwLVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m6D6Vqa9YAobVfvJ7w3lXUGqb/qSSi15jNbSoe4Tj2Q=;
 b=geL5LLr0NWitg3uZMrFGfvPd6CuctMjLYWPmVZjFZY/qnixw8JHteEcO5/z2ZLkWtAKU5Do7Cwgip1WUOg5thx4St+FIba/5tJZWQ7pcDh1LpR8IMIbzwWA6UaihOSy83/QXmcSndamG+ik2wVY3vnB+Ka+uiGUe1LcaiBlphlk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4763.namprd10.prod.outlook.com (2603:10b6:806:117::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Thu, 15 May
 2025 20:17:42 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8699.022; Thu, 15 May 2025
 20:17:42 +0000
Date: Thu, 15 May 2025 21:17:38 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        linux-mm@kvack.org, Yang Shi <yang@os.amperecomputing.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com
Subject: Re: [PATCH] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
Message-ID: <aabd6b8c-0a5b-49f8-b9a3-95619d438382@lucifer.local>
References: <20250514163530.119582-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514163530.119582-1-lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO2P265CA0123.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4763:EE_
X-MS-Office365-Filtering-Correlation-Id: 80f7968a-f737-4cdc-9273-08dd93ed8bea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x19xFfAsmhLG3f+ZtcPMOOnRcrFF1N2Nu2C9/udMkvxj5vIgmDJlYqHFye8T?=
 =?us-ascii?Q?s3RdoQdmFM/RyzFCSpL8BDkqY8WzEHOOEXIwAPcahyFND3XvX7OnvMEMhd6C?=
 =?us-ascii?Q?Ppo6nDSVjc0TGCCOWrF32YrMu4rhdnuFwFxJkbBIAHuCoQnSlhCaf+Eeg4Y/?=
 =?us-ascii?Q?oeAcVkW76yI3Uj0kP7gjyC6de5Uyedu6JLQnTKs6OxBax99yP19cg1rTP78n?=
 =?us-ascii?Q?CtxX7OqKlkZ+XJNLGHV3UF/G0507+NW1/eSCTRQCW9auo+RnlDvKzUANvUyJ?=
 =?us-ascii?Q?TZhBd4tlxud+lf7Jo9Bl5KB/QO8mN6chXMaCf9VMpUxhY5bf9JLkBsbSWNiI?=
 =?us-ascii?Q?4ah8MVCMNzp82yOGGl9lcM2DSZtBzpV/IkGt3pE4Lh1cKSfp91ZTQ8n+p6n1?=
 =?us-ascii?Q?EnqGA5cU7MmZ/pmKZ8H2w5+aRst1wOlOS/QYOyrATEx4Z9aTG/iFTAsDkQRs?=
 =?us-ascii?Q?ojOJpHrzFCtQz0T3F0WKAt4F1fzCs74ueyyrnTkBLxJbFYJTlCDh/kzrBfw3?=
 =?us-ascii?Q?VlpkJkXOXpSrLR3jrY5+MYqtqRubhW2f65X/3kv45NB/hyqGJX5OOXHlZFwS?=
 =?us-ascii?Q?QzX9feCbYPGfASdFG/sFvDA67f6u7VWoIUc5zK/p9BSVb73T8FgO2V09gQx2?=
 =?us-ascii?Q?CU8GnUxNvSmiYLMLz7RiHh6Th0vsx/gB9w7h0+aSGAUTxafVzHpk3dr8VMKU?=
 =?us-ascii?Q?HQDF+nRsLQ47tAiWMzTMkCTGXkH4Cfqxc76BcPYaLWXI2Sgpgt3M1XyWqqlF?=
 =?us-ascii?Q?J5NApwE2BOOfRDPQUXc+GFDhyL6kHVRlRtIZ9/wr0RbAJ1dqNnh5j/WPPhcS?=
 =?us-ascii?Q?XaM7b/Kbn9NrjRj1o20AHzooho9fbXeIPRMlDqOgy1epkPfemo+tORMzaOe9?=
 =?us-ascii?Q?5EnzWaeAer/ItmVrPQ0A68Ch3j1nTRFxW9A99P+BDMAirU3aCMlgUoITfORb?=
 =?us-ascii?Q?/v1xYgHokRaKmZizWx6KhDe4KvXNyQAsj0ZDb5ijKECsgY/PP6Q7jwyDN00d?=
 =?us-ascii?Q?WQ70XLNvX2aF1UXJEHyIj9/rmlFiO4z0TQOEVWvVJsVF0JNCg69QUWkCadIB?=
 =?us-ascii?Q?1IuVhQSVEAmniG0LIodMymLhpnl3X3ZcwiDK6x/npGAzsDgyEx2RbkX8s3p2?=
 =?us-ascii?Q?bo303xfKo6Ri7q5iKHMmTGu3WHFtIYfo66M2sFXBaQBc9svBs0u3kkSuRAHt?=
 =?us-ascii?Q?vdS7LAYg5XNg6ddmMc9hSqobvF9FKo3+iI115k/Va5HMMs3CoHOfgwKSOEe9?=
 =?us-ascii?Q?tF0wY9bgb/bewPngWJAgXjCPLDwktfeRSa5A/eFzOMbHnN1P4HLGcMiYDWFl?=
 =?us-ascii?Q?HDSUPfhN5S5HyHx64GVhsQ2pxDEoyCqaHTWg71LGht5tEZg36emcH0ShlPFO?=
 =?us-ascii?Q?7oRCiKR+qimsB7whPF+Dfzo+wQ0UMNWSwaZ+kwhmeUhWaXdY0YsJ/BJ4pu3O?=
 =?us-ascii?Q?nXQOWARJ98Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gyGsJ2y0anva0uhyYr+8aXQy5R+0YAVlFX6nGQwb7FEcTjhyxwd5VGjTDlC2?=
 =?us-ascii?Q?rKBeGXZjTHUNm1iuFI9hSYmfHDnBPTJyFnFcOBpvZdnUZEydeYuV98e1QJ+x?=
 =?us-ascii?Q?3wtY37rCU8tL9GbmcnTxS+v/jmK+bmmeCmz1aprDBx08r5wn5kZbE8T9x3Vd?=
 =?us-ascii?Q?Vpvuva2yNaF39v1pSnEaAv5onXpt/chCfm0B+hbVJ1G6ECyyMLsohbgIb3sN?=
 =?us-ascii?Q?iID9H1RqB9cIYgp8oeFIiBfPzeUG3YAO8apHU18CVEzh8qgJa54SsATtY0bC?=
 =?us-ascii?Q?z/60sw4Amf5p80x2qrClsvIJ2dc00lYGfw2qZJSQTfEiA5khYavi+yzhpOHq?=
 =?us-ascii?Q?wU1HhmLPrNZXw4n+H3SzIpyBypO4b5P+ZMHBgKMxSFNl5DqMQyQdafLwf3sL?=
 =?us-ascii?Q?R/6hVfEDXKQA9tWeoFXdFSU5+egj5xZNS5AOUni+InwLnPp+zLUoj2VfH5So?=
 =?us-ascii?Q?ALQkOuP15/b34PIbkNHvEHIri1HV605/PknGIUf4KTfasYBmspMWHpNkBxN6?=
 =?us-ascii?Q?JjIoOxg2WI72c8iRhqvEMc3E0/GfY2iMMEl2ScOWE00A5Ch8PRpLJpgbGSL7?=
 =?us-ascii?Q?qgp//Ld2V5Cayzqgyid8ULynxpIav3QW2A/oRgSqpRciDbM+KR6FO/nF5UQ7?=
 =?us-ascii?Q?aFU0OxbFNO9v6X+WJVHVx9JKY+BB6QwNYFjrCsmRNIcXSz2TDhl2FAmhULSf?=
 =?us-ascii?Q?wy9hRutrRlGmnGkIaDlYLCqtTx9A9xHIITbPK/gKc48a/UQ/cl+AHJvxmPPU?=
 =?us-ascii?Q?lscqP1OXxP5ANBi6F8d97Q9hz2TggYVdrQU9KS9dGT/EBKaQdcOzwzU3m97t?=
 =?us-ascii?Q?3uATtJzJQht7v0Ksuw/cz00pAcq0L2fvGydW7A/iR8izGUmkfU6g5ONMFWYv?=
 =?us-ascii?Q?/Mbd4bsgVXnScEM5COWeW+azf7toGL/wuxlk2wOSaWoVMDSNlaouJ1WPJ+16?=
 =?us-ascii?Q?OQK55vLo9VO5bA9VQxdNmKTVCAE+EKLdVATbZ479QikOkArFsFACLUqRRPt8?=
 =?us-ascii?Q?FTD8GlcS9+pGvk6qfzbrsR/5E2FGeMX2DvYAZq9cPs5M8JWRV7cLhQHLqvAv?=
 =?us-ascii?Q?VCj/Bqw1mzG/+CkdO1+4BcoW09G93BbMC5h9z6wmsw4e1c9jjgUMqIZMjaef?=
 =?us-ascii?Q?G2PGSuW1gnIdQHysZOt9y/rYM6gSghm0ZHOMRgY5odSQDZwozYIzkuUZW+Vl?=
 =?us-ascii?Q?A/hBiOcJnvj3YFmMxa1KMqOK8o8rrqUvTDwULb9RhtlVhCVq0bqXao/6KFgb?=
 =?us-ascii?Q?LlWeLw61R4bg/7wj8yGFoW9Y8eZN5YKOZXwXFR1KZnRuIvTstGZ3HdLrJshd?=
 =?us-ascii?Q?RtubfvEB4AotxjykXXPpH/2hgRRcPc+pRq3BhJfLGQq9NpSzHVTOxnhnTWhP?=
 =?us-ascii?Q?rJzABx+1LhwCUnpbo1qDzWTVeGT5oQc22xQwXj6YPjuEM/NF/7Sf0TdZxK6l?=
 =?us-ascii?Q?V4zbdaE69oQizoGsbYpA/dzFwlpkeU0O9+MXHxE5CF95j6YbgNP8gqSnowKp?=
 =?us-ascii?Q?ngluUdggauhbq3/MLhxyHFWSTVkbUTnnTprPEE/gxzadz8CDW3YZg/LngXO7?=
 =?us-ascii?Q?tUEcE0NmgMxbvp7H+osSyP9yqXnYLyHrAeJutZp++SsbgAjR0bC4VauqGX2X?=
 =?us-ascii?Q?rQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bQydIjrCF9kmWDseSjvE5wKWmEWQermr0FUMXnCGNHHkB8hEFVVo79sAQ/wozls5g0YOe+XvXUDjCxGlWhntDBy6dgk9yMRO4RyU1E7yg0Taw5SRw/r8v8n3imAz9K+gV27cDYfzlLAK8kndAOoT3xk48WboGwvHd2TpWLtWCvyUJgq5KpKgFx4Ek/nWX1w4AjVyM2hy5J6Vwq4KVbxyND/IldSI6hUIN85LzI/hnPb5NlTS4vNE5U3U+cusGP4AIDULe7hOcrGmoaStIeFVLaffZ7buZSUBqtr1TeByFLI24UdskaVjmEK4RASvfsgpvQhatvjdR93WNNDBo9qW7ArxI2hEU80TUg4pcD+NXeQ4sgLCW6B+fFWuZqnoEKQKWtebKRJW+oh/z0Acowd6Xl978gDglZiUpluGDh++3xdfjACZmDZQ1LN/5XGKTODzy34gPneuvnR36WivwfaoV4hU3mnQg8rsSk6oilBnucUZfcFt1b0aFIEqjQRROL0fllsWnnufoJIki9rqCASzlmmiWHTAFE2T/yY/SCfA1zX/AUshk16+hKw72kcKytesVMBJgcUu6HS1MK6j+/9GFyCcPKtRSSxVVSqV3+JrPYw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f7968a-f737-4cdc-9273-08dd93ed8bea
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 20:17:42.1158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b9Nc3Zn3OZTbFX5zP5dR6Ij3FGEOV3r+uslL7Ql/brGiJRMoHQJQDcDwSsATFAp2kfdkQ/nrEO/mpcYGEORYRfOkEe0W9sfJXjEBgMvf6Og=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4763
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_09,2025-05-15_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505150198
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDE5OSBTYWx0ZWRfX8Ie0rLu3/VoU +/V8G0xG5uC8wTA9RPrf/xgcBZHAmoIxXUroO3sgWhnz/E9DtFNAT9RSvGj7KInljmXI3MFeERt UBd08HRMGblXi931lsHGoFOtWNmpy3QlA0GWmc6pFmtsvMj2I+w39dKxb6GV/fAXaXCiReVXDFB
 1Ubu7aacDcHx3skz1t56VhkQ2YbpxIG7ybgYIvJedx3sVktEzVdQa7RAF0D4ACex0xbUOwzVdm0 QBki/YrknyRd5D+SrWw1IBI93VEJZZ1703dSRSUEnnepQeS0JnEsy3RGlf90VZd0sInixWYvfZy HJJM3QAPnGhWpdiOWmE6KTMUl8HN7HJ+44Y1+y75BU24OvxkWAabXR6HWFu17/nlZKkD7gjgeSX
 oqMYDBADhiuKa4L47ObIx9OSyzDeS0ZINEqeifsiJB0wdJ59lcE/WsotK2JbkABnXnAE2IbT
X-Proofpoint-ORIG-GUID: qDMs4ABviU3MRRA-uXDFnhh5VeMXkP93
X-Proofpoint-GUID: qDMs4ABviU3MRRA-uXDFnhh5VeMXkP93
X-Authority-Analysis: v=2.4 cv=P846hjAu c=1 sm=1 tr=0 ts=68264be9 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8 a=TAZUD9gdAAAA:8 a=tuJQyjvEnJ8IZv-UqXIA:9 a=CjuIK1q_8ugA:10 a=f1lSKsbWiCfrRWj5-Iac:22

Andrew -

Please disregard this patch, I have now re-sent it as part of a series in
[0] in order to enforce ordering.

Thanks!

[0]: https://lore.kernel.org/linux-mm/cover.1747338438.git.lorenzo.stoakes@oracle.com/

On Wed, May 14, 2025 at 05:35:30PM +0100, Lorenzo Stoakes wrote:
> The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
> unfortunate identifier within it - PROT_NONE.
>
> This clashes with the protection bit define from the uapi for mmap()
> declared in include/uapi/asm-generic/mman-common.h, which is indeed what
> those casually reading this code would assume this to refer to.
>
> This means that any changes which subsequently alter headers in any way
> which results in the uapi header being imported here will cause build
> errors.
>
> Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
> Cc: stable@vger.kernel.org
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
> ---
>
> Andrew - sorry to be a pain - this needs to land before
> https://lore.kernel.org/all/20250508-madvise-nohugepage-noop-without-thp-v1-1-e7ceffb197f3@kuka.com/
>
> I can resend this as a series with it if that makes it easier for you? Let
> me know if there's anything I can do to make it easier to get the ordering right here.
>
> Thanks!
>
>  arch/s390/kvm/gaccess.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index f6fded15633a..4e5654ad1604 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -318,7 +318,7 @@ enum prot_type {
>  	PROT_TYPE_DAT  = 3,
>  	PROT_TYPE_IEP  = 4,
>  	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
> -	PROT_NONE,
> +	PROT_TYPE_DUMMY,
>  };
>
>  static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
> @@ -334,7 +334,7 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
>  	switch (code) {
>  	case PGM_PROTECTION:
>  		switch (prot) {
> -		case PROT_NONE:
> +		case PROT_TYPE_DUMMY:
>  			/* We should never get here, acts like termination */
>  			WARN_ON_ONCE(1);
>  			break;
> @@ -804,7 +804,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  			gpa = kvm_s390_real_to_abs(vcpu, ga);
>  			if (!kvm_is_gpa_in_memslot(vcpu->kvm, gpa)) {
>  				rc = PGM_ADDRESSING;
> -				prot = PROT_NONE;
> +				prot = PROT_TYPE_DUMMY;
>  			}
>  		}
>  		if (rc)
> @@ -962,7 +962,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  		if (rc == PGM_PROTECTION)
>  			prot = PROT_TYPE_KEYC;
>  		else
> -			prot = PROT_NONE;
> +			prot = PROT_TYPE_DUMMY;
>  		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
>  	}
>  out_unlock:
> --
> 2.49.0

