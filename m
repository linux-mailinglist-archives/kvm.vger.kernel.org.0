Return-Path: <kvm+bounces-69869-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wBU6IiTFgGl3AgMAu9opvQ
	(envelope-from <kvm+bounces-69869-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:39:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 472C2CE58B
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 16:39:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0A7033007BB2
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 15:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C68C238150;
	Mon,  2 Feb 2026 15:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Mc0niS2M"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010009.outbound.protection.outlook.com [52.101.193.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0526C372B3C;
	Mon,  2 Feb 2026 15:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770046737; cv=fail; b=uc5ryZvZIgeBB/QjQg5gXN/Jy5Cbe0Lx4auxkIQ+r+0cx2xZNluBVum1lvwNdO3UvBhxe89voHa7RkW27lYWNlZtA/vm9C3CdZ/zu6qn0XTrTdZAgFMdft9ctHm0Nti4KtLXEMpKzMRcDPi8RHOusWHgMw6pM1JaQl1nev/Le14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770046737; c=relaxed/simple;
	bh=wycPTwmV1L5W0QKjA6hbbUR1uWPVP3KO9r4M+SPNfMU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tq6/MQn2Lv7IhSpR3QujO6erFEE8jUdOIQmrsDsarjtF9xdR1m/LEUobesdM4rfA+z5L4g+9gtSYqzDpZ206iiBgaftdJRw6gXyDe1/0thuUN3PWvgNf1vvDJoHL7CruIgK0rdc138+xaNa5s4Li/ZhQ64jxWeoh8pS8ivf+Ags=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Mc0niS2M; arc=fail smtp.client-ip=52.101.193.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RaJP2ENDV2ScDewoUwdIS3fUx4I7fBHi3KSgw+tDMRpm8mrIX40vt+VWT4z+OEzbb/qGtk96wWDTgBMZ/+Luct8VwgD3AWHu8iiJVKZkb7NuPoDk9bBBYNsHuDqW5Q1UpJU3g8vgAUgzqncCw4yueU72Jvu8nUB6vthpgVTX+QqySN5P9M9aT6cxE6AAqxet7yz19GYDR3YA6gXjeLfc8Fuwb9m0rz8IrdzkuruOVCN9MHBeeGintvKpw4aHzQb94+mYzbux+dDOcIyzPjc9CeAuy9KSsjRT18NS/5C9fQS5k9ApPm4uU2rpkBmvuQhHvPG0E+f9suzrpCoI6i7e5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b42hev6fsdigRlqdOhLkjiBKawwAsz73DprVhoIpn1Q=;
 b=qO2hHchJRUp6Y85q5bEW3YXoUyaho76mcntaq0+TL3C+8I2dcfWwxyK/gfbEkpdsXhiGKboHVgwrdDITn1YZ/il6OT+0YRYTxDK3/4amKXYn/btJyXaexIkcpAbhuddhK5AvDBUSa5bly/2wiu2XCdsOHCVdl6LfOSHOaudocUAr53XXxPSVwFmC59NI16Ik9u/1atNrSIkkdKWMxn5aExLCDfJE7pP1cOv6CPHdP4W2d63DvmKgleC+sPie6UumgnY/cJ9KVS7IsojJ97kyU6C8JOfzf/WJkzH9nGHsO7/R5P8LJ0kwKy0J0MXJVZ/VlxiS1nien6UUn7Xs49QfBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b42hev6fsdigRlqdOhLkjiBKawwAsz73DprVhoIpn1Q=;
 b=Mc0niS2Mo1RIh+BYM/0PN47wEvl8H37LlRMLHFkWSoVhY0/yWu4lh/Dp5g22UFG/cfBU6c9MYQsjPxo9O+fKaPkckqQ1GH50QRunIrTWHC23CJJStBzLN9AYauaxg7t8Fvgw4c1W3D4jwgUsZYIP1wl+/KTGpTcgrLPY46C0fKo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM6PR12MB4299.namprd12.prod.outlook.com (2603:10b6:5:223::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 15:38:53 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 15:38:53 +0000
Message-ID: <6556bacb-2e81-4aa8-92e4-0ff8642f4ec9@amd.com>
Date: Mon, 2 Feb 2026 09:38:50 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: SEV: IBPB-on-Entry guest support
To: Borislav Petkov <bp@alien8.de>
Cc: Kim Phillips <kim.phillips@amd.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev, x86@kernel.org,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Naveen Rao <naveen.rao@amd.com>, David Kaplan <david.kaplan@amd.com>,
 stable@kernel.org
References: <20260126224205.1442196-1-kim.phillips@amd.com>
 <20260126224205.1442196-2-kim.phillips@amd.com>
 <20260128192312.GQaXpiIL4YFmQB2LKL@fat_crate.local>
 <e7acf7ed-103b-46aa-a1f6-35bb6292d30f@amd.com>
 <20260129105116.GBaXs7pBF-k4x_5_W1@fat_crate.local>
 <f42e878a-d56f-413d-87e1-19acdc6de690@amd.com>
 <20260130123252.GAaXyk9DJEAiQeDyeh@fat_crate.local>
 <2295adbc-835f-4a84-934b-b7aba65137a8@amd.com>
 <20260130154534.GCaXzSHgkEFnk5mX14@fat_crate.local>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260130154534.GCaXzSHgkEFnk5mX14@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0094.namprd04.prod.outlook.com
 (2603:10b6:805:f2::35) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM6PR12MB4299:EE_
X-MS-Office365-Filtering-Correlation-Id: 41c4f9c3-d182-4692-0bc9-08de62712ac8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cWNLUDdHcE5NRWhHRUlXeHNiaXAva0VqVGR2cGNudlFMdThSaUtwSTRNM0lL?=
 =?utf-8?B?L21yanJBS25Qa2JvbWNPVGkzV2RscWNlRy9mMEVDL1p3Ky84NTY3TEdNVmQ1?=
 =?utf-8?B?eTRnc2lxa21QdDUvUXAyQ3VYckwvRlJEcTlibnRGT3JhdkxBdU1pS2NVUnN4?=
 =?utf-8?B?ckI1WElMU2tSVlhsRUpad3cvSTlZUFNNeUZsU3FrRW1PTzliZTQxOVJUazNV?=
 =?utf-8?B?eFBMK1pFVVAyaXJBT1NKYnFPbHNid0FpZEdieVJMeDkwc0hhZjJJNWFZdXUx?=
 =?utf-8?B?aFpaTU43WVRmeCtteFh0RjZDai9sTEM5WFg2aTB3OGdjcS9iaXFJUUxCRXlZ?=
 =?utf-8?B?MzJVdWZNSWdiRzF5L1RtV0VzaHBQemNZYzhuYXNSRnpsZHJweXN3NnB0SlBP?=
 =?utf-8?B?ZW1XSUMxbjJ3T25FaGZtem0reDVqRDUzSnNFeFArSnpqMGRQMitoSHM0c0V3?=
 =?utf-8?B?dUZpOUJLdlZXcFE2M3hvbWl2YmRWek9wdHdqWWUwbDQ0dFVhbTFKWWdTbG9l?=
 =?utf-8?B?MGtGL3FFeWZLbFZEVVRYVmNPVDJ0OVlKSVdRSVpKMVBXUmU2TDZLQkhLMW1T?=
 =?utf-8?B?SXNmd3JoUlVyQnB5ZnNuYWdSWUpwWGRNczBybk9Xeno1Ukl5QmorMVl4dWVi?=
 =?utf-8?B?WUdScEhYOXBuTkY2NEp2WHhPeGl3MGF2eXFOeG1uMWZvT1hWdWJobWgzYlBF?=
 =?utf-8?B?Q0RXWkNyZW41dmlBaG10R2RrTC9OMnQ1VE5Lbk1BQVBvTUFFSnh1Y3VMc2R3?=
 =?utf-8?B?RGkxcFFRQ21nQW9LajNWbVR0ZnFQSU9iRi9GMGFGTkV4TjI4R2JTTU1rMEYr?=
 =?utf-8?B?RW1JVUJEVVVFMjZNZFAxeGprck1GcTJxMlczWW1TSFl6NGNMdm1PUHpVNnBv?=
 =?utf-8?B?d2tmNEtmeGxuSEFTdjVxbDZFSGZSSkcvRHpnR3p1dDlmUEdJallGZXpnb2Yw?=
 =?utf-8?B?RmtCaTRQU1lCT1lpM2dTeVpYV09ZYU9NMEd5RHVHUVh0M1JqZmpNTzJWWGEy?=
 =?utf-8?B?eHdURG14bGNlR2w5dk5vakNQM0Qxb2NIUFFWS0hHdFNaY0o3T1prUTJ1eDRn?=
 =?utf-8?B?Ukl6RzhmNmxnWUFyY2toNFFjSGRkOWErcy9Ka1lmU1k5cTNFYzBscms1UHVQ?=
 =?utf-8?B?eUYyMjdCbmlNU2o1YnlTS2MwNndWalYvY2ZwaGhYQjBiZUZsWGF1TWdybUpI?=
 =?utf-8?B?QjdlTVh5SGV4cjlhQ1RnelYxMTlsMDE0cjZtZ0dCK2dHamhoT2JkK3plcHJQ?=
 =?utf-8?B?b3R1WTY1bGhyVGxpRmJpamtib3VGSUkxRE1Ub1ZrcHJneVJmUXNoL1lwSmpz?=
 =?utf-8?B?VGNDQ2dJRm0rMnRlWXlzdHJmdFI0aUdrNE9IL0pCdCt1Zjlhb3ZoeHhWM1FQ?=
 =?utf-8?B?Zzl5N2dnQlcvSVF6MjdGdExNNXpiVWRRa1dHejZDM3h0L3pVUENEQUwrd1BB?=
 =?utf-8?B?eVdsM1lod1REWjlBRHdXaEdnVDBTR0hHblFMcjdObVc5ZFB0cHFZdHVmMmhk?=
 =?utf-8?B?UmxULzNaMGx2THNsRlRncU5mQ1lML0I2TS80STBYUWVQMFQ5TnpFSmo2QW9r?=
 =?utf-8?B?U2NiR1YvbUNoUzZXalFxRkxJa1JKYnVicUF6QkxJbEN5b1lHcmFtMVlsMnh5?=
 =?utf-8?B?cU5mdldhclVRb2g0bTF6VWYxTm9HaWFGdWx5MGwyZG5OcDVlQmUrclJONWlC?=
 =?utf-8?B?VSt3clZkQ0JKaUdsb1RTWXVqUE9kTHBCOFJFQVF5aDFjTm9CNzdNcG9UM2dz?=
 =?utf-8?B?VzR6aG83UlNGWFZmdlhHcWt0VURBNjNIdXQrbno5YXMwc2lyeFY5ci9iMUdV?=
 =?utf-8?B?ZlZKby9neEdYWjU2NHcyZERIS2xuNHlIaXdJbDNnQ2xzSmtoK016cUJCNEJT?=
 =?utf-8?B?WjNWYmdqcERGa2JQdEEvR1pOSDN3TmVWR3VrbmYwaDZ2YmRzSWc4MGYwTlk5?=
 =?utf-8?B?UXExVVlqd2dJMEsxc3NqODdQRVNBMElXaDdja3dOYkVnLzkwQ1FCNDVONmdZ?=
 =?utf-8?B?eElLN21YVVNEWHI2RkVIa2VxSFduMlBMQVF2R0RYZ2JzL2YydHIvUjlOZzZz?=
 =?utf-8?B?N24xMHpwTm02Vm04WkVKQnREeTFVbXdhM0ZvdFdBcDZLZk1JZmVCNmhsV0NP?=
 =?utf-8?Q?l57U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkovdUtoeFJzOUJtNXFaekRQalZPSkVSRjlIUmQ0TGdlemsvSEFJSElQNjRP?=
 =?utf-8?B?alE5RC9CSFFWR1ZjUGF6UW1aS1RYT2N4SEd3VElIN3BXazUwTE1vbXRKdWJn?=
 =?utf-8?B?YkpRcmZ1aFNRMndtMXRwUDdQSlBnU1lvMDVGQ21QeTBQUGNnbEt0b3BGSHY2?=
 =?utf-8?B?dGF4RFdCLzd4M0VxSlIwRUlYZEM1V2kzNnFpYVJaaWwrU0hQbFpGVHpMVWY3?=
 =?utf-8?B?TktHdzJVckZpcU12NXlOTkt1cXQrMmZranBBOWp5QStqcWU3WXJYUVllNVpE?=
 =?utf-8?B?RFozUGhaZjNUZmZsdVBzQlVOT2w4Z2RaV285bndpTW45ZEZFRUZTdndIMWI5?=
 =?utf-8?B?ZEREa3NDUmNoS25yVGxKeVl4eE5wMGg0ZzRGU3hDdDNYTTNGZ285L1l6WEkz?=
 =?utf-8?B?bkcyNEJFQmRsazF1d056aUgwQTh1ellBZVhRb1BGVGpsVExWOE5JMUw4UW5s?=
 =?utf-8?B?ZnVwUmdUMnNyRkhkZk9ZdTJYM2ZKSy9tWWFaTmtTdWtYbmlidDhCM2cxZ3JX?=
 =?utf-8?B?Uzl2MnJtUlNNUDNJMXMxUmVvMHhOQzJmMWVNeGorZjNHNk5rVTZMaWdPNHJY?=
 =?utf-8?B?c1JFTmx5T3l1UDRuWVFxRk0rWFlzQmxMSFZRbWUzUFBYaUIrL2p0U0VrdFow?=
 =?utf-8?B?dUtsUTlHYkhDSUpzaUw3MXMxT1VBdWlvR1VFS2FGVnBwZENTU1lrWThobjR4?=
 =?utf-8?B?Z0dGRHFqQkQ1NEdZWGM2RkE5NGd6R3B0SXZGY2lKVEIzNTN2aVNVOEZCYnlH?=
 =?utf-8?B?dnFxNS9ydng4d3NDdTBEVWVicWcwWXNjVk9DcE1GY0xrQTdzMEgvVTk2Tm9m?=
 =?utf-8?B?ZG5SZlV0bVdmRnlBMEcvREw0T1FqM3hWUkNkbVBkcnZVRno5anhqd3Zwb1JB?=
 =?utf-8?B?cE9wVmlBNDhCY1FJTkFWSUFDMlRYcVYwaDJSQUxlVXZvYTZqMDBQRVdYMnVB?=
 =?utf-8?B?VFZSd2NVVjJRaTNsbWJiTXpwL1JVZzZXYUpWRElhbXhxSXVIK1dhYW9MTG5L?=
 =?utf-8?B?NzlJcGJTRjBEQS9QZUozQ2VWLzVnT3EvQm95c2RFdk5qcVQvSU5FN01xVDNp?=
 =?utf-8?B?Z1E0QkdTQ1MrZk9zL1pMR3FlRkcyUXlMcjFuZHFtc3FjOXphbEtTOWJsQUpJ?=
 =?utf-8?B?QUFyUjhuc0pETjJwaGJCTVRLamdzaURFN3dId2o2RzVhcUF3b3pUeU8za3k2?=
 =?utf-8?B?L2FmVTRRYlExbnA3YytsdU1YMnRGc2hMUHZpVGgzZ1hFaXkzRVZTenBXQnJZ?=
 =?utf-8?B?TFhGbUN5VFYvamtXM0pNdjJKcFlBU1FEUnExSWVpSllPOVpNQnozanJiU3BV?=
 =?utf-8?B?bG44bmh0b3RzMXVqYlh5SEF6MVlpN2JzaHNla040QUd3UTBQaVRZUzB5cnBq?=
 =?utf-8?B?NjVpVTdzd1FXTnhna25Hd05BcjcwZTF1aGwybjdiOXUrOVFHZDg3bk1nYnRI?=
 =?utf-8?B?djdlS1pNNTVQNUNYMUVNZkg1WlNVVWFRd3ZNWUdZUEsyNDRhRzBzK1Q5YWtU?=
 =?utf-8?B?dUxoN0l3S1RHS2h6NU5IY2tPVmJYSm40clVOZzlCYlZtdTlRREl2VTRPdTNw?=
 =?utf-8?B?SUthcjFiZHRNejRIVy9NanJydHRwamZFN2lXM2M5SVBCaXI1VUlCdi9Yemw3?=
 =?utf-8?B?T29PZ2gvdjh6QUZtUUxpV1doS3h4WlFuV3Qva2hBM0J5bzFKV2doYjRhd1pI?=
 =?utf-8?B?em1KRmtjUTIyREkzRGhPZHN4RHV6b3B3UXdMWFhiOVVQRGFKSjZ0WTJJYTRD?=
 =?utf-8?B?RjBydzlFRjdRejkycUZxR0szOTRHK0Q0VGdKMTFrRWhWZENXNXh6OG5zcEMw?=
 =?utf-8?B?Z3JWaTdoSmpBb3JzVkxvYnNBNEJYbUVwN3kxdjJUMEZ5RFVWaTNRdHh2M25m?=
 =?utf-8?B?L0M5Y1d4a0tldUlOUDBLK1Yrdm9pc1h3WUdkdXdqWXBZYXdueGxDQnBuRWJW?=
 =?utf-8?B?ak1xWlUydkJLamZJSnkxYllEWHdmVkoyK0RhOUNYbk1BUmRIWm5rTm5Fa2J4?=
 =?utf-8?B?SVhBK2Q2VHlYY3RPRzBiSzBwdU05bTdxK1JzRm9TNjBDa2UzSWFlTkFCUTUz?=
 =?utf-8?B?MWVyWTJqSjMrbUg5RFVRSytQVGluQ3VtdzM3Q2tldmhnQWJlTHNwbGwvMm1G?=
 =?utf-8?B?OHEwVDk3cWpnNE9RSVZ4aUM5c2lIM3pDUGswNEVBMVg5RTZiOStadElrazBw?=
 =?utf-8?B?cjBSNGpNVUl5NnppTTJZeU9lSmZ2cVpxcGpreXhDWDFjR0JKRUZQNkdZQVhE?=
 =?utf-8?B?T3RTV080ekVrL0pJbG5pNmFOTmZBSlZhbEdPbFE4aGxLa0V1NXBuYlhhVEVC?=
 =?utf-8?Q?PdKEckOzubh0XNi/SN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c4f9c3-d182-4692-0bc9-08de62712ac8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 15:38:52.8009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FgqG1+Hk+B1qY4PKZR/h5bc0h/ORRlD7EpKmRUDW2G1wEKUr5z9rxQhmFFvJ+z8Q8VW91xwLFj6X9HhvGq6kRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4299
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69869-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 472C2CE58B
X-Rspamd-Action: no action

On 1/30/26 09:45, Borislav Petkov wrote:
> On Fri, Jan 30, 2026 at 08:56:07AM -0600, Tom Lendacky wrote:
>> It can be added. Any of the features added to SNP_FEATURES_PRESENT that
>> aren't set in the SNP_FEATURES_IMPL_REQ bitmap are really a no-op. The
>> SNP_FEATURES_PRESENT bitmap is meant to contain whatever bits are set in
>> SNP_FEATURES_IMPL_REQ when an implementation has been implemented for the
>> guest.
>>
>> But, yeah, we could add all the bits that aren't set in
>> SNP_FEATURES_IMPL_REQ to SNP_FEATURES_PRESENT if it makes it clearer.
> 
> Right, that's the question. SNP_FEATURES_PRESENT is used in the masking
> operation to get the unsupported features.
> 
> But when we say a SNP feature is present, then, even if it doesn't need guest
> implementation, that feature is still present nonetheless.
> 
> So our nomenclature is kinda imprecise here.
> 
> I'd say, we can always rename SNP_FEATURES_PRESENT to denote what it is there
> for, i.e., the narrower functionality of the masking.
> 
> Or, if we want to gather there *all* features that are present, then we can
> start adding them...
> 
>> If we do that, it should probably be a separate patch (?) that also
>> rewords the comment above SNP_FEATURES_PRESENT
> 
> ... yes, as a separate patch.
> 
> Question is, what do we really wanna do here?
> 
> Does it make sense and is it useful to have SNP_FEATURES_PRESENT contain *all*
> guest SNP features...

I guess it really depends on the persons point of view. I agree that
renaming the SNP_FEATURES_PRESENT to SNP_FEATURES_IMPL(EMENTED) would
match up nicely with SNP_FEATURES_IMPL_REQ. Maybe that's all that is
needed...

Thanks,
Tom


> 
> Thx.
> 


