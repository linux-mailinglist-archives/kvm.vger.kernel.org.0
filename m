Return-Path: <kvm+bounces-10498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E33F986CA8A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:44:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D2E71C2245A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 13:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F178627D;
	Thu, 29 Feb 2024 13:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SKddM8fm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Xfx4Q87R"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028504B5DA;
	Thu, 29 Feb 2024 13:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709214251; cv=fail; b=Z2tPyEej4FNZbGt984FZjgMOrMU+qAUoCgd1p4Y+02PbbUK7TWgeveslnY6skAOyjTjLPFBvT+tbSAwF+aOFmJc7yEvIGQXgxcI7A+bgU0p+3ddx4wA0NvgOINFF0xYCjjHiFqnhX3FU2J4MPVW8eDXrZX5w42Z+fZr9pZKDw7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709214251; c=relaxed/simple;
	bh=qRDoNeKqbcYTOKhKuwxTa1mZVwmMUIuA4H5Jz2BDAnw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WAos8QH70BBqlPBWV++/W3lJXPz3ECn5WtTzfg8fJh81JYlXX1uxQBr9ipBDt9gqIJe1RD5bB8sgLJSjZxXWk6sbl5+gFPRohO7Syk8j9PeQu6LqpaX/PY/q9yqiClliY45YtZeiWnjsx1l3KxGHvU+mAinLeo6OP4CVYiFFq1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SKddM8fm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Xfx4Q87R; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41T9TwMb013376;
	Thu, 29 Feb 2024 13:44:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=H+teY3XgExtXvz7RRQMJP8VCSRx33NffbBt/KhT48nw=;
 b=SKddM8fmvRGN0ZnRRGGD/cBf+lMCeqxEaDcC5Gpi92wBsUjf/Ag5GjNrGt3Q5dhLhfzE
 Syb3azVnTyT2Rz6zmXB2z/r1yJvF+daBQOPQS9AeDdpw/xfyD865POoY0Zy6Nuf4hlFr
 NaM5XojTA7N8LPY/V8KHqL87YaahT2jit0eGXpwVZORmhVKPyL8gO+NyztMuwiU3Pu35
 g6o83cdUXU6j6HH5+rV1ewnxP1LJW4MgL8MjkG05wlOcpAQm8gua65MWawujwg+NCTYH
 YCz21aOVnpPnRX1gr+63BZMIIqnnKFoy1c0dkRugNBeSNnexhsOPsdC3Bs08kdV4IW3E 9Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf8gdnvxp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Feb 2024 13:44:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41TCmdFI009594;
	Thu, 29 Feb 2024 13:43:59 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wjrqk63ht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Feb 2024 13:43:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cT++O8wj8gAxkW06bktjgMnx01cdaT6TsrELiJEJGB22AOTRho5ST9oCIZ9MyMQRuRrVdespj+aauXHZ7kyax/rMhKfpP94NGYo0+SnkJ8FwMZlAQO5b8zA6UTQqp2Oa+9iQJxl5nK4p/QjGEB/mUUvXK1nzbx/jv7Ef55N06JEkaymVUWQfXUgDuwPJoqd9ZYuJ4pgP+ZxQiMyVZfxpJvqfU+HfOtbx0N9jiCr66y9fMV5pkgIrZ9/rPsRNP2Ybb9sL+4c2Q8HrBEQ/FzzZEta34jwhLMFjMSHkOk6wSDeOgtGrP1H0AjVutgTzEgVgM3/1Li31IiVvYqj5esTAGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H+teY3XgExtXvz7RRQMJP8VCSRx33NffbBt/KhT48nw=;
 b=isBhnbDRdALAuAdlFLvQnTTU7hZYjkNCZNmT2w9gI18i/XBJW6tavK5EzrK/fnSQi6VNSA6x7/XvhJcYuBjSOXS2VawLGs/dAXqU47pfcNEQvgwMbz2Cz9isxKoVg7szLW6pmo5/pPqGhkZr/Ej77lBqpxWecxukSSR/tZHykuzSeNTBMcokRwuGmcjK7a0auzB/bBHzfAzW7adBij000SKhIwWhzAsuFoDefLtAhbBxJ7z9mWWqbD+aGWuSLOu1YF01BzKpQuqMWYZItI1Hxn1LDCjBD6dApTnZMgNL042je8mD5i3r1aGCYYnf+M9KudleoGDec6ZGV+6fqQ8+1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+teY3XgExtXvz7RRQMJP8VCSRx33NffbBt/KhT48nw=;
 b=Xfx4Q87RXtehykV1/s1Uqto6ShU3gwZAP2whrXO0L/kBpIE16/H2MU+XiIHUBhAbshxy3ePsoe48RGmJ/2y+UcVMzzIFnU8FqNcpC/aQ4MxVyQcGcKpTYL60Wb5tsEUTNuUHlmcrse9IE0o00H8i5+PBbdwHouZd+xYhP/V/19A=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CH0PR10MB4921.namprd10.prod.outlook.com (2603:10b6:610:c2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 13:43:57 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f%6]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 13:43:57 +0000
