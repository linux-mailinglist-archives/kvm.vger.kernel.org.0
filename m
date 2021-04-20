Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FA5365299
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 08:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhDTGwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 02:52:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230139AbhDTGwt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 02:52:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618901534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/RHLOcD8M249MwA8TbQiobmQMiRvQB/PzoDWZSaIlRs=;
        b=Y936Gk9M26gzMLBLegxECrPfafsVyxe2PUwWjrexN//6IicNN/ENLqUTFSa0gZ6+ToDluz
        fGCXReIJm+OVszKndTMAwVpX43KMu5Z7AkqN7W9dyOU7zKcimp+0wgf7iVgCfHYy0hmn5J
        jbv+7Zhur8wyDkgQJFvslsyPWDRja5M=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-sFsymWPZOp-fmEFyccTCMA-1; Tue, 20 Apr 2021 02:52:03 -0400
X-MC-Unique: sFsymWPZOp-fmEFyccTCMA-1
Received: by mail-ej1-f70.google.com with SMTP id ne22-20020a1709077b96b02903803a047edeso3076127ejc.3
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 23:52:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/RHLOcD8M249MwA8TbQiobmQMiRvQB/PzoDWZSaIlRs=;
        b=tGFcTjoO5WiqJVcHOY9J04yW8cNwRPOKJyKP1MDd2zAvFLXlkNAIjuVUkCFglHPrlP
         6qcD8fXQVbNNDSip7BHWakvw//qLa7+NZUhe0kv+EWCTSaPbAKSkhF9MUkBFdcEPydt0
         1JxaMiB6nRpkW3nnrMWCaii50SHsjrsbpyb4f0ckgwxFp+MlTehA28nLeF7ILouOUZGc
         4qhAhmyxx6J2793P5ou/Idkikjp0vKB1q+KB3U2dJ+kuY0s/kH3Ro9lUi7OUHr3RLD7k
         wKfezjVYNWjavsxXsxU0U/Qhl3FatoYRtv2QpWDaTd+aBjQwHntUlZ6ORZACydApY9om
         Fy8g==
X-Gm-Message-State: AOAM533R0bIY0J9qGEpVZTEHjKCHr1ZrsSQREc0iBjOf/GpzOm19DrT7
        aAKl3Fcxi6kVzQOqGgGdyYJWkCq3qeoH5Zm0sUsMfKDJY8+9GhksCNS2dOsoZjXTvBdvzcis2CJ
        qGctmFAUVynNM
X-Received: by 2002:aa7:d615:: with SMTP id c21mr17156904edr.176.1618901522479;
        Mon, 19 Apr 2021 23:52:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZe4nQ7sV/TKik7MnccxJgmY8EXJfdk5pySAzdJqMH4GFHWmvdy8kRgIWbmaKvxr7m3t3iOw==
X-Received: by 2002:aa7:d615:: with SMTP id c21mr17156887edr.176.1618901522269;
        Mon, 19 Apr 2021 23:52:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id z14sm311068edc.62.2021.04.19.23.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 23:52:01 -0700 (PDT)
Subject: Re: Doubt regarding memory allocation in KVM
To:     Shivank Garg <shivankgarg98@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAOVCmzH4XEGMGgOpvnLU7_qW93cNit4yvb6kOV2BZNZH_8POJg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e7c9b569-a1c4-7b8f-ce47-8e3526464c60@redhat.com>
Date:   Tue, 20 Apr 2021 08:52:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAOVCmzH4XEGMGgOpvnLU7_qW93cNit4yvb6kOV2BZNZH_8POJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/21 07:45, Shivank Garg wrote:
> Hi,
> I'm learning about qemu KVM, looking into code and experimenting on
> it. I have the following doubts regarding it, I would be grateful if
> you help me to get some idea on them.
> 
> 1. I observe that KVM allocates memory to guests when it needs it but
> doesn't take it back (except for ballooning case).
> Also, the Qemu/KVM process does not free the memory even when the
> guest is rebooted. In this case,  Does the Guest VM get access to
> memory already pre-filled with some garbage from the previous run??

Yes.

> (Since the host would allocate zeroed pages to guests the first time
> it requests but after that it's up to guests). Can it be a security
> issue?

No, it's the same that happens on non-virtual machine.

> 2. How does the KVM know if GPFN (guest physical frame number) is
> backed by an actual machine frame number in host? If not mapped, then
> it faults in the host and allocates a physical frame for guests in the
> host. (kvm_mmu_page_fault)

It's all handled by Linux.  KVM only does a call to get_user_pages.  See 
functions whose name starts with hva_to_pfn in virt/kvm/kvm_main.c

Given a GPA, the GFN is simply the guest physical address minus bits 
0:11, so shifted right by 12.

Paolo

