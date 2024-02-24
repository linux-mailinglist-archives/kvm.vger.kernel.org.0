Return-Path: <kvm+bounces-9593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CDD57862275
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 04:15:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F04A1F25161
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 03:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D2A7134C1;
	Sat, 24 Feb 2024 03:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DZP7gzoD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="F13P39Sc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3154416;
	Sat, 24 Feb 2024 03:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708744500; cv=fail; b=OVb3587RRw2WLmkPM7le7BYt7jrS1g9mq3PmGqD2IWUQv0YkIAdjkUCIQUQkCb6V5KwFqBuio1bUruqwUnG5B27N1SfH3cY1aiF4NlQ1VNREi1pIcEH6VcCLK39QDxs0Xj66qJg7uvJZg1apQKDRfXZOaSDi1kOhvojBDJ5jSsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708744500; c=relaxed/simple;
	bh=GDlsNqyxeBBeuTxkZ68W+Yxunmfp5hYp1y0Iwf/O6uE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CTNz4cB4B/3/dtvjjnBFvflQ/U8hQuCLztWu1BL4zywrdiaDkEmcPjdq2ow7DFn1nroUlulMSV/45mu8bRWUo6DNjP0Xbz9En4R1uT8cuEYFqqQsmiDIkt67RnOOi3kWhhW4zR7ALSiuke5bGlEADl1uPTRIfUCV7oXkYagUPbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DZP7gzoD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=F13P39Sc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41O3EGqN029812;
	Sat, 24 Feb 2024 03:14:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=/Ac1ukEQfCX3FRQOp8CDNUp+lNzJKrh1UVvEL/IbEFs=;
 b=DZP7gzoD35RgC7l1cI9wWxtzZPpLv/68bHoajLtJDD0lab8aqlzEDdw2JymHCikEA3Yj
 +LnkLTEfteVHljELlu62eiWuNuFcSnQk63cX5YhlAMPnvNCbUAqvefAzdOE9MZ/LEROM
 F5pqYUaNjpWUMDZozPdIerVO8XapdzPOYS1D8XLgH00nhWgbY5BY+P5rYLXlegEDM7mC
 MetTmyGC/VMtV/Z+TMR085FPbjZMT3fGUuc/nfeGD4yQPB3mtLdyxe9etS3MMweiayw9
 /si3WV6cf87YOjpISSMppZ12IFNRDIKFAVn2An25otSUQSX2j1KfT7tpmj8wqdA9hfl0 Pw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf8bb001p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Feb 2024 03:14:54 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41O1XVV3038690;
	Sat, 24 Feb 2024 03:14:53 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w3hvqh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Feb 2024 03:14:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h25P7zNyGPlrhBkaMqrAZHM5M0/y+U3UMiULYSX64bR1WzxWeeTJE/ISsbxfXpZE6W/4c5pdndiAZayhEzNtBo078aH+4+8y3WWR27rYjn/cRoNY78osDK9aCwEq62DJyn7E1bWAABoEg1Te6h1pN2V4/mRRiV+MuY0C1JkAj6BeTCkqugiFkMUvHzL7fbn1VTLlN/y3oJydTkJiyitfiWHb6rqmizBpSB3jgoMzcEixe/5PBlx98B6Pi4eeDVZqeuohL/YDt84YMnhLeGLtEp11gZ5/83ZGzCis0zXIct29ijfVjTLOWNguDOOkEssvKbleq0CEPFHi4aB5zVb0aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Ac1ukEQfCX3FRQOp8CDNUp+lNzJKrh1UVvEL/IbEFs=;
 b=gkFLapc1OA5gsZFFGvuNfE4vcdslUKP4Vk3tUMnuVdB+ruMzL2O4S0slfuizvtOke3vkka+9KdjIxOVeZpNZp1HtozVUnRtX3u4rzPqwPJsoiUw7vUrQ8CrJCfLGZvlmdBpiU9T44Ev/vKEoOau3ENoYpqRf1FM9AcPguyqmsaFdfugtw0Jvr4vnpPilaKlw6EU9EyZRcs8vxbiZGe1qfIGvZWvZhe3lDmgJm91QugfUGq+KzFkKB/kg1jjMcl1kgkLNYWgzkFRPMyjoZBgMdbSvtEKKgrDInLTnTas4Wi7fIg8AmjTg4MkdT4migt47TkIJHiNH4PjX29E1RDVOWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Ac1ukEQfCX3FRQOp8CDNUp+lNzJKrh1UVvEL/IbEFs=;
 b=F13P39ScoVcbWl7vpTYEJomQtsEY7uXMGd+2t/mx6mYcexZZDJH1hUrDQVXUwOAANITdTJ5F2cXynEpCuPeYXbdWXMMuevLB5375SqoGy4X+kwcQdleR4ZFHCJq9Dm23OQeOX5PZkYgQijm5XFHQnXBLYVlWSbS8gwGgu5eWoJ0=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH0PR10MB6981.namprd10.prod.outlook.com (2603:10b6:510:282::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Sat, 24 Feb
 2024 03:14:51 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f%6]) with mapi id 15.20.7316.023; Sat, 24 Feb 2024
 03:14:51 +0000