Message-ID: <c0d80c37-ff1c-9c94-e1ac-78d26ee4da15@oracle.com>
Date: Thu, 29 Feb 2024 05:43:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 02/16] KVM: x86: Remove separate "bit" defines for page
 fault error code masks
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Michael Roth <michael.roth@amd.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>,
        David Matlack <dmatlack@google.com>
References: <20240228024147.41573-1-seanjc@google.com>
 <20240228024147.41573-3-seanjc@google.com>
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240228024147.41573-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0139.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::24) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CH0PR10MB4921:EE_
X-MS-Office365-Filtering-Correlation-Id: ae1f83ca-f746-4b00-cff5-08dc392c7a13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	zOjOWAJMGwCrNJGp2AvdMDoGb1axTQfhjQpjvHYy+dULmiH1PEVV8nr11x9NKZ8mOJU9ac8xwiCLJ83SovQ8Zoy6o5G81TazZH5ZEZQMAsSJEUbGrlVg9JHF/jvnE2fBWbgVts5zwG1xEiWM4zoKoixi8C7pmbVG4r9uj+qY08RUCneOsFBOR6HF//gmQusHsPwIDvp+/gGCZciQ6LK1Ixiqbo2kt3iHzCFSblLCZkkfCFmu5IyIfxSKZXxgK8EdkECVdLc+F59dtVgoVo2b1a9lKZpR7r6d4Og2RGm+tf6SpGtN08K5bDCknnQW61o0yafMyu9yLDIUQ2HmQCWOWYYM0novTeqbnR+UJoU67wIIo5f8GbAnFvQESlKGUnGrU996S5ScFymMJCltVQPpOyQWriSWFZ81FZs4SxdrD2foXW+Ci4zgF3iavyzZ1+x4IDwu8udciX2npUaryKDxPYuHv5uO/3IEQIjMZJOlC67dZG2TJFnqdJaCz0bzIrWY2M79nruc71/jf2ZOaBbLoizKn9/cS6o+eVN8m6dD9HTBgn9/0N0KWoV/9qpxknkYAulymVwIyj7O+2X6T4K3t6xjv05y8P+wNY1Sx5yM/3hsd7xw8qxQFVVdPQ7Fo+Wf
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SmFxcWdzTmx1WWZNT1V5V2VtTWlCQWJYWElYZ1BDZTh0dXJlSUlsTWtTTitT?=
 =?utf-8?B?bWVUZ2h5TTkvSDlyUVVrS3cweGxZL0xZZHV0OXIxV2N4SzhiS2pHQVMyQUxo?=
 =?utf-8?B?OUZiZ0NkUHdDVlUwM1BUREJMcjV2SHFDcDJod0sxOVYvOHVpVzJXaTRYQlBZ?=
 =?utf-8?B?ZitYbklBa0FGREt5dmpjaXRzZS9ieHpaSEFHallxdWJqcGlndmpIUVhZc3JV?=
 =?utf-8?B?cXlKNmxLMkFOVjZpdVArd2hvVFV4UEZVRW9pcjdJNlRPZU1XQjBvbGM1VUJ3?=
 =?utf-8?B?YmYySGJmaE8vbzhKV2NkWVdDZGFyTDhWR3BSM05NcFVkTHdhZkV6cVNwcDkv?=
 =?utf-8?B?VzFacHU2aTBpY2NwQjZZVVZxR1N6ZlF5VDhHdWdtazRmaE5rRGVEZzhHanlm?=
 =?utf-8?B?ZnZWUFJzWmxiLzVaQ3U4MEZhVitZMkQvZjYvUkg3TW10a3IyTDBVTkNUN2R4?=
 =?utf-8?B?M3dGWE5PNWN3U3d2RDduS3FSWHp0S0xuOW45MktGeUJBYUlHN1VLdlFVWUtQ?=
 =?utf-8?B?MDdJM1o4V2Y4dlp1dXZQU1JGYmU2bjJwM255R08wOTBNeTBEdDF4ckJuSkZ2?=
 =?utf-8?B?Wkt2N1ZxcGxscHhqZHVHb0JnWVRBZXRGT2k1RHZPZFE1anYwL2NuM1kxd1Js?=
 =?utf-8?B?U0JTeTNvc1hIZ1JodU8xVXByWlBTUlhROWVZRlN5TjNhSkZOTVh1ZnBWOVc4?=
 =?utf-8?B?U2o3Q1lsTzNNT1UxSGFNOVJKd1lLV3NtdDEvVmtGUHhqbGRZblpYTldiZ0Jp?=
 =?utf-8?B?OGs4elNmU1h0a24remtaTkxSdDk3VjVWOEpqS0U0THFSRGVZaGxVSlI2Qkwy?=
 =?utf-8?B?VDlzbHNYT0RPMTRBcjJMaGVjSmw0TWd0YlVIaFh2b21JM21QL3k5R2xIU2hN?=
 =?utf-8?B?RWJpdk1FUThPZHltUGpqSjZvT2V2M3lvYStvUWxIYmNXNjlnSy9ieVV3anpB?=
 =?utf-8?B?Z1ZqcnNuMm9RL21FcVNObUlQQi85L0xHNXpQSTdnZDU1M0JacXI3K1F1REgy?=
 =?utf-8?B?NUVoV0dmNmwycmFaRDQreWQxeFpTelBpaXhtd0xKS295T2gwYXVrNGg0S29E?=
 =?utf-8?B?QTZLeWdNNEhxNVNuRkVHdDB3YlJjUGxrRTZyRVE1b0JNVVhKOXZRQWhwT1lX?=
 =?utf-8?B?dEhRbzVORHNjcUZrYzcxOHhqTlhLZ1dYd3RGM3ZlQ05hQkJ3QzJOUlkrdVd6?=
 =?utf-8?B?bXo4NlpKZGFvaDF4SjJ4M1R0Z0NWRGY2RkZDd2FlMks1a2ZzYSttS2JESTRY?=
 =?utf-8?B?ZmJ1YnJMZk9nZjRjbUQvQXUxeVF3TW5WWnFDYk80Q3lISTg1Z01ZUmVTS1RL?=
 =?utf-8?B?VU53cjhRY2VMQlNzSWFvVnVvTW9rTWtWV3hta2FudW10NFlkKzJybUo3czFU?=
 =?utf-8?B?ZFNaWE5XaS9xZEl3Y0V4OGppRXNKMGFBKzl6SGJteHVsVGVCY093dDNDRk5z?=
 =?utf-8?B?TzRMbHhic3FRb2E1QWM3dTZ6SHJwb2lvWWZhRTVmeTdlakRvbEtodjRkM2Ev?=
 =?utf-8?B?Wm85M3N1SkNKVm9aV2lHcTIrWUcydWw0dkRjQjgybDRPYW5wZWZXV2tiWlFh?=
 =?utf-8?B?SXBOajlCRXBIQzYzMUJoOEFDRWplQ2ljeWZMSDhBNW5TS0l5RUNPRU1BZWxj?=
 =?utf-8?B?REN1bFRKNXVBUENwTEttRjZxTFNsekJEVFZDNWRKNmI3aDJTMVlPbGNCN0Ja?=
 =?utf-8?B?TFNVbVl1QUlIOEpwY0V3dE9CUFFaeVF6VzdrcFlRb2xQOEtOU1IvZVZMM1NC?=
 =?utf-8?B?UDRpc3J0ckh2eXpxTmJMOERwcDEyY0ZUdjFrenNzV2dtMXp2TWFicjFvNHY4?=
 =?utf-8?B?ZE9IcURLZVNXMEhaK3Zkb1p3VmRtTytBUkUzdUlWRUltTHk0bHVIMnFHOFA5?=
 =?utf-8?B?aEhwWndZNkVsZDFNMFNTSytBVXIzZzJvSTNxbXFmZ1ZhSnVnYU1KSDREb3hL?=
 =?utf-8?B?ZTZvMU9US2pBK25kNGlhalZIZmVhRFpKSC9Qb3doekgvWE5xeXNXVmlGNDBh?=
 =?utf-8?B?dHREZFo1MmZuQ1ZCbFkwZjNGTnFyT1dPd2g2ZGZJaFRhZHY4c0JFZU92SlBm?=
 =?utf-8?B?UnlVRlN3eTNkYk5nMDRkQk5maDVFeFF5TzRPczhrMitHQVNRRG5YQ3dZWXFQ?=
 =?utf-8?B?MnFCMGovbGZXenowYlhDUnArTGNCSUxmRS9MSlFEUlVtS25UWER4SlJHTGVS?=
 =?utf-8?B?TkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	MfMyGHsx0zXE51fFqTxibgDDE+YLJPwEOkbnbiVy8SJKynJZYoyOiRWlRW36CjVypt+IZdULRm8ZFOihd35HlVk9buTxb4S4m/EU7mNEUYQePkw1aroxNZm2+QGVNR4DRU2MvpgUw9vMIi4UYIMKOsux4xAZyXt+wddJEj9eILqMcGPFXLBvFjj0cNv9u8nL5qh7Je4IpJks2nVv4ZXISQJ/lcC9UbfMbGkKZsJvXRC98UimiQtsLP4ddR0TI4+Mv1y+OS1M4vbTDtrfvzYd1j4Rbt3Rd9PZS09SlenB3JKrdx2rmzz4vAu/3zULzVQ/Z48UesQVydF3vPGcJfvYCyBLy4pa4R9FP3syXQxAatudhzUt4jL8gjj6RbnD7H2IuIGUgJ/DvCSF/wcC53ayPKE5yv7oHPqXIjooLZhKvkQosCpv6WXfT5S1WdA4SNkzBjKPhKN6s0xSZDG/uJA4m+jW16IRDjNDSioNV4tL0z2AuWShNSdCVPC9WrbDYRAW5y19R5qwHpMykNpkQ1LDHoWX0YqvaVTEA0orESMm4PlEy5VXRIhMSMb1Rx/vv+gitSbMHr1eD81NcwNNECwjFH2joe0hWiohVIEmougR3iA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae1f83ca-f746-4b00-cff5-08dc392c7a13
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 13:43:57.0232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8kX1beN7byWwwzsGnVCxE4AV9YCuSk/UmYD0p9+RWihHsYrnYDNJ3BLWn+3Udf2hqc59AiyMUVYfdPvLF4FlDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4921
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-29_02,2024-02-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 spamscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402290106
X-Proofpoint-ORIG-GUID: g1Kxm_gMzc-8jV5TNxJpMXF7mUwXoSSW
X-Proofpoint-GUID: g1Kxm_gMzc-8jV5TNxJpMXF7mUwXoSSW

