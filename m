Return-Path: <kvm+bounces-37622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0349A2CAB9
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 19:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3A23188B46C
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 309C319D8B2;
	Fri,  7 Feb 2025 18:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D+aZhwbZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MzvE1Wyv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB65197A7E
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 18:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738951374; cv=fail; b=FPJ2vrzKVi69FzJyj/eEb7m4UGgsQtdHl2vOVBDsj+Ni1hh1G7BZdfXSu2PkMHPhW78EPiqV+QF0bNPOB83digS4Hjv/k/D1TY76zCQFjMypQp98m5lD+xzlcGy/tW2xspg2I1TOaZ0W4crim3cySW4a9ut8JrHRoi9qnNWuA9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738951374; c=relaxed/simple;
	bh=2GvXp7jbnLi/7SOHI0mya8VljOpMxwF2ZeUndqxJksA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cNE9+LEXpJoOFGUoqfM0mdXfoDmrS+Fi5Nnhs2MMfMQ9p1rf8QLjb4hvPMlKyE5nlNA0kBR0ZeZk/ZuyNJ/7nOkAhtdk7GkBAanMKygU8GNtCHK9G2wlqW3Xbr9xv57MEZTWNMw1O11KnSDAPRkFtyHOp/M0mXLNqdAf2CgYYdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D+aZhwbZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MzvE1Wyv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 517Hfs3E019885;
	Fri, 7 Feb 2025 18:02:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=aVMlHtuxwtGRK92aMx/9UwOGzoGS2Auk62EE5YdWFOA=; b=
	D+aZhwbZeXtAPs+HJWaC00BpwTb+V+9JEWK76Qo5Dc4H/lHRmtFO8D5KsYbWggT5
	CszY3jtrU0EymY9NClFpdqjaR7EWzd7hUMtJhHh/l/Is4wNoLnFbKLoRlpWfEkNs
	K4xDRGIhcgjbzmJI8P/h4yPHksfKk3338//1MFnpLnvL1PvGZ2myLm1JTl1cAh7I
	iVqIFEOHZqhal0vGZS7P3dCtxscKPSMOFhtaeinpfqUYYsFceaHsyBt4qn50WdIW
	jvSIkb5ix87AFbnNXpUv+x5inL/o8gR2x5IoGUxYq6WqbEfvQq/JQQ5yjNCmzAlM
	9uvoPMfswNB9VfYHblOjTw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44n0fsj8w3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:02:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 517HOG4s027833;
	Fri, 7 Feb 2025 18:02:29 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2044.outbound.protection.outlook.com [104.47.51.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44j8drubue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Feb 2025 18:02:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v1QvMabpEkvV8qA3I7u9XNR3SEgqLot/UFU2NXj0DrymhzWy8PSEkRxbZxSH6PBkLKfIGH80xZmQsv5qtWQ1e0IHngbp6tZtZpV5br15xZNXKmMxH/KyMHnszFnVt3sClB8gMcG5xC0fls4V4sattVq+wv464xceKQNUEoUjJRC0luw6FjyPN4Rx4MeCn56tLYD6wNxDz1D0rNcULrSEb0GmqVMCzROPuvCV9w27IC9Br9HT6i1d5rp5SNY134jsP2mzy1UadLweEOz6K4vJw5uU7fryzmeBP/p5XY9H+cTgQ59Ng1QGKCRejFklDtyyU9QJhZQxF+3Llm9N/wZfZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aVMlHtuxwtGRK92aMx/9UwOGzoGS2Auk62EE5YdWFOA=;
 b=ealjqBo9YJjYytnBI4OTKJAhyYJ5gPj2MWU9N/dyWFIUUtPl14lMw3nu3E/cUlio3vGGPCmomg5mzmYAQx5GlpNrtrbLlcJXoEJ3pDVr3NcLWdjXl+9AI01iBzFq3RJBol1qIk7ka/SU8yv3VayxXp/KAoPdfYgmWVA/+bz0wzZ9aHpaterOowUxrPy3PzrM/5GRWkadEjqTc4R7Sb3Yw4zHRYYtZ0iamQ8C1y6R8FpC+x1RBx5NuKXL5Qeqo5lcHq8ptySfO4D3xi11LU9m/g0j7GL3aYsoVHHuUBC/9brgY03xrXTwLGedLEjroFdPKnw2TQbv4BDJZ1BpmJdQ1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aVMlHtuxwtGRK92aMx/9UwOGzoGS2Auk62EE5YdWFOA=;
 b=MzvE1Wyveu0U2IRGyVniaAU1l8zoQMnUROK5aT9939FlM3DQPDCLsj88Bwrqv6rdlQazGUsupyFJzOhoNYa4Hl9tSgukX2jLynEKBbC6JqcgmYRXIidRe//N+ZcvcdFKLtVBW4rh2Lglm0R7QspGrdSaGxSijyhmnP6FCuQKsX4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH0PR10MB7411.namprd10.prod.outlook.com (2603:10b6:610:187::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Fri, 7 Feb
 2025 18:02:27 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8422.010; Fri, 7 Feb 2025
 18:02:27 +0000
Message-ID: <2ad49f5d-f2c1-4ba2-9b6b-77ba96c83bab@oracle.com>
Date: Fri, 7 Feb 2025 19:02:22 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/6] accel/kvm: Report the loss of a large memory page
To: Peter Xu <peterx@redhat.com>, david@redhat.com
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        pbonzini@redhat.com, richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-4-william.roche@oracle.com>
 <Z6JH_OyppIA7WFjk@x1.local> <3f3ebbe8-be97-4827-a8c5-6777dea08707@oracle.com>
 <Z6Oaukumli1eIEDB@x1.local>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <Z6Oaukumli1eIEDB@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0022.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH0PR10MB7411:EE_
