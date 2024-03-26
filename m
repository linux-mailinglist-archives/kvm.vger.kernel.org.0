Return-Path: <kvm+bounces-12708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A5088C9E7
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 17:53:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FA92303110
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 16:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D912B1C69E;
	Tue, 26 Mar 2024 16:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AdEuOGy1";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tkN5PqLr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F281C2A8;
	Tue, 26 Mar 2024 16:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711472003; cv=fail; b=SVqOWHPXcbr0Vnm9iSIwM6zEC5UkBpSalkruV3Xr0qeK8iiOtEcYVSG750zoBrWFoWCeArxkQ0UpSq7MvCterfWqm0cnfmmS8JN6MBd39/GYScheVv46+ZoqsTI35HwJk6BJcoe/aKV7xq0SfdImInEHTPrup3GJZg050le6FMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711472003; c=relaxed/simple;
	bh=LbBcusnLowsgkPIfFBsLQxnz1l6yVB4+Tm+WT6vEz+M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Hma3tkKHrfHZ1Uhavc++s0vjWH0vmbabwDW/F9YelDGc9aCWAhzuZvBzdUUQzeciB0fx5imbLblPxgSnMCR+ZoOpzHY64b48r0cb3+t9ogNwR+I7T9o/Q2QU4JgVC09ZVA/PtJL5IBLid3yeUCnIqEShEE4+XheNjNfsHNns1bg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AdEuOGy1; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tkN5PqLr; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QF4tf2028844;
	Tue, 26 Mar 2024 16:52:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=SEhMjVKt/VV9wdp+AMfCFQTWoMRSt2J4eZHmCrcThgI=;
 b=AdEuOGy1sqo9Hsq2L1HeAZU+GMh8+18gtRWuREJYLjIoCA91EH8ov5UZ2+TzodNSTcaH
 H/C0z7h2DYK7AwnUG/PQoF8o1hKFueSN2lg9UIICzo5Uo2ZOUzPGJjO6CXfU0yxO1oty
 XcKNw9cWaDJgJ/ujCtAjOzrx/p+V7SARPhPcSxRRylIMybAHlE27i7fG68MAbsojF8Hn
 P7u3a/HEnwBpes+51I1qx8LC3Rf2vEBNDQN19V/vZbgSI+mpz8HHMYvOC6EL42Puo4vv
 mgrrNOnlNWZ0DBo/Vdokuf+WtrnsMvYk+1PenYBjDFv6/n3WkNAF9BoYBXPXCc7MbZ9w 5Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybnf41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 16:52:44 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QGaoKr017642;
	Tue, 26 Mar 2024 16:52:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh7h4fq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 16:52:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjIfKKjaN8+vTajYY6egBGb+VeCNNxYKzJW/l0khtIsORKeONto9sbK2ZsSSrazO5eKLmElomujlpT3kTMCI35nqgNOMBU+y3Ml+ZaynLOVZBCrNeAivzMVpBBJ/dgIMEF0rk9jxg4HLYwJ0aM+fubnrOPUutTS8R5MryMUjmNp59ITTJgZQo0SkCg9jl78FO7Kfwqr8iiWdSP4FSFhSB6oUa+W1X6B4h6ZWgDVKEnmPguOD+mBbD/W3zj6Mj7Bv9rgW6VW8oXibBIQNC0046kDXR1D9glLWTEBffTDmL/7FmJzTW0VZM3AWP2RfbxK7gkbdyATtWJ7LP1Rgk2F5+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEhMjVKt/VV9wdp+AMfCFQTWoMRSt2J4eZHmCrcThgI=;
 b=T8ugJa0f6tqsreFBzDOBatfli4ucse7voQ9MgqkOnzl2ASd/ZtOOEyOaDCJ4iIPZstbVTXE2oju8S4pkjLiVum1i9T7UdDJexFfm+ET4QpIHsv6a5sYmOXqOaYbCcwLAwsI+1atWqwBh74Jamj8/anbqDMXX7skpsuV/LkRo7CEdWkjo8DqML25xGzarTRlBY6MBJSjX1rdqfWvXBh4t+QFPOBIpKFV8CzZh+R3K2hjQmSMgFxlqYAXvhQMo2pHQPwF4H0a7POmQLenNDgJUfRkMgVj+Kg+wOVqluyRkyrfS8UCuA5DGmjGB9UfUh5/j/yYKnXyqPKSPHlPckUEkYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEhMjVKt/VV9wdp+AMfCFQTWoMRSt2J4eZHmCrcThgI=;
 b=tkN5PqLr0yoGCegbUFgllTBpgXDrrdPSCKP9J08Rgqhb3Pm095Pt/0H3lI8BWKIns972EJRR1rNEVDrmoF+1j1KGoywO7HpW9PgA+Jlr4nP7NZgu8i5KF8poVaZegMN7IP3peyKSz1Vp31gHsrOz+VETGSve0aPWoK/OMD+2k6Y=
