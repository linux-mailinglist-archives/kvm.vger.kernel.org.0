Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69394A5CAD
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 13:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbiBAM7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 07:59:12 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:29920
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233789AbiBAM7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 07:59:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WMb6BGkifCJsCGs4pclelrq+9ldGDa+PS9NYjzyccaL7gJ87JBpCc8rKPg+K+LWFSgyCGsCkCKxSHeM7hhiLKEWswIyfaOQSvTHkPBapdWNdSZQ7ytc3qzKggcPcXFhhFUY9onM36nlvVlrJ50R3IW9rd50rlfXM1cr09vQ2vTi6vfM1KsPYpxELnPe6GBm4xFjhNqGmWGEhO4I1sG++0FinKMQeSL6Is/myt0jaK5Ggaux4dPXDQeqBMuxpZeIIbCXx3Hn9BOrcR2w/bqm0tp7xothS4Vk2gZpShBvgd2DjIroS1KeVfFvRvUBKsNSaqRD84rHd7MyVmBMe5y2PPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RMOnBQkJEukDqkJcgnUx5K+/8gZaRcl/FQTmBVaY4Ok=;
 b=WdkhNi9H5y2vhCRsqWwZGrvYnsuwX0zO7x74o9dCNDgXly/yLmXBB3zfoQrf4EMbjDN6Myh7Kg6wNQJHNXSJ8Erw4r0VDMCupl/BGC06ghjnwQXn/qMmbuB1yBND+gEVuQeBGoXY1b6lzH/NYKLaIUMZz9FawBvIZb2+8G1EsHCbSAZHYQUy0/pobWk5sRjmKI/0oI2x0z7B5STY/5Hpovc/PLDPKWR8G6aDgZA+fCIkTiw1qufEdTwEZdkPyFQrlaWFzGCCWG7EItzAEbIkcfww6L5OlBuOOMaeLeqO+zd/qGEismM3MZH8t2EK+joE5jrXVyZhpB82sbRV6iRbZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RMOnBQkJEukDqkJcgnUx5K+/8gZaRcl/FQTmBVaY4Ok=;
 b=KMkTwOQrg/JiPtP/zj6kXqBzYyR8zcf5OFZkj+aHbbEQNt59cqBaD30Md3HY/0yyeBC1xFxBMDyL+eiMm7GvLSpT6kmj9+EV+HidLrtK0JQWQZYzKdPFi+PnPbqSk3qLj1FyseR07RDZ+S8TSawhrcmLyZZS0luKm3j0NgYyTvY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 MN2PR12MB3581.namprd12.prod.outlook.com (2603:10b6:208:c8::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4930.17; Tue, 1 Feb 2022 12:59:08 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::389b:4009:8efc:8643]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::389b:4009:8efc:8643%5]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 12:59:08 +0000
Message-ID: <34a47847-d80d-e93d-a3fe-c22382977c1c@amd.com>
Date:   Tue, 1 Feb 2022 19:58:58 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v3 3/3] KVM: SVM: Extend host physical APIC ID field to
 support more than 8-bit
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, joro@8bytes.org, mlevitsk@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, thomas.lendacky@amd.com,
        jon.grimm@amd.com
References: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
 <20211213113110.12143-4-suravee.suthikulpanit@amd.com>
 <Yc3qt/x1YPYKe4G0@google.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <Yc3qt/x1YPYKe4G0@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK0PR03CA0108.apcprd03.prod.outlook.com
 (2603:1096:203:b0::24) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bc82a27-9c98-4347-1b76-08d9e582a251
