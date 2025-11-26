Return-Path: <kvm+bounces-64693-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 389F9C8B0CD
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:49:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4E5294E3488
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC802F83DE;
	Wed, 26 Nov 2025 16:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="yRkVuxeJ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="F4+DRZ0Y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8878B33DEF7;
	Wed, 26 Nov 2025 16:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764175721; cv=fail; b=IaJYRB/Zn8fdGvDwqeUjoSDsKCpJMKdTozb3OQvZvpHFQWbm0wMBf7NwzSJQbYT5SkGv7jQCwuAmctvEXPyl0hG0xTVko3QfX1yXE7m89zxmwLQmGpNy0+913GF5eBkjZWE46ZEmse4v47pUqOJ4CnxzwQh8rTyv9tqbSaUCwOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764175721; c=relaxed/simple;
	bh=CQxwlDG9unvOUO48ZZPni/tG24eRUChvTh+llPRcZpo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O2pgiUv8LNcGDX8vw7meRW55+6DiF29LZdMHFw5uEvoWI/nc4BuSpoLLWgrbxmP3OOLAzbZ7k0BAslGEMeMcSzk+F7zWRA+2G1ul2qq++VvMrvC4wHA0Uy9bVq4NJ6TWXGj6fRz8D21YTcsk++G0axNxVcQ9LHFKTif0sWVdWFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=yRkVuxeJ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=F4+DRZ0Y; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQDJSep1710395;
	Wed, 26 Nov 2025 08:48:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=CQxwlDG9unvOUO48ZZPni/tG24eRUChvTh+llPRcZ
	po=; b=yRkVuxeJBg/u6AcaqWo7+5a6MhsPRhl8cvMFq3SACs9wL0sCOWFXpljjc
	hiJEaogEN2M6kKcFCHUbcQ9y29zak0Z2hifH3hMB7ybQhR/KX+3L9G3ECw5rtteZ
	uPoPsOFYs1+ExPjWhzLl2LOmOvJoUX70ScfnL6xTh9szX5xeb5IKSaFwFWx6Qyo6
	EsrgtXdwu4nbIY578eN84qux0JUryJKqLDL8UaNs4KfgO0viTctlojFUV5VqbJlh
	CsERXzVbB0v3E0PZ8YVBM+DlRLhFlz7B+WRuq6cUl4fb+rVd8MPGNpGlJolEJ2HJ
	OBRVimr9M3y3bfPuecUavvkNnYAew==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022088.outbound.protection.outlook.com [40.107.209.88])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4ap2b78esd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 08:48:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uZjICtBK/hqSNcukLG/rMhs69JMiPwcN0YfOWrkUxPyLxxBjjceWCpPk/a+scOOJRylJq5okw8lfN3CwSBUkYVNQlplpdn/Ids7TPlDrHX0LfFBdmDGAg2CmYAwuKmWqFjMcJVwwwXP/XuwYSeJuozE4UY2D/m8VZDevjTZR4pgyMl7/UmgdKS4D6v9GMsRWHYY17mQOYxMl36FZBLmvqlAE3odvxs6Ls3j2VscA/U3xD+e6hdVsb80dVZBr5zYUczx9UkbiJ1uCuSYMCUhFFSIv+/5tUV7TvBYDC3wBKGdWadRlv3jrxqiBDBytWUJyYOOCIKRsnznLis8KKtyAEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQxwlDG9unvOUO48ZZPni/tG24eRUChvTh+llPRcZpo=;
 b=d6z910w0KzMocArkBxKxIdcXvhMy+d5rFa4sYyLX+VYhov3OA+CUZoJ7ZhcCmUvKDm0aBSIHZJUmutkOFrNvvMlZBJ2aIxPqbTyDBAVuqJzzer1qphOZVV1WDNKJA0IcwpCVg5f2Zuxhg/SSwbxjFVUQpoqy1L+b55U/t0jwj4idO8/1QGfL40nY0S8KEgGxU9HWnUw3D8Pk7xLPmU73upU4qDHiIxVRowd7z/+l+SY+EzbAnXo3K0CDf/rBlJFgh+kErNDJIM2/TAOJALJScg/+q0XftDo0kamXAsLEnyURsxHijirx04WbEy8xM2MXDSdD5N7yi7jcmlWy23oFfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQxwlDG9unvOUO48ZZPni/tG24eRUChvTh+llPRcZpo=;
 b=F4+DRZ0Y5u8ViIdU8mojXSSX3mDX8hYxmGyqVVPfyAgmcJjhhOB+2ai1YzENDZWSUKiNbImDB9ReZ86UMsLI286vs6tBkUP26Nh224Wt+09a5niFSMdGDPjY5y0K9aBpRMKqRL9X/E1WwPfCwhWXQo8JHE0a2lmUqUzJNLXX/ppprS2QVUK3L9daCy08XlLKiqRdOoDPDX0UoKNB6p8ks+8vCMgm953Ni80Hrt8C/zv/031JLTOpAJpgPTZwBdjkXpkevVW6Pgh/H/JPRTWO8NGz3ncAWlxfWlLkp+sVeF2URWNLm4uTuq1Ue5ov2KDrO6vXqDtK4HdYAfAMka+fCw==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by CO1PR02MB8618.namprd02.prod.outlook.com
 (2603:10b6:303:15d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.13; Wed, 26 Nov
 2025 16:48:32 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9343.016; Wed, 26 Nov 2025
 16:48:32 +0000
From: Jon Kohler <jon@nutanix.com>
To: Jason Wang <jasowang@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?=
	<eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] vhost/net: check peek_head_len after signal to
 guest to avoid delays
