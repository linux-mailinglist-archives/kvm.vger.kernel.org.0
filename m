Return-Path: <kvm+bounces-66589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 89224CD8190
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:07:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 11BD230595BC
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E4E2FB0B3;
	Tue, 23 Dec 2025 05:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SnjTEsrb";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="GXXA/aqW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF182F3C2A;
	Tue, 23 Dec 2025 05:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466304; cv=fail; b=ipj+8mC+AcEDl8btUHcFK4AfUeTFHwXzojxNWPlMbjuYhmsOLWmrzwDQGACf5id7YoLfCquiH1SWj7ZG8bzrElpQP+rFaDDybYKvHDVvLjuJXXjZawHfTbeiG1rALq6K7GFML16DawtGe2GTutTx6Qnqc4NM9BsUq5Dy+s9tFVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466304; c=relaxed/simple;
	bh=LHKUL8fNUnWTaiKlYUeigLE+loZtrr4R3EWjS2bXAlM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=ciU5ZQq7HxeLBvFFyM9QKyvEfpAlDPkLpAUH5rsAYgYLfPK1MvfmhlqHr0MFmDNTtoSFvTnvZxvam7vfOASd7LW/DidnVJFnICuraLocUfNflCHrvNRZY93wrMlOK6cmchbpKuLCOaFhlOHdGIqs7CMvRhW+qwBsmXzkSaeC69Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SnjTEsrb; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=GXXA/aqW; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMMwroV652844;
	Mon, 22 Dec 2025 21:04:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=Fl6XI6t164Egp
	x9PSQYXnmt6vwJoGJXy/KwVchWMsJQ=; b=SnjTEsrbLl+dUaaqGqBs84E0Bhypb
	+wsjgY5+h8sGuoxnx+ihjc3IUbd6dtVjjOIrG6TK+L8H3cWLQccmjlsoQ9WnLx5M
	YACaEQ1XJHgTp9uCCsofEYJ93qi5shJWieaUt4vts0Sjils0rdXtKRkDxe1Mh7/O
	yMGT+wGaCCLHYObDpj3VYtadNHvHoNEs+Wx3AjXfILqpH2/YCUyejI0/tbRlMOL3
	ysRWnQ7JCszan8ewHNHF4miPbaFs8UThWH/fLn+T2udO2q62lhDgxU7TTFq10HS7
	oABygEf3hmttJULVmw7PuavzTij9GCMYsAqFuu4M7f0yVdLwYXn/E3kRQ==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020109.outbound.protection.outlook.com [52.101.61.109])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5tsjmwuj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:04:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T5waU31crOzjGolZ6pDIVADtttHcngTub/TNTsSjDg0r27yStvPCjEY8LZElxNGAwRYMIJ+yFU1RZ9mIV2oz571myTk3ap8NWEbi95fFm1b1i+1qtMLmRAC7+8Flgn3iThWgNHA6sZPhProl2+Qhq3zArP1FuRCuMqaYZwbl/6jPWn79nExe1q7YiZmfpKuYXF6Een4RENLEMuU17YwQITqwQxzGPrlP1Xc6qOAW1KdSEESko15V7JmlsGFbnSQxICabdtVcjEG4hQTRffLTrN1gFL0g7nqBFLYmyD/tLvF78mIutgcMZQue7CNk0O7vAaXzZZWebV76gz4viFWXag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fl6XI6t164Egpx9PSQYXnmt6vwJoGJXy/KwVchWMsJQ=;
 b=SI6TarwQIjcAvsZNnuhqRkUDUSfOvvzZfjUvo/TKf2yPBAubBxrrgwg4gtjinXjsbM64NC4iBh0hmp2F/YjDTCkeUAKrtR+bdYhNcb5BufX2iny27vNG563GL1JU7gt1euMxN1zN5wZvDnp444WFkhkenlB2CSX9EYTcNHZXeW+rtyTFvceTSgNFBvXscbH8MUn3AjXwIGU2ETucg5jc656r2pzlQV3roi8gwsrvU+q12m273Rw+MBFM9nr39uCKmsHLfNuYh85cFhp3gppNAsO36b1CiLxjOi57FJHU4O6yrVViLUU7oyyoq9wTxA9UriyEvHi0xSbnc3NNiEtuDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fl6XI6t164Egpx9PSQYXnmt6vwJoGJXy/KwVchWMsJQ=;
 b=GXXA/aqWCpEl2GRQL42FOelz1eEuZr+/BiPRLNTpDsdaJfbIXYsdjSU+/tlQcE21JGBiRq7Yn0sGHCsV8aykZV/Het8Y1Mk6Ka07IlMtsFbju6omh3uSkQPKAksEE1G60Z9D70KKTF8b1kQ1Gc7q8ATVHKyiL8RLa8YdDAb4j2eaEy6XhXRp8MR49FAD+daSgrzZuN90DSJZbAtfb1cEMP7SmjpAfOGc8eYC8TPT8nfc7TxlDkAQdxTY0zWap3QgphZgG3f34zPYBPAPrGeh0npFN6ntm1sHWHXLpmYLPiGNXmnOfXegTRPplYW0DbhTASwukEd5aNW2SBkHRkmxMA==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8560.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 05:04:22 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:04:21 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>,
        Rick Edgecombe <rick.p.edgecombe@intel.com>,
        linux-coco@lists.linux.dev (open list:X86 TRUST DOMAIN EXTENSIONS (TDX):Keyword:\b(tdx))
