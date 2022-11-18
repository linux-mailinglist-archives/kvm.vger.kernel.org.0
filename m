Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4E662F01C
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 09:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241579AbiKRIwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 03:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241608AbiKRIw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 03:52:28 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1726455
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 00:52:25 -0800 (PST)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AI1kqUW009949;
        Fri, 18 Nov 2022 00:52:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=kq+sVHAxJB0JFJ8ATmskVGksDTz53o1sClY7905H9WY=;
 b=IN+saeUYD4+yDVIfgD+6DQCwYxO1qToAbsfbhIBBYHOyA1M8AfAmjJzo4/QNqoU2/t1b
 BIAZ3kbt9MJcPIJpEX8hisj3L5ZbPPdVeYf/JEfWC6bFF97yGjldaa1nxkgtjL3uYoAm
 MA0qDuUQSW3WaQzVFOEFMafyonOR+Ddc51gly6P0HajU8zzk53mvoIMZiOz7UNM5W+GZ
 wEc8I6RMHsgvle8jNvSAsLnWYyME6mGuDzpxEsZlru/9FZltaWEVRypWhd4+lVH+jRti
 GWztrTOBTU7o7/ewaX5IyqeW/CpIUeP43XsNzsSIQQizQsSzVXZTzOOL4z76M1WsxjX6 hw== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3kx0p5gn0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 00:52:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VwnRENTTvq2Yw19YXMWIXf4H8bTZ6stmChrA/jFC6UEbDoifpejZo8UZjEJ8GGUlPGWDojC82h+45tNXv/ToScX8q9JnFLIis50ajoyRL9j330IDSP5+uqwefJSSDsGNswtC978FfmTWgk3yJ8BABOR1GL4sG2JXgZOcbWpEYEEnFGBjQB7yZuC4g4aClgVM5nNTpbTSkPFa50l3FLJDfKBF04gZk5oNA17AM+7osAQqF8EIRRZw1tQVi6IMcC8MJaqFQtYY0fYfb2d/AhaS1hSEw+XKIBLVs0NbMl5NoUUuRza4K6CgGkPNtp35g0/xmfny275qGKzMwNlf5nsT8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kq+sVHAxJB0JFJ8ATmskVGksDTz53o1sClY7905H9WY=;
 b=b+tY4glGFPDdqtKP28Vx9DpRt5nbpccTBwU3IY1xQCjtV9qK+k8Mwx8qwX8WjsyjmwI+WaWXzcnWCIlSeDC1pnXhUFQFyewNbL2GZWZ2QKdkwke0wrlpNV5uCB6QwPLRveuZqeymJelLkwsoUwIoTOii5Akp6Nn3apXPuSjWpHf6zfnustQGTGdd9DxQXozlRKX8ttIUXINenm/wKqpamnms2Mugv7JPRJMCS80DpiyFpsxFw5Tv4kMMkuuqxIFxBVTGsaQ80ioSWXgPQElza+BexfXb0CoFpXj4Ddw8yJotvOSrU0PLp3KvWMZ8P4BPvuDKSUAOkmIJT5Iry6xxuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kq+sVHAxJB0JFJ8ATmskVGksDTz53o1sClY7905H9WY=;
 b=FZ/Wd/3FU+cJmyC7FtwjHiFHtwvz3/00VlMHIKxyUJ4C/bzemLXUKd/huJWVZjNAaRu00Y7cQckdG5vvqqYSJEOsBnt9RTHwaUAHzOY1yJuR123U0ZSjk7A/ZZR+hampVN/1k/VuKfATF657GjiYHhufr9GmM+qOMP5x0eOrQVIAymovYvBCXjPMJ4X/+k3BR2lvjZL63aUkl70MH8vzvAC426Ktfoy3GSMbuBWJtWz+oMmoHC+8e1I6XPv2tYU88F/RJxRKGNe9m59cvC1hZTKFzk4H98bgFCX6FU+EscFIpwX64Pg4yWYsC9ezNGz5mVp5aKG0UcBGU/YGnrZ0Fw==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CO6PR02MB7811.namprd02.prod.outlook.com (2603:10b6:303:a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Fri, 18 Nov
 2022 08:52:05 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301%6]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 08:52:04 +0000
Message-ID: <503893dd-f8e0-f58d-51a8-3e8062966ecb@nutanix.com>
Date:   Fri, 18 Nov 2022 14:21:45 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH v7 2/4] KVM: x86: Dirty quota-based throttling of vcpus
To:     Yunhong Jiang <yunhong.jiang@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-3-shivam.kumar1@nutanix.com>
 <20221115001652.GB7867@yjiang5-mobl.amr.corp.intel.com>
 <176f503e-933b-f36e-5a59-6321049df8f7@nutanix.com>
 <20221115064547.GA8417@yjiang5-mobl.amr.corp.intel.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <20221115064547.GA8417@yjiang5-mobl.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0014.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::23) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|CO6PR02MB7811:EE_
