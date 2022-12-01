Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9CD363E772
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 03:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbiLACEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 21:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiLACEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 21:04:49 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A4B99F21
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 18:04:49 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so3814729pjp.1
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 18:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Bz9GPXhmGKQVTTK7beDiMaQdeCePM172DwfXfhBVIc=;
        b=madQ1brIPfOnUL8Z2SseC0tOUkjPHYMGZwrHkGvkNoIMGWnxiT/FtwrdwTRokaaIGU
         p4f3SaJAxFW3nOzKGTgJUeB90+9ZGNEay3vgd2s9fjqR6maI7fersqza8nbOixYA32AX
         Zp7+mzIRkkEL9KpuOjrn4Olx7zwi8e9MwgVgBVqkbRB7Ycm60z4xb6066nPtzZrgA13j
         /IrDWVQYQpKaUkdhsS1J8OmPkcHuUrgIZwwVCQryhV22ytFK9uU2BxWgVcbWOas7mjC3
         ++Zt3HprseK6Hyw7xFEH5RVTMCJBBy+8wHu5ZbmtdlBWXS7D3MaQwBzmZOJvGGE1uvbY
         xk7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Bz9GPXhmGKQVTTK7beDiMaQdeCePM172DwfXfhBVIc=;
        b=fmbYLkZWMSNUpLWKh1LN03xCl+uhoj6x0F7eG5yNAt6b2SGWkyFCPM53PNSIInslk/
         lrORasBtY03THSXeB5RYid3r7OBYM+ydOd7mPJTndV8Bzg/4/D5EDdnO9raVr0pLf5EB
         6uc23LDwwNsjrC5Nr2AS7o3lJg85HuwzyRK0a3GYmvOrZrlN5zGhE0qqa3KH2OgiZZ3S
         K4SeQ6q4vkEUzVbfE5Cx51K2UPzUBhJBDhGwAdYpCV8wJQC0uNxhvp+5+qEVIgNtEZ3j
         X54MOGk0z3uV0zyXY9AeLHXpHY1tGAxeYe9T1wOecb0KKQ4KWP+FJl/c68pBZBqqOCsQ
         Wdtw==
X-Gm-Message-State: ANoB5plavDUsqEA8Bc1mSf6ecHxP5sa48uUKsGIYjX6PYkRI7VJt94Tc
        q/2YjJFB1gt1jaHAzcNjlr7cuA==
X-Google-Smtp-Source: AA0mqf5fE3Vacmmpj6UHUhNJRTYay+k6GwahXj9M3z7LP2XRxWAFcec52559m/LXNjzl4mqcIx6smg==
X-Received: by 2002:a17:902:d4c5:b0:189:5e92:d457 with SMTP id o5-20020a170902d4c500b001895e92d457mr31365274plg.166.1669860288447;
        Wed, 30 Nov 2022 18:04:48 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 3-20020a631543000000b0044ed37dbca8sm1555354pgv.2.2022.11.30.18.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 18:04:48 -0800 (PST)
Date:   Thu, 1 Dec 2022 02:04:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/14] KVM: x86: Remove unnecessary export of
 kvm_inject_nmi()
Message-ID: <Y4gLvN9mNQQ3kMsE@google.com>
References: <20221114095606.39785-1-likexu@tencent.com>
 <20221114095606.39785-7-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114095606.39785-7-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 14, 2022, Like Xu wrote:
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 69811b4f3eac..c5ff5b05af49 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -308,6 +308,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  			    int emulation_type, void *insn, int insn_len);
>  fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
>  void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault);
> +void kvm_inject_nmi(struct kvm_vcpu *vcpu);

Same as the previous patch, kvm_inject_nmi() is declared by kvm_host.h.