Received: from PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11)
 by CH2PR10MB4373.namprd10.prod.outlook.com (2603:10b6:610:a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Tue, 26 Mar
 2024 16:52:40 +0000
Received: from PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::b037:6181:76f0:9a72]) by PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::b037:6181:76f0:9a72%7]) with mapi id 15.20.7409.028; Tue, 26 Mar 2024
 16:52:40 +0000
Message-ID: <8aca78fa-1aac-4f3d-a153-284170fc0b6b@oracle.com>
Date: Tue, 26 Mar 2024 16:52:33 +0000
Subject: Re: [PATCH 0/5] AVIC bugfixes and workarounds
To: mlevitsk@redhat.com, Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>
References: <20230928150428.199929-1-mlevitsk@redhat.com>
 <CALMp9eSSCUSOpP64Ho16sU6iV1urbjfTafJ0nThAWGHE6oOkLw@mail.gmail.com>
 <22be7d6156e38dfba1a055cc3e9cc3d10de75dbb.camel@redhat.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <22be7d6156e38dfba1a055cc3e9cc3d10de75dbb.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0192.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::20) To PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5893:EE_|CH2PR10MB4373:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	IqBpiywjwAfx85H2t4oNZGt2Gr2TUYhzIu9+H/u2Y2mk9xC3vzs/sbTkV385sgQBk6XRYmoX+kaA7jDvCQ+E+a6hXW1fw2aO7xYVoyseFInF3a9fotDFKmASpGfHQluK0uPvCI453xJHBKggx9xFbxInWd0InNseMDJcvthmwDXocH28NQsAPXvuk2830rMpU6jwc7V/t88pT+f4XSux8mWu0H2EVkJEvmPgXWHFrqKCjaNAzc1OluAykVQSaJibbniQJ4ZpDFxqSTaqUnb0XODnfaWSB7/d78BOKMzgDXg30dM8WQnIKLBAqCtdw8RTTV2QDv+t8SMKY9ourDEN85/W7ZcFnmjzQZZI4Y8HyYSeX9r6GYnSD+2AKbcaXhqNYF9OL+084oiwfsiBf4NyxyzLvzmS+G0KjHIbNx0icw4pHtS20cO2exV265Ux4Dv9Op1FNaJYUSQ/BvDU9U5ik6UYfSlNAY/X1nzfKMNc+CtBkYQilqEVxqHWBmXodS9yyPAuaKXTake+VshunT6T8liVIC/vABc7vzkw9DTxmiHIfGu2o8wZK45VKNHAcbHY9DtHJT7HmOhO03QTx7pca18w4CoE8rsiPt5kj+xwBlU=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5893.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MUIzVXE1a1JRbDA5Q1V0aFhOOHllTVdwbURvaFAydWZwV2pnT2o0ZGpwaW9K?=
 =?utf-8?B?VjBwOXduK2tMNTQ1cjlXSURSRlZlYmRLM2t5a0pBNGJ6anJGZVJIcm9SL1Vw?=
 =?utf-8?B?NjFaOWV6eUlKQlpadDl4Sk5UQm9ubTg4TncrT3I0U2g2d1pjSTdRY09DRkhQ?=
 =?utf-8?B?NXRtd0wxY2NHcUpmRnNKNXBSL1J6L3dIZGpPN2VRQXhYV3FXN0JoS1B3MVpn?=
 =?utf-8?B?VVFFWC9EZFkwaWxWTWNRK0tVVVhFTVcvZXR2VUVlbnI0SHZjbmlwR2xBeEo5?=
 =?utf-8?B?QjlweVVvM0Faamo1SDM3YitaLzAvd2JwOW1hdXQyMVgwa1BBYXVKWWJwc1Bt?=
 =?utf-8?B?b1ZMMFMzUWY1a3JwdkE1bFdsWlNON2t6M05HZXVEODhvYzk0RWxOcDdOMnFz?=
 =?utf-8?B?TVQ2T2ZUK1A3N3RucjMxWExLZGVuU0xoeFBrVzAyRThNM2dYNWZUVk52Y3Vt?=
 =?utf-8?B?WXRGUU10Z3NyZmc1SGRkeXhQaFFZdXcxZ2ZqeVdXMlkvNmowTnpReHcrM3ow?=
 =?utf-8?B?clNaRlJ2NWNoT1B4K29iUlN2R25yMWJvblRWS3o5WmkzdkkzQnhrdDJsOFBY?=
 =?utf-8?B?cVkxTjlFMTcwR2oyMEF3YmF6OGdSMlZTOTZFditSV2gvMXBLOUhmRnhZMmJR?=
 =?utf-8?B?WEs1ZGg0Uzg4TUVWUHZrYUJWQ1hUdU51YmNob0dSVndwSlpBV2FnTGNTQ2hR?=
 =?utf-8?B?S1IvSUpKMk1FOUhFdDdXTjRHV3RiMHJhUjh3NG9tNmhNUGt4TGJON1FFTVZC?=
 =?utf-8?B?NDdoN0t2T0pGQmFMbGVNRXR6cnJScVRic013QzFtS2wrTGRSeWpzWU9CSzVy?=
 =?utf-8?B?VUV1bDAwUm5iMTdzYmF4Wm00eStwQldFeEs1MkVEUVp4NzhIYitYRTAzQnhK?=
 =?utf-8?B?WE5SaGFLWFJ6Ykh5TTRVS01qL2xIMnpjTmI2TXlhaGQySUJSMUF2Q1cwdDNv?=
 =?utf-8?B?SWtKaU9aUnVhT3RObERjN2ROMm5qSU55RkxRcjV3cktZRUdyRVlhbEJvT3Yr?=
 =?utf-8?B?SXc1c0hlcC9YU2Vwd1QyWDllUE9FOEdLYWRkMWFXOUV5VUg2R3pjeHhab3BM?=
 =?utf-8?B?VTY2cTJucE41cE16TGVjK1NjRnpmSXUvMTVBWnZYVVJCQlExcE9XcVgwVURB?=
 =?utf-8?B?U2JQZEZpdmZkUC9FazVJSDY2bXFCUGVrMm5odjcwdzFuRVU2b2pHSW5tUnoz?=
 =?utf-8?B?RFRHQXQ3WGpOK1hiM2V1enZJT0M4T2tseFRsZDlEUnJhVDVPRnhDRktjR3lw?=
 =?utf-8?B?RGF3YVpyQVlIVm55eDJ0TUltQjExSG5tNVlTRFRLYzdZTWQ0aUw3U3VyOU9v?=
 =?utf-8?B?cC9FSi9aKytKL1VETmdUeFBLdWNQQ082akJWZ0FmNjJnUUFCckhMdXpKcGtE?=
 =?utf-8?B?a04yUnFBTEFab2ZwWlExYktlSHNwbnB5RFVCejIwWmhaUFFHOXdhNmxRVXlv?=
 =?utf-8?B?L3g5OW1PUFBVVXBXblZyUFByRDVtendtVEE5R1hadmVoNmFqUTZuYytpNDRj?=
 =?utf-8?B?VnpGdk9QNkxCUzAyYmhLL3BlWjlrRjlkZVNYNzFwVnRvT0lEK0JRWUs5TTk1?=
 =?utf-8?B?YXMrdWdpSnlTbEpvTm1EaFdFOFBZeStreG50b1phejVBek8rNjFiaWJ2ZTJn?=
 =?utf-8?B?Vkk3NythbVBMbFRqSTFnZENPUWwwLzNKSGtHNFdDdDhpd2dvTFhvOUtXZGNE?=
 =?utf-8?B?cU9WYW9EMUtLTUkwUnozaGtIcW9TRWt1NGVGQU53WkJnZ0Z4UXNxU2ZhRmtC?=
 =?utf-8?B?VDhGVlZqWUpmcjF4bnR1bjBTWXdWQUw1QlVxVHBrbUhNMFJvdnlrZm5sdUN1?=
 =?utf-8?B?MjdBekRxSGQwYWk2cDVxTHdUei9BeitlemJVTWJ0cnBoVVJPOGVlTThlSG5v?=
 =?utf-8?B?N2doazRTT3FHMFJ0L3VqRW9FRW0xR1FMYmpBVHlBTEhPc0t0UE9KazNlK2Ri?=
 =?utf-8?B?NUZ6ZXBvL21GbTVBc0JSVy8rUFUxL0tIdHJBZ25mVmI1QVNuY2c5NVBmd3l5?=
 =?utf-8?B?a1hnLzhUT3JPVzc1Wk1xQU9rWWEzekgvbkdTclNLOThQY0k3ZVVUODNDS0J5?=
 =?utf-8?B?K2pmQTJzYnN6RmozNVRuaWk5Y1IyTDhaSE1vSmZzejhEL2Q3a1dXMWFGMzds?=
 =?utf-8?B?WXdlN000cG9XRFp0MGk4TEhyZWNERTZ1ZlpwY1ZzUnQxSlVpTVVrNDJtMWdZ?=
 =?utf-8?B?NHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	S87jC56aDg7NjhsqsbShYIQAHdpJPbF2D9ePIFeJPqeodJlGK+hF19mDL8bQdlhDwJVHNbA8+oaXB2BkBjSxkdAi76yOOuYa8PhsmROuywz54axgEWU9YwfCeNgfBdI+CEWc+/b02PyQg3GvnRyKXUpUfNQ7eYojijikHjCCwcJAo6qpdz4ld4qWsyM6OWNFgoquGv8XtKWqk3ccEIGY8lUhiQzROOKPaxj90OnPxGhFjAvCkJAKgKMBPmi8AMcR9ItfNxQO3GBOvHG5GGP0gwkqkwdkiZkRUMUnm/af+yDY25nD8CKbzoa8Drlal6Cci88ra4t6T13fC7UTOOtIHB0w9PsE8WIHdwnDWs31NStsTvrM5sx6Q3oln1Rm04N5mPEf7SVux2XdLi/75rtO1uKg1fqEkbx+TaDKeV3YELxFpGhiF4+HHf7jvQ2Q6DavvYITCNmd1hPrU1xvZI0XBLwKUhmmyM7H7qR0KygvNZ11Jio+iyDQolc/NmKch0VxydBsIecP+FL3ij0VVVxdeQEpH/Zw0dbZWKRnWaFYQRw7+d9E+9Zu4eUCN3/K+QIipKB1akOT+1WajzMdex39Qon01aT2nzzNLdrrldB5M9I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bb459b0-f239-43ed-e8d1-08dc4db52631
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5893.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 16:52:40.7709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PcXjIHt+NTdVKik5Vskdb5LxjuB3e5IcJQTWc7GVIUwl9CMft79CqAM4ir61tXTEKjnFnDF6iXQG5kJ0k+UooWIIo2QMa0Fx8Jknrfl3H0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4373
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260120
X-Proofpoint-GUID: fAjIgNIF39Uxwcz1a2HNS6tcV_J4SKh0
X-Proofpoint-ORIG-GUID: fAjIgNIF39Uxwcz1a2HNS6tcV_J4SKh0