X-MS-Office365-Filtering-Correlation-Id: 9153bba0-ca43-4cd1-8d14-08dd47a194d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MzNkTTRJcjhLNGpmNE1Xa1pKYmJTU3RickZvQlg0UU1rUlRuTmYyczdsSkIz?=
 =?utf-8?B?U1FIWmxleVVhcDR5SCthTzExV1VxTDVFendVMVk5VVk0MkdGTnU5OEhoL3R4?=
 =?utf-8?B?b1dxNWVpQTVaenpFV3pKckIyQy9pditBdU9JcGZyc0lMZGZjcVZrcGZ5NUpC?=
 =?utf-8?B?RzRBWDREZjRRZXZ1TjZBM0laeHc1bURhVENwQlN1ajVoeWlXVE9CbUhFMTRw?=
 =?utf-8?B?SG1Md0FVa1dKUzQ5UDJ0NXNlcXVyZkxLZGFVcFZpZjVMWVFzeUJxa1crOEx1?=
 =?utf-8?B?ZCs1L3dMOXFOcERDZkhFZjNUSkFmQnpzZVdpK05CdW5LSjZWYTJwYVl1M2Z4?=
 =?utf-8?B?czFPQWl2bjZra2Vjb0ttWmhxQmtHMFl5Y2tlK08yeHJEdzlCK1JXV2lUcGFM?=
 =?utf-8?B?QzY5QmtqWnlTUUd3d2VFMHFhVXF4eG5MZ0haK1BRRlVYS2p3cjZ6MWNjbFRN?=
 =?utf-8?B?RG5vc0l4WUxjS1o5WFpxN215cFdtMnN0M0JoY052N3E4azNXVXJVQTZPamJF?=
 =?utf-8?B?OFFwOXdRU0I3RlBMcHg2OFVCT2JPb1RUV3duaE4vT3AzalZmMml0MXJVemQy?=
 =?utf-8?B?UXM0WHhoTUNLcWUvN3dmdjVtK3kyV2RCUGFvd3ZPZU5tOTBuYllrNmVBTWpn?=
 =?utf-8?B?T1B0dUxGOVlpdHg4VFh6ZFRFcHIzVlRIenJYbVQ5VVdPTFUvTGJ5bnNRTnVU?=
 =?utf-8?B?ZlVSREVOQllyRWR4OHllUG5FQlkxK0piekduVFdHc3p5dkZNdmhpOXBWLy91?=
 =?utf-8?B?TkN6VVdqakpGdjhTTysxTE9yZUN4SGd5UHZwVEFXZlVodFNjQlJLQmZFQjcx?=
 =?utf-8?B?R0xYU2pQWjRyS2d6TW9uUjErcXROdlpmcUZXVjMwS3RhcnovZlY1bEp5Ykw1?=
 =?utf-8?B?NXBwTTdVZWlXZi9IeWEySFZDRC9vdDVHYXU4eVRoajlCVkd3enp5bnlQYkE5?=
 =?utf-8?B?M2ZWeVJUcTJiR1NCSWNlSC9DM2hCUjhMOHY0WnhrWTBSSmlEamtJOFZwa1cw?=
 =?utf-8?B?SFJ2MEcvQ2hVYmZEcXgrV1BlSjhwd0NBU1VzWDMvVWNhaldFeDR5UnBGa0dH?=
 =?utf-8?B?MGRLZjI3cUdZZTNiaTI4NklpbkRKRmFIWkE0R0JaVUxMT3Y4bms5QlcwSVIv?=
 =?utf-8?B?aldjY2RrUHQyQThHd3U2NjdVQWVPVkhlV0VNS3g5ZC9lQVVVTVFqTCtzL2po?=
 =?utf-8?B?cXBnSzVjS0hFS2FRcVBabEpEUktvdE4vbnFJOTJQdlBjbWQxSFFwRDJ2Z0pU?=
 =?utf-8?B?aDRuMll0Y3hzOGgweXJrY0ZwangyRjVtUlliSzZkWU1oNW1GYjg2ODQwOHE2?=
 =?utf-8?B?OGxYYmQ2N3lGUXpJbEJNdnVTcDZkNStoMjdtQmZwSUVwU1BvQ3ZXUmlSUlYy?=
 =?utf-8?B?a1V1N2xuU0ZRdFVKSjFWWUJQZDlVZ3RnazB1MFFjMWV2UWZDbEhGMHFab0VK?=
 =?utf-8?B?Q1lPOThNcm50ZGZjTGVRRkJCak9kWVJmNkl4M2luWk1zY0dKbUxqVlJLQnNF?=
 =?utf-8?B?TDhyLyt3RytKdHI4SkxiNkJQb1c5eGFTMUl6ZVBjWDhvZjRIc21YOWh2eENW?=
 =?utf-8?B?NzNvVmViWjNFN1c1Sld6eGJ3anU1L2tHa3RhMWFsSkpMVG9kcEYxNW50cEh2?=
 =?utf-8?B?NHQxbUdLaVNaYXI3RDFqajZXWDJTUC83RFhlQ1REditHN3BHYVpybkRmenkr?=
 =?utf-8?B?dzBVMXZ3VVlJWG9Pc3dqVEVPakhmQWJ0VUJnTVYxbitBSXZ0cWlLa2MvQkRO?=
 =?utf-8?B?UUFtS3l2Tjl1Rk5OVC9HNVJ3enZjbFlZVmdtejB3bHJaQjJTOEs1YlBpVGZ6?=
 =?utf-8?B?ODhndG5yYWR1MThXczAwSDd0OVMwd0JGempubm5pUkhQbDgxUXFFMVdJRm1Q?=
 =?utf-8?Q?UAuNknuBawbGB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b1JyR3ZLODVBM3Rya0Y3MDhVZUV5bjdsU2Y1Y1hSNWtEQzRJeXBzSWUzRkFB?=
 =?utf-8?B?MzJRbXgvUmlTMEljRXB4NU1SdDloZnc1a0IwVFQ3NmtWQzNWS1ZjRmNKR1Zh?=
 =?utf-8?B?RDY3MHZHS3VZVEJPYlp2S3MzOURvVUN5VERMU3Fva3lJNW51UEJ2OUxnVXJ2?=
 =?utf-8?B?RWw5TUFiZml2ei9qbGNzVGE0aDFmTjMyRDhuNGczT0xFclpxRko1T2lLRGhw?=
 =?utf-8?B?aXZkWEpOSXpZS05tcGV0cUlCUjBqQ2RORi9FWE45RDZTZUpVQWFmb2VhYms3?=
 =?utf-8?B?YTlYdXhLREx0QTMxWlN1M1YyL3gwRnZ3aktxZzN2cWdEUUEzMVN3SVdDd25M?=
 =?utf-8?B?VXZPN0xiTTdyU0dibjZsS3Y1SXR5ay9rcm1MRUdCbHF5OUxFMjhoNlY5ZWhi?=
 =?utf-8?B?M3VZdDhZQnJKOUsyeG9lTVF3K2RSenFmbjIvSDZmZEVWdWR5bFBCMUxnMEdp?=
 =?utf-8?B?bVFBVlVEdkdnV2wxZXQ0NG9lK0FrdE5qakxzcjZSQ29HZTJPSkNqR3FQdnd5?=
 =?utf-8?B?bGNKZTlsaDZrUzByT2VQMjJIUExTSFRHNzZhTStOZnlvNlMxUEhGVVlmSVdu?=
 =?utf-8?B?TmNrK1BQQWlRUGRxZFBxMTAvNUovZ3JZaXhLanFsTUhPQWJ2V2FVVWpCN1kx?=
 =?utf-8?B?US85K1MxM1pZbVdoNzZCSHJMVTFGOS9mZGF6Q2ZNN2IxdFRBNkpSbXEyVFlK?=
 =?utf-8?B?NDdOREtMZmVJa24wN3ZxU0JuK0dxQjRQQ2VyRTgyNlNzUmRrZ2orZEwxM2JT?=
 =?utf-8?B?RFl0NWFDeTJQbXhKUFpMWk4xbDVLaml0OVdPcDVRUjVRTFk5ZzI0bXdBRVI2?=
 =?utf-8?B?RTArOWZsQlg2dGIySzVDV01raGRnb0NpSUU0M0gxbXJwTG42VU1qeFJHZlVq?=
 =?utf-8?B?MnM1Q0daYnFGeU9jWFozbW8rRy9ybWlldXhkRkM1TkdCMi93ditIZFpRNEVP?=
 =?utf-8?B?aWE1OHRrNlpyZldlM0hwVU8wZkh6YVJSTGh4TUJQT0gwblF3K2YwSDM2dmxu?=
 =?utf-8?B?dWdHL1FzUGN5MVRLd2pCSkczTnZDU2JFWWs4K0NmYzZGYTlnY3lqa3R0N3NR?=
 =?utf-8?B?V2FyZzRaRnZMeXBkREc0aXdoU05CQmkweHIrQ0lzQnZXT3VXMHIvdDd4MXRI?=
 =?utf-8?B?VC9TTUQwcktVRTJWREd3WkV2QU1iUmFFQmhqQlViSUNwMFh6NEZuUm9KMmdr?=
 =?utf-8?B?R1E5YXJWbmFIYUIwL2l3Zko2K1ExdzA2Zi9EQTV6dW5yaGcxY3dlaGQvLzdS?=
 =?utf-8?B?QzZEWGRyTTNSREJaOUlLRitTVnhOTmRhRVBtUEdYNjlxWm0walBuK1dRcm1t?=
 =?utf-8?B?YVE4NXZUMHpaa1hZK3NBRE9PbmE2NEN6YXhDUUN5eFd4OXIvZlQ5R3J2ckFM?=
 =?utf-8?B?QnNwSUZQVGpqbnR0MmZTVXZ5UnR5N0ZIN1RoaVJCSEVubms1TXlyRXJIT1Jj?=
 =?utf-8?B?dnFmS3pReC9adDEvRHFjTlROd2RXYURFK2pwQ3lGcVlZUG5oRzRaK1lrbFNT?=
 =?utf-8?B?OHQ3NXhRNkdIbFlzN3BYbXgrNk02K1VTM2ZQazV4ZjZERzZ1QmE4a3Rnb1Bq?=
 =?utf-8?B?ZzF0bjFyaFZZNHpDdkFFSFV3ZjlVMDJhbXlhVitYbmRTZmxhWTBkRFR2bVQ4?=
 =?utf-8?B?cHViZ0RDSkx5czh6RFZjYmV4RnJjN3kyTjFMNkoxeGpnZ1hva3ZPTlYxMlNw?=
 =?utf-8?B?aG5KaldRaldkcWJXM0EvWTdaMFVRczc2c1FZWGs5cC96bUYvUVNpZUlpa1Ax?=
 =?utf-8?B?Ymx6QXVhcVN4MUI4Z25EWENUS1lQWXRyV05oZmkraktmWmJwanBNdER2eUt1?=
 =?utf-8?B?clN0a2FIaTF6czlYa0E1WS92QmZ3NmxoZGxXZHExU3l5YVBXYndkbkhYbVFI?=
 =?utf-8?B?OWZGMTA5OUlHZVJtNGVQK3ZBajM5SkdWM3RxWUJNOGVUelZ3ajc1R1dqNXha?=
 =?utf-8?B?VjFmN045RFB3THBnb0MybEdqZmlTT0VrY2xuTnV0dnJQODZMdy9WSVIxOWRa?=
 =?utf-8?B?RHJXK3NRbWJ1dms3NFpBZ3RjditmdUhYUStiZXFqNGtFZWZ5Szl3U2RSM1R3?=
 =?utf-8?B?ZzJCT2hMeXZ1M3YwNkR6NGVUOEkydmNROUt6MUNzTzk5U0JleGJIQjNRMGdI?=
 =?utf-8?B?UjNWYUNPbVp4V0JWUlVCL0FNS2V3blZYanByT1FDVDloYkY3d3p5bXJJeTVT?=
 =?utf-8?B?emc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	yg82yunvFNcikydJCElfb/VZoWyg2Q1AUSFiNH9kiE8OnIxCDtjMbdXjM9g+EfL5XS2VDLuE08hwl/CQ85d7wKaa+6HdjI2ysIWqbQbXikP5Iv1mqestmhpThRLr2GB9AonBEx9356nezzPgJdpCBM3PoSvJWjzFFfRUkgl4coPdM9A9XCrnku3rMw2PCDDO0ICAk2uCaxo/B1ZGnAJqtgHoGfnZihYtuXbcCWmN3Lb31a0Tqfx4jCD+H7mM9KurL4HzpYFxNJpg1kHEdP5m68SqonXRjGNHYHTfk1YV4fflMg0izSO5kHDS0QWVcdGTv5XutgwArEUDTqxHhlc8YisZ3r2/QImTgpFRkMZdG4p3OC4fujMbn/n4BD5vGq04jaWCTt+q2WFIMh/CEozlqpxL7WXVJyeLvD1N5SDJcODa6iVNFd799njJruaOzD6gG9E9BcvBA9H082wYW4OJilxsIt96kP7ytlW2PlD1SmvExkmCoodc0ba0HaBgQqHqOdd/h0cZ2MluKid5/AOk1DAGhuE6NqkUFUtwOq+p4tesSsA9ZeUbTwcOT+n//pZYp0iObSRwgfFJ/AQcSCpLlmWLFFWr+K+bomc3iZfx+hI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9153bba0-ca43-4cd1-8d14-08dd47a194d6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2025 18:02:27.1295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A0VRQ7pDylSy074ibq3IbodCL6hNrEDD1kjIEyzoc7g5O8lV+/8LcWMjj6EH0zzpJueyyln8KtW+pYBeCqUuJmNXE7j8/y/NVCo/1reHp6c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7411
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-07_08,2025-02-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502070134
X-Proofpoint-ORIG-GUID: 8A958N_cUa38ZZL9bZLqEG_x62MIdvw1
X-Proofpoint-GUID: 8A958N_cUa38ZZL9bZLqEG_x62MIdvw1

