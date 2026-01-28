Return-Path: <kvm+bounces-69416-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yFmiGEpzemng6gEAu9opvQ
	(envelope-from <kvm+bounces-69416-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 21:36:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D8BB0A8AA8
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 21:36:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7EE4230233FA
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDAF2374720;
	Wed, 28 Jan 2026 20:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fIlS5TqQ"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012071.outbound.protection.outlook.com [40.93.195.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A111314D0F;
	Wed, 28 Jan 2026 20:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769632554; cv=fail; b=ahHHBiR4X1UNVmPnEdBX5gR2pva3lLdtz/4b5EqNTSLQwvFivkZ0LT0uDvj04IV3UDvohFst5/6+r7SRwrVnvUR7+U+X2GZTjWiZyEs4qgePZysizL4DhPFCe34Llwhyw6p1tAHTy1pbZtUpK/iM1mUKmEXstxN9KQdSPo2pa2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769632554; c=relaxed/simple;
	bh=Ys4+PBtZ6IXJThBvCpwCPsQQaJXeJKU9sN8tKTlk6jU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UkNtJSaOwg/zV5XQUaNaG0hSYhFPkY4ZEFzyrwmXaWNblx0nqi23mo4DZbVHXw9q8aW2irR2WKSdOoSKNYuBbgUh0iqh6utqA9lLtFC33wPwX4bC8w1H8u2fUTrPjGGpS2YHxbOUxWymwkAiFfypF7XVcj5B+Aa2NcScp90M2Cw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fIlS5TqQ; arc=fail smtp.client-ip=40.93.195.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wIIcOc/gVCqq607QJnjdcnWYd624XFU6kSCxtAZVMpXowro/8Dmov2LpOxdO5ABxYk0ZloPCUlzguZfxJs1IxFe1JDRaOwPj+R+G+OOLAK4lGgIjd8UBau/yR055LNSyZfd9sXekQVsWVRm5jm5SrBuHvMgLZb7u181NViZW/YlD2DaRjRw1RGrNRu+Owt8Z4ehejxcZOrPpiOPKr6aIf0ye4PR/RuwZfM8b9vqn2NNb8DbiTSsn/Hk12Era//cOFlVUvqDctNSlwhR65zy7MWtP2x70c7DZDCLavnzTn88l/wDPZAf94JflcTLqId622gAPYyIE3/9Q3GPVF5Ev6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8pOVqbXJu7LjA/wnhhVOQRWLHcLgEG/1DS1BttdSv80=;
 b=dKuRzguR4q8TGlfm0WOkt2DU9tPpSSb1Ngc0+Ixg3InfkjhwrbEAE/YI7arjzDE0yaFrZ/rLl0lMDl4kIEZ1iPtsbD16H2XJWBmdYqpo5dHStzN0lEJ6rZ+eb56bQN7VeKrGZVJUXOzSRBmuePilQnLQXxCva4hHr8Pojzsi4c/UmMqYm2H+wis3SsoekiL66hIdf8RLwARdpikK4yt34o2L45M3CJTGURacCtVgsR9XUvCPesaEy4YNbL2Rcr3SEMO9ZXwi3kEM1zg+AlnJIoCOXw4L8+OmCeDKtiY7pMRTz+NMZ9eu7Vz6B6frHtphFB6XL/WBIzctFaWOtqBbEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pOVqbXJu7LjA/wnhhVOQRWLHcLgEG/1DS1BttdSv80=;
 b=fIlS5TqQ8gzDgWLmyNSM9SslmvHZeappf5GCUwNG/sU2o2Spezv9B3Zh6UTv5iExiGGVdnwqC3TR0KjMh2eqD9Z47APk5t1z5k4ebyCsuMaHRamW3WcogJyn23A1MuWsrs5gQ1pCffJYaTHyLjxU5Yr6Erxgw8MW9/NA15HyFaM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA1PR12MB6356.namprd12.prod.outlook.com (2603:10b6:208:3e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 20:35:49 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.9542.015; Wed, 28 Jan 2026
 20:35:49 +0000
Message-ID: <bcab95ce-4bdf-4b8e-a979-d579706a9cf6@amd.com>
Date: Wed, 28 Jan 2026 14:35:23 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/1] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: Thomas Courrege <thomas.courrege@thorondor.fr>, ashish.kalra@amd.com,
 corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com,
 nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20260128194956.314678-1-thomas.courrege@thorondor.fr>
 <20260128194956.314678-2-thomas.courrege@thorondor.fr>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260128194956.314678-2-thomas.courrege@thorondor.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0138.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA1PR12MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: e2276a85-ed92-4da7-2b52-08de5eacd245
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXNkOFBaaWtPdDFLeDVidTM0UkJDWUl3enNnUHBVd1BhNWxTT2JqR2FaMVh6?=
 =?utf-8?B?N0hkcUZuWTQ2TW1mOFZ1ZDRORGs4R1Zlb0pvbm5YcDhFZ2laZ29ENnhBeG1r?=
 =?utf-8?B?YnZzdU1iUnAzd1dTVDBteFhLRkc4a21mb3hsNXpEckxObGNNM2VEQnV6Q0xQ?=
 =?utf-8?B?WWlKdzBhSStCRWtpNUtZVElXUDFSYW5oeFdNZy9ZRmJCWVNwc1NyZWpRekxh?=
 =?utf-8?B?RDJWaTBzNHpRSm9qZzdKUDF2V3lRT3J2L1B0RUpiNThieGcxRCt1UDgvT3p5?=
 =?utf-8?B?VW5QQ3VYajljc3ZSVCs5Y2xTcDhtN2E2aUZLN1kwT2VNeGptSU82RjlVM1Zk?=
 =?utf-8?B?RHN1RTZvSUtzK3FDK0h5cnJ6bXo3QU1ZSEkzY1FyalZJRGVmRkthRWVuZkJN?=
 =?utf-8?B?OXRPVUxFSHliZmZTVXg0WWVqZmNOOXVJa3JaWklMRmNjNnBwZVBBa2cxQ0pF?=
 =?utf-8?B?TUhOaVNxekNUcHNVOXpXODhRb0VaNTZyVnRSOGk1cmN3cGd4SG5BVXhtbEVs?=
 =?utf-8?B?TGpyNzN4WkJoZm5vUzdkcjhoMXg2WHRrb0FjMXljRis1VlJRWXBLSllQQ2ZB?=
 =?utf-8?B?ZVFObzBOcGpsdERCZGNpRXU1cTRzYUp5VlRyTGQ1aUt3bmt5eThuNGdlU21I?=
 =?utf-8?B?TytXRSsvaGVlQVJ2UllndXpnK3NxVDNmMjUrK0F6N04xZE44aWlBL2JPYTAr?=
 =?utf-8?B?S0VrVHg1bVZ1RG8yYW83Ri9SbmVLNFBDc1c5SnZJaC9CVFY1dmkvazZNYVFE?=
 =?utf-8?B?TzQ5WHpjRURqWkV3Y0gvUzdrTGtuVUNKNGcvWHRvQ2kxRUpwWnQzN2poQUNk?=
 =?utf-8?B?RWE5L3E2LzNNT3VIYWlWSW0wSXJWRVNvRVFYUDBGOStBc3FEdW5pRFJIZkJB?=
 =?utf-8?B?Y3Q0YUhqK2tBYllla211eVlyaDFpWFhpR2c0ay9kTDdPeEtNVWRHd2NTMGJ5?=
 =?utf-8?B?c2RvVHM2RkV2bmxyVkh2U0dJZzMwaFRRdzNZdTU5cG1GbXoyQ3Z1TS96TWxj?=
 =?utf-8?B?M2dnQnhsZWhDNVdnQzg1NVMvMGhJVktsWVhyR1ZNbnhaUk9tcW9CTEs3NERQ?=
 =?utf-8?B?akJtVFpIU0lQUmVtTmVocDlMeGxTeWx6Z09tQU5LWWd4YTZSdm80YUhWQkVB?=
 =?utf-8?B?T0FFeVM1ZG5mU05kNW9DUDh6ZitOU2lCVFhuMFlGY2IvWXZOUUhTTllCTlpr?=
 =?utf-8?B?Q2NEdVhIMUlMeGRldFVFZ3dSM2dHUTYvaVZ3ZzlHNU9HbkgzbkczY3lmRmc3?=
 =?utf-8?B?dkZNS1hMUkNzTzhDSzY4VnBBZ2ZNQVd1ME5Sc3JoMDI4MG9vTlYrWmU0VkpC?=
 =?utf-8?B?S3c1b290YzJMWW1veXZTUm1sTEVlaUJnS1RvQ3BNa2lHZzZlcDA4eFVNbjJ6?=
 =?utf-8?B?OHN6UFFISnNjaEZrTU5hamhFMzhOV3hHS3pJRWRVbFB4T3FnVmFqdzZIbko0?=
 =?utf-8?B?dmZhbWxqMllWZ3Zibk1Nemk5bk5CWkVoUFBweW9BMlRZdFIvVEJkTXkvVTJz?=
 =?utf-8?B?ZFI3cUpSTXJvR01VR0ZMTzAydWVOVzA4aXBKZGFEdzBYVTJYQThSdE1oU0Vl?=
 =?utf-8?B?bzV5UGk2U2RiOEdkWURxRHdjWVJSVXhZSDAwZVV5bjJHTG9EakhDRVpyeVlX?=
 =?utf-8?B?V2NGV2lKV3E3ZFB4YkthSFFzRVBDWHU4dEIxTjEreURrOS93MlBMZzBESzNu?=
 =?utf-8?B?M2pBa1VOT05lVE1QZ1JHNDhnVXRUYzFKTWNMRWkwSlN3djFNMUM3bzljTmI2?=
 =?utf-8?B?QTMvektGbk1KWURtcG84T1lYZjZCdTNybko0dEZNZEtrVXNxMm9PSlBTdG03?=
 =?utf-8?B?RVVEN2xobVBONkdSS0NPZ2Rwenh0UWpjekpXNjlTY1BOcEw5N2R4U3NHSFNi?=
 =?utf-8?B?RVZTc0owdE0vUGVtdW5leUlRKzJGVFUzZTR2enorYXh2Z0VzUFFROVRjVHNs?=
 =?utf-8?B?aWQ4akJOM3hEV1F5TmQ2RGxoUFhMUmFFTjBOYkVXQy9leitHMkxNYWlXckhJ?=
 =?utf-8?B?SEJGNnQ5dXlVT3J5Q2ZONUZ1U1l3anZMSWtlS05zd0lpOE5FLzNVUVlGL2hw?=
 =?utf-8?B?RDZuaG92dWk0VkQ3YjFiVTlLS0RRTmVZeEJEaHRhaXBIeFo4ekZBa3ZjNkFk?=
 =?utf-8?Q?ED2w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SzB2clZxTXBSY3ZFL2pmN2JKVDdHTDhWSWlleHJRLzVEUUM2d0IwMmZjSnJ4?=
 =?utf-8?B?dFJKR0x2SEJEdW9ZcEpDL0I5V2JObVZOWVhZcWQ0dXY2RHJSNWZ5bjRZaWVK?=
 =?utf-8?B?cUdhQzRxM2lZOG9GZjMramplUWo4R2ExRi80SndtOUhURDdvNkd0cjdxWjlO?=
 =?utf-8?B?akdNTVNKSE5yVVc4OWZBUGtjdFRDMmFPOHZQRCtCd0xock9iY205OGJmbFJ3?=
 =?utf-8?B?dW5Sdjl1cDVSTW1hT0F5UXNSTVhwa3NxVVZGdThOY2xiRmtuQTFrOVZBOGpo?=
 =?utf-8?B?YUxBZ1Jtbk5KVkUyVG4yOTFTWXVXVnpsay9zNWRTSmU4eTBuTUx3Y3E1a0U2?=
 =?utf-8?B?U0ZRTkNKZ3puS05Vd2lLRkpIRHE0ZFVLdFlzRkgzdXFKd3FFL1JRTW5LTktz?=
 =?utf-8?B?dnlWVnBmYUl5R2lKbDgwSXBtNldFQ28wMFNNemRlNExzazhNbkFXUVE2Y29H?=
 =?utf-8?B?RnZDVHBtQTRTUmpKTERRMjVrTGo3ZDQ2RCtTeVltWFhuaFNuS0tENG1Dblcv?=
 =?utf-8?B?T1RRKy9SMURrM1V0RlRQN3dWeVVkMlFRUzdXdENhUG16aGtmWUt6RWV0anli?=
 =?utf-8?B?OXl0MzBYWnA3SEk3S0FxWjdhNVVXZFhML3hVQU1EYzJJTmxRNGRFcEY1TVFC?=
 =?utf-8?B?M0Y2NUlpSnhoQmVXWEtlUk5BSkp2TXZacXo5cFlmZU0vMmxtK3lIWWpVNUsw?=
 =?utf-8?B?S1M3T0dkTXFLRlAxYUxqSnpmck9zbVhUSy9WbytmVmVxZDVGZ245N1dZeEt4?=
 =?utf-8?B?ZzJhMGtYNWVqT0Y4dTlDWUlITHI2VjFTOWNUdlZKSVJXeUhud1FBcTlMK0tB?=
 =?utf-8?B?cDVqeEtNMXNCL0drb1BVYjVIbnMrdis5dThjVzBTN3hXU082NE84bENGYktI?=
 =?utf-8?B?cncrYnkwNHdNK1NZQmZIbTBFd3ZROWx3SzZwcHR5M2dCbzNPZU5tS0sybzky?=
 =?utf-8?B?UmlnQ0o2OUpBeTZsTTNWNGV2bWZzRS9SZnNYTit3QkJtVGhBbE1leGJXZDl0?=
 =?utf-8?B?dGorTXJEWUYrTnZ3cXZDZWMwZjJsNzJpMVpmR0hJWFR0SURJTGhqNWpwNWdk?=
 =?utf-8?B?SklGMWViRm5vbkZUa1hjY3REOTE5OW5RNXNQYnhRQmZzSW4yRjFub05ZZjhE?=
 =?utf-8?B?dGNHbkkxaDNVR003U3NlRW5QYVJ2RmROTTlMTGdFWVhHMktrVzYzZGU3NWg1?=
 =?utf-8?B?MDdkdUc2b2ZUSlA3ZGNhcm1FODVZSU52N2VZY21NT1dBajNsSDVOd3I1SHkz?=
 =?utf-8?B?SExvTHZnUkxBZnZUY1lKM2VYQzNaanJZNmNNNTVHbjVGWHNucVk5OGdlcW9I?=
 =?utf-8?B?enZJdVl1VDVXWTlUakhMWkJwejI0a2RIdzErR0E0NlI5dHp1QnJ0ZnVHY0FX?=
 =?utf-8?B?eFFvZmdQWTlFU1FuZDBUNGQ1aHg0S2VDdzBSNXJVQkZmR2k0VG5ZQXgvT3hC?=
 =?utf-8?B?VFVhL1RzellHQzJTenN0R2k0OU9RWmlDYm0rMHhoeFNMVlVVZFh5YlI4Nzcw?=
 =?utf-8?B?dWw0WnQ1SjJQT1ptb0lFSGlSVktueVRLa3M3SjN3T2l6THN6NHM0Q1JzbXJR?=
 =?utf-8?B?RjRVazNYdGNOenpYa3FGMWxybjlqN2xNMkxaa2VFUUc3eGxEekZwN05SUmQv?=
 =?utf-8?B?SkJJRk9xeWJzWGUrT2I2VGdYZ3VoT0pSWjBESnJwTlFaSFc0WThxUEZ5Wkl3?=
 =?utf-8?B?SUwzRUIwUjVMQ0xUNE1haGRldk42NXR6MHNzZ013Tld6R3p3MSs4V1MwWW1y?=
 =?utf-8?B?VVFwSFJiZjcwYW9rZ1QvSUhGRHRPamgyZnlEd01WM1BkYUhVRW1kZGJiYUVF?=
 =?utf-8?B?SGNXWGNydmpSeWVsUmowbEZ2azk3VDBMWld0THoxN3NuTERBcEFVZkVpUVh5?=
 =?utf-8?B?cEVzK3oxTXZ4YzRlUFY3WWtqWXdlMFdvMThCSVBmb01IT0k5dWRydG5XN1hw?=
 =?utf-8?B?OEg4N1YzVENlWUF4NXVEWlZtdDluaVU3M2JJYXJzM28xVWZ1Q0RNK3V6dXdS?=
 =?utf-8?B?YWc2UnVIbUdTYkxqWDArUmZtUjduY1pONlFNRngxYjBjY01kcDV0MUZWN1Fq?=
 =?utf-8?B?T0oyT1U0Z2xFKzFmMUFZdjZ4dEtJUzZHU2ZITytCblhZMDRDSU1uU09KZkhC?=
 =?utf-8?B?dkM4SzdQbDlEbDZiZXhxUko3YWU2K3VZN2Y2LzBHQjA4QnRvTkszQmdaQXVV?=
 =?utf-8?B?aFpxQytsMFhyRFdJRHdDK1BlOVhlVTdaM1FKV2o3WkRCa0EzS0NMZy9UY1ly?=
 =?utf-8?B?UmRIWFBET2ZWSHFMM1VwL1hMdERYdzBpaFF4c2pyejVKSmMvanV1TVJqdUs0?=
 =?utf-8?B?aDhON3NVUW5vdm5sM0xCYStNZEwzRUxEVUNjWkNaNFYvZGVmVGRidz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2276a85-ed92-4da7-2b52-08de5eacd245
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 20:35:48.9301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IG5BiPQPmoRdD6SJW0G0icKEw+E2XVwwQtfYbcCYhr3kizuM5ifK4SjlSt06BeiEYkTZFnK5lrDm0H/zhsmFZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6356
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69416-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,thorondor.fr:email]
X-Rspamd-Queue-Id: D8BB0A8AA8
X-Rspamd-Action: no action