X-MS-TrafficTypeDiagnostic: MN2PR12MB3581:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB35818DDF3B29E2DF7728A100F3269@MN2PR12MB3581.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /Zg+Yyr3QlR6JNDdp6CaXgOqzkE34QsQRrqGOU5FZhLO3GmhcOncOpuy+CQjCXdbbnFTRkWdNwH7bxmuEhLxUnKT24oC1y2lbADeWlCBWqNHRk4G6aK6bNY2kF/8smhgRBnFHebaey+1twlu6+whMSAFxZfeM0KHFERHTfJlGrU2swR0p11M1NS3k1chnmzFemEtiYzse0kFhzXLoem9iagc8fPs98Gn/M8+Ir4LFq7A2mE1vXxO8BQov2ZS2KyBRnAnLdizUqUXXO4Uh4aXRCBucLNbQFgOjTgiynq8Hg2rXQgSSq9idoDQVCsNSysJdBZJrD9xCPH5d4HXgeuk1fRkhaZIsMWHiT1+edoOgxY4fq8zUYqobawLCr8AhJG0589qkaH1hzZIES7lNiwcCrIqo2fFd53tDjGNATfcdoEnQXEKgwrU+jsNrbAsJINIyiP4BOBOkngc+eYgMrcjHLTPbootWNFxAwkx/43hLtfd5bvhsPjZPoFGRzRp2QIoCYHdUz4Q0wBGHdKjgLiMY757uhZQwqa8DUKpG8M7BdT2ScKPNJWti+7FLH7Q/YyGsjXMa/7AI9fI/iF5OiXEMRkUhmu9PJBs+1Eoi49ALiAofbQ+VJeBpqTCYgpvYEJt2q6q+U3/epNkcu+hsLvFfAFNLnGxusJ9v6V6xNMiWqphQFYNeA0uVQBrlKT52VpcEEL5PH11Wkirk1TnI7qkXyQHPVLOvAYPpAYOVk/QLLOh7DJ9J/nmFdKZZ8zxBv41
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(36756003)(26005)(66946007)(2616005)(83380400001)(8676002)(186003)(66476007)(316002)(31686004)(8936002)(6916009)(2906002)(86362001)(31696002)(6666004)(6512007)(53546011)(6506007)(38100700002)(4326008)(508600001)(6486002)(7416002)(5660300002)(43740500002)(45980500001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWZlU2VGR2djcE5La09UL1Y0Y2QrT3JBU1dWQldHb0xzR3RxSUI0aE1QZ3V3?=
 =?utf-8?B?bldUcEduaHhxVjZBbE96NzJ1ZWxZSDh6aldJSlJmQkpKS3o0Z2pKYU5TT2I0?=
 =?utf-8?B?a0xGN3JsS1pVMHFsVGdxNEJ5NDlsbXFvd3M2TTRLUm14T3ZoRGhOV1VKVW9M?=
 =?utf-8?B?eW4yTXpnZDF6MGg0c0tOSmFRZzhnbCtTeUdEbTFyMkEwSStJdFk5dGF6eHJO?=
 =?utf-8?B?K3lLNjJxVjRzdjFkUTQ5VzA3cVFEYnBUTEsyMWxjTmxId0dZcUtBemY3S2d5?=
 =?utf-8?B?YWc4ajhwT0hjT0M2dmpxdkhIUVk5UDFtRWhWSmZVUmFINnJxM21zZ0Jzckxm?=
 =?utf-8?B?aFhLTVZEME5PN3NGU3FSMXpRZTZ3b0VxY1BuWVNGeDNsSTNReXREZUk0dVd0?=
 =?utf-8?B?eWpFTGN3OFd1YnpFVVBuamcvSVcrU2hycjI1UHN6V0Qrbk5FRzNDQ29SV2E5?=
 =?utf-8?B?WEgxNk0yVmowazdhWERSQmN4N0FzekU4OE1EVUdaOXhDNHA1MFVic2h6bEF4?=
 =?utf-8?B?NlQ3Yy8vTnNjbCswMmV3aHd3OFF4aDBOK1BHTmtESE9SNzM2eFhDZW11WG9j?=
 =?utf-8?B?dG80K1Q1Q3NHQWZJTnhPbzEyV2RhakRlZHdaNXUrb29EdHNpdWxjVVZMRTIy?=
 =?utf-8?B?Wmdyb2d1MzZLbUg0SjhWZWFIQzNkdlVnZEhmTEFSU2w5VGtoSWRxSWNUdFM4?=
 =?utf-8?B?ZXlsTGgvR1FIakE0N1RKRzk5dmRBK2pSaUVjd2lwWXc2QnhPNDErUDB5L3JN?=
 =?utf-8?B?ZUt4V1dkckVQWENUWlp3OTg2WXd0a1FRbkdTcS9ORy94N05VSzVKdVBwK0Np?=
 =?utf-8?B?b2xIMVJVMVVBeUh5ZzEvK2REOWFOK2x6MUJJQjg4UktTbTdwbGVzK0xCUEhT?=
 =?utf-8?B?ZVZ4aVg3OFVZaTU0VWF1ekY2NlJJd21kb3ZUUFdVajdJMGtlTUxUM2lNQ1Zr?=
 =?utf-8?B?K1J1dEtLWm9RQ1c5d2d0YmkrRC84eVZGQnY1SDF3QnZyTnQyOVdPVFpvRG9E?=
 =?utf-8?B?UmEwR1IxaFIreFdsTU82THpVK3lmRTRmT3ZSOWlSOG9KdE5JYnltbStOK0M4?=
 =?utf-8?B?RVlnbCtDMVhHeWpLOWhGS09wZENTb2IrUUY3VXVOS3FCZEJBU29Bem1kM0to?=
 =?utf-8?B?UGJZVEZoRXZEMGF2aGZtcFpZRXo2aUlBdFZKbXpuYjIwc3JYREdrMUx1SDRK?=
 =?utf-8?B?S3ZobGVRQmk3VFNCM1RrNWx4RUJjYmVYT2FDR2R2bzJmMHMvY2wyQ3NZWVRa?=
 =?utf-8?B?ZzZ5RFpqWnY1T3dCZWNPR3JnYlhaRU8yN2FhRTVqcnJ2V3BLdDA3NXpxZ2I2?=
 =?utf-8?B?UERVN1FMRnlSR2RBcUlPTm5QOUJXMkMwcXRZNHN4a0ZUWG5FazFhZTJJUjli?=
 =?utf-8?B?OUNFaVhiY1VnMW9QU0hQWG5mdnFhU3hSb0pZRGlZWENyeGVpUjQyamxMZnFV?=
 =?utf-8?B?TWF5YzY1ejc2cGNtbTR4NGJ0VTE5UnIrSXdTY2tqQTdkVkpZVGt2UFF4QmFC?=
 =?utf-8?B?RnUwV3FxRk5pMm94d0liaFJBTlExZzhHc3orVXcxNDZOMUF3b3BJNkF0WG5O?=
 =?utf-8?B?MVlvTGRsZWNJa2w0TzVSUTVVNTcyMVpNT0pRa3ljTHp1VUZ6SFhmZnVtNzdy?=
 =?utf-8?B?QUNHK3BDenJpMEVkbGRqeE5wbks3MDVQYjFJUFp5Sm9VcnNkdzl5QVVCLzFT?=
 =?utf-8?B?cENjaGQ0SmFPZzdIN1BhSWtsL1hiQ0daS05nNWVNT3RiSkdleDNTb01oSGRB?=
 =?utf-8?B?SWZrejJjV2RDUndRUnFGTi8xY09xc29uazFBa084THc2Y1BXRVpvSTFNeGIy?=
 =?utf-8?B?S0xaSERJem9MQmhCenRMS0NUbVhSeW5qTzJNVDRXTmpYUTVBTDNneE5sVWth?=
 =?utf-8?B?bldOM1YwMjJjQm5iQ0ppSU8yV1Q3ajlVbEltQTJ1cmhPR2NjeUFLZW5HRURj?=
 =?utf-8?B?YkphM0JPNjUrU0lOSXNSSlRPV3FOR0FZTSt0azFzdUEydWZYRjVrWTYxY2Y3?=
 =?utf-8?B?QWwyY1dhZUdxYVNLbUpweDU5REoxcjhpbTFTc2hJWDU4cWVVWWpSUWduWlor?=
 =?utf-8?B?c3BHZlIzeUpGMHpSL1ZQTmZPMENXZXpLNFRON014SGNJTkIvWkJBZ0pkbElR?=
 =?utf-8?B?czBZTmJmeFZoUWx6L1M5dnFzbHJ4S3JtWmhmajdpcEd1RVdmSVQ4dFU3L3Zt?=
 =?utf-8?Q?GUT7EIBzhjyvrtrQvFlW+Zg=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc82a27-9c98-4347-1b76-08d9e582a251
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 12:59:08.4649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NkA112DA4Eip3u1IZub2GrpGG3vLC6Rlrqf8YHsO6yjeHWR0z/qpQz95cItWMMH+4yKmoXAoCsVQ2qAtaWRhxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3581
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 12/31/2021 12:21 AM, Sean Christopherson wrote:
> On Mon, Dec 13, 2021, Suravee Suthikulpanit wrote:
>> .....
>> +	} else {
>> +		u32 count = get_count_order(apic_get_max_phys_apicid());
>> +
>> +		avic_host_physical_id_mask = BIT_ULL(count) - 1;
>> +	}
> 
> Why is the "legal" mask dynamically calculated?  That's way more complicated and
> convoluted then this needs to be.
> 
> The cover letter says
> 
>    However, newer AMD systems can have physical APIC ID larger than 255,
>    and AVIC hardware has been extended to support upto the maximum physical
>    APIC ID available in the system.
> 
> and newer versions of the APM have bits
> 
>    11:8 - Reserved/SBZ for legacy APIC; extension of Host Physical APIC ID when
>           x2APIC is enabled.
>    7:0  - Host Physical APIC ID Physical APIC ID of the physical core allocated by
>           the VMM to host the guest virtual processor. This field is not valid
> 	 unless the IsRunning bit is set.
> 
> whereas older versions have
> 
>    11:8 - Reserved, SBZ. Should always be set to zero.
> 

