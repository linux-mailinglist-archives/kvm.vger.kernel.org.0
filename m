Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9FE51B550
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 03:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbiEEBmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 21:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiEEBmA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 21:42:00 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBDB28E3E;
        Wed,  4 May 2022 18:38:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZR2TWR/iUPTSu2ajKewX+xDyb8tlesE9gQDrXW9V6o3fn50KXFmkkIepHxhg/5GFakpSVMrLd8zjbrvFCKlWqfgnJBNzSoRsTT/owDxhK809OFJC/oNx5v5ZCerrrRlX+kASTRExoBHX3eClw8CazrLHIYj8DjIc2pvYTh0FqrSFRWX5DjvTmTaCpdeWnhRNJU6/p2mxTmUvROIbegKeWbboUPGt1urXkNWwwoFb234BsqyFDCXN0pnrUca3Eflku7oowyaWK4nCJJG+q7KBdSHaQKXC7OY96bWkNU3PMAedGG4iXL7VSqNh7501MLYL7OYtGAGQdXO+VnaeUoW3mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ChoiIrCvAjn/cN08CR0oB3CJcDOOlryyY/5hWZQbJ8=;
 b=UsqC8/EQE9CCjzHF6TGwA2unv5CLk5XZRpgVba074E0NQ674w3JHcQbJ2cN0lXmZcgiBYoG0Q3zvSQVQcgMf9FTCbUhYLGq7loT8suIOXv88SjQfqopIlEjxPrOODX+IaU66YlAY8abTjVU5oD7NYXs46s6Z0dyY4da99/c6og6syCdgg7Y6CyAn0ErIqZfhaiqKzi5QHS17Fmz/1uJABZVFl2d8iCc4Y+HocoAGNKCwFewOs96bwv4hhdcdiAgPNKI8euD5LMlsFWuViYIgTCzJ/Ds1AdMwHUAsPSzxEB2sCCE4ZFUDHr/nbyJE72ahrzEsiDQLvXn1ZEyc9a0jlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ChoiIrCvAjn/cN08CR0oB3CJcDOOlryyY/5hWZQbJ8=;
 b=rezwljQwpY2YWEWM2wrnOBp4xrmu3Bubbk1M2lhq7Pteq1IqE//F9kROyKXz3fkMR41qyj0HQKHHumSG2CiFptbg6qmB3vQRG7OQmj8+Qlvi6pO1TZmyKUsQim3HFqujcHzE7rnXfVJty1Q8prQol6ykHKKklzvdYHw9YFYfsJg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.20; Thu, 5 May 2022 01:38:18 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b%4]) with mapi id 15.20.5206.024; Thu, 5 May 2022
 01:38:18 +0000
Message-ID: <f308ae5c-968d-eab4-2caa-29517e5ac982@amd.com>
Date:   Thu, 5 May 2022 08:38:08 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v3 08/14] KVM: SVM: Update AVIC settings when changing
 APIC mode
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220504073128.12031-1-suravee.suthikulpanit@amd.com>
 <20220504073128.12031-9-suravee.suthikulpanit@amd.com>
 <ff67344c0efe06d1422aa84e56738a0812c69bfc.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <ff67344c0efe06d1422aa84e56738a0812c69bfc.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0154.apcprd02.prod.outlook.com
 (2603:1096:201:1f::14) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65abe19d-bb27-4a9d-c4fe-08da2e37edfa
