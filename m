Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19DE606724
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 19:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiJTRhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 13:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiJTRhW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 13:37:22 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 806DB1E3EFF
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 10:37:21 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 128so191881pga.1
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 10:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JuLFb2HYrfwzzIUJ8WPCK4Xtm71Bnu306c+MNhD3z3g=;
        b=kw8B7aaGsH6BdZi15wT/YuosuD8jdP46on61uMWy1RTl3xtFKv2nCHGNT8x3IzTk8a
         OdyIQU/djHuvQv3vXORwmlx0cGBNAQT2Yz+NSbGvsWAJTXIKSSMEr4HC5HT1HlQjdWsm
         BbdMkmuAlVVYraQGfjzqEV6dLppzemScbzcC26BVaFrA8Z7ang52uARPDNXPh8cKKPlY
         Dc1c70HiBKBM7uGqI44sGiV1lbbVGrhiRdycJdoUTIsfhmDKLfWDHRgKHMxm7iaVMIZ3
         lxerhrqRSHXDjBxFisd/rIvtZ9F7rFL7qt/pzLMu6CyqaUTgBSuNgAMB2SXx1b4RJ+K1
         NB5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JuLFb2HYrfwzzIUJ8WPCK4Xtm71Bnu306c+MNhD3z3g=;
        b=oXmLX6y/kBLbij5EAWciNIS0jpVNlTp1s82jOfDyRLtQlUls9mrUxd3/7dDw+yI9MF
         1A5RS6gqrIkX9JeQUW4ywnUumPIJ4DUyKKOMi7rfozNjEB8C4q8A76IXpiqW0tIcrd/T
         2CEQEc+dSG2+xl4vyymksgstfMSJgHp4lQa61dTGznGesEVhX2j5N10lfbXTurLGDBEN
         X0W0hfY4ZBkuONQ73df5ZVqfGCBpC3Y6OCPpXROTl8VSn3Nq8iRhhNwbGIyfVHAQOiUJ
         5vrI0HmhsV9pgjZZGjtWb69fbvpRBxdR8VX2z+AUiXkSw4EY8Ih1l5vK/8R6jHpOtgow
         fklA==
X-Gm-Message-State: ACrzQf2HX677wYfihRLeYOnOgtzMt5D5lvLnHtn+ZhkG6b+Ol856sMdv
        P1c3uCNYOzBBLt8DHFCmKvRhLA==
X-Google-Smtp-Source: AMsMyM4snBkELiQ5wjanJine7MlYwqh9G+QdRostMqbI65qSAtIXSiT2OcGiplCbheGSqRLfMCgmeg==
X-Received: by 2002:a63:5f0a:0:b0:459:537f:61d4 with SMTP id t10-20020a635f0a000000b00459537f61d4mr12531271pgb.609.1666287440933;
        Thu, 20 Oct 2022 10:37:20 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id l9-20020a170903120900b0017808db132bsm13187224plh.137.2022.10.20.10.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 10:37:20 -0700 (PDT)
Date:   Thu, 20 Oct 2022 17:37:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     yexingchen116@gmail.com
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        ye xingchen <ye.xingchen@zte.com.cn>
Subject: Re: [PATCH linux-next] KVM: x86: Replace IS_ERR() with IS_ERR_VALUE()
Message-ID: <Y1GHTIoJRLybmzpy@google.com>
References: <20221020113943.400103-1-ye.xingchen@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221020113943.400103-1-ye.xingchen@zte.com.cn>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 20, 2022, yexingchen116@gmail.com wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> Avoid type casts that are needed for IS_ERR() and use
> IS_ERR_VALUE() instead.
> 
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---

Ignoring until things get sorted out.

https://lore.kernel.org/r/Y1EVnZS9BalesrC1@kroah.com
