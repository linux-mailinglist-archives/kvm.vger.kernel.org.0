Return-Path: <kvm+bounces-59366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D843BBB19C8
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 21:34:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 52F857A829D
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 19:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E83A52D46D0;
	Wed,  1 Oct 2025 19:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MI+UGLJm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="viEt/s/q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4031B2E11DD
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 19:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759347216; cv=fail; b=VkrzkfnhOjx1gv4qUAL4HsJngDtPtWMDaA4e1/avp2sH6DZETmkLLL7OFZpFSSL2d0RshJAhf3u+Ey8WxndImlBaQreoNWAB8I72al4fnw/qVOQ1aMm1Md2nocm0yQTo0027/ICzoC+afp9Jepc7FGMEzLUo4opY9/yp1YznyS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759347216; c=relaxed/simple;
	bh=LNFpQltCGkOxP+JcXGqS04so3oU3uzqfTDvC8ig4aHk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e8ZSdvCPGxGDx7NWDTGAc1r5lwf+6ic5C6KbDkKMAbuNjomgzqdSL/dIxn6AI2rPgy9d+qqtOounYyJwCNe58S22KAyeec7iAEQWd35IO30Es3rZJclh9090CW88luiROxzl/Bh5qvvJeKKaWk7oFnkhNV0hrls9mogOmK1vttM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MI+UGLJm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=viEt/s/q; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 591I19nC006417;
	Wed, 1 Oct 2025 19:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LNFpQltCGkOxP+JcXGqS04so3oU3uzqfTDvC8ig4aHk=; b=
	MI+UGLJmIj2a6jSCgWuoaUxqTg/ZNKXTspC3+RgTOq2zsiuoWTTClYlEkI/Vxa50
	cQWiCYoeLYBh2R9xw/DTItk9JS5+ZFv11U7n3mwfl5geBQgxXo9QY03fotaULm+P
	/b5nCE1lS6dS7TK52dpyDYrjSorLIWd1XVlBH1oypmA+GDQeyn6WYCCqCdx1a+pU
	l75TB+cE5bd7LHXCu2Y+WhyH8PpWCTpkXV+72Q3zuj3S5G1+MtWrOYxs/uxrc8e7
	2k9s+aG/I2oe5/fCgXMaH+NtZWihzAkoaiSnOCWVtVIINxaxAv3kpjkMpeR1Slo9
	8W8Ly/+Cf/JayMMRMtr9Ww==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49gm3bj5ys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Oct 2025 19:32:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 591IkhHS023225;
	Wed, 1 Oct 2025 19:32:41 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010071.outbound.protection.outlook.com [52.101.193.71])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6cak40p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 01 Oct 2025 19:32:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ape9JWJJKUdyEn1wVwWoxMXO1++HD53Wlz3KSh+SJYfv65GJXeqTdT6XdqpfHmq5AzL/hESiHt9gTpk4mLQ5mxB8ZAXqQvhFLN0PPc22XztEk/+9XYTM4c/hns7siP+EKhLvuN874taXCbYtEpcm7tJWpUpu2K7ScdhBIzTIEcagnAw//kQpj3A9XECNF9Stmi/2CPivYJoKZ/+eyV9rLCxN9rF6XjeZk55qeDwCTDGb9//3NLgFsnpJfxEL8VlO9D8i+pEOPM6Rq8mJFvthgMrzGTgP2axYQswBzdeaMR0kIAZcHKAxgXioL3qbMv0WEFIS2j+dPz2DfNhihoUocA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LNFpQltCGkOxP+JcXGqS04so3oU3uzqfTDvC8ig4aHk=;
 b=bD85pZO90CFRrhrZvD5mQeQEtC1EVMe2r/zWwaVeQDu5x7yDb5EYeotSqvJQh6t9KzlNlUUqghf0Z7Gu9eqmH4ouexhOnsqElBCnRmSVdfLEBAup4uGjgJ6kPtsnC6JXNkyBUzchIk3NkzO0Z08EniVU3fTMerK7v7IrrFjSQeP42yA+Yi0T8POX1FW37G645sh/txsYEyIdKFBzzLZA7HqiQiftlLTENN1bjlpoLeRHsfSNMdZ2KyzyxwhBFPYAI05cvFw183eY6IhoYplmY2aNXFhSk7aWj5nWelqPA6lE7K9lRBF5O5EOfRncVe2zLsIxzykbEGPld5EDhqlOlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LNFpQltCGkOxP+JcXGqS04so3oU3uzqfTDvC8ig4aHk=;
 b=viEt/s/qcAixZPybhqgZYUOzQ/p3Eg5DMRWidInWOnY/zUaaWjDV4PKQRLHb+psTRDQBTJxHtzH8HPxTVnaGwM635ra6BDPCfIe2tIxRWLleJTluKPUDIzSG+plVHnIYXH1S3jcD2ojnQfonKVePtm3XDm7kYWX/CLq01DkJ/C0=
