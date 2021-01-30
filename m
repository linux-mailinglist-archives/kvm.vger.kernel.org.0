Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D043096F3
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 17:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbhA3QzG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 11:55:06 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39192 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhA3Qy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 11:54:58 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10UGjspr164420;
        Sat, 30 Jan 2021 16:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=tbgmIb6p4FuuZ1ScxX/xvsNq8SAHc2xvp88N4rgslKc=;
 b=Wox/J5l0/rhore1OUo6vBvBB4jJ06HUURVt3L5FdelTRpi0WBeFI7QW0ZivN13ttStQ1
 QIhIfEWbvLA/Kju5VNMckz5rRp9Z6eKp9EI/EWS6f12ooPkb+XjNcxSsc/c75Rs7GxNX
 e81TH97p0rfzgFlb3LzvV9OwZsOYphAqH7+84MXUOGDsBSbE6/jf8qgoF7BXntOTypHS
 tFL3d8+ruaXYLG9SHO9fCGWwlNgkCR2m/bTneCD2gzBkWLGcJX0adjgbcBnC4uYAcbY/
 CcDkxP2DQv5tNuzDXzPcHUJhe5dGhTk8WlB4hROOYp9g71OSlhzuIEqRFmzN8Q7/f1Rv zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36cydkgxv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Jan 2021 16:54:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10UGjJDU166514;
        Sat, 30 Jan 2021 16:54:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by aserp3030.oracle.com with ESMTP id 36cwg9tdqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 30 Jan 2021 16:54:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DJerSrbDiC4nWU5d+rF+zQuoT87X5uamjOHMy/crY/k2vm25seqviTg64+2ZKOFC2zMEnhqA+KVRX+9GnKAy9cJh46aIlU7nAWizwLNfd30J8wRn6lYb36N7eQFprCJr9gGbutSUwNvGPmcGZPifNiU/pAtFXRr0YSoyQh7Hi//vvOUAztpl+Y2LmCTC+912bpcf63hM7+8kKzZnieGjJTbslNQhhjWqoCAtIKFXxkMLWcmmE81gH2cB5ht7UZWrS1YnPH0a26TudJ8mcqnaLG8v/yW44qKjxMx/n96//cVxHwbg0i72fUzUzJg9HnVubuTHYX+F2mu8ruBAPMToCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbgmIb6p4FuuZ1ScxX/xvsNq8SAHc2xvp88N4rgslKc=;
 b=J63P0cbaIURVrIPvGpvxHEyBHvrZ0wNJlWjRGrQzzlXXbTNk9FOZtcoFDzx0s9kJ/QKosQLHAwDrAjiXFFAZ73EdyL+rqGASnMWFb8GTzG29VW/GZcjlG0shf5A4cZBa/2A6JK3fOvCRNXpg14bsF9HqePBzONS7wEioSuVpt9Y87cHieZKf52r3Eeetdnnveq9ks5HrjXrcVwxqzv3G6zZBrHXNzpnBsx2/kYGLaOuLXe+3qX/OIz7X5eOJ5Lg5IXfae/o8SdbUN2DzG2T1+XAQqtqOI9HJFZH0RhoinmVt5axSWwfOsAxetD3h6ERaNbq0fDHWVnd0j2by/5n/Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tbgmIb6p4FuuZ1ScxX/xvsNq8SAHc2xvp88N4rgslKc=;
 b=Ec+EwzkXkaSTX2RmWxfOlggpHUl6Oh+hjkbpr7yjZgw0g8P+MxCScIOhyUGOSMv0XkESeUhhdoPlfXDwxgoilzYWOZsoExtgbt/AzYQbtElG3OS+1RPVXJFBoXkCpe+k7fnpuy/rNhcyjvhVbxxgySh8qMKRce0z3ulL5pYSXzQ=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by BY5PR10MB4340.namprd10.prod.outlook.com (2603:10b6:a03:210::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.23; Sat, 30 Jan
 2021 16:54:07 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26%5]) with mapi id 15.20.3805.022; Sat, 30 Jan 2021
 16:54:07 +0000
