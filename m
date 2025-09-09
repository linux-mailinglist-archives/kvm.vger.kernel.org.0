Return-Path: <kvm+bounces-57096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBC53B4AAC9
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 12:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A62673ACDB8
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 10:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CBE4318157;
	Tue,  9 Sep 2025 10:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="caTe9/Wa";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="RRCOK2Ra"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32ED256C7E;
	Tue,  9 Sep 2025 10:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757414064; cv=fail; b=MqfD5ryKoVR11krZlSn5VOV1QGV0Skxvh4BLE3nlHLAPbg8Peo4ZYDgLXMBeULgTIWhBBTusp/ewG27FsFXvB0aCcnvqGzpxmxeIJu1pliq10myufCDgk5pV8oCMfN8gqB5WDC0Q/pSyxjVkdKGnL9HN+I2CIvdHRQG33xKdijk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757414064; c=relaxed/simple;
	bh=XzvTkjVD+8zH4t1KEdDe3/osdwOfve4rWMbhzVgM3k8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tpniNZkq7nNdG++jNZVR1osszyRUkxie5TUBciiCjphaBZcYO/f6OAWXIRhwwgqtFdi8USQS8lzUkmU4JbX1DeGQ/zaOY/gWkub8pefNbxhpiuaCsut8yl5tYiZeCsXa78wmzWPniO596GJCC0+GzALqKaJbf8w3foC/aEvims0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=caTe9/Wa; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=RRCOK2Ra; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58970vYs2386504;
	Tue, 9 Sep 2025 03:34:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=XzvTkjVD+8zH4t1KEdDe3/osdwOfve4rWMbhzVgM3
	k8=; b=caTe9/Wa7WwVK4+KPtvu1aYpvdW+TsBkGz/JHDlm+3H1y3aRYyjOw1T5w
	gm0yQowsO4jehMVRANbID1bbFq4AeRy1CLRzb+LVR1/YpWFqacN26OTaPHNCkjAJ
	ben58IRSDr9RHu38KWsMenspx+Z7bffap8/QUjX3+NUs9mtCM+jbfitnSlnpt9Gk
	XV+PMr/TssLNVIZAybughM/92zUSbP3RSyihfPcV0AOVWJixgqUlOtumpyKeNaZ/
	BHIfPPs/wVtGIg5Mu45/MmvzdXiMDPym4uG5lietcyIzZk5sAWAkScwYTN8aNnPg
	CCASA9uweZZ6bQX3LLknwA7V7zAxg==
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2105.outbound.protection.outlook.com [40.107.220.105])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4924hc1r4a-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 03:34:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=grwDLYR4LWL0MwFeJ3Ed2iP8eHEZSohwyjCDMVApaJ3jw5eDCV6VrJswybNnIqWW5lIUEQp8fIxeZ3lQIeZx4L4EhJZSFbXCmtHVtKSWSJpq/lk00BpCeKnox0GvyLSnNEmmEd/Q5BvagnoyWOiQxtMyPFlzj/XgphOnG2PdHuoCAcRySdMnBc1UWxpvH0UwQazKu4W3bJaHlbZ4SDz9ymVAFFCr2hd47dAVTcBl38WUT9BxdEK/ljCGiz/Z5XdEOokZcam8eL99Kf0wvquK9RFnrEcBUNQqL6q8xAH2HbJjT+5Zo/SYJppiP7PjsqsX0HDZPmZ+2DhRB3gxBkj/ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XzvTkjVD+8zH4t1KEdDe3/osdwOfve4rWMbhzVgM3k8=;
 b=a4psWx+Uo1t1hJt8Q7QI2DZxnxshJW5vzWeK81VYehZ3UI1F8HqOrand5wnZGQharwZx6lfBZ/uZdROv5DSMbxhKi1GtzzXP8mgRVztT4+YIpvnXW1h00KPgqnEmZTNVcLW60P7x9xbjXRWBCtFLju0D0myANbCJNjzwQoq7rogPZYniSluSlDarD0iCb0mmh0xK5l6RhliWPwR1vjEkmEJD4LvwIIR4979NJl3sQtV4cvtZCxkhEVGUo2bPy62FwbXV9gUE1MvtVmjhAJ6TwrnqSeOyFGkH+aUjn0oaKYGdxtS+fkDwC5N604iUDCU0tZW0Wh+9Y4nRciSjjOLUoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XzvTkjVD+8zH4t1KEdDe3/osdwOfve4rWMbhzVgM3k8=;
 b=RRCOK2RaWGCaW5EmfF15ep+/b+OqC407E7AV1t1gopn7v6WoplSyQy7KtaAyalKKWEhbZ0H32Fs1dLNhSTV+4LoEROvnb1yQIBMtPj31eLbq3V1FJ/x8UPacoIn8jeQKkl2fu/Zpndu/qokK7xyw9ou00rVldQx6+h544xE3/q0K98Ct3/BqidSxu+FcI/6yTI+43cp+ZMnAhe3dJSRxf8TC5UUpvZg2Imy57lc6WU1lplIY621WvLORmEmJpFyzSpXu/RXtAkzJCp177seOpDVwoSbRfq6CK3NGA+yb1vw5qYWabouYOvUAfcx3rpCdSyNF4uobgQ89c9qlWcfv/A==
