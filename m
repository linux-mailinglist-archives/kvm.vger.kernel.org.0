Return-Path: <kvm+bounces-51186-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21274AEF7FE
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 14:12:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 413E41650D8
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 12:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22CA52737E2;
	Tue,  1 Jul 2025 12:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fltwKMGu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="had45JJg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44C81E1DF2
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 12:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751371972; cv=fail; b=lx14qlkrW16OIDYicL7Wt6259HtmWXnoMpYt1AF/+sDy3PYg061qlJIeptpDn5z1JjMixDOx6NdbOEe+SNw0ZcVVnKJAQ/VkQBARIAgKQY7Da3I7Qg/5pY41hC8dynJ1NiwMkY+P/G83u0d8zXE8ghAVMJ8ovqM6OeeCc5RoT5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751371972; c=relaxed/simple;
	bh=zs0Vp3UjjF/3f8b31WVEzMguAC4XikzxflU/VfbYEQM=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uazxopZYYxojX3OY1Apfoed9fdXgpWBMJ+tXzpPoCs1QKNdF+m4z81hiBiIRMrxUdMBoGLCyyJuerykh5DEvwSRBd1ics+w4qYBI97wFxuQJtlubt/rhliCAj8UIlKH1ZO0nipfpJC+TS2FVcPcaOKifJLq5hedu1V26u6E7Vi8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fltwKMGu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=had45JJg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 561C6vjh007917;
	Tue, 1 Jul 2025 12:12:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=y0ZlpATbNqheTB0RNY23ndUXY/bLW3RARt1V6s7gP+Y=; b=
	fltwKMGuT/3GGvSynn1LdSOWPL4Linto6f+RBshjcy3c+ulmVnG3BJ5LORZowWjz
	fa3mztLv23JG6cFKEJZeNlylxrAxEoinHkdZHs7O2I3km5d8hukCw3G86NLjK689
	nFQ4ADjnUjfbvu2FJyfIDx0pcHvjaFeyOWklFZOxGUj34Bej4FuwdLvkwzVcUO2W
	NzNuvlEQcsAcJwElxwRF80344VJWRiAYhzlR6Pi0t3asWb7g8lerxvxfgKwRTJK1
	o3rARe4P0T+9NJMmOagukCk3miFLJena93ruCgQ9ReXvTxq79mH5udG/mwZDbeZk
	o2t9HzAvwS8C+mxe0yZj9g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j8xx4kdd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 12:12:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 561AncXA008952;
	Tue, 1 Jul 2025 12:12:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47j6u9pweg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 12:12:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jjfyR3ivtfyMRQlELH4W4UR2r6F4xMyxk+4sG/T4N6I/Jz29gyb9++fezqCeDd/UWPmZhRN/iwe4BLICGxTDIMLb92GiqEczw/BjHb6X3l6RlRdWwGpb4A5NstuQ8GtR8oAxKzdEyfzfY64wvC3nBEYG+5AMbXJK+hDMlSs42v0ENUtuby/KfvgQCnbuNXRmsuwowKVzl+gRFcxtbY+JX6NnViBwOxgceMewHeJbLvzb3O1XN7tleWKIYVen0UhZ72ndD9SMN6iqhtHD3P9WXSTJg3Uc4M8eCIDJ8X3QV3fwcRHAn5YYySPHkiQ0wcCjPipJP7DZfegkSI5Ppe665g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y0ZlpATbNqheTB0RNY23ndUXY/bLW3RARt1V6s7gP+Y=;
 b=Q1uWQ+2l7a9lxiuo8H8dfap1L8URlouGjonM7PtdXcn84RCfLJJ2m8oZMdL8QS0ayXRR3QmHDXgILgnTzrVEWTPT3bJoZLzLYyUOCb4rIJKN/WXAPseO0ZS1hwmX7pA6MZwTYTAgEzKfGTBVOZ6l7RgnmMju4W5+9OFBRFx+LRayTJQqPYYJQ1XB5/vxxrb4sPFtco3A3V6I8Zh6cv8AfA96eerBiHkLsZ7DQUEegV4SSZKM3/CwiN7XRKyarkAa30m/3uWQi1UVD0+ePMw7R50jKx+XK8VD7WHu9w+OK3Cww7fr8NuoHli/AuCclU9iw4ImAe2e/UZCTfBF4KMPFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y0ZlpATbNqheTB0RNY23ndUXY/bLW3RARt1V6s7gP+Y=;
 b=had45JJgo0LU848UBzunZRtI61tf7/FK834KGi9EnDeCVAXEOlHBPnSw5zDQECJuH2LWkD3V9y1MIk4JSP3vEFJFceqc1Y73iV3h1tRFDwU6IBmGlc24oOvhQJE4Wq+2Epp9UPzqw/htO9XcffAQpDxAlXWQrlxfcbsx6QcFPP4=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by BLAPR10MB4932.namprd10.prod.outlook.com (2603:10b6:208:325::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.27; Tue, 1 Jul
 2025 12:12:35 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084%7]) with mapi id 15.20.8880.027; Tue, 1 Jul 2025
 12:12:35 +0000
