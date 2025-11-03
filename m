Return-Path: <kvm+bounces-61778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A5C3EC2A07F
	for <lists+kvm@lfdr.de>; Mon, 03 Nov 2025 05:38:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EC8084EAC45
	for <lists+kvm@lfdr.de>; Mon,  3 Nov 2025 04:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 707D6284684;
	Mon,  3 Nov 2025 04:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Zuww6zZ3";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="JbSkkM42"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368662581;
	Mon,  3 Nov 2025 04:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762144664; cv=fail; b=AYt4KBgQjpgU09x6Ca5bi+lXKqJExpbM/8u7tOicP3/+X6lkiKyFAhNzRd/J7NCi/BpwRDd2WPQZr+ZOE3IQfcDnC64mhh5vi8//6+dwWKb/MGXxBtNvsOhEClZTFWYrPl4qdST5Ja4Tlj7soGOMPDy+iDBmJ3V3wzDQFeTGYwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762144664; c=relaxed/simple;
	bh=yxyanHPfujQVjABot7hxIbQeRGpasXmEBkvIlRtp2kQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JmemvbfpSw/ZQ/b1k94cf8ClagdWquvCNnL0cE7P6TZnExaAHGu2raHqPmeW+HtA4U6N5T8HTOnFRwhppjbRDL1KnwViafnh0JuF5jJXj8hnDwv+Sbogimj58CBwH7KuGth4++eEM+2raLVszkfj5ZK1+cVYjRkK2MyskGZjmMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Zuww6zZ3; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=JbSkkM42; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5A26GUMX1165311;
	Sun, 2 Nov 2025 20:36:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=yxyanHPfujQVjABot7hxIbQeRGpasXmEBkvIlRtp2
	kQ=; b=Zuww6zZ3lhRNT6yktIR9aGWzmaXMcmbaFMTU/CP8aRLR0jh/qeXFkuLyd
	1IT/hdeuK3/UFcbjJSkKmwPLbsN20RLnRrbWZVunM4HWvqd5BooQD9rSl1bLsTqB
	ZKBux6uYK/ipQwlnz45ZulSQHFHw7MFY//KxNXOjWfWwTW5AK2jz06bKLdtDzCTT
	VS3zYf8svgGrAHLPi0C9mSdJtNvw0CmGAD/RtrNT4fWkghC0QTvRpIcK358lf89f
	+Yqzc7edJlg0RX+kzY5fE/A7kTloZ6zBUeMf9oom6sKR82ACMfu5RC9VfUvYihjS
	XuOWDq+x6CvBtUw8oFICQwJg3hrmQ==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11020110.outbound.protection.outlook.com [52.101.193.110])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4a5frcj3r2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 02 Nov 2025 20:36:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XGwlJK8v7G0KPhgugpBIlScujWymhCHb6cpYxkil7KM2jN1rjsonTf3X4IsvCgpmmoJxOLngT9rfEt3dp/1HM1i30YTeHyz7wh/f036dXXtZr3Tmq681Rn1i4WnZBKxjE0MDu2ualF8RRDmOOCNX7AoYoUcS58bQCtS5n/VC71AfTQQxY5bVxKA5I+t0AvBlOXx9968pdTmdYS0tCdzvTJstR97oyn4h+90w8fLWGBMWoZ1/BgrQwFsQ6M0LQEzxLPASTyWLo5xMGYydGDKMGfqL2w/6xL1x1ePehKDc/Tn/UYZCXduV7ZFBmEMk1+VcvcwVnWqciRjhjE7XDoI+6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yxyanHPfujQVjABot7hxIbQeRGpasXmEBkvIlRtp2kQ=;
 b=O13MDzOTMF9HfeK4RKfLXTzYb481+B7+XYvNTtYJY99y6wdKkWFZP3+gZ6nuF+95zlqT0VktxDD0AWBT9MkG1CfXGFt8VTpjHTtNM7e+fu6hx7+VIyVedQnxzvdYN/6e6en68tRElRVdSApTXobEMX/a478ZWokc3k+b2y+lUs5N3Vn0LleZTITyI/+gxTV3VQmoCkKiwwSwAl0yGSXXQkCBWC5M1j2wgJNRxH/OrEcC3vPMCUhBDBigAPRgbar/iYTjlTwDLQvahWLzT//yg5fc4fdLKQB7TiCTrf0zhQcK3l7Vf+uKKffC/UTob4foM2icrVRJGN10LjbqHZiNpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yxyanHPfujQVjABot7hxIbQeRGpasXmEBkvIlRtp2kQ=;
 b=JbSkkM42B72la0en3s+qIfKQqazcPEwx6mylAfCv5ghiRVp6e0fM/umUtnZNnaP0Msc9Y4azqymMfYm2AZqwZg2+cv+lIntRyoxSAca6DCndl7dL4o29oY9hpnqjt67XewdNJGrt+s/ZOq3oqEiXfdcHEa//jeomO/ataRwWWv7Pxru8+yg0r8Dw92uWazpmP9umtDehcGsisezUR817qQlY+Yeflb9MzCHVwGvgrs8/3hJ4i1Nn7U/LkZ8LT77JuDjTLKxG5KPr+yJt8KbKD5lnFmTll3d3Jv7iWVh5bms/Wqigyi7FjhywX1wtI1YFZl9kSYjf+NoKdqWKscmqPQ==
