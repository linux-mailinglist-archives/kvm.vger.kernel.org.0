Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF0276ED50
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 16:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236208AbjHCO4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 10:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbjHCO4i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 10:56:38 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545451990
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 07:56:37 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 5614622812f47-3a6f3ef3155so780404b6e.1
        for <kvm@vger.kernel.org>; Thu, 03 Aug 2023 07:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1691074596; x=1691679396;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9hyFp+WOW+/vd01e2wQ2PJhYLg5FzB78DSPLaMZwJJc=;
        b=LM+vjonnFE2mN6DKBgGGnuIBMg+KyZq8ditO7F2DyWQOF9cbbMjPrISPG8/ISkAU2w
         /uU93H9qVn9Q1OOe54CqM3dsdI8DAQJpW6inYpLxDQ4mpAtiwDcQ9Z9rzlhjZ53QS4Fh
         TZHCI9x5zbiIRAjNWj05tsGo5+3jdHn5Z1MoYMxFaVyHuK9cpLupfKORwCUcAgUFtpJq
         7aPHeVsTrVKNFmy/KoTyS3GS9CtCwzl7B7dLXywap2r6PiGx1o3XYv59vCJumDvE+w+U
         bwiA8CZoLlhovg08C0F2ND5peG7dm/h8SnQp0IouxgdIlMCUPDREYYrM2rA8WMa7Ui/h
         rrKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691074596; x=1691679396;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9hyFp+WOW+/vd01e2wQ2PJhYLg5FzB78DSPLaMZwJJc=;
        b=OQs6AJ/yJazFkujx4uDzvk4ZdeE1n8VR/bvhGKkGR4XjHp6jfXTm7DaPKmAZDx1SPL
         8MyOG0f8rY5yuTjdcrdMAtxVytSEO19haF02LEduAomxoZ7E0bytDHZL9O+ZbZBLeSLU
         xZ/Z0JkLwEoZ1qIqDDAFUcH/sn5yWKXlsGSftj15A8PsKzLeKwwDcVqPp1a+R8gYSaBB
         pZ6l3crDwI5iHmGegONmHCprt+CBkK6pSTVC2hEutbJUhEIz4bs0M7IOI+VEchQEW6mr
         lrmlVEU6TR/Do9NTO28lnHOaGcXXFAH9bCFvV19efsmv1o8nPljzse/WHHjmSy4HqPcI
         c0xQ==
X-Gm-Message-State: ABy/qLaUQfYliN1lpJ5CaHhrEmVl3+NOMCdr+WQAaWQFod9P8qqK8UrI
        tEm/7zjiqzG/l220oE+AlwKsVg==
X-Google-Smtp-Source: APBJJlEzXXI3/ZLMBVq6Rkf2ep5w01HsOd8PK0JmrTvxzzjQp8NND2XQF0tUmpYGZgDbswWqNYEcng==
X-Received: by 2002:a05:6808:1a17:b0:3a7:458e:3df4 with SMTP id bk23-20020a0568081a1700b003a7458e3df4mr12354106oib.56.1691074596615;
        Thu, 03 Aug 2023 07:56:36 -0700 (PDT)
Received: from [192.168.68.108] ([187.11.154.63])
        by smtp.gmail.com with ESMTPSA id y6-20020a056808130600b003a7543bb635sm401034oiv.22.2023.08.03.07.56.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Aug 2023 07:56:36 -0700 (PDT)
Message-ID: <b7ac5ba8-63f0-ca47-aa64-cb634e0fb33b@ventanamicro.com>
Date:   Thu, 3 Aug 2023 11:56:32 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 00/10] RISC-V: KVM: change get_reg/set_reg error codes
Content-Language: en-US
To:     kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     anup@brainfault.org, atishp@atishpatra.org, ajones@ventanamicro.com
References: <20230803140022.399333-1-dbarboza@ventanamicro.com>
From:   Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <20230803140022.399333-1-dbarboza@ventanamicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/3/23 11:00, Daniel Henrique Barboza wrote:
> Hi,
> 
> This version has changes in the document patch, as suggested by Andrew
> in v2. It also has a new patch (patch 9) that handles error code changes
> in vcpu_vector.c.

