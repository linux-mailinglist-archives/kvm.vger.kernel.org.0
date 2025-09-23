Return-Path: <kvm+bounces-58587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C125B97048
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 19:25:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D610518A63D9
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:26:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE467280332;
	Tue, 23 Sep 2025 17:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cpLHRXKv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zKvwmwxx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046D72264CB
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 17:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758648341; cv=fail; b=SXPwA0J8B35muTJw70FM7PeiTodkO80fKCyoPPB940N2GPSXgHcrCneFRHxTxFowJqEuxCzGW8o5ql730PUsASeZSRpkhhdl+D6OFnaJmU4Skt5ONw6dwH8L+1cqJKwDMnHS3nrBVsmrrums2o+zVygeD2iKp0cyr1PfWK8Vrb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758648341; c=relaxed/simple;
	bh=5AwchgRYaypSkWw7uFy1lT2ZQCUOw/kldSHZ4uuFpTQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GxuHaZFeBSaOaF2TLEXyoy4vNWWdjg2YD0+ay7CizbUFaPZt+GoEijYKgIbqER9s6v1p5lRiDhKwa15hCU4RGFhAxCxBhexqRw4oYE84VWDcn1dGj7p+wMImyI/oMejm4yvUE9nz1TAP2VFYtcmUi5tR/dxY7/yEVGe+XwYu/rU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cpLHRXKv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zKvwmwxx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58NEY2h4017310;
	Tue, 23 Sep 2025 17:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=nW8w4Lx2cqs0i40VLkrDSu9UGQaJQltNs2+yU25+vho=; b=
	cpLHRXKvh0pnkstw2PJY3FpVM18S5PttJDAsSXgrkZNST65rrhCtQkP+274zH0k0
	oeYLbjyOXHZS8bH+c0PTolJibxs++daXEGHfGn7nlbfa+qetT4WVPBLNah8mX5Hh
	jpaSniS4BECuAexuHhMpZZJ/nZ30sIvqUeo3OJhVIvkJ6QtbIJp3EXEtXfbnZeQy
	Okk82zlFBNo+nHw4SaiLncSipNTlSTSFeLt5iGZq/HIlhL/+0KajhRULRDLJgai9
	ji1KoacYW61JxSl4wI0vXRgUOwKNsgkqeKmxxtrtw0CZubioh1vkpOE9u96m/Lf5
	zmodkxfxWQy5rW5rHR6HuQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499jv159th-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Sep 2025 17:25:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58NHDZlV034410;
	Tue, 23 Sep 2025 17:25:23 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012060.outbound.protection.outlook.com [40.107.209.60])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49a6njyn0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Sep 2025 17:25:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MzfanmVV98Es09G1x3wCxnZ/r6brRWSiqgVxc9+OCritx7GuKgGqbBAOMIPvF8/pAISjk5EVVrqNJXOqmLJfOIWcelepCFTj32u25HHD7hKYudDtOSywnjCI7q8GshgvLYlD682u7FRqmHcyEOAqm5CgKjUdkcr7sIUrIH60Bp77QmSiFyaCLfcYMqnccJhjXek1JDd73nNp6GD31YGjb133da53lQSj5pu3nZBUvsZ6qiOJeZOAEAYcwmIH+enKkJhf2C/2jBmNPU+ubSdwJAdHViCe5rDpR2aoFLn90zI1l9fU/ohmy9CsYRxhnd+s1CcrEvcAKFEGjOMS3/rRSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nW8w4Lx2cqs0i40VLkrDSu9UGQaJQltNs2+yU25+vho=;
 b=o76qFcLo0V+6un0cqEOM3FCprEv537uMHDLSIMuMn9Q+S7yBfmh3dgDUbbUCb43RLPMMGmnSAH7O3HXFnPjesScghHNrBlpSBLuWn6mhmFOmZPkoKi5aV1IHYIZnkTLzVZIFeHxir5jHQf5yigHHdYtB4Wzvp+pBH4T2ppXOUIWynE+HVV6rmQOVWHKvQuC9ygk5l89m3wthEsmagy58sGwCnO6u8t1wu8JSgSMSk0BsU7lq1fO0a2fFepaqyFa/I3Jup8v0ia1xxuU9lGbcYLNixRaJTP9Q0QRqzinuqJF4etvNyQMY28S0Q68O+KAcSlGMrdNArLqH2gsDY1HWgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nW8w4Lx2cqs0i40VLkrDSu9UGQaJQltNs2+yU25+vho=;
 b=zKvwmwxxULF/C4fpZFpXlyMFZP1qGgJ/oFPyO/ejqC8TVX7Ep75tx60MLV3GAqLhzexypJBKe33l+Yq/zTzlI8oq/tyYk5Gafx9hgHNAvgqhT1zDLmJI6Vq8Y/acX8JVjiyVXoowvNsJ/xQXNIh+XEUFdMnQeBQ9k6JYGFDU610=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 CYXPR10MB7900.namprd10.prod.outlook.com (2603:10b6:930:d7::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.19; Tue, 23 Sep 2025 17:25:18 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%3]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 17:25:18 +0000
