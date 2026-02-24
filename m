Return-Path: <kvm+bounces-71584-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMmJF/lAnWnhNwQAu9opvQ
	(envelope-from <kvm+bounces-71584-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 07:11:05 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BD6A91824F5
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 07:11:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0EAF830733AA
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 06:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CEDE2D23A4;
	Tue, 24 Feb 2026 06:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="ieMfyIEj"
X-Original-To: kvm@vger.kernel.org
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013075.outbound.protection.outlook.com [52.103.74.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8B22356BE;
	Tue, 24 Feb 2026 06:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771913452; cv=fail; b=R+wCA/D0l3pSgOD+nkKLzVJbAuc7LEKygn3+3qChQH9o1wJ3CFVgHBFQkSNXEsInomyblMBDXvorH2HEj+gVbKKsaD7GTC7BhbXw7XW6NLjo8gEBevKFHGevBIFZJiR2g93s4c/iAOpo82aodUj4Nn8wjL5HvL/UbuZ1t2TTlwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771913452; c=relaxed/simple;
	bh=sQFOF4zLxJznzcHzi/2OQIAgEBhZfZXurg6LGEIpnws=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qex0JNUDlOlQLMOVlqbb3q4Uo9OalOXty+DInDNguat80T8epF2ZU44OTcY0HFezscf1oiO2lrWzGdfTDfqq0sed4z1pNKHroqOZYd4+TuoYAV8/OxY++Ra6p/0Q3JH43QKKDl7vRTCK/277vLr7WfiTotu84wqJBbOGvU6TuDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=ieMfyIEj; arc=fail smtp.client-ip=52.103.74.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xtZrGRi6Wg5sjEvCg/pPTBCRzaE/VuvXKkxrciI3NEywlN9PnXr06EQb1t+9xSzWnz+qk+82n2Se2bqf1HGjP/gBlyWr8WgrKsFfUVvzOgossr6Z3iT+Kk1OU3VXaJAg71lvtvjgr7KcFw12sTLqF1aUp8WDuSwi64kffIn2GVOat9dw20GnVHiAWlSwbZbGCTI2r6iz0V3rgxA16yt++Yf2GzRullH7R5ywuOL1stCl46ZSI/+J5axS9l+ASshbNzbllWtZsx6CSi6p36ugx577HwMXOk6ketnlPIyb7PuxnvySBofs67bAOYrPuLdPmPZI2qY8wY9MQZ/Zzk1gMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RWMllDdPxd74lW9sWQapNlk+fh7k7s8Fpb5hAM9eLX8=;
 b=qce9d8H1HNXgoT8iY/xSyQRj4azUPEpl80fbMTYcywPwmcZak2b5P2RXkVvl8zUusTLHuuZ4dT4Vq1+HnqIIberkCc/K3evMGA2g4t5D6NPVFEG/cJ36dV9/E62ccW5av44+poo+MlH+eAi43+0dKzoYSYMo1KZCx7l5FjGaS2eFvMA2d28Vto6FYlIiW4HAlQvsNrq+HfGKQB5mfP9xeQbxi9k5LsaM/spIQbZXYGxEW8bONMKKPFZri6iXeS6M400zCJpfZrVh0dDvNPGq2d6V8OHSSB2XjyAXdj625qwQ+YCxBUmC6H76CP/l7WpBwoph7QMsfUFdeXH4CH/EIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RWMllDdPxd74lW9sWQapNlk+fh7k7s8Fpb5hAM9eLX8=;
 b=ieMfyIEjig3IJkzyPbTT/gFly7fzGw76YjesxKqbTE2qbGBhD50NT7pi70oUUSO4FN0MVN+cqzRiZ0PtTKG0TUxw3T1rGZndgjtz5oN1tLnZ60rNdLrMQ49P4u2gGk0SFDI8ow2hLd9Fqj2VwYz0QqVXIPB6bXmLEcSlnAcaOWwHhsxH9JlFwAz310hXRTmEA7PF64DztbWz2zACa/Bp0j3+ETyXLleDWZ+EDNwBO02Pu78k+069xzbT+1CgCf54zXp3ZX/DtbTACFfXyJePcBGF89dmy0NJhCkYPwUBviW/2G0489XkoHBLQXWqYec7hzyr0+lmyn7utzCOTfXH7w==
Received: from SE3PR04MB8922.apcprd04.prod.outlook.com (2603:1096:101:2e9::7)
 by TYUPR04MB6744.apcprd04.prod.outlook.com (2603:1096:400:35c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Tue, 24 Feb
 2026 06:10:46 +0000
Received: from SE3PR04MB8922.apcprd04.prod.outlook.com
 ([fe80::3450:f139:5238:8f58]) by SE3PR04MB8922.apcprd04.prod.outlook.com
 ([fe80::3450:f139:5238:8f58%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 06:10:44 +0000
Message-ID:
 <SE3PR04MB89220D1890E549CDB1222974F374A@SE3PR04MB8922.apcprd04.prod.outlook.com>
Date: Tue, 24 Feb 2026 14:10:38 +0800
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
X-ClientProxiedBy: SG2PR02CA0125.apcprd02.prod.outlook.com
 (2603:1096:4:188::13) To SE3PR04MB8922.apcprd04.prod.outlook.com
 (2603:1096:101:2e9::7)
X-Microsoft-Original-Message-ID:
 <fd40a4a6-47a1-422b-9cdd-d539f69ad9f8@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SE3PR04MB8922:EE_|TYUPR04MB6744:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a451fd0-ed00-494d-2553-08de736b7114
X-MS-Exchange-SLBlob-MailProps:
	vuaKsetfIZmcv7cN2CQdJd4XVKwegu/4uZqsT57xel8AYRw3XRvKlkJfqee46CrBgDT0pg/+Xj+eTH2Xhe2Ela/eRi+g8MLf4PndbkXA6DVne3eS8oi9mh3fZMyCjWtp8tIHZKYfl617WW+jH+hV7cyxIBCzVnfE88Bfb+nMYg+4crsgi0CrWC5HwOCGBbOpaRmP863LakmauFzPLQMgBSsPf59O0491j5PjfDB5aIjF8tP41VFJlcFJpSv7P2dN1B4dRY4C7HyTYOW7xi/IuoQXj8PUeCoyumbSniHxn1n8//6i1HFD9NuN6oOE9WgKAgpWhQ3LKvzYArZRB46o2NSLObtQVhocJQYFrASfINbWxPnHF1zlE89uwKnfxsCbWZludojwMoKrmwofF5Jj2WZq6tpGgARZhyf9FcUTHjLz2GF6gaOBBZZ8khtkL+Q+mbp9ghMvO1DSYdZ8S+Ng4xR1ORF56jZn4mUhrhW6OhqfoM1qi8xvJp4rqWN0m3jtW6mU2AYVEqsS9Rl6N2tsGI/Cz+i2JGrKOC5Oqo8daCWEwC0eoMr53ACJ/VrD6rXiCKi1YY8E6v8Z7TzdNVHOdO+m/6nn1gAqBnYmtcSAnR2x2nPDI8JV0/f6hhGRhWqLXYo4bpQsvCO+T6dkBgYkb8sxK3xRkx4RJbgpqNTQwnUN6I/iKOO0cFeKT711gRs6D7zptRP/s7SKV1s5o1ypAGewUTBzlsMJM0dLfYdmwJ1v1xofBsPz96oTgocNP0E1R79bEyh/tzPJurXueA5y5FdlRDiprBwHpnCdmFsYrD90rlDkzdbkpPDzteFMc930
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|23021999003|7042599007|15080799012|6090799003|461199028|51005399006|5072599009|8060799015|41001999006|19110799012|3412199025|440099028|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cmczazFaTWgzVVQ3bXVRVDdQenNMSzlXQUE0VmhoaDFaYVgvZmdjZ0tBaVp1?=
 =?utf-8?B?RVQxdW9iMitUOGZJTG1IRHhxVHUvSEgxZ1BHemp6dGRlQ3dKZUFQMDZJZ0Zq?=
 =?utf-8?B?Q2tHWFp6c3dmaTlmWXBRd1NRaXdpZko5WUxDSTMvT29kNWtXbTlVRG9HZ2JW?=
 =?utf-8?B?eEo1TUxNMVFBZmJicjJtYTJqRUNJZHRPMllrblMreHp3R25tN0QxUm15Tzcv?=
 =?utf-8?B?Zko0bkV5Mys1L0V5VkVBRFlmbGtnMk1pSGJmc1Zsck4vQ3U0VGtvRjJCSkdV?=
 =?utf-8?B?WUM0ZVVGQlhzS3lGSkVDWGw5UW9CZXU1USs5NWY1MXFVNFZneFNZQi9vWFM4?=
 =?utf-8?B?VGcwV1JLMWhjd2RyWm5WNEsvTTlYV2pva0k0MW1CVTJKUERoY2lBamxCU2Q3?=
 =?utf-8?B?M2lFVExsWTVLVW9FQ1VlcEIzNGtHamFsQlQvRVpSaGdmVXB6ZWU4dnQzNVRS?=
 =?utf-8?B?a1BZTWNPc2dCSmtDZWZaeS9UWi9FRWRZZ1JxMnpuemhtcVAzWExqQ1JLektD?=
 =?utf-8?B?bGduNkh4K0s5Y0srS2hrUmduZWN0NFRuTTMrKzFkb21zb01idUV1VXprSUR4?=
 =?utf-8?B?S3g0WlVSZ2tpZVRteGxiVTlzOFdIb0lITVZud1ZWQ3ptOFQ5YWQrRUg1aTV0?=
 =?utf-8?B?LzRHV0kyV1RCN1kydVdUK2dBUTU1UmpiK0RHNUgySUVuMWg1cG9EUHQyRS9k?=
 =?utf-8?B?UXNqVzdTbHI5ZzZFRmtveFF0MUNoeWNSL3A5eEg0L3NiK3lFRjlIVGE5UzVT?=
 =?utf-8?B?amtwcWNyaTBua0tIRWM4SjNVVUNUNVpwU0NlTVltVmNuZlZJaUQ4a3BhWGNX?=
 =?utf-8?B?ZVZOOXJwVnJ2TVpGRkhpbEdybjNyZ3JOU2tYaVJiaGh4b0JqYUd5V0tjb0dx?=
 =?utf-8?B?eG1XNXpmaHVNaUUvaEVMaXFFcm1xWHUwR0ppRGxKdHJQQWNXYzd1OEV6UWts?=
 =?utf-8?B?b3lQelc1THVwMkhqbWV3eXRTeVI1VC9LVHFUR3VuSUgyMFUxdkM0eXBlR2lx?=
 =?utf-8?B?ZGwxTWxraEdFWjQzTTI4TXJBSHU0ZVJacEV0dHo4dkVRcGE3WjdWWlpOVDFP?=
 =?utf-8?B?NDg2R1orNUxwNkpNdG8yMGZkbnhmQzhnSjRoRTRCQUlrbGQyZEpaYk5SSFpG?=
 =?utf-8?B?TVJ5eFZyV2hmcXh2bXo0a05aMmpVZURVNGYvVk5BVUxrbldCR2JhMWtURU96?=
 =?utf-8?B?dEhldCtJdDZRZkhWUXRHbjdZaGdxWGZWQWtPZFYwUmUzbXZybnBTOUdsTXhy?=
 =?utf-8?B?dVBxblFGd093UzhKcExWK2lQbHgyQVhiY1RZSHdDL2tzcDNkalVuOHVLSHk0?=
 =?utf-8?B?MzdpWDVESkZkd0wzN2FFd0crcFlFU2EzVmxQaCt5MGFEbkxBemZ2bjM5T1hj?=
 =?utf-8?B?U2NDWjgra1ZvSTZua1BTTzgrNi84TllhRTNaV05PWElpNHpCMnRLUEhYaEps?=
 =?utf-8?B?bXQyR0FpK0dCSHlCUXlXaXBjSnBTMGg3R0NnRjZ6K0MzWmxlc09iZm9iWFJv?=
 =?utf-8?B?eGMzMjZsbnhTYTZLWTY4ZFVWczl5OVhidEZUR1M3cU5XTXU0cStVWjh5dkla?=
 =?utf-8?B?RG9QWUhQbjYxYVQzSU5XZDBqYU5oMzE1dXVTazdXTmVCSnBGSndFL1JKU1F2?=
 =?utf-8?B?Snk3c1M5cHFhbUxtTDZrU1lhTFdmRzQxV0szdDBzTGlSeU1zUHo4YklHUmVE?=
 =?utf-8?B?c0J5RklLZ01xU1htQURHMnJKOWg5cStNcmtjcWdQdXRqTnVVUEtPS2dnPT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWRCcXY1WTlBa3BmVTRtTzNGUmdFdExsL2ZLemhQaHY3TkNvc3FZSDdNVkFz?=
 =?utf-8?B?clMzbjkvQjVYd0hVYnllSFp1VG92V3NqMkgwWmQzVDBQYWNNeWJldTlxUTU3?=
 =?utf-8?B?bnJ5eHNLcjVyVVMxWFRlZmFUK1F6ZnBZaXBMcXFmc1BDSFFnQnRjN2E2TUp5?=
 =?utf-8?B?aEZGSi9pdmJQdm96QjV6QkVTREFRaXNpbWF3TEVDT25IWDN3M2p5MkNHdFRV?=
 =?utf-8?B?ZW5jbStzcitVMXRsMTFVcDY2Sm9sbEFIcUMwUHJCenFmaDJSYUdaSTVYTUVO?=
 =?utf-8?B?ZGh2RWx2d0NIMmRwL0M2ZElEdXdBdEZjdGVGYnlDN0lqTlRGMlpRaWlZV1hq?=
 =?utf-8?B?WXh6VXNWbURJWFM2OXFVcG5GcTZtbkN2SEw5bkNmRVRTL1VYNkxkYWVoMTJL?=
 =?utf-8?B?YmtVVmRHb2x5ZWkxK3VndzVwRnpiVk12bVdVeEs4SVllRzVLT01lQW4rTHJy?=
 =?utf-8?B?Q2tybStjdFZLV3hraTNkeWVGSk5ENHpyZlE5MTE4WU4xTDZVWUNyMVdOaUhR?=
 =?utf-8?B?cGsveUx2YndnMnhEU2lYZFptczRXZVdBWWZyTjFCSWtrKzVaS0h4UEVsaUI5?=
 =?utf-8?B?WHkyM2JWeG5mbmt6Zm5iRTNtamtMcExScUE0OEhXMVJvYjN6K2UyQmpkZ05P?=
 =?utf-8?B?dTdjZ1RKTDh0WHRtVVdYNFNiWFUwUWVTTDh5Nm9ZWG9EdkNKSHVlbjlnamo4?=
 =?utf-8?B?VEo3cHFCQTRzNmFCUTNQNCt4azJGYWZGR2FnN3JTT0FSeWozUGNYYlVjMTBY?=
 =?utf-8?B?eDQwNmR6aUx3am5LM251bTNDbXVNSlpxcnlRYUg0aVphd2NnQnpqaElEdG85?=
 =?utf-8?B?WHdJRW5PNXRVQUJ3Ly9qNHJPaWhSUUg1Y0VUUkxEeXVyT01IRHhqM1YwdU81?=
 =?utf-8?B?dUtiV2Qxc3Y4c2dDS1RwUlFMZkF2eXMxMTdwNjJEMWdhQTJwME41SlJraGZI?=
 =?utf-8?B?QTdFMUxNSklnSGJrM0VqRDVTb0dhZjNIU015YURYNitZbFdqcUxQU0l1VlFx?=
 =?utf-8?B?OG9XdkJiYlFxUUR1Q0xzS2FDdUE3R2tCbEJOT3VJRTN6dVd3UnZzbFhHRHZv?=
 =?utf-8?B?M0JFdUpUVWlQQ3lmLzB5Z3F0WHVRbjVXRkFjVWx4RXoyTkhwekZiNWJiSHo4?=
 =?utf-8?B?Mm5pT0lld2tOSEYrS2xnbmhrNStYWHhBdjRyOHRETTRNMjZyc2JMenl5Yndp?=
 =?utf-8?B?dStTMXFoczgvcGJvazF4WXlJVHdYa1VnK1RlRTZselBQZ3RFUys1UEtSM3VZ?=
 =?utf-8?B?RFkvWEo1SjV2bFk3WTZPdVMwTHliYXphUEZ1ck9aWE1OV2Y4eEQxUlN0K1hq?=
 =?utf-8?B?U3RONzd4OXIwa01wTzU3TXlQb292WWgybm9ZOUE3WjFJTUNSY0tDVE0wU3VR?=
 =?utf-8?B?YW5MOWNZdGIwNlVZWWRrKzJJTUdsWFFLWjdwdks4U1dNdzBsaUVBd2Ezb0RC?=
 =?utf-8?B?Vi9tdHF3cHg4Q3lpS0tFei8wempmb1ZBWGRHamszZXJzZjR6aHYveWVyT3Yy?=
 =?utf-8?B?dGdKY2xNSVNvRzJldWw2cStXRTFUS3MrNnYwOUxaNXpQc1V4SzBHN2s0MFlC?=
 =?utf-8?B?N2x1N3FZaTVjOFpNcnp3djNnbStTeTdQZW9RSG1jV1pkNG5YQ1ZYRXlQcHhw?=
 =?utf-8?B?b2xjZTU3WnIzL0F0VThMd1NRNm1QL2M2UHovbk9jV3RVVHRWaU1mWE5WZDM0?=
 =?utf-8?B?N2gwR052VjFobGhWdEJKSWV0QzJjREVzYjMrWlVsZW44anNGNWtNMXY3eitO?=
 =?utf-8?B?aUZ2R2NqeUV5S0dXMHVlT3dab2JhNHRneGJQdFRqdmw4cUxyK2VtM2ZEaHo3?=
 =?utf-8?B?MFFMT1FiL2U5bmw4bE5ack9qSUprRlcvUjZZcUhWaXMwTmJYSWo1M0lQZE1k?=
 =?utf-8?Q?3tQrS0iaA3/t+?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-515b2.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a451fd0-ed00-494d-2553-08de736b7114
X-MS-Exchange-CrossTenant-AuthSource: SE3PR04MB8922.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 06:10:44.8616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYUPR04MB6744
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[hotmail.com,none];
	R_DKIM_ALLOW(-0.20)[hotmail.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71584-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DKIM_TRACE(0.00)[hotmail.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BD6A91824F5
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