Thread-Topic: [PATCH net-next] vhost/net: check peek_head_len after signal to
 guest to avoid delays
Thread-Index: AQHcXi98HPUjRK7uJEmyz5eQdWvl9LUEe9SAgACwwAA=
Date: Wed, 26 Nov 2025 16:48:32 +0000
Message-ID: <28F3518B-B24A-428D-BBE2-A1981D857A4C@nutanix.com>
References: <20251125180034.1167847-1-jon@nutanix.com>
 <CACGkMEv22mEkVoEdN0iPdgeycOEn8TaXcg-y5PGHTjw9YvTKpw@mail.gmail.com>
In-Reply-To:
 <CACGkMEv22mEkVoEdN0iPdgeycOEn8TaXcg-y5PGHTjw9YvTKpw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|CO1PR02MB8618:EE_
x-ms-office365-filtering-correlation-id: 6b75addd-3b65-40e7-81fe-08de2d0ba288
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|10070799003|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?N3Bhb3VJTEhvSmN3NGx6T1JIdVZSektPbGpQL0FjcE1OdVRGaUhoTFlHSVRm?=
 =?utf-8?B?OTFDV0ZSWjJLalN2bFVQNU1YNWthM0lFTG05eTdWSGg3UUVzdXIwdVRpbml6?=
 =?utf-8?B?S21wdFRDaytwUnZQRFkrL0s0U2YwM3BZZmxiWEd1b3NjL0gvOHBhM1BFa2pH?=
 =?utf-8?B?blVRYVA1ejhSZklqRG92cURsZk5SRWJzaE9rV3k5alFqSDhZV25lcVJ3cnZ3?=
 =?utf-8?B?RnNKWVd1R1VmTmM0cnVsTDl5SlVHb0hHL2IwYThyMkZFbElBaFRsamhUME1s?=
 =?utf-8?B?aEwrTHVHNUR4OUlvU3MyNGZGUHFsYVNINlQ3RlFoZEdheFlqd2s5ODcwYnZo?=
 =?utf-8?B?NDJiRlY5MXc0WEc2WjB4L1JwQ3U0endkU0VqTDd6bWxtVDFBUEZRQ3o0S3Jx?=
 =?utf-8?B?SjdzcjEvTDFDbHk0TE43aS9GY2JiRE53aXlnQzdQOUk5dzVJNktGeEVRd21q?=
 =?utf-8?B?OURDUTJacjBZWHF4VWRZMkZCWmRjMVF0RmxRY1hubjlwcmwwQmtxWXVQdjM3?=
 =?utf-8?B?L1NKTWhLcGkySW1GVDZPOVd2WkMvZmtKQXlLeU5pZSsyTzNEaHFjanM2THFY?=
 =?utf-8?B?am1mcjdRbVlxWDFJRHNzTUFDK1BUbnJuNlJ6SU1DbGM4TTlYdWE5S3AvSU5Z?=
 =?utf-8?B?b0ZOc01wL0xZcWZsYkxIbWxpVkE2cDg3a0FSSE1KWTlTdTc4aEZhays2WWRn?=
 =?utf-8?B?MVhXZElBbFNSZWQ3d1RVK3pkS09uK2xHTWxLNS9pOTBVZkkzTk9IOFJGamJh?=
 =?utf-8?B?UUM0bEV2NGEyK2JMZ2xIQml6RmN2dlg0VXRuQkprNmMxMHVQaEpjN1NhdDA1?=
 =?utf-8?B?WnVzTDNVMjB3anZnTStmRXpSUk1nd285NDhhbisrTVZybWI4clJpUC9oQ08v?=
 =?utf-8?B?T2JCSGtGMTVvQysxN0wzbTVkdnFYY3ZmWnFoK2VwZUpXZHlsMnJmODA3N01W?=
 =?utf-8?B?b3JYRnFvN2tJR1I3NElXeWtUTVk0YU03Q1JNMFNISXF2U2FiaG5CN0grMDQy?=
 =?utf-8?B?S2ZaT0kyMjAxR1JhdkYrZHhiVU1rWGFMNlgzRUxYWEtyd1NaeEN5djI3NVlJ?=
 =?utf-8?B?WHVYUE1NTHM5SjZ1QWt1UWd4dXErUElLR3BkZFdOeStLdUsrMmxnTW81YjJj?=
 =?utf-8?B?R1pEbTA3ckNtcVZWOXNtaHY0ZUxXZkduRDl6ZlRzNXRHNUJEVXlQbmxOQUdu?=
 =?utf-8?B?OTZqc3pST25ieWU4Tno2b1dSL0s1U1RjZHE4dGU1dExsb2RUcXhxQjZaQUdL?=
 =?utf-8?B?eS9PT05yUW5GSENxelNyMStlWFhyOWxiVXdOZWJTV2ZzV0xBSExjY3pySEdN?=
 =?utf-8?B?N2kyT0lNNEtOVjN5Tm04a1BvWk5YVTFDU2pVTWFIbVBEdFc3dm54MTZsWjZa?=
 =?utf-8?B?VWdiNm01RGJYKzhEV2lNZ2poZjRNSHFEenE0OXVOMWVTRDFBalJFR3h5QXNs?=
 =?utf-8?B?TG9McGl4a3pYbTlQRXJabHFGd2d4SzcvZ2c1YVNMN2VKbDhMYm0yckRtcFk1?=
 =?utf-8?B?VDNsWjZ0Z0NURFNSb0xVeGhyT1h4ZHB2bVBRUDRubE1yakNEcEN3YXA2aytL?=
 =?utf-8?B?NkNrOEFjRzlvT1BFcjdzMFpYZG5zeGpuRzlTbEIyS21KUlRlaXQ1aGdjZW5G?=
 =?utf-8?B?NFU4MFFDOG5mRnNGMzN2VU9zeE9VZUtQVVVvYmZCNmh0b1gyL0RaMUg2S3Zx?=
 =?utf-8?B?cWowc0V1VEZrZTJBZ21GYjd6TE91UmcyYURhR2JVRjVrSnFQdFZwK1NzcWF3?=
 =?utf-8?B?NDZPcXErWGpHWkhBUDNuSEFpYzhoSHhqRi9KOTRDSS9FNE9IQXhwZk01MDVM?=
 =?utf-8?B?ZWxpUUJDOUdWQzMxZENaTEVEMGcyM2lkMS9aQThTRE16cUNvWncvWlZBdnpj?=
 =?utf-8?B?a3FENEJkSk41eDlpaVY5NEF3RHRrWjYyK0lnWGcvc2pzdHB6Mkk3VnVuVFFw?=
 =?utf-8?B?V0RrbWgvaytWOEFMTXZFWEZvc0RPLzZScGtFRTJ2Y042dzdrZVR5M3UvRXJX?=
 =?utf-8?B?MlVlVWcyTzU3K0RkcXA4ZjdnUytGWWpGU0N2d0hCcDQ3dm9tZkRkUFhaZ2gz?=
 =?utf-8?Q?h2L6N2?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(376014)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UzU1RWx6dUZZOWVWUld2Unlicm0zVG9zbGJNUXV1TDkyNFN6SllXVVh5VWEr?=
 =?utf-8?B?emRWNDM2L3RWWEZXZlduMUVXemoxZHVxeHJTY0Zsano1aDZPdnR3YUwrckJv?=
 =?utf-8?B?eW42cjdNNHMzTUVOSDk3eUFnbGRWUGdkTEszc3hhUU1XMGFLd3ZtMnVUdnMw?=
 =?utf-8?B?bkpSRXk4UU40Y3dHZWV3Y0UxV01OUXNZdmE3NDNiVDBMQ2diY3ZmWjREQ3Jj?=
 =?utf-8?B?cTBncHErTGlQNlNXWGRmNXlLWnNTc2pzS1hna2ZGSUN3bTA2UXppQW55SGlH?=
 =?utf-8?B?ZytWL0U3QW5jTm10cjVJUGlVdUNadnNnYXMycUp2dDdSa0VwZStONGJ4Z1Fa?=
 =?utf-8?B?cEZGb2lVcWxoRGN0WThhbnErdVVFR3ZTMXBURE9HWGdtMjFsV1FEd29LZXhN?=
 =?utf-8?B?ZFBuT3AwYVo5bVFPMUlUM0kyM3V3NTBMbjhXZFRqcE5rU05teEplVVU0aEV2?=
 =?utf-8?B?L2lESEtUMzhhU0VmR1hhZTlMUHZ0NXBmeUJyRUUySW8rVFI5eituNnEzZklm?=
 =?utf-8?B?M3U2RmFKMjQvUzQzS0NEU0FJbjRSQnhrd2Q3ajArVTB0VnZVR1MxTm53RXhl?=
 =?utf-8?B?M3QrSGM5M003T1FaNHZBY1ZzRGpIOEtWSE5WQU95YkZabWNUYUVHSVgxamR1?=
 =?utf-8?B?V09TYldCMlZXU2UwY0lZVXZ1VVJ1UHp4cmVjOWVQYmR5ZUdrakNJdS9uckpG?=
 =?utf-8?B?RlE4UkNNWDdaTHI1L3FXcDVNc1pJZEtLUXNOOERHNm9UbnJZNklkTmJPanFH?=
 =?utf-8?B?WjEwVUdtMzB3ampCR3dOcjJ5TjRTK1ZVSCtyV0lSaW1lMkFHbGd6L1ovYTVQ?=
 =?utf-8?B?K3FOQmlMSEdLcDhlUXdmY3ZPbWtDT1NHb0ZCK2tMWTU4emR2Z0RCREZMZHlZ?=
 =?utf-8?B?YU5oUThnTkl4S0tjVSsvYjl4WUF4NjVZOEtVcjRtOTMvUE1CVnNIYm9NRXdh?=
 =?utf-8?B?dmJ1bGZmSnc2RmU0NHg1aXc0cGV2T1JUVUkwUVd1ejFzMFpxWTZmWVNZZWsz?=
 =?utf-8?B?dk1qdThCY0VsN01WY3dKNldDT1h2WFYrL05CeVFtVzMvMjJCN0JQemxoQXFT?=
 =?utf-8?B?b0lzRWhRT1lWVmRrTjhFOUs1eG5udC9LaXVGZlVKY3FCQndMSE1JM2JNODFr?=
 =?utf-8?B?c280UzZIbG8vWm0vckR2VFQ0SzZwbGFPazNrRmRwL0RLY0VxZWRKZ29RWkJs?=
 =?utf-8?B?b3hpWHBwblpCSkM3YlhqWlhFZko4Wm01L1VpdUFBdVI1Ym1Udm85U2ErYUFj?=
 =?utf-8?B?dXdkSHljT2JZc1plUmtTNjhid2ZVTHJNLzBkc2cwSUhnRDViWDdreTJxeUts?=
 =?utf-8?B?YW1tNVMwNmlUSXZoTFBRbmdFeDNlTjVoNVd5OHR5SXVHS3RmL0xaa21RYWJw?=
 =?utf-8?B?QTloUmZSanZzbHMzS3Y5YXEzRkVwTGVVY09aejlzSFlqbElqMmo0RStjTThQ?=
 =?utf-8?B?a1ZKdkxoSCszQitUTGlmTVBoL2t6eVpzUjRtYTlZN3A5R0pUOU1QZHFtZCtp?=
 =?utf-8?B?RWZBMnVMV0hzaXFTZ2ZlL1FhT283eHN3N2RsS0hjZy91TTU3UG52S05ha0tE?=
 =?utf-8?B?Q0RNczcwNk94SGxWc3UxOVkwbjh5QzYrcUNuTEI5amxyTDVRZml0VFdOSnFV?=
 =?utf-8?B?K0trMytQOStvdEZxeEg3Q2ZWT01SeGFkSjRmUTYvOHRma3hTVzluQnduWkpY?=
 =?utf-8?B?QzR2QXYyaFRhTnVOcGI5WUJicnZpNitVS1dpelNnTHptdGMrWUc2VndYS0dJ?=
 =?utf-8?B?ZTVnZkZ5N0pwcktGUjBST25PWVRLenhHYXlud1MvYlpBMk5kYm9Wd1NhaEFi?=
 =?utf-8?B?WVljaVcyUmUxSTFUaDRhUk9lTU9CUlh6UjFHRExmRzdGcDhYWm5uNC9YZFF6?=
 =?utf-8?B?aU1iU2s5Nk9zelJXeEVVK280MzJpZTVpYnVlQ0xLNFgwVENCOVhKU3RsdzIx?=
 =?utf-8?B?anI3dEVPWnRqSXZybjBQeXNNeUlRR1RBZ1lBNFh5YnhWaitMM1BHOVVVYllQ?=
 =?utf-8?B?anowNHlETCtlS2NFVVZGZ096ZWk2U01DeU9nU1ZsMHFZSG5PVm5McnNMMGta?=
 =?utf-8?B?U2l5aXNmQUFwZ0hZRklMMnhKM3Z5WnlnRzBPS3pIZ2xrbi8walhMRDUyRFg4?=
 =?utf-8?B?NyttMzFsSVNTeCs2ZDVQdVhBZkJSN3BNbzh2ZnJpbmRla2VDR0daN3BvNWJI?=
 =?utf-8?B?TndFbjd4UU5rOEhyZlFJWk1aS3MyTDdJeksrSmVrSTdRaHlXVVVLb3lZbW84?=
 =?utf-8?B?L1hub2pEUXlvTENGblNjMTNmaGFBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <481D0B842DDBD94FB3FBD14C444B0C44@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b75addd-3b65-40e7-81fe-08de2d0ba288
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 16:48:32.7381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: URmOtCdPANKMMUAdyGU3AwTgyvGMYskJtqEmDziLnXIIWryCCxL5ge40pUTtBLZ7yhQ/raG+4kZUjpqc0UIan6LiDIpNuLhgYBu13d35SgY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB8618
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDEzNyBTYWx0ZWRfX3AIKOAk/Kge0
 00pjDtCsWdKmh7YL8BA8AIgm63d2LWrb+iWtXk1b1wo0bz7vaa+5Xg0io4RQIbk3TY9KJ8rtTz5
 G19BW0sXGFpS0uo5cmZkSXVuGKnEVGR95WcdRP5JOMu+9Va8Cb6dI+YCQCW5+TZtb0LMi4y5oc1
 8Wi+8JAuck5tXNPKamS0Gj1fWIyk/iMaVs2faqM6v9gOYBEQchxXJNRwzteR4uxLNUu7rv7O/q8
 +obcMgszfjNSTA/p6wUSvUZe3O2GJLF3Ll1nHyRr14snlykwbjl4BTyAi5vz0OFZrshGsQMkAke
 /Vbw3v4/bq0wXKp94AMPHr8r4/FtfFM9eMTHtvc6UF3lyH3jbsVrrYIIqbCAJqlm+Cm0kaeXfD8
 c00SXGPJYTcHSX3374MG7hw2imr1Yg==
