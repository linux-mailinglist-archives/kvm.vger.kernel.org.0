Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9194C414FED
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 20:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbhIVSfA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 14:35:00 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:7740 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232806AbhIVSe7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 14:34:59 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18MI4GX5020387;
        Wed, 22 Sep 2021 18:32:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=upcw/uKfj88WDqSm8FUr1ULOeaphpyyhI9fexerZL3I=;
 b=UnyTwL74sWKlwKH1a5yP7BvpXgLZ0inIPo+8pYkxqmVbve1OABZqm6JBOryEgITmGe4d
 v3ZqJKxzqZ3wtIwtlgn47QSPQZnANardSBitueFulBSqcAp5lKBgNHfluO689/OR82JX
 mtmKyeE1V+grks6NMvl51iYGt6hn1BPdBeC7WCQ9xQdOqvMXcwa2xGTMU8oyAaf34yRu
 25TXmsxHtn8XYxVQ7GHu6W0WOpixHJbum9WGw9jvExJivzct0t1dohZi3WKgYwcg8yHZ
 sPVXS4hO7VbQ0LD/hdv/aM1ujtd3Aii0bsiSaJ9YXtLIN26RTN90jDFE9I2DslHZNBae Zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4re71w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 18:32:14 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18MIKq6j127725;
        Wed, 22 Sep 2021 18:31:58 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by aserp3020.oracle.com with ESMTP id 3b7q5b3e82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 18:31:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jW8X2+wlu25SgNrag+nc0VDWlTpFbMQENLYtTy+cBle78zgeXFPelgxb6fXIY3umTkwc6dwuSe4sqHUxNbPy0hB0V6yHCdTnzYUylodSjG46teOJc9/XHb48qKkvwnizKdpJFrw/t8XsaCs+RsMcVMsW+K/Hhbs6p8Z3bJkF3T3ohlxBKcFGCwCMtUTnpFB3ZWVr6ZK41q+Koxz4mkwBQKOupF+SEKs3RabxqDKNdh9dBek8i1SV+WrBpxiUzAstsLurbQ9EhDm5CL9Y6DJVd2Zd0ygqP/zLycTQq+0Ft8Gjc50l9ZEOP4jBz3wUlNvvbAHuoFJlw9Ck8w4v4FuUVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=upcw/uKfj88WDqSm8FUr1ULOeaphpyyhI9fexerZL3I=;
 b=Jnb1GdH8BZe/XROZgFX1rIhEOckYw9ZBE2lb78LaqOhqbntmDEkczD3NNpYsq3+pkelndFFIRMxPozIvnVjHJlWBXlPirAVj22bM/FykRoIgG+OhOhrkKeB3hxt5tLyoyNQ5c+Bps3SLvRimVvZCilyxaqoQ8YBzkF9Afpn/r4qhr7gVTVOGfCs+4sAlMNWyejjvNpFfWj/LQF5LH0aK1GDGP86/RuaSuBMbFu1Q8Ij8JNXiHvFYCPJ+mzInFoVum5DDGYTQa9yhYu6bsqbv+DJ8k8dpdZeR1CsvfBYkQlIv8ejzbymzD4ZSGX4efXot+7S9DUVgKNct/PgzOXSFfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upcw/uKfj88WDqSm8FUr1ULOeaphpyyhI9fexerZL3I=;
 b=Oh9lt3soa2YwtcTsLsewsGqJKk0lFlyIkWM8ICXdpJ0fgy+1k+9tyMApE+tjSQ0wcgnM3YZEQgLUIhKq96falghGBkX78IRrzJdCuVHN8gb39kBav375pcJ6o37r3vxdaaxakNr/0O8uj+mBP0V1WxbCWPDuTD1EWyJsm1yL1rQ=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by BL0PR10MB2833.namprd10.prod.outlook.com (2603:10b6:208:78::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Wed, 22 Sep
 2021 18:31:56 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::f520:b987:b36e:618f]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::f520:b987:b36e:618f%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 18:31:56 +0000
Subject: Re: [PATCH v3 06/16] perf/core: Rework guest callbacks to prepare for
 static_call support
To:     Sean Christopherson <seanjc@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-csky@vger.kernel.org,
        linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
References: <20210922000533.713300-1-seanjc@google.com>
 <20210922000533.713300-7-seanjc@google.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <07628e38-e865-a3b1-49bc-b4c469558147@oracle.com>
Date:   Wed, 22 Sep 2021 14:31:47 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210922000533.713300-7-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0501CA0142.namprd05.prod.outlook.com
 (2603:10b6:803:2c::20) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
