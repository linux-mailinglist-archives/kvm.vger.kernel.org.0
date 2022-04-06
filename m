Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1C74F634C
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 17:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236050AbiDFPdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 11:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236472AbiDFPc7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 11:32:59 -0400
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A352B1605ED
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 05:40:51 -0700 (PDT)
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23659XxT006134;
        Wed, 6 Apr 2022 05:39:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=ajkaaK6N7fBilzzU8x7UfmgMOCyCpZasAZ9ThRFsmiQ=;
 b=ub5HPy0ES0PuGel1+BWoOXNM8fIuHG2ONbHKARC9eKbOlikgZN2D3jTuRQ9urGmD7Ye5
 DzkkRZhdep72rTlkh9w0Ch+Tub/YEJIzV2AepwuMM2A4ZJzutJ7x1i57Yxa10qqghs4b
 1JpilT8NNhju5NNf8ITwB1TQZcHHKzqDWZyvGHukakIEXbJ+96bLXFNAdeHj3y7fxNut
 2dXQ6BiPU+Cv1UHbOs8wGBRGbd7mGmO/BIaI+jEZGSkRHrTVFbOS9k+MdKXMkzuz3DlD
 XEZfmb3Ta4e7kfRYqacjS4aLlpS6KnefPHXxtgIa1BbFdIadJukee0WGNZhK1STCloO1 ZA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3f6njfr8ur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Apr 2022 05:39:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XLEbix2OvoxVZNKz71oMP4nY5HLkzpoYrIl210PyMoZAO14nE14V8mkuQ51hOnmwg+7Gpr4NeZRkK2V/YxVtF7qjzMeB9rI3zOKsUEymni+Tf0lmFlvP/ncJcUrFNZrHYk+0FNaqwwvujKa/TWWYZz9HEdH7wu5s9rkfKeUfCjkOgtf6Oy6bL3fj40Fm12a+WzGEjid57XHRXNnKY0fBxJzjXhp1HRupdqv+ywnEjOcaOFd+3/oau4lXnp0pAbTvOAMbJmXt7o7ly3C4MiH6lQOCuXZ7M1xC9LTo/2mwmqP59ZRYX7m4cuS9GeHeOC1XQxeId9tLHRTxiS/Arm0bCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ajkaaK6N7fBilzzU8x7UfmgMOCyCpZasAZ9ThRFsmiQ=;
 b=F6IdsrVYMc6DTmRCCbEXYWK4giDpuHdRqGiKEZQzvii0pBrZAk46O7M6ncNAMTM1iePGqNo+Z1HcqXpRVhC9MJ3hU7ccthsh94v7+yqvPdnNDp12Qr2z12+k2DoeFGQmXU/x0Lbny2UXlbZqijpjRHWTnjrmXTy168pSt6+eS4U/VW/Uc6xVEj8CmCNa8ToJfpEZQl0wJIAbzv6Gr6hZiIZjlBpkH6NEJE5HQgWF4TP2A+xYhl/M+RrWY0l7IiwM+kfAX28LPrZS7JmupLO4WouxezwK5LiD6DpWDkLkg4LYoG00Zrvucaxtz8hyT4/RWgdSzP93xW6UqO3uu299Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by DM5PR02MB3685.namprd02.prod.outlook.com (2603:10b6:4:ba::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 12:39:33 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::f8cc:e0f5:bc13:d80a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::f8cc:e0f5:bc13:d80a%7]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 12:39:33 +0000
Message-ID: <92755bf0-0bb6-2a9f-3b92-3b380463759b@nutanix.com>
Date:   Wed, 6 Apr 2022 18:09:24 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v3 2/3] KVM: Documentation: Update kvm_run structure for
 dirty quota
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-3-shivam.kumar1@nutanix.com>
 <YkT4bvK+tbsVDAvt@google.com>
 <ae21aee2-41e1-3ad3-41ef-edda67a8449a@nutanix.com>
 <YkXHtc2MiwUxpMFU@google.com> <YkcC5cDUo7cQQyBf@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <YkcC5cDUo7cQQyBf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0173.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::14) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4a5e5ba-a103-496c-dba8-08da17ca8098
