Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4903431018A
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 01:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbhBEAVo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 19:21:44 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:37258 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhBEAVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 19:21:39 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11509xZU185085;
        Fri, 5 Feb 2021 00:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KFmM1wh8NeIqw8nGs73qCZzXPJEs8vtubtlwevbb8nQ=;
 b=gagGQBOzl44c+G9jguvWoXDIYXgAOmRaRQU7IG7bNgSb5A5DrFUSNH2Sc+JjufGwEMKi
 3CjagwywC8JqWo9jiIhzAg1h5FvIiuUJEZvzGeN6G7cdi+FKEsPk8c3RfXFXBXkzJD4C
 m+CqX0mdUkGt9Leqfe6kTJpWHGYGqLDjm311a0hpYLJAgruKoZap16EloyX0KmqLICge
 nlQOfGnnR48UKZbbgOXzQuLBRk6uibWiWnzdmQsqC28hjqN0H4FI5Tdpbiiu09gNVULi
 9q+S/m+U9NJvPudlxX7meK44txUjJDnJ93a3h1HKbCKx7Geo60MjzfGU7YjiV2BIk6BR +w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36cvyb801t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 00:20:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1150AhQB144750;
        Fri, 5 Feb 2021 00:20:52 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 36dhd24r79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 00:20:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4Y2uO8ArWlpM4ErdZr4wFKPa2IeHsK4HaxYzUWjtFBrHaTlShoLiZoWFlfCt+g6/Zeh1e8xxGv/S9WcFwhQIyGIFErvQasigIUGnQ3F98xeA0clid7CxK8bBMafOl0FO37+lAVfj5rlOUES9C7nDUzMq4MSp2+DRSpO8UB2Xw/92pZPgN0OPnhERo34TWIm7/3481JFL5qFP4SG+h1261cxcPSko3wplnntlrzRX7VtDbIkznRLmMPe9q+k6noklJCRilN7zeuv7sIW5cZRAnQ3P4g4sOqTQkmq9Fj4YXE5AH1cMjYxph4Ve4QICc5XhOQTb1ysRKrCy4UdQCSPWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFmM1wh8NeIqw8nGs73qCZzXPJEs8vtubtlwevbb8nQ=;
 b=PWZZvGFTXb3cOFAiTRCNfBLMpUE78pQljerqxGK24ZIjWdzNCjyq0NrPly57OuhoCtBGK3TuY14k36hS3/6zSHItaQFCuebmxaDv06CyC5DosrNNUDtBdX20ZUFLQLmwzsErMMqKLg90mT9ACI+h33KSn9MFdUdDRLkHsgwVXFrYdVULIPMgL+cTf3UvZS8RcZVfTaojTIa0bZvr9YW6GAiVK/Dc+/PAahfD/OJ5CWYYVs0Pn56uDpZph6TZiw50WwsrS2dqBDP++OLOT1LmK1VTMeBRl4MuOUlDUZykS//i+hwnr14rXjn7AvrZQGEMGxvbj7fN094HkiNUfrTN+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFmM1wh8NeIqw8nGs73qCZzXPJEs8vtubtlwevbb8nQ=;
 b=UDbjzE6ruKU3R0Pz0t8tW+/boiLpJXJYzo+7LLSaNb1HNg6yifV36unLiPr6ua+M3Xqj9JKW/k9AimVR8xOjKbW8HL1QaGi8Ki5PBf2nEy+B+79AVN0AN69qhMG5ZB8DoWvAJ6hspz8Cje7k4HwaOfuwrb+zDSUkCzvPj1DVy5E=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2702.namprd10.prod.outlook.com (2603:10b6:805:48::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Fri, 5 Feb
 2021 00:20:50 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 00:20:49 +0000
Subject: Re: [PATCH 2/3] nVMX: Add helper functions to set/unset host
 RFLAGS.TF on the VMRUN instruction
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210203012842.101447-1-krish.sadhukhan@oracle.com>
 <20210203012842.101447-3-krish.sadhukhan@oracle.com>
 <7599c931-e5a1-1a49-afe9-763b73175866@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <4022ce07-c1cd-0124-6874-6c40b1a9a492@oracle.com>
Date:   Thu, 4 Feb 2021 16:20:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <7599c931-e5a1-1a49-afe9-763b73175866@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: CH0PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:610:76::27) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by CH0PR04CA0022.namprd04.prod.outlook.com (2603:10b6:610:76::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Fri, 5 Feb 2021 00:20:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2218ab02-7f86-4a25-b77c-08d8c96be403
X-MS-TrafficTypeDiagnostic: SN6PR10MB2702:
X-Microsoft-Antispam-PRVS: <SN6PR10MB27028806897550B44B82153981B29@SN6PR10MB2702.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BrhURw1Qk04w4SUldFFqJIGYivylysvWEIZ3CfpIGuf4Cc/BweTBg0vDkLHjsfcyxoKr9jLjnASiu+agpUI5fwDhrmlvuS5ywOQe61cpcpG/5fX445RJMX0+ZX1y+NBSn2EapGqZMBfZGXAqvV3te53Hpm/Pdd0ZMgcQrW+EyvKs7GdJMc47XTl2nUIDmdUIXbRuzVOa+Gfa3YQHLVB36FuZi4xSE3Nhypj9/BI2TRxkIdKzAl/32Vk/ihQXdTWYweWfFvwhMthB+0qhY3PBnfVy+iTQxI/quB5iOR36812YDnwr+MbC2pVcdpDk00oK/zmUFRSsb760twGDqHCvpu9SVIkxeEh0UGEBQUd0Hf4kEteXl8Hd0JLO3ZOPgEPKtPBi1Bo8T6pirZ74x0y96HHf1EjvWLNViGjWisuYt/QC+Jtgj2scVZM4gpa3X2utal9ETH6qvHefXefw/XWAldkbiN1EEQrGIdA5LOBxyy2/cFGwVsnzG/z/wj8ldz54SaKDlAMXorgKDFa2D1vPh88h/psBrUKETeUId0W1Q7BnGPFHjBHW3HCfHSuHzSqZuM94e5g9LB/90vQqcsUA/XeXfQCCvGwsyxtc2DmGFMg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(346002)(136003)(376002)(44832011)(2616005)(31696002)(83380400001)(36756003)(8936002)(186003)(16526019)(6512007)(86362001)(2906002)(5660300002)(53546011)(66946007)(316002)(8676002)(478600001)(66476007)(4326008)(66556008)(6506007)(31686004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dHVEc3pVdVFUL1A1QTE1VXpJSWpoOXpWaW9zditzZjNsTmUyYVhlL2J4bHhl?=
 =?utf-8?B?N1R0SW5Tc2NnVTdYc2JmZ3lEcGJXaWtxeGVCb2x5NmE5WVFUVHVtOFY3c2ZD?=
 =?utf-8?B?MUdCSlZ1SUp6bTNVVnFOUXhFeXpyTlIvM0hyMHgwUk1ENzh0VGd2Y0g3M21Y?=
 =?utf-8?B?aGtRa2VQYnFaUVk5eWdRcGZqUTFtNUZEUVIvQWNDdEtCdVhRcXR2SXRNcFBt?=
 =?utf-8?B?a2J4aFhrMlRKWGdLVUV1QzZwdCtIN2diWkFDaVJrQjJoOXBhZlVEajFlaSt4?=
 =?utf-8?B?cUNwbDB2aWszVWhBTjM5U3QzY0tRemVOYWdZS3lrYjB3bTJIQUdOZVJHeXhT?=
 =?utf-8?B?TFVseWUvQmxGYnZCa0pocTE4NmhaWk9PVHV3QlBvKzkvbVZ4SGtacjk4TmJS?=
 =?utf-8?B?a0JySHJHdVdkZmNsalgrd3Vsem80NnMvbi9nMlBCWjV5THlTT1pGZkNIVUtz?=
 =?utf-8?B?ZVhTYlI4UFdCMkI2akoxRjRMYStpS1lHNWp0dG9HNnhIT3IwblZKMEhrdDUw?=
 =?utf-8?B?RFc2NWpPSnUwSWIvam9RSTlkcFdYR0NFWnJTeWZaYnY1UC90TjFZdHFPM2tB?=
 =?utf-8?B?YmxSaElPT0swa1hFUk5lVmxTTjYva0ExRHpQVUh5bGY1TFo2S0E3a2RHWWky?=
 =?utf-8?B?MlB2cllucTlQcnduSkhmdXZLRnA2WTgzSGdyRnE1QVNFbkErVkJoNkdHZEd0?=
 =?utf-8?B?TWRwb1N3WTdFUDluNXozWFdDUUYwQk9UVW5pNXladHlwTTFZMy9OM2hacm1F?=
 =?utf-8?B?OWhvN3JwR2RmR0RyMHQ0Sys0SGFLYTdTYmoySGhOc2drSHpELzhlQmk4dWla?=
 =?utf-8?B?cDhoOVNHS0FRbFJmWG1udSt2U2tBTSs1Q25TbFF1Q1JmaFJocUJnWE84TDdW?=
 =?utf-8?B?V2o2cTRsUGR2REFXajVxd0R2YVpNVG8yMm5QR1BXdVN3TGxhaDhGcUN4MDRm?=
 =?utf-8?B?MFV2dU1MUFQ4Vmd1c2RSNjVJNGJULzBiVGNWZ2lKY3JuNGRSU2RRZ3RzTDZl?=
 =?utf-8?B?R0xmdnJoOGtzMU5wdGk4Y1RXbG5xcW40SGNIU1gvVGtTazMvVjhjN2MxaUla?=
 =?utf-8?B?RlFISHJwc0dvVVIwRnJLRFhCZU5ubXIwWDRPZndYN2Rodm93TW9oVDhISjJo?=
 =?utf-8?B?NmxOZU4vRkxlVTRSbEh0YkUvZFlNc0sxeUZQemwxaVZBRXQrZkRMamQyeXlZ?=
 =?utf-8?B?SHdQQUIyL2NrOVpTc1NWQkgxbWhQQU1zN09uK1ZYNDdrRlhRbGNPQ1lVY0lr?=
 =?utf-8?B?RWxTRS8vV2plU1QrSEoxWEV0VmxHUzFieE5iNEhZQUN0N3R6L3llbTVtR3FJ?=
 =?utf-8?B?Qzc1cTV4bnJLcno2aWU1bk5ScWhKMlM4eGZqTGx6TWNPMEV0ZHFlSWhQUnlo?=
 =?utf-8?B?REx5bFJXMHc4clRVZWtrNXlWd0dYVGdMRStTNCtySlloNFNlUGlnYUdiOHVQ?=
 =?utf-8?B?QWRmM1hxc0hQVVFnMSszYTk5R2t1N1V3d1VOeDNYdlpTZTQraWJzR2RTdFYz?=
 =?utf-8?Q?NGPXIk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2218ab02-7f86-4a25-b77c-08d8c96be403
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 00:20:49.8556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: REhZTJrLnxCAaCds3D38oK6grlH+CWsB/57ToluBg2jcTLCfBkUV8WCsN+fL90dtWOhL3LgxcO7nSe6OiUBZ4OMtKGXm+MVB2YuSDNPEHQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2702
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102040148
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102040148
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/3/21 12:15 AM, Paolo Bonzini wrote:
> On 03/02/21 02:28, Krish Sadhukhan wrote:
>> Add helper functions to set host RFLAGS.TF immediately before the VMRUN
>> instruction. These will be used  by the next patch to test Single 
>> Stepping
>> on the VMRUN instruction from the host's perspective.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>
> I think you can use prepare_gif_clear to set RFLAGS.TF and the 
> exception handler can:
>
> 1) look for VMRUN at the interrupted EIP.  If it is there store the 
> VMRUN address and set a flag.
>
> 2) on the next #DB (flag set), store the EIP and clear the flag
>
> The finished callback then checks that the EIP was stored and that the 
> two EIPs are 3 bytes apart (the length of a VMRUN).