MIME-Version: 1.0
Received: from [10.74.85.221] (138.3.201.29) by SN4PR0501CA0142.namprd05.prod.outlook.com (2603:10b6:803:2c::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.6 via Frontend Transport; Wed, 22 Sep 2021 18:31:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7fae781-088e-4dc2-a9b2-08d97df74183
X-MS-TrafficTypeDiagnostic: BL0PR10MB2833:
X-Microsoft-Antispam-PRVS: <BL0PR10MB283351F4C1691BCF73AAE2158AA29@BL0PR10MB2833.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E4xTpRBm0zHZDQHxUELHK4o4skpgKGZaTxeR48ByZ9KpG1jacN8sVlmcSc0lVOmiUkbIrCDKKKwze9uyFo5txERSYJi2bB9P2aox/EB0V995c+AdT73iuCIKI1mvdB7KmMMnCZyxfKIcjNGgR+pR+w5BTqECk6wR1/QHlBpFoodnk436wQD8YTOSZFTgC8fv3W/zUDBhA3lhNUqnYwvSOP9tomXBwjX2YXF/JpXa9yiW5LZJSaKkhHpMwPD+vZBAjyAhVZK16s2FsLS4d6C7BZMYMqfoi1AUjoCTA12TS+T9QFWFth+73vUWCSpFqjiLBnk5Ry2YrQZj1Z8IFao12eqT//zzSpxR2yNnt370GNVdx+Z9CNq0L39LeUWHIk2Bv+d3t2yDLgJkZMsnTKMJ30+s+j72JbGm1ZrI1b8Y3EEjbNQDoBEkTe06zl0YLwyCfZ8FrlQco7xhlfIVis/8pW3p4oQlxyyanlfnmAYD1HyeSOhHB858PdDkaBc8h4Z+WadBoHxCQKXlMa/1Gs4Ga1g6XYtJ3BwsV+UCzoqD4GEV/orTFtDoaZ+OA3eqdAehf4qjMYZLuyuuIKEf/9JvGhbzQyPlDcJk5rGoxWZfP5B0GEIA4vUKweEjtbmQtCVZpve0EYDFxtushvGrSCJx6udp0FA1uh5LnewOYiz22m6IoR/x/zCYTUgue7CuYIR4wdkrIIzvll++9GBj2PxnTzQ82rnKCNRktlrHc36Wzu2BXtHfDD3V/nXQWhep4Pvz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(6486002)(54906003)(66946007)(2906002)(16576012)(921005)(53546011)(7406005)(7416002)(316002)(110136005)(186003)(44832011)(26005)(8936002)(508600001)(36756003)(5660300002)(4744005)(86362001)(2616005)(31686004)(31696002)(8676002)(6666004)(956004)(38100700002)(66476007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHVoaEhTOS83MVpGV1o2TzkyRGZrejRoOEwxNVp0dmUzdFdiamRzbEd1UnRC?=
 =?utf-8?B?TlNmaDdlL1A4dWt1SW9wdFl0U0pZNldNM1FTVFYvMThGM1o3SEV6eEE0OUNT?=
 =?utf-8?B?UFZWOGdjOGxBdmE5TG1KbVBTT1lFamdReUFzSzJIUnhmWmFZNFZxS3MwMUVH?=
 =?utf-8?B?QjM2ek1mdlRpQU9HMm5oVVFLM1gxaEh2NCtGdTRpNDR6OUdUbVdzT3Z5OTZl?=
 =?utf-8?B?WUZJQVM5NHEzSklXUkNFNUJSY2NMRGdVQVE3TGFWRXpqdC8zQXYxZU5SSGcz?=
 =?utf-8?B?ZmJ3UG1CbGNCRmxqWEJzbFFWN0R2cjVXVjdCd1kyTWgxVTRHdFNyenE2Yjlq?=
 =?utf-8?B?UDk3UVg3clYwRjlZY3lzbmxuYU5jTVZkWE00c29IalQ2cWtlUllaN2ZBWlFu?=
 =?utf-8?B?VEY5ckd6L3hZVGYvdzdMSTQ0ZkdLVUY5K3hXdkZJTzh4WUcvdVdib0FBYnh0?=
 =?utf-8?B?WWFjdTRCdktzbVUwTnk3TTdVZTNrdmFWNGd2WkJwbnRPa0c1QTJnRndMeDhH?=
 =?utf-8?B?aW5Rc2djTWxOZGYycXY5akZLdGlxcUpqWnZ6VFhNcENzdjgvdW9CRjJsdEhL?=
 =?utf-8?B?MTdxbCtvSkp2K21hY2tERmpleVljSUhFeVJyZlhXeGgyNmVZVjgyOVFwTXJV?=
 =?utf-8?B?NFpHQ09GczRWdWR6WWpYVWxFSnA2MTZKRFRUd2NCTElVdGNOdzdOeTRPRnV3?=
 =?utf-8?B?WDZQUU1FTG80NWlWVkRkMjhYcGhBSldHTHd2YVdhTDYxdHFkbnhtQmk2dkdr?=
 =?utf-8?B?Qk5EbEo3Zmp6ZU9rS2RGZjQva3dZOGdDT2x4aTU2blBCMHJhc3gvNXZFTzlI?=
 =?utf-8?B?OE1Hd3FOMnlsdTFMT0lsQmduV2cvbzg1L2V4dFRnZ1FKUXVjSlUrL1lOL2ps?=
 =?utf-8?B?ajJKdDFBZWNzUWd0bENnQTNkYmJyeWNUWVQvRm92eGVlZFFKMGJDdDVrQlNG?=
 =?utf-8?B?SUo1UEk5aEd0RHJPVlVOLzRZVGNDc0RrZUNPY0x2bjI5OEtEeDRLRWsxQXVW?=
 =?utf-8?B?Wk1BNEFjMkN0ZUpFNEp6Qys5RTEwSVNWQVhIVlIzRnFNTEpEekRMT3F0dmVw?=
 =?utf-8?B?bEtUeXNxaEtUTmVVYzA1RlBBbTV3aEUzd1FvQlZVay9La0dZYlFFeE9SNGNN?=
 =?utf-8?B?Q0hyNTlveG1JZzZpM3BFeGE2MDZ4aC9LRWUzZTVOYkNGK1cxQjQzSE9HKzlz?=
 =?utf-8?B?WU1xalJ3dmRRSWQ4UkpTYnd1N0NnYk9CVXhMbWwwOWNtTEFRNFNuNERjMmJF?=
 =?utf-8?B?WTdLell2V1pyY2VGRHpFS0czUHZJdXdMR01oaWV5SnlYK3cyWG1mMWRDalJI?=
 =?utf-8?B?Y2s2ZVNJQUJSN1BZYy9sNkpiT1FVbjRLc0VVR2xPOE96M2RQMHErbmgwRzd4?=
 =?utf-8?B?RFNLeElMTFd3bHNLTnBLQnkwMXVFcSsrUWc2a1ZuQSthMnFrRGpIYmlLOEZY?=
 =?utf-8?B?MW9zM29KUTMyUnM5QzQ2TGtUZndEL3NNMjB5L0paTFFxRmdWRDdadkVJd3da?=
 =?utf-8?B?SXlEU2liZFZnQ0g3cVI1Qk96K1ZUYlZhL2c4UnBHRjFlZVBqSFFKTittL3lH?=
 =?utf-8?B?Y2ZVQXhkcE4zL0FiVWlTUithRjdZeG1VUDlBS0xFaXc5UkhJUFhQekhKYkcz?=
 =?utf-8?B?bFpMdVIrcG1mWjdpdjNTYk91bEtlSWQwcTJFbnlQTWZLaWVsZ1F5Y2RQSEhr?=
 =?utf-8?B?OVc4T1dSSzJJLys2bGdlK2krOEVja0Q2dVFwamJiSTFjRzRiNlliNUNDTnA0?=
 =?utf-8?Q?SuheLxEqN2oagDCS7nHKWhp2dSOYSg6Er0YNcsO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7fae781-088e-4dc2-a9b2-08d97df74183
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 18:31:56.0621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vnq/xQQSkGPgKE6aYSccfGxRj6QAFMebqWcfPpt1ZIuQ9swJ577x3oljRPPcYQbGw5Q/BJuBwWGvCjKEolbUu2cl3rRLDq8nWyGjYUTkLU8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2833
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10115 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220121
X-Proofpoint-GUID: 7ZtSLXiphePv2iFgKHCg8JOXjSqu1mWK
X-Proofpoint-ORIG-GUID: 7ZtSLXiphePv2iFgKHCg8JOXjSqu1mWK
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/21/21 8:05 PM, Sean Christopherson wrote:
> From: Like Xu <like.xu@linux.intel.com>
>
> To prepare for using static_calls to optimize perf's guest callbacks,
> replace ->is_in_guest and ->is_user_mode with a new multiplexed hook
> ->state, tweak ->handle_intel_pt_intr to play nice with being called when
> there is no active guest, and drop "guest" from ->is_in_guest.
>
> Return '0' from ->state and ->handle_intel_pt_intr to indicate "not in
> guest" so that DEFINE_STATIC_CALL_RET0 can be used to define the static
> calls, i.e. no callback == !guest.
>
> Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Originally-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> [sean: extracted from static_call patch, fixed get_ip() bug, wrote changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>


For Xen bits


Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>



