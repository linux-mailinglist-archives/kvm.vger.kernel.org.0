Return-Path: <kvm+bounces-61941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 29FD4C2F60D
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 06:34:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5DDAE34CBCB
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 05:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2CA2D0C95;
	Tue,  4 Nov 2025 05:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="M7+Zq3+q";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="dZ/GHLDL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F430279903;
	Tue,  4 Nov 2025 05:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762234459; cv=fail; b=WolnxpxujBsKtj9NBBVc8rAdhIEN6Se7FqKncy815aDYivTnzq5QKZoG0FyFKdXH/SLksEocpURO9lxKKzj7KlAhbvtdxC6NIkQsUxEUhp5fKAx/LxFjKMlvAoXOPEk8a7aNUXt6C7aFmbqsM0o5d9wZAIQBSjjyBbiWrQZT4MQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762234459; c=relaxed/simple;
	bh=9TD3uc25CA7X2TRx25ddGc/5vvht1cZxUMjMKSVDfH0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fdzwzh4km4dBmjdQf+XvC2l12hl6kHAf3R+ORuKVSgaVPabOLVPgcNoAjW78vZwFXgi2qtmrWjrweWIibS+D6K+1bPSs9ObEagYyEb6BY+MmlIsNFAx3YbQvTqkpgzgJedvnYYpmXsiA87+ZppHWj0X4XMk1Duhh605NK2bI9dM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=M7+Zq3+q; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=dZ/GHLDL; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5A3NdKXQ2341430;
	Mon, 3 Nov 2025 21:08:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=9TD3uc25CA7X2TRx25ddGc/5vvht1cZxUMjMKSVDf
	H0=; b=M7+Zq3+qkY1auA1TFPM+YSVTZby8nvK01YgU2rHvA53oKO3yJMGslNoYs
	cxwmoWlklKnxkjMhRcJ59eMdyFKE5WI9QC5rFVj3Afsn39zzmYBbdSo3BD/7neKW
	Tmz1PieuTE6no1nDmyWg/xd+NrylR2fpGnuWw/P4AnQ1NjlgUAqj5GXMHDErHfqg
	qOap4wz2PEpEU05NtgjrW+hpvwGmWXymC/2h10NWXjRb1dPxKcbkVdmh+XFQpKwu
	yRz9BiccmgHLX+EEonIg7PGuceahdOuUqVizKBMUiTXg/BCloE6ebgjgLZPtzCQ4
	sHx733PbwTRUi/XdGwIDfridDrcCw==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11022107.outbound.protection.outlook.com [40.93.195.107])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4a6sxutd8h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 03 Nov 2025 21:08:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e+E9db1JjNEtpdmG3iGFFukEnl2heKXLGdZnwyp/W/xVrsRt0AerpiICf+sDKny8Q0Gsm/d/lPJDSHeSEVb/IK905HSylH1HSgdDjcIhkRDnHGVGUnOdbfxDiMYc6o7c8xS6lC1MXzSoD2KLMmO9YV1behSkuOmKWPJUewJ3Q2FQsb1VWVmJvX3r2tYjmxwLflSwyo7EtA3rK2EQQfS7u5ah0BHjicqMr/peZA8CNQS7n9aCty+yXnYne9Ab0oypB4tZxPwar/6a3veLmW9Y91Nm4cdSHHmiGCLNuSr1Eo78Ey/rsL/wEhSnaHB/lFTQanTYy2knzygoUULhJoy+CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9TD3uc25CA7X2TRx25ddGc/5vvht1cZxUMjMKSVDfH0=;
 b=Iey2SrQtnSBteh7JQPSm9WMhnfF1akg1eg9GRpjLq5JNO/gwgdjzQwpBUtv/zilBpztWxhH0PYcOHj8E7Le23cf20LcBLkjSQwf5+tJ2uMVxW3DgQSGseonh4u8dpL+5VNcQB/5860kLGoB78pxRmKkZ++X4LQt+bVdyqN5T6yFakXIPdOogLxpimTejUK3Eqs7Ztnm3j6gzvcsH+RavXa0cKV++eH12qLCr8Z3b//VuDaQIhnM1Ei5KxxOzzu92zFb5OUUE3MXE6zXoOSAlr6asKr7VlsbMd4vkc/aFuKbOJumYJL+ldsu4YZ9mDtfQ/KTCFnZF4/tKxTxy9ZFwEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9TD3uc25CA7X2TRx25ddGc/5vvht1cZxUMjMKSVDfH0=;
 b=dZ/GHLDLQ1bKYKz3QO0PjXOhuynJ9uqjxLsTZO385kisy9kM+lpv+Kg0+/Ynea5QP6juBnipJ7qn611doElg837uWlAd6mGY4oDD114hSdwhjQqcajmI1z00F9Zfu29UmX+Bl5rUPfQo/+WEWNGrsqrpZbpA0dSSsS9rrorRja9dMSjmuM/8bHnr4e3kzKULlmeLjleR/Es8a1Sxn2LVjiDATENfTfr9gaJlyNVPgBfu91G/+lqaS3uXCAWXJp5eshCrLAfY0FDG2rGPGPKf4DxoBH2surA05nbBmbsA1SwtjruGa10x3JSnsWl+Mbz69uu9CUt/kMZ1jnz78THPUA==