Received: from CH0PR10MB5004.namprd10.prod.outlook.com (2603:10b6:610:de::12)
 by PH0PR10MB5780.namprd10.prod.outlook.com (2603:10b6:510:149::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Wed, 1 Oct
 2025 19:32:33 +0000
Received: from CH0PR10MB5004.namprd10.prod.outlook.com
 ([fe80::400c:6e9f:d137:4a2d]) by CH0PR10MB5004.namprd10.prod.outlook.com
 ([fe80::400c:6e9f:d137:4a2d%4]) with mapi id 15.20.9160.017; Wed, 1 Oct 2025
 19:32:33 +0000
From: Jag Raman <jag.raman@oracle.com>
To: =?utf-8?B?UGhpbGlwcGUgTWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>
CC: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Peter Maydell
	<peter.maydell@linaro.org>,
        "qemu-ppc@nongnu.org" <qemu-ppc@nongnu.org>,
        Ilya
 Leoshkevich <iii@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Jason Herne
	<jjherne@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
        =?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clg@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Richard Henderson
	<richard.henderson@linaro.org>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Fabiano Rosas <farosas@suse.de>, Eric Farman <farman@linux.ibm.com>,
        "qemu-arm@nongnu.org" <qemu-arm@nongnu.org>,
        "qemu-s390x@nongnu.org"
	<qemu-s390x@nongnu.org>,
        David Hildenbrand <david@redhat.com>,
        Alex
 Williamson <alex.williamson@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v2 06/18] hw: Remove unnecessary 'system/ram_addr.h'
 header
Thread-Topic: [PATCH v2 06/18] hw: Remove unnecessary 'system/ram_addr.h'
 header
Thread-Index: AQHcMvyU8YWX3retOEmfoNOd1v8iv7Strj4A
Date: Wed, 1 Oct 2025 19:32:33 +0000
Message-ID: <6EC3EDEC-CF35-4F2E-AAB4-B10EDFFFCE48@oracle.com>
References: <20251001175448.18933-1-philmd@linaro.org>
 <20251001175448.18933-7-philmd@linaro.org>
