Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8A1368457
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 18:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236341AbhDVQCy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 12:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhDVQCy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Apr 2021 12:02:54 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9567CC06174A
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 09:02:17 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id p12so33157062pgj.10
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 09:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=TfyJ6MVZHZT4qYZs+QTfqHo5PYcAw3/WGKzKHmsNF7Q=;
        b=AC8rkw3fEGKaCuZyZ6x2cTZBIIiTsrNr+cOHoTXvzbovKivVSx+wAcBZ6QCSyXz3FH
         /2vaEl+ACQxujSmOl1iOoojBXkqdrWfjQeMmaSst7e6knIWot/a2tISkGD8+yjA6blrw
         u9mcnSr5jthgkA5MGFcFz+Vz/suvZwMX0bYHkIcC9NL8oEPLMlWbxgtcZDHk9XRkfAez
         0Rw3x++aTP4P+gstc7zuX55DTQMCoIQFtVKfQ68xubefZoQcu5oBX0aMErfn2srMeNq1
         JVze+kHDRRSl24IcVZ83yC3Wisfv2ojx3SDCh+VR5o7eavBAOqdC1QfNVoVNif0XUm3s
         qfhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TfyJ6MVZHZT4qYZs+QTfqHo5PYcAw3/WGKzKHmsNF7Q=;
        b=JCaM7H8LuCIE0HI/rT6lq+xLRNLjjdbi4tCvojgsUXcAHmziF8pJ3H6epNA16tsDR3
         8LwuWLQKTUaueOpqi8oFfrmXNNgdQ3tvFqcO7EIpNEqI08klfJTD7Qxd8BjX2pS5DxC9
         cQtiEW1qrWhpQd84g+Ez+zIGr8SayykJwjVYNCJzdMifH9dyj/lUncpi2g2s4JwSOjxp
         Kw+PNF4t0LJcj9fHA1ngP8kEt0iRKdNXQBCA7ammglSQTwRy5RlMLIVacklAVML3NOj6
         0Jgeb09pJujw+KMwvQSlHVupMbc0BFUdDEd9tT5S4H5vRp8JDCfsolKZR5fPEgY3tn4H
         beLQ==
X-Gm-Message-State: AOAM5327fJy44/iw52ANbZLBaRdwl7SyjBTSkB8EggHeLukA5mtKE+a6
        Gm1GLU3/j4ZoYjFF96xD4iAJdw==
X-Google-Smtp-Source: ABdhPJwT1O+t/p4an/2vRkDCCDoUTyVwUm0awyHzCOC6sIXQaBs6y7uc90epxfOrDrLmNNplO5oroA==
X-Received: by 2002:a63:1a5e:: with SMTP id a30mr4307155pgm.156.1619107336834;
        Thu, 22 Apr 2021 09:02:16 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id p10sm2761023pgn.85.2021.04.22.09.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 09:02:16 -0700 (PDT)
Date:   Thu, 22 Apr 2021 16:02:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v5 00/15] KVM: SVM: Misc SEV cleanups
Message-ID: <YIGeBHEZ27zIDByF@google.com>
References: <20210422021125.3417167-1-seanjc@google.com>
 <e32cb350-9fbe-5abd-930a-e820a4f4930b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e32cb350-9fbe-5abd-930a-e820a4f4930b@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 22, 2021, Paolo Bonzini wrote:
> > Paolo Bonzini (1):
> >    KVM: SEV: Mask CPUID[0x8000001F].eax according to supported features
> > 
> > Sean Christopherson (14):
> >    KVM: SVM: Zero out the VMCB array used to track SEV ASID association
> >    KVM: SVM: Free sev_asid_bitmap during init if SEV setup fails
> >    KVM: SVM: Disable SEV/SEV-ES if NPT is disabled
> >    KVM: SVM: Move SEV module params/variables to sev.c
> >    x86/sev: Drop redundant and potentially misleading 'sev_enabled'
> >    KVM: SVM: Append "_enabled" to module-scoped SEV/SEV-ES control
> >      variables
> >    KVM: SVM: Condition sev_enabled and sev_es_enabled on
> >      CONFIG_KVM_AMD_SEV=y
> >    KVM: SVM: Enable SEV/SEV-ES functionality by default (when supported)
> >    KVM: SVM: Unconditionally invoke sev_hardware_teardown()
> >    KVM: SVM: Explicitly check max SEV ASID during sev_hardware_setup()
> >    KVM: SVM: Move SEV VMCB tracking allocation to sev.c
> >    KVM: SVM: Drop redundant svm_sev_enabled() helper
> >    KVM: SVM: Remove an unnecessary prototype declaration of
> >      sev_flush_asids()
> >    KVM: SVM: Skip SEV cache flush if no ASIDs have been used
> > 
> >   arch/x86/include/asm/mem_encrypt.h |  1 -
> >   arch/x86/kvm/cpuid.c               |  8 ++-
> >   arch/x86/kvm/cpuid.h               |  1 +
> >   arch/x86/kvm/svm/sev.c             | 80 ++++++++++++++++++++++--------
> >   arch/x86/kvm/svm/svm.c             | 57 +++++++++------------
> >   arch/x86/kvm/svm/svm.h             |  9 +---
> >   arch/x86/mm/mem_encrypt.c          | 12 ++---
> >   arch/x86/mm/mem_encrypt_identity.c |  1 -
> >   8 files changed, 97 insertions(+), 72 deletions(-)
> > 
> 
> Queued except for patch 6, send that separately since it's purely x86 and
> maintainers will likely not notice it inside this thread.  You probably want
> to avoid conflicts by waiting for the migration patches, though.

It can't be sent separately, having both the kernel's sev_enabled and KVM's
sev_enabled doesn't build with CONFIG_AMD_MEM_ENCRYPT=y:

arch/x86/kvm/svm/sev.c:33:13: error: static declaration of ‘sev_enabled’ follows non-static declaration
   33 | static bool sev_enabled = true;
      |             ^~~~~~~~~~~
In file included from include/linux/mem_encrypt.h:17,
                 from arch/x86/include/asm/page_types.h:7,
                 from arch/x86/include/asm/page.h:9,
                 from arch/x86/include/asm/thread_info.h:12,
                 from include/linux/thread_info.h:58,
                 from arch/x86/include/asm/preempt.h:7,
                 from include/linux/preempt.h:78,
                 from include/linux/percpu.h:6,
                 from include/linux/context_tracking_state.h:5,
                 from include/linux/hardirq.h:5,
                 from include/linux/kvm_host.h:7,
                 from arch/x86/kvm/svm/sev.c:11:
arch/x86/include/asm/mem_encrypt.h:23:13: note: previous declaration of ‘sev_enabled’ was here
   23 | extern bool sev_enabled;
      |             ^~~~~~~~~~~
make[3]: *** [scripts/Makefile.build:271: arch/x86/kvm/svm/sev.o] Error 1