Received: from MN2PR02MB6367.namprd02.prod.outlook.com (2603:10b6:208:184::16)
 by PH0PR02MB7302.namprd02.prod.outlook.com (2603:10b6:510:19::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 05:08:06 +0000
Received: from MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328]) by MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328%5]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 05:08:06 +0000
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
Thread-Index:
 AQHcKLOgBGqDS4wr/EWm+kbhH0rY57SfxJ+AgABfUICAEG1YAIAhZQKAgAqBJwCAAE6SgIAD34AAgADPEYCAAMv6gA==
Date: Tue, 4 Nov 2025 05:08:05 +0000
Message-ID: <18B08EDA-7A16-4CF1-9E2F-79ADD46F8E4C@nutanix.com>
References: <20250918162529.640943-1-jon@nutanix.com>
 <aNHE0U3qxEOniXqO@google.com>
 <7F944F65-4473-440A-9A2C-235C88672E36@nutanix.com>
 <B116CE75-43FD-41C4-BB3A-9B0A52FFD06B@nutanix.com>
 <aPvf5Y7qjewSVCom@google.com>
 <EFA9296F-14F7-4D78-9B7C-1D258FF0A97A@nutanix.com>
 <aQTxoX4lB_XtZM-w@google.com>
 <80691865-7295-44C9-9967-5E5B744EB5D4@nutanix.com>
 <aQjd1q5jF5uSTfmu@google.com>
