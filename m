Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30195663EE
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 09:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiGEHVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 03:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiGEHVe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 03:21:34 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A989B487
        for <kvm@vger.kernel.org>; Tue,  5 Jul 2022 00:21:33 -0700 (PDT)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 264H38l8014576;
        Tue, 5 Jul 2022 00:21:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=yyKav4J5a8tUGbhQjrWelc5PwyAhb2gJyrlFGrKmYfY=;
 b=QtgbftHqeqkeCaD/ak+pII7UfBg79ZJtdRMIcpmm1QKbFBHV3shLVo1AFYN3C95Qkr3o
 EPTaPCDjL/9uoYlMPhsJpX/VUm369uMmBPQVi0HhIHiixan9kiLS/Uk8WvJ7bl+bPvMI
 jVUXxC4E5mw4i4qOB9fQrKVQfhd/lOZpySCHcPIVI9K11uBnLF7Ug/qzYWBqTRLtt6tc
 tOM1C8yQQAKd9QMFB2VONkbsvVwSYKOyKkCErsfMAaFGkAeqlS4ME14R0Sn3XrV/NPgH
 m1BfGIzeYzZCf93LFnJdw6+Iv/1GB3KKJV/zW/vYPRhaCmLD8ohMpXQlWvbsfHYEYcOo LA== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3h2kj9vu34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 00:21:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewBvdBdlEwhX8Rkeg/Xd9oYyLoxFVxJxVwLHJRnoDUN6eOLQvKglM7z3H8p6nfD80LL8rYTzDfiJgCxNU9aMlFC0ltK5uLF6HUnNbOhnIrk37De88FDZ8Xl90JUT9+0Mq8LWMZnTSThmutFoVoxqeRUaRHy3aVdJDdPVPyMm6qvVsR8Uh2h1rB2DMw3JbFXCoa/cyU6CpPsy9VOCeP0xrgu4ombygjaLV91MLg9lCPT/8Fqun5F4IJc6WG15p2pW1nyyyRy9CLEDS87ZXFBHcjB4gvw+zJilIo8tcenOK7ax/sxT97HyTTFcg8ikLTiDtKj/X/YoDaKrhv0vb3hYZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yyKav4J5a8tUGbhQjrWelc5PwyAhb2gJyrlFGrKmYfY=;
 b=TO4kOtZ0UljWZZ3IqQesi+ZUdcXbvSGbUUm34hP0ZNYYQDq817eI7njOmdxci8EJJJxoGhkSqevXe8EzkkKSKGBlrmWZSLkwbMO8yIitE9YvRw4Uu/FuWKgFefBaRxH4SHS6bo+7L3rYbPWQ1VBekJdUWq1AlTRX3vYJPOEDtKkTzVVLqqWJg9CVJ2VKoQSDUo/GYJIile2YLAAcNpd0s/0S8R6a6qrNn5bjaqlPX20qJ6HG2DVbGS8ADxURDf7cNWzIkaTvCt5qzhfdHbXhqrdEBRZESrffGAFcey319fIskcGzy44TfGUV6B59An+TCuBt88kW8ywZNZL08awmJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SN6PR02MB5024.namprd02.prod.outlook.com (2603:10b6:805:6a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Tue, 5 Jul
 2022 07:21:13 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bdaa:983e:1fef:b2d5]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::bdaa:983e:1fef:b2d5%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 07:21:13 +0000
Message-ID: <2e5198b3-54ea-010e-c418-f98054befe1b@nutanix.com>
Date:   Tue, 5 Jul 2022 12:51:01 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v4 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220521202937.184189-1-shivam.kumar1@nutanix.com>
 <20220521202937.184189-2-shivam.kumar1@nutanix.com>
 <87h75fmmkj.wl-maz@kernel.org>
 <bf24e007-23fd-2582-ec0c-5e79ab0c7d56@nutanix.com>
 <878rqomnfr.wl-maz@kernel.org> <Yo+gTbo5uqqAMjjX@google.com>
 <877d68mfqv.wl-maz@kernel.org> <Yo+82LjHSOdyxKzT@google.com>
 <b75013cb-0d40-569a-8a31-8ebb7cf6c541@nutanix.com>
