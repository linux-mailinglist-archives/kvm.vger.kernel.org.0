Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B66F91991CE
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 11:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731328AbgCaJJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 05:09:25 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38179 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730948AbgCaJJY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 05:09:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id f6so1689630wmj.3;
        Tue, 31 Mar 2020 02:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=i22ZQA6yLmZMoZO/Ys64tPvaaV7DizoXI2gCdBKlzmw=;
        b=VJQf9c9yp4DTJHeJnWmBct+Ii+sd87JXSUcDzExavZP19US/obSWJAde5NTQUyAUrN
         a53aNKl0a8JOl5Mn6X6PtaW7G5/txWRli9dk9taOQgZ5AL2vt3KkSgwqsW3dCrXZAylY
         FKAlKVnY4mYigkU4Q3S5r1YpeNpv4UMCJfYAAUfQ+FDJHWgOmiEtTIZxyjldK9LYXwn7
         EHV0PLKKRU7bfkBjcQd8+CqRFFKl1ytuNWu7KqRDzOIMlB+EjiZocYs6X8/i0PZiFJX7
         LxwZ9vruhgECADpLvr9/Y3BNHaEIs0jdi/rGiwh60bxVV2bh1lFaqboIUXeszI8s+mPM
         mfng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i22ZQA6yLmZMoZO/Ys64tPvaaV7DizoXI2gCdBKlzmw=;
        b=PP+6WCWY2bShYcHf+30yfTXcB+bWT9u4jGQa1ZMir/QfoPXQpp+aEr51Gt7Mc5SNnb
         +BL2F3wRIxqzrAEvXW7OlplTJBubrC9V3IygY76N2WRJ93ApeXdmrnhgyjVnyPAVs1TM
         ricSD6aFQjr4Oe5LmgWcGolUsztkDZJ3dFhZ5i9ziprG0z+a8bxe2tFtt/Wg2zO/6/Md
         QW4YPnLWi89zBpZ9p6LrdCqM23AB2qEay+50l6d6dA7bXnGQK1WmBcsJGzPjn2kZCOGl
         i6bbflfnS5t4zrELZau9agbRu1A4fwQasToMP/VoYUsj2pIpdti0p3MwnUC6MlgXgfO2
         5xRQ==
X-Gm-Message-State: ANhLgQ1M0lLXlXH4MHxdXPos+CA/czJtcmtForje8jB0df1/gFLg1qbn
        8kRd+tnyqqTi4e0qcb+Lbp0PSsBu
X-Google-Smtp-Source: ADFU+vsH4BDnMYsXGWqcq35Ioc0BDHVoghojzyDrHUGfBAWWqXSVgd/W6BFq09yVFwhT/6I7e2CZEA==
X-Received: by 2002:a1c:ba04:: with SMTP id k4mr2399511wmf.10.1585645761805;
        Tue, 31 Mar 2020 02:09:21 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id f25sm3030600wml.11.2020.03.31.02.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 02:09:21 -0700 (PDT)
Date:   Tue, 31 Mar 2020 11:09:19 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/12] docs: fix broken references for ReST files that
 moved around
Message-ID: <20200331090919.GA18238@Red>
References: <cover.1584450500.git.mchehab+huawei@kernel.org>
 <6ea0adf72ae55935f3649f87e4b596830b616594.1584450500.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ea0adf72ae55935f3649f87e4b596830b616594.1584450500.git.mchehab+huawei@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 17, 2020 at 02:10:48PM +0100, Mauro Carvalho Chehab wrote:
