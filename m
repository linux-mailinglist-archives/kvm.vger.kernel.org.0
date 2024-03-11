Return-Path: <kvm+bounces-11494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A2612877A76
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 05:51:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19C551F221A3
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 04:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38748C2E6;
	Mon, 11 Mar 2024 04:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="e+TW3V1H";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WijNbC9s"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC65DB65E;
	Mon, 11 Mar 2024 04:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710132664; cv=fail; b=THmUjIcJWrXLVVickzy6xWSw3G35COFP+/R+B/OeuEONetxFe5XDXxdoes0fijN7EjrVw0zPdfC6xPdzWNk3AHLfQaGtvBFHcrzM+r92iozRp44oIUyZ+eMiQGwabgrA0jSN5/7vZw4q145lEUc+d2p2VxYWSjGgeghXJlzfGEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710132664; c=relaxed/simple;
	bh=ZMCWOgeQgX0gIeNmfrkDnWWShrcCUkwAoTCv+706v6Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tfi3GCm4teZUKYnO0Owlq65rv1o844tCspI73IeIGi56as+mgZD6CVj5naav2d2MEVfgtr3Yk4U39xHcxE7Tj+zJE3ZQV44XMeR8Rfes+oRQcIKOJH375+U0WQ65MLUdm08wwqUvIhcg+Gm7tb6vtFJ0mPPXWNf+Q2xEKIr+Hxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=e+TW3V1H; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WijNbC9s; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42B4OJiC009006;
	Mon, 11 Mar 2024 04:50:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=VGXuKpQISdGM4JoW29nbeh2fKBPu3mj8lCo4wKazW0g=;
 b=e+TW3V1HSxBzPJIIFxhQx1GqwxhRsHtZfTIpjAgfJEheaA8Y2bSujbFRMpLDAsd6T1Bx
 0esP+iIZZnfQElXZ9xmxe4T8UKpQjMuAlXVhrB7zjG5ZgcsQ9daxg9aibTbMJr1np415
 aLQgAueGH+Nq6s7Q+/ba2sZKAmzcNLwjOymRft6b6oU7K7MpAZ7DSONrJymSt8HNCW1u
 grn8Z+tWEMPa0izNllG2P6y1R6J4r5SRTZSvkyKljee3HhOdCe85qL5NaYNXTF25W7sx
 OIQz53jpLFwSoMpJpZ0yqcLbzQC4DzDIcx5JIETSoqicFWwH/nn5ItR+jcMYxYNHAUFX Ig== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrfnbj9na-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Mar 2024 04:50:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42B49gOZ037444;
	Mon, 11 Mar 2024 04:50:30 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre7bf5m4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Mar 2024 04:50:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQJ1e4R4fIPXPRuBiaShXC9A/lDUYDqeWMZB7a/XrnUouS7ehqk4E9VO+BGBqBwlajgxKM6VtnaEtdruPaDysn+E7K+FnSg2/11Zrc7ZLTOr8eWGosBy82fgJHMbe1UCGIBqPLJK/Rnb4CE4EU84ttE0OiqdWo7rAX29cAkdFtkKuBFSZ+40RQ+5xDKb2lOkEP9/uJXzDuBkUnvJmyU/1cL0J2j0YkZuKxxCZYh6t8qF1Mn0gZF60NJqjPjoZx2qbHiS0wSdIcmCqqaQckKW+aH+RP3mZH/qxa3G4MKc8P2MgJq7J70FuGsXgIKokuOPwHPgh2M37kgiGoe7G4ESOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VGXuKpQISdGM4JoW29nbeh2fKBPu3mj8lCo4wKazW0g=;
 b=KDYnmwZSMe1yIYo8ShcWQl6IvbhZjCuoS5pNMBgL30UzkJ6dHfFN2WDrd4+gMBwl0d/8S6UohikmbuEUEv0G15mQw4MnrWsW6biGRjNbyGnJGBS+/UuGU5IfO7hIp9IyIPf5dKM5sJZm3P2oxjY+heJ7NlmcP13yJiE/ZOufumljP6cHbNxdbHpePOunXjsITepkSesfhONaDUfFFpS18C+IGDnN0MQ/U7r6e2F1CVg+YDLjshBnNEKZiww8Q0gThesK0LaRl7B5+g2Io6Looio9eyLAmpJJWjK/xcobSkSvbWooU6yeMNTm9IAtwE+tE2MKs3BqV2/1Z51f4YLozA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VGXuKpQISdGM4JoW29nbeh2fKBPu3mj8lCo4wKazW0g=;
 b=WijNbC9sPZgq93NwyLvLLncXekcBbO1aIQ2mhtBGMlIwDydN9hiHbcAkjuXO2kHCmF9G2H8ePsB/+pzVhfr/huoGmrIf0tZ5Y0Y4WV0cG1ocuOX45dI3XdK7EoodhRrrl2JnC2aBmuSaAXW0TGcCOjeF+8/Std7qsRYaW9EYPQs=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Mon, 11 Mar
 2024 04:50:28 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f%7]) with mapi id 15.20.7362.035; Mon, 11 Mar 2024
 04:50:28 +0000
