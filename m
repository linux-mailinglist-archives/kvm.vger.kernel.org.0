Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EED332321F
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 21:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhBWU3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 15:29:41 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50058 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbhBWU3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 15:29:18 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKQgci052360;
        Tue, 23 Feb 2021 20:28:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=J6S0Dib+Q4Dr2e/O/FI9SBszNPaGZXxnhXbPJ3Es5js=;
 b=s+FuL7teZTjM3aVMrMg0ZnxIb1ek68JX70pr5eOzXxKDoHJWueyU16WEYARfunWOLNGy
 GbYUT9M/GLfHtoqXjSNRkT67YpMK5zT/WUhV7a191Z/qGKBo0xU0nt/EveinlBG7yL7A
 EAx3tRqnGh9w9TZdW9dL7+TS7oAXttwRREwJ1XfhWlm8GVKSJYZmC3QIhhpp1FKxa/uZ
 IAnT3dIBTH2/q0IBI6D1A2JrAeQcGil4p11kxFrSbEqJPcO5xS/hKBRugG1c0s9cwdnb
 qyk0UbMmSJQoUUyvnnQVgxedkvFtyy6GOdyQdcs6o6DRoCeqdwLti89kQmSJHcmTlIQH Jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 36ugq3fm3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:28:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NKQWp8181347;
        Tue, 23 Feb 2021 20:28:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3030.oracle.com with ESMTP id 36ucbxyxww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 20:28:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HL1spAHVVkbqEzmXRWUx0KNA1eK9ROrPZKld6zogmvc8J0hsxzhr8XfZM+9O81QhFCy6HUMSwX7hutIheX3ZB8Og7iaZZGZj7ngU8bxrkV2TMwthLsMitcjT5ogsKOekvQaJCXlAQbH2n4JLeKoQJpeGyGtdY72VWlQprIKEq0jjmXeYTyHdHaD0YzhYcrrZcQrbsAl79evTrAJKdYatym6LFHYqmkVxyN+ihmLi4jL+k91wonCNNfkfddlIqDkrZQe6U6HFMHH4dB9hrCgwyZGG9oo3FvSWRhiIziLPokujqrYtf9A084p3C5ndHruYzRFeE+avkHrWUQHUGXTYdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6S0Dib+Q4Dr2e/O/FI9SBszNPaGZXxnhXbPJ3Es5js=;
 b=VQR/ENlCOM6mE0G+/ED7WA7ZWmNNb9xTmRIeOz5B+Darn97pAp6QJ1quc7CVIhMl5pts7x+KWI2gWhbxyGlSIKTmIxSlje66ajB9SvP+LmiAnPs7fhsEQ9s3Xvj0xQC/9SnScd42BOd5zo4YI3wSW7+CDMZRF45Ms+cF/F/txLgGCTI9vOcTrMwZ8z46/JGlJ/WB3jFGc0yYlntpNu9zNEEG9iXwLndHVrHdwKyBDu+ztC35oX1iCvP9KO8j+l2/1iyQbtClTb2LiK41uu3n67x/ZFQ2tP7AoIIOR/on61l9gjJ+6gWLQrBa6rTnlfuSSJUBSt3gtZex7+hyPpBt2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6S0Dib+Q4Dr2e/O/FI9SBszNPaGZXxnhXbPJ3Es5js=;
 b=bI9GhhorDEuNtsBreJuaWyV6KcySnXqohGqaS9eqHU0SKeAEc8vW9KxZu/C6Ux0k978KbAou4mJJXkGbAr7VSEAT0FmNtb/eGeDmlKKkRKZGsMOiqd2rV17icVgA782ZkI2k7yW7iWCSGZwCA8WkuAbIA4mQOwYt2qTJChpSu1I=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB3021.namprd10.prod.outlook.com (2603:10b6:805:cc::19)
 by SN6PR10MB2702.namprd10.prod.outlook.com (2603:10b6:805:48::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Tue, 23 Feb
 2021 20:28:28 +0000
Received: from SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7]) by SN6PR10MB3021.namprd10.prod.outlook.com
 ([fe80::1871:3741:cc17:bcf7%7]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 20:28:28 +0000
Subject: Re: [PATCH 1/1 v2] nSVM: Test effect of host RFLAGS.TF on VMRUN
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com, seanjc@google.com
References: <20210204232951.104755-1-krish.sadhukhan@oracle.com>
 <20210204232951.104755-2-krish.sadhukhan@oracle.com>
 <a3cfdf3a-9f6f-76e5-3cb8-2aaf117e798d@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <cedacbe4-6cb1-ac77-55eb-d28d4c818655@oracle.com>
Date:   Tue, 23 Feb 2021 12:28:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <a3cfdf3a-9f6f-76e5-3cb8-2aaf117e798d@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SN7PR04CA0120.namprd04.prod.outlook.com
 (2603:10b6:806:122::35) To SN6PR10MB3021.namprd10.prod.outlook.com
 (2603:10b6:805:cc::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2606:b400:8301:1010::16aa) by SN7PR04CA0120.namprd04.prod.outlook.com (2603:10b6:806:122::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32 via Frontend Transport; Tue, 23 Feb 2021 20:28:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41bef66c-020e-4fce-f2f7-08d8d8399458
X-MS-TrafficTypeDiagnostic: SN6PR10MB2702:
X-Microsoft-Antispam-PRVS: <SN6PR10MB27021162F709A1B2F1EE2EA381809@SN6PR10MB2702.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tk4hHNZcYABjcsLsAkWYxeOMdZ0bQgVGeJc2vkQmoyd0YsGbg3vQ3KE1Sldf9fKOxOvwd28/gWHf7lD/xWz2DnAdoqscdbRCt8qRkDqMP1JcqDoiA9jtN8PLUtIro8f5gj2yGXRd9ztX7yp7VBNRk9Tw4600dWmzKsOO49G/rlweAQzTnO2yDiwXnOcfavFkj7asEgdnwGd41H5qRWzCeL/8Nf/jBcQLxBZpqIyr7KnWPrGEsFplpyX9O3qjaDl2z69WgKSobofdwjkbnfzbq4LCK6nyPKmi1dZuEM5pYqrymc70IwNkHdxDnSL44gifaQxNOnFB/yD0ZsuAKaCbePznqTqyT8fdYozGyXvEokLQDRWTi5fEYJO1bRwFZzn1d1hXoPgniTOcESw+4kfIGEXUh65kXrUeRjRX5z8FoXZXpmXX+9OwEGFJEtqMSu5JjgMI40ZrkdImUjL+Z2ukpmXDwRQK1J89RPSEVxlOQACG4TAgxkPRQ7bG6lLxR0iWgkCx7ga0+oiJFclBVh9HJuhBmRbb0paQjrDGqSDHDLmoFyjw9WSz5fJrqEFy5o+GqqdNdX1iuNgAePg302r3Y2/cgsCJv3RF8ctRS4jSTxk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3021.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(31686004)(6506007)(6486002)(5660300002)(53546011)(86362001)(6512007)(66946007)(4326008)(8676002)(186003)(44832011)(36756003)(31696002)(316002)(2906002)(83380400001)(2616005)(8936002)(478600001)(16526019)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UTdKN1NtYTV2elJ4VmFuL2V4ZmpVcjlWQ1hNYnFxMk9nellqWWpkNkFFNkFQ?=
 =?utf-8?B?THFVNlhaK0NyQkduKzRhbWNFNmJ6SlhqZ0QxVFFwMFBaM2xzWU55UkdMdW5Z?=
 =?utf-8?B?aTZhSTVFQjJXcUNFQ085bXFxUjYwSVdqbDJjMnVVNmpGMHlORFhWaGxReXhW?=
 =?utf-8?B?bmJibktoRGVFb1BvK0xxc1FiOFpKWHpweVJtdmhGcTlmUkx3ZnEyVGJCMmdq?=
 =?utf-8?B?U243U3lpU09EN3RQaUdaV3ZYNTBPa2xkbzNoL0dHbU9EWGIrRnhNdnJ0dG4y?=
 =?utf-8?B?SFNFUWNtZTFwbXowWmdjSUcvQ1IwVE9MNDJRSHJlYmJFMFRKUkNwMUFpU0RY?=
 =?utf-8?B?UjhJMWxOMVZRNWMwaWtCT1ltMFhhZTlNenJjTVA5bTJFZnAxU2ltMzUyQlFO?=
 =?utf-8?B?UFNqNXJ4dFdLdFRLQ2hleUY1Nkd0WCtjWkEvRkRISHdtcERWNGVhOVJ4T3FC?=
 =?utf-8?B?ck5payswMU5ycW5VRDQ1NHJQT2pJS1pjTTBTVEdaRzdYemdpTXZweVhMeHZW?=
 =?utf-8?B?YzZWSk5veHNOMnhnWFgxN3duN2ZTUHp4Qm81UnY5b0h2cTJEeWtjRytWdEF4?=
 =?utf-8?B?K1RHcm1zZG1NcXFBZHVpYjNhY2Z3RFZvZnViWXZvbU84TGJsVEYzMDlOMEx3?=
 =?utf-8?B?MkFOK1ZGazJ3bkZjbmZhUHh6dXE0N0ZORnRrZDJGMGZZUitreG5TeUFSSVI0?=
 =?utf-8?B?WjdUbFE3RzVoMXdodDl3ajVjNWthK3lZNWlFUG1HdURvY0FJWTE0cDZUT1dl?=
 =?utf-8?B?MmpJUit0NlJVUDNqNGRTR0pIOWRPbVFMQUdkeFhvcjdMY0JWQkQ3WWFvZ2FU?=
 =?utf-8?B?N1pMdWI2SXNBWU0ycWJadVZSTUF1ekdkdG9oZktVM2ZvYXpZNnpyM3hKZWww?=
 =?utf-8?B?RjViWFowcVFhK3RkRnpSZ1NGMXY3and3MDhOcU9MOGljVTB3NWpXRlgxblNz?=
 =?utf-8?B?aXNRLzRUbUFlZTY4d0J6dC9UN2VpLzZhOGt3a3VLVnY2c0EyVVMzL0dNUUxP?=
 =?utf-8?B?aHRMbmZ5SUJFSm1DeUxJajVDNDM4aWMrbUpGZTZYWmZUTFBLbEFVN3lDMlUx?=
 =?utf-8?B?Z2FRaU41RS9pS09TRzh6TTh2TUVWZjcwcXBNeFduL1p3ZFI2NWcwd1daaDNz?=
 =?utf-8?B?eFcxajlRQklYTVFpWWJsZGJMS3UwWHdkTy9ZeWFWYUR6RzlLR3VZWU1UOUFK?=
 =?utf-8?B?TXlka0dGa1NUc1ZlMlZUcU9walJRUHQ2VERMS2hXdmRkQXcyVlF2bjd3ZHNi?=
 =?utf-8?B?ZlFFYmNxM0g2aDhpc1R6Y1pxYjlIRXV1MDNZc2FwNGlhcXY5RWJCQWROaDRO?=
 =?utf-8?B?dnZDLy9mQWR4Z0NlR2tvTTZtNDJVMDBoM0V1ZXFEUURmMVpVSWNsWnBUMURE?=
 =?utf-8?B?NU9nK3ZUWkRab3dyK1VnSDg2d1hKa3M4U2JnY1RSL3dhUFNEbGdJU1l6OTl3?=
 =?utf-8?B?YnRXMjdQUk10eEpiV3NPZU1QZy9tbElEOUdVZHowaXJsK2p1b3FvbmhBT1NR?=
 =?utf-8?B?WlE4cWN4YWQra2xJcjhFTy9hWmRaYkppQVBYWFZzUnB2ckxPOG9wNVNFbERz?=
 =?utf-8?B?eWwyTTBucXRVUHg4aUhxK1J0aUJzVXprVXJRUFMyTjBZdFpxYmV2ZjlMdnlV?=
 =?utf-8?B?UlAvTWNTVFljNEdjMk14Q3pIMnJLc1YxUjRrL2VYVVU3czkwV0lmbFFzcUN2?=
 =?utf-8?B?cFB3N1VQV3I1SzZFek1uOEVlZXI0TktxY3Foc2VZZ3RXNERNbllIWEp4cGlW?=
 =?utf-8?B?K1NGdlJlNzBCTjhKdk12QmVUaVBQVFR1V2w1aElwT2s5V0JYZy90V3h0U0pU?=
 =?utf-8?B?dVB4c0Y1Y29GVzNaRlRVUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41bef66c-020e-4fce-f2f7-08d8d8399458
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3021.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 20:28:28.8057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zcy7WPCJt1ms3B1S8qTBVhc2zvuDM1O5Oj/dKxTfzKOnQNj6jUPGCrwnl/ozDoQfrUHZq0Rir/9SU3jXZ9HZCCgJ5z1D1acskPQBuXdV4r4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2702
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230172
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9904 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230172
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/5/21 12:14 AM, Paolo Bonzini wrote:
> On 05/02/21 00:29, Krish Sadhukhan wrote:
>>
>> +static void host_rflags_prepare(struct svm_test *test)
>> +{
>> +    default_prepare(test);
>> +    handle_exception(DB_VECTOR, host_rflags_db_handler);
>> +    set_test_stage(test, 0);
>> +    /*
>> +     * We trigger a #UD in order to find out the RIP of VMRUN 
>> instruction
>> +     */
>> +    wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
>> +    handle_exception(UD_VECTOR, host_rflags_ud_handler);
>> +}
>> +
>
> I think you'd get the RIP of VMLOAD, not VMRUN.
>
> Maybe something like:
>
> diff --git a/x86/svm.c b/x86/svm.c
> index a1808c7..88d8452 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -208,14 +208,14 @@ struct regs get_regs(void)
>
>  struct svm_test *v2_test;
>
> -#define ASM_VMRUN_CMD                           \
> +#define ASM_PRE_VMRUN                           \
>                  "vmload %%rax\n\t"              \
>                  "mov regs+0x80, %%r15\n\t"      \
>                  "mov %%r15, 0x170(%%rax)\n\t"   \
>                  "mov regs, %%r15\n\t"           \
>                  "mov %%r15, 0x1f8(%%rax)\n\t"   \
> -                LOAD_GPR_C                      \
> -                "vmrun %%rax\n\t"               \
> +                LOAD_GPR_C
> +#define ASM_POST_VMRUN                          \
>                  SAVE_GPR_C                      \
>                  "mov 0x170(%%rax), %%r15\n\t"   \
>                  "mov %%r15, regs+0x80\n\t"      \
> @@ -232,7 +232,9 @@ int svm_vmrun(void)
>      regs.rdi = (ulong)v2_test;
>
>      asm volatile (
> -        ASM_VMRUN_CMD
> +        ASM_PRE_VMRUN
> +                "vmrun %%rax\n\t"
> +        ASM_POST_VMRUN
>          :
>          : "a" (virt_to_phys(vmcb))
>          : "memory", "r15");
> @@ -240,6 +242,7 @@ int svm_vmrun(void)
>      return (vmcb->control.exit_code);
>  }
>
> +extern unsigned char vmrun_rip;
>  static void test_run(struct svm_test *test)
>  {
>      u64 vmcb_phys = virt_to_phys(vmcb);
> @@ -258,7 +261,9 @@ static void test_run(struct svm_test *test)
>              "sti \n\t"
>              "call *%c[PREPARE_GIF_CLEAR](%[test]) \n \t"
>              "mov %[vmcb_phys], %%rax \n\t"
> -            ASM_VMRUN_CMD
> +                ASM_PRE_VMRUN
> +                        "vmrun_rip: vmrun %%rax\n\t"
> +                ASM_POST_VMRUN
>              "cli \n\t"
>              "stgi"
>              : // inputs clobbered by the guest:
>
> (untested)
>
> Paolo
>

Thanks for the suggestion. I have implemented it in v3 that I have sent out.

The reason why my test (v2) had passed, was because virtual 
VMLOAD/VMSAVE is enabled by default and no #VMEXIT happens due to 
intercepts being disabled (via init_vmcb()). So my #UD handler didn't 
get invoked on VMLOAD but got invoked on VMRUN.

This brings out an interesting point. When intercept for VMLOAD/VMSAVE 
is disabled, there is no effect of unsetting EFER.SVME on VMLOAD/VMLOAD, 
even thought APM vol 2 says it should generate a #UD. I couldn't find 
any text in the APM that describes the effect of unsetting EFER.SVME on 
the virtual VMLOAD/VMSAVE. Is this the expected behavior of the SVM 
hardware or is this a bug in KVM and KVM should handle this ?

I plan to add some more tests based on the correct behavior of virtual 
VMLOAD/VMSAVE.

