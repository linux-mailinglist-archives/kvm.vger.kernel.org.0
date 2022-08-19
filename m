Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21D159A42D
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 20:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354255AbiHSQtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 12:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354127AbiHSQsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 12:48:08 -0400
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7771312C7D0
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 09:12:56 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-32a09b909f6so134428397b3.0
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 09:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=C0GWzj365wE2sR7xJX1mOB/d9C1PQzA2HDwoU7ywZuE=;
        b=C8rxUGor26d4pLtnEfWBFLrobr0zohYJN0RmYiPmeejX1B5WIjYxlIW6O6vpwvR1kl
         3uyk2b69rpX1Z3KkgD3NkX1UoIyiYooWrnZ6e7S7ptV0p9zUkVWpISqr0vV4dh6XhLMo
         E/w7i0Od1rZfz4/HXc07NbXbPwaU3YJg3txrbrh6/mjobSJcCr/bsWdBDVEacMmKXqAR
         ks00PMAhxsmPvbjHWRuvDJvT0i4MbZWIBfJl6VOxH8utFU8fi+hxR2qvbZ+V3nh5ZB2Z
         QBUwOkvnNc6PVLu7I6vwOjRs/zkpKfYc3BrO7YAqAjfgYZFMAZ7OdpFJnQAUhunI4M92
         Tv1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=C0GWzj365wE2sR7xJX1mOB/d9C1PQzA2HDwoU7ywZuE=;
        b=AAe0KOnWk7EOUamTzchuowjk7AFbkKqKDGM5r0MDt9oJdXoCavDQGoWwcdQKNooBgK
         IBsdbpd/UvyT5Iu1LtJMG/wTf8ojtQPyo8GsAH1LvIhF3vJpMMBW7HyZjyoABqcqFPZU
         gH58GDsSDARSxfCozSIlsW34HEpceWKKGDjcfJvLTGZ647NFzwby6lAUXrYmYjyOm7Oc
         QQVi1pD72rvz19uofrv3fXN1D+/rhIlqMhzviDiGEUvsN3WLZSzL4YX01uCisOxeuCVD
         sfdPKNVUJiZ4OvN25LGT0nBKpWHN+doCbMCZwAwM5T6ZVu+VHgsmu7hkmqH4ICyI1DO5
         mEfw==
X-Gm-Message-State: ACgBeo0BvSsojO/OBZLd8F+DyTz5GaO1NjnKiQdzgSPtzKblvuHrw70O
        qqP74BNR1nffmHHvXm1Hx8JUo2dDmnR/33OJeJ9HAQ==
X-Google-Smtp-Source: AA6agR4cI9mNUD+gm+cIqyleTiDxTP2r6qU3PI1eMiuXZNFUEQ8DnMtoNGS2ptGOR81qvDTW+PP72cquB+zEajJtuZA=
X-Received: by 2002:a5b:850:0:b0:68c:5798:a927 with SMTP id
 v16-20020a5b0850000000b0068c5798a927mr8403287ybq.8.1660925547310; Fri, 19 Aug
 2022 09:12:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220814141237.493457-1-mail@conchuod.ie> <20220814141237.493457-3-mail@conchuod.ie>
In-Reply-To: <20220814141237.493457-3-mail@conchuod.ie>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 19 Aug 2022 21:42:15 +0530
Message-ID: <CAAhSdy2bc4StpxUu6CgqygLG4FgzkN+VhsEavkge4rvJjPqNng@mail.gmail.com>
Subject: Re: [PATCH 2/4] riscv: kvm: move extern sbi_ext declarations to a header
To:     Conor Dooley <mail@conchuod.ie>
Cc:     Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Xianting Tian <xianting.tian@linux.alibaba.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Tong Tiangen <tongtiangen@huawei.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 14, 2022 at 7:42 PM Conor Dooley <mail@conchuod.ie> wrote:
>
> From: Conor Dooley <conor.dooley@microchip.com>
>
> Sparse complains about missing statics in the declarations of several
> variables:
> arch/riscv/kvm/vcpu_sbi_replace.c:38:37: warning: symbol 'vcpu_sbi_ext_time' was not declared. Should it be static?
> arch/riscv/kvm/vcpu_sbi_replace.c:73:37: warning: symbol 'vcpu_sbi_ext_ipi' was not declared. Should it be static?
> arch/riscv/kvm/vcpu_sbi_replace.c:126:37: warning: symbol 'vcpu_sbi_ext_rfence' was not declared. Should it be static?
> arch/riscv/kvm/vcpu_sbi_replace.c:170:37: warning: symbol 'vcpu_sbi_ext_srst' was not declared. Should it be static?
> arch/riscv/kvm/vcpu_sbi_base.c:69:37: warning: symbol 'vcpu_sbi_ext_base' was not declared. Should it be static?
> arch/riscv/kvm/vcpu_sbi_base.c:90:37: warning: symbol 'vcpu_sbi_ext_experimental' was not declared. Should it be static?
> arch/riscv/kvm/vcpu_sbi_base.c:96:37: warning: symbol 'vcpu_sbi_ext_vendor' was not declared. Should it be static?
> arch/riscv/kvm/vcpu_sbi_hsm.c:115:37: warning: symbol 'vcpu_sbi_ext_hsm' was not declared. Should it be static?
>
> These variables are however used in vcpu_sbi.c where they are declared
> as extern. Move them to kvm_vcpu_sbi.h which is handily already
> included by the three other files.
>
> Fixes: a046c2d8578c ("RISC-V: KVM: Reorganize SBI code by moving SBI v0.1 to its own file")
> Fixes: 5f862df5585c ("RISC-V: KVM: Add v0.1 replacement SBI extensions defined in v0.2")
> Fixes: 3e1d86569c21 ("RISC-V: KVM: Add SBI HSM extension in KVM")
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>

I have queued this fix for 6.0-rc1

Thanks,
Anup

> ---
>  arch/riscv/include/asm/kvm_vcpu_sbi.h | 12 ++++++++++++
>  arch/riscv/kvm/vcpu_sbi.c             | 12 +-----------
>  2 files changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> index 83d6d4d2b1df..26a446a34057 100644
> --- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
> +++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
> @@ -33,4 +33,16 @@ void kvm_riscv_vcpu_sbi_system_reset(struct kvm_vcpu *vcpu,
>                                      u32 type, u64 flags);
>  const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(unsigned long extid);
>
> +#ifdef CONFIG_RISCV_SBI_V01
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
> +#endif
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time;
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
> +extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
> +
>  #endif /* __RISCV_KVM_VCPU_SBI_H__ */
> diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
> index d45e7da3f0d3..f96991d230bf 100644
> --- a/arch/riscv/kvm/vcpu_sbi.c
> +++ b/arch/riscv/kvm/vcpu_sbi.c
> @@ -32,23 +32,13 @@ static int kvm_linux_err_map_sbi(int err)
>         };
>  }
>
> -#ifdef CONFIG_RISCV_SBI_V01
> -extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
> -#else
> +#ifndef CONFIG_RISCV_SBI_V01
>  static const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01 = {
>         .extid_start = -1UL,
>         .extid_end = -1UL,
>         .handler = NULL,
>  };
>  #endif
> -extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
> -extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time;
> -extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
> -extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
> -extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
> -extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
> -extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
> -extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
>
>  static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
>         &vcpu_sbi_ext_v01,
> --
> 2.37.1
>
