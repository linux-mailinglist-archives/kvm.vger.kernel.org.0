Return-Path: <kvm+bounces-72203-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6BmXAszzoWkwxgQAu9opvQ
	(envelope-from <kvm+bounces-72203-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 20:43:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FC541BCFB0
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 20:43:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C2D0430C691A
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 19:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 008454611FE;
	Fri, 27 Feb 2026 19:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="YO6kuv+P"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F53366DDD;
	Fri, 27 Feb 2026 19:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772221368; cv=fail; b=JKtgVApdMsFUVgfinPpg7n0b8aw5RLdeoaG1g9H87qZH/jD/qUwQIqClOyGs+gFsi/iORVdfjvqKD8u+952SXtmafrZNDuckvXsNjVQ4HSmxLAvuqIP0jxvsBIImLL7JbEiHvBwSUd3ovToX9loCika2MpXwsIscCo0hi1UDBB8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772221368; c=relaxed/simple;
	bh=BE8jREe+DfaFzcbsSgxYjaJ8EJC5cHIIPiwbX6Gk51s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IQuj4tmpFhB4eMxk6g2l5aNA48fXKPbj/MFONjbrI4r8nlUX0sOCQop6W0zrjOSxQbJijkyb4GOfgTNNLKqrKhkIIEP8pt2apHMga7+LUKkiDtkw6QkhXqmg0h947gHNxUyqQkV1VoxOkFX84DrsSUah2tysZbQh3OWzQelcwgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=YO6kuv+P; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61RHPGeQ1119659;
	Fri, 27 Feb 2026 11:42:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=bRuxVaLFaMJbjxWG1egSI2q81GTEYI21pSLZoQT1Nm4=; b=YO6kuv+POyy2
	/5o3UpXjbCJ/b7186fwBtUAxTMrXMDRqJUvraMnhxrilV5OSvFFNZ0FGmzHpFa0d
	QXee2vRK0SjXPp1wFE8HP3lDFk6xpSXdhbnclPOKGkLsN1EDKDNbZ97S3nFagPXK
	yz6PWIxAz161UKy9MQDmonh95tFDjaDSyEhNvRQlQ8yvJ9Wbhr5/yjyRDL2ajUvN
	qTHyk1ipXjvvxeEu1O01MlTy0O5PUaL8OXBUfTVzcqlU12r/bAPHCOhrbIm+8n0u
	hLaPN5R8V3H2mz0wpz8vZIOUh0NGGxA/xj+Bg10tmcrw9vfvDyNrM9UwMNe/D+pj
	k6e8eRYNwQ==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013000.outbound.protection.outlook.com [40.93.196.0])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4ckad74r1c-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 11:42:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Us1dV67xgbtaKpAFXtat3wLTc++M6q5zbJuCzd9cxYB4UZ179IuJEmaVT4Mts6vxS/I+WF1G+IkrxJYrazr+k8zW/5VKWXt0+0ESSF3oDUv127VjkpdKWFXcZlcOSBSI5wp7A2czjAPJJZtAdR6IL9XHC6V8yGBbJuf83SfH0kNr7+WRShoUZ7BXqoa4holhQjnerZZdbPk2OdSGGXLfM6wOjRP0BdE5iB0508vZcYOjOI51jZrjT6nl+tsxkGmbgTz3fbHZooeoj8/yUG9NOwX/71Hy1KQnMSt2zQJ8m+QNvLviXQzhKtir0FmD3XF179jBrMGs3V2yTTYYUmL7wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bRuxVaLFaMJbjxWG1egSI2q81GTEYI21pSLZoQT1Nm4=;
 b=MCHgpYndRY8YAhlwtR0crnnXkcOEnGzKjpIfaTneZ3KKKfCfieKx17qQPGe/apsQZklbqFCgr5re8u413b1lUjE1747EUocNUUHHDkAMQY9EXZfoxs0Cs19Cr5xyMeDkOdeseIuzgb3SsIqe0E3UfHaH3fiWx0Hz7VBkJMoU4mIl5mTqbdszEYH2XgYcv/r7I66KofaqtKf82RTgXzx1yRHffuJUsTm+PphDlNX0cr58IFpRJgDpytyl3dgITRvllgSw/7XDlIsrGHmnlPV6CiVp/cLG5zb9aonVbZ/PoCGt2N7zPpHKLoxlSMjbX58QPoNTI5nEZTOzPwjTqM9iVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from PH0PR15MB7038.namprd15.prod.outlook.com (2603:10b6:510:38d::10)
 by MN6PR15MB6242.namprd15.prod.outlook.com (2603:10b6:208:47c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Fri, 27 Feb
 2026 19:42:28 +0000
Received: from PH0PR15MB7038.namprd15.prod.outlook.com
 ([fe80::617b:b77c:494d:de19]) by PH0PR15MB7038.namprd15.prod.outlook.com
 ([fe80::617b:b77c:494d:de19%3]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 19:42:28 +0000
Message-ID: <c5a8f318-20af-4d80-a279-2393192108c3@meta.com>
Date: Fri, 27 Feb 2026 19:42:08 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/7] vfio/pci: Support mmap() of a DMABUF
Content-Language: en-GB
To: Jason Gunthorpe <jgg@nvidia.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Alex Williamson <alex@shazbot.org>, Leon Romanovsky <leon@kernel.org>,
        Alex Mastro <amastro@fb.com>, Mahmoud Adam <mngyadam@amazon.de>,
        David Matlack <dmatlack@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Kevin Tian <kevin.tian@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
        Pranjal Shrivastava <praan@google.com>,
        Alistair Popple
 <apopple@nvidia.com>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        kvm@vger.kernel.org
References: <20260226202211.929005-1-mattev@meta.com>
 <20260226202211.929005-4-mattev@meta.com>
 <90bd4185-1e87-4393-b9e1-1318a656a7d9@amd.com>
 <20260227125109.GH5933@nvidia.com>
From: Matt Evans <mattev@meta.com>
In-Reply-To: <20260227125109.GH5933@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR02CA0186.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::23) To PH0PR15MB7038.namprd15.prod.outlook.com
 (2603:10b6:510:38d::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR15MB7038:EE_|MN6PR15MB6242:EE_
X-MS-Office365-Filtering-Correlation-Id: d008d02d-886e-49db-ecb2-08de763856c1
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|10070799003|366016;
X-Microsoft-Antispam-Message-Info:
	auhGjtyFVbYYM9xJ7atmMsCX7uTDghYcI1fNo0nn+Frc3TjIqkfrNseQKOs5fq88wRBSybFTRJpLJ6zNaMmvAQss5VfaI5iMshXGSuMpgUSJvmkshQy84IDtWvrDB5AbQ9XBybpc69WsH9lGprh5AlRKYNLk31Zcumob90HuZhhKddJw9RlgQjlDiT9WzGJOgIA/IK5aWquGBVKAk2wli2GXvMbBiJmDPfKOb+KyzUTPvdpd6opGzbY23M0Oq+sS7mXGPmw2pYbfUj7X8FK8cbaAZzzqRFzM2zCc5yPusefaDLChhuqbvQ05hSca3pJmmSfDKqDT3fy3MK+E6Jz3k1h3Av9nmfZsOhGWbyk1jN/F7U8urQ24kUWrRTlqyNhiYo6Yi9qvfeiYFffL262UsmQLFFy3hYDM/7/O9bTYcR4PEYXCE7cbySftGCSdCAQY3++1sjzmz5zWkOW+V6bH65XGDscUCRw1BDAA9pjPdbfF7yXlnnR+1+sushxwS9LN1UlxPu55AAfQtOQLSbLGlTr8kO4PsJwi4klRMTT7HSBYD0+AiW/bRmoKkvaruE0W3ykG/USxsM6nohdKi3p/5S3uBngkHJi9tj9jfR5ZIsSGNcWl3RSJoXWFpHppx3bqkvFdfEa6qegm89YcdR8cj3wMYRYXP5bm3wVYZBdzl95NH1Jz4Altpo7db11qq4v+wVKtS/MyvsaEXVkaCYhQ7wbZ7mXBu6MOzNEm1lcCMdU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB7038.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(10070799003)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V2tQclNBSjh5RFR5MkhvYUQ5Z1VnKzFncGtPaHlkaElZTC9ZaU0zZ2hja3V3?=
 =?utf-8?B?VUpjTjg0a0w1aFRkaWhlUzZIbDh4U3lOcjg3UXVuU1htMFJXZW1kdDRERy9k?=
 =?utf-8?B?YzllQmNaK0VyRkFDYlE1S2x0aEcxaGc5NTc1ZDFDVi9GK3NJaTB5L3JMcitB?=
 =?utf-8?B?L2gvL0RDN2Z6UWV3VjdXQVJpcXJ2eStLOWJVaTJWRVZrb0xoMkxhTTNMemtF?=
 =?utf-8?B?L0tsS0x2SStLakdmUVRuQ2xwSzN0Qnh3USsvMEFJUkNCajQ1bnFSbFpVQlkw?=
 =?utf-8?B?VDQxOElTK1FjcWFLRnZYWnZpdExwQ25VNmRDMk1pdHRnK1QrZ0lGaEg5M1ht?=
 =?utf-8?B?NHFuN1ZEV0dKR2M4bk5vSDMrR0ZCTlBOc2ZhRE5jTDV2RWNxZ096Q3hNZldD?=
 =?utf-8?B?R3pDWStPRUdIUzVNdTNKcGlUNjBmTTcyMW9PVnZUQmFpaHd4ZXVNY2h2c2hv?=
 =?utf-8?B?ckYrWGlvdUR2OUhOd0E3azVxM1ZURVBTZlNqeHhESHFlZGNFTmFtendKNjZi?=
 =?utf-8?B?a0kvNEFoYzZvdnhLT1c3RjhqRHVyaUNIUkNhVVFEbjFPWU13eXpST2lMcitJ?=
 =?utf-8?B?UnNybUVnMExnOGV2dWZiS0pYc1RwMEorajVVbURVclpZSVN3eXoxemxjaDFi?=
 =?utf-8?B?dzZMdnNKcm4yNEpHaWh4V2dNSXlNZlpWZDk5OEw0ZnBMVklreVVVaVNldGU3?=
 =?utf-8?B?OGc4OFdLSXFZVHgrN211OEd5dy9xM0UwREdMWTQ2aGhFa1Rkb3dudG90V2hE?=
 =?utf-8?B?bEUzSkxvS3RLWmNsN2ZYbGVWb2VLclJwY21hQXNXeGZlazFCMitiWC9JWTN3?=
 =?utf-8?B?WC9HYzhVOGlmM1d2M2IyVXc0ZC9CdTYyaWx0RDRtZW9xcG1nL2kwSXRUZ0tI?=
 =?utf-8?B?Q21tVGc2NGFtR1lWTE1LZEw2TjM0SkVQMHFGWCszZjEyR1dwdWJTUCt4MUJl?=
 =?utf-8?B?RHVDQ20ydk1rNjV0ZElIR1dNZXI2NGRvSHVXdlJKb3U5KzRPRFZ5Y0dRbms5?=
 =?utf-8?B?Rm1KQ0x2MUVnTHhQQkFmN0crRFp3VnFXZEczNzQvSkd4alg0WDlDN3F1TFpH?=
 =?utf-8?B?QjFjakZUUXNBNWNrSXhnenBhTDhBeUhTOC81YU5lL0VRS1ZDSFVJU1dGejVH?=
 =?utf-8?B?b0FJbk1tRHJ0M0ZndEhRZXExSXp4S0Qwc1pYR2dxcHdQb2V4a2xldkVBMllN?=
 =?utf-8?B?TnFvQ0ZuVEllOVAzWFQ0cU02ZFJ0V05BYXU1YlZFSUlZZzFWU2pGOUVqWC9o?=
 =?utf-8?B?OXVCWlp2SHRDTE5vVERhaXNJanFWMDJldFhaQ3h5c2JxVXZ4eHYxYmtKTkxJ?=
 =?utf-8?B?aStCY1lRVFE1bDA1TlBacTNrRi9jSmtDcjhoN2VEdEtjWVN5K0FmYk51OVBs?=
 =?utf-8?B?ckdFTFdtYnQ3em1pUWJmeE9sWGQrNVBDenlOdDRlLzVWeDR6M3dmcThUaDZC?=
 =?utf-8?B?b2hpaUY2Y3NMZzVFV0p5V0FsVFVsUDRxUHJab2gwNmp3bm0wWlJLRWFUaitl?=
 =?utf-8?B?K29PWGpkZDEvMzRTRUNjN1JFZEpQdXducXIrU1RWMzBZYkExTjlyTkRERUFV?=
 =?utf-8?B?dDdwSGVlbENWNFZHSHB2cGhpbkFZTXBnSGRVbUxMNmN2b1htOWxDY0h1L3Q0?=
 =?utf-8?B?a2YwRUwzT3VIZGp4UFpEZkdGOUdzbXVFdnpqTGlKajA5ZlRUcDZ0ZlVwcmE1?=
 =?utf-8?B?YVIxR2RqNTJHdm1tbUxRMGw4cHVwQ1hoZVk5R0NWVUVMU2JTOTI3QUt5U0Q5?=
 =?utf-8?B?d0puTUNmbkg4RjllTjZobUY3YVYrNkM2UlN5WUlrcVZUSkdzeHRnZHM4YWk0?=
 =?utf-8?B?dzUreXV4NHZNNDMrOUpyek5oOFBGakZmaUw1QTlYYk1BRGRjdWNuUnFnVE5R?=
 =?utf-8?B?ZmlMUW9tTUxhb1dsZ2NQbm5KU2tJNWZlSFJSYlE4ZXBYRlNka2ZrbGdZOHk3?=
 =?utf-8?B?V1dtakRKNWttTDFmSVhSeExFZjlLWlp0NERJM2J1UDVpR3AxYWZLcWlJczRL?=
 =?utf-8?B?MjRTUjZsWjBEaWJ6V1k4dVpGZUcvY3B1eEV5eGVIS3NrOVNYTC9URWdYWkhL?=
 =?utf-8?B?S1Zlc0JYakhqZmNtSWY5L1FRWW9rdkdab3dvN0p2V252bmZHZTYrbHM3R2ty?=
 =?utf-8?B?cUdpbkpKQWdBODcrUk4zV21uU3hJRUplMzhhSTZrd0kyVE9nNnZiaE41ZHQz?=
 =?utf-8?B?eVZYTDZrcWQxbXZDcFlrMFc0VldJRmVZTEcxc3YzMDZDNGFEWUlHSE41bkgy?=
 =?utf-8?B?UkJEU1lNR25TRzc1Y0xLdHdnc2gzd1ZwWGlwVTR2TG4zZ21TNi96TXI4WmNL?=
 =?utf-8?B?eWlqajQ3ZnRIczdqMUFLaGpKRWl1QzlTZ1R2MGVQeVRrT1VJZUhtcnN2bkR6?=
 =?utf-8?Q?VXdDz99pQdJ3FeJU=3D?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d008d02d-886e-49db-ecb2-08de763856c1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB7038.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 19:42:28.1132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qs+wtESPjOS++kaYAS3tngKpZr5izCtXkqqsjrOL70dUFDKaaRsOkQ8j+ad7U9gM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR15MB6242
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDE3MyBTYWx0ZWRfX5eoGKr0nOZ9d
 GmWwiGAYHEpHfsVj5SxuL2j450rq+bz/0nhGo/ojaFEzwuX3148rkzRA6yboxR9aDYu6JG4FWJi
 hlpYKef2eCHAFVCWlKIErWkux+RsZHukcy+B4oh4B1m7v38oeZPbusV2bhJovI+y6l/vVojqd+Q
 EQQQPTqeR2aJUT/pCoq0twj3gdmVdNw1W2cf6q7+C7EPXnMormN/M3NSjTskwb9qnTQoeseo5SS
 BiqxKgzHO2cJmsYIfSs0kww3J/wFXLkzuZ3YZV8gem56Ut3KptsJmMHW5a1XyoRHv5D5v+QVDdW
 /cLt0oP6xqkTNIkCDzS+QLa58WTVsg5GbR28+R8iSXFG8LXF/dhqgWc7WO9Tlj9+vy667i9TFTA
 sAhBcguPGdw7hMA2kQKf3b6N6hDNbHMAssc1xdYinrTYlFWBteAGm1/CnCbnY4rWK6s5TEZznlQ
 i1ppofjQw+fjlxwyjlw==
X-Authority-Analysis: v=2.4 cv=A7Jh/qWG c=1 sm=1 tr=0 ts=69a1f3a8 cx=c_pps
 a=9AjoWhdl+q7f6/Aw5qa/DQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=Gp_XjBoH_XgP9xz1ZW0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 1jwUM4lGYqt3ez7jr7wcR4HdXJA6ZjtW
X-Proofpoint-ORIG-GUID: 1jwUM4lGYqt3ez7jr7wcR4HdXJA6ZjtW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_04,2026-02-27_03,2025-10-01_01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72203-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,meta.com:mid,meta.com:dkim];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[meta.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mattev@meta.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 5FC541BCFB0
X-Rspamd-Action: no action

Hi Jason + Christian,

On 27/02/2026 12:51, Jason Gunthorpe wrote:
> On Fri, Feb 27, 2026 at 11:09:31AM +0100, Christian König wrote:
> 
>> When a DMA-buf just represents a linear piece of BAR which is
>> map-able through the VFIO FD anyway then the right approach is to
>> just re-direct the mapping to this VFIO FD.

We think limiting this to one range per DMABUF isn't enough,
i.e. supporting multiple ranges will be a benefit.

Bumping vm_pgoff to then reuse vfio_pci_mmap_ops is a really nice
suggestion for the simplest case, but can't support multiple ranges;
the .fault() needs to be aware of the non-linear DMABUF layout.
> I actually would like to go the other way and have VFIO always have a
> DMABUF under the VMA's it mmaps because that will make it easy to
> finish the type1 emulation which requires finding dmabufs for the
> VMAs.
> 
>> It can be that you want additional checks (e.g. if the DMA-buf is
>> revoked) in which case you would need to override the vma->vm_ops,
>> but then just do the access checks and call the vfio_pci_mmap_ops to
>> get the actually page fault handling done.
> 
> It isn't that simple, the vm_ops won't have a way to get back to the
> dmabuf from the vma to find the per-fd revoke flag to check it.

Sounds like the suggestion is just to reuse vfio_pci_mmap_*fault(), i.e.
install "interposer" vm_ops for some new 'fault_but_check_revoke()' to
then call down to the existing vfio_pci_mmap_*fault(), after fishing the
DMABUF out of vm_private_data.  (Like the proposed
vfio_pci_dma_buf_mmap_huge_fault() does.)

Putting aside the above point of needing a new .fault() able to find a
PFN for >1 range for a mo, how would the test of the revoked flag work
w.r.t. synchronisation and protecting against a racing revoke?  It's not
safe to take memory_lock, test revoked, unlock, then hand over to the
existing vfio_pci_mmap_*fault() -- which re-takes the lock.  I'm not
quite seeing how we could reuse the existing vfio_pci_mmap_*fault(),
TBH.  I did briefly consider refactoring that existing .fault() code,
but that makes both paths uglier.

To summarise, I think we still
- need a new fops->mmap() to link vfio_pci_dma_buf into vm_private_data,
  and determine WC attrs
- need a new vm_ops->fault() to test dmabuf->revoked/status and
  determine map vs fault with memory_lock held, and to determine the PFN
  from >1 DMABUF ranges

>>> +               unmap_mapping_range(priv->dmabuf->file->f_mapping,
>>> +                                   0, priv->size, 1);
>>
>> When you need to use unmap_mapping_range() then you usually share
>> the address space object between the file descriptor exporting the
>> DMA-buf and the DMA-buf fd itself.
> 
> Yeah, this becomes problematic. Right now there is a single address
> space per vfio-device and the invalidation is global.
> 
> Possibly for this use case you can keep that and do a global unmap and
> rely on fault to restore the mmaps that were not revoked.

Hm, that'd be functional, but we should consider huge BARs with a lot of
PTEs (even huge ones); zapping all BARs might noticeably disturb other
clients.  But see my query below please, if we could zap just the
resource being reclaimed that would be preferable.

>> Otherwise functions like vfio_pci_zap_bars() doesn't work correctly 
>> any more and that usually creates a huge bunch of problems.

I'd reasoned it was OK for the DMABUF to have its own unique address
space -- even though IIUC that means an unmap_mapping_range() by
vfio_pci_core_device won't affect a DMABUF's mappings -- because
anything that needs to zap a BAR _also_ must already plan to notify
DMABUF importers via vfio_pci_dma_buf_move().  And then,
vfio_pci_dma_buf_move() will zap the mappings.

Are there paths that _don't_ always pair vfio_pci_zap_bars() with a
vfio_pci_dma_buf_move()?

I'm sure I'm missing something, so question phrased as a statement:
The only way that mappings could be missed would be if some path
forgets to ...buf_move() when zapping the BARs, but that'd be a
problem for importers regardless of whether they can now also be
mmap()ed, no?

I don't want to flout convention for the sake of it, and am keen to
learn more, so please gently explain in more detail:  Why must we
associate the DMABUFs with the VFIO address space [by sharing the AS
object between the VFIO fd exporting the DMABUF and the DMABUF fd]?


Many thanks,


Matt