Message-ID: <36f0a5b5-01d7-23a8-b562-0470e0dddc22@oracle.com>
Date: Sun, 10 Mar 2024 21:50:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/5] KVM: arm64: Add accessor for per-CPU state
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Mark Brown <broonie@kernel.org>
References: <20240302111935.129994-1-maz@kernel.org>
 <20240302111935.129994-2-maz@kernel.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240302111935.129994-2-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0324.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::29) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DS7PR10MB5150:EE_
X-MS-Office365-Filtering-Correlation-Id: 5026f07a-471d-4930-2e5d-08dc4186c5c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	feXcD5M+vcZN6dny9au/xUPMDTbXvB2Tvo6cM3xcsPDbOARICkBhLBZPQrmS+4I9h4xv+DXbcqFNcgp1Jid0hYRDNkCZKQRqxIj3daoOYpzto0AqiEekIn8eKp/6F3jZWvOUiq5om+B7GGmsq3f1oEKy/YhlQ5iOQDoCmXxoCJ3JA/3/12pa8utlOU9LWZ29TRacsybCjyhlC5gM3v+jXQc1gULAHwuIZRqgLOJILP2rJIAp4blgD2tNp0249elAl/2hH6e4g/AAYxNUaKRVyXkUXbtzsYvtH2T9vETi7zItlSZswxuGoeIVaRhNEHcoR/+Enjk0TIkP7Zx76Fwz09MgEJTtek1u8I0kZJo9ksZ4XY83xPxK1Qu++rEdKi2e+U0vxoDS6mCx3YzAkD2AB7qhLtwRFfa6+ISYs0cTw/BVwkHB5Zg9cun0sykLHEQDghYtkj2J1c8L6kuynR1eKPNz4yH2SkyAo6XiIWaUQqdyC53T231rycffs++dbKmC0xz7aMhjs7WZItN7AYGWOHhu30XH7rOir4SyZKnZhmB2B9LYKqK356oKkPejXNiwBP19pzqRgUGBFZGO7VJ/d65h6rCPR7ZfjFOkvVmz16tUI4DSr7k2GMj+p6whPFz+QUZ9E96+qbeoceq9QozKNVPylj+K8yo52RfZcp5Rw/o=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dDlDNFN4MksxMEh1c1JBbUl5ZTlsOVdWeE5MNWI1Ym1YZDE3WVJ1UmFNUG9m?=
 =?utf-8?B?NXVWZVVLaUlzb1hGaHhlaHJsQUxwWFRWZmU5ME5RZUx5SlR6aVhReW5yZEIw?=
 =?utf-8?B?WXpORWo5QS83ZXNOUWVLV1FBTXduN21TbVM5RkkyNFY4RjB1ZUt0cjlsTzJk?=
 =?utf-8?B?ZjdsdGNtRDNYRnl2UnV0VngxZmlTeHZZZ2ZKM0g4S1BPWHBEZFFHbmxna05S?=
 =?utf-8?B?VExuZHI5bTNRYmltTVVtcFMvaExvYnAzZUxRMlNDc0dFTVFOTnNWaGs1bmNw?=
 =?utf-8?B?Q3VXekRqRjdFRWZic3pHYkp5RmN0VUxHeXB0SDB2dU9BR0NYaEUxU3lSbitF?=
 =?utf-8?B?QVpRL09HUyt0STF5WCt4QmJiREtTL2lzUXhzTlVmUkl3bHRwNUMvempRZWJS?=
 =?utf-8?B?OS9lNkErV2FCVDE4SUtTVmhpa1hSeG1sNVpDblV3UzdETUF6TmRyUzQzQy9G?=
 =?utf-8?B?dDZpcnhodFdZcHJNQ3VXQUhYVkdDOXRwUzhkQ0JQYXhCZTErQXlVWDZBQU1E?=
 =?utf-8?B?SDl4U2I5Wk9WSmx2TzhLMDNRMTVzWWJxeElIVFVQZHlGZ2xQVEIwUTIrTmM1?=
 =?utf-8?B?NnRNT3JEdVk0Y0FwNEMrK0dCWURhbW1oMEt5d1Y0MFVOcXVScHNrNVBEMGVO?=
 =?utf-8?B?QmlzOWl6MmtxQmhGUWQ0N2FlZ1orTURjdzVNL2RTTWpJenBDZHNUMDM4YXRY?=
 =?utf-8?B?dTd3RGNEZ2lDUXdNYnVTR3pzeU9HZytUUTJWSEVQUnJxYUE0ZjA0QmR0OXli?=
 =?utf-8?B?MmJ5THRXL2dGQ2pNNmEwVmlaeEdsVnFVaUtHVm0wY0x1dmlTcnczQlBKRTM2?=
 =?utf-8?B?RncrSFlaZXRNeTdBMWVmSjBZNVRNNWZPeko2ZWphL0pySWJOeTlQQy9GcVRG?=
 =?utf-8?B?aTk1WWwxQmJ6RXFuRC9nOTdtcWZmdlRTaEY5aW1JbkQ5QUNrdUhpOXZvbjZz?=
 =?utf-8?B?R1ArYjhJN0IxaEhYdzNqWmZ4UVk5dmlvcnhMbzBKTG1ycDhMN3hmSGcvNWZh?=
 =?utf-8?B?TFE2bU9iSisxTHZXM0V3VEJZaGlwRGEzR3Z0ZldXSzJJMU9jMGRyelZUZTNP?=
 =?utf-8?B?OGFyczFzbHpMa1RuSk9MckhidVpoNEMwQzNLUnRxK3grbVZxRWtBZDVqQXFN?=
 =?utf-8?B?VXZRUkJZOGRYNmJoYzlUTm8waEdpQUx1UEhONFBsMkFDYWV4Rk5kVnl3T1Y2?=
 =?utf-8?B?RHk0ajBUSDNZckFzQ1NNd1JsQkN0QzhsbVFVQUxiNWlIdm9tUHVsYlc4VWxo?=
 =?utf-8?B?YzlCc0REWDZ2NnVrYmNBVXdYbWtNaWxPbW15Skdxa2VSWW1kNCtNdjk4dEJj?=
 =?utf-8?B?THlHa1NYc21WSXEyQldDWC9NMFJ0VUQxWEZiamZmUWpTaXFjcWZqd3hoWHlQ?=
 =?utf-8?B?UzZsSHdQMWVIaXFpVlJSREpicmdDekpVUjEyVTl4RWZOL3hlOTRuQjF6L0hY?=
 =?utf-8?B?ZWF1eElOWVZwb0I3cFVQalkrQVFHaktEVm91Vml5WFNLTVlEL0FRWjhURG5V?=
 =?utf-8?B?MFROVWNLVlJDd0l0N2trUWRSS0dnNE1sNWM2ZjVkYmNIeTJXZjFMKzdsTU05?=
 =?utf-8?B?dEI4b1VuRXRsVTBqRmltbnQyMGsyTWlwVHU4dnJVbktuTlp2ZVdqMEt1VVBk?=
 =?utf-8?B?QzZRMTRkYTU0bXluby93QjFUWk5kM1p0MmtoT0lUNUpCVW12K0U1MlVkVFZU?=
 =?utf-8?B?S25acHFBT0EyM2tvN3haQ21udU9uRVcxRHVab25TZWc1MU0rWEZlMHVZOWlp?=
 =?utf-8?B?RlpvZnVPTnpFWmlVbjgrdnZ1SEkxNkd1UmhEQUNjY3NBeks0L0tYZVp5RmFv?=
 =?utf-8?B?di9xc2RaSC9Ua1JFZXNDUjlzT0dRaFVjSnhJSEN5TEFKSFZ3YldWSWcvNjN5?=
 =?utf-8?B?eHU1VjBoMTQ3OVVrcW8wdlg1YldBbG5wdDFSZGlmMWZWQ1pmcXI1TE83U1Na?=
 =?utf-8?B?SlBIZnVGcXdXb1pjdW9CN2M4eEptOTVpMU9DK2FxcWFGdzFIT2Y1NXJ4d1JP?=
 =?utf-8?B?dTBvaHFoT3pMTm0xeGhzbmdwMUpVVW1EMmFHck9UMXJ3UFVMc3k0a3FUcHRW?=
 =?utf-8?B?QVNzSmtOQllPOTlFNzZvdkVFd1pZYjRwZktVMnFUZUtodXgwY2pWV29mZ2hV?=
 =?utf-8?Q?eEW7HirC5TPKYGS2Bgre1MeKR?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5+sByvbRHkkR8aiLH02nG4y6GtgW7aSOMcVg9XQKKYLBNo6RdvugCBXyniWC0POnTOTWuzZzpJPaSlBLV9m8j+4Vj123IAg/bgTJUWkjatqJdAa+eWJATElpclMYbSJ0grwIqRH+Bcy76mAF+tuyLTNwxEJslIlB+SR5EMcjxfyz3RhSNlUKmeUsNk2PGEuWkkYXxCmiLl41vxHaH2D3Kh5sgv1iYxDv8Nmh9XFTGU80SWdE0yGDxGX2DMn0aYAoJjqjfTkmspVx1Wuu/lxT3Xl43rYMW2z3VX8RcUXXuNrMDAkcBkiCmHMvjHSg6bc9EGfrr3EH8XC3fNUEAGhV1AwITN1VFdgjdP6mZLHS4umfYZa7mGRI9G4IFt5NuQKDyb5b+KHu0o8NdykY5LixHH55bOi1zKduAbCvAn9esSF8jBIp/JngoUBPExIepvIP44OAOgPwM6uNVk4vexrsET39Vj53cQffXWRev/1UXlyX6R8o/Tf6/lVi7j8wzJB1h/9zlu4fnXslhpgefUTD2Lnpaaxq6+47C7jlXyWNvq7TjDh3QIikNNDd2jfllvrXqM1OJe6uXHOBqsCeMYm3+aQuWwQCfHTx2aA4087FPpo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5026f07a-471d-4930-2e5d-08dc4186c5c4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 04:50:28.0373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tmt/DGzT/wrCF+zOkd6QNNMkfl9JWNvi2RRydWrUAao4lgyR+V9+blDUSnUzNrLmPnFBX6MymuFb1NfmtlZuKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-11_02,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403110035
