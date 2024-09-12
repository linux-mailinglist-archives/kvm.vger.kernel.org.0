Return-Path: <kvm+bounces-26741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CDA3C976E15
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 17:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1F53B225C1
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 15:45:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16E7A1B9832;
	Thu, 12 Sep 2024 15:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="HnRPcqGH";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="OYcdmqU5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9B21BB6BA;
	Thu, 12 Sep 2024 15:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726155905; cv=fail; b=SS5Qn7QtuPTP8VsiFd0C6BH2H/8k1DRdY1QgxUXglVX3NWRpkLTeT/Cakq4wt6eF9pFBqb387CdvnVlmjzmtob6uvdCCGSmu2MYx2j/nSEddO3IZQ79WAhvRp4qBvQlrfQpsDRilW6DoMyLlaBq7GIfvMuSowEY/3QMbRC+MNIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726155905; c=relaxed/simple;
	bh=dzHxFRl+cz4EC8lEUJQbgm12fhu6ZfmkjiMqtb5FYTw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oZ5Kdo6kFNonChoWJ/J/EWYkypusc9xp8Pde3hiaDdJEspqT4mdKTEDxE/a+bmXJgdNoc74EerhUpFnTUVu6lHLW18LZgJSkZhM73fTaTyY5Kg5BIPdIWio8rBKFF5nxb1TSjMumv6Wq9DV9qoE9kBfO6ZLSLiHzGLlSMG0WL8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=HnRPcqGH; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=OYcdmqU5; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48C5s5RP019396;
	Thu, 12 Sep 2024 08:44:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=dzHxFRl+cz4EC8lEUJQbgm12fhu6ZfmkjiMqtb5FY
	Tw=; b=HnRPcqGHm0iisHe63ZrKSKI9Ia7Xym5ZKOPHIGbvUMP63kwyF5krL8VxD
	K7BZcL4wUL/+86bHE2xBYvttBEWDclv5a+B6d/xTvFrMRyJYMp3FzuMqKURc8XzW
	Da2o5hS60LCn0rABS/VWCsS4dYDgwVIZYD8QyxyQXVDDM1DfGeEE/LPAphgHXmZN
	Q3Ycf59QeYKI9I4siP2pY6QjftReHnzGhAz3KRvYKD9843OKvYFYcdtoJZxiQf+y
	ouLyakCriC4nUXskGrur3LBq15MUjxmfb+Ctcj6UZmqDrsPtQSPc4uzuz2wkjrGn
	BiXEU+0HiX2WZLX7CqEHUctAE3auQ==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazlp17010002.outbound.protection.outlook.com [40.93.13.2])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 41gmxhvqx4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 08:44:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Da7xIsvuefVfwYHiEhQoVGBOCMHcss2tKCU8SFhl3BHYOdjKloZAuNOT1/Sq/ByVqjg8xka4iZLC13/0naFPIoYNFF6f9bX82KAQiOnSv5i5B3tPYlH9mVEk+peOxZGCLhDuKceUHyZFc6xMtn/iCkerC1hBzBsqBsx3RGibwt0OBQjdqo04wdCCz+1hpYGf6zUVJVbdN92deNYFPCEfz0p8UXcVAOJUvFy6hRRLo/Z0wqNW7fe8ph46GW9T4VKdau3Swl29Aij1lQT7elGU3NFaoPf78bpfGAakMObbOESomagSmTdvj66Qf32+CyeO9v4CSH+Pbm0ysVoalYfBrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dzHxFRl+cz4EC8lEUJQbgm12fhu6ZfmkjiMqtb5FYTw=;
 b=ZEGn+v0jd25+juMLB4ScCYktX25EjyYO04uVCydUVEO80PeK6gJJypTGxyyRMWbAzONfVEein8LnurLy2ViMLVUpjq7Yp8+ekcGUo9bpRTxf+kma9HnF7vYkgu/XGaH9goB5+GkYNagPGzjD6LVFq8mY24kiaPpV3a0UFKYnigxnc+1fwEoZXzHMLYGoEo8UHTATEn27zZOWGHCcSwNXWN+HXse6Qhh9mWFK4VuxufkiHu2fA8HDHlDErWwSdtfmWfTaGzRUArP9WnrcG8U6FLxlXcpmctgziYuTXA/EcecNmeAa5y8NwbXTf/TbpTVxM2/n9OOEpvaBxY2yYY/eug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dzHxFRl+cz4EC8lEUJQbgm12fhu6ZfmkjiMqtb5FYTw=;
 b=OYcdmqU5e9XMQa49ahRnMWoAbQfO8skBtziKPp7e7bjIAQ8q3IVaaJBoKNj3OhD6iy2hnJyKGC0YT6FLgRuJBud3WYzk50R5t0RO8aYzyeyNh79XIr2eQ+gtaAUid+xpgUnUnZsgQcfAtZ82zRq6D4879R5Rjc37z7XMkW7ub9uz9k1HiPojM1eysvA3LOorA7DCUibtLcpddz2VOeidvRuYxrhuYEq7EbZqbKK4soczCg/ssJ/y7qGYvU6St38yEceK7biLHjhb4wuNsaR5+Hwr9hNrzTRG1vp9//PxvFFqjFqhJD0LO8fM4A9XFs1ovg/EaOvEQ5qWZMbkQY0XPw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SA3PR02MB9347.namprd02.prod.outlook.com
 (2603:10b6:806:313::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Thu, 12 Sep
 2024 15:44:38 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.7918.020; Thu, 12 Sep 2024
 15:44:38 +0000
From: Jon Kohler <jon@nutanix.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML
	<linux-kernel@vger.kernel.org>,
        "kvm @ vger . kernel . org"
	<kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/bhi: avoid hardware mitigation for
 'spectre_bhi=vmexit'
Thread-Topic: [PATCH] x86/bhi: avoid hardware mitigation for
 'spectre_bhi=vmexit'
Thread-Index: AQHbBRtn4jznGhv7KU+IMqTomlXzNrJUQp8AgAAIdoA=
Date: Thu, 12 Sep 2024 15:44:38 +0000
Message-ID: <070B4F7E-5103-4C1B-B901-01CE7191EB9A@nutanix.com>
References: <20240912141156.231429-1-jon@nutanix.com>
 <20240912151410.bazw4tdc7dugtl6c@desk>
In-Reply-To: <20240912151410.bazw4tdc7dugtl6c@desk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|SA3PR02MB9347:EE_
x-ms-office365-filtering-correlation-id: cd56b73e-1e1f-49b2-40be-08dcd341cf3f
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?c05aTWFyNWVoNG5pZVVZMjJMMkNjclJaWlEwSXA0Nkd2akFqZjlIeVJ2Mi91?=
 =?utf-8?B?elFxWjU1ZDh1S3ZPaDJYTEszcEY3d3JMVnc5Y3NTZUpWNXZ3TDh1cTdwNnF5?=
 =?utf-8?B?SGF0Rlg3MDc3bU82aUpGNU9sWEFkbmJpSHRjN3YwbFA0QjI5dzZGTitIUjJ4?=
 =?utf-8?B?QVJrVmVhalJrN0pqZFhKY3ZINXpPV0VYc3F5K2pTc0ZnOHZWdVZDNUJXcDQy?=
 =?utf-8?B?RU10dzNrNzFJWktnQlI4U0wzd2dkVlVqNjNnRDhTbC9RUXVLc3ZzTVhEUk8v?=
 =?utf-8?B?UnZjQndNT1YxU1NvUXMxUklJWGgxWVRQcjNzeVM1Q1dnd0NHWWlvbFZJbzB5?=
 =?utf-8?B?b1lKSDRxa2NSMjdQMEsybk0yTnFtZ2M4dGprU2YxLzdtR05ZZTEzRXE5L01r?=
 =?utf-8?B?em16VWxySTdyUzVETGo5NXZpNnZjZTFrYzFOQUtiZGRpUzUyTXEvV0RyYkRL?=
 =?utf-8?B?STliaTUvMVB4SGxnQWdncVhRSkZseGRVK0s0Mlk0dmNWdlpnZi9iTUEza3Jv?=
 =?utf-8?B?aGJueVE2a2dxMzh0eEsyODQzdjVmWnpmaGNFYmljcGdkQy9yNUtNL0R5NU41?=
 =?utf-8?B?NnlSNWI4QThWeTVCTHhVY0dqSjlUcDRPZ2UyZTQwZWgwemFsVmtZUGhRbzVp?=
 =?utf-8?B?TVNhM0FUa3RaRUNHcXJFb2pEbDUwYWxlTEJ6UnUxU0JxWVNkeFlwUTM0UWtU?=
 =?utf-8?B?Q0dzWjllT1BsaG5OeDI2dkRMMVczaFI1eDZaYWo4MmJWTmhIT25EMHZZSHdm?=
 =?utf-8?B?MjF0OVhHQzNtaWNxV1lldjg2MDE1NENIVmI3S3llbDN0cm9uT3JPNGNwS0pG?=
 =?utf-8?B?bGxkWkVRU0FER2ZIYitGQS9PalVVNzk0NERNVWswL0JrUmVVa2d4bmJlWTBv?=
 =?utf-8?B?UjJnb21tL0tTV2ZQNGFBcGwwZy92N0ZNT2JtRnRpL0lwRXJiOVZLWkhRdTVN?=
 =?utf-8?B?NnI2NW5IZWdtYUFjQ0tIV3V4SXByeHBKbUR6TExjT21OT2hNNDJiZ1k2b2po?=
 =?utf-8?B?eUlvOGE3eDZDV3RkcklaYjBoMDVOVm1QTVNMbk5OZlNheEd3UXlxbFRjamJH?=
 =?utf-8?B?UHVFYWsvS0JDQVZRd2ZPdUo3ZG43TENTTlh2MCtkVUw5RUFNZ1p2R0ROcm9i?=
 =?utf-8?B?bGN2a29BaUk1SUhTWEdmQWkzdE53YTJKNkVKMFd0VGQvRmxHZ0pDRDFmaGJ5?=
 =?utf-8?B?a2dJakx0a1BFaXkwS0JYUkRIa3dZWmcwYStpSEIwQytycTRDaFhlVlZLajRV?=
 =?utf-8?B?em9CQm0vNkpWcXJ0clJBSnVsalc2d0tpNVROMFFQQTN1Yk1rNk9tazR0YlVY?=
 =?utf-8?B?aTExNjE0bTFONFRZSjRnQUl0NjJFTzNRdnFxTkF4QzVsS1VyZ2lDK0x4T1pK?=
 =?utf-8?B?cyt0Vk5WT1J1U3lacytVQy9pdWhXK1NRR0ROL29OdmZIaCtrSDY5cUhadkJK?=
 =?utf-8?B?b3JoaHl5cDIxTnNkVWIzdnUxY0V6TDRMelZGL1J2NDVTTDlxVzN1VVp4UW5m?=
 =?utf-8?B?czh5WU83enJFU0hKWGlrVWUvZzJsdVErSkhuSzFteENQK2UzeE4rckxPcDZZ?=
 =?utf-8?B?M0I0TzNCdHRjelFEQXlkOHR3SkFzdUNPUFZuK3VVQ1R5UjJjbHJvZzFYNXo4?=
 =?utf-8?B?cm1KSmN5YnNOenVyUG5vZ3R4RllEMmZjOTNsbm5iL3hPM1U0R3NFZDRtaHcr?=
 =?utf-8?B?aGU1MUUvY05JTVNRNERXUDdwdTVVRFd6U0hPMFRKK054RzdRdGdFUXBOWTlE?=
 =?utf-8?B?OWpySE4rMFZ2TjNvamZwY0JaRVlWZ0cyRk9wRzJFSWFQTFR4SGdwdCtKS2Z5?=
 =?utf-8?B?MTFFMXE5N2ZOSHVEMERWUnVid0dqL1dKeXZSMm9wUGJ0ZE1tM01KV2plbEJl?=
 =?utf-8?B?c3d2bS8wNUJlTG9oa2NKcWxmd2tVbUZyNjhxOGVmd1Fwc2c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?VWJFekpjTWIyWktZUzBZc1lYNEJjTnltVlk2dUJwM0c3ZzBkbFNudUN5dkZp?=
 =?utf-8?B?di84L2hqeDd0MmNtOC85M0Fpci9WT1JXYnlEdkJjR2pzVUM3dGQvZGdlTnUx?=
 =?utf-8?B?T0NQcHlYZHhNcjE1TTdBSVliVi9ZYWVjTWROOXc5UzV3NWQ2NUNZRVZYOWxS?=
 =?utf-8?B?KzVDQ3Fodm9wSmtNZE5hdktiNFBZaUlvM0Q1KzR6azdQVHRDZnlqM0htb0lm?=
 =?utf-8?B?S0VDd0Y1andTM0laM3hsb0pEekVyakxOVnJuemVRL2RaZmpHV0tvQlU3K29H?=
 =?utf-8?B?Zkl0TFBqeE9LYXQwR2NqREwyd3dueTJvbVAwOUUzNVNzY1Fubjd4aDRrRXg4?=
 =?utf-8?B?dldFVzgvZlV5M2UxaXUxN1BXYTVFNnNpNkMvbUpOQVIzRlJJT3hyVUZZdUl0?=
 =?utf-8?B?VDZqMmpuYlFldHh3RmhYMy9sbVFYSThZa0ZmSlMybnZjd1ZCVmd4UFRqWjVT?=
 =?utf-8?B?WWpzM1ZtTU1sNG5GVlFmaGdtdmMyQm1aZllsOTJva1JlbTB0Wno4cU1YZkl5?=
 =?utf-8?B?cWdHQ1FPT2Q4U0VHKzN6NkIyeCtvRFZWM3FDREF6TlhoSjd1d1lwaFcxZktP?=
 =?utf-8?B?UVdHR3krRjNSTHpjMUdXQTNPTkJBWERDWWFMTWwyajEyeU5JOSswQ2ljTFQv?=
 =?utf-8?B?N1FTa1pSeXpmdzBGeisxV2p0Wk8zcG5USmJvNDFGQU9HYmR3ZXNEZjhUOTUw?=
 =?utf-8?B?MVFIQm84bis5eHMxa240QjdCOS92WWltNEVrcnJjSmJjNzRHZHNhckpzaFdB?=
 =?utf-8?B?OU16SE9VOWRibmNFdXFTNGEzaG9yVmp2WGR3Y2JBckltWFlZQ1RJMmFNcVBT?=
 =?utf-8?B?d3Z1YWxraXlQdU5jR0pwc09DRDY5YVdaY3dVN01zMFY3N3hVbXBlclN4dk1Q?=
 =?utf-8?B?bVBIek9FbzdDQm5wc3pldWM5SnBTK1ZTUTZlMkkzb2s1OXJDYXRlcnEveUVG?=
 =?utf-8?B?SEgrbkczb2tIMnAzN2l3YjRjb3hQdkEwSEpGOUhPUTQ1dkZsL2lJcXJtUWNX?=
 =?utf-8?B?VktyRFlnM3VvYjFOS3F6c2U4empUU2R6SGNFVjF5Q0RiSXpNS3NuVXJHdWFM?=
 =?utf-8?B?c1Z1RXJhMEoxb3RUVVQxS1d2US9rVHdyTFVIbzlsblg0RUhMTzhMbTlVWFZ1?=
 =?utf-8?B?OFBTYWRVTWNENzZXRXVJeEwyU01wYXdXRTNrclQ5Um5FRmFLbmVTUWg2RjdP?=
 =?utf-8?B?ejh3K1NGYTNvOXNYRWxoU3A3Q1R0NEpzZVlYc1l3Q1ljQno3QjhTNzVBZHE3?=
 =?utf-8?B?M09hN1hEUnFuZmZBS1Z3VVhwOGkxWWlpZ21mS3ZXWGQ5eXJDMjBpZ1RQL1NX?=
 =?utf-8?B?Sk5YNnpGYkRjL2pZSVhSZjI4R09nclNUcjFRU29yR0Z1ZjVGTS8rdmVPVFF0?=
 =?utf-8?B?NitQaTBPZGgvYTNNU1BzSW95MGF0cjV3aWVxNGZzM0I2QktpazJUYUFVTnFO?=
 =?utf-8?B?NjAySjBWK1lia1FQSjVRdGFaSW1Ka21yeHNlbDViK1Q0VjJrdXBSR2lCY1Fx?=
 =?utf-8?B?UER6dFBiVXpMZUc1cjQrbzR3SXlNSHR6UGlyUmpQdjZoL2RkaVR0a1ZJT2J6?=
 =?utf-8?B?NjV4T0ttY1h6WnArVUl0T09aekFpS2RydGFwTGF3SktBTlZrdDRydHBiLyto?=
 =?utf-8?B?cHFIWFFvR00ybktzSHdCckloQjI2SjRNOWhuYXNBekdsUEpDRnRhSkdUclhI?=
 =?utf-8?B?eXFiRnhOVGJXcWxqOFpHaGp3eUhYdit6dlBkSjk5RVh2eHpzcDY5UEJFZjJU?=
 =?utf-8?B?Q0tXTGNtajZHZ1JyejE4RFcreGRvN0t6RWN4QjRBUG1hRVFaWDNLcko4Z0pT?=
 =?utf-8?B?bkhhMDY0cjV3R0dFQ25veWJQUHoraThZM0pmUmRKbFlTL3NIRnM0b0VlWENm?=
 =?utf-8?B?RjI2YUtTMnBrUlpncHcyZkhnSXFDTTRRRU9obUV5UHhGbWtnMzdOZ2wxWStT?=
 =?utf-8?B?MEZSUEptU0NSNURIREVVSmw4SmZpSHUzUXZuSlYzNHBxM0Y5aEVIUUcyQzc3?=
 =?utf-8?B?UXFxRndtREgvdDBiY09yQ3pPMjR1K1AyL1AwU1RVdGpxRjZyaU1hUUhtYklD?=
 =?utf-8?B?QXJWU3F5Ry9MZEF6WEVpdlB5R0UwQ2N1NlNTZ3lRSUxzUjI3UnZiNkdWQ2pK?=
 =?utf-8?B?ekoyRVBQdkp0QTA4VFJ3cFk2dWRSWWFsaUFpcDFjQUJCaHBJdFFiRC9QcDJV?=
 =?utf-8?B?VUNOTXNuUlVMSzJHeEpnUUI1dmV0VXpFcmdYVnVIczBZUVhtQ2xQa3JiZi94?=
 =?utf-8?B?dW9PaGhWK3pCNmJsbVRnaC8wOEJ3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1BA81E4681E71F458C821683DC09CE5B@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd56b73e-1e1f-49b2-40be-08dcd341cf3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2024 15:44:38.3062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v254JXDWc02S/xINsJRY4U+HS84zwNNrp+ecP9y7cFXeu2r9PqLZW50sn4KlMuHmtetZZcBmXalHS4SO1eSFsQ+F8UoEML80PLa95e5lLM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR02MB9347
X-Authority-Analysis: v=2.4 cv=SfSldeRu c=1 sm=1 tr=0 ts=66e30c69 cx=c_pps a=rknZK0v7KRh+kGA6vhtu4g==:117 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=EaEq8P2WXUwA:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10 a=QyXUC8HyAAAA:8
 a=64Cc0HZtAAAA:8 a=PVCY_jKM7sJ306oarKUA:9 a=QEXdDO2ut3YA:10 a=iJeLTDR2-uQA:10 a=y5rEMOVZ_0gA:10 a=14NRyaPF5x3gF6G45PvQ:22
X-Proofpoint-ORIG-GUID: AYgBpJbevOCfTLIXNnl-QYuRpZ67qLP2
X-Proofpoint-GUID: AYgBpJbevOCfTLIXNnl-QYuRpZ67qLP2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-12_05,2024-09-12_01,2024-09-02_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gU2VwIDEyLCAyMDI0LCBhdCAxMToxNOKAr0FNLCBQYXdhbiBHdXB0YSA8cGF3YW4u
a3VtYXIuZ3VwdGFAbGludXguaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0K
PiAgQ0FVVElPTjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gT24g
VGh1LCBTZXAgMTIsIDIwMjQgYXQgMDc6MTE6NTZBTSAtMDcwMCwgSm9uIEtvaGxlciB3cm90ZToN
Cj4+IE9uIGhhcmR3YXJlIHRoYXQgc3VwcG9ydHMgQkhJX0RJU19TL1g4Nl9GRUFUVVJFX0JISV9D
VFJMLCBkbyBub3QgdXNlDQo+PiBoYXJkd2FyZSBtaXRpZ2F0aW9uIHdoZW4gdXNpbmcgQkhJX01J
VElHQVRJT05fVk1FWElUX09OTFksIGFzIHRoaXMNCj4+IGNhdXNlcyB0aGUgdmFsdWUgb2YgTVNS
X0lBMzJfU1BFQ19DVFJMIHRvIGNoYW5nZSwgd2hpY2ggaW5mbGljdHMNCj4+IGFkZGl0aW9uYWwg
S1ZNIG92ZXJoZWFkLg0KPj4gDQo+PiBFeGFtcGxlOiBJbiBhIHR5cGljYWwgZUlCUlMgZW5hYmxl
ZCBzeXN0ZW0sIHN1Y2ggYXMgSW50ZWwgU1BSLCB0aGUNCj4+IFNQRUNfQ1RSTCBtYXkgYmUgY29t
bW9ubHkgc2V0IHRvIHZhbCA9PSAxIHRvIHJlZmxlY3QgZUlCUlMgZW5hYmxlbWVudDsNCj4+IGhv
d2V2ZXIsIFNQRUNfQ1RSTF9CSElfRElTX1MgY2F1c2VzIHZhbCA9PSAxMDI1LiBJZiB0aGUgZ3Vl
c3RzIHRoYXQNCj4+IEtWTSBpcyB2aXJ0dWFsaXppbmcgZG8gbm90IGFsc28gc2V0IHRoZSBndWVz
dCBzaWRlIHZhbHVlID09IDEwMjUsDQo+PiBLVk0gd2lsbCBjb25zdGFudGx5IGhhdmUgdG8gd3Jt
c3IgdG9nZ2xlIHRoZSBndWVzdCB2cyBob3N0IHZhbHVlIG9uDQo+PiBib3RoIGVudHJ5IGFuZCBl
eGl0LCBkZWxheWluZyBib3RoLg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBKb24gS29obGVyIDxq
b25AbnV0YW5peC5jb20+DQo+PiAtLS0NCj4+IGFyY2gveDg2L2tlcm5lbC9jcHUvYnVncy5jIHwg
MTIgKysrKysrKysrKy0tDQo+PiAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMiBk
ZWxldGlvbnMoLSkNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9jcHUvYnVn
cy5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9idWdzLmMNCj4+IGluZGV4IDQ1Njc1ZGEzNTRmMy4u
ZGY3NTM1ZjVlODgyIDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9idWdzLmMN
Cj4+ICsrKyBiL2FyY2gveDg2L2tlcm5lbC9jcHUvYnVncy5jDQo+PiBAQCAtMTY2Miw4ICsxNjYy
LDE2IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBiaGlfc2VsZWN0X21pdGlnYXRpb24odm9pZCkNCj4+
IHJldHVybjsNCj4+IH0NCj4+IA0KPj4gLSAvKiBNaXRpZ2F0ZSBpbiBoYXJkd2FyZSBpZiBzdXBw
b3J0ZWQgKi8NCj4+IC0gaWYgKHNwZWNfY3RybF9iaGlfZGlzKCkpDQo+PiArIC8qDQo+PiArICAq
IE1pdGlnYXRlIGluIGhhcmR3YXJlIGlmIGFwcHJvcHJpYXRlLg0KPj4gKyAgKiBOb3RlOiBmb3Ig
dm1leGl0IG9ubHksIGRvIG5vdCBtaXRpZ2F0ZSBpbiBoYXJkd2FyZSB0byBhdm9pZCBjaGFuZ2lu
Zw0KPj4gKyAgKiB0aGUgdmFsdWUgb2YgTVNSX0lBMzJfU1BFQ19DVFJMIHRvIGluY2x1ZGUgU1BF
Q19DVFJMX0JISV9ESVNfUy4gSWYgYQ0KPj4gKyAgKiBndWVzdCBkb2VzIG5vdCBhbHNvIHNldCB0
aGVpciBvd24gU1BFQ19DVFJMIHRvIGluY2x1ZGUgdGhpcywgS1ZNIGhhcw0KPj4gKyAgKiB0byB0
b2dnbGUgb24gZXZlcnkgdm1leGl0IGFuZCB2bWVudHJ5IGlmIHRoZSBob3N0IHZhbHVlIGRvZXMg
bm90DQo+PiArICAqIG1hdGNoIHRoZSBndWVzdCB2YWx1ZS4gSW5zdGVhZCwgZGVwZW5kIG9uIHNv
ZnR3YXJlIGxvb3AgbWl0aWdhdGlvbg0KPj4gKyAgKiBvbmx5Lg0KPj4gKyAgKi8NCj4+ICsgaWYg
KGJoaV9taXRpZ2F0aW9uICE9IEJISV9NSVRJR0FUSU9OX1ZNRVhJVF9PTkxZICYmIHNwZWNfY3Ry
bF9iaGlfZGlzKCkpDQo+PiByZXR1cm47DQo+IA0KPiBUaGlzIG1ha2VzIHRoZSBzeXN0ZW0gdnVs
bmVyYWJsZS4gVGhlIGN1cnJlbnQgc29mdHdhcmUgbG9vcCBpcyBub3QNCj4gZWZmZWN0aXZlIG9u
IHBhcnRzIHRoYXQgc3VwcG9ydCBCSElfRElTX1MuIFRoZXJlIGlzIGEgc2VwYXJhdGUgbG9vcCBm
b3INCj4gU1BSLCBzZWUgTGlzdGluZyAyKGxvbmcgc2VxdWVuY2UpIGluIFNvZnR3YXJlIEJIQi1j
bGVhcmluZyBzZXF1ZW5jZQ0KPiBzZWN0aW9uIGhlcmU6DQo+IA0KPiAgaHR0cHM6Ly91cmxkZWZl
bnNlLnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX193d3cuaW50ZWwuY29tX2NvbnRl
bnRfd3d3X3VzX2VuX2RldmVsb3Blcl9hcnRpY2xlc190ZWNobmljYWxfc29mdHdhcmUtMkRzZWN1
cml0eS0yRGd1aWRhbmNlX3RlY2huaWNhbC0yRGRvY3VtZW50YXRpb25fYnJhbmNoLTJEaGlzdG9y
eS0yRGluamVjdGlvbi5odG1sJmQ9RHdJQkFnJmM9czg4M0dwVUNPQ2hLT0hpb2NZdEdjZyZyPU5H
UFJHR28zN21RaVNYZ0hLbTVyQ1EmbT02NUdUV2h3alBlakF2c19RYU1yQjZwdzFLcVZJNXpaVXg2
cjZoc2FTb1BIRER1bHB3aDk2UTd6ZWRZUzZDR29UJnM9YlE4WDRtamZPUFVaZ1dVeDdZUUE0cmtE
QURYb09YMi1wbW4tNjV4UEw5ZyZlPQ0KPiANCj4gSXQgaXMgb25seSB3b3J0aCBpbXBsZW1lbnRp
bmcgdGhlIGxvbmcgc2VxdWVuY2UgaW4gVk1FWElUX09OTFkgbW9kZSBpZiBpdCBpcw0KPiBzaWdu
aWZpY2FudGx5IGJldHRlciB0aGFuIHRvZ2dsaW5nIHRoZSBNU1IuDQoNClRoYW5rcyBmb3IgdGhl
IHBvaW50ZXIhIEkgaGFkbuKAmXQgc2VlbiB0aGF0IHNlY29uZCBzZXF1ZW5jZS4gSeKAmWxsIGRv
IG1lYXN1cmVtZW50cyBvbg0KdGhyZWUgY2FzZXMgYW5kIGNvbWUgYmFjayB3aXRoIGRhdGEgZnJv
bSBhbiBTUFIgc3lzdGVtLg0KMS4gYXMtaXMgKHdybXNyIG9uIGVudHJ5IGFuZCBleGl0KQ0KMi4g
U2hvcnQgc2VxdWVuY2UgKGFzIGEgYmFzZWxpbmUpDQozLiBMb25nIHNlcXVlbmNlDQoNCg0K