Message-ID: <bbadb98b-964c-4eaa-8826-441a28e08100@oracle.com>
Date: Tue, 23 Sep 2025 10:25:16 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: Should QEMU (accel=kvm) kvm-clock/guest_tsc stop counting during
 downtime blackout?
To: David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org
References: <2d375ec3-a071-4ae3-b03a-05a823c48016@oracle.com>
 <3d30b662b8cdb2d25d9b4c5bae98af1c45fac306.camel@infradead.org>
 <1e9f9c64-af03-466b-8212-ce5c828aac6e@oracle.com>
 <c1ceaa4e68b9264fc1c811c1ad0b60628d7fd9cd.camel@infradead.org>
 <7d91b34c-36fe-44ee-8a2a-fb00eaebddd8@oracle.com>
 <71b79d3819b5f5435b7bc7d8c451be0d276e02db.camel@infradead.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <71b79d3819b5f5435b7bc7d8c451be0d276e02db.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN1PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:408:e2::29) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|CYXPR10MB7900:EE_
X-MS-Office365-Filtering-Correlation-Id: f6abdaf0-95dd-46c6-2a11-08ddfac62aa6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZzVDcEJDVWxlMjJyTFFGYTJmMUxDM2lsN1JzZmpoRXBQRjBlTDNoNzlMVXNT?=
 =?utf-8?B?cjkvYnpsdGlpR3paZU9YZE9saUFTLzRkS1A5aWRMVjN5RlZkaEUwSzhNbWNM?=
 =?utf-8?B?a3ByOGFpY2ZjOEZNa1JCZ3RBd3pWeXpOQmtQZldTcjdNQVlCTlEySzFhRHc4?=
 =?utf-8?B?L2RkQzdRai94TC9xVTl6Z1d4VjkwZm9NNVpYSFVtMGpsMlZCZDVrVHR5WXRo?=
 =?utf-8?B?bjJERXVnN21sYm1idlVDSzkvNUQzMmFhWkVSaEZUU08wWHN1aXpDdjYyWWJy?=
 =?utf-8?B?YVJMOHlBWWt4M283aWRlMFZoaG9Dek4vcWsrb2t0dFhZR3F6VDIwdS92dnZK?=
 =?utf-8?B?K3JPeDN1Q05aSURKZGZ0Z0Z6M1QxUStVTENCclVjSGpobnFHQkh0enkxVzBM?=
 =?utf-8?B?MUM0dXFJUjhxMWhjR1F0ZjRLVm82Y1hqYWJqakFYK3oxTVhMdlBzYUtCUHlB?=
 =?utf-8?B?c2QwajhNbWtIM1hDajJ2Yk9YZUZCamNKSzhMMHhkRTJPdnhicDFIeVUvR2Rt?=
 =?utf-8?B?OGlMVzMrWDQ4aVZDcTlnTmRwQ2ZOT1NsT3I4ZjJVTGlBTjRpclJVeEpjaUlN?=
 =?utf-8?B?SDhPeERjMDZoQ0tSMzhnMHZPYzJHNzRYWS9oelhicWFmNEJxOVNyWHBZL013?=
 =?utf-8?B?N0l5WG5ZN2xaekltdEx6blc3UjFkT1JtZEZ3bG1tMHFpWmxhcmFZaFYvZDcw?=
 =?utf-8?B?Mmlhd2hPcy93UWQ2WWkwazc1UTB1V2JUVGt2NERSRHRzN0FsWm5Vdk96Wlpq?=
 =?utf-8?B?dWFST0o0Wk52U25DZS9TOExxc3hUK3c5TXV2WmY5c2JqZkMzWThFeG45WE9Z?=
 =?utf-8?B?UXMxZWt1S1lUSGgyRXh6SU9RRmFpcm5PbndnclloMkZYSytvL1MwQzVlOWdQ?=
 =?utf-8?B?Um1JbWd2TUhuYm9PTTVCeDc0eVpscE5oMUkwV2NpdGQ4c3RoZEM5UGQ5NzFa?=
 =?utf-8?B?OTBrUkt2eXpyTnByQ3Z5VFFVQ3ljbkJiLzFUTENCd0xYRDMyVkpndWRQUzBV?=
 =?utf-8?B?UjFlMHNNUmM3NnJGTWFsd0lhZ3Y5bXBqMlk5SHRjc2p3ZXkvMHA3OGhyRldq?=
 =?utf-8?B?bkY3SVZ2Wlc0MEQvejFWdEZtbHBJMllPRHZoNk9Jcm5OTk5nMU5lRFYvUEZ3?=
 =?utf-8?B?REFLYVVCeWRrTXhkamExTVRQS2ppM055VFdYa3krYzhraGo0VWRHYlFuckM5?=
 =?utf-8?B?bDliSWVTaVc2MEtkekwxMmlIUGZEcDlBWVZFOE03VDRmWFNuQWxGVVU0L0Zv?=
 =?utf-8?B?MDJvNWJCbEpybHh3am1wTGZyc3BmeXd0bDdmZEtrd245VGpMcmhqNHZPZ3Bu?=
 =?utf-8?B?Z2lNRkpTaGo3b3MxZitvRmdxRUpQQ2t1Z2xvaTl2TEwzMk9qcnNiMFhxK3BI?=
 =?utf-8?B?K3FOLzAxSjh6OHRINGU3emtjTHV1NUtPT3JqZC9wMGw0RjZXTmdnNE5JWGE1?=
 =?utf-8?B?UzZGZ1B3Y0N0ci9jQzREVzB2aWpSUWdTMlFha3QyOGJldzVaYTZQYUEzVUJu?=
 =?utf-8?B?U3k2RWRhaXFveTB4cjd0ZEpzWDRhQnF3ZndYaGRDMEJLRm9JVS9OQnVKM2Vx?=
 =?utf-8?B?bk8xT2FjbzJxbU0yVE81blNQVktzdjBUTXBQQm0vT0lDREZpenBBZ2NheXpP?=
 =?utf-8?B?Uzhldy9mQkl5ZDRaOFc2a1FJMmcydE9PNEhxelpzRTFxZUs4dStEQ25uUWVL?=
 =?utf-8?B?SGR3VnFETUQxcW9LNGdJSUw3VExWZkp6akpQOG1QemE5cnpUcWlkL3l4Y1du?=
 =?utf-8?B?aW0zWFI2Q0puSHdic2lKMGpKNXp6YXV2Y3Z5SHFuNEh0N2pLenc1cjBiKzRX?=
 =?utf-8?B?bW0zY09qZ2pFUHFCcHF3RTZXcDBaUDRSN094Nk1XcnlhN2FBQjRwa3dXZ2dQ?=
 =?utf-8?B?bWowa2p2ZmNYZjA3S0o5c0ZYTGtrK1BCemlLSlZiU2FzbkRLZTVqdjB1dUk1?=
 =?utf-8?Q?d/Bl83kdxXA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R3hrektPQUVJd2xNbVFFS2Y3ZXloRTgxakdhZnRiTE8rd0hyVXUwYzVBcDRo?=
 =?utf-8?B?SkQyZURkNWFOaGdJLzg1VEtpaEs3azVyWnNmWGlTTVJBTDgvdTJaWUx3MEp2?=
 =?utf-8?B?d09odm5SakJ5VE1mZE5tWE4rQ3h3b0hIS25ob3k0SVl5TGhVWURDSUpML2pV?=
 =?utf-8?B?THpjRkFURWwyRmNmTDluVXN4Q1pUaWpQNDcySXRKSnYxOHpmaElCcHBGYU11?=
 =?utf-8?B?blc1WGZmR0wrUVhtMFlOYzRTblhBWXlKZlNITXp6Vll2K0M3RVhtOFE1RnND?=
 =?utf-8?B?V3MrMkU3UDRWSjlEVVJtc0NNd0hmNjlZQkhpYVVsQmZKbDkrbmpTVG5SRy9j?=
 =?utf-8?B?RXlBSFhaZWxWbzBpY2NmZFpWV0NMR0tjKzNJOTJVRHMvaS82ZCt6Z09abVNG?=
 =?utf-8?B?VDhqT0Y0WnVxUGdKT001b1hGRk1XRDhUYnd1M0xsYlVGa05YbVZvMEZGWVZw?=
 =?utf-8?B?MlFmdFFlZmtlb2ZPblRwZm5ycGhwYkl6RkcrRW10NXhrWDRaSzVKMTF0YTMv?=
 =?utf-8?B?ektpRFllblIyMWxoZWF3V3dTbWlxa1pyQzE4YXVBVmh0bERkUitaRWJ3N3NY?=
 =?utf-8?B?QkRKQ1NTbnM3NVJIUVNUa0x6NEgvVTM1T3JQN2o3SzJTTGw2czhycHhpUnVO?=
 =?utf-8?B?bnRtVUN1ZHVaT3dmN29OUGw0bitDa1U4emNtd2FXaW9taWZTclNUVDNhYXpx?=
 =?utf-8?B?Y2FnOFlSY3A5K2ZHVWhWNkV4RWNZdkdpeDUxZlNtVkYwbDVQTlNIb0dFb2lW?=
 =?utf-8?B?NkU0OXErcnBMNkFLd1JBMk82ZGhIRXRRaXBXbXVobFJZY2haZ056TUtLTnNR?=
 =?utf-8?B?SXc2dUJ3U2pYcFgwVDVGb1psZVJjYjdrU3VscEZVR083UEo3dndrYkRkSzRF?=
 =?utf-8?B?VzZQcS90TkJESzRXdExUQ3MvVmdsTlFGMzRmVitzdk1UK1lHeUIrWVdLT2Q0?=
 =?utf-8?B?MjRuMy8xQWpFSVZXK3h6dFNSTUhoY3NZRm90Ynp0Y1JicnVlblI5T095d1Iy?=
 =?utf-8?B?ZTNTWnFvTXA0U0ZjYk9WYk9ReXFub2ltRWNBRXFoc2JFMGhkcDM5L1R6Y1Q4?=
 =?utf-8?B?dnkvKytERUFiaU40c1BJb3AvQjRCNythMlhtK052enRVV0tLSVRWOHdJak9W?=
 =?utf-8?B?Z3ZUTVdLQmRGVERwMTNhbUExOW5HMUlxRVpQU1hTWnhxbFB6UlJnR01HZkI0?=
 =?utf-8?B?WmJMTjJ6RXBZWVNpYTdSaDJZWGFzL3dxMll1UDQrSzdiVW5aMmt0QnB6YnZR?=
 =?utf-8?B?YWJBZi8xNmdNYWtZUmw4NTZtREtPWk5RMGo4MEhoZ0NsRjd0THJlZTgzTWtO?=
 =?utf-8?B?RVVta0Y1U0U3bXNyaE1hZ2M1ejVXWmoyVm9HSE9BbHE3bk02ZE5tcVZIbFhN?=
 =?utf-8?B?Ym5GU3M0Z1VIQlE5OFhGQzRNZUFNcVFKTFlMZ2w5dWJTMUQwU0RITkhGRTht?=
 =?utf-8?B?Zlk0T3JIdVRXdWpHNmpoNUgwMDdraGk4OXYxaEh6d09wM2xXZ255cWc2eFF6?=
 =?utf-8?B?UFBGWXUvb3NPTjJJUUhNOTJNNkZWRlMxTSt0QXhNRFBQeVl6NTNISGVhU1JH?=
 =?utf-8?B?Y0tZTFFOWGZXWGMxUDJmcUZYSDMxY2pxOTgyM08rZUczbTNhT1JmM0g5Q2Qz?=
 =?utf-8?B?RDVseDNtd1N2SFdqVHgwekxCUm1YRXg5TzQ3bFd1VkJMWWVtUWQ0a05WV2JU?=
 =?utf-8?B?OTNHVHhRTzQ0UmZ0T1VLNHpnUU96TkZFQWVseUpkRU9LbU4xTEUwZlMvYk5M?=
 =?utf-8?B?VENjWUhmSDQwREhwUVVJZ1czYzJ2cjViVW9LSUZzNk1POWJ3TzBrRjU4di9S?=
 =?utf-8?B?cUdCWEVVdUJqTjNPYTNsUVg5SFZUekw3RUg3eWpEdjZMWEdkS2dWOXRQT3Vv?=
 =?utf-8?B?VXpwVEpVM3lJbWFNbDg1Y2VtbGRrREdjMnRkRFkvWnpwY04yYTM3MzBKdEdO?=
 =?utf-8?B?VnRudE51blJWcGJlbUxiRW9WdW9aU0k3Z0ZEejhWVjVTRDdIYWdNK2s2a1FE?=
 =?utf-8?B?TVNlN2w5RUJKQVljQWtvZ3VWbS9PSnRGLzRwZ2RhT1dDL2t2aUZ5OFA1SVVl?=
 =?utf-8?B?TWZyTXRtSmUwVG91VE12UnFwV3piRFNkOW00MFlDd01uZkF4YUdrSVBjMEpv?=
 =?utf-8?B?dk0raURLR1ppN3B6Y3R6OG5Pam9mU1gyaEY2YUd2SUtjVTVURndHSHV1MUVu?=
 =?utf-8?B?Tmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BTM2ehRU9Hs5U9o92ILyl8bFR1YCRHP1sqabLDsVTOiTOcfup23DkRKtw1rvPyajQAzw8z+C7jD6ytVhpJJnHVbB+nReiaJ+I5iN9wCZy083n98xvwmWCGdPcBV3pWCC/BlBfsv97R1TBl+QnJ+SwkzobusdIfrsjRygiS+j1DD6nPpejSQkgwpSm9G5d7cdrgrKqL/MxqbvYYyCtG2BmNDmSGfhsc7DECcUH/2C+fFiUfDYNCn90j79YuDFgNr0To4B79hIlJgBdlwSKFN5qUcNsHpbYy9tzU0VoOJU7nX9/iFBcr4PXfZ5EcdN8jF1IuDoDJkE0g21P5whNUb5qBYv9NEajtuG6xwBz0E5CrfWYr23HSP08MBzSvzbTAuHof6UEvx2X8X+Z2aFe6dBgNskwtaUTQVrLVubNZF5Gnr3l6CXaO/pKvLpMN9lyOahkhzENR28hKhvMM7zgGHepsHXWGXxjUZCcqDvS5GHWsWSv5WfQ5MGl1lF2UdXmHpGQvfMT7z/95ZIZsMePxnGjrFzcvWYGuFzK3eqbNfJJoByrsgt6jY4idvX59Y4iEBuUYOp7Ewf50ZyGXOXvlavKBo+Mh5jjwYJmgGfjLYq5ko=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6abdaf0-95dd-46c6-2a11-08ddfac62aa6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 17:25:18.3915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GyVVAeIBEvso/NYZV4Ie8HybE5gVuW3z6yfpZ+0aeIl8zucxcdMVX2Eut7IYTvFAeDs0RlJSm2jBLEtvwNdxYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7900
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-23_04,2025-09-22_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509230160
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxMyBTYWx0ZWRfX034bK2nAgQzQ
 dgbnFta4QN52tB/a3U+guTDf2JpoOON0gdPATDBo3SxZjb/WqS3656NSTuxBELoridVw9+WP237
 X7rZnC7Xuo4T/u/dvzgc6pf/Pg88oKMK18ReUx9XxbKL9MGqSbU2xZyIswcXYP++OBKPhYIWA4E
 /ulwFbSz9nfwRlwucdMP0Sbhz7v0Vdbj8QEWX6H1llu9Q6UzJzxkEPX+9rmL8GDzMcHVJ5cIORJ
 94EOe9PfRhYt7Pj3uu7kqwpaug5gvaBKxbI/8HfgJg7XLghPy7r2Yj+aAcCaUSrsnWPNyLcDEcD
 Fm2RTwYWbAdafnA1Isw8SCpfBl72bCZjW3dwmXuSHtlnPr6wIPZ59yS8ODKttkqmRY0rCjfR+vC
 We51hTfT9JKdWSZFI4+oR/pqKTqsmA==
