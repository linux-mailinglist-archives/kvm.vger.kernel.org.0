Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A6D2772D0
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 15:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgIXNnI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 09:43:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727749AbgIXNnI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 09:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600954987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Beq3tcVHKt0C0LLvHS7U4jOl6Zjv3+i2AR35+0ULbkA=;
        b=eBlZe0DKNqSqin6ad7rfP/ojrExhhCUuREONsEOPJ/NZ1TJS6Xq+cCIenTOxddZlTzxplh
        M7QVfwRMCXiFTdBVyqCaId7pDAU19kRQgY0d4bYmUNfP9ETb+lFsikEo6Ez2TVspZ+wJ2+
        2kqxv0psf5xC1rNS58dofvSPRkDOtpM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-bLaRTvL-O1ybKUyK26edqA-1; Thu, 24 Sep 2020 09:43:05 -0400
X-MC-Unique: bLaRTvL-O1ybKUyK26edqA-1
Received: by mail-wr1-f71.google.com with SMTP id l9so1235445wrq.20
        for <kvm@vger.kernel.org>; Thu, 24 Sep 2020 06:43:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Beq3tcVHKt0C0LLvHS7U4jOl6Zjv3+i2AR35+0ULbkA=;
        b=TwBtgmVegqkUncTSovsuRnbG4baV0ZbKkdoGAmpM7zZaibx0czf4A1SKhRC/MsOtXX
         QfkxHWi8O3AH9qzekeBzuMMBTdBj12l4Agq4W6M8FwnBrg80WN8gIR4PP5zW6jmoRF7c
         Jgy/UCzr1nd6/Gymnf3T1o8dRuc3JNQKrgOx84FkYE94JJeiTbYLHRhIXfs1fOuAeUsk
         0CA3go6gtUsgTf7nHq62ttey4o1Anh1IY3jCDQYl/MaEB0y/etb05+GuDqAcqQgsRjLT
         iQ4scUwwJK/QNbMOL1105LGTGUqubr4s9gZpat7cwyBAQWncOz8vTOdaaJsT4uC1R32u
         z0hw==
X-Gm-Message-State: AOAM532N0fVtyiJnhRjYbvl0lCvDVq7mCUwZz2CmBqZ2GGri7f6EtN5Z
        tYp1z5tiwLQ4yQoKf8kG88YICH5wPCIM62Urbz5RoYhgfbYIieh+WLltWGIMWUmt74jOYH1Z8DG
        Et+dla1tNJnlD
X-Received: by 2002:adf:8544:: with SMTP id 62mr5208667wrh.262.1600954984446;
        Thu, 24 Sep 2020 06:43:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxA0L1uyLRE025BKVDqUW+CTr4Tao6ZBAklnXuIJXKdmo4+OV+RHcRfyxXgq7/diAKKZLA4aQ==
X-Received: by 2002:adf:8544:: with SMTP id 62mr5208647wrh.262.1600954984189;
        Thu, 24 Sep 2020 06:43:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d80e:a78:c27b:93ed? ([2001:b07:6468:f312:d80e:a78:c27b:93ed])
        by smtp.gmail.com with ESMTPSA id m18sm3636734wrx.58.2020.09.24.06.43.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 06:43:02 -0700 (PDT)
Subject: Re: [PATCH v3 0/5] KVM_{GET,SET}_TSC_OFFSET ioctls
To:     Oliver Upton <oupton@google.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>
References: <20200722032629.3687068-1-oupton@google.com>
 <CAOQ_QsgeN4DCghH6ibb68C+P0ETr77s2s7Us+uxF6E6LFx62tw@mail.gmail.com>
 <CAOQ_QshUE_OQmAuWd6SzdfXvn7Y6SVukcC1669Re0TRGCoeEgg@mail.gmail.com>
 <f97789f6-43b4-a607-5af8-4f522f753761@redhat.com>
 <CAOQ_QsjsmVpbi92o_Dz0GzAmU_Oq=Z4KFjZ8BY5dLQr7YmbrFg@mail.gmail.com>
 <CALMp9eQ4zPoRfPQJ2c7H-hyqCWu+B6fjXk+7SsEOvK7aR49ZJg@mail.gmail.com>
 <7dce49db-9175-bfe0-8374-d433a7589de9@redhat.com>
 <CAOQ_Qsg9+a07bva3ZsEhx8-wAw8JPDm6Amss0XnWfMT2mNtqaw@mail.gmail.com>
 <7775b2a5-37b0-38f6-f106-d8960cb5310c@redhat.com>
 <CAOQ_Qsipib1qvTw_o3pAp-t9jjf9kWm8M238zxN+Q=3yAMA9oA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bc8ada67-fcff-c48b-c4f8-1f4452073a2a@redhat.com>
Date:   Thu, 24 Sep 2020 15:43:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAOQ_Qsipib1qvTw_o3pAp-t9jjf9kWm8M238zxN+Q=3yAMA9oA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/08/20 21:40, Oliver Upton wrote:
>> If you don't have time to work on it I can try to find some for 5.10,
>> but I'm not sure exactly when.
>
> Shouldn't be an issue, I'll futz around with some changes to the
> series and send them out in the coming weeks.

Ok, after looking more at the code with Maxim I can confidently say that
it's a total mess.  And a lot of the synchronization code is dead
because 1) as far as we could see no guest synchronizes the TSC using
MSR_IA32_TSC; and 2) writing to MSR_IA32_TSC_ADJUST does not trigger the
synchronization code in kvm_write_tsc.

Your patch works not by some sort of miracle, but rather because it
bypasses the mess and that's the smart thing to do.

The plan is now as follows:

1) guest-initiated MSR_IA32_TSC write never goes through the sync
heuristics.  I'll shortly send a patch for this, and it will fix the
testcase issue

2) to have a new KVM_X86_DISABLE_QUIRKS value, that will toggle between
"magic" and "vanilla" semantics for host-initiated TSC and TSC_ADJUST writes

3) if the quirk is present we still want existing userspace to work so:

- host-initiated MSR_IA32_TSC write always returns the L1 TSC as in
Maxim's recent patch.  They will also always go through the sync heuristics.

- host-initiated MSR_IA32_TSC_ADJUST write don't make the TSC jump, they
only write to vcpu->arch.ia32_tsc_adjust_msr (as in the current kernel)

4) if the quirk is disabled however:

- the sync heuristics are never used except in kvm_arch_vcpu_postcreate

- host-initiated MSR_IA32_TSC and MSR_IA32_TSC_ADJUST accesses work like
in the guest: reads of MSR_IA32_TSC return the "right" TSC, writes of
MSR_IA32_TSC_ADJUST writes make the TSC jump.

- for live migration, userspace is expected to use the new
KVM_GET/SET_TSC_PRECISE (or whatever the name will be) to get/set a
(nanosecond, TSC, TSC_ADJUST) tuple.  The sync heuristics will be
bypassed and it will just set the right value for the MSRs.  Setting
MSR_IA32_TSC_ADJUST is optional and controlled by a flag in the struct,
and the flag will be set by KVM_GET_TSC_PRECISE based on the guest CPUID.

Paolo