I forgot to include a diff that Andrew mentioned in his v2 review:


diff --git a/arch/riscv/kvm/vcpu_onereg.c b/arch/riscv/kvm/vcpu_onereg.c
index c88b0c7f7f01..6ca90c04ba61 100644
--- a/arch/riscv/kvm/vcpu_onereg.c
+++ b/arch/riscv/kvm/vcpu_onereg.c
@@ -506,7 +506,7 @@ static int riscv_vcpu_get_isa_ext_multi(struct kvm_vcpu *vcpu,
         unsigned long i, ext_id, ext_val;

         if (reg_num > KVM_REG_RISCV_ISA_MULTI_REG_LAST)
-               return -EINVAL;
+               return -ENOENT;

         for (i = 0; i < BITS_PER_LONG; i++) {
                 ext_id = i + reg_num * BITS_PER_LONG;
@@ -529,7 +529,7 @@ static int riscv_vcpu_set_isa_ext_multi(struct kvm_vcpu *vcpu,
         unsigned long i, ext_id;

         if (reg_num > KVM_REG_RISCV_ISA_MULTI_REG_LAST)
-               return -EINVAL;
+               return -ENOENT;

         for_each_set_bit(i, &reg_val, BITS_PER_LONG) {
                 ext_id = i + reg_num * BITS_PER_LONG;
@@ -644,7 +644,7 @@ int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
                 break;
         }

-       return -EINVAL;
+       return -ENOENT;
  }

  int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,


I'll send a v4 including it. Thanks,


Daniel


> 
> Patches rebased on top of kvm_riscv_queue.
> 
> Changes from v2:
> - patch 9 (new):
>    - change kvm error codes for vector registers
> - patch 10 (former 9):
>    - rewrite EBUSY doc to mention that the error code indicates that it
>      is not allowed to change the reg val after the vcpu started.
> - v2 link: https://lore.kernel.org/kvm/20230801222629.210929-1-dbarboza@ventanamicro.com/
> 
> Andrew Jones (1):
>    RISC-V: KVM: Improve vector save/restore errors
> 
> Daniel Henrique Barboza (9):
>    RISC-V: KVM: return ENOENT in *_one_reg() when reg is unknown
>    RISC-V: KVM: use ENOENT in *_one_reg() when extension is unavailable
>    RISC-V: KVM: do not EOPNOTSUPP in set_one_reg() zicbo(m|z)
>    RISC-V: KVM: do not EOPNOTSUPP in set KVM_REG_RISCV_TIMER_REG
>    RISC-V: KVM: use EBUSY when !vcpu->arch.ran_atleast_once
>    RISC-V: KVM: avoid EBUSY when writing same ISA val
>    RISC-V: KVM: avoid EBUSY when writing the same machine ID val
>    RISC-V: KVM: avoid EBUSY when writing the same isa_ext val
>    docs: kvm: riscv: document EBUSY in KVM_SET_ONE_REG
> 
>   Documentation/virt/kvm/api.rst |  2 +
>   arch/riscv/kvm/aia.c           |  4 +-
>   arch/riscv/kvm/vcpu_fp.c       | 12 +++---
>   arch/riscv/kvm/vcpu_onereg.c   | 68 +++++++++++++++++++++++-----------
>   arch/riscv/kvm/vcpu_sbi.c      | 16 ++++----
>   arch/riscv/kvm/vcpu_timer.c    | 11 +++---
>   arch/riscv/kvm/vcpu_vector.c   | 60 ++++++++++++++++--------------
>   7 files changed, 104 insertions(+), 69 deletions(-)
> 
