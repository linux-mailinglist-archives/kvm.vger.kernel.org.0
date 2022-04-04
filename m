Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26CE54F0F0E
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 07:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiDDFag (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 01:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245198AbiDDFae (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 01:30:34 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F051CB11
        for <kvm@vger.kernel.org>; Sun,  3 Apr 2022 22:28:38 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id r2so9935088iod.9
        for <kvm@vger.kernel.org>; Sun, 03 Apr 2022 22:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4vQFrjglrchZfWnBhpFno0OG8+JYEPYgRfkxp+2Eq7o=;
        b=LiOBtM7e9EsGoXdzZHjt3VAlfi+P8jggYvXUvinv1GwvKXhD/C1MVwLT0WYFC4rAGp
         jmol3SXOFoa4Z4ooFSn6wsQKtk8C3Lub7I7baeX4E74lH/ovookztTEfvijFA4NvE4yk
         Wjt7jhgVAkfRGf4TYEeICMrubHLMEH3B+edLHVG3HJr27PFedThMd11inj5vbzFOhq96
         vBZU9QHgDlLdKkJugc7xPxBG/N9cSEvyLt5EBYWMKySVdKf7U4oUVmzo38Mv4CikzJr+
         w1TfMl2QfEk6pVs4s09A2AqAYL6GMRWZoMh4P8xfkPK2EgaK2cujVFdvqxTkGY1/5ON9
         rMiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4vQFrjglrchZfWnBhpFno0OG8+JYEPYgRfkxp+2Eq7o=;
        b=xwh6i4A3nbyt3zFqorRK5kX1zokxt46QJMPwHd/O9uDV3V4NMwDJYk73DMDKRm+fSZ
         SxKry9UB8jm7hmDxPYX0IRZAIb+lqmYne9+OdZ0cH5kq5SjE928dydMLoa7ofW/oeUch
         UTOYLuk3vJECWO1+FXRLkGiUbXakGnDmXKpz5T4qAB4kBggNvi9em+ULYkdSkao8vQ9K
         xDU3Mox3jrg73U3GyDggRDAQMgWc7VZuFGIeu1XzESbxpZaB0LpxlPVQJ5kJeLofSDd1
         yhLlFXPCZTy92+ftPtEG4RXQldmY9ZCph+whsVzB13s9KAx47lh+3uwvTJSxFI6RRSX1
         99Rw==
X-Gm-Message-State: AOAM532USAo4qGf92J43ryDwk+qHQrIk5+DjmgYIVJ1gdY9Z8+7EobVN
        RzukGJEF6a3uic6WvbxHygGRE1+EF62dsA==
X-Google-Smtp-Source: ABdhPJwnrz63bQuIY0Qz/p4MN+rMjCvcRj6uMmNM+SGy8AWlCr6QKV0I4658w5YLbDhl2gu2ASyxBg==
X-Received: by 2002:a02:224d:0:b0:321:370b:6d59 with SMTP id o74-20020a02224d000000b00321370b6d59mr11248053jao.104.1649050117857;
        Sun, 03 Apr 2022 22:28:37 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id u10-20020a92da8a000000b002ca48fff4c7sm435056iln.13.2022.04.03.22.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 22:28:36 -0700 (PDT)
Date:   Mon, 4 Apr 2022 05:28:33 +0000
From:   Oliver Upton <oupton@google.com>
To:     Reiji Watanabe <reijiw@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH v2 2/3] KVM: arm64: Plumb cp10 ID traps through the
 AArch64 sysreg handler
Message-ID: <YkqCAcPCnqYofspa@google.com>
References: <20220401010832.3425787-1-oupton@google.com>
 <20220401010832.3425787-3-oupton@google.com>
 <CAAeT=FxSTL2MEBP-_vcUxJ57+F1X0EshU4R2+kNNEf5k1jJXig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FxSTL2MEBP-_vcUxJ57+F1X0EshU4R2+kNNEf5k1jJXig@mail.gmail.com>
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

Hi Reiji,

On Sun, Apr 03, 2022 at 08:57:47PM -0700, Reiji Watanabe wrote:
> > +int kvm_handle_cp10_id(struct kvm_vcpu *vcpu)
> > +{
> > +       int Rt = kvm_vcpu_sys_get_rt(vcpu);
> > +       u32 esr = kvm_vcpu_get_esr(vcpu);
> > +       struct sys_reg_params params;
> > +       int ret;
> > +
> > +       /* UNDEF on any unhandled register or an attempted write */
> > +       if (!kvm_esr_cp10_id_to_sys64(esr, &params) || params.is_write) {
> > +               kvm_inject_undefined(vcpu);
> 
> Nit: For debugging, it might be more useful to use unhandled_cp_access()
> (, which needs to be changed to support ESR_ELx_EC_CP10_ID though)
> rather than directly calling kvm_inject_undefined().

A very worthy nit, you spotted my laziness in shunting straight to
kvm_inject_undefined() :)

Thinking about this a bit more deeply, this code should be dead. The
only time either of these conditions would happen is on a broken
implementation. Probably should still handle it gracefully in case the
CP10 handling in KVM becomes (or is in my own patch!) busted.

> Reviewed-by: Reiji Watanabe <reijiw@google.com>

Appreciated!

--
Thanks,
Oliver
