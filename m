Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2B142B46B
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 07:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhJMFNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 01:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhJMFNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 01:13:08 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2EBC061570
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 22:11:05 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id oa4so1283941pjb.2
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 22:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P8gf7IINw+jRwIt3X6fN4SZBz4OTW9W5HW6/ZYA0ZrQ=;
        b=OJnnPOpYu7eJYXwdgr0zRBsIp/7JCoJdWnLex1e+Nc59Ox3JrNo/ipy44NWbdZ1Wij
         cYg9Oe3IdKwjLZ3ccjWj/lfARUHUDGXHYczC1qcS8GhYxeGqNfAmOiqjRGIpNbWEKXa2
         Qi9tEO86QIO9mq7K47Docwc+8w/vFa49WJ0i3X1YPZ8DwOrxIaJOvQhs4oTCjIw7XhMs
         85rNypB1vqioXE/4YRebipGjt4G4OJKFB3ozkhVDBnROsdS2D888AzkaK6wai/y9wcPK
         fKZlh7cJKDfsqEQisJ01cAjq66cHlSWqDJ4/mRmAC2HTJLmfX15DM2CV03Md2tO4vBCx
         h8Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P8gf7IINw+jRwIt3X6fN4SZBz4OTW9W5HW6/ZYA0ZrQ=;
        b=SeCC/a15jKA372+Qk0FqdoxS60FsNKHNWeWPsHMJ6fax5NVYdGCXqrQgPwV4cCmZY4
         Qw9Lt2R02V5E+OjMJB6E96SGaWF08jLL4uzwv+U2R+6FJb90Hq8einR/pD3kpb4bSYQ2
         4Ln1YBMGSZo7/A+7Qk3rj7bVuTFzgPHZSUXPiPKyEfZpC59DvaWPAi+DaNxjUoN22iSE
         ec9C92QqIdfeIZAliN7AMbPuhJn7DSMQ9Gn4LG+exMhelRU+/oudjlgLY/bjL4V6WoFz
         tTKHP4iV474extpe0cfTJIjEmRfzUg2PLx2ilJ+G1drzHB9jm3dknQooc4lmnq3srmvx
         hL1g==
X-Gm-Message-State: AOAM532oOOw1GDDFjCxkR5Cy/1MKfurXRLtjfqB93v3lxEw9kD/DN5eg
        M2xsjPTVyZ20k92kdZqSPPBbudBxPD3NBsTLTf0QiA==
X-Google-Smtp-Source: ABdhPJzuE5GfZRyptpvG0d49NR7yBY6nXSth0Pf0CO5A5fn5OISFtomB4UlZSF8y0nx09KKkz3b+VnV54dmuG26Efq8=
X-Received: by 2002:a17:902:c402:b0:13f:1c07:5a25 with SMTP id
 k2-20020a170902c40200b0013f1c075a25mr24520082plk.38.1634101864597; Tue, 12
 Oct 2021 22:11:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com> <20210916181510.963449-6-oupton@google.com>
In-Reply-To: <20210916181510.963449-6-oupton@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 12 Oct 2021 22:10:48 -0700
Message-ID: <CAAeT=Fwuy2TT75KmBMgHXkxt++BAc30EUaybkU_V-zix+2Q9zw@mail.gmail.com>
Subject: Re: [PATCH v8 5/8] arm64: cpufeature: Enumerate support for FEAT_ECV
 >= 0x2
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16, 2021 at 11:15 AM Oliver Upton <oupton@google.com> wrote:
>
> Introduce a new cpucap to indicate if the system supports full enhanced
> counter virtualization (i.e. ID_AA64MMFR0_EL1.ECV>=0x2).
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/sysreg.h |  1 +
>  arch/arm64/kernel/cpufeature.c  | 10 ++++++++++
>  arch/arm64/tools/cpucaps        |  1 +
>  3 files changed, 12 insertions(+)
>
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index b268082d67ed..3fa6b091384d 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -849,6 +849,7 @@
>  #define ID_AA64MMFR0_ASID_8            0x0
>  #define ID_AA64MMFR0_ASID_16           0x2
>
> +#define ID_AA64MMFR0_ECV_PHYS          0x2
>  #define ID_AA64MMFR0_TGRAN4_NI                 0xf
>  #define ID_AA64MMFR0_TGRAN4_SUPPORTED_MIN      0x0
>  #define ID_AA64MMFR0_TGRAN4_SUPPORTED_MAX      0x7
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index f8a3067d10c6..2f5042bb107c 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -2328,6 +2328,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>                 .matches = has_cpuid_feature,
>                 .min_field_value = 1,
>         },
> +       {
> +               .desc = "Enhanced Counter Virtualization (Physical)",
> +               .capability = ARM64_HAS_ECV2,
> +               .type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +               .sys_reg = SYS_ID_AA64MMFR0_EL1,
> +               .sign = FTR_UNSIGNED,
> +               .field_pos = ID_AA64MMFR0_ECV_SHIFT,
> +               .matches = has_cpuid_feature,
> +               .min_field_value = ID_AA64MMFR0_ECV_PHYS,
> +       },
>         {},
>  };
>
> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
> index 49305c2e6dfd..f73a30d5fb1c 100644
> --- a/arch/arm64/tools/cpucaps
> +++ b/arch/arm64/tools/cpucaps
> @@ -18,6 +18,7 @@ HAS_CRC32
>  HAS_DCPODP
>  HAS_DCPOP
>  HAS_E0PD
> +HAS_ECV2
>  HAS_EPAN
>  HAS_GENERIC_AUTH
>  HAS_GENERIC_AUTH_ARCH
> --

Reviewed-by: Reiji Watanabe <reijiw@google.com>

Personally, I would prefer a more descriptive name (e.g. ECV_PHYS)
rather than ECV2 though.

Thanks,
Reiji
