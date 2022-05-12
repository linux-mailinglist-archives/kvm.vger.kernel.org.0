Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F657524F13
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 15:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354841AbiELN70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 09:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354836AbiELN7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 09:59:24 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792B91E21B1;
        Thu, 12 May 2022 06:59:22 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id be20so6300408edb.12;
        Thu, 12 May 2022 06:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g/Qg+1AZg6aTBJtpO/aq9xOI91f+bSFV81BXjqwHGko=;
        b=GzBUlMuf69Ac0C7m/kaNVndV6Br0xiShvNqxUeOtw0juwWg14tpjtIRYebJbMQnycZ
         gfsbrtjvbB198B/98w558vukOCoVUdS4/T5UrB7bGiHdWbfn56tqO9iKrbphRYbSsQUO
         /Bip1JrTlw/Xs5cs4JtbClv1JRpR4YOzdebdBpfbcudpz2YrG5l5AwU1Uw8QJ0qmWBys
         1tDUVkL99PTMiG7dUcrldXVcWZazAmRggiPt+16TFwqSq0NFTGlSo7qHwlkQ9v7lWZ+c
         af+8hAUiy8qSER3xsYxNg1BOMPKLk+bJMQyWJkb0b1V6mBQ9pn99UxqCRrR8If9bBVLo
         UtbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g/Qg+1AZg6aTBJtpO/aq9xOI91f+bSFV81BXjqwHGko=;
        b=KfrVUMd7A4KlmGOYziAIQueQwJ2TdH7zgSpzWmRAQHGnAXUNt2Zj9UTvDiJ0IV5O2g
         As20+SjaJSketS0gJsSbS2yXCFiyQoVFsI59LGUxcike0Ao5xXM4c5Rz0hfjX33QhwtU
         CCxjG+jSjqjDH0lI05EjuZCwB4xDItkacGCZbfvCwdtamGVmEB0YpOHo+bXdwU+rnbYx
         oEpz/3QGMkxbJLrlRGUUqgjq3jTcNY4TO9WO5tx1KclXIs/7m6x9oy4Tiaz8T82pQ7/K
         uyNPfsO5CoTIIp7+rtOjbw+XxX3qle/QTuDCmNcdTRKBKCHDOUiTD8udrWSeABiyU9FY
         VtoQ==
X-Gm-Message-State: AOAM532c7th8JiC8Q1011h1PuecmgXKtj++6TTD8450TCwRS5IUA0fmJ
        PpDNJSwjL84ggzq2kQKJaDI=
X-Google-Smtp-Source: ABdhPJxN9Fo7H7WahKOcrH15At67L2t0c/BFv/7iczdzwo4PhNstc9jrR++vhZVYhx07TuYHak7d1g==
X-Received: by 2002:a05:6402:747:b0:428:1f98:d17 with SMTP id p7-20020a056402074700b004281f980d17mr35536640edy.57.1652363961067;
        Thu, 12 May 2022 06:59:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id dx18-20020a170906a85200b006f3a8b81ff7sm2195937ejb.3.2022.05.12.06.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 06:59:20 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <e1fc28b6-996f-a436-2664-d6b044d07c82@redhat.com>
Date:   Thu, 12 May 2022 15:59:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 16/22] KVM: x86/mmu: remove redundant bits from extended
 role
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220414074000.31438-1-pbonzini@redhat.com>
 <20220414074000.31438-17-pbonzini@redhat.com> <Ynmv2X5eLz2OQDMB@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ynmv2X5eLz2OQDMB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/10/22 02:20, Sean Christopherson wrote:
> --
> From: Sean Christopherson<seanjc@google.com>
> Date: Mon, 9 May 2022 17:13:39 -0700
> Subject: [PATCH] KVM: x86/mmu: Return true from is_cr4_pae() iff CR0.PG is set
> 
> Condition is_cr4_pae() on is_cr0_pg() in addition to the !4-byte gPTE
> check.  From the MMU's perspective, PAE is disabling if paging is
> disabled.  The current code works because all callers check is_cr0_pg()
> before invoking is_cr4_pae(), but relying on callers to maintain that
> behavior is unnecessarily risky.
> 
> Fixes: faf729621c96 ("KVM: x86/mmu: remove redundant bits from extended role")
> Signed-off-by: Sean Christopherson<seanjc@google.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 909372762363..d1c20170a553 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -240,7 +240,7 @@ static inline bool is_cr0_pg(struct kvm_mmu *mmu)
> 
>   static inline bool is_cr4_pae(struct kvm_mmu *mmu)
>   {
> -        return !mmu->cpu_role.base.has_4_byte_gpte;
> +        return is_cr0_pg(mmu) && !mmu->cpu_role.base.has_4_byte_gpte;
>   }
> 
>   static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)

Hmm, thinking more about it this is not needed for two kind of opposite 
reasons:

* if is_cr4_pae() really were to represent the raw CR4.PAE value, this 
is incorrect and it should be up to the callers to check is_cr0_pg()

* if is_cr4_pae() instead represents 8-byte page table entries, then it 
does even before this patch, because of the following logic in 
kvm_calc_cpu_role():

         if (!____is_cr0_pg(regs)) {
                 role.base.direct = 1;
                 return role;
         }
	...
         role.base.has_4_byte_gpte = !____is_cr4_pae(regs);


So whatever meaning we give to is_cr4_pae(), there is no need for the 
adjustment.

Paolo
