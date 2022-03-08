Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5444C4D0EFC
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 06:24:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242471AbiCHFZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 00:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbiCHFZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 00:25:44 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A913B56C;
        Mon,  7 Mar 2022 21:24:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UqpG2MNqLnTcQcgJ/BOI72uMgHArPshb+EPplqMj0fYX9Mw2GEf3Zg+SjFOlhqdGHiuG/bIvHcoX6YPKzuaYjhkkHnTRa/jJQ+yhBHfRsbWEcSoSaHeTXDto9SIJzQS+EbgZTxg01ec5PMeE4nmhRWyjT2N4XNoBACdUxWNA6H4Q6W7udbUn7uj7XhaBEhYj0ihvApT9rWgmbSpc034VIoiBcL0wD+qsCvTO5FGwp9ewXp9qX8FmTJ5Yx3cz86TD81xwufuvAOqa3bWTbjsrMaHhYSPfMode1WBLPwGTteqVu2TsRWZ5lr9l2CYOf/Np7Fd+kQJdPaCIfP0/sWdN1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aHBp2YQ+04wv3mP8DDVx6VEXWm8SLR3WzKPwMZPBNs0=;
 b=X9BT82z9KO6tF3R9aF29rcmhLG1KzTvaVY5AEjS2Mkpp4lctKM8O5cO/KFsYEX1cXQXTgu7QZUKwj1YEQ17ULKakCFY+srBGVKF5Gx/mOzS9uysqG58Q0WS5rTNQsslJ70UWSHD7OlOQK+ApdSFCMq0Jo0dGQPIIeMYYkU6BlAxmSdbOOryGTwJmnngP87hr3f5AgiSWAoADXYs8PSAqv6Xgw/JX0ze1RXUVUrNDWZ0KiAAAnJiL63/xtq8IT0jSS88FWZMzwspKojDb0vjEXmnYboBiR+o1frCV5BHEwieUMW01MaJH+VHbBYyrK5HOEBWRE57fnF9Vzmf7P0hp4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aHBp2YQ+04wv3mP8DDVx6VEXWm8SLR3WzKPwMZPBNs0=;
 b=fl32V85BIWT3aaTHtqDYnSsXIZBfQRLboHabWmKRZ/crtyuxNORBoZ6lblTVVy53LUF5MO/knoycPnV755IfOIXHdSWVBca1To1wIgFAvFR7C4uBvIYh+Z66RMAtZKMSvy9lJZzuS7bIlTks6uttz++vpagDAo2tgfsH8UZIoX0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM5PR12MB1738.namprd12.prod.outlook.com (2603:10b6:3:112::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Tue, 8 Mar 2022 05:24:46 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::6807:3c6c:a619:3527%5]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 05:24:46 +0000
Message-ID: <83cc0a88-b212-c3f1-a2d5-68142344245a@amd.com>
Date:   Tue, 8 Mar 2022 12:24:37 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC PATCH 08/13] KVM: SVM: Do not update logical APIC ID table
 when in x2APIC mode
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
 <20220221021922.733373-9-suravee.suthikulpanit@amd.com>
 <55c391a51bf6b7d3927493ff56333e9846e04a4a.camel@redhat.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <55c391a51bf6b7d3927493ff56333e9846e04a4a.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HKAPR04CA0012.apcprd04.prod.outlook.com
 (2603:1096:203:d0::22) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff6779e7-fbab-483f-0fac-08da00c3f542
