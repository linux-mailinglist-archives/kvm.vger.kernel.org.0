Return-Path: <kvm+bounces-69838-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eITTJZyQgGkl+wIAu9opvQ
	(envelope-from <kvm+bounces-69838-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 12:55:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 209C7CBF2B
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 12:55:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8369A3012C82
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 11:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2C936405A;
	Mon,  2 Feb 2026 11:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b="bRBopqjf"
X-Original-To: kvm@vger.kernel.org
Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazon11010065.outbound.protection.outlook.com [52.101.69.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AEC2EB876;
	Mon,  2 Feb 2026 11:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.69.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770033289; cv=fail; b=mJaqH3MrJpu9mXlzNtvibsIBZFrXxrR2+ZTQiAl67i7m3x0FUI7dovp0xoFYmhKTxDYc6c4umh3n0Xd7YeLamwSfnMuHrXZm353+9ORpTMASo/1F/r1Ajzco1SLh1DZ/Ea2xoyVBXsBhjbPBsOFERmKjSaYjR6rrV4J7VNysfj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770033289; c=relaxed/simple;
	bh=HTg8NG96tj4qVJ40/46OnbKEcfPlqC7690NhWKKvrX0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RofGlTMHhdlVaxfwyUXD5yXwXi425jZhsbK5HTGDjQgK1YUfK4Grt2SuQ/dLWNn8f8I2k7gfY8URdc4OxYcAiI41GgYK9898afBwcZ5MGSHk2bB5nCQEOfqvPWajCmgf9s5yJVxm6swWgJBZMhkplVJC4SsvJxiKuUIBMm9a6Ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com; spf=pass smtp.mailfrom=siemens.com; dkim=pass (2048-bit key) header.d=siemens.com header.i=@siemens.com header.b=bRBopqjf; arc=fail smtp.client-ip=52.101.69.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=siemens.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=siemens.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DozXTZV0kx5ROzKeem5FK2V/FOHC6/dH0lotIlOYCHL3ZQIDfFtSxZi1xx5ycNzZC/Tb1CJflSSSq2/nFiOwT4/y/in89K44mK8o5a+3TGJU47YnrwQAyO95DbGcnJM3qpMKfzq+22MSzZd90DPiEJR6C3HWocQ+xoshaPBm+Gt5S0ppH0Yj0B/a/qZe7UVR1FMpPgkVOL/IJLjJHBHCTVPYoNcdLbpBIrYaxzWb1dR9aLU6DKaxhMJ2VOl7G5r7DKElpZVX+vOHSXLj12Sg6vK0ZQ7Z+7aHdxveu8afO1ExPN83LFhCstmXSppLUG3Y2zqseq+1brhFdSOZmGRktQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YzfWWF6jM28jFZOkgFILKwIP1XwR7LJcAB/6B93JfUg=;
 b=SVJT5Io95w6cCExyw8q2qYOteGFMQTdE3OenwQ3wJXGId6LkLsxmh4cPS+iHsbykeII9Lpckztcw7ssUtScKcM8ai2zRw8xGRSuWyuA3E6qNmBoX/cs26yBg2u4Pew6mgk2vW/ZvCPopxoPfuo/fh1UwYIlKMKK73ghkTf+RdATmv7NZm4PrRZVvBmtDDdNyc5X4nvw78XnVsEh9K9maoaUTnJ+EqBG+XXMj/jCs+BDz9uA50U9fpmrfJCE2hlKbtcfGsx705VCghRd8Mdr4kPPrhV7EluDZDfkkzlLpoQeJ+yATnzFgmLsZY3GR1OqQ2s+e+baGjMXIDhZhvatkdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YzfWWF6jM28jFZOkgFILKwIP1XwR7LJcAB/6B93JfUg=;
 b=bRBopqjf8Qg7MR8ntdZfcoeXIZamYuC3k66Mfx19KhlksKdiMgmCyVNHrGUuxCv6rC0Bcftuh71gsUSh3gXhhi1Ncpbg0bAo5/i8xrjgsHDU9casr/6daQHqjWgkLtGJpPqzemDKhuWyUBUfedkFTsRyDEZZdq/V2EmsjX0ARBnQ4HI/SxgfPB4ycGRjBMVk6brV+3/u2JLZaUyrPPBTng94zyRZL94rsXetUuRhdlYZw+eKjfBQXK/bjvEaDJUT5QoXby1bYm6B1hU8+TDI3r681p3yMr9FQX1IMBLHxj7Koqom4ZOQ6D0dAqWyUkmKwz/pqMGzvJ2DZWaWcvHk6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
Received: from AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:588::19)
 by AM7PR10MB3892.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:14c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 11:54:42 +0000
Received: from AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::be9f:e8ca:ee9:83e1]) by AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::be9f:e8ca:ee9:83e1%6]) with mapi id 15.20.9564.014; Mon, 2 Feb 2026
 11:54:42 +0000