X-MS-TrafficTypeDiagnostic: DM5PR02MB3685:EE_
X-Microsoft-Antispam-PRVS: <DM5PR02MB3685035B2A1F11907ADA4DDEB3E79@DM5PR02MB3685.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6DSRBNWVkwLjHRw9hS9twwcHSEUBYHMGKTxDZKzFmy2nlVMbgV3KEAXEtnciUZqNGqJ9i04RVrbuGy4iBsgKcrZiQe+zGIJdpO7Zumd60T0I9sWzTXkFGmXtPGRTSspznoUSFTRIdsMLvlpEA9sWCMK4R3E3kcpCSZ5vYpd6LFMlcXyMzbvAmF2beiKWzA9bGpo4oOh5f2Y2uVB/x/vY04qea+FYKKCSFEKP/IGMaGQNd3iaPzFqPKnDFbDRTtu4X9yqXOciWLNMI07ygy1TiCCJc+QYzK44RsrTGiJ0oOmK+9JO3JLMgyMWxVNnV/Rvk5iI6ToOLxQbt3x7QJ12tUunit3ohPM9JwA2uYCukRxhLuyFnT3RWDvl8v8AToPxbhDQgO7No+cpp5e+e4RqxYld2VEHpIGoEG58B8V3thDnYDIsXkSVophuhieoaNNAAKODOcVOdixq23evxL124473WgLx5g+KfVPXrc/yAQ6uBs74M+fe5FXw6qOgrVBgl4FB/z1pzxeSagU4ufFjgme3+trUadbs2xZor8CBncINJm6A8yutMScEEoaZBzT3I8GfguXX9X4QoAhjXswavDuulTiycmdLri+nzj4QoMWEIeSyTxSMzQOFT8oPElgstg/bm5OQiVkMBgClwfyZpLP86MWaS2ikM5SSH4579epur0/GEs2bfxJsOfpJcP3KAx1YYd2tEnWdyPAIE3HcT6Cammn3MuMMCZAxnXZl2bWgR9qZPkc1iH+W/3anWGOz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(6512007)(6916009)(26005)(6666004)(2906002)(4326008)(186003)(66946007)(66476007)(53546011)(66556008)(83380400001)(316002)(38100700002)(8676002)(508600001)(36756003)(6506007)(86362001)(6486002)(31696002)(8936002)(15650500001)(107886003)(31686004)(2616005)(5660300002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0hsa2Y3RlBEQ2dZMnRTbzRReUhKLzlvZllOTkJZZ1VWODU2MTNGNlJ6NUc1?=
 =?utf-8?B?VUdzd2ZqYStzTG5qcVgzV28zUExScGt0TnhZSExxckg3U3A4MlNFbnAxWU4z?=
 =?utf-8?B?eUhYK2hEYmJuRnRTaFJGWTc4d2wwQkoxZ0M4ejlDWVFVb0F1VCtVckRMVzNV?=
 =?utf-8?B?N281SDB6M2E5YUpHL0Z1ZENGaEFNQWdXOWV0d3RBUEZkWis4MTNRTUZlV0pl?=
 =?utf-8?B?d21OVU9Kby9QdG1waTJTQVRpeUV0UjVBd1NyR1cwZHVIRERoNWRFTWRIejFQ?=
 =?utf-8?B?dTVaOXdWdWdVOWkzR003TXovNVI3Myt5dEJublV3Qy9WdVlBSTQzRFdleG5o?=
 =?utf-8?B?ZHF2ZmVjRG15UmpnMnJ6NW1KNzEvdTNsVnpRWkFQM3RuRXF0c0R1SXM2S09z?=
 =?utf-8?B?b2ZPUUhsckFMVlF5UGUvVFJRLytWRTJGNTd1SFlQZW96S21FRHp0Q0tnckl5?=
 =?utf-8?B?YUg1cUg2K0hnWnBBWEhPZTlEaGhpVEF6YzJ2dXg1Q09vWGdTQnZ6OVM5ODda?=
 =?utf-8?B?eGJ4bWs4ajd2SDBRSmloaVFhdisvVXNadDNnTkIxTmJNczlqcW9YUUNmc0Zr?=
 =?utf-8?B?ZThNSXZ3QWh1SUFkaGxYdEJpRDA4cTQ3NGlaQnNXVVp1aittaXpvS3Jja0NB?=
 =?utf-8?B?RG5SOVFJbWRqcTlVQWM2cWRnZ2ZMWFMrUkZ6ZGZnY2VZWFNpRGhsYnpCeFY3?=
 =?utf-8?B?Nk00YnNyVWJkbEhrMHBtVExSdFBQWndaVTRNaC9pK3RTb1VQc0N0NWxSUHpC?=
 =?utf-8?B?aUNtS3U4NVRHbjRpZFdmb0Z6YmhVRmRWcXRMcjBUU3lZMzBMNVlCV09rUERm?=
 =?utf-8?B?ZGd2OTRYL2FUZmc5SnJPb0lLSzhnWlhxRmVXS3NPWWZ5WDdsOXd0bVpwd2tL?=
 =?utf-8?B?c0pMK2w0ZytWOW1nVTNXb0p4ZHhCU3d1UmU4N1EwKzBkb3pvRUl4QkhycDJn?=
 =?utf-8?B?RUdIZ3o3NnRHeEFmaEdZcTNweEs1Rm9KT295SHlXQnlRU1J2REpWRGI1VXZa?=
 =?utf-8?B?TU1VZ2k3c0UxOXd4dHRHS0s0eWllYzArUi93Nlc5Uk53WUhua2ZqdlNxdzkv?=
 =?utf-8?B?VWZOY0dKNDk2VVJVWEczVUJJTXlNTUxPNnhNenJwd0pjUFE3WHhvdE1VVDFK?=
 =?utf-8?B?dnc4V3p3bkNORERTQXhXa0gvRkt1NzNVZ09LWEFnRnllMzFkeHBtQVdSYk50?=
 =?utf-8?B?WHRWUkJUTzBMTSsrbkh1RXMrbG8wWXRMRHkxZHlpN1BqRUo2RXFMekJQdmVY?=
 =?utf-8?B?c2l0TjBDbnRaa1BwdEkwYUx5V2lZSHdRQUlReE1DNFRmbXBISEQvM3F5aGNk?=
 =?utf-8?B?OFg1a0o2N2RrbTBKcHhCSDZka3VNVEZlZUphb0VmQkw3U0djTVdZbUwzZXh3?=
 =?utf-8?B?alhxT2ljOWVUSHIza3FQSG4yRk1XZkV1eUU3TWtzamUxSFpRL3cvQ2ZCTGRG?=
 =?utf-8?B?akxkakZuNWg2bmxiVHlTaUxJTjQ0bzk2WXFZdGx6R3E4V201SktXZ1ZQd0dY?=
 =?utf-8?B?bTNpTFJ4RUZpWFQ3MWRaOTE2NGlZL0tHQStQY1B1YUZUQjZkQmZNNWZoYzZi?=
 =?utf-8?B?bU9jSmJidldUdnlKb1dqRUtxMERlaWMyVWI1OHhLSHk2REwzOWFsaXZoY0dY?=
 =?utf-8?B?VkpoUGtVSzVzdnQvTWN6dWlyRVlVWWxZSHRXM21GTGVTSzFZRVpjYkRUVnVm?=
 =?utf-8?B?bkRkelBBdm1LZ3hpYWFCekpwdWYybXlBa2JOS1VuN2p5QmRaVkl4czhBekRn?=
 =?utf-8?B?QVRGdGptaVJlZGRKbFVMa2p5d1NGUkcvbHZGTGljMnkzcGZaLzRFQ093bzRq?=
 =?utf-8?B?WWhlWDBJek53NzFaZURTS3ZhekpGemZXNGZKbXRFbkJOSG16Z0RDYzkwK29r?=
 =?utf-8?B?S3lLNnhvOU9OdDBsUjVidVo3Wkh5ZUpPOHM1U3FTYUhqZnFBRmNyemtTRC8z?=
 =?utf-8?B?L2Nnbjl0K1NnZkVXS0h3N2RRbVVqSkdsT2V3SjlURVhDazJaNC9mUlVwVldi?=
 =?utf-8?B?MVBRSEI2WnpSOWdwb0hONEprOUtnN3pnQkJTRFdqY1NaWkZZOUxkbmVqNTFN?=
 =?utf-8?B?cW8zNGFTVXdiU3g2eC9FdjdYaVpUT3NLNTFRMlRIcTA0MFJtdmo5Ri9jMWN4?=
 =?utf-8?B?WktqUE0yU01vcXJvRXlFeExFdEd0QTJxQmNNME9KNkZJVlhNWWdaQUNwbVlJ?=
 =?utf-8?B?bjBRNE9lZk5pRUk4QzNEdTBNVUpTV2ZGbHo1MHBNNGhDald4Vlp1dTRQOGY2?=
 =?utf-8?B?Wk1hR0lBVnozNGFlZFlxZmpKVExxWThqTStUNGw5V0tWYTl1UGxoWjM2SmQx?=
 =?utf-8?B?eHhVcTJtS0Zxc3krQzA3SEJEVXFiUk56OWVzZXdXL0hSMXFkbXNlQ2dBRk9a?=
 =?utf-8?Q?sIWumq03DopIWHY0=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4a5e5ba-a103-496c-dba8-08da17ca8098
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 12:39:33.7492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ZchE73U+E0noM38rydBLcijCmPfAzNQWhLkVqYf2QKJgcn/HrPauOA8EQmkEb8jtBzbaO1f5R1TWbIAHSz8wpd23X1qxveCYWAgDP7Iw2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB3685
X-Proofpoint-GUID: UkAix7Y18mr1ktoxgMtXAeeLkTXw0fbR
X-Proofpoint-ORIG-GUID: UkAix7Y18mr1ktoxgMtXAeeLkTXw0fbR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_04,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 01/04/22 7:19 pm, Sean Christopherson wrote:
> On Thu, Mar 31, 2022, Sean Christopherson wrote:
>> Oof, loking at sync_page(), that's a bug in patch 1.  make_spte() guards the call
>> to mark_page_dirty_in_slot() with kvm_slot_dirty_track_enabled(), which means it
>> won't honor the dirty quota unless dirty logging is enabled.  Probably not an issue
>> for the intended use case, but it'll result in wrong stats, and technically the
>> dirty quota can be enabled without dirty logging being enabled.
>>
>> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
>> index 4739b53c9734..df0349be388b 100644
>> --- a/arch/x86/kvm/mmu/spte.c
>> +++ b/arch/x86/kvm/mmu/spte.c
>> @@ -182,7 +182,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>>                    "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
>>                    get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
>>
>> -       if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
>> +       if (spte & PT_WRITABLE_MASK) {
>>                  /* Enforced by kvm_mmu_hugepage_adjust. */
>>                  WARN_ON(level > PG_LEVEL_4K);
>>                  mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
> This pseudopatch is buggy, the WARN_ON() will obviously fire.  Easiest thing would
> be to move the condition into the WARN_ON.
>
> 		WARN_ON(level > PG_LEVEL_4K && kvm_slot_dirty_track_enabled(slot));

Thank you. Will add this.

>
> That brings up another thing that's worth documenting: the dirty_count will be
> skewed based on the size of the pages accessed by each vCPU.  I still think having
> the stat always count will be useful though.
I thought it was obvious :)
