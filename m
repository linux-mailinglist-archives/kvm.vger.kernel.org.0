Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8BB64D124
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 21:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiLNUYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 15:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiLNUXy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 15:23:54 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 234752D1D5
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:12:05 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEHFepE019821;
        Wed, 14 Dec 2022 20:12:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=1BysTWo3kDX7BO5TGAMDBIRLJUPUmXiTEbVRrA6eHsk=;
 b=se9QctisZ1jjHEFjRMCYtjoRMQnRGVd+Htt82BLQ4iaXevBwWV9zjLAZnzseQV1wgFu5
 dZDha0SBYB8jc6V4bqY6h86uvvv3NiTf90IQlbZMaTD0sLBIaX8vMikb84K+iA6Duawn
 43kfqfVJ8EqW79psNws3ZK6Ij8dqqMByAAA5YE8h8FZ0Maea69pPHP+h4n0RUWHCgm9w
 9kF8+XjnFzJHkZubfF/WSBNfVhuvGXksTg9iVB5zGsRcxg2bVCBQc8Uv0DyoCkigc0w1
 OMabcTMU23ZpMOa065ak42tGNbr2bE0VypK2niKA4FJSucUMrnlyIfXzEbY/lAg2Mzor 3g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewu9jp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 20:12:01 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BEJ81SS031126;
        Wed, 14 Dec 2022 20:12:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyepk74h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 20:12:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Guhdrj8RP8JGoOuw9aXkbP0ZjnGgpOf80c+Q+cHRkuuAlcMCO07mPN2eqh7wMJAqer5rDt6GBjL04URgXreqUM4pOIGGUhOnln9r7AMhxHsZWNq+FOCfVOplcWYnWxgpXYViSAUBxhwops5d22zLaxj19C5lH0NyVy0nc0NnWgpBiHQ7CQCkI/ZeSkS231AMpTTVRQB0itDxJdNFGyr5WDjsxtR8kaoKyoSM5fAu85jNzqXM1U3Yrk5OqXfllZM/ZwjkZTpMZFKGfTevShicJGvQq1cHHwegCPco4s2QCjFFp7O1YQduuqFh/amVWuYzQK+bQ8DT8Fenpb08+O69Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1BysTWo3kDX7BO5TGAMDBIRLJUPUmXiTEbVRrA6eHsk=;
 b=K//oJlWfaVbevCow3YTVcKwsa64Vz2gW1U+0vwrbakNN3T+TMx2Fp28/OmqLRVTFCdtDi9j3tw5y7C4Z+0rBnrECyQTGhAvq+ROzVtGFsk8F3p6YbfFfL0nNnOlSor0reebIpEO44cvy7dni7wrmhr7UneQEd2vfaFmI4B8xz0NpQ9pF6eAu1XdCcOC0mbn+mrb0xkMSWMAFCn2OcJ7wtm6zf8DZZI0B3nHR/OdgwB3WyAyZRueGTGVAThD+ibBfD7wBl+OBIw5S7R9/18OPH+uKbTNXUK0LwdGEC+TmFkOFWJiQMlNyKyfn2D34rKex+3x5/SkWc0Ci7LBZdlyURw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1BysTWo3kDX7BO5TGAMDBIRLJUPUmXiTEbVRrA6eHsk=;
 b=cHZWa9efeo6/oxZEYDCkEUZh2mzUPpE129QQtuClgfAruZAh8e+A2wpBWrLkAAwT4RfXyaLtOnaPqg6b79/8Bt2s4gwHyD5KYx12CboSMp7q9JxlugGME6XsYVRGsQ+X7q1PilpTJdlZftL8TDE4qLlxaWgVYwsMSHrinLy0igs=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by DM6PR10MB4169.namprd10.prod.outlook.com (2603:10b6:5:21b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 20:11:58 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%5]) with mapi id 15.20.5924.011; Wed, 14 Dec 2022
 20:11:58 +0000
Message-ID: <e36e89cc-1b7d-377a-5ff5-5abb6edc2169@oracle.com>
Date:   Wed, 14 Dec 2022 15:11:55 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V3 2/5] vfio/type1: prevent locked_vm underflow
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <1671045771-59788-1-git-send-email-steven.sistare@oracle.com>
 <1671045771-59788-3-git-send-email-steven.sistare@oracle.com>
 <20221214130318.05055dd7.alex.williamson@redhat.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221214130318.05055dd7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0321.namprd03.prod.outlook.com (2603:10b6:8:2b::6)
 To SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|DM6PR10MB4169:EE_