Thanks for the suggestion. It worked fine and I have sent out v2.

However, I couldn't use the two RIPs (VMRUN and post-VMRUN) to check the 
result because the post-VMRUN RIP was more than the length of the VMRUN 
instruction i.e., when #DB handler got executed following guest exit, 
the RIP had moved forward a few instructions from VMRUN. So, I have used 
the same mechanism I used in v1, to check the results.

>
> Paolo
>
>> ---
>>   x86/svm.c       | 24 ++++++++++++++++++++++--
>>   x86/svm.h       |  3 +++
>>   x86/svm_tests.c |  1 -
>>   3 files changed, 25 insertions(+), 3 deletions(-)
>>
>> diff --git a/x86/svm.c b/x86/svm.c
>> index a1808c7..547f62a 100644
>> --- a/x86/svm.c
>> +++ b/x86/svm.c
>> @@ -179,6 +179,17 @@ void vmcb_ident(struct vmcb *vmcb)
>>       }
>>   }
>>   +static bool ss_bp_on_vmrun = false;
>> +void set_ss_bp_on_vmrun(void)
>> +{
>> +    ss_bp_on_vmrun = true;
>> +}
>> +
>> +void unset_ss_bp_on_vmrun(void)
>> +{
>> +    ss_bp_on_vmrun = false;
>> +}
>> +
>>   struct regs regs;
>>     struct regs get_regs(void)
>> @@ -215,6 +226,12 @@ struct svm_test *v2_test;
>>                   "mov regs, %%r15\n\t"           \
>>                   "mov %%r15, 0x1f8(%%rax)\n\t"   \
>>                   LOAD_GPR_C                      \
>> +                "cmpb $0, %[ss_bp]\n\t"         \
>> +                "je 1f\n\t"                     \
>> +                "pushf; pop %%r8\n\t"           \
>> +                "or $0x100, %%r8\n\t"           \
>> +                "push %%r8; popf\n\t"           \
>> +                "1: "                           \
>>                   "vmrun %%rax\n\t"               \
>>                   SAVE_GPR_C                      \
>>                   "mov 0x170(%%rax), %%r15\n\t"   \
>> @@ -234,7 +251,8 @@ int svm_vmrun(void)
>>       asm volatile (
>>           ASM_VMRUN_CMD
>>           :
>> -        : "a" (virt_to_phys(vmcb))
>> +        : "a" (virt_to_phys(vmcb)),
>> +        [ss_bp]"m"(ss_bp_on_vmrun)
>>           : "memory", "r15");
>>         return (vmcb->control.exit_code);
>> @@ -253,6 +271,7 @@ static void test_run(struct svm_test *test)
>>       do {
>>           struct svm_test *the_test = test;
>>           u64 the_vmcb = vmcb_phys;
>> +
>>           asm volatile (
>>               "clgi;\n\t" // semi-colon needed for LLVM compatibility
>>               "sti \n\t"
>> @@ -266,7 +285,8 @@ static void test_run(struct svm_test *test)
>>               "=b" (the_vmcb)             // callee save register!
>>               : [test] "0" (the_test),
>>               [vmcb_phys] "1"(the_vmcb),
>> -            [PREPARE_GIF_CLEAR] "i" (offsetof(struct svm_test, 
>> prepare_gif_clear))
>> +            [PREPARE_GIF_CLEAR] "i" (offsetof(struct svm_test, 
>> prepare_gif_clear)),
>> +            [ss_bp]"m"(ss_bp_on_vmrun)
>>               : "rax", "rcx", "rdx", "rsi",
>>               "r8", "r9", "r10", "r11" , "r12", "r13", "r14", "r15",
>>               "memory");
>> diff --git a/x86/svm.h b/x86/svm.h
>> index a0863b8..d521972 100644
>> --- a/x86/svm.h
>> +++ b/x86/svm.h
>> @@ -391,6 +391,9 @@ void vmcb_ident(struct vmcb *vmcb);
>>   struct regs get_regs(void);
>>   void vmmcall(void);
>>   int svm_vmrun(void);
>> +int svm_vmrun1(void);
>> +void set_ss_bp_on_vmrun(void);
>> +void unset_ss_bp_on_vmrun(void);
>>   void test_set_guest(test_guest_func func);
>>     extern struct vmcb *vmcb;
>> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
>> index 29a0b59..7bf3624 100644
>> --- a/x86/svm_tests.c
>> +++ b/x86/svm_tests.c
>> @@ -2046,7 +2046,6 @@ static void basic_guest_main(struct svm_test 
>> *test)
>>   {
>>   }
>>   -
>>   #define SVM_TEST_REG_RESERVED_BITS(start, end, inc, str_name, reg, 
>> val,    \
>>                      resv_mask)                \
>>   {                                    \
>>
>