X-Proofpoint-GUID: wwrHj7gC3mHz66eKfGLHXrb3FMUZ5bbV
X-Authority-Analysis: v=2.4 cv=YrMPR5YX c=1 sm=1 tr=0 ts=68d2d804 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=rg0hoZXVBB5K34YeZrAA:9 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf
 awl=host:13616
X-Proofpoint-ORIG-GUID: wwrHj7gC3mHz66eKfGLHXrb3FMUZ5bbV



On 9/23/25 9:26 AM, David Woodhouse wrote:
> On Mon, 2025-09-22 at 12:37 -0700, Dongli Zhang wrote:
>> On 9/22/25 11:16 AM, David Woodhouse wrote:

[snip]

>>>
>>>>
>>>> As demonstrated in my test, currently guest_tsc doesn't stop counting during
>>>> blackout because of the lack of "MSR_IA32_TSC put" at
>>>> kvmclock_vm_state_change(). Per my understanding, it is a bug and we may need to
>>>> fix it.
>>>>
>>>> BTW, kvmclock_vm_state_change() already utilizes KVM_SET_CLOCK to re-configure
>>>> kvm-clock before continuing the guest VM.
> 
> Yeah, right now it's probably just introducing errors for a stop/start
> of the VM.

But that help can meet the expectation?

