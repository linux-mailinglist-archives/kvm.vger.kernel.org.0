Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4681AAB19
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 17:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371190AbgDOO4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 10:56:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55881 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S371091AbgDOO4b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 10:56:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586962588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HIaiPNRpjXdJUwZ/Wes1WnHqY3RuQjDIrcgY5yBGayg=;
        b=K1X4+qlGgwbVQt7viMnFwE10JdqZ71hChhVPH9cK9T3GGFGfNMKeJoYt/WTPtdg25Py/3t
        te7wPuEfWPcnPr9hnER5CT6etPENxuTiugxgTso7VgXnIsO7ZrrwlC0781VVTR/UduW1ZI
        G6fNFvM0Xn45MQEmEGfH1FtEzqwak8E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-98b5AAejPK-F_0cy_TbDpw-1; Wed, 15 Apr 2020 10:56:24 -0400
X-MC-Unique: 98b5AAejPK-F_0cy_TbDpw-1
Received: by mail-wr1-f72.google.com with SMTP id d17so24740wrr.17
        for <kvm@vger.kernel.org>; Wed, 15 Apr 2020 07:56:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HIaiPNRpjXdJUwZ/Wes1WnHqY3RuQjDIrcgY5yBGayg=;
        b=B/Ag6U1+edIry5XSIbY+PYkEokTNNtHPb8XSDI6rt4vqlledxFPUF+3x6D9jVE83jj
         /ERoCaYd1BBWBYkmh+OMR8KZmsNTiBQMdnXwBIrh6cm/234seypszzy0fkCUSf0vIMAz
         5TVJsnwC693Rt2dvhb7uoBl2dTO3MRbxsAFNW622HXiDF5Ta45sStsz5QDyG8YvjBoPq
         8NuSaCcsaeMwXM3uhDDen77a6rMtiQ4mY4e6Q8tOLBdMZYsgxDK5IPqrLxwMYBjoj0H5
         ZWW5YmqRhN2Lvm+R8XDWGYuyC8rYPYZymE/pG6SM8E3FUEnXWXjdaiLMjuM53HYurJbW
         AjAw==
X-Gm-Message-State: AGi0PuYm4l7IebClXtjC0kgf2eaKrSK9/z1STj3JBZxydfRXr1YYWy3l
        3XrXJifG+l/HrrDUMliGbikMBRX3otQY3zxppWPQZMrj3m0PtmUj0BeOK/z9lK595QjCy/HFyJT
        sZqkvNCN/nbLT
X-Received: by 2002:a1c:48c:: with SMTP id 134mr4761606wme.47.1586962583467;
        Wed, 15 Apr 2020 07:56:23 -0700 (PDT)
X-Google-Smtp-Source: APiQypL1t3gwkdztYXfM5YsgHJcd2dkz/LSK8oZ3Cn5Xg1piA2o3ntblkhJcixch9oMoL9nrh7UFig==
X-Received: by 2002:a1c:48c:: with SMTP id 134mr4761580wme.47.1586962583140;
        Wed, 15 Apr 2020 07:56:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9066:4f2:9fbd:f90e? ([2001:b07:6468:f312:9066:4f2:9fbd:f90e])
        by smtp.gmail.com with ESMTPSA id d133sm24709709wmc.27.2020.04.15.07.56.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2020 07:56:22 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] svm: add a test for exception injection
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <20200409094303.949992-1-pbonzini@redhat.com>
 <801ca90e-dc5f-37ab-2138-8cbd0950b4f7@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8dde8698-839b-ed69-8448-b40ac02c8a72@redhat.com>
