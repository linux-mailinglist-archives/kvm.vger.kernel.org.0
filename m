Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AFE687944
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 10:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbjBBJoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 04:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbjBBJo1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 04:44:27 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7009887597;
        Thu,  2 Feb 2023 01:43:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUmPy65v1aw5aFZXvWXjZOCYUeo4kAPGwNAD1BEYffJEaUm9i8XBuaUSDIvcPD8tTsNXByRB3ze/To9lsHFt0HFFSkNLiekJDPpQWhH1u61z6tP5y4jxQmarZIb/qR+1q0ffZHt5pU0gtemh+rn5Ubb945DA1kZrWv4GqLSaltWCi1ev17n8Bvq2J8rbj93Wv4HYdtIAedr3tcOU4WAO8HiFdQj8b5TD59rHqovsJT+WCPoyJmNo1fgw+G55YdnuHz04XfDXLeerw5HvtFcTGA0NwWhCTrR4MRf7iLDT+7mdRuieA98HrziVToF2NY6Be9Lo764Q5Sg5b9DgdHP85Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45fQumEXRGcmvB2AdAziYJpk3tepWzltm3WITh7jUy8=;
 b=aXFeYXSG1EwV5qDGkvFyILkkUg3HM59fneIutab14wk43x1zqk+Z0ifTMVrkxv8oIylaFuEHSW4oZHvxKwSjzLoZyzCZ01uTL54NhyzU9n3qKWOAVYYOkdw/LHjqL6EOIxgcuIRcD3f3RFM6akRVSAZF1++ejPRnM99QgGzuN5iRwXH6XVgILmXglR62r1TXjgfkUoRAC0+CNbHQQUKmFdbw8UyiA0OZ2RlyujeIQQksrC3W8RVSFHWtZZHCoQbCGINGXakU6CVtf2i3wE2IRa0W6DAPXNWOJbex95GFinn31vqNcv/hvK1LE8x+JBdRsWICH2P/kjBj6K3OEBLskg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45fQumEXRGcmvB2AdAziYJpk3tepWzltm3WITh7jUy8=;
 b=XTnH4JiXDiuoYDYFHEXlJ4LV1L0fhflLgb4GhaNAyQ8J2MimKEF3toVedWHkZQrgYDv9IjHNKHDKpx1gc6i9xYd4LPbz0nRbbRckjalYeoGuCjCzWq+u2F0UnI/5cyL7zgp5WsXQOhrjDcBoQADhO3UsJEiW1NK8h6vT8Jy+WkY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by BL3PR12MB6426.namprd12.prod.outlook.com (2603:10b6:208:3b5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Thu, 2 Feb
 2023 09:43:11 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::caf0:cffe:94c4:df18%2]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 09:43:11 +0000
Message-ID: <66f93354-22b1-a2aa-f64c-6e70b9b8063c@amd.com>
Date:   Thu, 2 Feb 2023 15:12:53 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 09/11] KVM: SVM: Add VNMI bit definition
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Sandipan Das <sandipan.das@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Babu Moger <babu.moger@amd.com>, linux-kernel@vger.kernel.org,
        Jing Liu <jing2.liu@intel.com>,
        Wyes Karny <wyes.karny@amd.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20221129193717.513824-1-mlevitsk@redhat.com>
 <20221129193717.513824-10-mlevitsk@redhat.com> <Y9mZRU3nbz6ru2lS@google.com>
