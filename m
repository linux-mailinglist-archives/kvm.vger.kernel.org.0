Return-Path: <kvm+bounces-61685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B598CC25173
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 13:50:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43D201B2128C
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 12:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BC0B1E9B0D;
	Fri, 31 Oct 2025 12:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="sKbXN0G6";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="uli7V4gB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44883CA6F;
	Fri, 31 Oct 2025 12:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761914865; cv=fail; b=cqOOd8lC4zNiR8XemKjjP0Ip7T3u7FWzvPbDA5XLmWqhgDhN61yYtmH3UndMuRYPt7STxdIvWVDIKl/HRxFWtThgP2u42ZdqImDD1PqnDF8E0hTD0nEkDbkTIxk+ovL0riBp1UcdafE9BHV/tzE3CQAJ2RBvc03R5jVnTN4s00Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761914865; c=relaxed/simple;
	bh=YSl72r9YPOMTXo9LmAR1R6bBncCeX7JLcldgcGHYycc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JLythnE+G394nkIMB941FZ5NxaA0qMnWBWjUfa3Yu3BOrWoM35VChoPjOUfd73CPcsrpDSHqJOclHoHmN8vDyaGAtmzFluh5o/aZd7aMD9k5O/KA/JrpNQr0qDG/oozm5G1PdrVpseEb1Xf4YzSQ0sKCBwQTojsYlQ0Ht4wq5yQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=sKbXN0G6; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=uli7V4gB; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59V7woW03700474;
	Fri, 31 Oct 2025 05:47:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=YSl72r9YPOMTXo9LmAR1R6bBncCeX7JLcldgcGHYy
	cc=; b=sKbXN0G6+1UYtm2Bko+3onntI+Mw9P0u3ZSCbSM56qByvplhP8PBtb2eq
	ghlDOriPn8y/g1QtVUCkpN/prCCW025dW4y2RpuSv0bBxPXtLkQ0xe+6qnl6f9eE
	iecw0tcjpv60BSX0pjJXDFa1u6aGnpg5mN8eLHQ0nYQMrgbDmz8LaNtj77L6wpA/
	1adgums+bngREqjx20fNl0PqLXn1MW/F6TmSqbqRjnrofiyWu5sb+/WW9sACchzv
	pmDg9J0cF4QX3dx5L79gi4XKYQrh5lVix8H6NAc6CTrFSuIqOa0GeiK4mhmg/j1c
	dhQgpoPStrkRyRFMI4G8H+OiSSk/g==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11020090.outbound.protection.outlook.com [52.101.46.90])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4a4s4v0j9r-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 31 Oct 2025 05:47:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WYmRlpMpXnMudN9Q61TQ3S5l+8JC35OHaSQzKg994UVAe3ouSL2651JAxD+InNdy7erayLA7qjxPaAVv9XryA1KP5Pms4SUXPg38lapkMD9QkvXEVBydSCd2Zi8wHH6vrL/gTjGyxqG32z5l0cLrfECmru0dqkkcHts9EAtgQpRNbQteGQOEBo51qTbh5FI733iUYlIdTj8PuocJOndRAH58zjUoBfxQmk1ebBVODxjPEQkaQB+g9Mp+mheax9uI6k4eNl3WzKKVSkB+EkzZlKeZQ1saOy5ryCXvmFbBCnifM9962LQXtBTH7E8Anaq5o+yiE6fVtl5O24zhds5ijg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YSl72r9YPOMTXo9LmAR1R6bBncCeX7JLcldgcGHYycc=;
 b=lXNIljx/dfsfS+PcUj8B9MYdwl/dlMglBgeP5ZvkqhcFxGhOYosTMnD/fbpQgDeEi0ZyxYQgm436phX08jDY/0X7iVpDcB9HHgKtxFJ0OHa87JLcbZwS/8FOgQB1S77wzkfz8G0tuwp1Yh1SW8J8OizYupmk25E9VIZfyHkWF6CRO/vb6VjvHifc74MXL9R/MMaSai75MZvYw2xPCdMxxF/sCXqogjeZUsiTEgDAzLRm2huGoy5DdwN8XfDyUCKJMHD0/OfIcw/DgmfxQzGlbYZT0XTECyt/I26OFGpHSK2KOirKDWSrAuOnbHVxpeqUdY7SR5DtmG4USU268NiHYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YSl72r9YPOMTXo9LmAR1R6bBncCeX7JLcldgcGHYycc=;
 b=uli7V4gBvRq0bEm2R8cwgAhope4WO+HSTJ4AzGYjeRXFl2VoNmZ4h2lGcvEzrPu3+PeBy6Xm8dwa6MaPNx02+Vn3KzfE3xw1s7PISIL6EIGphtpq8O2zQiT18IN9Sx7ruKJZAn+Xyv7w7iNRgknUlDXhGlfzilCkZt+BtGc0kTo7d+MAnz05BnuR7CBIK0KXIbqOw+yFjUpZI+8jUmGXiQ/cTWXKciG48N4Z6p2c0BjY6Wpb91HK37/HLr8Y4+XwMRwYSYTYLdRhWOeLp/W/Xf5zsthWbM1ilEY8H0iCbX++sGZ69sDKJ32L/2s/nGmgShWY+zx5a1faVHvPWpDcRQ==
