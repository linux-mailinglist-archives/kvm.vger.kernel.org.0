Return-Path: <kvm+bounces-57755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D064AB59E0F
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:46:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 61ED51C0288B
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:46:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDEB9393DC9;
	Tue, 16 Sep 2025 16:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="FIDbDRv9";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="DF72s3XD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162B132A3CC
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041105; cv=fail; b=o9vLM3c0+78bSSIUqw5ZLVjSqXNhgO8cACw6BhwfgOlmRvTD3LIADvIaC5+e/orKaG7QQFH9uo9ybQ4pWOxOopzT8hq+m1ZjhSpLSksPmLHOaXoFmW8J48e3iJ+aM1/S50cJ8Gzz+p7iO3SLbqsJGFrm0PYyi7yQEKkCIcZr9Do=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041105; c=relaxed/simple;
	bh=NrkwkzmK+QSdv09Z5HwbSQDG6+ZHOAx0F7LLb9hIwG4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QZM7AIRY2lMGUFlX+hTnPfyU9Gob8StVTPDpb6sQelRplAlAXwg6mX+HxvrSSLZVm6aS+SbAj6XPme1i922HBhj0uK5f3FQRB/4hAAR/vX4TvquE3Ni74KhCiuEZaj1DzYCtwCSoMuknwYrQZQu7FkAKyvWDSIMme69H6mBj2cc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=FIDbDRv9; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=DF72s3XD; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58GGQop23598621;
	Tue, 16 Sep 2025 09:44:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=KD9MyZfAtyzU8QUVR9RUNtWdScgb1lTXJJMvU7jNf
	g0=; b=FIDbDRv9rav55OxTOiUETqVx9zs3PGIaSbZyCttcwXK9egt8gWrTIo2aK
	+Tw+OxCW0UWvkMGmmypJ0Q/cu4YW9/WiA+8GuRUPjtflH9DGfMUrGVokcl0VqtcN
	8SOGTd1cKck7Ov9pkjoYOpzbKV3TazgvYemsB2/YBjnps5u1+jjOelnef5/FjGz/
	/bxZGbLl9yoJHOrR70/KQRqQX78H7T2+Tbo/84CN7QmD0GlJ2/drfY2F7Y8cyq2z
	ZVDGCQZ2sSzfu4qLHTNEHXrrjjGn1GtPNiYA2O0+oHMiiE+4rf/DcQz7q5f6HzXy
	yDTcY+9fM6d25M8iYWu6nZzOD0ufQ==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11023077.outbound.protection.outlook.com [40.93.201.77])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 496pby2vkt-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yd4+TDGuLAnmqacTGjVRpNNSuJV6JVNNN2Va2fLgRGSowXytm6ZHCj5+0DpAe7Gas7B6nBqVy1l1WhSEuSp8IYIo1q9Yf0aWCPuCqZmn57yQa4oJSs9Ae1u3XUuKEGBJ6aicYpcAM4NcpsDaBdoE5Ey+m5Cmt/TG77RCatprtpZMJVPpe7WHDsp25PE4goIXxWkS3k277XwyOzh/JUPTHTuwbtV7LpPyweMQf+hUrju4RF/xePq1LGnoDFQSxzhT/W35DKJT2ggfnmfIk5htfGKdlKHH2l79Xna2MnjfLWRtVx6eH9ur7xjKbo58Gad3eP2roatIqlk3NZHu1vM+QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KD9MyZfAtyzU8QUVR9RUNtWdScgb1lTXJJMvU7jNfg0=;
 b=ExWYinO/gqNATK2HyBIw/w1aYfQELGkiNsByafw9HrHELpAByeV9GOreIYu8E3wzyHWZZ7lkXafuW8JUfKl1wak93dzRCUN2gbRE1sZC+qRUR/uFqBjBtkVsxN8lzN1VDGX4cO9u6XzuBlHYatPLmYnh75TmZE7MyyCcP1oxyyNpRsMl1dw/iAHBFMVgXMXG4sTUw7Z3iK++NKXTTT06QeQZRUPzHvmJYfbMf+O1dWZc/Id/N7ZnndjqygxI2NsoxWn1iMyTh8NjkcuBJRwDl5Q8jm1GefYAvTx8mJ+9e6u3k1XlDeKbB1KaOLnZJfoF9VGFr0IJ/puQvBo5JWsbqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KD9MyZfAtyzU8QUVR9RUNtWdScgb1lTXJJMvU7jNfg0=;
 b=DF72s3XDfcgPN5Dsj7oX9AC0MHqfei/xi0TPfMcWyYuglMoaRpo6DOe3DC1znWWyocbMgQF/7OjfqjwRFYtg5hgcGet1TE7GWzKnC2Y3mwo2oRXyNcPGECOXcgUXfbE6D96fxukvf+N9CYKGokg9XBClfXLvSBjXwKbL/S28LMuBn56C0DxGfqsvkFjwjHm9kDxqTiuKut692PSctXNONfm7PTsYeW8e3LnPAIIay134vNm/h+8mBlCTckQUZPjdiLlj8I6wFYhs72IxMbH9obZF6ASCYu+doqhLaT0NKZhJcPRXcn+2kKUgDXJYaQh+Csftwc/zmCc4YDw8K1VH8g==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9620.namprd02.prod.outlook.com
 (2603:10b6:8:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:43 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:43 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>, Thomas Huth <thuth@redhat.com>,
        Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 04/17] lib: define __aligned() in compiler.h
