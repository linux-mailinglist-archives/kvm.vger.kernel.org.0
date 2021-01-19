Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5082FC0AC
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 21:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbhASUNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 15:13:40 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39686 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391798AbhASUMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 15:12:54 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JK9Tg4170127;
        Tue, 19 Jan 2021 20:12:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=rS4QfC6REdLT7PG7Mi41m9jBYqYWtC7Mqb5EN+8NZ/c=;
 b=i8YTgCMf3MuKMGdxJhIzr33ICwxHqQGR2R/xHzOQHY0LrdvAHSYX71kq5gz1h+Zj04eI
 /Fn7iZr1ITfFn8K8XrCFZuRmVZhstBRRNxPOZUB5r8d0VqQVyhhpykk4uRx3akVe86XJ
 JPqkmwMonnt8oY8Ew7DnA5Z/54l7gQetnYbjXQGghK05yspmxcHAGMXt0M1WqGy2iB/s
 Vjjy1ww4jjG8dwDXO35YevNG9ShrbDj1wO9Di7KaNB0FbNTHD4P0xZJIVjpVC0p44grO
 XxgRqckbX2AWnfcKvSQj29uHxXXQUL5WUMomvfnw3XXc54r0I/wn/CxWAqUo1Fp11io0 lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 363xyht8g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 20:12:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JKAlpN068348;
        Tue, 19 Jan 2021 20:12:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by aserp3030.oracle.com with ESMTP id 3649qptqeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 20:12:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9+LKK6W7NBYVtiC9BcF0r0QvxggGxi9fFavV3xffCgoUZMbUs2flhdsV8OFmjHpQRxpjiMZ9YnP1B4Lhz81qJ2HmOPk6V/OoMYUiiMXWpZyn+dFYVRQHg9Ia35KA20b2IqfJYc5mQsvZ8UjicG9L+jjlTWeQsQIe/PsncQ/3+k2DFTPPpZnoQtOkLQTvpGkIyfhyRb7FmcQXJItRuEOjEFps5OIY/iR+hKFIpXKlSQqVTMmibuWuz/HIU0tyxiH/l+n8hhP+1hOBA0jqEZbZFKS2RJnUXzRlYybc0qqTjxY5FaDQLWAziMHCjxZp91+Qd2wlxpo0SFRv6u5CPgpqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rS4QfC6REdLT7PG7Mi41m9jBYqYWtC7Mqb5EN+8NZ/c=;
 b=Mj0kR/YUKff3xIAh5d9aufXd8QuRuyDIj6i8SMf21DwSMU/fbBIDl95U1ei+u5wSrfJoR6jwaBrqV+BgmYWDtT0Mx5nBJzMnx+pplDUsNIlsR2LekQjENHwlcWv8cFi1grgi5kc4Gg/74NJ3LHwY7mUMOpyk4rZO4ZcSOMxpWwic9YQO89VIlhwoHHyijn0ieLGoLsVctZf7Ddek6PKbDdP3bOAGpnjAnhuCbqoj1lZsyBktzwAv3q1M9lJxUHYYG9xaBgg9j8Ve0Z3bNUZeBGi9iG3FTLkknPZpmyPbZB5w1a8ijKcAsdlRT+zUQ2jyeOhn2nsVPlqDeDhKnjNOfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rS4QfC6REdLT7PG7Mi41m9jBYqYWtC7Mqb5EN+8NZ/c=;
 b=wUaTQt3FlJPmFVqdoGSmYdekRdsJTi6vxZF3OfHmpPWkbAjeHYQbVlExF2BtYG5zzVdqstDfObEmFOj3CwM7MJEHewsv1nS4LKdDjhaFrLPd68A2o+NT//GC69/Qy22jDh4wtgYeU1pxQyQCVkJ9QCp/LWa6/3aCuDCIYPVjJqQ=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by SJ0PR10MB4414.namprd10.prod.outlook.com (2603:10b6:a03:2d0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.20; Tue, 19 Jan
 2021 20:12:01 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26%5]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 20:12:01 +0000
Subject: Re: [PATCH V1 4/5] vfio: VA suspend interface
From:   Steven Sistare <steven.sistare@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1609861013-129801-1-git-send-email-steven.sistare@oracle.com>
 <1609861013-129801-5-git-send-email-steven.sistare@oracle.com>
 <20210108141549.071608a4@omen.home>
 <f40232ca-710f-1b65-1d21-564c3ecb62cc@oracle.com>
