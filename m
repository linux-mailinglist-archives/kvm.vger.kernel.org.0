Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57AFE64EE0C
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 16:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiLPPmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 10:42:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiLPPmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 10:42:31 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2B819288
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 07:42:30 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BGFY5xH025414;
        Fri, 16 Dec 2022 15:42:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=d68YVO3oWBlOo3/kn1kPPp2vASeF54SlhY0Ltc2uQoM=;
 b=M17bd+VeNAm9gsEt0dHgD8n57oJ01II8YH1hsjO3VXRMCBBBVApHx2ryiOHcMMhiJwlm
 la5Jw94DdAMW0BbJBLUhjB0yBPVRartask/JD0ZOqpyinF2ZMhF0OFr04Aca9YJPLNhw
 fSSjR2HDR/dG53xAKz8JAwejPepFzhQP1aN98yr7JYo+lTxDaFhRam+9INiINhJFrnlO
 afCdIBhoW8zUw3ZmNdkv+KJTsPQkw2hcooSEulW4u4PAplYZGYyLgRBhpMV+WORu/gXT
 CH6UZoo8kOIsyCXpM7zs12JuVRBdgv8gIL//moR4nk5Cqob+y1ctj3qlkWOt3Az78vzv CQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyewyryq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 15:42:20 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BGE11vd026645;
        Fri, 16 Dec 2022 15:42:19 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyetd0rp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Dec 2022 15:42:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NurhhWYUVuZhKIHVDnC8bPq8Cp2AHpDeWu1Y+zDDW4J5aXK6AYJt3hx89SnW0qWUs5TjnZ6E4510/M+/geWiN7oRrjl2YRvhmKHZngcBTWr/x3kmFe33BIGrod9RkW+d+k9/8P0T5akwuknnpH/fnDIvZ67Z8/G8XqUaGgkOTsKrvnoFG5AhAPJknYJ8P2oGujok/EI/k+6EAsXZEiy1roUyuSUwjUzN0rohgUZKAJHBFSCdlsmSwqWsaohldOV5jpGY5vzdnheeOPHje34Kl5sa4cHqHE94eQO9inllPwzgAgXwew9kJTNRhoe5xDRL/OHUeFh5VoT4DfrLhpPcow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d68YVO3oWBlOo3/kn1kPPp2vASeF54SlhY0Ltc2uQoM=;
 b=X9qHUZQqFJLnfu8OEHGYT+FnKatIHQLM30Te2WbAJpfqR1OWelS4U89FF8wfEcS8uwtWsuQK6idDm9v4wF+ZZSgz2NPG0S2Eawt0+6pp6weWeiriG0C66U9gYfxt30Qtn/nZythSxuiGDzEFk9aG5LMaOEjYA9ewbEJGz00CkVC53yx93egXQsNPo95zbCCvB558BTklpVYLAf61omXgtkGteGi79UHHEr8qQg+3GMyy1lifvBXjHL/+tw6rYnZ3t4PC4qpnfe31lTObgQRH1OIuk8nfUhvl/0519F7uyx1ibWw76yokzwy/E5HP/AT/iPpSI6YdDvv15L3mIBjM9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d68YVO3oWBlOo3/kn1kPPp2vASeF54SlhY0Ltc2uQoM=;
 b=HrIWZjAPcEC+fRYDbPNkPE7tpz73f2+mf1218ZDiEnDTJdW/X7ecIU3E41mgVPJbPgwyVcUXM4uZHCiFyyt3rPg5jmtJ21ATznmlW2kE/n337bIfYEK9kLwqYPDtWE36MrP0Jsg8/mS3UVwGcVfTQ2PFto58eOfxTjBcS3Nbxwo=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by CO1PR10MB4691.namprd10.prod.outlook.com (2603:10b6:303:92::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Fri, 16 Dec
 2022 15:42:16 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%7]) with mapi id 15.20.5924.012; Fri, 16 Dec 2022
 15:42:16 +0000
