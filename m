Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902A84ED2E1
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 06:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiCaESz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 00:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbiCaESX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 00:18:23 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F81E1834D4;
        Wed, 30 Mar 2022 21:04:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IT5ajtSSDaeXvzOD3yiomCD+djGTQtL+unhno8B0R6BY4yBUwJvN050lvKSl2iYVg53DsoDTyDkeg/m6ewLs/dTwo2azH2dxh4OCVPAzdFxcmBstlP5IxgddXS54QShWvTg8rfVI0w3jGNG5vB3WiqwwoN+CwcM2X9Ut9sdVG+jn1pNWr4RVASx3Ra+jba+mXsY/YMFrAa0cB4vjELu6C7k2RXNXocvd6ATiuhfRXCYf9YAyhkSKW2OgYlBwkGbV3Xsd0RLvSB0LuKxzN3/e55B3jWlsARjCo3GjXstjDmbYyaecPXCMiKfjBie7CosEjMX+eaJ9Ti/VH9v4lfAWww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IhTNiy/2uLS9UqCtPfASgDRCWOwO+YWCSE8NDLA8QXc=;
 b=WV1tNRvDdDUnUmbSEWSGVnsUHqZ3BsioV+kR9c2jcJEa6OR+Sn/aDGLey3vI/QFjBK+aVXyR/DqD34eBtHqZrF423NFrZqmexD90nck0R27Gmi0yBSg0m89Crv8OeJS4yJJyMW+1E3lLO0Qm2GbFYwuzvjluvaiCP5GYyf93J0XwR2xZUDkvLk4GLsDjlaMqOfeDaqeWpHqrl82vM8GuT2VneA5jTTC5zbWS8KMpooTcm6Yl6VvPHCg+vOwZmBqiWOhJv95UmnvVdeU3X/2dNKt7c/HBVNrKw7FgdWod36r9uO0ggePuxwGLM3kmInlDMJkGV7xB80bhWNDQv0ucSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IhTNiy/2uLS9UqCtPfASgDRCWOwO+YWCSE8NDLA8QXc=;
 b=45/QsZn1VBJ0WqW2fMH3SiZin6kE3lyv2bFt4ZXlp88zNhei5oIPzuXZ+skIan1olSqqLskMrqW6L4sA+V/thi21ZZtDSxLelrx52Eh2bQVyD24H2UlwSAmOsZ/gFHcjkJC6pIzo9obDPzMrhuzzjn7v34qLiwD1PXMT26leTLc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 BN8PR12MB3460.namprd12.prod.outlook.com (2603:10b6:408:48::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.19; Thu, 31 Mar 2022 04:04:34 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::e0d3:d505:3bd6:e79]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::e0d3:d505:3bd6:e79%5]) with mapi id 15.20.5123.020; Thu, 31 Mar 2022
 04:04:34 +0000
Message-ID: <ad4c2a2f-9b9c-23c8-b64a-826943c54459@amd.com>
Date:   Thu, 31 Mar 2022 11:04:24 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [RFCv2 PATCH 09/12] KVM: SVM: Refresh AVIC settings when changing
 APIC mode
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
 <20220308163926.563994-10-suravee.suthikulpanit@amd.com>
 <91692f799dfa1d064b8f2839789869aebcaa6c5f.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <91692f799dfa1d064b8f2839789869aebcaa6c5f.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:4:196::8) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3970fccc-309d-4a98-e1e2-08da12cb90c8
