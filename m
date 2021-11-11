Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D2444DEAC
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 00:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhKKXz7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 18:55:59 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:44678 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233255AbhKKXz5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Nov 2021 18:55:57 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ABL0khw015490;
        Thu, 11 Nov 2021 23:52:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=tEN09LGmekFR2YsfNrhyAwulV48vJbqkXXl2WNUpD2c=;
 b=MqrW1aA1GLTZrMG+yPvD1+6jK5CD301zJH+AzgGNNclvqAhpgKUaxF3aoePLUvFUM8T2
 iUV+/lqPIn0h+wP5tfdqWh3cP+NpUlzqwtq2nWEmIzxNr/jAQleN+j91UvjkJS0WbZ1M
 rv6O9ayPJEkskox3y8k7LzRdXOIiJkG/nioj+CV+1xjVZzKTMYMcLSXYUmChSZNbw9eN
 URq4385W59lLMCdVRzHcYpQainVBjChoTqk6OyDB552xSyeKLZGrf87WZcO3GgEhYEnZ
 hnUA46VBTgzYohWezFuBypv1oNbgyKLWSjbVonwFdc+7SfKgdUbiu6/Zq31W5c8TrYDB AA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c7yq7nsx2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 23:52:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1ABNpk1U138741;
        Thu, 11 Nov 2021 23:52:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3030.oracle.com with ESMTP id 3c842ecqee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Nov 2021 23:52:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BfvBLWlE1ifQekY0tw4BhJ73nefp/f7ia38ibemLxHwL3SIhFdgGBFDMArY0zt5IGXj24mUYNQ74zfJ7cpVbAsc7TYCcl74aJU0cl5T6XnRenMMHLh4A6pj0flntPqfXUz/zgmci6rtzODmksWtXIQtqrN5D1URsk/YC6zQqORfWTZ0NiJA11EXoO+nx73KT22Lh+bE/o9HQwBU+xpP6layl4XJ8oHctPyqLmg9GUsbZnxR9R7lfa/+wPApbDtu2Bg7OcSBj+AW3JeHt0CEg2tVNFIhX3OxtVnuNIJSie+gkhaELcfsG1duZKTBOUwDb9KEBI0t5FvzytKMW9y+Ndw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tEN09LGmekFR2YsfNrhyAwulV48vJbqkXXl2WNUpD2c=;
 b=KDeCYyaUy4NTzezjYeeCUCN/Ezoc1tQQ8CXdnd0qW85tLHw9lfC/LoHny9cmYrm3lN9me4pLdDpNmMfXVype5FEvseNuwiN9ZFdy1tgZbWVqC9VO4GstC0TaFtOyKgAyZrFZYLiUrUXMl3+4JO9Ln1s01AK2c26sIyOw3MFA39WtEU6O9nBEwTru2kcQBRgvwg+k9Xp/YrkGY1XCad43Y8dO8BdT988TXbZJxqrVhzSc/bvmPa/yiDjWZBTxlhk2MWsojUR81+5pQ0xjbKCBJWWjrtEEpJxskDNem0NADOSDlBEUpN9awKcrPAIvoiUVpncu/ZpfTOazqMjYTq2zfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEN09LGmekFR2YsfNrhyAwulV48vJbqkXXl2WNUpD2c=;
 b=tX5AJmZtx0S1dTqVNBV6UvQNSMBV5NnLaxH4wNkenUZJiMrx9MUbbsBLx1/HFXSLm3drBqlZJSR6pQJFfvQx5FR+C+8SV51OoOiuHsfxUWrWudiJcGfJcr/cYi596NlkvXJts5XwbsbBPj/3ZUfos0XbIFWVr/q2G2BvaJF0700=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from CH2PR10MB4008.namprd10.prod.outlook.com (2603:10b6:610:c::22)
 by CH0PR10MB4938.namprd10.prod.outlook.com (2603:10b6:610:c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 11 Nov
 2021 23:52:16 +0000
Received: from CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6]) by CH2PR10MB4008.namprd10.prod.outlook.com
 ([fe80::74b8:818d:18e5:e6c6%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 23:52:16 +0000
From:   "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: Re: [PATCH v5.5 24/30] KVM: Use interval tree to do fast hva lookup
 in memslots
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
 <20211104002531.1176691-25-seanjc@google.com>
Message-ID: <d76707b5-8710-b1a6-0cc6-defdaf9e37b7@oracle.com>
Date:   Fri, 12 Nov 2021 00:52:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20211104002531.1176691-25-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P195CA0081.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:86::22) To CH2PR10MB4008.namprd10.prod.outlook.com
 (2603:10b6:610:c::22)
MIME-Version: 1.0
Received: from [172.20.10.2] (37.248.219.146) by AM6P195CA0081.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:86::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Thu, 11 Nov 2021 23:52:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9a75fa5-a1e0-43b3-5be6-08d9a56e4a4a
X-MS-TrafficTypeDiagnostic: CH0PR10MB4938:
X-Microsoft-Antispam-PRVS: <CH0PR10MB4938ABE8C71852DAD09453CCFF949@CH0PR10MB4938.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JFKGZGQpR5MV/NKeaDePuTYtCKp5xZTW28aTLZilhtoGBro5hqoiZLX0hUfkO6hhuSi/SnFwWgqNYwgMo++3D7olVkLKll2Bj2s8+0gCn1T4lT+XRTa7Xt9CiDjL9/+6T5BjIxTaRveySH+tgzNrlYSWSTTBLXsKxhykIFwJlN9IIsQSB8gTpuGTQU0TA3bB4IHS7igGNYGIImZlexuRD8i9gP9MHjCv5GnIC8GUOkXBFjiu//D0tyaIqNSzNF9WdeWHH0BtHljQnDE/R/My9A7kmgRE5TFvBuiVkjtmx/l8c1UwPqNCn6lfaGrND03u6yhtrBKysLTIgLvDhNvYm3MRAeTsUsdtlRJ3AgEnjQesCNsTTKv0nWB6TvHk/fRKsIQqLFtPS7KlsK90Z+YFSBUpujgpVc5HfcAr3iCVZ9WeQcKC1sZkW/AggdEfGN1IV+RanPVknyIXozvR0htJFZCPo+QQ+LE+1ZjisrdVBUtRrGqnpK4Qx0Pocle2MgjAck9Fs9EOXQyVaokebQ5Zi1R6QGFs5R/y/Fv+NabMUWQ+zoITBRmaQZy0KdyaTCO/3OI0eZPlM2oscICPx0LLk5cJHNOyXNoPzq2DtEj17vr6kyJdjDEyUqX0vZ0cLyp2NkcHHXvRWkjhaMutxpv6EK0E4Kcv6Cfi8qwK+tZN9m2RYETppNtfVVJplCsoVqAEM12CQx4muU++7LVf8Kakb+nDScLTlI4n40TKdLVwf0c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR10MB4008.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(86362001)(36756003)(8676002)(6666004)(16576012)(5660300002)(2906002)(316002)(38100700002)(956004)(83380400001)(6486002)(508600001)(7406005)(4326008)(31686004)(26005)(2616005)(8936002)(6916009)(186003)(31696002)(54906003)(66476007)(66556008)(7416002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUQxY3lMbS9Pb0ZQQ0lkZnpZK09JbDdtS1VTelJIWkR1OHcrNHlpMFpmNENj?=
 =?utf-8?B?andIQXQ3dllKWGxTajFNNVRwUCtKVFg4OVNmWVBQc3RkTUJ1djYwVitmRnpw?=
 =?utf-8?B?YmpYd3pEanZCQ2JNRWpET0ovVEZ4Vm5oeU5pSko5WlYxRnRXUDZ5RmUzZXg4?=
 =?utf-8?B?bnNyWStEeGgySVo0a0UyZXFxVXYxV1RYWm9pdHpiN3hPSXMvTTl4VVQrdHh0?=
 =?utf-8?B?dDJsZG1rUGw3NDF4S0hqc1FYOG9xbzA1dUF2Z05rNDF4RFFxNUxGY2RrekVj?=
 =?utf-8?B?MUgrOGprQTdtUWhFazduamI1UFBPbGExa2FtQmVnOWJEMXI0a1JTb1JubW1G?=
 =?utf-8?B?QTFlajdKY2hFVFFUbmRMOWlGK3VhRUpkb1dwMUI3cVhPaWdmNnpiOUxtUlZL?=
 =?utf-8?B?UUUzeTJSREZJN1drRlVUS2N0cGQ4aDAvekdMY3Jjc09kTmhhWnRWOHAwbkRM?=
 =?utf-8?B?Z09ld3BGTVpmUWpyamtkazhzTlFvVUJldkZBUWhHTEJCV3pzV3V5aDJWcytH?=
 =?utf-8?B?QlBReWVqcHg5QVZ2NHhlMWVJM3grdDFJZWlobTltTlpnOEtVYytaNHlFRWV3?=
 =?utf-8?B?SUVjbERldFh3dDlBQXJjZXBxNVBoaWNyaUYwUW5BaUZqYnIxRGsvZXJNZ0VM?=
 =?utf-8?B?VmJMcmxpdDFQb2QxWTBMNVZMNmZydU5XZkdBTzVTdGJCQWh3TWRKNVV2RnVZ?=
 =?utf-8?B?UlZqaGdwNXB4T0N4ei9KK3g1c1RTMUhFSVFORW1hek5MYWhHbjA5akNrR1o2?=
 =?utf-8?B?S2FJN0FiK0FGbHNiUXRwZXhKbUJyOXVIMnltVnJVUmlITnFIZENWbnJTTm5z?=
 =?utf-8?B?T1N6ZzZMWUtMU2puZy9USVdsSXgrMndUUC9Dd0V0NytzZWQydUdVYUpJa3pO?=
 =?utf-8?B?NExoTHA5TWNYTHJMbW1weXNuN3RNRGtiSWxuTG1UNEtFTmp0Si9hcnJmOXJ5?=
 =?utf-8?B?N1ZKTGhTOHNqU3lMOEkyNHZ1UHJEM1ZmOFB4MzJjMGgxdjdPdWZhSkRoeFBL?=
 =?utf-8?B?b1dnOUh4anE1S1F0ODMwa2F2U09xLzFvRUNsam1GMHA1b2dPRUhyZjYxUmJW?=
 =?utf-8?B?czltanRGNDMxNStlaklwSHkrVUE2UHhWajFqOWgrVlBuSjA2NFNIVkxtTkg2?=
 =?utf-8?B?TnRXRGc2NVBuUGZ3dFRkc0pGeDc1MUwvKzVRVTdIcmxkN1lFTm14dk5aWXoz?=
 =?utf-8?B?cVdERFVSaEhodlFnNjBZU21LREk5NG03RFlHZ3VtQVJ4ZFBaSWhhRzhRcGRT?=
 =?utf-8?B?Q3RQZU5KY3p5dUc5NmNPUisyNHczeFZqam4yYTQwRjZzNmtQdlpqTWFDbFFZ?=
 =?utf-8?B?Sk9VUjBuQmQ0NnNQem9iaVRab3psY3RDUXUwRHdvdk9GcXducERYVGcxVjJC?=
 =?utf-8?B?a3B3R3o5RzJXd3BxdEdRWmhqTnhUYWlNOHhCMFY2QmJqdHp3ZU9jcDFaMWNw?=
 =?utf-8?B?SHkxb1hVMWVlclMyTmt5cTRjRm1xM1cyT0hiNU5pTEtZL0FvQmRFY2lkRFhM?=
 =?utf-8?B?clpTTDFiUGMvSklzb1UyeUNlN3JRa3N4Z0ZKRHo3WWhMSEZCcm42VUlUNFE0?=
 =?utf-8?B?aVZuNEliYWZBR0g1aFZJZnZpK2JzYW1jYk54N3NkcmRVUm9GUnpNRFVjcUJk?=
 =?utf-8?B?amMyb2owWk4rNHR4dVVud3U1YkdtZWRhT2JSODZoN3VXbG5VckRiR2ErL3RO?=
 =?utf-8?B?UmxiZ0RQK2t1ck1wRkdOejNtS1hIMDJmWENFbWJlakhXc25EVis2L2hOSkRT?=
 =?utf-8?B?KzRNcHJLV1JVSitCOHJzRXVsU0VqRUJWejNTcjRMNG1wc0VJaE9TVFhHam00?=
 =?utf-8?B?bHpLYWZzQ3dreGxvK1pzMGsxRW9samFqTlVpcWU0MFRTZHRGYzg5aFhZb09H?=
 =?utf-8?B?YlFjZ3BWZGJyTEEzZVY4cFZJcUpSYzFBV2JQY24yMU5BMTN4WlduWmVCOS9n?=
 =?utf-8?B?eDVSRHgxSnlPbW5YLzVIdjFqUlAvTlY1WWhPZ1k4eGdVclJwNzNyT3FHOHI3?=
 =?utf-8?B?RGtXOTFDcEx5b3RJZjkrRkxQL3A0cVA0Tm15REozcmFNY051OW9FLytjQURP?=
 =?utf-8?B?eFNVU2t1Z2dqU2QwcUpRak1pQ005ckl2RXJZSC84elRKc2MyKzlNUjR2c3Jx?=
 =?utf-8?B?a1VQY25yVk9VWmNPc2xLcC9jdFF1VVJiUnNWSW9aQU1OVmd2ckIxVm9zdkVM?=
 =?utf-8?B?NjhtNkNmL2N4NFBlR3NJejFEZXY5d25paWEyek85Q0Y2QkpBZWk4ditBcEdZ?=
 =?utf-8?B?ck5teXhDOXdMajRQU0xrU1QrekNRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9a75fa5-a1e0-43b3-5be6-08d9a56e4a4a
X-MS-Exchange-CrossTenant-AuthSource: CH2PR10MB4008.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 23:52:16.2387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KTtCCNyXgGnv0mAo5cFxey+hb6nt9vivN/f0W7f+EilbAjXAGQkiUmvgy7TEniDrbZiVzMp5D6iDOHRd5OaCK154eLTgjzyVIcx4rPfXI9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4938
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10165 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111110121
X-Proofpoint-GUID: 7ca21L04sK3P8FwTLwepM2QryLeLHTmt
X-Proofpoint-ORIG-GUID: 7ca21L04sK3P8FwTLwepM2QryLeLHTmt
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04.11.2021 01:25, Sean Christopherson wrote:
> From: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 
> The current memslots implementation only allows quick binary search by gfn,
> quick lookup by hva is not possible - the implementation has to do a linear
> scan of the whole memslots array, even though the operation being performed
> might apply just to a single memslot.
> 
> This significantly hurts performance of per-hva operations with higher
> memslot counts.
> 
> Since hva ranges can overlap between memslots an interval tree is needed
> for tracking them.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> [sean: handle interval tree updates in kvm_replace_memslot()]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/arm64/kvm/Kconfig   |  1 +
>   arch/mips/kvm/Kconfig    |  1 +
>   arch/powerpc/kvm/Kconfig |  1 +
>   arch/s390/kvm/Kconfig    |  1 +
>   arch/x86/kvm/Kconfig     |  1 +
>   include/linux/kvm_host.h |  3 ++
>   virt/kvm/kvm_main.c      | 60 +++++++++++++++++++++++++++++-----------
>   7 files changed, 52 insertions(+), 16 deletions(-)
> 
(..)
> @@ -1262,22 +1274,32 @@ static void kvm_replace_memslot(struct kvm_memslots *slots,
>   				struct kvm_memory_slot *new)
>   {
>   	/*
> -	 * Remove the old memslot from the hash list, copying the node data
> -	 * would corrupt the list.
> +	 * Remove the old memslot from the hash list and interval tree, copying
> +	 * the node data would corrupt the structures.
>   	 */
>   	if (old) {
>   		hash_del(&old->id_node);
> +		interval_tree_remove(&old->hva_node, &slots->hva_tree);
>   
>   		if (!new)
>   			return;
>   	}
>   
> -	/* Copy the source *data*, not the pointer, to the destination. */
> -	if (old)
> +	/*
> +	 * Copy the source *data*, not the pointer, to the destination.  If
> +	 * @old is NULL, initialize @new's hva range.
> +	 */
> +	if (old) {
>   		*new = *old;
> +	} else if (new) {

Unnecessary check - if "new" is NULL then the code will crash anyway
accessing this pointer unconditionally...

> +		new->hva_node.start = new->userspace_addr;
> +		new->hva_node.last = new->userspace_addr +
> +				     (new->npages << PAGE_SHIFT) - 1;
> +	}
>   
>   	/* (Re)Add the new memslot. */
>   	hash_add(slots->id_hash, &new->id_node, new->id);
> +	interval_tree_insert(&new->hva_node, &slots->hva_tree);

...in these two lines above.

Thanks,
Maciej
