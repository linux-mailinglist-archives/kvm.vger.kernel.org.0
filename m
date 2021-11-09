Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D24449FCC
	for <lists+kvm@lfdr.de>; Tue,  9 Nov 2021 01:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241414AbhKIAoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 19:44:21 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15846 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241408AbhKIAoR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 19:44:17 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A906tMS013262;
        Tue, 9 Nov 2021 00:40:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6JAHO7WPPzcafI8RWigLemy75zFC3rkzkkWX8iQoBm0=;
 b=De8g8BKnAvXsHWpCc8Tecj5l0XwObOmeLBFg7mLVa5/N4yzZTXZss9FKJ7yCBINowWX4
 kTag86f8kRP1bw7hOiyyKvbd9HSfvCTElz1xo4stjPrGecnJgV6zG8fx6GgE0S/G2B+1
 BUkJhCyznZfrjl32F5Uv0kNfZY+N1KgnfFkVxcFKxhvtov/TdlbDu3HJ9ggr+itazjbe
 mdwNAO95MoDc3bW5Ge00q1L22iFyT6M+7x1LOcRlte5HQa8ARAe75kXlGEVDJo7g535e
 3ecXRt5ip0lATY2+iBcayQoRFHYxkuR4llxbOlWgk4750MA039Olbn/oZ6xvt6dfQ8r7 IQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6st8qyha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:40:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A90aaBQ054123;
        Tue, 9 Nov 2021 00:40:50 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by userp3020.oracle.com with ESMTP id 3c63fs5fqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 00:40:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QK+cs+aUTIc2DbQAK0ybszqewcw8phNvkqdm3BqsyLgBRHX3N5RGUwYr3ulm2vFNmnh7CMT+nbwzEnMNBonKAPj1SikCdbJ9q9rzqpdt4+fqRRSrCbtJ69/lhnTA3bJuhAj+A0AnWf/skpZPrZQiTtCPEGReGHAfy80p8iZwq95c5/+znxrUnhkeAeyyFmhjWS7oBROVy8Wc9gDDufn0jGsGtIFtUVKroLLmhn20tDq5IpMXRWMSMPqwinpOufIQqvt0M4bn/WUh1lWzPcMICmbsU4c/yxSi6Fn0uHcs8H7dPvxnCio1feOaPGqTJjqvkM/adyOStG6m3jJwxVa8HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6JAHO7WPPzcafI8RWigLemy75zFC3rkzkkWX8iQoBm0=;
 b=kHaOWRdSthpHpmL4NFEJYJeRqxiUnxOzjgY6S2yuH+MKT1CF3pWIzNWyUsBQ8idLGDgMci5L9AfWLN6KabaiEWLEM4M2mptsxJnj3igicHD4sfhRlN0Nd66aViDEkjjA4Xwz9M/RUwAG8EmEfiXo81wUKjVJCSSrvg1ZcShbyb6KqJBZcOCLh4eHthZOpdrQH08zIJEgnja38fkc3Tt5gaH5ZA2/hmDncyy08eebsuzOBSGA+Nn9anJUSbA5N+0fnCQ7f8Hl/ednzcY3VE4HPF4nDHok6yem9PCuvti1Rc0yH+FsqsrHR5CUJjFu3g8qvTloCQHuLOX/P5KQ6WGolA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JAHO7WPPzcafI8RWigLemy75zFC3rkzkkWX8iQoBm0=;
 b=BC6wubsKZcApxt67M8EeY06V4ciAdSu9Feann2ToOfoCadrS50XvyLWOaDDteAoCxM/p+ZSGpK7XSq9RGwbKSOnJKUAyBSMTBz1eOrwf9V7ekkeLT8ro89OzG4QAm0hkDHVl/fn3TTV5Io8NuAa2TtgwsjGeCGJw3Jmi/0Ged5w=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB5273.namprd10.prod.outlook.com (2603:10b6:610:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:40:48 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:40:48 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 14/30] KVM: Stop passing kvm_userspace_memory_region
 to arch memslot hooks
To:     Sean Christopherson <seanjc@google.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20211104002531.1176691-1-seanjc@google.com>
 <20211104002531.1176691-15-seanjc@google.com>