In-Reply-To: <20251001175448.18933-7-philmd@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR10MB5004:EE_|PH0PR10MB5780:EE_
x-ms-office365-filtering-correlation-id: 13072591-8e91-4581-82ba-08de012144b0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZWFOMXU0VlU2Nnl5MHhleDF4bFBNaGpFWlF0L1UzUzUvOTFaYjFlK3Y5Q25S?=
 =?utf-8?B?Z3FwT3l3MExvYTVpZ3VZU2N1YmhjYUcxNXhtdTFzeG1wRnR5ZUhEYUxKMDh3?=
 =?utf-8?B?VlFFVjBoL0RvTERmaWRZLzJSeHgyVFhJaTNCZjM4L0hyTTFHNHBLVnNucTVM?=
 =?utf-8?B?R3lPd2R0OWhoUHY4elVZcHBqT2xMUXBCT0lWKy9rYUFnQWdvZWdjRlRiRVUx?=
 =?utf-8?B?VmltM2R0TEdWMk0xTkFGQ2k5RW5SMmYxTzlTcCtpakFVajFSbnNxeHZMYm1K?=
 =?utf-8?B?Nm1qK3k0VVVwd3N0Zy9penJPdXZyQThKbVhmdUFrRDdpdnB5dW5ZdXRJa1Br?=
 =?utf-8?B?UytiMHhyYmxRVjJwQ3pIL0VxejA5QklINlAxTS82MFJ2ek5taUQ5dzBML0lN?=
 =?utf-8?B?Yml0a0NCdXRwcmh6UndEVUFCZkt1NmlELzU3VGUxSE5YTThSTEo3MGY2YTFW?=
 =?utf-8?B?QVVHSUtnczdSOEI0ZGJBUWJvZ2d4cUwrZnpPemhpL0lFK3hDOGxlU09GM0lB?=
 =?utf-8?B?S3VNY1JUVUNFalgzR2s4YXRzSXNmRm9XR1ZGSlJjdUY0dng3bUIrQTJoaElE?=
 =?utf-8?B?MTBMWVpON09keDMwU1ZCdU1zSGJPUDVwUVBsamFqTHkxSFpDWm01VEdHKytX?=
 =?utf-8?B?cmY0ak94UDB1SWxEdVdNTGEwU0hzUW4vK20yYjVVa3g0SzFsQmVZM084MzJD?=
 =?utf-8?B?dU9yaEFyMHdPRndPMU1XOGMyZEJoNjNoQU1vSmxTQ3hiWjBHeGpIcHM0YWtl?=
 =?utf-8?B?N05FYkJmdHZjWlIySkJDYW1jWWdVMW05YlhVUVM4RVZreXptTGNXSktxYnho?=
 =?utf-8?B?R1o5M2tTQ251QllCVkkrb2JYWUtaaTYzOW50V0luQmRIL29iTzJjQzZnQjBE?=
 =?utf-8?B?eGQyVzFIS0dSZW5rSWxUWnV6UldOSm10YXBubVl2UFVUQWZLbWZza3ZSZ0Nm?=
 =?utf-8?B?b2labFBiZVREbjdtUElBUE9ycHVsKzB0MjZ0SFBPRGlDVjhERTNyZThpL1hk?=
 =?utf-8?B?b0ZKWDFZT0p4M1Y1NDRDc1QwYjNRZzBrVXd0RkkxNXVPanFzSXZDRzRFV3Fn?=
 =?utf-8?B?a1pGM0xjeXFqSU43ZFZkVkxtVmlIU2s0OEJKUmgwd2YrbUNKOUZGSjU5NWI5?=
 =?utf-8?B?Y2RsZ3REZVRGMCttMTBibzZPQStYakJEbDdyWjI5RXhrRi9NNW1RMSsvQlBN?=
 =?utf-8?B?WHF5M3hLbTZHSW9uY0FBZ2lyYjM2OVRVeURQVk1QN1Q5T04wYno5K0ZNTDNL?=
 =?utf-8?B?YUM3V25sWGpMdVJpWUdJMTJBUHd6emJJa1M4aWs5Q1JLa0ZnMk1KRUx1YjRJ?=
 =?utf-8?B?T245UkZUaFlxUUJWQlZIR0x2MnFXMytIQkdpMVN3R2ZNblBqQld1dzhJazZI?=
 =?utf-8?B?N1FQTWdqUVc1NU8zRkNlY2gwTERLZmJtTDY1djBkWmoyZFowR2xYRFl3RVhv?=
 =?utf-8?B?Mm43b0d6QTRWbURlS29EcXFXUVB5NHZzVTRiVEdxSUUzY1BTVDZIbm45aFls?=
 =?utf-8?B?ZTdzcU1zWkNxdmxCUHlFREdNSXJKbzhQV2M2Wk1XQVhpRVJrZ3FiQnc5VElR?=
 =?utf-8?B?R3NSM1N5UjNsREU0STdsY243WHAzRXFMOEkzVit2anZKUFVrNDk5OENVQlZH?=
 =?utf-8?B?WGxuMXRSeVhQOUtmSHQxaksyVnlaTHFJSVhSUk1hS1hXSzh6NXFpNy9GVzVR?=
 =?utf-8?B?RlhYVThBdGV5cUUxMHI4Q21ib3FoemhSajFDQ1M0ZFBFV2NKTDVUWlE2cVlW?=
 =?utf-8?B?SVZRQjJUSWdOM2h4VmNacWRUSS9uNDIwdjlzdEE4d3o0cXRWZlg5RGpqWUdZ?=
 =?utf-8?B?dGhMbUIvK0dWRkNrUXIyc2FQQWJ4RVZWZ3B0ekMzQ0drRWNuSGg2YXJDSGh2?=
 =?utf-8?B?bkFPaW5SbllLVHZ6WUJzRXJrTmVnM2szTnZPRHI4TjhGaTJWMUdieHdvOG42?=
 =?utf-8?B?S1ZDMXQ5R2dGSlNyLzN1Nm8rRU1GUmZNdTNLN3JrMWl6MFNyRTdLcFgraHpw?=
 =?utf-8?B?WmNmY1AzaTRicDRONlRzTHErTHJCRE5sOWVtc0dGZ3lIQ3RwVFV6c1NEcjZG?=
 =?utf-8?Q?PACRYO?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5004.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c0o4UWh2REFJSFFBa2tJSFc0N1FCOWZ2N093NzR5Mzhka1pxL3kxd3hBajJZ?=
 =?utf-8?B?NjduZ2wzdDBCbjl2TWJwQkUzR2I2UTNRbmsxeE41WWdKU3Y5TTFkQlJQd3V5?=
 =?utf-8?B?aUw0Tjc0Z09GREc5REQxcnA1cjZMcGlEdmpDbG5WYU52SXQ4b0hPSktvTTBJ?=
 =?utf-8?B?Mm1QQ3ZmRHNBdFQ0RDB5c29ZN3F1Yi91Q24vVjMxM0tERitZdUtmdytYQStZ?=
 =?utf-8?B?VVAzb3IzZjRVaG9oVTlHZTVPTTBReENGQTNCSVArTWhLK1BwNkJDbDZnZUhW?=
 =?utf-8?B?MmhLSmt1K1dYM0JsN0ZsMEhQQUlJK1A1Q1U5cnMyd3hkeEZRaUFiMmNNeTh0?=
 =?utf-8?B?V1VmUFpLdnphRjEzNEVyVWUzRlFyMWU0dFhDdi85RVFkMlFFeU9WbTJnQTQx?=
 =?utf-8?B?UFZDMit0b2Vhd3pOekNibzZEMWxvbWU5MVdEVUJ3N1J0SDFicnpBK0N3NmlT?=
 =?utf-8?B?aStPQzhRTzl5Y0ViVWFTOE51QUU0eTAvYXBDcmxueEVjNHNzMEdzYXpVdmFZ?=
 =?utf-8?B?VG9HbUM2T0wzWWlFbWsvd2hsMkk4U0ZOdXQrQkhFb2ZoYUZBK29mOFVnSU5K?=
 =?utf-8?B?aWdtK3NnUHpZNG1IeWx5cU45YUUrTEJ4NTA1TVNibHBqTGtiVFA3RnlrMTVF?=
 =?utf-8?B?UGdMSUprTS85OHJhVUl4MCtMbE5udlpPbTF5RS95WnhIYjd6QWlvVmdRdGxx?=
 =?utf-8?B?Um50WUxVT1ltalhRenpXREVwTTdXTlRCWHVxQTJIYTJqS0FkZ2EycGVxeWVZ?=
 =?utf-8?B?WkxDKytmSXlpK0U2eVRob0IyYThQK2xBaUlrY09QVk5oTjdaeCtiUWorZHpi?=
 =?utf-8?B?dFU5bEZTSm9yWDdCUytqRmUzRFBQMlo2N2k1dWdQOWxXVzJSS21sWVEvSkRt?=
 =?utf-8?B?U1RseEJtd0JLN0FkMk9ScW9SV1dJdlY5d3RDVVJvR1JNS0pzTFhnK3E5eE1n?=
 =?utf-8?B?MHNtWmNiRFcvR1ZVNVl6a21MTzFmZ2dON2dzdFVmbmlLdzNhcmR1YXpQdTk3?=
 =?utf-8?B?VmY1RGQvL0FkUHdoNjExRTN2aFFrN0VQMytJT2lPak4zbkcrZHY3Ny9CZ3ZM?=
 =?utf-8?B?anZYamRsN21pMk9qdWhGOUtyRFpvQzlwc0d5Qm9nbDJZL0VGbzhscXpHK0pU?=
 =?utf-8?B?bXUzZXl0a2FET2NBL2R1WlRBNGx0akRrNXVNL1RxM3VXZkd1SS95dGRDdmFY?=
 =?utf-8?B?UG1KbmtuT3Z5ZnozeVFIejRnVlFuT1gwT09zKzgyVlZmQ3RiK29HQjNYSmdY?=
 =?utf-8?B?SXBXb1FCa1hDVFRFTStjL3pqR081b21adGIwNi9BR2xBNkZHM0ZPOVBJQ2F3?=
 =?utf-8?B?T0xHSlk3ZTdCREh0d3QxbUV0TXB5ZnRZSSsxK3I3NitIYTgwQjMxeHk2UXhr?=
 =?utf-8?B?MzlvYlorbXpUM3dPUXpWdjQzcjI5YUlBNXNLM0Z4b3Y0a2FXLzJRS3J4MUlO?=
 =?utf-8?B?TnArMFh4ZDdEaU5Db0VPV1A5Sk5idlNUdGZsSEVVTmtmbnA5akRaTDIrTGIr?=
 =?utf-8?B?QlZkNE9kYWsrTVFhVjQ2L1FmV0VQMnRqVW5ycndSZ0VQT1htUC8zVXNvbXEx?=
 =?utf-8?B?RkVmRXAwRVg2a0trbVlyQ044cU9uT2NyMjdSUmxkM2N0bWxCSXptZkJlSXpO?=
 =?utf-8?B?MHNlT0ladW9RM3lHRGV5L0JQaXlaVU9pQ0FHTDlCN2hxVldUQnM5dVZ2V3Zv?=
 =?utf-8?B?TTFYTjRuV3NvYkp3VzNpWktpT2Fid0sra1JYZ3V0VFpkeTluV25kWXAwNFJS?=
 =?utf-8?B?MUJObW1sSFpvdStYSFVTeTRqUml4cHVjZUt6VzdQaVpXbGY5UVFUMWlLclJV?=
 =?utf-8?B?VE5PeWI0aUtUNm9oOGtKaGdWZmR2ejRDYXNVOVNMekdoQ1owQ3R0T0hOeHFJ?=
 =?utf-8?B?UTc2NlB3cVorZjJLZHM2UkxxU3lCY0U3bk9BTC9EYzdBSExRa1QzNmduMmVH?=
 =?utf-8?B?OTlWaXJ2Tm9VanVwZUgvVnNneWs4bXhadkllTG5sVU1MTXU2WnptRkFiTE1t?=
 =?utf-8?B?Z0dxbnk2czJua0FOZld1dU5STldXT3d6Q2xxbC9mKzd4R2R6akhZMHdXVkhT?=
 =?utf-8?B?ZlBuZ29uMFkzRVN2eWR3R1ZHcjBrUFdIZUY0aVlETStZamxCbkV6SG9IZk5p?=
 =?utf-8?Q?M07ijk8+rULyaM7M4hTOqur/6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E60E06598098ED4D8E9CBBBD31CF88E8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tqb1hnGkJdQKeER7DlxGOtYuBFdICzsR1N/kliuWKcNaBNQEzJjQu0TlBD6pxafED5gOqjl4wKW5mg9TpgX8wEhVonUJfGYBuVSCee1DcZmkja0ZDcL7o/lhdg/F6Kpuu6qZ9YffVBkGplV3R3k7HXBYTOKNOFnvDdGJGla78P4Jf0k7v+TB59RSBwAWc0wnh3R9Ai0Xzega18LsQt9+RmKP40SpDEnVKWKerzO1m4mcIzH7OeATEkVZFVhUhPjFUMPeQqS6Z+FlbsraQPqMYpen53/XVC2rlGutD6c0t44Rnu92B9k4BM15wl3WhPYuuVQ14YcHy4Rka4ANg9cSp4A0otfhMTn20xEf6DxN4ne6dDr3Pi/kP5lHYM6Qh48Y3GlyI4wk0t84nuWh/cJYhuTMd4hfJh0y8RsmgyXauwkaujt4u3kIZxgNGRUqJJgQtJQ/5zbF5Ab3Jcu+LUHh2mechxuTOjXeO3LtDayAi7FfUydNr3AYxrvkqsQgXnkm481LOz0SgHrtcYEFDTjp0a9soqZ7pEXSPdnlz2ixXoBJrAEI7PZWbcj2Nia3gv377v6eMG732ZLBiv4kF/WxSadG6TiH+1T+FUgIJwX+7u8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5004.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13072591-8e91-4581-82ba-08de012144b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2025 19:32:33.0675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R3k/znwclXg7Y1tlqWVoLS58YqMSmncmpfQsJ946usbi0+1ukIgJA5zkbglC3WRyWAMLf1P3AeHufO1Eg94eLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5780
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_05,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510010170
X-Proofpoint-GUID: Ej4nVDckJiVhrJ8P1V9gp3cuLICxAllP
X-Authority-Analysis: v=2.4 cv=GsJPO01C c=1 sm=1 tr=0 ts=68dd81da b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10
 a=KKAkSRfTAAAA:8 a=yPCof4ZbAAAA:8 a=SsoORxr1X_bU6p0JkCUA:9 a=QEXdDO2ut3YA:10
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDE2MiBTYWx0ZWRfXwTkKJW3KIAIi
 CPvwxLfhDdIJpwreXkeJQ2ZyksAoY5yIHhjU9fPUWKgxSbxM+4WhVycCLkI03hCfI/AxgPSHqqe
 KzVcI6IF7GOVF9NQrZ497kkcMdmiT5r5BRJimw3MGhQGSGan1OYmll4NeEfFWVt7SNspKD/9VXH
 GbgDnM8gJG0SIK+x51M0RxSNv+OECYP2+OFLNOSru7WjRtmX9U0ZBDVmGimJqgIbR6Re197CfHB
 ++eIGxuv8ffSE+3q0FocMwahy0EjedJqT8fRmVsHWHkbDvj4V+0WpgjHk5s34r8HrDdNkeJe4iE
 zZOU6gypjta7tnVqkrQ8Zn6iVe9G2Bd7VBeyd1fA8ZOgveO9V2Aj1QKex96oFe/j/UUiG6ib+dO
 BSjf7cLzk6a7RiB+t1WA5zqlu+OJMg==
