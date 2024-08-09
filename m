Return-Path: <kvm+bounces-23675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A21594CA21
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 08:10:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 882D71F277B3
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 06:09:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA7CA16CD2A;
	Fri,  9 Aug 2024 06:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="c0DWNDcf"
X-Original-To: kvm@vger.kernel.org
Received: from esa11.fujitsucc.c3s2.iphmx.com (esa11.fujitsucc.c3s2.iphmx.com [216.71.156.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1202917C98;
	Fri,  9 Aug 2024 06:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.156.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723183788; cv=fail; b=BYLGY1QizN1uJW0p7UomHVYzkse9SqEn9+zRjIxKSVWqYhcJmWnN1tvvKYmNnd9uOMY/HcVdRmTWBE4m6i3K0F5jrlZ2zcmTJcECxeKufMVkO2MsEl4Nc5n8LBzb5IKqCANKXf+Tl0/zq8P46hjode9Wl6zPwQjy6jwmFtgX9oU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723183788; c=relaxed/simple;
	bh=UD5G6UQBmi+/9bPnXkPEY8IooRhZZAEKvehAJnLiNtk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UENMFHq2MIKiKftDOVbVd8S8KRfu77BOgrznii1PWRTQgBPj/2K5cF/HT1brLZ7FneOHWTRCPUjC2m5W/zRKGCGT0Mo1hlEOLGxx1V3oo70oIaPldSbCrH0dAi7Y5S5nT5ZRM6IRR5zVpNzsVjICrY7jIrDgBlWqLfN+qTAFeaw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=c0DWNDcf; arc=fail smtp.client-ip=216.71.156.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1723183785; x=1754719785;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UD5G6UQBmi+/9bPnXkPEY8IooRhZZAEKvehAJnLiNtk=;
  b=c0DWNDcfhro6mbn6aLjgicrNwuFK0tmJXbGasbwvZ+1F7eVHm0/IUgzr
   CX5vNW/BJiQSJUUyATb5D+7VYVALpDWdlhF2dszB6wlFUHwo18o8jJWF2
   IGqWRE0tZ/nwt8QxJWARTcwPkjJrz/QExN2oIZ3BwX+MFWh4y0tvmrWJh
   s2ufS7hoNALwapjq93R8QuR+1rHITjT8S3dPXeNKw4IYddhZ8DARQCmaM
   VaCTfgeo58kgOzyXbnAt/1aMyNWVr7BlDfCHPqrtskecEfQMdhPuLIU3l
   WP62PgoauzJpbmmfwXWNqjXvjqB2565GeCuogIkyhaSQ5tYdmBEeG6Ybv
   g==;
X-CSE-ConnectionGUID: DCmpl1J7Tl2px9d0YeA2Jw==
X-CSE-MsgGUID: QSkz/MPrQLGquKWv2TPFZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="128506147"
X-IronPort-AV: E=Sophos;i="6.09,275,1716217200"; 
   d="scan'208";a="128506147"
Received: from mail-japaneastazlp17010001.outbound.protection.outlook.com (HELO TY3P286CU002.outbound.protection.outlook.com) ([40.93.73.1])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 15:08:26 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mZth3M87J0eyre7z7LHNNxSGNZwdljHk4pHL8oJ+Vo/IdlfAmCRLPu4T4T24vlJYFyeOET6y6bdOS06OiMcmvAYmzW0jAED2YJCyl/bmHxo69nB40ENA1ZoEI0qiWoPUlrq4AYTM5goKmdq1aYLTiluhNEKa3UjW1+n6FBoEvLVILVFdbK8Rfp7NJljN9g5W2yHyuFag+LQ1tMPyDab0AarRq2rAFHTHtZgowm0nYjwrvDhX5xw4iQtAb2k6kF0HdVxQxli35vgKIPdxmHyz/1yhjyIgc0pnkICv7Hx8SXedU/B5XL6cBMPpMb5FZ5aupoT52keIkPm0XjJNTRmGVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7N+aYPKfe155koO1jdXjhWvpOWTUqI4xgHhuce0i7Y=;
 b=Pi3nC8ovk5Bct7pMkdaPD0mLBksEu7Fi+OHmi0OktnwuoWcNgZm4t2GcpIbp5VFWoc0XBU3j73oVULtgqW5uYVR1bbgPlRtRSDUr7FlG4rFzsxHV1nIGywxqigPws9OurH6KkcYaJugkzSu38BxLzlJBtW3ppGbaqZ/LCc4kKZ1PXSMYoJOEaYTjMeL4VVx9utQVSHawfcVw6QzUCz9Lf4tXDzvNJHVENecvMicuuzS57sdq5917Plf6BeRkZvOvHNud5aDQO3MljFwf79rqm61/TGQ4yuYFlgdNuJkyE0jsz4tktmfOYRx2osJyvV2tEZ9CFkFNxJh2CX9KsjURgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
Received: from TY3PR01MB11148.jpnprd01.prod.outlook.com
 (2603:1096:400:3d4::10) by TYYPR01MB8197.jpnprd01.prod.outlook.com
 (2603:1096:400:fd::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.14; Fri, 9 Aug
 2024 06:08:23 +0000
Received: from TY3PR01MB11148.jpnprd01.prod.outlook.com
 ([fe80::1c1d:87e4:ae79:4947]) by TY3PR01MB11148.jpnprd01.prod.outlook.com
 ([fe80::1c1d:87e4:ae79:4947%6]) with mapi id 15.20.7849.014; Fri, 9 Aug 2024
 06:08:23 +0000
From: "Tomohiro Misono (Fujitsu)" <misono.tomohiro@fujitsu.com>
To: 'Ankur Arora' <ankur.a.arora@oracle.com>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "wanpengli@tencent.com" <wanpengli@tencent.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "rafael@kernel.org"
	<rafael@kernel.org>, "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "arnd@arndb.de"
	<arnd@arndb.de>, "lenb@kernel.org" <lenb@kernel.org>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "harisokn@amazon.com" <harisokn@amazon.com>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>, "sudeep.holla@arm.com"
	<sudeep.holla@arm.com>, "cl@gentwo.org" <cl@gentwo.org>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: RE: [PATCH v6 09/10] arm64: support cpuidle-haltpoll
Thread-Topic: [PATCH v6 09/10] arm64: support cpuidle-haltpoll
Thread-Index: AQHa35mGzbTig3/y6U+lE3ymkVSp+7IehFBw
Date: Fri, 9 Aug 2024 06:08:11 +0000
Deferred-Delivery: Fri, 9 Aug 2024 06:08:11 +0000
Message-ID:
 <TY3PR01MB1114841B832015DD88D121EF0E5BA2@TY3PR01MB11148.jpnprd01.prod.outlook.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-7-ankur.a.arora@oracle.com>
In-Reply-To: <20240726202134.627514-7-ankur.a.arora@oracle.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ActionId=f0d89468-6893-4b80-8d11-8ca60a04f710;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_ContentBits=0;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Enabled=true;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Method=Privileged;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_Name=FUJITSU-PUBLIC?;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SetDate=2024-08-09T06:04:18Z;MSIP_Label_1e92ef73-0ad1-40c5-ad55-46de3396802f_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY3PR01MB11148:EE_|TYYPR01MB8197:EE_
x-ms-office365-filtering-correlation-id: 48479765-a9e3-4637-2809-08dcb839acb2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|1580799027|38070700018;
x-microsoft-antispam-message-info:
 =?iso-2022-jp?B?T29Ic3hza0RsOE10R1dQN3FUUFdyV0NHa2dXS29DRDRLSzlEVnA3SGFa?=
 =?iso-2022-jp?B?WXpOcUNqTnh5TUpPbC9iNlNTQWRXMlhkS3RXUTRMN0M3V01TVHQ1dm5H?=
 =?iso-2022-jp?B?TEJ4SjR0NzNEVjlIQndLL0pIVHZDeThlSVJ6elErZVBjcCtsTnV2VjF2?=
 =?iso-2022-jp?B?STJ5dnl6ZkN6M2h4blVBS2h3Rk95YzVqeWtOUVhWUVJkYitrVDlxenlT?=
 =?iso-2022-jp?B?SWlIMzl3U1o4VENHc3FWMVBaZXJiQ1gyTmlueXhxWGR1S3lCbGNXcll3?=
 =?iso-2022-jp?B?MnlybVdycm5peGlRVjIxai9RdVNYUXljLy9mcFlBNEo2YXp1K1JpOFJa?=
 =?iso-2022-jp?B?Z2thWVJWOEE3dWxqcjBkWlQ2aExPTDhWT3BCR0w5d1VrWWxjei9yUHRy?=
 =?iso-2022-jp?B?RldRd2FIUVpwZmRoaXFIWDlocDBvNHhNektaelBtd0dhdVN1RjBvNzYr?=
 =?iso-2022-jp?B?VzNLSEozUFVDYVJMdTdsR1Y2NjdHL0lUNzE1WlMyMjZaRENSMmlCOENP?=
 =?iso-2022-jp?B?dmVvQTFkTC82Y1Mvdkt4ekM2alZKZ1REdTNIMHJyNUgzcFNsVW8zTUFJ?=
 =?iso-2022-jp?B?MWNWb1lvVWgvazR2V3ltTkFieHFlY1VadWpKdjZDc2RUN0Y2aWMyVUE2?=
 =?iso-2022-jp?B?Ti9zd2NoSlk0VXhUNGEwMXpkV0J3NjZEUFJ5cTBSM2lnTnc3WmlacmEy?=
 =?iso-2022-jp?B?NXlKbHU4dU5KRFc5MGxUdldyWUllNmtpL0V6ay9mckZOS25EeDVtUVdp?=
 =?iso-2022-jp?B?TWkrZ21SeUlqbG8wcWNCQVVjU1dibDM1R1FVdFlsTDRzdG1IVXhXWGpt?=
 =?iso-2022-jp?B?aGJQa0xSbC9DcjIxUnJRdlN4ekZUbHdTeFMvTnRZSnRjSTVvdm5UR3lU?=
 =?iso-2022-jp?B?WUtOTnIyQ1JidGlUT3pacGNBWE9CUm5PSFZhVlVxWDZCNTgxZ3JtTEF6?=
 =?iso-2022-jp?B?SDFoazhKeWhhVXlHZlUvZnFOeFhWSTAyVkdpWjFYNXlubFh4VGFCRHll?=
 =?iso-2022-jp?B?VW1RZnJja3FyamFWNVhULzk3MG5iUmhKYjNhREhNS3hXTUplVW8xY2dB?=
 =?iso-2022-jp?B?UUdVMnFBM2tIMUZZaUd3OGplL0ozdTVuSW84VzhuTTBEaUFhRHkxc2Z2?=
 =?iso-2022-jp?B?bFR6YnRNUlN1bk5tL0w1amFzbTB4ZXdhbnFMNEVtcktvSE1vOVBoSlNr?=
 =?iso-2022-jp?B?ZXUvTG8raDRaTko1U1B2cGVJQkJmL2VGUk5RU1ZJOFpSMXIzeTN0YnZT?=
 =?iso-2022-jp?B?YnBrV2d5ZnE5Q1FiaWF6eE1yUnNTZWl5dzNzWTZhWWhMSGRDWCtyOUxE?=
 =?iso-2022-jp?B?eHI5akNweHM5a3JENUZVdEhWbUluZm9PM3NwcURiLyt1aG9SblpxUTVS?=
 =?iso-2022-jp?B?bEtNZnFNWEJLK3VpRklVdVZqZEVaZGZVcWlhSU15Y0M0MHdoL0loMkJ4?=
 =?iso-2022-jp?B?T0M2Nmd5NVRtVG9URUM3ZzZEcTk1Ynpya3VTdjU0TGdBRnhXWElyeUlO?=
 =?iso-2022-jp?B?QWFSdFd3Q0MvZnVHY0RoQ0hWbHNOR0VhK00zUGFtZ2QwRjdLZzVad2N5?=
 =?iso-2022-jp?B?R0M3elJmZ1NvWjBkbm5NR0tKSWtMNDFvcHd2T3pNcVdGK3hsZ1hoY1Vy?=
 =?iso-2022-jp?B?S2VYcWNPcURlMUhTaW1GMHR4VmE5K0NmejBsaHVUNDVvRFpnVFZlc0Vv?=
 =?iso-2022-jp?B?NWltc3N4aE9YWGlrSk9vRnFwSFMvT0RHdzJSalMwc1RheFB0UVllK01u?=
 =?iso-2022-jp?B?MXBkWitFNkFHS0FmZ2lFampQdjBjaVl5ZllwTUlzbTIrdW8zU1pkYUdS?=
 =?iso-2022-jp?B?NVJYNGxSY0dnZTFHVlJRNkI1ZUFqS2N4aHY2T0o4b2tGcktYSkxrdVVw?=
 =?iso-2022-jp?B?M09Yd0lYdFk4Y1RFa0ZpcEo5aVFUaE10UFl2U3NLWWZiMWZGNVJ3VWY1?=
 =?iso-2022-jp?B?dWFUS2VBTVVpYURuSnZUZUdaNzc4ZUQwT2xEdHlIWGZ3dCtYRW9JY3Av?=
 =?iso-2022-jp?B?ejdJYmxwei94anNHUVBFWmlqeVgweg==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:ja;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY3PR01MB11148.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(1580799027)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-2022-jp?B?N2I1VWJqTk4yREpBR215bzdadHhtc0lkaGY4WWFzd0IvTEJXRFFDayta?=
 =?iso-2022-jp?B?czRDdXpHZW5RclYxN0ExVUVHQ3NXT2hjM1ZYR0NIdWpMOEJHbEpBVlNQ?=
 =?iso-2022-jp?B?Q0UrVnZTZUZkZWJkcVNzTjdCZ2UrWjYxakhpc0VXVklqYjRLTnU1Njh3?=
 =?iso-2022-jp?B?MDVoQVJWUWd3WFN3NXJnRld2OE0xQzVGVmNQK0F6MFk2RVR3dlZ0ZGwv?=
 =?iso-2022-jp?B?Nm9ub3RDTEljc0pRbzNoMXVOTWZXL0ptakpZYm5QMFJBWjRqTDByZWdK?=
 =?iso-2022-jp?B?RTViaW5IMzc1RDBaSDRrc1doTGN3c2RZaSsxVjRlcHR3MjBrQ2Z2bzQ0?=
 =?iso-2022-jp?B?cE9zTFdvUmhsNmdqOW41YmQvVGpyWUNvS0hyMlNoSGNVQTJCZzVUQ2VO?=
 =?iso-2022-jp?B?cXlkSHc2Y2ZyUTRFVXorMWVLVndXZEZwVGZNUjhlVkFMWGd5L0lvVWdk?=
 =?iso-2022-jp?B?YTRaU3IrR3NKeDNodHZWajZUOVhQK3NVaUJkU01qNU9QL1ZySmsydTZI?=
 =?iso-2022-jp?B?bnRaQzlhZEpRd3U1REpqT3pyQ1hFRE9xUEJhVWM1ZWJpMVZkc1hVNE9t?=
 =?iso-2022-jp?B?QkVOVFRmOTJYcFJJaEt2RUo4SWtyUUYydTdJS3lFNXE1MnZydDlTRWdk?=
 =?iso-2022-jp?B?ZllSOFVtRGZVU3ZWRFRiTXQyY0tRa2tFS0phMFRlSllPQVpjOG1SN0hz?=
 =?iso-2022-jp?B?WlhaZk9qOHRLUHhNRFN3RGZNK0dvK2tQMEhuY0N0TjRkbzFtcUZNMWRL?=
 =?iso-2022-jp?B?ZHZ4L0U4Wk9FVU40NUpiL0ZWQ2ZETTE2SmY1Sk1GNmpHeVhJaHpTMWhW?=
 =?iso-2022-jp?B?ZUxrMXFqV3d5TUY4b1lLUk9KYlM5a3Q5aGQxaUFZN0N0MUU3NnluU2xx?=
 =?iso-2022-jp?B?N2RYQ0ZRc1JKZmdqQkN3cDlBclhQWVZvWnhEeVVsSzZRa2RNRTBTZm1r?=
 =?iso-2022-jp?B?UE5FUFNoM0tSeVN6TXVWYkdIN1c3T1pkMUpHbDMwKzRiZTdMVm9lTXNJ?=
 =?iso-2022-jp?B?V09kbnU5ZVNRN2FpYTZxalNwZk1uRzdyR0FEc0MyZjZ3dGEwLzYzSmxB?=
 =?iso-2022-jp?B?amc4SnY3UnF0b0pEdWlSSlQyeCtuUTFKZ2I0V3VjQmQyKzJOZXY0c0lx?=
 =?iso-2022-jp?B?U3BFNkJiVmJ4dlRMd0JvWGdkWWtEbTNHcHRYcTlhVU40QjVMR1ZhYm1C?=
 =?iso-2022-jp?B?TCtiaEdzbjVuQWZPNmIyMnZEcWF4eHR2Y1JZN3B3Tk14SGZKUlBvR2p1?=
 =?iso-2022-jp?B?UGpXR1o2YldNOGpqQ1RqQ1RKTytWL3RpMUl4ZFlDLzJOK05paThwOVg1?=
 =?iso-2022-jp?B?T0Y0VWFZUE1HRVJGR1pvUk5FV3I2clU0SkxCU2NaYnlGaXMxMXMzZUVq?=
 =?iso-2022-jp?B?eHpramF0dTA4NEtxVGhCMDRQT2NEekhWWXREUi95NzVwOHRzRjcxK1U2?=
 =?iso-2022-jp?B?UEhtd0I3RHlHSWJYRGRBR0U4bllpVXZJb2NyRlNYU2VlcXlaWEhLK25C?=
 =?iso-2022-jp?B?UlJ0V2RneDk3RzN3dXZNenZiakhZRGRRZzkvMHdpY2JjT09qdndvSW5I?=
 =?iso-2022-jp?B?Y3lrQU9ZUnBnL3JJUUVMQ0tGd0pUQjBHSUpsSkU1QmhBTUpPeU0ySWdN?=
 =?iso-2022-jp?B?VUdYRE5uVW9Rc2h2TFZUR09rd2t0WCtKeWpEK2ZkN3I1NmZoQWlZc3I2?=
 =?iso-2022-jp?B?ZFp5b2ovUHoxTWZxZU5KVUUvdHAvQi9UNzhkY1k5WjZPVXhNT3lJYVZv?=
 =?iso-2022-jp?B?WVNlb3lWM2dpWDNSUCtWOTZoQ3hjYkRkMUp1dG90dlhMVXZQM0tTNGxq?=
 =?iso-2022-jp?B?eWpBR3VXZmpNd2NlYVhXdnZMSEM4Yk5ybTVNWnUrN0JRZEhrbXhsd2U4?=
 =?iso-2022-jp?B?MDlJY1k1WDV2b0hpV0JwYjIzQUFpN2p2VFgzbjQ5UlQvRnIxUGxvbitl?=
 =?iso-2022-jp?B?WTVSa2RoemYrVGtrdlVWOTd1QUJiUjhOZXE4OHJtWnlyaWk3Q0xiRXox?=
 =?iso-2022-jp?B?dEMvZkZGNk9VdmZaT1FCQ3R3ejJhQTN4YkZIdmRnNGhieWc0azJ3eUFv?=
 =?iso-2022-jp?B?ZWdna1N5L0NOU0NPRzVWNWxTeTVmalFxb3J3cHlodGh6c0FRdGpFZnJm?=
 =?iso-2022-jp?B?NTc5WVRNRjB3WkNlWXVsdVZ0TmpjUDhKWUk0NFlkcVZ1MjkyMWZlYWhQ?=
 =?iso-2022-jp?B?NUNsY2RxbEErcEI0Y1gzTUNabGd6WHMyN08wNmJqMHlMOUMySllpNHp5?=
 =?iso-2022-jp?B?SEdOejZrYlhETjlSRUg4ZGpueVZTR2VMeTdzQ2Z1R1ZZVTNrV2pGR0Vu?=
 =?iso-2022-jp?B?RllucjN3eXFKcFE2blNDR1NTclBqb0E0akE9PQ==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	s3jvARbKZM20koILndOmZ6Q5396D0MhevJL5iPMj4gyvZdYwjP37XmpvD0bjvV+Jk9od/181WrJgJ0nUMZIPHUx/MO14GAy602NiXSFRtmWoGZyBWKI4Evve7rOmVQRKioiiOxAcQUQ2k/HokVoUnnmUQXdr2CN/FVusKEO9ccIIeR9R5vNa0IsAq/YpygbQ6K8d2KeYbELFNEUafwKGfnd/6ZQHTm1W0u0bRCgoFmIffKAWM2aKWUkVRpN39b3+o9sLdxD4AikB46a1Duyur7CeAWoByez76BONPw/b08PeqaOmcBm6fOIxT7sYCpdwvtakM10vU95un0PZRoAQ9l1/MUu8XXsAnXG+qp1AwVm3mSRNSVDNjjXI/WqtfiGQRsj/sr12kGsVXUWwOKcewXEK6UyDG2+UWm5VzQnGsrnKTwL/by0Q5fbRbEoHwn2eeyVUziOffb9Vfxldx1eFgk+AhzSiOlwDiOpStiuIsws7ia6sdx67WRXwcpiZsOcSMFqVCLF5p4wtEX8f4E9Cy+NekI8Pp36cN4QoKsQtwK8LgYvSvYf216OzooBUECHrAdQbA8Tg8RG4jF+KfpTGBB0LSoZYdrMBcJ6jWsqPmqrRoW03KvFfJ2TKYKKU/3dD
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY3PR01MB11148.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48479765-a9e3-4637-2809-08dcb839acb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2024 06:08:22.9302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mLQbZxKtPvM/CczlL0zztqJ0G8q48b6VCAmeL0cAf6LEvPDJzMk5HRV/F9L8af0GwMauUCSjJ0xyZ2/279/ndjJnQfsl0+d6bpohylYTLo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYPR01MB8197

> Subject: [PATCH v6 09/10] arm64: support cpuidle-haltpoll
>=20
> Add architectural support for cpuidle-haltpoll driver by defining
> arch_haltpoll_*().
>=20
> Also define ARCH_CPUIDLE_HALTPOLL to allow cpuidle-haltpoll to be
> selected, and given that we have an optimized polling mechanism
> in smp_cond_load*(), select ARCH_HAS_OPTIMIZED_POLL.
>=20
> smp_cond_load*() are implemented via LDXR, WFE, with LDXR loading
> a memory region in exclusive state and the WFE waiting for any
> stores to it.
>=20
> In the edge case -- no CPU stores to the waited region and there's no
> interrupt -- the event-stream will provide the terminating condition
> ensuring we don't wait forever, but because the event-stream runs at
> a fixed frequency (configured at 10kHz) we might spend more time in
> the polling stage than specified by cpuidle_poll_time().
>=20
> This would only happen in the last iteration, since overshooting the
> poll_limit means the governor moves out of the polling stage.
>=20
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>  arch/arm64/Kconfig                        | 10 ++++++++++
>  arch/arm64/include/asm/cpuidle_haltpoll.h |  9 +++++++++
>  arch/arm64/kernel/cpuidle.c               | 23 +++++++++++++++++++++++

FYI, arch/arm64/kernel/cpuidle.c is move to drivers/acpi/arm64/ in 6.11
and therefore I couldn't apply the series to 6.11.
https://github.com/torvalds/linux/commit/99e7a8adc0ca906151f5d70ff68b8a81f5=
3fd106

Regards,
Tomohiro Misono

>  3 files changed, 42 insertions(+)
>  create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h
>=20
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 5d91259ee7b5..cf1c6681eb0a 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -35,6 +35,7 @@ config ARM64
>  	select ARCH_HAS_MEMBARRIER_SYNC_CORE
>  	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
>  	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> +	select ARCH_HAS_OPTIMIZED_POLL
>  	select ARCH_HAS_PTE_DEVMAP
>  	select ARCH_HAS_PTE_SPECIAL
>  	select ARCH_HAS_HW_PTE_YOUNG
> @@ -2376,6 +2377,15 @@ config ARCH_HIBERNATION_HEADER
>  config ARCH_SUSPEND_POSSIBLE
>  	def_bool y
>=20
> +config ARCH_CPUIDLE_HALTPOLL
> +	bool "Enable selection of the cpuidle-haltpoll driver"
> +	default n
> +	help
> +	  cpuidle-haltpoll allows for adaptive polling based on
> +	  current load before entering the idle state.
> +
> +	  Some virtualized workloads benefit from using it.
> +
>  endmenu # "Power management options"
>=20
>  menu "CPU Power Management"
> diff --git a/arch/arm64/include/asm/cpuidle_haltpoll.h b/arch/arm64/inclu=
de/asm/cpuidle_haltpoll.h
> new file mode 100644
> index 000000000000..65f289407a6c
> --- /dev/null
> +++ b/arch/arm64/include/asm/cpuidle_haltpoll.h
> @@ -0,0 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ARCH_HALTPOLL_H
> +#define _ARCH_HALTPOLL_H
> +
> +static inline void arch_haltpoll_enable(unsigned int cpu) { }
> +static inline void arch_haltpoll_disable(unsigned int cpu) { }
> +
> +bool arch_haltpoll_want(bool force);
> +#endif
> diff --git a/arch/arm64/kernel/cpuidle.c b/arch/arm64/kernel/cpuidle.c
> index f372295207fb..334df82a0eac 100644
> --- a/arch/arm64/kernel/cpuidle.c
> +++ b/arch/arm64/kernel/cpuidle.c
> @@ -72,3 +72,26 @@ __cpuidle int acpi_processor_ffh_lpi_enter(struct acpi=
_lpi_state *lpi)
>  					     lpi->index, state);
>  }
>  #endif
> +
> +#if IS_ENABLED(CONFIG_HALTPOLL_CPUIDLE)
> +
> +#include <asm/cpuidle_haltpoll.h>
> +
> +bool arch_haltpoll_want(bool force)
> +{
> +	/*
> +	 * Enabling haltpoll requires two things:
> +	 *
> +	 * - Event stream support to provide a terminating condition to the
> +	 *   WFE in the poll loop.
> +	 *
> +	 * - KVM support for arch_haltpoll_enable(), arch_haltpoll_enable().
> +	 *
> +	 * Given that the second is missing, allow haltpoll to only be force
> +	 * loaded.
> +	 */
> +	return (arch_timer_evtstrm_available() && false) || force;
> +}
> +
> +EXPORT_SYMBOL_GPL(arch_haltpoll_want);
> +#endif
> --
> 2.43.5