Cc: ken@codelabs.ch, Alexander.Grest@microsoft.com, chao.gao@intel.com,
        madvenka@linux.microsoft.com, mic@digikod.net, nsaenz@amazon.es,
        tao1.su@linux.intel.com, xiaoyao.li@intel.com, zhao1.liu@intel.com,
        Jon Kohler <jon@nutanix.com>
Subject: [PATCH 0/8] KVM: VMX: Introduce Intel Mode-Based Execute Control (MBEC)
Date: Mon, 22 Dec 2025 22:47:53 -0700
Message-ID: <20251223054806.1611168-1-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH0P220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:d3::19) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|SA1PR02MB8560:EE_
X-MS-Office365-Filtering-Correlation-Id: c7ced8b8-e6d5-4a90-cb2c-08de41e0bc2b
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|1800799024|376014|7416014|366016|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eitnY3M4SG9MWVhOTUFlSGwxODFmRHFlNTlNbTUyRThjRTYrSnV3TEh5aVVr?=
 =?utf-8?B?M00reVdJdlZUSWo4aWg3aGtYYml6bHFBaTdaWGptOG5pY011c2lJa1dIM2pw?=
 =?utf-8?B?ZHhkWjhHRWtqR3ZvY3Q2QXdTSlNhc3B2UnFWWjJyVnV2RzI2OXcvZzhBSmQ0?=
 =?utf-8?B?VGJLbXRZdG80bXpFcW03Ump5ejVNTWtOd1VNQXkra3NOakYweGIzVVdtbytS?=
 =?utf-8?B?dlVCdnVTazFzc2pKem5YQXlZSDM2N0NWN2c3TndYa3N6WS9JTXpnNkdBYzN4?=
 =?utf-8?B?Wmk5RG5ZODBzYXFKTmxWN0VpVmtGZFhpaGpiQitIYmRTc1Y2aEw4KzRKemVV?=
 =?utf-8?B?K3paeU1ua3Z0UCtrSW1rWXFqaVpDRk9tUm1sMUZRcjBJUVBJemJrbE9jc1c2?=
 =?utf-8?B?TGk2WTNQekFVSm1xQTFlcy9kWHc0aXA0cjdlZEEwbVRwRXA0REk2Tk9zVTAy?=
 =?utf-8?B?bzl3cGJpYjdZMHhQbUduaGZ5ci9lOTVsVHlLbmtLTStFdzgvRFhMbkVpWGkv?=
 =?utf-8?B?SkxIWnJodUVrQlJ1VXF3WmtETE1BR3JLT1Ird2xaeTBtMkJTUUJNN3A1S3dt?=
 =?utf-8?B?OEZTZ0FQOTcwVGxEN05XWFU3c3d0UmxZdmdFa0pBY0cvajJTN1JuRXlVbElR?=
 =?utf-8?B?ZWZNbGJvdzJNRHFCNjVGQ2NTbjdLeGl6UzFKMUlrN0twWmx4RkpJVk1USEVp?=
 =?utf-8?B?VDZNb2I5cDFOQjZoTUExYkJ5QXozSVIzaGxQQ3JGWGx3bGx4cDNjSENUS1Vy?=
 =?utf-8?B?blJ4Z09wVGxCZ0wwb1I3cFVOdzg1MWZWQnpUdkVWcjMxS2FCR1lTaDA4aVIw?=
 =?utf-8?B?d1pIL2tJaXIxQWZ2d29SRVVQNUEzMTdiTFZOZjNuRjZEK2pyTlpGbXpUcisr?=
 =?utf-8?B?QjAvdXMwa004V1U2WVM5UTNpK0xOZ0RZQUoyaE8vTml4YlZ2SEpqbGVpeEZv?=
 =?utf-8?B?ak1xUEduTUx1aHBZeXpsVDJuSUJaVjY2dmY3NVFtQm1nbXE2NlAxbkR4clVT?=
 =?utf-8?B?TE0rZnE4TC9PdkNvaTBRaWdveFlYQm9FNWN3eGJxOFhCVGJuNEVocmV0K2pW?=
 =?utf-8?B?ZGEvWjRWYVJCVnlGR1Z4QXUrNEZnS05ybmZFYjhDWmhBcTZJRlYvTDR1cmw1?=
 =?utf-8?B?OG53VnlKZTB3Y3Bock41dHc3YTNvakNaSjljNFpqdzViZ0hydUFNa1VXY0c4?=
 =?utf-8?B?K2pPa1U2dWREUkgvMER1cFNrQVNQMDNoS1FhK2UyalRidmYyL240ZklpYlJs?=
 =?utf-8?B?QWpKTGx1blpBRWlaR21mRWM5T25IZlF0UDdwaThlaTBoR0crREdQNHVsbkQy?=
 =?utf-8?B?cTdYajhUSjJoYnFjeEl2cU1MSStCWUNnVGxJK3dlcFVZcTFQaXFGQzhTV3RV?=
 =?utf-8?B?TEdlb01KcThMQVZNUCt3aktWWTBZM2ZpNXpZbmxLc0Zld1p4L1N1L1FVT2Yw?=
 =?utf-8?B?UFdyMzhxNEw2dkIvdm53RmNWcHMvcC9kVDFra0VOVGhDdGx5ckpxcFlEU0Vo?=
 =?utf-8?B?RmUwUEdsMkVaZ3FoMEZVaFJSV1Y1c3FOU3dHcGtxQXRSSW9OeFd5Njl0U3Z6?=
 =?utf-8?B?VXlSR0QxRkdSUjBxTmk2STN4dkwzRklEbFhwQ1BqWVJRUFJpdGdvSXdVOXlC?=
 =?utf-8?B?SUlDUU1mbkxSVXg2ejdsK3dUekljTjliZXBnbW1rU3pzcUVBcXlDSmsyQmlM?=
 =?utf-8?B?YnVMY1d6MVN5ZFY1UHpUTjZmUENTS0c4YnJpMHhWV2t5NGlLeEtBUWxLcmVS?=
 =?utf-8?B?a3JPaUIyZ0FpMUlzc3hEWjVYUjVEY3llS09NNWJpYjNlWitoM0NlV1IybXpN?=
 =?utf-8?B?VitvQUIxQXBHbEJPblR4b3hrdWpNNW1ldHM5eDdYKy9YRzNTTWdjQ2NNWk9O?=
 =?utf-8?B?ZTRHdlVRYXFSZTRMM0VRaDRXMjR5S1ZZeTFnaC84ZXVGMjNHSjBhTFZ5NS9r?=
 =?utf-8?B?Tk9LRmg1NjZObzFQdkt4ajFXZlYrRThMZ1A4MkRlRlVTbVcwb2ZkT1ovdGln?=
 =?utf-8?B?dEZTV2ZlMjRYbTJRSzlveFZsOWRqOWU3Ny9BaDlGUDZUcWYyRjZGa0FkZUFO?=
 =?utf-8?B?MGo4ZCthMHpubXczb2FlQUFpYUFNWDdaazJEOTJGZ1g4Nk9VMHFBWVVVTHU3?=
 =?utf-8?Q?cP8A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(1800799024)(376014)(7416014)(366016)(921020)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RFh5VzU3OXJlaEJ3dXB0T0NNaG5kbDVxV3pwejBTUlRPbGlZUWJOSjhrbEp2?=
 =?utf-8?B?Yy9keUJ5UkY3SC9XSU5ZQ0h5SmRFZG5PdWs0ZDFOWjZvZCtyWFgzdkdmUng1?=
 =?utf-8?B?OXFLVlQ3R3cvYUpjanVzRGhHeURYU25ZMXZCbVlva3QzMTJyLzRnM1ZheFI3?=
 =?utf-8?B?NGZwOFhDclVVN0lHbElJajY1SCtGckpOTU5uSFg2L1lXUTdhbkhaTDFQRWIw?=
 =?utf-8?B?MnJZZ2c4UmtVQk5qSGswa3ZYdU9XeEdGS0VHK1NJOElxaVVmT3hNU2lvNW1w?=
 =?utf-8?B?QWVrSEt6Uld2WWlKTGVvNlZWWDh5RWZPT2cyOEtLaEdDNUwxMWhLRmYxRW10?=
 =?utf-8?B?U2pTWmdhcWVYQk5EUFhBR0VyRXMxb3U2bEdqeUhYSmp5NmhOcXd6ajVlbDFl?=
 =?utf-8?B?RlEzYVp5VUNMOUJ4UDBXcHVGNUttelp1bWx5S3U5TUl3VHhlMFI5akI4cVpx?=
 =?utf-8?B?ellCbUM1bkZzU0NPZkJZVndDay9TTlhlWkN5WWlVVExxOU9RYTlrdngwbDFz?=
 =?utf-8?B?a0N6b2lWbWRGTThJLzFOMkNKWXNtNEJPQ1VkZWNXR1VTUUxvRXVuTEhKRlJK?=
 =?utf-8?B?S3FRL1J3VkpneE11WWQxdnFSZDBidHUzT0tqWFpnVVNDTnVwWks3Zk5NMER1?=
 =?utf-8?B?WkF6UVhHTTNlamN1WndEYnZ5OTBXVjhPNHRuRTJzUWVtMkhzNG5aSk9zMmJR?=
 =?utf-8?B?QnpNaEE3VFdwT3ByN3BpOVNaVGNPNGJveDJiM3FMS1ZBQ0QzWFdxbE1tSmEx?=
 =?utf-8?B?Qkl0cVpacXBoUUdBR2s4azZrcmxiTHBoaU5obHFudmZyRjRteEMrVXhqVjBZ?=
 =?utf-8?B?VlJEcmcxLzZaeXZONjlpQWU4TTVyNkZSb09DL2MweDZ3a010VkNKRnBCUDJr?=
 =?utf-8?B?WE1oeXNEaGpEeit0NUtLL0xmcXJGSHljbnV2UFZDclJvRWIxZXVyZjdOQ1lp?=
 =?utf-8?B?MjRwbHpHV0t4SjRiMXlOWjByejRtUHNZeG90MHJibjJFTEMxVVFocmJyMWox?=
 =?utf-8?B?bWM0VE9GOXpmSVlYK3FoYm1EZWVneWhkZ1ZsSFJoV0FvYXhRSHpGWXFyTmxq?=
 =?utf-8?B?L1JvUllLOUNsMnJCTXFtL3luYmc3WEs4M3BMenJNQUxPb29KSEhwM2llSGs5?=
 =?utf-8?B?dUNRNjhCQ0ZsYUlwTk1RdGl2UUg0M0pSQTViL2VoNDNoaTdBVnViZ2FXcmFV?=
 =?utf-8?B?WkNXTFg1QmpxSDd2L3RlbFJSNmFzVkdCN1o5UmJVNThqUTJvR3FRL21sY0ZQ?=
 =?utf-8?B?Nld6NVZWTWZSRGZjNUhyc1dFMmJGeXd5UWV1UUh5d0Z3YUJ1YytRcnRmU2dO?=
 =?utf-8?B?UjBRMDRiZW1IZHhnV0hFRDNTa0tHdi95NlowZkRVL2d3dFJ5MWZzOUcrRi9Z?=
 =?utf-8?B?UWZVMXNUUnVFUTdOeksyMzYvTlVSczl4TjJyb3cxQmZWa2hLdUJML3JHSTRx?=
 =?utf-8?B?aXU5MnpEM1B4akxvdklQL1JrMWx4T1dyR1Z4cWdtNHhGS09maS9qY3NubC96?=
 =?utf-8?B?SlhrdEY3SVhWbi80NHE3dzM3VDUrMDNUcGgxSStZdzNsOHBiWXZUanVQb3NP?=
 =?utf-8?B?NUNVbmFqb1FBb2FuZTFWZG5IRnhOUjNjZEt2MjlXekw1MHE0eGNsc3RuMkVk?=
 =?utf-8?B?U1BaRFI4cUR2dkRuU2xDWmRSZTVSNUlvNzkwSS9IUmorSFVOSHFLeGNXYlI4?=
 =?utf-8?B?YlhwOFVYQUhiOVEzL01OMVRHQUhxQ2lldjRGNVNNWDdlaXpkdCtNcTlSNVAx?=
 =?utf-8?B?R1pCaXdPSVJXck00TUtZTSs3Y3R0NnNrZUwyV2RhdlRUQk90eUdaTCtWVEMw?=
 =?utf-8?B?TkM3NStQZmtOTUtEeEZacHdQby9NSm9TWmhxb2tTNDlUNjU5WHRMZk5ZZFZN?=
 =?utf-8?B?Tnp3ZTZReGJuM3oySWZlbFY5MHp6MFRtZjR2Z0ZGMVdYWGw4QURCZjRUMEFv?=
 =?utf-8?B?N2xmcjNaRSs4TTlRNC9YWDhRTEkwc0g3dTJwRG13MUdURExobmZoamJBelZv?=
 =?utf-8?B?Y09XSHB5S0F2dVJVQk90bXdRMWJIS09QbFFUTFhDVmNtd0RpUTdtb3lLM28v?=
 =?utf-8?B?SkNmQTFUZmNNOUNVNm8zeE40d2lKK0pvMElCL0ZsekEzM3NXeTYvZi83T1Ux?=
 =?utf-8?B?U05EbEtmVFhVbWwrRThsVURSK0VKV2xGVkhsOXBkYldsV1ZRWjJuRk5sQm5i?=
 =?utf-8?B?aXVRS1pER2R2NXQrOGNvQXNYUFBOelZIVHkvSytqSmZKcUFxMzVWWlcxaUln?=
 =?utf-8?B?U285aGVuaXFZOVd6T0Z6d1lCNmFNTlNBemt6OEV3VEJtMEhXYlJMUy9LRUQ0?=
 =?utf-8?B?VnNxckwvQzNJMjcvQUl5KzlOWWxNazNHajUydm4xb0FRaFNqWHhmSHZMZnQ4?=
 =?utf-8?Q?soHX9oFy77PeZwGo=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7ced8b8-e6d5-4a90-cb2c-08de41e0bc2b
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:04:21.9350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4gTD3qt4l/+ANjda4H56kipcQU4lB/ViKPZpABRRijGySR6aoNWf0kzO08pSG1STqKLKM6g4ZCCuUKacaYR5b4uJUyV7uLgm1JORmmUcwJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8560
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfX7jLW036N1G6X
 +Rnhq3W1lLN6mvdUmRNv6m3N80Xj9FSp7KTPT2CJDD3tidp8h+0vwsS0tuwyqjWbBAKubbUn4S0
 MbC6d0dIt7iaQfkAacvNn0H42ngXopftrSWVaQALp+Spdipv4rQ3VPhfcAlIE4rwBD/9nanfHk7
 UIsmNImK6lnVAvYrf9hA9qYZj9VMCqP2LhV8kjVwmEyKJYLTPbfUvhGT9blC+KUz67Pta+ucrUl
 DceQtgwB8YoFMGsuaxTRKKsd0VplXgVdkFdYyxV856sbBZlxc/xpqJE8CUxIs7AEQXAv2PuSNEZ
 M77R6WS9hG0Om5ie5IkeYI3jyh2OMLcseSOVoMJw4SBRCYAQ2meQxh3O79LCzVOuLplju0A2L7c
 id4A/Y1SsOOGbZxEGX44DG3wT5zEEssvBUxV62sGjxPfabVdPXHI31ixP31Bg49x5Y9TCM6JrLT
 fKZFJeGpjAVvCuE86+Q==