Message-ID: <1ecfac9a-29c0-4612-b4d2-fd6f0e70de9d@oracle.com>
Date: Tue, 1 Jul 2025 14:12:31 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, qemu-devel@nongnu.org, pbonzini@redhat.com,
        qemu-stable@nongnu.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
To: Xiaoyao Li <xiaoyao.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com> <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
Content-Language: en-US
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 xsFNBGJDNGkBEACg7Xx1laJ1nI9Bp1l9KXjFNDAMy5gydTMpdiqPpPojJrit6FMbr6MziEMm
 T8U11oOmHlEqI24jtGLSzd74j+Y2qqREZb3GiaTlC1SiV9UfaO+Utrj6ik/DimGCPpPDjZUl
 X1cpveO2dtzoskTLS9Fg/40qlL2DMt1jNjDRLG3l6YK+6PA+T+1UttJoiuqUsWg3b3ckTGII
 y6yhhj2HvVaMPkjuadUTWPzS9q/YdVVtLnBdOk3ulnzSaUVQ2yo+OHaEOUFehuKb0VsP2z9c
 lnxSw1Gi1TOwATtoZLgyJs3cIk26WGegKcVdiMr0xUa615+OlEEKYacRk8RdVth8qK4ZOOTm
 PWAAFsNshPk9nDHJ3Ls0krdWllrGFZkV6ww6PVcUXW/APDsC4FiaT16LU8kz4Z1/pSgSsyxw
 bKlrCoyxtOfr/PFjmXhwGPGktzOq04p6GadljXLuq4KBzRqAynH0yd0kQMuPvQHie1yWVD0G
 /zS9z2tkARkR/UkO+HxfgA+HJapbYwhCmhtRdxMDFgk8rZNkaFZCj8eWRhCV8Bq7IW+1Mxrq
 a2q/tunQETek+lurM3/M6lljQs49V2cw7/yEYjbWfTMURBHXbUwJ/VkFoPT6Wr3DFiKUJ4Rq
 /y8sjkLSWKUcWcCAq5MGbMl+sqnlh5/XhLxsA44drqOZhfjFRQARAQABzTlBbGV4YW5kcmUg
 Q2hhcnRyZSAoT3JhY2xlKSA8YWxleGFuZHJlLmNoYXJ0cmVAb3JhY2xlLmNvbT7CwY4EEwEI
 ADgWIQRTYuq298qnHgO0VpNDF01Tug5U2AUCYkM0aQIbAwULCQgHAgYVCgkICwIEFgIDAQIe
 AQIXgAAKCRBDF01Tug5U2M0QD/9eqXBnu9oFqa5FpHC1ZwePN/1tfXzdW3L89cyS9jot79/j
 nwPK9slfRfhm93i0GR46iriSYJWEhCtMKi9ptFdVuDLCM3p4lRAeuaGT2H++lrayZCObmZxN
 UlVhZAK/rYic25fQYjxJD9T1E0pCqlVGDXr2yutaJJxml5/jL58LUlDcGfIeNpfNmrwOmtUi
 7Gkk+/NXU/yCY17vQgXXtfOATgusyjTFqHvdKgvYsJWfWZnDIkJslsGXjnC8PCqiLayCPHs+
 v+8RX5oawRuacXAcOM66MM3424SGK5shY4D0vgwTL8m0au5MVbkbkbg/aKDYLN33RNUdnTiz
 0eqIGxupzAIG9Tk46UnZ/4uDjdjmqJt1ol+1FvBlJCg+1iGGJ7cX5sWgx85BC63SpKBukaNu
 3BpQNPEJ4Kf+DIBvfq6Vf+GZcLT2YExXqDksh08eAIterYaVgO7vxq6eLOJjaQWZvZmR94br
 HIPjnpVT9whG1XHWNp2Cirh9PRKKYCn+otkuGiulXgRizRRq2z9WVVQddvCDBDpcBoSlj5n5
 97UG0bpLQ65yaNt5o30mqj4IgNWH4TO0VJlmNDFEW0EqCBqL1vZ2l97JktJosVQYCiW20/Iv
 GiRcr8RAIK8Yvs+pBjL6cL/l9dCpwfIphRI8KLhP8HsgaY2yIgLnGWFpseI3h87BTQRiQzRp
 ARAAxUJ7UpDLoKIVG0bF4BngeODzgcL4bsiuZO+TnZzDPna3/QV629cWcjVVjwOubh2xJZN2
 JfudWi2gz5rAVVxEW7iiQc3uvxRM9v+t3XmpfaUQSkFb7scSxn4eYB8mM0q0Vqbfek5h1VLx
 svbqutZV8ogeKfWJZgtbv8kjNMQ9rLhyZzFNioSrU3x9R8miZJXU6ZEqXzXPnYXMRuK0ISE9
 R7KMbgm4om+VL0DgGSxJDbPkG9pJJBe2CoKT/kIpb68yduc+J+SRQqDmBmk4CWzP2p7iVtNr
 xXin503e1IWjGS7iC/JpkVZew+3Wb5ktK1/SY0zwWhKS4Qge3S0iDBj5RPkpRu8u0fZsoATt
 DLRCTIRcOuUBmruwyR9FZnVXw68N3qJZsRqhp/q//enB1zHBsU1WQdyaavMKx6fi1DrF9KDp
 1qbOqYk2n1f8XLfnizuzY8YvWjcxnIH5NHYawjPAbA5l/8ZCYzX4yUvoBakYLWdmYsZyHKV7
 Y1cjJTMY2a/w1Y+twKbnArxxzNPY0rrwZPIOgej31IBo3JyA7fih1ZTuL7jdgFIGFxK3/mpn
 qwfZxrM76giRAoV+ueD/ioB5/HgqO1D09182sqTqKDnrkZlZK1knw2d/vMHSmUjbHXGykhN+
 j5XeOZ9IeBkA9A4Zw9H27QSoQK72Lw6mkGMEa4cAEQEAAcLBdgQYAQgAIBYhBFNi6rb3yqce
 A7RWk0MXTVO6DlTYBQJiQzRpAhsMAAoJEEMXTVO6DlTYaS0P/REYu5sVuY8+YmrS9PlLsLgQ
 U7hEnMt0MdeHhWYbqI5c2zhxgP0ZoJ7UkBjpK/zMAwpm+IonXM1W0xuD8ykiIZuV7OzEJeEm
 BXPc1hHV5+9DTIhYRt8KaOU6c4r0oIHkGbedkn9WSo631YluxEXPXdPp7olId5BOPwqkrz4r
 3vexwIAIVBpUNGb5DTvOYz1Tt42f7pmhCx2PPUBdKVLivwSdFGsxEtO5BaerDlitkKTpVlaK
 jnJ7uOvoYwVDYjKbrmNDYSckduJCBYBZzMvRW346i4b1sDMIAoZ0prKs2Sol7DyXGUoztGeO
 +64JguNXc9uBp3gkNfk1sfQpwKqUVLFt5r9mimNuj1L3Sw9DIRpEuEhXz3U3JkHvRHN5aM+J
 ATLmm4lbF0kt2kd5FxvXPBskO2Ged3YY/PBT6LhhNettIRQLJkq5eHfQy0I1xtdlv2X+Yq8N
 9AWQ+rKrpeBaTypUnxZAgJ8memFoZd4i4pkXa0F2Q808bL7YrZa++cOg2+oEJhhHeZEctbPV
 rVx8JtRRUqZyoBcpZqpS+75ORI9N5OcbodxXr8AEdSXIpAdGwLamXR02HCuhqWAxk+tCv209
 ivTJtkxPvmmMNb1kilwYVd2j6pIdYIx8tvH0GPNwbno97BwpxTNkkVPoPEgeCHskYvjasM1e
 swLliy6PdpST
