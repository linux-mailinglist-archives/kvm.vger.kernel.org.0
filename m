Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC49964BBD4
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 19:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236382AbiLMSV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 13:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235216AbiLMSVY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 13:21:24 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56DD0F01B
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 10:21:23 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDGEJuA023923;
        Tue, 13 Dec 2022 18:21:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=gUS7zUQnPvIeYxnk1mk40SvHzoFRN/FC4UDGJvq/r7w=;
 b=Gn6RXQgloiZ+cQWrdrNLMarPL87sO4TEIOdge6M1a0gxMkRAONKaonk4mXA1mkGMRjDy
 DVvGd4Fkfla8yLSbqH6q+0ugvbcxR1pHkYvO76EQkuVv5QxLHLJo7ASpG7YR10dIXt6I
 tW1MVE5Ygr32ax37VUNwtInFYJJhJ1Jl2OtDCpv+Pm5ls1ZpDpiyHPG5K7VZBATmyLOS
 xlCav6wgrl9qcpM6eK6xPyc2ZGHpFTUQ+q4Uz481oJFZrOiS1fHmO2K5r/Rs58rgsAsz
 JXM/V3bzcIWv/uguLOKCmDtPsCh9/bQjNfyd424Pgimv6Jx6bSp2Ct3sykyyi3IlrI9a mQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mch1a66aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 18:21:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BDHwcWr009294;
        Tue, 13 Dec 2022 18:21:20 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj67wxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 18:21:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWa+CDwkormR+o94RAsHcT0LoTowSPrnr5i8mzWlEy8Ekbfp3Qt9Zc1WuIeeyM72AVi0dIMUg8MNuyVKKJrXlXWZrlGewn+TaUomFl+fbDoS21fL0yVJn2C00ivwHin/Z7BDMqSKrfopqjB+H2JitwGxZOOX7coN16zZ6XWU6wq8PIzK+eTPGyp39jkYhF0NEyWtgLTQHw1mVUQ9X/CnJaPA422b+xjCBrICaBYjU9tqUMczydSmIz/pDppM33pNeMWkIBln/EhRWBnFP05AB/PFW4nVfFWhqQeA4tbqBfJNElRZQrDEy7nfL7TDwsJXbwzI+mIlGxYHDRsES0ob7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gUS7zUQnPvIeYxnk1mk40SvHzoFRN/FC4UDGJvq/r7w=;
 b=LCcLsm5ZWosRt5xLvpT2TKwqHd5Ag2IJCGLgcGEs6qohrLIA6AoeSN6BKjTKlIKgXfP7cofWfeetO0yB0R7Tij0yAiqmeQd6OQzNE0hQ1CQuWVunq5Pt9pT5e+fcSvrglYyubAnZ/CoZXkqU9CEfy+90kp+c2cs5BwLVSujuCxHJUN3e8ilfVhET9aJ0V9p9FXNFhs3H9ydupEScu8eEtXL+hw1iFUfr4zDX2VkigMm70vm5/6tU1HVS2esIye3130zHeCfo/Lretc+oXbTyplA59ZOrXG+Et+zF0paQU3WwP9K6xq5RgIlqjPc6btfnZFCyqGDA6hmL7y/amfObYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gUS7zUQnPvIeYxnk1mk40SvHzoFRN/FC4UDGJvq/r7w=;
 b=q7qt3fiDSKl/NImuawNIUnmSm4/+BU2UeoYyneswzgJPZGBnK5JA5g3N/y6z67mAVuB6+2D4C9mZbtuqKEDEACl6hGdjr1D8Pbt/BFl2ziWx1Y7j86ikStMMcMwYrvlTNM3U6E29rYZXTnKL4yXA5vA56kHPxH3R3m+qkK+LdeA=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by PH7PR10MB6967.namprd10.prod.outlook.com (2603:10b6:510:271::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 18:21:17 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::4056:9f2c:6171:c37e%4]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 18:21:17 +0000
Message-ID: <43ad3256-e485-b358-6445-35645d943b7b@oracle.com>
Date:   Tue, 13 Dec 2022 13:21:15 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V1 2/2] vfio/type1: prevent locked_vm underflow
Content-Language: en-US
From:   Steven Sistare <steven.sistare@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
References: <1670946416-155307-1-git-send-email-steven.sistare@oracle.com>
 <1670946416-155307-3-git-send-email-steven.sistare@oracle.com>
 <20221213110252.7bcebb97.alex.williamson@redhat.com>
 <69e68902-eed9-748a-887a-549c717ebe01@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <69e68902-eed9-748a-887a-549c717ebe01@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0071.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2c1::18) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|PH7PR10MB6967:EE_