X-Proofpoint-GUID: zovxxvFZUylMgHN8nbe8HL_OslqNRb_-
X-Proofpoint-ORIG-GUID: zovxxvFZUylMgHN8nbe8HL_OslqNRb_-
X-Authority-Analysis: v=2.4 cv=Xr73+FF9 c=1 sm=1 tr=0 ts=694a22d8 cx=c_pps
 a=qWtZlk1y+0YHnbN0PxcX1g==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=yMhMjlubAAAA:8 a=VwQbUJbxAAAA:8 a=edGIuiaXAAAA:8
 a=NEAV23lmAAAA:8 a=QyXUC8HyAAAA:8 a=rCu0DFmBVQTGpS9XFasA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=4kyDAASA-Eebq_PzFVE6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

## Summary
This series introduces support for Intel Mode-Based Execute Control
(MBEC) to KVM and nested VMX virtualization. By exposing MBEC to L2
guests, it enables a dramatic reduction in VMexits (up to 24x) for
Windows guests running with Hypervisor-Protected Code Integrity (HVCI),
significantly improving virtualization performance.

## What?
Intel MBEC is a hardware feature, introduced in the Kabylake
generation, that allows for more granular control over execution
permissions. MBEC enables the separation and tracking of execution
permissions for supervisor (kernel) and user-mode code. It is used as
an accelerator for Microsoft's Memory Integrity [1] (also known as
hypervisor-protected code integrity or HVCI).

