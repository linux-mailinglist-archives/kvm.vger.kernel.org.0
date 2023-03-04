Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687116AA955
	for <lists+kvm@lfdr.de>; Sat,  4 Mar 2023 12:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCDLpn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Mar 2023 06:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDLpl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Mar 2023 06:45:41 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CCC81A95B
        for <kvm@vger.kernel.org>; Sat,  4 Mar 2023 03:45:40 -0800 (PST)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3249Ut4F012814;
        Sat, 4 Mar 2023 03:45:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=nIYBw6fQ0oipUsRzuJAkwTZN49PHvJ1o4wrsReSHjjE=;
 b=uV3u3VTRLEDE4K1tMcNVKJ394HA5QweJwLPmlliGbZzJrLSN4xnTUrPBvx7gLqeVV52b
 gtXyfSTsRLUhFeXUVMGSldBddXHb9ucP/lAsVYC84goHfBQJp/Pe1t+N/+i1zrOzHecA
 4QPh12Xvf1VObfg8LkndArd9+BMpPcyNWXpQOB6GNpkOQIpKtq9UEoxBbd3syhgFq/9q
 CRqzZddNq1U6h5KADv4FD+NnlZVexjmA31jmv0T7BGShe/Y5S9jJ7MBmZkPVZEf1YfSe
 JIN0pbqx2Xgs+fEfeOU4zRTkUiQ2GbHzZoL/k2PZqS4CmSWLnzpuvB21k4fBLglq0rii Eg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3p42sdg6qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 04 Mar 2023 03:45:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ISeUeQ+Q8BRQZJn2CtzlMshLJYogzj0EJio2s3qHqsDYKzlAOEg54xSKLCgg+l7DCg2sLwSXw8EqJoEsQ5+M/49j0sM7/rTRrVPtdh5zCKZOiKcmjwz/iNlYqf0e+biRsHqE0n1FY6ZuQBZieaFNckQmfIgJGdyBvUFvdrAners55EWgUseEUagppK9ObsiHMKiH8bU+Do2BT8lft5+QbIoZyp5OsRHhwoVpv/1hej1DpHWUtdsnZCcOgSTHakfqndHE+yOHhyl5uLOvldPMlavTTXlgbPscIyWEnV7Lc5cSViZ8JdA3GHNvXzsBr0mXfPhvRz1pCnTqbinj9aLRgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nIYBw6fQ0oipUsRzuJAkwTZN49PHvJ1o4wrsReSHjjE=;
 b=gJWBpgtYOPxYtGavLEoMHxM8OMYQgiSu5Etb/FymhxywV6RQiLgOhsXDpoC0N0wuTiyzBlg4jcpwZ6Vn5TOwYOtLgI7K0UOfTuSUxoEBxZm7SUT3tQrpI9bZ+O7sxnE+tMHf/ruN8P5BTWyRYfYnkDKKse8MF59/7x5atR83VpCr6DchkdDgKPF9+zOhYXuOA9Bn+mF3bzcTF31UIW6FcqW67Y1nxTVP+3Ojc/XpsD/IyNH36XimPAc1v16PEzNchKh+myvprcq+lD4u9MUyiPvn+mi3tNcbt2N0hM2r9Geqn+bwqv4ilcnzbq6TOtJYmjfBBUi9SraxS62pQh7+8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nIYBw6fQ0oipUsRzuJAkwTZN49PHvJ1o4wrsReSHjjE=;
 b=F0RlNPgw6MJMP5Pgrd7VCPyIjFlctATki145RvCllONXMog63UhlEfLZ0V6n7qqlzxn4sk1+/+2VVqspPHkltI3JKjiS9t6YrWda9cAgzmmUTFfG7Phi7zDxQjXZbpQ7vMRfvBJzR21IboN2rCoQwv27sIoIuFoNiyVLbphEfsZ56VewKt7AnE/2mYAr4e990h126MqwQ9ZWZqEils2YJqdoz/Ii6JMLfR7rW20pza8woLt3wx2PIdRJAsMzRXfoL4XRqjrevkJOMcJ1yu00CC8w9BgTiebZiNXn4hzwZqk/D0bUztYHq6HhYtJB5cksp/a+kSH2bqrWcAIGY7l0mA==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MW4PR02MB7170.namprd02.prod.outlook.com (2603:10b6:303:70::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Sat, 4 Mar
 2023 11:45:21 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0%8]) with mapi id 15.20.6156.019; Sat, 4 Mar 2023
 11:45:21 +0000
