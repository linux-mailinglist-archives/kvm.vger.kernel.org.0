Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA81D368A44
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 03:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235869AbhDWBN2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 21:13:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55736 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbhDWBN1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 21:13:27 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13N18vb5157257;
        Fri, 23 Apr 2021 01:12:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=O5U8ArhvyLh6wAXec+9qOeUCJKmQS+2hBuq9XtacwVg=;
 b=lsVuyleJFlQPbJ7bXQ4UkaHm5hdir0Aa4klBzqyCCvjT6Cvc4DlBHFjtKFeFjeN2V1ps
 kWb84unnx7nooaKV7tP3K0I9+OwvcIAHhLqQ0g5qAlyWfbQGKihEiHZBOR76+yD6WBCm
 sm23NfIwnpS6LSvJ3CYKmNhBRMj22Zuj67PiU0UXs6gbM7B5xzZIfQBfvcNrJWGTSyVp
 cP1YEfdsNgv1I7yDIGhMMFb0ADuP7Y34mmMT+5QJTEwzJm3CrHn/IStokBUe9yaQCWBM
 JgiPsIgPbkVGDqFLPC2LMhBa2BUyKXjARUV5YVKTCPtxeCSL4DsESKze+F9A1CRMSSs5 Fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37yqmnq15g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 01:12:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13N0xsGq172113;
        Fri, 23 Apr 2021 01:12:48 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3030.oracle.com with ESMTP id 383ccf1r67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Apr 2021 01:12:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSutsej2biPoxMKOT9Qwpdh6gZIICwzHK0A91Vdr2sPs0Lc8tTA+K2cmfv+M7dgZcwXPaEs9pu8xYqnaBrEg27zDg6EeFwhOvPL2XF3I7D1zjynm2K/MsWw7grBoYgvO6+CegpnOSSvb4iO4w6/+/WqqSmYwIj6pAJRw6aN2jefc6Pt59oAmT7KDwqMFvZNECEuHIfBqE3JjYGMhIFbqct/5lcrUQHHvMt8ZkUVRbORAru5APov0KQH3kUhhQ6gfY5RLIx+b4JJma96tnEssFoqPEUARsopxi4tmRO+U3htwqtPdVSoYri55rWKXr6wqtG4CtaI+HHFzEtebicQi1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5U8ArhvyLh6wAXec+9qOeUCJKmQS+2hBuq9XtacwVg=;
 b=c8rYWBRVYGwB5D2Y18NEnmWs+xzlid5hKJy/SvRp2iB+8+P1hTl1bF9ZWAFSHJcyjCykWjF5G6IzqUzTiNJ19lus3r5pXEoBLE3zpplYJNSv41HHaWNHsgeUPWEqneZXREucOxlC7jmAhLKtF11IBUUnTRdkzg1TY0ZPWg0vRBHOXN91zesm4XNqhfNiowEsKB07TnAQd1ohpGdu511elbA9MTzb0BllCcLCyVxrwO7ERKg/uLGKbE4nAQ+3XuRU92dC5orA+NZXPJu1NMJ5aYnD8Rjy2XYvKrIUrpQT0UFXE2Hp8vu1fkDJe56J1593YpDLx/LjD3xg2/VjxFyVIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O5U8ArhvyLh6wAXec+9qOeUCJKmQS+2hBuq9XtacwVg=;
 b=EKNRcuubRs/JxtyBnm3z1yPvxNydV6nciDEg3Uv96HCKXKdpeqFokxUCMLW5QiAcU02Cc0pCfkJFyEBDizHk/36mdeoImcxH9IicE7N2PPeTCxYJdNRk53oAheSDQnU4nj82mcAByrSsREYqeFnGeVQDp1w54w3BAEIxCqjbyoQ=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2560.namprd10.prod.outlook.com (2603:10b6:805:45::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 23 Apr
 2021 01:12:45 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::5911:9489:e05c:2d44%5]) with mapi id 15.20.4042.024; Fri, 23 Apr 2021
 01:12:44 +0000
Subject: Re: [PATCH 3/7 v7] KVM: nSVM: No need to set bits 11:0 in MSRPM and
 IOPM bitmaps
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
References: <20210412215611.110095-1-krish.sadhukhan@oracle.com>
 <20210412215611.110095-4-krish.sadhukhan@oracle.com>
 <YH8y86iPBdTwMT18@google.com>
 <058d78b9-eddd-95d9-e519-528ad7f2e40a@oracle.com>
 <cb1bb583-b8ac-ab3a-2bc3-dd3b416ee0e7@oracle.com>
 <YIG6B+LBsRWcpftK@google.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <a9f74546-6ab7-88fc-83d1-382b380f6264@oracle.com>
