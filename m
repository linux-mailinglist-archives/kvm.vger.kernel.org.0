Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0FB6031BE
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 19:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbiJRRoh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 13:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiJRRod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 13:44:33 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F2FDF12
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 10:44:27 -0700 (PDT)
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29IEAcZF022960;
        Tue, 18 Oct 2022 10:44:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=RJlXkdR9yuzUlUXAa5ZGo96XV9Px6IeUANEOR8r4u7I=;
 b=slRjXDAkSfWut5zMuNjakX+gFVgvtOvsg71Xm1kkIo5ciV+hLDBolIvKiuazuSaVF/MY
 U8zZ6/p4WuzHOutNrMwpgaLNJl/XXLEVVZM8Q3qtf/w/9Ym1nusan+u6yuW0fhFFR4F5
 yPPZpipc8FR2E3zwAd6yFstqcqnfYW3eXu3HLqW/14PJshXpsWKDzycjfjhanCSclRyO
 LGFy7EAwn6UB875vBmwp7AfXrOb9AztgZ6RJNpPLS0xfRBnzfguIA9SR2gNpYK8/Ksao
 DFlU/XG0E3NfvUbYgerI4eDnPJGdVBpEi8CdgwwuaVDPMZyVvZbupUUtVx8QJG5Hvp5l jg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3k7td9fyet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 10:44:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nMDxUNhElGrCtjUohivjKxPlfdNktY0bgp2LJXsEfcPGfDrSZjKCr/R2Leaqb0hzD8eXlIGjvJcxm6+cngsHuQUWtSJ03c9Ywg5bvvenCI5hN2pcxhfFDCtjiFOwLCb2yvjtYkL+q3zet7A0dZAdro9gwGjfHMpXBGUX5WwCSURFe6Lep2W/id4qp8oylSPAly1TnJitjPLVjn4T2qPxhrht4+xb7Z1BYFVp9kr2b0PtsVcASCavODcsUyMbJeu6X2UcnXzGjCU4O7D7HX+K5TUzhVJw5ve5dp7iGrUpE+7TNBIO2yb/C5fuEEF+oVNC0cffadVErKms3v4I39qY0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJlXkdR9yuzUlUXAa5ZGo96XV9Px6IeUANEOR8r4u7I=;
 b=bAOrr4lrE3IOUgq//hpxZYBm3jmVjHUE1uRUexCi2WnTQ1onnKDnKvcZnAw3WKPHLT4UTPMYhPg0IayX8fnndWGfUc+wRzZLaKDNa5LGHp4Js9pMwlBvxk4ZjjCkmK2dbhpIIk/GSysQHSiyrvhWd4sB7XpvKdWWGbKVzb+TRqngH7MJOvcp/D7rzCuL9DTMzfl5wCS/tgs6WPBWBz/6sgT3UULPE96MF9Exn7ik3jZp1wS8/SfWJiSjTWr/ynb1pojQUn6r0Nrt1YCjdy1VmTIQXapSiPCEwCOxQEWbGGSgR6e1qRvyo4IkU9uTEWyTm8kz98yZbQGutoI2IdYEYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CH2PR02MB6491.namprd02.prod.outlook.com (2603:10b6:610:35::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 17:44:07 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::a337:4fdc:23fc:f21a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::a337:4fdc:23fc:f21a%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 17:44:06 +0000
Message-ID: <a835d5c3-8742-e8f7-e810-a69a139c4349@nutanix.com>
Date:   Tue, 18 Oct 2022 23:13:54 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v6 2/5] KVM: x86: Dirty quota-based throttling of vcpus
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-3-shivam.kumar1@nutanix.com>
 <Y0B+bPDrMdJQVX6p@google.com>
 <c6700c5d-d942-065b-411c-7f4723836054@nutanix.com>
