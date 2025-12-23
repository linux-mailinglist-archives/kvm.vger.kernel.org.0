Return-Path: <kvm+bounces-66580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 79443CD80CC
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C845C301FBDD
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3507D2E5427;
	Tue, 23 Dec 2025 04:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="I/walBpF";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="gwYyUdr7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554F62E0B5B;
	Tue, 23 Dec 2025 04:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766463869; cv=fail; b=T1uewpunN2beavvqfJSbzSpCGiAvCsakd8oq26JyaozY/S/q392lTm01QIzNWzAwnnKcPjgtwNov2n12cyO48ufkIN2ULMxWeei96z5yiN++aWPSQ4PsJCnxJ+x7OVJSgKStveJP97+DlF08jXQQlqLgIAHK6jQu/h1IM+70hgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766463869; c=relaxed/simple;
	bh=V7FphXoYiCZ5OhkJMDQsKGDBGFqlqFW0om8Ty2XmMW4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LLtO0H8NcqUX9yQjbgVDGdZEpyyB8SvgiY51Ljt3F69Z+jXfo3LAg7nn2BDerPX7MJK94gaRX2SgUhlrlwYWuRMlk+zyHs8RGZWiMB4wPDHCeNPfJ4UmGF7wrX8l2WZuTfqL8qwrKerNw8IiYBcZG+9d24M1GSRgjFxYJz0AaC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=I/walBpF; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=gwYyUdr7; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BMLPXdx3586348;
	Mon, 22 Dec 2025 20:15:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=V7FphXoYiCZ5OhkJMDQsKGDBGFqlqFW0om8Ty2XmM
	W4=; b=I/walBpF5v59maTLCFzm1wJy0qDxY5rbxqsR491kaSjEkIfSmbxqkY2x8
	vsZO9aYdF4LkiQDlRFpQpGay7tBVyXGT/Uk0ZKAFMYtnPyCQDgR1q9PkNANYzW7T
	IqwEHndVHuLyywb3j0X241YvKMIeE6qZtXnbIQNWncduyCpwyBaxT+bG75m7nHfy
	aLxwIa1I7nXnmSY9LcafROW7guoZXZmtrLgMXLWUKbiz3OCqewqYrel31rgoU5E/
	PLNbFNlfs6w3aEDt6vEFXk/zm28j7J9nNUTXn1OmvAv48YQ7sbJ4nTbDLdgk0xMg
	lYbMwhhVuKPLlweA5/QttDkOfeP7w==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11023134.outbound.protection.outlook.com [40.107.201.134])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5v7yvrf2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:15:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W08LAm42aeDNXpY+RaDVsuyNMucf86RWlxGOl3CFDRbNPdLeqWz+mEw2ulInXPZstYn//OGUG4QCTStYpk8sO4WfRxJxxKGisgX25BYvbfhyXtea0OkeibBt9dmKWT2oAdi+5fjKoaFtUVYyIEFs4mSMQnfF4Y2bbOIr/KsmHqOxYcxTeErWr4PG/woNL1T+Vcn8CtCzjhsiNNRmwh5CIAct8SNdOYjXIUA8orvgOy2yEyxV0Da6ywA3o+nWUwgOBnRk3ofOf4no01BwKa576jh0fNo1mYi+U793l2Reo77IcKyT8XwoV0NSJtXH2eZM+HuWdlRYsOYAZ5zKR2cBwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V7FphXoYiCZ5OhkJMDQsKGDBGFqlqFW0om8Ty2XmMW4=;
 b=EfiY+UUIuFpFukusLMwFRYtKUJ4RtO95zfPCn0MOKAIgLmj3nxCq8bQupRsY30ufoBNKvzU0CRugUO4YPTwM9jLMX9Ppg0XHiiCsBsceZzbpjlG3ytWh5Fv4kpSMW0EbVpvXg+aMT5iDPs34A5CHLa2FyH7pP0qKyGLY3etjCDPItl0Hqs6rgbJQIrm0gSk6eyNmrldiEXadrh6Gqw2IkhPuyh/6F9tD4a8o8n7d2J9pQm4szGUx8GvkRC43IZLWsv0VVh43WpqlK33U0+vrpDqchyTMzd5mXTJMmf8PgA5gzh4zWPQ5FvOmovR4FM8RgmrVsiN0qrkaNmvO2A2jJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V7FphXoYiCZ5OhkJMDQsKGDBGFqlqFW0om8Ty2XmMW4=;
 b=gwYyUdr7+STQuZEJiyVtKdaeFKXTrzjkeqa+xdN4H6zv9apfiawM3mYUYc/GSRVPMT3W787P1v7txcWJP4xQTDGG6Q9913fyqtn/RlgzGlBSNts1UHLxT/W+71IeW/uumaI6T0/xV9/UerhhxtuTGofDpjqKJ/kU6i9x8KETlozLprHrPF6kq5ZF0kh2/EvFdF2/0y+6B70vHIxFKNHLPfpWDvzk7jZDUQGG2PXKukFxUhj4C0uvgupICTAtLBMSqVYHiJ0pt7BhDGgVT1DGDWAx+6QUsLuuLrpVF8ZaXd/h3UXH5NE23aCNlkfsTNEg9yNG/ipzy5Jxb8W9aAjatw==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SA1PR02MB8512.namprd02.prod.outlook.com
 (2603:10b6:806:1fb::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 04:15:41 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 04:15:41 +0000
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
	<mic@digikod.net>,
        Sergey Dyasli <sergey.dyasli@nutanix.com>
Subject: Re: [RFC PATCH 09/18] KVM: x86/mmu: Extend access bitfield in
 kvm_mmu_page_role
Thread-Topic: [RFC PATCH 09/18] KVM: x86/mmu: Extend access bitfield in
 kvm_mmu_page_role
Thread-Index: AQHblFPzZbE3L8M/tkagt2HsJIwA07PPr9yAgACBBoCBYCwCAA==
Date: Tue, 23 Dec 2025 04:15:41 +0000
Message-ID: <1A77268F-2781-407C-A35A-693F3A41AAE5@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-10-jon@nutanix.com> <aCI-z5vzzLwxOCfw@google.com>
 <A72BD2D1-4D38-4F3E-B05F-A9002256BFBF@nutanix.com>
In-Reply-To: <A72BD2D1-4D38-4F3E-B05F-A9002256BFBF@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.300.41.1.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|SA1PR02MB8512:EE_
x-ms-office365-filtering-correlation-id: 315c4946-9b67-4ec0-7a08-08de41d9ef40
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?K20vZW5IR04yeTVIUVBxL1gxeVhINHdtZmg4MHlSbUYwUTQwTWxrcTVkSmM5?=
 =?utf-8?B?WDVReHlKdVdyYTFvRHd2R0x4dVRPTkFnN0xZM3hMcUorelFNYk40RTFWUE9O?=
 =?utf-8?B?NnUzUVBncE1ZdHJOMGlVUEhJM0F2ZkptcDdNd0c3U1ZaclpZUjFBTDJPRjk1?=
 =?utf-8?B?NEJMTEFMekV0bnJiQzhURGM5QjVkWE84Uk1ld0RYNGxveGhPdTRYQ0NRbUV6?=
 =?utf-8?B?V0hLSWpYc2tLSkVQZzM4bHNmMWx3bU9ybkhZRUtBZ0hXN3hpazVGNjZUSGlG?=
 =?utf-8?B?bjNWazVqRXdieXpsQ3hBRE1lSDhQa2QwTXpJcGZOR3hzVHBTOUZOaGc0Nm9T?=
 =?utf-8?B?Mm9lblZKYXBBUEZWSVNkZVNVNGNjUjlJdlNPcm44NjdVblNDbDhTM1ExU3Y3?=
 =?utf-8?B?OWZxcVUyWEphT1NxZEpNQ0EzcS94WXJGaktFZkZ5NDN2N2hvczdVTGQrTnVu?=
 =?utf-8?B?bmdmRSs0dUpMZTVud1FtRmFBZUJrbE1jZU5GbHo1R3dIaVowdXg2djFXNVJh?=
 =?utf-8?B?MlVFcDZFTGxtYkg2TDNtNExzQjJibDc4c2Q0L2NudzE0NFVaQXpON2kxcnh4?=
 =?utf-8?B?dFJJak93L216a2NTeWdxQzNZTTd1N1ZuWFZVS25mK3QwdGdlVHdXV2IyMHA4?=
 =?utf-8?B?bHg2ZDR6TnFRaWZYd2J2UDI1Z1crQnM5a1Nmd05ucFF3cG91ekEwcHBJdE5I?=
 =?utf-8?B?QTJjeFJJNWhBS3RvcU1Db2FCbEdnS3dMWlVYWFZvLzBaOWV3ZlBCdzlKbXVr?=
 =?utf-8?B?eldUcWpnb3FkVUpnanJhRmFFWWJJb3RSQUtmc1JITjZ2SWNhNGZ5dE56bmJo?=
 =?utf-8?B?SFZHWFJ1RUtGemR4WVBWVUtOb05iOTl1aFowYkw3K0xpcFhUU0htM1VmRCty?=
 =?utf-8?B?cG9WS0VHNDVRWW8vR0hBZ1B6MEdKRnJjcCtsREdBdzhvTUR4Y3lVTmNCbVV6?=
 =?utf-8?B?elVFYTEwaHduWGxuT0xmY25FcVRTalhIVmlvc1BENEtJREhDYms1cXBQS3NH?=
 =?utf-8?B?Y2dqSUFxSU83UVFNS1AxbnFyZEIvZVV0OCs2TUcxblVDSXZiLzVtaTZEUkJw?=
 =?utf-8?B?cG43OVFGcHNuSGNnekNFbVV6cVNpcE82TnprblV0UldhQkVaTGtXQjhrUEpB?=
 =?utf-8?B?dDRDMlJOUzhmZmFPSkFuMFlPb2hOa3R5SEJjVmd3S2Z6NHBCKytEWi9SakE3?=
 =?utf-8?B?ZnlVK2JZNE1xblRmNWV6QThWbWFSZU1hMmI3SzJZZ2tWcUFBN2M3SEpKS0dB?=
 =?utf-8?B?WU1VZFY4UU9WbG5uUlF4VkFpRkZwemRwcUdUNDZLYmxOQ1hlTFRlWk5rUGZn?=
 =?utf-8?B?K05XZk14S3VWb1NsNzBxbFdOZU9KdVo2RFhqeHlvUjI3eDFKUk1WRjhIQ2lp?=
 =?utf-8?B?V09HL1NsYU9ZL1NWYWJYTWZhckxGODE3cmJhWDJhR1g2eE51WERtTnRoL3dG?=
 =?utf-8?B?clcwclZ0RWlQV1dPejFGKzdVdFBlY0ljOHY0dVhLWmFKbXA3Z1pHVk5GeUJE?=
 =?utf-8?B?dTl3ZGUzYm9xdDdBa2Q0SGVJUlB0T0RZR3dYWUUvNWhHSFF6R29YZWVPdmc0?=
 =?utf-8?B?OHhqQjhCb2lRaXFYQXVMUlN2RUtUd1FhM0lkdkFJN2lQZE92aE0xa3BhL1hO?=
 =?utf-8?B?UW9reHZqellzT212SDljRDZrdDArYmtDWCt2U0tldkFFL1NyVWVPZVBSdVlp?=
 =?utf-8?B?MkFoTzUrNmFiTnhFWUZyR0FJVElPM00wMlM3UlNLeUJLRWFJRXArazg5VnRM?=
 =?utf-8?B?YUNCYzVMZTRJaGVxVDNZZTdFRGVVa1BMTFNjZHIzVzgzQkZIZXllQlJ2cjgr?=
 =?utf-8?B?M3pvdmxHYnIyNUQybWpaVVBLQjZFc3lmMjJvREZncEhrWnF6eXd6NThjRmJU?=
 =?utf-8?B?aHh1cUI3RExVSkZmTy9BenRXUzlNblB2VFZ1aUVSQlRxRXBjd2JyVTRIOGcy?=
 =?utf-8?B?czZGRmJOQndzakFuUWk4T0tST2ViUlhPeExiVkVKZzI3YWtlRXFtdXlENGhv?=
 =?utf-8?B?YzNUUFhZdk9IT05Ybi91dExLWk8vQ1A0VHR5Njl3S1VXbWViMjRmQm9SdDls?=
 =?utf-8?Q?rX2G9k?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UlIyZU9hRDdndWtFdFcyeGcrMURvT25LNkhWUjVadWc2T3RYb3V5MElZZm12?=
 =?utf-8?B?dzZSamM2YzI1SkpTUmNTNGpkLzd2cE9mdzFSb2c1dFZhNVR1ejQ4aTdiN00v?=
 =?utf-8?B?aHViVUtlbHhtQ3ZZZmYzcTErbGNmMUxoaFJDcktyN2VzR2QrZ1BCWkVFWmcx?=
 =?utf-8?B?dTZJUDJSMHFCNkVieU05b0ErSmZSUmV0aW1qa0Q3NGRoWjV6R2Jka3o4VW9O?=
 =?utf-8?B?T1V2OVdCUXA4VVF5VEJmdlY1a05HS09LR0MvdXFITWNucisyOUlnL2JGWUhY?=
 =?utf-8?B?MVUyVTJib1NRSXZ6TkhIOU1Bb3gwZjZsVWxrdjMrMUIvbVo5aEVBSEpFYkFK?=
 =?utf-8?B?WXE5dStiQUQ3MHV2WjdtR2pVejBEVzBuTjlpMDhsNnIwRlB0OTFjNy9oZnhk?=
 =?utf-8?B?akVkd3ZURWdMM1Z1Q0tlL0tjVHJZWC94aW5xVTVxczR3Z0U4TDNqZjRkUXlR?=
 =?utf-8?B?NkVRWFFzWis4Ulh2UE02QkFnQjJ4Z2QrRDRlSUIrcmpRL0tZeXdBSFN4MG1a?=
 =?utf-8?B?VDQxcXczVTVTd2loaEZCblhGdFRXRWVaWDlRWDBSWW9lRVhTZ3ZmVmd4aVdu?=
 =?utf-8?B?Ri9JVmN4SmE4azFUQm1aUzMxc3h5ckNvNDBFSWo3ZWVUcUNmd3pOY1RzbW80?=
 =?utf-8?B?Q0dnbC9JT3o2a1ZJeG8xano4L1JYQ2RRNDRGYkU4UUxKU1FFTHlvN2V5NFFT?=
 =?utf-8?B?eTRIZVBFU0ExUDh6OGg4bnJya2RTU2h6Y0xHcmx6SVFmYWFVL3VpQnVnTmQ4?=
 =?utf-8?B?T0JTWTRGSWYxdis1TXQwVW1jRTJOWitVRG9GdWdVeUtad2ZqRHcrajdYOFhx?=
 =?utf-8?B?a2FqUDdqTCt2Tkc5Nk5weHByeXV6Q1l4eVVXV25KMzFuaTY1ZVh6c1BydTlX?=
 =?utf-8?B?NGQ4Mi9FUi9iRjdCb05VSmNpT29PZFdMN0ZXcDc2b2duUzk3emk5VHQvQU9W?=
 =?utf-8?B?VUVoazZMSTBubEorZ0hJNlR6RDd1Y1c1aS9RbXF2eExYMW9PQ0htMDRQa0VE?=
 =?utf-8?B?dXl5ZUN2SWRWdFdyVDFXTFBHVW1aRFpIOUtyT1RJUlZGcFl0QUUvUFhPeUw1?=
 =?utf-8?B?OVBHR25kUlg2T1V0VzB3VkFJYVNCdlZZUkN0SW5UdTBQZlRjbHF1amU4eW40?=
 =?utf-8?B?SmtENTlTZDRiQ2F4VnV1dlg0cjF6d1l5ZHF0bnRQL3BpWWJMTGFnSE9ycGl2?=
 =?utf-8?B?Q3NBK1dKU1hBL2I5ZWhtMlZDVDZ2bWx3TXc1aDZaM0ljWldTNm55Y096OHdq?=
 =?utf-8?B?QjR5cHd3VTFVY0NjS25jVGhFdWdmRVVzTFVuUXR4TEJqWm4yUXM2c3JncTFa?=
 =?utf-8?B?cFc2eGNMYmxqZW05TFEzWm10T3pEaDV6SE1id2hPeEo2ZU1CT2R2ODA2WUlu?=
 =?utf-8?B?M2pjWWdmVDZwUk9PRkNlbmhpRFZ3bFFNeC9QWnlUMlBRWmZOQUgvR0VxM05Y?=
 =?utf-8?B?dk5yNmlFd1RJMGtnSGZldW5ZTEFEdDRFZTduQ3VxRTFZdGpQdEsrbG1TeG9K?=
 =?utf-8?B?QjZGT2ZvOERWa296eDN3SGJKWkF1L2lhUHh6TjNrNktBOVZvVzhUWVF5bFVW?=
 =?utf-8?B?QjM1aTdZc2hnTG5YN0YyUTc3dXU0Q0Q2czk4dHViZWhIdS9VeDk3V2ZHWmIy?=
 =?utf-8?B?Mi81Q3dvWFAzMjlHaUtuNFcvSFdGNyt6NXVpZlR0VHo0WlpVcFV3OGxHNkFQ?=
 =?utf-8?B?ZWRJRXpSY1RadnBHOHlrMlQ0elBWbEovcWRHZFhDbTBYcytPWVlqYVdMTHRE?=
 =?utf-8?B?RTVVQ0Y1ZFQ2WnU5YnpWQS9nRlJWVVZTNDg1ZExXWHU5WVBBaUxkamZBaDNy?=
 =?utf-8?B?UytwR0w2N04wVWhRREVrcDZITEgrUDRyMUUzVmtnRkZ6ajNYV1hTQnhpYzFB?=
 =?utf-8?B?TGNvWHBxdHdyNW82WFI5STNIM0xJRjYzMFp1cjZQb0hVWUU5NnhHWlcwZEJI?=
 =?utf-8?B?MW5nOGNVSXgrNHVMVnhiajBxV052YmFHRjJXV0s5akRRekZaSk84bFl3UEEr?=
 =?utf-8?B?aGNDYVhEL2t1Vzc0bDIvcmdmdkVyWTlwOHZycVBObGFiSzZEYUYrUUh4Wm1W?=
 =?utf-8?B?OCtQNlJSTm52K3JMSTVFTmE4OSsrK250QzBRZU0rdDQySFZxSE44ZDM2VEow?=
 =?utf-8?B?V0NHbkkxYU9sSlhOV1U2STZTWnBvc1lZdW1QSVBFWVEvL2xtRGZFNE1Fc1Jr?=
 =?utf-8?B?Tmx0SzlOZGNhTHRVUXJ3REpBYkVSTDg1SzFXWnhybXZJZVVIKzJRREh0Zm5F?=
 =?utf-8?B?TkJzMzFjejBHOUl6clBINTFVRFVkS2VKQTRnSVM5amcwYWZWczBUY1poQkhH?=
 =?utf-8?B?RHN3MWQ2b0c0WUI1RmF4ai8xOTVvNnZTeWw5Zm9xRUdLV1daaGF1Ui9hSElz?=
 =?utf-8?Q?95ahnTQifAd6+MJMw1DtIdQTnCVROCrT9IvQgzoLyYW4v?=
x-ms-exchange-antispam-messagedata-1: X3+6rGSPPkQiSxUP2ht0BZh6vdNXyaTlMR8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48DBE362192CA6428DEA4B1EA0B9972D@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 315c4946-9b67-4ec0-7a08-08de41d9ef40
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 04:15:41.0405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cdumg51yhvohdDjvr/20DeiohkqW4QuxEVZgFCnPSW+DNkrgcAxw96MzwfirpOCcqmHAYn6+OALIjPTMkGLoQGrcihMv6CeQFQR3TGfykaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8512
X-Proofpoint-ORIG-GUID: w_mHiR-raW2cNqem6eyKIFFunpteStjH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzMyBTYWx0ZWRfX8FaDPhGGftVw
 ncTja9LPYRgfMEmD4g49SeAFjLWQrnjCCmQPc3qk/h6FEuCyyWGSNd+2nBGx7z+9jiNH5/oX4YG
 n7JeqcWihrn9UjRxomHCj7yhodWHCrttOjw82bZrWmZkGPuk67GODCeEPkQl2xfdfzCqiyRdSuS
 4rC8egSjOCUXCIhBKBxIIZI/f8HnIgvFANjMJo1DJSPKxI1f4sSBEUnM4k2QYiR6O8i0/SKXJ/k
 Y73NCKS7PUCJQeZFYtvjphQQP8tV+xvwvQ89EtYR0ScdOhvTY0ZqylvlnOSR3wf+u/+4JsIa0zz
 K5vCzeJVwGfiDyQuG6YW7raizHX+vtno81pDboi98ZugKFV6LHLONaYdlT5YA2NjaUVVyODnsKs
 g+RvhoRp8GFNBeyyvHLVS6ZM0Ejp9CxTclIXxpRYBXk0Ad/bIL7uQjuBISes9mHRnWRkNCMFWBp
 94OHpmnnImxkpz9sB9g==
X-Authority-Analysis: v=2.4 cv=S8TUAYsP c=1 sm=1 tr=0 ts=694a176f cx=c_pps
 a=1BOVGqFqTWJq7wXoTNd6ow==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=64Cc0HZtAAAA:8 a=1XWaLZrsAAAA:8 a=WnAg_hP8hIc-RQk8H7MA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: w_mHiR-raW2cNqem6eyKIFFunpteStjH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCAxMDoxNOKAr1BNLCBKb24gS29obGVyIDxqb25AbnV0
YW5peC5jb20+IHdyb3RlOg0KPiANCj4+IE9uIE1heSAxMiwgMjAyNSwgYXQgMjozMuKAr1BNLCBT
ZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+PiANCj4+IE9u
IFRodSwgTWFyIDEzLCAyMDI1LCBKb24gS29obGVyIHdyb3RlOg0KPj4+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rdm0vbW11L3NwdGUuaCBiL2FyY2gveDg2L2t2bS9tbXUvc3B0ZS5oDQo+Pj4gaW5k
ZXggNzFkNmZlMjhmYWZjLi5kOWUyMjEzM2I2ZDAgMTAwNjQ0DQo+Pj4gLS0tIGEvYXJjaC94ODYv
a3ZtL21tdS9zcHRlLmgNCj4+PiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L3NwdGUuaA0KPj4+IEBA
IC00NSw3ICs0NSw5IEBAIHN0YXRpY19hc3NlcnQoU1BURV9URFBfQURfRU5BQkxFRCA9PSAwKTsN
Cj4+PiAjZGVmaW5lIEFDQ19FWEVDX01BU0sgICAgMQ0KPj4+ICNkZWZpbmUgQUNDX1dSSVRFX01B
U0sgICBQVF9XUklUQUJMRV9NQVNLDQo+Pj4gI2RlZmluZSBBQ0NfVVNFUl9NQVNLICAgIFBUX1VT
RVJfTUFTSw0KPj4+IC0jZGVmaW5lIEFDQ19BTEwgICAgICAgICAgKEFDQ19FWEVDX01BU0sgfCBB
Q0NfV1JJVEVfTUFTSyB8IEFDQ19VU0VSX01BU0spDQo+Pj4gKyNkZWZpbmUgQUNDX1VTRVJfRVhF
Q19NQVNLICgxVUxMIDw8IDMpDQo+Pj4gKyNkZWZpbmUgQUNDX0FMTCAgICAgICAgICAoQUNDX0VY
RUNfTUFTSyB8IEFDQ19XUklURV9NQVNLIHwgQUNDX1VTRVJfTUFTSyB8IFwNCj4+PiArICBBQ0Nf
VVNFUl9FWEVDX01BU0spDQo+PiANCj4+IFRoaXMgaXMgdmVyeSBzdWJ0bHkgYSBtYXNzaXZlIGNo
YW5nZSwgYW5kIEknbSBub3QgY29udmluY2VkIGl0cyBvbmUgd2Ugd2FudCB0bw0KPj4gbWFrZS4g
IEFsbCB1c2FnZSBpbiB0aGUgbm9uLW5lc3RlZCBURFAgZmxvd3MgaXMgYXJndWFibHkgd3Jvbmcs
IGJlY2F1c2UgS1ZNIHNob3VsZA0KPj4gbmV2ZXIgZW5hYmxlIE1CRUMgd2hlbiB1c2luZyBub24t
bmVzdGVkIFREUC4NCj4+IA0KPj4gQW5kIHRoZSB1c2UgaW4ga3ZtX2NhbGNfc2hhZG93X2VwdF9y
b290X3BhZ2Vfcm9sZSgpIGlzIHdyb25nLCBiZWNhdXNlIHRoZSByb290DQo+PiBwYWdlIHJvbGUg
c2hvdWxkbid0IGluY2x1ZGUgQUNDX1VTRVJfRVhFQ19NQVNLIGlmIHRoZSBhc3NvY2lhdGVkIFZN
Q1MgZG9lc24ndA0KPj4gaGF2ZSBNQkVDLiAgRGl0dG8gZm9yIHRoZSB1c2UgaW4ga3ZtX2NhbGNf
Y3B1X3JvbGUoKS4NCj4+IA0KPj4gU28gSSdtIHByZXR0eSBzdXJlIHRoZSBvbmx5IGJpdCBvZiB0
aGlzIGNoYW5nZSB0aGF0IGlzIGRlc3JpYWJsZS9jb3JyZWN0IGlzIHRoZQ0KPj4gdXNhZ2UgaW4g
a3ZtX21tdV9wYWdlX2dldF9hY2Nlc3MoKS4gIChBbmQgSSBndWVzcyBtYXliZSB0cmFjZV9tYXJr
X21taW9fc3B0ZSgpPykNCj4+IA0KPj4gT2ZmIHRoZSBjdWZmLCBJIGRvbid0IGtub3cgd2hhdCB0
aGUgYmVzdCBhcHByb2FjaCBpcy4gIE9uZSB0aG91Z2h0IHdvdWxkIGJlIHRvDQo+PiBwcmVwIGZv
ciBhZGRpbmcgQUNDX1VTRVJfRVhFQ19NQVNLIHRvIEFDQ19BTEwgYnkgaW50cm9kdWNpbmcgQUND
X1JXWCBhbmQgdXNpbmcNCj4+IHRoYXQgd2hlcmUgS1ZNIHJlYWxseSBqdXN0IHdhbnRzIHRvIHNl
dCBSV1ggcGVybWlzc2lvbnMuICBUaGF0IHdvdWxkIGZyZWUgdXANCj4+IEFDQ19BTEwgZm9yIHRo
ZSBmZXcgY2FzZXMgd2hlcmUgS1ZNIHJlYWxseSB0cnVseSB3YW50cyB0byBjYXB0dXJlIGFsbCBh
Y2Nlc3MgYml0cy4NCj4gDQo+IEF0IGZpcnN0IGJsdXNoLCBJIGxpa2UgdGhpcyBBQ0NfUldYIGlk
ZWEuIEnigJlsbCBjaGV3IG9uIHRoYXQgYW5kIHNlZSB3aGF0DQo+IHRyb3VibGUgSSBjYW4gZ2V0
IGluLg0KDQpUdXJucyBvdXQsIEkgZ290IGluIGEgZmFpciBhbW91bnQgb2YgdHJvdWJsZSBvbiB0
aGlzIG9uZS4gSW4gdjEsIEnigJl2ZSBhZGRlZCBhDQpwcmVwIHBhdGNoIHRoYXQgZG9lcyB0aGlz
OyBob3dldmVyLCBJIGVuZGVkIHVwIGhhdmluZyB0byByZXZlcnQgaXQgdG8gZ2V0IGl0IHRvDQp3
b3JrLiBJIGxlZnQgdGhlIHByZXAgcGF0Y2ggYW5kIHRoZSByZXZlcnQgaW4gdGhlIHNlcmllcyB0
byBzaG93IG15IHdvcmsgb24gaG93DQpJIGdvdCB0byB0aGF0IGNvbmNsdXNpb24sIGJ1dCBJ4oCZ
ZCBhcHByZWNpYXRlIHNvbWUgdGlwcyBvbiBob3cgdG8gcmVzb2x2ZSBpdC4gSQ0KbXVzdCBqdXN0
IGJlIG1pc3Npbmcgc29tZXRoaW5nIHNpbGx5Lg==

