Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAFD629150
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 05:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbiKOE4B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 23:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiKOEz7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 23:55:59 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECDC2D5
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 20:55:57 -0800 (PST)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AF1RTGc017070;
        Mon, 14 Nov 2022 20:55:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=EP8CZacKrfloHDiezCGJEM10AEnUWFtkEOOeRZvY/hs=;
 b=Ub4DVRvd6dmJk8xfKX+/qFHlVB6kJRWziy/7BPQzKglCtRah3FzWfdql6gk2YDunjTnN
 14rYRrr+W7P1RRG9cgbhUVfHOFU42NYkeTA+GHahBt284AcwI3GRahwVwIquzwLtIKYE
 PFV7srMoZ0qi+KZmCBS7QJ8ToLII58hL5JPgjHeAIMiHCWq318gOZyjCn1D6lek85S3P
 hk2Bi5Kil0NJ7AXw6mx9uoBqjaLGL63V+eeDaJpRuGERYcYg9beTE6//o1aOP5gi56Q3
 GduCBmshUmZ7Idf0lrgIpukHvSWifp4ZfBNDmrzTvn8BM1wkhpc9Ed42fzsnaX2ZdjA4 5w== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3ku2n6bwkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Nov 2022 20:55:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BpV2djlMpQOoL9kARkghF3Hah3Obx3KSQ904jllR1ezXgMIgvLGZsR4VsY3H9512bHjr7Otx42Qrqh2IhDGgC4gSQsb6Uy5QljeeK7+3kxwhBQpgsQk2gqDiARNJNelOX8LHEtPT0EymR+uqtooEnmp8XRj8y3J2hTBoz/Tv+VhiuCtxKZye5KDlqkr3yN8vQLxiNtfZPB+vCXF26MIfgirwCaCe+Gmao9Efd5G372g7CEtyEQ9TP/G8qdA8A7Y7ZboCVOtNvywgkO8b5RQLz3dNxatNtmCtu6h1bBY1dBvdva6CsQWIlcUKcv8rBJ/ZmYsdnr6Ngqpk+gBWfjS42Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EP8CZacKrfloHDiezCGJEM10AEnUWFtkEOOeRZvY/hs=;
 b=nb0weC7GhjBlTSPndwwLa5jmQNBHhYTHEn6el3CNJMVUIRlz/6V3xk4AOOMLEZCjJww1gqekF6KbDtiI1soruO2wsa7ni26FsWWdTBi/7JGU4fyDCm6cnSA0JKUiy09Z7sKQ8vUtYshUpWv1SQdw/HfKCwUSVn4GObdCU1QUJCY+CHkwazHEPKgIsSuawDjo4SJsAjfrr1mEtoCTdNofaDjPXqkCCfjFo3ilYVbQOXvE6k27Wm1B1oVfuOh9Q0gyC7FN0dXyeDixPl/X+zsMKJ7cyOA/qv0yUAfYFRums9dQxnykMZ0Nmd0no3/95ZZDpWUAp2GP5MpFh14a7VZPLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EP8CZacKrfloHDiezCGJEM10AEnUWFtkEOOeRZvY/hs=;
 b=GxMZeQ6E0AFEQKlRb0896xWWu33+g0xukxfA6MfoBtbhjrHfLCAl3bHT9cvVyVNIKopL7/uPoIsb73VjIpNI83zyR/VAiNt/fQ1QXi1bDBpTwStSunMZn8ISrgu3V+/ZejETp7FZtGlwy9kAAJTjdmiZSnNlRskraabt0caTdAK/IMZx+He0yabET0grB1OhCGaL0+NYK5Tn1eUmuihEVEJU1QQKRLWrY1Dio6oSvMI2TcLxib0LIuxpiY/o45hyNoUE/geYN7k5s6eRx9aRPuRjg9lTme7J2dc8UgJ67VlpZU5buYrqOIGUUB9h9q2eOJF3rKSi18u4R3jYbtieFQ==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by MN2PR02MB6813.namprd02.prod.outlook.com (2603:10b6:208:1db::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 04:55:41 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6ae:b51b:f4f3:3c20]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6ae:b51b:f4f3:3c20%7]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 04:55:41 +0000
