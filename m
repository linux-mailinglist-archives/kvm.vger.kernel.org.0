Return-Path: <kvm+bounces-70999-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AMx3JV79jWm0+AAAu9opvQ
	(envelope-from <kvm+bounces-70999-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:18:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF25412F44A
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 17:18:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CC909305B0B7
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 16:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB24830BF6A;
	Thu, 12 Feb 2026 16:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="rqk7dTg8"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010050.outbound.protection.outlook.com [52.101.56.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DC954774;
	Thu, 12 Feb 2026 16:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770913104; cv=fail; b=iNRs/L3tEyI/K3pxIyqV20E897Pb5g0YaPuabBIr/Vl7uF7u2f2pEybVRuGk6x2iA4JBSFyUvkhxmS4geMWFU925FmUh4KesNfvGocculNqvR0ZzH4e01AG2s0TSO1eK/0a3szpMr6yvMYkz/IjnnbVebzqeUDLSEsPBXhcH9og=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770913104; c=relaxed/simple;
	bh=J4iOdsH2nUQjuC3CSBtBgCTcujwBIEgAYRwsgABCW2c=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rrnDMd7i8Sn5zzcHBLghhmxGpJETmDe9oELu6GgGzRbnV8K8IxeDUzYCz1BcM/juBChw2hnvLLQeOVWLg8B5jsxYw1l1ITYZbR56xzhQS7yUhN/MZTyL9kXLhwyTrRfP4YtuE6fCTsAzgabFQwV/D4NSXQCKVNJxJ2flOmBfRcE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=rqk7dTg8; arc=fail smtp.client-ip=52.101.56.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gMmEaOa2FBG4ZSCDYm6nlIoipCz9O4QSQvmkkyeRAmuVTXLHWK8aW8gZmY2GVRgHRNLHm0pDv8RTEIhKeYqE6MJVjPUWZZN3rbg9B1NkG+yeqG0taJMbRD0rXs2bxH3FGMvv2VUMVVU0ZMYRMNtwyxf6Bu71JJZGFruSYmp2jjpQBf28cTAfBYG0gqRtx8EzXjDGrc2brqUumG8dIfrEd7P91XrbBwwn6/UyBeXTsjY0qH8mZ++08xIrGgBJq7EfeCerEWZLRZ3dqVsqojwrBUDZUFIqorA9IVBnVg90neTJuc/P95hcx/bqc2S44ZaC51/62k3HWPWST8Mmm528Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J4iOdsH2nUQjuC3CSBtBgCTcujwBIEgAYRwsgABCW2c=;
 b=o/450iKEqRUIIZtbPFQuNdmcdhVJH13zknj1YKcQHKO0sToXaJ4zMXhzWuXMfJn3Wbl82gPSiIvc+1n37UGaLduTORObLWghjINrl8nnrtfXlPSbqkNl6P8z8pWLpNRhAcOqQEd7qg9MpvqsQsSUAbH+PPuYD19pwI0tlDuFVNKxaDl3NzImkf4lG+Lt31srV6vko8SWi3BnKQSQ8LlvTv4w97BvO28kKkXSMxd2Dc6UPzlZothA8A4jWI23zbVlyUIiVHbIhWh1j7f6+h9LJBXboK+HI7guApEOO9Lp8K4z05u5s2ReZ/830dwAiSesQlCPaeqP41s2vLTl+8AMqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J4iOdsH2nUQjuC3CSBtBgCTcujwBIEgAYRwsgABCW2c=;
 b=rqk7dTg8lyfASXg7gEoDpiiOog5w35jGKFUzKEsq9sL2EkTnQ+Z0FqkXLUzV1dq31be2iwjfWTAQnXNLc+IngJLW6ZBbo3OItT6yom0v1fHRsdnQ8yeOitUtbcey12YkVtdWyj8zS+XmIh9nr94jPhGZI3q3FctmN5hM8qnD9zE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by CO1PR03MB5827.namprd03.prod.outlook.com (2603:10b6:303:9a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Thu, 12 Feb
 2026 16:18:18 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%6]) with mapi id 15.20.9611.012; Thu, 12 Feb 2026
 16:18:18 +0000
Message-ID: <03d63568-4c75-4600-9f7f-18e080cac169@citrix.com>
Date: Thu, 12 Feb 2026 16:18:14 +0000
User-Agent: Mozilla Thunderbird
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, mingo@kernel.org, pbonzini@redhat.com,
 seanjc@google.com, tglx@kernel.org, x86@kernel.org, ubizjak@gmail.com
Subject: Re: [PATCH 1/2] KVM: VMX: Drop obsolete branch hint prefixes from
 inline asm
To: ludloff@gmail.com
References: <CAKSQd8W3ijML2L6hPTR6+eFUh3bZXjrMjSsdbMaZrmpGTSFoOQ@mail.gmail.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <CAKSQd8W3ijML2L6hPTR6+eFUh3bZXjrMjSsdbMaZrmpGTSFoOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P123CA0035.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::8) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|CO1PR03MB5827:EE_
X-MS-Office365-Filtering-Correlation-Id: 79fec8ff-cba0-4636-4bfa-08de6a525500
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OGFSenNWMVhFMDFEQkRLbUNxc3QyY3FXRmY5R2xEMGpUdVp5cEFML0s1aVdr?=
 =?utf-8?B?TkF2TXlDM1NPSk44S3BDSmkySmIvQ1JmRFJzb3krV1FUUVFKQ2xqTzNMYUJ6?=
 =?utf-8?B?V2MyNTdvaXpyWHo5R0doMUl2SlF4QjdNaEtYeUZuTWpzL0NUdkt1cTgybmhU?=
 =?utf-8?B?QXNEK0toWG5QNEQzaGthNWtsOWkyVzYrL1p3QWtPcGZDWVFOU0o4ajBRK0hm?=
 =?utf-8?B?eW9FdGlCd3ZBVnVBV1JPSmJCNkRKYlJRRWJpYk0wUEkxNURtRlVOT3pjcmN1?=
 =?utf-8?B?UjhOWFlzc2hqL1haUmhMTDZEdlNDbzA4YitoY0R0YkpMYXFHNUVrZWNRZjBq?=
 =?utf-8?B?K3pWK3JTUUsrNTBYR01zYmdpaC9xR09HT0RINlNCYWtoVEt2aUVYNklsVlp3?=
 =?utf-8?B?Sm9kMmJTY1E2NDdrUlhvOXRCSlFOSTFCMURjR2xkSTdYdkRXRGlSdFRzS1Fo?=
 =?utf-8?B?SjJJS3BXWC8xOU1GVHlXV3krM2xQUTltbXlCdzhJQ3QvS1dxaWZ0V05FOUJ2?=
 =?utf-8?B?RUdGcm1DeVBwSnA1Vi9QME1OeE50engyaHA2U3RsRzNWTnFpTmVZcHFhUGg0?=
 =?utf-8?B?MXRxeUlaR1BrSUtZL1k4VHY4NnhJRnh6M01FQXphREJYcWFLWnFnNE1JWUsy?=
 =?utf-8?B?R0N2VndvVWFiR09NYmtCZ0NZTlB2SWdKLzdEcm9ZelRRQURnUTh6cElOaUR1?=
 =?utf-8?B?TmErYjBwU3Y4TEd1SmZBc3d4QjVTMHRNeHV0VW81NlluU1BsVFkyMWNxMjBj?=
 =?utf-8?B?S1pITGUzemNpRWhGYWNxcUQyUzdJTWFiVUhBcFRjb1hwVTlva2xRbmdrUmp3?=
 =?utf-8?B?OFduUmpRTHNFUU9GSmsvVVJrby9pWStUa3k1U1pMNUUzNkRpQ1RqSjd0Y0M3?=
 =?utf-8?B?OFZ6MjVBNVZWNHhSdkxHNmNNbk5Mb1dFUUlZMnFzajQzTXlLa3JSU2xXbkxT?=
 =?utf-8?B?d3BVdEFqSWFzZVVaYVZGU2sxSjVNLzA2VERsV3JzQ28xaVhqYUVIY2dwOStL?=
 =?utf-8?B?THByclZuK1plTGVydHNBcVN6a1c0S2MybXc1alJhQjdHZTNuRzJLOCs0SkJK?=
 =?utf-8?B?N0o3ZitCYnNxZzFuWXdiNTJxRUVNT0ZZMnZjZkNtY2hDSXZVY3hacVdFTE5D?=
 =?utf-8?B?NFhoRmdpVGVEUmNQWkJhck9wR3NrMCtEMElPT3cvTTQ2QjgrN0hOcGpIejR3?=
 =?utf-8?B?aE80TDdxa2xMQmZHMjJTSndUOGlwNDMrUCt1UFhUdUVJRzRoOG5ERGd4QWwv?=
 =?utf-8?B?VzF6VEU3N0VpcHhqemVzWnd3Wmw4cE96MVpKVDdoT0xxOGVON2FZbDF1MmVw?=
 =?utf-8?B?Q0hOTXM2UXhXd2dnVFJ5M3lMN3hRMWoxV0x6dFhWaVdYenlOdlpXRFRZaVRG?=
 =?utf-8?B?LzdGalpjcFl2aS8rb0xpWWNWeTN1QmpRZDdqcUp1R09BQit5TURyamswQkgz?=
 =?utf-8?B?Um5WNEFoMXZyMUUvczBwYkRsT2pIRnFUY2xENk54SlZDR2h4OGhjM05walJG?=
 =?utf-8?B?dzV5NlZuZmZ5cUZraldVOU5UOURuSnhKOWFENkl4SHdTSm5aWFA1Z1hOMzBj?=
 =?utf-8?B?WTcrbXBLSFR3S09NbmpEcXdPSEdDbHM2MGdubnJKNGh3ZWNabmpZblNrcE5t?=
 =?utf-8?B?SzVGZ1A5VGRwZkdLQ3hYU3plRTQwU0ZvMTVmcFNpc0Z3ZG8wWW5iK1VpZlZJ?=
 =?utf-8?B?SUhoQ0t3NUdYekRaci8veWhMdXNhakd3MGl2RVNROStBeVo4LzRIWU5ZL3pT?=
 =?utf-8?B?WWdmTmUrejdBMkpkOTRjU0RMQzNTQ0JXVDRqV1JZYWVCVVNldEFqNm5Dd2l4?=
 =?utf-8?B?MWl6ZFkxWFQvUXVlb0REZHBaWk1HWFBVRGROVVlNQVBlcC8xODAxOExGRFZG?=
 =?utf-8?B?cVVXdTNqS1FrUHo1dE9ycU5MbWN2U2ZGVzIwUm91UU5QWEJEODFlc0l3amJi?=
 =?utf-8?B?ZU9hZmJ4WTl4NmJyWU9vNno3dWJ3VVYwN3Z4TXpURGx3ZC9HWkl2bEZhUUN3?=
 =?utf-8?B?dmtjWEY3dE5xVHAvalM1L0VNRE9jWFZLUmROMWV2U0l6YVlkVWN0Rk9Femlm?=
 =?utf-8?B?S3hLZjFETGFpK2RUTzAyaWswNFhLby94bC9FMVBZckdCQjFlTWVHY2ExcVp2?=
 =?utf-8?Q?XMns=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFAxZURqT1VOYllzWmVnMGwwRzRBeXJ2QzJZMDJLajc5c3dCWm5rbzRCb3N2?=
 =?utf-8?B?K0tDVlVsaHhKV3VXbklTTW1lL1ZHSXZPVnJxbmJEd09TV0h2RzI3Yzlodngw?=
 =?utf-8?B?WjByenM2RmpmRnI3U1NmeUpwZDBLd3hwZzF3cmJjUy9CU3VjNnJVb2pqc21Q?=
 =?utf-8?B?eFlwL2JmQmF6TENmNXBSZHdVakpVRW44VFRSbzNHdzJDT0M5OTc2S0hnRE5L?=
 =?utf-8?B?VG9wU2taZXZCL3FsRng5bVlPY0dibEhqOUxpRTdrTWw1c1JmTysrVUdWQlhU?=
 =?utf-8?B?K2tISU9jY1BqK3I2NEJIcTUrTENwck5nVWZKb2hJeTM3bUloUnpMYlBVbVRZ?=
 =?utf-8?B?SlVJelpreVNDZ1RJbEFkNGpNaExsS3M0MjZSZ2FvSkRyQVdrZlVodkVUMzhX?=
 =?utf-8?B?Nm9yejQ2NFJZUU5QdGp5dkJpdEh5aitKTXZxN0hDMTZaajBEU1l1L09YdXhS?=
 =?utf-8?B?UDBkVUVzNTBnSHZHbkZaN01vSFF4YlhMQ1g5a1VDUmFUZFFQdG5nRnRnL2d1?=
 =?utf-8?B?Wkp5Tm1LU1BYRlY3TjAxblV5RjlCanpyT2JHZ3JKSnEyZGpNUE9OVUlqR04z?=
 =?utf-8?B?dkxNRWhCL3Q3MktYQ3N3V0t2cjJnQTB2dkZsdnNMVlBrM3k2VGxSRTh0VUMw?=
 =?utf-8?B?akhQWlRXQXpsTzQyUGR0ZUswajZlWjFDajdBWDhYT3BKdUhIQ2VmckpLdXJv?=
 =?utf-8?B?ZXZHUldKVDl4eGt0c0RIQVg4UjJKWGc5RVlPQ1BPQkVDd2FBdWlXVHQ3b1dm?=
 =?utf-8?B?dGdoK2syNmFwS1l5ODBpeEtXZlVDdVpVVXFHL3BxM2IzTEN3OHNZK3Rrems0?=
 =?utf-8?B?bEV6UzlnL2NybXJ3Y2ZDT0gyaGNXUGwxSjdpOCtRU1duOU9UdnBmcnlWVzlZ?=
 =?utf-8?B?RVlkUVVHRWRtOFVMekdvSXlOMWg3dkp0c0R3ZW5RN1hVSXlmVHIvL2xvVk1R?=
 =?utf-8?B?VFYrazc3N2h3WElFc2o5N1h3T2R3aWZNb21uOGRyWGJoNTFJeVRBRzJTVXoy?=
 =?utf-8?B?TEVoTFUzazkyU1dJemROUGFLTEJwS0ZrSDl0UUpYK21vYnlaUU05YUk4UWo0?=
 =?utf-8?B?UWlJaks0MUhJTE92QzUwN0hSeTZrMUxXTGppNSt5WENEWFRVSkIxZjhiUGVa?=
 =?utf-8?B?QWMxcVF5QUd3K1NCM2hNY3pSMHROQkVMQ2ZGaE5PTmRpUi9RZlBEWVlVd3o0?=
 =?utf-8?B?R3VaN25rbTcvV2hoRHNscEk5c05mSy9vNmF5TFRBamYreXd6ZHhWU1EvV0Za?=
 =?utf-8?B?OS8zRnhPN2FjNHBFMURqS1pqdEFtU2dPbWZuQXFCM2pGT240ZmxPc0FnZXpo?=
 =?utf-8?B?dVQvNkowc0hqeE14RmZ2elF6T1lUVnRVZG5lbUErK1hsenBzMndseWtyTC9K?=
 =?utf-8?B?NXMyaXY0bFZHQmI3NDRYbXpGUDNJY0hQSnFJZ3o0WW5CTlNDMXZnQnhHL1BG?=
 =?utf-8?B?V2tkdms5cWY5cjV4RzR1SWlzajh5SjFKMXJVQUhQVmlRdkRsQ0luamZtVzFi?=
 =?utf-8?B?SDh6MUVvOFpyT0xSV240cmVsMXF6VE5FVmhMQ3ZRWUhnT21mVzBxR2xWcnRi?=
 =?utf-8?B?aEZLUnlhczRYNjN1S1pySk0wWVJlSnRVRnIvd1VIK1grNEpLLzkzMjhaV3ph?=
 =?utf-8?B?NkpIZklsUWxJOHpaa2hweXBBQ1M4S2t2MzlXR3N3cTluQVk5NnQvcVowN0dv?=
 =?utf-8?B?RWhLWFhyWUxFUzI0VGl6R1liSzBWaWVJNFJSN0VKdG4yblhEeDNaTDFKclht?=
 =?utf-8?B?enJ2TnFyRzd6bXJMSnI1dmQwTEF0R3N0aWU3NTBsVmQ1MmYzZ2tVODU0SUgw?=
 =?utf-8?B?Y1FsTHRrOVVnWG1nQUFIdmlrdmxQeXFiOGd2Vy90Z1JsSjg5UVdWUVdsTEFQ?=
 =?utf-8?B?TGJ6N0RDWHhVNUFZZjlxUUhzMXZnamsrVUdqS3lRVFU5RE5TOVB3SVdkbE55?=
 =?utf-8?B?VC8xcjBFOE9ka2tjaU5GRjl3VlpFUXZKc3Z2MCsrQmRCZmpuZ2tWMjkxNk43?=
 =?utf-8?B?Q0tFTjRBWHZkOXp5YU10T3R0NkIxOFRlSy9UdlpjNENJVU93c0Y0cjRGMFN3?=
 =?utf-8?B?dW9BUzFqYUFKRnRJLzlmTkVac2FQajAxeEpWd01tL1VYbGYrRGZRcmJKOTF3?=
 =?utf-8?B?V1UwcUJ5Vlp0UUdlaEl3MTQzMkY1d1BHVjBBb0ZIR3JjaC9uWFJUNjFUUDB4?=
 =?utf-8?B?aXJDU3dDOFJKQnZaY3UrTy9Cb0t1T2IvRkZQNzhFeExLTVpuRjdHNTJ3aEd5?=
 =?utf-8?B?T3UxcFBxdXRMSiswN1F4bmdDZGlaT0dUR1Ywa3dzNmR3em9UWjB4L3E0Z0xn?=
 =?utf-8?B?ZzVGbTAwVTM0eWVwTVB1Y0FNd3dsa24xSnZwaEdQbkVBWDluT0w4Z0krVmNZ?=
 =?utf-8?Q?Nd1VHL3r9pk1JTAk=3D?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79fec8ff-cba0-4636-4bfa-08de6a525500
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 16:18:18.1115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SxnboqwxcTqx8D9IUFheXXR7ZTBJWzley+8tcv6Ls49bszLTRs+25o3J2zw5taGIYa1VMFrjykZnUs2998GF1jIool9j7gBF5OXnWNZVwE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR03MB5827
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[citrix.com,reject];
	R_DKIM_ALLOW(-0.20)[citrix.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70999-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FREEMAIL_CC(0.00)[citrix.com,alien8.de,linux.intel.com,zytor.com,vger.kernel.org,kernel.org,redhat.com,google.com,gmail.com];
	DKIM_TRACE(0.00)[citrix.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.cooper3@citrix.com,kvm@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,citrix.com:mid,citrix.com:dkim]
X-Rspamd-Queue-Id: EF25412F44A
X-Rspamd-Action: no action

On 12/02/2026 5:33 am, Christian Ludloff wrote:
> Andrew Cooper wrote:
>> The branch-taken hint has new meaning in Lion Cove cores and later,
>> along with a warning saying "performance penalty for misuse".
> Make that Redwood Cove. For details, see the
> Intel ORM Vol1 #248966-050 Section 2.1.1.1.

My apologies.  The ORM is the source of truth here, and I clearly mixed
up the uarch.

~Andrew

