Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA1738CCE4
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 20:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234697AbhEUSHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 14:07:32 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56418 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbhEUSHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 14:07:32 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LHsvqX172476;
        Fri, 21 May 2021 18:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kDNHIuKYji4LbTDiCFpIgKjgW6DjdetAzhhDmDv9KvA=;
 b=pxMZvW2gOvvQ3VKhPL5R2VWtolB9Q0vZ+132upW3AADTP6PwMGx+SJD+bQ3eXRMSNGVq
 JU4d+RtpsBWmnxVT8EWWAtxedjs1i4ECxZ0PSF1Bo7hnX+AVLs3tailcptbbp/h7WYc1
 L8i/10jy7YJln3fI4Vs+qxZOLEN9Dsx1QpQGeclir4syU/6dyRCpCvBn1S+ITHcVV7t0
 3PXaLwoD1cez/cTGVvFgiU8qZYx0zgx6cn4vKmK5Ilx3oNUk+TusAZxajamwrsEtgX9u
 ADGmO3F4Hsz9At7msPD44MKF2Ko3wUzT4l4RQp+f3g+rP01637vP7D7WMwe9jpgipIjK Xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38j68mrc3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 18:06:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LHuZEr114958;
        Fri, 21 May 2021 18:06:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by userp3030.oracle.com with ESMTP id 38megnt0my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 18:06:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+BpZqGa1AXbrOcgB/8GWKkD0j71bS70KVW4YFoYrOPSI4zbmCIZb+RuZYM09JL60Nc4bWIDdRB9MDGNYkJz5VDb5UldHApc4mZSjuXTXE4pCUcGsC/yI8mRlAvpx6T0X0B7SDPGaYwasPpiw1+cGGpRnx4Rm5fTGium2YDQqfOhayUVPW1LbrVRDECGBPtf51zBhd+zOtvUx6Wv/3/qs0RgibLKgAeiBXxLnij5JYbSniVohqV4fL8rMSDqMS4hWKFC9nM0yIW0T8jBgQBnDGcPJOTmBSCaK3r0rUrnH1vGsILJ+1pwgvP5GsJ29jsQMMLf0qQY65sRfG6JmR7Ikg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDNHIuKYji4LbTDiCFpIgKjgW6DjdetAzhhDmDv9KvA=;
 b=NYWNhqzbWgvBp/zeN/z5RcwmmtzbIT0MMnM+EKG2LhkLZTa7uyFkivrBoQ5h3ID5p1xHL9Ovgbc8SP+pICrco+y5WKf3NYZSPincIQm9OoF4zOOaTlyLXGxozC2fYOhD9Mf0iVijAZqbLJRDlTNQgZ1GVA+znzZ+CzazRAOuJa5Q1VrPTk7SGvztpt+yHBw/sDssTOW42kWVa0gDe/DXDHrEWj02pjUNZm8hx8D9Hi99deHFkK4qGxyYKnlC0aGjKLgUiiH4mDUe4r03KR2kk6x2kXumkiJM++UE8aGVtkTfzN/qCiMnTgn0KPFpCHt4j/bJY/39Dvpf8GKdROtMWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDNHIuKYji4LbTDiCFpIgKjgW6DjdetAzhhDmDv9KvA=;
 b=B7p2F02LNhOXvkIy44MbWekzGg65mW8dYfE0UgXmQFUn/fM0bfiGFKViEmq3ycDMcZZ3hpor7yTctzkmKZ+EB1UaQ48omdmVPnDQp79HpL3BdyNVLBI7OEg1Afs+aq0B1aUwrgZV4En0kq4Y1VhBUbItyISj0HiOb1tmi/DYf34=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4604.namprd10.prod.outlook.com (2603:10b6:806:11c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Fri, 21 May
 2021 18:06:02 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4129.033; Fri, 21 May 2021
 18:06:02 +0000
Subject: Re: [PATCH 4/4 v2] KVM: x86: Add a new VM statistic to show number of
 VCPUs created in a given VM
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
 <20210520005012.68377-5-krish.sadhukhan@oracle.com>
 <YKZ6a6UlJt/r985F@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <e7c6c2c8-87e5-96ca-5ec6-d28dda16b603@oracle.com>
Date:   Fri, 21 May 2021 11:06:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <YKZ6a6UlJt/r985F@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SN4PR0501CA0078.namprd05.prod.outlook.com
 (2603:10b6:803:22::16) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SN4PR0501CA0078.namprd05.prod.outlook.com (2603:10b6:803:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.11 via Frontend Transport; Fri, 21 May 2021 18:06:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 176ab519-43d6-4636-7111-08d91c831868
X-MS-TrafficTypeDiagnostic: SA2PR10MB4604:
X-Microsoft-Antispam-PRVS: <SA2PR10MB460492515CB9BEB75342B0A281299@SA2PR10MB4604.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ueOi3zSl4EYup7VRw98rzCdhcbutdPxrMx6oFg4WXf+bp1qs5sVX6+1wX8rxP8+tB9BOPRv17Cdyz+8dhdLNz71t3hy+0oK2LYsNHapcIJKFePwYHAOIT1GF2Myo8gWCY2xwsmQ/H0DrRCCZNIuI3I9FO3ESS8aDOftRNL4lvIkRq8Uui3GI9iVvV82L7URBZcJppiojYciU3XJa0o6+kug9VOuvuxDqcd6waIiYRtigTl2ftA1iMAZOplkXUtjWEOWv0geQ5jCC2imdRxlLYtcOhdow3GyOHdfZvlAyAQEAxReFgzmNTf+ih1R9Ph/7NHzpJwsCRYF9qsmXsWIZLePA2OkjnVt85C1eKVP/OVGzqxCc0Al7XiBime1YV5tndy6F5+TRTa+fxO2IP93Q/UvuAMyJwlhsTXTGPyO7i7iPlsCY3tHUKFSHpBeYkgXyLG8/hfUhhJNwdyGvZtN+HoX5Lo4vSkvSloR9xxVk9C0qU+SbPyMFJWBO9opE07KF2HzfgJQ3sVN4zalKM5WNyC2iFs1Q459ZsrlH/tzQWFLJfrwpNJ3qJxwfpngDvFy0w3kfFAeUbiaI7iCCKHnVHqOzgKP3sltmptqxdl2Pj1P/lh27z6Y1p1VkBLZSI7TKOUNV+CqjqSM0HiBSHnooGJzN3b0ewrhXKIs1FnvYr0cnraJjtt8omPvC/bRt20j6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(39860400002)(366004)(346002)(4326008)(2616005)(38100700002)(6486002)(8676002)(66946007)(8936002)(66476007)(31696002)(44832011)(86362001)(66556008)(53546011)(6506007)(16526019)(478600001)(186003)(316002)(5660300002)(83380400001)(6512007)(2906002)(36756003)(31686004)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OFZ5ZlFqL1NLdlJ4emEvUEk1S2UxcmpKQTNyZm5MWjh5ZlgzQ2RLMnRiTVBB?=
 =?utf-8?B?eGZBRUNVQXN4MVpYemRRZHc2YWpGQXVLa09TS1V0MTN0aWltOUhPQytKRkRi?=
 =?utf-8?B?a1dVejlnMCtuY3NubHVZUnlXcXM1NzJpSzZIZGdLQ0ZPWVlGSHR3dmRkaTl4?=
 =?utf-8?B?VGlKNUMwTmswc01uVDg1TVhHaGZTbjQ0SWx0L2ozQjYwR1U5RDhGd1JXaE53?=
 =?utf-8?B?WEVaekZSWEwycUdpcnRKOWROVGNMMitUb3YvRTZDYXpDVjAzbWExcEovTUpo?=
 =?utf-8?B?OFBhL2FNRXY5NDNlZzJiUEtnc0x6NFcvSldXTjZaSnA4MzNudjkraW5kVzFx?=
 =?utf-8?B?KzJyNjcwTXVQV2RURFplMk1HL3hDeE41SWpaTWFzUUZ2NjJHWTdSeW92bUdt?=
 =?utf-8?B?bXlyL0dvQmxRWmRjSVI0Z0pwMHprdk5wUUd2cDdmazhUMWo2aloxSFFRY05M?=
 =?utf-8?B?MzZXeEYxR0VhSWpTRU9iR2hHbUlyaG82SWlNcWVwSjhrc3pDd0JRVDFKd1JZ?=
 =?utf-8?B?T2JuOUxXVnQ3TFNEU0RpMmJqa0FLUHhWZU9tWXE0dVBaTURGN3d6dDNiZko3?=
 =?utf-8?B?OTlNL2hMcndhTnFEdmdpRjlhQ3hSdUloblg0NlE2WG43R3dtUWlXZjVGb3BK?=
 =?utf-8?B?MXg5bmc0ejZQRXQ5dHlRYnc0WUtETkt0bXUwTTJZdmt1cWxhcFFENGE0VTBD?=
 =?utf-8?B?TFVvd1JFbXk4ODQ4OXhBb0h2cWhQRzBTUXhGbTdnVWRveDc1eCs5UG1NUHgy?=
 =?utf-8?B?WFU3aHB6SVRVV21sMXI5ditqc1FPbGJGWWxEUEYxZUp4STZiUkZ0VVdhcUpD?=
 =?utf-8?B?MWlPSTlRNjVxZ2tvMUl6Z2xsd1lGNDFKcHRIK1hFcm9QbG9FbUo1NlM2azVy?=
 =?utf-8?B?NWo0NHpMOHovSmFWaUVqNDRCNW9yV2xjN240c1AwMUZ5Zy9ZcnJTcnJ0T0Ji?=
 =?utf-8?B?Z2NxS0tPK0NIMU1PNHVKZ3VubURFY1ZuZjI0dGtaQ000aG5yVEEzM3dwWHlX?=
 =?utf-8?B?bHBqSnIwUWlhK2IrRUYyQ1ZnaWYyVWI3QUhTUHd3QXMwb1QxcVZmdm5JMGNK?=
 =?utf-8?B?ZEdyVUordlNnc3IzNWZnZ0QwTEJ2NndaMk5jeFFFcytmbi91S3N6QmI4YUVy?=
 =?utf-8?B?SFJwVUtoRVVNdUVOV1pXekNJQXFyd3huVzQwNFhhUG1TUHB4dzgzWmxXeGVs?=
 =?utf-8?B?cXhIYmVtcmllRVVzMjAyUnJnd3N3eGtaUjB3dDNmOHlOZTlpbDdjSGV3clh2?=
 =?utf-8?B?ODZkb2M1cGprQ2RZY1NhWEJkUVRUMHo5d0JkcnBkTnFjVTRiNllicUdlOU5V?=
 =?utf-8?B?S2JXUjJLNVhGbHByL3VCeHBpditGK0FWQWdlY25UQ2VIT1E5RlROVWh0MWhU?=
 =?utf-8?B?Y0MweVBpTTY0anJ3YmZoaFN6SFhvZWowNkFIQ3lacFE1bTM0NWdZZm5Da3FT?=
 =?utf-8?B?anlLRU5LeEJSeFZkNytQTHZ5djFJRkd5YmE2L0NXU1ZDem8vQkJBTHVEcDBI?=
 =?utf-8?B?M05hUGNvRXA5a0xxd3QvUDJSQVIvWU85NmRqNWdDb3A5bUx3VFFCSEZmRnlx?=
 =?utf-8?B?ZmE1cFpZMzVjQUw0NmZwcUtQU1hDalNnd1M0NTk5U3EzTnp5by9tZ2t2ZTF2?=
 =?utf-8?B?cGhTN3pBZzh0UlNGRzJwMGc4YkthcG44MkpXdUsyMXdMdUVnZXZvckpXbnJx?=
 =?utf-8?B?ajFHd1JZSDZLb0xIVGtaNko3TllXalRzK1lHK201ajJOL016MDczejNrT3VT?=
 =?utf-8?B?c0phQWpDVDVSc0xCNnlIMDVKWHkxMjJjemFVdVFsY1hXWkxVUytXSHF2OHlr?=
 =?utf-8?B?WDVIQ3lhSkc0aFJObHdPZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 176ab519-43d6-4636-7111-08d91c831868
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 18:06:02.6786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffdAyVVE0Pu2r3agb5lDxgaFHYpgM2tGQWAsawMRKW0CCaBXrZD6Guu1CDBg2pX2/5VyjwcC4oOQ6RPEdTB64fieEfRaSPsSeXfV8NjwMOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4604
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210094
X-Proofpoint-ORIG-GUID: Es4CRSa6eAk-BD2YPoEEowW5OJL1Z6U8
X-Proofpoint-GUID: Es4CRSa6eAk-BD2YPoEEowW5OJL1Z6U8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015
 adultscore=0 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/20/21 8:04 AM, Sean Christopherson wrote:
> On Wed, May 19, 2021, Krish Sadhukhan wrote:
>> 'struct kvm' already has a member for counting the number of VCPUs created
>> for a given VM. Add this as a new VM statistic to KVM debugfs.
> Huh!??  Why?  Userspace is the one creating the vCPUs, it darn well should know
> how many it's created.
>   


If I am providing a host for users to create VMs, how do I know who 
creates how many VCPUs ? This statistic is intended show usage of VCPU 
resources on a host used by customers.

>> Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h | 1 +
>>   arch/x86/kvm/svm/svm.c          | 3 +--
>>   arch/x86/kvm/x86.c              | 1 +
>>   virt/kvm/kvm_main.c             | 2 ++
>>   4 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index a19fe2cfaa93..69ca1d6f6557 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1139,6 +1139,7 @@ struct kvm_vm_stat {
>>   	ulong nx_lpage_splits;
>>   	ulong max_mmu_page_hash_collisions;
>>   	ulong vcpus_ran_nested;
>> +	u64 created_vcpus;
>>   };
>>   
>>   struct kvm_vcpu_stat {
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index d1871c51411f..fef0baba043b 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3875,8 +3875,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>>   
>>   		/* Track VMRUNs that have made past consistency checking */
>>   		if (svm->nested.nested_run_pending &&
>> -		    svm->vmcb->control.exit_code != SVM_EXIT_ERR &&
>> -		    svm->vmcb->control.exit_code != SVM_EXIT_NPF) {
>> +		    svm->vmcb->control.exit_code != SVM_EXIT_ERR) {
> ???


Sorry, this one sneaked in here from the other patch!  Will remove it.

>
>>   			if (!vcpu->stat.nested_runs)
>>   				++vcpu->kvm->stat.vcpus_ran_nested;
>>                           ++vcpu->stat.nested_runs;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index cbca3609a152..a9d27ce4cc93 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -258,6 +258,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>>   	VM_STAT("nx_largepages_splitted", nx_lpage_splits, .mode = 0444),
>>   	VM_STAT("max_mmu_page_hash_collisions", max_mmu_page_hash_collisions),
>>   	VM_STAT("vcpus_ran_nested", vcpus_ran_nested),
>> +	VM_STAT("created_vcpus", created_vcpus),
>>   	{ NULL }
>>   };
>>   
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 6b4feb92dc79..ac8f02d8a051 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -3318,6 +3318,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>>   	}
>>   
>>   	kvm->created_vcpus++;
>> +	kvm->stat.created_vcpus++;
>>   	mutex_unlock(&kvm->lock);
>>   
>>   	r = kvm_arch_vcpu_precreate(kvm, id);
>> @@ -3394,6 +3395,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, u32 id)
>>   vcpu_decrement:
>>   	mutex_lock(&kvm->lock);
>>   	kvm->created_vcpus--;
>> +	kvm->stat.created_vcpus--;
>>   	mutex_unlock(&kvm->lock);
>>   	return r;
>>   }
>> -- 
>> 2.27.0
>>
