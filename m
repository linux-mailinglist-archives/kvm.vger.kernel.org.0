Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8A34F2101
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 06:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbiDEEBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 00:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbiDEEBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 00:01:00 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391F9B25;
        Mon,  4 Apr 2022 20:58:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVN6IAGthx2Wy0uBv9DcQJzvzmCzOeAJYhO6tyfRHwx9MSH4XSrSDqOvEw3IUqgP/xlHdn9c03cfae4jcQC5/bpxMON0U4LVlqBcfJMEqWEaJXLuXwzJSAUONJKyoVb8X+6gupl8fT7q6KyRBbk8Josw5m/3GVVHRf50e3ORpPM0j8GUyQYU8peaE1LCYEuImxqYYIZ9NabDL8db/7+FMqPEcQ6AQfLndQDofZBtLBqQWnpilNhE915ktwk4N52wSkrpLay60G0FLwwX7ALaJM0uzHa+/hgSQ2e8gNtsPGZFznzQtx3dhTL4Pv/ChrNN30L7L9HHraUmrGN6ggSxQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yjPj0oMODvE2egXCSZcaeTasgcuUEnFUg2s7w/ACq3s=;
 b=RyN3gcFCGGEtfoOqmoTNzQw0lufoX2BiayMpbz4k7aLderqzYbq7zurfY4zx7NkbRFrWFAOsDugC/oFCD9nfQbOA/N+cpOrT5H8uZ3RNav0qXJYugceM/XU1u/W0DDWdi23c6GtQPRp0TgtfgatGLE05eCW058eqvOVwMSCss1D0v4sfIyySGslO5bliBwrtQUpA52OnPRCxKwF1AXErEwaN3FKR1vuTIuecdGXLRtMlhrQ5B4JwiH7ItRIv+swruoxApPY5vDDEn5I9avCkfP96wR5Gjntk4t7P6pqlksRslv5ykOfCcw64c92KyqCs4NBta3mYUX98UiElqyoaBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yjPj0oMODvE2egXCSZcaeTasgcuUEnFUg2s7w/ACq3s=;
 b=a7ajyi4g4ij52CS8txDqKbV3ilpeoRvEUEHYKsV/ibQkC5bPlopY9zmi4+yRYETYzBC+Wpsisfeeeo78u9gFYVfH6XQl+uNSlJW7KTJoOpFJOhOe72Fut8AmCPYdX9xsCyP8xVY/wdtPv2ZRSCyii8u6xAkz0CvI4sFDu8fGSCI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 SN6PR12MB5693.namprd12.prod.outlook.com (2603:10b6:805:ed::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Tue, 5 Apr 2022 03:58:22 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a80a:3a39:ac40:c953]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a80a:3a39:ac40:c953%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 03:58:22 +0000
Message-ID: <5876774a-c188-2026-1328-a4292022832b@amd.com>
Date:   Tue, 5 Apr 2022 10:58:10 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [RFCv2 PATCH 07/12] KVM: SVM: Introduce helper function
 kvm_get_apic_id
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
 <20220308163926.563994-8-suravee.suthikulpanit@amd.com>
 <d990c42a3ab5e8b1cbfa7775eef37ad4957147f6.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <d990c42a3ab5e8b1cbfa7775eef37ad4957147f6.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0037.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::9) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 681d7e4e-a755-4a19-bef6-08da16b886bd