In-Reply-To: <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0P190CA0026.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::36) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|BLAPR10MB4932:EE_
X-MS-Office365-Filtering-Correlation-Id: 42ecd4ff-4300-410d-d4e9-08ddb8989077
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S0YxRFg0a1hYSW1XTE5ic1Z1MHhtYUxVazZ2d2wzRDhUdGtGbGhheW0vMU9l?=
 =?utf-8?B?clptUDFXbzM4dWNsZGIvNHRIWHArOEJoZXUwYzBhaXJqdGwxZlRERlA5bXRH?=
 =?utf-8?B?ejJLWmFXWm9uczdXTTZmVDIvR29Zb3NseXRaUVBCcHVld0Q5K0N2czQwODg1?=
 =?utf-8?B?aVpiMFhvWUpvUCtKMDNrdlBtZyt5U0tUUDNhNFpUd0pJcG5NNWxyb25oMWdZ?=
 =?utf-8?B?MFo4aXVOc1pRY05WY1NzRUxmUzFmbnVNQXdoVzRKR1FZWXZWMlR5amI1SzVS?=
 =?utf-8?B?ZVJJTUg2WjRLT1lRbStmQ2RlTFZENTZ1QlJXUWs0VXdqODF2ZU1pa3VWd2d0?=
 =?utf-8?B?eEQzdDNIRmpEQmRzRFBaR2NhbVh1UGE3cDFFZ1ovYVkvbWJRLzBoS3pRZTQw?=
 =?utf-8?B?ZWozU3RLaXI1L2xTVG5JL3NiOUc4dDB2NHFZK0dYR0xhK3lqWXkwVWw5OEY2?=
 =?utf-8?B?ZjdCK0RMSjV3bE5BOVEzSzBJUVZEbTg4czJHUGZFdThXRmd6WlJTODNCZUps?=
 =?utf-8?B?UXJzWVd0dUU1eWRHeFVJRDRBM3JwSXFYU2dXcWlOSklwQjJidmZGRFh1M1Yv?=
 =?utf-8?B?Y3dWMUtKM2phMVF4R09qNUE4Vm1KL0d4MlkvWE0yWDQzSE1BUjVCOVgrSmRr?=
 =?utf-8?B?b045eG15SkcrblRXbHEzNnhKQWJIRFE3ZXp0K1V3cmMzR3J6bExjalBXelpN?=
 =?utf-8?B?dkVqblBia214VlZpUmtoaS8veWdmQXJsL0RRQWkveFhEYjZYSHBudk9DSzZw?=
 =?utf-8?B?c09aN21ZSWNNanpvc3FMdGtrVldxYWtrdWhPajlseUY3dksrMmZIa2VNdDdj?=
 =?utf-8?B?Mk1WZjJXaER3dWZZS2oxMGozNTJkWlN0anNQakJXcDJINDlTZFd6RVBQdi9k?=
 =?utf-8?B?RWM0b29SWGRrVytCQzFtYlJYeHVxb3BkNGRONXc0Uzd2TGIwSlB5S0c4QUxZ?=
 =?utf-8?B?Z3VkbmlzNC9zekxSSzkwSG5pVG1vZS9aeGdaOWhub3h3QWdKQ0U1YVZkVm9t?=
 =?utf-8?B?Z1ZodU4zNG0vVTRYTkJud0pqQ0FHUXI1eTJ0N1dkaWxmM2dYeTkxbWV0K1ZN?=
 =?utf-8?B?MzlxOE0rV2h0cUkrR1pPVE9DMGQzWDhFQU9jVWJLdFRCdlZzOEZjbUFHK05V?=
 =?utf-8?B?aUVwbTVQV3RpOHpreFdvZ05WbXhCbVV1ZW9qTEswR0JlRE9sMnlRbWhTYm1K?=
 =?utf-8?B?SXVNdTJRQ2ZPNFNJdUZ0RkVnaFMzTjhZWG4zNjc5dzlMNWlFc2RVVStiYkF3?=
 =?utf-8?B?K1NRYjBlV1p1NmV0WWd1VERnZFBnb0Q3cmYwUU8xWXpDZ1BWSkU0WmplL1FX?=
 =?utf-8?B?NFNVbzRxNGdhdm5pWC84d3BGdHNBSUFzNWI5c2xGQ1F1eFlqbWhaY2hMbi9w?=
 =?utf-8?B?WkZ3UlZURVc4ZlJZdTdtVkV2ZUJCQ05xNWo2dmQyU1NZQ2Z4R1pCTDFUT1BU?=
 =?utf-8?B?OWhqR1pEWFYrMDVTcnpIMVJzN085aGxHcW9iOTR5Z2xRU2VPOVpkcGYvczBD?=
 =?utf-8?B?OVBGb3VsWkQxamJVSCtjNmFLZ3U4eFZCcE8vVWExU0EzeU0rREFsVC9TeUdV?=
 =?utf-8?B?MVNtVnRwOWtYMWttQll4WEloR2sxZUdkUUFCbWV3TzlrbUFXTVUxb2NqUHV5?=
 =?utf-8?B?V1V3dWFKV3N5WnhTSy9YUWJheE1SREt1ME9Vd2VNbzBGY0ZFeUVZZXR0Ulph?=
 =?utf-8?B?VVlYVUZJRk52UFlvNUExUVprZ1VhUjM3WWgzMkMzbmMvZWtXR1BZZWpQTUhi?=
 =?utf-8?B?TEFDU1FJNU1pMGpjcnQ4QmJrVUVraGZOY2hWSVErZ2JKR3ZsUzgxbFFXWjNv?=
 =?utf-8?B?V2xhMmNQR3UvSjhOMGM4KzM3SCt1WWY5MlFjQnU2eEVUbmMyZElyOUFwcUIz?=
 =?utf-8?B?M1hZck5kUFh0OXRtQnZzZjNQRWt0eDZPeHRlQ3BxYURzSkN0eGF5VnpoRmwz?=
 =?utf-8?Q?0i5E41rYTww=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YU1jZUpsMzRZcC9ldnk3dml3VGpaTDVrWGwwVVNOaEpOUzNQVzgxcHF1cXBM?=
 =?utf-8?B?R2Q0aHkrdWI3ZEk3RjQ2Mis2Y2xqU0l3MzZ6WERnNER4czZ6Z29oUEUwMFpJ?=
 =?utf-8?B?cVpma21SWk1xN2x5MEFMNlZaVE5xWVpSL3Q3NWNQMHZuSU5tcjRFVzQzQW1q?=
 =?utf-8?B?cnJyVmUxNU5LcnhaWHUzSUdiQjVGZUxDbkd6eGhSTEJkZWR2WEd5OFJQckxK?=
 =?utf-8?B?MThISHhPTVlnOSs4dnIyQ0pLSnJjWWQyRjBXUktGSXlRU2xVTCs3K3ZjMkN3?=
 =?utf-8?B?d1IzSmRvTVMwM2dnNGt1Mnk0VWpyYVBReDNRZERwYUxKenk5eDdPbzVrQkM0?=
 =?utf-8?B?YkhWWlp5UDlvaHN0b3R3VkgrZ3E3QWF3RlNCUUVrNG04d1h0aks4UEdQMzVL?=
 =?utf-8?B?MjhDWG5mMlk0NFZsQnozdWtHWjlIRDk1MjdTbmxrK25GdGVwcjVQWThtaEh2?=
 =?utf-8?B?RU5GTWo1YlZPdmF0Qk1BN1Jyc2E4VmtkZEVlaC9Tb2gveC93emhZVGJOYzAr?=
 =?utf-8?B?eHYrREE2UDNubXlqVEVqak96REZxNzRWaFg3S1ZqcFdrbGtndWdVMGFmcXBi?=
 =?utf-8?B?NWE0VEphQmo3NzFIQlE1WVlVaThwdFY3V1NmOTNWVDNQbGs1TCs0N3cwTktq?=
 =?utf-8?B?RzdEcUMyaW5qckhScXllVW4wMUw1UDc4S2QrbnlsU1B4YWl3YVllY0t5dU1p?=
 =?utf-8?B?RS8yM0dBOWpXTm1uSDNTckNnbE41eG1sK3hZendPQnRWOW9ub1Q5TFJ1YXRu?=
 =?utf-8?B?YVBOYitPK0VUOUtpSlVHNHd0WE9GWDB2VVFNa3Y2WXphdUp2SVlEWk1DUEhV?=
 =?utf-8?B?bVZIeHVZWkZaZWMzOHZpcGd2eXQrL3FBMWczaWNyVlJ4UTR3amtpcUxaUmJS?=
 =?utf-8?B?WlI0a050azBIQk5zV2U0MnNsQ1JMcnEyMmdDYTkvUDRqN0d0bzU4YktkeEZS?=
 =?utf-8?B?TEhPQTFjcWJQMHpuZjVzYTQxdTRkY21UU1pnSEtSN1Z6THdadjdreHdXOStJ?=
 =?utf-8?B?ZFJ2aGcybVZBMXBNVkk0ZVZocDIyb0s3OWY3M25XMW1TdHJBS2JJZ3JQTm9D?=
 =?utf-8?B?d2twbVNGZmwvZjZiZWdjeWFFZzcrWEpEeWpHSmJVNWtDa3J1UGQxZlpUOHRO?=
 =?utf-8?B?ZVZuR0N4WC9JY2FIcUkrMHZiQks2VW1rQXBBeGJYbkR1aW90KzF1MnUzZGxI?=
 =?utf-8?B?eTd3OVpjcVVEZERZVisvQklsV2l1aEdTOWhWMFZwVGU1SjJpWURWT2NxZzVB?=
 =?utf-8?B?b3lMUStIdE5oRDFsQzBZNlU1WjNWVUIrKzRuV0tUd050NFFoV1p5cXY4bkJC?=
 =?utf-8?B?eUVSTmFIS3R6TjJSM1pJY3RxRnFaV0lvWm11VHczNDJjN1JRaXZWb2pydVBv?=
 =?utf-8?B?Yjc4KzY4LzhxNWN2Yk45a2RPTjBzSmNMVDBCeUY1QkJScS9ETHlCamQwY2Ur?=
 =?utf-8?B?RDB3S0t5bVJCMDgwZTBrbm8yYkxCVFUxeXNIUGRjRGh1OXpubG5wSTgxUTha?=
 =?utf-8?B?dDdncHJIejVQckl6SE1lS0Izc3JRN2hHYVZTY3MrOWNUWnhDY1FoV1Y4amV0?=
 =?utf-8?B?RjU1Z1dvVVhpUDl4UkZmNlJsbkRUY2VjZ0RlK2JCOWFVU2h0b1VLTFhCTjdH?=
 =?utf-8?B?VGNpa3pqcEZESkVGUnljR1ZhZGt2clVJVDNqajRhU3hBMDVJU0NhTWNXSVhJ?=
 =?utf-8?B?YUhma1hYd2gzT3FkTVdhU2ZHeFRtRlMrdEhndVFsaVh6aVoxQy8zSngrYWZl?=
 =?utf-8?B?NVJqVXJsYjZ5MXoyckU5Mk8xZEo2T0NYV3Z4dXB5QlZpaEtpTVVKZUxadUFK?=
 =?utf-8?B?YWZqUHhiTFd4MGQ1bWZGTkJvYzNZaXBNK1FaRzBqTm9CNUlGVWdRZHczVGJQ?=
 =?utf-8?B?YVFCdUN3U2xxSkdQT29hemV6Zm1lT3lYU2U5UGR5MFdWVkFURHFieWZFTUtD?=
 =?utf-8?B?Q1l4UTFoNVlIYWtHaXBWRUphQS91S1hnV1A3YWQ5a1huaHhxVFNCL3ZreXA0?=
 =?utf-8?B?U2dUZHVUZTVwSmw3allmU05CU2F0WGhDa0F0bkpGVHBsbHJLOWtlaUhOSlMz?=
 =?utf-8?B?UGJYaFB5WXFiOThHODFHaWNJVXNrbkRUVnhTU2ozOU5LMnQ0WHF5VitWK21x?=
 =?utf-8?B?M2s5d1pVVFBORGx5NXk5cEkyT3BaSXZNdkluNW1iaVc3Y0tYOXJnWmI4ejVw?=
 =?utf-8?B?ekhTWDRwcTErb0ozeGIxZjBTNDFkb0JhcWQwN1JmSmVCSldVNEZOYlR3QWZS?=
 =?utf-8?B?Z2d3dWdnMGU3RTZObzBWQkhQSWd3PT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	P528CcIy+vZ6N7ggKY/i0TK++mx/WSiA/nQ//dBLChTKuCojV+jTqu5JscHYbf6UC/QuZ82nCA/31D9+isvgDeRqVCQlhskQa93oCTUfwYu6/konFGbU6972Iy66Mvt3YB87aRELuUx/AVZ6lQy0aeSmbmGdqZSYxvvwbmfvtA9e/zSI8jto5Xfokx3sFWgQHr4rqO5mQI0bZqxWmcKrKoCVt4sVq8hfgPENqrM7HqkLUZdvPBUgvIV7qY7EbVs6A8Xy22VSCfJhyT3W4b248FT7oxLe3vPQQ3I7DMhxvNYV4jlGoBOhH2yARLNVoiEfZHBSD+Gymv2vFqC+aY3YHMNJIxTe1gP1o4+IL0MptO/UjWfq5EXlhOd07C4vGSCqDZJ7P9j/4BbT9HwoGZKTazoWHehWQaCr9HYEck6EinnnYf16jcO1n8kvTReGUyzzzDp5UNEpIVfcYt3INU7DhH5bTI+6Hz400eD1wiwvPuweTEONmrC6tB0n9pt7LUof9ooPcTZKtycwBY4RX2dLQd+o4orAegxWDKdxkZbdqtRKZwChr2mNCDNt036LF5UPYatNX0y2t1g+2mv4+rwPkPD5t8sZl+eHZoyrDGAtG4s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42ecd4ff-4300-410d-d4e9-08ddb8989077
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 12:12:35.6291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOqIoWlRodviIfrnFmgy5jL4tSKzE6mRFR9sF0VGT7YFp++N3YnnBNZTctwxkYim9XGflNENV4vc5svzSQNR/UVJAiJE0oyYg8UzaT5CTaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4932
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_02,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507010075
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAxMDA3NiBTYWx0ZWRfX0NCCwV7vbtjA 4+XYyhIi3l8f8Dt/xhS7Pm4RKqZcfPV5e8zxiIYgGBlfZV7uBBzprQlmy3JuR+HMnCsJom5EDw8 HB6xQCnZ35mPlWMHZL5HD8oxmMxiYK30JEGbtHkzSgD1JWZvn6A7PuiGdQzXZTFKOidl8eRwuto
 mtN6lmiJvU5Us5/owxjqboZ14RjH4u/RhQPkyeEHdCuy4T3ZhniqavPmWIKxrw87rgDO4sNsS4B gnhlwICc1MruJhTOGvC4er3Jt0/toifcOFCYCdbtx/KBSWRIPcxreuejed6LqxDfAZJbgYvXgHr lPtbWspYqs0GO1Opa3X5IbjX4k0c7PSb/9K/TZjRIgYrABcYQRlQSM2pSIJCmehMXtdfbRrbG/N
 IF3vufqWe8WyMIAcHmsftK+/x1toYtxqztkMawp9hsX+Tjm2xint6g7qdYev30NBdbGPxh0Y
