Return-Path: <kvm+bounces-46040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00956AB0E70
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 11:14:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E7C27AC1F7
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 09:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F750274FE5;
	Fri,  9 May 2025 09:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="2cs4m8am";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ZHJULfbU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D6D274669
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 09:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746782081; cv=fail; b=X7xEEVjB5xtJ7LeafrB/VGa6XToub3q6lqD5sIj+4GMPCIO566d/UrdErT9fikeLryIyszDJAG1BCHb4isv1gIv0KErX5Euy6S5jsg8/KntFtjZyDUQrYu0KoiCn8Qrxs1PwqF6Dse9FXRszdQ2zbJmRavouUuOWGEhxZnsy48Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746782081; c=relaxed/simple;
	bh=zx6HuVPlQ2jO9YFGayEyzrnaM1tCKjWAJl3i3gCUk9Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DqQA+CdGAfxvpyuS59qFMJOYXrnvQrUbkC0OiL4zdC/7bGkWypZnjjscVm1Yfc0F7d8dEhmRM4dpXsK8jg56tIS6hbIyvmnSzU8SjKCEGJA59mHKTRi0+IPrZm5yAEZuSxNbA+YSoK8VW4Vf9vNWN2/4S0xsLg8ypwXkGJ7Ph5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=2cs4m8am; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ZHJULfbU; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 548KBmt4023450;
	Fri, 9 May 2025 02:13:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=+AcZwDsM/CV76w/hgkyKaXIylp9iwvf+hxw1Di2qz
	68=; b=2cs4m8amAss9z5dY1AyAeFxCfWLw1pJN72DCcP0RFrrmt1I3hLmXr+JhP
	xVYaE2Pl7uF3186jxeqylAZ0v7wYOH+gKv0SOUNsQl30o0FcvfVHec8h2cuGROSO
	Ehoy8xy+sF14sujCPNwBRedr+LH9M9q2tyzkYtJ8cdiNfmXQOKq7j8U16Ml1CCou
	KyH0fa0ZXwq2hEANW+njXW6m9nh6gShryxObLbgS+KLW9Fil2KqsHhoVikJ9/VTT
	hVlfkWxf4fVy8if26RtG04SQeBzZt2Tpn3mygfOAxSU9o6/PqLJwwSnAd7yH3UPO
	me4PCFtTQ8AcyaQma8uS8Rr3Um+Sg==
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 46djfce0n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 May 2025 02:13:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sXSvhzb6zBuUk5fbQ5kM78EsBzPSrMEGoAts1iR6ubKFUJfDyH4N15Pll7fWWoW8DXJBs2w725JrUWGd5VBu9dUBPqfraOGYY3/PhAGMFK6sFqMRq5yek1BDomDcrxSPnPS7wXkq39ZYjBmRWVdxRNkth/IAHwcfjn1mjHT5JPK286mNJGySQfYtHpZL7NHLDKZNzkZRKLkI/3H0Ex1/GkC/xxBvK0cO0VwAcP+VjurYHYTdPnRJ/zPopcZIbkBiN3nF6/sH6wSopTqtY3iNO1GCPStatsSW7nOMR7Px0JIKRwdB4qSPRWdIz0Rbpq/9Q6f3BfsnZOKn9Lh93p2G8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+AcZwDsM/CV76w/hgkyKaXIylp9iwvf+hxw1Di2qz68=;
 b=olqK5cLilsJww6wDoG7C4eAmK7F4OGUysF6KMq0mYrIqrE9svkhwf+A7X3hAkuu1qlPFx3q4yfozeyNzO9boOkiupSlNUsE/4Vf/1FZr4pQzqGQ23nVFkI2uEjkHnvomV+aLrYcu8SfYX+XMpnVXPDN/nL5ZwHKqaQHtJwU572lh9QN36jiHjDZJ/0kXctEFZDQonA34cKCUFkMKFUsl22VyaGkqj2Pyw3AYXDICkZOy/PLGKwuDmbkuapozSJFyBYbOkg1KahqVmCuOvVPEXz//ER77SZUee2C/qQp6kpOule0MiTN85YOytjn5grCi7971yU/sL3E0H5sgJcjRag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+AcZwDsM/CV76w/hgkyKaXIylp9iwvf+hxw1Di2qz68=;
 b=ZHJULfbUHCeO7txr7td9G/6JHteYa5Ees8uf6b1Y4ACtM0/oMyUx9E8RycNTkYRJxsVHJPvdujgTnKoWJFm9h9hEpYCewsSLdQY+xauPz0z2ynClZ0aItk3UY2yf826VKfDSr507vPWZIJc7EZzIhpVcEyu5wvMOrooSz+Wr1s5g5oc/wcayzEJIbd5FINxWGZy6IqfhjJL3ZeWS95tzQA518m2HHiKFN/OEJCp2OTm/eDhYzAkfTxtEsjaf6+mN+sFIqz36DTuGYUwjnWhfYbCcZU6du9SgW/ul2dabnnQyUTiM9SFp86+nzWWbstK7SGezm1mI2H/w3DrBg1U8uA==