X-MS-TrafficTypeDiagnostic: SN6PR12MB5693:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB56936907CAC69621983D1F31F3E49@SN6PR12MB5693.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CLYnzJ+k02EJ8exTESq2u98YVRMua+UXJ0Xyi2NNVn1Geux8mr9vqEnwMJdiG7lp+6cz44fej7fI6kE6rWQaown9EgeIAf3RgsesUg/jYsPwJVXwOg7OjRDIBMY16+cfVLU4Ex+dsq+5OnnNarGWQahLFFeNWcHJYpG3twiDstEIwtWSjKynjv1lzz61HgCc8XpTFerolnlgslwT1pm6y6kjzrMf/4er6cxNR+Xxn0ZwFJ1YwAObWFi79y5TyfAJaM8dWWx2YTQCfXbFw/1RdT9mSehpf1duiWXyi3X9z24U+c+G4PrGoWrry1WJQsqY4GWpG7fje30+7FpT8OtBp0tNpkh45/t5cFpSpkvuhnqp3iBDeoFVYSAJ6qQxO3r4pXserAYN4WiCCpPBIm7cq6SzK0ILKyQYfPIcvZbCQWkR3GQCQCOy9ITokJ8KI9eSIS3CJYnaC/J46F3Rn3cnLhnUe3wlrfm8mttlckUk1TnfqnjHXGN+Eqqay3KExHv0k+5nyHgRq/BrzsDTerfPAiS/YqVOcrYddBOLj9EKLVq+tfnNHmz9aYZdfcy0vjz5Ym8DdoGgkGk+rFSxY8hKPp4VJQkHLoj3FpEnEpDRB9lNgRIB3rRsSOdMg0yMecYt0TvZHdZeS6stwdUSRIW2PtfWjBfTXUiAa7KVREwDBAHS/oB7DhWOkAvXtcayCdWbk8OTAn7b1ahmpgJRFbUfIV3krJ35MWkd9KxsWTfMRY07CHDqKNf28hHZhECJz1X+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(6506007)(8676002)(38100700002)(66476007)(508600001)(6666004)(66946007)(5660300002)(6512007)(66556008)(2616005)(53546011)(31696002)(186003)(6486002)(86362001)(44832011)(36756003)(316002)(2906002)(83380400001)(31686004)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WS9ac3lVSzR5aXByK3RlNW1peFNjRld1clRIaDhxQkc4SkU0MENPTkp6bHpE?=
 =?utf-8?B?cFRzelFQMFRJS1NlMkFoRzMzamYwTFlvNittQlA1aWhlTWU4VnkvV3BIM0Iw?=
 =?utf-8?B?NXU5emF4VDVxdW9FeVE2QVNNQ1djUFJCaHZJcjlhaFBZd3NYOWluWVVUbFlW?=
 =?utf-8?B?ajNPRVRBU2lDVm95YlNQekVmZFVvMzNwRFc3YVducFQ0cS9QZWkvb29NcjQ4?=
 =?utf-8?B?ckFlUlEyYVJaYXdPYVoyZDBJd0MzVklodkwvZHBqNTdTUDZBM2k4MG5Nakp6?=
 =?utf-8?B?ckNjOEFEUWVvczgxSVkwdmdVSDVVQnlSaTNSblRmZk5Icjdoa2cvVi9nbTI5?=
 =?utf-8?B?Y0h1QVhueWFpZm1EaHF1RGpHMVpMdThFN3U4TG05ZzBackpubDNZb0RXYkZH?=
 =?utf-8?B?cmdqblUvZCt4MTdvcVRjdUtkTUxFakFPK290bUF4Y0xTbVc3dzNXSDdza0Fv?=
 =?utf-8?B?OGFzMVMvNHZISzRQZmZUMnJYRDZORUk3YTBRTTc2VG5lTHcyWDY5UXdBS1la?=
 =?utf-8?B?bFJKVWJTL3ZGcFZVZFk0VHpBNVVoQk81QXo2QlMreU8wMWhOT093Q2xydXMr?=
 =?utf-8?B?bGlHZjNaREI1WDJ6aXpMdVRtVy9JcFVkdEhSanRydU5iS0ZOYks2TlVVcTVj?=
 =?utf-8?B?anEzdkJPZ05jSmQzWlJpUW0yNjk1VmlXVjdBMlByRXVpU1VvQnp3Q01Sb21i?=
 =?utf-8?B?Ymk5eUpuSFhUVlZQc1NyN2dYaDlmcGVEUCs3cWhTbXI3dDA2SllFL3cweFBS?=
 =?utf-8?B?MVBxbTZndC9ZNksvZy9WTy9nRkJpR0VLajRjRTgvbW1ZMmxvVnl3WlRiR3p4?=
 =?utf-8?B?SVN0dmc4b3dpK1BDNHk3a2pYT2trUDNoclM3a2RhZzJzNHBnS0dsWkVTZFBL?=
 =?utf-8?B?d0VNaW1rYld0UjBDVkdIWURiSTRvWmdPZktpNzVmMm5nOXZHN1UrYWJzYjJj?=
 =?utf-8?B?Ulo0SlNsNHd5aHZXYndoVWxjVkJpRHFJQlhvdkNGMGlZUVNQNWl1eEFTbSt0?=
 =?utf-8?B?Y2pFRHE0QkF6WldYZndtRU0wRjloRDdDRno2VncxOTZTSUtRUUpIejhJYXdV?=
 =?utf-8?B?cUdkUkVVemdsQjA4dnJrVXBueWJtQk9FY3NYZ1BPV0kwTjVxbnpGTDhMMU5v?=
 =?utf-8?B?Tm1BbGd5WmN4OFk5SEdDK1loaWJaaVVLRUJseEd4NjhMeHVDbkd5b2FEUlJ2?=
 =?utf-8?B?R0gvcVpXSDN1dHFZRlJXdkxSS3huVS9mRXRxL1BCRWtmWGY2cFNlN1BSYWZ6?=
 =?utf-8?B?cVJka21FWjRNZ3JSYlpsZ2lYN3pSSEswU3g5QTZxMEIweGo2WE9WSGl4UWpF?=
 =?utf-8?B?ZTZPdThENVVDUWgzN3BqYUt4K2RodGprZ2dWN2RhVXNhdUlJOUo0ZERZRzYy?=
 =?utf-8?B?TkRlcldiK1RpbzE5T0E1Y0pKTCtOd0c4YmlrSG82OElNaHE3WkJ4WHVPMGp3?=
 =?utf-8?B?QUxTcFBHdm1WdWtndllYWUY3VXIzUDlEb1ZlbWpQTjB2MVp5NEl2d1lTdXNo?=
 =?utf-8?B?eEthelBJamlUSXJlS3VPV21IYmJhZHRobVp4eG4xZE1XcUtETDFzNWxaTU8r?=
 =?utf-8?B?ZjkwVXZLeDNTUkl5WWxWV0tqNlc3bFk1YUNsWjY5dllyZjZpSmE2VEFIclpV?=
 =?utf-8?B?NVpicWpjZHduNnFJaHJSRWl2YzlPZ0wydWNpa0dmM0RLcUlveTE2NFoxbXhu?=
 =?utf-8?B?RmxaWlpXSGhRdW03TG0waVkyZTliOE5SNzl1RU5DMm5Lb3ZudXhlQXNoUkNn?=
 =?utf-8?B?UVpRSC9ETnFXcGZwcStqTlZRUmpQa0FCZ1huRlI3MTZ5NmFFVWZ1U2VNV2Y4?=
 =?utf-8?B?blVJa2dFaFcrbFlTTlEvaEQrQk9nZjMzaHJDV0pEczBxMDc5ZE1Tb1RaUExi?=
 =?utf-8?B?Qk1NK25ab05XTElWM0FqcHM2MmllMGsxNlNjOWNXQ250M2N5QmdWZkxvNzJ1?=
 =?utf-8?B?QVZoZ3ZNN3dFQ1p0RjFHbVhGNk1Jc29scVB6dk1qcXF6T1I1MWR5b1VhZ01z?=
 =?utf-8?B?SklER0RXcHFpYjJBSXVrTi9Kb3Z6TlNXalZqRW51ZWFuaStpTmhIKy9ObTlO?=
 =?utf-8?B?ejZIK3lseEg0ZUxoKzdiWEt3dXlyblNCRUpQZFVTQ0IzclNOVWVVbXJTQWVo?=
 =?utf-8?B?QmF5dE5jc2Z3aHlXR3BPdDRJd0laeU1US3UzUWsyakcreFlnR2syZHpGWWZE?=
 =?utf-8?B?OGExdWpRb0tudmttUEx1QTI1bm5FdnJpT0N3QTVpWm01S2o1Y2FJVFkxYy9O?=
 =?utf-8?B?WllHeXhQblZTby9rU2V3aUNjUmxyaUhEMHltdjJ5OFlqb3ZwVXVvUk1BNjNH?=
 =?utf-8?B?QWRCMlNRTnhIcUFaY0cvRFpmdkRoclg2Mm92bXk4N2cxZW96ZnFNcGRzOVZ4?=
 =?utf-8?Q?uqJLf8Y/FVgQoqvN0cZR6qJOj2LQfKsl1zutDBihjYUzU?=