Message-ID: <f875676e-c878-4d3e-9eae-1f74f24cdedd@siemens.com>
Date: Mon, 2 Feb 2026 12:54:30 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] x86/defconfig: add CONFIG_IRQ_REMAP
To: Andrew Cooper <andrew.cooper3@citrix.com>,
 Shashank Balaji <shashank.mahadasyam@sony.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Suresh Siddha <suresh.b.siddha@intel.com>,
 "K. Y. Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 jailhouse-dev@googlegroups.com, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org, Rahul Bukte <rahul.bukte@sony.com>,
 Daniel Palmer <daniel.palmer@sony.com>, Tim Bird <tim.bird@sony.com>
References: <20260202-x2apic-fix-v1-0-71c8f488a88b@sony.com>
 <20260202-x2apic-fix-v1-2-71c8f488a88b@sony.com>
 <a7d93306-42e5-4617-91df-23f7dd35aa1c@citrix.com>
From: Jan Kiszka <jan.kiszka@siemens.com>
Content-Language: en-US
Autocrypt: addr=jan.kiszka@siemens.com; keydata=
 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
In-Reply-To: <a7d93306-42e5-4617-91df-23f7dd35aa1c@citrix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0446.namprd03.prod.outlook.com
 (2603:10b6:610:10e::35) To AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:588::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS4PR10MB6181:EE_|AM7PR10MB3892:EE_