Received: from MN2PR02MB6367.namprd02.prod.outlook.com (2603:10b6:208:184::16)
 by PH0PR02MB8597.namprd02.prod.outlook.com (2603:10b6:510:109::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.29; Tue, 9 Sep
 2025 10:34:10 +0000
Received: from MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328]) by MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 10:34:10 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>
Subject: Re: [BUG] [KVM/VMX] Level triggered interrupts mishandled on Windows
 w/ nested virt(Credential Guard) when using split irqchip
Thread-Topic: [BUG] [KVM/VMX] Level triggered interrupts mishandled on Windows
 w/ nested virt(Credential Guard) when using split irqchip
Thread-Index: AQHcHnl3X2e3RPdxkUCpUW5qLv/tRrSJApSAgAAlboCAAAZagIABfzMA
Date: Tue, 9 Sep 2025 10:34:10 +0000
Message-ID: <376ABCC7-CF9A-4E29-9CC7-0E3BEE082119@nutanix.com>
References: <7D497EF1-607D-4D37-98E7-DAF95F099342@nutanix.com>
 <87a535fh5g.fsf@redhat.com>
 <D373804C-B758-48F9-8178-393034AF12DD@nutanix.com>
 <87wm69dvbu.fsf@redhat.com>
In-Reply-To: <87wm69dvbu.fsf@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR02MB6367:EE_|PH0PR02MB8597:EE_
x-ms-office365-filtering-correlation-id: fb9abe18-0a03-4a7b-7382-08ddef8c69dc
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?WEhzU2tOOUNuWnkrRG10cHMweTRZYi9MaUJLbzZENXd4ZmJ4d0RFVGd4Z1Jq?=
 =?utf-8?B?NkswTnBUcGFKV2tqOEZieUMzMmhvYXhGSVJXZW56dnJuWWplbjNWL0ZuTm5E?=
 =?utf-8?B?NHNPOStIYUFDL25aVk43WlByeC9pUGNqZVVwWUFLNnErVGI2bFlQdDZVanZp?=
 =?utf-8?B?SktsdnBJbWQ1c1JqaUY5NFRGazdHa2h3KzB4MkZaaWNaQkRoWE8rZzRISWVV?=
 =?utf-8?B?SjNZMkg1TWNubUE0b0RFS29LUmtaamY1VGxXclJydWVwN1NQd0p3Z1htc2xr?=
 =?utf-8?B?MTBLdndlcW95bDhVZ3MzbUJ2SS9EaS9YemdVL1BlQWVydW90OW82Tlg4eEhB?=
 =?utf-8?B?OCtGWDlSL2ZGSGdSU2pSOHpadXBXU3FZS2puODBHV3ZlcHNSZXY3ZHRpKzVs?=
 =?utf-8?B?RGxiWjkzR3ZqWnpnUHpCVUc2ZTlyU1BaVzZERVZrQUFYTzN0OHBkbW4wVlZY?=
 =?utf-8?B?Wm5PaFBwOEE3eXl3dktHdjlnUzl0b0FMRm5iSWpDRytkNENrZ0F5b3dsN1ZF?=
 =?utf-8?B?cXArckc4NVZBMjZ3WkwwQk5sUXBHWW5LT2pjNnpvUXBibndycklVbDl2cnBO?=
 =?utf-8?B?aXU1K1FTWnZYZVVoeGxPZ1NFMHl6QkFIc3kzSGhFM2Q0b0JjVWhLM25TOTVF?=
 =?utf-8?B?bjhMT0dCYVNVWW5nSUZpQ0pQaFBWekRFa3puN2JiTm1xUksyRWdnY1JoNWFV?=
 =?utf-8?B?bjR2U3lCVkpQU09mQ3ZkdE04NkMzekZ5OVA3ek4xQmdSRU1yS0ZxN25TT2dw?=
 =?utf-8?B?NUkwSllSYlVGM2dCVGV4MytiVDBMY2MvaUltMUdYTjZCc2lEazBxT1hVbGEw?=
 =?utf-8?B?OXp1N1BuNFp2UVdFdFFVOENjd0tBT3lmSVNiYzE5Z2VZNFU4NDdnRW9JR3Ez?=
 =?utf-8?B?bktBdkw3TE5RbUdmRFdDaEZLYitIM0tJSlVsMGhvRWhFS3g1djBRalRIMjhw?=
 =?utf-8?B?K2FJdUpFUW1TUU9LWnRHS25sbXNCcWZJR2hoVWRsTjBqRlQ3d2dpM3phdHM0?=
 =?utf-8?B?eU5PaHBiZG1ObWVDUDJFTUZleWVaTFZacWJUYlA3eGxiczJ6WUlkS3lpdzg0?=
 =?utf-8?B?cnNZWkpHU2VUK0ZIWU9WMlRhRkFZUmpzM0FrUlFUbi81NDAySFlRaS82SEhK?=
 =?utf-8?B?S3ZTMzBwTnZiTzM5emF1WG1UcFppYS9LQitzMURGLzRiK3p6L096QXU4Y2Y0?=
 =?utf-8?B?bWpxbjdtZnQ1TEQ3d0kzaFhMV3p4WGtQbUlkL0d3YWllb2xhN1NDVXZ0K2dn?=
 =?utf-8?B?VWdGTE9na1dDM3Bva2RDN3FZaTdQVStiL3lETzVJMkdDbFNUREpuL3BtOVBG?=
 =?utf-8?B?V0wzb0FTUFRvZ3ZRclFYUlJtNkZhRWZhdEk0VEh4Q1lselY4S3lSMVpoOHlR?=
 =?utf-8?B?UGVSVDh1ckVEOUlzYWtaYWp1VUEvdFdrY2FsU1NHU05keTkvZXBIZ0pzUWkv?=
 =?utf-8?B?YTZOMm5QM2tJalBNRWVMaWpmMndOTUFwWFZ2WXAxQ2FaVGFvNEdkWGxYUXVt?=
 =?utf-8?B?b3IySFVoaW9aVTl1Q1lkY0xicXE4dmJZWWMxZHFMM0p0SjNkTVE3UTZOcjly?=
 =?utf-8?B?dmw2QkkzRktRMjJEclZBUWZrSDk2M1hRenRqaWF0WnBqSi8wVk1YaDVydEs0?=
 =?utf-8?B?R2Y3OHl3V2IxejROYjBoTTcrTHdMSUlYNzRFRnFnc0ZlRTZ2VGw4aml0aU80?=
 =?utf-8?B?dXh4bnMxcEQxdlA1aWNUa1g2anM2STZ5Q0F6TFBHR1hWdklVaE1XeUp3VkVW?=
 =?utf-8?B?SWJ0cVExSXdHL1NxR05SaGpTR2JvUmJzZHVEOEU0TFVkc1lsTnh3OC85WU45?=
 =?utf-8?B?c0FmM1J0eDQzUE1EQlJweU1JOWQ5U21zYUs2djQ4bTFjaFUzb25tNzFUTG1R?=
 =?utf-8?B?bUFGN1VWU1Q5M01iRzc0V00rVjNyVWZDRDY3Rjh0dDRuQm1wR3N0a3VGRGdN?=
 =?utf-8?B?eWFHQ3ozTjJiQVB6aTZsTHBvYXNLY0ljb3A1T29BdkE0OUw4Tmw2NTh4cm5u?=
 =?utf-8?Q?KIPqDoW+GrqsqBSaWc5HxNMimQuARs=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR02MB6367.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?LzRTSElPY3hpTDROcGhDRWtwVVphMjExSmhqZnVoeTdNQjlETDE3ZEIySDN2?=
 =?utf-8?B?ZkJJMVYyRTdtQ09MMVMvNFhrVkFDbmErekR2RWdVc2RtS0N5VGNlMm9jS2tB?=
 =?utf-8?B?Z0g5MmsvckcybzhZN2NlcEhicUZtQzg2LzJEd05Dcmtwbmx6Y3FDOFJ1b0V4?=
 =?utf-8?B?dFk1UUd6M3BWQU14T05YaWhxWEx1ZCtGbmdiaXZZb1VNQW13RU9mYmNSQzVy?=
 =?utf-8?B?Um1HcitTc3hMZXZ2dVFSLzhrbm9NaDhET3pFZVRFSjU5eStMUURtdHR0bjA5?=
 =?utf-8?B?VExQaXFibER6OEhpaHRQZzUzZHNLNjhmYVNTNXdPRytzOXlXVXp0Wk8wVHYw?=
 =?utf-8?B?K2I2RjRVK0lYUkpsR3JTcXJ2eVhkV1FyZEVQbzFCenlTTWdmTjQyYVF6ZDRt?=
 =?utf-8?B?dDluWU9wNXBlWm4yOGhXYkwxWjNtWS95QTZ4cDg2eWY0a0JIZUxHNzlFM0tM?=
 =?utf-8?B?cVRhUXRoWGV6anVVWHJsR3RwUUZ4OXBDWGZ1cHFPU2ZxNUMyYkkrWWZJVFNt?=
 =?utf-8?B?bThNTGFJbWY3UmwzVjRUOGJrQVQ5WEQvNG9zVSszTlNhZGsxWXBQd0dGcDZX?=
 =?utf-8?B?QXlVWDdwSEU2eGNST28yc0RVa0E2clp1amdIZG12Vnd4d3BuVjQxdHJzbkRI?=
 =?utf-8?B?UVZZRFBpOC9lcUw0N0VoRVRsK2Y4QWM2SzMvWklhbElRV1J3clRNQ3hkTmls?=
 =?utf-8?B?aThQU2JQQU1LeUIyTVZSOFBtWldYbHp6dmpPNlozZHBEVWFXVUMzdjNGdGVE?=
 =?utf-8?B?TTdsSkFjOExvTUVoN2UxN1ZsVHIrWnpQQ2tkbmlHOHpweE5WUGRDZzRXdzZw?=
 =?utf-8?B?MmxyUFVPYzg3RlcxL0JFZ1d6bnVEcDBXb0hGeXJUSDVjWDVBK1d5ejNRNXQ5?=
 =?utf-8?B?b3h2ZXkvd25Rby9RZTI0OS9YUUs3QTJ3Njg2emVrdnk0TFVwNElaKzBuaWhR?=
 =?utf-8?B?V1pFNUc2UFJvL3dLRnVoZXFGSmxBL01saEV3N282Z05KZTZPQy9nWlJUSzdm?=
 =?utf-8?B?ODgzWmEwY1lEaU5Wd3FKT3ZOQnVlV1lwOG1IRmhxeDVLT29RNGVIeVYyTUZy?=
 =?utf-8?B?TGJjTWdVNXJmc2tPY2R4VlIrMHd6MmtYdUhJK1dRcmRjZnJHVnE2ejhXbXRH?=
 =?utf-8?B?bHdaYmVCSzFwMWk5UmtoSW11SWRuM3drTjlHdUt2TWVXZThlYjYyM09FdGVD?=
 =?utf-8?B?bmZUKzBtRS9ERUhEcmtmQ1FuV3NLdUY0ditMT2RDcFNuYXIxMS9RUkVQVFhC?=
 =?utf-8?B?T0hEUjdidFEwajdWNitsUFVzM3FRM0RqNUZ5Rmk0R05FSlVGQTFJT3puZXdU?=
 =?utf-8?B?MGJGK09iLzY3REltTTVBVFBCUUZtSXBOd2trMHMrRzgzQkF4L3ZNWnkvTTlJ?=
 =?utf-8?B?ZDMvOTBkbno5bU9PU1hMNTE2UDhxc2JSSi96UEROU0luZGl4UVFYZ1BHQ05L?=
 =?utf-8?B?bk5mbm1Bbjl6VVJYblFGTHh3WGcvQXJaSW1RNTZCcUFsYjZOSGQ3MXpZL2tH?=
 =?utf-8?B?WEZIdXo1cmpENE5kQXdSMExvSVFvVVYwRitEL0lrT1NIY2gycVFBcVVTVmhZ?=
 =?utf-8?B?cU1EUDhsVW4wTnVGSDQwbWd5V1d2Mk81RkdDSVRVWkc1RTFCVFFWc1JPNEh5?=
 =?utf-8?B?bzR0U0QyZDQzM3ZuazQ2K3gzUlRic1VISTRYMnZoYTV5UUNDZHhvNmVmOC9E?=
 =?utf-8?B?MUs4dnQ0UlZkQ1Y2RFVoRDBmaHpWT2xtaVVLUWFxNHMrVEV6a3ducjAyYVpR?=
 =?utf-8?B?NERWOHdTalZJRWJXU3VURkNqZ3ZLd3BkUGJhWjY0UW1jQVplRSs2V0VxbUU2?=
 =?utf-8?B?UVpPa1R6Y3krZndWVzVHazViREFQVFcrZXMwbW9aYm1pVDZ2YTlUT20wM01M?=
 =?utf-8?B?a0ZsOUJzM1gvUWNTWUFXMUNTenhKZG9GdFZPbXU4YThFRC9VZ2hmbkJsMUMx?=
 =?utf-8?B?ZmJqTGhodjdmN1VBL3RFZ3BWMlB6K2RoRjFMb1NFblhLWk9leVpLYitsS2ZL?=
 =?utf-8?B?WjRka3E0VXdnbjVTWkNQNExTcWloaE9KMlFyVWpuVlpHdytlR0RENkJ2TGxm?=
 =?utf-8?B?MUg0SW1pRndFSDI3K3Z2b2hlaVhqVFFodCtaS1ZOTVRQTFJUN2ZhREpJbW1E?=
 =?utf-8?B?OERMMXc5VisydGpDQlVubmlNSklMRGNtb09KUUxDQXZBVUlOSTB4TER1MENo?=
 =?utf-8?B?Vmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26B870DE96E455498785BD3EC6993FAB@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fb9abe18-0a03-4a7b-7382-08ddef8c69dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2025 10:34:10.6428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QcnaspPZDV2vRX/yjOMYUjyZWpXZv8r257WBw4zNcZmR11sjdTTIFmg6lzMVXjkr9ldVkR8VCjzkMKNac+TJlg4EM8BDdKVPtKU/KdGVaA0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8597
