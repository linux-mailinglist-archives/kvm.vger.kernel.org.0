Return-Path: <kvm+bounces-68663-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CEd7EoEYcGkEVwAAu9opvQ
	(envelope-from <kvm+bounces-68663-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:06:25 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id ED6DA4E498
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 01:06:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 27D4AB4E14C
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 23:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 352FA3B5305;
	Tue, 20 Jan 2026 23:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tgvvJwzF"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013014.outbound.protection.outlook.com [40.93.201.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB7E40B6D7;
	Tue, 20 Jan 2026 23:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768952743; cv=fail; b=bcN2aqHyiHq8IUZ4k59npppTPH7RWd14QjOffXNwAb+ZyrQVoz/gc9KuLMJxu597QzbVamGJM2U+RatdNOZvU+6u3DgpjRimi1FHODJr+bBB5tcRwwIB/6IDtjQTJEUhrxe75TGY7JAqG5o9RXoLHgNbTUK1Ztn+WrKYpGrO/eo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768952743; c=relaxed/simple;
	bh=p68B/N/SaxeYLn8aTLKZp3Mwd6Qh4f/Hu4VAMS3/uas=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kL2C3sugQ3YnOJ+YghEG7HgC4+PVvIUszgTxfcbZGkBp5pbqfAA0Tz1l0injMIxeNJLw2ZT43zYg9VPaSwxTOCry1PRvklz9SxoxRZ1EgUoIldh3H53ofI1cr43sbvuKQBNP79TwRrIArLTLPRhUGzwZ0Rniqsj/wZVsjW2Nsv4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tgvvJwzF; arc=fail smtp.client-ip=40.93.201.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NSPAfNfzpdIYCqw6PP/NH2vWkmFYSQFNB0o6R2/FWCzKW4se1cecNBuCkITP5OAsx53IUm2DrAkicCjmJTf3db9XAJ77yxnaPSPG/uFzHxTtxnr8Q9T7yJP6h8o8ajFc3kC3Lfq9wKlM0tFo0X/gLS2o2ycVv5OOz/wldpvmzAofhaNQSew+09a6jVKRCyrYbtVcka+Xh1Sosweufzf6h/5kiw/Pv1EPUznOFAqmn3xT0xlx5KiUZdInXHBwoKy/R9dFKQxi1076q+Z4wEAgVEWY7849EldaVSpr2pqo3TC0oMUkrDumkGeDAmb2cfv+lfe4bGEpMIDlDtYQBC7tJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZFXxE84pi4OjpUMn3chyXg/j5sCUsQYa4QHT930Z8gc=;
 b=n55chbOgVUqjXLwQRmO67jpmI+VXTKcbHr2ZEnyFa5cARvMgbkvE4dnKrSFgAQBIkwLEbPSRg2WpXRQy/pTjDOIYsad+ufyTvS0ZyOuh8vOKNXqQk1E26DWPKMa81NmUOdnwNoemafNMXp4ULfZK/4f4spdS/Tr8dPT8XpgJTmA5N0po1h8jXGoK8TjogcQF5cTdmTzQTgs5O1QZRo7gqUvo7vlOSUFN0Ru2hdPPIrspKTNzYFJCz1JbQ9bYTeVPN/RymW2ZazASgT5AxKGA2eOSfXy+WS8m65OXjnbDMzj6MjRKwPRM2TbJv9WjuXqWOFv0OVzshrMMgJc1VMQcVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZFXxE84pi4OjpUMn3chyXg/j5sCUsQYa4QHT930Z8gc=;
 b=tgvvJwzFl81amFMLsKbZndSHPWJkEWqgZ1TfaOGqTODeYOPdiSmXVozUknrNpQIPqL6tKOQjaAW4OVgpI/R2ycYp8VQvUcuB3yB9AN+nS/hmrUF5cwo0mI90XDGVT7D+ruJUI8bSkJr2BQ01CTJPOVIBTVFMCnIqptz1aiUge8w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY5PR12MB6599.namprd12.prod.outlook.com (2603:10b6:930:41::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.9; Tue, 20 Jan
 2026 23:45:36 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.9542.008; Tue, 20 Jan 2026
 23:45:35 +0000
Message-ID: <254d7d53-b523-452d-8c6f-d611ab08a9ff@amd.com>
Date: Tue, 20 Jan 2026 17:45:34 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: Thomas Courrege <thomas.courrege@vates.tech>, ashish.kalra@amd.com,
 corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com,
 nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20251215141417.2821412-1-thomas.courrege@vates.tech>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20251215141417.2821412-1-thomas.courrege@vates.tech>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0163.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY5PR12MB6599:EE_
X-MS-Office365-Filtering-Correlation-Id: 703fd7b2-0ef6-4aa9-9fb8-08de587e01d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWwxWURZcXhPK3FkREdJd0toazhIOS9IYXVkNm5HcGp3azlOSWhCM2FuMExq?=
 =?utf-8?B?d1pOaGRzRnl3Sm5ZdFFKWVdUTmFMTnc0VVdHMFU0UmY4a2NDOTEzSVpEUnhj?=
 =?utf-8?B?K0dFcXdVMHZSVXhJeHVvMmZUYmZrY2RQMWtDK3o4SkQ3MXFEd2Urb3RIWEZo?=
 =?utf-8?B?N1ZqeXV2TUtoRXR2a2JXUEx2VUVxcWxHZGpaRnAzL1BQZHNaQ0NWSGh0ZnI4?=
 =?utf-8?B?UFA0SGNLeHdJM2loazJJbEZ6TzFXNitnVVBCelJqOFdveEhvY3VUZXRJTGl6?=
 =?utf-8?B?NmgzL1B0MmhHUDdEdkd0WnpMVHBWNElnUUg5UllrMkZiYkZzSzQyZFBxL045?=
 =?utf-8?B?eW5iUndHS3dkN2hrYmFmWktHS2c5ZGVFR1R1MXdYNzlmbWl4R2ZNMThXMmVi?=
 =?utf-8?B?R2NJVk1kTWc1K2NnOGJVTmVjSEZVT1UzVTVkYlkwK0hIcG02empHWm1iQnR6?=
 =?utf-8?B?OFBwTjdHTHU0S1VuK24zYWtYMFh4NlJWMnluZFFRN0F1bDVGMGpwbm4zbGla?=
 =?utf-8?B?U2VoeE1PN3F4REw3ZEFnYmpyL3hkeWUxWjRKN2RPbXhyd041TzNXSmdVcko2?=
 =?utf-8?B?Y2J6eTduNVhjQXR4RmJtd09lSUxEWndERmVUY1NMSVVJKzE5cUdhNnprcXA0?=
 =?utf-8?B?ZFRSbDB2OUM1Z0E2dzYrQmRxWWI2UFlUR2x0NWJmNXZDRHdJR1hkbUZLTTZD?=
 =?utf-8?B?ZTR1Y2htdzhxOEdkamRsQkVLVkluZzNCWUZuRmUwdHFWQ0puRGxqRGg4OHpP?=
 =?utf-8?B?djB2SnJsMTZRS282Y25ncWZFUTRVL2w5OERkRGdYRkZhVHFDVDZmdEVYWGdh?=
 =?utf-8?B?S2pGRlNFSHBzUGlpOWNTYjFaRFRlMFVsYnJCSjFnUVFvOURwSENDbis4di9m?=
 =?utf-8?B?aFk3L1hhOGZkNHJQRm5ISTRnS2pITjRENHc5NmNiRzBJdEJMdWNzaitxeGZH?=
 =?utf-8?B?Z1A0cFFCWUNnbXRQZGNXMjZkSVhVM0dnOHVyS0tETEtqQ216dFFINTZCQjJF?=
 =?utf-8?B?bkN1YmdnL2pFTVpKU0dYWUFicnZMbkxpZktMaUZTTjBPOTNJTlgwYStpbk0z?=
 =?utf-8?B?eUJYR2Fwc2VlSkQySjB3MkMvajR6L1U1YnlxUkgycVFPRjRuVHVoZEF0dkpG?=
 =?utf-8?B?N2ozVTQzbGhCR3ZhMnlEdUVFNFhSTjMweXpRUzVGUUhHcUNyNjU0TlZUSUFU?=
 =?utf-8?B?MEdSMTBJcTlWY3BtYWN1aVR3MTIzczBRNS9Ob2pmREQwbGc0MUZ4NEQ5YlR0?=
 =?utf-8?B?dllUZG9BcWd1MldhZkZ5OVdGZmFvait2UzhWSWVKNkpDYjVMdjJHdmhaODkz?=
 =?utf-8?B?c0FCdGFnTER3Rlc3L0tkb1hGSStEWmpBY1hDODkzcFdrUTdjazI2SWZQek1v?=
 =?utf-8?B?a2tVRnFoRHdFM1IzSCtPWXlxWGJqakFqUHF3RnVVK01lZVdDYmhkL0h4VUR2?=
 =?utf-8?B?d1BLRWdFM28rYnpGUjRwYkZuRm1qVUF6MTUxVVkyd3dud3RJMWJyODVUVTMv?=
 =?utf-8?B?UWk3b0RUZnNObGcxQlBMbW5ET21JbGJPZFdDa2xZczE4Y0tSbXNvTzF2QVBk?=
 =?utf-8?B?UlBHRTJqN0NTbXZndW1Na05qVjA4RU11aTBneXd2SzkxT0loVzNzRVJ2OVkr?=
 =?utf-8?B?NDBkOHYzL2xySkdienVzcmRyUXkxelkyaklzM1dmRXN6Mi9zN2Z1emFuSXUv?=
 =?utf-8?B?NFFmTEVLcG1IdW9lKzJrWVZIMXJVWnd2R2JRZXRld0ZoVUhWT0ErbHMvN2xF?=
 =?utf-8?B?bG1YL2NLSTFjMm93M3c2ZG5wMnU4NkF6RkVnSElhM0hDMFdQdFRYVnE1Qk1M?=
 =?utf-8?B?OEFPVWl6eWl0d0krZFFzc1ZPczdYUlBSUHRBNHpZT2NMc3dXdTFDbmRtM0or?=
 =?utf-8?B?Y1pTYklkdytOTnpoTWlMUzM2WlRMSWxtM204R0FNbDNSU1BEZWtFY2ZMdzJG?=
 =?utf-8?B?dTh3RDdUTWttamRIeGFDNDdPVTRTNCtYOWpMUzRJZEFyVXo0MFkwYnZCWExH?=
 =?utf-8?B?Wmp0LzcxVEtQZStvdXpNMTIyd1NvdUpLK1I5K2Z1TlZFaXpPOEhZMDJnOXNj?=
 =?utf-8?B?MzhFWCtIajNBamdMTU9IdGRGYUsxTHJySTlHVXRSSzNKZ2hnNXcwdzlvSFBa?=
 =?utf-8?Q?HzK8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0pRUEJETmdsTnpDd2FjN1UyR042aks4ZzQ0cWMyMUJmWWZiZFhKeUdXL0N3?=
 =?utf-8?B?L1NaN3ZLaUwwTW1aQ0s2YXNNdytUbXJ4blNSZFAzS3BYMWY1a0FFdEFTNzR5?=
 =?utf-8?B?MmFpRkdTbHJZWU5KTUZIemlWMXFPSEJad2lpQklXRkl0QTgvamlaRHVkejNw?=
 =?utf-8?B?THhYL0xFMUMvWU5hYmh1NlAzQ3pCVDZxK3ZuK3B5Q3o5QldEOFFBVXVBM25K?=
 =?utf-8?B?b3NySWp0UEZkdkZUOVQxMVRLKzhnUHpqcE1PU1laZHFOd3gzVW13Wk9RVlVp?=
 =?utf-8?B?VEl0UThvb1JlSUlyUHFRYlljdXExdDRBRHhPVG02MjlSZnplK2FsVFlUQWxL?=
 =?utf-8?B?WFQ3TUlsN1l6QW9oRlY1Yk8rVExTNVJzTzc2MHNJYnpyTTFsUHdRTitFY0tM?=
 =?utf-8?B?S0Uwd2U2UlA4SDZoVVVHY2JiNWZvNWpDbVR2M1VIai85UE9KSUxlMkVucnlM?=
 =?utf-8?B?a2lrOGRFMzlVTHorUnk0cHMxM3AxeW5PcTU2QUZ0SWVDSzU3elN4UHg2Z3JK?=
 =?utf-8?B?bG1yNVJrUG1EZlFXR1liallvNUZZaHdMdEV6SGNIWGE4dGxTT2t5MWpPNERY?=
 =?utf-8?B?dklXY0tkOGRmdkdBZUp0ZGtaemJDRTYxS2pvUTM2cmgxTkY1ZEcxcWh5emt2?=
 =?utf-8?B?Mi91bmdHZXJPR2o3YzU4SkRMbDE1NHNGWFptdDM1d3ZncUdlYzVTTGdCa2FJ?=
 =?utf-8?B?ZHh5ZzQzcllxWmJWU0dlamgzaWFYUE9obXFkSG5OVUpad1NKQWZPSWhCbE5E?=
 =?utf-8?B?bUxSNkZ5UXA4ZmlNOEoxQWkzWWpzQ0RSZloxWUZuZmUvWW8rN3hKZG44SnRr?=
 =?utf-8?B?SDBobDFwNFRuN05rU0VDMlhvYjV2TXR2dTFlbVVvNXdzYVZkUEQ3Zzk3TlRI?=
 =?utf-8?B?b1JQRHpGL3BmWVFPalJCaGdycXJ6MVp5Z0VtTVhMVFJ5SDkrYnM1Nk5VMUlC?=
 =?utf-8?B?ZlpCeElnM1BiT2NNWHhtVnhlcS9WRmliOElsNXR6T2pXMm5TWWdoSGFaOEo1?=
 =?utf-8?B?YWdWaXNiSmtHSTcrSUJYdXQzMURyQTMwZ3FpT1dZRWJvNjVoamN3eEh6ZnNF?=
 =?utf-8?B?eTVyeEhJaDBBNllVb0xSeVkwak5NT2RydmJKd2swMmhXMStKZ0t0d0N0Q2Rv?=
 =?utf-8?B?VTZZS2R6aWpROFVzelNtcnRMOWZZVDg0d29GYkN1QnFPdjV3Ui9vaVY3NEt1?=
 =?utf-8?B?eWszRmdDbjhISDBBYUVNSnByWmt1QVlzK0l4T2FNLzhYWjVheXZ2VjVzZjlE?=
 =?utf-8?B?Qm5EYnh6dHlsRk80WURGQUs4NlpiNUp1eFJDOThCR1g5ZFZJakV5YjJ5Wkpq?=
 =?utf-8?B?Y1BEYytRbU5idXZQMnhHdWhrbCtOMkU4by9UMjNKbWNGdzRPTmVNQVJ5Q1cr?=
 =?utf-8?B?Nm5OMExibVRQeGM0TDJQUS9OU0ZCbS9qZnVLRmNET250UUVqNklXeCtjM05p?=
 =?utf-8?B?dTVnY2xTUHQwdTFMMDJmcm0vOFBTRFVvc3Q0MVV1ZFI4U3dkT0VPMTRHZTJD?=
 =?utf-8?B?dU5kL2dmV0FYc1pUWUdxQ3FNMWNLS2JBZWl2TmRLOEFXNVpEL3pITG9SYS96?=
 =?utf-8?B?SjhrK0dOaXJWN25mdjY1aThRUHp1R3JLektMdWNndUVLdlRwNGd5TTlVbnho?=
 =?utf-8?B?WWtwN2lZbFE5MkRZUFlXV0ljTkwzZSsza3JvOCtEMUdmN3dPenR3OTN4aFdy?=
 =?utf-8?B?TVAwV3BWQ3RBTGZ5WFFNSmFDMkwyVERtUjYzbFBMOXFkdUN5RWNrNUltSDF5?=
 =?utf-8?B?MnF1eHRCQWpQWnJsUG1OUVBhTlN6T3V6ZXNMbUg1NGRtSG02QVE1KzJFNmZN?=
 =?utf-8?B?aklPcDZSTFp4NllJbnl1N1pxQlhySFZFdTRHRUFPZ1FjWG0zZ01hdnd4OUYr?=
 =?utf-8?B?YU4rUFZOOW1OMVpscEZ0aU5SZU40YmkwQW5GYXI0TmxYQ2VIOW01VmRxZWVC?=
 =?utf-8?B?UGQzUklMaEtIb3RYTjM3blBCa2JRaXNiSTlKU0hyRUltN0pDK2owOEo3WDdG?=
 =?utf-8?B?RExTN0VKMFQ5MHE5Rm9lZkxjejlUNitWY3dXZ2dhMFlQRVRtNi9YUC9MdHgv?=
 =?utf-8?B?NURkUWd6VkJYZU14dWcvaGlFNEJtcERRQUROZTJtRDZoUXZub25LeGFMcXBQ?=
 =?utf-8?B?cTNmYnRiazhYUjExblNORGR5SG9hNlNxZE9LUTJZQkFwNDlYM0pkQXFvSnZn?=
 =?utf-8?B?Z2ZQQ2swMVB0UDFkM3V0T2dETHE4QkFBK0F5bmxlRGtNbWNuQ2NUY3dYZDFx?=
 =?utf-8?B?STRqTkZLZEYrb0FnRnZWWEhtVlZ2RWw4T3E2U2hCc2NNRGsvdU9KNXRNWXFY?=
 =?utf-8?Q?la1RclQkjU6WYvYDz+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 703fd7b2-0ef6-4aa9-9fb8-08de587e01d9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 23:45:35.6915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: apRfj+LEvwan10FZR/xwzksp9nqqorHqmTl0yo5mGUzwQ93xT6SO4YQzTE+lvaFMuA+r49Zs406OXUjI5mj03Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6599
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68663-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[amd.com,quarantine];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,vates.tech:email,amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: ED6DA4E498
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 12/15/25 08:14, Thomas Courrege wrote:
> Add support for retrieving the SEV-SNP attestation report via the
> SNP_HV_REPORT_REQ firmware command and expose it through a new KVM
> ioctl for SNP guests.
> 
> Signed-off-by: Thomas Courrege <thomas.courrege@vates.tech>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 27 +++++++++
>  arch/x86/include/uapi/asm/kvm.h               |  9 +++
>  arch/x86/kvm/svm/sev.c                        | 60 +++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>  include/linux/psp-sev.h                       | 31 ++++++++++
>  5 files changed, 128 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 1ddb6a86ce7f..083ed487764e 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -572,6 +572,33 @@ Returns: 0 on success, -negative on error
>  See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
>  details on the input parameters in ``struct kvm_sev_snp_launch_finish``.
>  
> +21. KVM_SEV_SNP_HV_REPORT_REQ
> +-----------------------------
> +
> +The KVM_SEV_SNP_HV_REPORT_REQ command requests the hypervisor-generated
> +SNP attestation report. This report is produced by the PSP using the
> +HV-SIGNED key selected by the caller.
> +
> +The ``key_sel`` field indicates which key the platform will use to sign the
> +report:
> +  * ``0``: If VLEK is installed, sign with VLEK. Otherwise, sign with VCEK.
> +  * ``1``: Sign with VCEK.
> +  * ``2``: Sign with VLEK.
> +  * Other values are reserved.
> +
> +Parameters (in): struct kvm_sev_snp_hv_report_req
> +
> +Returns:  0 on success, -negative on error
> +
> +::
> +        struct kvm_sev_snp_hv_report_req {
> +                __u64 report_uaddr;
> +                __u64 report_len;
> +                __u8 key_sel;
> +                __u8 pad0[7];
> +                __u64 pad1[4];
> +        };
> +
>  Device attribute API
>  ====================
>  
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 7ceff6583652..464146bed784 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -743,6 +743,7 @@ enum sev_cmd_id {
>  	KVM_SEV_SNP_LAUNCH_START = 100,
>  	KVM_SEV_SNP_LAUNCH_UPDATE,
>  	KVM_SEV_SNP_LAUNCH_FINISH,
> +	KVM_SEV_SNP_HV_REPORT_REQ,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -871,6 +872,14 @@ struct kvm_sev_receive_update_data {
>  	__u32 pad2;
>  };
>  
> +struct kvm_sev_snp_hv_report_req {
> +	__u64 report_uaddr;
> +	__u64 report_len;
> +	__u8 key_sel;
> +	__u8 pad0[7];
> +	__u64 pad1[4];
> +};
> +
>  struct kvm_sev_snp_launch_start {
>  	__u64 policy;
>  	__u8 gosvw[16];
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f59c65abe3cf..ba7a07d132ff 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2261,6 +2261,63 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return rc;
>  }
>  
> +static int sev_snp_hv_report_request(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct sev_data_snp_msg_report_rsp *report_rsp = NULL;

'= NULL' shouldn't be needed, right? Or do you get a warning because of
the use in the sizeof() below?

> +	struct sev_data_snp_hv_report_req data;
> +	struct kvm_sev_snp_hv_report_req params;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> +	void __user *u_report;
> +	void __user *u_params = u64_to_user_ptr(argp->data);

Do this assignment below just before the copy_from_user().

> +	size_t rsp_size = sizeof(*report_rsp);
> +	int ret;

The declarations above should be in reverse fir tree order.

> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;

Add a blank line here.

> +	if (copy_from_user(&params, u_params, sizeof(params)))
> +		return -EFAULT;
> +
> +	if (params.report_len < rsp_size)
> +		return -ENOSPC;
> +
> +	u_report = u64_to_user_ptr(params.report_uaddr);
> +	if (!u_report)
> +		return -EINVAL;
> +
> +	report_rsp = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!report_rsp)
> +		return -ENOMEM;
> +
> +	data.len = sizeof(data);
> +	data.key_sel = params.key_sel;
> +	data.gctx_addr = __psp_pa(sev->snp_context);
> +	data.hv_report_paddr = __psp_pa(report_rsp);

This would leave the 'rsvd' portion of 'data' unset and possibly
containing random data, so it should be zeroed.
> +
> +	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_HV_REPORT_REQ, &data,
> +				&argp->error);

This last parameter should align with 'kvm' above it, but just make this
all one line.

> +	if (ret)
> +		goto e_free_rsp;
> +
> +	if (!report_rsp->status)
> +		rsp_size += report_rsp->report_size;
> +
> +	if (params.report_len < rsp_size) {
> +		rsp_size = sizeof(*report_rsp);
> +		ret = -ENOSPC;
> +	}

This can be contained within the if above it, right?

if (!report_rsp->status) {
	if (params.report_len < (rsp_size + report_rsp->report_size))
		ret = -ENOSPC;
	else
		rsp_size += report_rsp->report_size;
}

> +
> +	if (copy_to_user(u_report, report_rsp, rsp_size))
> +		ret = -EFAULT;
> +
> +	params.report_len = sizeof(*report_rsp) + report_rsp->report_size;

I'm not sure if we can rely on report_rsp->report_size being valid if
resport_rsp->status is not zero. So maybe just set this to rsp_size.

Thanks,
Tom

> +	if (copy_to_user(u_params, &params, sizeof(params)))
> +		ret = -EFAULT;
> +
> +e_free_rsp:
> +	snp_free_firmware_page(report_rsp);
> +	return ret;
> +}
> +
>  struct sev_gmem_populate_args {
>  	__u8 type;
>  	int sev_fd;
> @@ -2672,6 +2729,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_SNP_LAUNCH_FINISH:
>  		r = snp_launch_finish(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SNP_HV_REPORT_REQ:
> +		r = sev_snp_hv_report_request(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 956ea609d0cc..5dd7c3f0d50d 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -259,6 +259,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>  	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>  	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
> +	case SEV_CMD_SNP_HV_REPORT_REQ:		return sizeof(struct sev_data_snp_hv_report_req);
>  	default:				return sev_tio_cmd_buffer_len(cmd);
>  	}
>  
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 69ffa4b4d1fa..c651a400d124 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -124,6 +124,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_GCTX_CREATE		= 0x093,
>  	SEV_CMD_SNP_GUEST_REQUEST	= 0x094,
>  	SEV_CMD_SNP_ACTIVATE_EX		= 0x095,
> +	SEV_CMD_SNP_HV_REPORT_REQ	= 0x096,
>  	SEV_CMD_SNP_LAUNCH_START	= 0x0A0,
>  	SEV_CMD_SNP_LAUNCH_UPDATE	= 0x0A1,
>  	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
> @@ -594,6 +595,36 @@ struct sev_data_attestation_report {
>  	u32 len;				/* In/Out */
>  } __packed;
>  
> +/**
> + * struct sev_data_snp_hv_report_req - SNP_HV_REPORT_REQ command params
> + *
> + * @len: length of the command buffer in bytes
> + * @key_sel: Selects which key to use for generating the signature.
> + * @gctx_addr: System physical address of guest context page
> + * @hv_report_paddr: System physical address where MSG_EXPORT_RSP will be written
> + */
> +struct sev_data_snp_hv_report_req {
> +	u32 len;		/* In */
> +	u32 key_sel	:2,	/* In */
> +	    rsvd	:30;
> +	u64 gctx_addr;		/* In */
> +	u64 hv_report_paddr;	/* In */
> +} __packed;
> +
> +/**
> + * struct sev_data_snp_msg_export_rsp
> + *
> + * @status: Status : 0h: Success. 16h: Invalid parameters.
> + * @report_size: Size in bytes of the attestation report
> + * @report: attestation report
> + */
> +struct sev_data_snp_msg_report_rsp {
> +	u32 status;			/* Out */
> +	u32 report_size;		/* Out */
> +	u8 rsvd[24];
> +	u8 report[];
> +} __packed;
> +
>  /**
>   * struct sev_data_snp_download_firmware - SNP_DOWNLOAD_FIRMWARE command params
>   *