X-MS-TrafficTypeDiagnostic: DM5PR12MB1738:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB17386D5EA8139BB45A7031A0F3099@DM5PR12MB1738.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JFQsZll9a3wc48Orhlc2l9KZFZSLQhkaV9wkS2hpsBaiasprWfnA67ZvH1UcUT8RoaDPfwi1flX5z3BOgFMD6W4dr+VdjPGAWG8B6eyIVnRMrCAHJ/NbCMFuPN2jhYBb2CtjAC4Fs4u2RQMJQCpI5v7mendfo6Bvt7XbYc1Ww1NM1L8WHgCdlYI1j9VwMOgpFIOCaCbL8xd0G8+D/Vj4U9mWQRSyMMmzV0CnXY374BO2vIfx4tQtQKr/HhxBkTqzVwFZoX3hL85UCurfmjkQW9QMC/rbPMX3QqEwoY5cyswqCKvi0VQm5s0g0Ye6kRiBr8zHlZ1L90Ff6Ybh5ecMzVqCGZVyzl1buIXZ+xoCubcHexWefRQ73J/CtwfiA96l+uMSynaBII5Ge5bnxb+qwAZMf6iPF2u+QofQHha+mh4rykgW0dKroH5SKEe+XNzElIz0XuIg9OQWPIdBGeRCba8781OXy8wl/iWR6by/CxGZxu6PA1DYoOby+O+5aul6PrPyk8Cn08y3w9/xfcMmRzHuzP9qOxheVD7WfClQfyN+uRqdrqXTxEZHypxIqQdgNOa4X/9CPxBqLvTDQsju25Tjyo30a5mjnl8CWocxIOo28AnMic52IuA8gIw1XxCLE+BlFdxVnxA/oR8hnnkKBBQnAuK+JAuYAbUVCeM1bKrh+1xFqq+xEVNlWcb8Uh0i0Suy0YQOGoJ7ZP/ARPBQSnPWayUEa+YiUmCWxHRZ2JI/NI+GKfrfo8BuRVXSzV6L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(186003)(26005)(2616005)(6486002)(6666004)(316002)(53546011)(83380400001)(4326008)(6512007)(8676002)(31696002)(6506007)(8936002)(86362001)(508600001)(66556008)(66476007)(66946007)(31686004)(2906002)(38100700002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1lPMkFuVHNlQ21LQjAvaDhUZzUwVHdGdlpxVk9xdkhscWR1ZUpIM3BQZFZp?=
 =?utf-8?B?VytmMXpKb0N1M3RJZm5BQ0I2SjNGd0xiUjc3bmc5L3Rja294d1hNbDMyV2pi?=
 =?utf-8?B?dTZLaW0xSUlKYlFHNHlZdEZQckJsbldER3VTSEdaWmhoaWtBU1ducEZ1UFE2?=
 =?utf-8?B?dms0cTlXaVhyUlVlb2FQVEVlTFhaL2pTaWhGMHJodHJEenp1UDE1blpvKy8z?=
 =?utf-8?B?WjRKclQzZXhtQ1h1aWtWeUoyeDFxTzJmQ3RyYXJ3Rkt1aVJQcXBTYzdheS9i?=
 =?utf-8?B?cmVlUmh6d1Exb0tFTVJtK2d3Z09FV3VtWitBcktpdFVRSXcrUWlkcG9ycCt1?=
 =?utf-8?B?S0w3VjlzSGxvZHBlQ2VWc01LK09hWWptZ2k5cVBZVjhKRDFKeUE4M1RyeFNO?=
 =?utf-8?B?NVlnSXVmSjhJWW5jZmgydlJINVZNVGhnMWFFRTlnWEhsK0xsd2RXdzhKZCtY?=
 =?utf-8?B?NTUzYTMwdzduT05zekp0RkNRY3h1azl6NlZSdVZieUJTZ0FuU29JQ015a3Ry?=
 =?utf-8?B?VXlkRzU2WGJwM3pRMEFybDR1enlkYmZPS3A1cFYxMzBXbUttUFdEYldzWHE4?=
 =?utf-8?B?amdGcmNhRFZvNUZkblVnNnJraU9qVS9hYUlDTkQ2ancyMHNlTFYxQWozV3Fs?=
 =?utf-8?B?NTllMTI2dkNrNDl6OWsycVpxWXhkeEtDSkxuU3VaRlhVRzlPNkR4cy9ZSUFQ?=
 =?utf-8?B?TFRPRkNaenJML21GWWZmZ0dXMkJZeGdEOGFPYmpOSDBlYkJkQUVJRkcvMGVi?=
 =?utf-8?B?L3hLd3NlRzE4dG9hVkM3c1JJelRvTHd2ZGtjcndybUpXN3lTZi9pdXV1UDZN?=
 =?utf-8?B?d25xQnNjOW5jQ25iYmNua1ZBNndJN1NvTG1mQ3MrNG9adk5iSTVzWU41RFQ4?=
 =?utf-8?B?MExrR01SRE9zQW5PbEszQ2hUTVk4ZmhqaU1tU1ozRUN2Z3JMTE1RRHIyOGFw?=
 =?utf-8?B?UFhXRUpseWZWcHlyOENUQ1N1c25jUkRyR3JjZVdtRGJ0VlJDTFgxdDRleUdF?=
 =?utf-8?B?WHhSVkVIVUZ0VDBGQU4vSW52OCtvaWh4bjBtMmQvK2lFQWo5L21FbHVMSklz?=
 =?utf-8?B?bm54ZUg0TVVEbkpOYmRVK0JiaUdudXV2QkRnZE5LQWpTZXdXZnB0azZlclo1?=
 =?utf-8?B?OXF0K29VZnJFbWNIUFVwVTlaNTY0d0sxTWlxTXd0c093bE4yRStvYUszYnNu?=
 =?utf-8?B?amR2RUYySi9VL1VhSmlVMVYyN2ZlV21aQlM4cEZnTkhGSUpSRkp2SkY5d0pQ?=
 =?utf-8?B?WEQ2ZkFiMm94RmlhR010VDQxam1QYklTUTlzRzVRRUNsRDB5NFExZzF3dDlt?=
 =?utf-8?B?SVJYcWQwaS9GNFNORGlCOUtsbzVtN3pBdkpSL3R5S09DbUJxVDBpREoxMjBH?=
 =?utf-8?B?b3JPVjBvWmRsa3JHY0dRK3RIOVIwN1lERDl5NUhnL0pwZkxYeVlUWURya1p3?=
 =?utf-8?B?ODNpbkhBdTlLeHhsM1VnaDB2Q0RIY25QajAyWTNRN2JQTnVLR0lDUE1GWCtN?=
 =?utf-8?B?M0xwajNhT0tGOVRab1d0aURMYm82RG9mUzZoRXM4K2FqcXpVYTlTYjlDelZv?=
 =?utf-8?B?M3JFN0tBSjVUNHUvOUZqV2pqbzRtRkNCdXE5d1FyL2NwTk5XYXBxZmpDeERJ?=
 =?utf-8?B?eGtCU3FaSXl2OW1lcWZuNFNrVHg3eEdlZlQyVll0VUN2dWcrdlc1MDRqdUhq?=
 =?utf-8?B?Y0NONC9IVUlzazhtOEdrM1FpNCtXTTVoY29zcThtK1JPL2hDOHlTZitqdGQ0?=
 =?utf-8?B?aFA0dmhrL0hzUFR5TkN4Uy81VDlkeGd2ZUc0YlkyaFB3UnZVMFJzd0NSN09N?=
 =?utf-8?B?bkEzdG5zek1tVkJKYzhIdmlOTjJWSWxrajU1UmJodStibWRvWlhEd2ZCVEZv?=
 =?utf-8?B?US9maytLcnJQaGhDZ2tYWUJGbFhXMkQycEVCS1E2NEk4YXhSSlZKVmxyT0xk?=
 =?utf-8?B?VG5yVSsyWWxKSkVjSk5oTElaWjhWMEk1NTRQQy96Y3dPZmgyNWxjVG1Vd0JQ?=
 =?utf-8?B?MXhjL1Q2a3p5Rk1oWkJkY0dtMHBpL3VqZFZOOXU0dU1YQks1N3RYL2lkc0hX?=
 =?utf-8?B?enFLWFdwUHYxZlRJb0RwUGMrUlgwZUwxZGJqS3FtTXpMVDZITjZQYVd2aG5W?=
 =?utf-8?B?VzhWZjl5SExrS0paQnppS3FjOHVTOXRtMHFLTW5waXlkeTRDeGIyNUV4OFdO?=
 =?utf-8?Q?ufSvo7F3gQMEIuGT2ddJUtk=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff6779e7-fbab-483f-0fac-08da00c3f542
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 05:24:46.3309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m1V1EXqctv0npLKOVzmrMlCEpZFLQyZnsdm9SdYl1Za5tGCbukzMcghgvtL/IMTFWOQFnNYcskMyPcPTN8whpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1738
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim,

On 2/25/2022 12:41 AM, Maxim Levitsky wrote:
> On Sun, 2022-02-20 at 20:19 -0600, Suravee Suthikulpanit wrote:
>> In X2APIC mode the Logical Destination Register is read-only,
>> which provides a fixed mapping between the logical and physical
>> APIC IDs. Therefore, there is no Logical APIC ID table in X2AVIC
>> and the processor uses the X2APIC ID in the backing page to create
>> a vCPU’s logical ID.
>>
>> Therefore, add logic to check x2APIC mode before updating logical
>> APIC ID table.
>>
>> Signed-off-by: Suravee Suthikulpanit<suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/svm/avic.c | 11 ++++++++++-
>>   1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 215d8a7dbc1d..55b3b703b93b 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -417,6 +417,10 @@ static int avic_ldr_write(struct kvm_vcpu *vcpu, u8 g_physical_id, u32 ldr)
>>   	bool flat;
>>   	u32 *entry, new_entry;
>>   
>> +	/* Note: x2AVIC does not use logical APIC ID table */
>> +	if (apic_x2apic_mode(vcpu->arch.apic))
>> +		return 0;
>> +
>>   	flat = kvm_lapic_get_reg(vcpu->arch.apic, APIC_DFR) == APIC_DFR_FLAT;
>>   	entry = avic_get_logical_id_entry(vcpu, ldr, flat);
>>   	if (!entry)
>> @@ -435,8 +439,13 @@ static void avic_invalidate_logical_id_entry(struct kvm_vcpu *vcpu)
>>   {
>>   	struct vcpu_svm *svm = to_svm(vcpu);
>>   	bool flat = svm->dfr_reg == APIC_DFR_FLAT;
>> -	u32 *entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
>> +	u32 *entry;
>> +
>> +	/* Note: x2AVIC does not use logical APIC ID table */
>> +	if (apic_x2apic_mode(vcpu->arch.apic))
>> +		return;
>>   
>> +	entry = avic_get_logical_id_entry(vcpu, svm->ldr_reg, flat);
>>   	if (entry)
>>   		clear_bit(AVIC_LOGICAL_ID_ENTRY_VALID_BIT, (unsigned long *)entry);
>>   }
> 
> Here actually the good apic_x2apic_mode was used.
> 
> However, shouldn't we inject #GP in avic_ldr_write to make this read realy read-only?
> It might be too late to do so here, since most AVIC writes are trap like.

I'm checking to see how HW would respond to LDR write in x2AVIC enabled case.

> Thus we need to make the msr that corresponds to LDR to be write protected in the msr bitmap,
> and inject #GP when write it attempted.

Actually, we can setup the MSR interception for LDR register (0x80d) to intercept
into hypervisor (i.e. not virtualized by AVIC HW), and let the current KVM
implementation handles the WRMSR emulation (i.e. inject #GP). Would that be sufficient?

Regards,
Suravee
