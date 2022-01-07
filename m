Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7714879BF
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 16:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348103AbiAGPdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 10:33:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56903 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239665AbiAGPdC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 10:33:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641569582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H/H2mDX2q8rcyZbVzf/HillL5w4kGErId3g4pPO9m2w=;
        b=SQ5+YgDybCFwN4/0wWUrDibVd4qqbOjXwvbvW0aV3BC7Myt61fG5Py2lQS3fP3ybdYNe8J
        6W2JMfMQzsiEpVGHDPdNEfxiORtr6z63BD2AnNJjFsQrFqaMAUNuFZe0/vZ8nqniI3vi5f
        RiBgf8Pwu1H8MXklAkDV7fQJAzc6QbM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-NsmrGdS8NfmZ-Jhz-OwWVQ-1; Fri, 07 Jan 2022 10:33:00 -0500
X-MC-Unique: NsmrGdS8NfmZ-Jhz-OwWVQ-1
Received: by mail-ed1-f72.google.com with SMTP id g2-20020a056402424200b003f8ee03207eso4965204edb.7
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 07:33:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H/H2mDX2q8rcyZbVzf/HillL5w4kGErId3g4pPO9m2w=;
        b=T8KymgPAGyznc49W+iT6BiwwdPtkz1YN27JvddGq9nnqSk+ZOJpnNU+5AWxWeresWE
         ZQCvoQv6WY4KFHcMffjIIYGzujey9JFdTuzR53Qx8P6bn9qx3KFRzRoNkvUFRGzuSA/g
         1KS0Eu7LHc7sq/XV4lEUWnMhMTBPeyncxrT8U9ZpOs8lZi5Hh9EdTPWidQusCdZ9SBvi
         cZxPD+QUozSgnq/Uk6/wmh6Tx24c6j7K7lV/mm28GsQ27AYl4wXVyIN8oVCETcV+Z2ZO
         zUvXKikz5P7udpt+uQ87/V8iU/Oemsakx+BcZDXovsBCgM53KwJ18pJSF7a3FwfG7MYU
         Y6kg==
X-Gm-Message-State: AOAM533GCJFdgbUm/maiu3YoEEjYh+sYua8T8r0pwmplnYNoa7meSI19
        Vvm/+KNerdn1K8gLklRC1Vcgv6dJ//XhLWm7cXNBjbxzhaEOMpuBHHyikiAkPg5XFoDeDkTc40C
        0qyOT1/QpVbv6
X-Received: by 2002:a17:906:f02:: with SMTP id z2mr40837783eji.499.1641569569287;
        Fri, 07 Jan 2022 07:32:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxXPZxhuv8SeNED/De3domyV+TcjynfaIg7g6FcPzOCYEs+sBMHCOkLDFMiOd6U29lCQOssLg==
X-Received: by 2002:a17:906:f02:: with SMTP id z2mr40837765eji.499.1641569569065;
        Fri, 07 Jan 2022 07:32:49 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id gs9sm1490609ejc.30.2022.01.07.07.32.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 07:32:48 -0800 (PST)
Message-ID: <6a11edec-c29a-95df-393e-363e1af46257@redhat.com>
Date:   Fri, 7 Jan 2022 16:32:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 3/5] KVM: SVM: fix race between interrupt delivery and
 AVIC inhibition
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
 <20211213104634.199141-4-mlevitsk@redhat.com> <YdTPvdY6ysjXMpAU@google.com>
 <628ac6d9b16c6b3a2573f717df0d2417df7caddb.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <628ac6d9b16c6b3a2573f717df0d2417df7caddb.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/5/22 12:03, Maxim Levitsky wrote:
>>> -	if (!vcpu->arch.apicv_active)
>>> -		return -1;
>>> -
>>> +	/*
>>> +	 * Below, we have to handle anyway the case of AVIC being disabled
>>> +	 * in the middle of this function, and there is hardly any overhead
>>> +	 * if AVIC is disabled.  So, we do not bother returning -1 and handle
>>> +	 * the kick ourselves for disabled APICv.
>> Hmm, my preference would be to keep the "return -1" even though apicv_active must
>> be rechecked.  That would help highlight that returning "failure" after this point
>> is not an option as it would result in kvm_lapic_set_irr() being called twice.
> I don't mind either - this will fix the tracepoint I recently added to report the
> number of interrupts that were delivered by AVIC/APICv - with this patch,
> all of them count as such.

The reasoning here is that, unlike VMX, we have to react anyway to 
vcpu->arch.apicv_active becoming false halfway through the function.

Removing the early return means that there's one less case of load 
(mis)reordering that the reader has to check.  So I really would prefer 
to remove it.

Agreed with the other feedback.

Paolo

