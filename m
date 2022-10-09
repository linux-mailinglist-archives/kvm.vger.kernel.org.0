Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2AC85F8DAE
	for <lists+kvm@lfdr.de>; Sun,  9 Oct 2022 21:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiJITSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Oct 2022 15:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiJITSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Oct 2022 15:18:02 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD11023388
        for <kvm@vger.kernel.org>; Sun,  9 Oct 2022 12:18:01 -0700 (PDT)
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 298NU0Rv019611;
        Sun, 9 Oct 2022 12:17:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=h+iARhdEy9rvDbsiiIWCn2Fl/k90n0Ub/19K/FEVe0U=;
 b=yogWHh3kYAJhe67B8yx23cFc2vLF5iVyFDY+4k+E+Y54/ea/IbtIPCV4lAhz+UUmc5X4
 u1IgNNVoWrO0M3aTp1Y6TKwwrzXaeNLLy8I6YtEpUxSHzBMLTKAbtQXMUa3hdoii9WRL
 lRUBnDvZ6JyvcN9bW6GETGbCISABbm/JkxWWMsDgR4TGrplOBhQ8sD2ZPJHMoA1RpPoo
 7ccxaBlBJQLahDuz8+5m9DwXX7bCzcMpMvjEM4IaVnmbrheAI81i3GR5RbpG7OuTkllr
 6mdsZHMi8BivI/cTg1/+bpkvyBiPA/i41pMvwai8Wd9fOVPOi0uuZCgE+jR5vetKTOR9 pA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3k38hfa3y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 09 Oct 2022 12:17:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YfzhaIFWwaBM0pUHFQbLIc5vdKDAGM/hdhHx6SLvojQmL37ATQLCO12R41RNJAIop2HaISX49vO4UdDac9j+yrrJtTGErxtnANWJkYc414gbMnXgDQ7YWTu0l1k5M8NLtV97BFS+MyrxdGotUW4IjLgIWSWMdSL4ZVHEck5qrwCIuBsGMVeI4b3TdfKYOBhVCErwSHgPTE+9rMt07l8LThzOG0imUj3EB5BgswWxKgF4/LdwJM6ZMLbyneRy9TpH4uLE/xC8Y1Imlc8cMxjlTwIUksu6vUM88546dSa6NKC455k9pqBGY6WYPpb4JIGvXqe003uS853BV4qXuS4QJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+iARhdEy9rvDbsiiIWCn2Fl/k90n0Ub/19K/FEVe0U=;
 b=QbWLcLSjLt8+cHVd55uyaHBbB/xj8WulHfzd/ij/SfmKsvUTP9cdsjLH6AeUJgcdQJ/Vumm5SuQNUticUHNHO2DTY6U5q4MgKJILLKYEVfm6l+xFPJoOQpzdHmEk4PKCISttjS32CCx4UPC2nvX86kxnmEeem8QYocaq37FfjIwQj8qJnIhwKMlDn4FVwbXyqcprSSULkSaQ8f+6dn9aOkYOe8RLoD6AT7/bamFAcx+nlLZd4ohokeFwIch9esXEnGCc3PlxZILkIVvMD0KXcmkUMMgrKxx7UwU42ij6kwphQt4jtnLWivPMeLDA+OCGw17+eB8+ED3MR6N9r7uNkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by BL3PR02MB8204.namprd02.prod.outlook.com (2603:10b6:208:33b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Sun, 9 Oct
 2022 19:17:41 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::c0a5:1300:e72c:46b2]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::c0a5:1300:e72c:46b2%5]) with mapi id 15.20.5709.015; Sun, 9 Oct 2022
 19:17:41 +0000
Message-ID: <8a379b78-b14a-48f0-67ca-312f7cfa4e64@nutanix.com>
Date:   Mon, 10 Oct 2022 00:47:28 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH v6 2/5] KVM: x86: Dirty quota-based throttling of vcpus
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, james.morse@arm.com,
        borntraeger@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-3-shivam.kumar1@nutanix.com>
 <Y0B+bPDrMdJQVX6p@google.com>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <Y0B+bPDrMdJQVX6p@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MAXP287CA0015.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a00:49::27) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|BL3PR02MB8204:EE_