X-MS-TrafficTypeDiagnostic: IA1PR12MB6353:EE_
X-Microsoft-Antispam-PRVS: <IA1PR12MB6353D15DC702CFC1E00265E3F3C29@IA1PR12MB6353.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AH0pdkonZCWXlsszw86JOd82bp7N1/uWVfk9nKOLNJOro93UL83j49Qp6lCgLoa68oxy1vnQrkng78Qgaebm3UMi79tfokZROZc1effqrs5GFa0ylaoW5l8vA79CeYc+XtHOO9yLqR02I29z8mF3/VdKATT+uUXdvmDceSKRxzHHHP97EuiyBheTct1bxhX2133tka8ZSntq9CkS9qfDl8SS0iLO2SEDYBxcwBVhAT6rMphR8579azyRqwKjN+crhLlzB0c2BIXNeI1fQFxAuMQZCa2A+XwEP7WZLYVK7j0KrhegJj5dZDmOAnfXiZ8rm4y37iMUCGT3ZjaE3YW98TTPO8qi0ZI2AhaFaP1OcB5Z9Q6Go9tJuU3MVy/h58TALcZ8d0/VCQ3OBPJ6EOZLNwl3RMcdj6cCP/e7AGHuxGprqpsDqOzgS1wMAb9k30mya8KWUUgqr45FMXzrD9o0KkuM86OI9WNUijQnlrLVd0d9Oh2iCCPyn/cd80w3HiXSRxo5AmeYkK9CgP7LMf0/LqYee7J/2VnC+gRRjv5ZwYomTxvfT2ZxH9VIUele/Yjq/gRJKmWeqyCrgPeVCT9woJ/aG9Wb5HtvejchIm4sYO+PiNT/HNafxx6YpkoIaiXBqKA+EUPGPOgHgpG7RdCxLkAVLBMUWAYhRzBX3hRn2nP7lIAQqHGAQnmIeuXnyHgccaRfGbsc9HN6NUodlq0UJDLriq5Ev3gvKKOhCzvjDo4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(83380400001)(86362001)(66556008)(66476007)(2906002)(508600001)(38100700002)(6512007)(186003)(31686004)(44832011)(6486002)(15650500001)(31696002)(4326008)(36756003)(2616005)(8676002)(5660300002)(8936002)(53546011)(316002)(6506007)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDBlcldnaytra3FnWEpqUmwzcGFqMTVNTHM3Z2M0VEI2bDViaTNZN1cydUEx?=
 =?utf-8?B?R3RUSUFmOTVFTEEyWHE4aTlzRTg5enhZMEdLZmJvb3Jod1FQSTdMcEgxUzd3?=
 =?utf-8?B?RkJURU5lY2VWdkE2Q0NHall6VW9CQjJVbXFFOHRweWw0WE1ncXdtUzdPN3dm?=
 =?utf-8?B?a01LVTZ2aVovMjRzRkJrV0hzcHpXa0U5S2ZRdnphYWJ0OG5Lc1pZK2xlNHpS?=
 =?utf-8?B?K1A0cXpvMndFOGxJbzBQZkpwdVgxc3pNR21vajRBR0V4eUFtRWxIQUdOQlg0?=
 =?utf-8?B?d2dPcDhzVjJGR2ZBYTdCaFN5c3hJTklzRXhLVWliV3JhU1lUTm5yRm9IbkdD?=
 =?utf-8?B?cndveW5HT0FVQ2NnK0RPK2pXS2FoTVNvcFF1UktZUjNWNTEwbjE0ZXczazU1?=
 =?utf-8?B?RkRQQTU4VWxlQk1TTERkSG5jK1drRWgzMHFZZGcrOGNBZWZtL0xERlhqMlQ3?=
 =?utf-8?B?THU4V0YvS3BLSnQzS2F4WXA4Wk1QY05qME15NW44RFJpZDZSODIzaEtBNmtM?=
 =?utf-8?B?NEFNbkdiWG5oN1ByY0VHL1ZHM2EwaFRzMFVqMlVNUCtuTThpMWVEZkMvdmFG?=
 =?utf-8?B?RFVpR1loL3pKMHMxRS90bS9obHdpUnpVSUpXbE92bTNkMENVbTZxdTVSWW4z?=
 =?utf-8?B?a1lQWkx0dFVyb3JGTzVNRVRVc2NXVDJSZ2tSdUFORFZEQkJSN09KZFU5NmxB?=
 =?utf-8?B?Q3FYT3pqQ2tvWmpjQktTRzRRTW8xSDRWZ0xUTlE4ZVYwbDR6OW5CYTNSVFZZ?=
 =?utf-8?B?RWxnYlZDT2UwQmI0cTM5WDNrSWlsQ1BwVTRTaFNUUHY4aXlyblJGRXlRUVkx?=
 =?utf-8?B?WUZreGtmSU1LOEY0NUFyZ0lyVmVWTGpQeUJjcCtEL3NUcG52NEllVEJndnp3?=
 =?utf-8?B?dVpLR3hhU091dUJxNWw4ZDRBY1dxeTk1YVJqQkJsSTVTUDYwUUErcmxvdGsz?=
 =?utf-8?B?TkJVWWs1cjZQSkg2azh1YWw4ZWJHcm9oVmM2TTBZdFpwZENkOGp5ZnpvbVZU?=
 =?utf-8?B?VEt2REMwdU00ZlF5OEs2UUNoUy8zZUdLUUhXakVoM3JsWEYrNHc1endkK0tP?=
 =?utf-8?B?VDVWYlVvWWNlU3pQM3d0Wi9MU280cElXWWRzUS81SElPd2kvNVZkTGxlekFS?=
 =?utf-8?B?MWZHT1V1VFpGM21KeUlOSWdSbjBnVzFyempISjlVem5ua1psd3dCdTNzcEc3?=
 =?utf-8?B?bndITE1tMVdmVXI4dkJnNFNRRVVnSWdNeUgwYjNLRzhwWTBMRmdITmRuZjJn?=
 =?utf-8?B?R09iRkpsREFLM2FUUWRmS0tUTHBVcDlwanFWcDdkc25qZDNkd3pjajg4WXpK?=
 =?utf-8?B?QmFnVHFXdkJWTDRWc1NRQ1pCQzdxejEyNmh2dmNKQ1dDUTJzUzJ4RlJvcjNZ?=
 =?utf-8?B?b3I3YllwTmdOdGlwZnI2OVlValpKdDg2VWRsSm51dUZteU1nQ1RYeUNkUStX?=
 =?utf-8?B?VU00bndxOUxxYUoySEFkV0ZiQ1RuSnVLWE1SdVY5QmNaQkFibGtXRUJZUHhQ?=
 =?utf-8?B?di9nQjAzWm1BR2lucFVGWXI2bUc0MzVTb0o1blBMRWQrYkw2TEJtQWh3bU1i?=
 =?utf-8?B?bW91VlcweHErcHM4eUFJb2cvdXc4SWx0QlhPbE15ZVVXTDMwYXVabVZIa2pS?=
 =?utf-8?B?dG9DTXBKbXN1NU5wNVdaQXFuRTJvVElBODhYRW85eGZ0RmVyNS9iQjFPbEgr?=
 =?utf-8?B?UUZxQmQ2Q3FFeklMZGF5KzM2YXpxdFkvemJ3b3VVTis2Y2Z5aFNUUnJhUExk?=
 =?utf-8?B?LzBIVUpwREp4VEU3b0h3MXR2UXd0MlUxQzdPVHhrMVhLamQ3RmU2cWl2YUtq?=
 =?utf-8?B?UFMvam1tVDFOeVFudHB5Y1RkaTIzVEkyR0sxbTBkYlhKVCtEa3FaWnlLZXli?=
 =?utf-8?B?aDRQVk5OZFRaT0tvSVZzdjYwbGxCVmNOVDVLQ0ZNdFA4bmxrTmhvV0FUa0Ns?=
 =?utf-8?B?VnNHZ1pyRXltaFNwZUhIdzR0ckVyNWVoVW91VWQ0ekp1UUcwUGp1d01wTlZi?=
 =?utf-8?B?SENjaVJRM0Y1RTFsQWlQc1FqNEN4ZlFKL1ZKYk8vZEdzRW8vd2c3dzgrc1ZQ?=
 =?utf-8?B?UlNjT0JRYjFoNVhmMzJzNjIzRUJGT3JhVzRYMjk0bTFTSDlFUXRBazVmeGxK?=
 =?utf-8?B?S0RhNkZWSE4wV3M4VVg5NEFmYUU3TWozaVVNaGlPdXBkUnU0SGZUbjl6YjU1?=
 =?utf-8?B?cXo4QmtqOG0yMmtHMW12RHcxUmZxYzd1RjMxU2dkaCtXVXBDZUlKZXZzYU42?=
 =?utf-8?B?V1V3WDl6MFVuR0s3TTYvaVpMVjhSME1QV2l1UlI2TlZmS21JNm5sYmNnY1RU?=
 =?utf-8?B?NDMyTkdTcjBHT29CM0RET3JaZmdnV1EwYXV3ZUhEbXNZSzZNRTNid0JpaU5m?=
 =?utf-8?Q?r2+GHDLcgCipf5kMfFx9nIQO0HYb1HJ4MPCq3pTsdcjRX?=