On 1/28/26 13:49, Thomas Courrege wrote:
> Add support for retrieving the SEV-SNP attestation report via the
> SNP_HV_REPORT_REQ firmware command and expose it through a new KVM
> ioctl for SNP guests.
> 
> Signed-off-by: Thomas Courrege <thomas.courrege@thorondor.fr>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 28 +++++++++
>  arch/x86/include/uapi/asm/kvm.h               |  9 +++
>  arch/x86/kvm/svm/sev.c                        | 63 +++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>  include/linux/psp-sev.h                       | 31 +++++++++
>  5 files changed, 132 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 1ddb6a86ce7f..46fc07d9942a 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -572,6 +572,34 @@ Returns: 0 on success, -negative on error
>  See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
>  details on the input parameters in ``struct kvm_sev_snp_launch_finish``.
>  
> +21. KVM_SEV_SNP_HV_REPORT_REQ
> +-----------------------------
> +
> +The KVM_SEV_SNP_HV_REPORT_REQ command requests a hypervisor-generated
> +SNP guest attestation report. This report is produced by the SEV firmware
> +using the key selected by the caller.
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
> index f59c65abe3cf..63026d254ab1 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2261,6 +2261,66 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return rc;
>  }
>  
> +static int sev_snp_hv_report_request(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> +	struct sev_data_snp_msg_report_rsp *report_rsp;
> +	struct kvm_sev_snp_hv_report_req params;
> +	struct sev_data_snp_hv_report_req data;
> +	size_t rsp_size = sizeof(*report_rsp);
> +	void __user *u_report;
> +	void __user *u_params;
> +	int ret;
> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	u_params = u64_to_user_ptr(argp->data);
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
> +	data.rsvd = 0;
> +
> +	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_HV_REPORT_REQ, &data,
> +			    &argp->error);
> +	if (ret)
> +		goto e_free_rsp;
> +
> +	if (!report_rsp->status) {
> +		if (params.report_len < (rsp_size + report_rsp->report_size))
> +			ret = -ENOSPC;
> +		else
> +			rsp_size += report_rsp->report_size;
> +
> +		params.report_len = sizeof(*report_rsp) + report_rsp->report_size;
> +	}
> +
> +	if (copy_to_user(u_report, report_rsp, rsp_size))
> +		ret = -EFAULT;
> +
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
> @@ -2672,6 +2732,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
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