## Why?
The primary reason for this feature is performance.

Without hardware-level MBEC, enabling Windows HVCI runs a 'software
MBEC' known as Restricted User Mode, which imposes a runtime overhead
due to increased state transitions between the guest's L2 root
partition and the L2 secure partition for running kernel mode code
integrity operations.

In practice, this results in a significant number of exits. For
example, playing a YouTube video within the Edge Browser produces
roughly 1.2 million VMexits/second across an 8 vCPU Windows 11 guest.

Most of these exits are VMREAD/VMWRITE operations, which can be
emulated with Enlightened VMCS (eVMCS). However, even with eVMCS, this
configuration still produces around 200,000 VMexits/second.

With MBEC exposed to the L1 Windows Hypervisor, the same scenario
results in approximately 50,000 VMexits/second, a *24x* reduction from
the baseline.

Not a typo, 24x reduction in VMexits.

## How?
This series implements core KVM support for exposing the MBEC bit in
secondary execution controls (bit 22) to L2 nested guests, based on
configuration from user space. The inspiration for this series started
with Mickaël's series for Heki [3], where we've extracted, refactored,
and completely reworked the MBEC-specific use case to be general-purpose.

MBEC splits the EPT execute permission into two independent bits. When
secondary execution control bit 22 ("mode-based execute control for EPT")
is set for the L2 guest, EPT PTE bit 2 controls execute permission for
supervisor-mode linear addresses, while bit 10 controls execute permission
for user-mode linear addresses.

