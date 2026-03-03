Return-Path: <kvm+bounces-72492-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SM09Fh1SpmkbOAAAu9opvQ
	(envelope-from <kvm+bounces-72492-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 04:14:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CEA601E85E0
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 04:14:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 61C5030532A6
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 03:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8918937DE92;
	Tue,  3 Mar 2026 03:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="RNiZv6pP"
X-Original-To: kvm@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012061.outbound.protection.outlook.com [52.103.43.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5550E37CD37;
	Tue,  3 Mar 2026 03:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772507642; cv=fail; b=s/csDcOggO0xWnXx/ngns73GhVj+pBDq4N+vloj9/k7kxpG1cwlHfpcwfItZEigga2oJFG62FsD47hugtq1ht7lHX/q2XKnvlok8CNEA9fDWoc4yRHwpvFRKHuL93kz8Xt3jrSdWQyWL24rec95UFoIEu7YkKzHp6NzXDCHkh1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772507642; c=relaxed/simple;
	bh=9KZUsebXBbLmoZuq738NpRgkcHpNnHP6yqNTIZ9NSyw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uk0yzVBvA/Jokhpmd/VZJa0dKeE4jbAXGmxlMogwIFzND62HzwRsSaylHw/EBz6HF1KcS4bexXVNwH3JBT6RiDcBS6Dz98tv3Q99y3IVGazf422B3lF9kwh24A80KowW5RdJNtYh6lNZGb0m+VtG6odaFSdbunZvsvqivuc1b0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=RNiZv6pP; arc=fail smtp.client-ip=52.103.43.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GtZ0YY5zn3d/uOLwQUg4iOLC/UnEE6ERpmC21wZlAsb933DHn0Ar/F8JwkdZtSv5AmzLAirwk6k0j+X6gE3CohFNxLWmglepeQUt22N+DcwUHCTJR7fnCueq6piGnAxRbjwrIqhsybK2yGrSbVzQk7EPqt0I6BG/NZnsJVb1/p7iccGZJdrhUY6mo7GRVmwstzK6XEvX3DBHwTIlQ7Eg4IvPzJFAixTKrD7qLcQRk+GhYpfTNr2uZ6Riucbg3VrPKXQhlqsfWL4x8HyftV/zU/Eiv3hAOJhJvM44jzXkbSALyR43Jheh19HhJKhL0DYlY82FILVc33cPG5fnZNetAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z7z6gldFoDPqXep6CI3CRw3HqWNMcQjvha6YzD+yjQ4=;
 b=hmq2ossX2BruiCHzkfOE9LxpmacUolutBheewGvWlFfwYaGMZNvRkivBSqHNfhDhWj6Zd9vy//+36eSplp8Q9wE8h+3h2CN6ke8q3YWzIG4v68sWnPgnhlLdZhz4msVujAj/82NzMVOSXAcYDli+2vdTm0zPOVVQCwfQhsWSXrAHAIUDMusDxoQC9Oixak+YlHpbD4Rnon+aDc4iI3N0kPtWc1AXu5f2QetmnkV1WyGs0FME6sk2UWRJa7eym3mafDEQf9fQGGqIcD93IYxqDsVDUte+nPLlFBqJu7xG+ERu8uRWd1FBQqnwFZAHdKhGj/qtM07gSfuRUnGXr3yElQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z7z6gldFoDPqXep6CI3CRw3HqWNMcQjvha6YzD+yjQ4=;
 b=RNiZv6pPqeweFTCwqF1a5mVhPH4pg4GM4ceYs0lNfCE3IiDl6UMrQEgqwSgZzereuF2qlHx9zWo+nacLX1rvt4DfO2IBDcGjbEHQ5f6NM0KOAS7ZYkSZ+Yt5maoRWpm8FRlBLCQ9CfSGKxqNoZVEAKDSmFnQ1UUTJ5KCpL6ARNiiRh1ygZUtQfIyvgK3zCHzv4ySkMTtCSD3kz8XE+YT3slpPaRQ84kI2qgWXDNV2Ti0ZqGxW/ZLR7JjPgt4CIWvWeJL0tbjGjiUVgj2H7fDmOsp2aJ76Wi+1JYd0dfggwZIF/u2K5if+fRo1EAoE9k7W+Tp8bc359t81hBuYzBuFg==
Received: from KUZPR04MB8925.apcprd04.prod.outlook.com (2603:1096:d10:46::5)
 by SEZPR04MB7650.apcprd04.prod.outlook.com (2603:1096:101:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Tue, 3 Mar
 2026 03:13:55 +0000
Received: from KUZPR04MB8925.apcprd04.prod.outlook.com
 ([fe80::e3dd:6f77:3be9:b71d]) by KUZPR04MB8925.apcprd04.prod.outlook.com
 ([fe80::e3dd:6f77:3be9:b71d%4]) with mapi id 15.20.9654.020; Tue, 3 Mar 2026
 03:13:55 +0000
Message-ID:
 <KUZPR04MB8925B405C8AB50882EF915ECF37FA@KUZPR04MB8925.apcprd04.prod.outlook.com>
Date: Tue, 3 Mar 2026 11:13:42 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7] KVM: riscv: Skip CSR restore if VCPU is reloaded on
 the same core
To: Jinyu Tang <tjytimi@163.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?=
 <radim.krcmar@oss.qualcomm.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atish.patra@linux.dev>,
 Andrew Jones <andrew.jones@oss.qualcomm.com>,
 Conor Dooley <conor.dooley@microchip.com>,
 Yong-Xuan Wang <yongxuan.wang@sifive.com>, Paul Walmsley <pjw@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20260227121008.442241-1-tjytimi@163.com>
Content-Language: en-US
From: "Nutty.Liu" <nutty.liu@hotmail.com>
In-Reply-To: <20260227121008.442241-1-tjytimi@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TY4P301CA0027.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:405:2b1::9) To KUZPR04MB8925.apcprd04.prod.outlook.com
 (2603:1096:d10:46::5)
X-Microsoft-Original-Message-ID:
 <8973079a-7ea7-4ab5-879d-8852e1a0edff@hotmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KUZPR04MB8925:EE_|SEZPR04MB7650:EE_
X-MS-Office365-Filtering-Correlation-Id: fcf8202a-96e0-445b-8c5e-08de78d2e641
X-MS-Exchange-SLBlob-MailProps:
	ZILSnhm0P3mCsD4RYpiBXP8G60zXrCmR3nXwQaUIaBlNYECgnPqZeGccEPc/LWboYsIHAzfHETXeG5WvYeA5HDP1cDzzt+HwK1fdG5ihHwp8e9wyjY53d5u84t/LhzRvFyylB49/Jn4cQHVjFrYDkUpMdEXe5eHHBEUUiRVRI+nLxqlQMER8iyPH/AcyYr7PzsZN/DBXVpHecKSzfzSbAFZ/DgtHtDntBQonqtXRlfGArb3zVTIbFAmOVZpeezxDNO5IFB4ox1C4eGfa2fGy4E3TtyW5y/jMStQPJkisSKb7qMe6iy6lWsm/9qCyfjue8/H9nR4SJNAIaq7pOd3MGROBldDVw30a1X/U+r9Goay4SZaV576hNOdtHH7lKfdF/fslWgBPtQ56pxmwK68W76SeawwNz9HAujdSRamQ7Cpy5YbSKwtiLXqcZ/nAucZyZM3EJ/kca8X/vSU6vfzhOe1epEM9YOnF9Ij+8+IMqjpAA8S/8BURqIbY1JJ7DQbb3gy6nAdBHjYmIKIts4dVISca2WJzPUDaGl06qst78JfmAoQwcfNrxZOeC6qxtm4V/wLvTy6kkdTldxLXi91I5SmZnMgkDz4JAGVHYpvvMR2BKNmRTt9Qdo3uGvOqE9NEhTFaNjW9XS7QEHICVoQMIBkEj8WAmuvjKzzDOhaETBt50vqmQKMe55Uoc3GbE2TuIrWH5NklYtGHSi+tkJHeWFZM78dxaJfSoz+nnjNtH0mZqlp28XyffOM8Xxve2KeNP0FpkCm8B+6I22mVmFs2u8JDDCbQpaHx
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|12121999013|23021999003|7042599007|8060799015|15080799012|19110799012|51005399006|5072599009|461199028|6090799003|3412199025|440099028|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SW1IUUt6c2cvUXRvMmdaS0FQUDN4ajR6SmtQVVhDd3d4cjJJTTg1N3B1bXVv?=
 =?utf-8?B?aTViNXJWc0pLWXk1YUpYY0JyMmM1cm9weUxHY0tNdDJ3VGVEWU0zcncrZ2VC?=
 =?utf-8?B?UU5ZMm94Nms2SDdGd3B6MUpYVnZKcGIxd2tBSU83SUJ6NytXa3YyL256b0x4?=
 =?utf-8?B?UVZzVEtubzNyempXMUtNR2M5L2hDVi8zT1VmNEk5eXUyaHFTZGNlVnh1dWsx?=
 =?utf-8?B?ZFR1S3BRWHBGQjQxanAvNzk3cGpudDVjQWdXdDZXMG5WR096MVYvOGtjdExE?=
 =?utf-8?B?Tko3RGc2d3AxV05pMVlaeUNrMXBEb2kySWh0aWtzbmJKcWtRWGNVZmNnbUho?=
 =?utf-8?B?NWNDYnRQckdQTjkwcWNWbkgzTDRNc0F6RFRzL1pkQzVJaTVsa3d2Y0c2eVZs?=
 =?utf-8?B?L0R1M2syNThPOUN3WVZ3azdUWTE3MlVnSWFIc25jZURVSXpRQks4TVhaRVRU?=
 =?utf-8?B?dnZpZjlnenBZekJhUEpxb1FFNjA4Yk1tdjQwL29FVUlRN3doR0U5bGdhRnFq?=
 =?utf-8?B?bkpWVlZDb1Z3TTc3bFpMaUxqRGRBUmNITm90ODhEdEVlc3E2L0o4Mml1M1Y4?=
 =?utf-8?B?MHJDamVBWXphek5oZG5KTEl2SnBYL2NhRTRuMVNleUtKbDBBRFRFZnpVdGc1?=
 =?utf-8?B?ZTMzMXpxWDZJbldjUU1HdkwrL1BFOFllRWVlQnpTeXRHc3k0QVkzQkdjZVJh?=
 =?utf-8?B?U1F0a1RTMXl1MGcwRUpRTWpFTU5ZK1h5Sjh1R0tNa3hya3ZVRjMxbkw5V0NJ?=
 =?utf-8?B?dGJseVJZNmt1NEFCZS9MczFEc0tQd3lBSnJJVWpMekJELy9YRDh2U1pzTXc4?=
 =?utf-8?B?RVRLWmhDVk83MzlnRk1yL2llMkxzUFB6alBWNDc0amp4bEZqei9SVSs3Rmg0?=
 =?utf-8?B?YXdZNGllay8xR0lmK2laM1dUTWJaTktNRkpYYmgzR2hnbW8xNkRlbkl4Nm9p?=
 =?utf-8?B?Q1Zia1FFSWFsMnNWM0duSnVKNnhkYkh0UHJ4Nko0MFNtSG81SU1BRDNWbmM3?=
 =?utf-8?B?ZTU5NmIwcEFUSkZjaHpzbG93VzZvelNueStvQ1FITDJNR2tBZjJDRk5xbnli?=
 =?utf-8?B?Ry9KNUl2cmFoSy9JbFk4SVEzS2V3a2hBVk9TWExBcHRGbndwYm95c1dFalJN?=
 =?utf-8?B?dXlJeXk3Y0k2ZHVOZ1BxdWRqaDR6OFVXYU9pK0xOaGRiOW1pcC83eHpYaDdR?=
 =?utf-8?B?VGpFd0VvYktnbGJsL0ZFc1JUbmZ1a0w2R2dXT2xROTRaY1Z6QVlyaVJRT3RZ?=
 =?utf-8?B?VHVBVUlnbHhacGhEczJTREQwU21iTThXczhFRUlVam1rY3NyR09wM2d6TVh0?=
 =?utf-8?Q?VI63/s1c2WwGw=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aU9NcVVSbE5xaDU5OUpEcWpqRVp2cWNtb3UxNGtieVhYaEhVcjZUSlJFVzI5?=
 =?utf-8?B?dGFocDlaQllUNFFuL0tyUG15eEoxbU9PRUt2ZlJkOVJJT1hoWFpLWFY5MjNV?=
 =?utf-8?B?Q1VxSkNEQndHbVRFejlmSzcvSlU3N1hQdHRpL1JQWW1zQ292ZXdhbStsMndG?=
 =?utf-8?B?bjlia2N0dG56SytGQzNROGYyZTVIUDFGSHgxMU1GdEptVEZFR2c4WU1heVY4?=
 =?utf-8?B?RlFtaHY5bTNpVzZTVmJsYXVkK3NtMzNCMndEM1BjVW1nclpndDdFdTVFK0hr?=
 =?utf-8?B?SDU5bjdWRkMwYy8yNnN4K0hkTHRPSEs3Z1BWaTlObTNQWU5nUlJRa3VEV0Zs?=
 =?utf-8?B?WXVHWG9Ed2N2NHNURW1qSXdCSXF6ODVpaENEV3dRbEZDeUlFWm1qaVN4UkhS?=
 =?utf-8?B?QjhmakN1dnZUQlYxOXp4SWxRVTcxcm9zWlNsSGZGUmdkVk1HOUMrNjNEKzgx?=
 =?utf-8?B?M2s3U0w4S29QZlpqcFMxamxOaHo2Rnp6SFpsaXA1RXBHbFBKZ2hhM1h2U1VG?=
 =?utf-8?B?YUFRTElnNHcySkhxQ2NVSDcyTExpZUhqMXFtMkZNeVFQaURKWitFTTdBNDBq?=
 =?utf-8?B?NGJuZXNJWGV3Q1hVTFo5bzVsMklGYkQ3ay9OeENVL3NwMDFxbng4ZUxGTkZQ?=
 =?utf-8?B?VWowS3BDZ0k3K0JGbEpiQnRDc2lpNVpnY3loVks2VEF2VlJEVnliUUc2Sk50?=
 =?utf-8?B?bFkrT2t6aEJaZW15THFjVVRHY29SdHFlRitZMjR1eXpEUVN5dm1JbmQxUmFu?=
 =?utf-8?B?NXVIMEYzQ05uV0o1UHc3OUxycDRpczVXQTcyUk51VXpDbnJyalptVmw5dVhR?=
 =?utf-8?B?ZVFMblVZRHJ4VTl6ZDNjb3lPeUZwaVRiMlEzVytISkx5ZkJRSVN2NFhyZmJB?=
 =?utf-8?B?anluWGVTTkczcWpBR09DSVQ3NEp3a0J2MmhKc3R5NFJQOVFHZDBZaS9YWGRH?=
 =?utf-8?B?aUpZYVpvR3loeldtSk1FYzlYam16ZGQrWmt6Y3NuazVLdnpQTUY4RGY5NlZs?=
 =?utf-8?B?bmxHRjdkaGlqMWNKVGkxQXByQ0NzL2wrUWVmUGNoaUF4cCtHakRZam9ReTFK?=
 =?utf-8?B?Y3lIZGlHTUlwZElBUnpUNTBiaWpmN3RDRzBsRmNzMUx1WVN0QVowOGlPYTh6?=
 =?utf-8?B?bGp2QUROWkVHUUJScnFjWnNqc3pRZ1pyS0FqR3hxcVI1aGFKRGFYRDNpSitX?=
 =?utf-8?B?V25Xa29Ua1NTOThoY3lPYUhPTWRVbThGc0V1WEw0RjZPaW5qaStlMmVRUjlT?=
 =?utf-8?B?N09uQzI3WHY4bUZpTVppMzljM1g3bTgxZ3NaUkJNMFVPOTNkVDVIOG82eHRv?=
 =?utf-8?B?RThuZElqVTRzRmJFY1VVRkc4MjBmdHZPYm01RTZPZHpqekZ0OEVESmdGMjEx?=
 =?utf-8?B?QndmWmhuRnRibml3VjRhU2xSeER4ZWlkWVNRcTFOMFpXRis1bEdYdFczOWRH?=
 =?utf-8?B?NkZESGlWRkFnMkFGaVA0Q2g5OERObTd3dlA2dEpIODAvbldzQ001RCtza0xO?=
 =?utf-8?B?cVlNVzM2R29nQ2lCSWRnNWNxd09lOW9CNFVqK3RhTjc2Ny93NUh2VXFHdXdn?=
 =?utf-8?B?M0J2c2lLYUFRZWhlVzYrSUcrbXpXckNibFk3SjZiMVJvS05jb3E5d0QwQ3VH?=
 =?utf-8?B?WEFIMitEYmJYeEU4OVF1eUEyMnRidXdYMXplbmxIWVJvNDFBd2xmcHJXRTlz?=
 =?utf-8?B?V0o1Q24xdlMyZzVvTHJmS3NtTjhZdEI5QlRCazFUOVgxUitjd2NJVWNLdHVv?=
 =?utf-8?B?K0pJeHlmenU4V0RjSEpjRjhOT2t4V1JVdC9hTjFUaStwN1pCRWZCbDJrS2p6?=
 =?utf-8?B?aTVIdGZUekhZL0lVdFczdGJycW9xMGVIamc3RC9YRm5RVENSMjQ0R3FCUXp5?=
 =?utf-8?Q?q8666QWs+WsLm?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-c3e7a.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf8202a-96e0-445b-8c5e-08de78d2e641
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB8925.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 03:13:54.9099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR04MB7650
X-Rspamd-Queue-Id: CEA601E85E0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[hotmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[hotmail.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_MUA_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	FREEMAIL_TO(0.00)[163.com,oss.qualcomm.com,brainfault.org,linux.dev,microchip.com,sifive.com,kernel.org,dabbelt.com,eecs.berkeley.edu,ghiti.fr];
	TAGGED_FROM(0.00)[bounces-72492-lists,kvm=lfdr.de];
	FREEMAIL_FROM(0.00)[hotmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nutty.liu@hotmail.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DKIM_TRACE(0.00)[hotmail.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action


On 2/27/2026 8:10 PM, Jinyu Tang wrote:
> Currently, kvm_arch_vcpu_load() unconditionally restores guest CSRs,
> HGATP, and AIA state. However, when a VCPU is loaded back on the same
> physical CPU, and no other KVM VCPU has run on this CPU since it was
> last put, the hardware CSRs and AIA registers are still valid.
>
> This patch optimizes the vcpu_load path by skipping the expensive CSR
> and AIA writes if all the following conditions are met:
> 1. It is being reloaded on the same CPU (vcpu->arch.last_exit_cpu == cpu).
> 2. The CSRs are not dirty (!vcpu->arch.csr_dirty).
> 3. No other VCPU used this CPU (vcpu == __this_cpu_read(kvm_former_vcpu)).
>
> To ensure this fast-path doesn't break corner cases:
> - Live migration and VCPU reset are naturally safe. KVM initializes
>    last_exit_cpu to -1, which guarantees the fast-path won't trigger.
> - The 'csr_dirty' flag tracks runtime userspace interventions. If
>    userspace modifies guest configurations (e.g., hedeleg via
>    KVM_SET_GUEST_DEBUG, or CSRs including AIA via KVM_SET_ONE_REG),
>    the flag is set to skip the fast path.
>
> With the 'csr_dirty' safeguard proven effective, it is safe to
> include kvm_riscv_vcpu_aia_load() inside the skip logic now.
>
> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> ---
>   v6 -> v7:
>   - Moved kvm_riscv_vcpu_aia_load() into the fast-path skip logic, as
>     suggested by Radim Krčmář.
>   - Verified the fix for the IMSIC instability issue reported in v3.
>     Testing was conducted on QEMU 10.0.2 with explicitly enabled AIA
>     (`-machine virt,aia=aplic-imsic`). The guest boots successfully
>     using virtio-mmio devices like virtio-blk and virtio-net.
>
>   v5 -> v6:
>   As suggested by Andrew Jones, checking 'last_exit_cpu' first (most
>   likely to fail on busy hosts) and placing the expensive
>   __this_cpu_read() last, skipping __this_cpu_write() in kvm_arch_vcpu_put()
>   if kvm_former_vcpu is already set to the current VCPU.
>
>   v4 -> v5:
>   - Dropped the 'vcpu->scheduled_out' check as Andrew Jones pointed out,
>     relying on 'last_exit_cpu', 'former_vcpu', and '!csr_dirty'
>     is sufficient and safe. This expands the optimization to cover many
>     userspace exits (e.g., MMIO) as well.
>   - Added a block comment in kvm_arch_vcpu_load() to warn future
>     developers about maintaining the 'csr_dirty' dependency, as Andrew's
>     suggestion to reduce fragility.
>   - Removed unnecessary single-line comments and fixed indentation nits.
>
>   v3 -> v4:
>   - Addressed Anup Patel's review regarding hardware state inconsistency.
>   - Introduced 'csr_dirty' flag to track dynamic userspace CSR/CONFIG
>     modifications (KVM_SET_ONE_REG, KVM_SET_GUEST_DEBUG), forcing a full
>     restore when debugging or modifying states at userspace.
>   - Kept kvm_riscv_vcpu_aia_load() out of the skip block to resolve IMSIC
>     VS-file instability.
>
>   v2 -> v3:
>   v2 was missing a critical check because I generated the patch from my
>   wrong (experimental) branch. This is fixed in v3. Sorry for my trouble.
>
>   v1 -> v2:
>   Apply the logic to aia csr load. Thanks for Andrew Jones's advice.
> ---
>   arch/riscv/include/asm/kvm_host.h |  3 +++
>   arch/riscv/kvm/vcpu.c             | 24 ++++++++++++++++++++++--
>   arch/riscv/kvm/vcpu_onereg.c      |  2 ++
>   3 files changed, 27 insertions(+), 2 deletions(-)
Reviewed-by: Nutty Liu <nutty.liu@hotmail.com>

Thanks,
Nutty