Message-ID: <176f503e-933b-f36e-5a59-6321049df8f7@nutanix.com>
Date:   Tue, 15 Nov 2022 10:25:31 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH v7 2/4] KVM: x86: Dirty quota-based throttling of vcpus
To:     Yunhong Jiang <yunhong.jiang@linux.intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, maz@kernel.org,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-3-shivam.kumar1@nutanix.com>
 <20221115001652.GB7867@yjiang5-mobl.amr.corp.intel.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <20221115001652.GB7867@yjiang5-mobl.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0053.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::8) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|MN2PR02MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: 73d5b1fd-966e-4244-2dc0-08dac6c5a556
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zUl6QHJH/8ThnkOkPudx9ZtIxPw5oHzEx9ruWKUpp8Y/Mg00T+ex4x+EtyEiJNZLzS7ucUEpbUVcSEb5BsX2KzECyNKhzHHMgyosFVAdp54mbMqqKRrqerHdl+M3APyOkmnhnuFmxu1n3AhxInTLfsiQz4qpaLIoVFvUqpfjTqzZ8Hi66Y0c90hlBLcU81vS6mOtTu5Lrhal+E4pJbaIWyvjwQQOWzGKlHT3qypPmFjrUWDXptn9so/VgHlPuYrqvZAWgqWBZjFvPJRvP4zK7Wi1BcqC4FMZgLcZyBDYF+GS3SwkD/rL4qz4609VcE8HblJ0o65qpEg2UCQ5j2zMjH0WfG+DonyPvlB+eTyvZbTNC6BLSj8KIVKanwjV1A5e3sXMG3g3ETFJyMyri02Yxd745mXZ6VKglbSU4naUCj9Ebb0W/O55aUxIpaDO6LbH6SECcY1JZ7QYznHBeOrNO/LlxtlhiAzChB2cw9YAdXjjmrvNUD1dFTERb6bjXWTSzd4ABj2/GNSj9EgDOoLr2iv1AoafzlasSGQj8jYASOQTTq+vJTM6kOwgrf0cFxd36LFMGEd+fCksa1geVkACppjtQQfj08IkPO/ebRjUHpIsi+sxDQDPTP+QCN5PLMcfxlKYD78UeY7uDCE9IlFudA7yehhJj04YPZnpcopJz1dt0anCqG3A8rJwp9MmeuhYwK95MvooRQMkoL5Z6uEzt5B8yZzkaPPypI0Yc5OWJyiyksLN/Dg9Hk17A3UXafj8PZeOcoWwWYSDV9D1TqQeuikfS3wRQOIkOSlz8XAD+2Q5M0LobcDnI4W0lX+b5X1o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(136003)(366004)(346002)(451199015)(6666004)(107886003)(478600001)(54906003)(6916009)(6486002)(31686004)(5660300002)(8936002)(15650500001)(2616005)(36756003)(41300700001)(6506007)(2906002)(26005)(66476007)(53546011)(66556008)(316002)(8676002)(6512007)(66946007)(4326008)(186003)(83380400001)(86362001)(31696002)(38100700002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2VYZTFvczF2NDVpc3RJQk1OdEh5cmhZZkJRUWZEbFQyTzlrcHE1ZVFxMTlK?=
 =?utf-8?B?ZlNwWUFQOTBBZ3dFQWZNRFpucG0wWUF3QURSVnNWUHZmZDBIaTc5Rmo0ZC83?=
 =?utf-8?B?SisxcnZET0MrQnNmclpodG9JR3pFdWxqaEd0Mnc5T2U2N3A4S3lxZExGYVI4?=
 =?utf-8?B?TmNCTHo1bFVrY2FnS0ZKU2QxL2VhdDdjMXBKclFzRmZmN3ZRbzd2TmEvUGhn?=
 =?utf-8?B?ek1TeGdQajZweXhXbjBxVk1EUWVrYWlLN09od2xCS1JRVHBHeEt4T1V3Tm85?=
 =?utf-8?B?MmxlU2hzL1BYeENEQVZsZ0N4U3BmaUhxNXFYcEloblc1bkJxZ1lxNGJ1cnNx?=
 =?utf-8?B?bEVHbWsvZ3BrcGZEWWZLVUR0UWdXcElWR3pFblowbE15UW1FNTNLbWZZbkM2?=
 =?utf-8?B?ODJUTlZXUVo0MElZTzFXSlJweGVCK25xZEkzOWppZFVZYXMvTU9EZkxSMTRy?=
 =?utf-8?B?Q2hIMHc3bFk1bnBOaFJEVWhsNmx3REZQN1Zmb0FvT0lMQm9sTU52cnRVYjJO?=
 =?utf-8?B?cGNBWGhKVVI3QThrRysySkFFUk1nVjI4OVE1ZnpNbEthSlhkWDU2MjFHN0ly?=
 =?utf-8?B?WGJDQXU3czY3aUErUzY1TWtiMGxRdVFWM0VIVHpTbWUrUUFMYWk1TlQ4cjZN?=
 =?utf-8?B?L1AzNHRiUW5TaklndlZTcEVWaUkrZEFwMnVUVlJyTG1zdFRQbTlEdkVGWkIz?=
 =?utf-8?B?Q2xUSTZTV0VvZE91elJZY0MvZGJIc3BUaEswbHhxSGlwUHVBN1NLdnVUQU13?=
 =?utf-8?B?bmJHOWQ1UklnMHplSGtuKzlKNldGUUtnb2s2S1p5Uy9yek5PQlhkdWFpUkEy?=
 =?utf-8?B?VU1yeGtDd0lHWkZESXBOc3YyaHRzOFFJSUVzOG54azJoaG43OER2NjJvT2s3?=
 =?utf-8?B?Yk9TNXREN2V6R0RQZTNVWFlqY25oVk05c1ZNWXVibTdHQU5TYlBIWFRwOCtS?=
 =?utf-8?B?Z1lZWkI4UmY0T0UvNnQrQzU0Rnc3NzhmQktmZmZGS2VtditHOHFLa2tYUWhy?=
 =?utf-8?B?U0ZFR25sbUtmNEhWVmtPWGt1OVJJRjlaM3ZrSXlsZFAwVk5Xb0NTQ3FKMkZ2?=
 =?utf-8?B?SXRYK1ROQ2ErSnNPR05rWjlhc0gyRHBTUDRHRVZiK1NPVEZHblp6ZFY5NlND?=
 =?utf-8?B?aWxDRWxFTW1sNUl1TVY5RUhKS2tvR2ZFelkxcENpZmF3bVZmQjlEMnBFQ0hC?=
 =?utf-8?B?M0hqQ0QrSUN6Q2dxRGxsSWpnZ1RJS2kybEJaQkxUbTZXQlg1T3RrbFZOWXd2?=
 =?utf-8?B?SkxPLzYwbVFaOHp6NDNSOW5iUVVVZ3ZidGlnYTZaajhDM204R1hvVWgyd0Q1?=
 =?utf-8?B?WVlmSEhsU0dpZ3RzQVFiV0FRemh4aXc5a0ZIenU1OUJyVE5KSDlTUXBvME0v?=
 =?utf-8?B?QlJlU0pDN1FRaS9YY0NjU2l2UW5WYmdXTisybVkvWGxvMmVWd3FQVUR6UFJU?=
 =?utf-8?B?eFdQRUdxdGUzd0l5Z2xuVXVyNk9MeUh1Y2xGOWdSQnZ3VG1mWFBiVzVMTmk5?=
 =?utf-8?B?aGszWFVhSGt2MFhRNTAxVlIwR01xSzM1WFdCdmxISmIwL0pYZm9iUStJT3ZF?=
 =?utf-8?B?ZmhFYVBlT0Y3Y3FXRXB1RnRibjVoaU1KbGQ5TldOQ09WTjFnSURmb2dqNFhn?=
 =?utf-8?B?WlhUM1JMQlNjdDBKN0NQSUtFdXNjR2JxM280RHVWQ3lMYlhqUWtrZjg2T1d3?=
 =?utf-8?B?S3lZcVdUQ2kyS1dpQ0pid2xhdDZwNldrSDFrcjU1TVB2dk1zV0x5WEJPMzBL?=
 =?utf-8?B?VHpQcTU2Vld5WkNaOXBjRVU1d1YwMUtMclZMRlVadWxRWm5wWWxQb0VCZnpD?=
 =?utf-8?B?YUFzRUc3Tzdpa29ZU3JlQ1gxYk16MVFaWUg3aWJLM2h2WHVEL2Jza1V2REho?=
 =?utf-8?B?QzgzSlBrWkdoZ2tOQ0V3cTZJZk1SU1NGd0Z4UjhQSHRkbkZiMmc3OVlSSXFG?=
 =?utf-8?B?VGtNNTVNbmZ5RVY1eTN1Y0I4dit0L1M3NTlYWDBpSXFPTThvelM4RWc4L3pV?=
 =?utf-8?B?RDRzN0JNcXBvUXdCT2lFajhwcjBMZFozTkRaRW1paE1lMHRjeTE5OXEvVFBT?=
 =?utf-8?B?emJoK1V0WDhpUnJRTWNIdEx2dWVqRldEaWZ2Z1RlcTdlbXlzVHVwSWYyZisy?=
 =?utf-8?B?eDdnc2NVNWlISSt2WWR4M2pvUnlyR05NaWFCRUxocXQ4WENqSU4zT0hRMm9s?=
 =?utf-8?B?aFE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73d5b1fd-966e-4244-2dc0-08dac6c5a556
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 04:55:41.4372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YHEdbxnwfOGvPrGohyf1UnhFKXTl4D0O19sjdlNAtPyoCsNH1Ir6JJt5QgP++OXeglWLdrG8wr8Xntb6+aIt7Mi6l3CAQSHFrcjzw4pR8K4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6813
X-Proofpoint-ORIG-GUID: 60RaoMHNtCum__7wuL98tlffDkIIUydQ
X-Proofpoint-GUID: 60RaoMHNtCum__7wuL98tlffDkIIUydQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-14_15,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15/11/22 5:46 am, Yunhong Jiang wrote:
> On Sun, Nov 13, 2022 at 05:05:08PM +0000, Shivam Kumar wrote:
>> Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
>> equals/exceeds dirty quota) to request more dirty quota.
>>
>> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
>> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
>> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
>> ---
>>   arch/x86/kvm/mmu/spte.c |  4 ++--
>>   arch/x86/kvm/vmx/vmx.c  |  3 +++
>>   arch/x86/kvm/x86.c      | 28 ++++++++++++++++++++++++++++
>>   3 files changed, 33 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
>> index 2e08b2a45361..c0ed35abbf2d 100644
>> --- a/arch/x86/kvm/mmu/spte.c
>> +++ b/arch/x86/kvm/mmu/spte.c
>> @@ -228,9 +228,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>>   		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
>>   		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
>>   
>> -	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
>> +	if (spte & PT_WRITABLE_MASK) {
>>   		/* Enforced by kvm_mmu_hugepage_adjust. */
>> -		WARN_ON(level > PG_LEVEL_4K);
>> +		WARN_ON(level > PG_LEVEL_4K && kvm_slot_dirty_track_enabled(slot));
>>   		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
>>   	}
>>   
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 63247c57c72c..cc130999eddf 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5745,6 +5745,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>>   		 */
>>   		if (__xfer_to_guest_mode_work_pending())
>>   			return 1;
>> +
>> +		if (kvm_test_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu))
>> +			return 1;
> Any reason for this check? Is this quota related to the invalid
> guest state? Sorry if I missed anything here.
Quoting Sean:
"And thinking more about silly edge cases, VMX's big emulation loop for 
invalid
guest state when unrestricted guest is disabled should probably 
explicitly check
the dirty quota.  Again, I doubt it matters to anyone's use case, but it 
is treated
as a full run loop for things like pending signals, it'd be good to be 
consistent."

Please see v4 for details. Thanks.
> 
>>   	}
>>   
>>   	return 1;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index ecea83f0da49..1a960fbb51f4 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10494,6 +10494,30 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
>>   }
>>   EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
>>   
>> +static inline bool kvm_check_dirty_quota_request(struct kvm_vcpu *vcpu)
>> +{
>> +#ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
>> +	struct kvm_run *run;
>> +
>> +	if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
>> +		run = vcpu->run;
>> +		run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>> +		run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
>> +		run->dirty_quota_exit.quota = READ_ONCE(run->dirty_quota);
>> +
>> +		/*
>> +		 * Re-check the quota and exit if and only if the vCPU still
>> +		 * exceeds its quota.  If userspace increases (or disables
>> +		 * entirely) the quota, then no exit is required as KVM is
>> +		 * still honoring its ABI, e.g. userspace won't even be aware
>> +		 * that KVM temporarily detected an exhausted quota.
>> +		 */
>> +		return run->dirty_quota_exit.count >= run->dirty_quota_exit.quota;
> Would it be better to check before updating the vcpu->run?
The reason for checking it at the last moment is to avoid invalid exits to
userspace as much as possible.


Thanks and regards,
Shivam
