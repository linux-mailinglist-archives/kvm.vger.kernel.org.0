Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7A0344F82
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 20:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhCVTBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 15:01:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47040 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbhCVTA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 15:00:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MIwsnD075259;
        Mon, 22 Mar 2021 19:00:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=WCLf5z3kfnZ/M3gWBRCla/kvjytY3u+newj5rJau660=;
 b=YsSIP0NWwK6jAi2/JUTkEy+evNtbTyLlA0KJaxbauq8yMHykk6ik12hQ1ax0IJjFNYU3
 qG9SBG4cAdJscNMzI8CLcw11ogyKbTvA21/GJ+ltUYmyspgVINS180a3I2cVwCW2lt4J
 ARBmqAmXIZHhasnDei/KndNtJxFaRcplU/u13vdcf4e62ET4L0eLc4Va7/1eTB3XSZxX
 S8B4LRZ0iDiFoZmvdk7n97iphnhVLnbgmeQjEpICa7SDO1yYIDxwmmz313lObovq22MQ
 NpvdmWyW/SfC1ZTN7C0cUn3FPzQzB5I4KTcU5FDUPAxeFH5RddnTTVlBsrrxl2f3MQGx gQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37d8fr4j21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 19:00:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12MIp5Zl155798;
        Mon, 22 Mar 2021 19:00:52 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2040.outbound.protection.outlook.com [104.47.74.40])
        by aserp3030.oracle.com with ESMTP id 37dtmnjt2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Mar 2021 19:00:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATNu4ClsPBbPktr0zFkyHIBql9xvxntJ3o9OEbrKgWy/GCRw7z65oTpnC782FucNBHkA6ofDMbKouRT/13vnLJIdrq41FzZhzhqW+R9y9he4gm96joGkh/nTCcgM4o+z/gYiSnz59Rz9yfVnuu2JWodZYmOWjN6Pns4eLIm54U79F96ao+2hkTHaA2nh7/wVjdAJoWSB9XnubJ9v1Uq4gzvuVzlWf3//md7AYsmnG6ZSMrboecv5RblvmW/e5+virPH/cfgI9a9/HYy4/KRtkUAXZOvLFgu8o4RkHhK6ta6bYE0IZbOgymUSfTtIOp5tiYFfm/QSfWQxhEYtA6y7aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCLf5z3kfnZ/M3gWBRCla/kvjytY3u+newj5rJau660=;
 b=fQ4CtqBAINuOaTwlhZCJRT2nKeFUBM9qBUFoxof+nP/4vlT97N9+aCYC0SdQJu40GDIOGyJeB2dshZX1ZYsIDWbeHXkUBmeBPpW1GVNQjg+KdgE+xWTYXup9bnIDCpEH1dW/F+NYpewdm0HSU/7QCE7mcZdoqamhdBukmboveAPwF1liPnqLvB2v2FFBMtBZyrdmeQPbocf2JF5GySefOe4x8r6Xse6DBRn0PkmMhymrAMHXHX3IKGg+SBhYIVwGplvtioAitsm1hyOKQM2VPU5xJTZ8Skoq80N62qTd0jinf8xS1JsbezqZiuS/VjqFQWsvB1s86T9RhY5D/c/PDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCLf5z3kfnZ/M3gWBRCla/kvjytY3u+newj5rJau660=;
 b=xPA8MGS4+0xyIYXv2lP+Lns9exPoW7zbQowg9I+LKA59xuyC2R47I2AZYdkPpyQ0Tyu/e29pAPHF/baj6d1FoxsvmUejxetVsDmrh5Gy48QXK+pDjJXPy1QubWpJljS5N7lB5BqAANNyjT7cvdIiEQdkl0CVNByoxiZQzI8XCcM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2559.namprd10.prod.outlook.com (2603:10b6:805:44::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Mon, 22 Mar
 2021 19:00:50 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3955.025; Mon, 22 Mar 2021
 19:00:50 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH 1/4 v3] KVM: nSVM: Do not advance RIP following VMRUN
 completion if the latter is single-stepped
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20210223191958.24218-1-krish.sadhukhan@oracle.com>
 <20210223191958.24218-2-krish.sadhukhan@oracle.com>
 <YDWE3cYXoQRq+XZ3@google.com>
 <0e553de2-2797-9811-b2a4-8d1467ab64e8@oracle.com>
 <YDbMOxqQLw5Q2Iy1@google.com>