Message-ID: <d7ef0c04-dfc4-17d7-d0a5-3e91e43ed8c8@oracle.com>
Date:   Tue, 9 Nov 2021 01:40:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-15-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR08CA0013.eurprd08.prod.outlook.com
 (2603:10a6:20b:b2::25) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.218.22) by AM6PR08CA0013.eurprd08.prod.outlook.com (2603:10a6:20b:b2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Tue, 9 Nov 2021 00:40:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90e37216-571d-433d-1c3c-08d9a31992d7
X-MS-TrafficTypeDiagnostic: CH0PR10MB5273:
X-Microsoft-Antispam-PRVS: <CH0PR10MB52730960D2CDB6230E0C2156FF929@CH0PR10MB5273.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nEPsisLp03BWXcOawyvXhu6+PLI3n9yAcMUd64fp/eFt3hPrfBeCpT9tTjiCv4F6tdCxptaQmAEWA0vM+OdUMBBz3LQEOjfS58q16HtKgzKoVJfjN6t2Wy0aaxVD+VVW8GWabiEjRGdyZVk5NHJpxXh1uFjJPx5gIfUdJ05qvpbd4Lv6Y9LixP31RRryUrj8loIs20o8ZgDM9+K42XCYmiNAo3H79bASrsJA0IujuDAQxoQbxXhLOOtnJwtVlq4SAsI/WYOhzGNvsn9H97DWBO0yasYVdn9s8XiwoqL3xLoNlsQvBGbd0sfAWSW7XpdW58KPo6Hqe8aDcySjma8yTvwE1uK33KuGY2AC6oPvhrgry9NNa72RJjwRwNk5wFbIoUyXRVfAOQUgSoih53rxOengvPYxRgn//8R+GojI0kCWAic3yuzVYeSS9Mt8Ij/VeRfGIcBYFCxa49mi4YkjsAMrkoAzy7zf5kJk1OD93WnjEzo8dV69smWZNXwc2CpShH+Q3zqfVJXWQeyOahgOyC/vawuTpOd76QHt4JM2icG7ZLfzNgPl/7eHmLMVD31mjDryzYtUemip3e3jYqu13bvOICIvb+M66JJ94OD98ok2R575ljtltoLZBL7dYepvGbVPC205S78m+Pzi/FU2gW+MsBycDFq91QcnSNWJjywBvxUDh6CrnK9VpwG4W0Xn53fTMjiT5aFLuhW+/YYxVBQVt2fqYuvMbFCt2LYmFm4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(8936002)(7416002)(508600001)(2906002)(316002)(7406005)(38100700002)(86362001)(186003)(53546011)(4744005)(5660300002)(6916009)(31686004)(4326008)(956004)(31696002)(6486002)(66946007)(36756003)(54906003)(26005)(2616005)(66476007)(66556008)(16576012)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NU1nUmVqYnVLY2hNb0hoNFZiODRmVXpUY2FuVlovak1RWnY5ZUpjRjc5Um9E?=
 =?utf-8?B?U1FDMWtvcmg3ZGozM053Z0tvZWhBaHpSWnBtYnU4ZXhPYURoZ1BzNCtoQlFG?=
 =?utf-8?B?cGV0Z1pMR1RrWmZzVnRaOWJVeWNubkIyYkRCYTRZS2RjVHZYQ2tYTVpLb3R4?=
 =?utf-8?B?VzR0K1NLVkQxNjJmR3AxVEl2bWNEWDJjclBMNnpZL0dYQ1M0M1VCZ2tUMlAw?=
 =?utf-8?B?b0FnRHNqN3lERlZzb3dXSkd0aWxUV3ZvYUF2OCtYQU5MdkhQMVZJSXhnKytM?=
 =?utf-8?B?Q045eTV1KzlWWFd2OHlRc0dHN0xLOUlsWkRZalhUYXdRQ3B1ZVlQbGZZMzBw?=
 =?utf-8?B?UHliWEQ4Ry9mUVg3TldSZ1FkQnRjeWJCQlpEVitqR1h0eGgvMFErano3amli?=
 =?utf-8?B?ckxvVFdDRDBJU0paT2wrVmp0cXR5Y1dFZEQ0bDcxTlJ1ZnUvdllDcmFNaHdX?=
 =?utf-8?B?ZkVzOXhMdVQwdWQydDg4cytIcWM0STZjZmVIVlhybHNvdHVtWm9Cd2RsWkV0?=
 =?utf-8?B?SUhNOXQ5Z0FGT3VMUVZiNml5VTRyNWpCVzF6MHppRTRGMUUybEdrS3dSQkpP?=
 =?utf-8?B?MlZ1ZXlBZVZQTU5QUXhuNnBhaUtjVmlDVHVEeDhDeUpDUjgvSzRsWG8vTmcr?=
 =?utf-8?B?aXJPbTNhVGNjYVZCQXowNEFEQWhCRUJnY0VHNlQzRHk5OStQQlI5WGFtVVRG?=
 =?utf-8?B?UENOZUQzQVhwN20zWnFuY3c2MldwMmorcUpTb01DWE1haGxrUm10L1pFWDNJ?=
 =?utf-8?B?eXB1ZlhVYXNuVnRXcExiejg3b1ZsclB3ZlROTENpUUZQb21vbmpCRWZzN1lp?=
 =?utf-8?B?ZUNTY3Z6MlRMVXNOZ3RnZVkyODkwMGh2MmhTUVBMSEI5b01MVk16ditmNnd1?=
 =?utf-8?B?OVdEaGRROUFhYTJqbkVrYWpuWHFPOURZRWRmT04yMkI3M2xWaldVZ2dJUWdD?=
 =?utf-8?B?a1gwS3puRkNCM0hkSTJMUEZRYS93c0gyZ1RodkwwT2ZDWFByWEY1NDQzRmQy?=
 =?utf-8?B?M2tyYXVnMzR5UDhDNnVVNXcxS29PTlNwZ01JeU5FNWdwdk9jU3FtYjhHVmJP?=
 =?utf-8?B?V3d5TnpObjkwNlE4czlTREZJMzNjNDMybVZTTTJ5UlNhMDhQSDJDOTYzb01C?=
 =?utf-8?B?ZDNqNHY3RllEdHdzbXc2T3RrcURpQXcwQ3ZYUW9STVVET3hCL2EycTlJTiti?=
 =?utf-8?B?bGx0bDFMQlZ4KzZDcHc0NU5vN2VqL3NiRFlMNjE1YnpBR0pMcytpVTJselNT?=
 =?utf-8?B?cU1pYmVhU1lWVVVSWk9LTjJtNkc5M0o4V3FGUE5HTk9OdTkxU0VXOVkxdmRD?=
 =?utf-8?B?QUUxNVpYVVhDZ3JxdkhJK00rUU5zSVNJaVNROUhCb2ZjSnJGWEJXbjRTU0tw?=
 =?utf-8?B?Q2RkYkdIdFRYSnFLMFdPTGlkRGRaTEtaQ24vMkNrWEU0a01UZHppRHVmcWtz?=
 =?utf-8?B?bWtpUTlDeGZjQ1I3RStSNjMySEJWTEFWakZKcm10N1EwYjl4eDlNSnRKM2Rn?=
 =?utf-8?B?eE5RODQ5RXVrWWd3OXBXV1BPK2RDdk1sY1g1ZitLZHdrb2V4TytSUUI3dGl2?=
 =?utf-8?B?aWR5bjVOYVRETU00ZlBhTmRsL1VrY2ZENy9aQkJJT2VPS2RoWS92VURza2dC?=
 =?utf-8?B?aE9LSGwrTEs5UmZzOGlCMzVUVm1KandhbklucTE1VEFnODIrakdGbk1nYzlO?=
 =?utf-8?B?bENKMXFUZXJpQ3NjclVHT1ZrSk5GMCtXU0c2UjRwVVRQdXVyM3N2UGxwTkJ5?=
 =?utf-8?B?aWpIMWduT1NQanZIRWlLR1lDUUFOYlBrY3R5cDRnQlAvcVFYOU5TcFBXb2cv?=
 =?utf-8?B?SmJHZDNEU3R2bWZoc0REbkh5elU2QkcwdUdWZWllOUtwVEJDb2JuVGJnZm00?=
 =?utf-8?B?VUxTa0wvZHhoWW01Y1FjVUZEVklCU2ZCYWVsNER1R2EyNk9yNDJ6am5kcmx1?=
 =?utf-8?B?dFdYTjY4eURwMnk0K2grS0J0cFBZQU1pVkZZdXZHY0ZJbGg2Vzkvb3J3emtM?=
 =?utf-8?B?VkpwakpIRTlUcVZYdkZJTkdibURYRGg1a2xuNU1qZy8rRTRqb2pIMUt6cktq?=
 =?utf-8?B?a09rdlE1R01xYkdnR0lFSlZ1WUpWWmN6L1JpUTZuWThZVU1zaGtZN2orUnVl?=
 =?utf-8?B?ZkE2OTl2Yjlma3J5ZElyTTVVOXpsM0ZUdTJnck9pRVZTZ2crYklHb0dUUkdZ?=
 =?utf-8?B?eXJJMk5kbldxTTU5NUpvbkJObFZEakZaRDhNZTlobnlNZzBNc09WY2swcG5t?=
 =?utf-8?B?dlZWaTFrbUczNENLTkFYWm5RR1h3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e37216-571d-433d-1c3c-08d9a31992d7
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 00:40:48.4095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ZkLzNT2SHyRcxc4dpvF7MNCpvcNZglEdawkOChA8Iox93AWi0BdZReyIgC7sfOtsqcbbY8EnOLg8x8Hr3AYsVgO+nk3sTHIK0rGsxxiplg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5273
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111090001
X-Proofpoint-ORIG-GUID: pY-egOyyiXUQnwwvxHHiMv-5cBTO8ugf
X-Proofpoint-GUID: pY-egOyyiXUQnwwvxHHiMv-5cBTO8ugf
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> Drop the @mem param from kvm_arch_{prepare,commit}_memory_region() now
> that its use has been removed in all architectures.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