Message-ID: <ac491404-f486-5242-8270-54b0c9d5829f@oracle.com>
Date: Fri, 23 Feb 2024 19:14:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 3/3] KVM: VMX: Combine "check" and "get" APIs for
 passthrough MSR lookups
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240223202104.3330974-1-seanjc@google.com>
 <20240223202104.3330974-4-seanjc@google.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240223202104.3330974-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0158.namprd03.prod.outlook.com
 (2603:10b6:208:32f::24) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH0PR10MB6981:EE_
X-MS-Office365-Filtering-Correlation-Id: 29c39180-f0f6-4ab4-12d6-08dc34e6c41f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	vzP6x5zfyCp6NzAvQUNZZv7imYgogyeMtyLNTOWQ64Ruvr4GAKkm0KGSQ7gV6BL28eLC27NUlFU2kgz+MwNNQmUUd3sOoVuuNY4aXBrs+z7YcVuIV3ERDEXuZMOx8G73lkWGH/NIiT0yxSVND7ouHo7qbSptEkuI61rMi1+/gnb59v1rwti5J7OzrsNCl/uHnw5I95OuirmgWDoLo/nkdThKCiuC6t0eP6b9/C0KKKmqK1VcIxGaHUFsZi0QLlBzFG+zFI8w4OGqkXoy0PcG6ysM8f2LX8UjFA0Sog/CrhxnJj1QOMf+yAYxgb+eu+82bCCei4xmAOuCqi4qJ9Pw4blNfgzFqJqLwPHpD8oAARMg1hV2rK5kWsS/myZKiEP7A5QORSSoNFrfu/tGRGqUH+ahy8T2PDIXZ1KDHaHv9jS0b0VpT2ELJEKOR6vRoAUo2QvRPtnNQZ6AFjIoZPJk4OWaNL7v6SVYa83nlp0IzoZ7RkgJdJjo/Vd6MOzP+69Q9iRTwzwzMdrlwc5e8FZ86H/7wTp4rArpK9AMJJpvqj4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bDYvblVFUXg0VmRiRVF6cTVrZFBGS2IwOENrM1BzdnFzTENNWTAwakNxaGdU?=
 =?utf-8?B?aUZxQlRhZHYxQ3hjeVpWMUFYMEl4M21lYWpVaUhnWUxnNnJ4dlFkN0tKWTNZ?=
 =?utf-8?B?d3QxcEo0dVpFcmlPU1c1ZXRWbHNDSmxORWFYSjA0MERJR2U5Z3dGcERHUFhP?=
 =?utf-8?B?TXlRTzR3R004NHhhMm0xM3FHNDFpY2gra1NrSmkrN2tsV2FQM2phQTRYaURn?=
 =?utf-8?B?bnk1VXdaK05mOFd2T0hMclZHMWZzeFV0aEZpalp5Z09Fd1JIanpYcTJtNXpV?=
 =?utf-8?B?anhsS0JORWxIQnJxRjlmVWo0Z21NZkhtRElJd3JqcGlYV1kzTlRxWnEya0JN?=
 =?utf-8?B?QU5RcDhhSGpPWnY1S3VNbUhmMDJtY3lZZjZCZXlLdVo5b254Wklidm5BSncw?=
 =?utf-8?B?bG92Mi9iOE1GQ1lMNmxVRzdueTl4T29kNCtDVWtBTmFSSjBaVVh6MGlsNkhM?=
 =?utf-8?B?YVV4OUhSTmtJVG9lSWczVmtCUWNZR0d6T1JzRE9YVTJFSmRpQkJJZXlZajd3?=
 =?utf-8?B?WkN3UVZtWXN5NS9VNlhoeTZ1WGVmc205aytzK3ZtUkkrS0pRT0Zvd0tmSGMv?=
 =?utf-8?B?N3h2Zm9OZnhJR3ZIaVRvMDgrbU56TC9QaDlFS2dRSGN5cW91VFNsVGw4b3lJ?=
 =?utf-8?B?N1V6UERWb1pKVVRmSVRNZkZ6cE16eDNBZTBwRlY3UGwvbXlVMWIzMUZQd2J3?=
 =?utf-8?B?emlZL3hiYUhNbkRsSll0Nm5FQW9oMTViYnRza1h3OW1HOGQ1d0hDcFo5NlVM?=
 =?utf-8?B?N0lvVGJidm9NZ2QxVkNielpaMGd1T2NOKzRhMjVyRFBQNmpQUXptbHFZQmM2?=
 =?utf-8?B?KytQWWtYcVdxdStlallmRHJEME9xRXdqSEgzbUk2emtwUW5XeUM5NlRSMDMy?=
 =?utf-8?B?NUp4dW9KaTR5dEpkeVBoRHdvMHA5dFZUdE02MlpyWVpaaFNpY3BVRVNHdUdF?=
 =?utf-8?B?eTJKTDRlMXkzMnlGdlg4WklhejdDSkJDUGdmV1ZpNkNjSU5jelh2bThSb0hJ?=
 =?utf-8?B?b0pjNFJGVkN2bHdSYzdyWlpPOUF5d20yek9ZMW9VaEFadC9QOHZlWVU2dnds?=
 =?utf-8?B?WldjSjBlaGVhU1ZIbkNsaUJ1dkRvVjVEZXZhQ3hlUDlOcHZ5MDlRWkJ5a1hX?=
 =?utf-8?B?aDhEUXVER2o3TGxWbUdUbTFOaSt4cVY4SnFwclE0Q3JlaWhTSklQUGZUM2R1?=
 =?utf-8?B?bGNQL3I0ckJxRmtFK01paGt1dFV5d0FsaTlxVFlCeG5lay9nNGxEanRKN3B1?=
 =?utf-8?B?MnhYaTZSSmQ0UE9pUjVJUmNnQVl1M2hCd0lpWkZEZ2kwTkg4RWw3VHk0cExP?=
 =?utf-8?B?NzErV1h4WHo4ajFVVG41V1VzNjZpdTRySU9UajhYekVxd1N6dCtWMUxheGxG?=
 =?utf-8?B?czBKNHVhRjFEenJYUUtGUVNZT0FjUktoMEJGY0d4dUs5dnpwWGhMNEJvZDZL?=
 =?utf-8?B?enh1bWJORWoxbmJuYTB0Q3ovRm01WlRBRkRKVUk0VXZ3K2RHbjBXVit0eUxQ?=
 =?utf-8?B?elZwaTc4ZWY4cGlnSEFiNmtGY2xROHhLWlQyMHR0bVRhRmZOMGxHYjJvRkky?=
 =?utf-8?B?dDlJRmhEOXJoRXZ1WU1XRHAwMmJrYm1SeG1DQ214Q042dlp1STBqdWUrS3FV?=
 =?utf-8?B?THhlOGF2dUhrOG84VHh1eDdha2l4S0U3eWZFZ3ZQRWlBQjNOS1pEQUd0NHJP?=
 =?utf-8?B?dkpRV0dJRmljWXhOTDk2WEJCRmFsOGpreDNKdFVwY0llQ0MwYUsrMDR5N2lU?=
 =?utf-8?B?NDBQQVNoUUg0VDBiQWw1M0x2VTlLMktMemNMbHFETGJ5SDhKcjhwS0E1U0JE?=
 =?utf-8?B?L3hGTnl2LzV4Zm5lNk9CNmZJYnhXaklEb3JkUzE2Q0hUZ09hcWNYV294cE53?=
 =?utf-8?B?TGRIanpOaHZMRmVITVQ5N2o4OS9XbzA0c1lxREFlbGVnRTJmQ0drZmFBQ1I0?=
 =?utf-8?B?SHdVK09nN00yV0N2NnZjYWJyNWtTbVJZanp3TTJDTVJWYXJ5NVQyUmFZWFJR?=
 =?utf-8?B?ODQ5QTdNbW9uV2MwRmx6TzNyQWlSSFh0dTdUODREdzJLdWZ3dzdhQlZDaGdo?=
 =?utf-8?B?NlQ0NnVsVWhyNGNNVTI3eVhHMHk5a05XbFNqelo5M2NJMkhydFZFZlpURURr?=
 =?utf-8?Q?H6Lm/z5tP+i7IW5q1W1eaMYDC?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	2PNdaZ2kgYXkytkuvuDKKbrnmkqoTlfYSsKfhBqNF5cu4Jl2IJ9KB7pPBPoMa7BBxrbGCDyEh0c+E1A4YS1GIwywp46MqyrbV2ML9fEWL8tDQfiSRUTWk8ZrMECrlgWGtJOaEOpxyIIEOXUb9H4+O4+KsbgCkMT6wIsoKt2YT8nZwxhdiAozlCl/6fYnAyFm4HjDKWXg7HVmk8BPmI+Kz+vvfpv+i2ggho/6OiQB7skF766HXqO5lOEaCWWyHWI4KCBusHrKmTNxEC+bgyXllbANOgqLmimf3dljocSfPGUgiaSbHUx2Q7K+sumM2L6+6PVWuG4IguyYYKzRUaThobZUQczLHXWUSAnTo9l9aXUZrmJDql+1bJoRjJVT4qBIvt11XFCAW9u363Qgs5zPiYhF/x/IGyQCa9kTPuLBkok8pRL0aFwUWbMS8vx3dz0k5+sZPMvsU0ssDbYK72b9xQGwAt+5gvwaJnzUHjZ0vdFgsg9IfxY+7G6c+UoM79RcAUt2gkc3aqPjEOE23x7emqOsjwkWm23Rc5xn8C85NZzCrKOaTvZYKei941HvzM4CEd8fJeqdapDeajSOCs+jkMGn+HT3RrUAPCeKR73JmAE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29c39180-f0f6-4ab4-12d6-08dc34e6c41f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2024 03:14:51.8374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mG+DvCHbS6DochwrpvuDzggg/GW2caU/uTA6/Z+bnK7WPLfgNWuG3zdCapZy+/0iO9xkWO4yTzPfuMe6mLNUsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6981
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-23_08,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402240025
X-Proofpoint-GUID: OcVexHYTtuwQtTsQ0jgodR4MBKN2rTr-
X-Proofpoint-ORIG-GUID: OcVexHYTtuwQtTsQ0jgodR4MBKN2rTr-



