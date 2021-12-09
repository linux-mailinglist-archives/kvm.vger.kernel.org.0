Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4BA46F288
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 18:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242320AbhLIR5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 12:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242078AbhLIR5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 12:57:35 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B93C061746;
        Thu,  9 Dec 2021 09:54:01 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id v1so22373495edx.2;
        Thu, 09 Dec 2021 09:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=678cBG8EpN1DFb6ImU5fHcIRCMdxEdhtC0zcEhiXW58=;
        b=SzS0ZMjLigt/ibaWZ6/885pEc5GjOOXMLdbHopS8Lrl3W8cMn+SUuH20F+d2a7mkpV
         oL5LpUC8qG5V7OVJx4174vV/PMaAfCrx0AAbSjb43enfNyNo19XII3mWad0NuR2E0Lep
         P9xJIj08fh7fxWQO6T5GX2RblMR7mnf9hfJYlDLuONf7iXK+Bl0kCTEY8C6Mc5pLd7lP
         y4QtSDF4M+ejUV88a4nEnoZvm6kKpLvsXOHPHf59JvDLjSLStMbkcYxjJYIncAFvlVp3
         18qU6n6GcH/vBxIHodjlv/wEMfdjiZuwG3J9c6RNz5O9CW6aW+MSUklRSdUm1T4Wwfk1
         ZJ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=678cBG8EpN1DFb6ImU5fHcIRCMdxEdhtC0zcEhiXW58=;
        b=hqgf3B52aJtc5F9rOIXCSRCAjKteAZ/+5xecqCLxNuxKncYhOD4bJr2ieBE2Vawgdc
         XZPx71fmr8fzmeijyY+RucFvivd6yFMpdYon52QHqIR/VRN1BliHV/1xh5p/6rPMSTOg
         k3q9HG9LFAgnXoVpgBbykoWO/QUXKdeC0tzT/H9W1XyGGIANMA3rfopsvGGFSAjw7qRC
         l4M3udhsYoqoq0NV9liUBRRP46WVetHgb7JSkllidAu6MfVbGt1L2QFzMT6678SYqCBT
         m2JpTW4eXzOGfBmOLbwUf7OdHyQTArj9BHCKVmSzzeHrpeTi+wJpVjj5Yv1ZltiIiRad
         pU1g==
X-Gm-Message-State: AOAM530pi/6MuMm8U4Vop8h232VZNcy/KXTG6q8CchWH6+p3p4Wq4gXf
        /uAAam9ZKivquKFaGSgH2ZQ=
X-Google-Smtp-Source: ABdhPJyTicmcpmQQw3X+d6VI7pBqQk98I+HArJUyGF2phD3z3EYzIbRDV49wDGoQAsU1hqa0mCMzGw==
X-Received: by 2002:a17:906:dc8d:: with SMTP id cs13mr17835571ejc.323.1639072322838;
        Thu, 09 Dec 2021 09:52:02 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id hu7sm238454ejc.62.2021.12.09.09.52.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 09:52:02 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <0d540a6b-8838-bdf5-ddad-f3b9576ca9f2@redhat.com>
Date:   Thu, 9 Dec 2021 18:52:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] KVM: x86: Always set kvm_run->if_flag
Content-Language: en-US
To:     Marc Orr <marcorr@google.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>
Cc:     seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207043100.3357474-1-marcorr@google.com>
 <c8889028-9c4e-cade-31b6-ea92a32e4f66@amd.com>
 <CAA03e5E7-ns7w9B9Tu7pSWzCo0Nh7Ba5jwQXcn_XYPf_reRq9Q@mail.gmail.com>
 <5e69c0ca-389c-3ace-7559-edd901a0ab3c@amd.com>
 <CAA03e5Gf=ZsAKhuLCEtYCCf0UuNXSHRXQHgmjOj3MKtbiSMbqQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAA03e5Gf=ZsAKhuLCEtYCCf0UuNXSHRXQHgmjOj3MKtbiSMbqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/21 18:28, Marc Orr wrote:
>>>>> +static bool svm_get_if_flag(struct kvm_vcpu *vcpu)
>>>>> +{
>>>>> +     struct vmcb *vmcb = to_svm(vcpu)->vmcb;
>>>>> +
>>>>> +     return !!(vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK);
>>>> I'm not sure if this is always valid to use for non SEV-ES guests. Maybe
>>>> the better thing would be:
>>>>
>>>>           return sev_es_guest(vcpu->kvm) ? vmcb->control.int_state & SVM_GUEST_INTERRUPT_MASK
>>>>                                          : kvm_get_rflags(vcpu) & X86_EFLAGS_IF;
>>>>
>>>> (Since this function returns a bool, I don't think you need the !!)
>>>
>>> I had the same reservations when writing the patch. (Why fix what's
>>> not broken.) The reason I wrote the patch this way is based on what I
>>> read in APM vol2: Appendix B Layout of VMCB: "GUEST_INTERRUPT_MASK -
>>> Value of the RFLAGS.IF bit for the guest."
>>
>> I just verified with the hardware team that this flag is indeed only set
>> for a guest with protected state (SEV-ES / SEV-SNP). An update to the APM
>> will be made.
>
> Got it now. Then the change you suggested is a must! Thanks, Tom.

Besides, the bit wouldn't have existed on old (pre-SEV-ES) processors.

Paolo