In-Reply-To: <c6700c5d-d942-065b-411c-7f4723836054@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXP287CA0006.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::17) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|CH2PR02MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: f53ec309-6b19-4c43-c182-08dab1305a60
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ik5oWyVzR13Lbr6O+6kXgw28f4wC2nO7ewEJQuTvP8tS12PH9m5HzUq5FAwluBPL4N39ETEO8GulyyBdY2gwxgdSvkPzDmvkEf4RBCe1gHard1D6WiT3bCUBTDmk21vk3cQ94HXhBXtgjuxDVMdYeAkQWx6eTx5KP67xmrM7JlqG81gkvJFK/AjGLvkpzHGomMDvekVbMU5pNI0DjdCFISA+3QPkDoOBykhNHX8bcC0DXD17tSpzL2ds67/NWSk00Fcf6rgNt0Vy1i7uQt5/RwIWNDSXznaOHZ/K8pVs3utIvsJdMEbVIgC0FvXUW1/BYNL3GGsTGTlRRjNw8bTmsn6TMyhUfx8lzzTHDeBs13KCpK30I31FMsHLHbG113nF8KUNNjJ94CIrBoO0mCwibI3/u/Uw7g84Ak2kS1SXXawIMVFtHWqzWzKiAus/7dzGx6AqKIbrb6w2zwBtZWb3UVJNqecfupPXXLuQ2eWCi92OuVS1cwID+AiLQb8vjoHn31cgX01DHXaHkqGbcWxdLZsolKOo/ZXsJY1SSO3rhuq9lzFpoKce20jYxRE3wP7Cz+laH+QUZetjpiydwTCbAwcJoEVwAAU+UBDO1d7yZJ6+9NiAGWUX/0k2CYF2V2Pvj/o0YTn/aBUyIykFj/Cx6FKJyoEqTR3cq0LoUgdUM2i60qTh7mXhSHusbgIesKnlnBoqTh0ReM4ZdifEVwHMyAEp0KMI0wCf+7y4/zoB35cKMZ2d2ysCirofkJo3f+YDCfMDBXZUQr6SkSJF05xsky6ZxMslkZ/EUzy7yR0JlhPG/9SYxndbSwrDvC8nyYX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(39860400002)(366004)(346002)(451199015)(186003)(31686004)(2616005)(2906002)(6506007)(15650500001)(26005)(54906003)(5660300002)(316002)(6916009)(6512007)(86362001)(38100700002)(107886003)(41300700001)(6666004)(8676002)(66476007)(66556008)(66946007)(83380400001)(4326008)(8936002)(31696002)(478600001)(36756003)(6486002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WlRzNmNjWWNDR0JOVWhyZnNhbmZVUUdJblZxa3VqUk1qekk3U0xBWHpnakho?=
 =?utf-8?B?YzBaaVAxZWZhbk4wWlE5WDdFMmQ3VnFzYmdFWjRndFdqOTB2bS9yNVZNSTdq?=
 =?utf-8?B?SkIyT3F0ZHZNbkdiV3FBZWtOMmZGblJDbm9IaDFORk9MZ1BFOFBObTJTbVd1?=
 =?utf-8?B?S2Rmb3p6dW5pMmlyWVRkVHpjd2tnMkJpMlBuQkVuNk5ENytVbUxvQWNMQXBu?=
 =?utf-8?B?VTBYb2U0cXd3U0NGTjFkWGZRai9mNXkyRDJmMitEbTd2L01hdzVEQ25wNDdI?=
 =?utf-8?B?R01la0NSSTVJY1lqam9OaUVFUkdOYUZQSjlEUTdnd2VkY0tRN1BHd3BhS1RR?=
 =?utf-8?B?c3JIdHFLbmlJeTFET1R5Y00wcTZaUXJCcUsrS21zUUxQUXhxL3J5cS8yUVBl?=
 =?utf-8?B?L1FyT1ViaHhYUGNQZnpkdzBRNEdySUxGSEoyNHdhajZ2YnlyNlFWZUJIUWlH?=
 =?utf-8?B?QmFBU09iOHpqSzRHb1VkRXhSZGsxSTF0bUM2TGVGeEpyc2Q0UDAvMW5qbS9B?=
 =?utf-8?B?UERSVnZ3MmVwcWZqZEZiaEFUdE5LaWZySVl2YlBmMTFNSWZ6dG5PbWpMUDN6?=
 =?utf-8?B?L0E1WXBSSFR6SGNSRDNta3QrOCs1dFVRUmhzK2YyTmFISjlKS2VCWSs1N3Nw?=
 =?utf-8?B?bWs4S0hoSE0xbmNTNTRBRklCYlZNTkZGN1lWWEVRb3UvS1lxZDFXeEFLZ2Rr?=
 =?utf-8?B?YlhJUDhDSGI2ajBaL20rcnE1TlZydUtYTzIvaU4rU1lQdVVEL3dlNHpSVzVw?=
 =?utf-8?B?MDdLZTNpVkdWaGIzVjFRa2xyNUl5ZDlVbHlIMDFJdDRHdjZPallvYmI5NWxM?=
 =?utf-8?B?TXFialRaQk9pSmdnd2FYdmVvM3FJS1g0UVlFd2JwWnFvemZHdXZEV3lZSmda?=
 =?utf-8?B?allNWnE4VkdPMmVmQjk0UFRHZUFkK21wRS9uaVFlK3laNll0ZXNBTTRlQ2lm?=
 =?utf-8?B?K0M4YmhCbGpZeHVFY05XNDhHYUlpeXBmc2ROZlpiOGM0V2YvWTRYSkx3Y0Iw?=
 =?utf-8?B?eHlMeW9ENWVyUStpNFpFaG5iVjViM2ZLb2laOWxxTXM1YS9xNUxTbDlOb3Nx?=
 =?utf-8?B?cGRhZlZjMlFDWW5DcnpLVlJaM2U1bDRxYXVOS3lvY0RIeGplb2dIY0c5cjMx?=
 =?utf-8?B?VWdoSldLQzRCcm1uWGdnZ2dwdmlURmUzOXNNUy9jdFNyeWNPZUJlb0lOVmYy?=
 =?utf-8?B?VEdTMjZjdXZ5MkFjcW4rZzZLK3dYcXBBZmE4cWZIZU92UGdORTcyMzVLT2s4?=
 =?utf-8?B?OVVZeDFyM0poMVNMU2VDTXF2R1pOUElTQXRNYU1GckE5SGN2UDY1dVdGZW9L?=
 =?utf-8?B?Z0JSd2FTSGlIdW5nak1PTWowUDE3ZURKdytKaDBJTHFMOWZVYmxtbUxzREgr?=
 =?utf-8?B?dGFrZUo2UDN2QUd2VHE3UkhWVndJQlJGYWw0c2s4MXdsN1Zzam5BRjIyWG5K?=
 =?utf-8?B?NmdiTW5rRHlocEI3SVBUYk5yZkdQSTZwNEZrSUVNRkNRajE2Vk0yUDl2TzNt?=
 =?utf-8?B?cHRsUDB6QkRubUNjY3o2U21OeUZ4VlB6MlI3LzliMUZld2pvRW5zRnNhUm93?=
 =?utf-8?B?RWZDVXZGUkR6NU5GYXROWG42QVNrU05TMmN0V0JNUEtyM24xcUsyL3l2NVZ2?=
 =?utf-8?B?MkpKSXcrR2VqTXYzYmlUWjRibU5oc0p4TWErQU5qV2hGQ3A5ZkdIdWVQd3ht?=
 =?utf-8?B?NTBZSGp1Qm9TT1lsNkh0RGN5ejJBZzR5VGpiSGY3UXVrVElGd0UrWUdDZEhI?=
 =?utf-8?B?MUVtQUprMzBZRVRWc1hFQXZpSUc0RFZrWFVpby9OVVR0ckUzem5hYkZWSzhR?=
 =?utf-8?B?ZEtrT20xbFhRWHBiTzgybkFDU1pWNDkzaWYzM1c0bStsd2FUTVljNTByZFBn?=
 =?utf-8?B?REp4Yi93eFRDNHJWK1Azb0tHYTJsRlVCTGJudUVaZXBLWWlDYm9HMEtPelN6?=
 =?utf-8?B?bDBFcVByMFlaTXk3elZBdUQrSFc3cExEV2Z0MWI1c2sxQkNtdUlMQjVhTHhB?=
 =?utf-8?B?RHZEeHY1dGRCNFZxMTVRU2lndGNZMC9MUXBZdkhDYjVYbkplQ09OVHJBMVRw?=
 =?utf-8?B?bW5TT0o2WThidG8vQnI2ZDRhVEg0NTlaeW1BQitpMTRRa0E5S1lYRkRhTUtO?=
 =?utf-8?B?cFlmV1N0dEhlOFJtMDdCZnFFcjFZdlRLZTlNOVlNQ0k5U1NNcE5XakRaK0xC?=
 =?utf-8?B?bEE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f53ec309-6b19-4c43-c182-08dab1305a60
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 17:44:06.3867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4C6aN6jJ5Y9xZQR26dV62s92qGLZ6WWwtWwHOf9FO44cxxSKvvvjOmmCSMhkrd6l206sZdaIw6wAiwcoc0oAh79c9MLqYCo5Dx+Ry2dovYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6491
X-Proofpoint-GUID: miTlREKJsjJ64Ns8R5aWjhcIlI56LzHC
X-Proofpoint-ORIG-GUID: miTlREKJsjJ64Ns8R5aWjhcIlI56LzHC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_06,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>> @@ -10379,6 +10379,15 @@ static int vcpu_enter_guest(struct kvm_vcpu 
>>> *vcpu)
>>>               r = 0;
>>>               goto out;
>>>           }
>>> +        if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
>>> +            struct kvm_run *run = vcpu->run;
>>> +
>>
>>> +            run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>>> +            run->dirty_quota_exit.count = 
>>> vcpu->stat.generic.pages_dirtied;
>>> +            run->dirty_quota_exit.quota = vcpu->dirty_quota;
>>
>> As mentioned in patch 1, the code code snippet I suggested is bad.  
>> With a request,
>> there's no need to snapshot the quota prior to making the request.  If 
>> userspace
>> changes the quota, then using the new quota is perfectly ok since KVM 
>> is still
>> providing sane data.  If userspace lowers the quota, an exit will 
>> still ocurr as
>> expected.  If userspace disables or increases the quota to the point 
>> where no exit
>> is necessary, then userspace can't expect and exit and won't even be 
>> aware that KVM
>> temporarily detected an exhausted quota.
>>
>> And all of this belongs in a common KVM helper.  Name isn't pefect, 
>> but it aligns
>> with kvm_check_request().
>>
>> #ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
>> static inline bool kvm_check_dirty_quota_request(struct kvm_vcpu *vcpu)
>> {
>>     struct kvm_run *run = vcpu->run;
>>
>>     run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>>     run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
>>     run->dirty_quota_exit.quota = READ_ONCE(run->dirty_quota);
>>
>>     /*
>>      * Re-check the quota and exit if and only if the vCPU still 
>> exceeds its
>>      * quota.  If userspace increases (or disables entirely) the 
>> quota, then
>>      * no exit is required as KVM is still honoring its ABI, e.g. 
>> userspace
>>      * won't even be aware that KVM temporarily detected an exhausted 
>> quota.
>>      */
>>     return run->dirty_quota_exit.count >= run->dirty_quota_exit.quota;
>> }
>> #endif
>>
>> And then arch usage is simply something like:
>>
>>         if (kvm_check_dirty_quota_request(vcpu)) {
>>             r = 0;
>>             goto out;
>>         }
> If we are not even checking for request KVM_REQ_DIRTY_QUOTA_EXIT, what's 
> the use of kvm_make_request in patch 1?
Ok, so we don't need to explicitely check for request here because we 
are checking the quota directly but we do need to make the request when 
the quota is exhausted so as to guarantee that we enter the if block "if 
(kvm_request_pending(vcpu))".

Please let me know if my understanding is correct or if I am missing 
something.

Also, should I add ifdef here:

	#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
	if (kvm_check_dirty_quota_request(vcpu)) {
		r = 0;
		goto out;
	}
	#endif

Or should I bring the ifdef inside kvm_check_dirty_quota_request and 
return false if not defined.

static inline bool kvm_check_dirty_quota_request(struct kvm_vcpu *vcpu)
{
#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
	struct kvm_run *run = vcpu->run;

	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
	run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
	run->dirty_quota_exit.quota = READ_ONCE(run->dirty_quota);

	/*
	 * Re-check the quota and exit if and only if the vCPU still exceeds its
	 * quota.  If userspace increases (or disables entirely) the quota, then
	 * no exit is required as KVM is still honoring its ABI, e.g. userspace
	 * won't even be aware that KVM temporarily detected an exhausted quota.
	 */
	return run->dirty_quota_exit.count >= run->dirty_quota_exit.quota;
#else
	return false;
#endif
}



Thanks a lot for the reviews so far. Looking forward to your reply.