The semantics for EPT violation qualifications also change when MBEC
is enabled, with bit 5 reflecting supervisor/kernel mode execute
permissions and bit 6 reflecting user mode execute permissions.
This ultimately serves to expose this feature to the L1 hypervisor,
which consumes MBEC and informs the L2 partitions not to use the
software MBEC by removing bit 13 in 0x40000004 EAX [4].

## Where?
The implementation spans multiple components:
- KVM MMU code: Teach the shadow MMU about MBEC execution modes
- KVM VMX code: Handle EPT violations and VMX controls for MBEC
- User space VMM: Pass secondary execution control bit 22 to enable MBEC
  for L2 guests 

A trivial enablement patch for QEMU enablement is available [5].

A GitHub mirror of this series is also available [6].

## Performance Impact
Testing shows dramatic performance improvements for Windows HVCI workloads:
- 24x reduction in VMexits for typical browser usage
- From ~1.2M VMexits/second to ~50K VMexits/second
- Enables hardware acceleration of Windows Memory Integrity

The implementation adds minimal overhead when MBEC is not used, especially
when combined with EVMCS to elide nested VMREAD/VMWRITE vmexits.

## Testing
Initial testing has been on done on 6.18-based code with:
  Guests
    - Windows 11 24H2 26100.2894
    - Windows Server 2025 24H2 26100.2894
    - Windows Server 2022 W1H2 20348.825
  Processors:
    - Intel Skylake 6154
    - Intel Sapphire Rapids 6444Y
  Unit Tests
    - KVM Unit Tests [7]