Received: from MN2PR02MB6367.namprd02.prod.outlook.com (2603:10b6:208:184::16)
 by PH7PR02MB9340.namprd02.prod.outlook.com (2603:10b6:510:271::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Fri, 31 Oct
 2025 12:46:59 +0000
Received: from MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328]) by MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328%5]) with mapi id 15.20.9253.017; Fri, 31 Oct 2025
 12:46:58 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: Jon Kohler <jon@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav
 Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
Thread-Topic: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
Thread-Index: AQHcKLOgBGqDS4wr/EWm+kbhH0rY57SfxJ+AgABfUICAEG1YAIAhZQKAgAqBJwA=
Date: Fri, 31 Oct 2025 12:46:58 +0000
Message-ID: <EFA9296F-14F7-4D78-9B7C-1D258FF0A97A@nutanix.com>
References: <20250918162529.640943-1-jon@nutanix.com>
 <aNHE0U3qxEOniXqO@google.com>
 <7F944F65-4473-440A-9A2C-235C88672E36@nutanix.com>
 <B116CE75-43FD-41C4-BB3A-9B0A52FFD06B@nutanix.com>
 <aPvf5Y7qjewSVCom@google.com>
In-Reply-To: <aPvf5Y7qjewSVCom@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR02MB6367:EE_|PH7PR02MB9340:EE_
x-ms-office365-filtering-correlation-id: b4414bdf-fc28-4973-fbe8-08de187b94c4
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?OVlzdUlFQ0xKTUdiam1wbFBPUmRPS2MzZFBzckp1RHZPWk04WnNOWjNLOE02?=
 =?utf-8?B?MlVWQ2liNzdPVjhLTzR1RExJTHRWUmNvVktGZUVyT25oUG5uSjNiU3JZZnBN?=
 =?utf-8?B?WE1vVkh2OWsxcWUrL2RkWkhrYUtWVXRpc0NTOCtvTCs4aWJlcjJwSUtWV1l2?=
 =?utf-8?B?Ukd3VHNJL0xnbVhoMnBWbEtVOEtxcjhQdzFGdGhaRmk4VkhCMGlwY29pOU5a?=
 =?utf-8?B?eXo3Q1NJWk1ORXljdDRTT0hZT0ZpMXB4VXB4SGJTcWNJWTJlZSswemd1YWUw?=
 =?utf-8?B?aGk2cno2WWwySHkyN0pxeHJ6ZzZXTVI1b0svY3VhYWl1M2F5RC9sa2hwSGFX?=
 =?utf-8?B?THYxUGs5ZGxCbWUvSCsvVXEvemZIQXJ6K0swUTMrU29ORFY3ckMzVEhDTHBN?=
 =?utf-8?B?N20zNlhHek85MUNEOW1CRVBaOVZyK1IyS2NTMThQTnM2UjlST3NGclhWeUtr?=
 =?utf-8?B?R2Q3Mm1EaWdjWjdGeXd2bWF1UTZWM1hhYWZEU256L0NiWFpHY21NSFdQVnll?=
 =?utf-8?B?WXNyaFNZdlZiMENrc3ROSUttRkhXMVk2L3U5bTM1c3B2T3Y3S29LcFIyQitO?=
 =?utf-8?B?Ulh0Nk9tOWg2T3JNZTh3bTZoQk9jUUwxK1ViT01FdjZzaTFYdmxMaEpZaHk0?=
 =?utf-8?B?dHphUHNpSm9wbnRtSXc5MnU5bE5rcWdIckZYZ3ZKYkJSV0wyRHBLcmdRcU5H?=
 =?utf-8?B?YnR0TmcwU1NpOHlXMXJNZzhpWitkTDhUZzFBR05wd2dqc0pld0NaenlLc0I1?=
 =?utf-8?B?SVY4NG14cExKbWdnempONW4ySjdjbG03QThLdGo4NUQ0d0JpcUxXTHo5bmZ5?=
 =?utf-8?B?dFpNazd0cEsvWEIxRXhndW9hNDVmbEdWemtiNmduam5PeHlCMUkxL3BuOVJ6?=
 =?utf-8?B?T0doT1poeVZRVlMwdFlMY3g3VFZkRmJCR1RqVzAyb1NCeHJzYmY5Zk8yN1Er?=
 =?utf-8?B?Mm4yai9USmRKcjBXQ1ROa0x1UzFPUzRvbWcyTXFPdnBtWGozZHVEdzlEWndl?=
 =?utf-8?B?Y3JLdjhTMGF6WkZNcC9aTVlIbjdIN1FMTGw4QTFhOVNMNXJlemV5Q0grWVU1?=
 =?utf-8?B?OE44Rmw2MVk5b2pJei9STEJsYmIxRHR0K21vVlhiM2d5RkkxNUJSSHZmT3Jz?=
 =?utf-8?B?bGc1R2ZrSkZkTlVHMnhRYjA1S3diZHZSdzIydVg5UUpvYXdQa3RhVklqZGxK?=
 =?utf-8?B?bWJTMlE4OUdxL1NYcGU5VmZBdkxJa3k3c2tERjQ3MTd1RmNvV2hiaWFaRnBS?=
 =?utf-8?B?VUtiOTZaRDFMdDFhYUNGTm5EQjJYTlRaL2lMYW9DQkpia05iK0szZzhzWVl3?=
 =?utf-8?B?RG9OT2FzVXhRN21ZVU1RZ2daRXJuVC9TYmJFQSttUllTaVNDcGVncnlPcmxn?=
 =?utf-8?B?U2hJWE9OTVlLc1gzakpqS3Z5SXYxNDdnY29mVS9VU0RJSWVITXRLT3dGRjhi?=
 =?utf-8?B?UjRPUUFIWDg4eHB3OGlRRUZIUC81VjdXU0Mxa3pSSWpqeWR0QzdEblo0RTJy?=
 =?utf-8?B?SGl0S2VNZlVxRVBQTXpQdEVpYzFWRDNJbXFQN3BvMHVJU0FOWmsydzhNS21U?=
 =?utf-8?B?WExFeXdNeWdoamZPZmFtYUN6dmpDM0M3dy9BdnNuWWJ1MEU1NStSRUhWTk1U?=
 =?utf-8?B?RFBmU3JzZkNYeERKRnlRNThjSEZKNU11YXcwanVORFFCdGFzTTJtQXpSOVpQ?=
 =?utf-8?B?Q3RFSDRLSUhudnVKSHpjZ1pxbXVBQkY5M2lnRTgvanV6QzRHWVh2cW9VUXhl?=
 =?utf-8?B?RUkyYUZQS2VyajhHUURQMHBoZklqNXVHNTlvVnJGUUtVZlVlam4yKzNBU1lH?=
 =?utf-8?B?SUpWZ3lKOFVZak5KSk9ETGJvSHFJVWMrNzJpSTFreWhCdHp6NndmbFg4dHl3?=
 =?utf-8?B?RHlIREF5ZzFHZGJCdWxBdHFtZFZQTHJhVVhHZnMvUTJ0MUxMT2NPL0VOUHRP?=
 =?utf-8?B?RVdCM3JPU0I2ZGFwdlBrT2M4aHB2Qm9EdThzZXppbGt1Z3FnYklMWFd6dmVs?=
 =?utf-8?B?QWNYWGM1cGR6R3EvZ2t6VHVGcDJ1RmJHdHB3YUhEK2ozY2tTekZnMEtBVVR4?=
 =?utf-8?Q?/Fjm+Z?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR02MB6367.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z1RxY0MyT3ZjL0VCdlFRNTlCcGNIOGJtS3ljTFJEc25GU21sRGZXZmpkZUVK?=
 =?utf-8?B?bmE3RCs2YVFQejJkQ0ZOK1NLTk9CcFlCa0xvVmlRMXFPMldwQVFsaHB1M0VD?=
 =?utf-8?B?Tk14VEFaYXAwTHNGd0tPZWgrNWpuT1lkVnRPbGg5OTVzNXNOMnVpeVEwV2dp?=
 =?utf-8?B?TzVCSTh5dE50aUp1UG56c2IySGFrcUlMTkZ3bDNUOUNUckZQSDN0SlFZUU9Y?=
 =?utf-8?B?SUpzbk1XL2lPOUJUbUU2OFdiQVQ0QXhVTUFINyt4aGVWQWtmbGlHSlJTMWZo?=
 =?utf-8?B?WWxuWE5PdDdGQnp5Wm9FOE5HODQvbGdyRHNyVnBxYmRma1Vmc2IwWWdYRDhs?=
 =?utf-8?B?S01PMVZQTllSd0IycFl2M3Nnelh0c0h5QUFIbTVVUHIzZFJTdEpFa1dRUTBs?=
 =?utf-8?B?R2xCY0l0cGdWVjF0ZXc1VTQyV3p5UDhzN1JqN294dXdDODBTeWJxZUd2R3BL?=
 =?utf-8?B?MzZIZmtoUllPQU0wZ3RFcVQ5U0t2cDNPYUxTaGp0MFd2UGVIVGFsR2pmV25a?=
 =?utf-8?B?L3JxT3hGQVdhOEsxOEYyZUc1MVAwakxZaUFOeEZNTzhpRG13Tk9oK1JUY1Ax?=
 =?utf-8?B?S2FzNy9wMm1qbHFwZlNrR2Y0amp3VHZsZEw5cWRyd3lydkxXMEJwUmptV1ow?=
 =?utf-8?B?Vkp6ZnNicXU1eXZLK1lqMndIRkVWZWRFY2h3d0NlKzR4TzRSZks5UExxZVh6?=
 =?utf-8?B?OEJnMGdEbDAzbEtaYXUvTHpFT3pwU1VRVWplaWtpRU9xTGpuME4xMHg1bjhm?=
 =?utf-8?B?S2Y5M2piTitDREZXOUpIUWNPL0krMTQvZWM2eDdHYUpUd25iT2xDcnNxVWVF?=
 =?utf-8?B?L2tRUnpVdGtWUmJINlJNd0RmK0JKZHY1cGlvNnBwcFYwUWI4K2FXWU02cmpP?=
 =?utf-8?B?Yy9BNGszYUFMYjVrY3RJNWM1c0JNMGRpa1QrdHdoZSsxVzNHZlpLaGl2MU1m?=
 =?utf-8?B?ZzQxY0Z3TVV2V3h2b2c4RmVra1FDMENNaVJTWlVPQmFJa2pjRkxsanZUV2gw?=
 =?utf-8?B?WmJqWG13SFdUd1ZSQzJpcjdHRlJyUHR6VlQ3ZHJZNnBHQlRNWm1uQjM4aVpY?=
 =?utf-8?B?ck5oMTYybkUrS2Y1L3kzei9jUytXVFFxOGlYNERjSDdoNUQrWkNmT0ZXUHEw?=
 =?utf-8?B?OFNMOHMrcFZUQmRDVW50REhtbnRuN0N0RFdMbkR6ZHhlMU5mQytrZDd6M2Ir?=
 =?utf-8?B?WUZxZkFwcXM1Vm5uNVBHeU1NZzdia2wyOUoydVBLUEdWa2VyamVFbEVhcldl?=
 =?utf-8?B?dFI4REt3em9nSFFjekhsaE9IU1BYZ1RUTkFBQVdOb2txREU4UXV2OU5jenhS?=
 =?utf-8?B?N0FhSDlWcE9nVnA0R3dtcXZWc1lsOTZmS3AzT1ZVSGQ5bjF1SllLNVp4M1Jp?=
 =?utf-8?B?c0JMMktlSnkxbWk1OS9IRFp3dEdXWGtkdlMzNHN4bUQ4UTdVcWc3TUZDR3lk?=
 =?utf-8?B?YWhvUE9DL3g4cnFxQ1dqRUwvSm81TE1oMFJGZ0hZdUdEN2RYWUtjcldReTZV?=
 =?utf-8?B?WG5zdmZ3dWErZ2dZOFFnbnpYWWFnVktyQTNGUFFpcy9ub3lyTm45T3dTNzNn?=
 =?utf-8?B?VUlKMkpvMUJTcTRCdkN0WTk1dE1ySnFTVkdWUXJIMVdEclU2RFhyQllaRXJP?=
 =?utf-8?B?eTNPb1pPS0Z2VjlzZndJa01BcEdTVGNEMThDYU1kL0lvTFEvTFhhUDcxbnJ2?=
 =?utf-8?B?dnlQK3ZXaXF1UTVnbDJzTGhJSlRFdkhVUzBoVjY2T1Z0V2RueVdzTENqNEho?=
 =?utf-8?B?MVc5d2ZENmh4VjNSSEtqNW1uU1NLVkRnakFvQnN3QnlReWNEU01CZDRyN2Jv?=
 =?utf-8?B?MlVQaGJ5RDZOdDJpYnVLTjM4WjZyMUpiMVV5QkVVa2FoMko2elB4dVgzdU03?=
 =?utf-8?B?bDl5eTRtaEphUWpuRVZpZHREay9jd0g1SGlYNUhkcXVwWHlOUmJmTnppZ1JI?=
 =?utf-8?B?a1haVDNXYitlMVpUWTFVSTJRN2FWQStiUm82M2UrMFJ6b2RreVJDOHZBOFlR?=
 =?utf-8?B?b09SaS9vV2V1aEMrRkJzRE1NZzNRYXU4ck5NQmxEMTlNU0FyV1F3N2xydi9z?=
 =?utf-8?B?UXZHVGoxd3ZsdHFvWm94NmRoVkpvdTc5NDczVmhqMVhoQ1hqejlGblNqeXVG?=
 =?utf-8?B?M0l2MDZqamxzUXNzeStsLzRTeDU2UCtHWHNYVDhmeTFJaGdkdzhmN2RaNnpY?=
 =?utf-8?B?Y2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EA80A950DA24E24993DDCCE6543F081C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR02MB6367.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4414bdf-fc28-4973-fbe8-08de187b94c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2025 12:46:58.9027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zS4loLtnz93E5MGSIzpdewF6Y52DZMuIKk5PQKJGq8kZ33JR7bjo8oH07KHILi3gf6lTFUFGXr7DDsZSfzy9M9KT0y+DqLFmg6v+5JjyDQQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR02MB9340
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMxMDExNSBTYWx0ZWRfX0WcwygkuWDx7
 KuEj25lIPHaQGpZopDlLfBXQvY6gEzQDkhoOH63Wx/HdT116UnRtodBvKYnHPtHu6wQmS7c39UH
 YGB1kRiDjQzM9+BB7kaV5z1Nbn+DybSvUzHEYmepbSpFHFCWk/qf7j7z4ZCMMVI7ZwuhXHBk2Vm
 LcwUPXY0AknCHB1Qu/O4cXF2qp8rA4vEWXX/uuqhyMxDkTymH1ysBkz7P+DSnxAWwSxvB6oOt0h
 GBSaDVUSVh0ne1aPUAERGD+8U+g9JYm3cOuK9jEtH2iZrWwk+HfMWVi7npfwsz1ZqLNYK9KAv4l
 JylbAHg2GaribJDn5IwcSd/U9/FLQ6BjdHxRJuOwCkf1sDHu/shskq6bian9k5lMr/UiqCD81yA
 yGOpItl2/dYAsxJQRj8FW9QCgZC8Pw==
