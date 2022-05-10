Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD92521151
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 11:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239132AbiEJJuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 05:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239210AbiEJJuF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 05:50:05 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4611CE632
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 02:46:07 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id j12so13002234oie.1
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 02:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o39NrF3LSVHYlVpwQr3bgKqf/zDQFHhHc4PtC81jizY=;
        b=SfCXjLw/VznGk6AzMLnh7lqE+0bjdTxIsbqedkWfVZqnAVpZe04Rtg0cAPR5Lm0vOw
         a1kDK6R6UBoc+F5Yl3KfbXmwnV6Cs4sXZNlaUnx1/SMPTpAyZQkLkF/c9D8aBrv01Iah
         tvG1ziIqkAHUJiTdG/zyHnWJUmkIImU8U2SPnPtDhy2YyWpsswc1M9nnhnmZ18vN+sZE
         jt7q/yvmNghXEQD0vNgIaZ2okgFiFQ1cF/kdeFLmaU8QY94W+1SMIvm9Jlxq+fbwdn2v
         P2tJNjrzzSCEvw3d1vtCJUmt5N51xAAbG3jSDRoljFkTgx8V7lFNvSPxaRxk90AGZSLH
         ZhNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o39NrF3LSVHYlVpwQr3bgKqf/zDQFHhHc4PtC81jizY=;
        b=w2jCLekvWWdJo6+hrf42QDIOTuigk69KjOXFAJ5TWNHSjQayma/1Gh9LlopjKXw9p1
         WKH6zeXs2DdPJWp4tLpgawJJ8RQ1sZfy/2eVt6CRLouJUbTtYV3tuSe07uN995v5l1dQ
         HVr8KqpDjOP/sE2Xe9kpJ76msUvjHiaj3SQU++jpHIQCRgnw2zHvFJVIwdiIIZp8NKEC
         v4F9xcTpqUhq4NuDOPoDobnlNRNpUD+VKFA8hlILkmlRFRuTPFWR4v2Omye1uwS0Vp9N
         KH9Su58hvRun6vhxPuuc6S1fMy6DwtRjC5lMSNiDoRv8DXHvogNuPAJs8MX/lMSOL3bt
         gjFg==
X-Gm-Message-State: AOAM530l5ijQSzyxCl4avxkRiXX+8QQsUBU2nsXN3VMdnnyyCDY/153+
        XNB87Ds9vF+AD4NZieFvjiWQkendwKXZFnXzVb6hdw==
X-Google-Smtp-Source: ABdhPJwLwLi6HfB/M1LmfOIjn+TH5lqS8GI3HaBOG4okjrcTmcuCVhyHfe6tbTsbpvj2w6SW3d8BLPBFZfrHl3Rc9Qo=
X-Received: by 2002:aca:180b:0:b0:2f7:23ae:8cd1 with SMTP id
 h11-20020aca180b000000b002f723ae8cd1mr13435377oih.146.1652175966977; Tue, 10
 May 2022 02:46:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220509162559.2387784-1-oupton@google.com> <20220509162559.2387784-3-oupton@google.com>
In-Reply-To: <20220509162559.2387784-3-oupton@google.com>
From:   Fuad Tabba <tabba@google.com>
Date:   Tue, 10 May 2022 10:45:30 +0100
Message-ID: <CA+EHjTztV9ZN4sQyS8BGxuROw4NY873LXve8LPjo417Ao6y4aQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: pkvm: Don't mask already zeroed FEAT_SVE
To:     Oliver Upton <oupton@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, qperret@google.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,


On Mon, May 9, 2022 at 5:26 PM Oliver Upton <oupton@google.com> wrote:
>
> FEAT_SVE is already masked by the fixed configuration for
> ID_AA64PFR0_EL1; don't try and mask it at runtime.
>
> No functional change intended.
>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> index 33f5181af330..3f5d7bd171c5 100644
> --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> @@ -90,9 +90,6 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
>         u64 set_mask = 0;
>         u64 allow_mask = PVM_ID_AA64PFR0_ALLOW;
>
> -       if (!vcpu_has_sve(vcpu))
> -               allow_mask &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
> -
>         set_mask |= get_restricted_features_unsigned(id_aa64pfr0_el1_sys_val,
>                 PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
>
> --
> 2.36.0.512.ge40c2bad7a-goog
>