## Changelog
RFC -> V1:
- Fix incorrect bit reference in cover letter (Adrian-Ken)
- Remove module parameters (Sean, Amit)
- Remove redundant arch-level tracking boolean (Sean)
- Update is_present_gpte to account for MBEC bit 10 (Chao)
- Move MBEC enablement tracking to MMU role (Sean)
- Restrict MBEC advertisement to nested virtualization only (Sean)
- Consolidate preparatory patches into main implementation (Sean)
- Add permission mask refactoring preparation (Sean)
- Implement TDP-aware executable permission checking (Sean)

[1] https://learn.microsoft.com/en-us/windows/security/hardware-security/enable-virtualization-based-protection-of-code-integrity
[2] https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/nested-virtualization#enlightened-vmcs-intel
[3] https://patchwork.kernel.org/project/kvm/patch/20231113022326.24388-6-mic@digikod.net/
[4] https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/feature-discovery#implementation-recommendations---0x40000004
[5] https://github.com/JonKohler/qemu/tree/mbec-v1
[6] https://github.com/JonKohler/linux/tree/mbec-v1-6.18
[7] https://github.com/JonKohler/kvm-unit-tests/tree/mbec-v1

Cc: "Adrian-Ken Rueegsegger" <ken@codelabs.ch>
Cc: "Alexander Grest" <Alexander.Grest@microsoft.com>
Cc: "Chao Gao" <chao.gao@intel.com>
Cc: "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>
Cc: "Mickaël Salaün" <mic@digikod.net>
Cc: "Nicolas Saenz Julienne" <nsaenz@amazon.es>
Cc: "Tao Su" <tao1.su@linux.intel.com>
Cc: "Xiaoyao Li" <xiaoyao.li@intel.com>
Cc: "Zhao Liu" <zhao1.liu@intel.com>