X-Authority-Analysis: v=2.4 cv=dPemmPZb c=1 sm=1 tr=0 ts=68c002a5 cx=c_pps
 a=+nNJfTtXyuiF5uNGX6Ug4w==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=20KFwNOVAAAA:8 a=pZDf02ZPG_RWj_fpjPMA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: lHiuIO05kvpVByGeWkWdrtKX4yJOg1Ch
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA5MDEwNCBTYWx0ZWRfX5Qxu2dRkldsM
 qf7wtxvPe2NcJb7+TXMw1N9/l4Pt4csm9yBeqdE3o2NFhj+UhmEZo2cHjTzV6/3OHOw98JzZgKC
 MtrITvHAJr3fGTlDHAY43eXtWsA04hus+raM/o36ogIbwWshgVudWqVI+uiLvUVu1uoTWf59Cgb
 7HlJqdAXYEYATkh09B6YlecePwDkprAKDGtJlfDZv3l/xAJ9mJXj25ZXdXiv6r3ONThppUVL+LI
 VweDBA5lqR8IalY2+ZvYHLD9wkFDgtWCjjTMjXtKW8K5ZmtqESfXYKYTLxcaHUqoqCgcBucSkEy
 8ExjZ000rVXWAVFu9+viJfrjayJuYYEwvzEFf7jaZj2ALTlwvA+iP1WVZPw1AI=