Received: from MN2PR02MB5760.namprd02.prod.outlook.com (2603:10b6:208:10f::11)
 by CY8PR02MB9542.namprd02.prod.outlook.com (2603:10b6:930:78::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Fri, 9 May
 2025 09:13:35 +0000
Received: from MN2PR02MB5760.namprd02.prod.outlook.com
 ([fe80::3c78:4f18:e21:2b54]) by MN2PR02MB5760.namprd02.prod.outlook.com
 ([fe80::3c78:4f18:e21:2b54%5]) with mapi id 15.20.8722.011; Fri, 9 May 2025
 09:13:35 +0000
Message-ID: <2efa6e0a-72d8-491f-9684-c2f147fb0b00@nutanix.com>
Date: Fri, 9 May 2025 10:13:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 26/27] hw/char/virtio-serial: Do not expose the
 'emergency-write' property
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org,
        Sergio Lopez <slp@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Laurent Vivier
 <lvivier@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org,
        Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>,
        Zhao Liu <zhao1.liu@intel.com>, Yanan Wang <wangyanan55@huawei.com>,
        Helge Deller <deller@gmx.de>, Palmer Dabbelt <palmer@dabbelt.com>,
        Ani Sinha <anisinha@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
        Fabiano Rosas <farosas@suse.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        =?UTF-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
        qemu-arm@nongnu.org,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?=
 <marcandre.lureau@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>
References: <20250508133550.81391-1-philmd@linaro.org>
 <20250508133550.81391-27-philmd@linaro.org>