Received: from MN2PR02MB6367.namprd02.prod.outlook.com (2603:10b6:208:184::16)
 by BY5PR02MB6817.namprd02.prod.outlook.com (2603:10b6:a03:20e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Mon, 3 Nov
 2025 04:36:55 +0000
Received: from MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328]) by MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328%5]) with mapi id 15.20.9275.013; Mon, 3 Nov 2025
 04:36:55 +0000
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
 AQHcKLOgBGqDS4wr/EWm+kbhH0rY57SfxJ+AgABfUICAEG1YAIAhZQKAgAqBJwCAAE6SgIAD34AA
Date: Mon, 3 Nov 2025 04:36:55 +0000
Message-ID: <80691865-7295-44C9-9967-5E5B744EB5D4@nutanix.com>
References: <20250918162529.640943-1-jon@nutanix.com>
 <aNHE0U3qxEOniXqO@google.com>
 <7F944F65-4473-440A-9A2C-235C88672E36@nutanix.com>
 <B116CE75-43FD-41C4-BB3A-9B0A52FFD06B@nutanix.com>
 <aPvf5Y7qjewSVCom@google.com>
 <EFA9296F-14F7-4D78-9B7C-1D258FF0A97A@nutanix.com>
 <aQTxoX4lB_XtZM-w@google.com>
