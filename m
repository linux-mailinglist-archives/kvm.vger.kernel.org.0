Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1BFE457760
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 20:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbhKST5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 14:57:36 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:19188 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229457AbhKST5f (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 14:57:35 -0500
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AJH2vVQ008270;
        Fri, 19 Nov 2021 11:54:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=msyVfXstEHSX3eyaIfoR9LmxSlLEi8UyuO7ug1TVmbk=;
 b=Zeq6zPytglDpNh4HKQpjI3CjitY4LjW+Ogv0IP2WfsKWagvvUJ4Y/3iZV4VgpBOLMifu
 SzLruIUBtjxVQxpLdrYxOIOkvKrn4uzZUJ4X61f1dwNrZPhhAwQPZCXoJ18W0VWVrCBl
 5vjuOU3g42jeLuvZ22HqIBgTf/ZmtGjt3sJ+CPXlL38W+HnRyGrMY5WBBUuJX1BpHCaM
 MXFtat7XSM9G1cLCbJkw1paVqWs06hscefkk2KejLp66GEeJ0Xqu2KzAhf7bLckYcGWo
 bzzA4ZvcYblJZ4CBQITdQwJjF5MV/KqdSWEHvnSP/JhfKe6bmHVh5qRwTNH5F8K3Xiwe tg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3cdywxt63e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 11:54:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dgZOB2z70wNyNs90DoKcDiayh5KDxNus3jeQkVDEThGWpn2A7JnK4ONP4NLZJIqV2tE/W0dV/23hJbBxJoY/PVvkOYDGbdYzQ+stxTHltlvRvu8HUa9poXB6Fs7jWqbZ91ugtrzOqi4jAve6upB5vnhJYVD7sHQLhAIknLVCdK+gQJfkD319ioWwQAX+xLHaZy7oZztpXyaCCyYgsT+LAkgW9R649fKB/p7+VFCdC1hDDwsm4HryMI7qPDz1GMCPV7WaGSuBsneHJ1yuVUjkVCDpn8sowazRUb8gQAHBoQaGbauEKSV27OWzZ8x7kPnY1bRZETuiHHxDFGdWAAG97g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=msyVfXstEHSX3eyaIfoR9LmxSlLEi8UyuO7ug1TVmbk=;
 b=ZHJmFc+VWWhq2rdlhGPFxH9NaBWFLqVtRpegXS4z1016UwEXLSxaRK1Fu0rygrAqRnow98Qobj56c1sakuQoBa8i0HEFtoGfwale2G+gmcTqSh/CthtFgqIcsUf7HKu6IpMnq+amiCm/O5SZrZWShdkEaWnjM6ioDR+inF3ugGjZ8kenwRT8pNmXWsn/KMeSDgJ6lv7+Hx4Y1BMdsyrIT8jTqND0dQkMYC/JMzgL16LL3pMglJQyCN1ySf7GvpVMotDSxWxGYyreqVZAVgXM6BwFKufGLmWVPyAvRPpU7C7vfs7wL0D543QehDo+HlO3Ee68eS0N8YOtix9OdAkn8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MW2PR02MB3834.namprd02.prod.outlook.com (2603:10b6:907:3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Fri, 19 Nov
 2021 19:54:28 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%8]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 19:54:28 +0000
Message-ID: <7722707c-cae1-4198-9189-923e96b2bdab@nutanix.com>
Date:   Sat, 20 Nov 2021 01:24:14 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH 4/6] Increment dirty counter for vmexit due to page write
 fault.
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
References: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
 <20211114145721.209219-5-shivam.kumar1@nutanix.com>
 <YZaR4U5r3j7zWBIF@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <YZaR4U5r3j7zWBIF@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0089.ausprd01.prod.outlook.com
 (2603:10c6:10:110::22) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from [192.168.1.4] (117.194.217.157) by SY6PR01CA0089.ausprd01.prod.outlook.com (2603:10c6:10:110::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Fri, 19 Nov 2021 19:54:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73ddb541-04b2-459f-70d1-08d9ab966527
X-MS-TrafficTypeDiagnostic: MW2PR02MB3834:
X-Microsoft-Antispam-PRVS: <MW2PR02MB3834D472C6DF8B89941DF692B39C9@MW2PR02MB3834.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNsBw9XxHPCQ6fpZ6KyAShVd8p/84ZG0P8esfsTR1ET5vmfM8XyhF08E0GWIFgg3K19lQcnauzP5HXDZkgxvScyCBSqneYZeoIoqlVCuoXdduUdTk2a4rdhAxc7fqE/Hgi7u20Nd9+gXO1L02UfVrOMwoAbcxpSOx1WswuPd8UEcciCDewGoxSYNR1dnem1WaGuNek59ZVu8L/iaqnldBZaiGvj0znLpzr24x0Qafj9+DbwGkF0jPd6JVHysAVOUqbWuVrjc5VtGoO8CSk8fL3pAau+ZUbAshodVapkzW86AJIPDDZI+uPai0lzRtJkl/kBrnNaJld8LSpWX7aag276HWCy0th1qeEwUvdfab0hC4cb/sTXgknAiPVBzSO7f5Ngvsh7UxD8lPQ5b9zjurmxe66rf5zQQjt6t4dnrnyUb0hWqqp/7nU6PsRDSmiyg6gkq+KUWiU2ZxMRS+4bbW/UpJdlhiFpppLkFMpIryXewKyoFdOXxDo9t+YVmhfgKVM7HOsATHWNGYojfb3ljEv6FPs+1ABN5BfRJMsuQQ9j3eTsfqgWpJfWPkRRs6WZk1n5he1nhFSsU78FeYqde6TCCcLFa5wkj7OSBj53ePAmCOw6LKylQ2UVYTXmbpAgfBmMJ6mDYL7VEfALoj1r7qd6M84E9p470MoH5lsMej6oQ+MZcLD9Nxv71nQuTkZYqJ1pR4bBjXkNBgmfnlNZI3ygNzGbywsYVdbm8kqLQ8DJFq5vn3nZeo0vaQYpAr7v2g8WrRidOAycygJqs04tBQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(4326008)(8936002)(26005)(8676002)(66946007)(86362001)(55236004)(316002)(53546011)(2906002)(66476007)(66556008)(5660300002)(186003)(16576012)(6666004)(31696002)(508600001)(6916009)(2616005)(956004)(6486002)(36756003)(31686004)(83380400001)(38100700002)(107886003)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHlxYmd0Z2UwMWhkWE81QlVLU3pUSkRPS1FRMm5URTc3VUtjdVRwVmlzYjg4?=
 =?utf-8?B?VHZGUStwT1Bna1lEYW9EVHV2MWRiRndpOUhmMFN3SHZ4NTJjdkNqd3FnZmxk?=
 =?utf-8?B?Q1cvYUFFNjVWZWQxYnZXZDdGREpXb3ZSL3YxVGoxSnBZdHFGVUlDQUFuaXU2?=
 =?utf-8?B?NHAzOXp0T1FMbVNBZXJseHU0L3RuNm1iNEdhUVNvWVJTRGt5ZlVsejJCYVdK?=
 =?utf-8?B?ODRHMUNXeGFiWE1vaGFIQmFlK2UxZnV4RDZKbmRZQ0JGZnNuSnl0OW5PT3V4?=
 =?utf-8?B?d3ptdHQvQXcvb3BsUVZ4aHI4bXQvWUpuZGlBREtTRDU0Qk5wR083OWNnVkhz?=
 =?utf-8?B?TUVUaUt6MW44clB4R21RY0dFaXFrTEZpdUcwdHJQUWg0TWcxU2lhRCszekU1?=
 =?utf-8?B?dXdrRjgyS3A4VmhMTnBKekY0OERjL1YyV0ZZRkovaUpqZzkvczhkK05RRVVO?=
 =?utf-8?B?WkZzeDQrQzNIWk51U0xlcmw0V1hYRmZQU0ZTVG1KdFdkQnpxZC9kQy9HQjVk?=
 =?utf-8?B?bElnNzc0ZThaVXE3VURReUEvczgyZGpPUHVLYmh3NXlReHZmOENoLzBOaktw?=
 =?utf-8?B?RFNSdFJ5RTZqaTNCUFlKaFU1bitsRTRsUHVwcjJQTHlJQXVncnM2aFBUeHhF?=
 =?utf-8?B?MjcrRkgzREFFUEFwak1JaEJFK1d6dnFRRzNQRXYxR1NONzJTQy92ZEV5a0VR?=
 =?utf-8?B?MFpIaWpOS2wvTUdzQXVndXpxSE9iT0tXOVRGYVlWenVqV3QxYUFCS0pqTG1w?=
 =?utf-8?B?T3RaMmVIaElPTEk3NzVRRnZHVlpKSjd2Zm9WVU9KanlLWThXS1gzeFdXWUpw?=
 =?utf-8?B?N2QxUEQ1T2J5cTQ4VXkwZmJhZVJQWmRXSFhvbWxKM2phYmhNYTd1UDUzZnBF?=
 =?utf-8?B?VTBnbENKYndkNHhFVjI4WW1pTUFLMnRRVjZTdFVpZU5OaVNKU3ByYUJRVm5E?=
 =?utf-8?B?TlBISVVWeHV5RG10K2hqRm4wbVBrQ1FsRjRpc0VvOWF6ODdqelZtZjJNVkpN?=
 =?utf-8?B?dDY2WmkzTThVSTUva2JhWkFxU2t1QmtVcHVCZWRva3lLTVRjaysxd21HMzJl?=
 =?utf-8?B?U0xoY0V5TWhlVmF5dm9BMWR0Wml1UDRsYXdIMTJXRVJlSzlydXRwTVBTNjlO?=
 =?utf-8?B?WGVlK3BGdTlxY2p4Y1RDck5XV0pOTGM1akt4VUJ2ZTZBYWpzQlE2TFIrQ0FB?=
 =?utf-8?B?RGo3R3RZcmoxU0JPbTBnR0YwWVNzSE9veXVNbjZTWVlYRDZRKy9jckhpMGtq?=
 =?utf-8?B?alhSbWhrWUtLQ21RcGt4dTNpTy80OE8yY216bFlLelc4WUhISExVZXR0SkZt?=
 =?utf-8?B?dWU1VXVvMXhxNG5ZUHF4TVlKTnVlZEpncVNRQkRSRlVHaUdTQUo3MlNMSmkw?=
 =?utf-8?B?cHY3V2dwMWF4NytGNjd0dDVveHQxNHgrRU1IVHlSN0o2VUNoVkMzYkE5eS9w?=
 =?utf-8?B?dlYxU0RlcnVRNWtTUTB6cElkdC81SzMyeVlVc0UwYjJTTldmWXNyQ1NJVEtx?=
 =?utf-8?B?SlJuYUcwZnlHYjlGbmVOa1I3U0RsSkdqdjRsTi9JQ3ZMSW0yTWE5eWNNMWZB?=
 =?utf-8?B?blNyc2RrY1Y2dlFsR1pWR0l2dVdpTm1QV0J5Mnd1TmIzYjR6RUI0R3czZHBq?=
 =?utf-8?B?d01NSUlqS1NVMkhZZWVDTzZrcWhjVDRpRGhrMUlJcktpeVFMS1J0b0VGOXNQ?=
 =?utf-8?B?Z2g5eFhDYzVDVWNROUJBNEFGcjU0NzIyYXAvSzA2MFNlN0hNK2xiQlE0MHZ2?=
 =?utf-8?B?Y09PZ3MzeThHeWNPVHlRYkppYkFzcFA0M0FmRFJHeGsxVzYyLy9UaXpocklq?=
 =?utf-8?B?M0l3L2pickFnWGN1dUx0SUJZSC9EY1A0ZUd6dHFlbnpZNFZIRFdaVzI2RWhW?=
 =?utf-8?B?NGNodFJBSzZ2RzRvOUQ4bnJUeGxKTHZtVko3TjRJa09CSU9lVkVlb0EvN1kz?=
 =?utf-8?B?Q3BsLzM2c0xhRE9lVEpVU2FWUDNQcjJtK3B6WFJ5RDJKdCtUWm1JUkR6SklY?=
 =?utf-8?B?cnUvTkxlMjZJa2lvN1V6cFdoNlU5L0lEYVVUQXlvdlV0MklRNHdSaXUvYldh?=
 =?utf-8?B?ckErOUl6aHlQaG5sRVAxajh5azdNajlMZXYwY21PR1o2RUVpTWNteWVzMmoz?=
 =?utf-8?B?TThGeXdGNHJlREtiWFBhZGhxVmswakR1VWxtcWY2QStSSVUyaGdUeld2bDJy?=
 =?utf-8?B?NE1DMFliK3lUODZ5eXQ5azRkMzFlWHBPWGU4dVQrVjllckJCR0VEUlRXekl3?=
 =?utf-8?Q?LB64v/CKxFnLxjfbATybWEq+nJXJk4OQNPCPTdUk3E=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73ddb541-04b2-459f-70d1-08d9ab966527
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 19:54:28.3289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XR0gXBCNrnRlfMxur2k7sWINUkuyUcF85PlhoEnxc3SSLab5gIeDrTptKgIKfrU3XM8a6Suj2Df3YHBuhq4ZxP7cVY4Fl/HL5UXVPixzrvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR02MB3834
X-Proofpoint-ORIG-GUID: EjJxQWIvEFtAjZieSWz_VI8VkHKUY4IE
X-Proofpoint-GUID: EjJxQWIvEFtAjZieSWz_VI8VkHKUY4IE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_15,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 18/11/21 11:18 pm, Sean Christopherson wrote:
> On Sun, Nov 14, 2021, Shivam Kumar wrote:
>> For a page write fault or "page dirty", the dirty counter of the
>> corresponding vCPU is incremented.
>>
>> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
>> Signed-off-by: Shaju Abraham <shaju.abraham@nutanix.com>
>> Signed-off-by: Manish Mishra <manish.mishra@nutanix.com>
>> ---
>>   virt/kvm/kvm_main.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 1564d3a3f608..55bf92cf9f4f 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -3091,8 +3091,15 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>   		if (kvm->dirty_ring_size)
>>   			kvm_dirty_ring_push(kvm_dirty_ring_get(kvm),
>>   					    slot, rel_gfn);
>> -		else
>> +		else {
>> +			struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>> +
>> +			if (vcpu && vcpu->kvm->dirty_quota_migration_enabled &&
>> +					vcpu->vCPUdqctx)
>> +				vcpu->vCPUdqctx->dirty_counter++;
> Checking dirty_quota_migration_enabled can race, and it'd be far faster to
> unconditionally update a counter, e.g. a per-vCPU stat.
Yes, unconditional update seems fine as it is not required to reset the 
dirty counter every time a new migration starts (as per our discussion 
on PATCH 0 in this patchset). Thanks.
>
>> +
>>   			set_bit_le(rel_gfn, memslot->dirty_bitmap);
>> +		}
>>   	}
>>   }
>>   EXPORT_SYMBOL_GPL(mark_page_dirty_in_slot);
>> -- 
>> 2.22.3
>>