X-MS-TrafficTypeDiagnostic: BN8PR12MB3460:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3460325E599101878B85B376F3E19@BN8PR12MB3460.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5i+9RPwfr3flA9Bj05xTEmjoefajFGR7t4HIvCXuX8FJa/ELiIZbisAMOoydXewTYwVPYcs2vgQ/hmCn3XxOW5tgVSBDHuvAg5Jm6vzulUOPoIH5Ea1QwVXLirYbobtkFLCHR55QiBs83q4IB1W551/SjXgbJfB9WZuJKNbl3Z5BHWCnhkaFBGe+7DLQXxkz1wk93klCsYsCKosbNzelChhKMAuEvsDsM35o0rGiPjrZRqlK3zchohRo0NPCPqRozbuAPzsNMXa5TKMkY3RrRxpM+xj1WK06erv0wePldJ+HTPFTgcCVqDYHjEq6T9g6+rAmSnyVlTXGnmcflPgeZKoTIQErBs6fLeXBjGv87xSya5caewx3Dc5xHevjHX0UYnYs5/Yszel4I/9SZqhoGlxkQIWjUZKZZtoUR0Km674FKT6/IVnWZ1+ffQFpw9ct0nyvitUZjYYtvTcxdFomussN2ipuZ0cszXo6bnfDnxL3msa5QvWsmjRFHONhmpPOmArATTxKr3ZgKLcXvqKNzeioYKTo7HXF4foadpL1vustl1LTx8oatEVEZEoPbkc3gb9r8/lhRBPbln/JqtZ39HNAwbkaPHexIE4mkzLFSmTXgEbrA5hOrDNK9XY3h+sfIUu+27AAIswZcT/mjoRSwIP9jLIJD2CddPb9HtTm45Kc4j0G/k7o4KngL3CvPsJ2LHX6r3e/3zGcCxgxxpT3jwdDBjutfKn3okNZZj7D4RU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(86362001)(186003)(53546011)(26005)(2616005)(31696002)(6506007)(38100700002)(83380400001)(2906002)(8936002)(36756003)(31686004)(66556008)(66946007)(66476007)(5660300002)(8676002)(4326008)(6486002)(44832011)(508600001)(316002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlM4cGdpdnA5NVZyd0JDR1hsSkkxNXlXV2d5RmRSQUZKMG1NRUkvUzBMdVln?=
 =?utf-8?B?OGZxVm1zWDdEVjZ3M3RzM0p2OWIzMlhVRFFPa1RTeGNNMGhCREdITU1jTnUz?=
 =?utf-8?B?STd2dWhpa0lreXgxMjJRUkdRUEtlT3hlRmdMa1drbVZHakIyd21MbFhXaHp4?=
 =?utf-8?B?d2d2R0lNQ1V6Z1ZvczRuN3BoMGtsdllwUFBDa2wxQ0xqTWZqMzBRb2ZvdkdJ?=
 =?utf-8?B?OXpsbGt1QmZTV0VvV3I5RWZ0TU5LQnU4cVpSR2o4d21kdDhDNUluUGJNYy90?=
 =?utf-8?B?ODEvcjRnM0Z2SXp5QjJGRXRNNGRzakp5Vm1EMVhmQmo0RGdwSkd5NlVkTDZN?=
 =?utf-8?B?WWtZaXBPamoweFpsZ2JBd2dYVWR5ekxocG45Vm9SUy9YV0N6UTFuWW5IUEFS?=
 =?utf-8?B?T0JrZzl4Z2I0bUJJS3ZyZ2pOY1JCeHQ2T29QZmkxNy9wS2UydWUvdGw2S0tC?=
 =?utf-8?B?ckdONlNRbElxSytSTXo0YlBpUDNRN3Y3VXpFbHRFUUNHOGwrRDQ0bHpac2N1?=
 =?utf-8?B?TGFIaUdVcWhreTVvOGRDM0xTVmtUSWl5Zi9rRFpCVUJZbkJkRHRCTU5DQWNU?=
 =?utf-8?B?Q2x6SDZsRFpqcElTMnRKc2RjSDRlRk55cnJMbWc2Ykx1bWNNUzdPZlY1Z1Ni?=
 =?utf-8?B?a3ZjaWphQU55Y1VXcUFRdm9XRVlYTVk0Mnl2eVlxdjdFNCtRZk55NFdyYVpp?=
 =?utf-8?B?WVNtVzI4S2pacFltWjRlQlYwc3RmQlZBazJTbHczUDlJaktOWWxYUTdlcWs4?=
 =?utf-8?B?Lytwd0pZdmdpQ3NycExLVXJNWmxLdkVMbHZYcmxaeFJxRlB4ZGlVd3QyNFQr?=
 =?utf-8?B?MG9hQ0tMVGtWWno1U1ozaFQwNFZGWjMwdk9mOEVxSjk5dWZmdlpYL1BuZzZS?=
 =?utf-8?B?enhqcTBXc2p0bm1CRkMwWmxxdkRuay9Pc0puN095MlJxSWQySSsvWlphdWJH?=
 =?utf-8?B?L0JWUlF3ekVsOEVyR29JcFhjaTBuVTV6LzZFazdIa29nYjBkUE1ER3orSUt5?=
 =?utf-8?B?S25DUSs4bnlBNThIOVBNWjJhMEZEckt6VnNpay91SjZTbmU3Wm5LWE9ZeFBr?=
 =?utf-8?B?VU81SE95bDAxQU1pS3RtakxxaWFvTnVIaGttZ2txTmJFUmRpbEpubjJZRmto?=
 =?utf-8?B?cjlWb0xwOFZQUzcwRUNNUDRoZUhDMjkzZHFLWXozSldQcFpwdnlUck9YMWRS?=
 =?utf-8?B?WWhZQmJRWXpkMXVzSERxZGF1d3U5VGhpdTdPTUVGRkdrMGVPZTBWc2ZNRzlF?=
 =?utf-8?B?Y3MrNnBxenlSbDVlcDF1MnNXa0ZWTzdSSkFySS9pNjZCNnJ4WU9SaFRJemhh?=
 =?utf-8?B?SFR4R1huM0UzQkozWmRBZ3RiQldFOUZZdVVDTG9hSUxHbG82dTc5dEdYWVhm?=
 =?utf-8?B?WlJ5QWd5Vm5wSHhDelJXNmJVTHBRYlBKYzBzb2F0Z3VFMlQxMERaczRFNWVa?=
 =?utf-8?B?ZG1qU1djTjhGYldjTzZhT0Mxd09kTzNPR2VzbGtyVlh0S3VPRlZlWUVMSlQy?=
 =?utf-8?B?cEdMa0ZYTWFHQ09FRHZsOW8xL1lNQnZCMjdxSzRlOU9aR1B4bWZpMFZCODFk?=
 =?utf-8?B?RzVCaVdKY0d5dzhHZ0JTOGVNVURhWkJEUUlMRlhzWUZXeFMvSVhOeFFCc3Np?=
 =?utf-8?B?K2EyTG51QW5BQ0Fta2NScWFFa2RDcytmMEpLT21TQkhxUFBZbStjTU11ak9I?=
 =?utf-8?B?eHF1bU9PNnIyNXdzdDlGYXRxMERKZHFyQ0RPSDh3MGVSeXYybEJQZ1FQMkhi?=
 =?utf-8?B?LzRLNDRkaHJkc29MOURaRTRnL05SNVFUdmJtTm81cHJlWTRMWi9sdzFZMDg4?=
 =?utf-8?B?d1JnRHBucjJCUHNIWisyM1JpcWFocHk2R0V2NkRlYWg2SmVTNlRVZnB1Tytw?=
 =?utf-8?B?NE1PSktodzV3SDJaanlpTlhuQUJNYnVOcDRWbDFSdU8xY0ZFRk5HaC91M3JV?=
 =?utf-8?B?S3F6NmZLQ0JFZkFWOC9IL3JXc0kvUGxxR0J4VFlwYW1CNFBNU1hPejM4NHN2?=
 =?utf-8?B?MUNQNnVsVEVVMWlMZGMxMHhXNk9mZ0hGdUJTWmx5OVJISDBXakxBckM1V0Vz?=
 =?utf-8?B?QUdlVXNNVTFpbHFPODB5YXVQL0JnbzhSa05xSFpHcmZOZHV3RUpyc2IwOEhY?=
 =?utf-8?B?VG9YUng1T2hBb0RyOVRBT0pDbjBRZjh1ekg3eS9pcVBtSUtpWmY2SGhNVWls?=
 =?utf-8?B?VHJMUDh1aXVNUnpSY3ozRXk2MHdrUUNDc2wzYU8xVFUwdldhQ3QwN3JDbnhT?=
 =?utf-8?B?Y1M5UkVzQ1JjbFFZbzdwVG9Ic2tWTFJwUlJDdi94K2NyelNuVEkrb3M2TzRs?=
 =?utf-8?B?Q0RyMXRLd0Z1OGk4a0dxNWFEZ3l0K0o1VjMrS2c5SGlXZ1o3OWRCdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3970fccc-309d-4a98-e1e2-08da12cb90c8
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 04:04:34.6841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Arh5EJGEDEo0RPC38iMCg9DPRfpMEhWO4l3gXp96MWXo4f4hl/zziQq2GHRIgKSOHavnRZpi1hk7ILxt7aVPdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3460
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maxim,

On 3/24/22 10:35 PM, Maxim Levitsky wrote:
> On Tue, 2022-03-08 at 10:39 -0600, Suravee Suthikulpanit wrote:
>> When APIC mode is updated (e.g. from xAPIC to x2APIC),
>> KVM needs to update AVIC settings accordingly, whic is
>> handled by svm_refresh_apicv_exec_ctrl().
>>
>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> ---
>>   arch/x86/kvm/svm/avic.c | 19 ++++++++++++++++++-
>>   1 file changed, 18 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 7e5a39a8e698..53559b8dfa52 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -625,7 +625,24 @@ void avic_post_state_restore(struct kvm_vcpu *vcpu)
>>   
>>   void svm_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>>   {
>> -	return;
>> +	struct vcpu_svm *svm = to_svm(vcpu);
>> +
>> +	if (!lapic_in_kernel(vcpu) || (avic_mode == AVIC_MODE_NONE))
>> +		return;
>> +
>> +	if (kvm_get_apic_mode(vcpu) == LAPIC_MODE_INVALID)
>> +		WARN_ONCE(true, "Invalid local APIC state");
>> +
>> +	svm->vmcb->control.avic_vapic_bar = svm->vcpu.arch.apic_base &
>> +					    VMCB_AVIC_APIC_BAR_MASK;
> 
> No need for that - APIC base relocation doesn't work when AVIC is enabled,
> since the page which contains it has to be marked R/W in NPT, which we
> only do for the default APIC base.
> 
> I recently removed the code from AVIC which still tried to set the
> 'avic_vapic_bar' like this.

Got it. I'll remove this part.

> 
>> +	kvm_vcpu_update_apicv(&svm->vcpu);
>> +
>> +	/*
>> +	 * The VM could be running w/ AVIC activated switching from APIC
>> +	 * to x2APIC mode. We need to all refresh to make sure that all
>> +	 * x2AVIC configuration are being done.
> 
> Why? When AVIC is un-inhibited later then the svm_refresh_apicv_exec_ctrl will be called
> again and switch to x2avic mode I think.

Current version does not disable AVIC when APIC is disabled, which happens during
APIC mode switching (i.e. xAPIC -> disabled -> x2APIC). This needs to be fixed.
Then we can remove the force refresh.

> When AVIC is inhibited, then regardless of x2apic mode, VMCB must not have
> any avic bits set, and all x2apic msrs should be read/write intercepted.,
> thus I don't think that svm_refresh_apicv_exec_ctrl should be force called.

The refresh is normally called only when there is APICV update request (e.g. 
kvm_request_apicv_update(APICV_INHIBIT_REASON_IRQWIN)), which could happen or not.


However, I have reworked this part. The svm_refresh_apicv_exec_ctrl()
force is no longer needed.

Regards,
Suravee