In-Reply-To: <aQTxoX4lB_XtZM-w@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR02MB6367:EE_|BY5PR02MB6817:EE_
x-ms-office365-filtering-correlation-id: 8648283c-8a31-4eda-74ef-08de1a929e47
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?QkFFdTdpZVY4QUNWMnVINWZhY0UyQVNiODlZbGU0WnY5MkFNUnFKSFhmdjBR?=
 =?utf-8?B?QUlra20yL0s5YWdTYURRalBrYm0xdVR4MDRPbDNtNnhnRUxubGNnV244TnIx?=
 =?utf-8?B?dkZydVUvVkVvMzFlNy9OM0lzc1B2cFFoV2t5b2NwUklETWhuaUZpdURBUDgx?=
 =?utf-8?B?cExaSElhbHlzYmdxeG54NmhYQjIvR0lKVTJDNWhOeUZaSURQOGd4TUd3cGla?=
 =?utf-8?B?Wjd3N3B0QnhHWnB2NkpINWhIN2o2MndYbFNraGQrL2hOQ3VpV0FCSW9yci91?=
 =?utf-8?B?M1AxeHNkeU91ZWFWYVhqZDhUUkF4OXpGeittY1J1c1JxYTdZRm1vcklWVmZi?=
 =?utf-8?B?RjhaV1lUYWZjZXpkUklMTkJvd0FZV1hYb3gyVnJtSTd4Tnp6aFFtMlVjVUNS?=
 =?utf-8?B?TkJjMDFRYkUzc1hGQysvRzhLWE54alNKNm9ycEtRS3lmZURHZG1JQzNHeGJQ?=
 =?utf-8?B?MHYwYWFYYkJNSGFyN2VRT3I0bUJENUN0WVNNaW1QNFJaYzhnanhGT1hjTFBY?=
 =?utf-8?B?Zy85WDI5ZjlGWmJPNGx3MnVPYS9CNDhuR1dFTW0xL3pVcDV0RitpQ1JFc0pU?=
 =?utf-8?B?MTVjNmpQSElVSm95RWVNbWlidFFxVHArK1YrL2w2UWVKYnc5K0wyZVFxYUEw?=
 =?utf-8?B?NTFUTDdMMVZMNjJ2eUtaaXovUWFra1MyMUFOK2ZSSzF4L1FXTVA4ZXM2eGRE?=
 =?utf-8?B?eFpvQnlGTENwQ3N5cDFwNVhXK2haNUVWbS9LSXJ6blJvczR0VkQ3bFRUUVNI?=
 =?utf-8?B?SFJaN1RleEFXY0w1c1lYVi9nNUgxS1BpREFXcWJvVTZXODN0dFRPWWRuWUdK?=
 =?utf-8?B?L3ZPWWpQSzc4NXBvKzdKVGpnOWUzcnlUQUl5MytWVmVYbVg3THZwNmxJOHRY?=
 =?utf-8?B?eTJleHBLMHBiM0RaNkhVaU1jdnY5ajdwUStHeXFVQW9OV1UxSStMSEJvYXAv?=
 =?utf-8?B?OVF1SjFkUkJLYlROTFNzUmZjZmhMQWNNdmpjeGpDQk5OTFVFMllrSVBHZExi?=
 =?utf-8?B?Q1ZldFFyb29WTWlraWI3dEllcHRZM3lpb2hQOVQxT2dMajZRbFprblU5eDlN?=
 =?utf-8?B?SzZIUjU5K2tXSGJwSSttMkY3bkpXWndFZEZoa01KTWcxVkVPRWtJdXNYbkZI?=
 =?utf-8?B?RWw4WHY1SlpDcVEwV3hOcE1SREMzTENZaTJPVE9lUjB3aWhReFd4a1g0TmZa?=
 =?utf-8?B?aTFoNjQ3dTg2M1lGSDB5TWFGcVFNdVplZitLQlVPOFpDSzV6U2FSVmZjcVZB?=
 =?utf-8?B?UFJldFNUbTZaY0lhU1BTTGM3cU96Nm1DYjB2ZW04MlJEVG1OVlVVclo2L3cw?=
 =?utf-8?B?dEJBdENya1hrYXdMbnZ6RHViK2dnakJhS012cDZnR21FRFk2UkhsWlNhNDRJ?=
 =?utf-8?B?NitCT2lESk96WmF1QkZ1UytHekt1czhuOVN4NkJvK0dLM0lUQ1k3a1pGSUJi?=
 =?utf-8?B?THhuVTFUTTFSazlMZlU5d0hlU016Z2hFYU5zd01RSlc3VzFleFJocFFHMnd1?=
 =?utf-8?B?eXRnazAzdEdETUZWMXFDMTVOVGVGUlF4d3JmSFRjZ09pQjF0Y0tNVzZ6a25R?=
 =?utf-8?B?T1k2blJHdzZqaUVlRFpiWXo2QjlYZ3oyNTJYWlhRdS9uaXIyRHQ1RU9sTi8z?=
 =?utf-8?B?QUpnbnFVWHNHcnhwYXc1dElLaCsremkwaVdLZU0vd0FuV3NRbG9RZ2hmVHJa?=
 =?utf-8?B?N0laaFFmeDZjNC92SFJvTmJON01MRlVJVUgvUWtUREY0WHFEa0FPVXkwMjQ5?=
 =?utf-8?B?L09nanhQU1d2MVUzYUVXT2txTWY0ZzVLdDQwZ3ZXWVh2WjcxaGdzMExhWUlv?=
 =?utf-8?B?RWVRUXVzSmlXZGNXd1dyRTdZQXNJUGNydFVBTkFSSlM1aWVKNWtZYk9NVXJr?=
 =?utf-8?B?bWRWNmYvaDhLOUp2b0xOVWZyV1l1QmlIQmR0a3lrSDlxeWZCV0tOMzhKT3Iv?=
 =?utf-8?B?bEJ2d3NCU1lXY2JCVjBOUnNnZDNtd1RveEx6anU2OU1CcFlBbk9iU2phTTVO?=
 =?utf-8?B?KzIrdlRWeUdLOElacWpsOW53dE1zcU1aV3EwMnF5dTFZMkh3bitCSU1TTkh5?=
 =?utf-8?Q?L9vCEv?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR02MB6367.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c291cFZzMmJOYVBvejI4cWRVVjBxdHJxTTlxNzNnM0NxOXN4L0l6Z282eUw0?=
 =?utf-8?B?elYwd1IyTEFQZThHVlZyRmJ0U3RHR1c1MFJMWTVDM1NUQzJUVGVwbG5Yb0pK?=
 =?utf-8?B?bGRCdENwSXg0V0JBU05PSXhzZlFyYzZiRmtSb24wUXB4Q3oyTUcxMVFJcmVQ?=
 =?utf-8?B?QWNJL0tSZ1J2N2RWZmVkRWVwWWlPZzFycm5taW1ONU1nRXVOc3hhZURtNFFM?=
 =?utf-8?B?dlRjdjg1cnF1M0hVZjhoSXIzbUw2aW9saUVuVDBnMmJCV0VtajQvckxJSUQv?=
 =?utf-8?B?Rk5wVTJDM2kwQStaekRVMjJjYkpMMDFJcVBHMXRJYWhiVjliSmxmZjZjdmdx?=
 =?utf-8?B?dnpSN2w4Qm9ackl5dkRSbGpXUW02cTVJYnBtM3BhNzRwYk9heE1JQVkxaURL?=
 =?utf-8?B?YXhBZkhKeEVtUnpoQ1dIcTRja0M0VEtMajFlN2E5LysxU1VsQjhZSUhSeDBG?=
 =?utf-8?B?d1BCVkFhdWhGWWpsdzMyKzFqY1lTQjkzMktwMlRaYUtzbzI5dkxCQnZFZDJm?=
 =?utf-8?B?VFgzdTFQYlJuSGNLcVJ2TXZGZUY3VzZ6MnVMdDlmRVhra0hUTnE0VVRJTFY1?=
 =?utf-8?B?Z3VONTVWcXNRQklOK2ExSmY1am1nTEZmREpqUVZ5MkRtNlJmQzZtaktycXd6?=
 =?utf-8?B?ZmEyWVEwR0s1Kzk1R0VObktPU2N1Vyt2eUE0RGpHVlR3UG5TTmpoRE9JN2Zj?=
 =?utf-8?B?dklCSjBYOU1Bei9WazgrcTZUSENCcTZZZ3k2TlR6REFiYlMwTmx4WVNTQ3Fj?=
 =?utf-8?B?Q283THVyUWlDUkgzZ0ZQTW4vc1RxMTFJSnN1S1I5ckpFZTJFNXMvRGFqS3lT?=
 =?utf-8?B?QXF4UWdyNUdVcVNDMkpjNkRibmV0MFVSbmNJNGJ2L3JVbEo0cWN0cDUrUUlz?=
 =?utf-8?B?ZDNJWFNack1SWjlyQ2FTR1NpQVpKU0dGQnlPUktuLzg3RndxVEpROFdQeTVk?=
 =?utf-8?B?eE9RTy95VTQ5UFRiYzdHMlR4Q2R2WE13M2NOTjlvOWU4NUZFd2lueG1JdDA4?=
 =?utf-8?B?TXFFVm5qSHdZSkpmcC9yZlpWLzExOUw2UWx0MCtJY0pXZmpDVmt5M205ais3?=
 =?utf-8?B?cUMwaUtha1J1QTVlWGd1Q09saTRKUHZlNzdYc3JaTXd0SzIwTkcydlVSQjYz?=
 =?utf-8?B?UlpIaDFXazVLbTF1VUVLalNpVU5CRElVR2NzQ3RHbUFCZXlmY2plaE5wYXlU?=
 =?utf-8?B?OGZ2SlMrUU0rbkxpNEdzTE5ySlYxa3FxbU5CZ1hibjNqdUhBREZQUS9SQlRw?=
 =?utf-8?B?eUQ4NTdTcitHampRRkRxSVQ0K0dnQXdBVVFTSXN0WENTWlc4ZGUwQXRkczlL?=
 =?utf-8?B?TFg0ZG1MNk55OHBsbmo2V3ZyNHk5cWNlUG93ZlN0UGtWMStkdVgxNDh0U3l0?=
 =?utf-8?B?MlBkdWYxK0hEb2FGTzNEbHhxWmVlT00rcFRxQzdzRVc5L1hnODJpZHlDSE5k?=
 =?utf-8?B?cnZPUzB0dU1XZGM3VFJNT0tSMG04T010ZnBaQ2hjRVRQWDdmOU9WQS9TWjZD?=
 =?utf-8?B?eHhPblRHdlFxZklaOGJ5SDB2V1F6eThBM2FlRFEvaVRheDRxRjlwUkVXSUU4?=
 =?utf-8?B?WjZla21TdXdqYUtQNFpnenpSV0tqVFRydllTWVMzMG40UzJaSGRodlJuUURH?=
 =?utf-8?B?a2phUTl1OFJ1cDJsbVNmZFJIQllVUkxQZmN0TlhKSDNKdVp2ZFRLK3VoVDV5?=
 =?utf-8?B?TUFWeUlZTlZWYXdSTlpEb3VQeTdWWkdnTHJnTnpCdFB3K1kxVnBocTZTTElO?=
 =?utf-8?B?NHFDaGtmRnh5aytaajZ6L2VLZEFRM3FYcVdGVVBYcjhDL3VEbEpwYjNzdjRY?=
 =?utf-8?B?SzQrVkxGK0lZWCtyWGlnZVhJOGlURlVrUjRHZmFWZXl4UHBRVEJFUFhPRDA0?=
 =?utf-8?B?b20xdEkwMm5wN0J6VWU2L1UydFRsSGp3R1pBbmIrTXBob3gxZWhhbnh1SlVj?=
 =?utf-8?B?NUl0c1VpRFNBUHFJZjNocitiOVVkTTRRSXhrNmEvWnFPMkFVeWUrTTJrK2k0?=
 =?utf-8?B?K3RtMUJSZ1JOL0w4UmU0ZGxZTTBnaGV1ZVNQb2hGV25odm1HbWlwazFRRTQ2?=
 =?utf-8?B?dG5TVlZvUE53TWpkbXUxbWs0Nm05czhBV0hpQnAyRGxmZGhPZElmaFBsaXBJ?=
 =?utf-8?B?NmQxYWRpT2hFeDZjV21zZ2o1S0FVNzAvUGlad2lUODZnRXdkaG13M01uSkVZ?=
 =?utf-8?B?NEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D63E29BF0120E943AFF17D7D0FC61639@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8648283c-8a31-4eda-74ef-08de1a929e47
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2025 04:36:55.6039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UIar/rPuFGhA5yNIzwge6x/Li4xZnLfqlaQr6STHDLEd385j8K1ImY92MlKeohGw/GBJGEuDpIKmeHwVVMkk7I/6usi4pnx3tfzdjWtoPy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6817
X-Authority-Analysis: v=2.4 cv=YpQChoYX c=1 sm=1 tr=0 ts=6908316a cx=c_pps
 a=pY+kOdcf8RAo0+yonGAjpg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=DRBcsuOvayzXcs_ae-UA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDAzOSBTYWx0ZWRfX4B4Nns0uTq4+
 utX2WBx2W9lL9KbsFNtr5IVm9amYMduWWmUlFyLovIfVrndY0gj0bKKMPHMeYJXxAD4kzvQxdPq
 a3E+DBNpucylWzon9M9q9nIJgOeO3/Oog5WGVy/9Y9XSgsAfvYkt3bheIpQ6P1if1+hPztGfn/G
 2aHY8RJRUNSrB20xsy4SR/ynd7F9difDRKzgadhrZwNBb3sz+qD4v05Q2iiC8n4Dfj6wBOvsNvA
 JJqkJ97EHvS7dGNS6QEBn7GkvdKNFylYbt+8apxLUt/y4gKPInXadL/yk02M9jE4PcHXZsb38x1
 KmzTgHzaGVGoRSZz6w3IEWxJdJmDxCVzcF0gGmS9XNVnZnQ6kG1dJbbqifuZkODOrznNLKvEXEI
 EYKUVIiLDWyQ4HSXxES40iTyyOqQRw==