Date: Tue, 16 Sep 2025 10:22:33 -0700
Message-ID: <20250916172247.610021-5-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916172247.610021-1-jon@nutanix.com>
References: <20250916172247.610021-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013309.namprd07.prod.outlook.com
 (2603:10b6:518:1::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|DS0PR02MB9620:EE_
X-MS-Office365-Filtering-Correlation-Id: c09fa4ab-08c4-420b-f062-08ddf540567e
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BS8PeYWo5z5ae0ej7+2perlxWa6XKKVHlMUYZDGMoO1xhUkkj5cr0SicGEAn?=
 =?us-ascii?Q?XBnfWV1EJ5kztqRIVcKPaCA7UBRWe7bt/xDjqeAv/56ZSw0fOsF7HUdXxEBt?=
 =?us-ascii?Q?kr/wxs1sCpojZBQXzZyPkwFPgvVlYvyPcvL5LzPjSmoHa15onLJ3LhXId7+N?=
 =?us-ascii?Q?ihOAmMR9egkJ46d/F1Gob7yydU15eG21NK1MMppZhBSFF4kYj+fWsceT8OkU?=
 =?us-ascii?Q?1BWZzSV1ZkZmA8EsjBNv209AX1KaDTcavpb+7fhxiIVsecCxb74OdwLlNLBb?=
 =?us-ascii?Q?eXqvcsyGC6fwQRfvw94PQPkyyX4fwR/BgUZjdNbHHBPvkoPqfmcdNxwiq3ls?=
 =?us-ascii?Q?F5NyAS4UkAGmPuaktPY9wc2MoNGGZsZP4EmsJFW8cozfLa/Z/rt8xUFVU+IC?=
 =?us-ascii?Q?zatq5t26PRwdKiJLxIihgpaQKv5klhdoZ7B/09OnvYMY99oTdVrsAI9JjpUQ?=
 =?us-ascii?Q?Qu57/JlJFtZJBuGuLHRGUWnF/+YTqS4bmcbxa1/rrsLxcWdGNHw2Ho4tToB0?=
 =?us-ascii?Q?i7WmOtvyz2Qv0Wn9eM/2GGc0VCIICAAxM2YCnsjmbPdgB9fBMWO8xe2l1mVH?=
 =?us-ascii?Q?7zpdGAS+F9ltM5NmHAIkhYEs/VcfVPdlLob1eZEAOeOS4kyh94vDZOb6UksX?=
 =?us-ascii?Q?od2TlQc/No2wO/7d+7ynDDLXdQuMbG071PitbnnRLMwsCyZNdwLZO30l6pDt?=
 =?us-ascii?Q?/AwZRUgIpvHlNRW2Hipzv2xzVaGXV2f6yH82b+fvWFqe96xVjAEehndqnkv6?=
 =?us-ascii?Q?lmdArHMgRq8AwecoIdCLkL8rOhpus2C87j3lJfhgqFTvvrKNv5EHvBeVwoal?=
 =?us-ascii?Q?I2Lf/X16rGrhbRoMTNytIlQKGeZGlmn9FKRi5xPgUF7lNrKTZ7kVpiV/XNAU?=
 =?us-ascii?Q?GIJ+NIS8iwUKbczBzkaN+WMa02SMEwJAzTiGP+FQnNpd4yK/+gP/4aPHKC1E?=
 =?us-ascii?Q?RzI3lfyfONypBhEZvopTfoPURDrpGXCWcVCtVQsb+zFbKeUno776X43gCrU5?=
 =?us-ascii?Q?gfdB8UXtCQdtGiiT79XAPmMf10/ds+YRU8T6WwVC+2k7Rbf//XZzxtxOSr3t?=
 =?us-ascii?Q?6Jzy7aCu94bVNir9bfCustBfG5w2+NCS0Q+8t7irbeVN1JQUEtrLqkWOfODW?=
 =?us-ascii?Q?BBh2VJZLVE6z/TYsbz5qn3KvLdy3DeIrFyHjc/gPF5gI/DWMnlHAJJPgYHUv?=
 =?us-ascii?Q?KcF01b0LYLGEpgk2zzGHm7DgZYTETClH6SppkUO+VaX7N6cSxEsqyLHBD1Rg?=
 =?us-ascii?Q?pkb/oEUviuYlIXLsSVFLnVlTgBaoxoGPBQ1O77cYS/IJPV26xdxk1MtR05We?=
 =?us-ascii?Q?WJ2qjLYpM3JtBmgNRzD0nKJ7Yq3Z2akJNnrg/ILWd4WCBYVofKtOPNG0LCxB?=
 =?us-ascii?Q?5YTJLWqxBAHqE+huVs9nNxpNhWmMZkkTXa73RWsg199Xw6hS8rL2zjtsoFiL?=
 =?us-ascii?Q?Aqd8X61Dge+5B+9bqG7tnYq1gCTkQWtDqUzpxmIFgZqL7h0RG8cACA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LEDYw2UmVMVVs0bK3qWStvvpPpey4iURwZ1dKLhq4r0nup2NkND3uMA2c3m+?=
 =?us-ascii?Q?bYX1BWUp1b25GZD+zLMtqzoKKzfr2fwP0PfWgUOEetBMGunQ0ucqKxYQgZ7X?=
 =?us-ascii?Q?A5+uAjUNkDofc9M6PArqev92vogQlod6duarzJg3SbVzSr95Shupc+I3rsyK?=
 =?us-ascii?Q?rm3c7FTUqzN5Ki+LYhhWsjfbVzx5vU7f2buhUluehfrYe/n5/B5kfsU7//sw?=
 =?us-ascii?Q?cUwer7L2WfHzX2Qnt51pzuK7T5r5seyTY0xi4w2ilZSmYbc+0gbMc4sqIljY?=
 =?us-ascii?Q?ylf6W+sgtoS9NrnRMl8r9WnpSQNx233AnWb64Cs61VH4nGWR/YRud5MNbURX?=
 =?us-ascii?Q?9/UvupVqCqY15j9oLrG46wR1+UGrYb2w5ebbzkEbNU7ON26St0QqEfqM6fZa?=
 =?us-ascii?Q?qNVboGt4I6HVvoev6Y+/E8bMBj42JcVBEoP41l+7m8MZowugqCy6PQXjm33p?=
 =?us-ascii?Q?VkqicpyheoLO2HBizZQiXYtXvSWn5Hox/NIeckT94cFp66cJB06TCdYt+gXC?=
 =?us-ascii?Q?tQvMHmkoGqeO4v5TQOPAfUM/60nIU2Rev02TcggZdaUVmAmS8Z8Znuhqs4bO?=
 =?us-ascii?Q?e4CCApW7K/5TP3phRbQkYrziE2Jpds2zP+7wBYQpuTo3x08BJi3w746ygYHx?=
 =?us-ascii?Q?GdpL9CnxELWsKeSeQnf0zbcJ8sTtxAgN6gr9gE6XU9Oabl+2zr13Gjfn4Ufi?=
 =?us-ascii?Q?azQwpVxgP5XScpE92TYQVchQqJU/qbH/zScIOVKnSoNJ6dK6F+9g+y352ZO7?=
 =?us-ascii?Q?X6fr2wqq8pSn5jAfNfrVLX4JhYJDCI/zdWlSGmslVPB8n8WrIw9hmJsipSyN?=
 =?us-ascii?Q?+2OU7nnYlm0NuicDgBuKd2wot3nwuORPafP+bw+Tn4ixhY73dspDpEBqoL4B?=
 =?us-ascii?Q?kqDmGrYobcMdS26OqVPbV8K4W7rZ57oEh8SzrKZ0sl4fmOo4eBQZHDf7IS9R?=
 =?us-ascii?Q?GTxP/9P4iCCzbF/1g2ITt3RVTLlVTvTCjpoWUhmqBHRYZCUgFADhaUtXeOOE?=
 =?us-ascii?Q?gxyc+oeyfd/+3tLiOiHN7l/l3OElMJq25RIHgvXEVKBOT5xqjDNnfQcoTWEk?=
 =?us-ascii?Q?Goan2m+qaxvB4JrfrenJA3r7kKOvbtPArXxid0J9eWLdbfNlnuTg1wPiMiKO?=
 =?us-ascii?Q?LpmwTq0Bz30AW/qaYdGHpBDfaBUVneYuKNqbDRnUacvie1Ic6jVpaLwupBJo?=
 =?us-ascii?Q?Hanq/JqsbpyZluWNXqZHRxQ6DeAxOOSr0Pki4VWCrOrMu1tNkqLb+Oj112xo?=
 =?us-ascii?Q?Dg2rPeMCyDIgeLnWOS0qgNP2IuuZeBmnkYAKK63KA7/JiTTclVL8GWfjN1yJ?=
 =?us-ascii?Q?uGoU7KKjT7WCx/S0c/n1DVWdGrbYJ4p+49D4EnLPZnQQFl+5kVOUmgUoKaqv?=
 =?us-ascii?Q?K/UPHuQ8BFNxV3+1W88MdsfRpfNUFcATYY0uDpZ5etoLiPR9aXuYzsMZka9w?=
 =?us-ascii?Q?IZOA1gn4QaHqLYJMRJiqY2N4831OhkAta1DevqrCUmP3Ok2Ol0pjSxYo82pp?=
 =?us-ascii?Q?+lWgvCIv7fQHvEbqMr9Ipik06C9EctEnQc05eIlp3AcIu8SSBoQ9RSZO++Ai?=
 =?us-ascii?Q?5T7lVTUPYc1nHEWC3tcKOd+gAc4YDJDs2m03VdyM40xxMyMh1H36cOZb1qpE?=
 =?us-ascii?Q?Nw=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c09fa4ab-08c4-420b-f062-08ddf540567e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:43.6520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p3+kkCBztwqXP1M+9DbEGEzcsdCimUCQ+abiA5aFTm0FSdFxyABTjPwiO8G3Bqro7g8QF+iTrbd8n0YxjdsBLHG2ymUpDGtOepK1LhdNHZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9620
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX5oeBZ8EC/nzI
 +cAclIhNQ9Qi4E71OgkL8b4clnZAYQYsJxccB/0qziysMrzpG54khCCEhrQJa9eSAfc/+0OGw4a
 EA3fm8u0wiJHkDgqYTCS6avDe+i1ZSQgUBw7F4R+L/wvQ3eobWxkMxfL5dKx5BEOpJXyzKHBZTK
 tNj9FSPNgs57oam1NjAPSvhm1Py9j0K5YfkmchUzVcR2Lx15MN8i8iKpkIIJO4qA1wuek5DdgSL
 BusQAjGqlviHeVQrZOKCCxXeUh+ylJnfR2wtBnHxFuAmeJgo+NkAbsGnkEYIJB7X8ZpEf5/RymE
 CKXOC2ykj7+ajvDNcuHK82vnqwnAO4nozWSdewte+8Ydiwh83bJunG8+QxBXgA=
X-Authority-Analysis: v=2.4 cv=ePoTjGp1 c=1 sm=1 tr=0 ts=68c993fd cx=c_pps
 a=YgmEgYFPUO0vKsAsXG+6iA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=KWSg5PfvyG5qMYVu67YA:9
X-Proofpoint-ORIG-GUID: 1uoCcfO0k6rhq816NtmJE2iYAd5rapk9
X-Proofpoint-GUID: 1uoCcfO0k6rhq816NtmJE2iYAd5rapk9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Add __aligned() to compiler.h, copied from Linux 6.16's
include/linux/compiler_attributes.h to support __aligned(16) in vmx.h.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 lib/linux/compiler.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
index 8e62aae0..5a1c66f4 100644
--- a/lib/linux/compiler.h
+++ b/lib/linux/compiler.h
@@ -54,6 +54,7 @@
 #define __always_inline __inline __attribute__ ((__always_inline__))
 
 #define noinline __attribute__((noinline))
+#define __aligned(x) __attribute__((__aligned__(x)))
 #define __unused __attribute__((__unused__))
 
 static __always_inline void __read_once_size(const volatile void *p, void *res, int size)
-- 
2.43.0