From:   Santosh Shukla <santosh.shukla@amd.com>
In-Reply-To: <Y9mZRU3nbz6ru2lS@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1P287CA0017.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:35::36) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|BL3PR12MB6426:EE_
X-MS-Office365-Filtering-Correlation-Id: bb38b24d-55f4-4cc2-fc42-08db0501e5c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n4XF7O3aC5/pOmHgqwFBEEBlAi06sl6E/L5S5xiWPFQjicmHoXuTKDYPSmaG0qpnzeTx6/pWYgoFENinOhJKHG4PGCwOG4H566X5AFVXmnghXWchV2onO255TfEAcyEh8d+6hMtBcShdZSbdMvRZRszHp3Bn9KtnqDKjn1bl2KUAhkW+mGUV2ZncfQgt4xnpD2GQqxfNaC2Bjz4sFqL/8Hk7Xk8j+P+8fkUF6PvnjKetUy//AO+rPKCWVn9siAgFjO+hOvUrZdSOmNw6UAr7ny816O27HxZ31d17vc2XXA8/9ziw0fLzfzliWynnmVgA6zcfNXx8suJvewjPzoN5fH7Qcb3wP+Dc5voAecRCtNJUUwW0Efj+1RY/4SisH3oTca3Lmr+MFWwx/VFWhRduEkczZUbMa7wvOV6VGX9BK5WaE2kVH6w2Moy2A6p/H6HbfUXMCI5RhDcZ40XWTOSG215wYt4lqcjGfPBj/OREb8BwNq4vzRHqhueURRht36sZa5kX+o58lmtZejZOJIDCwetOYwynejTAQ2G5dZRUqmUuRfaapFjQp676d/jjOamdVPrAak3BIkinx5MAPB22VdZPtmP64rBeELCIKFnmP/S30ZxMQ+xSV4yt3qLcUajpqtwqkvtrDigzOXtBe52d+xQnSUnN2bAGCvGHMEqAD4IHHhUPnQ4+NabsD41DyzDet2WmKXbjUiuT+dVwZ3KxNYRxeLDSZUokwyLf3BU3oyA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(376002)(39860400002)(346002)(451199018)(110136005)(8676002)(54906003)(66476007)(6486002)(2906002)(478600001)(316002)(41300700001)(8936002)(4326008)(66946007)(44832011)(5660300002)(66556008)(7416002)(86362001)(31696002)(38100700002)(36756003)(2616005)(186003)(6512007)(26005)(31686004)(83380400001)(6666004)(53546011)(6506007)(55236004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGE2Vm1iRkhFNFVjeVVmdDhPZ1dpVHdkQUdwVFBzYmRJcUZOQlU3SlBCMlpY?=
 =?utf-8?B?b25ac05DeXpvUHBJWU9vUTQ0VXRQMjMzYWdKeVdHSitlRDQyRCthcFBzMEs4?=
 =?utf-8?B?bXdwOVFDeWlDWUxjVWFXYUdCRi80RTFhejJhRDdvNERqb2NOWTZHVWNBWFNK?=
 =?utf-8?B?R1VmSEV3ZEc1bkt1YlF4bjQ0aitKRm1obS9VV0wxdUc3S2NLUXBKVGJnajFo?=
 =?utf-8?B?K3VDKzdyR1AzYk0vRFJFeUNkazBYekJXQ3JtdFgvRzhFdmZ5Sk1HVWJYRTVJ?=
 =?utf-8?B?REp0T3dsNHlYL1NZRm9PeVM2akxTN3VKSVppbmIvMmM0L0ZMYm5ZdUg1WUdR?=
 =?utf-8?B?bjJQUDYxSmt5MVJySVdPYU00LzdrR21KKzhIZjlPbXFVUUZTVWo2blZyU2dm?=
 =?utf-8?B?MENlRklRYzYrRUJCZ0Ira1ZFeEU3VndqWi8rUmdwaE5FNkwrM2dFYVlZNloy?=
 =?utf-8?B?cm1XZHZrMjgzdjR2YzhhYkd4L3orbi91b25NaGhhcnk3MHk3ZHZJS3RVMmtD?=
 =?utf-8?B?UENnV1lWYndnaW42NHdnd29WS0IzZC9sNTBSNmJzUXNKeXNCZVFWMjFDTFEw?=
 =?utf-8?B?dHdab2Job3dYZksycTJvUUJzTSt2QTZDRk0yVmVyZnpydGs4d012NlEycEYr?=
 =?utf-8?B?dDYrSThvV2tJOGxib2VOaS9RdmczWHRnQ1J5Z2hVbmVJbTcxRTZZSTllbTBz?=
 =?utf-8?B?MTlPekFLMWpwMFdxOHF0bjZkdGxlNFpwZVRyZng3ei9qVUtISUNCTjFsckpi?=
 =?utf-8?B?TkZTRXlpb1Rhc3dubHdZamJ1WUJGc20za3FHekUvQVlaMXdqOVl2b0ROa0l1?=
 =?utf-8?B?bmRHUWdpZ25idTlyQy9WQVZGQnVxQmNiOHpUdDBaTlE0R0xyc2x0Zk9KZFJD?=
 =?utf-8?B?T25RaUR1QnB2OFZ2Y21wb2U4MVRyQVFHNXpqcitUdnZHWGMxM2k1SHpsUHNG?=
 =?utf-8?B?VTNkeUlIMDRpVStnWFVoYmxjU1VJd3FWWUNyOXFFSUxubThjV0tMdEI5a2Z1?=
 =?utf-8?B?VnFNdjZtdU1ZU0ZFWVVKWnFWYW1GUUJuTkd1cjlOMTJCRk5jMGhicG9qVytJ?=
 =?utf-8?B?OW0rRnQyTWR1cXVWWFlNOUJVd1ZCVE44OFJoNEFjZnhTMWxzNFJ6aEc0UTE1?=
 =?utf-8?B?T29oUi9UYXJ2OEhLbHlFMmJnNE92NFg2TmhSeVRETVc4OEU3NERUejJHQUdu?=
 =?utf-8?B?OHVxWVZTRFBrUmdzRkRTdkkxRzZBVzZYb3A2MXVidXVjb2hFUGRCUWlMOTRI?=
 =?utf-8?B?OUs4UUg5MUxNT3g2WEpoamZmSkQwTlYzb3dzV1lWN2dIcWhzM0lNUFhXclJN?=
 =?utf-8?B?NU9FVzlHSm56WnkvQk9ocXphUFRjMXM5TEFOOExacy9JaHRMckU0aVdua2l3?=
 =?utf-8?B?QmVYbE5sb0tvVkNrZzdKc0pFNGFiVm5rR1JMazFpWlZtUU9PTnVaT0wwNmsx?=
 =?utf-8?B?RUtESUcwcUFpRTdQWlowbVp4Q0xGZ2FkK3VMc0NkQWZQRjBXc25uT00xSHpR?=
 =?utf-8?B?QkxXS3NzcmM0bHVIeEJxeFI5NVNoWVJYczJwdWF0ZmwwS2JlTG9TcFlyakFG?=
 =?utf-8?B?bS8zWE14c1lNSlhuMFRwaVhRMUVuN0V3SWp6a05qZVZMY0dQRVo4Wjd4blg3?=
 =?utf-8?B?WW5qT3NQU3hFdUhtQ0NQeXpwZGUvK2NQRmR3WDlSWGxMQk1oWkxzMjZMZnVj?=
 =?utf-8?B?TzZkM2tlOElHby9rb2NTSVRxWlo3L3hwRHVha21BZXpwM3kzNlgzK2JUTTl2?=
 =?utf-8?B?c3NxTkpTNTc4RUViaW5GUndRckJjcml5VktaQ21XcVBUY2tCU3I2OVBHWUth?=
 =?utf-8?B?ZGEzUmJEYnBRemZyaXpodHQwOFNJWnQ2Q3R5QXlKdm1jT3hRRjF5NXU1NEtu?=
 =?utf-8?B?SGVHcDcyMHd6Q2pDcmRJSFRmQUlsRTJvMlFLKzNkUngwNzdKam9xczFHR2d4?=
 =?utf-8?B?U0Q0QXNXZm50MzJkb0hWa1o0cnkwTjdXWjRCMDZGeHNmbnNVakI1Q0lFQkQ2?=
 =?utf-8?B?QmdtLzFNdzdYZ0N0aTVIZzA3Wmp2UXRaNzcyY0crUHIzalFoVVhYckJJRUpk?=
 =?utf-8?B?THNoeDZRQVIyNzI5Q2NDMHVlMTlkQUhOTkJzUEpMREgzaTNleXRmaE1jZ1d3?=
 =?utf-8?Q?zr5oJ18d27l9i6gPPAWeS/7w4?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb38b24d-55f4-4cc2-fc42-08db0501e5c8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 09:43:11.5222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FxfBVO73i8W4D03lQRe8QvdOzixc2Zx7xxeo8Xd8Mg76S5T7p0wBElhQVxg+goOlGtnd/AqZmWgELCMZtZpOCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6426
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/1/2023 4:12 AM, Sean Christopherson wrote:
> On Tue, Nov 29, 2022, Maxim Levitsky wrote:
>> From: Santosh Shukla <santosh.shukla@amd.com>
>>
>> VNMI exposes 3 capability bits (V_NMI, V_NMI_MASK, and V_NMI_ENABLE) to
>> virtualize NMI and NMI_MASK, Those capability bits are part of
>> VMCB::intr_ctrl -
>> V_NMI(11) - Indicates whether a virtual NMI is pending in the guest.
>> V_NMI_MASK(12) - Indicates whether virtual NMI is masked in the guest.
>> V_NMI_ENABLE(26) - Enables the NMI virtualization feature for the guest.
>>
>> When Hypervisor wants to inject NMI, it will set V_NMI bit, Processor
>> will clear the V_NMI bit and Set the V_NMI_MASK which means the Guest is
>> handling NMI, After the guest handled the NMI, The processor will clear
>> the V_NMI_MASK on the successful completion of IRET instruction Or if
>> VMEXIT occurs while delivering the virtual NMI.
>>
>> To enable the VNMI capability, Hypervisor need to program
>> V_NMI_ENABLE bit 1.
>>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
>> ---
>>  arch/x86/include/asm/svm.h | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index cb1ee53ad3b189..26d6f549ce2b46 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -203,6 +203,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>>  #define X2APIC_MODE_SHIFT 30
>>  #define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
>>  
>> +#define V_NMI_PENDING_SHIFT 11
>> +#define V_NMI_PENDING (1 << V_NMI_PENDING_SHIFT)
>> +#define V_NMI_MASK_SHIFT 12
>> +#define V_NMI_MASK (1 << V_NMI_MASK_SHIFT)
> 
> Argh, more KVM warts.  The existing INT_CTL defines all use "mask" in the name,
> so looking at V_NMI_MASK in the context of other code reads "vNMI is pending",
> not "vNMIs are blocked".
> 
> IMO, the existing _MASK terminology is the one that's wrong, but there's an absurd
> amount of prior art in svm.h :-(
> 
> And the really annoying one is V_INTR_MASKING_MASK, which IIRC says "virtual INTR
> masking is enabled", not "virtual INTRs are blocked".
> 
> So maybe call this V_NMI_BLOCKING_MASK?  And tack on _MASK too the others (even
> though I agree it's ugly).
> 

Sure.

>> +#define V_NMI_ENABLE_SHIFT 26
>> +#define V_NMI_ENABLE (1 << V_NMI_ENABLE_SHIFT)
> 
> Hrm.  I think I would prefer to keep the defines ordered by bit position.  Knowing
> that there's an enable bit isn't all that critical for understanding vNMI pending
> and blocked.

Sure, Sean will include in V3.

Thanks,
Santosh