On 2/5/25 18:07, Peter Xu wrote:
> On Wed, Feb 05, 2025 at 05:27:13PM +0100, William Roche wrote:
>> [...]
>> The HMP command "info ramblock" is implemented with the ram_block_format()
>> function which returns a message buffer built with a string for each
>> ramblock (protected by the RCU_READ_LOCK_GUARD). Our new function copies a
>> struct with the necessary information.
>>
>> Relaying on the buffer format to retrieve the information doesn't seem
>> reasonable, and more importantly, this buffer doesn't provide all the needed
>> data, like fd and fd_offset.
>>
>> I would say that ram_block_format() and qemu_ram_block_info_from_addr()
>> serve 2 different goals.
>>
>> (a reimplementation of ram_block_format() with an adapted version of
>> qemu_ram_block_info_from_addr() taking the extra information needed could be
>> doable for example, but may not be worth doing for now)
> 
> IIUC admin should be aware of fd_offset because the admin should be fully
> aware of the start offset of FDs to specify in qemu cmdlines, or in
> Libvirt. But yes, we can always add fd_offset into ram_block_format() if
> it's helpful.
> 
> Besides, the existing issues on this patch:
> 
>    - From outcome of this patch, it introduces one ramblock API (which is ok
>      to me, so far), to do some error_report()s.  It looks pretty much for
>      debugging rather than something serious (e.g. report via QMP queries,
>      QMP events etc.).  From debug POV, I still don't see why this is
>      needed.. per discussed above.

