Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B261730B1EB
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 22:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhBAVOj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 16:14:39 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:58516 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhBAVOi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Feb 2021 16:14:38 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111L3Tfb121233;
        Mon, 1 Feb 2021 21:13:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=rByuw7g8fTNL5lgQEbEkL3/XM6fHKBtUvsfBA8Gbyk0=;
 b=TvDQ8PTIk0x1ArxGETGu2IxehXY0gBFJ1bJ+Ww6O67M7KZLRGRPgRzHkiE6dsvU8V0BJ
 mF90qxvxEh3Xp7rHlEnxZpScTfDEKOSrFu3447Js8k6siq2xbPxlVpTQZT1oPTj+pEes
 NMX8wJdCREePK1/Zc6MnmmS2h5hzepttHUzB+0XMlQ+OvZcrs5dSfxrRuC8lPFWC2LLY
 Z1RdqOTzlowgpQAVTvdjYnZh9+jrIxU6L8KLz1rLE44RiyE/C0jMLji2LRXFHlXAfFRB
 R9mTWbHBTw+c/SV4krvFF0o8xaBwy4A4GL1Wo6TuvUfAIeGC3XaBmy1c2H4iX66l5b0f Lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36cvyaqu78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Feb 2021 21:13:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 111L69Ra097801;
        Mon, 1 Feb 2021 21:13:50 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2054.outbound.protection.outlook.com [104.47.36.54])
        by userp3020.oracle.com with ESMTP id 36dh7qbpw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Feb 2021 21:13:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZh5AR4wNfoPQZCi/bhoFwBnrmxeYuNpV4mt9OEN5ARHtSjgQY0Ymsa+ahwBrLgdX7stKWHg7Oq0djQMZsCvRqjke/Jsl+UkwwqO7lMxVuuMNYtKSRhB8qs/grewjTlJy++kfzcRQ7MaTaQtccVtRCYm7wx3HGjFs2oiey4KtF0hthThq86ldHef/R/o122Nx4DH+5s8qy2HTo3IDKF23sDm1m/P1JZNdAg+lgd2+dO2qSL9tnSj/a4yVemBV2FKlxUFLvQNgSiLq5YSenjm7iaaNNSKBg0o4AGSya2ZoAg9L9sQooIwMvj8+gc2soB6B38y7urdm7lzJ2I7Zu4aQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rByuw7g8fTNL5lgQEbEkL3/XM6fHKBtUvsfBA8Gbyk0=;
 b=ZDqXCkkf2TPoBg3zonbfkp3I8r1OJxDXw7lh47f3qzxdAJhh7AsjaBaQEntibZ+/66DLJg4EVaGmX954J3XStdnR5gWJGJZRKCgpIOMKmLG9KwDukjkJr+aWXuRDuTKgOCC5g4ppvxEbl+jxAKusKb+leCkznAgKSRo7KrgbjPNh2L/vzbhj8rCqOWo1SYe3+gV3K0PhLwahFpMvYv77ZQ06XL7bY22A8DvxSVYgEVwwvHCzEIVUfKgoXkZCZU4MYz1WNLWatX8sgl+2fqgfbss9P66jjU1kAzM//KWTGU0d+WMjotFUm7pmJ+Zyiy3VzIXIjxn3dAM//ifyKBca2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rByuw7g8fTNL5lgQEbEkL3/XM6fHKBtUvsfBA8Gbyk0=;
 b=G+k9rZYrt496uZyaH1X1lXQTJRxHnzrC7vUliyHLarYz+EcrgYDRcFD992mAhvsZMTJa7VN7E8idfmEOWaWaBr1VdJNrQbPQC+62NAr+xaoPcDfnUw4pXzBXYdstj80IBwRd5CDFBXDrezAG2grYwbQKErw5kUoaSu5ODLnId8E=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by BY5PR10MB4242.namprd10.prod.outlook.com (2603:10b6:a03:20d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Mon, 1 Feb
 2021 21:13:47 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::9123:2652:e975:aa26%5]) with mapi id 15.20.3805.024; Mon, 1 Feb 2021
 21:13:47 +0000
Subject: Re: [PATCH V3 0/9] vfio virtual address update
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
 <20210129145550.566d5369@omen.home.shazbot.org>
 <29f7a496-f3c5-c273-538a-34ae87215e0c@oracle.com>
 <20210201132318.36795807@omen.home.shazbot.org>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
