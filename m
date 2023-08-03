Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F5976DBEA
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 02:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbjHCAEf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 20:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbjHCAEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 20:04:34 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCAF31FF3
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 17:04:32 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-56cf9a86277so2838267b3.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 17:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691021072; x=1691625872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LR0gUEb+d6vy/5/y9RMKjoX8S1s9lNuEvXexoSjnakA=;
        b=mmgJMTFbNK1UJLZG91k+s3kKc02NlqCqOqm9/Rt+hQZC1xWfzWPpJMwGjRTAK9AT9n
         j+YjF3UFUuxj2nkUCBDQAwZI5KD4VJjElfYp63zp2NNshxSxCntd5oeAPWfxHnvVyVxO
         PILo3oax+rCaVAG/v5Ldi/47eXsqGepKU9N9EGyPZb4CI5LOTsojP2b7fi3M6ijfAUFL
         +vS1pSEvSs/hhNbiYKuy+qCZwfsns7HTcCRc/D25F9xSSL+ffm3n5MsBCyGnXNhuRzKC
         yVPiAcgeoQpGwZtYjcTmH+sB96uf0cdm4nQxSl+mWfgUciguG9gz/GoZQvyI5YPfMRRH
         /O/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691021072; x=1691625872;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LR0gUEb+d6vy/5/y9RMKjoX8S1s9lNuEvXexoSjnakA=;
        b=ZTO5IwyxSsGyAHLnioaXkm4QvkmAiFjz4nPA6Fo9I9DdOFPbyr2RBCM8Nzo72kNFhs
         ps1rezzSQolzTkaas9lGAXAX3fTPjebHtxloegXz+4AtJFffl4hA4QKylkAGfnq3Date
         h8dnR9lNbJeLKCY82VtvE7KA9DybGPNTPmSDZE5DsOVnsyk/xGdZMhqndTHDeR62Bd+W
         u1W17QrAL3T7Nk4BFl7y3ZzELntVsqrM0RRYvZeQC2AY/OjhdyjoN4Y7fpqipBuY4NDj
         ktiuNNRuIWAj7QGgjBh2lfoz7FnqXwD2TAmmZZ8YY7uVNDcQKZBYWAswiuej+zlAcGtX
         E6gA==
X-Gm-Message-State: ABy/qLY9aFnboFwLqvfDm6EDebsFeXzTF4Lj1u+6qY1FbFc8d9ZnPc+t
        vMNeLdd5TtGBDnwZ+1DlUT/L9D7PhK4=
X-Google-Smtp-Source: APBJJlEEHT176Tb6k+4ZInXk/ZHuEE9moC04ehkMkZpfTjR+ogtPHHqlEwz2ILItO0honvBCgpQc+8MWR+k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c609:0:b0:570:b1:ca37 with SMTP id
 l9-20020a81c609000000b0057000b1ca37mr159089ywi.5.1691021072079; Wed, 02 Aug
 2023 17:04:32 -0700 (PDT)
Date:   Wed,  2 Aug 2023 17:04:14 -0700
In-Reply-To: <20230712183136.85561-1-itazur@amazon.com>
Mime-Version: 1.0
References: <20230712183136.85561-1-itazur@amazon.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169101763292.1822238.2978170484113965893.b4-ty@google.com>
Subject: Re: [PATCH] KVM: pass through CPUID 0x80000005
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takahiro Itazuri <itazur@amazon.com>
Cc:     Takahiro Itazuri <zulinx86@gmail.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jul 2023 19:31:36 +0100, Takahiro Itazuri wrote:
> Pass CPUID 0x80000005 (L1 cache and TLB info).
> 
> CPUID 0x80000006 (L2 cache and TLB and L3 cache info) has been returned
> since commit 43d05de2bee7 ("KVM: pass through CPUID(0x80000006)").
> Enumerating both 0x80000005 and 0x80000006 with KVM_GET_SUPPORTED_CPUID
> would be better than reporting either, and 0x80000005 could be helpful
> for VMM to pass it to KVM_SET_CPUID{,2} for the same reason with
> 0x80000006..
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: pass through CPUID 0x80000005
      https://github.com/kvm-x86/linux/commit/af8e2ccfa6f1

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
