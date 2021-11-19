Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B0A457797
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 21:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhKSUGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 15:06:38 -0500
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:30804 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230399AbhKSUGh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 15:06:37 -0500
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AJEJCik017038;
        Fri, 19 Nov 2021 12:03:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=sRi26w5yuurEvXy5vuLQGHBIyqS9gJXtkOdPbytu2Hk=;
 b=XjsR8P/YaOc+r9cMVAZysdCylZgh7unjfq11EnameKNsMYjt3k9kvJ+nsojYuzn4xqlt
 jl9golPHQ/HrtFLyFT4wdSu5PHb6Kfh7Xla/QawxAV5Tz669pCNzJgIfsFIHNSj2iAqF
 VYOiM4ZEyf/q1WA/fSRf3F/NIqht1dodBx+41cWAzK4Ml/gvAK+pzcc9WcToBOuU6twi
 a4pLUSVtClr48rEdtUV58JvHtGnxApF8R4hdUT16CEpDWvs74hX6TRXSKX2/GO7GTSfd
 HjgBY9JtyWIhGjo2wp1dED0JnKhgalzPzuHi6FG3achbvE7mINMhBXOg4PuVt6Shv3qr SA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3cdv5a2q31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 19 Nov 2021 12:03:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d4dzL4JBK0HFNuvN+9bJRAfdcjrf9bpCUZDGRlNbQ1pOR4p2EDNPi7qgSR4O6QFj9IiASFfYFfBalyKVal7dQA+dE6CyUgm62A3x9S2meL8O05DtZSmTPwkZs/BKvAHFwfSERElRCAgUZSNP1m2XSWm60h2k6VNtaQmtves9ulNScDXPZw+u2+gqIbo0Axiti1blzc4eBugBUw21JelyTEqB5dxbwHkEb7bmXlAFxSJooaIQIYSYY+WlQ1GWro0ucFma96B0oYp+17Xjd1qJ83Zb18LwjkuEo5DaAxy4Er7SQfmduLxSVTFiqYi3Y5X3PN0NjqtNQG0gmJhNBQSJtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRi26w5yuurEvXy5vuLQGHBIyqS9gJXtkOdPbytu2Hk=;
 b=U2cbMmDQBkLlH2GU7TrtH2v94WtML2KmhuQxBKV/8pR0h8COOBCGuThUrxG6pMRpQVtu6tt3ie4Wcckgjhvrwi58uYAIeIx35tRrKfSFyEE0Gr7lqlvfB/ti1KRgm6HQjRWX/A6WMxmQyh9g7c+AQbeBFqRFLypGoyC1KX3httTduisPYduEh8SkTrkosQiLbuodTs+sfTE/Tk18MWvjZzCf6KanAdka+gKSORUSAOMXgDWjep0Jj3MDUOZlzWjaiVZn4QRA/SPrwFsMQ5OBry2YAPV9eBiwaokdHtj9XpUKVJlRUTtx4WiRAF0FhYJeINw4MezusEpddBjSp9WlDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MW4PR02MB7409.namprd02.prod.outlook.com (2603:10b6:303:7a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Fri, 19 Nov
 2021 20:03:28 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8d99:ba07:279:25c3%8]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 20:03:28 +0000
Message-ID: <4543fc85-54af-16b0-5ed0-0788e434d91a@nutanix.com>
Date:   Sat, 20 Nov 2021 01:33:15 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH 3/6] Add KVM_CAP_DIRTY_QUOTA_MIGRATION and handle vCPU
 page faults.
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>
References: <20211114145721.209219-1-shivam.kumar1@nutanix.com>
 <20211114145721.209219-4-shivam.kumar1@nutanix.com>
 <YZaUENi0ZyQi/9M0@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <YZaUENi0ZyQi/9M0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY4P282CA0004.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