On 2/23/24 12:21, Sean Christopherson wrote:
> Combine possible_passthrough_msr_slot() and is_valid_passthrough_msr()
> into a single function, vmx_get_passthrough_msr_slot(), and have the
> combined helper return the slot on success, using a negative value to
> indicate "failure".
> 
> Combining the operations avoids iterating over the array of passthrough
> MSRs twice for relevant MSRs.
> 
> Suggested-by: Dongli Zhang <dongli.zhang@oracle.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 63 +++++++++++++++++-------------------------
>  1 file changed, 25 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 014cf47dc66b..969fd3aa0da3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -658,25 +658,14 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
>  	return flexpriority_enabled && lapic_in_kernel(vcpu);
>  }
>  
> -static int possible_passthrough_msr_slot(u32 msr)
> +static int vmx_get_passthrough_msr_slot(u32 msr)
>  {
> -	u32 i;
> -
> -	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++)
> -		if (vmx_possible_passthrough_msrs[i] == msr)
> -			return i;
> -
> -	return -ENOENT;
> -}
> -
> -static bool is_valid_passthrough_msr(u32 msr)
> -{
> -	bool r;
> +	int i;
>  
>  	switch (msr) {
>  	case 0x800 ... 0x8ff:
>  		/* x2APIC MSRs. These are handled in vmx_update_msr_bitmap_x2apic() */
> -		return true;
> +		return -ENOENT;
>  	case MSR_IA32_RTIT_STATUS:
>  	case MSR_IA32_RTIT_OUTPUT_BASE:
>  	case MSR_IA32_RTIT_OUTPUT_MASK:
> @@ -691,14 +680,16 @@ static bool is_valid_passthrough_msr(u32 msr)
>  	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
>  	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>  		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
> -		return true;
> +		return -ENOENT;
>  	}
>  
> -	r = possible_passthrough_msr_slot(msr) != -ENOENT;
> -
> -	WARN(!r, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
> +	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
> +		if (vmx_possible_passthrough_msrs[i] == msr)
> +			return i;
> +	}
>  
> -	return r;
> +	WARN(1, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);

Reviewed-by: Dongli Zhang <dongli.zhang@oracle.com>

Not sure which is better:

WARN(1 ...  , or WARN(true ...

Thank you very much!

Dongli Zhang

