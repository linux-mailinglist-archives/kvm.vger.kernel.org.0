Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEDA0176120
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 18:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgCBRfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 12:35:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27161 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726997AbgCBRfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 12:35:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583170512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jRmkfkREZRr5cSADufe64Sk2NlZOhAyH+TEmdSkGMs4=;
        b=I+3EUEEyh5E3jg/kJBWq5BAFXaVGG81L+Pks6IAGXOCBV2tEorB68s44SuWazLMH2qjvEH
        suudfyLU8pVpIufnDY5H7pvMZ5NRewyXyWkFog8sCtyrBPsFcQk/wYLWCBfWHhFcTM/EOq
        QcTUuX/BZRj/5592OyP12+Sf2tlR2pw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-MOLMtU4WNuGLh_151OXuFQ-1; Mon, 02 Mar 2020 12:35:11 -0500
X-MC-Unique: MOLMtU4WNuGLh_151OXuFQ-1
Received: by mail-wm1-f69.google.com with SMTP id q20so28059wmg.1
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 09:35:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jRmkfkREZRr5cSADufe64Sk2NlZOhAyH+TEmdSkGMs4=;
        b=FWs2M0/QMrtnx063gySVS8RS6B8tzKdYaJThBB3qZIAQHjLun2jDcPp7fdds7nFYMW
         fbqWeCMjXtHxaijjUayZUtbZy1LG+CHw1GJOt6AJWRGFSB4LGvEii+1nfPcgZaU0z+Ll
         gpILo744Fg6akalPvuntHwCDdehHlWJRqdHWQifz8lX8S3r+47WZYszSHw6YB+fZRhAC
         fuQer5Ib0LMJ5mF08sdOUIACToszRWumCjY55uMa6vOFvJYkGriO5/6K53m6SIuF1Hef
         OX73KB/mpdYfx1+zFpBb6Ykr5/yvbnR49MQ1lsf93HXLPLbWPri2jQGiUPU1bJ+NG1LI
         eHAw==
X-Gm-Message-State: ANhLgQ1CKKoLHXldQtn98JOH6QwL9S1/VC5X2B+D2ndjlHlCtlB1lCzP
        3u7w2R6nafyqVeUqeSPSQzeU8yeiM9oI0/ZUQ3N9pgdW5nC3AZ9SPY4RSy0p3PSDxfkvo7IX5Qv
        lsUCfETG7GEGC
X-Received: by 2002:adf:ce8c:: with SMTP id r12mr655762wrn.189.1583170509932;
        Mon, 02 Mar 2020 09:35:09 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvE/Gfc4OBjrE3k80qcugUZJGPEoO2ilSKecg2qLF0RGKSFz1U2t1MitRu0ZX3CVDdslmGZSw==
X-Received: by 2002:adf:ce8c:: with SMTP id r12mr655744wrn.189.1583170509671;
        Mon, 02 Mar 2020 09:35:09 -0800 (PST)
Received: from [192.168.178.40] ([151.30.85.6])
        by smtp.gmail.com with ESMTPSA id a9sm164979wmm.15.2020.03.02.09.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 09:35:09 -0800 (PST)
Subject: Re: [PATCH v2 2/2] KVM: SVM: Enable AVIC by default
To:     Wei Huang <wei.huang2@amd.com>, Wei Huang <whuang2@amd.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200228085905.22495-1-oupton@google.com>
 <20200228085905.22495-2-oupton@google.com>
 <CALMp9eRUQFDvZtGBGs6oKX=-j+Zz6SV8zTpLPukiRjmA=nO0wg@mail.gmail.com>
 <6487d313-dedb-1210-1c7a-160db2c816ad@amd.com>
 <af610180-d7fc-5a62-029f-0e27980c4037@redhat.com>
 <cf351926-e136-1974-fda9-27427ed18a53@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8df94378-e8c8-98fe-06ee-0e20dc9279fb@redhat.com>
Date:   Mon, 2 Mar 2020 18:35:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <cf351926-e136-1974-fda9-27427ed18a53@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/03/20 18:11, Wei Huang wrote:
>>> I personally don't suggest enable AVIC by default. There are cases of
>>> slow AVIC doorbell delivery, due to delivery path and contention under a
>>> large number of guest cores.
>> To clarify, this is a hardware issue, right?
>>
>> Note that in practice this patch series wouldn't change much, because
>> x2apic is enabled by default by userspace (it has better performance
>> than memory-mapped APIC) and patch 1 in turn inhibits APICv if the guest
>> has the X2APIC CPUID bit set.
> QEMU will work fine with this option ON due to x2APIC, just like what
> you said. If you feel other emulators using KVM will behave similarly, I
> can revoke my concern.

No, it's okay for now to leave it disabled.  It would be nice if this
information would be more easily available than by you lurking on the
mailing list. :)

Paolo

