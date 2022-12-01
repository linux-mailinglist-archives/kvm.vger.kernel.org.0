Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6301363EE49
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 11:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiLAKos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 05:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiLAKn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 05:43:29 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13792A13F1;
        Thu,  1 Dec 2022 02:43:24 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id ay27-20020a05600c1e1b00b003d070f4060bso1172940wmb.2;
        Thu, 01 Dec 2022 02:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=34xRbeJm4Ksf3agn72vdHuQrCy+xFaOAkMI20jSUs8E=;
        b=AzHg60UfqWIuniRDwSV0kUn58L84AxRbLj1KxaWUpkExnaz9Jf0mpMJsRIxs0KObgd
         soQ1W7t6DClFqZL5Sz4pVLJxPODSdcfWH2JFiVW2zEBMerlLvjkR1+DJoc4+WpNBKL+I
         PW6xkLEEUmN/Se6yT0vIWJph39WzqIA+SJPH1Jsv7h7dKXsKvjwPoKUClZhTIgXjAbFD
         m9zWUx0GIE8Dv1vkZzsH73Fq4mPpvgYZnpRmT8AL17xzVUC4+XcR3wej4y3vY5DfOIdr
         5pF7L9v5/ffa3NIJyyFg3JxW0kRC69giw2m5lejSbkJhsGZxR9w1oE4BDHpBORKVLYtO
         3/ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=34xRbeJm4Ksf3agn72vdHuQrCy+xFaOAkMI20jSUs8E=;
        b=IvrCioty0zyIqvdOrbfh/k1/GCHkt1WnFawJl8gpwhVQZ9IMjqyWpli0WU21szOuwN
         9aojgDzGytZ6mIED9JKmFYuziJ1w49pvlt+sdPJJUM9PrxAipyVeoXEwobK8pYccnQlH
         URZoQYy7lesUk4CcsN04FNBfuDdggZfxAYcuRd3ovY5VI0VlHt0M3tsbv+1xaqn/FIS4
         uvD8ALedZEHjDz7ze/VoudpbRfhGl8C0CjFv1aCNoTtmjeLVBd+u5wYIYSsg/5mw26DR
         MhChioC+AyjF6tBbvMIHWZBsQwC1T6CzUTTNfIBr9/pPxgfThtTbhBG81R6FdULqZUe4
         083A==
X-Gm-Message-State: ANoB5pmORjucJiFmBUSXwAp3OiMKolPawXjF/simdxYycKdIwSmtGuo6
        DqogSE0ckAs2QROipSVAKtU=
X-Google-Smtp-Source: AA0mqf6f8L9W/LFpuxiieU1hwL0SgbBmWKJep4VDP/7W75bGJuJSe0KFg6OoADvN7w7dpRP5siL0uQ==
X-Received: by 2002:a05:600c:1f16:b0:3cf:66a2:d440 with SMTP id bd22-20020a05600c1f1600b003cf66a2d440mr47429561wmb.108.1669891402569;
        Thu, 01 Dec 2022 02:43:22 -0800 (PST)
Received: from [192.168.0.248] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id i10-20020a1c540a000000b003cfc02ab8basm8303094wmb.33.2022.12.01.02.43.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 02:43:22 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <aa3be096-4f05-b653-b801-e102abe01903@xen.org>
Date:   Thu, 1 Dec 2022 10:43:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 34/50] KVM: x86: Unify pr_fmt to use module name for
 all KVM modules
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yuan Yao <yuan.yao@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20221130230934.1014142-1-seanjc@google.com>
 <20221130230934.1014142-35-seanjc@google.com>
Organization: Xen Project
In-Reply-To: <20221130230934.1014142-35-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/11/2022 23:09, Sean Christopherson wrote:
> Define pr_fmt using KBUILD_MODNAME for all KVM x86 code so that printks
> use consistent formatting across common x86, Intel, and AMD code.  In
> addition to providing consistent print formatting, using KBUILD_MODNAME,
> e.g. kvm_amd and kvm_intel, allows referencing SVM and VMX (and SEV and
> SGX and ...) as technologies without generating weird messages, and
> without causing naming conflicts with other kernel code, e.g. "SEV: ",
> "tdx: ", "sgx: " etc.. are all used by the kernel for non-KVM subsystems.
> 
> Opportunistically move away from printk() for prints that need to be
> modified anyways, e.g. to drop a manual "kvm: " prefix.
> 
> Opportunistically convert a few SGX WARNs that are similarly modified to
> WARN_ONCE; in the very unlikely event that the WARNs fire, odds are good
> that they would fire repeatedly and spam the kernel log without providing
> unique information in each print.
> 
> Note, defining pr_fmt yields undesirable results for code that uses KVM's
> printk wrappers, e.g. vcpu_unimpl().  But, that's a pre-existing problem
> as SVM/kvm_amd already defines a pr_fmt, and thankfully use of KVM's
> wrappers is relatively limited in KVM x86 code.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
[snip]
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index b246decb53a9..3bf7d69373cf 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -5,6 +5,7 @@
>    *
>    * KVM Xen emulation
>    */
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>   
>   #include "x86.h"
>   #include "xen.h"

Reviewed-by: Paul Durrant <paul@xen.org>

