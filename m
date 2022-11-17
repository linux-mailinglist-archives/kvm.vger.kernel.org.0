Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE5A62DE6C
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 15:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240018AbiKQOkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 09:40:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240235AbiKQOkK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 09:40:10 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FCF786C9;
        Thu, 17 Nov 2022 06:37:35 -0800 (PST)
Received: from zn.tnic (p200300ea9733e7de329c23fffea6a903.dip0.t-ipconnect.de [IPv6:2003:ea:9733:e7de:329c:23ff:fea6:a903])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F15821EC064F;
        Thu, 17 Nov 2022 15:37:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1668695854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=6660MItCcmrf2jvcqYXWQ4EexmhDBrOeM17HjTku/vs=;
        b=ptO1DtFiRZnr7fCz5RYzAO1xDxodia2k1UKVrmWSMT82Yp3w1zqWMCKYGfBqLOtAQ5YuFm
        quuCJH8+18YPeLPa0/FjPdiMh4Gwt1grDKBXjFIwT9dY6lAfriy2b3D1D1Z/E0I7gi9EZ2
        ypYOj8vg7faDFUZfWiIFf16R0HIQd5k=
Date:   Thu, 17 Nov 2022 15:37:29 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sandipan Das <sandipan.das@amd.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Jing Liu <jing2.liu@intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Wyes Karny <wyes.karny@amd.com>,
        Babu Moger <babu.moger@amd.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Santosh Shukla <santosh.shukla@amd.com>
Subject: Re: [PATCH 06/13] KVM: SVM: Add VNMI bit definition
Message-ID: <Y3ZHKVq8enyxJmVu@zn.tnic>
References: <20221117143242.102721-1-mlevitsk@redhat.com>
 <20221117143242.102721-7-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221117143242.102721-7-mlevitsk@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 17, 2022 at 04:32:35PM +0200, Maxim Levitsky wrote:
> @@ -5029,6 +5031,10 @@ static __init int svm_hardware_setup(void)
>  		svm_x86_ops.vcpu_get_apicv_inhibit_reasons = NULL;
>  	}
>  
> +	vnmi = vnmi && boot_cpu_has(X86_FEATURE_AMD_VNMI);

s/boot_cpu_has/cpu_feature_enabled/

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
