Return-Path: <kvm+bounces-71579-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ODqYJUgZnWlsMwQAu9opvQ
	(envelope-from <kvm+bounces-71579-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 04:21:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BA69B1815CA
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 04:21:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 27DBD30080A4
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 03:21:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C370F29BD91;
	Tue, 24 Feb 2026 03:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="iHLQw14f"
X-Original-To: kvm@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazolkn19012054.outbound.protection.outlook.com [52.103.66.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C86223815D;
	Tue, 24 Feb 2026 03:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.66.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771903297; cv=fail; b=OTSA1VQJEaujaop2ntuqOMnbiHBnNwdXnIVaq+ESdqaUrl3iNP0Mein8vMOU4qSM+l8saAJaeKhxIVaojKNlVs+souwsD+HXgZgYI75tmxJjo690gAYkeCF75qdj6aIe2yPJC87RDyB9s3kLtDz2ntsE1tU4/lZMI5sNBvPMZf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771903297; c=relaxed/simple;
	bh=sQFOF4zLxJznzcHzi/2OQIAgEBhZfZXurg6LGEIpnws=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qbe3zAw2GKakLLASYLF4T6q3oq5l6ltDOUAgphBHLxEQ8YUS4r1RvsDvqjHffg+FWzErSn27violHDtfGXjQHQ/VYg8IT82Ga9gdYy8p2RL0tmLAcngzA23u4Wq/F98gw1EurMvGRpAXn5IZEj14Ez2xCehm42WGGKz0h7Pz6ms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=iHLQw14f; arc=fail smtp.client-ip=52.103.66.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=evXeGyCEShjnDEi3DsY6CtbvX2cgkJrJFTk7caOz2ALlZdjftBku/RIc1ZbCblzijzIPDpAEAGP/x3WCr3CknnevEqH/2CUIV6yMlmdWfqoXKMBIogTs9yUcBkXubqFyv6ke4MEb0J1gHoD9+RaBWpYjD6WB5eXj48wvowFcegnW1+z/gER/u88FcX6sfMRDqSTWz9Oq7Q63Xdj9pX9D3KK2Iha4oIImxA3JMeU/iz/6u/VPQqo8SlsJlZIRl+ve7mTObxMOUboUOivJgmt9C0tNX0fXFSNqIAiKXKrSyRYzkJg/mrHXqlaf/xRoS9aDc6iRlJV96bDktysERR1vKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RWMllDdPxd74lW9sWQapNlk+fh7k7s8Fpb5hAM9eLX8=;
 b=vnCpdF/EtxvkMCcis6YzN33UMPsoXto7r4vmxNg5QvFVFnIVYYTayuF66UOYpFeyD6Ht0A1hiCRTjt08yINbA2b629cxO5PbbUFe01Cisxia0sZRByk/7Dl5b8e3OTrQvGbCnwjF376XE8WwYrtXnclm6HmgrPHHHPkwig+SCTc0TUxSPWpCYmnuw7EB1sJUZRAMdzCFSiT1BAF1wSogR3hKOddxaiImXrxJy5eJSWZwLSzJwq48HMO0ccFKi4RGj29xStUQ7BUBVLzww2hWplc4NLK1TfPLgB20SqhJ0+7ekIIS56cUSadIIrPbfeR8HSw1lmvXpP6I1yoDQ4fUZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWMllDdPxd74lW9sWQapNlk+fh7k7s8Fpb5hAM9eLX8=;
 b=iHLQw14fcbEZ4/Fykzb4oPfpl6skqELn93u32t0BeAWuyUhDqt0DPMsIX/4OYdBzPxqGgSjrUOL2UK0Y2H7RihfnW9A9SA7SPXw12TEKVB0jVozynk9ejlol6K58XgRXVjj4rxxghQrYIzu0nKzAqHuUrv6l0pXtWqYvr36lyW6gQw7dRvKXNjpkouQ28zTS5AAlohp9CtOdGDUOUXG9asNggapWL625/D5e/7dPA4SiUqK6VpCutwF7uLkdwvYkLkr9P9WoRRqmYNdPSE9u8o752wKxWxauUL0MUVHWd+Dk2WodVHdOul4Eyyi6za+dsK1HXAq89oQHn1lE+rYVQA==
Received: from SE3PR04MB8922.apcprd04.prod.outlook.com (2603:1096:101:2e9::7)
 by JH0PR04MB7057.apcprd04.prod.outlook.com (2603:1096:990:33::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Tue, 24 Feb
 2026 03:21:30 +0000
Received: from SE3PR04MB8922.apcprd04.prod.outlook.com
 ([fe80::3450:f139:5238:8f58]) by SE3PR04MB8922.apcprd04.prod.outlook.com
 ([fe80::3450:f139:5238:8f58%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 03:21:30 +0000
Message-ID:
 <SE3PR04MB8922FC10A8C7243DD4E3F369F374A@SE3PR04MB8922.apcprd04.prod.outlook.com>
Date: Tue, 24 Feb 2026 11:21:25 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RISC-V: KVM: Fix null pointer dereference in
 kvm_riscv_vcpu_aia_rmw_topei()
To: Jiakai Xu <xujiakai2025@iscas.ac.cn>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Atish Patra <atish.patra@linux.dev>,
 Anup Patel <anup@brainfault.org>, Jiakai Xu <jiakaiPeanut@gmail.com>
References: <20260130101557.1314385-1-xujiakai2025@iscas.ac.cn>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20260130101557.1314385-1-xujiakai2025@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::6) To SE3PR04MB8922.apcprd04.prod.outlook.com
 (2603:1096:101:2e9::7)
X-Microsoft-Original-Message-ID:
 <4e67a0a5-d7b5-4828-8a22-900aaf8a17bc@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SE3PR04MB8922:EE_|JH0PR04MB7057:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eb7d7cd-c6e2-453a-bd6b-08de7353cd53
X-MS-Exchange-SLBlob-MailProps:
	vuaKsetfIZmcv7cN2CQdJd4XVKwegu/4uZqsT57xel+0AS8sysXPzYPqG2zwoydNJm/VzRnerYAC7TIxnfmG8CmHnWdpn1xoOmrEx57BJK3qxUo2ZizfmUZCMo1riTmvF7EbkmRZHwPgF/Fdov9RdTII2yJKlZxt4NY0xo0idf0FcAPGaicduaTWkvn1kgt3xDTLWCjbQ0C/+3aay/G/l1tZYpVrwggXhxKvdu0NZGQt14oC0wGHx7jscpp2krkLDaRMNpngyaWT9fNSucGakENuX6r/wg3t8aFXPLSVWCGc87+zkP43yzn/AYQ0iBvuPV1MGLiiToaLq/Y1A8b2qfKXi3oulM7QaS8yapLMcNGXicPX4eSptumhBfEYUqA6XpowAXlAiETZHVZMOkkteQiMHrAOvFN/a5GCFUSpzWIdMW1asVmqpOHS98xQD/kllK4OE8F9HA3CDHvJ/ZubEGPhlqKZDFkKv/kvYCeOaba3V8aeUgFg7Db+XC8pCwqDuax9YB9U6yhpdNUgEuqHfAE5+79YTt0oMwjYUcE1OeksxvItAyLy7SKEsR6vLh3gJ6eE+PheZX7n+/IOi30DibsdXcm6EbijWiVUQQ8/b7jWqyosYZh/LUFLgoJ/qX9SXh6fKyUGvOIfTSpp1qN3q7co1b2bqdTkhCpq0N3jQ6lvDVlNjUvzVRQgWz/Aj2aOcI1mJGfmYGrg+3w6mt347IVWbyAmYWERAcPKv3D2+UIfVx1m9Q/PIdmRV7FdWTqQsQPka6K97fmJPX6aEfY5clavkKLRqQipVUD9Q+ycPtuuWKoqkaiNqRv7DVVakvLk
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|23021999003|19110799012|7042599007|5072599009|51005399006|15080799012|6090799003|461199028|8060799015|41001999006|3412199025|440099028|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWw4c3BIcGxqRGlFeFgzalVWT0RzSkw0T1RmQnZwYjBqeTNSdHIrWTYzdFU3?=
 =?utf-8?B?c0c0eERxYUJQZFBaVGIra3pUVGoyYjVxdG9UQmhDN2VqNmxyNXNGYkdyT3dt?=
 =?utf-8?B?dCtockNlaDExOVRibEorRUhobkFGNDJ3Qjc5THBzQklOemovYytKSWlMVjkv?=
 =?utf-8?B?Um0zTkx1dHQ5UXkrQzZGY3hJc2x5R3I4QVBWUytCREE3ZkovRmxCTmpkOXVX?=
 =?utf-8?B?aHpDSFozNGVzLy9NQTQrbHMyUUpMZzFVYUdDS3FYTEhNQjZObWJsMjFVdzZY?=
 =?utf-8?B?NXFSOXNjK2thK2piSHN1UFFTOWxrNXUzK043MGpDY0NTQWxoZ3p4a1EvZ0E3?=
 =?utf-8?B?SWI5cjFQT2xMMG83a1ZTWVV6Yzlpclphd3RDNE51V2p3d3pnNTdQV2JoREhG?=
 =?utf-8?B?WEY1L1hkeXBHaXJpMFo0cTJycFVQbCs5TnZWSVpkTjhjMkVSWGkvZGNMZFUy?=
 =?utf-8?B?TjNMU0l2RURGYytZS2wvTEMrMVVBRll2bjVFQmdTcUt3d3dGdmxNdHFEYzNx?=
 =?utf-8?B?NEEzMWVkS0RsTHM0WEZJRXp1d2I0cEFKTGJsRU5YcUEraGhrM3ZGZlpTQnJS?=
 =?utf-8?B?cmhtMldVNzYrbForVmRtTnNSeEQweWF0Sk16Sk50cU1FTHY1aDVKYUhQU2pQ?=
 =?utf-8?B?QUdzYjJ1M0dBWi9iSTBldml0T1o5WkZ3eXhyWUtHbkNLNUxOTTFxMjV1V0Zu?=
 =?utf-8?B?TXNXY1ZMay9Pc2QwK0doTUpDSkZrdGF4LzZXMVUvaytJZExibENFTklIeVph?=
 =?utf-8?B?bTYrT1kxZXBtMC9jOWpjV1B5OEJhTzFnK1NpOWdhYk9ZbVJhbnZxZ1E0YTA0?=
 =?utf-8?B?dncrYUVlQXY3MURBUyt3K0xHL0FuWEZocThyZ2lPVzBDUG9jQmtnM2ZXQWh6?=
 =?utf-8?B?WFZxdGgrY0FrVlpnOXphT3UzNlpWMXdNWWRCNDlMN2N0OVI0a2xhclJNZ0VF?=
 =?utf-8?B?MWx5ZVRzTmFQbFhMNTJ0UHdBN0tTLzZZbnRjdkFUR3VJM1ROcTJBRFFHRDJi?=
 =?utf-8?B?cEtnQlRRTGt4aGJCWGdqVktGeHJnVkh5R0xPOHpRSkpLSVVJVHNONmJySk5n?=
 =?utf-8?B?M2JhdUpvSTZjNS83cm9xVUV5djZxN0Mzd2NuYzhVTUdWeGozeWI3VnZvZFRX?=
 =?utf-8?B?VFBPU3plZFhISk9GNG1lcGI4RU1zak1Hb3dPd251V1E0WlVwYkUxVER2Z1RB?=
 =?utf-8?B?LzM0cHFHS3BySUNvL0x2cTJhR0NqV1g1Y0R2a1YzajhJajZiQ25LN2dzTkZY?=
 =?utf-8?B?SHdocWFnZldGaUpUcmNJT0lTYVpyQ1BCWENTc0RnZTFveHczNXpzakRXdVFk?=
 =?utf-8?B?czdmdkk4QmNGSCtJd1F0T2V0QWRmOUpVNmlsem9YbDYzbXlSUnplL29ZbVhl?=
 =?utf-8?B?eDRCM1ZLYndwaHNWSTFQdjFNMFdyZ2NyOFUvSmJ0VExpVHlwanN0OVVsd2FE?=
 =?utf-8?B?Mm4xR2RkSXFOMEpaa01lVXRmMjVJdlpDMVI3QWZRM0R3cmhIaG0yTDI2ZnZR?=
 =?utf-8?B?OW1xVm9CcWZKa0doanh0emRleXFtVitkWW9PcjhRWG9ZZ2RhYUxvTXpvbDRa?=
 =?utf-8?B?Sll1TFc5NDI2N3hXU3J0VmdHSXlFb0RjZ0NHanFSQkl2dWdiSUIydmZhZWJW?=
 =?utf-8?B?bEpGc2pNeGoySkVhUTRpUHdYTmJsMkV5KzJJSytWWi95dFN4QWZ5MEdmdjl2?=
 =?utf-8?B?eFpMa3ZhcG5Xdi9zeTMvaUJXNnJycXRKUVM4UkNSSlYwYzcrRUNTUEJRPT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTJEVmM4NDUzZW1TQTNoZElZdjVsdU81aE5QTEpEVjZYNWlRZldZZ1ZEVWtj?=
 =?utf-8?B?NEZFcW1JaWdidFFEYmVqNVk2a1lIRTM0VnBYMlRTYXMzYnFQYStkUXd0TWtl?=
 =?utf-8?B?aG04QkI4TkM5MCsxYythb3lsNk1WWENaalhGYWZ1YXpZRHdLMXYvaEVPVUtr?=
 =?utf-8?B?N1JXUEVRWTRsaGJHVDhsMDE4UUd0V2tJRExnVjRybXlSVTFWUFZSZEpyVEZE?=
 =?utf-8?B?VkF0TXNSYmp3U0QyRHlwcG1PaVpscmQrR0FvTkRpRW1aMWcxcnNaMWZxT01v?=
 =?utf-8?B?STRybnIxc1lXcHR0OEJ0bTBrYVpySXFKWWpMRkphdmVoY2NlcmNEMUorV2pL?=
 =?utf-8?B?ZGh6TkpxRHZoamNnMVNZV1VtNUtVK1FtZnZ2RTlVT0pubU1yNkFrVzUveHVM?=
 =?utf-8?B?cHFaWkdQcW03cnVYaTczYUtnd202WlpWaGRCV1JjQXdQWUYwbXZ0RGxTSmhm?=
 =?utf-8?B?U1pjR2FGalJoRE44Nmc2QUFrc1BkbW5EWUQvM1kwQzhlNi9RSG1tTUs4WWo4?=
 =?utf-8?B?b3ppM3hWK3hoazdFODNNOGZLU1I0Z3N2dkZOV2d0YXFFeVVmWmpsenM2WWIy?=
 =?utf-8?B?Nys0ZjRkd3oyTTNnQ3A5aWdIOUhDM01QM3MweUdrZCtlOFZVeDA0TGZweW0v?=
 =?utf-8?B?bDUyMCtwMzZtNExFcWZzOWIrMzRDT3ZrZGdqZzMvQmJuMHo1TzFET3NQSkNE?=
 =?utf-8?B?cTZSWUZzSEtHQjQwRzNrNE5FanJFanVSZ1QzRUlBTHQydHA0VFZobkNlWmpR?=
 =?utf-8?B?OUtmZEIvQmNEZy9lRDNIWkpUcWwzQXMxS0xsUFhtWU5PbGhRRVB0QXZodEpI?=
 =?utf-8?B?ZG55RUlEOTBhOGh2T2YwVjBWaGc0bE1XdXRzVUY4VmxDSVVkMklkeFdyeEVa?=
 =?utf-8?B?TU1uU3p1c2czTDJwb0N2Rlc5VVhWVWVVT3E5NDJpdXMzRytjYjdkeDlLZCtS?=
 =?utf-8?B?M0o0ekQ3S0JybW1XRGRRb1BSeDJXNzI0OXM3WlBaYjVxcVphUjYwdUFCcUxX?=
 =?utf-8?B?cVBXZk9jNWo4V3c1dzRRZTYwb3k5WjloMWlLd0pud1lKSm05Q2NwaWY3QmxM?=
 =?utf-8?B?bzlYSjdPdk5CelJTTG5SRG9rcnkrYzhncmR2alNRTGhKbVFiS3hGbmE0b0pq?=
 =?utf-8?B?WUtEWDdqNU5xcEc0L3ErZzhvQjFXYWtrMWJSYUtCZk1oS0hSTGw3Z1lrYkdj?=
 =?utf-8?B?WmlLblIzTHhxQ3hTaFdHeFhIUFRvbExuS0FTNDJWcmtkR09NWmIyTi9laFlU?=
 =?utf-8?B?aWZnUVV6NFcyZmpCRDE3K3d0ci9jdlB4SVVGamdJYWVTSHFHN29uQUJJUUY2?=
 =?utf-8?B?Rm0yallvMjQ5YU01NXNjbjJkdmVYUGZHWENlcVk5bGhtVWFGMjlrK3hHSGFP?=
 =?utf-8?B?akpHUTZoVTJRdGphcGNtWkFXRVpxVjFGazZza2tHRGR5VTNZTFJlbmV1NlBC?=
 =?utf-8?B?eVd2Q3hIR3JncHIzR1hRQVVpdGxvQXcrZ2c2eGVPdkFXM29wU0lCbjVTV0N4?=
 =?utf-8?B?Zjk1TjJ0T3dnS2gvTkdYODl3NWRvV014OTdBYjZyclo1bDFOYmRtTStBOGxC?=
 =?utf-8?B?NjNTWlhUWVB5L0hRSUdmWU1kcU9TQVZvNnFJYW5QTGhzd2xzdGNsNWlBdFI5?=
 =?utf-8?B?eVFIMFc2QXVHTzRJYng1bTF3blBhcjlpZEQ2b2lZRDhXVDNWWHRKRlZUZHFT?=
 =?utf-8?B?SjFaMjA5cjlTbGE1L0JOMW5iUFZJZ0oySmU5UzRRVG4zVXBTUUNDQms1RStO?=
 =?utf-8?B?aThXTVVzcll6OGxhN3hBSGNaYzczeXhrWmJPb0F2bkFuSzZmMjQ4L2JwUFJV?=
 =?utf-8?B?ZFRnWUpWamNaVEJwb2FWL2ZQS2M2VUdFcGR5T0ZCekRtRmJvazBiRzFEeTll?=
 =?utf-8?Q?MTIFB3kPNYev3?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-515b2.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb7d7cd-c6e2-453a-bd6b-08de7353cd53
X-MS-Exchange-CrossTenant-AuthSource: SE3PR04MB8922.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 03:21:30.2517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: JH0PR04MB7057
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[hotmail.com,none];
	R_DKIM_ALLOW(-0.20)[hotmail.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71579-lists,kvm=lfdr.de];
	FORGED_MUA_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_FROM(0.00)[hotmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nutty.liu@hotmail.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[ghiti.fr,eecs.berkeley.edu,dabbelt.com,sifive.com,linux.dev,brainfault.org,gmail.com];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DKIM_TRACE(0.00)[hotmail.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,iscas.ac.cn:email]
X-Rspamd-Queue-Id: BA69B1815CA
X-Rspamd-Action: no action


On 1/30/2026 6:15 PM, Jiakai Xu wrote:
> kvm_riscv_vcpu_aia_rmw_topei() assumes that the per-vCPU IMSIC state has
> been initialized once AIA is reported as available and initialized at
> the VM level. This assumption does not always hold.
>
> Under fuzzed ioctl sequences, a guest may access the IMSIC TOPEI CSR
> before the vCPU IMSIC state is set up. In this case,
> vcpu->arch.aia_context.imsic_state is still NULL, and the TOPEI RMW path
> dereferences it unconditionally, leading to a host kernel crash.
>
> The crash manifests as:
>    Unable to handle kernel paging request at virtual address
>    dfffffff0000000e
>    ...
>    kvm_riscv_vcpu_aia_imsic_rmw arch/riscv/kvm/aia_imsic.c:909
>    kvm_riscv_vcpu_aia_rmw_topei arch/riscv/kvm/aia.c:231
>    csr_insn arch/riscv/kvm/vcpu_insn.c:208
>    system_opcode_insn arch/riscv/kvm/vcpu_insn.c:281
>    kvm_riscv_vcpu_virtual_insn arch/riscv/kvm/vcpu_insn.c:355
>    kvm_riscv_vcpu_exit arch/riscv/kvm/vcpu_exit.c:230
>    kvm_arch_vcpu_ioctl_run arch/riscv/kvm/vcpu.c:1008
>    ...
>
> Fix this by explicitly checking whether the vCPU IMSIC state has been
> initialized before handling TOPEI CSR accesses. If not, forward the CSR
> emulation to user space.
>
> Fixes: 2f4d58f7635ae ("RISC-V: KVM: Virtualize per-HART AIA CSRs")
> Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> ---
>   arch/riscv/kvm/aia.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/arch/riscv/kvm/aia.c b/arch/riscv/kvm/aia.c
> index dad3181856600..c176b960d8a40 100644
> --- a/arch/riscv/kvm/aia.c
> +++ b/arch/riscv/kvm/aia.c
> @@ -228,6 +228,10 @@ int kvm_riscv_vcpu_aia_rmw_topei(struct kvm_vcpu *vcpu,
>   	if (!kvm_riscv_aia_initialized(vcpu->kvm))
>   		return KVM_INSN_EXIT_TO_USER_SPACE;
>   
> +	/* If IMSIC vCPU state not initialized then forward to user space */
> +	if (!vcpu->arch.aia_context.imsic_state)
> +		return KVM_INSN_EXIT_TO_USER_SPACE;
> +
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty
>   	return kvm_riscv_vcpu_aia_imsic_rmw(vcpu, KVM_RISCV_AIA_IMSIC_TOPEI,
>   					    val, new_val, wr_mask);
>   }

