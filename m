Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF598402CDE
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 18:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343868AbhIGQb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 12:31:57 -0400
Received: from mail-bn8nam11on2082.outbound.protection.outlook.com ([40.107.236.82]:58561
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343671AbhIGQb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 12:31:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+KFzsa+rc36uQt014EAJaeuCacilVqypmR/mpwwOUKWWQ9/moh6JYUnbex2Gefv7NWXVAXDOUWExXWceKoxC52TprljN1UkHnQkJV4J93hJiJL9z6JHpst07UiUnoQqj6gcHVRMyDD0xJU2gTlyjyftZ82a3Z9SvwZGHiEqVUpdrk8P/Fsd1qwwNMdJ+oSaBa+AHKA2v5CDjZhNVpFafkc5tEHDVtLe/V4DBWty59t7pM3wUlTzHiydlZTB6CJWfh7/mUwKydYV1hYvSVSxJHjE62pXY/Y+iFP+8q2i4th73ZIsUEkKu53IxOw4fioJ0XMn9QahSzqsScxk4mrQ7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QYTUveTWQmSGm1Fi7UbI3cfJGAE/TEMPoqRTTYs3SZ8=;
 b=Au1R02IddAG6oUyVW7rxweV+ZVHnwL2R+WubkK33FRiKGoZx+7E7rZZ6T6o4lrWhEyFIJQmPP3o5yXP+yFgMGRt9CUWuJkGBcXpUqI17GnFUHggsF0VtvrHK1PxuP/rghog7ss1EhZFEnik77dh9qwQuJxXi14Ry5ZNZUj81eXKvQvqxm6ju60s9g7NHoPOXlb1HcB9TFLnzkJwllCv80Iw0fHA+oPrtF9djDqtdVuy3XISBJjtiHY/m2vhDTnZHtkKVG8Nk1yUknQ/FTBc+L6R5H6PbNWw7j40bSSXufAwSUEomk5XcXjCsGUgFaOlff4dWeQe/A9kYRe452FkNMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYTUveTWQmSGm1Fi7UbI3cfJGAE/TEMPoqRTTYs3SZ8=;
 b=u2tcW86qF+FDXcTNBbyPilZYlWw8puDosHOQ7dnWLjI6fqyhsLNowActl022HskCBV0R9+FqaffUYwfYO3UODchLOR3jHXKpWRoE8qr1yceqXDcLaFi+wm825ygCe+L4cvR86wBxLIRlQAx3SeAIXUxoNPUNQRq0WsoctHeahb4=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4430.namprd12.prod.outlook.com (2603:10b6:806:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25; Tue, 7 Sep
 2021 16:30:47 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 16:30:47 +0000
Cc:     brijesh.singh@amd.com, Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH v2 3/4] KVM: SVM: move sev_bind_asid to psp
To:     Sean Christopherson <seanjc@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20210818053908.1907051-1-mizhang@google.com>
 <20210818053908.1907051-4-mizhang@google.com> <YTJ5wjNShaHlDVAp@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <fcb83a85-8150-9617-01e6-c6bcc249c485@amd.com>
Date:   Tue, 7 Sep 2021 11:30:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YTJ5wjNShaHlDVAp@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0030.namprd05.prod.outlook.com
 (2603:10b6:803:40::43) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.31.95] (165.204.77.1) by SN4PR0501CA0030.namprd05.prod.outlook.com (2603:10b6:803:40::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.13 via Frontend Transport; Tue, 7 Sep 2021 16:30:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 932e7749-3b61-4b6e-4eb6-08d9721cd8dd
X-MS-TrafficTypeDiagnostic: SA0PR12MB4430:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4430FBE883FD814AC6CE91A2E5D39@SA0PR12MB4430.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KM9mMYFeCiB1DD2RT+6jTSoxZi3IuxZlHVJk204Za6s2bcUWpxt5+2TzckIZ0PPertuP6rPXD1bSdQdRdUOWDS/eDe9ySO1E1wjS6q1bCs9pKtQoer/d1fnZy78gINCTRAAxnkor69poCaaYb71yfC6pqumMiKGHEBmKJVCjo9IyG9GS78S2bmJJ3PgOhqiQcOA/C4+JIJ44J+SUULuHE47vVP3vYEetiavPSofi/hF8Fyr21DJuyLw5mKqiIeEAfd9rb1gMAXoWDw7GVsyb48mGjv5kq9pH3FU+MLobXkWw6hqsSQ3FM1Dao+g+b+iHtA1jHLmH7BEGbTrz9xImr+ezHq/ILqTDg0iip5geoNMpM3MUKdAAHGQWvJnLXyi9z+lxuBSVexFs0CuMSKUrxLgfPLdbUt4r8b/pPURFLlMaUv+LtPXY6qz9Sv3+IhIPkxCH1ziRIzGBJYvWafZoKUI1NrDDnOzTiazssA3XtuhxE1asJR7nNxJ+BHGMPalTT3SJlQvyG7tPQWHaDobdH1EaCaO8yf/zX64C+c1oPd8MWnU6eYztyID0rZYNgGwlKUTDCgcIm8PujxcnQZDHwJDNjct/hveDSBuK/+ixdjqzN1ha7IRruY9DPt1Opd3TNkeuaa15sddDQRjNa3EH1+wbf/el/xT/enIfs8050obF6FPga4Aff5AVUfTP8UuYJL1mCwcWJ8eRMjx7zajKkmvqPVoTrYxsjc5PtFK7nBuxCbQDRITsGnPFOEzDXJKOlTtQoY0NFHlmw3uhOx8SWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(8676002)(36756003)(66556008)(66476007)(66946007)(38350700002)(8936002)(38100700002)(6486002)(54906003)(5660300002)(478600001)(86362001)(53546011)(4326008)(110136005)(83380400001)(16576012)(52116002)(316002)(31686004)(31696002)(44832011)(2906002)(7416002)(2616005)(186003)(956004)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OW9NeHpLSnVYSlg0ZXYxK3l0dGJ2b2FvZzVyOHRYMlc4bTg3ZjRUVGtEckNM?=
 =?utf-8?B?RkwvRU9sSHh2aG5UQ1VJSlIrL1hnMGhNZzhuOW1jUEdDdjRjVGdFbVBWNmxx?=
 =?utf-8?B?azBrUFhsYmw3c3R4NlpVS2kxVW4wVEZYMVpGaVZwRHg2a0xYeGR1U1liRDNI?=
 =?utf-8?B?SzRMSlIyYTlpd0xlaFZiZm1yRy9RTzBOakdlelVEcFVhNDR1OU9OVm9WWE5v?=
 =?utf-8?B?VllFeWd1d1pBVWpFRXM2WWVhcjk2SEQya2VJYS9Vb1FCTXltRkI2RE9iVjh0?=
 =?utf-8?B?ZW1Ib0tCSlZhV3NvTVdTbUlQYitXNG5rTnV4MFJxTjBrc2Z2OFpqeWRkK1Zi?=
 =?utf-8?B?ZXc3WExZSzJKYjhRd2FoQkxPQ29XSks2cUVyQ1dxMC9EZUVuN1VubHFYOWIx?=
 =?utf-8?B?d0s2amhKMWQrUklYdzVwSHA0aGVNOEE4UFdWeWxNS1JiY1ZVY29BTUxIU2hF?=
 =?utf-8?B?TGwxbE1hUUZXeWpORFdNYjhGUm9tZzMzTGtLYklSbkpBK0Yrb2UwS0NOenhC?=
 =?utf-8?B?NXQ2L2cxTkRVVzE0UzEyVHhBMzFMQS91ZURCanZrOTVHRmQvdUk0SEdpOTJN?=
 =?utf-8?B?dmYwSjFoek84NWU0Z0drYVBKWUVZSDhsRDkvMW1ndG8rRkZQZU1wbTdDeWtO?=
 =?utf-8?B?NFlRaWpWQjI1Q29Wa0JqNjZtWXlUV2lRMnlwZGtFVSs0R1BON3B5ZlFLR3JI?=
 =?utf-8?B?T0NNbUx6RXpPRkt6MWdqTXJaS3ltL01PNkM5M2t1RjYvdmQ0MEVSL2hGK3NQ?=
 =?utf-8?B?c3RIMGFsT3cwQTFJdk5Va2padjVTc1h0cFd1TWhSSlRsWFVYT2dSaFJ6bFd6?=
 =?utf-8?B?MjBSQVNBZVhBSWRmZUkraVlxMk9UQ2x3RjdxTU9ncENUSWpKREs3eWVPVW5l?=
 =?utf-8?B?andSTFZDNXJuRmR6ZVA1bE1Nd01VRktWWkQ4YVJpQ3lKTjBJMFRZN2tXUjdK?=
 =?utf-8?B?Z1JqY3lIeE9EUTdaNWNxbncwOFV4d2M4NEp4WTFqbGlxQnpmc2J5MGhVOENB?=
 =?utf-8?B?R3JEM3hBUWtHdnpyQkNlZzROamgvODVtMSttRjJ6cnE4M0Y1MTJwV09BNmxs?=
 =?utf-8?B?dGRCUjV2aW8vSDl6R1dwK3ZxRktBRW9YVGE1RDd4T2RsMUlhaUhpWXlpTDZT?=
 =?utf-8?B?NGtrcmJyZHBGMzY4NGZWVm5lT3puTzBucG54cUY4RzFiMGdpOC9DemRES1k1?=
 =?utf-8?B?TzJlcFl3SCtXV3FSamhidGdaZm1zU3dPMzNwd2Z5a1Bta3BIcVkxaDJEczBC?=
 =?utf-8?B?WC96cjdCTGsrdzZPL05uSVBBOHlVS3pwQWFielc3cW5OT3Z6eE9yVmNsSGV3?=
 =?utf-8?B?ZDNLMG1iYXZoR2JGSWUrNHRJWHpZYXNodWxSRU1mU0pPR3BMZFBHNytZQkpy?=
 =?utf-8?B?WEZqL3VUbXpxTXVpMnNzbWh2NUQzTjVlK25vMnl1OGlRWVJHNDFXc2JyRk1m?=
 =?utf-8?B?d05PdTZTcW5JdmwxQ0ozUlJaN21ZeERIT1hxQWxrc0YrTnRnYmk3a3cvR0VZ?=
 =?utf-8?B?MWJlOGpVc3Y3RDQ2dkxBd0dQMUZtclhiRm8rVk9oTkNMNXYrZUF4YlJjd0JY?=
 =?utf-8?B?azFXdm5odFNyYkYySW41SkJGSm1Bd2RseXVsaldpYVFJcTJuUi8yZ2ZEU2Rp?=
 =?utf-8?B?QTRNWDhwbjUxZTgvUndXNGdNRVBCQ1BKL3JBaWx4NHRYbmlhVmJQeElLYUF4?=
 =?utf-8?B?L1FmWXYzR2lqSm9QbXd2Y0ZidnFmRmZUTjF5clZ2MUxBUy9uYnB0Y2xMTXBk?=
 =?utf-8?Q?6VLHVKkijVV1bWu/cKdGYKtaTFQueJkPDOzJjNm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 932e7749-3b61-4b6e-4eb6-08d9721cd8dd
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 16:30:47.7925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k4Z7f2uFXdy65OlbSX3Rjd1BF090VEBc4QuRMOTgwHctGslLcoFYcoHaV/39x8/awQ+NZQwXEMwh1ARug2xMTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4430
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/3/21 2:38 PM, Sean Christopherson wrote:
> On Wed, Aug 18, 2021, Mingwei Zhang wrote:
>> @@ -336,11 +322,9 @@ static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>   		goto e_free_session;
>>   
>>   	/* Bind ASID to this guest */
>> -	ret = sev_bind_asid(kvm, start.handle, error);
>> -	if (ret) {
>> -		sev_guest_decommission(start.handle, NULL);
>> +	ret = sev_guest_bind_asid(sev_get_asid(kvm), start.handle, error);
>> +	if (ret)
>>   		goto e_free_session;
>> -	}
>>   
>>   	/* return handle to userspace */
>>   	params.handle = start.handle;
> 
> ...
> 
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index e2d49bedc0ef..325e79360d9e 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -903,6 +903,21 @@ int sev_guest_activate(struct sev_data_activate *data, int *error)
>>   }
>>   EXPORT_SYMBOL_GPL(sev_guest_activate);
>>   
>> +int sev_guest_bind_asid(int asid, unsigned int handle, int *error)
>> +{
>> +	struct sev_data_activate activate;
>> +	int ret;
>> +
>> +	/* activate ASID on the given handle */
>> +	activate.handle = handle;
>> +	activate.asid   = asid;
>> +	ret = sev_guest_activate(&activate, error);
>> +	if (ret)
>> +		sev_guest_decommission(handle, NULL);
> 
> Hrm, undoing state like this is a bad API.  It assumes the caller is well-behaved,
> e.g. has already done something that requires decommissioning, and it surprises
> the caller, e.g. the KVM side (above) looks like it's missing error handling.
> Something like this would be cleaner overall:
> 
> 	/* create memory encryption context */
> 	ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_RECEIVE_START, &start,
> 				error);
> 	if (ret)
> 		goto e_free_session;
> 
> 	/* Bind ASID to this guest */
> 	ret = sev_guest_activate(sev_get_asid(kvm), start.handle, error);
> 	if (ret)
> 		goto e_decommision;
> 
> 	params.handle = start.handle;
> 	if (copy_to_user((void __user *)(uintptr_t)argp->data,
> 			 &params, sizeof(struct kvm_sev_receive_start))) {
> 		ret = -EFAULT;
> 		goto e_deactivate;
> 	}
> 
>      	sev->handle = start.handle;
> 	sev->fd = argp->sev_fd;
> 
> e_deactivate:
> 	sev_guest_deactivate(sev_get_asid(kvm), start.handle, error);
> e_decommision:
> 	sev_guest_decommission(start.handle, error);
> e_free_session:
> 	kfree(session_data);
> e_free_pdh:
> 	kfree(pdh_data);
> 
> 
> However, I don't know that that's a good level of abstraction, e.g. the struct
> details are abstracted from KVM but the exact sequencing is not, which is odd
> to say the least.
> 
> Which is a good segue into my overarching complaint about the PSP API and what
> made me suggest this change in the first place.  IMO, the API exposed to KVM (and
> others) is too low level, e.g. KVM is practically making direct calls to the PSP
> via sev_issue_cmd_external_user().  Even the partially-abstracted helpers that
> take a "struct sev_data_*" are too low level, KVM really shouldn't need to know
> the hardware-defined structures for an off-CPU device.
> 
> My intent with the suggestion was to start driving toward a mostly-abstracted API
> across the board, with an end goal of eliminating sev_issue_cmd_external_user()
> and moving all of the sev_data* structs out of psp-sev.h and into a private
> header.  However, I think we should all explicitly agree on the desired level of
> abstraction before shuffling code around.
> 
> My personal preference is obviously to work towards an abstracted API.  And if
> we decide to go that route, I think we should be much more aggressive with respect
> to what is abstracted.   Many of the functions will be rather gross due to the
> sheer number of params, but I think the end result will be a net positive in terms
> of readability and separation of concerns.
> 
> E.g. get KVM looking like this
> 
> static int sev_receive_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> {
> 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> 	struct kvm_sev_receive_start params;
> 	int ret;
> 
> 	if (!sev_guest(kvm))
> 		return -ENOTTY;
> 
> 	/* Get parameter from the userspace */
> 	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> 			sizeof(struct kvm_sev_receive_start)))
> 		return -EFAULT;
> 
> 	ret = sev_guest_receive_start(argp->sev_fd, &arpg->error, sev->asid,
> 				      &params.handle, params.policy,
> 				      params.pdh_uaddr, params.pdh_len,
> 				      params.session_uaddr, params.session_len);
> 	if (ret)
> 		return ret;
> 
> 	/* Copy params back to user even on failure, e.g. for error info. */
> 	if (copy_to_user((void __user *)(uintptr_t)argp->data,
> 			 &params, sizeof(struct kvm_sev_receive_start)))
> 		return -EFAULT;
> 
>      	sev->handle = params.handle;
> 	sev->fd = argp->sev_fd;
> 	return 0;
> }
> 

I have no strong preference for either of the abstraction approaches. 
The sheer number of argument can also make some folks wonder whether 
such abstraction makes it easy to read. e.g send-start may need up to 11.

thanks

- Brijesh