X-MS-Office365-Filtering-Correlation-Id: d78c8d76-a7b5-47c1-370f-08dadd36d3a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pdBGYHblzyADOtg6HL5uDHhZBkKVf7ZgOMt/4boChDcSaa2PvyeeCuVzFx66a5V4J5ragRyfUoLIC5xKTKNeXs8tDbYeWPico3HJPhw4RKo0un8/HVy1Tw90PZJTRkqK8Rwjp+Sbf/bB6Tebgt1te5ww3qrr6jyEcF5GmhdcXM74FF6HQWdtpjy0qK4XysV9fUf1DiCtnfS2byrULXRI1OxNhg+qUjvTQXxKACZ7u1Qi7krZWnrDIbwoAwD/bleHdOPoSfCZkpIgt5QKEtNioSQnC4S+3x2h8suO7lG/9xTxQroPEloclT78z1tyUIXRO0PFQDx56EgZFjSyO8KYd0MXs0dNgIDgPmOE3fRM3tPqB2vXHb9U1/C2l7jqJiFdbP5aRCR+ElzKRTicrjyJhKqcfpeO25fI704+blucC2HdRlfFueuUZ9v+SkminTJEblZ3gKIPPrvss2th1QpapDDTIu6A0n6V2k5RvyaWZh7NH/99PvKMkvDV9xKXaMLnvrxBfLeFF6MbgAmEhvfzpv8CbNJ6Ti661Ksc7pbB9EEjYyWguVcWsRvKcwpcwKmap0FXDN5ynnfEtjDprto5sPlM0WhL2G00349fjQd7SER2QLlOsVk5PZ3OOZOmthBQOCwxwscMiQFbpVGxfMAJb1OaBWyr1Qw7/SeuRWt64wRHAa3OhVp2Ue/ngurOqfQXy07JizE62aqEagDOfyW6TZ5toVT7qQbRbONlF/vpK94=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199015)(66946007)(86362001)(6512007)(6506007)(31696002)(478600001)(6916009)(6486002)(26005)(186003)(36916002)(41300700001)(83380400001)(2616005)(44832011)(2906002)(5660300002)(8936002)(4326008)(66556008)(66476007)(38100700002)(316002)(31686004)(8676002)(36756003)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjZPSnQ0Z0w3eXpXYXFDdlV2R2g3emVkNTY2OUNrSXpuU1g5MS92WXdGcXVm?=
 =?utf-8?B?MlpHdkVZRDNJZVQ2dzQ5cldPcU1zSWduY253RWJDNG9haDRqODk2WDBQQms4?=
 =?utf-8?B?QlpVdkpRT0FuQmFTNnIvTzBkWERUN28rY2wxbHh3ajNMNnpzSVNVcGVBTllx?=
 =?utf-8?B?ZldzRlFmb05hR0g1MEpRdGFXTlRuanVvaVl1aDU0Y2FibmRWUmFwUE5FdFpl?=
 =?utf-8?B?eWhsQklib0FjWHdRRmkvSExhc3FGMzFmd2c0WVJWSnVhb1RWMW5OR3hNeTNw?=
 =?utf-8?B?TDB5cXpEWi82ZTl4eld1WGd5cks3cnRwS1NTMy92QUhydk4wNnpBUG1Tb2RH?=
 =?utf-8?B?YXFLaWVPSWttUStFbUx5QjFrbFNLZzdURThZN24rMUFjYWFINVEwQjI4S1Uw?=
 =?utf-8?B?UXM0ZFE2Uld4azY2b0FTV3RBeWJoUzgweVZoMzQyQWRzcnVZemw0dGN3YVlu?=
 =?utf-8?B?YUVLQ2ExWDNvVjJNb01RUlByS09hNDlZcXVKYk1NcUlkUlBCeHQ1d2RQVnFF?=
 =?utf-8?B?d0xuUmsxb0lpaWN5NFd1elNSbTE5emRWcE91S1pSckdZMVV4MkVWYWhQUVdv?=
 =?utf-8?B?Z0FOWGFxbTlrUVBwMVpqTzBsZnFWeVB6TjJKdWphNFBCL2hBdHhMWG94MlB6?=
 =?utf-8?B?b2krK0JkWFpjS2FPSjZ2TlpiZFN3YlBnT2NGQ1c4N2NyWEg4QXpQV2dCZkF3?=
 =?utf-8?B?ZWhuaysyZEtqVUxTVTNBTjVnSjdwVWxPMDlhcHpsN3RxWHZURktDam5ZblZN?=
 =?utf-8?B?UGpvZDk3K083bjA4SUhSRHVubyt1bmIrSkRYVXI2QjdzTzBhVEFmaGJEeUox?=
 =?utf-8?B?Y0gvMGdZNEZsSUdma095UGhCZ0J6L1Q3SGVBWnJXVzNuVUVacFNsdTlvMHR1?=
 =?utf-8?B?ZTF5allpdis3NHd0dFJnczFxeHo4aGZSekFZYjVyMW1uVHQrR2JaUjhEZHhL?=
 =?utf-8?B?NGpLUXE0RHpFRGV2Z2MyUDErZDNMUjA1Z0JQbDhTSjJrTzNhakg4cWFyd0Ex?=
 =?utf-8?B?MFREM3hzbjJENUZSZmUwRzl6em1BY1hIc2VnZ1Jaa3BXOHVSWVdCNnpUMU13?=
 =?utf-8?B?bUJidCs4M3Y4Z3NNTjZ4eDNvckcxb1g1RnV4dVAwb0hpU3JLbEc0bGF1TlZX?=
 =?utf-8?B?SlJBNkFmNUVOUmwxYURsUmc2S2ZqK0JjTUFLTWppaEd1SG1qRWhaM2hWRHQ1?=
 =?utf-8?B?Yk5SVUlDVEZrcTl1MjVqRnVsMzRLbDIzZ0NGSEp2UzNQM3k4bU13U0k0WWhB?=
 =?utf-8?B?N3kra0wwNnpZOWFTMG1UT3FFTkRyTzlpQ21mWEJLT2VnaTRWY1ZTNTRkdXYy?=
 =?utf-8?B?d1FyUnVOK0VxcFpMNDNhdURMY0VkUXZZODh6Y29ic0gxYUlUbDE3clNzZ3Y4?=
 =?utf-8?B?YWV5SFhrdE5TbFNMM1ZwamhRczZlWTVsTTRPc1F3R1JMVTgrbFFhY3N2RXdD?=
 =?utf-8?B?SjVNUUpFZlZFanRwZW1yL05TZDhuN0tCTThFUnRJVXpZL0NaMVhnVGVqbFhw?=
 =?utf-8?B?Y2ROQTMwQURzZjFUWWtQak5BTytSTTlHTWd5djVpUzYrR01XWUZsRm15eVRq?=
 =?utf-8?B?TDVZL3A1OWM0UHNZMysyQUtneSs0K09YeUZsSEhXTXl2NkVQRnd0a3QvVjA2?=
 =?utf-8?B?cW01R3ZWVnJ3b3kvbzl5WFJSTmdEMndHMWVIbElrc3JTTnBrandiTkVZUGFH?=
 =?utf-8?B?L2lwczZpRVpTSFltK01GQlEzb1F2RWtXTjEzd2EyZ0RWVU92c2Nyc2ZnRFBL?=
 =?utf-8?B?SEFFRDlvcktTeURxMjFhZnVoRnJUSTdkUzZBUlBWWDViSG11aVBPU3lqbHlY?=
 =?utf-8?B?bWxiZWRwUStSYmo0RUFzeTRNelZVbHZDMWYvVktIeEtLV1JYaHU0a1ZXeUVQ?=
 =?utf-8?B?TXJEM1NRUVdpYUJnZXdWSUJKdFFnVXJta0lMU3FRcHJWa3lHanhCT2kwRTdt?=
 =?utf-8?B?SlA2M1pWaVg2OXRlQTdGL0ZBWlZpbU4zRFl4ZFBnZXRMdHhKS3pHVUhIN3dI?=
 =?utf-8?B?dkozZ0t0aWxsNnRtdGxWZWxSSkQyVHNMclBQcVN6YWxjTklpUSsxall0cG9E?=
 =?utf-8?B?dGtnamdTTXl6N0RxZnBaVFdHaUIyOU1NTlRibHEwVEg1WUtlR3pkQU9uY09B?=
 =?utf-8?B?eDRlcXYvK0V3NWM4RStSZ0pLTWVVSlZ1b2lDVHRRMjhTYmkwa05kYjFmS29Q?=
 =?utf-8?B?S1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d78c8d76-a7b5-47c1-370f-08dadd36d3a8
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 18:21:17.8147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZYMD9H9KvOsmA+4/wdBBzInJS0BrTESIlFOkm8sGreosB9XuHmdwCKewwQITWfDyeaKbYDVjgZTUFt9xlbUm454fy+96ATy3Dwtl3U+9NO4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6967
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212130160
X-Proofpoint-GUID: Ac1fe5y54S_GwbG86Zqt50682eEe4oJ-
X-Proofpoint-ORIG-GUID: Ac1fe5y54S_GwbG86Zqt50682eEe4oJ-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/2022 1:17 PM, Steven Sistare wrote:
> On 12/13/2022 1:02 PM, Alex Williamson wrote:
>> On Tue, 13 Dec 2022 07:46:56 -0800
>> Steve Sistare <steven.sistare@oracle.com> wrote:
>>
>>> When a vfio container is preserved across exec using the VFIO_UPDATE_VADDR
>>> interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps a
>>> dma mapping, locked_vm underflows to a large unsigned value, and a
>>> subsequent dma map request fails with ENOMEM in __account_locked_vm.
>>>
>>> To fix, when VFIO_DMA_MAP_FLAG_VADDR is used and the dma's mm has changed,
>>> add the mapping's pinned page count to the new mm->locked_vm, subject to
>>> the rlimit.  Now that mediated devices are excluded when using
>>> VFIO_UPDATE_VADDR, the amount of pinned memory equals the size of the
>>> mapping.
>>>
>>> Underflow will not occur when all dma mappings are invalidated before exec.
>>> An attempt to unmap before updating the vaddr with VFIO_DMA_MAP_FLAG_VADDR
>>> will fail with EINVAL because the mapping is in the vaddr_invalid state.
>>
>> Where is this enforced?
> 
> In vfio_dma_do_unmap:
>         if (invalidate_vaddr) {
>                 if (dma->vaddr_invalid) {
>                         ...
>                         ret = -EINVAL;

My bad, this is a different case, and my comment in the commit message is
incorrect.  I should test mm != dma->mm during unmap as well, and suppress
the locked_vm deduction there.

- Steve

>>> Underflow may still occur in a buggy application that fails to invalidate
>>> all before exec.
>>>
>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>> ---
>>>  drivers/vfio/vfio_iommu_type1.c | 11 +++++++++++
>>>  1 file changed, 11 insertions(+)
>>>
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index f81e925..e5a02f8 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -100,6 +100,7 @@ struct vfio_dma {
>>>  	struct task_struct	*task;
>>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>>  	unsigned long		*bitmap;
>>> +	struct mm_struct	*mm;
>>>  };
>>>  
>>>  struct vfio_batch {
>>> @@ -1174,6 +1175,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>>  	vfio_unmap_unpin(iommu, dma, true);
>>>  	vfio_unlink_dma(iommu, dma);
>>>  	put_task_struct(dma->task);
>>> +	mmdrop(dma->mm);
>>>  	vfio_dma_bitmap_free(dma);
>>>  	if (dma->vaddr_invalid) {
>>>  		iommu->vaddr_invalid_count--;
>>> @@ -1622,6 +1624,13 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>>  			dma->vaddr = vaddr;
>>>  			dma->vaddr_invalid = false;
>>>  			iommu->vaddr_invalid_count--;
>>> +			if (current->mm != dma->mm) {
>>> +				mmdrop(dma->mm);
>>> +				dma->mm = current->mm;
>>> +				mmgrab(dma->mm);
>>> +				ret = vfio_lock_acct(dma, size >> PAGE_SHIFT,
>>> +						     0);
>>
>> What does it actually mean if this fails?  The pages are still pinned.
>> lock_vm doesn't get updated.  Underflow can still occur.  Thanks,
> 
> If this fails, the user has locked additional memory after exec and before making
> this call -- more than was locked before exec -- and the rlimit is exceeded.
> A misbehaving application, which will only hurt itself.
> 
> However, I should reorder these, and check ret before changing the other state.
> 
> - Steve
> 
>>> +			}
>>>  			wake_up_all(&iommu->vaddr_wait);
>>>  		}
>>>  		goto out_unlock;
>>> @@ -1679,6 +1688,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>>  	get_task_struct(current->group_leader);
>>>  	dma->task = current->group_leader;
>>>  	dma->lock_cap = capable(CAP_IPC_LOCK);
>>> +	dma->mm = dma->task->mm;
>>> +	mmgrab(dma->mm);
>>>  
>>>  	dma->pfn_list = RB_ROOT;
>>>  
>>