X-Proofpoint-ORIG-GUID: YAZAqrkVyBVMAjZG7tQdGrBolfrQSO6p
X-Proofpoint-GUID: YAZAqrkVyBVMAjZG7tQdGrBolfrQSO6p
X-Authority-Analysis: v=2.4 cv=QfRmvtbv c=1 sm=1 tr=0 ts=6863d0b7 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=IcqAfu_iuSFnjXyg7KcA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:14723


On 7/1/25 13:12, Xiaoyao Li wrote:
> On 7/1/2025 6:26 PM, Zhao Liu wrote:
>>> unless it was explicitly requested by the user.
>> But this could still break Windows, just like issue #3001, which enables
>> arch-capabilities for EPYC-Genoa. This fact shows that even explicitly
>> turning on arch-capabilities in AMD Guest and utilizing KVM's emulated
>> value would even break something.
>>
>> So even for named CPUs, arch-capabilities=on doesn't reflect the fact
>> that it is purely emulated, and is (maybe?) harmful.
> 
> It is because Windows adds wrong code. So it breaks itself and it's just the regression of Windows.
> 
> KVM and QEMU are not supposed to be blamed.

I can understand the Windows code logic, and I don't think it is necessarily wrong,
because it finds that the system has:

- an AMD cpu
- an Intel-only feature/MSR

Then what should the code do? Trust the cpu type (AMD) or trust the MSR (Intel).
They decided not to choose, and for safety they stop because they have an unexpected
configuration.

alex.