X-Authority-Analysis: v=2.4 cv=dParWeZb c=1 sm=1 tr=0 ts=6904afc6 cx=c_pps
 a=mKvPdnfujGBEPWwSy16I3A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=5-tIs7N4doU7CmY5bYIA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: Gqfr0xfz33Jaosiba-fPyoC8Ngp7FYj8
X-Proofpoint-ORIG-GUID: Gqfr0xfz33Jaosiba-fPyoC8Ngp7FYj8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-31_03,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

SGkgU2VhbiwNCg0KVGhhbmtzIGZvciB0aGUgcmVwbHkuDQoNCj4gT24gMjUgT2N0IDIwMjUsIGF0
IDE6NTHigK9BTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+IHdyb3Rl
Og0KPiANCj4gTWFrZSBpdCBhIHF1aXJrIGluc3RlYWQgb2YgYSBjYXBhYmlsaXR5LiAgVGhpcyBp
cyBkZWZpbml0ZWx5IGEgS1ZNIGJ1ZywgaXQncyBqdXN0DQo+IHVuZm9ydHVuYXRlbHkgb25lIHRo
YXQgd2UgY2FuJ3QgZml4IHdpdGhvdXQgYnJlYWtpbmcgdXNlcnNwYWNlIDotLw0KDQpJIGRvbuKA
mXQgdGhpbmsgdGhpcyBhcHByb2FjaCBmdWxseSBhZGRyZXNzZXMgdGhlIGlzc3VlLg0KDQpGb3Ig
ZXhhbXBsZSwgY29uc2lkZXIgdGhlIHNhbWUgV2luZG93cyBndWVzdCBydW5uaW5nIHdpdGggYSB1
c2Vyc3BhY2UNCkkvTyBBUElDIHRoYXQgaGFzIG5vIEVPSSByZWdpc3RlcnMuIFRoZSBndWVzdCB3
aWxsIHNldCB0aGUgU3VwcHJlc3MgRU9JDQpCcm9hZGNhc3QgYml0IGJlY2F1c2UgS1ZNIGFkdmVy
dGlzZXMgc3VwcG9ydCBmb3IgaXQgKHNlZSANCmt2bV9hcGljX3NldF92ZXJzaW9uKS4NCg0KSWYg
dGhlIHF1aXJrIGlzIGVuYWJsZWQsIGFuIGludGVycnVwdCBzdG9ybSB3aWxsIG9jY3VyLg0KSWYg
dGhlIHF1aXJrIGlzIGRpc2FibGVkLCB1c2Vyc3BhY2Ugd2lsbCBuZXZlciByZWNlaXZlIHRoZSBF
T0kNCm5vdGlmaWNhdGlvbi4NCg0KRm9yIGNvbnRleHQsIFdpbmRvd3Mgd2l0aCBDRyB0aGUgaW50
ZXJydXB0IGluIHRoZSBmb2xsb3dpbmcgb3JkZXI6DQogIDEuIEludGVycnVwdCBmb3IgTDIgYXJy
aXZlcy4NCiAgMi4gTDEgQVBJQyBFT0lzIHRoZSBpbnRlcnJ1cHQuDQogIDMuIEwxIHJlc3VtZXMg
TDIgYW5kIGluamVjdHMgdGhlIGludGVycnVwdC4NCiAgNC4gTDIgRU9JcyBhZnRlciBzZXJ2aWNp
bmcuDQogIDUuIEwxIHBlcmZvcm1zIHRoZSBJL08gQVBJQyBFT0kuDQoNCkd1ZXN0IGlzIG5vdCBk
b2luZyBhbnl0aGluZyB0aGVvcmV0aWNhbGx5IHdyb25nIGhlcmUuIA0KDQpUaGUgcm9vdCBpc3N1
ZSBpcyB0aGF0IEtWTSBhZHZlcnRpc2VzIHN1cHBvcnQgZm9yIEVPSSBicm9hZGNhc3QNCnN1cHBy
ZXNzaW9uIHdpdGhvdXQga25vd2luZyB3aGV0aGVyIHVzZXJzcGFjZSBzdXBwb3J0cyBpdC4NCg0K
RXZlbiBteSBwcmV2aW91cyBwcm9wb3NhbCBkb2VzbuKAmXQgY29tcGxldGVseSBzb2x2ZSB0aGlz
LiBBIHBvdGVudGlhbA0Kd2F5IHRvIGZpeCBpdCB3aXRob3V0IGJyZWFraW5nIHVzZXJzcGFjZSB3
b3VsZCBiZSB0byBsZXQgdXNlcnNwYWNlDQpleHBsaWNpdGx5IGluZGljYXRlIHdoZXRoZXIgaXQg
c3VwcG9ydHMgRU9JIGJyb2FkY2FzdCBzdXBwcmVzc2lvbg0KKGkuZS4gd2hldGhlciBpdCBpbXBs
ZW1lbnRzIEVPSSByZWdpc3RlcnMpLiBCeSBkZWZhdWx0LCBLVk0gc2hvdWxkDQphc3N1bWUgdXNl
cnNwYWNlIGRvZXMgKm5vdCogc3VwcG9ydCBFT0kgYnJvYWRjYXN0IHN1cHByZXNzaW9uLA0KY29u
dHJhcnkgdG8gdGhlIGN1cnJlbnQgYmVoYXZpb3IuDQoNClRoaXMgd2F5LCB1bm1vZGlmaWVkIHVz
ZXJzcGFjZSByZW1haW5zIHVuYWZmZWN0ZWQsIGFuZCB1cGRhdGVkDQp1c2Vyc3BhY2UgY2FuIG9w
dCBpbiB3aGVuIGl0IHRydWx5IHN1cHBvcnRzIEVPSSBicm9hZGNhc3Qgc3VwcHJlc3Npb24uDQoN
CkFtIEkgbWlzc2luZyBzb21ldGhpbmc/DQoNClJlZ2FyZHMsDQpLaHVzaGl0DQoNCg==