Subject: Re: [PATCH V3 0/9] vfio virtual address update
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
 <20210129145550.566d5369@omen.home.shazbot.org>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <29f7a496-f3c5-c273-538a-34ae87215e0c@oracle.com>
Date:   Sat, 30 Jan 2021 11:54:03 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210129145550.566d5369@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.62.106.7]
X-ClientProxiedBy: BY3PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::12) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.92] (24.62.106.7) by BY3PR05CA0037.namprd05.prod.outlook.com (2603:10b6:a03:39b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.10 via Frontend Transport; Sat, 30 Jan 2021 16:54:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b23bc02-3db2-4ed6-47f3-08d8c53fa880
X-MS-TrafficTypeDiagnostic: BY5PR10MB4340:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4340F923FA2309EB4F011A39F9B89@BY5PR10MB4340.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2lKDYCAPj+HnTHPOOBzM2Z4rFdRK+wzqkS6Nn+KYQ/J8VO5Mmrk5c91R58GGJDiL0pKbZrk6zAUaALYAA6/+g1zLQVb0Ecr6wTozNh6uvpcEhGG/ZAkuJJuY4QDA4F4Fh1/FlQYU4w2sccxecmzUFg/tApMbeSVJ6wLYtw5stGTorCQkBo7VvJ7l7NdOh6l3i6LgxbiC4kMpdV/7ZtybiTfnSqWfKGux4riZBMlaycB1yZPvG5Ti+8otGV4fj126FSB+Famlf5SQhKklxx+Qu9vMrSMWSlsrHyc+uA0El3JToWFuN1q8NUzH2MSQQcpHjyNkdV+T/pPR5tbO95gPwiskOa6VCDl59QaFZsj842Gy4KpowKrqzFPEK0+SHobgeeh+NFLi+v/sfWiE3S5MSbUtpXaz0TR5EVxeHrVYxB1E/z6zmTn5oMHmRTUlx2GiIha+LxCK0FtqUAuLM/RbJ0GeOjuGkBrVP+dQXWHshr9OtYNgMNJd5xXpT8TcHUiDagAZCTQ6gzQT75tFCB/MU6pWGxb7D9SWBoybSrT1K8FO8lcdCA/lNK3+ye45TToFUg17zFizbuoPG9agbEN4xo0ojM7qp/7kiUvkYtgJOKy2mZAHNCIDRJMCxz4kyKnRn7lbY36iP4IZJrTpsQBTQMIwfwEhKSicB3xF0dWm5ipwK8yeDfx6n8XP3IFtS/H0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(396003)(39860400002)(376002)(83380400001)(36756003)(6916009)(6666004)(6486002)(66556008)(66476007)(5660300002)(478600001)(53546011)(16526019)(36916002)(26005)(31686004)(66946007)(186003)(8936002)(44832011)(2616005)(31696002)(54906003)(8676002)(966005)(956004)(86362001)(4326008)(16576012)(2906002)(15650500001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NnU3VjhjZXl2Wm1WRE80U3pKaGNhOVVPVHA0bUZWV1M1NlpObllhMmIwcCtW?=
 =?utf-8?B?NjFMR2w4QS9iWEhOekltM2IwRHlqZVFlajQ2ODcyTVBsUEh0L2U3R1lqTHdB?=
 =?utf-8?B?UlhKT3dSVE51d29RTitCdTU2Y0hSSmtLaU9UNW5xV3ZLMGdqL2dET3Fvb2dU?=
 =?utf-8?B?V2h3TU40OWdJZU9xRktJWmRoa1FXWFI5YWc3dVFpMFE4VmM1UEdYTEJzK0ZN?=
 =?utf-8?B?a253UzdRSHZXQ0Q4N0FNc2lueVI2ZjRybHhxZ1VxY3NOcDN1UU4yZnZzenlV?=
 =?utf-8?B?RFpDOElYUk9DSG5VOVN5NitoOFcwR3EweG9rOUt6VG1uSFN4Y1cxNm52NW1l?=
 =?utf-8?B?dTRpVTlZbkZKOVhXQ2U5QUppQU1wK3JTa2lFUVdaT0FHMEs0Q09La3FFaHJs?=
 =?utf-8?B?Y3lmYWRBTmFjVnhyREtJUzNyeE5TZmYzekRnakRKeEZqZytleUxrdEF4VVNi?=
 =?utf-8?B?TGNsd1NCek9vbUtWcWoyYjFaQ0VLcTBnSU5rZmdoVGdvcjRWamRQYVgydjRI?=
 =?utf-8?B?Y3U4bURIb29aVGszb1FYanVNYXhkcittQ0ZKKzkxTjZuS3FHMzFpcGI3ZnhH?=
 =?utf-8?B?LzlVbjBlZzREUlBPaDd6cGNxTkoyd1hRSTF0L1BSdEY1d3JGaTYvVi9xNXB3?=
 =?utf-8?B?VmpUdzkxaitUUjF6RkduYVlOMDZid2puMUZ4bXFZRG9LQlMra0MxbHNFcUty?=
 =?utf-8?B?Yk9UZkw5TmJpOTFkck8zZVdHNmFqOTcvQ2k2MlBhRm5jZkRLbFFobFM0bWZH?=
 =?utf-8?B?OUQ3eXIvUWptTHZmcG05TlpPWG9TVUY1akdsUUgzQWdCL0IzYTBzTlpTancr?=
 =?utf-8?B?aFZRUTZuMDdrOXh1UklBY1ZpUHp2VzdMbWtEMkFwY3ZjVFBrck1wRzl1dS9E?=
 =?utf-8?B?NzRnWWtDRVFmNzBGaFNqbHZibGVhcWpaVWxhcGEyaTYrY2pub0NJV2ZCeFdR?=
 =?utf-8?B?MHJvU1hMWmJ1b3UvSWNnTTdwSURScXV2T1VtUW9qd1FqNTY0M1VPUlhvMlBX?=
 =?utf-8?B?WTdMUEtPclV4SGJQS0h1OXJ1WjBUeXFZR3ExSVRrSjZsVDkzdVdocWZnREhO?=
 =?utf-8?B?N2E0ZkJ6dk9mQ3RZbmFaSzZTNFFLZ3FPLzRqcW1qL1FKMXRkT2tNcFdtOHFN?=
 =?utf-8?B?Sy8xVnNqakxUTTQwbzZVTEFIT2VWeU15VXVZTWZaUnNRY3RwZVRuNWhZUXFz?=
 =?utf-8?B?Z1FLTzY2aU9WcEZnOWt5ckZDa1ErczBocE92NDFReUc4UWpodDlycDA2NTk3?=
 =?utf-8?B?UzkyYUcyb0JMUHFZRDBmaGNNSG5XSW5uYTlDZi9IUm9vTWsxSExDYnY5NDRB?=
 =?utf-8?B?TkluOE1xazhmb2Q1RTJiT3pIS1ZvZkJ3L2dOVVlsSjdSNG1kZGkvSmlpeDVU?=
 =?utf-8?B?Q3A1NU5OL2VmV21uOG93a3BFdjkzd2NVay9xMGc3VUhlY0pMVk8yVVIrNjNz?=
 =?utf-8?Q?M2EVnYM2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b23bc02-3db2-4ed6-47f3-08d8c53fa880
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2021 16:54:07.4765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fhortoeguL/IQ67OnVxJWBqZOo1aPqOV7zrRkff0yhL9Wjr43q7tlgGM4hkn6+PEQIMNXv0VyHmvLHsrq/zw8e0xugKgWOFyYP3nkUznaBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4340
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9880 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101300091
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9880 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101300091
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/29/2021 4:55 PM, Alex Williamson wrote:
> On Fri, 29 Jan 2021 08:54:03 -0800
> Steve Sistare <steven.sistare@oracle.com> wrote:
> 
>> Add interfaces that allow the underlying memory object of an iova range
>> to be mapped to a new virtual address in the host process:
>>
>>   - VFIO_DMA_UNMAP_FLAG_VADDR for VFIO_IOMMU_UNMAP_DMA
>>   - VFIO_DMA_MAP_FLAG_VADDR flag for VFIO_IOMMU_MAP_DMA
>>   - VFIO_UPDATE_VADDR for VFIO_CHECK_EXTENSION
>>   - VFIO_DMA_UNMAP_FLAG_ALL for VFIO_IOMMU_UNMAP_DMA
>>   - VFIO_UNMAP_ALL for VFIO_CHECK_EXTENSION
>>
>> Unmap-vaddr invalidates the host virtual address in an iova range and blocks
>> vfio translation of host virtual addresses, but DMA to already-mapped pages
>> continues.  Map-vaddr updates the base VA and resumes translation.  The
>> implementation supports iommu type1 and mediated devices.  Unmap-all allows
>> all ranges to be unmapped or invalidated in a single ioctl, which simplifies
>> userland code.
>>
>> This functionality is necessary for live update, in which a host process
>> such as qemu exec's an updated version of itself, while preserving its
>> guest and vfio devices.  The process blocks vfio VA translation, exec's
>> its new self, mmap's the memory object(s) underlying vfio object, updates
>> the VA, and unblocks translation.  For a working example that uses these
>> new interfaces, see the QEMU patch series "[PATCH V2] Live Update" at
>> https://lore.kernel.org/qemu-devel/1609861330-129855-1-git-send-email-steven.sistare@oracle.com
>>
>> Patches 1-3 define and implement the flag to unmap all ranges.
>> Patches 4-6 define and implement the flags to update vaddr.
>> Patches 7-9 add blocking to complete the implementation.
> 
> Hi Steve,
> 
> It looks pretty good to me, but I have some nit-picky comments that
> I'll follow-up with on the individual patches.  However, I've made the
> changes I suggest in a branch that you can find here:
> 
> git://github.com/awilliam/linux-vfio.git vaddr-v3
> 
> If the changes look ok, just send me an ack, I don't want to attribute
> something to you that you don't approve of.  Thanks,

All changes look good, thanks!  
Do you need anything more from me on this patch series?

- Steve

>> Changes in V2:
>>  - define a flag for unmap all instead of special range values
>>  - define the VFIO_UNMAP_ALL extension
>>  - forbid the combination of unmap-all and get-dirty-bitmap
>>  - unwind in unmap on vaddr error
>>  - add a new function to find first dma in a range instead of modifying
>>    an existing function
>>  - change names of update flags
>>  - fix concurrency bugs due to iommu lock being dropped
>>  - call down from from vfio to a new backend interface instead of up from
>>    driver to detect container close
>>  - use wait/wake instead of sleep and polling
>>  - refine the uapi specification
>>  - split patches into vfio vs type1
>>
>> Changes in V3:
>>  - add vaddr_invalid_count to fix pin_pages race with unmap
>>  - refactor the wait helper functions
>>  - traverse dma entries more efficiently in unmap
>>  - check unmap flag conflicts more explicitly
>>  - rename some local variables and functions
>>
>> Steve Sistare (9):
>>   vfio: option to unmap all
>>   vfio/type1: unmap cleanup
>>   vfio/type1: implement unmap all
>>   vfio: interfaces to update vaddr
>>   vfio/type1: massage unmap iteration
>>   vfio/type1: implement interfaces to update vaddr
>>   vfio: iommu driver notify callback
>>   vfio/type1: implement notify callback
>>   vfio/type1: block on invalid vaddr
>>
>>  drivers/vfio/vfio.c             |   5 +
>>  drivers/vfio/vfio_iommu_type1.c | 251 +++++++++++++++++++++++++++++++++++-----
>>  include/linux/vfio.h            |   5 +
>>  include/uapi/linux/vfio.h       |  27 +++++
>>  4 files changed, 256 insertions(+), 32 deletions(-)
>>
> 
