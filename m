Return-Path: <kvm+bounces-72149-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2EZxBqOUoWl/ugQAu9opvQ
	(envelope-from <kvm+bounces-72149-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 13:57:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 61CCF1B7648
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 13:57:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6C58030B7736
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 12:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A02343EF0D1;
	Fri, 27 Feb 2026 12:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O7t765jn"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012068.outbound.protection.outlook.com [52.101.43.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AD036C0A6;
	Fri, 27 Feb 2026 12:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772196988; cv=fail; b=dqUi1hzaTHib0ZwzqSRriy5QEEARHlEwCxs6ZLU09Wfg0QpnbQRYgIw1rZLscNv4XSbqMJMeVHdejyzB2gm69qbq48J+pxzI1Z62sx6W7kEeM7nDhx1swixHneFhIRtV2RZXLmAafWg/JQ7RFalH2frRYZJ5gYvI8GxuZQwq1Q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772196988; c=relaxed/simple;
	bh=BFekGNTJ1rAOolkDTN+5KzPxy3p3ZRYxPYMaoR/Ef6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MTMkry5765clbsaCUF14HZIo1n2igKfxEpWA5Sb262kWSg8OANApOwgSA/REmCX3VFg0ZPQI4asHNBLmejx6EwkNb0Ob3+qlsbnlaYKwhXywDJ6ZQjVyl+D0FNE44cs3L2pVfxFdF6LrC4pVr6+OHTueyMy/bx6PBR8s6hS/JLE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O7t765jn; arc=fail smtp.client-ip=52.101.43.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IstXFkLuki/mU0XPawMa2Xc2cJvNRX7QQwkW7z+qKwVoaH8W+HUu0zJFb/Lt6aHAli9giCRpwdzBzUM0AGn+uQvSoS797LinW9Aga6gwVTl/STuBvFHRE9oKgRQq3fkjgr2WWYuvOX69ulyJmqyqqrwNwgu89wL5MLv/QK5RXOsK6MwZbp4k2s2qUhN1o4uBdl7jD3iBtgu96HuKlskfDj4quBKcuPbFt5HKaDM14x4P06yhZnST0RuQZS20VPksR0bZ1ga6HHx20cJKAqcPICzzcUm6sjWj3lUOVh8Hhinhn2aVt/sbgHqJ9HYpTrDUOzj4T3wAtW7JrTjOifkiUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4wSltaA/DRGUa/5Nn+GFTNn8rkjaOcuKlbIMWPcEIc=;
 b=fw07/t86ZFTwqO/+b3OedlRkMzgfZhl43YIqQx8J5cJ7l2CCXqspTOLhXH6wc24H3M6CM7X34sy6CEacP9ZwDU+jEls0mgkp3q3vXCPgqXRBU2mrcIN7W7vmHo4YcrrGTtx1k/4G+P18MxJ5fXnUODJZFNnjrRhfUjHioyxhIjKjH8PQitl40Z3n/BXIDfjwDPqQXa4hcpfgl7ul8lItSm8wESedTB7ZUDwN1sohF9PsU2qRWzhUJmhO3D0xEpYtwJyyQYlVVGfaGX+iOiAXgSwVy/r3Y/vl6kBnm2R8DVd2BEgTOZXrkW2xbXRB8svp1vtWaYe66lpMchDUaJhQ7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4wSltaA/DRGUa/5Nn+GFTNn8rkjaOcuKlbIMWPcEIc=;
 b=O7t765jnmNYD+kbceyjJgtpH71gCYFjyoXoiWSyV7LIBT8JfWa+onEwPKXoNb/nBw4CvKQ7WJY6Fjq5lyHw6LF55RhWKpIdJc+3QL2NYePWtIDRS2oohEwjbtLOPa4bZLfqMplE685ZBiwb1e1WovfFQZHxfoOWjx3Jmvhum6MYUNZ/bF0ObDiqEo7pNpCFiU0XEHowl0yR49h8UTliNmABPzC35RMcke2eS8LcOUZZw5+JPav9EDC4XTrLJ5AdGfxzLN3ovA8wdF4LHgRdV52xt3h37/ru7RGH63XDI0Q+PepTH5LJxlgAcxRKC9n/MoqPCfgL14V2DDWR8nLEQVQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM6PR12MB4468.namprd12.prod.outlook.com (2603:10b6:5:2ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Fri, 27 Feb
 2026 12:56:23 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 12:56:22 +0000
Date: Fri, 27 Feb 2026 08:56:21 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Matt Evans <mattev@meta.com>, Alex Williamson <alex@shazbot.org>,
	Leon Romanovsky <leon@kernel.org>, Alex Mastro <amastro@fb.com>,
	Mahmoud Adam <mngyadam@amazon.de>,
	David Matlack <dmatlack@google.com>,
	=?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Alistair Popple <apopple@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org
Subject: Re: [RFC PATCH 4/7] dma-buf: uapi: Mechanism to revoke DMABUFs via
 ioctl()
Message-ID: <20260227125621.GI5933@nvidia.com>
References: <20260226202211.929005-1-mattev@meta.com>
 <20260226202211.929005-5-mattev@meta.com>
 <f75088c6-5795-49cc-8932-ea46c2223d74@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f75088c6-5795-49cc-8932-ea46c2223d74@amd.com>
X-ClientProxiedBy: BLAPR05CA0021.namprd05.prod.outlook.com
 (2603:10b6:208:36e::17) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM6PR12MB4468:EE_
X-MS-Office365-Filtering-Correlation-Id: 8027fd16-94a7-4e7c-4793-08de75ff9bcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	c7GI/p7hs2uGajxL1O7QxHzMn0i/pFXX52CDUP0Jxhuil0baXNd9ziBqBqCEYolQ4KLqIFnoruJFOW/CHdFVuQ6k2z5emkJ1g7zcgK83Mts3/L1jRgWLnQMxmO83xB5eCyPPHKubWd9ZiREuvdeoJrBNA2sdiBfnYI95BJLHn3Ym81Hd0LtbHCA/raea0NF0a/SD+dRlLfn8e2zgs46cs+Xxnnisah+9hrHyygYco+a0Hu+pJL1TA98SCsAh+J75qQRh1tMtFFsPf78W8/Yp0BsKPFHqmcrJtPb65uedNATfz0fPf05c4nQKeHhxCsb/FHhSM1CKokEqW/BWBrbcEijVgF+wyZjSqCM46Hvvyk1d8dk/uZGcawDMlCjNdOBHF6lI3iMdxI8DXCvcYgrXOR2QWJLkdvRrey3/rQwGKt6tOV6ZH2z7adIAnh03xCKdUMZqpSnRT6+i/QSaZWlkeR/kTPrF+0Yv+jRpBuwp44Vk63OdHcZ1ybxBzvsGPtf9s+FdIdM017Rz4xrZPNES45VFU0DHsYtsRigGjzdrlkr15wLDx/DLkVUDLJyDmQpznfpCWb8CZdU9s+ZAvhzPLdby4ZvQHvuvPgzHcR4oWVi84u5seHXon6nkqgRjlDFhdQqvCj5FlRqz7OntvpkvrTxV3L+n/ICyxwGfwSyUv7l5fFsb3lC3KB6ahgZ/Vr6m77vyHDi1R+wSogPA803g2rhdqx8S0PeKAjnKHdn2WDM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZytBb1F2SHp6VGhnMWV1aHhVdmFxVSs5aHpFQndTNFM0emJsQ2RUby9hTnJo?=
 =?utf-8?B?blQ0R0xKK2h1cldwaXBJVmFmOFhKYVhZR0RSK2NBVmFKMVRkQVhaT3ZGV21a?=
 =?utf-8?B?a0xTRlpKb1AxSHdlUVQyT0pLcXhhL2JiNEFYbU8vU2VRaGpnZndDSFZQQTlF?=
 =?utf-8?B?dnp5eklNTG10VXJBZC9wck43a0U3czNQTXhRcU0vWUNaSkY4OE9tbzZqbjJv?=
 =?utf-8?B?eWdnR3NxMWl6YkNDK1JMZlAxWGR4TXFQVHZFdXZIbEdsblVhUlYxcThIQzhX?=
 =?utf-8?B?WEZXeG96RWU3c09zSGJjZGptOU85VmRRbml3MTNCODdhaDY1bnQzQnRGbWFp?=
 =?utf-8?B?bzZnUTY2cms3VHJkazNIMFhhNnhIenU4Qjhsd1BqUHY4TVI1RHlXUHlMbGx5?=
 =?utf-8?B?NENNVTNXU0VZT1dROVdhSTdTR3JsYkxTTGc2T2ZTNFpzUTdvYno4RlFKbUNs?=
 =?utf-8?B?SWZKWWRQN01DOXFQd1ZYaWFtbzRkOHBYZzlML3VoSUVJSlMwU0VndURBUE84?=
 =?utf-8?B?Z20wc0N3citBUjQrUHZoUjIrYVhJRHAwK0g1MEZQRFdTNnNJd0pVTFNkV08z?=
 =?utf-8?B?Z1N1QUZSZHkxUDE0NGdvdFdoZzRpZ1k3SW9oaW16YU5Hanp3K3NkdzdXV1V3?=
 =?utf-8?B?MVc1WFBMQ2IvMWRXbnVKS0NtTmNhd3plVUtRR04xaHdleHJIcS9FbkcvanEx?=
 =?utf-8?B?YjZHdnlFNXVlb0VQSGQxZVNzVmtVNW5mWjN3NG1pcWpwQnFHZ3ZLZjBUKy80?=
 =?utf-8?B?VUtSWWV0dlNOYUYvNGVvNG5KZUpiUVFjMVkzc1EyWGJLTlVkdEw0MFdHUlpE?=
 =?utf-8?B?cFJ6bEwwMWV1bEluZzJnMncyNWVCZEVEcDN5eVBjV3hKYUQ3bnVlTWVaY3c5?=
 =?utf-8?B?R05OWndRMmhPK3lCZEl2b2ZiSGhvN2xsWkZKSGdlWVlRREprcmtmMXlXSGtp?=
 =?utf-8?B?YzBQdGZpdjB1eGxnNG44aHQ3eEQwVmQ2a2hVcEo5MjlrL0VQS21pNVlZM3pq?=
 =?utf-8?B?Z01MaEdNZXF3OXNmVXFYMnJXZ1lrUDltcDRPMUI2eXRXcU5rcURpTEoxbkVs?=
 =?utf-8?B?bUVKaVlXU211eUxqRmc5RFp6SEc3ellCWVRYZnVqZEcrbWJ3VzNUVFl4bDdW?=
 =?utf-8?B?WUV4NUxDVnFNV0t6bjJzQnkrTU55VzFkb25ROWViTWViNDY1T0RIK09PT1Zi?=
 =?utf-8?B?ZkJ0c240SlpPNGZ2V01nTmRJeVhrRDIydWdCeEhSZnZwZ0crT05Ub3Jic1Vu?=
 =?utf-8?B?VjNielVqVUhTRndYaG9oMzR0TWhObElWVFExbHBzNGFNaGlqeFVmTGM2QndS?=
 =?utf-8?B?L3FtUWQyeVh0OVZmU2RJWE5wOVZaQkYyTk1hRFJhTlpmdXB2anROaVBpOGhv?=
 =?utf-8?B?eHdLbC9HSHlVdi9ySmxBQ0tOKzZFVWdaWitHZUVIQ0ZrWjZIZmlUSExlWk16?=
 =?utf-8?B?dSs2ckNMQ0VKeWZxUDBtWEgzbytGeG1BalFqMzZ5WTV3TlBQeklBcVFLKzYx?=
 =?utf-8?B?NFQ0dzV6YTBGamJIczI3dG5XQ0Fsc2U0VFlNUk1nWjhDTHZJVGoyWmE4R1Zk?=
 =?utf-8?B?MXdEM0IyYlMwdno2d0wxQkFvZXVJWXVRQi9oVkNGNEhpdFpkc0dIQldBZUlk?=
 =?utf-8?B?OE5raExjYjI0VFhJcXVVd2t6MHI1azdRc0VjMXRGb1ZjdEN2dWZUaC9LR2Zp?=
 =?utf-8?B?WGxMUDBqUDZKSkN3Tkh1bjJ5eE45c28xUDg5dkRjVGZBb1lvRWEwVVFnbjJi?=
 =?utf-8?B?Wjg2Vi92STcyVWhhSlZ5U0h5c1FDdmRjRzRkZEg5ZVBCaExtWWVmVzZTcHRq?=
 =?utf-8?B?UkhaOUlNUXg1SVEyVWRsSE5FSG1OczZmOHJvemhEelQwc2JMZmVFUldIL1py?=
 =?utf-8?B?dTlUU3Zic21DdDdGd1A3aCtldHdHalBWblJQWCtJU2NyQjVSeUVFb2ZOeFkr?=
 =?utf-8?B?anVielhTclo1MGVYTzJsRUtBcmlyK1h4OG14SVZndWl5TkVWYVo2UWlOOXNv?=
 =?utf-8?B?emN6U095VWplenROTSs0K1ZDdHhuTklrSHNSYU5VUGs5SVBvZEZKOTR3Zll2?=
 =?utf-8?B?eGtCdThtRWRoWEtHQkZXNDhLTHNYR3UrWDRQcUtNOEhMQzZJWGdhaDFwWi9j?=
 =?utf-8?B?ZmRoRlcxaUlYZllVRGwwbVMrRXJJT1lZU2ZBYWhMVzVzaytyS2VBdWhwVGFZ?=
 =?utf-8?B?SEFTUkxKN2cwYVhpQWQ0dW5oVTF6RnF3WGpUK3ZUMEdtaHg2dit2cmlheDBs?=
 =?utf-8?B?TzNKeHNYOVhyTGJlZ1VRbnk3aFdYZm1FaEZDY0ZYRS9LQ2VyTy9mV0NMVEpj?=
 =?utf-8?B?Z3ZrckJXajAyMTNXeDBxcm1UdUFhL0ttVjZTSEtacTNHOUJGNGswUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8027fd16-94a7-4e7c-4793-08de75ff9bcf
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 12:56:22.5914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /mhAyJz+8wAzPrBwwSGRimc+zenJX2KahD9daxA+NOuPFk8kDUdb9wzjmh+eVNha
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4468
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72149-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:mid,Nvidia.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 61CCF1B7648
X-Rspamd-Action: no action

On Fri, Feb 27, 2026 at 11:05:24AM +0100, Christian König wrote:
> On 2/26/26 21:22, Matt Evans wrote:
> > Add a new dma-buf ioctl() op, DMA_BUF_IOCTL_REVOKE, connected to a new
> > (optional) dma_buf_ops callback, revoke().  An exporter receiving this
> > will _permanently_ revoke the DMABUF, meaning it can no longer be
> > mapped/attached/mmap()ed.  It also guarantees that existing
> > importers have been detached (e.g. via move_notify) and all mappings
> > made inaccessible.
> > 
> > This is useful for lifecycle management in scenarios where a process
> > has created a DMABUF representing a resource, then delegated it to
> > a client process; access to the resource is revoked when the client is
> > deemed "done", and the resource can be safely re-used elsewhere.
> 
> Well that means revoking from the importer side. That absolutely
> doesn't make sense to me.
> 
> Why would you do that?

They are building a "vending process" to wrapper VFIO. They want to
send a little bit of MMIO space wrapped in a DMABUF to some other
process over a unix FD. At some later point the vending process will
want to revoke the MMIO so it will issue this IOCTL to the DMABUF FD
it held on to. That will render the FD unusable wherever else it
happened to go.

I had a similar discussion about other iommu features where they want
to insert security protocols into this vending sequence.

IDK if this should be generic DMABUF or not. Another option is to add
a new VFIO ioctl that does the revoke and takes in a DMABUF FD. If it
is a VFIO DMABUF FD then it will revoke it as desired here using the
VFIO machinery.

Jason