The reason why I want to inform the user of a large memory failure more 
specifically than a standard sized page loss is because of the 
significant behavior difference: Our current implementation can 
transparently handle many situations without necessarily leading the VM 
to a crash. But when it comes to large pages, there is no mechanism to 
inform the VM of a large memory loss, and usually this situation leads 
the VM to crash, and can also generate some weird situations like qemu 
itself crashing or a loop of errors, for example.

So having a message informing of such a memory loss can help to 
understand a more radical VM or qemu behavior -- it increases the 
diagnosability of our code.

To verify that a SIGBUS appeared because of a large page loss, we 
currently need to verify the targeted memory block backend page_size.
We should usually get this information from the SIGBUS siginfo data 
(with a si_addr_lsb field giving an indication of the page size) but a 
KVM weakness with a hardcoded si_addr_lsb=PAGE_SHIFT value in the SIGBUS 
siginfo returned from the kernel prevents that: See 
kvm_send_hwpoison_signal() function.

So I first wrote a small API addition called 
qemu_ram_pagesize_from_addr() to retrieve only this page_size value from 
the impacted address; and later on, this function turned into the richer 
qemu_ram_block_info_from_addr() function to have the generated messages 
match the existing memory messages as rightly requested by David.

So the main reason is a KVM "weakness" with kvm_send_hwpoison_signal(), 
and the second reason is to have richer error messages.



>    - From merge POV, this patch isn't a pure memory change, so I'll need to
>      get ack from other maintainers, at least that should be how it works..

I agree :)

> 
> I feel like when hwpoison becomes a serious topic, we need some more
> serious reporting facility than error reports.  So that we could have this
> as separate topic to be revisited.  It might speed up your prior patches
> from not being blocked on this.

I explained why I think that error messages are important, but I don't 
want to get blocked on fixing the hugepage memory recovery because of that.

If you think that not displaying a specific message for large page loss 
can help to get the recovery fixed, than I can change my proposal to do so.

Early next week, I'll send a simplified version of my first 3 patches 
without this specific messages and without the preallocation handling in 
all remap cases, so you can evaluate this possibility.

Thank again for your feedback
William.