Organization: Oracle Corporation
Message-ID: <e4b4f865-18d9-678b-694c-6ad7da9090bc@oracle.com>
Date:   Tue, 19 Jan 2021 15:11:58 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <f40232ca-710f-1b65-1d21-564c3ecb62cc@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.62.106.7]
X-ClientProxiedBy: SN4PR0201CA0002.namprd02.prod.outlook.com
 (2603:10b6:803:2b::12) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.92] (24.62.106.7) by SN4PR0201CA0002.namprd02.prod.outlook.com (2603:10b6:803:2b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Tue, 19 Jan 2021 20:12:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7867e77b-22e7-43fc-e58d-08d8bcb67b2e
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4414:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4414C37A952448D46453159AF9A30@SJ0PR10MB4414.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9BJZflPH1ZHvNwfpbnQsSzTPq8/FYZIrrYIVbddoJ5eOd9nEA+9FeSM5TgDzg5fd/NHTk1czlyRbdIIjrCzbYk9A68cDWE9VWmmBvQ2thZU8LJcYXJn2M7FmCl5C8QirOrOnN/JjQOcKAa0OUKNTkFAAaJFG52/tbkRC7e1wwCjxkvsm5SYH7gwl5HJWBz+j4nihb0pgPo/Fexl50mCTVPyph9iy899+KeSBKa2vxaIT4KXQA+riHOQ/6FZda9dTlTNJoWvcoCNkMT5Gaf+kUh9gVCCnau1d8c3cmRWcY6vngAEkPwuDBAPqCOScI6GDvAP2mzF1z37avkF2pTrPa7T32zk7/g6gFvAinyFbQPcy0NUgG5SiDoCuu0MBw3hcWoTUoIhnLP4GYcCJNgTKxohefl+guE30Kl2xPoHC0jzIScIV1CSLI2TkSzcdO1Tt27PKDteLPYMT9TNvWRxXI+dvluDUSxoeSO0tiWrfHaU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39860400002)(346002)(396003)(136003)(5660300002)(6486002)(6916009)(44832011)(16576012)(316002)(86362001)(66946007)(31686004)(2616005)(66476007)(26005)(31696002)(478600001)(83380400001)(186003)(53546011)(66556008)(54906003)(956004)(15650500001)(16526019)(36756003)(36916002)(8936002)(8676002)(2906002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WHdNbENYd1VqSzgxNExjbCtCc1k4dlc2bkhuTXcyeTdKSUUxTFpuVGhhbU1Z?=
 =?utf-8?B?L2pMOXlrWGEwM2toUnhQeXJaL0NrajI3TFZrTHNzSGpMR2JicW1Hc1RDczZn?=
 =?utf-8?B?Z1VjOFpkaEtzNjlJVy9TSWNCUnMrakNKL3VpWU9STG5Lc2t5THNYRDBWbFFU?=
 =?utf-8?B?RUJHQTlRTy9uc3QxWlhlV2dSZjdpZ0h2Rk56OVdxOEx1eDJ0SldteVJHa0w1?=
 =?utf-8?B?UGloaUJZNk9seGNITE1UMGhEaWdMVHJscFBNMEk5UWxmSjNXdVFTN3o1V2N5?=
 =?utf-8?B?Qk50Q2dCYmlxOWs1UXdKNlVPb0NoZnplYUhUeEtITDRiL3NxeUg4MTdLS3hC?=
 =?utf-8?B?SGZkQm9TNlIxdDNrNmVTU1ppbWtlN1VDbXBGOXVycWw2bVV2cGZHNGFRNytM?=
 =?utf-8?B?ZmpUUFp2UXJIcDYvTklKeFFBZHhwY1FyOXhVdVM3VUZ5MHhVUVlwZUVMVjBa?=
 =?utf-8?B?SDlMcWxSTlJPTmtybHlpR2RlWjVZdTNXUmRwdzNZTkZ6WkE4SDBxQ1ZyNTR0?=
 =?utf-8?B?SDBDVGthUGJOUHA0c2R5dm9JWVdNOWZMdGxtcDZsNWpjL3d4ekhGVk1hSUtH?=
 =?utf-8?B?eUozWG5hYWpIK2lpRjNOdTNOU3BRTWVYdUliWmtscUErLzVpYTV0Mk51Qndo?=
 =?utf-8?B?eVhvWHVPMkFnWUpLY1o2VmNMeDNqN0Z3N01sZVNwOERPYzBpc1ZRWENDR1NT?=
 =?utf-8?B?N3l4UmtyMjV3Rjk4cWZhY1FKQTFjR004ZDVSM3podFZROGJYbE1STWJKQ0VF?=
 =?utf-8?B?akpHaG5SUllsZlRBVk9HVDNTbVZjSVZKK2VTY1orMDFiUU1RRWtaYlk1UTdi?=
 =?utf-8?B?NytOZ0toUGk4UVBpMHpydnF5ZnBnUldMQ05QTWt2T2pIeXFVL0ladGwzVGFQ?=
 =?utf-8?B?eEpjK0d1YWMwZW51dFF2Ni9yck1SRE4ySHZFbVpKRVRpeTN0dUFTb3BSWENN?=
 =?utf-8?B?c2t3bGRzeWNWSFJNelJqdmllOGRMakxiOGlzOEFoU1EzMDdQdENQekIxem9T?=
 =?utf-8?B?QUNrS1licTMrZnZhc21JZkhab2xJYWFFMUk4YzU4cHNJSld2eWFMRU10UnFK?=
 =?utf-8?B?eGowTXZYMnFhcWRyL1hsZnRpTmZXY1ZrQ2RhN0txRHpVcnhkdjJzdUZqeUp6?=
 =?utf-8?B?Si9uSWU0bEN0Qk90aXBvZ1paMHF3Wm5rWmwrZmJSbVZZb2x6NHFLMUFIVC9C?=
 =?utf-8?B?NVZwUVd3RkpTazd6YTBsOWQ0eFFBL3hNSVZsNFIyZ0drck55YlFzWkRLTk9B?=
 =?utf-8?B?Y0VKZmZUYUl1REhPTEYraEFYSHN4RUhhek05dE5lRFFsUnNwVmQxaUp1eGdM?=
 =?utf-8?Q?oBsSOzWgXw8lQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7867e77b-22e7-43fc-e58d-08d8bcb67b2e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 20:12:01.4833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nahFawJ93td5v+XQLH03FOz1MiZXCSfrJJ/fcMe9izv0N/0kef6lO1w9L1kc9uC3F/Jvmy7oKHLnmfcAPJnJqv2f/yvQ6YAg8PUgHBvAv7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4414
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/2021 4:15 PM, Steven Sistare wrote:
> On 1/8/2021 4:15 PM, Alex Williamson wrote:
>> On Tue,  5 Jan 2021 07:36:52 -0800
>> Steve Sistare <steven.sistare@oracle.com> wrote:
>>
>>> Add interfaces that allow the underlying memory object of an iova
>>> range to be mapped to a new host virtual address in the host process:
>>>
>>>   - VFIO_DMA_UNMAP_FLAG_SUSPEND for VFIO_IOMMU_UNMAP_DMA
>>>   - VFIO_DMA_MAP_FLAG_RESUME flag for VFIO_IOMMU_MAP_DMA
>>>   - VFIO_SUSPEND extension for VFIO_CHECK_EXTENSION
>>
>> Suspend and Resume can imply many things other than what's done here.
>> Should these be something more akin to INVALIDATE_VADDR and
>> REPLACE_VADDR?
> 
> Agreed.  I suspected we would discuss the names.  Some possibilities:
> 
> INVALIDATE_VADDR  REPLACE_VADDR
> INV_VADDR         SET_VADDR
> CLEAR_VADDR       SET_VADDR
> SUSPEND_VADDR     RESUME_VADDR
> 
>>> The suspend interface blocks vfio translation of host virtual
>>> addresses in a range, but DMA to already-mapped pages continues.
>>> The resume interface records the new base VA and resumes translation.
>>> See comments in uapi/linux/vfio.h for more details.
>>>
>>> This is a partial implementation.  Blocking is added in the next patch.
>>>
>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>> ---
>>>  drivers/vfio/vfio_iommu_type1.c | 47 +++++++++++++++++++++++++++++++++++------
>>>  include/uapi/linux/vfio.h       | 16 ++++++++++++++
>>>  2 files changed, 57 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>> index 3dc501d..2c164a6 100644
>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>> @@ -92,6 +92,7 @@ struct vfio_dma {
>>>  	int			prot;		/* IOMMU_READ/WRITE */
>>>  	bool			iommu_mapped;
>>>  	bool			lock_cap;	/* capable(CAP_IPC_LOCK) */
>>> +	bool			suspended;
>>
>> Is there a value we could use for vfio_dma.vaddr that would always be
>> considered invalid, ex. ULONG_MAX?  
> 
> Yes, that could replace the suspend flag.  That, plus changing the language from suspend
> to invalidate, will probably yield equally understandable code.  I'll try it.

Hi Alex, I was not able to implement this suggestion in V2, because the old vaddr must be 
be preserved throughout the loop in vfio_dma_do_unmap so that unwind can recover it.  I 
renamed the suspended flag to vaddr_valid.

- Steve