In-Reply-To: <aQjd1q5jF5uSTfmu@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR02MB6367:EE_|PH0PR02MB7302:EE_
x-ms-office365-filtering-correlation-id: b7916896-f905-45d6-8ef1-08de1b60237e
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?eGRVRHF5TlgwNzF1K2laamhScnBYSS9FUTZvQkkxdng4d0VTbFhpdnZmZnpB?=
 =?utf-8?B?QzQyd3EwRW1wZDhONmZsT1AyUEtGMDFDV0ZFSlc2V3FKa1FUYnFVVTNKSStX?=
 =?utf-8?B?M1BpU2JOOGRHN1MxTGlSS0JEdlVVemw1ZWJQdS85alUyeis5UGhyY1Rzd0t4?=
 =?utf-8?B?UFBraXdlTDZnLzR6clF4aExUck40NXpXZTMzTkQyMjhwaXJWYWJkK3V6ejFQ?=
 =?utf-8?B?Szl3NjU3TzU2c1ZRS2RDTkt4b2ZudlhkN3ZhUkE2UUM4TmVybWt6cHBpT2Rn?=
 =?utf-8?B?QU93NGxHTWoyd0Z4clJxVnViR2FqNlJ4RDJqc29sblB0TzFOazNYRHd1elpa?=
 =?utf-8?B?dVY4UXM1M2ZRSVdGditzOWk4bnUxNGNDMEtwYXNQR2JMamd4c3hER21ya2R0?=
 =?utf-8?B?bEFuWFhJcktydWNVeGI3WlAwR3gzbEtUK0I3L0V1emNLMkhsT3NPcU5hVmN4?=
 =?utf-8?B?YWV6RXJkT2JhWWNZWTZDcitUNmNhWWJFVURLWlFJSjB0OEFYdHlrYWhoY0VJ?=
 =?utf-8?B?UkZzRzFOeGtjUERXMEdBQnRZVTEvRVVPVWF3M1JFUEdYSmRlQS9TV0wzWnla?=
 =?utf-8?B?ZGFhSWJzT0dJNlFuVWRIUnFITWRGTmV5a1RFRHk5ck04RVIvT0RBUDVzdUlZ?=
 =?utf-8?B?S3RVRHpxM2paaVFYVjJqWURCVVlEMjdLUE9VNm9UVCttMmpLYkYyQjB5VzVX?=
 =?utf-8?B?ZFcrNms0ZVNOdVVkaUNzU2F6eWpWN0RYaWFLK2V6YURXZVJQckRmSzI3YkVQ?=
 =?utf-8?B?ZnljZFRoMUxGQzVCWlJ5K3p6VTE1T3BBNDdZdTdnWDFmamphQTIvSzZGYWVp?=
 =?utf-8?B?V0lNK1V1c3pWTG5XWjM4aGpZZTZydGRlaXByQlRvc01LUnJ6SGd0SXR6S2NT?=
 =?utf-8?B?NEE1aE9QOUZsY1owTXI2VXZORXVKamNDMlRleW5WM1I1T3MrN1N4ckQ3NDFE?=
 =?utf-8?B?V09ueVI2RTRBaWtSTUFSTXJjKzlyVVV5V2JpeVhEekZlME4xVWlLRGVVYk5o?=
 =?utf-8?B?UTl0YkNEVFU0WmFSWDNUd0hEb1JFSkkybjVJczlBYnF2UE04VytGcFkvUkxm?=
 =?utf-8?B?YnFQdVFIM2R1MzVtNTQySHJ4NUlDeHA4OHVwa1RrQnBWOXBscUxmemM4bFJP?=
 =?utf-8?B?ZmJUQzBJaitZRmVkMG9FL2lPWVJGR1BzUGNSeENWL0ZyNFRPMDJ3eEprbm9D?=
 =?utf-8?B?TnQ1QTdXMERpcllDc0tGQXIvZzZRd1dIa05aNjRiakJSbHlId1dxcTlnTFVB?=
 =?utf-8?B?YkNyVG1zWXk0VVpNRHlXSDdBbHc1V3pHNmZtTk9rQ3VtRWJFUzY3Q0dkQXF2?=
 =?utf-8?B?cU5sanpqbWRlWmNHenRrOVBQd1pqdUNaY1ZxN1h6V3BJRUlqeFlDaUtXcWVo?=
 =?utf-8?B?akFwRjFFS0NDanR5S1dMd082QXpIaFFHMGFhenRkVjMycDZ1ZC9sSUdxelEy?=
 =?utf-8?B?TDlLc0RrV0w2cEM3RWgwVjJMVE1VSjJFNVBuYm5zUnBQVy9JeEV0UUpEOEd4?=
 =?utf-8?B?MnBRZEpkVDJNY1NtOTNpUk5ialNOckVkSG9URGg1MzlHdTZTWkxQTXNzWXBj?=
 =?utf-8?B?SHB6ZER2Z01sRGZmZVhrejlYeTU1MXNkRGJpSUFJK1JWT2M1TEVYbENRQ0hn?=
 =?utf-8?B?SFNFUi9ZcEJqVnlHYkUrWEhJSk5MMWFSdlJlVHhrTnJEWVRUME9rUFF1dk1R?=
 =?utf-8?B?cVJ3ckE4TjlFUDl0eFBDWmxmNW9OblFTYnN2WkhEdkZvRVJjOVBrTVhaWk9v?=
 =?utf-8?B?NFZtd3NHTytEcldWMVVoRUNmdjRpcGVmL2hqRGw2RnZPeGk4ZERPWHBBTDI4?=
 =?utf-8?B?OHRNWnc1YmJ1aVc1WStRREh2TGJqM1R6S1lpU1FFL0NZRHpxRXNCY05renJz?=
 =?utf-8?B?OEk3VFlCVVh6elMrY1IwbTRwbGN0ekdyVXBUMFJrTXRrcVVJcm4wQlcwZ2pI?=
 =?utf-8?B?WVkreHFETU1JTGJLMVlBYll0ZG5YVW96SFU2VE92VnJSOEo2eVczT0l0aG1q?=
 =?utf-8?B?UDB3dnBDNDNIcmtYbHlEVGJaTUpSMm5oMktjYXkrZWFodkdhdDZTUUxJemRm?=
 =?utf-8?Q?ec8EuS?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR02MB6367.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S1ZpdXU1SmVHaE1SQ2xUTVFpVVFocWhPUFpGZEdUT1BoMExxWE9QZGRNeWZG?=
 =?utf-8?B?VUxobzFGOW1MbG1OTTYweFl3OFJ0S3FwcE1HVFF4QklRS2c3YzJuOUgyV0hs?=
 =?utf-8?B?cjZwUVpsVno0dWN1VnM4cUYxYWNJRHJOckRqb2I4RDBQa1VkZjRDTG5aT1ZI?=
 =?utf-8?B?RkNFaFVCei94UjI4RURnVnJ0V1VsM3NMUktyYW1EL3lHbGNkVFBDS0RGMkUy?=
 =?utf-8?B?Q21aaXF2WGN4SFJQU3JCL2wvQVBaSDY3aE8xZmFEbDZCYW1yVm54Nm5PR0hK?=
 =?utf-8?B?UzJUZmEwTGlJRG14UitIb1ZIZlRXcm9kQktianZrZ3dwYmFvOU10ZTNIVzRw?=
 =?utf-8?B?cGF2dXY4ajNWWGFEbDI5UmhaaE9aM2tWMXJZWlNGeDFrNzQzU0hkdXJMVFRm?=
 =?utf-8?B?bzdFUTZCTDgwbFZnQUVGdVpKeUpyQStPVy9QYTllMnIwTlJzSlkvVmY4TXZK?=
 =?utf-8?B?SVJiYVhncXJaR0dXMHZXRVVTQWczdUVJS0h0aXpKZzFMZjlUcGZvTXlrTk1k?=
 =?utf-8?B?ODlKUzBFU0FZMlArdjFkUlFxQ25OZEw5TTZyZlozQ2tsQ0JlaGR6Mmw3amVT?=
 =?utf-8?B?VldJbmJQcUpKd1l4V2N4WFJqdWt0SGdPaDN2SkZsdUNKdVFlRlQyUHd3Ky9P?=
 =?utf-8?B?VCtPZWtla2NYejA2TDZZalRiVGpYSnlEMGtuRUNkc1djU2ovaDRnYmhpTXlv?=
 =?utf-8?B?enJtUG5RSkZCejY3Qll5bWpFL1FqZTVEUGo4dERHMlN2c3IzWS94MjdqdXdY?=
 =?utf-8?B?WTAxa09DTzhLRzQ3V1pUK0h1ajB5L0d1UU1xL01yQmZoUHZUbjdSdEVBblVI?=
 =?utf-8?B?YytjQmZ4dTgvbU4zdHo1ZXdiY3dVY1M5SFNScXdoc0dmSDBnbEpTRk1rQ2Z0?=
 =?utf-8?B?TkJ0V2JKUHcyZFVDbXQ1M1VvdUJOYnJKbTM0bWMvVEpGTndmV3hBYTJObXF3?=
 =?utf-8?B?MnFKSFJRMlZBWTkrUkdxaGoraUdVc0M5Y2x6N1FOS2w1UDRaZEpyRnpvbE9C?=
 =?utf-8?B?QzdXOU9qSU5aMVZ3QkZNbVpHZ1ZPY0QydnZmUytiQklHVGhscWdEYVJmR0Nr?=
 =?utf-8?B?dDlIM0hpeGdpaGg3ZDJrMC9DRUJEYXFVS1RFRFpDOXdIM3h0T3gyTUZ3Q1dC?=
 =?utf-8?B?ZGp5M2tKWHpwdVRuRjNzaG9sV1RXNFhHcEhuMG8ydTNVMVIzWjhxd0VoNUl3?=
 =?utf-8?B?NW9UWlB1SHh0b0o1SEhRTnl2Zzl4dTlPaE5jbnQ1YVk5RzFxZGVUSi9uQXBG?=
 =?utf-8?B?ZDNGNTVhZzhDSUZ4RDVrNDNpbGYyZCtILzFpbFIvRDJrTHg0bDE0VmZ3UzRG?=
 =?utf-8?B?VjF0aWdCL2N1Z3J3OGc0S2VGWFZVcHdYekVjNlhqajlEK0xJR1ljNjhyR3k0?=
 =?utf-8?B?SXpLWk5GWTF2RksvV2pBN09YY2FmbGhoc3VJMlJydWRJTGhvZXc0RE5jaXdv?=
 =?utf-8?B?RWJZaWxJQmxZWXFYWjExRFpYWkErbnZrbzB5alNnajd5STNuY21xMkp4aHVQ?=
 =?utf-8?B?SGUzOGd1Y2NEOHJVSGxqZ0phYXdpT1h1RGxrRTVmdVVBT3dYQjAvQ1VFOWQ1?=
 =?utf-8?B?L3VpY1JqdnVQMURtOTRzb2JCMVJXREttY0RTa3Z6NmJKeWRRSGNEZ1d1RTJt?=
 =?utf-8?B?Vkd2bk9oVkJYWjN3aGpDNjZ5ZThpcVRheXBjZjFaNXJ4U3prdlJTUEFLRmw0?=
 =?utf-8?B?V01jTEZIYlIveXF3NWF5Y3R1STBMR1pwOEJaZk5ubVBRUytTQnpVR0tTSTRy?=
 =?utf-8?B?WDlnZGVMK1lVUk82NWlpczBKaERVcXl6SHhJUDJjUEk2S1Mvdkk5SDBhMitl?=
 =?utf-8?B?ajB5RTQ4aGNXRFpON0VpYS90OUZQWjRQRjMxckZ6bGdkRjU3T0JNR3dpc0Zr?=
 =?utf-8?B?M0FBMEFSMGg1Y090bDJiU2tzM0svVWR3am5IVEYrTnhEdEorUHlmUmVlMlZU?=
 =?utf-8?B?TUZqVUtOZ1g2dm5zcXRlTFVwakNzTmkrcWtoazNTSFFrNVdwNHAyMFVOOFlo?=
 =?utf-8?B?OFdCeTV4dUtuUmpkWUFqd0liVEtTSkd5TnZ0VXE0azl4bkFoNHJnVDZoWk5k?=
 =?utf-8?B?Vjh3akprekprM2d4TFl3YzhpTXBvbzlOU3FTeGgzK0w5SWQ0UCtCcW9CcXcr?=
 =?utf-8?B?aFNhWmVmU215L1MyOG91RVFJZTVmTHVNdGdrWXF2R0pSUGxxQjNnbHFTV2dj?=
 =?utf-8?B?K3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <182CB2576DD4344883BDBE27DD509BC6@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b7916896-f905-45d6-8ef1-08de1b60237e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2025 05:08:05.9232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TzQf+dtuU5HGL54R58dhpM9CrRc0O0fHbIdVdqyc6OeqWq3Xbfws0M0rd/3wrXOmsY/lNoZtF2siAqFsY/hngYyyreTw82c2xEraXMHk8bc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7302
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA0MDAzOSBTYWx0ZWRfX9hgm5DrWVLkX
 UW2meoiSKhCOl4h5QluLfSpTkxuFOE00VfcIIRBeYyy1qe8G550oaCOQewQp8/nXzXNvepiIpHa
 Xjj744RhFqZ0eUCxvB9iEFc0gWr0ZK0gmHNAeQtD6ENbUc40nsh+r5L2ZC6ydkTpKWeFPE56yFb
 ax+d5K/6HqoHI4fFQ+vsBCG/dWJrzzU04cctybYr71j/wM1OVvEEa52LaMO/mhury4+icbMGkck
 4Z9aJSXCmRE/U/KFG+Zstz1E/xTw9V2KSW83g2w43QILkO139V1hcdkfYqQg/QAgBq+K9r+QA+q
 ql7VC0nt49UCtAg4G0W+2ogJC/I66XAwmqi530WoJ4eWwuBttK7mINqDtgxWb9xlTryn+S5QjwY
 3SYVqcDenAZ/F4wjeUpIDr3xMx3vHA==