X-Proofpoint-GUID: 6jQTbewdMvLxNnaMPfuip_FGP7-l5Ilu
X-Proofpoint-ORIG-GUID: 6jQTbewdMvLxNnaMPfuip_FGP7-l5Ilu



On 3/2/24 03:19, Marc Zyngier wrote:
> In order to facilitate the introduction of new per-CPU state,
> add a new host_data_ptr() helped that hides some of the per-CPU
> verbosity, and make it easier to move that state around in the
> future.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h         | 13 +++++++++++++
>  arch/arm64/kvm/arm.c                      |  2 +-
>  arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  4 ++--
>  arch/arm64/kvm/hyp/include/hyp/switch.h   | 11 +++++------
>  arch/arm64/kvm/hyp/nvhe/psci-relay.c      |  2 +-
>  arch/arm64/kvm/hyp/nvhe/setup.c           |  3 +--
>  arch/arm64/kvm/hyp/nvhe/switch.c          |  4 ++--
>  arch/arm64/kvm/hyp/vhe/switch.c           |  4 ++--
>  arch/arm64/kvm/hyp/vhe/sysreg-sr.c        |  4 ++--
>  arch/arm64/kvm/pmu.c                      |  2 +-
>  10 files changed, 30 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 21c57b812569..3ca2a9444f21 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -492,6 +492,17 @@ struct kvm_cpu_context {
>  	u64 *vncr_array;
>  };
>  
> +/*
> + * This structure is instanciated on a per-CPU basis, and contains

instantiated?


May this patchset (at least the first, second, third and fifth) be qualified as
"non functional change" in the commit message?

That provides some hints when backporting this patchset to some old kernel in
the future. Thank you very much!

Dongli Zhang

