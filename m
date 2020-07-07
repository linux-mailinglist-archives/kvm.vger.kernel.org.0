Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1230821681C
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 10:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgGGIRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 04:17:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27144 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726681AbgGGIRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 04:17:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594109839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2kxw8jGSvoStBvcs9wwLMwSg4FTlFK/RnZoowv393PM=;
        b=BcnGrycJRbw+4AsftoQcs3DeAia8HdvNIFmnTtSLDbls1CUMrV9b7F5pU+PNEgXLbTwhMt
        /bLffY09oU7cB8aupX4MYyIXBkx4VwY7SI/fdjzW21qMsySHVBKmsr7RnTNIl7yHRiekkb
        8PUm53/Gbqw6/KKw7RHGBuZWfP2r1Cs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-y-3W0Z1BNbuW1yGQvjEeFA-1; Tue, 07 Jul 2020 04:17:17 -0400
X-MC-Unique: y-3W0Z1BNbuW1yGQvjEeFA-1
Received: by mail-wm1-f72.google.com with SMTP id g138so42893564wme.7
        for <kvm@vger.kernel.org>; Tue, 07 Jul 2020 01:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2kxw8jGSvoStBvcs9wwLMwSg4FTlFK/RnZoowv393PM=;
        b=nV1qO4X48m+UeT1VQ3Xr9HXAywclLJbIP8znvvVA1MkapyfbdhWkUb6i9FpudeRH7L
         a+2BSh44bkYPMbGXohy6CM6pGDM4jkBLCMVHvkTv0fpNY7PWpXirPyWiqFfTIvw23HaH
         uU4VbRg3UQer2UpqgTujL21mfMfsoUpuIYnkEAgr8ptCBCcLbNLVOzfMA+C8HlfKiZet
         Lgp2yKvR1B1K36qkHE7nbNeXchQcB11vXaKljP2BfZjGouDNAMbCttzZGYIkLlAwsydE
         alYghCPUS7GeHgPFiBWCo0A56/CjJoBnGAjyYI79sqU5u07ZFI0PFWXVP/FlIYIkaC9f
         w/bA==
X-Gm-Message-State: AOAM531fQt2bJsUTlq/C+ZfToCvbXkJF+jXJyhYn7wLzp1U9AfUFThri
        Kq1mPe0T8BUP8VuRQBMPnZvir8K85X/hdanjssTX5SaBNI/B6AFeel6rExd1q1Y8jJgTuAFfEt4
        Khw2pDCGRDtTg
X-Received: by 2002:a5d:43d0:: with SMTP id v16mr55317223wrr.296.1594109836838;
        Tue, 07 Jul 2020 01:17:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRRgsZcT5qn/1NYBhutG36Ov7sfbQPzmiPv2vi5AaTnoUJjAOQ7wg/jDiQ45EN3SXy2rIVeQ==
X-Received: by 2002:a5d:43d0:: with SMTP id v16mr55317207wrr.296.1594109836609;
        Tue, 07 Jul 2020 01:17:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e95f:9718:ec18:4c46? ([2001:b07:6468:f312:e95f:9718:ec18:4c46])
        by smtp.gmail.com with ESMTPSA id v3sm27637294wrq.57.2020.07.07.01.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 01:17:16 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: rewrite kvm_spec_ctrl_valid_bits
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>
References: <20200702174455.282252-1-mlevitsk@redhat.com>
 <20200702181606.GF3575@linux.intel.com>
 <3793ae0da76fe00036ed0205b5ad8f1653f58ef2.camel@redhat.com>
 <20200707061105.GH5208@linux.intel.com>
 <7c1d9bbe-5f59-5b86-01e9-43c929b24218@redhat.com>
 <20200707081444.GA7417@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e5da32da-6cb2-85b1-a12b-da796843d2bb@redhat.com>
Date:   Tue, 7 Jul 2020 10:17:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200707081444.GA7417@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/07/20 10:14, Sean Christopherson wrote:
>>> One oddity with this whole thing is that by passing through the MSR, KVM is
>>> allowing the guest to write bits it doesn't know about, which is definitely
>>> not normal.  It also means the guest could write bits that the host VMM
>>> can't.
>> That's true.  However, the main purpose of the kvm_spec_ctrl_valid_bits
>> check is to ensure that host-initiated writes are valid; this way, you
>> don't get a #GP on the next vmentry's WRMSR to MSR_IA32_SPEC_CTRL.
>> Checking the guest CPUID bit is not even necessary.
> Right, what I'm saying is that rather than try and decipher specs to
> determine what bits are supported, just throw the value at hardware and
> go from there.  That's effectively what we end up doing for the guest writes
> anyways.

Yes, it would prevent the #GP.

> Actually, the current behavior will break migration if there are ever legal
> bits that KVM doesn't recognize, e.g. guest writes a value that KVM doesn't
> allow and then migration fails when the destination tries to stuff the value
> into KVM.

Yes, unfortunately migration would also be broken if the target (and the
guest CPUID) is an older CPU.  But that's not something we can fix
without trapping all writes which would be unacceptably slow.

Paolo