In-Reply-To: <b75013cb-0d40-569a-8a31-8ebb7cf6c541@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:97::21) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5be1eef-3b1c-475f-277b-08da5e56f0c3
X-MS-TrafficTypeDiagnostic: SN6PR02MB5024:EE_
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MWuA8irytCswKIlul7y9U6uU5RN6bylZ9vYn8Jndfo1MZBHLGipsRZzLeLkz4xoVbPGJHXcyz0VMO+Voj7gZUwaF8iHIkN6NAmdqN1WXjeppXcvUsjEtelm4CI/e0qPUoF6VIrK1NTFGPpwcS0CupsaHvKrFO2o2lRMEjUeIkf9IycwPe4YKCkGZTqoNYkiEALjkCC7FAj5vfID2GHPpMDqgWNXvE35AK7PjbAkWIhSp/XFT0av9tDOtTrbu0anbJkgCxt6qFH2y5KhJ5VZARAYR0aIdH2n79FbwCfnVpqvSXd54TC0KgFt+8YjKgSLjSwU60LDyV9f6lK6NdqtysHMV02FU8QFXx73NKGZvcFNr50AcWU1s6+U3XezmCpVjPkCCH/DL4ZEIpA+uh29CkUwTEHrWHVOd4NeAsmgngPSlrjcsYrVB5VzmaTVR1AaL6CJGsO6GaIkOzuur05t+cEMXlFLF/p/k2BQJ2nAD/qU9UdcdiZt5S8R6RVol6U6wuGr9ZQOqeAmtyippumc7Ymxg7jdl+AU0MzgccwZ9afisQvgKXyC+lU6AmxOlUSt3ngdT2RPpoRNZUy8TECIL3gwbjjO/vgEfz2/U8YoKZ5qJedn6rUsqg9W2a6n1BCAxCOrYYBPbC/9c96ZJGhumOvcy+mfZfE4m81pKjDDszG+1Z02PvKTVwhmDICqKI5Ee4kpKW8IkljRHqNuQKwhVoH2HOC94tPa7Wy3RrK7Ntz0IvOcG5aOlghN4rTNXv6SrYPpAFdW1QWLd72/ZHQgcYXqnulPA7iP7mulg/4dz6MKdoSDPq0viGhJaeKfc8XcLNNFS1XuZX8gWVKTQonVw9m0Ru5Jt3aD0p+6LjNXN64ZjoT+S42wqOLBjH+ZQHqjP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(366004)(346002)(376002)(396003)(2906002)(15650500001)(6512007)(31686004)(6486002)(186003)(478600001)(36756003)(83380400001)(31696002)(86362001)(316002)(53546011)(6666004)(110136005)(5660300002)(66946007)(107886003)(4326008)(8936002)(8676002)(54906003)(66476007)(6506007)(38100700002)(66556008)(41300700001)(2616005)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUNVUGhSSWxXbm5LYmhsdGZocC95a0FDYmRnM2p0dGJhMUwyR3hxVXpCZnFn?=
 =?utf-8?B?NWNxaStuSm9pMFIvVjZpTFNKdldNeVZHNFBzQUx6b25JQSthNW1WWmIvMnRo?=
 =?utf-8?B?SGx5RnA2OGtXQVA4bjZYL2FjUGUvNGpzVFJOK3NRNktXVFpFVElBWUpnMWtW?=
 =?utf-8?B?SlJCa24wSmVseEN1RzRQYjR6Y1JoS215eFFDa1BzL0tQUVR1UUExa3pKd0lm?=
 =?utf-8?B?Q0poVDJzcXR3U2hndmk5dUpic2NQTE90VG1vK2pabitTV3BzbUVrVWJmWWg4?=
 =?utf-8?B?RkpvRTJWaUNHTnkzVlFwQVpaTzNWeU95KzhrQVBxeDA4YUVnQlNRbjdqSUpC?=
 =?utf-8?B?NHNwSTNHRnQvTVhMK3ZUdU9tOWhiaHF0aVlmS2hBdTlxb3dQREIzL1BXRitz?=
 =?utf-8?B?d1RickJ1NVFYZUMra0pmMHVIWWdTVkxPckwwdzRxNUlmOEdmeUFPeXhzTFVw?=
 =?utf-8?B?bUZoQ0pHMGdWM0VmZlUwTWdFMURkdTJpNnZwb1lVZ1kzZzNSaHh0TmR2OXlt?=
 =?utf-8?B?N3BTQlY4R3FQSmdTYW9CUDkrbllnb3lIUm1zcEtrdExBalhvUy9neDliQWts?=
 =?utf-8?B?c1dwWHpnYkJuajV4YldxTTZjUmlEbEZSZHhVd1BlY0gxajJVL2RXeFFMS2Jr?=
 =?utf-8?B?a3V2RHlQcXVXMkFmQXVqYWhIN1VLUDk1VElaRGFiK1lZTHI5MzQ4WEt6SmFk?=
 =?utf-8?B?U3BOVGdnd0dCVXo5YzlXZXRWeEo4Rk9lSlhwbUNReWpvTWpRYjYxcjZYKy84?=
 =?utf-8?B?NjFvYnFZVWxrNU5hUFVqaDdrQk8vZ0pVWVg0RHMySEY2bmpkK0VDcVNMT1lN?=
 =?utf-8?B?RWY1czNlVVFGSWZ0TENuQnFJTVFxbjZHMGVpcVZnMjI2NHhRR3hXdDFmdm9q?=
 =?utf-8?B?bVRJYzdFaFJHU1NncjZoSk5KNFFiZ3FqbE5ONTJ0MHA0TThEMDR1b2RBMFc4?=
 =?utf-8?B?MGdXMzFjSnNkQmNqdzduWjJqaG5wRWVVczhQMFhDL00xZGdCWkVOYm9tSDZm?=
 =?utf-8?B?WldyRnFpY0FSbVlJaXp1eVhkRGgvSmR2TFVmcXExeVpadHdIVXdOSXM0bkVW?=
 =?utf-8?B?MkxKTjZ3Y3hUaHRQYUVOZXh0V3A1OFhNQ1lwWWFCdURoRDRZVzI4RGtwZ2p0?=
 =?utf-8?B?TGNrRXkxUExoOVZZVWdVdlNjUk5OaUJ2eUZpZVBoWUwxYTA0UVozcWhuOGQy?=
 =?utf-8?B?SC9pbFdDNkNtbE9mQXJZV3F6NWluMGxYb2xnK0pjNG9qVVZHUllqQmJZSDRW?=
 =?utf-8?B?QnJxOWNGZU9xT2dUSDcrRzBMa0V5QkhCcDlDOWZjL01BTEkvN09EdlFES2dz?=
 =?utf-8?B?SzlpWG10ZXQ2RUdQSnRWWVNzajJrYnJqM0ViKzZxSUlISHFFa3J5UnpqTk1N?=
 =?utf-8?B?bFVBUjVRRCtPZ3VaKzNEWFVXSWRDaW50a1hUMkR1ZjZLdzJsbjVSbVl0Y1NH?=
 =?utf-8?B?MzQxNGJQbS9FVXFQOHg3M05GZUZjNktraitpcVNYS3B6NFZaK2lWTVBPQWFS?=
 =?utf-8?B?TzdKL3ZCRHJiWU1xa1M2T1k2dEpuRnp0S3BUUUhZYktaU1U3aTRMYjNLQXpK?=
 =?utf-8?B?cnFTTUloY1lmRkZwT1dGTnJiTFpxcFJnUWxqNTlTVGNpS1VvT3RhZFh2Nk9k?=
 =?utf-8?B?RFhIV1RIalljeFh1OW9Xc3FTY3NFT24vY3VtNzZEZE5FTEdMV2g0T0piczZD?=
 =?utf-8?B?c0hTcWRIeklkTGlkcnNueExrZE9Qb2NUMlBOZGNxWllIayt5dmV2akVRbkVa?=
 =?utf-8?B?SFcvajE3aFFtKzBzd2JCdVZlL3Naa2dSTTlLUlpBSG1MSzBmU1l5TWxTd2hK?=
 =?utf-8?B?ampGdnBVN0lacWN2NS95VXROQXVFL1JkRE5yeXlhNXNOY3pvRzdPZm5XeXFl?=
 =?utf-8?B?OVY0U2xWaHpjQ0tZM3VURVNwdGhHSWowQ1l6SGw3R1ZicENCeTR3QTcveEU0?=
 =?utf-8?B?VFVTSDlVYnF1QXdLUjFkaDdkeHhneWtLVnBjMWJ1WGM3N3NhZGtra1B6ekFX?=
 =?utf-8?B?UTVPMzNJSm9rSGdMSGlLaTNxd2JvaUFMUWMyaUhTMnZIL011K0NaRmVwSThX?=
 =?utf-8?B?VUhGc0F0NGN3b25pcUJ2NG1RWE1lSFZuRjlkM0FVVUZhZXAxSXlHS1BtNnlj?=
 =?utf-8?B?anB5RkV6SHlUZTljSjM3My9UWGl6NUNHbDJDczJySHlIMkJPbnBGR2NDRkhj?=
 =?utf-8?B?WWl6WHFQL1cwNXhRK1NkSkZ5a1lOVllzSjZjVksxa0FuenFYdFdEb3BMeEZl?=
 =?utf-8?B?ZW9PK0ZjbUFKNlpCL2poV3BDSld3PT0=?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5be1eef-3b1c-475f-277b-08da5e56f0c3
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 07:21:13.0084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qRlgjbjqYAgUPCbrTD6NR7VjB/m5Qx6oKToneM01DQBFHvgLUSCoePQh84KzrAlgAqILtomDpDWjdj4pu7OaB6kTZIkO+Wxs65tSupBtorY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5024
X-Proofpoint-ORIG-GUID: kDBmJ51gy08V1u0ZnpLSYAZuf34wuZTv
X-Proofpoint-GUID: kDBmJ51gy08V1u0ZnpLSYAZuf34wuZTv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_06,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30/05/22 4:35 pm, Shivam Kumar wrote:
> 
>>> It just shows that the proposed API is pretty bad, because instead of
>>> working as a credit, it works as a ceiling, based on a value that is
>>> dependent on the vpcu previous state (forcing userspace to recompute
>>> the next quota on each exit),
>> My understanding is that intended use case is dependent on previous 
>> vCPU state by
>> design.  E.g. a vCPU that is aggressively dirtying memory will be 
>> given a different
>> quota than a vCPU that has historically not dirtied much memory.
>>
>> Even if the quotas are fixed, "recomputing" the new quota is simply:
>>
>>     run->dirty_quota = run->dirty_quota_exit.count + PER_VCPU_DIRTY_QUOTA
>>
>> The main motivation for the ceiling approach is that it's simpler for 
>> KVM to implement
>> since KVM never writes vcpu->run->dirty_quota.  E.g. userspace may 
>> observe a "spurious"
>> exit if KVM reads the quota right before it's changed by userspace, 
>> but KVM doesn't
>> have to guard against clobbering the quota.
>>
>> A credit based implementation would require (a) snapshotting the 
>> credit at
>> some point during of KVM_RUN, (b) disallowing changing the quota 
>> credit while the
>> vCPU is running, or (c) an expensive atomic sequence (expensive on x86 
>> at least)
>> to avoid clobbering an update from userspace.  (a) is undesirable 
>> because it delays
>> recognition of the new quota, especially if KVM doesn't re-read the 
>> quota in the
>> tight run loop.  And AIUI, changing the quota while the vCPU is 
>> running is a desired
>> use case, so that rules out (b).  The cost of (c) is not the end of 
>> the world, but
>> IMO the benefits are marginal.
>>
>> E.g. if we go with a request-based implementation where 
>> kvm_vcpu_check_dirty_quota()
>> is called in mark_page_dirty_in_slot(), then the ceiling-based 
>> approach is:
>>
>>    static void kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
>>    {
>>          u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
>>
>>     if (!dirty_quota || (vcpu->stat.generic.pages_dirtied < dirty_quota))
>>         return;
>>
>>     /*
>>      * Snapshot the quota to report it to userspace.  The dirty count 
>> will
>>      * captured when the request is processed.
>>      */
>>     vcpu->dirty_quota = dirty_quota;
>>     kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
>>    }
>>
>> whereas the credit-based approach would need to be something like:
>>
>>    static void kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
>>    {
>>          u64 old_dirty_quota;
>>
>>     if (!READ_ONCE(vcpu->run->dirty_quota_enabled))
>>         return;
>>
>>     old_dirty_quota = 
>> atomic64_fetch_add_unless(vcpu->run->dirty_quota, -1, 0);
>>
>>     /* Quota is not yet exhausted, or was already exhausted. */
>>     if (old_dirty_quota != 1)
>>         return;
>>
>>     /*
>>      * The dirty count will be re-captured in dirty_count when the 
>> request
>>      * is processed so that userspace can compute the number of pages 
>> that
>>      * were dirtied after the quota was exhausted.
>>      */
>>     vcpu->dirty_count_at_exhaustion = vcpu->stat.generic.pages_dirtied;
>>     kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu);
>>    }
>>
>>> and with undocumented, arbitrary limits as a bonus.
>> Eh, documenting that userspace needs to be aware of a 
>> theoretically-possible wrap
>> is easy enough.  If we're truly worried about a wrap scenario, it'd be 
>> trivial to
>> add a flag/ioctl() to let userspace reset 
>> vcpu->stat.generic.pages_dirtied.
> Thank you so much Marc and Sean for the feedback. We can implement an 
> ioctl to reset 'pages_dirtied' and mention in the documentation that 
> userspace should reset it after each migration (regardless of whether 
> the migration fails/succeeds). I hope this will address the concern raised.
> 
> We moved away from the credit-based approach due to multiple atomic 
> reads. For now, we are sticking to not changing the quota while the vcpu 
> is running. But, we need to track the pages dirtied at the time of the 
> last quota update for credit-based approach. We also need to share this 
> with the userspace as pages dirtied can overflow in certain 
> circumstances and we might have to adjust the throttling accordingly. 
> With this, the check would look like:
> 
> u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
> u64 last_pages_dirtied = READ_ONCE(vcpu->run->last_pages_dirtied);
> u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
> 
> if (pages_dirtied - last_pages_dirtied < dirty_quota)
>      return;
> 
> // Code to set exit reason here
> 
> Please post your suggestions. Thanks.

Hi, here's a summary of what needs to be changed and what should be kept 
as it is (purely my opinion based on the discussions we have had so far):

i) Moving the dirty quota check to mark_page_dirty_in_slot. Use kvm 
requests in dirty quota check. I hope that the ceiling-based approach, 
with proper documentation and an ioctl exposed for resetting 
'dirty_quota' and 'pages_dirtied', is good enough. Please post your 
suggestions if you think otherwise.
ii) The change in VMX's handle_invalid_guest_state() remains as it is.
iii) For now, we are lazily updating dirty quota, i.e. we are updating 
it only when the vcpu exits to userspace with the exit reason 
KVM_EXIT_DIRTY_QUOTA_EXHAUSTED. So, we don't require an additional 
variable to capture the dirty quota at the time of dirty quota check. 
This may change in the future though.
iv) Adding a KVM capability for dirty quota so that userspace can detect 
if this feature is available or not. Please let me know if we can do it 
differently than having a KVM cap.

I'm happy to send v5 if the above points look good to you. If you have 
further suggestions, please let me know. I'm looking forward to them. 
Thank you so much for the review so far.
