Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA7D62F8F8
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 16:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbiKRPMH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 10:12:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242155AbiKRPLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 10:11:51 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6896D11A06;
        Fri, 18 Nov 2022 07:11:48 -0800 (PST)
Received: from zn.tnic (p200300ea9733e767329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e767:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B90501EC058B;
        Fri, 18 Nov 2022 16:11:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668784306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=W04ieH3l3YNqi5aPLlL1P9gDGjaGNXHHDgtBGeabJLI=;
        b=lx1OXYkGW87IEw8UBBluJXoiUL15Z6WQPQQacP5JT+m8cXqv81dKsKrJXnR+bV6zOvs1O+
        +WKq81u1Vgw6pqwQtn+M8PfX9zYTQHKBWiYwU4GMHpS+4IZV6blkD4TiuBzlRG9W0WTJpI
        2D2Fiyw291Yzfw5GIeJLHFU3TqA2LG4=
Date:   Fri, 18 Nov 2022 16:11:41 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Jiaxi Chen <jiaxi.chen@linux.intel.com>
Cc:     kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, ndesaulniers@google.com,
        alexandre.belloni@bootlin.com, peterz@infradead.org,
        jpoimboe@kernel.org, chang.seok.bae@intel.com,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        jmattson@google.com, sandipan.das@amd.com, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, fenghua.yu@intel.com,
        keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] x86: KVM: Advertise CPUID of new Intel platform
 instructions to user space
Message-ID: <Y3eghRSvj5chxpfD@zn.tnic>
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 18, 2022 at 10:15:03PM +0800, Jiaxi Chen wrote:
> Chang S. Bae (1):
>   x86: KVM: Advertise AMX-FP16 CPUID to user space
> 
> Jiaxi Chen (5):
>   x86: KVM: Advertise CMPccXADD CPUID to user space
>   x86: KVM: Advertise AVX-IFMA CPUID to user space
>   x86: KVM: Advertise AVX-VNNI-INT8 CPUID to user space
>   x86: KVM: Advertise AVX-NE-CONVERT CPUID to user space
>   x86: KVM: Advertise PREFETCHIT0/1 CPUID to user space
> 
>  arch/x86/include/asm/cpufeatures.h | 3 +++

For the x86 bits:

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