X-Proofpoint-ORIG-GUID: VkqkMDeDdb0NFWgypNzki4-LKFaqYgg8
X-Proofpoint-GUID: VkqkMDeDdb0NFWgypNzki4-LKFaqYgg8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-02_02,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

SGkgU2VhbiwgDQoNCj4gT24gMzEgT2N0IDIwMjUsIGF0IDEwOjU44oCvUE0sIFNlYW4gQ2hyaXN0
b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+PiBIaSBTZWFuLA0KPj4g
DQo+PiBUaGFua3MgZm9yIHRoZSByZXBseS4NCj4+IA0KPj4+IE9uIDI1IE9jdCAyMDI1LCBhdCAx
OjUx4oCvQU0sIFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToN
Cj4+PiANCj4+PiBNYWtlIGl0IGEgcXVpcmsgaW5zdGVhZCBvZiBhIGNhcGFiaWxpdHkuICBUaGlz
IGlzIGRlZmluaXRlbHkgYSBLVk0gYnVnLCBpdCdzIGp1c3QNCj4+PiB1bmZvcnR1bmF0ZWx5IG9u
ZSB0aGF0IHdlIGNhbid0IGZpeCB3aXRob3V0IGJyZWFraW5nIHVzZXJzcGFjZSA6LS8NCj4+IA0K
Pj4gSSBkb27igJl0IHRoaW5rIHRoaXMgYXBwcm9hY2ggZnVsbHkgYWRkcmVzc2VzIHRoZSBpc3N1
ZS4NCj4+IA0KPj4gRm9yIGV4YW1wbGUsIGNvbnNpZGVyIHRoZSBzYW1lIFdpbmRvd3MgZ3Vlc3Qg
cnVubmluZyB3aXRoIGEgdXNlcnNwYWNlDQo+PiBJL08gQVBJQyB0aGF0IGhhcyBubyBFT0kgcmVn
aXN0ZXJzLiBUaGUgZ3Vlc3Qgd2lsbCBzZXQgdGhlIFN1cHByZXNzIEVPSQ0KPj4gQnJvYWRjYXN0
IGJpdCBiZWNhdXNlIEtWTSBhZHZlcnRpc2VzIHN1cHBvcnQgZm9yIGl0IChzZWUgDQo+PiBrdm1f
YXBpY19zZXRfdmVyc2lvbikuDQo+PiANCj4+IElmIHRoZSBxdWlyayBpcyBlbmFibGVkLCBhbiBp
bnRlcnJ1cHQgc3Rvcm0gd2lsbCBvY2N1ci4NCj4+IElmIHRoZSBxdWlyayBpcyBkaXNhYmxlZCwg
dXNlcnNwYWNlIHdpbGwgbmV2ZXIgcmVjZWl2ZSB0aGUgRU9JDQo+PiBub3RpZmljYXRpb24uDQo+
IA0KPiBVaCwgd2h5IG5vdD8NCj4gDQo+PiBGb3IgY29udGV4dCwgV2luZG93cyB3aXRoIENHIHRo
ZSBpbnRlcnJ1cHQgaW4gdGhlIGZvbGxvd2luZyBvcmRlcjoNCj4+ICAxLiBJbnRlcnJ1cHQgZm9y
IEwyIGFycml2ZXMuDQo+PiAgMi4gTDEgQVBJQyBFT0lzIHRoZSBpbnRlcnJ1cHQuDQo+PiAgMy4g
TDEgcmVzdW1lcyBMMiBhbmQgaW5qZWN0cyB0aGUgaW50ZXJydXB0Lg0KPj4gIDQuIEwyIEVPSXMg
YWZ0ZXIgc2VydmljaW5nLg0KPj4gIDUuIEwxIHBlcmZvcm1zIHRoZSBJL08gQVBJQyBFT0kuDQo+
IA0KPiBBbmQgYXQgIzUsIHRoZSBNTUlPIGFjY2VzcyB0byB0aGUgSS9PIEFQSUMgZ2V0cyByb3V0
ZWQgdG8gdXNlcnNwYWNlIGZvciBlbXVsYXRpb24uDQoNClllcywgYnV0IHRoZSB1c2Vyc3BhY2Ug
ZG9lcyBub3QgaGF2ZSBJL08gQVBJQyBFT0kgcmVnaXN0ZXIgYW5kIHNvIGl0IHdpbGwganVzdCBi
ZSBhDQptZWFuaW5nbGVzcyBNTUlPIHdyaXRlLCByZXN1bHRpbmcgaW4gdGhlIHRoZSBJUlEgbGlu
ZSBiZWluZyBrZXB0IG1hc2tlZC4NCg0KPiBPbiAzMSBPY3QgMjAyNSwgYXQgMTA6NTjigK9QTSwg
U2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gVGhh
dCdzIHRoZSB3aG9sZSBwb2ludCBvZiB0aGUgcXVpcms7IHVzZXJzcGFjZSBzaG91bGQgZGlzYWJs
ZSB0aGUgcXVpcmsgaWYgYW5kDQo+IG9ubHkgaWYgaXQgc3VwcG9ydHMgdGhlIEkvTyBBUElDIEVP
SSBleHRlbnNpb24uDQoNCg0KU2FkbHksIHNvIGlmIHRoZSBxdWlyayBpcyBrZXB0IGVuYWJsZWQg
KG5vIEkvTyBBUElDIEVPSSBleHRlbnNpb24pIGFuZCBpZiB3ZSBkbw0Kbm90IHdhbnQgYSBndWVz
dCByZWJvb3QsIHRoZSBvcmlnaW5hbCB3aW5kb3dzIGludGVycnVwdCBzdG9ybSBidWcgd2lsbCBw
ZXJzaXN0Pw0KDQpVbmxlc3Mgd2UgYWxzbyB1cGRhdGUgdGhlIHVzZXJzcGFjZSB0byBoYW5kbGUg
dGhlIEVPSSByZWdpc3RlciB3cml0ZSBub25ldGhlbGVzcywNCmFzIGRhbWFnZSBoYXMgYmVlbiBk
b25lIG9uIHRoZSB0aW1lIG9mIHBvd2VyIG9uLg0KDQo+IE9uIDMxIE9jdCAyMDI1LCBhdCAxMDo1
OOKAr1BNLCBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+
IA0KPj4gYW5kIHVwZGF0ZWQgdXNlcnNwYWNlIGNhbiBvcHQgaW4gd2hlbiBpdCB0cnVseSBzdXBw
b3J0cyBFT0kgYnJvYWRjYXN0DQo+PiBzdXBwcmVzc2lvbi4NCj4+IA0KPj4gQW0gSSBtaXNzaW5n
IHNvbWV0aGluZz8NCj4gDQo+IEkgdGhpbmsgc28/ICBJdCdzIGFsc28gcG9zc2libGUgSSdtIG1p
c3Npbmcgc29tZXRoaW5nIDotKQ0KDQoNCkkgYW0ganVzdCB0aGlua2luZyB0aGF0IHRoZSBvcmln
aW5hbCBXaW5kb3dzIGJ1ZyBpcyBub3Qgc29sdmVkIGZvciBhbGwgdGhlIGNhc2VzLA0KaS5lIEEg
cG93ZXJlZCBvbiBXaW5kb3dzIGd1ZXN0IHdpdGggdXNlcnNwYWNlIEkvTyBBUElDIHRoYXQgZG9l
cyBub3QgaGF2ZQ0KRU9JIHJlZ2lzdGVyLiANCg0KQWxzbywgaW4gdGhlIHBhdGNoIGluc3RlYWQg
b2YgYSBrbm9iIHRvIGRpc2FibGUgc3VwcHJlc3MgRU9JIGJyb2FkY2FzdCwgSSB0aGluaw0Kd2Ug
c2hvdWxkIGhhdmUgYSBrbm9iIHRvIGVuYWJsZSwgdGhpcyB3YXkgYXQgbGVhc3QgZm9yIHVubW9k
aWZpZWQgdXNlcnNwYWNlIA0KdGhlIGJ1Z2d5IHNpdHVhdGlvbiBpcyBuZXZlciByZWFjaGVkLg0K
DQpPdGhlciB0aGFuIHRoaXMsIHlvdSBwYXRjaCBtYWtlcyBwZXJmZWN0IHNlbnNlLCBJZiB5b3Ug
d2FudCBJIGNhbiBwb2xpc2ggaXQNCmFuZCB0ZXN0IGl0IGFsb25nIHdpdGggcWVtdSBzaWRlIGNo
YW5nZXMuDQoNClJlZ2FyZHMsDQpLaHVzaGl0Lg0KDQo=

