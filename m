Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FC67BA69A
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 18:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjJEQjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 12:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbjJEQia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 12:38:30 -0400
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04191712BB;
        Thu,  5 Oct 2023 08:50:55 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id DB66C40E019C;
        Thu,  5 Oct 2023 15:50:52 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
        header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
        by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ErWHnuS91E4b; Thu,  5 Oct 2023 15:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
        t=1696521050; bh=j8N8Mna4YY+PMvlM4sYoaRgYzR+IgHczIxpklyEfbE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aY8surf7pQyW/bMIHoiYFLnzyCp/jiCMSEHSF+/x41KMguZx8DxJmL4e4KDu+oSk9
         M10OJxd19diSDp1lxKH8Q5lR0CNlL1PfKnkMP0K0BUl+ZxCA6jA+lyCU2aFNkkgDxA
         bzk1nQzAe4+M9bIlUjSqW4B0TX7FUTdWnRlShDblS+NhJr3IgkKXTiRCwEOVP/1TGK
         o1vIJhIsVNkGE7OGV0TMD5AxWd2sylaM7tG6+d2SGWW9+q1zcCk+ksKzy9Hd6jYKQ0
         9Nw0Xl6WGiCa77Ju1biSUW/WEdVz4mBhsHxrNOVMROy/9oMise29DKbcMzJa1NF312
         S99pdCs2MQK+EPRYQA2GAp/AC7fGWSAm1PgdpPBnS8MoVCJ1oEvwidiVu/DwexJqPB
         BAmsm3jqHNLaj2ZF3rKUbiqg1ZPne1YBjY8BW3NHUuU/FNXTDRekDoh6WYKzMNg8SU
         vZ4lw8dk4nKrrCK/hT6eWvXWv/vV/GxLD0CoWOLPlyCOx+2Eb4z0PM7HCc5QvhODW2
         JG4d2IeRQt8/Qf/RnqmWC1ARcWSt8ENvj0ZkAM4xGBcPo3e7yTXMFL3mmfGLAgOYpZ
         6LSqLED+iQ+imeZY1wx8pZcPvxeVkYov/l8YYePWopgtUdBkFV0JvxMvlFVLBCiUHJ
         HOkvu90srVdVyycUYiBSuDgM=
Received: from zn.tnic (pd953036a.dip0.t-ipconnect.de [217.83.3.106])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F1A6E40E014B;
        Thu,  5 Oct 2023 15:50:36 +0000 (UTC)
Date:   Thu, 5 Oct 2023 17:50:32 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2] x86: KVM: Add feature flag for
 CPUID.80000021H:EAX[bit 1]
Message-ID: <20231005155032.GEZR7bSFlZwxRR37Gc@fat_crate.local>
References: <20231005031237.1652871-1-jmattson@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231005031237.1652871-1-jmattson@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 04, 2023 at 08:12:37PM -0700, Jim Mattson wrote:
> Define an X86_FEATURE_* flag for CPUID.80000021H:EAX.[bit 1], and
> advertise the feature to userspace via KVM_GET_SUPPORTED_CPUID.
> 
> Per AMD's "Processor Programming Reference (PPR) for AMD Family 19h
> Model 61h, Revision B1 Processors (56713-B1-PUB)," this CPUID bit
> indicates that a WRMSR to MSR_FS_BASE, MSR_GS_BASE, or
> MSR_KERNEL_GS_BASE is non-serializing. This is a change in previously
> architected behavior.
> 
> Effectively, this CPUID bit is a "defeature" bit, or a reverse
> polarity feature bit. When this CPUID bit is clear, the feature
> (serialization on WRMSR to any of these three MSRs) is available. When
> this CPUID bit is set, the feature is not available.
> 
> KVM_GET_SUPPORTED_CPUID must pass this bit through from the underlying
> hardware, if it is set. Leaving the bit clear claims that WRMSR to
> these three MSRs will be serializing in a guest running under
> KVM. That isn't true. Though KVM could emulate the feature by
> intercepting writes to the specified MSRs, it does not do so
> today. The guest is allowed direct read/write access to these MSRs
> without interception, so the innate hardware behavior is preserved
> under KVM.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
> 
> v1 -> v2: Added justification for this change to the commit message,
>           tweaked the macro name and comment in cpufeatures.h for
> 	  improved clarity.
> 
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kvm/cpuid.c               | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