X-Proofpoint-ORIG-GUID: ZzgpyhMpBK5_a_bZy-8ZYVLg_ChJhfsA
X-Authority-Analysis: v=2.4 cv=SpadKfO0 c=1 sm=1 tr=0 ts=69272f62 cx=c_pps
 a=L9bPh4WBBd4gk+7eRhA/fw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8 a=qgo6x60IZ4buIVWc3jEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ZzgpyhMpBK5_a_bZy-8ZYVLg_ChJhfsA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTm92IDI2LCAyMDI1LCBhdCAxOjE14oCvQU0sIEphc29uIFdhbmcgPGphc293YW5n
QHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBOb3YgMjYsIDIwMjUgYXQgMToxOOKA
r0FNIEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4gd3JvdGU6DQo+PiANCj4+IEluIG5vbi1i
dXN5cG9sbCBoYW5kbGVfcnggcGF0aHMsIGlmIHBlZWtfaGVhZF9sZW4gcmV0dXJucyAwLCB0aGUg
UlgNCj4+IGxvb3AgYnJlYWtzLCB0aGUgUlggd2FpdCBxdWV1ZSBpcyByZS1lbmFibGVkLCBhbmQg
dmhvc3RfbmV0X3NpZ25hbF91c2VkDQo+PiBpcyBjYWxsZWQgdG8gZmx1c2ggZG9uZV9pZHggYW5k
IG5vdGlmeSB0aGUgZ3Vlc3QgaWYgbmVlZGVkLg0KPj4gDQo+PiBIb3dldmVyLCBzaWduYWxpbmcg
dGhlIGd1ZXN0IGNhbiB0YWtlIG5vbi10cml2aWFsIHRpbWUuIER1cmluZyB0aGlzDQo+PiB3aW5k
b3csIGFkZGl0aW9uYWwgUlggcGF5bG9hZHMgbWF5IGFycml2ZSBvbiByeF9yaW5nIHdpdGhvdXQg
ZnVydGhlcg0KPj4ga2lja3MuIFRoZXNlIG5ldyBwYXlsb2FkcyB3aWxsIHNpdCB1bnByb2Nlc3Nl
ZCB1bnRpbCBhbm90aGVyIGtpY2sNCj4+IGFycml2ZXMsIGluY3JlYXNpbmcgbGF0ZW5jeS4gSW4g
aGlnaC1yYXRlIFVEUCBSWCB3b3JrbG9hZHMsIHRoaXMgd2FzDQo+PiBvYnNlcnZlZCB0byBvY2N1
ciBvdmVyIDIwayB0aW1lcyBwZXIgc2Vjb25kLg0KPj4gDQo+PiBUbyBtaW5pbWl6ZSB0aGlzIHdp
bmRvdyBhbmQgaW1wcm92ZSBvcHBvcnR1bml0aWVzIHRvIHByb2Nlc3MgcGFja2V0cw0KPj4gcHJv
bXB0bHksIGltbWVkaWF0ZWx5IGNhbGwgcGVla19oZWFkX2xlbiBhZnRlciBzaWduYWxpbmcuIElm
IG5ldyBwYWNrZXRzDQo+PiBhcmUgZm91bmQsIHRyZWF0IGl0IGFzIGEgYnVzeSBwb2xsIGludGVy
cnVwdCBhbmQgcmVxdWV1ZSBoYW5kbGVfcngsDQo+PiBpbXByb3ZpbmcgZmFpcm5lc3MgdG8gVFgg
aGFuZGxlcnMgYW5kIG90aGVyIHBlbmRpbmcgQ1BVIHdvcmsuIFRoaXMgYWxzbw0KPj4gaGVscHMg
c3VwcHJlc3MgdW5uZWNlc3NhcnkgdGhyZWFkIHdha2V1cHMsIHJlZHVjaW5nIHdha2VyIENQVSBk
ZW1hbmQuDQo+PiANCj4+IFNpZ25lZC1vZmYtYnk6IEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNv
bT4NCj4+IC0tLQ0KPj4gZHJpdmVycy92aG9zdC9uZXQuYyB8IDIxICsrKysrKysrKysrKysrKysr
KysrKw0KPj4gMSBmaWxlIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKykNCj4+IA0KPj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvdmhvc3QvbmV0LmMgYi9kcml2ZXJzL3Zob3N0L25ldC5jDQo+PiBpbmRl
eCAzNWRlZDQzMzA0MzEuLjA0Y2I1ZjFkYzZlNCAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvdmhv
c3QvbmV0LmMNCj4+ICsrKyBiL2RyaXZlcnMvdmhvc3QvbmV0LmMNCj4+IEBAIC0xMDE1LDYgKzEw
MTUsMjcgQEAgc3RhdGljIGludCB2aG9zdF9uZXRfcnhfcGVla19oZWFkX2xlbihzdHJ1Y3Qgdmhv
c3RfbmV0ICpuZXQsIHN0cnVjdCBzb2NrICpzaywNCj4+ICAgICAgICBzdHJ1Y3Qgdmhvc3Rfdmly
dHF1ZXVlICp0dnEgPSAmdG52cS0+dnE7DQo+PiAgICAgICAgaW50IGxlbiA9IHBlZWtfaGVhZF9s
ZW4ocm52cSwgc2spOw0KPj4gDQo+PiArICAgICAgIGlmICghbGVuICYmIHJudnEtPmRvbmVfaWR4
KSB7DQo+PiArICAgICAgICAgICAgICAgLyogV2hlbiBpZGxlLCBmbHVzaCBzaWduYWwgZmlyc3Qs
IHdoaWNoIGNhbiB0YWtlIHNvbWUNCj4+ICsgICAgICAgICAgICAgICAgKiB0aW1lIGZvciByaW5n
IG1hbmFnZW1lbnQgYW5kIGd1ZXN0IG5vdGlmaWNhdGlvbi4NCj4+ICsgICAgICAgICAgICAgICAg
KiBBZnRlcndhcmRzLCBjaGVjayBvbmUgbGFzdCB0aW1lIGZvciB3b3JrLCBhcyB0aGUgcmluZw0K
Pj4gKyAgICAgICAgICAgICAgICAqIG1heSBoYXZlIHJlY2VpdmVkIG5ldyB3b3JrIGR1cmluZyB0
aGUgbm90aWZpY2F0aW9uDQo+PiArICAgICAgICAgICAgICAgICogd2luZG93Lg0KPj4gKyAgICAg
ICAgICAgICAgICAqLw0KPj4gKyAgICAgICAgICAgICAgIHZob3N0X25ldF9zaWduYWxfdXNlZChy
bnZxLCAqY291bnQpOw0KPj4gKyAgICAgICAgICAgICAgICpjb3VudCA9IDA7DQo+PiArICAgICAg
ICAgICAgICAgaWYgKHBlZWtfaGVhZF9sZW4ocm52cSwgc2spKSB7DQo+PiArICAgICAgICAgICAg
ICAgICAgICAgICAvKiBNb3JlIHdvcmsgY2FtZSBpbiBkdXJpbmcgdGhlIG5vdGlmaWNhdGlvbg0K
Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICogd2luZG93LiBUbyBiZSBmYWlyIHRvIHRoZSBU
WCBoYW5kbGVyIGFuZCBvdGhlcg0KPj4gKyAgICAgICAgICAgICAgICAgICAgICAgICogcG90ZW50
aWFsbHkgcGVuZGluZyB3b3JrIGl0ZW1zLCBwcmV0ZW5kIGxpa2UNCj4+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAqIHRoaXMgd2FzIGEgYnVzeSBwb2xsIGludGVycnVwdGlvbiBzbyB0aGF0DQo+
PiArICAgICAgICAgICAgICAgICAgICAgICAgKiB0aGUgUlggaGFuZGxlciB3aWxsIGJlIHJlc2No
ZWR1bGVkIGFuZCB0cnkNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAqIGFnYWluLg0KPj4g
KyAgICAgICAgICAgICAgICAgICAgICAgICovDQo+PiArICAgICAgICAgICAgICAgICAgICAgICAq
YnVzeWxvb3BfaW50ciA9IHRydWU7DQo+PiArICAgICAgICAgICAgICAgfQ0KPj4gKyAgICAgICB9
DQo+IA0KPiBJJ20gbm90IHN1cmUgSSB3aWxsIGdldCBoZXJlLg0KPiANCj4gT25jZSB2aG9zdF9u
ZXRfcnhfcGVla19oZWFkX2xlbigpIHJldHVybnMgMCwgd2UgZXhpdCB0aGUgbG9vcCB0bzoNCj4g
DQo+IGlmICh1bmxpa2VseShidXN5bG9vcF9pbnRyKSkNCj4gICAgICAgICAgICAgICAgdmhvc3Rf
cG9sbF9xdWV1ZSgmdnEtPnBvbGwpOw0KPiAgICAgICAgZWxzZSBpZiAoIXNvY2tfbGVuKQ0KPiAg
ICAgICAgICAgICAgICB2aG9zdF9uZXRfZW5hYmxlX3ZxKG5ldCwgdnEpOw0KPiBvdXQ6DQo+ICAg
ICAgICB2aG9zdF9uZXRfc2lnbmFsX3VzZWQobnZxLCBjb3VudCk7DQo+IA0KPiBBcmUgeW91IHN1
Z2dlc3Rpbmcgc2lnbmFsbGluZyBiZWZvcmUgZW5hYmxpbmcgdnEgYWN0dWFsbHk/DQoNClNlZSBt
eSBvdGhlciBub3RlIEkganVzdCBzZW50LCB5ZXMsIHRoYXRzIGV4YWN0bHkgd2hhdCBJ4oCZbSBz
dWdnZXN0aW5nDQoNClNpZ25hbGluZyB0YWtlcyBzb21lIHRpbWUsIGFuZCBpZiB3ZSBkbyB0aGF0
IGJlZm9yZSB3ZSBkbyBvdXIgbGFzdA0KcGVlayBmb3Igd29yaywgd2UgY2FuIHBpY2sgdXAgcmFj
aW5nIGFkZGl0aW9ucyB0byB0aGUgcmluZywgYW5kIGF2b2lkDQphIHRyaXAgdG8gc2NoZWR1bGVy
IGFuZCBJUElzLCBldGMNCg0KPiANCj4gVGhhbmtzDQo+IA0KPj4gKw0KPj4gICAgICAgIGlmICgh
bGVuICYmIHJ2cS0+YnVzeWxvb3BfdGltZW91dCkgew0KPj4gICAgICAgICAgICAgICAgLyogRmx1
c2ggYmF0Y2hlZCBoZWFkcyBmaXJzdCAqLw0KPj4gICAgICAgICAgICAgICAgdmhvc3RfbmV0X3Np
Z25hbF91c2VkKHJudnEsICpjb3VudCk7DQo+PiAtLQ0KPj4gMi40My4wDQo+PiANCj4gDQoNCg==

