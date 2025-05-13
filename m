Return-Path: <kvm+bounces-46285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EBA1AB4965
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 04:17:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DB9C865A51
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 02:17:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58C551A9B40;
	Tue, 13 May 2025 02:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="RLYfiI81";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="RWij/OL3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D5919D89B;
	Tue, 13 May 2025 02:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747102659; cv=fail; b=QVG9vwnibZLsfmBF1Z2TEwx4x2FMLfisEjpsik/18fOF3jkLhtamASapWO5p8rdBK8VX8+qutBghRH2DmYE9JA5N4GK8nHwbwzp3SOSKV7HvtxSLk4uaWP9mlZHdVhGF8ldvniuYR/q3TyRsFJEw5LpEbwYMQZ9dMcH95uuoKeo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747102659; c=relaxed/simple;
	bh=YuoaCJDr8cbnlQ0AeOkzSkujaQ80LgIsy5zb4qLSLRU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SEMSFoZIHVo5jbz6Wg4e340+VlNRATeWNjU0CTUqP1XgyAQIrEVvPRqlH4JhcdSNVSvWVeUso46XtF4d/Eb5N5GnEbBphkcr9Fd/nGoDro3/vYc6/F7vcLtNOFmyYTAAi3NNltQbMK363i7+Lkhg7+vR+An27nNljOPh63lUiBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=RLYfiI81; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=RWij/OL3; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CL4MQF003163;
	Mon, 12 May 2025 19:17:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=YuoaCJDr8cbnlQ0AeOkzSkujaQ80LgIsy5zb4qLSL
	RU=; b=RLYfiI81hi3yxzKHQ2xO8+/gehGQqiMSfrPvLiqNidst7T9EiXC0VRygZ
	ju1Q9kzhljyZnQInP+WIHF6t48M7xwxwKD8Cb9CZAYqgmXR70aXT+epUc+XgxYTT
	Oxshx24tZqKV36y/71oCKQ4GZpCp0ofqA0zJBr0snRSc8u9E8Gav7ksksf18WSIF
	rQAgV9Q1LitNcgTnPdVb1Jsm3Msu8gTJLCrTwKQrxfDCjGORIH4M4neXx820tsnn
	kqes95w8R1d9fImnKDu2HzDp1F/CUedW4Xl0D2Ac4Y3jhuPjljcSeTskxO5Vn0O8
	CleioJ3SglaGaTO76pyFysX71JXoQ==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 46j2q8cn2d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 19:17:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QzSyM6Lxl1c8OhLra2NZNkB/WY28dG/1UHHTAPx1qJNopOz8xCwM/qsVnOTdB/WHOmbvbXPeemI1lvRouDr81a+STByOPZ53h7NKzIvSdhLEvTcIIZxNXAy5yOvrGwb4wJQVhp+sNgzW2zDXOm3n9ZQKf+GrX+NpAiG5kj6TYoBP/ScVJhl87PVe3YCRFcjCjhozbGGCXETFP6VF6Gk8QkFHuzM+qlFiNPVJNqtQSDNBndsaV4xZ6rbxVoALjTQZNgzBuCtf+0rNzfTr9KqiqneMTc1uZwxuPh4O/Vp7wthHQDsa6q0W+FFMhl5l2nY8kpd+2ZeTJo7OmYTORHZDQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuoaCJDr8cbnlQ0AeOkzSkujaQ80LgIsy5zb4qLSLRU=;
 b=nnqQaOOcZEsDiankDrY24hlr6oCWLAPaR10GitqqHKgFnnXyEkGcuBusVuqJzm5pSo9otJ1Wo3jqq7fLWaFTLwdK7PgUftCDs/W/KbxRl7qZ9W93tJTLKhfhtALasGq5zC5hZ5aiL9jw3j/sh8nG3XQV0CUIV5wMh23O8Wx6Ggy0lgJ6Xv4Ss4jLdx3Rz6gBMmYk4pkpAXt9ZejKrIIMeg5m6PaDBYzZ3fj7QprnjX7LI31bslenlE9Kny9h605YLmZukOnqldiw5llUZmNcyMNSoKHwNHE34sKo0U+gqYQYcZjrI2InImH3dr18LwJiQa3TsNV82zBRtFF/zisP1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YuoaCJDr8cbnlQ0AeOkzSkujaQ80LgIsy5zb4qLSLRU=;
 b=RWij/OL3vK1U4pUVT7qxHCgKGIE48uyEgwMF7FHhBNGaJ6its2bc9U7udYP2IZEZwuMlsnEd+JEwsMkXjRIkEpNagi4E68CkPNug1yjRa76H8CCIiuYTWbj2sM1pYCJ7dn8lYl3ky9yryiQLYcHTfKurytat1pIH4PERCLqVPk+kyqpDs1/sHoh7NbIm+Kx7AjUL9VhOOBPuAvdQIXM5gpyu0orUd+hqua5E3hwuFFKJKZ7V04j7+DpWmXa4uZT4aRI8Zn9C184zXQPU+XWjvKp3YFsWAHaAlRA2nz7FMe8nX8ml87wILTTZAunn+iR/LY1sVsqgyB0qh84xom8UpA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by SJ0PR02MB7151.namprd02.prod.outlook.com
 (2603:10b6:a03:290::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.28; Tue, 13 May
 2025 02:17:06 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 02:17:06 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de"
	<tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        =?utf-8?B?TWlja2HDq2wgU2FsYcO8bg==?=
	<mic@digikod.net>
Subject: Re: [RFC PATCH 04/18] KVM: VMX: add cpu_has_vmx_mbec helper
Thread-Topic: [RFC PATCH 04/18] KVM: VMX: add cpu_has_vmx_mbec helper
Thread-Index: AQHblFPrSejAFX4Z8kmZoV0Mq28sLLPPqrOAgACG1oA=
Date: Tue, 13 May 2025 02:17:06 +0000
Message-ID: <78B2A649-BF46-4907-86FA-952D6CAD162B@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-5-jon@nutanix.com> <aCI6e6KYXmfi_Oqp@google.com>
In-Reply-To: <aCI6e6KYXmfi_Oqp@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|SJ0PR02MB7151:EE_
x-ms-office365-filtering-correlation-id: 4ccffe55-114a-4b77-7b6d-08dd91c441eb
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZHp2ZWkvZER6cmJuUnAzL0dNMFQ5akVweFVnSE1GZGhpNSs5SDltejNTbzNY?=
 =?utf-8?B?N29kOGdtblJISDdMQjZMNEdTRit5VUxJVjhLM3hENC9YdHF4WWhtR2tFTVR1?=
 =?utf-8?B?eTRnUTE1Z2l5Nm9IWjdHbVdUS2dnMjVjRE02SVNqT1BuZDRlaTRlb1FNc0l4?=
 =?utf-8?B?SW12QXFQbVBYVXJsZGh5bldwSFVOdjFlQ0dnZloxeVRLbzArQ094R3JCLy9Z?=
 =?utf-8?B?UFBBYktnY2xqSjNYVm8ycTRKeFRvRmdKNitDaEFBRE4rZ3czUE9idWxSRGVj?=
 =?utf-8?B?YWNtNFlJNXozNFV4ZmhCSytXTXBQR0d4Yk53dUhmWlFCbUo3eEtGYi9vTVgv?=
 =?utf-8?B?ek1kTE9nMGtydGtLWnlhZGkySUoxQUs4RlRYM3VFUGFub1ZPRUVXTDYwanNo?=
 =?utf-8?B?T29Mb3I0Q0s0a3V6dUJsRk1wQWdxWVVVNyt3Y0U2Uzg5UzZpZGpoWlhrOGRC?=
 =?utf-8?B?SnVvRzJpUnhoa2lCODZNS0w0UEFWVjQzOFdNeW5aeXNqTWVQQkpvUXI4aWh2?=
 =?utf-8?B?UmE0TkNqKysvcGNNVUkrK1VRYXF0VDIxMThSR0pOeXVEZ0F6SnNOWGFRd1RN?=
 =?utf-8?B?YTFXTDZwVkxmUW9wYzRGdjRVeWt0N1RxMDUyV29lNG9uR0lOa2VWMTZvdm5S?=
 =?utf-8?B?VUV5OVJJT29ZeU9QemlnS0hZaEJxRFU2Q3FTaXl0bGYzS3FMUzQwelJ5UVUv?=
 =?utf-8?B?Nnl0Tm5RRkZ3U2JzNHJBaDZEMllrRVJUdXVycWZsY2lmZ3haVHdjeXBWWDVN?=
 =?utf-8?B?MUVzSHBncDdNc01POEppbytGRjdIalhxaEtKV2NMQVhmcjNydE10alFwYnBE?=
 =?utf-8?B?YVdNLzR0RXZ3K0pUM0NsT1k1MHBrUzJ6OGJiRkdXYnB4a3pHWXhHM3Q0azF5?=
 =?utf-8?B?Mk5aUjdPTVFna1VHb0JVakZKTzkzWXB5SmhrRmlXRzVjMmFGQ3dJUkd3b2hl?=
 =?utf-8?B?U3JJNWhWZkNJbHdtaU1QQ1I5YUZFTDlGMU5XdUIvZzluR3o5ZitpNUQ0c1ht?=
 =?utf-8?B?WTBmYzdqN1pCZzdzZUp0Q05sNElaMzhWT1JZMGlCTC9aQitsNHpXTVI3L3pP?=
 =?utf-8?B?TEtiNHg5Vms5UjZhVnJaS2ordUFYNUJGNzRSb2NiSEhvU3EvZExUVnpjclEr?=
 =?utf-8?B?dXRjODNVQ3dwamxxcytOb3NKaVAzZU9xVUQ2Skc0by9jWm5XTEJFNmUvb29F?=
 =?utf-8?B?ZkVGTmNaU3hxTDNXWnI4amRrYytRU01SeTBlN2xKTUZhQUh0L1RUeGNCVk5w?=
 =?utf-8?B?dXd3dmwxTytwQ1Irc0JuLzRuTXd4WUxER0VqNVBHQlBTU3F2dkZYVGNLMTBH?=
 =?utf-8?B?dzBZRGdHZjNLYVc0QXNvakxsNUxWVWFDaWRhUURUN09GNVFrNjNmV1NtRkRK?=
 =?utf-8?B?Yk1oVDZod2NpQkRhRDZUR3g2NlZZUUUxYTMreEp1SlV2NTlXNFVDSndWa0pF?=
 =?utf-8?B?WWovMVp4MlNvZityK0FPQW0vOHpnWTFEbVQ3eHZOcVl3KzVJNnBGU1NoWTVM?=
 =?utf-8?B?U2ZrN1NVZHkxL3JTR2pjOHdmTDcrVEJ5MTlSMDhSWFJqYk9Gbng2NE5CRmhF?=
 =?utf-8?B?V1d1S01GWXc2ZzBBdHJVZXpsL1RGbkgrWk5VUVRjRzJBVlNNTGh5QUczckNp?=
 =?utf-8?B?UEZ4NDgwYjlGWkliVnY2alZndUtNdlhLd1pHWGhLZ3hQeHhPemZ5aW45elRH?=
 =?utf-8?B?NTlXbGp6bzZmeU5OZHlyNXdrODFHaEhKYUhndzFVMW9OOHNieEdSaHNWVHl5?=
 =?utf-8?B?eFZ2NW04TloxdDdTa0lEMWdRMURNQmJjRXBMY0RYZHpVN0xlaVZtZ05udmJ1?=
 =?utf-8?B?YVJvQUh1RFZiNnlZZHAyakxwVGNieDByVmN1M1BJemQxZ212L0ZZOGhKdGJZ?=
 =?utf-8?B?RzJlczk3WmdVaDI4TzdWMC83V3QyYTN2anM2STRkV3YxcW1PTHQwakc3Mnhr?=
 =?utf-8?B?SGpOM2dyUFFSaXdmNzZMRlhLN0oxR293S1lNOVA5eCt1eHlwTGUrajU4WjB2?=
 =?utf-8?Q?YNZf34D7oKoIhtGpeTTpv8H/1CQWxM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R2J6QWN6cHBoVVl5ZkdSbllDVHNQNkNFUzMwdWdFRWdoUWlZc1dDdU55RUZC?=
 =?utf-8?B?NVFlWVM5cUovRG1KMXQ0Z1ljU2taUjlWd2hZRWFucVpkUDMxNDYyT2dEbGRR?=
 =?utf-8?B?WWRPL2FFQjNTTzUxYmk1dGRLbjFwNmZyTnpFWVlxWGtDYUc4SFNsZ0lkTElY?=
 =?utf-8?B?b3phYjZrUVNlS2c1MHRlT3dYcDIyaEdkTGQ5T3VmSVBLa3VPYXlNRHlSRHJV?=
 =?utf-8?B?M1VvWWRXWDdXaGxIUmxqNTlFdS9BMTRrdVFjclgwM3F0cDduQ21nc250RTlE?=
 =?utf-8?B?akJIVzRieVowTjRDT3R6NExhMVMwWnUzK2RkUFNQU1pvRWtrcGxMY0NjVVgr?=
 =?utf-8?B?dCtLbXdwT1VKV1U2OS9JMmo0UzZkZnBZVXlsTHMweGRmenVLbTkvSmhzaHRq?=
 =?utf-8?B?T2xUcXBjNDBiY084Ymg1TktCRWJCbXptRSthZDRTV0xnK0ZrWkw0NEJRaUhw?=
 =?utf-8?B?aWFubW82VHplSnV4cWxXVHVrT2tLTEdNdzM2NjF4QXRLK1NnemhoSjNNSndj?=
 =?utf-8?B?MWhjUHVQNWdyam5KbUlZWU5pYkVmT0RPMThtUjZGSGJiZ1YrV3I2dGdlcFdx?=
 =?utf-8?B?Q09CL2xubTB0cUlYWXRkeDlzcm84SVZzKzNWYk5kNGc2VHRDNnk3R1l0Vlo1?=
 =?utf-8?B?RTlJS2pGWElJSlJwRWN0U1N6RStaZ0NiRkxnNmRFSDFEaXRRUlVKTlpFamVz?=
 =?utf-8?B?elJzUk1Cc0J0Z3NXeENwc0JHZE9IUEMrMFZ3TG1KcG1YODFWUWphWmpRdldT?=
 =?utf-8?B?WkxHdmlSeHFjOUZPcjNkRnM0cXRjaHVxVGZMaXNvTnR4b3YvSzMxempndG9h?=
 =?utf-8?B?SHltMmdacEFPNTRNOHdaaVJiRjUrYzRBNGtWN2R0YWRHSFFDSkZ0bzMvYnpx?=
 =?utf-8?B?cTc5RzZuTHZQdHJ4OVluZ3VmcE5GYkdmWUdxUW0zSkhBMGwxRTZVQ1FST3hJ?=
 =?utf-8?B?am1KcWZ1RE5IZTNMRDN2MldkNyt3UFN5SC9kd2Y5U21QSlJwcGQzbWttWWla?=
 =?utf-8?B?eFpvR2FRWmJTQ3cxaGxvZTgyZjJIK29tM1VrdEV6Q09Pcm1KcjB0dGdvanBn?=
 =?utf-8?B?YTdpMWcydzdobzdUSjVXVEcvYS9lMUNtS1I2d1EzcG1NczFFbzhRenNqUXBT?=
 =?utf-8?B?QVNZV0lCeVBPcTY3am1UckczOFNlUFJiaEpQRGtEWXQwN2pZdGQ3UFNpSmVZ?=
 =?utf-8?B?cTVreW82WkcrTTFFYmNPQVRZd25PQW5lWHpRNVZnTGR0MkgvOXJva2hYTnZF?=
 =?utf-8?B?cVRzbmEzc094TGx1dTBnNEdWWGtieC92anMzL21Zc3c0bVNZT2pDOU9xN1dB?=
 =?utf-8?B?ZVZld1IyUEFCZ2ZEYjh5bWxRSlVva2JRbVVBOXkzbUMyblZkaDBQVmNiczVL?=
 =?utf-8?B?WmtGbUNJSFFRVUg3c3BjTjUwQzgxZlNpZWxHb2hEWEpQeVB4WTc5OWtpbFps?=
 =?utf-8?B?eVE3YndPeUU4Yjk3dVp2L3kwNHhDQ0drOWw2QWtKRVk1OGFwT3h0NVYva2No?=
 =?utf-8?B?M0J6YXJ6QUtFdStJMjg4eDdOYTEvelNabExxc0xSZ3A3Wngxa1A1UWZUeXBI?=
 =?utf-8?B?TFlCVFNBb01TM1dCNzBKSmhDY1ZHRUVsbmI3UGMzRDFYL1NGR3ZXVDZTYkpE?=
 =?utf-8?B?T1EvUGxLTUdLZy9GWlhOamNpRXF2ODZGV1ZtRXdoamcxc0pGZFhDRnJDTng3?=
 =?utf-8?B?d28ySWV5cWFLY1QwNW4yQ3c2RS9wcEFUV0sySmVLZkRHaG1xYkJZcmtEcVp0?=
 =?utf-8?B?RnUrVi9GcXluZXNYRDlVYXhqNHRWaEtzNVJEQk00OFJwUEVvajhRek9MMVlS?=
 =?utf-8?B?RFpPZGVURU9pZTBZNWw2UGlFRk9zQzNrd1FnVGFIbk9OWFcwSFhlZFlKL28r?=
 =?utf-8?B?d3JHNHlZYnZJaDE3a25tQjJ1RzFMY2trczR5ODZTazRSQ050d05MQzRXOEFH?=
 =?utf-8?B?YkNDUWV3aDNIZFRydFNWQmxCWFdQbE04N0xhbWZhQkF3ZE94WU9GaENYMjc4?=
 =?utf-8?B?MUxHNWthaFB4VFpQNWtXYmEzcFJQblpYYnBMeVpKY2VrSm1yYmw1bW5zOGdV?=
 =?utf-8?B?L2JGbythdTlJbElQdHZuVVdIbDhtNmRqVHpQUjVRSXQ5dGtHZWlyUHJQVlV2?=
 =?utf-8?B?bkFNeGh1NUppYUs3QmplS0k3RC9JZ29wOTBKMjZqTGF5Tjd1QjdpUW52cVk5?=
 =?utf-8?B?Mnd4N1hqN1Z5ek9KeW9GSFBjWEViWVJnRWhMQkg0MTRMTEVGSWpYWVJKckg4?=
 =?utf-8?B?Ui95b3dDMnhJZGtPOVc4bWhkbVJBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <53BA80FAD4EE4C469669E4F67885FFED@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ccffe55-114a-4b77-7b6d-08dd91c441eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 02:17:06.1622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xcuJaJpzZqrbgRFq0epbTakFWxQSAtSWfTTUd5qKDTQJfAEB2Zno6Rzp7fIkliCT7JlPLtI6C5t/P9ec7v2ZQNVq2/IVZWSOKlmOrMywpSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7151
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAyMCBTYWx0ZWRfX988yAkQ2kHRD bNhD5/sfrGHxFC90IrK67x0+NrHX6Pij66Yhp6VjfghACQXRH8GkeLSoZ2hq4ougmXH3IGzeVms lsTQveztYdLMvUk5EUoJUz+1PvOsNE3bEpU4AnJ7PqkEfs/qMGcqA54t1v7JEhzKYpcG4uaMRjf
 H/1+Us5iJThDxiWss89aQ+CSbfSdsOa/nGVmIKcSU5GsS2Kt8807aENc1b2k092WBdOOFkzVAjJ +sHuTtpz9NaJepWVH6FjJsntucXBzWVXzkI1U3iYpbVPMd6LtCE641/EB+AeAhrjExKqtVwvGT2 8yNLGDAgz3XLNpTInCUgA1m3rrIxsjoMNm8IJgMn83kjLQEbO4Izzcmps07s+XgTtFhaetRapS7
 4+II7sgVwtabU6i0SLIIu4IDXiAj221sGH7KKp06CwFADMdZJ+02ufwJWkJ3NOLxGhKH2fU+
X-Proofpoint-ORIG-GUID: dFbmhzySBW6oqLfO0SDXWMvXpi42W-ff
X-Proofpoint-GUID: dFbmhzySBW6oqLfO0SDXWMvXpi42W-ff
X-Authority-Analysis: v=2.4 cv=X9JSKHTe c=1 sm=1 tr=0 ts=6822abaa cx=c_pps a=ur2hu7Zt/Tb0cWAHmjvzJg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=1XWaLZrsAAAA:8 a=edGIuiaXAAAA:8 a=64Cc0HZtAAAA:8 a=-W3QP1XaWFm1dxXsd-cA:9 a=QEXdDO2ut3YA:10 a=4kyDAASA-Eebq_PzFVE6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAyOjE04oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElP
TjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gT24gVGh1LCBNYXIg
MTMsIDIwMjUsIEpvbiBLb2hsZXIgd3JvdGU6DQo+PiBGcm9tOiBNaWNrYcOrbCBTYWxhw7xuIDxt
aWNAZGlnaWtvZC5uZXQ+DQo+PiANCj4+IEFkZCAnY3B1X2hhc192bXhfbWJlYycgaGVscGVyIHRv
IGRldGVybWluZSB3aGV0aGVyIHRoZSBjcHUgYmFzZWQgVk1DUw0KPj4gZnJvbSBoYXJkd2FyZSBo
YXMgSW50ZWwgTW9kZSBCYXNlZCBFeGVjdXRpb24gQ29udHJvbCBleHBvc2VkLCB3aGljaCBpcw0K
Pj4gc2Vjb25kYXJ5IGV4ZWN1dGlvbiBjb250cm9sIGJpdCAyMi4NCj4+IA0KPj4gU2lnbmVkLW9m
Zi1ieTogTWlja2HDq2wgU2FsYcO8biA8bWljQGRpZ2lrb2QubmV0Pg0KPj4gQ28tZGV2ZWxvcGVk
LWJ5OiBKb24gS29obGVyIDxqb25AbnV0YW5peC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBKb24g
S29obGVyIDxqb25AbnV0YW5peC5jb20+DQo+IA0KPiBMT0wsIHJlYWxseT8gIFRoZXJlJ3MgYSBq
b2tlIGluIGhlcmUgYWJvdXQgaG93IG1hbnkgU1dFcyBpdCB0YWtlcy4uLg0KDQo0MiwgSSB0aGlu
ay4NCg0KPiANCj4+IC0tLQ0KPj4gYXJjaC94ODYva3ZtL3ZteC9jYXBhYmlsaXRpZXMuaCB8IDYg
KysrKysrDQo+PiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspDQo+PiANCj4+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L2NhcGFiaWxpdGllcy5oIGIvYXJjaC94ODYva3ZtL3Zt
eC9jYXBhYmlsaXRpZXMuaA0KPj4gaW5kZXggY2I2NTg4MjM4ZjQ2Li5mODM1OTIyNzI5MjAgMTAw
NjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L2NhcGFiaWxpdGllcy5oDQo+PiArKysgYi9h
cmNoL3g4Ni9rdm0vdm14L2NhcGFiaWxpdGllcy5oDQo+PiBAQCAtMjUzLDYgKzI1MywxMiBAQCBz
dGF0aWMgaW5saW5lIGJvb2wgY3B1X2hhc192bXhfeHNhdmVzKHZvaWQpDQo+PiBTRUNPTkRBUllf
RVhFQ19FTkFCTEVfWFNBVkVTOw0KPj4gfQ0KPj4gDQo+PiArc3RhdGljIGlubGluZSBib29sIGNw
dV9oYXNfdm14X21iZWModm9pZCkNCj4+ICt7DQo+PiArIHJldHVybiB2bWNzX2NvbmZpZy5jcHVf
YmFzZWRfMm5kX2V4ZWNfY3RybCAmDQo+PiArIFNFQ09OREFSWV9FWEVDX01PREVfQkFTRURfRVBU
X0VYRUM7DQo+PiArfQ0KPiANCj4gVGhpcyBhYnNvbHV0ZWx5IGRvZXNuJ3Qgd2FycmFudCBpdHMg
b3duIHBhdGNoLiAgSW50cm9kdWNlIGl0IHdoZW5ldmVyIGl0cyBmaXJzdA0KPiB1c2VkL25lZWRl
ZC4NCg0KWWVwLCB3aWxsIGRvDQoNCj4gDQo+PiArDQo+PiBzdGF0aWMgaW5saW5lIGJvb2wgY3B1
X2hhc192bXhfd2FpdHBrZyh2b2lkKQ0KPj4gew0KPj4gcmV0dXJuIHZtY3NfY29uZmlnLmNwdV9i
YXNlZF8ybmRfZXhlY19jdHJsICYNCj4+IC0tIA0KPj4gMi40My4wDQoNCg0K