X-Proofpoint-GUID: s9vrEfHtXRn-5PIfPYSVyo62fVnz7TQv
X-Authority-Analysis: v=2.4 cv=FooIPmrq c=1 sm=1 tr=0 ts=69098a38 cx=c_pps
 a=8M1Omf0bnxBxzy+yzgHWvw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=twfy-4HgzkaJ50DcOIcA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: s9vrEfHtXRn-5PIfPYSVyo62fVnz7TQv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_06,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

SGkgU2VhbiwNCg0KQWdyZWVkLiBJIHdhcyB0b28gZm9jdXNlZCBvbiBmaXhpbmcgdGhpcyBwdXJl
bHkgaW4gS1ZNIGFuZCBkaWRu4oCZdCBhY2NvdW50IGZvciB1c2Vyc3BhY2UgcmVhbGl0aWVzLiBU
aGUgcXVpcmsgcGx1cyB4MkFQSUMgZmxhZyBtYWtlcyBzZW5zZS4NCg0KSeKAmWxsIG1ha2UgcWVt
dSBzaWRlIGNoYW5nZXMsIHRlc3QgaXQgYXMgYSB3aG9sZSBhbmQgcmVwb3J0IGJhY2sgd2l0aCBy
ZXN1bHRzLg0KDQpUaGFua3MsDQpLaHVzaGl0

