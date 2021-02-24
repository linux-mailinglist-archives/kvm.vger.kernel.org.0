Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521D53245A9
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 22:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbhBXVTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 16:19:16 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44620 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbhBXVTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 16:19:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11OLAsfN015973;
        Wed, 24 Feb 2021 21:18:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Z0PM3GELoplniTQvHlVg3CqSuFZZN1gM6nPuOjPjdJQ=;
 b=AQGqDeZP8RFk9GdW4ChAMP/73VjJEq7FWgmFMtiK9hn8D19z623ylMGLN6dq8ExcXJ2s
 sicoiNm7bgun0epWMM2Gh/MzUe6uDXfxhG5rNO3Pj59FxAzPOSlwjdL3SsyD0T9py3AL
 OQv7TWXKfQZWK4O373sZ0tK2X1qGPtUdM7akBQpy2ouXbqtKJxau2wL7cacpWZleDMvJ
 WyE1TFCeatm7Z9EvlXuew8FZcyLIWI6jtyX82YLWitXHMjkrH+VUennjOq8T2vP9nmxL
 4MEEORq1aONs2j0wdpyKAjMCFJn4ak/TauI04hnjr1sw4QwmYn8XDrk9nfc4vsnvgKsY 5w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36ugq3k9s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 21:18:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11OLAdoB040961;
        Wed, 24 Feb 2021 21:18:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by aserp3020.oracle.com with ESMTP id 36ucb184nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Feb 2021 21:18:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rwsiv4vqQZwgzwjPl+nAA4jz0UV4sZCKcpod1Ob5TIY5mbXAnXRCZBtHQc099FwrvbQ5kUpFF/kZ2u4RMue3cARzbnLGq3joOkl6PshD8Poek7oOXHlI7y5bOliGw3XtcCVF9p9o8PVpwACfQgSps99X3fjRzTc5HzhmpEg3rIqM7LG7rXMOhDoMI/Mq4z/36vYuhizbFv3YKjXD7+fdTuDPz7r0KmsCYbe2uTh8RBsE4WU0k3pJZLDBrOAR17ZzwLzn1eP0Ttys4zAKKXo5tRQt3s1l82sYmcO3mZJw2NdhtO4fTMqkE60JP+FX7HITfviCkwR+BATZOu4iH6/ehw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0PM3GELoplniTQvHlVg3CqSuFZZN1gM6nPuOjPjdJQ=;
 b=PzeKmPp7jX8Ag0m4v+GDQ4hpSO0R/P0l6oTczRaDy1QoetS9XarMtP9av4uS7tnF7L8ri28IFkOQ95+VFbF8Y5ziYbq/8HgqqsoLKlTJRJZlhTCXH+4c/ZA49S8Yjg9r5k7irkbaYaJrcano6xHKMYDhqXDhlc0EzvsJZoR9soucuIfSFCYJaaYQDhDfwVzqPeKDaUQRDF9Lb0NgD9zWF2yBIzdgKZztDs3qpbEu9SJaROh/fDK0Na/mDRq7miYU7Gvz+ctF1xHeGaAy1UPXXxxHGq9783cvC7A5GHuyYFoMbrq289jbhlw/Ap953pRoAth9etRUhthiotHOFrRVfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0PM3GELoplniTQvHlVg3CqSuFZZN1gM6nPuOjPjdJQ=;
 b=NLsbN8W7NhL5mwuLPIKq0rAGUqGoYeNijXr5IUmkZvlS0t7Kksb7abH27ubrzlG8V6CmqSZiBl5vRYEhx9hRlfdGUu4V3plFTD3PdDYoC5ivV7VwuSxZzHkTfZxi9+jF9PlJb9gILHIOpmyv6uF15R/tAK/QTIgs+aOv6UhI0zQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SA2PR10MB4522.namprd10.prod.outlook.com (2603:10b6:806:11b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Wed, 24 Feb
 2021 21:18:27 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 21:18:26 +0000
Subject: Re: [PATCH 1/4 v3] KVM: nSVM: Do not advance RIP following VMRUN
 completion if the latter is single-stepped
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20210223191958.24218-1-krish.sadhukhan@oracle.com>
 <20210223191958.24218-2-krish.sadhukhan@oracle.com>
 <YDWE3cYXoQRq+XZ3@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <0e553de2-2797-9811-b2a4-8d1467ab64e8@oracle.com>
Date:   Wed, 24 Feb 2021 13:18:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <YDWE3cYXoQRq+XZ3@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: BYAPR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::28) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by BYAPR07CA0015.namprd07.prod.outlook.com (2603:10b6:a02:bc::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Wed, 24 Feb 2021 21:18:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3db18ad-f40a-45b1-f594-08d8d909b9c1
X-MS-TrafficTypeDiagnostic: SA2PR10MB4522:
X-Microsoft-Antispam-PRVS: <SA2PR10MB4522EEB1ECF5D75FF19E2567819F9@SA2PR10MB4522.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YHBcyWZpsBTGqT5EWic47XA5RBHTBIOXfYJxus3C+3JfMf+CUsLsii5MTePPFDxPshowbbW2IZFeseUWhs0lkyLhjikN0tGYmGHywuIljsp80lSVx3b5R211VqLQHf5mNaj71mhtmOPsgYwh/L65B3UvQsK6bCMU8V6DFNiL2XvQB3RYXd7H4z8FRtKGUcVHRj3DXWm7KNrxIc6fGSHfLL80wZnuaDOE/rKHgn4WFsveqVOFD/l/Cq37uaA7+cK/q9Gmlgnkgz3GR6JIDOYloZzzlaIliyz0DU4N+bfQK01NKyae2cTHmlIbvkmtc02WXoyaB/tpsNt/I6nkgKrWyLGNuszoxMgqfJn8WNVPESqDgm1ChYLOGK70JXJ+e4ouCmLL4MbXx/mvgS1nzu7lsHC2nDD05oj4WdqgFhZ8KGk3Haifa0r/Ml5XXvFse1DGwq8xX8q9k38fRxFGPHB2DfBN+r7bmoTrRh6oc7mqy4fZCSnQazoZ0cYSPl0+fSPX5RXHFh2LGgSCGKkaX0+hpSkNikj/2ljTdvRaqNlsb1SbEDX0BOloT7zWX5bwa787hMyrL9iahUnkS7eZKT3/+CCW9q3I4qd49I5AbxWZXRc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(136003)(376002)(39860400002)(186003)(83380400001)(4326008)(16526019)(53546011)(86362001)(478600001)(6666004)(6486002)(2616005)(36756003)(44832011)(31686004)(6916009)(316002)(6512007)(8936002)(31696002)(8676002)(2906002)(6506007)(66556008)(66476007)(66946007)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bnRiME9xbGFGck12MlFtc1hMekdWT2xVVHkxc2RhMUFKWDZpZ0xGRVhnNHJE?=
 =?utf-8?B?YXVpZUdMc3hTalREU0JvOEtKQ285cnNBQWNDWW5EM0tNWHVCMDhIM3ZBVWlC?=
 =?utf-8?B?QUNpeGluakdveUVMaXFSY2xmNmVMTFNsVlZIYlpGUlREeUU5azl1aTlEcEVK?=
 =?utf-8?B?eE1GTW1PS3lxSEdabVV1UU40WXZmTlQ0NTF3di9WRFY5VE9Tc0d4VUhLTkh3?=
 =?utf-8?B?NFQwMk51R3dIeXZNR1VYYS9oclhEaTBsVjF4NWVHYzRXMUN0cVJGd3o5bWhN?=
 =?utf-8?B?Lzh0bGVBK0t1ejh4TGFHV1JjMjBPRm5iTzQyQm9xQVdUbVRjcisweFdCcDMv?=
 =?utf-8?B?eDFtUVZFUUhURjF5UHY2VW52b0tUR1Bld3BWTXJJOFVla3d5Z2JXdE1qRGtT?=
 =?utf-8?B?Y0FpWmRyOVYyMHdHRUM5enN0T3ZJWmZpcER6ekdnRVhYZ2lkN1YwdWpPWE1Z?=
 =?utf-8?B?TkNoWUZ1elpVTHlOc1hjd0x3eGEzSTlaYWN5ZEZBS0RVWUtNNzZhamllZFpp?=
 =?utf-8?B?TlYwTWkydmlMVXBmWk84aWxLZ0tlOU9tRWtPZWROeUt0ZnU5V2pDanZ5ajVU?=
 =?utf-8?B?ZlVOL2lMZ3RrZnZKVUNnaWhNeXZqeWJsd0RQK0Z1cjlRaFZsTWVQOVR5WE5U?=
 =?utf-8?B?NUxlY0VNOTdIdXBDampoY09yRDZ4OWw2UVhGSWJnRkpKWStDRk1SRi9MQzRN?=
 =?utf-8?B?SG5LdlBWMlU2RW1Fbmlka0pVbnVEQmc5V3lZTHE1a2pXT2hYVDgzTXd3dDJG?=
 =?utf-8?B?T2M2R1A2RE9BdzZHOEZLYnVVTnNVckQ3T2FKNFl4aThzY082a2dJZ0toUCs2?=
 =?utf-8?B?U0tuUHBXTmlMOEZQTkFNR3BYMEJSYjE1L1RhU1lzQit4RWdqeUJPd1c5OVlq?=
 =?utf-8?B?MTBqWUpMQURTb0FYNnFIWllCekZXU3FZaGdkQWFjclJZODhVZDFGc2hlaTl5?=
 =?utf-8?B?U3o0RkYybEYyVm1vSEpLaTBqZHM4bmpEcjZ3UUhJazJ3MjYxMDA0eFJUL0U5?=
 =?utf-8?B?ZGtyZUt5dkE1TWJjRnZwMVBCWTdUN01XdkhGTlJoaWNRbXh2K3RBekxIL0Vt?=
 =?utf-8?B?bmtEd05yMnJRdVY1SWFFRENFZit1c3NOMjlpM3A1RWk5Wm04WVJoaStrVk5i?=
 =?utf-8?B?V1MxdEpYeUs4QmZMMHpNc3QxTU1EVWhUd2VQTkRLcDBDUnFHa29zMXdlYjQx?=
 =?utf-8?B?TnpScWFYTTh4VmhvYmVaZ2ptTVN1NmpZVkxHdEFVV1BBMTBQZGFXTVFOQ1Ja?=
 =?utf-8?B?cHhscjhldWplRmVpb2wrVW1xTW1MUEZ0QkxTNUhTM0JYNi9UcHJSRklNclBP?=
 =?utf-8?B?UHQ5UnRzTExwbnhwZ2ZNM3lGMXVpZWRpeGFQeTNsQk5OMnpudFA1N0tuRFJs?=
 =?utf-8?B?YXdwVEVPb1RJT2s1WWZDblk2b3JjWnJzQlZEQS9kcmRlb3lHeG5VZ2l3dVVD?=
 =?utf-8?B?REcyVWViWWJxbmhtNmlTekczOXVOZGRGS1dxZk96VFNaOHZFRW1PL2J6M3Mx?=
 =?utf-8?B?OUVNYlhhWTk2OVRFZktONHNSaVY3MU1DTDc0a01VMmNjM0ZEekF1My9qK0dO?=
 =?utf-8?B?Qjh0S0JUYUtrTHg3clVudnlybnZid09jYkx3NC9vZUdZWVJ1VWFjOW5uZGlZ?=
 =?utf-8?B?R0xXYkxDUUh3N21HR0dMTWJ2ZU1BbEJXbkthdE9tTmtPbFdtRk90eFg2QVpn?=
 =?utf-8?B?QmMxa3UwaUVKbk5jajViOU5yVCtrL2FqcjE5VitSMXNhKy9MWFF3Sk9ISkhY?=
 =?utf-8?B?eDY1MVE4QjZGQkJ5bEV0U2R0dEszN3B1ZmtUZWlpUS9ZRW5XNjdRd3pOVnJP?=
 =?utf-8?B?eXdGNzAyZ3pKSHNuTkx0dz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3db18ad-f40a-45b1-f594-08d8d909b9c1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 21:18:26.8853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rrrt9QAPB9GqYH7FAFnIIU5xAMglsYwOs3kZeNEpZQyO246mZmrSGSQxAriW62vsjShOCFcTbnTpnxLZzcrnLqzaRWZsIq1gaH990/TsnUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4522
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240165
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9905 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102240165
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/23/21 2:42 PM, Sean Christopherson wrote:
> On Tue, Feb 23, 2021, Krish Sadhukhan wrote:
>> Currently, svm_vcpu_run() advances the RIP following VMRUN completion when
>> control returns to host. This works fine if there is no trap flag set
>> on the VMRUN instruction i.e., if VMRUN is not single-stepped. But if
>> VMRUN is single-stepped, this advancement of the RIP leads to an incorrect
>> RIP in the #DB handler invoked for the single-step trap. Therefore, check
>> if the VMRUN instruction is single-stepped and if so, do not advance the RIP
>> when the #DB intercept #VMEXIT happens.
> This really needs to clarify which VMRUN, i.e. L0 vs. L1.  AFAICT, you're
> talking about both at separate times.  Is this an issue with L1 single-stepping
> its VMRUN, L0 single-stepping its VMRUN, L0 single-stepping L1's VMRUN, ???


The issue is seen when L1 single-steps its own VMRUN. I will fix the 
wording.

I don't know if there's a way to test L0 single-stepping its own or L1's 
VMRUN.

>   
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oraacle.com>
>> ---
>>   arch/x86/kvm/svm/svm.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 3442d44ca53b..427d32213f51 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3740,6 +3740,8 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>>   	instrumentation_end();
>>   }
>>   
>> +static bool single_step_vmrun = false;
> Sharing a global flag amongst all vCPUs isn't going to fare well...