Thanks to KVM_GET_CLOCK and KVM_SET_CLOCK, QEMU saves the clock with
KVM_GET_CLOCK when the VM is stopped, and restores it with KVM_SET_CLOCK when
the VM is continued.

This ensures that the clock value itself does not change between stop and cont.

However, QEMU does not adjust the TSC offset via MSR_IA32_TSC during stop.

As a result, when execution resumes, the guest TSC suddenly jumps forward.

> 
>>>>>
>>>>> KVM already lets you restore the TSC correctly. To restore KVM clock
>>>>> correctly, you want something like KVM_SET_CLOCK_GUEST from
>>>>> https://lore.kernel.org/all/20240522001817.619072-4-dwmw2@infradead.org/
>>>>>
>>>>> For cross machine migration, you *do* need to use a realtime clock
>>>>> reference as that's the best you have (make sure you use TAI not UTC
>>>>> and don't get affected by leap seconds or smearing). Use that to
>>>>> restore the *TSC* as well as you can to make it appear to have kept
>>>>> running consistently. And then KVM_SET_CLOCK_GUEST just as you would on
>>>>> the same host.
>>>>
>>>> Indeed QEMU Live Migration also relies on kvmclock_vm_state_change() to
>>>> temporarily stop/cont the source/target VM.
>>>>
>>>> Would you mean we expect something different for live migration, i.e.,
>>>>
>>>> 1. Live Migrate a source VM to a file.
>>>> 2. Copy the file to another server.
>>>> 3. Wait for 1 hour.
>>>> 4. Migrate from the file to target VM.
>>>>
>>>> Although it is equivalent to a one-hour downtime, we do need to count the
>>>> missing one-hour, correct?
>>>
>>> I don't look at it as counting anything. The clock keeps running even
>>> when I'm not looking at it. If I wake up and look at it again, there is
>>> no 'counting' how long I was asleep...
>>>
>>
>> That means:
>>
>> - stop/cont: clock/tsc stop running
>> - savevm/loadvm: clock/tsc stop running
> 
> What does "stop running" even mean here? You can never stop the clock
> running. The only thing you can do is change its offset so that it
> jumps back to an earlier value, when you resume a VM?
> 

Yes, I meant "change its offset so that it jumps back to an earlier value." From
the VM's perspective, this is equivalent to "the clock was stopped."


Could you help explain why we treat stop/cont differently from live migration?

The live migration/update is same as stop/cont because the blackout phase
involves stopping a guest, and continuing execution in a different/same host.
You technically stop the guest in a way that's not controlled by the guest
(compared to say hibernation or suspend-to-idle). and then you continue. Part of
the reason I think 'stop'/'cont' ought to have same behavior as live migration.

Thank you very much!

Dongli Zhang

