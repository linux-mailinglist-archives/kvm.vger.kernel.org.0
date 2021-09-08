Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA7C403A07
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 14:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351644AbhIHMju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 08:39:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58073 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349214AbhIHMjt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 08:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631104721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HLILDPxKgTqKXnfuzAZAfkzzX4dTKMN4K2TKBTinPy8=;
        b=D0tydaL518ZpQkubxTFAgD+b0Pnd1oAEt1bBldPyybGkfCVEqC/ruqvuTcyxPkXlTjaxTY
        +a2mC7u1pYjuLNHSJDo9/50QYEofNW8OEHa4S7DALEUaLVJBlHlYd+6uVH8yKQyCHgf76i
        OZjECARgTwfOE+VSOvpEZ7vgfktmLPM=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-tLmQS1-AMqOgaesEl-L8Lg-1; Wed, 08 Sep 2021 08:38:40 -0400
X-MC-Unique: tLmQS1-AMqOgaesEl-L8Lg-1
Received: by mail-ej1-f70.google.com with SMTP id q15-20020a17090622cf00b005c42d287e6aso912545eja.18
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 05:38:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HLILDPxKgTqKXnfuzAZAfkzzX4dTKMN4K2TKBTinPy8=;
        b=n+KqNxzz6ZSpVA5T1pIviMsVC/otP0vCNgm4t/AoSqJ5GjKuXkPPU6RKo6Bk9qA/DD
         CEvZvKio4+h872qN/1xFvP79wOu6pZbSUY/kST9nH4V8jRysx5fNzQkb8Rz9KHcY/PWN
         mNxu+1UHUdmKEhAUs1BJvI/z0ef8+yX4Iokxu6vExVBaT3M6dAuGGv7uxIJ5/pdpoT25
         U030HZZ79BenosSwFVM6SB54NAozAiCpn+Or3xMP1DBgAV8mbGLrLctjkaYxxcpEkI0o
         qAlG1r7yK7wbxtgwG5b5Ix9bdKwuiPKYzHrWwzkhiAHawnqu2fsH99g3hJd4BnTf8s5q
         tjiQ==
X-Gm-Message-State: AOAM532pFUE9CEKCkRvDKoeRk0kyR4IxrUdevofTrtizMpGsVUnzOtfR
        b4AfloXSNYphTVFrg48hN6QClWAQN+RkYAcGr5vlfU9jSknNAeG0B9cmnM5fxQ9y35tArgUoNrC
        jmsnLSSlKfRyL
X-Received: by 2002:a50:998f:: with SMTP id m15mr3606154edb.193.1631104719307;
        Wed, 08 Sep 2021 05:38:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycLx7AoNuPav5pLLv7LxfvSTvHfNhFqLrFBMo/KI4x2WofYcProh3FH9UDqZ+zN64+XUkKlQ==
X-Received: by 2002:a50:998f:: with SMTP id m15mr3606130edb.193.1631104719187;
        Wed, 08 Sep 2021 05:38:39 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id w3sm1072659edc.42.2021.09.08.05.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 05:38:38 -0700 (PDT)
Date:   Wed, 8 Sep 2021 14:38:37 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, maz@kernel.org, will@kernel.org,
        james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, mark.rutland@arm.com,
        christoffer.dall@arm.com, pbonzini@redhat.com, oupton@google.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com
Subject: Re: [PATCH v5 2/8] KVM: arm64: Add missing field descriptor for
 MDCR_EL2
Message-ID: <20210908123837.exyhsn6t2c7nmbox@gator>
References: <20210827101609.2808181-1-tabba@google.com>
 <20210827101609.2808181-3-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827101609.2808181-3-tabba@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 11:16:03AM +0100, Fuad Tabba wrote:
> It's not currently used. Added for completeness.
> 
> No functional change intended.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_arm.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 327120c0089f..a39fcf318c77 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -295,6 +295,7 @@
>  #define MDCR_EL2_HPMFZO		(UL(1) << 29)
>  #define MDCR_EL2_MTPME		(UL(1) << 28)
>  #define MDCR_EL2_TDCC		(UL(1) << 27)
> +#define MDCR_EL2_HLP		(UL(1) << 26)
>  #define MDCR_EL2_HCCD		(UL(1) << 23)
>  #define MDCR_EL2_TTRF		(UL(1) << 19)
>  #define MDCR_EL2_HPMD		(UL(1) << 17)
> -- 
> 2.33.0.259.gc128427fd7-goog
>

If we're proactively adding bits per the most recent spec, then I guess we
could also add HPMFZS (bit 36). Otherwise,

Reviewed-by: Andrew Jones <drjones@redhat.com>