Message-ID: <4f633178-9799-20b1-1d60-30ac31145928@oracle.com>
Date:   Mon, 1 Feb 2021 16:13:44 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210201132318.36795807@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.62.106.7]
X-ClientProxiedBy: CH2PR15CA0020.namprd15.prod.outlook.com
 (2603:10b6:610:51::30) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.92] (24.62.106.7) by CH2PR15CA0020.namprd15.prod.outlook.com (2603:10b6:610:51::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Mon, 1 Feb 2021 21:13:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89870172-6bcf-4343-7e71-08d8c6f643d1
X-MS-TrafficTypeDiagnostic: BY5PR10MB4242:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB42428A0DADDAE4E53ADCEB08F9B69@BY5PR10MB4242.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FvO7jA+dSLIpA251L0L30tgEVcgHe/OGykkr9RhJi/KI2IcDjqbEJpVTmspkGwHs/NRrtJxu2Iuxktm4WlnCCILOIpmtf120pu9KN1RN+peFnWOE8325E0oycyYR/oiUHslYBZXsfxtMvnKbSXUxsWst/nmKZCGwoMxOwzPKBA6pfz/8vPJSJdYTdHSrQYKZI0Xu8rWXvsiyU4U3eeOJJXdEvrjBsFZ6iVlSI/x3g3rZNnbYnPjTFTSsjAgO1yTJh5bvv98VnGBeU/3OLgyDiqtoXUL7B6xSF/m0PbKyIkPloKfCBNHvskqcUvfyWEZbM6FYwCxnzXD7UZWZO1eVXc6UKpwlRTqsSgbQ2MRbNOzhMzOfuaYjCLCg85p9ri1w8ylEHLkfi6WNGmDvoxEsbOdbFdK87iH3xPuJ3jxOaK8NR1VXuVWgRnTfzek6ztecjxVFuZj2LUrZRyjVrBeSvDHgoDjSFczslsPbMTlJlHXSjHkKMiim+TqoJU5d5nzZFTpSZ01gQvoAmu/LTNqHnS7+Fm5rzSFdjTxD13WssaG8apVDh3hoZxelsxi2dIPrQd9tcx8AwPRge70ssDIYCruT+5BXghhG5oo9u+FcqkqmHHaYqXGpYSCQZ7j1vg+MQsnNC55KKFcjQ/qTi8xAP2D0stEroHURyCOWifjSxo3vClaHbXYeG111ze54+CJo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(346002)(376002)(39860400002)(956004)(53546011)(26005)(2616005)(16526019)(31686004)(186003)(5660300002)(4326008)(6486002)(6916009)(83380400001)(8936002)(66556008)(66476007)(966005)(478600001)(31696002)(36916002)(8676002)(66946007)(44832011)(36756003)(54906003)(86362001)(2906002)(316002)(16576012)(15650500001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eTVzQngrNndTTis4U0pKMUtpVFErWkZKNm8vdENVWTlHRHdvZmZLY3l4SW54?=
 =?utf-8?B?U2EwRDAraDdEajhoNFVLLzZESHl2c3JFekhCdm1ZN0JKYWJaZDhNL2I5ZFdR?=
 =?utf-8?B?QzkzS05xMmd0aEkreDJsaGZwWUg5Zy9zdnBGU2dvOVlRRXNkRDEyWXZRSWFI?=
 =?utf-8?B?RTFqM3NzMWdMTFl0SUJaMGR3Nkp5cEMxcGg2Sk1CdnhxWHNFMGNaTDNFVFQy?=
 =?utf-8?B?MWgvbGJUNVluMDBsWndOUnZKV1M2S1dKdVhRYmg1VEsxbjAyNC9zakVYUUgv?=
 =?utf-8?B?b1E0UnAranZYdWh1TzA2c2cxRFp0OWlsZzZXSnRwSmtZeEJ4WG5oelhGMHVo?=
 =?utf-8?B?T0d0bFppL3dWZnJQS2ErQkpTNUJaaHVmcGJmdXNkQVpHdThGN1p6QzFxZU9L?=
 =?utf-8?B?REdDcVlObzEwdmI1cEVxNm5kVVBLcjM4VVpFVEhRcmhMcjZFUUZUNkdOZkMw?=
 =?utf-8?B?R29rVks0N2F0bXhmK2NaQ0hKUlpYTFY0UlNOTGhIRHAyU1lsYk96VkxZTUN3?=
 =?utf-8?B?dG8zZUY1SFc1alRjZjJNYzJDNDlNWk1LaExqQTF4TFZpVlFWQXIxNjdqdDc5?=
 =?utf-8?B?SDJxR3BXWjA2RXpSOGxLL1JpM2RObEVNMUlKM3VKaFdvTCsxYlBJNUp4bVJn?=
 =?utf-8?B?cHNXelFTL2ZQZUJpaUpmaW1YWlNRZFNkbS9jV0U2eGJleFlTNy9WZjlPSXlI?=
 =?utf-8?B?V1BLY3BnY2t3aGZ5NUVmR0tEMUJyeDY2Ulk0UDNNSmpIcnFQbWdIOFhiSWJl?=
 =?utf-8?B?RGpadmJUZ2llMnVFdHJOSVVkUlh4cUwxdE11emxHNEp6dDJBQU96Zm4wWCti?=
 =?utf-8?B?QmRXRWxjNUprVHRTWU1zVTNOWkJkeXpacE1VVG1na2cxVG1PTThKTGlQZWkv?=
 =?utf-8?B?RTlGc2Y2bXhlRWdtc1pjbTVrNzBXUVJMMEhuUWViV1RLNTBGL2haRmZnQ0xX?=
 =?utf-8?B?bW1mUlNUWCtKSnVFZ1BHTlVQRURvQlpCY1BTZnlsd0RDMXJVTXYwZWdLa0dh?=
 =?utf-8?B?d0RKMUZ4UU15TDE0MEovN3A4elZDN1VTdm1RcXNYOEpnT0gvSVczYkpkM0pS?=
 =?utf-8?B?VjlpN1VGcGhrZlVFNHZlaFlVNloreldjcjd1UzJIdXFMYS9pQ3JiSFdCQlcr?=
 =?utf-8?B?Q1hvRUNuN2tZSUd1cnBpMFR5SHVacE9HSHpjaFh2QldBcm4rZm5oK2RZc1lk?=
 =?utf-8?B?c0cxaTY0M0ZVaHpDVDFNWW5oQnNXUDlrTzdldGUwQnZnZVM0ekQ0aHRSejA4?=
 =?utf-8?B?cVVrTlp6dUg3UXByV1BwT1hZOS9SVXlvamlWWGZRblduNzVGNWo0eWVDakl5?=
 =?utf-8?B?TVJibVRIdnBxc1dobHhuQktBdElRNXBrcnBCQ3pxc1E1NVZjNHZ1dW1SeEJP?=
 =?utf-8?B?c2dLaVAzMkxsR25EaVJ2OXI4OXB6R01mYjlCRE85ZHQxdU5mWDY1SEk4TGN6?=
 =?utf-8?Q?bj8ov6Az?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89870172-6bcf-4343-7e71-08d8c6f643d1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2021 21:13:47.7850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +gTsQLh0QblqMfeBwt4SBoccTmSiRjzxXAuKNYAC+BCpKj5Fh11pwvjOl/sU/F45myLtS9oC04+TK7wZU6Lf29Lj/LbSWl5JWAdXGwS7cV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4242
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010116
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010116
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/2021 3:23 PM, Alex Williamson wrote:
> On Sat, 30 Jan 2021 11:54:03 -0500
> Steven Sistare <steven.sistare@oracle.com> wrote:
> 
>> On 1/29/2021 4:55 PM, Alex Williamson wrote:
>>> On Fri, 29 Jan 2021 08:54:03 -0800
>>> Steve Sistare <steven.sistare@oracle.com> wrote:
>>>   
>>>> Add interfaces that allow the underlying memory object of an iova range
>>>> to be mapped to a new virtual address in the host process:
>>>>
>>>>   - VFIO_DMA_UNMAP_FLAG_VADDR for VFIO_IOMMU_UNMAP_DMA
>>>>   - VFIO_DMA_MAP_FLAG_VADDR flag for VFIO_IOMMU_MAP_DMA
>>>>   - VFIO_UPDATE_VADDR for VFIO_CHECK_EXTENSION
>>>>   - VFIO_DMA_UNMAP_FLAG_ALL for VFIO_IOMMU_UNMAP_DMA
>>>>   - VFIO_UNMAP_ALL for VFIO_CHECK_EXTENSION
>>>>
>>>> Unmap-vaddr invalidates the host virtual address in an iova range and blocks
>>>> vfio translation of host virtual addresses, but DMA to already-mapped pages
>>>> continues.  Map-vaddr updates the base VA and resumes translation.  The
>>>> implementation supports iommu type1 and mediated devices.  Unmap-all allows
>>>> all ranges to be unmapped or invalidated in a single ioctl, which simplifies
>>>> userland code.
>>>>
>>>> This functionality is necessary for live update, in which a host process
>>>> such as qemu exec's an updated version of itself, while preserving its
>>>> guest and vfio devices.  The process blocks vfio VA translation, exec's
>>>> its new self, mmap's the memory object(s) underlying vfio object, updates
>>>> the VA, and unblocks translation.  For a working example that uses these
>>>> new interfaces, see the QEMU patch series "[PATCH V2] Live Update" at
>>>> https://lore.kernel.org/qemu-devel/1609861330-129855-1-git-send-email-steven.sistare@oracle.com
>>>>
>>>> Patches 1-3 define and implement the flag to unmap all ranges.
>>>> Patches 4-6 define and implement the flags to update vaddr.
>>>> Patches 7-9 add blocking to complete the implementation.  
>>>
>>> Hi Steve,
>>>
>>> It looks pretty good to me, but I have some nit-picky comments that
>>> I'll follow-up with on the individual patches.  However, I've made the
>>> changes I suggest in a branch that you can find here:
>>>
>>> git://github.com/awilliam/linux-vfio.git vaddr-v3
>>>
>>> If the changes look ok, just send me an ack, I don't want to attribute
>>> something to you that you don't approve of.  Thanks,  
>>
>> All changes look good, thanks!  
>> Do you need anything more from me on this patch series?
> 
> Here's a new branch:
> 
> git://github.com/awilliam/linux-vfio.git vaddr-v3.1
> 
> Extent of the changes are s/may not/cannot/ on patches 1 & 4 and
> addition of Connie's R-b for all (rebased to rc6).  If there are any
> final comments, speak now.  Thanks,

Looks good - Steve
