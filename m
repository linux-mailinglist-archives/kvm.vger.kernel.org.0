Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D27134DCDA
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 02:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhC3ARB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 20:17:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41012 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhC3AQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Mar 2021 20:16:32 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U0EK51187865;
        Tue, 30 Mar 2021 00:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ljApwJHXh+7pjCh7HyR9urSeNDhqiGt7HFDeWKp/n0A=;
 b=xmPBRTtuwT2ECbTpQXw1mqQ7VvjxJoN5C1tPpLAiBHoWZbv269vq8c5VMlM6zuuw35yn
 /xrlsCK//R+qTFJSu0Ekq5K5ZYunY6GZbDt6JWdw+Irt7bdNDZEzsIilIoeh+E6NGNJi
 bNuEB5OCwOJNUgigoQhtjJ3aZjTzsfS3YS6uWrb82qLlKYm0G1Sw9lVsdgRKKwz/Kbrv
 4BTvCL9Qfhzrg/slM/RTelgC+z3hlwMOay2kMeiUqWaElqKujbOJmFMpGu6CgHBun+LK
 nn3Tke4PPr4YqX2nBlVNP88CWZxiqU7vfnqFX7c2MQqHXofLDrOZlIQiDNcmF/zglTv0 Bg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37hwbnd8tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 00:16:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U0FXIh012719;
        Tue, 30 Mar 2021 00:16:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3030.oracle.com with ESMTP id 37je9p19q7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 00:16:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qrh209JMNiFteJtCOi38UFc2Je6dpSSZHmXfNp+vgSMOIRu7tAowyBPOFxxo0oc7iGg/d+WAJqZ8Nkqzw6Lc2WSorvLzs5RFBKTAhbsjmTDmc6m0/s42x8PQo2v2ZqASvUKcaxXabq4/n154UvnlD91k6WQIJ4XBhqRsOnpqAdDAxi7ISpvq8FdVZTDAH70sCJDWv1NFOM6bFfenf8i6fpuglNjr8ixzaK6MOIfFWzgC5wIN7WVemq1UQ/4rIFps8zCfEIzyLZFqzRgbXFBBkmv74b64VvXAqYd6EB+JVSzpoY6WnUR7fYMrJWHMQNKEECEF2FzH/FE0PsBU79DxPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljApwJHXh+7pjCh7HyR9urSeNDhqiGt7HFDeWKp/n0A=;
 b=DZtpEXD63o0eRbv7E+y8ZSUXUDEScVAxpgi4ir4Y1Pz7AKRVRghDo9bk8ghOoMYaxjhynzkdUgoOT0HLGhDkX5SLhOtycIckjc1ecWDgWsRAvwdjdJVd42G03Mn5PiQ3CSxmY1a4L7d+3bTFHiVhtAtNea0CO2Ro//yrghEOPJrvw3NNdz8N4P+sgc2HPqYkQChf9cr1hj/Fyt/gWi0l2Jel0Robob6c2JYFA9hApjIjmjs9ONTZOrcj065r/C7zuuvpo+xttjm2XQAcvpLMJSYlzXUIZrzlcSpb5sW7N1w5Awnz/v/asBEDgVpHgX9WNMOo+y79VD1BRFTV+Gd+kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljApwJHXh+7pjCh7HyR9urSeNDhqiGt7HFDeWKp/n0A=;
 b=ugPDNy8QKaSGphtn8luOv4EDfFCqztHA1WQc4qdVRGG0NNQCQQslC6C68EWb2IbmxFqNGg6AHxLVT5S5WW7ggPfSF/Q08L7awgmDmfR37p3Tlnv5aG/7A9BOZk2wVy/qdCElxpGLMDHlHPe8ccPTk1K8iDayvQpUIu0Hx1GeA/4=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4811.namprd10.prod.outlook.com (2603:10b6:806:11f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.33; Tue, 30 Mar
 2021 00:16:25 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 00:16:25 +0000
Subject: Re: [PATCH 1/4 v5] KVM: nSVM: If VMRUN is single-stepped, queue the
 #DB intercept in nested_svm_vmexit()
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210323175006.73249-1-krish.sadhukhan@oracle.com>
 <20210323175006.73249-2-krish.sadhukhan@oracle.com>
 <fca2f20e-5be1-701f-32a7-33e262b90edb@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <c854c7fe-b31b-9ea8-a6a4-334e82ed0ad5@oracle.com>
Date:   Mon, 29 Mar 2021 17:16:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <fca2f20e-5be1-701f-32a7-33e262b90edb@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SJ0PR13CA0039.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::14) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SJ0PR13CA0039.namprd13.prod.outlook.com (2603:10b6:a03:2c2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.16 via Frontend Transport; Tue, 30 Mar 2021 00:16:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d374894-6b32-438d-0437-08d8f3110e2c
X-MS-TrafficTypeDiagnostic: SA2PR10MB4811:
X-Microsoft-Antispam-PRVS: <SA2PR10MB481177080B54CCDC8A27F103817D9@SA2PR10MB4811.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uojXIYnXxnMfjZdRey2+tJcbOkxEOTxQ19K0egDS8ktKWjiKKgAX2U8K+6nrwdl6ovmSVWJze42tsNNZbh0ejE2/hr9puiP41qhC480ACmskAtT5lYZXDvJiX9MngDGez2c+WVob/IaTUhdvEtEAAw+9vE31Wijc9pYF9gMym2sx5IwnDwGa4sCz53001JUt/anCpm8uztDb/U6hnhvV2MapXPMwA35vyhm3qDQIcc9D+NuNoab1U/XnitvTC+64uLivxo8nwTnD8S5a7EUoy5lPAMSDtBbbZ5YgfQWv6reSM6GOT1V24K/zOzx08aeslaioqQhxJi9BWKRN5bIqVNkePAoz/I0D4DRuc5CLa1yqReiVDL3TxFGMtyKnEcC6VRPDevh32EueQyEL04CJtjmiuRz52SEqzVxc/N8BecE8xHQHTe1PObHGc5+0yMZurys2UXnke3yXShtXgvUd2HJrCqixCdGh6u5ukUFeBktqFSYpp1RCvxaQnpkx6zcrnm2JT3jmnB0A6vGK/AP5bxZVO7sJToWd/TYuyWcAt50AaVQ37Lr5xc5yepH3d+fuLZwwcfLqGI4bpGDZNILQHsuhwvcVubzdqyte+J+ve0sU1Iv4AYZ5HMUjiH7uIJDg5dBgPucfilkJM4eKd7fy8MuNj/EeJbmzyGnGaSnhLIoXVmkA7vkNCXhXUxGQutJb4P4qQsTC9u6JN6SKylthIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39860400002)(136003)(376002)(44832011)(6512007)(2616005)(83380400001)(66476007)(66946007)(4326008)(2906002)(53546011)(66556008)(16526019)(186003)(5660300002)(8936002)(6486002)(31686004)(478600001)(36756003)(316002)(8676002)(31696002)(86362001)(38100700001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aS9MdUoxSE43SW16UEE4dUR2Nm1qZkRqYlZMQUh5eGs2cnFvckFsMHdYRnQv?=
 =?utf-8?B?cFBOMHhXUmswSVM5cjNGYUhoMEk4KzQxNGtVaUxDMFU2NGx0VTJLTFRwanlk?=
 =?utf-8?B?ZndCZkRpRFVqZ25UMCtYWEdYMDVHZWRkeFBMVisybkphRXJMSUdSQVB4QkRN?=
 =?utf-8?B?ejdqT29qL2VXQWphUWhmNkNjM0JtQkdJTlNjNkdlU1k3Nk9DeHE0TkM0TmVB?=
 =?utf-8?B?TGdFalZqMDZJRVQ5TjNDTWlnclBkVk8rYmVpZVB2KzgyRiszQVBCcTczdW1T?=
 =?utf-8?B?QWxHMjl3dmFiNkVrSGxna2dYRWJGdXFVMzdqK1djR3JEZE1FeitrQ1h5NHhS?=
 =?utf-8?B?N05xYmp2cG5tUzZwQkJtSFJHU2ZNalhvUmhOdUc2TmszcnBnSWJUbDJvdHBJ?=
 =?utf-8?B?TTRvYkZOeTBqNmtETUR6WUltSk83TDVqNkg4ekhzY09mTnBRMXp0L1VOb01L?=
 =?utf-8?B?Z3ZUSkZtTHR4a3ErNk1jMVUrZHhtZ0hHdXVNVXB5aXdWakkrY0wrMFdKQjJX?=
 =?utf-8?B?QzlKWEpJZ25tcjdBZVJEb0lNZ1JHcjNXVzRHaCt0YVBEbGZmUjN2dStsWkdn?=
 =?utf-8?B?TjA3Q2pYWWtBVXJKVytaaVNRRWwxRm1SbTZ3N3ZzVzdIL01tVm5iL2VZbWVw?=
 =?utf-8?B?NjV5aG9ZU0JmMll0anlaK2ltWG9BMG42dkUxeEJmOVU0ZlhzQk0xR2J6bmJi?=
 =?utf-8?B?cEJVYVdwbEl2NmhZc0NoeVNBdlR4UFR0T2lmMG5sYU1QdzhrQk5vQVFDSGp2?=
 =?utf-8?B?bEFta1JOeHFGSnFnRk9XQWpkTDBCTjFtbDRzajVXZEVFdk43L0dTckVPUkgx?=
 =?utf-8?B?V0poVm96QjM0bC9mQ0w1MGJFYml6aURZeFpacGo4aGV4bU1PLzk1K1RvN3Bs?=
 =?utf-8?B?N1FTdTh2QXFXNlEzUnZSS0l1anY1S1pEWnVyMXYxdnhMYm1oNmNkNTZzY0RB?=
 =?utf-8?B?emdEWUN3ckJGUnpOdm9wMlJCVmhLWTZiM1Q0ZEhpZDNZa2xyaXlpa1ZYS3lk?=
 =?utf-8?B?T3l2c0t3TE1naHppN3NscDdodkNjWmZOREtSd2NwQnJZUGRtUXJISytxeWdo?=
 =?utf-8?B?ZlZrbVJTSkhwb1Y0MlBTSmZRbkRuNjNLdjVvZVJvTnZmblFobzBpVmFzbHVP?=
 =?utf-8?B?SGlBcFNsMzNsOUIxanFyMmI2YjlrSGRWZnlldXVzakg0TWV6a1c3bUhrOS84?=
 =?utf-8?B?Qnd5Sk95SUZTK0ozYkNUU2lmZjg5RmlUM3ZLVXhINGRhNHVVWklSSU5BRFZK?=
 =?utf-8?B?YXRWbTNOSjVjWHRxV0o5NHNKWkFHdlZTNXQ0MzdEOW9UYWZoalo1Ulhpekda?=
 =?utf-8?B?cEVoZXVzTE40aFpvaTRvZWkvQXRRUlJkK0E2MHlwam1KTXZ0RmVRRnRhRUtW?=
 =?utf-8?B?MXczdFhZM2tPcUw1Q0Y2M2tIamZoOWJTS1k1Y3dCWkFkZDdEUFMzZndoUkdG?=
 =?utf-8?B?UmNxWkc4NTlzVE5iaUQwRUpoU2Y0WUt6Q0g0ZUdBa1BWRDJMVDZPUzZwai9F?=
 =?utf-8?B?SFo2QmtJZ1Q4MmllNUc2ZGgydWZIYnoxb1JpSWtBVTI1Q05TU0MzNHp5VHJQ?=
 =?utf-8?B?RGZUaVdqQ0E3UkpVREE3aVlSVUpJNGpySFk3OFYyNlZ3ZW96VHNHVDJqYU15?=
 =?utf-8?B?a3lFdkkvR1dxSmNRZXRhb013cTk2M0IwTDlXU3NVRitTZ29FamNMSmJ5WEtn?=
 =?utf-8?B?REgwVTZuYndwZzY2YmlJdzRWYXVEN3h0dy9WSDc4bTJqSDVuTlNUSFcvV3hn?=
 =?utf-8?B?SUxENm84VHlkRHNCclhXR1RSbXdxeDU3RUViMWdFV2MxZzMzZ1hhRmkyTTdO?=
 =?utf-8?B?R0t2RFowKy93b1JQUkkydz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d374894-6b32-438d-0437-08d8f3110e2c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 00:16:25.2263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ktnu6N+UuTeMB77fUqLTjoZpKX4mVrV5/AOtHYSsehmBY74IDLHYxooqTzpELhwps3MIkWM5OzeBK+yObCV01nvz5Gw8VzsbdFwGOwLwBaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4811
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300000
X-Proofpoint-GUID: _hYd2LyjSq7gJWrx8QP_sZApMrD_-192
X-Proofpoint-ORIG-GUID: _hYd2LyjSq7gJWrx8QP_sZApMrD_-192
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 clxscore=1015
 phishscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300000
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/26/21 10:32 AM, Paolo Bonzini wrote:
> On 23/03/21 18:50, Krish Sadhukhan wrote:
>> According to APM, the #DB intercept for a single-stepped VMRUN must 
>> happen
>> after the completion of that instruction, when the guest does #VMEXIT to
>> the host. However, in the current implementation of KVM, the #DB 
>> intercept
>> for a single-stepped VMRUN happens after the completion of the 
>> instruction
>> that follows the VMRUN instruction. When the #DB intercept handler is
>> invoked, it shows the RIP of the instruction that follows VMRUN, 
>> instead of
>> of VMRUN itself. This is an incorrect RIP as far as single-stepping 
>> VMRUN
>> is concerned.
>>
>> This patch fixes the problem by checking, in nested_svm_vmexit(), for 
>> the
>> condition that the VMRUN instruction is being single-stepped and if so,
>> queues the pending #DB intercept so that the #DB is accounted for before
>> we execute L1's next instruction.
>>
>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oraacle.com>
>> ---
>>   arch/x86/kvm/svm/nested.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>> index 35891d9a1099..713ce5cfb0db 100644
>> --- a/arch/x86/kvm/svm/nested.c
>> +++ b/arch/x86/kvm/svm/nested.c
>> @@ -720,6 +720,16 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>>       kvm_clear_exception_queue(&svm->vcpu);
>>       kvm_clear_interrupt_queue(&svm->vcpu);
>>   +    /*
>> +     * If we are here following the completion of a VMRUN that
>> +     * is being single-stepped, queue the pending #DB intercept
>> +     * right now so that it an be accounted for before we execute
>> +     * L1's next instruction.
>> +     */
>> +    if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_VMRUN &&
>> +        svm->vmcb->save.rflags & X86_EFLAGS_TF))
>> +        kvm_queue_exception(&(svm->vcpu), DB_VECTOR);
>> +
>>       return 0;
>>   }
>
> Wouldn't the exit code always be SVM_EXIT_VMRUN after the 
> vmcb01/vmcb02 split?  I can take care of adding a WARN_ON myself, but 
> I wouldn't mind if you checked that my reasoning is true. :)


Looking at the patchset on "vmcb01/vmcb02 split", I see that we are calling

         svm_switch_vmcb(svm, &svm->vmcb01)

in nested_svm_vmexiit(). So, yes, by the time we reach the above check 
we should always have an exit code of SVM_EXIT_VMRUN.

>
> Paolo
>
