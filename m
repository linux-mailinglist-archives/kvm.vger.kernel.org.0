Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C582128956
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 15:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbfLUN77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Dec 2019 08:59:59 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56029 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726339AbfLUN76 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 21 Dec 2019 08:59:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576936797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OzGanSLZTyj0rQovzhKYZlGacf6XiNSu8LL+snIztqY=;
        b=fFK/+JAuFdzfM4hilgmUIDGLshPc5v5ij9k7VWOTBhLaL4LF/+RnrVSTQAe8/u69ZJ8q+y
        Q7MmLLlmAMnqsZJDKMd5lGkP+SdkcEoPqL0WfOyasb5qAK60vLvQLZOaiiaHul4UbjAeFy
        6s8zi23EDEzjJLDFAcWf92Z048z41lg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-COaqtliaN7e9mAFW3Sy94Q-1; Sat, 21 Dec 2019 08:59:56 -0500
X-MC-Unique: COaqtliaN7e9mAFW3Sy94Q-1
Received: by mail-wr1-f72.google.com with SMTP id f17so5248701wrt.19
        for <kvm@vger.kernel.org>; Sat, 21 Dec 2019 05:59:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OzGanSLZTyj0rQovzhKYZlGacf6XiNSu8LL+snIztqY=;
        b=OTLCODmzRdPHMNGNuorRKe4+lCU+A4E+Yrxxn7WF5WeexDw+GLiMFcaOmGRlzYdQt+
         v6dfJReReGFbi4NouEYzCozZTKlhmP4jjVkofcv6FxVT9reoCjBT/RvgrN9C+G+beRZJ
         c0EeC/yYHCLz37d6PLd2VfqSbhyBjvyiMAl+skc9i/NEexv9+QA1JI9EjYWYayh5fYcV
         8ohXuhBF/L06H95LkDhUann2funFJNgbvd/BUpHYQc4yRd6dfTw67IgOcoPGPv4/E5XJ
         eS0YcM7KArtXN9j9137YqWOiJOWEjKagf6hV06S7IgZoXdM+GRqIxsl7muXQQ2u9oiRu
         Ie7w==
X-Gm-Message-State: APjAAAVruvnW3cQU2BlYyTvxDitJD/PgkTt9/zSa3lNMwgI9jgpTVlcx
        UH6oLeABDCL8gQTEpTYW2IFTqsuh9jlFI09NlyGLddjjW3SrhHOu7BJIxMFijjGMMVm6Zx0nWW1
        FbNp95E+WSI8B
X-Received: by 2002:a7b:c246:: with SMTP id b6mr22038920wmj.75.1576936795196;
        Sat, 21 Dec 2019 05:59:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqyLRAsNew8w/Njk74OL0w+jRQfW7rEi8LEKPv1tveKg6C+XetMl+GwMwsCmTl3DOuerVovVrw==
X-Received: by 2002:a7b:c246:: with SMTP id b6mr22038894wmj.75.1576936794923;
        Sat, 21 Dec 2019 05:59:54 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ac09:bce1:1c26:264c? ([2001:b07:6468:f312:ac09:bce1:1c26:264c])
        by smtp.gmail.com with ESMTPSA id y7sm17763133wmd.1.2019.12.21.05.59.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 05:59:54 -0800 (PST)
Subject: Re: [RESEND RFC 0/2] Paravirtualized Control Register pinning
To:     John Andersen <john.s.andersen@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org
Cc:     hpa@zytor.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20191220192701.23415-1-john.s.andersen@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0f42e52a-6a16-69f4-41da-06e53d8025d2@redhat.com>
Date:   Sat, 21 Dec 2019 14:59:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191220192701.23415-1-john.s.andersen@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/12/19 20:26, John Andersen wrote:
> Paravirtualized CR pinning will likely be incompatible with kexec for
> the foreseeable future. Early boot code could possibly be changed to
> not clear protected bits. However, a kernel that requests CR bits be
> pinned can't know if the kernel it's kexecing has been updated to not
> clear protected bits. This would result in the kernel being kexec'd
> almost immediately receiving a general protection fault.
> 
> Security conscious kernel configurations disable kexec already, per KSPP
> guidelines. Projects such as Kata Containers, AWS Lambda, ChromeOS
> Termina, and others using KVM to virtualize Linux will benefit from
> this protection.
> 
> The usage of SMM in SeaBIOS was explored as a way to communicate to KVM
> that a reboot has occurred and it should zero the pinned bits. When
> using QEMU and SeaBIOS, SMM initialization occurs on reboot. However,
> prior to SMM initialization, BIOS writes zero values to CR0, causing a
> general protection fault to be sent to the guest before SMM can signal
> that the machine has booted.

SMM is optional; I think it makes sense to leave it to userspace to
reset pinning (including for the case of triple faults), while INIT
which is handled within KVM would keep it active.

> Pinning of sensitive CR bits has already been implemented to protect
> against exploits directly calling native_write_cr*(). The current
> protection cannot stop ROP attacks which jump directly to a MOV CR
> instruction. Guests running with paravirtualized CR pinning are now
> protected against the use of ROP to disable CR bits. The same bits that
> are being pinned natively may be pinned via the CR pinned MSRs. These
> bits are WP in CR0, and SMEP, SMAP, and UMIP in CR4.
> 
> Future patches could protect bits in MSRs in a similar fashion. The NXE
> bit of the EFER MSR is a prime candidate.

Please include patches for either kvm-unit-tests or
tools/testing/selftests/kvm that test the functionality.

Paolo