Content-Language: en-US
From: Mark Cave-Ayland <mark.caveayland@nutanix.com>
In-Reply-To: <20250508133550.81391-27-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR03CA0071.eurprd03.prod.outlook.com (2603:10a6:208::48)
 To DM6PR02MB5755.namprd02.prod.outlook.com (2603:10b6:5:158::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR02MB5760:EE_|CY8PR02MB9542:EE_
X-MS-Office365-Filtering-Correlation-Id: 223628ed-538f-4ec5-da45-08dd8ed9c65b
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|10070799003|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ri9VcHpmelg2OUpNNy92VlN3bnExQnQ1eWt0aWFmTjNDUGtVQWkyUG44cklj?=
 =?utf-8?B?NFArNUVta3N2QlNGQmNNeC9kYjRGdGJpdmEvOW5NR0xRWmpmdVNjZWlkbnM4?=
 =?utf-8?B?c2lxYWZIS3NvTzh1ZVhxWDlJYVM0V0RXZUJhZXd3RVVFaDc0UjQ2dmpROCtm?=
 =?utf-8?B?L1JLaUlrYzZFdGgzRFYyQy80S2E1YkVVZC9aVmxUVHRqcmJERlRFYndwc3pk?=
 =?utf-8?B?ZmwrWFliT3MvK0lZMlFCT3FqeGlXZVluZXRyZnFIQ1paYWc0aXgvbGprR3BB?=
 =?utf-8?B?YkMyNEh3YWQ3eEhFYzN4N1BsWE9GOWtWVXFMUTJhdSt6cTVPQjVaTEUwbU9G?=
 =?utf-8?B?QVNNYVRZd1l4cElibm05Q0FmWEJJZ1pRdjNCcEp0TThFaFF1cVdiT3huSjZ0?=
 =?utf-8?B?NHNoMXJEZFRqUCtQdDcvbFpGK0hpSDJyRkJCbHV6b09LU0pqOWZaT3JlSnZw?=
 =?utf-8?B?alF4ZGFjVEJlaTJyd3ZpbmIxZVB5S0ZkMnlIOTBLbXlielJGUkFXa0Iyc3Zs?=
 =?utf-8?B?UkhMVS90VTFxeklaRGtJMkNaaTduaFFGTVgyNlhBVEtFcnJpSUJ0L3hEQncz?=
 =?utf-8?B?OTRVSGpOV0dTcUg0WXpnOUhpOTRUMDhUZUJhOHVaOHYzTkFDVjZQY0JmcXdD?=
 =?utf-8?B?NC9JWDFWUVdaaEwwMEEvaUpCZnhuZFhPQ3Z0UldnY3h2dk4wYmR5RUorVFk4?=
 =?utf-8?B?emJJcVBrN2xHWWNUWGpZeitpaXV3TTljVDI2a3ZOYVY2NGNvZDI1cmtMV3RG?=
 =?utf-8?B?V2x0d1lyZDk5WGY5L3NNdU1QS2dUc01LbWcvZ091VUJhdnpIZHh1ZlU4TVJk?=
 =?utf-8?B?UHBGYmZmZEQzamNLNmVrWVV3OVRBUGsydWRiRnlBWDkxSDQ1bzJYZlJYb1ZY?=
 =?utf-8?B?dGVVU3MwUUcyeDJWdkthdTRrR0VVOUs1TlB6S3A1TTQ0aVBjTE5BL1g0TXZR?=
 =?utf-8?B?NXdsQXNVU2RrOG9UM1AxdjVmQ3FCWmpIczN2YXJpMEdwMHpzVXBJcFFyM25j?=
 =?utf-8?B?WWgzR0pTZjBVVzk1OWczQWlHR2ZWUEFKanhQbDVPQjhoWERNNlRacGU2WFBy?=
 =?utf-8?B?R0ZGekZNNy9uelJrVmdWQlRNZGtIbjQwYWErdkVBWWFzRmJKQ1FqN0dKODg0?=
 =?utf-8?B?MSs5NlFsdVo2SEl5bnZHU2dlMXYxdnA3ejQwak1Yd21vR0hKQVJSYWF4M3B6?=
 =?utf-8?B?cnN6UUljdFRXTGJ0eDh5SzZtUXl6UVo1M043U3ZJWDZIRERDaXVOVSs0aW9T?=
 =?utf-8?B?UTZMR2ZHSEZ0Sm1YZHZoWjFFYkRMUGpPNFhoTXNwd3YwUzNoZzYxY1N2by82?=
 =?utf-8?B?cGhGY3NwS2ZKamxFZEJvMXdrd0g4bWFOeGg0SUozenNkRHo2eTF1UzQzbmJu?=
 =?utf-8?B?eFRsbElNMGgxeFNYTURzTjJ1Vnk5d0x3M1RKVGZUN0t5VGIrM0Npcy9jcko0?=
 =?utf-8?B?YXFGVHpNMCtTZU1nL3NlOGEvVitaT3MxUGN6UTZnN2pXMkFlOHZrc3R2cDZX?=
 =?utf-8?B?a2s1T0E5VjJyRVVLdFZPSTVzVDUwZ2VsL0dyYmRjV0N3ZEhJVFozMCtMTFU5?=
 =?utf-8?B?TTNZVU9mOEQvcGRKdWlaTW9DZ2R2SXN4TTFWVENVV0l6TWdXQzUyb0wvTjJq?=
 =?utf-8?B?L1J4Y0ZCV0EyNTUwSE5uN1BRRGJBUDVZWDNLM29jWjFaQXNjMFQ0UGlwRXBn?=
 =?utf-8?B?YjRhWWN1NlRJTGxUeXZnZTJkVlV5dnkrMmtDc2YwK3lJb2JHc2RyUVVyMTVR?=
 =?utf-8?B?MTQ5ZlFBeHp3Y0g5emowajU0eER6b01ob1BjVXFRdkI4K0V2cnNxUFZkWitN?=
 =?utf-8?B?Z2lHZ3FnVCtRZVJBc2FEcU1GbnMybkRUT2J6SFpmQVZvS2JFeVV1cXJ3czF1?=
 =?utf-8?B?aTFDTVkvWXhaSUR5OEUvSDMwTDhjb3NJZE92d3pyY2ZiR20rcUtCQ0k3YTFk?=
 =?utf-8?Q?Hzn5FtCeASE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR02MB5760.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(10070799003)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHZMalhPSmFNVEEvamk5VXpnemI0Y0djN1lVZWJVZzRaaDVmYmF6UW1aRW0x?=
 =?utf-8?B?RkE5S21QK1hzL3ZLN3VwTU05QjE1TXdrT2ZOOEZyQzdBdkVPNkhOYnI5MDQr?=
 =?utf-8?B?MGYzeEpaaDhkVEFQeG5ONlBObEdKYUd4WDF3alAyRHc4aVIvQ0l6QzQ2c21V?=
 =?utf-8?B?ZkNTc3lmRXNzM0diY2VmRnh2RklGU1lCZnI5RWRLQjZQcHJCTUozRjhWUlBJ?=
 =?utf-8?B?ZXFZazVzLy9UTXA5VFRxaklNclJUVVU2bXEzUkU3LzVTNDR6Y0I4VGpMcmlN?=
 =?utf-8?B?cWNwZGMzL2Y2eUc2NmprSzlPOHhMOUQxSFFpMGo3UndFeTJwSnhML2JmUHlC?=
 =?utf-8?B?YWlZNWlPS0c2RVYycnlaOGprbWxhNk1WVmkyS3BqbmxlWE9ZS01EeWxsQzBu?=
 =?utf-8?B?ajNRUjlBbTJtMERiVGVQZ0xLRkF4VktDYXRBYktRNzBQOUZGb0Z0ZUdDMTEz?=
 =?utf-8?B?QVBCZVdtd3JabDA4R01FaDFUOVY3VW41SkxGcitwK0lTemVZaEJsdWIyOEN0?=
 =?utf-8?B?TllXejFpRnhySk9WUExtU3FyY1VndkpPRi9maUdPYnpLbzFyRklNRWF2RGk0?=
 =?utf-8?B?MTl4SnM5dVRyZXlyc0ZMQVVwTWZVY1Y2cWdON3c5NXVzU0lZUmpwem9QY21i?=
 =?utf-8?B?aURQQ2Q5dmFVS0o5bUJoS0RCTEdRTkRidDRnUk84M3N6UlpwR1lzcFVkRWsx?=
 =?utf-8?B?dGxPWDBLV0h4TlVsdkFha1pzazEraHdvUy9IZnBDZ001OWs3bGd3bC8zVllB?=
 =?utf-8?B?bS94Y3BMY0VrZFZZZnFHRUZvUktJWGVCdVNUdVRlRGErMExvNUNDSTdTaGM0?=
 =?utf-8?B?eTBsdkpHOHU1VmZSWmF3RTJDY3BHaEt2dlRiZ0llRHVsSFdGak1URXB3VkR2?=
 =?utf-8?B?NXVPb2tPVHJ4TjFqaDF2L2xNWUt6SkJWK3NacGNTaVZ5ait4TTlCU2RPYnNW?=
 =?utf-8?B?OEp2Mk1Yb09ObmwrSTJaV2Z0Qk1JSDc2UUg5dk15RjNkR1k3VVNma1hCd3dn?=
 =?utf-8?B?ejhITUZhVXBQYlJKczM5VG45NktJTjhZUC8vcGJKRDBLcmlSNGhSMXZKRU9M?=
 =?utf-8?B?UDBVb3lkODR2cFp2Yi9TSGZXR0twR0lUMFJVNi9lekdxU0F6M0cxRlhtWU5R?=
 =?utf-8?B?MU9SRUZQYVF0dlpIOEhvT0xoNlg2RE1ZSUtseHZCc3pwUS9HN1liT2tTNDBL?=
 =?utf-8?B?Z3dZOVNrTGcycFFhNkRNQjFlK3ZmUFdBZEN2MEJtR0swd3p2QXQzS0lmcDNS?=
 =?utf-8?B?ZnNvVWZld2F4bU9JRGlZVDdFRU5ad0dLdU11em45WmozNXZEUm9aZnc3Sm1S?=
 =?utf-8?B?dlJHb3QxbTJPN09xNHdxSU5KR1ZSeVptZElkUjF2YkZ0czFXK0lDTXQrRGxU?=
 =?utf-8?B?TUdkVEluSlR5SHduc2sreE16QWhvekw5cmRvT0hBQ2I1UUNacmhRL1NaTkQx?=
 =?utf-8?B?RTlTNDFvcnM1S05QRDhwZktLdWp4bDlKMXRndW1xeVBnekpqOTI1ZVFzYzBq?=
 =?utf-8?B?L2JhYWwzaHJyUUladXlKeWFlMGlWc2dZVWRQUHpiOHYwOTc2T3MyYW0wTnc5?=
 =?utf-8?B?M1EvQkEra01tODNONkFyWDRiL3ZsU3NEazNlQmdXY1VhTlROQm8yRjVjMXh6?=
 =?utf-8?B?UTBjWTRlZll1bHkwVzNjaG44Zmg0UlNPWVFWS1Y0MHAxckJRbmNHYWc4bWlu?=
 =?utf-8?B?K1lnSE1tcnZkMUtLV2lNUTVseDVnd3hqQ3ZPdFNDUHQvTGM4cTk1TmVwSzJq?=
 =?utf-8?B?RG9UTjVCdy9qQSt6Z2IwbXJadGZSbjZZZmJMYWpSUDAvRE5hWVpwUi9QclF3?=
 =?utf-8?B?MGpuR0E0WnpObFM1M0htTzU4bXk1UGkrblBNbVh6SEpod1dlem9rajZ5N1Iy?=
 =?utf-8?B?QWZZWEU1THRKL0gvZ05Ua0tsMERSM1ZyZXMzQlEvYmpXY1V2KzBtdmxUNDI5?=
 =?utf-8?B?d1Q2NjMxWXozWUpWVytqZ2lRT1I1Yzg0RzNiTVBWT1g1dkl5TTFScnBtRHlu?=
 =?utf-8?B?SkovMHlmQWI4YkdhZExpS1JmQVNXZHlLY3YxWmlva1o4RXMyUTg1d3RCeHRx?=
 =?utf-8?B?Q1JobWdnZ1Z1ZDBhZisyb3Rxd21uSWR2bm5tejVyTjk5RzJKVmlPSGYxTmRQ?=
 =?utf-8?B?alpXNmJtZVJjQ25uTjJId2tnTnhvcWY4V2huNzlqWmlsbjhHZmFRbkF3Q1NX?=
 =?utf-8?B?dWV6Q09zajNqR0VFcnFyZlgvK2Nha3Uza25rNDVQdEtPTnBOZXMvUWVaUk5w?=
 =?utf-8?B?UDJhcDd2QVZiK21oWFhLN011N2pRPT0=?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 223628ed-538f-4ec5-da45-08dd8ed9c65b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR02MB5755.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2025 09:13:35.3456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7fHlosuP4CtteL2vXHkjuDCSPj1KG6y/yzzOqgjHUEGv8V1YWNB5PNLhfmoCAoJiqErBRjP/gZlMt24BERzmUHdfJu8PbzyqmnDOjOQxxq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR02MB9542
X-Proofpoint-ORIG-GUID: Q_frSyAT3gSrZuz_-Tk8W6kh1mEO2Nhf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA5MDA4OCBTYWx0ZWRfX3gSFsU2ybG/6 2bjLnTqvvvUDAVPy0tpsdkXW9uyRaMYFWySxrGDIyu/xssS2B29gpZFW3JKGYcDuojDoUp49zE3 2260GqMS97aHyAlgQIABDy8GW9M5Ejznr5n7BAjNicPfRMyB8qxPt4b9YICVdFMd+YdnNyDhY6O
 YVJ9sr21vipa5k52cDOgNviDY3g9KVmklZew63IpepEnbGJ9rWxCdjRdyij030f1fWyT1ZwRmII Ps0LpWQ/bdjQ9SUnC7oqY3W2RLol7xcF78CssdIGEeJjZUOhFJ0HqLmq/V6D48Om3nYb9MPuXK9 1VHG8Com7IhVXXhK+VZmpJXisWviXctorw8y91vA3Zicg8ZuzFu7HOgepmAYlkOesy1Oy/56Vvw
 BfTeqQTcofPRsgUCiaJmHtQuaDyFOevvmch1hrJJBxEEDBGfmQ0kEtul5sYIqkZOvcvqvfbX
X-Authority-Analysis: v=2.4 cv=Bu6dwZX5 c=1 sm=1 tr=0 ts=681dc743 cx=c_pps a=Dwc0YCQp5x8Ajc78WMz93g==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=KKAkSRfTAAAA:8 a=64Cc0HZtAAAA:8 a=NroRDp64RXCMFiFBd8UA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: Q_frSyAT3gSrZuz_-Tk8W6kh1mEO2Nhf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-09_03,2025-05-08_04,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

On 08/05/2025 14:35, Philippe Mathieu-Daudé wrote:

> The VIRTIO_CONSOLE_F_EMERG_WRITE feature bit was only set
> in the hw_compat_2_7[] array, via the 'emergency-write=off'
> property. We removed all machines using that array, lets remove
> that property. All instances have this feature bit set and
> it can not be disabled. VirtIOSerial::host_features mask is
> now unused, remove it.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/hw/virtio/virtio-serial.h | 2 --
>   hw/char/virtio-serial-bus.c       | 9 +++------
>   2 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/include/hw/virtio/virtio-serial.h b/include/hw/virtio/virtio-serial.h
> index d87c62eab7a..e6ceacec309 100644
> --- a/include/hw/virtio/virtio-serial.h
> +++ b/include/hw/virtio/virtio-serial.h
> @@ -185,8 +185,6 @@ struct VirtIOSerial {
>       struct VirtIOSerialPostLoad *post_load;
>   
>       virtio_serial_conf serial;
> -
> -    uint64_t host_features;
>   };
>   
>   /* Interface to the virtio-serial bus */
> diff --git a/hw/char/virtio-serial-bus.c b/hw/char/virtio-serial-bus.c
> index eb79f5258b6..cfc8fa42186 100644
> --- a/hw/char/virtio-serial-bus.c
> +++ b/hw/char/virtio-serial-bus.c
> @@ -557,7 +557,7 @@ static uint64_t get_features(VirtIODevice *vdev, uint64_t features,
>   
>       vser = VIRTIO_SERIAL(vdev);
>   
> -    features |= vser->host_features;
> +    features |= BIT_ULL(VIRTIO_CONSOLE_F_EMERG_WRITE);
>       if (vser->bus.max_nr_ports > 1) {
>           virtio_add_feature(&features, VIRTIO_CONSOLE_F_MULTIPORT);
>       }
> @@ -587,8 +587,7 @@ static void set_config(VirtIODevice *vdev, const uint8_t *config_data)
>       VirtIOSerialPortClass *vsc;
>       uint8_t emerg_wr_lo;
>   
> -    if (!virtio_has_feature(vser->host_features,
> -        VIRTIO_CONSOLE_F_EMERG_WRITE) || !config->emerg_wr) {
> +    if (!config->emerg_wr) {
>           return;
>       }
>   
> @@ -1039,7 +1038,7 @@ static void virtio_serial_device_realize(DeviceState *dev, Error **errp)
>           return;
>       }
>   
> -    if (!virtio_has_feature(vser->host_features,
> +    if (!virtio_has_feature(vdev->host_features,
>                               VIRTIO_CONSOLE_F_EMERG_WRITE)) {
>           config_size = offsetof(struct virtio_console_config, emerg_wr);
>       }
> @@ -1155,8 +1154,6 @@ static const VMStateDescription vmstate_virtio_console = {
>   static const Property virtio_serial_properties[] = {
>       DEFINE_PROP_UINT32("max_ports", VirtIOSerial, serial.max_virtserial_ports,
>                                                     31),
> -    DEFINE_PROP_BIT64("emergency-write", VirtIOSerial, host_features,
> -                      VIRTIO_CONSOLE_F_EMERG_WRITE, true),
>   };
>   
>   static void virtio_serial_class_init(ObjectClass *klass, const void *data)

LGTM.

Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>


ATB,

Mark.