Date:   Wed, 15 Apr 2020 16:56:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <801ca90e-dc5f-37ab-2138-8cbd0950b4f7@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/04/20 02:24, Krish Sadhukhan wrote:
> 
> On 4/9/20 2:43 AM, Paolo Bonzini wrote:
>> Cover VMRUN's testing whether EVENTINJ.TYPE = 3 (exception) has been
>> specified with
>> a vector that does not correspond to an exception.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   x86/svm.h       |  7 +++++
>>   x86/svm_tests.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 77 insertions(+)
>>
>> diff --git a/x86/svm.h b/x86/svm.h
>> index 645deb7..bb5c552 100644
>> --- a/x86/svm.h
>> +++ b/x86/svm.h
>> @@ -324,6 +324,13 @@ struct __attribute__ ((__packed__)) vmcb {
>>     #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
>>   +#define SVM_EVENT_INJ_HWINT    (0 << 8)
>> +#define SVM_EVENT_INJ_NMI    (2 << 8)
>> +#define SVM_EVENT_INJ_EXC    (3 << 8)
>> +#define SVM_EVENT_INJ_SWINT    (4 << 8)
>> +#define SVM_EVENT_INJ_ERRCODE    (1 << 11)
>> +#define SVM_EVENT_INJ_VALID    (1 << 31)
> 
> 
> I see existing #defines in svm.h:
> 
>     #define SVM_EVTINJ_TYPE_INTR (0 << SVM_EVTINJ_TYPE_SHIFT)
>     #define SVM_EVTINJ_TYPE_NMI (2 << SVM_EVTINJ_TYPE_SHIFT)
>     #define SVM_EVTINJ_TYPE_EXEPT (3 << SVM_EVTINJ_TYPE_SHIFT)
>     #define SVM_EVTINJ_TYPE_SOFT (4 << SVM_EVTINJ_TYPE_SHIFT)
>     #define SVM_EVTINJ_VALID (1 << 31)
>     #define SVM_EVTINJ_VALID_ERR (1 << 11)

Indeed.  I queued the patch with these defines instead.

Paolo

>> +
>>   #define MSR_BITMAP_SIZE 8192
>>     struct svm_test {
>> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
>> index 16b9dfd..6292e68 100644
>> --- a/x86/svm_tests.c
>> +++ b/x86/svm_tests.c
>> @@ -1340,6 +1340,73 @@ static bool interrupt_check(struct svm_test *test)
>>       return get_test_stage(test) == 5;
>>   }
>>   +static volatile int count_exc = 0;
>> +
>> +static void my_isr(struct ex_regs *r)
>> +{
>> +        count_exc++;
>> +}
>> +
>> +static void exc_inject_prepare(struct svm_test *test)
>> +{
>> +    handle_exception(DE_VECTOR, my_isr);
>> +    handle_exception(NMI_VECTOR, my_isr);
>> +}
>> +
>> +
>> +static void exc_inject_test(struct svm_test *test)
>> +{
>> +    asm volatile ("vmmcall\n\tvmmcall\n\t");
>> +}
>> +
>> +static bool exc_inject_finished(struct svm_test *test)
>> +{
>> +    vmcb->save.rip += 3;
>> +
>> +    switch (get_test_stage(test)) {
>> +    case 0:
>> +        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>> +            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
>> +                   vmcb->control.exit_code);
>> +            return true;
>> +        }
>> +        vmcb->control.event_inj = NMI_VECTOR | SVM_EVENT_INJ_EXC |
>> SVM_EVENT_INJ_VALID;
>> +        break;
>> +
>> +    case 1:
>> +        if (vmcb->control.exit_code != SVM_EXIT_ERR) {
>> +            report(false, "VMEXIT not due to error. Exit reason 0x%x",
>> +                   vmcb->control.exit_code);
>> +            return true;
>> +        }
>> +        report(count_exc == 0, "exception with vector 2 not injected");
>> +        vmcb->control.event_inj = DE_VECTOR | SVM_EVENT_INJ_EXC |
>> SVM_EVENT_INJ_VALID;
>> +    break;
>> +
>> +    case 2:
>> +        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
>> +            report(false, "VMEXIT not due to vmmcall. Exit reason 0x%x",
>> +                   vmcb->control.exit_code);
>> +            return true;
>> +        }
>> +        report(count_exc == 1, "divide overflow exception injected");
>> +    report(!(vmcb->control.event_inj & SVM_EVENT_INJ_VALID),
>> "eventinj.VALID cleared");
>> +        break;
>> +
>> +    default:
>> +        return true;
>> +    }
>> +
>> +    inc_test_stage(test);
>> +
>> +    return get_test_stage(test) == 3;
>> +}
>> +
>> +static bool exc_inject_check(struct svm_test *test)
>> +{
>> +    return count_exc == 1 && get_test_stage(test) == 3;
>> +}
>> +
>>   #define TEST(name) { #name, .v2 = name }
>>     /*
>> @@ -1446,6 +1513,9 @@ struct svm_test svm_tests[] = {
>>       { "interrupt", default_supported, interrupt_prepare,
>>         default_prepare_gif_clear, interrupt_test,
>>         interrupt_finished, interrupt_check },
>> +    { "exc_inject", default_supported, exc_inject_prepare,
>> +      default_prepare_gif_clear, exc_inject_test,
>> +      exc_inject_finished, exc_inject_check },
>>       TEST(svm_guest_state_test),
>>       { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
>>   };
> 

