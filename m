Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247405FBB4C
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 21:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiJKTWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 15:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJKTWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 15:22:51 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BFC4A814;
        Tue, 11 Oct 2022 12:22:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LK8m5xwUbied42egTpztrYk+lgx+uHaav8GhrSTKiFuCXOz2cJv5r+Z3zXpmCn0KVKqdXGMr0oEtKqhX2Z55fS34md7VliQIRd2HkFWHVGqsOw/bjPGHkS7veupG+G8j/p2VH4Lw3cdrwh/gNK5NTxs5p3NGbnF1Hybq928tWYNhFsyVJ2Q9oxrvj6m78s8YD/RBqtmoPu9GUJTjT6lLkZoBeuBL9R4qxHBm59/mB8UckfYaKgHDfME4TiMJYOqSrW/xiEb1plKB8bCOq5oc0a8GnPGvVTmXnB/8veTF5QQuzcbfHhzpElzdQAahVk4yIMxkA274UnYsTTd8xZBr9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KcBdaVe4fZj9kPwo7c3h8loGtAknO2WMO+cyyHNfUEY=;
 b=YahrIMlVkoz+6wzxJW7sTYrohaIY9/ZSXhaXUZzOUSHTgmykMtirVn7lY2tUp7Zbe432spAxODKZ+sJJL8KI24OwM0OgnjmESNXXDA3lV7G4DQCjzyTdAax3ixBMbI/ih9ejZVhuQERcIkxU36wLf51XE0t4RsSUu+Rs0VTzvegWhlsjQnc6EghF9xPGSItvvY7tr0y81TqmEGBxiFSI19on55SU7yyGdvGTK0MN2gLmcBqhjZoWbeudnjYukgItDm/SSTywUYBiAISQhgnh3cw2PbRSo5j/OWVoUYgGBINKSLc+xBhdt0oW0mzqIR/mTtF+sNNvdkztHJ/8iNU5OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcBdaVe4fZj9kPwo7c3h8loGtAknO2WMO+cyyHNfUEY=;
 b=ULwCKcTIIiQnfUTwCLyg8lKnUO+2xAThePfTAJNbtpDJlYcWytF8jH9x3Z20SLJ8VQH9j2CUcByz4Eham+L/ceE00OOb7+O/h7coOTAm5mIyZzBRov21NDg/ilh3jk9+5gtJj+WcDwYr+y1MalVeZpuquEwKC+oNITqLE/Mt44w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5874.namprd12.prod.outlook.com (2603:10b6:208:396::17)
 by DS0PR12MB7654.namprd12.prod.outlook.com (2603:10b6:8:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.19; Tue, 11 Oct
 2022 19:22:48 +0000
Received: from BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::ea28:b6e6:143c:8649]) by BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::ea28:b6e6:143c:8649%7]) with mapi id 15.20.5676.032; Tue, 11 Oct 2022
 19:22:48 +0000
Message-ID: <515927f6-a53e-519e-6d7b-80f26f6f8946@amd.com>
Date:   Tue, 11 Oct 2022 14:22:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] KVM: SEV: Fix a few small typos
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, bilbao@vt.edu
References: <20220928173142.2935674-1-carlos.bilbao@amd.com>
 <Y0W7J9+2P2u83EaD@google.com>