I have checked with the hardware and documentation team. The statement regarding "x2APIC"
is not accurate and will be corrected. Sorry for confusion.

> That implies that an APIC ID > 255 on older hardware what ignores bits 11:8 even
> in x2APIC will silently fail, and the whole point of this mask is to avoid exactly
> that.

On current AMD system w/ x2APIC and 256 cpus (e.g. max APIC ID is 255), it would only
need 8 bits in the physical APIC ID table entry, and the bit 11:9 are reserved.
For newer system, it could take upto 12 bits to represent APIC ID.

> To further confuse things, the APM was only partially updated and needs to be fixed,
> e.g. "Figure 15-19. Physical APIC Table in Memory" and the following blurb wasn't
> updated to account for the new x2APIC behavior.

Noted. I'll inform the team.

> But at least one APM blurb appears to have been wrong (or the architecture is broken)
> prior to the larger AVIC width:
> 
>    Since a destination of FFh is used to specify a broadcast, physical APIC ID FFh
>    is reserved.
> 
> We have Rome systems with 256 CPUs and thus an x2APIC ID for a CPU of FFh.  So
> either the APM is wrong or AVIC is broken on older large systems.

Actually, the statement is referred to the guest physical APIC ID, which is used to
index the per-vm physical APIC table in the host. So, it should be correct in the case
of AVIC, which only support APIC mode in the guest.