X-MS-Exchange-AntiSpam-MessageData-1: FdAgH0ALO1qADg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65abe19d-bb27-4a9d-c4fe-08da2e37edfa
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 01:38:18.0486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QDoGqyhqXEz1PLkWhPneVqlZO1fqlELEIZfPLbBdtMumifNR1Ya870TMMTjOlBNhREFE67Vr4QC/sgQKxsKJ0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6353
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim,

On 5/4/22 7:19 PM, Maxim Levitsky wrote:
> On Wed, 2022-05-04 at 02:31 -0500, Suravee Suthikulpanit wrote:
>> Update and refresh AVIC settings when guest APIC mode is updated
>> (e.g. changing between disabled, xAPIC, or x2APIC).
>>
>> Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/svm/avic.c | 16 ++++++++++++++++
>>   arch/x86/kvm/svm/svm.c  |  1 +
>>   2 files changed, 17 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 3ebeea19b487..d185dd8ddf17 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -691,6 +691,22 @@ void avic_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>>   	avic_handle_ldr_update(vcpu);
>>   }
>>   
>> +void avic_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>> +{
>> +	struct vcpu_svm *svm = to_svm(vcpu);
>> +
>> +	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
>> +		return;
>> +
>> +	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID) {
>> +		WARN_ONCE(true, "Invalid local APIC state (vcpu_id=%d)", vcpu->vcpu_id);
>> +		return;
>> +	}
>> +
>> +	kvm_vcpu_update_apicv(&svm->vcpu);
> Why to have this call? I think that all that is needed is only to call the
> avic_refresh_apicv_exec_ctrl.

When APIC mode is updated on each vCPU, we need to check and update
vcpu->arch.apicv_active accordingly, which happens in the kvm_vcpu_update_apicv()

One test case that would fail w/o the kvm_vcpu_update_apicv() is when
we boot a Linux guest w/ guest kernel option _nox2apic_, which Linux forces APIC
mode of vCPUs with APIC ID 255 and higher to disable. W/o this line of code, the VM
would not boot w/ more than 255 vCPUs.

Regards,
Suravee