X-MS-Office365-Filtering-Correlation-Id: 56946468-7fac-439a-4a97-08dac9422a81
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0CGX9j50Z+of8KX1surdDaC9MFaBcZ9VZXiT/yiWpYFYVqkLvU4e01fQx24gKD/sGbqVuIqx5R6YwhTLwcYXa8eRqLOLEoaqSrZAvJ7MXFP9GJJHjeFaagVsBIu/q63ker+fmgyl8+H/zFdZrxuyqScZJtpjkYeDW8NMSKc9mtpvAOXkKDK0Eu0Gb3nGjst49dGnF7oomd07MsYNubbNQXsmvle7y+dAmQKmfnRidDstbOq2Ue8tkcz8l6JwxLvUTKIvituVqj0QIBdUXjGaBEDCpffiYaWRbN8Q7vN6lUIyyXmp6E7lOP/9Z2GjPv8wHgGpDJ++smaRSW6e8cBV5ORT1EYP4EZYy2SP9cU0FgqFiZUa1T7mtKyENxEnS6o4P9QyIVuKfQ7lTxIbvzDGrVQS+pyZEpK53jdyPg6KBKdSFf9YIBP9IOFBiYzd7B1sxID4ajSLssdI65199NuBzkrnz1hdyjo4sX7mbmUrA7lK+pvq1bLvln1QoZ7zsnB2qKYGtrH0xDbwIi8OBoEBL29qOrWt+t3eb5z/lHzlCJkMQA7c29ACCJ7810v0dYiniX1IYUNu4+FZHWIK1FxJE0stEX/RpnA06Mrfo6O8KD4cWSTbCirYrU7mAjsB+AD4l3GGd2XGm9rXirHANcEm1XrifWmWd2YEdcap5JonnyH327IyGTPlZnJApphdh+WpF3YVAfgocIrzWihJW0gCVQ2GwjiE4mbLc3Hq8baI2fFlfHcwwjr18uxt+JzuTBVm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199015)(36756003)(31696002)(86362001)(38100700002)(6506007)(53546011)(54906003)(31686004)(6916009)(316002)(6486002)(478600001)(6666004)(107886003)(5660300002)(186003)(8936002)(83380400001)(15650500001)(2906002)(2616005)(6512007)(41300700001)(8676002)(66946007)(66556008)(66476007)(4326008)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckNWczJVU01JTllPVGtrTEhobUdxMFo0NmJNSUE1Rzk5b3NlUjRnOXlGTXVQ?=
 =?utf-8?B?a2tUQ1habi96aUtGTmZlNTRETE9lOTFQb0djNUNxeUd5NEFFckpzdUlCSHVk?=
 =?utf-8?B?cFUvU1RUa0dCQ09JalVncFl5aVBuQ01sL0lRWnQyOUgxVU1YVldVUnV0d053?=
 =?utf-8?B?RFRlSysrelZ3aEJSckJPcmhDVDZaTnVnWTVrUG5yakRGUElrK2s3a2FkK3I1?=
 =?utf-8?B?dUtWSlpKSzVJS3VHdStGWS85dVVNWE5zYkVaNzZBTnIyNFRLbUhZN21YU0pC?=
 =?utf-8?B?MVdVT0lrZDVuUnVtbWt0c0NKNk1zcHVCVFF5ZHJZNHFod3hXUnZBRW5vcmlT?=
 =?utf-8?B?MmlPejRDWUVwWnhhSjU0NWFNMTlTRnFyNzBFbmwrMkRrOUpodklZS3ZoR2xt?=
 =?utf-8?B?VnBta2VNaW95ZDR4U3Q1elhsSHR6eldodW5odTRBVVVNUG1CeEZ0RnJLaTFY?=
 =?utf-8?B?Ry9pTWpka0JlazVranNWbjREaHZIMkN1TllnSnFwZWQ3ZnVCdDg3YjJoMWg4?=
 =?utf-8?B?M2JZT1QxUEh4QXlzOGdTMEgzS0JXSXQveHNFUzZMWXo5STFRQ1dXaFZJcnZG?=
 =?utf-8?B?YkI2MjJBc0ZjLytKaytveTNIRmNVdEhMcThUZ2YrdU5FV3lPcDdsSWkxcnUv?=
 =?utf-8?B?WjNZNTJRRWRsOWRMb25PalpicnVyMU9FaklpWkhZMFlnL1NGMTM0S2R6U2lj?=
 =?utf-8?B?M0pRQlBjNWlVYURueXhsOGxFV2Q3bGh4ZkFzbFpnNHI4S1E4VkplelltVDVa?=
 =?utf-8?B?MzEzK3o3MlBsUG5FOTlLZnRUUDdQN2NoOHpKa040YzBMZ3R1bXJoK1BrbnlF?=
 =?utf-8?B?ODgzSnZIVWpBUXRFWWZPTVNUSW1GU21Sc29RQnhkT1JOWlorUUNGalY4K3U2?=
 =?utf-8?B?Q2t0UXFvSi9OQ091bUJOZGl3V3VFSXozQUFiV1JBenVVNzIrSzQ0bG8yeitt?=
 =?utf-8?B?bXRvakxqdGt6MWpGdEtlb1lqVzRxM2dlZy9FckJWR0MwOW1HUVdZMmxCOG1R?=
 =?utf-8?B?SWdTRGN1a0NxT3ZUMEV6RFh4eW9Xd2x3MDFOdGtiaEg1L3hoTVVzOVJWdHZH?=
 =?utf-8?B?RllBK2pHZS85WlY2Q2pZcWJUcmttZEp1Z1JxZ1JrNWZTNzJkZ3dHc1doMlpU?=
 =?utf-8?B?Q1lyODFZYUhMbzl2MkdueWlmUzhYUEdQSXB6R0J4b1pHZlJOV1Jid2drRzRD?=
 =?utf-8?B?a1M2MkpVdEFBeDRUWG9KQnFrWU1wblNQS1RqQUF1a0ZFUWgzNzJyYnNPTWJw?=
 =?utf-8?B?VVdaa1VycFFLWDJkRGdDNGNHaFo3Sk9xNHUxcGtXNCtoZGtoSmNHWE9tY1Ev?=
 =?utf-8?B?OERnL1AwSmpNb3kwWU1yeEQ2Sk1zNXR1Tlp3RGwxNU5xSk1jUWxHMG5MK0VQ?=
 =?utf-8?B?b0kxc3N6UTdXK2NEWUhXeXFyMmRQZmE0MS9GZUh0NFlOaC9LcHR0eDRsQjVr?=
 =?utf-8?B?V3dyOUltNWdhc2NvdFFBb3VtSnBlbW16NDA2NVIySmdIdWVXSGhPTnltU3Yx?=
 =?utf-8?B?R0IzS3FUVzExY0FXN0JlTS9NNys3aW94Z09lL0Y4QUV3TUNHQVhTYUZOUXlt?=
 =?utf-8?B?RExRMElmNGFPWTNWdlQ2UE1sWCtUVkRYbFhRQWZ4U3o0d1dRRHZhcDMxVktD?=
 =?utf-8?B?NWhONFozcG5nUXlxcXFPVHNYYUZESVR6Vi8zNUx0dkViSUY0KzZFbE9PMS9I?=
 =?utf-8?B?cVhNZVJEU3VFSzFSWDJsTUkzVnhSNS8wMWZBUVliaFI1QWZrWmcvRmtpUXpV?=
 =?utf-8?B?TTlseUxjemk5bFFHdnY4ZXlVanQxanpqQmJON0kwcFBoajg0WVFaVElnLzRH?=
 =?utf-8?B?aHVnRC9FVzBiWUtCVGpLbzZJRFRxemdxOHBlNGl2MitTck5NcmJpdlhQZjBQ?=
 =?utf-8?B?ejFsZGpKYlJCQ0N6WTJ3Z2VVd0tRL0xocFhuSFdQYkduODJzV25aZVJtOWc0?=
 =?utf-8?B?WDk5bnJ5Sm02VVVtWHBOdHZ3dkdEZkU5TG5NSFBkckNKcERjeTMyS3lYdXl6?=
 =?utf-8?B?Z1d5YjdDU05ycHdDNk9ZQmZJZVdGQTJ4RG1BMUhSUGlGNmNRMVpubDF2TXhj?=
 =?utf-8?B?S2RWYnpaQTQzTWEyUFlwTC8vRElhYWJkVmtST1dIUkpHc0drZW96eVlkSFB0?=
 =?utf-8?B?WTJOTVpseUJCelBOK2JSY3E3Y2lZRUMyQUdJbHZyd2wzYnFHYkZEQnJkdmk5?=
 =?utf-8?B?UDdPaFB0eGoxSDZTTlB3YkxRL21laElyTFF4K1FLVlErSkliTVc2MHNyYitQ?=
 =?utf-8?B?TlM5SzVYREVMYjVCcHRiRzZyc2p3PT0=?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56946468-7fac-439a-4a97-08dac9422a81
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 08:52:04.8248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7RtO/yV/N00NNHc18uESC1YvYTiBepOes5HGVn8SOuk2QzLewQerTo3ihz260Ccf3pZ4itVBbh9jFgwu859BUOOY0BBYXYZw65XSR0XlvYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7811
X-Proofpoint-GUID: 19HKfc01bsl5NWWtiE_PPiG6BUygJ1ep
X-Proofpoint-ORIG-GUID: 19HKfc01bsl5NWWtiE_PPiG6BUygJ1ep
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15/11/22 12:15 pm, Yunhong Jiang wrote:
> On Tue, Nov 15, 2022 at 10:25:31AM +0530, Shivam Kumar wrote:
>>
>>
>> On 15/11/22 5:46 am, Yunhong Jiang wrote:
>>> On Sun, Nov 13, 2022 at 05:05:08PM +0000, Shivam Kumar wrote:
>>>> Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
>>>> equals/exceeds dirty quota) to request more dirty quota.
>>>>
>>>> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
>>>> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
>>>> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>>>> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>>>> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
>>>> ---
>>>>    arch/x86/kvm/mmu/spte.c |  4 ++--
>>>>    arch/x86/kvm/vmx/vmx.c  |  3 +++
>>>>    arch/x86/kvm/x86.c      | 28 ++++++++++++++++++++++++++++
>>>>    3 files changed, 33 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
>>>> index 2e08b2a45361..c0ed35abbf2d 100644
>>>> --- a/arch/x86/kvm/mmu/spte.c
>>>> +++ b/arch/x86/kvm/mmu/spte.c
>>>> @@ -228,9 +228,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>>>>    		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
>>>>    		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
>>>> -	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
>>>> +	if (spte & PT_WRITABLE_MASK) {
>>>>    		/* Enforced by kvm_mmu_hugepage_adjust. */
>>>> -		WARN_ON(level > PG_LEVEL_4K);
>>>> +		WARN_ON(level > PG_LEVEL_4K && kvm_slot_dirty_track_enabled(slot));
>>>>    		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
>>>>    	}
>>>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>>>> index 63247c57c72c..cc130999eddf 100644
>>>> --- a/arch/x86/kvm/vmx/vmx.c
>>>> +++ b/arch/x86/kvm/vmx/vmx.c
>>>> @@ -5745,6 +5745,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>>>>    		 */
>>>>    		if (__xfer_to_guest_mode_work_pending())
>>>>    			return 1;
>>>> +
>>>> +		if (kvm_test_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu))
>>>> +			return 1;
>>> Any reason for this check? Is this quota related to the invalid
>>> guest state? Sorry if I missed anything here.
>> Quoting Sean:
>> "And thinking more about silly edge cases, VMX's big emulation loop for
>> invalid
>> guest state when unrestricted guest is disabled should probably explicitly
>> check
>> the dirty quota.  Again, I doubt it matters to anyone's use case, but it is
>> treated
>> as a full run loop for things like pending signals, it'd be good to be
>> consistent."
>>
>> Please see v4 for details. Thanks.
> Thank you for the sharing.
>>>
>>>>    	}
>>>>    	return 1;
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index ecea83f0da49..1a960fbb51f4 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -10494,6 +10494,30 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
>>>>    }
>>>>    EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
>>>> +static inline bool kvm_check_dirty_quota_request(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
>>>> +	struct kvm_run *run;
>>>> +
>>>> +	if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
>>>> +		run = vcpu->run;
>>>> +		run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>>>> +		run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
>>>> +		run->dirty_quota_exit.quota = READ_ONCE(run->dirty_quota);
>>>> +
>>>> +		/*
>>>> +		 * Re-check the quota and exit if and only if the vCPU still
>>>> +		 * exceeds its quota.  If userspace increases (or disables
>>>> +		 * entirely) the quota, then no exit is required as KVM is
>>>> +		 * still honoring its ABI, e.g. userspace won't even be aware
>>>> +		 * that KVM temporarily detected an exhausted quota.
>>>> +		 */
>>>> +		return run->dirty_quota_exit.count >= run->dirty_quota_exit.quota;
>>> Would it be better to check before updating the vcpu->run?
>> The reason for checking it at the last moment is to avoid invalid exits to
>> userspace as much as possible.
> 
> So if the userspace increases the quota, then the above vcpu->run change just
> leaves some garbage information on vcpu->run and the exit_reason is
> misleading. Possibly it's ok since this information will not be used anymore.
> 
> Not sure how critical is the time spent on the vcpu->run update.
IMO the time spent in the update might not be very significant but the 
grabage value is harmless.

Thanks,
Shivam