Message-ID: <1e02dfcd-48e9-48b3-7a59-57ca541d0dcf@nutanix.com>
Date:   Sat, 4 Mar 2023 17:15:02 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [PATCH v8 2/3] KVM: x86: Dirty quota-based throttling of vcpus
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        aravind.retnakaran@nutanix.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20230225204758.17726-1-shivam.kumar1@nutanix.com>
 <20230225204758.17726-3-shivam.kumar1@nutanix.com>
 <20230228013131.o4xw3ikacrgyjc52@yy-desk-7060>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <20230228013131.o4xw3ikacrgyjc52@yy-desk-7060>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0116.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:11d::18) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|MW4PR02MB7170:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d8a2c6b-fcc2-4c4d-f17b-08db1ca5eed9
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zONLR5XkCtgJ6hJklcbOToHXJj4/0JvPZXQrnlZYdkdfdnKyKYLIjeRd4l99CnpqJG+YFw13J98NIxsjC3Ogl0m3WTepnEnEtZSuqhD4fx6f+JiCEdec1j/DUc+zwSCSc7zYe53TrXaPPtFBKdrcC4qWIfavUG3mkrFNQmJwbffVyaIrmnmbcH9CIVa+R6k7n+xoqL9+tGjPT8cFOMJ3jUg9XcKSfuoByP5XDpKM7o6PUxvSjEsZQjXQ7pDmaAiBIuuljoMHvaHPM+TMjad8ZrCQbvhMIRpr6Dc0CDNvvjb2PYgcivdm3qal0EDU2pfNdoPbD69gMJ7BBxGdzcLGLMxoakaB9QiClDMTfmhWmlIjQX0uISqW3LPaQT+kdyX8x7PtVgWFObdD3D96P290L1XgEzdmrIZ3KV+Myh9UjpIGjT3/LpybKXbE3jkT9HXZgB4O1jmagbWj7FGf+xmswGNMNhV6cxG+2n7JAhoWXSDGc899JwVM9T6cNYPzAZNREGkAr3jw6vUxpwU5ngDZhM6bU0Jwbe9BemXIXZwV/mGoZQdyex+mMNT8A+XPgA7YrvllztVWXGur9uO7r4YC94GE/p09vjcoTCnKYLMt7NPcLxfYTd7M12524bk6N6C+/0zW2vja110L/pd8dAhqPGNLupJy6L0NeZrvltFI2gvJL2KB7IwGyRsErkfOGAAWk+aPE2cnC4FosX/+jrDKAgtyoDMYJMJ05ZGabgAcUu6wtEzYN+aEcF92Osat00Js
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(346002)(136003)(366004)(451199018)(53546011)(186003)(6512007)(6506007)(26005)(478600001)(15650500001)(2906002)(36756003)(2616005)(31686004)(6666004)(107886003)(38100700002)(8936002)(6486002)(6916009)(66946007)(66556008)(66476007)(8676002)(41300700001)(4326008)(5660300002)(316002)(31696002)(54906003)(86362001)(83380400001)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SWttT2g2eFUvQnFpa3NlNjhDMElvSExndjhPdnRhV0Q2WDJQeDV3VUZ3RkVY?=
 =?utf-8?B?VlJXd096eUptczRUUE5rM3NZblhCRi9HZVoyL0pyb2hDSEpDNXdtNjBVZnFn?=
 =?utf-8?B?RjZyaHBMSjI5WDZ1QzlqNzE2SWY0a2taZkJQUyt3S1pWeEZ3L0NEQU42L2tw?=
 =?utf-8?B?UnZYWVJWVGFuc2FNRGJKeEZlSkxKVzFXZmFQTkdxSXBWL1FMUDV5VDNDeDdq?=
 =?utf-8?B?MzVpN25kTUhaVjhqQkJOaTQ5cVJtNkEzQVFsWng1TXpFRlF6Q1lXY0VRSWlu?=
 =?utf-8?B?U3VmZkhUTC9IVWFXWStNUWNubUZXbXBTSEYzTUhka1lMbmEyNlR0MTJxeDZN?=
 =?utf-8?B?dXZURXNEb0pUS3pqWWhWRTVKVlhIOFFyc0tzN25NU3ZkQnFHMWVKVWdESldx?=
 =?utf-8?B?ZVBKUkRwRTAwVGJ0L2dHbUJtM2tWNUp5Nm9oRXFRTGdYZHAvd2pBcWh6VmFa?=
 =?utf-8?B?dGRZZ3FsRXhzM0s5czNHRTBkVFNsZWNpZ3VGZmJrbDJtblZwMjdTUnBHZWJW?=
 =?utf-8?B?STJCSnBpazVCSlBVY042V29Uakh2cDhDMjdhUG1nRXF5QjhRVWkzTWd1RmE1?=
 =?utf-8?B?QThJOEFYM1BWWXpXN3llb1ZmbW1GdFU0WXc5SWhLQUltRHdIcTJiL0VOTEJQ?=
 =?utf-8?B?RWhpU1hObjloZVpyTXRQNnp2NGlEemhBWjhZZmE2NWg0U25yOE9uVUcxeUx0?=
 =?utf-8?B?ZjJIbDRKTG5INmlvM0hiNjMxVGZRM1BvejBrMlc1WnBpbGZzLzNmWC9RSkhv?=
 =?utf-8?B?VGx3blZOM3NlWTBpUW5EYXFPc0NGZVZveTFNZzRpNzVsYTJ5MVMxS0hiZUx3?=
 =?utf-8?B?OWJVUytxNHYxK05ocWczZ0NDaWdBcW5vbCtPWldjQm51Ly9UTWQ4MUx2Tlpl?=
 =?utf-8?B?ditocTFNTlhxbnR6YTBIOHZLRkx3Y0pyQWRsUDBIN1dDWGhuOGhoeUJqOWNq?=
 =?utf-8?B?dTl0TnJ5L0VWUHp1RlkvTWdzU05HZnNSWEQzYk1mNnF1WTdlY3lNUTBJL0Y5?=
 =?utf-8?B?UU5aNnhFdmxTT3UvdUlHVXRZazRySHY1NWFwNVdsOE9qN0ErOEd5RGoyS013?=
 =?utf-8?B?UGFsUkE0NVV4MzlvVzJKSVYvVHhOcVZBeGhVRk1zZWI5NThvZG1Eb1FGdmNm?=
 =?utf-8?B?V1VwS250SHpRMGRvZ2RjZ0N1UHFBMExRc29LMzQxZDlLNHBYNXR1WWVnU2tL?=
 =?utf-8?B?REF6ZlRZeUlVK05UbGRaTmx3U0UxdzhuUGFKWkwzZGtWeXNYYm9MVEZxVFNP?=
 =?utf-8?B?d2ZMT1pncGFIR2VCbTBIV0xuK0tocFd2eUxUSE1EUnVLNHZBQnduZHpTV0Ro?=
 =?utf-8?B?QkNmTjQ5ek04QkJSRlF3ZHMvZEl4YWJJQmZqZk16cFdXM3crU3M2MXRKVitT?=
 =?utf-8?B?RDZHSkNJQVN5Z2h2d3pVV0VqbldPUTB6SEZPR1lmMUtxMlhpMzN0endXNkVm?=
 =?utf-8?B?bXJGazJKdFM3dm56dDVZUXJ0UDJVdUFoQVdBVUtFSDZENjN1MFcvVXB0bXRs?=
 =?utf-8?B?Njk3S1ZJOEVHMzQxdVNiR04vZTEwVzBTMUNFemMzUDh4emlpNTRpR3ZZbHF3?=
 =?utf-8?B?QlJZdFFPeHZjcFEwdmgwOEJQMGRjOTU2TVpTYmJsSHJOS0QwWFNkWmcwZHgz?=
 =?utf-8?B?cHVNcm9ucm1qbjdYNzNuajdveHpwcmEwYTZqNlVRM1ppampYcVJ3NVZrSFFM?=
 =?utf-8?B?emplS3VJa1hhWXFmeVVHZXFlUXFFalVyWVN3Y3NUNWRxNC82bmIwRFluRCtw?=
 =?utf-8?B?b2hGVkl1OVZKTCtzK3JBazA2T0dUZ0ZmbFczN3RKT1BXOGkxRGV5cXFseHNU?=
 =?utf-8?B?WHlscWtXTmI3cDF4ZzVoZlNodEEvNEo4RTExUFIycVgwQnd1MjZ2TlY2U3N3?=
 =?utf-8?B?bDNzLytHZGhURjd4NUZTZ3phNERLY1Y5ZXREQXlkelVZL0xlak9PMDZZMjF0?=
 =?utf-8?B?MGcvakc4ZFZOaDFXMDJKRU55dU90OUpUNmYzSzV0eDdsS1NoMVRFdzloNFpt?=
 =?utf-8?B?aE5KdGd6aUdNTnU1R1c5eHRXTko5aURCN1RtSlYwN1VCbnd6Q1g1NHBTR3ZF?=
 =?utf-8?B?VEJzbVpRVFQrWGFYem1hbkNZOFhmdTlCVGFmdm0vYVdSbmM3VE1iV1o5N2F6?=
 =?utf-8?B?eDg5aHNWbW54NUVjRmd0aktoMDhTVzFuUFFFQTMvenJUNEVHSnNuR0JaODhw?=
 =?utf-8?B?QlE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d8a2c6b-fcc2-4c4d-f17b-08db1ca5eed9
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2023 11:45:20.8634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fvtVfQmU+Ttcc9PX1V65dT+aD7BS/2cS3OEEVCCTC/sKik9DbewDNb5XByNVfYLa8ap3XJa3PfdYhRkb5L1NzATNM7tj8Mcfn8qmImpZA24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7170
X-Proofpoint-GUID: POVoyqyh_XwBq3OehO6y7QWaxkK4Zr86
X-Proofpoint-ORIG-GUID: POVoyqyh_XwBq3OehO6y7QWaxkK4Zr86
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-04_04,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28/02/23 7:01 am, Yuan Yao wrote:
> On Sat, Feb 25, 2023 at 08:47:59PM +0000, Shivam Kumar wrote:
>> Call update_dirty_quota whenever a page is marked dirty with
>> appropriate arch-specific page size. Process the KVM request
>> KVM_REQ_DIRTY_QUOTA_EXIT (raised by update_dirty_quota) to exit to
>> userspace with exit reason KVM_EXIT_DIRTY_QUOTA_EXHAUSTED.
>>
>> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
>> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
>> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
>> ---
>>   arch/x86/kvm/Kconfig       |  1 +
>>   arch/x86/kvm/mmu/mmu.c     |  8 +++++++-
>>   arch/x86/kvm/mmu/spte.c    |  3 +++
>>   arch/x86/kvm/mmu/tdp_mmu.c |  3 +++
>>   arch/x86/kvm/vmx/vmx.c     |  5 +++++
>>   arch/x86/kvm/x86.c         | 16 ++++++++++++++++
>>   arch/x86/kvm/xen.c         | 12 +++++++++++-
>>   7 files changed, 46 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
>> index 8e578311ca9d..8621a9512572 100644
>> --- a/arch/x86/kvm/Kconfig
>> +++ b/arch/x86/kvm/Kconfig
>> @@ -48,6 +48,7 @@ config KVM
>>   	select KVM_VFIO
>>   	select SRCU
>>   	select INTERVAL_TREE
>> +	select HAVE_KVM_DIRTY_QUOTA
>>   	select HAVE_KVM_PM_NOTIFIER if PM
>>   	select KVM_GENERIC_HARDWARE_ENABLING
>>   	help
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index c8ebe542c565..e0c8348ecdf1 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -3323,8 +3323,14 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>>   	if (!try_cmpxchg64(sptep, &old_spte, new_spte))
>>   		return false;
>>
>> -	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte))
>> +	if (is_writable_pte(new_spte) && !is_writable_pte(old_spte)) {
>> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
>> +		struct kvm_mmu_page *sp = sptep_to_sp(sptep);
>> +
>> +		update_dirty_quota(vcpu->kvm, (1L << SPTE_LEVEL_SHIFT(sp->role.level)));
>> +#endif
>>   		mark_page_dirty_in_slot(vcpu->kvm, fault->slot, fault->gfn);
> 
> Possible to call update_dirty_quota() from mark_page_dirty_in_slot() ?
> Then other Architectures can be covered yet.

As Marc commented on the first patch of this patchset, 
mark_page_dirty_in_slot can be called multiple times for the same page, 
e.g. in the case of PML for nested guests. If bitmap-based dirty 
tracking is not enabled, we might not be able to handle those cases 
without adding an extra param (which can tell us whether a dirty quota 
update is required or not) in mark_page_dirty_in_slot. Thanks.

Thanks,
Shivam