X-MS-Exchange-AntiSpam-MessageData-1: O5U1zO/WIdn4nw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 681d7e4e-a755-4a19-bef6-08da16b886bd
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 03:58:21.9534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zgX6nNgMjQAcnel8bHj5L94Z05LlwKkKcIrkxVNIOlw1XZX5xu8o+OT+83vHCSzKw5Bv50aSTNQr8sjaThe/FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB5693
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim,

On 3/24/22 9:14 PM, Maxim Levitsky wrote:
> On Tue, 2022-03-08 at 10:39 -0600, Suravee Suthikulpanit wrote:
>> This function returns the currently programmed guest physical
>> APIC ID of a vCPU in both xAPIC and x2APIC modes.
>>
>> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/lapic.c    | 23 +++++++++++++++++++++++
>>   arch/x86/kvm/lapic.h    |  5 +----
>>   arch/x86/kvm/svm/avic.c | 21 +++++++++++++++++----
>>   3 files changed, 41 insertions(+), 8 deletions(-)
>>
>> ...
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 4d7a8743196e..7e5a39a8e698 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -441,14 +441,21 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
>>   
>>   static int avic_handle_ldr_update(struct kvm_vcpu *vcpu)
>>   {
>> -	int ret = 0;
>> +	int ret;
>>   	struct vcpu_svm *svm = to_svm(vcpu);
>>   	u32 ldr = kvm_lapic_get_reg(vcpu->arch.apic, APIC_LDR);
>> -	u32 id = kvm_xapic_id(vcpu->arch.apic);
>> +	u32 id;
>> +
>> +	ret = kvm_get_apic_id(vcpu, &id);
>> +	if (ret)
>> +		return ret;
> What about apic_id == 0?

The "id" is the returned apic ID. The "ret" is to let caller know if
the APIC look up is successful or not. "ret == 0" means success and
the value in "id" is valid.

>>   
>>   	if (ldr == svm->ldr_reg)
>>   		return 0;
>>   
>> +	if (id == X2APIC_BROADCAST)
>> +		return -EINVAL;
>> +
> 
> Why this is needed? avic_handle_ldr_update is called either
> when guest writes to APIC_LDR (should not reach here),
> or if LDR got changed while AVIC was inhibited (also
> thankfully KVM doesn't allow it to be changed in x2APIC mode,
> and it does reset it when enabling x2apic).

At this point, we don't need to handle LDR update in x2APIC case.
I will add apic_x2apic_mode() check here.

> 
> 
> 
>>   	avic_invalidate_logical_id_entry(vcpu);
>>   
>>   	if (ldr)
>> @@ -464,7 +471,12 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
>>   {
>>   	u64 *old, *new;
>>   	struct vcpu_svm *svm = to_svm(vcpu);
>> -	u32 id = kvm_xapic_id(vcpu->arch.apic);
>> +	u32 id;
>> +	int ret;
>> +
>> +	ret = kvm_get_apic_id(vcpu, &id);
>> +	if (ret)
>> +		return 1;
> 
> Well this function is totally broken anyway and I woudn't even bother touching it,
> maximum, just stick 'return 0' in the very start of this function if the apic is
> in x2apic mode now.
> 
> Oh well...
> 

Sorry, I'm not sure if I understand what you mean by "broken".

This function setup/update the AVIC physical APIC ID table, whenever the APIC ID is
initialize or updated. It is needed in both xAPIC and x2APIC cases.

Regards,
Suravee