X-MS-Office365-Filtering-Correlation-Id: 7865567d-8830-4aa8-9878-08de6251da16
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZnorV2s1cDZWazdsdDg4d1gzclRKMSs2K2p0MXoxamdXelFUY2E5TlozT0tN?=
 =?utf-8?B?NVZPYTZ1eTJUYnpMN21yVFBSVVBuR2VwUitSWks0SWhUczRhdWwrcHo3ZSs3?=
 =?utf-8?B?TnZhbVduSUhtQyt3TVptcng3Ymx1eUY4NjEraEdPMzhRbi9HQ01WQUZ5b2l2?=
 =?utf-8?B?MzhwUVRQWlZ4V3Vtd09DTmRramJDRTlUWHgrYzJjd0h2RWJwc3R3NTJQb29m?=
 =?utf-8?B?SjQxeTQzN25aaFRUUGJYNjM4RDIwcGhSWlY5clVsdG9MREgwTVJiMzNWajNv?=
 =?utf-8?B?UHB3TGVTY3FBaWJMZXRIL1dhcy85eGFOMlYwc0lud2kwZTBGY1d0NGhmQVph?=
 =?utf-8?B?R0JFUHRFdVlnQU1CQW5WbE9pR1lYT1hST0RjWmdlYm01MWo1RHRmYlNaR3JQ?=
 =?utf-8?B?VVg0RzZueFM0dEJJQkpWcm01OWhudjZqMk5zU0VtaERYMmZpRVZRN1FBOWor?=
 =?utf-8?B?TlVqWHIrZ0d6UXRwQ3BELytLek1ZRGRTSXNuN2dQSjZmOU1iOXh0RXE3ODlt?=
 =?utf-8?B?VUlxb3VHRUZMZXU3QXJTQnFnM24yYXk1M0crT0F2cHdYcUdEOEFVdldhd2dQ?=
 =?utf-8?B?aEw5WU43OFhEUnViNDFNUmdhTGt2UXlPOS93NGRTMHBxKzBFK1VYU3htSlpj?=
 =?utf-8?B?azBHVFBYZGpUSFNCTGZscC8vem82R0J0VzY4ZWVHbnRxRXR4SWV2dDRMYllY?=
 =?utf-8?B?aHp2M1N0WjdqS2RxOXpiRkVucjAycWsvZmQ4dDA3U2orMGFNbmdySDVnOFlN?=
 =?utf-8?B?U2lYb3M2ZVQzSGxWV3NFOUdzOFJVWHI3MDJFS3RweVZxYXJoeDBVcmtGWEtt?=
 =?utf-8?B?b1Y0VWdJQkVhTnFMQlFndEVwWUFqRWdOalZLVmwzSCs4bDdSNkFMOWdKVGkz?=
 =?utf-8?B?SURCWjJqOEZUWWZ1YU4rZ20xNXEzVUJ3K0FaeW1DR2duOCtjRnRHcC9pc1FQ?=
 =?utf-8?B?b3cxeEQ2RXlsRnFvNTdRaEhIRUI4ZDVvRFBNbFpEdk1lZUNQNmZjWUlmZjFy?=
 =?utf-8?B?Q2xuVnQvcnBUV1VKOXNNdHZ5UDhmRDlpYkZmOFlpQXdkL3VWLzB1bE94bytw?=
 =?utf-8?B?dGJEbERFV05LMjNsbFRlOXQ4dGVyVjV3dlpPNDZBMWpvbXJ0S29sQ2dIamtx?=
 =?utf-8?B?bHVHb01XYzAxUVRSK2FvTHpCd05iRTJJTXM1OWVtZGcxQTBGemxxc0hmdTQ1?=
 =?utf-8?B?ZWFKSHQxcDA3bXZWczRuZGM4aEwxUzdMQTkzY0l1RHdCSEpJZXJQWW1xTk02?=
 =?utf-8?B?NEZXT0RkTHQ2alZzM1VQUGJ0bDVIT1NuY0VNd2d4bTlCZlREOE1aVlZBUGlk?=
 =?utf-8?B?d0M1UmRmQnRjOHZ4VCtzMEFBNVNhUVQ1ZVJQVGRvbUpDS0tWQSswa2YxTHlN?=
 =?utf-8?B?MGNNaUJhVzRmN1N0Uno2U2xhNWJoUi9MWWYvd3BXSWpJRGEyYm5zUDc5eGll?=
 =?utf-8?B?cElqdjVXK2gySk1QWnEvV2xrL0lDMENSQTNybHhzUCtnZ3drKzIySDQ3bGhu?=
 =?utf-8?B?a2lLRG91MkRkQmN4Rld2blFxMnBiN0hJbVVZWlJvL0lPQlRJYXplUTViMGhG?=
 =?utf-8?B?L2d6U2ZrbkN5ZVNJYU5NcEV4VFoxdVdHeTJqQmNoVVY3MnpkWDRGSkF6T2ww?=
 =?utf-8?B?MmZxUTkrMXRVbGxJYXg2bFBEWGtCUmpOT1BpYlpWNjNOK2d6WFFTRnQxdTYz?=
 =?utf-8?B?aEZ3TVh4OFA3TjFBaUFjMG9QRzNTV2U4S2pSN1FqTEx4NEFxSmVaR2VjRTN4?=
 =?utf-8?B?ZDlldnA4LzZkZlVyU1MxK3JXTVpJeGxVMWxzUWJJd1VSYTVDRm5kSVFrd3B0?=
 =?utf-8?B?L2NxUGoyTkVxZ2I0a1k1NDAxbzNTVzNwbDkwUGg2SFJNT1lCUnVsdW9tWGhY?=
 =?utf-8?B?dUxyaUdYOWpYeENKaWk2Y2RIQjJkV0VjZ3dwcVlUSm4vZ1FWcm96TERzNTZr?=
 =?utf-8?B?ZW1STkdVNG40MnFTaFhZbmRRczdqczBmYy9qU2RwYnFITVhTYkNGYmcvaURj?=
 =?utf-8?B?T05iSEZHUElIZlFtVGpiWmkwT09kRnNKdFJTdFQ5ZEFSSy92UGdaMk80bzZV?=
 =?utf-8?B?V0NweGJzQTFTRTBQbGlBd015Zk13aFJQazJXeDAvTEVJQzhvSFFjM1NhR0tK?=
 =?utf-8?B?SStOU2hFUE1MdndOdncralpZQnpNYWs5YkpXS2ZJREZrVURUSFc1OU1Oa3JT?=
 =?utf-8?B?NlE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WlV3T0tEVU41b29tb1JVRkQva2hWWmdGd0s1cDVXcUFqZ1FwVkVPdDE0aHN0?=
 =?utf-8?B?dEJtMnMrMXo5QWdVUExTV2cvL3pKaHZIUkN6Q0dOaFBsc0RVZEpqWktYMHIv?=
 =?utf-8?B?N3M5ZUloWTNZUDMySHFRQ1RZWmx2M00rTVg5dElJcVU3cVZQanRDd3YwNkgy?=
 =?utf-8?B?aVVSa0F4ZEx1VzFjL2hMN2xzcERia3VSbnplYTJaUEpzTzlBN1UzNXZYRHZM?=
 =?utf-8?B?eDdMaWE3bjYxS2JBZnJva0lqOFBkVTlVZDNmeDNQTVVjUy9rL3ZYRkhGK0pn?=
 =?utf-8?B?QTZOZTRUMXc4eHUrUlI2N2s0M2Q3bnVlemVnVXhXNHRFc0Q0SVdlZ1gwakNB?=
 =?utf-8?B?RWFPRFNEZjBWckFzR2ZWa3JxWGt3eDZ5SHlNWndhR0hkT2dTakNjTDRsNjFv?=
 =?utf-8?B?SmlYWHVkT1RQTHJPUHByb2hMNGQ5aEhVVmEva2xGNFpwTUlhdllGNmNuVTB4?=
 =?utf-8?B?bk9qYnpEdEdGMDNpSmtsdUM4UVdqc0pGRVFYRjNSOFdSbW84bk84SHFHanRj?=
 =?utf-8?B?MmpObVAwSkhBNkZkVU1vZnZLRWxlWkpNZFA2WGt6QjlPNFBRVkZxMTdZK2h3?=
 =?utf-8?B?TUFRS2o3WGtuSWY2S0prRWh3TVpnNXFTNlBiYlZ0VmFvOGR6VGwwenhkR0pX?=
 =?utf-8?B?dUxpaGk0YWl6dXljTDE5M05TdVJJaE5vMVpYQXg2NGJwRVpkV3dpYzFxUWJQ?=
 =?utf-8?B?aWkwdXA4L2IxeHRQYVBnRkxFemtYeUNwMVlsaW1NRVJNbmk4WlF3SGNWQkIw?=
 =?utf-8?B?YnNzYUMzTHFIbU0yR1pqdEwzL0tkcjlaTFlQU2RzZXN2Z1RyMDdCbmpHaGZJ?=
 =?utf-8?B?dytGWmxMSnVmcU1CRlArbzJJczZTd1N1UHhUd0RpQUE4Wk9nckVVM0dOcjQ0?=
 =?utf-8?B?S09xK0wwNndRSU9JcDhWYnRTY2NFcWx2ejVVUWlYN2xabXZMdnpvQmlZTCtP?=
 =?utf-8?B?Y1l2TjNnaVI4OXdMVmYyUElkMUVIVThpMmZuQUE0STVUNGsrVVlDbkRacDBx?=
 =?utf-8?B?dnczUmQ4aTZINXpEK3JWYS9QSTJZeXhtN3p2K2xZQkhrOGN4NlA5UXYzUDkv?=
 =?utf-8?B?VncxdVZYcFBWRkhmbk55c0l6VUxoaFI2Y2ZjckFZRHVuZDJqdUdmcVEyZ1FP?=
 =?utf-8?B?Z3NEbTUzeVBEc216OWNpdXd2bGw2WEMrVFA5MXRZQXBQTU1VUDJScEhDTXdx?=
 =?utf-8?B?eGNKbUxYMW5XRzQ5aFdKQkdJYzVhRHE1WllaVE83Q1A2S2VpQllzZ1BiWGF4?=
 =?utf-8?B?a1ZkYU5XTGxzcHhNQm84RTlaemxYVkg0eVk3cnNwV2M4TkZva0I4blpoOEFE?=
 =?utf-8?B?blZjeis4cjM2bXhpVXNQbFVEaG1udlBqWEpoaEZ5SUgralFTeUl4cklnUk84?=
 =?utf-8?B?eWUyZWUveFVQMTgyYmRSd1NRYmoxU1NxMFQ2ekJPSUZTNEFPc1dkMnlBSGNF?=
 =?utf-8?B?ZGRYbzhIVDdpUG1jby9PSEVGZ2JOMEFiU21OR1pSZHV1RU1seTR4Vk9VMnM1?=
 =?utf-8?B?UklQdnREMTc2cHZpM3N2V2RQaTZNa3N5Ry9pUmFlZk44UjIwUkxSZW03VWNU?=
 =?utf-8?B?WGhrWVZ0ZGxaa2YwMS9RbmNvb0JzYzlReWFRRmNNaUI1VUQwSkd0Si9QRGYy?=
 =?utf-8?B?ejZZdVVaS2pVYmRmWE5hTndXM2cxM3BKZnFQMFlVMUNwZktxOXRJOXFVRzBt?=
 =?utf-8?B?dnU1RXQ0ak9aMVJKaHJhY2RMS1hIR2VhVTdnYzAxOExCU256Nnh6aXlHRWY0?=
 =?utf-8?B?UVZvTE9NTHBCY1NuMW5EQVI4a1VPbUNRZWVtaHhUczF1UzdZcHFpMUFUMm1u?=
 =?utf-8?B?Q1dLSi84MW5ncU9IdzZMd3l5MWI4aDBYUFpZZXRzZHJSa0wrTndOTmdPNjhK?=
 =?utf-8?B?U29pbEM5V0FkNGxvUTdTR3ZuODI4bEV0MEFDVzd6S1o3TGNZYkRaTVlLLysw?=
 =?utf-8?B?ckdtMDV5YkRGSXNwM3QrSkxwNnJzT2J4dVliQTd1TXNtOW5OREF0MUxPR0pq?=
 =?utf-8?B?UlIrbWkxY0QzRFUyakR4aDBpSFIrdVNHNlF4MFVvUFJQVC9UNnB2TWRCckla?=
 =?utf-8?B?WnMwcE5QdnorQ2pkcTF1WTZTNjZmQjErVlRvVzZndTVPUldDMkwzVlY5S1pR?=
 =?utf-8?B?VGl0YWRPa2dsU0Q4OFF3MUQ1TkdnVFFiTFVTWEtZdnN0NXl3emtOS0xyVjhv?=
 =?utf-8?B?SVdjSXFQaXJZZWZlQVFvTGNIejRVWEtVbFpvU1l2Y2FEdXYyYWVrbjhpMGxP?=
 =?utf-8?B?d2I5bXlVZlU1NEtWcCs3c2xhb3NzWGIramtzN05Jankvc2pRZjF5ZjNLQk5R?=
 =?utf-8?B?NHRjWEJLNE1kdXdLT3Zla2VESUQ4MGJZZzhyUldwUGYzbTZCVDdYQT09?=
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7865567d-8830-4aa8-9878-08de6251da16
X-MS-Exchange-CrossTenant-AuthSource: AS4PR10MB6181.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 11:54:42.6504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6j5fwVUYO/xWkMypQHU9bq+RJP+IDHK2huxg45zU2Co5F+2w6bNYQ1VFO64rww615hdViVwxdTKfmmojUiH7QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR10MB3892
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[siemens.com,reject];
	R_DKIM_ALLOW(-0.20)[siemens.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69838-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[31];
	DKIM_TRACE(0.00)[siemens.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jan.kiszka@siemens.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,siemens.com:mid,siemens.com:dkim]
X-Rspamd-Queue-Id: 209C7CBF2B
X-Rspamd-Action: no action

On 02.02.26 12:35, Andrew Cooper wrote:
> On 02/02/2026 9:51 am, Shashank Balaji wrote:
>> Interrupt remapping is an architectural dependency of x2apic, which is already
>> enabled in the defconfig.
> 
> There is no such dependency.  VMs for example commonly have x2APIC and
> no IOMMU, and even native system with fewer than 254 CPUs does not need
> interrupt remapping for IO-APIC interrupts to function correctly.
> 

It is theoretically possible with less than 254 CPUs, and that is why
virtualization uses it, but the Intel SDM clearly states:

"Routing of device interrupts to local APIC units operating in x2APIC
mode requires use of the interrupt-remapping architecture specified in
the Intel® Virtualization Technology for Directed I/O (Revision 1.3
and/or later versions)."

IIRC, ignoring this would move us into undefined behaviour space that
may work on some system and did not on others.

Jan

-- 
Siemens AG, Foundational Technologies
Linux Expert Center

