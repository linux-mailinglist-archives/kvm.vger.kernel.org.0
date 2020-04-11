Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE08B1A4CE8
	for <lists+kvm@lfdr.de>; Sat, 11 Apr 2020 02:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgDKA0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 20:26:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44334 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgDKA0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 20:26:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03B0Id75044794;
        Sat, 11 Apr 2020 00:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=P2dJot6RTN60BQgKEvHeKmpJ5KSDhuPSPD/967w/gt0=;
 b=HdWFM6fxfXRhGyr4oOmZtUe8hwkvvx9mEX2jJVwJ57gcLHwkMiAlZdIAgygnxq6lUBvo
 CLu0dBg7bN5AlBYA9pNlp/dk7Hzc0eVgI182b0WGt27gc6Lbl7isCVsp7O10pYMMFWeZ
 7ZrfJHCSVQ+UjVR+x3crPOy6HVL01Jn7s0m8o9FIZYB5AwsjSCHibMfcMQm1UBXVMW1B
 JjWnmQ7OSm9nIUWA9hS/B5A8NpcUsTmRd3lgjSCeXnfIKuRcG/ZsC2C6qtVLc4AL2PVP
 pExiJ5yqS8lgR6i0OVGnc6BmIOaGW/xWfYmGkpAftt1jGOr33rAfS3j1S/ceCoQu+NiY Bg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3091m3rcq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Apr 2020 00:26:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03B0HwrQ071327;
        Sat, 11 Apr 2020 00:24:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 3091mejmvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Apr 2020 00:24:20 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03B0OIac029780;
        Sat, 11 Apr 2020 00:24:19 GMT
Received: from localhost.localdomain (/10.159.146.114)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Apr 2020 17:24:18 -0700
Subject: Re: [PATCH kvm-unit-tests] svm: add a test for exception injection
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20200409094303.949992-1-pbonzini@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <801ca90e-dc5f-37ab-2138-8cbd0950b4f7@oracle.com>
Date:   Fri, 10 Apr 2020 17:24:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200409094303.949992-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9587 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004110000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9587 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004110000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 4/9/20 2:43 AM, Paolo Bonzini wrote:
> Cover VMRUN's testing whether EVENTINJ.TYPE = 3 (exception) has been specified with
> a vector that does not correspond to an exception.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   x86/svm.h       |  7 +++++
>   x86/svm_tests.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 77 insertions(+)
>
> diff --git a/x86/svm.h b/x86/svm.h
> index 645deb7..bb5c552 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -324,6 +324,13 @@ struct __attribute__ ((__packed__)) vmcb {
>   
>   #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
>   
> +#define SVM_EVENT_INJ_HWINT	(0 << 8)
> +#define SVM_EVENT_INJ_NMI	(2 << 8)
> +#define SVM_EVENT_INJ_EXC	(3 << 8)
> +#define SVM_EVENT_INJ_SWINT	(4 << 8)
> +#define SVM_EVENT_INJ_ERRCODE	(1 << 11)
> +#define SVM_EVENT_INJ_VALID	(1 << 31)


I see existing #defines in svm.h:

     #define SVM_EVTINJ_TYPE_INTR (0 << SVM_EVTINJ_TYPE_SHIFT)
     #define SVM_EVTINJ_TYPE_NMI (2 << SVM_EVTINJ_TYPE_SHIFT)
     #define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
     #define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
     #define SVM_EVTINJ_VALID (1 << 31)
     #define SVM_EVTINJ_VALID_ERR (1 << 11)

> +
>   #define MSR_BITMAP_SIZE 8192
>   
>   struct svm_test {
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 16b9dfd..6292e68 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -1340,6 +1340,73 @@ static bool interrupt_check(struct svm_test *test)
>       return get_test_stage(test) == 5;
>   }
>   
> +static volatile int count_exc = 0;
> +
> +static void my_isr(struct ex_regs *r)
> +{
> +        count_exc++;
> +}
> +
> +static void exc_inject_prepare(struct svm_test *test)
> +{
> +	handle_exception(DE_VECTOR, my_isr);
> +	handle_exception(NMI_VECTOR, my_isr);
> +}
> +
> +
> +static void exc_inject_test(struct svm_test *test)
> +{
> +    asm volatile ("vmmcall\n\tvmmcall\n\t");
> +}
> +
> +static bool exc_inject_finished(struct svm_test *test)
> +{
> +    vmcb->save.rip += 3;
> +
> +    switch (get_test_stage(test)) {
> +    case 0:
> +        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
> +                   vmcb->control.exit_code);
> +            return true;
> +        }
> +        vmcb->control.event_inj = NMI_VECTOR | SVM_EVENT_INJ_EXC | SVM_EVENT_INJ_VALID;
> +        break;
> +
> +    case 1:
> +        if (vmcb->control.exit_code != SVM_EXIT_ERR) {
> +            report(false, "VMEXIT not due to error. Exit reason 0x%x",
> +                   vmcb->control.exit_code);
> +            return true;
> +        }
> +        report(count_exc == 0, "exception with vector 2 not injected");
> +        vmcb->control.event_inj = DE_VECTOR | SVM_EVENT_INJ_EXC | SVM_EVENT_INJ_VALID;
> +	break;
> +
> +    case 2:
> +        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
> +            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
> +                   vmcb->control.exit_code);
> +            return true;
> +        }
> +        report(count_exc == 1, "divide overflow exception injected");
> +	report(!(vmcb->control.event_inj & SVM_EVENT_INJ_VALID), "eventinj.VALID cleared");
> +        break;
> +
> +    default:
> +        return true;
> +    }
> +
> +    inc_test_stage(test);
> +
> +    return get_test_stage(test) == 3;
> +}
> +
> +static bool exc_inject_check(struct svm_test *test)
> +{
> +    return count_exc == 1 && get_test_stage(test) == 3;
> +}
> +
>   #define TEST(name) { #name, .v2 = name }
>   
>   /*
> @@ -1446,6 +1513,9 @@ struct svm_test svm_tests[] = {
>       { "interrupt", default_supported, interrupt_prepare,
>         default_prepare_gif_clear, interrupt_test,
>         interrupt_finished, interrupt_check },
> +    { "exc_inject", default_supported, exc_inject_prepare,
> +      default_prepare_gif_clear, exc_inject_test,
> +      exc_inject_finished, exc_inject_check },
>       TEST(svm_guest_state_test),
>       { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
>   };