I will fix this.

>
>> +
>>   static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>>   {
>>   	struct vcpu_svm *svm = to_svm(vcpu);
>> @@ -3800,6 +3802,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>>   
>>   	svm_vcpu_enter_exit(vcpu, svm);
>>   
>> +	if (svm->vmcb->control.exit_code == SVM_EXIT_VMRUN &&
>> +	    (svm->vmcb->save.rflags & X86_EFLAGS_TF))
>> +                single_step_vmrun = true;
>> +
>>   	/*
>>   	 * We do not use IBRS in the kernel. If this vCPU has used the
>>   	 * SPEC_CTRL MSR it may have left it on; save the value and
>> @@ -3827,7 +3833,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>>   		vcpu->arch.cr2 = svm->vmcb->save.cr2;
>>   		vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
>>   		vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
>> -		vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
>> +		if (single_step_vmrun && svm->vmcb->control.exit_code ==
>> +		    SVM_EXIT_EXCP_BASE + DB_VECTOR)
>> +			single_step_vmrun = false;
> Even if you fix the global flag issue, this can't possibly work if userspace
> changes state, if VMRUN fails and leaves a timebomb, and probably any number of
> other conditions.


  Are you saying that I need to adjust the RIP in cases where VMRUN fails ?

>> +		else
>> +			vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
>>   	}
>>   
>>   	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>> -- 
>> 2.27.0
>>
