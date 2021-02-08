Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 816053140BC
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 21:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhBHUoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 15:44:04 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:32852 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbhBHUmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 15:42:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118KNpDu156960;
        Mon, 8 Feb 2021 20:40:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LrNhMNmnV/0+inL4sqZDte138PYeAI7+5M64DB6TuRc=;
 b=GTYI/RTFb5RKnc54iywJsaf+MzDqdx2T3hQp25SXqpnVtxKKaJ/YaiQsM1BbuL+2xNXe
 XOdVXVJgJu67pRnFv420bslG4yO3YX/e+u3PoFHTuggGyRK3ht5qIJVXXSwypvDYb0ON
 F/wFphlglVSUQzrcaF/KnBD+/a312Vsrn7sG4FlGtX/W/f7nV9gy/24AGjCS7DsN9seV
 bECAD/GWrLeQ5XEhaJRffG/qjSlH63aH6fS7QhK0fWLmeliLEToAyxxMTOfJl3REfyc5
 8qWQQtPUzmepdFmB2+o3/1J8gQn4OhFfIicKTQsXtI3Rd/CSg69OkJOm+k6pqPURU0Pw Hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36hk2kdajm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Feb 2021 20:40:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118K5MKK020842;
        Mon, 8 Feb 2021 20:40:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 36j510akff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Feb 2021 20:40:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZI7mqltsXTceNhW9A5cxfAC5yDeunYLkFDNsjk1woJcSldkXhAP8eeHDMuKIHbRgELttCD546RRSrAhYF1XB2bKOwznadKq+TBkmUo6qU7i1XP3Bqn0MjWIiDgs8kqMUVDvtgrBJDOMlao2auCztI6wtKZElAsjhqs4W6fhj2hwxa3FPwsA16lE7nvib6gd09b9OkPgiia0g2xc5D2MBxcKZ3zR0D0HzaaZTRudz/RuJONvJ1/im9qJe9g3vCk52BrKqgRsrlLgybAVKIqxDcBFx2c5MrsbIj7GYNdojRiW0jctAeouog0WGdBuxmA9oO/DsIm/CkDRTJ7JttWnVSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LrNhMNmnV/0+inL4sqZDte138PYeAI7+5M64DB6TuRc=;
 b=eqjYGukt1AKyROVMrKdNiXlk3Y8DgXMpEwu60P6TEPXJdSJWqNlotl+TDQynMOb8x262U6uZ7Qfi8x76hOP4H6PAHK+RaRlAUYPO0b30p9d/cApO/tTNqoilniHD88mSg09M2UoOjYOlhm6HY0BgI+17mTRvnb7QCIjovgnuwAU37QI3E09ujs/8G0P3DmjGAOKyVRNxY2qrIVRnwxouMFWF46gBVPe4I1W018aagveMjluBZCC7lPws71hQw+0vLj+j33sWPqmbWztj+A29xglixgTWhQv4Idov7ML/momgK/trbm9stj3e2g4jQpqP/p4jk0Yddg7tmJEhLFBEag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LrNhMNmnV/0+inL4sqZDte138PYeAI7+5M64DB6TuRc=;
 b=fas14bzajrZEB6ZoftovtJWfT7CMtUBujCOkJCxhXexiyBbq2Hs7tDie7K43nf72SXDNakAKRCoN//ovaIV5c4LQemABzdQy+uDCu8wb2u2aga3+tLK/hd6FSS761gupWsxqG1jIpZEbRoWg7wV6xKIdgfwswag/Ebj0CT7cqTw=