I remember I read somewhere suggesting not to change the headers in selftest.

Just double-check if there is requirement to edit
tools/testing/selftests/kvm/include/x86_64/processor.h.

Dongli Zhang

On 2/27/24 18:41, Sean Christopherson wrote:
> Open code the bit number directly in the PFERR_* masks and drop the
> intermediate PFERR_*_BIT defines, as having to bounce through two macros
> just to see which flag corresponds to which bit is quite annoying, as is
> having to define two macros just to add recognition of a new flag.
> 
> Use ilog2() to derive the bit in permission_fault(), the one function that
> actually needs the bit number (it does clever shifting to manipulate flags
> in order to avoid conditional branches).
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 32 ++++++++++----------------------
>  arch/x86/kvm/mmu.h              |  4 ++--
>  2 files changed, 12 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index aaf5a25ea7ed..88cc523bafa8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -254,28 +254,16 @@ enum x86_intercept_stage;
>  	KVM_GUESTDBG_INJECT_DB | \
>  	KVM_GUESTDBG_BLOCKIRQ)
>  
> -
> -#define PFERR_PRESENT_BIT 0
> -#define PFERR_WRITE_BIT 1
> -#define PFERR_USER_BIT 2
> -#define PFERR_RSVD_BIT 3
> -#define PFERR_FETCH_BIT 4
> -#define PFERR_PK_BIT 5
> -#define PFERR_SGX_BIT 15
> -#define PFERR_GUEST_FINAL_BIT 32
> -#define PFERR_GUEST_PAGE_BIT 33
> -#define PFERR_IMPLICIT_ACCESS_BIT 48
> -
> -#define PFERR_PRESENT_MASK	BIT(PFERR_PRESENT_BIT)
> -#define PFERR_WRITE_MASK	BIT(PFERR_WRITE_BIT)
> -#define PFERR_USER_MASK		BIT(PFERR_USER_BIT)
> -#define PFERR_RSVD_MASK		BIT(PFERR_RSVD_BIT)
> -#define PFERR_FETCH_MASK	BIT(PFERR_FETCH_BIT)
> -#define PFERR_PK_MASK		BIT(PFERR_PK_BIT)
> -#define PFERR_SGX_MASK		BIT(PFERR_SGX_BIT)
> -#define PFERR_GUEST_FINAL_MASK	BIT_ULL(PFERR_GUEST_FINAL_BIT)
> -#define PFERR_GUEST_PAGE_MASK	BIT_ULL(PFERR_GUEST_PAGE_BIT)
> -#define PFERR_IMPLICIT_ACCESS	BIT_ULL(PFERR_IMPLICIT_ACCESS_BIT)
> +#define PFERR_PRESENT_MASK	BIT(0)
> +#define PFERR_WRITE_MASK	BIT(1)
> +#define PFERR_USER_MASK		BIT(2)
> +#define PFERR_RSVD_MASK		BIT(3)
> +#define PFERR_FETCH_MASK	BIT(4)
> +#define PFERR_PK_MASK		BIT(5)
> +#define PFERR_SGX_MASK		BIT(15)
> +#define PFERR_GUEST_FINAL_MASK	BIT_ULL(32)
> +#define PFERR_GUEST_PAGE_MASK	BIT_ULL(33)
> +#define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
>  
>  #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
>  				 PFERR_WRITE_MASK |		\
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 60f21bb4c27b..e8b620a85627 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -213,7 +213,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  	 */
>  	u64 implicit_access = access & PFERR_IMPLICIT_ACCESS;
>  	bool not_smap = ((rflags & X86_EFLAGS_AC) | implicit_access) == X86_EFLAGS_AC;
> -	int index = (pfec + (not_smap << PFERR_RSVD_BIT)) >> 1;
> +	int index = (pfec + (not_smap << ilog2(PFERR_RSVD_MASK))) >> 1;
>  	u32 errcode = PFERR_PRESENT_MASK;
>  	bool fault;
>  
> @@ -235,7 +235,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  
>  		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
>  		offset = (pfec & ~1) +
> -			((pte_access & PT_USER_MASK) << (PFERR_RSVD_BIT - PT_USER_SHIFT));
> +			((pte_access & PT_USER_MASK) << (ilog2(PFERR_RSVD_MASK) - PT_USER_SHIFT));
>  
>  		pkru_bits &= mmu->pkru_mask >> offset;
>  		errcode |= -pkru_bits & PFERR_PK_MASK;