X-MS-Office365-Filtering-Correlation-Id: a3f844cb-476c-46df-df7a-08daaa2aef6e
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ndo1hJ/4nLYgrHELpYb72KUIFFAnYb8rmcDhHidRsCwZCz8tv/kKP3K55F2q/TQ0TVrvyHfeVisoVfBeeTKjjqqR6AfaBoNmmolG28+/5czhiR3wYIrU+xnVARZh32uGLdEBS4LxB1Ij9RSkStAwv8kwXRS6MH/ACPwDEH8Qv0dzRy5/qJhOHsNwBjTx5wl0gBeomhU/DaCKXm5zbEGazptfUwkLV6tNyY44BHVlJ7ltK45Wren3yapULjbuVP3qrjB3SqGcKrQMjznBYTLyouOsN+Lyy0WoDoWvBL4E5y9SQd0cbhv+iO8IrUvDmvujAUnZq81LqS8xTn3ViHMvF88KIR34BHtb2QhNBBBjSy5ihQEqEKNl8a2RcIZSjVSB9exfhYX5VupUzWloceUW1QylD081Mo3uMdUV1+OPfiZF19+b7uIbMUAGCEC/rFURJQ38XRaSljd6QdvMsjVmEJyaE/WCFSEBt0eMrRYUIrqLeGghNuSenQEyIl7wyjN9la+rpyab4jN/JMO1DxIDIPYGtSJSLVN02YHIzxwZcc9l31zZyNM8i/92z4/HoBQ7ckRWK7sJS/eoqIRlUIeA1mShhmVj1NR2OW7te+OX+5x+FLKjYtyb1Iv5a1dW2xFFaGpLOY/EmRQ5Na3DlI95kUv89oY4DORdQ8RhNdsWdAZnmSWtRjqvQEvU1thZ/E4gzlmQYFgIlNQQ5i8m+t/svp0VtWnmzMrMkp+DWNG3+i2E/EmKD0zhWpUVunRgA57hMfeLrPyuUm4e24JrJS/9Kfg+WVE3gHbrljfxUXuHe7f2pAQ1oFG2uHCI+DwLRFzK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(396003)(366004)(136003)(376002)(346002)(451199015)(107886003)(31686004)(26005)(8936002)(2906002)(15650500001)(41300700001)(5660300002)(4326008)(36756003)(31696002)(66476007)(86362001)(66946007)(316002)(66556008)(6916009)(54906003)(6512007)(6486002)(8676002)(478600001)(6666004)(186003)(6506007)(53546011)(38100700002)(83380400001)(2616005)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3hjSFIyR1RpUkFZcExBaThLbHY1Q003UmxhWWVWaEZNR0xoUkZPbmdNejVp?=
 =?utf-8?B?TTBvdGM0ZWdCeUpSTitDZWdRM05lcVNmeTIzSGRPbVZZZUl5dDk1TDduaU5q?=
 =?utf-8?B?Mmw3eGdDUzNZQ1ZkczA4WENTbGMxRysvN0FCSVEvQmJid3o3OGk2RnB4bUZG?=
 =?utf-8?B?Z3pkZjh5NHU0c1dGMmo3QUl4MXl2ZVF0eERQRW5SdXNPWnR4ZVJnR0JBdHEz?=
 =?utf-8?B?cWZ5OUtOMm9iRm54clNCV290UytMZDU4WERuZHdLTkRtZmxSRHBCZ05nblRE?=
 =?utf-8?B?NDg0ZmlCdnJFMWhGNVNZa3NIRUdNWGhSVGRvMHo2ekJoRC9hejhXcHRpUmZi?=
 =?utf-8?B?QU5vN01paDk0R2k0ME5VUVBoQVFTNE9qaEIwVlZxaHh2TGRoN2lNRXlFY1hs?=
 =?utf-8?B?dUh4RXBZNjRZajVqTXhSVUxOOEtJWk0yU25TUEpla2NYK2JzTnNpK0N6a2NK?=
 =?utf-8?B?MGRqc1dUc2FJNDlzYjdhNFBaVjRKYm9OV2xnMml6VGFLR1Z4Tzl5VDlzTXRN?=
 =?utf-8?B?Y3VtRU95elFyV1FxeW4yVEpwa0VYZU0zcnRmL2d2ZVVWeW9pL2YxNHVqR05M?=
 =?utf-8?B?RVJOSEQyRVVSalBKeWRDRDNXUnZvOUhyQmhqUDM0ZHBMNnZZeDVuYU9sREhS?=
 =?utf-8?B?NkZEQWlkVU1LRzJ0Q0lwSEVyVFFDUzJkQ0JwSzlQS3RQSC9qVVFFZElPbSt2?=
 =?utf-8?B?cndFZDRTbStmUkFUeEx4M0kwOXk1bm5ESHcvNmxzaGdrNlVQVlJZNGEvOURo?=
 =?utf-8?B?Y0J6U2JaNmk3Tmg5SEtPeDc1anNUNEZTaUdtYmk1Y1R5UjFxYzU2Vjgyck5W?=
 =?utf-8?B?ZlNPQkV1TVNwRloraU9QL3BDZmlTYVk2N1hhNzFmUlF2K3pObnJ5QzVMWXlS?=
 =?utf-8?B?amdkRDMyY2JiY3dYMkJ4WDIwWlNuRndIdUVMc21GS1k5SGY5bExkVkJsdVJr?=
 =?utf-8?B?Y2ROa3NSOVBnMU4vbkZCcnF1UVg0ZDRsTWI5REFkYWJ1UVpacWlMWFBSckM2?=
 =?utf-8?B?SUJtUkdiQ1E5dGszS3V1UGdqOE41WVpyVWRYN0F5V2pzWGFTVlcyZHR3UlFF?=
 =?utf-8?B?RUN5Ulpza2ZNN2lER1BlNW0xKzh2cVY5amg2cXdUWUdOV1hXMlZlZENPUkUv?=
 =?utf-8?B?UWJDQ1g0L3RjWHZodzRlcGZ0SU1ZajlxbnVkdTJMcHMzNVQ0eDRzSlMwdFBV?=
 =?utf-8?B?K0x6MU5CVlg0Y1duY3FPUTFka3kxcE5VekZkSUVaQXIzMXNVVFVVN3BsRWV0?=
 =?utf-8?B?T1NrM05naVhXTXBzZkQ3NXU5alVWWFFWdjY1eHZiVithQ3I4L3E3VHM5Tmcz?=
 =?utf-8?B?VFJVb0M3K0QvdUcvTm5KVTNIM2lORUVNWWFkMUN4ZWtzMHBaOEh1NnJiZ014?=
 =?utf-8?B?OVo4cjNuWWM5Y1ZiRUFaaTZRaC9yZnpGVkd1eFlJQ1p6Rk5hTmNOQThyWW0y?=
 =?utf-8?B?WmdXTTdLeEFkb25NUU95RXV6RVVNY0g3L0ZvNUZwYUE2UEpVaFNrRGVWMHJ4?=
 =?utf-8?B?Qmxud0RrejZBYlpVdmMvcitIOG1RdW1iRmxKM1VpSTZmdkJ3NnVOeFNBaUw4?=
 =?utf-8?B?bURYMXhyaUpPZVNnUG1NUlZNUGw5SU50RmNBVWl3ek5jSGZhVUJOYnRqL2p1?=
 =?utf-8?B?Q1g2cGJlQ1VkaC9YUXhHOW8yK1VEdVFMTUVhZHlQSjBxTW0wUW9HSk5xMFBp?=
 =?utf-8?B?dFdoRGhMbUEvc05TZ3pEYUQ3aGs1WGVaVFVFOGkySUdUUHdVQlgyMjFvQkpB?=
 =?utf-8?B?TTlvN3VCTU4rWUwzWkVzd3BZUzFzS1h0bTFXZjFPQWxuZG9uQUNQb1g3dWtm?=
 =?utf-8?B?NURBV2kwdm1NYkdnMDNhai9jcUY5WjQxcWY5cmcraDI3eXpybUNubWE2SFNo?=
 =?utf-8?B?V25DZkI0MTBONmhSdERHTGJXajhtWGZuUUhaUFBXM3h3WGhCbFdoRU5lelRG?=
 =?utf-8?B?aVNhZVVDS1M0ZE02aEo5bXVRWnNualFrUGpPc2dHQ3l6TXpwQm80Ykx1RTBV?=
 =?utf-8?B?OHFpRjk1Z2ZBOFEzSGhpY05VMTJESHpqK3ZpR1VWWXpRV1prbTVFWm1qWnIr?=
 =?utf-8?B?R0U2R1AzUzhFc1hhTDVJKy85d0p3a3FKdDNteGlXcWtzS3pVRDAvbVc4cXZH?=
 =?utf-8?B?UWpaNFVXN0RPUU1wd0lEWE94TmI5MEd3TjBXdnZ4cnlBSCtCMHFjMDlnUFNX?=
 =?utf-8?B?bkE9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3f844cb-476c-46df-df7a-08daaa2aef6e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2022 19:17:41.2322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36oJsEggP6Hdgy8jT8XFniRrHGJKzot/ozwxEX+H4UBmCF1BOrf0KphYSapholuE/G5QCSroUiZBA2EFIO2c7zWWi+1SpKfkEvsODob8iNQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB8204