Received: from [192.168.1.4] (117.194.217.157) by SY4P282CA0004.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:a0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 20:03:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd9ccfec-1828-4086-1a4c-08d9ab97a6e8
X-MS-TrafficTypeDiagnostic: MW4PR02MB7409:
X-Microsoft-Antispam-PRVS: <MW4PR02MB7409382E56F43A3455A24189B39C9@MW4PR02MB7409.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GvFn1z3WEMsLskmA6Hi2rp8EeH2SBMnEL42umYQ92uIdefi+QMFZ9Xle3WNtvk7bYXWvIAFGjMi8YGfRdTX9LpdNAJzQqa7fp1bWi9LUTFRJ1O4sBR6g/buT7UO+v0JmiS8y3IoAZ5I+Ryv3EnpEz7Kyo/gY8eV83rslublXwCkMTUy0iDHnIu+mrmp93uNZ72kWcrm5aK5DBfNVo00JKz1DidTgSb+5MByfeHyltVybxg9IdbCH7ZBzDA/pi67xuAWT+9qqFXf+4vyiBYzWRSQHXHlVNb9AujbDI7obsWMHs8z6prnkbalXzsFFbdah48W9DuVxbRm/1zylXY9oCAMApiwKdJcNG//+VgGa3r9jeQvYq9OmR1cHJMN6kgWcCf9nfWWGI4/myjyOpgk77f9SmUc4Fcdbdc+rOEWTqFnQx9soQBGXjIi59Dh3T833GeI/2t27hHH3gXTXjVX5MQ9wRnEkrbDHkpMudZSKihRqM5Hu7p+koH1XKEtgIDyq5Y+r6gN5WO97WMZN+PIMentTSU2oa0TkRHz2g/DMYSBVNfoT6Z4+ITSMxIUnEdxArB4JmaNe5b74fA6Q0+0JTYE4ywEUa9Ts34ZPRw9UX20ptyhC38nDx9ZRrL5Z5hQuRr7Zm5cfe13fMET5AgOCkQZewuMSIxfNf9T4WQHFEbfYcnm6anqT+ngFnQL5B+ZrWDsnpg7PwFyw9P4pDGlTvchaC9dVvrj6jvbeA4nKWhyGRYmHErMvgmpKRyIxhYKygcW61Rugfeh9jPcjQCpNmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(83380400001)(6666004)(36756003)(4326008)(186003)(53546011)(5660300002)(107886003)(31686004)(86362001)(38100700002)(2906002)(8676002)(16576012)(31696002)(66476007)(6916009)(66556008)(508600001)(66946007)(6486002)(54906003)(2616005)(316002)(26005)(55236004)(956004)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0VHTjZqYUZyTGxlazMydEI4cGFlRlNHcGJuMjBJUHAxQ282dFNoS0lyWHBD?=
 =?utf-8?B?UmhLREZUTDBDajV5UFZuN2pzTjk0QzhwSVVLN2oxeHZyUjBCb3FzaXVncGFP?=
 =?utf-8?B?UEhpWG5lVCtwQ3p3MnYra3ZPaStWRUVKaDA0QnBHUG1DOWxPaUNYRy9TeW9r?=
 =?utf-8?B?MXplaXlQTEdpVnJocDBwemRseEtPTmFkU1BGNTQzZkRGQXdUYm12SUdxdGs5?=
 =?utf-8?B?c3JkVjVya0thYVBhcTh5MGtTNDhGQnJaZFUrenNoM01iU0hhV05MU3B4NTNK?=
 =?utf-8?B?NUtvZHBrcWxhUVhoUVZyaUJ1ZStMVnNEUTZOcUJ0NGFCbWZyZTdLNXZ0aVBv?=
 =?utf-8?B?REIyWVpiTmNLdTdCZHJ2b1o4SlNocUNhOFFOMmNqdHZDbUFEdUVCVmIzcTB0?=
 =?utf-8?B?SGJQMllBYldzUEU4NU4wUjVaUWx3c3dtRC9OUFRrRFYxNXVNK0VkY0s4OXNX?=
 =?utf-8?B?cmVZYklqSHpySkNqd2VBdWo5Y0pDSGtLVnFjVzdJcWwxTlBkZ3h0L2R2em1Z?=
 =?utf-8?B?TmNQWVRQNFBiZjNyZHZHOUY1ZGJOSU9VSzg3VHUzR3kzZkJZWk1lTXFkbjVR?=
 =?utf-8?B?U1pSNm5pZW9BOEVmUjVTK1ZhZGxHNE9ybWxPNy9PekpxV0NpdlVsT2pkQUZk?=
 =?utf-8?B?VFFJZlhsQmxXZGxoTzdXV2ZKNFd2RmpEV1REMVRYTEJ2VlF2dTNOK21LcWY4?=
 =?utf-8?B?S3lQVitML1QweVNMQU41TG9GZkVmZWJiZTE5N1dWQ1ozcEtlMVVZODF5MHhp?=
 =?utf-8?B?UTFjSEFlNGdKeitLbmhIbnJmT0xlNVhBTXd0Y2E0bndsQUVrb3NiNWNnWktq?=
 =?utf-8?B?YVFoeXYwNEFmNGhGY1lwUlQ3bks0K2V5YmdhYWpUQ2Q0bjJwNFd0bUQwc1dC?=
 =?utf-8?B?YTVzWXRaSHNreGU1ZDk1ckpEZ1V0S3Vlajh1UElaWXVsMUJnS002Vk53bjRN?=
 =?utf-8?B?QVpUdFEwK2pJT1d6aGExTlRUR3ZON0R3TkQ0QnJIdG80RktpTXFEemljcGs5?=
 =?utf-8?B?aUw0am50M0RSNjI3NWxPbW9vRFdJZVVzdjFaM2NUcUtNNGFtTWFYOHI3elU3?=
 =?utf-8?B?d3lUZnpWL0x5cGk0aW0xc241WVh1VjQ3dlhid2xpYzJ6b0dTL3RwNjhTa0sz?=
 =?utf-8?B?NzUvKzF2M2NjOSszckdGVmo1NWxSM3hKZzQ1MFk5UHVidEcyUFdBVFBHa1ZO?=
 =?utf-8?B?dGhxSndlYkpIY2tzckdJaVBkbWkxcjJYei8vM05FODRHeVNUNkV3alFqY3pv?=
 =?utf-8?B?QjkwR2ZYZGNWcE56Y2JhakV2aEN6eXBlekp4NERTTWZLa1E3S2gya0FWa2p1?=
 =?utf-8?B?QTRBUm4zYVljcFhWZDBHeFBBbFIyMzFTMVNNeWh3RGVWVXdTa1UzQWhuTm5E?=
 =?utf-8?B?aVJRd2hQS2IraDM3d2hlcCs1YjJoTWpmclJMQ0t1RnNLYktuRHRsZGVLQ3Nq?=
 =?utf-8?B?N1hvOVFuS0liaGp5VkpWbnJ4d3o5bXdaYmt1SXBZMUdrTllzbFQzM2ZaYjVH?=
 =?utf-8?B?clVOK2dzbE9CL1psZUJzRmw2ZGpkOTc1ak9JYXQ1bnhQT3pJZ09FTFhNeHRI?=
 =?utf-8?B?N29VOXNnclJJZ05Ea2dZOVJ1aVFkbVlrVWwzanJnRWFZNHg0SHpCaFlybW85?=
 =?utf-8?B?bnNTakdYZVJJU2hnM04vSXY5QTQ5TjkzQmtHREZIc0RCNGROTTZjZC9yN2xQ?=
 =?utf-8?B?WTM4ZnhyaDc2Ym1BTTNGNEd4TVN4dGQyY2Z3bnZiOFc4a3M0YzNlVVN3aURj?=
 =?utf-8?B?aEZTYTNmVi9hT3l3QllUdG5DWGRCRzJ6S3ZhSVM0Y2NsOTZOazF2aTd6aURF?=
 =?utf-8?B?ZXczcVFBZHowMDNKOExzSkRNTlE2eFR4cEpVZzczeHFUT0VKUHY1VE5TaTE4?=
 =?utf-8?B?UjYwalJ2YWNqeEtpelNSS0xKQW45RS81TXptb2gxUmZnSkE3OFpILzhrTk5q?=
 =?utf-8?B?bFIzblZlOCtENHpYcThlbUxOcTV0NWpjdHY4dE9DbU9keDU2TmRqOFlSUXpW?=
 =?utf-8?B?ZWUrelJwZ0U0MVBXM1dzMFVhdURnQ002MkI5NHZRUlpDKzcreW5vbTJtRU5l?=
 =?utf-8?B?OERSbVFuWUpzYmt6d2VLNU9HQ1Vqc2tzRFlLY3c3c3piOUlJUDdaTjJuckNk?=
 =?utf-8?B?bHE1VEZxRytHUmxadUdpQ2hlNDVhNjdldXpVai9NdzlkRWVJckhpL25kQVlX?=
 =?utf-8?B?RGF0Y1ZNU004T2ZHVFBjTWtVSW00bG5BNktNbDZmU1B3ZTJzbW5ETDBDZmhp?=
 =?utf-8?Q?mkuXNYGxXUTLo9+p03aLYBTjL1BFr1Ms2LEMw2Hetk=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9ccfec-1828-4086-1a4c-08d9ab97a6e8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 20:03:27.9301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QBwHZDtQJEkxcqdTpLWzAcsZZpX7Wdkq6oHQCxzuB/DNStwKL7SPTWkMGR+KtUk5SCFuHFCfAkWJaXFICP6Bs9E//5mAOMrItCFzgCYZ244=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7409