X-Proofpoint-ORIG-GUID: Ej4nVDckJiVhrJ8P1V9gp3cuLICxAllP

DQoNCj4gT24gT2N0IDEsIDIwMjUsIGF0IDE6NTTigK9QTSwgUGhpbGlwcGUgTWF0aGlldS1EYXVk
w6kgPHBoaWxtZEBsaW5hcm8ub3JnPiB3cm90ZToNCj4gDQo+IE5vbmUgb2YgdGhlc2UgZmlsZXMg
cmVxdWlyZSBkZWZpbml0aW9uIGV4cG9zZWQgYnkgInN5c3RlbS9yYW1fYWRkci5oIiwNCj4gcmVt
b3ZlIGl0cyBpbmNsdXNpb24uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQaGlsaXBwZSBNYXRoaWV1
LURhdWTDqSA8cGhpbG1kQGxpbmFyby5vcmc+DQo+IFJldmlld2VkLWJ5OiBSaWNoYXJkIEhlbmRl
cnNvbiA8cmljaGFyZC5oZW5kZXJzb25AbGluYXJvLm9yZz4NCg0KVGhhbmtzLCBQaGlsaXBwZSEN
Cg0KUmV2aWV3ZWQtYnk6IEphZ2FubmF0aGFuIFJhbWFuIDxqYWcucmFtYW5Ab3JhY2xlLmNvbT4N
Cg0KPiAtLS0NCj4gaHcvcHBjL3NwYXByLmMgICAgICAgICAgICAgICAgICAgIHwgMSAtDQo+IGh3
L3BwYy9zcGFwcl9jYXBzLmMgICAgICAgICAgICAgICB8IDEgLQ0KPiBody9wcGMvc3BhcHJfcGNp
LmMgICAgICAgICAgICAgICAgfCAxIC0NCj4gaHcvcmVtb3RlL21lbW9yeS5jICAgICAgICAgICAg
ICAgIHwgMSAtDQo+IGh3L3JlbW90ZS9wcm94eS1tZW1vcnktbGlzdGVuZXIuYyB8IDEgLQ0KPiBo
dy9zMzkweC9zMzkwLXZpcnRpby1jY3cuYyAgICAgICAgfCAxIC0NCj4gaHcvdmZpby9zcGFwci5j
ICAgICAgICAgICAgICAgICAgIHwgMSAtDQo+IGh3L3ZpcnRpby92aXJ0aW8tbWVtLmMgICAgICAg
ICAgICB8IDEgLQ0KPiA4IGZpbGVzIGNoYW5nZWQsIDggZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvaHcvcHBjL3NwYXByLmMgYi9ody9wcGMvc3BhcHIuYw0KPiBpbmRleCA4MmZiMjNi
ZWFhOC4uOTdhYjZiZWJkMjUgMTAwNjQ0DQo+IC0tLSBhL2h3L3BwYy9zcGFwci5jDQo+ICsrKyBi
L2h3L3BwYy9zcGFwci5jDQo+IEBAIC03Nyw3ICs3Nyw2IEBADQo+ICNpbmNsdWRlICJody92aXJ0
aW8vdmlydGlvLXNjc2kuaCINCj4gI2luY2x1ZGUgImh3L3ZpcnRpby92aG9zdC1zY3NpLWNvbW1v
bi5oIg0KPiANCj4gLSNpbmNsdWRlICJzeXN0ZW0vcmFtX2FkZHIuaCINCj4gI2luY2x1ZGUgInN5
c3RlbS9jb25maWRlbnRpYWwtZ3Vlc3Qtc3VwcG9ydC5oIg0KPiAjaW5jbHVkZSAiaHcvdXNiLmgi
DQo+ICNpbmNsdWRlICJxZW11L2NvbmZpZy1maWxlLmgiDQo+IGRpZmYgLS1naXQgYS9ody9wcGMv
c3BhcHJfY2Fwcy5jIGIvaHcvcHBjL3NwYXByX2NhcHMuYw0KPiBpbmRleCBmMmY1NzIyZDhhZC4u
MGY5NGMxOTJmZDQgMTAwNjQ0DQo+IC0tLSBhL2h3L3BwYy9zcGFwcl9jYXBzLmMNCj4gKysrIGIv
aHcvcHBjL3NwYXByX2NhcHMuYw0KPiBAQCAtMjcsNyArMjcsNiBAQA0KPiAjaW5jbHVkZSAicWFw
aS9lcnJvci5oIg0KPiAjaW5jbHVkZSAicWFwaS92aXNpdG9yLmgiDQo+ICNpbmNsdWRlICJzeXN0
ZW0vaHdfYWNjZWwuaCINCj4gLSNpbmNsdWRlICJzeXN0ZW0vcmFtX2FkZHIuaCINCj4gI2luY2x1
ZGUgInRhcmdldC9wcGMvY3B1LmgiDQo+ICNpbmNsdWRlICJ0YXJnZXQvcHBjL21tdS1oYXNoNjQu
aCINCj4gI2luY2x1ZGUgImNwdS1tb2RlbHMuaCINCj4gZGlmZiAtLWdpdCBhL2h3L3BwYy9zcGFw
cl9wY2kuYyBiL2h3L3BwYy9zcGFwcl9wY2kuYw0KPiBpbmRleCAxYWMxMTg1ODI1ZS4uZjkwOTU1
NTJlODYgMTAwNjQ0DQo+IC0tLSBhL2h3L3BwYy9zcGFwcl9wY2kuYw0KPiArKysgYi9ody9wcGMv
c3BhcHJfcGNpLmMNCj4gQEAgLTM0LDcgKzM0LDYgQEANCj4gI2luY2x1ZGUgImh3L3BjaS9wY2lf
aG9zdC5oIg0KPiAjaW5jbHVkZSAiaHcvcHBjL3NwYXByLmgiDQo+ICNpbmNsdWRlICJody9wY2kt
aG9zdC9zcGFwci5oIg0KPiAtI2luY2x1ZGUgInN5c3RlbS9yYW1fYWRkci5oIg0KPiAjaW5jbHVk
ZSA8bGliZmR0Lmg+DQo+ICNpbmNsdWRlICJ0cmFjZS5oIg0KPiAjaW5jbHVkZSAicWVtdS9lcnJv
ci1yZXBvcnQuaCINCj4gZGlmZiAtLWdpdCBhL2h3L3JlbW90ZS9tZW1vcnkuYyBiL2h3L3JlbW90
ZS9tZW1vcnkuYw0KPiBpbmRleCAwMDE5M2E1NTJmYS4uODE5NWFhNWZiODMgMTAwNjQ0DQo+IC0t
LSBhL2h3L3JlbW90ZS9tZW1vcnkuYw0KPiArKysgYi9ody9yZW1vdGUvbWVtb3J5LmMNCj4gQEAg
LTExLDcgKzExLDYgQEANCj4gI2luY2x1ZGUgInFlbXUvb3NkZXAuaCINCj4gDQo+ICNpbmNsdWRl
ICJody9yZW1vdGUvbWVtb3J5LmgiDQo+IC0jaW5jbHVkZSAic3lzdGVtL3JhbV9hZGRyLmgiDQo+
ICNpbmNsdWRlICJxYXBpL2Vycm9yLmgiDQo+IA0KPiBzdGF0aWMgdm9pZCByZW1vdGVfc3lzbWVt
X3Jlc2V0KHZvaWQpDQo+IGRpZmYgLS1naXQgYS9ody9yZW1vdGUvcHJveHktbWVtb3J5LWxpc3Rl
bmVyLmMgYi9ody9yZW1vdGUvcHJveHktbWVtb3J5LWxpc3RlbmVyLmMNCj4gaW5kZXggMzBhYzc0
OTYxZGQuLmUxYTUyZDI0ZjBiIDEwMDY0NA0KPiAtLS0gYS9ody9yZW1vdGUvcHJveHktbWVtb3J5
LWxpc3RlbmVyLmMNCj4gKysrIGIvaHcvcmVtb3RlL3Byb3h5LW1lbW9yeS1saXN0ZW5lci5jDQo+
IEBAIC0xMiw3ICsxMiw2IEBADQo+ICNpbmNsdWRlICJxZW11L3JhbmdlLmgiDQo+ICNpbmNsdWRl
ICJzeXN0ZW0vbWVtb3J5LmgiDQo+ICNpbmNsdWRlICJleGVjL2NwdS1jb21tb24uaCINCj4gLSNp
bmNsdWRlICJzeXN0ZW0vcmFtX2FkZHIuaCINCj4gI2luY2x1ZGUgInFhcGkvZXJyb3IuaCINCj4g
I2luY2x1ZGUgInFlbXUvZXJyb3ItcmVwb3J0LmgiDQo+ICNpbmNsdWRlICJody9yZW1vdGUvbXBx
ZW11LWxpbmsuaCINCj4gZGlmZiAtLWdpdCBhL2h3L3MzOTB4L3MzOTAtdmlydGlvLWNjdy5jIGIv
aHcvczM5MHgvczM5MC12aXJ0aW8tY2N3LmMNCj4gaW5kZXggZDBjNmU4MGNiMDUuLmFkMmM0ODE4
OGE4IDEwMDY0NA0KPiAtLS0gYS9ody9zMzkweC9zMzkwLXZpcnRpby1jY3cuYw0KPiArKysgYi9o
dy9zMzkweC9zMzkwLXZpcnRpby1jY3cuYw0KPiBAQCAtMTMsNyArMTMsNiBAQA0KPiANCj4gI2lu
Y2x1ZGUgInFlbXUvb3NkZXAuaCINCj4gI2luY2x1ZGUgInFhcGkvZXJyb3IuaCINCj4gLSNpbmNs
dWRlICJzeXN0ZW0vcmFtX2FkZHIuaCINCj4gI2luY2x1ZGUgInN5c3RlbS9jb25maWRlbnRpYWwt
Z3Vlc3Qtc3VwcG9ydC5oIg0KPiAjaW5jbHVkZSAiaHcvYm9hcmRzLmgiDQo+ICNpbmNsdWRlICJo
dy9zMzkweC9zY2xwLmgiDQo+IGRpZmYgLS1naXQgYS9ody92ZmlvL3NwYXByLmMgYi9ody92Zmlv
L3NwYXByLmMNCj4gaW5kZXggOGQ5ZDY4ZGE0ZWMuLjBmMjM2ODFhM2Y5IDEwMDY0NA0KPiAtLS0g
YS9ody92ZmlvL3NwYXByLmMNCj4gKysrIGIvaHcvdmZpby9zcGFwci5jDQo+IEBAIC0xNyw3ICsx
Nyw2IEBADQo+IA0KPiAjaW5jbHVkZSAiaHcvdmZpby92ZmlvLWNvbnRhaW5lci1sZWdhY3kuaCIN
Cj4gI2luY2x1ZGUgImh3L2h3LmgiDQo+IC0jaW5jbHVkZSAic3lzdGVtL3JhbV9hZGRyLmgiDQo+
ICNpbmNsdWRlICJxZW11L2Vycm9yLXJlcG9ydC5oIg0KPiAjaW5jbHVkZSAicWFwaS9lcnJvci5o
Ig0KPiAjaW5jbHVkZSAidHJhY2UuaCINCj4gZGlmZiAtLWdpdCBhL2h3L3ZpcnRpby92aXJ0aW8t
bWVtLmMgYi9ody92aXJ0aW8vdmlydGlvLW1lbS5jDQo+IGluZGV4IDFkZTJkM2RlNTIxLi4xNWJh
Njc5OWYyMiAxMDA2NDQNCj4gLS0tIGEvaHcvdmlydGlvL3ZpcnRpby1tZW0uYw0KPiArKysgYi9o
dy92aXJ0aW8vdmlydGlvLW1lbS5jDQo+IEBAIC0yNSw3ICsyNSw2IEBADQo+ICNpbmNsdWRlICJo
dy92aXJ0aW8vdmlydGlvLW1lbS5oIg0KPiAjaW5jbHVkZSAicWFwaS9lcnJvci5oIg0KPiAjaW5j
bHVkZSAicWFwaS92aXNpdG9yLmgiDQo+IC0jaW5jbHVkZSAic3lzdGVtL3JhbV9hZGRyLmgiDQo+
ICNpbmNsdWRlICJtaWdyYXRpb24vbWlzYy5oIg0KPiAjaW5jbHVkZSAiaHcvYm9hcmRzLmgiDQo+
ICNpbmNsdWRlICJody9xZGV2LXByb3BlcnRpZXMuaCINCj4gLS0gDQo+IDIuNTEuMA0KPiANCg0K