Message-ID: <12c07702-ac7a-7e62-8bea-1f38055dfbf3@oracle.com>
Date:   Fri, 16 Dec 2022 10:42:13 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH V5 2/7] vfio/type1: prevent locked_vm underflow
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
 <1671141424-81853-3-git-send-email-steven.sistare@oracle.com>
 <Y5x8HoAEJA7r8ko+@nvidia.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y5x8HoAEJA7r8ko+@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0020.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::33) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|CO1PR10MB4691:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bd4047f-954b-4434-f5f1-08dadf7c1c1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KgWj0p4cso06Gj5pE0/v69CPNOzCypjUGO8PUEbIbuTsKrMXbjRoPdjAqYcbmkogQx6MhTcTOaIadtq6LmEvxCUSu65vQtmhBdFJ4A3D3QFaSsc9lSKRi91an8p4rYfSA2zynup0sFEb1g9HJvjsF+M9XeRdd6ucFdu89ZwcO3lbvbpgaF9wHGzvO/fspoZSw2uhBFzGt6uOpX6IAt+gkoKjqsZ4GeYH7g14+v0h7wUwVbXWZfALJep0oEt0JmJpJkc7IAHOQaNF/slp60+S0BIXYlil1y1V1JY4h4yU1mcBNQmVLOK7DvqzsObLQSzYeEvS3Jy8DTpf7nmpy+3VZFh7UvPkcCDwDZEahc6HOevrN/jAa4p/T+psMHKHHe+wp2ypRhzusOJDyChflx5ARg/KUzHbpanEG4Ts+yiY5NaZXXR0JG9BCQZpTWh0K/nsCWMzkrd1EkMfrhUVPp5PCBkk+OqTw/yX6YGIIqyMppXT/ve5POaqwYY52UOLM1HGf9iZe20OHReUx19jcewdRcjdEkRcN31vBfxne7gSpUGuoTm3rR/+boTJpJBt6VtEeXLW1liKYc/ax/pt63uEJkHVD7fymK3D9ZWDZz+wWgtIAgQG1B5BKsgD8AP7PcsPTNx0lwyhyKHphbU96NP/p4lNSnW5J6KClF/gc48b77wPZ45oBX9vDhDdru15WRMFpTJz4qDlS2WZPCJd50glSjNaZZ51NOH2TPskRdimBvA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(346002)(366004)(396003)(451199015)(6666004)(8936002)(54906003)(5660300002)(2906002)(6916009)(31686004)(316002)(66556008)(6486002)(44832011)(41300700001)(36916002)(6506007)(53546011)(478600001)(66946007)(8676002)(31696002)(4326008)(2616005)(36756003)(86362001)(38100700002)(83380400001)(66476007)(26005)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUhFbWZGZFIyUStHV3FuMDRKVTVKOG9FampVRUdiQlNuNGFjeXdpVk43bWpv?=
 =?utf-8?B?endRejh6dld1aVRZTDhMZVh6eFB2ZVN5OUdIcjkvYldZdzRUeCtnSmRpWDVj?=
 =?utf-8?B?ZGJRelFRSXpZTEU1YVY1d3MwcmMwMXVJMlcxMnBaZ0dLZ0I3QkM1dzN3UmZ0?=
 =?utf-8?B?eHhEUzRtN1dFK1F6bGFlcExlelhQaldFcXpRSEJncnREOUtoYWdEWW9JLzVV?=
 =?utf-8?B?eHVLbDhYMHl2NjhuSGQ0YVM2a0NtVEhLaHpsUGU0WTRMY1FYMFk1MEpPQVlD?=
 =?utf-8?B?cTV6MkxXZUFWZ242bGRmcjhkc3dIYXczNVEwY1JWR3MwVWxNTld6TmpjVG1s?=
 =?utf-8?B?MGwvWURjeTN6ampSalFQNmtERGNLcGdYdVdZc3ZhVjVXckRSNUVjN0F2SUts?=
 =?utf-8?B?Qm1xN0Joekd2Wk1oMWp4YVdiWGV3empPeExiQnNxdXM1NWthaXVjcTlrLytR?=
 =?utf-8?B?WEg1YUNpTnlYZHV0aGx2Z2ZzbFFxUVpEMitGZHlBY1ZZY2RpTFh5QnZCMGdQ?=
 =?utf-8?B?S2VIZ1ZIcU5hS3VVaFhKMkEyRFEvRm9BdHlBVDdoNndWUDhuNjZkek1qQ29O?=
 =?utf-8?B?RTA1eVRLakFUUnR6dnJsMlZ0bURJWUNaODNhb0ZqWFZuS2Nucm00S2RNU21j?=
 =?utf-8?B?dmtZRWlZTTVWZFFxQit5Wm93bFMwZkFscXVaSktXWG5VdCtVWFJmVXVlOUdO?=
 =?utf-8?B?aDBlQVVMNmlpK0xyM2VWT1NYS2YvTUdGSFgvZ1Y5Um5obE5OUjlLaDh2cjNj?=
 =?utf-8?B?UUtZUDZDYzh2c0FMNHhSZEdCT0NPWFlKVlY5TmNtcDA3eDN3ZUwwTEFGakVP?=
 =?utf-8?B?OGtMR25JTk9kQVJPZjBoai8zdElBVGFZZjZIdmlsYjFnY1piY1ZLUFpva1pU?=
 =?utf-8?B?d204NFczZ1ZnV1dRd3lkVmxHT00vSERtMDBMVG11M2c2TnRuVFlwV1hLRTY5?=
 =?utf-8?B?Q0xud01ZZWNja3l1K1kxMCtFQjl3S2c0YUI3ZXFyQVJGTnR4NmxMYzFOSndi?=
 =?utf-8?B?VlBnMUtFdDNvMDgydHcwZTRZUFVzK2lBU3FNQzZuRXB6ck9GcWcwdXpyOFlq?=
 =?utf-8?B?QzBCV1RXZ2IrM1dBblVOUHVFR3MrMHlGOVFOWkJjSHlhTWNJVUo1bTdmMG4r?=
 =?utf-8?B?bFM5ZzBkYVFTbHdrcXNZeVlpb1dKMVFaZWtmRFhiOEtqYVJjbWwweFkvMXdi?=
 =?utf-8?B?U2x0RHIrZ1NUM24zM05TTlF2R3RHZWN3SGZVWU9KZkRCd0FDYW9Kd1kxZTI5?=
 =?utf-8?B?UlhneEtxaFpMaXZ1ZmZ4b3JvSmNQRlRidkYxZTkrQWQzTlM0REN2YldPSGhk?=
 =?utf-8?B?WUp1K2paUG42NDFLeFlNbGNnbVVCSVorRVZHVUJIblBzTS90d2xnczNNVlVp?=
 =?utf-8?B?Y3VZVjM3NHBXTWxjWHVWS0Z4VkM0WkpCS2hBRUZBR0JvQi9xUldNMkloYy9o?=
 =?utf-8?B?c0k3VkhqdmNCc0FmMWw4Y2VpNXB4OHVob25HMzJ0OXg3VHhoM3pWYXREUmdu?=
 =?utf-8?B?bkhGU1ZlSDgvdWswZVJVQTVwbk8xYlNMYXBnWWIyZEtwVEUweUNyTUsrV2Rm?=
 =?utf-8?B?SDVMNVBmTDRyZEJ4a1NvUzRQQXZqNU9MRVpnanJTZ2ZkN1lPTEU3SHRoL2hm?=
 =?utf-8?B?RzZUY1gwMHEreWduN1ZPVzJVT0FDQzNSbHFOeXh0QVNFVnJva05GbzJVMzkz?=
 =?utf-8?B?TjduaVI0MHpSTFZoODl1cGxrTVZYeUhHeVN4NjJkRDlDQ2FlUm1hdTEzZVBY?=
 =?utf-8?B?UW5UVEZKNHlHVUtHU0YrYW9hTzh3RWYwdnlxT0FBVTJhVkVBUmNkWk5tTjVk?=
 =?utf-8?B?YlhxTkQxWlZkOTJkZE53RnF1UlNXOWdURE9mR0lqQkFkdVFhaExLSkMxbnZz?=
 =?utf-8?B?RnpRa1diUWtKSXd0Q0JNWlFsb1RxeFMvNkkyeS9VV2JKRHpkaVpWNTRCcC95?=
 =?utf-8?B?R0MrQ3d3eTJycTE2Z0JOL1FVdDRMdFJEMk5FMUtJK25NK04vNlNYOXYvbW9J?=
 =?utf-8?B?S3F4TmdIVk8zVTMxd1poa0VvVXYyN2Zyd2E1YlVSOGZXL3VZcVhseDJ6ZjBX?=
 =?utf-8?B?TWtNYk5VQmE3QXBRcFpwTnlJVisyeVhTZzVmQnhxVks4Wi9rV1hYSkJJaWhw?=
 =?utf-8?B?QVM5Nm8vWk9NV2hQa25ZUktyTGtOQnBBdG1MdnpXV2ZzbzExeFRuNDd5djFB?=
 =?utf-8?B?M1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bd4047f-954b-4434-f5f1-08dadf7c1c1b
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 15:42:16.8129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mxqx7sz+LcC0dzohA4+AiNXBhQ5c4LRnbT77t+4oEgAFxHaillrSQDwzTgJ3SPHXkcqpH1Td5Dp1DSZduoxC52WlTMglidV5sODM66ZnG0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4691
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-16_11,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212160135
X-Proofpoint-GUID: SyP9z7aveJbr4I5UlkUgM8bpFL_ysfzK
X-Proofpoint-ORIG-GUID: SyP9z7aveJbr4I5UlkUgM8bpFL_ysfzK
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/2022 9:09 AM, Jason Gunthorpe wrote:
> On Thu, Dec 15, 2022 at 01:56:59PM -0800, Steve Sistare wrote:
>> When a vfio container is preserved across exec, the task does not change,
>> but it gets a new mm with locked_vm=0.  If the user later unmaps a dma
>> mapping, locked_vm underflows to a large unsigned value, and a subsequent
>> dma map request fails with ENOMEM in __account_locked_vm.
>>
>> To avoid underflow, grab and save the mm at the time a dma is mapped.
>> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
>> task's mm, which may have changed.  If the saved mm is dead, do nothing.
>>
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 17 ++++++++++-------
>>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
> Add fixes lines and a CC stable

This predates the update vaddr functionality, so AFAICT:

    Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")

I'll wait on cc'ing stable until alex has chimed in.

> The subject should be more like 'vfio/typ1: Prevent corruption of mm->locked_vm via exec()'

Underflow is a more precise description of the first corruption. How about:

vfio/type1: Prevent underflow of locked_vm via exec()

>> @@ -1687,6 +1689,8 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  	get_task_struct(current->group_leader);
>>  	dma->task = current->group_leader;
>>  	dma->lock_cap = capable(CAP_IPC_LOCK);
>> +	dma->mm = dma->task->mm;
> 
> This should be current->mm, current->group_leader->mm is not quite the
> same thing (and maybe another bug, I'm not sure)

When are they different -- when the leader is a zombie?

BTW I just noticed I need to update the comments about mm preceding these lines.

- Steve