Date:   Thu, 22 Apr 2021 18:12:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <YIG6B+LBsRWcpftK@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SN7PR04CA0154.namprd04.prod.outlook.com
 (2603:10b6:806:125::9) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SN7PR04CA0154.namprd04.prod.outlook.com (2603:10b6:806:125::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 01:12:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c8b077b-5f51-40e4-fe17-08d905f4e5f0
X-MS-TrafficTypeDiagnostic: SN6PR10MB2560:
X-Microsoft-Antispam-PRVS: <SN6PR10MB25601520AD9B78DA8085457581459@SN6PR10MB2560.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yyIebktkNQo+oLW3HSlDGLj0CEJk29vbkxRwqDvk4bBHaUEeXoKQvdORYarGvvXHMX1lys0Egu1/r9CfABefu00dRaT6f7ojSvgMS3aDvjFhveOPxRD7DizwdJn+PSonOb22oBVQ62vx5VTxwlBbxz+guI9zJiW8/YAwMtb+v1Zje7BDUvfSJzE+2foBO33jkNigLR0ryKjNDh0qGZqO8TdXswEiMygOvHt+6IqpZJLZpbrRAUNMsRmW4a2WP4vI18qx9z1qkYHHPZUuT+hT3tUopOFiLQ7vzkzQ2T+CBT2iyIegKCJqPu11UXczKKv0PfwF0hNFK1CN1mwXPVHThacNCI791b49ek60hgmOPcupUHY6kJNeJCbeX2ETiCbiGVlV0zVrrZpK5x38ZOkeBWW5mAJgcNBpZ9P5Lx90feNIR05f0C2B4SfPHhmsnQpsAEt04/TCQY8KG5JYYx1dL2zxrGojVFQy8wzfaY6yq2wL7zAwMYwga1u1BRfdT+hpmjlYuhOeJvL3qiIcCSW4azuO5wR73Tpl1FX03/o6yv/QqfBFn6S6/yzsLO0d7QuTumPe99ihEGUXlTurHrq89DurLq6guflNZzKR4RZ4h3i9m7j6vt0YTUm96iRBsMEjCs2lnhuEFo/SykqKVIDvWiWcwVq9f7xsLiDYT9oS6iEBdFpHgduJwtwKMAXeY2kP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(396003)(346002)(39860400002)(2616005)(8676002)(316002)(5660300002)(2906002)(66556008)(66476007)(6506007)(86362001)(38100700002)(8936002)(6916009)(31686004)(478600001)(6512007)(6486002)(66946007)(4326008)(36756003)(16526019)(53546011)(186003)(44832011)(83380400001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MkwvNHJkb3Bvc2U1bVVXejlRd2x0MXhmMS9VdVpzSVJNaHJ0bjdOTnhvQzJX?=
 =?utf-8?B?dFRzcEhRZEtmSDd4ejlibDNLRnFoTTgyWm9uSUw3bDlwNFRsdnlMT3hUM2M4?=
 =?utf-8?B?cTJNb0FDaXkyaHFZK2R6ZFc2cGJoeTBNWkhGY0YrTCtsODIxenBNR28zZHd0?=
 =?utf-8?B?QThDQm9GdXUxb2Mxb2F2KzIyZHcvcHVPUG5pT2kvbjRnTHhrbFN6cUlnd2xm?=
 =?utf-8?B?aFdHb3RuOHA5S3paVFJDMW9KSmFOL04zOVAreTVpeno3OHVBZDR6NUlOMDV5?=
 =?utf-8?B?VHZjcW5xUzdFaGlhTkQxRFNic0w5THVHcVpLZXI3WkM2K2VsOThYVlZpc2Vj?=
 =?utf-8?B?YWtiU25IelJkdEQyZzdiN3RmZnNIa0l5QXBHa1BuQVF1VVkrZ0ZPR29qcEhu?=
 =?utf-8?B?L3Z3emszMEdobDBCc2dmVXZEWjhEQjZ5b04xbE9pdVhTamFUMEFTNWx3UWlk?=
 =?utf-8?B?UHhCZzhaTTl3NUtpUlR2REFlMXhWWFNDZy84ZzJLZ09udHoxRDY1eHg1aXBC?=
 =?utf-8?B?Z1BMYSt3R05MMTB2RWtOOFdGWk1QZ1NDbW10Qy9PekdSOHlRRWRsZGtCcTdy?=
 =?utf-8?B?Vks5TmRsYWNJUHJyemd3WWx3S0xPUzl4cm05aGtLNEZKTjMzM0Y2QUNqZzY3?=
 =?utf-8?B?Z2w5YmtGT0RqNzhtTm41ZlpYZnNINmNicGFkMytLT3pacjRwN0ZKMzVZbmZ2?=
 =?utf-8?B?QWtnL2JNelR2Yitpem1UT0RRckJtdy9NcGZOTHRVZ2VZc3hCS3pmZ1h4N3Fw?=
 =?utf-8?B?Q2dJSFZtcCt1N0pINFAyVTFVbzhzL0RKOXhVUjR4eEwyeE9OSWkvelBZTUt4?=
 =?utf-8?B?VmFVdU9HVmZla0V1N05RYmtIU3YrY1dFTEF1a2VtUy9lK04xaUdzNVpxQjBL?=
 =?utf-8?B?cUNCRTNwVkJHdlF0SVRSZW41cHBFb280RVMzdUZQSG52dnpHbFVnaE5oZEtk?=
 =?utf-8?B?TG9wMEFMZVhVQnZ4bmN2SE05VTJGOGxUMUFSMnNkcmt5VFNTbU5SbHhhaDBM?=
 =?utf-8?B?UXNvbHJQQ0d0V3p4eExJZ2RqM2hoTko4YjlWODJMZXo2a0JoRThwdG01Y3pE?=
 =?utf-8?B?dzNqVnpFTkhJWFQwclk5Y05naU4yMWFHOFNPblJnS1ZOTi83R0lscTdqTUJO?=
 =?utf-8?B?QWRjUHlidVlMWlZ2Q01ZY1RreDZHVWZsNkw2T3J6SGVwREVxYzg0bS9QeS9B?=
 =?utf-8?B?dmhnblVqZFFtVlh3QkVMMzRsRUJNL0EreGlXN0lsUm1TNnp2VCttbXB5NEgv?=
 =?utf-8?B?YjZqVGQ5NVdJblBkUlg4VmlFY0x0a00zbTdBVkhUcFJXMlpyWktHZURqekNX?=
 =?utf-8?B?Z3FSMTYrTjUxMkVCR2tsTk9wTEhyQnV5di9aOE9ZUUE0dnZjWDlWOWpFNVNv?=
 =?utf-8?B?ZzNQNnYzNzdtU2pFRHBwQmNOK2MxOVJMckVDb2s0UkpUS2R1ZzhZQnNCQkVX?=
 =?utf-8?B?WmQ5QjhVeXdrcm1mZWhTcWR2Nm1HSklXaXVlK1B3UzBKajdpNjZQOWlHQ0wr?=
 =?utf-8?B?R0hScS9RTG9MOG1YVEhLbTRrazByMWVydlBOczN3REFudFRXeHcyeGdZaW1I?=
 =?utf-8?B?VitXSks1NXpRSldSY0EzeGFGRHBqTm5WaVBVZzBpZzdabm01RWdMZHpIOFo3?=
 =?utf-8?B?VTVaMFdnandrcFVZSDVmZnd0RHRtbzkxM0ZXSklCUUtiQ2NQQjlmc1Z6dzRQ?=
 =?utf-8?B?RnF6bEdOSzlJVTl0d2c2RS9VM0dVQ3d0OEh1NTJ5WXBydUxpZU42U3B0cTZ6?=
 =?utf-8?B?QzYvWENWUjVLekJRM0ZiQXpXTXh5dHp4b3VLZm10NXY5cjJQelpZSjBvTWtX?=
 =?utf-8?B?RGRvaHhJUkJFYWNGTjZIQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c8b077b-5f51-40e4-fe17-08d905f4e5f0
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 01:12:43.9649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TZzcePraoJkVp/5sNsOiSPTIK0NSoPVkfATrPgpBdh506967586zGHD8p12XZOmU//BVInwaRmUj+Glh8qzHfBpSicbMpJRB88F89rh1syU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2560
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104230003
X-Proofpoint-ORIG-GUID: jGBepJbZZiX8w-Kp2fK0DQTgHXLydY6K
X-Proofpoint-GUID: jGBepJbZZiX8w-Kp2fK0DQTgHXLydY6K
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230004
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/22/21 11:01 AM, Sean Christopherson wrote:
> On Thu, Apr 22, 2021, Krish Sadhukhan wrote:
>> On 4/22/21 10:50 AM, Krish Sadhukhan wrote:
>>> On 4/20/21 1:00 PM, Sean Christopherson wrote:
>>>> On Mon, Apr 12, 2021, Krish Sadhukhan wrote:
>>>>> According to APM vol 2, hardware ignores the low 12 bits in
>>>>> MSRPM and IOPM
>>>>> bitmaps. Therefore setting/unssetting these bits has no effect
>>>>> as far as
>>>>> VMRUN is concerned. Also, setting/unsetting these bits prevents
>>>>> tests from
>>>>> verifying hardware behavior.
>>>>>
>>>>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>>>>> ---
>>>>>    arch/x86/kvm/svm/nested.c | 2 --
>>>>>    1 file changed, 2 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
>>>>> index ae53ae46ebca..fd42c8b7f99a 100644
>>>>> --- a/arch/x86/kvm/svm/nested.c
>>>>> +++ b/arch/x86/kvm/svm/nested.c
>>>>> @@ -287,8 +287,6 @@ static void
>>>>> nested_load_control_from_vmcb12(struct vcpu_svm *svm,
>>>>>          /* Copy it here because nested_svm_check_controls will
>>>>> check it.  */
>>>>>        svm->nested.ctl.asid           = control->asid;
>>>>> -    svm->nested.ctl.msrpm_base_pa &= ~0x0fffULL;
>>>>> -    svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
>>>> This will break nested_svm_vmrun_msrpm() if L1 passes an unaligned
>>>> address.
>>>> The shortlog is also wrong, KVM isn't setting bits, it's clearing bits.
>>>>
>>>> I also don't think svm->nested.ctl.msrpm_base_pa makes its way to
>>>> hardware; IIUC,
>>>> it's a copy of vmcs12->control.msrpm_base_pa.  The bitmap that gets
>>>> loaded into
>>>> the "real" VMCB is vmcb02->control.msrpm_base_pa.
>>>
>>> Not sure if there's a problem with my patch as such, but upon inspecting
>>> the code, I see something missing:
>>>
>>>      In nested_load_control_from_vmcb12(), we are not really loading
>>> msrpm_base_pa from vmcb12 even     though the name of the function
>>> suggests so.
>>>
>>>      Then nested_vmcb_check_controls() checks msrpm_base_pa from
>>> 'nested.ctl' which doesn't have         the copy from vmcb12.
>>>
>>>      Then nested_vmcb02_prepare_control() prepares the vmcb02 copy of
>>> msrpm_base_pa from vmcb01.ptr->control.msrpm_base_pa.
>>>
>>>      Then nested_svm_vmrun_msrpm() uses msrpm_base_pa from 'nested.ctl'.
>>>
>>>
>>> Aren't we actually using msrpm_base_pa from vmcb01 instead of vmcb02 ?
>>
>> Sorry, I meant to say,  "from vmcb01 instead of vmcb12"
> The bitmap that's shoved into hardware comes from vmcb02, the bitmap that KVM
> reads to merge into _that_ bitmap comes from vmcb12.
>
> static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
> {
> 	/*
> 	 * This function merges the msr permission bitmaps of kvm and the
> 	 * nested vmcb. It is optimized in that it only merges the parts where
> 	 * the kvm msr permission bitmap may contain zero bits
> 	 */
> 	int i;
>
> 	if (!(vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_MSR_PROT)))
> 		return true;
>
> 	for (i = 0; i < MSRPM_OFFSETS; i++) {
> 		u32 value, p;
> 		u64 offset;
>
> 		if (msrpm_offsets[i] == 0xffffffff)
> 			break;
>
> 		p      = msrpm_offsets[i];
> 		offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
>
> 		if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value, 4)) <- This reads vmcb12
> 			return false;
>
> 		svm->nested.msrpm[p] = svm->msrpm[p] | value; <- Merge vmcb12's bitmap to KVM's bitmap for L2
> 	}
>
> 	svm->vmcb->control.msrpm_base_pa = __sme_set(__pa(svm->nested.msrpm)); <- This is vmcb02
>
> 	return true;
> }

Sorry, I somehow missed the call to copy_vmcb_control_area() in 
nested_load_control_from_vmcb12() where we are actually getting the 
msrpm_base_pa from vmcb12. Thanks for the explanation.

Getting back to your concern that this patch breaks 
nested_svm_vmrun_msrpm().  If L1 passes a valid address in which some 
bits in 11:0 are set, the hardware is anyway going to ignore those bits, 
irrespective of whether we clear them (before my patch) or pass them as 
is (my patch) and therefore what L1 thinks as a valid address will 
effectively be an invalid address to the hardware. The only difference 
my patch makes is it enables tests to verify hardware behavior. Am 
missing something ?