X-Proofpoint-GUID: AeI669rgalQT7okB0vVe-DL-dy92csDT
X-Proofpoint-ORIG-GUID: AeI669rgalQT7okB0vVe-DL-dy92csDT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-07_04,2022-10-07_01,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 08/10/22 1:00 am, Sean Christopherson wrote:
> On Thu, Sep 15, 2022, Shivam Kumar wrote:
>> index c9b49a09e6b5..140a5511ed45 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5749,6 +5749,9 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>>   		 */
>>   		if (__xfer_to_guest_mode_work_pending())
>>   			return 1;
>> +
>> +		if (!kvm_vcpu_check_dirty_quota(vcpu))
> 
> A dedicated helper is no longer necessary, this can _test_ the event, a la
> KVM_REQ_EVENT above:
> 
> 		if (kvm_test_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu))
> 			return 1;
Sure, thanks.
> 
>> +			return 0;
>>   	}
>>   
>>   	return 1;
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 43a6a7efc6ec..8447e70b26f5 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -10379,6 +10379,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>   			r = 0;
>>   			goto out;
>>   		}
>> +		if (kvm_check_request(KVM_REQ_DIRTY_QUOTA_EXIT, vcpu)) {
>> +			struct kvm_run *run = vcpu->run;
>> +
> 
>> +			run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>> +			run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
>> +			run->dirty_quota_exit.quota = vcpu->dirty_quota;
> 
> As mentioned in patch 1, the code code snippet I suggested is bad.  With a request,
> there's no need to snapshot the quota prior to making the request.  If userspace
> changes the quota, then using the new quota is perfectly ok since KVM is still
> providing sane data.  If userspace lowers the quota, an exit will still ocurr as
> expected.  If userspace disables or increases the quota to the point where no exit
> is necessary, then userspace can't expect and exit and won't even be aware that KVM
> temporarily detected an exhausted quota.
> 
> And all of this belongs in a common KVM helper.  Name isn't pefect, but it aligns
> with kvm_check_request().
> 
> #ifdef CONFIG_HAVE_KVM_DIRTY_QUOTA
> static inline bool kvm_check_dirty_quota_request(struct kvm_vcpu *vcpu)
> {
> 	struct kvm_run *run = vcpu->run;
> 
> 	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
> 	run->dirty_quota_exit.count = vcpu->stat.generic.pages_dirtied;
> 	run->dirty_quota_exit.quota = READ_ONCE(run->dirty_quota);
> 
> 	/*
> 	 * Re-check the quota and exit if and only if the vCPU still exceeds its
> 	 * quota.  If userspace increases (or disables entirely) the quota, then
> 	 * no exit is required as KVM is still honoring its ABI, e.g. userspace
> 	 * won't even be aware that KVM temporarily detected an exhausted quota.
> 	 */
> 	return run->dirty_quota_exit.count >= run->dirty_quota_exit.quota;
> }
> #endif
> 
> And then arch usage is simply something like:
> 
> 		if (kvm_check_dirty_quota_request(vcpu)) {
> 			r = 0;
> 			goto out;
> 		}