From:   Carlos Bilbao <carlos.bilbao@amd.com>
In-Reply-To: <Y0W7J9+2P2u83EaD@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR06CA0027.namprd06.prod.outlook.com
 (2603:10b6:208:23d::32) To BL1PR12MB5874.namprd12.prod.outlook.com
 (2603:10b6:208:396::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5874:EE_|DS0PR12MB7654:EE_
X-MS-Office365-Filtering-Correlation-Id: f71498c1-3ee0-4e98-36cf-08daabbdfb8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h4WgmVIFM4ud1ZwSWaTfJG20fLjJfaxX0jp4pTyJ5wW7DSPYQdfOr+z1IfVEFNPwDrNELXwN9OPRhPPVsJelcqxVED2NwQJuPVZjtbBIFcWMxV4CCwWjaMl5kyJpzwQx9YO9SN31zL9VGWThJiNot6dcCZQzBwoi3zExBjqr3MleMcHOEkvOl66ijptgHPdj+EkmC/I7gkPC++TnJLmgEoCU4V4qgp27KO0Ez7yDtvXRpzwTA0NIebh9ECrep/66Pm7qkUEY/r4onoip+5yAFe77Ofh/x4oGeNP8rDXJSGFqt00HkBlqyv6lHW8fOhWXlQn6ZXu43apetv2bX3d9FmTn9PRHh0D+gF3OPLtusKvygF6ZTWLZIBM5VdFUkLfmkaAdtwKTEr8zS1PNPs28YNDECQl54fmlmKX2VMrDL4bBdvdO5xsD0In0EpI7qQNSJ1Tz8+yfG9XzUZ5rBvcGLeU+Lyk2Hvymd7Xyd3jXnKO9/Q4ihGLeu8A8uprVi8fe2Qs2FmFSFyaHyvK/j6udcW4NzBbDzmgaVE8asGXv9sIJefeYD7gdhNfvL1QgKELfrjzR2XUEckWlZGuf4kglqsHRHanvxSt+rOj8LA2sYK4nhELvjPmGqC9pjCdW8xqZhm3AFejhE2AWNJ6zBmrYs/JtBa+/bbJhP6TU3cInLf22U2LbmePv+JEGTnw/QCOM1PrSRHNNOPeSGvta+WW4dgu0R0qP4nfP9B5Qdavrao+/6XY2yd2VsD7E/MAw9xczRePzjwSUNTJ0tHytZgiobtGt8XWU2aUe5+iFD5K3KrY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5874.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(451199015)(36756003)(31686004)(66899015)(31696002)(86362001)(83380400001)(5660300002)(38100700002)(2616005)(186003)(6512007)(6506007)(53546011)(41300700001)(6486002)(26005)(6916009)(478600001)(8676002)(316002)(66946007)(66556008)(66476007)(8936002)(44832011)(2906002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDRhNk04THRJTUgvOVNteWV4VkR1c05Eb3o2TDdkVDZEUC9seUhxdzJCaGFX?=
 =?utf-8?B?WXZLMTljL2FRMHhSNU9DYzIxVDJxWGQ1dUFYV0xXSkwxRTRLcC9WUEtoQUY0?=
 =?utf-8?B?M0t0Q2o1NHVWQVg5RXZ3SWdGZ3NZSWl3RkdkNG1pTDl3SVBMRjZ1dXV2M2ZH?=
 =?utf-8?B?Wmo2WjFVdjVyTmNkZ05wbmlyWjFob0VwUEp3bnJrS2o2UEFrQ2VHbXA1NE0y?=
 =?utf-8?B?dTlOTko4QjdoSEhFY2EvRCtIU0xDR1JPcFVRYU5WUzQrMEowSzNYUlBrVnQy?=
 =?utf-8?B?M2dXakQ1WlVlV2FLZEEzM0MxMWh2bmdXTUppQzAwdWZlNCs0S25wVmZ4eTI3?=
 =?utf-8?B?MVprMS8zczQvVFJmTTNHS0Q3M0tTRGIwbFFRV2hya1Q1Rm8zWGFWaW5Ea0N6?=
 =?utf-8?B?Ti9ZcVloTXVmUjh4MXNUaTd3TTBMMGduVVorY2NtdENsc1hWWENQbFRBd2R2?=
 =?utf-8?B?SC9GR3NXZk8vc2Y3QzVnMUNyRXJncHlqWTNmQm5YUHp2SldMRU1ZTzk3dzJl?=
 =?utf-8?B?L0NBNlZabWQ0VkcwaTlrYjU5MHdxcDErM3N3NG03L09FT3ZUMitIdHFwZzF2?=
 =?utf-8?B?UWt5ejlxZ2c0ZG5UaWpLRS9EVlIxajc4Qmh0UzNKbk5McyttNi9peURCeGJj?=
 =?utf-8?B?YTNQY2VKU1N5Qm9VbWFuU2xGVm1YNnB1NjNFNVFmbE95YXJhY1BXTDZ5STBB?=
 =?utf-8?B?bGJDZG9OZHdCY3o2OW1Ud2NlZ09JVFNqZ2d5ck4zV2JZdWNXdEowNjNIR1hv?=
 =?utf-8?B?VWpVYVltLzI2eituckFuamxNOFJmMHVHcXVXbmFTa3RoclRVa3oxUm9LaitB?=
 =?utf-8?B?K1BQekZtREFSVGhJSFFWSk9YVG9vV0laOHVPTUF5SU5yc3ZVekJPUFBYR1Rp?=
 =?utf-8?B?eHFabXdEb3dVVlBWb2tPeEY0S0lBL2hOaHA5VUdQWEtTOVFKOUhKcEZGd0tt?=
 =?utf-8?B?NVBIZHd0MjFBWnF1TUJTamNJSDZiVTJjcjB5V284TWZqOHd3eTZKSXk3Zmxq?=
 =?utf-8?B?SEtQMUFEeDRIZVVINmFCWjVId3RCeHNNdnBHWnkwcVQ5dThMWU5JRVpkcXlt?=
 =?utf-8?B?d3RReUk5N2RwcjR6dklnN0xuaVFNSEpJUWdqOHRNTml0Mk84ZEZSRzB6L2l6?=
 =?utf-8?B?R3R4YXUxbTBIUlY2WUhpM24rUFl2TjFTcU5seU9MTTJtS0NWZnR0YXU1WWtv?=
 =?utf-8?B?TC9ZNG5qQllBMXdkcW1PSjBQWDNuWWtnKzBLUENGNDkwZi9iY1NUcUxEWFJS?=
 =?utf-8?B?NDJ2NUszSUlVSitxVHltcHBqdE9oTGUzZHNOVXBsYWhTVVJHSFhaSng1TXN3?=
 =?utf-8?B?dTVPK081eTJqODdmdno2TUNYTExoWnNQaXVUbXRodXpmQmZwazQySkJUbVRH?=
 =?utf-8?B?WEw3RXdsR3hUSVFqQ3kwamp1dU11MDduT3JGc2g5dmd6U0labjJjZVdYUDBE?=
 =?utf-8?B?S2dxd0dna3RLbFp0TEVKc0hoYmNNUG1EZTloaDNaRmdCZ1pGcC94U240d1VN?=
 =?utf-8?B?akJueUNMZTlURFhZa29tRVE1cWo0TFhoeTNLT3lpTzZmRHhubytIQ296VzhY?=
 =?utf-8?B?Wjh2eDRyYk5Lc0lNTExlV3F1Nk11T1l3MlBpZnhFd05rZ3hPM0ZlSDV4am5Y?=
 =?utf-8?B?Y0hwcU5LWGZqSzVueC9qTWdDaHdyVzJzbE9ZQzljVWtmVHRBdFpBTC9LV1Ir?=
 =?utf-8?B?UlNtQTJQT0dCbUdhTW1ibnJCWldYZlFjSUtSMzMvb1hDVDkybis0L21nSkpC?=
 =?utf-8?B?cWtzN21DQWdzK1F6enFoMnlhV250NlI2Z1I5Wlh3WGdxbWJkemlEM3JMWkhq?=
 =?utf-8?B?cEtCUkVQcXRrVmtmTWhlcytIVHB2MGt6VithN0xwYk5QM05YR1l3UFRBcEhW?=
 =?utf-8?B?U1J0NWFTNGl1YWxDUjIzU3lCV1M0N05kNzU5L2w3Wm1yLzl1eVR2UGsxMVI1?=
 =?utf-8?B?UERCaWFhYTAyVFRJRkZ6ZFNsWXRDQjZoL0ViOEpmSDFvNE5VU0hvOFJBN0cx?=
 =?utf-8?B?VHdsaSt4OGswbnJHZGkxOUpUZ2dXWkRiSjF6ODc3Y3BOVXpBS3BTUElnRlRw?=
 =?utf-8?B?a2xJaHBkN0k1L2k2dyt5UWttZzcwOVRBUS90UEp0VHZBNi9iaCttVklnNUJm?=
 =?utf-8?Q?uaza1LcuZU59yV3pUKEQw/AKt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f71498c1-3ee0-4e98-36cf-08daabbdfb8e
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5874.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 19:22:48.5634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gbPi8XGL5ExdPho9BKN6JcAzBtjFXyARw0ZwJ2PelklUu47NS/7TXD10YwG+bae+ilw8Uk0HU0Kl7D81qmOyMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7654
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/22 13:51, Sean Christopherson wrote:

> On Wed, Sep 28, 2022, Carlos Bilbao wrote:
>> @@ -3510,7 +3510,7 @@ bool sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu)
>>   
>>   	ret = __sev_snp_update_protected_guest_state(vcpu);
>>   	if (ret)
>> -		vcpu_unimpl(vcpu, "snp: AP state update on init failed\n");
>> +		vcpu_unimpl(vcpu, "SNP: AP state update on init failed\n");
>>   
>>   unlock:
>>   	mutex_unlock(&svm->snp_vmsa_mutex);
>> @@ -4170,7 +4170,7 @@ void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu)
>>   	/* PKRU is restored on VMEXIT, save the current host value */
>>   	hostsa->pkru = read_pkru();
>>   
>> -	/* MSR_IA32_XSS is restored on VMEXIT, save the currnet host value */
>> +	/* MSR_IA32_XSS is restored on VMEXIT, save the current host value */
>>   	hostsa->xss = host_xss;
>>   }
>>   
>> @@ -4223,7 +4223,7 @@ struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu)
>>   	 * Allocate an SNP safe page to workaround the SNP erratum where
>>   	 * the CPU will incorrectly signal an RMP violation  #PF if a
>>   	 * hugepage (2mb or 1gb) collides with the RMP entry of VMCB, VMSA
>> -	 * or AVIC backing page. The recommeded workaround is to not use the
>> +	 * or AVIC backing page. The recommended workaround is to not use the
>>   	 * hugepage.
>>   	 *
>>   	 * Allocate one extra page, use a page which is not 2mb aligned
> SNP support doesn't exist upstream, looks like this was generated against an SNP
> branch.
You're absolutely right. The only typo that's upstream is "currnet" in
sev_es_prepare_switch_to_guest(). Not a big deal.

Thanks,
Carlos