Authentication-Results: amazon.co.uk; dkim=none (message not signed)
 header.d=none;amazon.co.uk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3077.namprd10.prod.outlook.com (2603:10b6:a03:8c::12)
 by BY5PR10MB4273.namprd10.prod.outlook.com (2603:10b6:a03:205::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Mon, 8 Feb
 2021 20:40:08 +0000
Received: from BYAPR10MB3077.namprd10.prod.outlook.com
 ([fe80::74a8:8649:e20b:d571]) by BYAPR10MB3077.namprd10.prod.outlook.com
 ([fe80::74a8:8649:e20b:d571%7]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 20:40:08 +0000
Subject: Re: [PATCH] KVM: x86/xen: Use hva_t for holding hypercall page
 address
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>
References: <20210208201502.1239867-1-seanjc@google.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <3fe02090-14c7-23eb-e096-ba3d463884cf@oracle.com>
Date:   Mon, 8 Feb 2021 20:40:01 +0000
In-Reply-To: <20210208201502.1239867-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [94.61.1.144]
X-ClientProxiedBy: LO4P123CA0320.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::19) To BYAPR10MB3077.namprd10.prod.outlook.com
 (2603:10b6:a03:8c::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0320.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:197::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Mon, 8 Feb 2021 20:40:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1c9a38c-ad97-47b1-2700-08d8cc71b909
X-MS-TrafficTypeDiagnostic: BY5PR10MB4273:
X-Microsoft-Antispam-PRVS: <BY5PR10MB427334A1004EFCB53484B11EBB8F9@BY5PR10MB4273.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 79k8FG8b8A4ey3E+qCC1YeROdOCugNgi6SHYWNs4WhBIAoHoylx+8f/iurRSveeVExA5fjNmxBiteZhlQytdDU229RNbi5y6L6GhpRe5N5qmhoY9QwjZgFQcUnB+YJwdanogI1xMvyWnmzJo/mkUKQdwxzniwj8ZbcRIH0UupxcQhidHXSENYRQbZX92FFbYzYPCNXWixfsYczDLiUaSTS8gkf24T5YeX2YSI09zurq2+PYzulBawVCps2Eb39fDwX3N3MnK//GlvpL2QMY92QbxPFSnpAifVbU1re/uUAOWJ5nlT1KpFE2ZertcWBniTQfRb5J6Krp4Lpv9iJlVXlLftLjqAr9mUhcw9mgokuSby5ZrQTpCR7kUe+dJEu/aYta5LOwV0bfsGr6fkyMizNyKGm4+w+SzsvtO25kwangkW2pqHiI+EJtfSKB3Vdjs3UIoqnWgPoYiP4gjK6DRnxnVMzdTXF7F5lNTQcloumWYxB1xEJrucMf6VeVyMpanyAzB2o1Kcn37LLnqq4oX7ns7ZM71Jkjd7L4er7SmRhefn+gTcWyhBIcV45MZhRAFhFNZ4RZp+ie7PXlhD/NYGw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3077.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(346002)(39860400002)(8676002)(2616005)(5660300002)(83380400001)(6666004)(2906002)(478600001)(4326008)(66556008)(66476007)(86362001)(66946007)(31696002)(8936002)(6486002)(31686004)(26005)(186003)(16526019)(36756003)(53546011)(110136005)(54906003)(16576012)(316002)(956004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TjU4L1NTODdLM2VwNWt2dmI5bGlHL1h4Qkp6Y0tsRVJsVVdiWGJrUzcxM2o5?=
 =?utf-8?B?UFNzZWVHMUFGNVduRVU0ZGlQdmRsd3FFWG9telN0MGNXQnlMbStoaFBFL2Nw?=
 =?utf-8?B?VFE5S1ZlZklXWmM5dTg5OHl5R3Qza09FaTRLUmhVVTJPaFJ6dmI3bnMybXdD?=
 =?utf-8?B?WEhnMUxXMHlia2VNQlpDVHV4SXdobGo4N3JpZk5JODN5a0dqWlNGNDc2aWd4?=
 =?utf-8?B?Qkhydy9GQUsxeWFjK1ZNUjIrc3FhYjJwS3dxVzU3N0ZjRTVPWllMcnVoYUpH?=
 =?utf-8?B?RG9HdDJ1ZlNYb1VHRWlRZFpRMEZwWTVjWWJKQUk4NUsrekxGTmhFWHppTW9M?=
 =?utf-8?B?d1J3eVZTL1F6V2htWGxDUFVsUys4TEQybGdZd0N1QWFPU2IycFdBVGR4STNY?=
 =?utf-8?B?czgvcng4emRVdUlQS0Vsek5MOEhpVU1VaTZQQTNJM1l0V2hOUk9oYi9CZGhU?=
 =?utf-8?B?Vm9iUVBnN3lMWWpkVGdmaVY3d1RoK0VUL01RWnFyYmI2djE0Uis4UlluVU84?=
 =?utf-8?B?cHk0d2dyTnhvVWowa2dnTnBKYnZJSHJPZ09wUEJENnlWdkNnVWRuZlV2Y2N1?=
 =?utf-8?B?c0piMjdldUY1VzdlNklSMzAyTDNnbi9LaGNLd2JvZ2czRXVGcUExRjlEMmdH?=
 =?utf-8?B?ZmxwVlRwSnJPaytKRndROGs2WUZtVGhmcHZEV1doNUI0THhQMFFQR0NFSnpx?=
 =?utf-8?B?eCtUOTdvYWNyOXlyQTdZWVpZbTZPRklCY3JYY2tiSWdrUkJEMGs2YkhhUVMr?=
 =?utf-8?B?eW1oTHh3T1U1dEhFRnJxejBBQSs3R1I0ZzJlMlR1Q0RZMFY3aVF2K1RsbmZX?=
 =?utf-8?B?WnQvNDRWellobno5RHMweTVDQWhVTW5YbHE1OHh0N1NxcllVQzJZd091MlFK?=
 =?utf-8?B?U2RrWjJtNUJTamFEV3h0ZzZneW1IcWQ0Q05PTVRsVmpLRlptVldwdEdHRTMy?=
 =?utf-8?B?Wk1MbEwzMnh5aFhYSU9pVGo2K0JKWjM5b3VCMGpuNUt6K1lPSHJETDljMHhh?=
 =?utf-8?B?Nk1EcHhzN1BKZ3hiYWtvLy9LdENET25tdFlxemNZVmVkK2NIUXBncGloS1k4?=
 =?utf-8?B?aGNVbC9BWGR1OWtJeVNPKzJhWDg3MkowUVFNRlJ6U3QvaFBISVhRZnk2elMv?=
 =?utf-8?B?SzdwcWVYcE9ZOFJwMHhwR2JPWFl6Nmx0Zklmb1pLamhvS0pBVFA2d0UrR0p3?=
 =?utf-8?B?V2RWV1pFeC9Tays3Z3N4Y3dGeGVacU80dWt0WGk1STM5NllBWDBrVCtMTVM4?=
 =?utf-8?B?VGtpK0twOXFjV29QRDFiZE9oM01sbSs5UUxuRzFsL2tNNVllQ3ppRVlZRm5E?=
 =?utf-8?B?ZHpoQ0FYaDRkV0RHVmNHQnpDTnZta0l0VWFtNHNlSllER3Fod1kzVVJqODV6?=
 =?utf-8?B?ZXFRVkJrcXk4dk5lVWZHSUNkRCs5eEgvT1g2QktGTkh5c3p6Nk1DSE9CQ0ds?=
 =?utf-8?B?eWZ0WUdSdE5CdEIzR1IzL1RZUGhCTGRZV3JjNlR1U1dZSWpLWUhaVG51VElQ?=
 =?utf-8?B?QVRkajJ0bjk0bVpYYzdOd3hTZXhRSE9RZnpRRlhibmFMWnVKeXNOcnVUOTNv?=
 =?utf-8?B?M2Q4TEdGakRONjdreHlMZnZOc2VUKzVYS2NNOStlVzRnN2E4Z25leCtlZGpQ?=
 =?utf-8?B?U1piOXhSNVRESzNORVlQZUNLdzd4N0srOGJmTWdjU29ROTV3dXp5bTNJR2tN?=
 =?utf-8?B?dWdnUHNNWVg2SXYzd2dRUHhSMkJ1Qkc0TngvU01BSlpod0FwSlBlV1NCdm12?=
 =?utf-8?Q?AbmJT73L0jTEG/XIbrbQp85Xe/aizi3FKitF68O?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c9a38c-ad97-47b1-2700-08d8cc71b909
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3077.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 20:40:08.2959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ms/Jl4MaMVAMb68Ywpjx3j7m8bClSzu9SUPPCULG461q1kPx0armLillakv5BYL9j6Rqs9M4aM87fHDxe+0FNvmakbl7vCfKhWxlkgeXbCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4273
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102080119
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1011 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/8/21 8:15 PM, Sean Christopherson wrote:
> Use hva_t, a.k.a. unsigned long, for the local variable that holds the
> hypercall page address.  On 32-bit KVM, gcc complains about using a u64
> due to the implicit cast from a 64-bit value to a 32-bit pointer.
> 
>   arch/x86/kvm/xen.c: In function ‘kvm_xen_write_hypercall_page’:
>   arch/x86/kvm/xen.c:300:22: error: cast to pointer from integer of
>                              different size [-Werror=int-to-pointer-cast]
>   300 |   page = memdup_user((u8 __user *)blob_addr, PAGE_SIZE);
> 
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Fixes: 23200b7a30de ("KVM: x86/xen: intercept xen hypercalls if enabled")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Joao Martins <joao.m.martins@oracle.com>

> ---
>  arch/x86/kvm/xen.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index 2cee0376455c..deda1ba8c18a 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -286,8 +286,12 @@ int kvm_xen_write_hypercall_page(struct kvm_vcpu *vcpu, u64 data)
>  				return 1;
>  		}
>  	} else {
> -		u64 blob_addr = lm ? kvm->arch.xen_hvm_config.blob_addr_64
> -				   : kvm->arch.xen_hvm_config.blob_addr_32;
> +		/*
> +		 * Note, truncation is a non-issue as 'lm' is guaranteed to be
> +		 * false for a 32-bit kernel, i.e. when hva_t is only 4 bytes.
> +		 */
> +		hva_t blob_addr = lm ? kvm->arch.xen_hvm_config.blob_addr_64
> +				     : kvm->arch.xen_hvm_config.blob_addr_32;
>  		u8 blob_size = lm ? kvm->arch.xen_hvm_config.blob_size_64
>  				  : kvm->arch.xen_hvm_config.blob_size_32;
>  		u8 *page;
> 