> Some broken references happened due to shifting files around
> and ReST renames. Those can't be auto-fixed by the script,
> so let's fix them manually.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/doc-guide/maintainer-profile.rst      | 2 +-
>  Documentation/virt/kvm/mmu.rst                      | 2 +-
>  Documentation/virt/kvm/review-checklist.rst         | 2 +-
>  arch/x86/kvm/mmu/mmu.c                              | 2 +-
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 2 +-
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c   | 2 +-
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 2 +-
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c   | 2 +-
>  drivers/media/v4l2-core/v4l2-fwnode.c               | 2 +-
>  include/uapi/linux/kvm.h                            | 4 ++--
>  tools/include/uapi/linux/kvm.h                      | 4 ++--
>  11 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/doc-guide/maintainer-profile.rst b/Documentation/doc-guide/maintainer-profile.rst
> index 5afc0ddba40a..755d39f0d407 100644
> --- a/Documentation/doc-guide/maintainer-profile.rst
> +++ b/Documentation/doc-guide/maintainer-profile.rst
> @@ -6,7 +6,7 @@ Documentation subsystem maintainer entry profile
>  The documentation "subsystem" is the central coordinating point for the
>  kernel's documentation and associated infrastructure.  It covers the
>  hierarchy under Documentation/ (with the exception of
> -Documentation/device-tree), various utilities under scripts/ and, at least
> +Documentation/devicetree), various utilities under scripts/ and, at least
>  some of the time, LICENSES/.
>  
>  It's worth noting, though, that the boundaries of this subsystem are rather
> diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
> index 60981887d20b..46126ecc70f7 100644
> --- a/Documentation/virt/kvm/mmu.rst
> +++ b/Documentation/virt/kvm/mmu.rst
> @@ -319,7 +319,7 @@ Handling a page fault is performed as follows:
>  
>   - If both P bit and R/W bit of error code are set, this could possibly
>     be handled as a "fast page fault" (fixed without taking the MMU lock).  See
> -   the description in Documentation/virt/kvm/locking.txt.
> +   the description in Documentation/virt/kvm/locking.rst.
>  
>   - if needed, walk the guest page tables to determine the guest translation
>     (gva->gpa or ngpa->gpa)
> diff --git a/Documentation/virt/kvm/review-checklist.rst b/Documentation/virt/kvm/review-checklist.rst
> index 1f86a9d3f705..dc01aea4057b 100644
> --- a/Documentation/virt/kvm/review-checklist.rst
> +++ b/Documentation/virt/kvm/review-checklist.rst
> @@ -10,7 +10,7 @@ Review checklist for kvm patches
>  2.  Patches should be against kvm.git master branch.
>  
>  3.  If the patch introduces or modifies a new userspace API:
> -    - the API must be documented in Documentation/virt/kvm/api.txt
> +    - the API must be documented in Documentation/virt/kvm/api.rst
>      - the API must be discoverable using KVM_CHECK_EXTENSION
>  
>  4.  New state must include support for save/restore.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 560e85ebdf22..2bd9f35e9e91 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3586,7 +3586,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  		/*
>  		 * Currently, fast page fault only works for direct mapping
>  		 * since the gfn is not stable for indirect shadow page. See
> -		 * Documentation/virt/kvm/locking.txt to get more detail.
> +		 * Documentation/virt/kvm/locking.rst to get more detail.
>  		 */
>  		fault_handled = fast_pf_fix_direct_spte(vcpu, sp,
>  							iterator.sptep, spte,
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> index a5fd8975f3d3..a6abb701bfc6 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> @@ -8,7 +8,7 @@
>   * This file add support for AES cipher with 128,192,256 bits keysize in
>   * CBC and ECB mode.
>   *
> - * You could find a link for the datasheet in Documentation/arm/sunxi/README
> + * You could find a link for the datasheet in Documentation/arm/sunxi.rst
>   */
>  
>  #include <linux/crypto.h>
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> index 3e4e4bbda34c..b957061424a1 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> @@ -7,7 +7,7 @@
>   *
>   * Core file which registers crypto algorithms supported by the CryptoEngine.
>   *
> - * You could find a link for the datasheet in Documentation/arm/sunxi/README
> + * You could find a link for the datasheet in Documentation/arm/sunxi.rst
>   */
>  #include <linux/clk.h>
>  #include <linux/crypto.h>
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> index 84d52fc3a2da..c89cb2ee2496 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
> @@ -8,7 +8,7 @@
>   * This file add support for AES cipher with 128,192,256 bits keysize in
>   * CBC and ECB mode.
>   *
> - * You could find a link for the datasheet in Documentation/arm/sunxi/README
> + * You could find a link for the datasheet in Documentation/arm/sunxi.rst
>   */
>  
>  #include <linux/crypto.h>
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> index 6b301afffd11..8ba4f9c81dac 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
> @@ -7,7 +7,7 @@
>   *
>   * Core file which registers crypto algorithms supported by the SecuritySystem
>   *
> - * You could find a link for the datasheet in Documentation/arm/sunxi/README
> + * You could find a link for the datasheet in Documentation/arm/sunxi.rst
>   */
>  #include <linux/clk.h>
>  #include <linux/crypto.h>
> diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
> index 97f0f8b23b5d..8a1e1b95b379 100644
> --- a/drivers/media/v4l2-core/v4l2-fwnode.c
> +++ b/drivers/media/v4l2-core/v4l2-fwnode.c
> @@ -980,7 +980,7 @@ static int v4l2_fwnode_reference_parse(struct device *dev,
>   *
>   * THIS EXAMPLE EXISTS MERELY TO DOCUMENT THIS FUNCTION. DO NOT USE IT AS A
>   * REFERENCE IN HOW ACPI TABLES SHOULD BE WRITTEN!! See documentation under
> - * Documentation/acpi/dsd instead and especially graph.txt,
> + * Documentation/firmware-guide/acpi/dsd/ instead and especially graph.txt,
>   * data-node-references.txt and leds.txt .
>   *
>   *	Scope (\_SB.PCI0.I2C2)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 5e6234cb25a6..704bd4cd3689 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -116,7 +116,7 @@ struct kvm_irq_level {
>  	 * ACPI gsi notion of irq.
>  	 * For IA-64 (APIC model) IOAPIC0: irq 0-23; IOAPIC1: irq 24-47..
>  	 * For X86 (standard AT mode) PIC0/1: irq 0-15. IOAPIC0: 0-23..
> -	 * For ARM: See Documentation/virt/kvm/api.txt
> +	 * For ARM: See Documentation/virt/kvm/api.rst
>  	 */
>  	union {
>  		__u32 irq;
> @@ -1106,7 +1106,7 @@ struct kvm_xen_hvm_config {
>   *
>   * KVM_IRQFD_FLAG_RESAMPLE indicates resamplefd is valid and specifies
>   * the irqfd to operate in resampling mode for level triggered interrupt
> - * emulation.  See Documentation/virt/kvm/api.txt.
> + * emulation.  See Documentation/virt/kvm/api.rst.
>   */
>  #define KVM_IRQFD_FLAG_RESAMPLE (1 << 1)
>  
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index 4b95f9a31a2f..e5f32fcec68f 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h
> @@ -116,7 +116,7 @@ struct kvm_irq_level {
>  	 * ACPI gsi notion of irq.
>  	 * For IA-64 (APIC model) IOAPIC0: irq 0-23; IOAPIC1: irq 24-47..
>  	 * For X86 (standard AT mode) PIC0/1: irq 0-15. IOAPIC0: 0-23..
> -	 * For ARM: See Documentation/virt/kvm/api.txt
> +	 * For ARM: See Documentation/virt/kvm/api.rst
>  	 */
>  	union {
>  		__u32 irq;
> @@ -1100,7 +1100,7 @@ struct kvm_xen_hvm_config {
>   *
>   * KVM_IRQFD_FLAG_RESAMPLE indicates resamplefd is valid and specifies
>   * the irqfd to operate in resampling mode for level triggered interrupt
> - * emulation.  See Documentation/virt/kvm/api.txt.
> + * emulation.  See Documentation/virt/kvm/api.rst.
>   */
>  #define KVM_IRQFD_FLAG_RESAMPLE (1 << 1)
>  
> -- 
> 2.24.1
> 

Hello

for sun8i-ss and sun8i-ce:
Acked-by: Corentin LABBE <clabbe.montjoie@gmail.com>

Thanks
