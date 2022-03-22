Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109A84E3FF8
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 15:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbiCVODn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 10:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236014AbiCVODl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 10:03:41 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABD03B00E
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 07:02:13 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22MDJvxR029059;
        Tue, 22 Mar 2022 14:02:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Qld32XV6cVD9yMyYCWkI2KZEfLn/q6Hay3b9SXzNy6M=;
 b=cgYtq/2DDVBzwOJYky7ldF5ahcavQZgu8ImRG3j+i2ypgRi4ZnJlT9oaZg0Fk8Jok7E6
 4MCdSQFiK656Ncxa+FnfI5NNX2C9JmRh2d4MsgGYC1VNzR0KRRy46rW2gQ7xgAu05uZM
 3W5HEdeJt3tP5//99H35Ph5B+3EnOsdCuvk1GIjpxTatj9tpRyBc217IWu+3bWnh/TSb
 UD3qxEbrZpYe/p44Psx+1De+wzMtEiFF+wnPKwD85hTJjNrbVzzUEgpvIkChsg+fHF+G
 tpGm8TCUS5tyR5D12wvssKUD75nGIcCVfb1x+pPsrrNbqMhVMmGDUSiwHNQe06EWMtmI AA== 
Received: from aserp3030.oracle.com ([141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5s0phbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 14:02:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22ME1YRI121173;
        Tue, 22 Mar 2022 14:01:59 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by aserp3030.oracle.com with ESMTP id 3ew578up06-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Mar 2022 14:01:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=My3qf3ZyKQcJHg0gNgpyzaJqNXgv1InVhIdvMNHy8jB9YLHzAsNuO6n6NYTweBCC5A0rfNsPXWCxLBqNn3HYN/+fWZS0yR6DviMeq+1RvHMzzWs3dakFBSahZDQPbxmd+0dWt1HeCkObQe7lWqQvzKPRmMtbpFRCm8M6qA1HrVaFlbmeeXVB61v0j5HU8wvMnu+aKw/Sn2vPf6DGrLYpMwctS2xxK0Pl7yWOHJwVAQNj23T+FKT89+OlexDdUzO59cTz8G21mxhQ9NZNpJFS9ZdQqTrly5yt6F3kiLBSC0R+OooBow5CLS00AZKNy3hm082ZrKoOE6q+0uRTsvi2Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qld32XV6cVD9yMyYCWkI2KZEfLn/q6Hay3b9SXzNy6M=;
 b=AGvNfXdAililjNSRvmRk49u6ID5rmjSsJ9VjXFt9OaHMT02+8ylIQ8J7B47gto9F27SNI8Bb9faC3tIwFTC2AN27hjoathQVtLM54Cm/dJur5nHGyjddH5OFmkqYZi7an/x7Ii+sCbJYadxo19y4lbSmsiTom9sQdNRTMugWHRc2UyMR/gPPAMoH8q7viBzyM94J0fxBBncoijVmsQDYaYz+uiVHe17GYMC/X+wHrFIiQ+3YFBzXrczdoDcj+sQ89zP3gryMg67er4dWXNT0oMU9NnkPOmKAvLIGlG7sp0ABMOCttadx8nSUUcTeVf3no/CqmJozMNOhjAcqIfGbfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qld32XV6cVD9yMyYCWkI2KZEfLn/q6Hay3b9SXzNy6M=;
 b=YIl/dkF6gadfq1EDoPzRhc/+JvbiOJs5i7sGd9xhWR34E11prwr+5M9URtCSe17ynCNjaYA8xVB7+J7/hk1bMhIsoEHlr7mz1NCn5i4NKEWh351a/w63hjNH7VfRBf9zLL5bldTV7CGi4uhjgx6moaBD2nTBnQyF0LrTYvXTZIE=
Received: from SA1PR10MB5841.namprd10.prod.outlook.com (2603:10b6:806:22b::16)
 by SJ0PR10MB5663.namprd10.prod.outlook.com (2603:10b6:a03:3da::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Tue, 22 Mar
 2022 14:01:56 +0000
Received: from SA1PR10MB5841.namprd10.prod.outlook.com
 ([fe80::85a0:903e:852d:6c15]) by SA1PR10MB5841.namprd10.prod.outlook.com
 ([fe80::85a0:903e:852d:6c15%5]) with mapi id 15.20.5081.018; Tue, 22 Mar 2022
 14:01:56 +0000
Message-ID: <968b9e8c-0a28-dd40-5a39-a261d838a82d@oracle.com>
Date:   Tue, 22 Mar 2022 09:01:54 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH-for-7.0 v4] target/i386/kvm: Free xsave_buf when
 destroying vCPU
Content-Language: en-US
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
References: <20220322120522.26200-1-philippe.mathieu.daude@gmail.com>
 <e4603209-651f-a0a0-d7be-255e0ddf2db7@gmail.com>
From:   Mark Kanda <mark.kanda@oracle.com>
In-Reply-To: <e4603209-651f-a0a0-d7be-255e0ddf2db7@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0020.namprd11.prod.outlook.com
 (2603:10b6:806:d3::25) To SA1PR10MB5841.namprd10.prod.outlook.com
 (2603:10b6:806:22b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 466f3a5c-00ca-419b-ec43-08da0c0c86bc
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5663:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB5663812D81957EE6E9CE6BDBF9179@SJ0PR10MB5663.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xjmxq4S2/GvXy+XnAH71uFhwMVKytd5aga/e14Mng+830dfLi6lxa48y1yfja7tvmIs4N6YfKTYbsarvzysLS7kjuyuJcKwp9chjErIJuRhwOAFccB37NTDn/MkbESdptRjXd/wDYtkjMOCSEcu1altTSWuEQHDajq0tGko3M1IXx0PF8vOZmSbH71Bih1X4RpDD02mFrUM+7HQMybZ+AGmY3RJ6VtR+LwlYxVp+oS6hii5eHj8leL2nB8KrI+/s/ONQC9HXe3kqBhJTVt99tGgSEXNQVa39QtfwQGV/nJCMoAD/9g7pHwBK/QZo8RdyRSq8pgfxibSVvA9DnqI3JLu127bNOBjcsbEpuyZaYisGTiWjCKG5Z07aAte2Mzrh0cQoQ6Nv97saW3mLqFH9UsbQbGZYukugGZkYQEfWZY7SC5eraeif5WDadVnhCYLcfy/q/P6KqbDrK28HJR95TAL/C9IK2PUWraue1hUt3kTKRMFhIy24VCROSXMuf5+5DHYAL6Ebpv7v6npw1+EQVozWQVphbEhXpCh/QXIf7fGWud0/ubOSQQQzXjhNdDiVM4KjHe1eCVAngpquoKdidBmKGVYLvCnzmvonGi4gF1SBzjLhY1wQ5xPLhEXoc9r3YGsMzdqnypGA9WLh+n1SONKPfdtlOS08dyGzOOLqXN6uU6OBNnxNGe53tX1vsYLLmmfiTy2XjjAXwdxdqomX0Ah0ODNQ+lO70UngTJ/fvQ/rvyL9VNKxewiJgOgh8h7hYaQ6mEc/GnRTHV9p3DtXR+W589gk+Okj+pWPk3e4siLv1aO3PCdof2eS2Dl/m989
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5841.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(2906002)(6506007)(8676002)(53546011)(66556008)(66476007)(4326008)(26005)(6486002)(966005)(66946007)(508600001)(44832011)(8936002)(5660300002)(31696002)(86362001)(38100700002)(316002)(186003)(2616005)(6512007)(31686004)(36756003)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SG84azhwRFJRdVdYTjZmTklKa1Fnbmx6Kzhjanh2Z2QraG9jZStScWNQQ1JO?=
 =?utf-8?B?UkJUQ24xT0V1T2NXUEJ3VUZKam9MeGZBK2lCcnNGRkt1T3lXWEpaeUFTbkF1?=
 =?utf-8?B?c095Z0dyUCtSbnNiSGJaY1k4aDJmbTIvVmc3VHUvM3p6eWoyZEh1TkZVbURq?=
 =?utf-8?B?MU1lS1hvNU1NU2dNMWFMb1hLYWJKL3pLcXQyVHBLejdpMTNtMWYzQlpBZlRR?=
 =?utf-8?B?dFdpVzZlL2ViR0RVaW9JN2pJZmdUN1BTWUtZcjBNd2FLVTY2c1diYm11SFZa?=
 =?utf-8?B?c1haWFh3MXkxNVJIUWc4WUxwNnpaa2xDajc3K3dNaDQ3dzF6TUJLY3FZVlo5?=
 =?utf-8?B?L1orcGh0V25tN25XS2QwK0FoVTV0a1QybkVxSm9WY1g3ZytIc2psYzJDWkVu?=
 =?utf-8?B?MGNmTnE3UG5iMi9WcmRWUi9FQ01wcllMQUEyWFlNanVmMkYvLzJGUFhCVGxM?=
 =?utf-8?B?ZE5PcTdrY3h2NXFJSXE5V2dTUmM1Z1FCcm1JMDFqUitpUEhRYmxlNWc2a1ZV?=
 =?utf-8?B?bWNjUWtXZGdDKys4NlZYZXliUXJZTmpGWGZHQTRuc3pqRTJSRG5ibm9rRjNZ?=
 =?utf-8?B?RTF1N1JSUzdtOEFMT3RnMU1tTnBXbDR3bXRMK1NkRlNxTnhnc1lwSVdYVmJj?=
 =?utf-8?B?aTA1UUo1Yk8ySi9abzdjNGZTc3hKU1VkZ0tXdnd6Y29YQ3gzWmhLbnh6bm1p?=
 =?utf-8?B?NkVZcUxrZHNxSWd5SzErclNnSjJPcStBZlJ4ZjVxZk9TSjhWQ2o3eHNzWFFw?=
 =?utf-8?B?ZFFEbG5VMDJsQlg2dDA2K0d2TVgzeGpMWWRobG9tNk5xVnYzbTdmWFV6dzgz?=
 =?utf-8?B?Qm5tcENVZzVJbnB1NmVyYjc4bVA0OHh2bWhIN0FkdjltY2hmbkRhSkxtZy94?=
 =?utf-8?B?UGUzRjRiWWlBSSswVWRMY2l6T0lLSEsrNjh6Mk42ck8zdmZQN2Z2Z0pIa0dx?=
 =?utf-8?B?RDg3M1daKytJZWJjZXhZU1BoaW1kcmJ0ODgrVXBTbm5LTU1hMU45YkRXYk5G?=
 =?utf-8?B?ZTR1VUZvQmt1NnU4N3NuZDJ3RW9vTkdaUXZ3Rmh4aGJ0QXI2S3ZQSzh5YkpR?=
 =?utf-8?B?cHc0cHlLSHMwVFUvNC9uS1pqbWEvZ21PMU81QmltQ1VaKytCbTd4WG1FclBu?=
 =?utf-8?B?MG5lV3JRcFBmYitGdTNQcXJyM3RlZUY0aWwxRWNPUVNwUGl3SUZWWGZ4YkZX?=
 =?utf-8?B?WFVnZmthMUd1OWtLUS9lbk1nb3RjNE9QZ25qc3ZjMS8wYlRULzZoS01sNHFV?=
 =?utf-8?B?UHZqdEhCY2RVQ2RCOTAyYUc1azZHSVJpL2JLY3h3UkI4WDN5NWZJQi9CQ1pz?=
 =?utf-8?B?N3NlenV4aW5VNUpRZUd1NFAvWVQ1UWN0U0lmZ205dlhuSDhMOW1sMllWaG5h?=
 =?utf-8?B?aVhKZlByeWhmYlFwQzd5eHFYMmg5RHBxRjg0UnRoMlJUUENBTDdJV05CUTFT?=
 =?utf-8?B?RjdwVHp0SDFqOUJUSkVtbmZFR1pOUGFvalI4T00ySHhhL3NEcG9IQ1BTSEZL?=
 =?utf-8?B?NnEwSE9NNmw3czFKUHJQUHhNSVdFSXc2WUptcEo1TGRlb1ZEUVNlQmhESjda?=
 =?utf-8?B?SkFGcU5rSkxhbVZvQzd6Ty93SDNDZXhqWk85VVhMZG14UmZ1V1RrYXdDYnd3?=
 =?utf-8?B?b24vYjR6QUY5QmpaaFRKVzQ0dzhsQ3BlSjJsOUlZVmhER2hxWS9CSjE5bTVG?=
 =?utf-8?B?WmpoT1NQaXU3bHlHeDNpL2V4WW9MV29EQWpMSlhNWFlacXlocTA5TVJvMFhG?=
 =?utf-8?B?RnRTZUljNzBqeVZaMVpPSDFxNTVaWnJpajdXTzduYTRmYmFPUGZ6VmhwTzlZ?=
 =?utf-8?B?U1c3S1JaR3d6R0l1QVhrYStJRFN4RWIrM0tkd1ZMd1BmaFJldXcyN2xQYnYw?=
 =?utf-8?B?Wnd3RFV5elYxVEwraTRwWFFtU0lmRXNOSTZCL1JrNE1GZVBuT0dBN0lxOVAy?=
 =?utf-8?B?VDdXdVM0MjUyUHJJNW1RanROd2c4dlkyS2xWQVVyNzVoc3lBdFQ2WmthWHhK?=
 =?utf-8?B?My9zSi9QVEpBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 466f3a5c-00ca-419b-ec43-08da0c0c86bc
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5841.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2022 14:01:56.7890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NvOjR1bsWDZqmozQMTSrdN0c0v0HB2LlH/WMHcYp8Dwn1BTsjqgvluWbJSmkm5mcGoW23B9X27YXOGEVN4fgwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5663
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10293 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203220081
X-Proofpoint-GUID: CfqxrqxPP42JqAF0_cBRzHZbD-WqT8Dp
X-Proofpoint-ORIG-GUID: CfqxrqxPP42JqAF0_cBRzHZbD-WqT8Dp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/22/2022 8:29 AM, Philippe Mathieu-Daudé wrote:
> On 22/3/22 13:05, Philippe Mathieu-Daudé wrote:
>> From: Philippe Mathieu-Daudé <f4bug@amsat.org>
>>
>> Fix vCPU hot-unplug related leak reported by Valgrind:
>>
>>    ==132362== 4,096 bytes in 1 blocks are definitely lost in loss record 
>> 8,440 of 8,549
>>    ==132362==    at 0x4C3B15F: memalign (vg_replace_malloc.c:1265)
>>    ==132362==    by 0x4C3B288: posix_memalign (vg_replace_malloc.c:1429)
>>    ==132362==    by 0xB41195: qemu_try_memalign (memalign.c:53)
>>    ==132362==    by 0xB41204: qemu_memalign (memalign.c:73)
>>    ==132362==    by 0x7131CB: kvm_init_xsave (kvm.c:1601)
>>    ==132362==    by 0x7148ED: kvm_arch_init_vcpu (kvm.c:2031)
>>    ==132362==    by 0x91D224: kvm_init_vcpu (kvm-all.c:516)
>>    ==132362==    by 0x9242C9: kvm_vcpu_thread_fn (kvm-accel-ops.c:40)
>>    ==132362==    by 0xB2EB26: qemu_thread_start (qemu-thread-posix.c:556)
>>    ==132362==    by 0x7EB2159: start_thread (in /usr/lib64/libpthread-2.28.so)
>>    ==132362==    by 0x9D45DD2: clone (in /usr/lib64/libc-2.28.so)
>>
>> Reported-by: Mark Kanda <mark.kanda@oracle.com>
>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>> ---
>> Based on a series from Mark:
>> https://lore.kernel.org/qemu-devel/20220321141409.3112932-1-mark.kanda@oracle.com/ 
>>
>>
>> RFC because currently no time to test
>
> Mark, do you mind testing this patch?
Sanity tested with x86_64 KVM. Valgrind confirms the leak is fixed upon the vCPU 
hotplug.

Tested-by: Mark Kanda <mark.kanda@oracle.com>

Thanks/regards,
-Mark