Jon Kohler (8):
  KVM: TDX/VMX: rework EPT_VIOLATION_EXEC_FOR_RING3_LIN into PROT_MASK
  KVM: x86/mmu: remove SPTE_PERM_MASK
  KVM: x86/mmu: adjust MMIO generation bit allocation and allowed mask
  KVM: x86/mmu: update access permissions from ACC_ALL to ACC_RWX
  KVM: x86/mmu: bootstrap support for Intel MBEC
  KVM: VMX: enhance EPT violation handler for MBEC
  KVM: VMX: allow MBEC with EVMCS
  KVM: nVMX: advertise MBEC and setup mmu has_mbec

 Documentation/virt/kvm/x86/mmu.rst |  9 +++-
 arch/x86/include/asm/kvm_host.h    | 19 +++++---
 arch/x86/include/asm/vmx.h         |  9 +++-
 arch/x86/kvm/mmu.h                 | 15 +++++-
 arch/x86/kvm/mmu/mmu.c             | 74 ++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/mmutrace.h        | 23 ++++++---
 arch/x86/kvm/mmu/paging_tmpl.h     | 24 ++++++---
 arch/x86/kvm/mmu/spte.c            | 65 +++++++++++++++++++------
 arch/x86/kvm/mmu/spte.h            | 78 ++++++++++++++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.c         | 12 +++--
 arch/x86/kvm/vmx/capabilities.h    |  6 +++
 arch/x86/kvm/vmx/common.h          | 15 ++++--
 arch/x86/kvm/vmx/hyperv_evmcs.h    |  1 +
 arch/x86/kvm/vmx/nested.c          |  6 +++
 arch/x86/kvm/vmx/tdx.c             |  2 +-
 arch/x86/kvm/vmx/vmx.c             | 10 +++-
 arch/x86/kvm/vmx/vmx.h             |  1 +
 17 files changed, 301 insertions(+), 68 deletions(-)

-- 
2.43.0