Message-ID: <6fc70470-1268-9592-67b9-eb27f7878d46@oracle.com>
Date:   Mon, 22 Mar 2021 12:00:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <YDbMOxqQLw5Q2Iy1@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: BYAPR02CA0040.namprd02.prod.outlook.com
 (2603:10b6:a03:54::17) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by BYAPR02CA0040.namprd02.prod.outlook.com (2603:10b6:a03:54::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 19:00:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c730bfc7-adca-46fa-e417-08d8ed64cf3b
X-MS-TrafficTypeDiagnostic: SN6PR10MB2559:
X-Microsoft-Antispam-PRVS: <SN6PR10MB2559456457B101A99E9490B681659@SN6PR10MB2559.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PfgUt9EqT/4Oil2Hz04P+gNu35BQRF2KQXKVBoEqJjmqeHgN8cNVjng4+PapL+9tsMgkkLQXSRmdMQSDbSEPpoQdz/TIH7smIxxCYng2NgzE1BkFnTS0Jumu+sk4s7Iki3a+xldNQQfSTwlDhy3M2W6JtPyVdcbvPf8D2Zz5NiZ6eIS82ncIMrdgSNN0hXgJQfB5YYLrTNsyuNH9KWImyyRcSwcp8cweJcaxDEhIVPp/JkHbuFB+UOULeJLy4eKhWUvIyJk3awe/kY4fWMgfYD16LF/ltnSRo7eQYYsDMVe37WHMELMKRkSxWSDlaG+ghh/ImhWOTk2cIwQsVj1jvYHccoTcOKNwdXMlKO+WqNqiIDSFeEde6AeIxwndS1lxZs5sOJU511OcLvn7gAEvj5JezyCdssuwPK8xF7t1gzi0pH2CZXQuhwJoij2wragI2jsQphpUUG6rOKMtsUuAJQnjjNiAKqNXi2QUnRy170gh6HAEuld7xbnVfz+8n4vQVYJLA6foJok9AOix8EwrKpmg1D4X8QvZeP8XYm0k0z5ewByYNu2IX/jUKMzHXu/nmH794ez7wBxBhfaRxcdy+rqJxJchJ0b4OwgiZWqBk2B4LESsHq0DoqeTitD/uthiMVcyBBYX4jCS0eXs70Fmt3lHkf31cJxgTUpNu2MhvmBhtzW3zBLJSyboTAodPQtmIi3Zu0oPUqLTqs0Esx7zQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(396003)(376002)(366004)(5660300002)(36756003)(8936002)(8676002)(31696002)(6512007)(6506007)(53546011)(86362001)(16526019)(478600001)(66556008)(186003)(38100700001)(44832011)(66476007)(66946007)(4326008)(316002)(31686004)(2616005)(6916009)(2906002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VHpNck1TOXJPait3OWlUK3g3QW42Q09tMkt6TDk2NFBQRHNHOTllRmpuTlBO?=
 =?utf-8?B?bkRTOFlXNVRXSHJ2Zkl2MWkxak5vVTcrRWx3SkVuMjVUaTVtL2ZpTjVtUTYv?=
 =?utf-8?B?SkJaVzVETTJ0bVorOVAyY1F3RGdtb2NaRWc5QXlZbUJXbUVzWXBDOHRTcW8w?=
 =?utf-8?B?WkVUV2hPaXBya1lqMWcrekpLczRCSG1nTmIxWDZRakhja1pJZHRYY3pqSlYy?=
 =?utf-8?B?cTFZYW1WMmppUU1KMGpUVWZWQmVqQVdKNGRQVytZSklDbUdwR1hBK1VXYTV6?=
 =?utf-8?B?T3RrNUdMM2tuMVYvb2dlK3NnTWRXSTJlem9vbys1aUZxNW8xUTJUVGQ2aktq?=
 =?utf-8?B?M1hzcXk5WHY3K3dremVXOWpFa0hmdU04eVVUYll4QTIySk11Tm9yVUt3VW83?=
 =?utf-8?B?Q2ZyWHdzUkJXTGhtcWN6MkdIMXNaYXU4L1MzTDYyR1g1NG0vU2RHdXZrSHFt?=
 =?utf-8?B?VUtqaEQxNEUrZ3RPWkhkV3ExdjAvb1cvSWRPLzlpRGd6cHpNdVV3NVI4NlhU?=
 =?utf-8?B?U0tuc1YzeVNPd1VBQy9Qa29Xd2hsaVJieFpaZG90M0h6WXZKSHU2U2tFdHhm?=
 =?utf-8?B?eGxveGVhd0VnWkJWcVhpNktjWFhzeXZheHBvYUJBSWZOSWJPbmFjZUk4YTZB?=
 =?utf-8?B?Ui9pR0J3SVQ2MnJLR0FiUlQ0eVJaWHNWdVZMNmlMOFRYejFZa1dDbmRiUmw5?=
 =?utf-8?B?d1pyeGdNT3haWjZybEFBdnR1YUJud1QrTUFGNlh4NHphYVl3cjJ2eEhEVEF6?=
 =?utf-8?B?UUlVSWpoWkJycWY2a3FtV1pnL0hSV3c3R0xTK1JRdTdYZXF6aFFnZXR5ZWxQ?=
 =?utf-8?B?Njg1ZGIzQ3dRWE9Qc1JJMlVINWxrODFmQk9IcGs5ZFpPZERkSDN0eWYwMkNj?=
 =?utf-8?B?QkFPWkhuZC9OeTcwTFVqZWRnNzN1WmxaUCtDaHdJbGZXT0RIZVNCYjZBeHJz?=
 =?utf-8?B?bDdHaWF4Tms2cG1KajlFcTdlcWtOa2FHN2l6YTk3RlpJbFNHTmQ1cTdCVjRp?=
 =?utf-8?B?K3FYTkZjUE5vSXFmRFhFWXl5NGxLcDZUWEcxUTVHaERyNW1YNElEOUw0V1NP?=
 =?utf-8?B?cmo0dUxRS3grcXROM1hnNW9kVElVV3c3YmRzZ1d2ZnZ6eWY4YWg3VUFJcUhr?=
 =?utf-8?B?cmU3MXR5WWdPSnFhRE0rWnJrYjBFRHNKL0tyR1dtUmF0OXU3SmhtL1RMdnJn?=
 =?utf-8?B?Sjl5MjgxRnJ5S1A4aHpKSVBBcnhaZWg1OFVGK0w1ZnVLUEVydU5jOFk5QVJE?=
 =?utf-8?B?YWpkaTlUS3JocWtlVzV0YkVFTmhvV0dpZUZ4VytsVm5FQVp2b09YRXJsWW1N?=
 =?utf-8?B?bFh2ektYVGFBb0gzZW90ZGMzcGR0YUEyM3I4UHM5RmFvdkE4OW85MXlpK2dN?=
 =?utf-8?B?Yy9VM0R4azZ5S1lneldNSnp6SGhydDVGSEZvSktxenVmelREbjE0S2FERXVh?=
 =?utf-8?B?UVdnY2tiUFRrTmVmZmM5dXlEbUgybTdHKy9raXRHd3Uxa0JtSmE5K1BzZm1L?=
 =?utf-8?B?ODdYUnViQWdRVkpqYTVXSTZyek1JeVpQZFdOMFJ2OFQ2dnV1eEVvYVRPSzRa?=
 =?utf-8?B?ZUxHL1dJQmtlbXBCK21seTk0Y0pucXJORitsaXRlcUZrcFdnNXQ2bnVIRnp1?=
 =?utf-8?B?ZlQzZ25LUEZNQVNwQS9tNGtUN3l0Y3lVOTIyd2xObWQ2UEl6RmtkR3RxTDha?=
 =?utf-8?B?VmVBczFVNnNXbmw5NkdKTWlEdGFQWGJjZ3Z4c1Y5WDFrek9FWE1iV2ExcENJ?=
 =?utf-8?B?QVZhMzFzbDVXelZseXdwRG5pRS9aSFEzNVZhNWQ3NGpnY21oV1lUVXhiSnF2?=
 =?utf-8?B?aXpUWlZDMkk5bTVtbVU0Zz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c730bfc7-adca-46fa-e417-08d8ed64cf3b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 19:00:50.3755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d4FYKrpfOQrj7zbclt5QPGj0WHzHAluf6mpnd3DjUAjnUYnwU0cyiVDIwzQMv9LkAzU846nJLqak+ZGihw0I0hScZR4vc8pe3jcYEBgZ8Bg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2559
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220136
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103220137
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/24/21 1:59 PM, Sean Christopherson wrote:
> On Wed, Feb 24, 2021, Krish Sadhukhan wrote:
>> On 2/23/21 2:42 PM, Sean Christopherson wrote:
>>> On Tue, Feb 23, 2021, Krish Sadhukhan wrote:
>>>> Currently, svm_vcpu_run() advances the RIP following VMRUN completion when
>>>> control returns to host. This works fine if there is no trap flag set
>>>> on the VMRUN instruction i.e., if VMRUN is not single-stepped. But if
>>>> VMRUN is single-stepped, this advancement of the RIP leads to an incorrect
>>>> RIP in the #DB handler invoked for the single-step trap. Therefore, check
> Whose #DB handler?  L1's?


Yes

>>>> if the VMRUN instruction is single-stepped and if so, do not advance the RIP
>>>> when the #DB intercept #VMEXIT happens.
>>> This really needs to clarify which VMRUN, i.e. L0 vs. L1.  AFAICT, you're
>>> talking about both at separate times.  Is this an issue with L1 single-stepping
>>> its VMRUN, L0 single-stepping its VMRUN, L0 single-stepping L1's VMRUN, ???
>> The issue is seen when L1 single-steps its own VMRUN. I will fix the
>> wording.
> ...
>
>>>> @@ -3827,7 +3833,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>>>>    		vcpu->arch.cr2 = svm->vmcb->save.cr2;
>>>>    		vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
>>>>    		vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
>>>> -		vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
>>>> +		if (single_step_vmrun && svm->vmcb->control.exit_code ==
>>>> +		    SVM_EXIT_EXCP_BASE + DB_VECTOR)
>>>> +			single_step_vmrun = false;
>>> Even if you fix the global flag issue, this can't possibly work if userspace
>>> changes state, if VMRUN fails and leaves a timebomb, and probably any number of
>>> other conditions.
>>   Are you saying that I need to adjust the RIP in cases where VMRUN fails ?
> If VMRUN fails, the #DB exit will never occur and single_step_vmrun will be left
> set.  Ditto if a higher priority exit occurs, though I'm not sure that can cause
> problems in practice.  Anyways, my point is that setting a flag that must be
> consumed on an exact instruction is almost always fragile, there are just too
> many corner cases that pop up.
>
> Can you elaborate more on who/what incorrectly advances RIP?


The RIP advances because KVM is not taking action for the pending 
RFLAGS.TF when it executes L1 for the first time after L2 exits. #DB 
intercept is triggered only after the instruction next to VMRUN is 
executed in svm_vcpu_run and hence the #DB handler for L1 shows the 
wrong RIP.

I have just sent out v4 which fixes the problem in a better way.

>   The changelog says
> "svm_vcpu_run() advances the RIP", but it's not advancing anything it's just
> grabbing RIP from the VMCB, which IIUC is L2's RIP.
