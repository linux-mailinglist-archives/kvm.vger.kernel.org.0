Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5DF5BA634
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 07:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiIPFB0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 01:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiIPFBF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 01:01:05 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A387DA1D61
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 22:00:10 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id g8so13967352iob.0
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 22:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=bKygYTvjEKEBNRDEZXtXhWOlX6vaC0+Zex0fl1XbnPM=;
        b=KdBA4v3rOunzK+xLcSfGxBleQsAtiSTGZL0tORFMd3++nYFpDWNddKTsqUuyJf3BlE
         ifNY+cdNWSRdaKNV8Qoa/E+QBydloOXbCb2VNScGF77lGfomWyRfvd6TZ64kBnIHw4dA
         g+VOEkGTt2/hll1aSSYQj/9RsP/OK7TyAjSjkVGMpcR/JNb9A3CbBATOoQppYLL2p2Y/
         RnOluBNDBURgp7WsnGcPV7/1noAuRq8dKSlckYudptGIB1E4paip4RMsHuvRxm/qM+NI
         e4b0qfC1pfIP42wqoJb/8TQxOtXwu7jMWysVP0gf26ocTuFUqATDt4XcajESRBJIRhE6
         LMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=bKygYTvjEKEBNRDEZXtXhWOlX6vaC0+Zex0fl1XbnPM=;
        b=Zsp/pdM7n2ZJWsBOagviEnS84LsNZ+BLFj8hEQaAupWlJgqcHihDVfbQ/Hnfe6vJ11
         DS1HigelF4HKCdcdC180aoPh7wGPCYVSOLz1UiDyIK50wZxPDj20DeCloeDvdYR5HNlz
         qoAIi91H2PEtjntWh76KvxFm8+tEQ7v3xQ6dNuqW369TVGu7AdKp77JjJa6Acl1Oc5bi
         qOGBDGwPBlOzIxcuF32sr3nszStR5ZgMAt9z7KN22/8VTCeJx6kXiiurk2jBst0UKni0
         xmYheiNBgMBJ7nL3zoMhXRRXl7KucmftMXIwtJP66jGjkBHUnEvm4LXTCon39ASFiIgR
         HHvA==
X-Gm-Message-State: ACrzQf2N/NmatSf+wuf9+HTgex5Gl7JUwYUUuikY1EdCvySVX913KHOD
        75Vm2o2ilA8d45WZM49U+O1cKHzl7POJ2WhPVSpbNe3Jog8=
X-Google-Smtp-Source: AMsMyM72+hfnNGiGlXYNaeL/WF4pHIiV2cNC/m/eAyzLyDzNpIxf0SFv0Yllm7X3h9SB+d/xdsbVCo+5CXj9LMrDnoE=
X-Received: by 2002:a05:6602:2e0e:b0:684:e4f9:734a with SMTP id
 o14-20020a0566022e0e00b00684e4f9734amr1223608iow.200.1663304409492; Thu, 15
 Sep 2022 22:00:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220908110404.186725-1-apatel@ventanamicro.com>
In-Reply-To: <20220908110404.186725-1-apatel@ventanamicro.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 16 Sep 2022 10:29:57 +0530
Message-ID: <CAAhSdy1RVVq28h3FtbmToTOZJKPza4t-uFLVV2Uotj3DUrAEHw@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: Change the SBI specification version to v1.0
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 8, 2022 at 4:34 PM Anup Patel <apatel@ventanamicro.com> wrote:
>
> The SBI v1.0 specificaiton is functionally same as SBI v0.3
> specification except that SBI v1.0 specification went through
> the full RISC-V International ratification process.
>
> Let us change the SBI specification version to v1.0.
>
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>

I have queued this patch for 6.1

Thanks,
Anup

> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 26a446a34057..d4e3e600beef 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -11,8 +11,8 @@
>
>  #define KVM_SBI_IMPID 3
>
> -#define KVM_SBI_VERSION_MAJOR 0
> -#define KVM_SBI_VERSION_MINOR 3
> +#define KVM_SBI_VERSION_MAJOR 1
> +#define KVM_SBI_VERSION_MINOR 0
>
>  struct kvm_vcpu_sbi_extension {
>         unsigned long extid_start;
> --
> 2.34.1
>