On 26/03/2024 15:59, mlevitsk@redhat.com wrote:
> On Mon, 2024-03-25 at 20:15 -0700, Jim Mattson wrote:
>>> On Thu, Sep 28, 2023 at 8:05 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>>>>>
>>>>> Hi!
>>>>>
>>>>> This patch series includes several fixes to AVIC I found while working
>>>>> on a new version of nested AVIC code.
>>>>>
>>>>> Also while developing it I realized that a very simple workaround for
>>>>> AVIC's errata #1235 exists and included it in this patch series as well.
>>>>>
>>>>> Best regards,
>>>>>         Maxim Levitsky
>>>
>>> Can someone explain why we're still unwilling to enable AVIC by
>>> default? Have the performance issues that plagued the Rome
>>> implementation been fixed? What is AMD's guidance?
>>>
> Hi
> 
> This is what I know:
> 
> Zen1:
> 	I never tested it, so I don't know how well AVIC works there and if it has any erratas.
> 
> Zen2:
> 	Has CPU errata in regard to IPI virtualization that makes it unusable in production,
>  	but if AVIC's IPI virtualization (borrowing the Intel term here) is disabled,
> 	then it works just fine and 1:1 equivalent to APICv without IPI.
> 
> 	I posted patches for this several times, latest version is here, it still applies I think:
> 	https://lkml.iu.edu/hypermail/linux/kernel/2310.0/00790.html
> 
> Zen3:
> 	For some reason AVIC got disabled by AMD in CPUID. It is still there though and force_avic=1 kvm_amd option
> 	can make KVM use it and AFAIK it works just fine.
> 
> 	It is possible that it got disabled due to Zen2 errata that is fixed on Zen3,
> 	but maybe AMD wasn't sure back then that it will be fixed or it might be due to performance issues with broadcast
> 	IPIs which I think ended up being a software issue and was fixed a long time ago.
> 
> Zen4+
> 	I haven't tested it much, but AFAIK it should work out of the box. It also got x2avic mode which allows
> 	to use AVIC with VMs that have more that 254 vCPUs.
> 
> IMHO if we merge the workaround I have for IPI virtualization and make IPI virtualization off for Zen2
> (and maybe Zen1 as well), then I don't see why we can't make AVIC be the default on.

Additionally, I think right now with avic=1 it fails vcpu creation when creating
more a vcpu with an id bigger than what's supported i.e. the MAX_VCPUS we
currently advertised in UAPI isn't quite honored. So that's the only wrinkle at
least I am aware. Sean had send this one series to inhibit AVIC when such config:

https://lore.kernel.org/linux-iommu/20230815213533.548732-1-seanjc@google.com/#r

But I am not sure if it was respinned.

	Joao