X-Proofpoint-ORIG-GUID: lHiuIO05kvpVByGeWkWdrtKX4yJOg1Ch
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

VGhhbmsgeW91IGZvciB0aGUgcG9pbnRlcnMsIFZpdGFseSENCg0KPiBPbiA4IFNlcCAyMDI1LCBh
dCA1OjEy4oCvUE0sIFZpdGFseSBLdXpuZXRzb3YgPHZrdXpuZXRzQHJlZGhhdC5jb20+IHdyb3Rl
Og0KPiANCj4+IFRoYW5rcyB5b3UgZm9yIHRoZSBjb21tZW50cyBWaXRhbHkhDQo+PiANCj4+PiBP
biA4IFNlcCAyMDI1LCBhdCAyOjM1IFBNLCBWaXRhbHkgS3V6bmV0c292IDx2a3V6bmV0c0ByZWRo
YXQuY29tPiB3cm90ZToNCj4+PiANCj4+PiBJcyB0aGVyZSBhIHNwZWNpZmljIHJlYXNvbiB0byBu
b3QgZW5hYmxlIGFueSBIeXBlci1WIGVubGlnaHRlbm1lbnRzIGZvcg0KPj4+IHlvdXIgZ3Vlc3Q/
IEZvciBuZXN0ZWQgY2FzZXMsIGZlYXR1cmVzIGxpa2UgRW5pZ2h0ZW5kZWQgVk1DUw0KPj4+ICgn
aHYtZXZtY3MnKSwgJ2h2LXZhcGljJywgJ2h2LWFwaWN2JywgLi4uIGNhbiBjaGFuZ2UgV2luZG93
cydzIGJlaGF2aW9yDQo+Pj4gYSBsb3QuIEknZCBldmVuIHN1Z2dlc3QgeW91IHN0YXJ0IHdpdGgg
J2h2LXBhc3N0aHJvdWdoJyB0byBzZWUgaWYgdGhlDQo+Pj4gc2xvd25lc3MgZ29lcyBhd2F5IGFu
ZCBpZiB5ZXMsIHRoZW4gdHJ5IHRvIGZpbmQgdGhlIHJlcXVpcmVkIHNldCBvZg0KPj4+IG9wdGlv
bnMgeW91IGNhbiB1c2UgaW4geW91ciBzZXR1cC4NCj4+IA0KPj4gDQo+PiBBY3R1YWxseSBpbiBw
cm9kdWN0aW9uIHdlIHVzZSBhbiBleHRlbnNpdmUgc2V0IG9mIGNwdSBmZWF0dXJlcyBleHBvc2Vk
IHRvIHRoZSBndWVzdCwgc3RpbGwgdGhlIGlzc3VlIHBlcnNpc3RzLCANCj4+IFdpdGggdGhlIGZv
bGxvd2luZyBodi0qIG9wdGlvbnMgYWxzbyB0aGUgaXNzdWUgaXMgcHJlc2VudDoNCj4+ICAgICAg
IGh5cGVydmlzb3I9b24saHYtdGltZT1vbixodi1yZWxheGVkPW9uLGh2LXZhcGljPW9uLGh2LXNw
aW5sb2Nrcz0weDIwMDAsaHYtdnBpbmRleD1vbixodi1ydW50aW1lPW9uLGh2LXN5bmljPW9uLCAN
Cj4+ICAgICAgIGh2LXN0aW1lcj1vbixodi10bGJmbHVzaD1vbixodi1pcGk9b24saHYtZXZtY3M9
b24NCj4+IA0KPiANCj4gVHJ5IGFkZGluZyAnaHYtYXBpY3YnIChBS0EgJ2h2LWF2aWMnKSB0byB0
aGUgbGlzdCB0b28gKG5vdCB0byBiZQ0KPiBjb25mdXNlZCB3aXRoICdodi12YXBpY+KAmSkNCg0K
DQpJIHRyaWVkIHdpdGggaHYtYXBpY3Y9b24sIHRoZSBpc3N1ZSBzdGlsbCBwZXJzaXN0cy4gDQoN
Cj4gT2gsIHRoaXMgaXMgbmV4dCBsZXZlbCkgRG8geW91IGtub3cgaWYgdGhlIGlzc3VlIHJlcHJv
ZHVjZXMgd2l0aCBuZXdlcg0KPiBXaW5kb3dzLCBlLmcuIDIwMjU/DQoNClRoZSBsYXRlc3QgSSBj
YW4gdHJ5IG9uIGlzIFdpbjExIDI0SDIsIEkgd2lsbCB0cnkgYW5kIHVwZGF0ZSBoZXJlLg0KDQo+
IEFsc28sIEkndmUganVzdCByZWNhbGxlZCBJIGZpeGVkICh3ZWxsLCAnd29ya2Fyb3VuZGVkJykg
YW4gaXNzdWUgc2ltaWxhcg0KPiB0byB5b3VycyBhIHdoaWxlIGFnbyBpbiBRRU1VOg0KPiANCj4g
Y29tbWl0IDk1OGEwMWRhYjhlMDJmYzQ5ZjRmZDYxOWZhZDhjODJhMTEwOGFmZGINCj4gQXV0aG9y
OiBWaXRhbHkgS3V6bmV0c292IDx2a3V6bmV0c0ByZWRoYXQuY29tPg0KPiBEYXRlOiAgIFR1ZSBB
cHIgMiAxMDowMjoxNSAyMDE5ICswMjAwDQo+IA0KPiAgICBpb2FwaWM6IGFsbG93IGJ1Z2d5IGd1
ZXN0cyBtaXNoYW5kbGluZyBsZXZlbC10cmlnZ2VyZWQgaW50ZXJydXB0cyB0byBtYWtlIHByb2dy
ZXNzDQo+IA0KPiBtYXliZSBzb21ldGhpbmcgaGFzIGNoYW5nZWQgYW5kIGl0IGRvZXNuJ3Qgd29y
ayBhbnltb3JlPw0KDQpUaGlzIGlzIHJlYWxseSBpbnRlcmVzdGluZywgd2UgYXJlIGZhY2luZyBh
IHZlcnkgc2ltaWxhciBpc3N1ZSwgYnV0IHRoZSBpbnRlcnJ1cHQgc3Rvcm0gb25seSBvY2N1cnMg
d2hlbiB1c2luZyBzcGxpdC1pcnFjaGlwLiANClVzaW5nIGtlcm5lbC1pcnFjaGlwLCB3ZSBkbyBu
b3QgZXZlbiBzZWUgY29uc2VjdXRpdmUgbGV2ZWwgdHJpZ2dlcmVkIGludGVycnVwdHMgb2YgdGhl
IHNhbWUgdmVjdG9yLiBGcm9tIHRoZSBsb2dzIGl0IGlzIA0KY2xlYXIgdGhhdCBzb21laG93IHdp
dGgga2VybmVsLWlycWNoaXAsIEwxIHBhc3NlcyB0aGUgaW50ZXJydXB0IHRvIEwyIHRvIHNlcnZp
Y2UsIGJ1dCB3aXRoIHNwbGl0LWlycWNoaXAsIEwxIEVPSeKAmXMgd2l0aG91dCANCnNlcnZpY2lu
ZyB0aGUgaW50ZXJydXB0LiBBcyBpdCBpcyB3b3JraW5nIHByb3Blcmx5IG9uIGtlcm5lbC1pcnFj
aGlwLCB3ZSBjYW7igJl0IHJlYWxseSBwb2ludCBpdCBhcyBhbiBIeXBlci1WIGlzc3VlLiBBRkFJ
SywgDQprZXJuZWwtaXJxY2hpcCBzZXR0aW5nIHNob3VsZCBiZSB0cmFuc3BhcmVudCB0byB0aGUg
Z3Vlc3QsIGNhbiB5b3UgdGhpbmsgb2YgYW55dGhpbmcgdGhhdCBjYW4gY2hhbmdlIHRoaXM/DQoN
ClJlZ2FyZHMsDQpLaHVzaGl0