> Anyways, for the new larger mask, IMO dynamically computing the mask based on what
> APIC IDs were enumerated to the kernel is pointless.  If the AVIC doesn't support
> using bits 11:0 to address APIC IDs then KVM is silently hosed no matter what if
> any APIC ID is >255.

The reason for dynamic mask is to protect the reserved bits, which varies between
the current platform (i.e 11:8) vs. newer platform (i.e. 11:10), in which
there is no good way to tell except to check the max_physical_apicid (see below).

> Ideally, there would be a feature flag enumerating the larger AVIC support so we
> could do:
> 
> 	if (!x2apic_mode || !boot_cpu_has(X86_FEATURE_FANCY_NEW_AVIC))
> 		avic_host_physical_id_mask = GENMASK(7:0);
> 	else
> 		avic_host_physical_id_mask = GENMASK(11:0);
> 
> but since it sounds like that's not the case, and presumably hardware is smart
> enough not to assign APIC IDs it can't address, this can simply be
> 
> 	if (!x2apic_mode)
> 		avic_host_physical_id_mask = GENMASK(7:0);
> 	else
> 		avic_host_physical_id_mask = GENMASK(11:0);
> 
> and patch 01 to add+export apic_get_max_phys_apicid() goes away.

Unfortunately, we do not have the "X86_FEATURE_FANCY_NEW_AVIC" CPUID bit :(

Also, based on the previous comment, we can't use the x2APIC mode in the host
to determine such condition. Hence, the need for dynamic mask based on
the max_physical_apicid.

>> +	pr_debug("Using AVIC host physical APIC ID mask %#0llx\n",
>> +		 avic_host_physical_id_mask);
>> +}
>> +
>>   int avic_vm_init(struct kvm *kvm)
>>   {
>>   	unsigned long flags;
>> @@ -943,22 +959,17 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
>>   void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>>   {
>>   	u64 entry;
>> -	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
>>   	int h_physical_id = kvm_cpu_get_apicid(cpu);
>>   	struct vcpu_svm *svm = to_svm(vcpu);
>>   
>> -	/*
>> -	 * Since the host physical APIC id is 8 bits,
>> -	 * we can support host APIC ID upto 255.
>> -	 */
>> -	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
>> +	if (WARN_ON(h_physical_id > avic_host_physical_id_mask))
> 
> Not really your code, but this should really be
> 
> 	if (WARN_ON((h_physical_id & avic_host_physical_id_mask) != h_physical_id))
> 		return;
> 
> otherwise a negative value will get a false negative.

I can do this in v4.

Regards,
Suravee