X-Proofpoint-GUID: NISZfS6ZsiZ5Y_dZQ6yfoWweBY5ns6De
X-Proofpoint-ORIG-GUID: NISZfS6ZsiZ5Y_dZQ6yfoWweBY5ns6De
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-19_15,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 18/11/21 11:27 pm, Sean Christopherson wrote:
> On Sun, Nov 14, 2021, Shivam Kumar wrote:
>> +static int kvm_vm_ioctl_enable_dirty_quota_migration(struct kvm *kvm,
>> +		bool enabled)
>> +{
>> +	if (!KVM_DIRTY_LOG_PAGE_OFFSET)
> I don't think we should force architectures to opt in.  It would be trivial to
> add
>
> 		if (kvm_dirty_quota_is_full(vcpu)) {
> 			vcpu->run->exit_reason = KVM_EXIT_DIRTY_QUOTA_FULL;
> 			r = 0;
> 			break;
> 		}
>
> in the run loops of each architecture.  And we can do that in incremental patches
> without #ifdeffery since it's only the exiting aspect that requires arch help.
Noted. Thanks.
>
>> +		return -EINVAL;
>> +
>> +	/*
>> +	 * For now, dirty quota migration works with dirty bitmap so don't
>> +	 * enable it if dirty ring interface is enabled. In future, dirty
>> +	 * quota migration may work with dirty ring interface was well.
>> +	 */
> Why does KVM care?  This is a very simple concept.  QEMU not using it for the
> dirty ring doesn't mean KVM can't support it.
>

The dirty ring interface, if enabled, blocks the path that updates the 
dirty bitmap. Our current implementation depends on that path. We were 
planning to make the required changes in our implementation for it work 
with dirty ring as well in upcoming patches. Will explore the 
possibility of doing it in the next patchset only.


>> +	if (kvm->dirty_ring_size)
>> +		return -EINVAL;
>> +
>> +	/* Return if no change */
>> +	if (kvm->dirty_quota_migration_enabled == enabled)
> Needs to be check under lock.


Noted. Thanks.


>
>> +		return -EINVAL;
> Probably more idiomatic to return 0 if the desired value is the current value.


Keeping the case in mind when the userspace is trying to enable it while 
the migration is already going on(which shouldn't happen), we are 
returning -EINVAL. Please let me know if 0 still makes more sense.


>
>> +	mutex_lock(&kvm->lock);
>> +	kvm->dirty_quota_migration_enabled = enabled;
> Needs to check vCPU creation.


In our current implementation, we are using the 
KVM_CAP_DIRTY_QUOTA_MIGRATION ioctl to start dirty logging (through 
dirty counter) on the kernel side. This ioctl is called each time a new 
migration starts and ends.

The dirty quota context of each vCPU is stored in two variables dirty 
counter and quota which we are allocating at vCPU creation and freeing 
at vCPU destroy.


>
>> +	mutex_unlock(&kvm->lock);
>> +
>> +	return 0;
>> +}
>> +
>>   int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>>   						  struct kvm_enable_cap *cap)
>>   {
>> @@ -4305,6 +4339,9 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>>   	}
>>   	case KVM_CAP_DIRTY_LOG_RING:
>>   		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
>> +	case KVM_CAP_DIRTY_QUOTA_MIGRATION:
>> +		return kvm_vm_ioctl_enable_dirty_quota_migration(kvm,
>> +				cap->args[0]);
>>   	default:
>>   		return kvm_vm_ioctl_enable_cap(kvm, cap);
>>   	}
>> -- 
>> 2.22.3
>>
Thank you very much for your feedback.
