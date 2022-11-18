Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1637562F03C
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 09:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241356AbiKRI5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 03:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241544AbiKRI5D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 03:57:03 -0500
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8822360359
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 00:57:02 -0800 (PST)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AI1k9m4007006;
        Fri, 18 Nov 2022 00:56:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=I8JUFT69+OWmsT+HxExPfmOIQL6yz3SGvHoU24fXkgQ=;
 b=O6nmqXfkKRJX31Gb1qldC7IdOGW93Gioj30Ym+Sp+ba+Bm0OzNVAZ9K07vYOvrIb212A
 CQ+x5VPXBKMe4AsgeHxtK5LF/fyDhYvt61zCsEhKkUleApUrR8Hm8gG5+RVWow+0sFVx
 /g1RQg2SyeVScsrhYPVWtaMxjUrjb2oj97T1btNa50iIc9sRBjqhx6MMpUT9ziUO7VyX
 8Ww3rLwostOW20L4Qc1mnDZIJE8PPmR3019w7pE6vAL2UTIg6woDbmPE27FqKqSfsXmw
 XIcXAl1N67kjFBVuNp38lPR5pFvzwxmgVPM1XzYEBJ6RBsbqlRlImkC0Vkei98vjNRWX sw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3kx0p5gn79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Nov 2022 00:56:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0fPYXzAbt1Gd81GdL/LyjXi89amfmoedou23u/1Pc94XwFC76fRC4P1ySAW4bXkXECy41TVldm9er15w9o/f7bVEvP+Y5pP/13WuS4AOd7Ty7e/n+ZOge3N7rYWDeQotaYWplr87KyuuM5lWtrygfw+8vFELfo2j23TNiSs9y9u8JenZ6my6MmxX5k5GQbm9WzqQaUCu/1xn+4iKy9rMywsLw3//wOclgJiQgoIqKfrFhpASRzyuBEA5YsZ97+W7RjNfB4wNquvgMeuYJ385gru2WfKfe50EwD328I2rcaRdDM0KWNuNYZ+3MsuDv0IOgPN5Sizds/U1O6GqExoWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8JUFT69+OWmsT+HxExPfmOIQL6yz3SGvHoU24fXkgQ=;
 b=I1Su7ecxYWSMiW4MFMVG3NsCaWl9nqgXw5JT7y4D9vGAYyfnKbpTCzRPTG5ukdNBV8aaMABe+WZCjahIdtE0HYzzqO1ZqUJ8wSqpeGgzeUZ2RofcxvxShjYyVrI36Sb4gQcF0CO59jchENoRMl2vOtxBNNnYgNMO8Jj46F7zvqE42gLkI5KWQ+emA0mIcbd6QqCbRBzysmPqbYJBlbFbwa+5etaM08DwJzFZRFC6blwTP+flcfBD6ev69Dsww7eIpqTjSvn8WDxkfuRK/EFDWFSCU02NdfRW1FpOE4Er4JJgyechcuxrwMta/6Mj50KhX9m8Wn3aj9Oy7f4axv1W7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8JUFT69+OWmsT+HxExPfmOIQL6yz3SGvHoU24fXkgQ=;
 b=UmpP7psQwIhdB+sjk6EuuhGI1aRA6bVzUXE1znAVMD5VEsCHWJhP1GP3O9KqXfcRZfvHxLY7RRD61z/0zG9v2Pye8G96JluZp8XR+qDpPQWpLXk32bMDX9c6srEtzH8LFzQxwKtiMm+/CNBSbh4vU4s7fWdJQf8xa8lN2nQbkd8bRjm4o6DsTzPA+F9ABx/hsKer4RKzoNBf+ROfiCM5gSYFPDgeOjpM3zLTIwMo7jz1xEPzGCG68bvgeNEy9S53DRVf7Hbi7Ml3CoJuhIAIlEPO9nHv4jbeSu0Z2KZmqdvze0KdCi2tk/kCiSMWfEvkW1Alt/7S39BJSDghD2Ls7Q==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by CO6PR02MB7811.namprd02.prod.outlook.com (2603:10b6:303:a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Fri, 18 Nov
 2022 08:56:51 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::8779:9a4f:69d6:a301%6]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 08:56:51 +0000