X-MS-Office365-Filtering-Correlation-Id: bffad6ef-6002-415b-1226-08dade0f744c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U+cbitLG/Y98BhlW6jm7RxFbT7zpgh55irb7Y3gjVVBufiiyDlFIBGabvwnUuwBPRzEH4uw8TVgsvNfM4Soh7KjPz67tGnMrsMstg0tTe80F8vfw5xMjtc7ZvpxXOtdUNn/Ion8u4LkkldkrNBdJBAf7KE9oOB3jibM/ARO/aQhYxJNgKWm/q3BxDOD4S8DyGpg8M/2eRUARSQzY5J8oqinPKbf0qvPIGYmu+0waKw+/5xxGDGj8wsshJVim41Hi7dFz7rdzoampHOh6BIx36acEQPYcXAQGGUaGOOZGd3cNHC2hzVQtNOc2PUi2HIXYf0xrr9bSntqnI5HhnH4/zLJrVGm4cvYDjKx66gm4VHjwbIDDP7U0a/db4D42/fkJ6vmqIWEJW3mvodznP2f5TC8FP/MSEuLbNY6MCC3irf8l2oEWEHgiO1gMdiXY3dfuWkkCiz4Rlt9G1Toapb240mGUkcZKEMxHmW9ebKYbhQoDgH+iamdJ/hRaDj+zT6Lua1zW6tACNbObLHcODgbZPTI3wb+aMPrJS2OYJxRt/oTAITuKTNg3GmHT59QEelmy+g5HR1+2Lw21RcBhHf0NvIZvZcWmeeJ9WQw/vPrGJTsnvUpPHnCT4jMXCvuwEGsWVJrh6rNn7HdMqli7Q15cO9lQwW1qdCNzotQkLlXTbCzE/Yb0Go/i3gVmid46J/Pmc/dAO3FOvBLhAK5oTnvAWZvldggWm7Ba6Kg9iJicKhQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199015)(2906002)(44832011)(26005)(38100700002)(31686004)(54906003)(53546011)(41300700001)(8676002)(31696002)(66556008)(6506007)(6486002)(6916009)(5660300002)(316002)(86362001)(4326008)(66476007)(8936002)(478600001)(83380400001)(36916002)(36756003)(66946007)(6666004)(2616005)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uk5HQnBxVkQ4RGJDdnZFdDNZbnlrZWxVMVZvUEl6bTR4UVQ5ck9XNnFQMDJq?=
 =?utf-8?B?dTJwdkJZVDNocUdMZGdjYXlMalhHN0tpRVhZNEdiQ0tZVUVUanFwSUM1VmNB?=
 =?utf-8?B?REtyai91ZkJGK1FWK1BaclpyMWIwc2d2bHZnVk1wWk8xUWFGRE5EUXREOFdl?=
 =?utf-8?B?dTVoQkd5dlYwU0taOTNMcHljRGViUU5QMXdpUVdlSXh5WGdYc2czNThOZ2pm?=
 =?utf-8?B?ZHFaU3BKeENkY3hwUmt2WUc2N2htQnpxbUc3UWhRNUE3K2xMMnZWY3hrd2la?=
 =?utf-8?B?eXVwOTVtamdCbmpteDFRRTh0eldFS0lmZzFjOEU0VFM2N0tETi9hZ2k5ME1q?=
 =?utf-8?B?UGZLNENQaE1nVTk3VWJlRk9NUmNLK2x3WURuMkNmQStGMGMvVHowcmYzN1Ni?=
 =?utf-8?B?aFBib3VjS0doWVM0T094cmw2VXZ2dGxqNGNJR3l0eTNpcjNobituWUxSUkNk?=
 =?utf-8?B?bVZBb256d2orUDZQSXUrVURqVXhMbDBqWnNhTSt1a0hhSC9KVXdwS3U4ejk1?=
 =?utf-8?B?QVgwdWJxb1JrK3JnSW9PK1R0bnNweGUwSjdBS0xHcWdZVWNaazcrejdCOXNX?=
 =?utf-8?B?ZlVDWjd1L1ZLbVhZMk5mL0N0K094VUxvaE1SUVRheEpYaVRvTzBPNmdRQlVH?=
 =?utf-8?B?aXIwaXhuNzExQjgxYVVISHdKSE5FOE5WL2JHTmZTNS9PQndseW12VHgwNytH?=
 =?utf-8?B?R2FmT0EwWXg0bmlpcFNza0FDQkRxc3dOcnlQYlh3TlM0bmZLbml0ZHRZUWJF?=
 =?utf-8?B?NCtweXBBSUdxdlZQOWdyUTlhclBLeHlZSWVFb2luOXlEVkg2b3d2THFsd1F2?=
 =?utf-8?B?UU1oVUxKQXBPS0ZlWUtGVjltMVNDTTR1d2J6aHV1aHBnM0JoU1pxeFUzQ28v?=
 =?utf-8?B?OVdsaW9OTHVJSXdQeUs4ZENmRXdVM1YwaTZkazRCekxSY09lZWtya3pQRGYr?=
 =?utf-8?B?RFBnSnptbW9DZkU2bm4velpiOEVwR1lqN2VYRGpQWUJQTW9kT2NpK2VXeGlH?=
 =?utf-8?B?OUFwMnU4RXV3dm1kMUEweVVoUys0QjdpT2sxcUlnK25ORUxKS2paNHlQRHla?=
 =?utf-8?B?Rm5lNndKdmhCUTd1SkNaZFdtYWxkbE5mNDUvK3RKWFk4VUd1SEY5Ykd4RVBT?=
 =?utf-8?B?WjVWaFBLdkVxMmZPSFpTUGhVSEp5by9wY0crRzBPeWlDU2YzNVRhY2hySC9k?=
 =?utf-8?B?YnpxTkdRSm9MR1EzZ1VXWjc3aElvaVBLWUdQUVMxekMxa2NRWlM0ZHBGMnRJ?=
 =?utf-8?B?QlQvbWFRTzFhWW12VUNZSW8yb3EyTGMzNm0rbWdzRElMRStkMERneSs1bGRu?=
 =?utf-8?B?RmxEY1RBbld0RUliV05iWVZsOXdvOWg5YURGbUhzRUlOMEREWDg2VHd4WDcy?=
 =?utf-8?B?Y0IrQmpDOHFpdEVncytoenVNV0piQ0FrdE5OUVJSaU1WS3kzVGNCRGZQZEVt?=
 =?utf-8?B?S1cvY3dKUEFjNnhZNU03Mnh5cDhkWXRIR3orQlA1MTlzZ2dYb0xpbWdIRFdV?=
 =?utf-8?B?MlAxM0ZLTEZ4MDdsbXByQXdHU3VlMU43WCs2SzFqWm9oa3pzT2hlYjFmZzRK?=
 =?utf-8?B?a3BNNUtEa2pnd0VYQlZRU2lvcEdKcVhqR0RlRXA4Nzc1cEZPdGNkZnhac1BJ?=
 =?utf-8?B?ZlpJOGlaNW5rV0JsU1JvWkg4Um5saE5NdVB6NlhBeHdMTmNrVnZwK1FJUDVS?=
 =?utf-8?B?YmV6U0RaMnBudXczYU51UTViRzlOZHdYbjduL0M0T1N4NnkwRjRKRUR0dWhq?=
 =?utf-8?B?Tit5ekk2Nm5weUg0aHc1MDJDMlIvRlZNQ1VWWTUxMEZMN3hUYXluUDdMOHl3?=
 =?utf-8?B?N2ovVkNWNVFiTFpWeHBBeEtWUXR4clc3TER5UnFjc0ZYcFlCU0pETkIvUEo4?=
 =?utf-8?B?Wk9GYnpnbVA3OFJLMlEzKzBoNURZOTZLTHVBQTlMVllFQmtYZE9ndjJlQXpD?=
 =?utf-8?B?aDRZWjdYMERteldXYkRDY2x3bVZnd2NCZ1lOUXVmQ3c5MDQ1SUdrSUlMeHMw?=
 =?utf-8?B?NGozZk1OWlQ3eXMyek5DY0pWN3JnRXNzUkFNSWRIb0o1QkFia0REMlFONHNV?=
 =?utf-8?B?dEY2bzNwNzhpVTdyZTZnZlNzRnNIZDNVMGhiTEQ5Y2VUdEEvUXdWdy9wNDlr?=
 =?utf-8?B?S1ZaMGxjYXFKcER1R0lYVXRRNlJTYnVrTFE4aStCN2NuWUpUN01ncjFxbzlp?=
 =?utf-8?B?eHc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bffad6ef-6002-415b-1226-08dade0f744c
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 20:11:58.4614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 63sHdYcqsUkQtT8wUcuHU8N2Cw54iS04qKfdbKTncYmHG6mWjRznmpHcPGMDD9AJY0kKlpx6JBGCPNUv2T7jnpXmhfKaO7hqHVdAS74adpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_11,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212140164
X-Proofpoint-GUID: uG7RhGekAABecZv3HQVDMaz2RgEcz0RN
X-Proofpoint-ORIG-GUID: uG7RhGekAABecZv3HQVDMaz2RgEcz0RN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/2022 3:03 PM, Alex Williamson wrote:
> On Wed, 14 Dec 2022 11:22:48 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> When a vfio container is preserved across exec using the VFIO_UPDATE_VADDR
>> interfaces, locked_vm of the new mm becomes 0.  If the user later unmaps a
>> dma mapping, locked_vm underflows to a large unsigned value, and a
>> subsequent dma map request fails with ENOMEM in __account_locked_vm.
>>
>> To avoid underflow, do not decrement locked_vm during unmap if the
>> dma's mm has changed.  To restore the correct locked_vm count, when
>> VFIO_DMA_MAP_FLAG_VADDR is used and the dma's mm has changed, add
>> the mapping's pinned page count to the new mm->locked_vm, subject
>> to the rlimit.  Now that mediated devices are excluded when using
>> VFIO_UPDATE_VADDR, the amount of pinned memory equals the size of
>> the mapping.
>>
>> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 49 +++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 49 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index b04f485..e719c13 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -100,6 +100,7 @@ struct vfio_dma {
>>  	struct task_struct	*task;
>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>  	unsigned long		*bitmap;
>> +	struct mm_struct	*mm;
>>  };
>>  
>>  struct vfio_batch {
>> @@ -424,6 +425,12 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
>>  	if (!mm)
>>  		return -ESRCH; /* process exited */
>>  
>> +	/* Avoid locked_vm underflow */
>> +	if (dma->mm != mm && npage < 0) {
>> +		mmput(mm);
>> +		return 0;
>> +	}
> 
> How about initialize ret = 0 and jump to the existing mmput() with a
> goto, so there's no assumptions about whether we need the mmput() or
> not.

OK.

>> +
>>  	ret = mmap_write_lock_killable(mm);
>>  	if (!ret) {
>>  		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
>> @@ -1180,6 +1187,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>  	vfio_unmap_unpin(iommu, dma, true);
>>  	vfio_unlink_dma(iommu, dma);
>>  	put_task_struct(dma->task);
>> +	mmdrop(dma->mm);
>>  	vfio_dma_bitmap_free(dma);
>>  	if (dma->vaddr_invalid) {
>>  		iommu->vaddr_invalid_count--;
>> @@ -1578,6 +1586,42 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
>>  	return list_empty(iova);
>>  }
>>  
>> +static int vfio_change_dma_owner(struct vfio_dma *dma)
>> +{
>> +	int ret = 0;
>> +	struct mm_struct *mm = get_task_mm(dma->task);
>> +
>> +	if (dma->mm != mm) {
>> +		long npage = dma->size >> PAGE_SHIFT;
>> +		bool new_lock_cap = capable(CAP_IPC_LOCK);
>> +		struct task_struct *new_task = current->group_leader;
>> +
>> +		ret = mmap_write_lock_killable(new_task->mm);
>> +		if (ret)
>> +			goto out;
>> +
>> +		ret = __account_locked_vm(new_task->mm, npage, true,
>> +					  new_task, new_lock_cap);
>> +		mmap_write_unlock(new_task->mm);
>> +		if (ret)
>> +			goto out;
>> +
>> +		if (dma->task != new_task) {
>> +			vfio_lock_acct(dma, -npage, 0);
>> +			put_task_struct(dma->task);
>> +			dma->task = get_task_struct(new_task);
>> +		}
> 
> IIUC, we're essentially open coding vfio_lock_acct() in the previous
> section so that we can be sure we've accounted the new task before we
> credit the previous task.  

Correct.

> However, I was under the impression the task
> remained the same, but the mm changes, which is how we end up with the
> underflow described in the commit log.  What circumstances cause a task
> change?  Thanks,
The task changes if one does fork/exec live update.  I tested exec and fork/exec
with my changes.

- Steve

>> +		mmdrop(dma->mm);
>> +		dma->mm = new_task->mm;
>> +		mmgrab(dma->mm);
>> +		dma->lock_cap = new_lock_cap;
>> +	}
>> +out:
>> +	if (mm)
>> +		mmput(mm);
>> +	return ret;
>> +}
>> +
>>  static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  			   struct vfio_iommu_type1_dma_map *map)
>>  {
>> @@ -1627,6 +1671,9 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  			   dma->size != size) {
>>  			ret = -EINVAL;
>>  		} else {
>> +			ret = vfio_change_dma_owner(dma);
>> +			if (ret)
>> +				goto out_unlock;
>>  			dma->vaddr = vaddr;
>>  			dma->vaddr_invalid = false;
>>  			iommu->vaddr_invalid_count--;
>> @@ -1687,6 +1734,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  	get_task_struct(current->group_leader);
>>  	dma->task = current->group_leader;
>>  	dma->lock_cap = capable(CAP_IPC_LOCK);
>> +	dma->mm = dma->task->mm;
>> +	mmgrab(dma->mm);
>>  
>>  	dma->pfn_list = RB_ROOT;
>>  
> 