Message-ID: <3f22abb6-ba6a-cf3c-b3b1-f7dfb172670c@nutanix.com>
Date:   Fri, 18 Nov 2022 14:26:37 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [PATCH v7 3/4] KVM: arm64: Dirty quota-based throttling of vcpus
To:     Marc Zyngier <maz@kernel.org>
Cc:     pbonzini@redhat.com, seanjc@google.com, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-4-shivam.kumar1@nutanix.com>
 <86v8ndnwep.wl-maz@kernel.org>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <86v8ndnwep.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0192.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::17) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|CO6PR02MB7811:EE_
X-MS-Office365-Filtering-Correlation-Id: 64f8a309-0b34-4e97-5523-08dac942d364
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dWPgatwUxfLIXmCSa3T3LdlK/v2cejELE5d+ox7CcxwejIGWGRf4todv6r/oZpvIz6bcrzfwOruPAZw49KoAScWxpcn7x3h9E1g1RggBcYazyYXJbZ/usFZ+g43V+jDU0lXbGGezqO927VxE+upGFQEdplBMMa28KBCQwMwbgXWs9PeldQBchjqDjoIRTBDcqOFoAOF/zzFd3dMCx7QQDfYQZZcz7yaR6FXMPxveXql9C68IyyHPI5GIPgP50Zyb05P9rfFbQ0Gln8CD8Mcqt+kdQCwpTq3d4u5WjDcdGavcpI/7k3n6D9wvYh/RYzq+D9Pany82s8CmaUrmJERUWbdVtpVJexKXu2Tsw4sWMGV8dIjDaozwhw3Nt/BH/HH9XTpJUgfgwPKP1tpmbe2SSMNYzd/nqVqExGoagi25OvGWU0704XvyCuCS3uLtBn4JxeCIaOxmz3MNAa4F34y9oZMtq4/GTDvo/mwdOObHX9QH8uShXw7XSuk/CyQU6dM62EWwOg/dgcFGCo0dOsR23HIXDhlU+TcjQzlCRDT9cH+x90oUOssZ1KwkKhalEOLleXUR2/8lB8GlE5OpoidDeZ5LWpGXjHAnoUpyhijyX0LS9v7n3+FlazzUHj87SozPi11tjmsHz2kGntkHzwZPt2cejh8eCyAQJtKKVpkszRVEHFVRJCvELZutl4Qxrz8IobsAJdchmQvNZudKrhOpCDLFsqpvo+iiWR3n0BZl0HITdVJdCOR5haoEZF+8c4jJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199015)(36756003)(31696002)(86362001)(38100700002)(6506007)(53546011)(54906003)(31686004)(6916009)(316002)(6486002)(478600001)(6666004)(107886003)(5660300002)(186003)(8936002)(83380400001)(15650500001)(2906002)(2616005)(6512007)(41300700001)(8676002)(66946007)(66556008)(66476007)(4326008)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFF3NXJ5anFodFd2NnA5TmIyS25RcU44aDJlaDBNOTc1K2NFeHVRWWN5TkV5?=
 =?utf-8?B?R1pRWWtjazBTeDBGaFVwZzg0ZVdTVEd3OVRjVlI1RHFWSkcwdVFnNVhJVzAz?=
 =?utf-8?B?S2dTWDdRY1FsaTlWQjNzSk9uMVZkN2lHQ3FpQno5Um1CamJxdUkvbjNDN1Z3?=
 =?utf-8?B?aC96UlF3R1hSM04vSjJPZmhOR1UxMko3TTFpaVJSbUlsblFqMUd5VnlaNkI4?=
 =?utf-8?B?TTR2WmFucllBZ2ZFL21vdTgzVHlzbHRvREhsaURadjAxU3ZNT2FVL0doSUxN?=
 =?utf-8?B?cSsyRi8ySXZXQ0ZLMFdIY2k3SzJaaHplYWRHWGhaem9FZjZCWkRSQ1ZjLzZx?=
 =?utf-8?B?eTJNbTdaMXg2blVqdmt3cTRhM0o0K3dYaE54TytiQmZqeUducUhPRmd3a2J4?=
 =?utf-8?B?dEtaMHJMVDdndmNNUm9NSFVIM2lQR0dQS2lJTUdFMXh4NFd3MVlJUnFvK2lV?=
 =?utf-8?B?dmZmbFNMTlcxWmFtelBOU3ZIT1ZyNlBCZW84bHB6TTQ3aEREaTFVTDNRNENN?=
 =?utf-8?B?Yy9YNGJUb0MrdEI4M2ozZGhpL05paVZ0WmpWT2lqVmpRdkQ0Qm15RXYzR1JX?=
 =?utf-8?B?djE0OGVoV0cyNWhtTDA0SGpUc01PQU1uSnVqcEhVUnZua3BUNnhvUDdSWTI2?=
 =?utf-8?B?emY4djhMeTJlWnVtODBEYWNXMS81OVMxTjd3eEtpN2wzSHROanEwUW5waU1k?=
 =?utf-8?B?ZjRYNGUzS0U3S014aHVKaFlpVWt5WjhUdzFvYUgycU1wUnM3UldjLzlkVjZG?=
 =?utf-8?B?NUZjMkdISHRZTDhFOHA0TlF4elRNaEpJN1hFc0UwZWgvb3h0ZFVpV093WUN4?=
 =?utf-8?B?Zmloem1xQzJ0TjRSMzUzQnBQSTdOejgzUGViYUFlL2kzWEFzUlJrUktlWjUv?=
 =?utf-8?B?ZG1LOXJ2R1E5bUthaDI3NitoTlJ4UkZJUGJnaHVBV1g4UHRyamZQWEdVQk1B?=
 =?utf-8?B?Y3NmbFdxa2duekxmay9RNkMzb2dkSklWYnpkSnQrbmx4SzI2dGpxT282bUtP?=
 =?utf-8?B?ZVF1MWpvRytVd3JyOThzNFVYeDdFWTNKV1J1enVJd2ZuS25hUDE4ZHY0aDAv?=
 =?utf-8?B?dkNQSk1sOXNUaXluc3U4Qk16YUZXMFdGWGg1UmxRNiszUm9uNkZtcnVlcU9n?=
 =?utf-8?B?dG9xSjMvZlh3YUpUUGxwVU43bjNpT0JDSXh1eEpsM0QzYkI4VGw2OFBrYWdI?=
 =?utf-8?B?Y0ZwWG1jWVNja2tIaEgrTFUvQ1M5Tnk4bUpEMVhkaUoyQm5KM1FzU2dvNVFI?=
 =?utf-8?B?Nk5icnJLSnRNWDhUUHIzQUVkVm5VWEh1VzZNYmVwdmhqTjlxVWZCWUpWemcy?=
 =?utf-8?B?QmJRd202cVFJRVljakFxQkFBeGJKUVk4NUpocEZCQ2l0bTR2MEJDVy9sczRI?=
 =?utf-8?B?ZUZQMmwzaWh2ZGZzZ0ZkZTVzcHl1MG11TGEvWU1LWTJXMjRTTmQ2eFdYcWhl?=
 =?utf-8?B?SnZnV2gwUUZ1UUtIZ3BoUXhzVkhuVHl6ejY3c0hUQ3NIZHRRSm5aSnZpUGts?=
 =?utf-8?B?Myt6NkMxbllGam05eUw0V3RvT0duVVB0NzhmcVpqSTl3V2M5UFlKM2Z0UHVt?=
 =?utf-8?B?UnVtM3pTVURoZUIrbEZJMDFQVVRRdDJ0OHEvVHphdTVxNFhPRjBOb1ROUVNz?=
 =?utf-8?B?VXk2NmcwR05BWkVWR08xNTZnM0I5OURPYURMMEZOY3ZaUmNFamsrLzlVZFNI?=
 =?utf-8?B?QkVGV2tTUXRDT015d2xabm40QlMwVVN4NlN2WHgweU1lRTZDdkpoTUY0SXRN?=
 =?utf-8?B?WU5qWDNpM2dCZnRULzBEQWpxRG9qQUJjQkFMUGV2T0dSTjVKVGtsZnVqTnpL?=
 =?utf-8?B?QWNOR2c0cjBKZzJ5U3FlZzFvbHExd25IUFZGWVc5SGZUSm53WHhSb08rbFMw?=
 =?utf-8?B?WXJPNmZEejhsV3BrazdVZGFFbllXNFBiMlRkbUF1VnV5YUlLK0dwODdCL2NL?=
 =?utf-8?B?d3plR2xnVHNBUDhuZFQrcnFjR1pqVjBtSytVeVM3QUJWT0Q5dHZ5RzQ3RVNq?=
 =?utf-8?B?NzBvOFI4dk51MU1UZjdiTUVBMUk5dElYU2Y3S1FUT3VqUHU4aUgvVGJKREk4?=
 =?utf-8?B?ZnlYQkFZSFlLV3pNRFc3ODNRRzJwUGd5WXVGdS9OSWdZcHdOOTZWbVB1M1hm?=
 =?utf-8?B?OEQzazltSXU0dzBoYWhpaWRNc3dzakIyUDVGeWhkNEw5TG9NUEFuY1BDcnB2?=
 =?utf-8?B?MUJVemJCOFYwZVB5UmticjFIMzNqY1ZXYXhOdzFnUTFYSWdmd2tEQ2RnRndY?=
 =?utf-8?B?ZXZaWHRoemR1ZFpkVjlrdnpqcmRBPT0=?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f8a309-0b34-4e97-5523-08dac942d364
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 08:56:51.0279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Rtdal86kKx5swwLDx32RYcoW6m61mF49CY9/3dKjBnyr3K+IioIHdSPQoWlZP5EDlog+Y645YxxsSHrly/GGNXNR+qxlavFMY3nAyzRMS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7811
X-Proofpoint-GUID: 1FP6Y89lUXuMVOdvcmtPw8LNcZUjhzvz
X-Proofpoint-ORIG-GUID: 1FP6Y89lUXuMVOdvcmtPw8LNcZUjhzvz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18/11/22 2:14 am, Marc Zyngier wrote:
> On Sun, 13 Nov 2022 17:05:10 +0000,
> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>
>> Exit to userspace whenever the dirty quota is exhausted (i.e. dirty count
>> equals/exceeds dirty quota) to request more dirty quota.
>>
>> Suggested-by: Shaju Abraham <shaju.abraham@nutanix.com>
>> Suggested-by: Manish Mishra <manish.mishra@nutanix.com>
>> Co-developed-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Anurag Madnawat <anurag.madnawat@nutanix.com>
>> Signed-off-by: Shivam Kumar <shivam.kumar1@nutanix.com>
>> ---
>>   arch/arm64/kvm/arm.c | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 94d33e296e10..850024982dd9 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -746,6 +746,15 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
>>   
>>   		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
>>   			return kvm_vcpu_suspend(vcpu);
>> +
>> +		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
>> +			struct kvm_run *run = vcpu->run;
>> +
>> +			run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>> +			run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
>> +			run->dirty_quota_exit.quota = vcpu->dirty_quota;
>> +			return 0;
>> +		}
>>   	}
>>   
>>   	return 1;
> 
> As pointed out by others, this should be common code. This would
> definitely avoid the difference in behaviour between architectures.
> 
> 	M.
> 
Ack.

Thanks,
Shivam
