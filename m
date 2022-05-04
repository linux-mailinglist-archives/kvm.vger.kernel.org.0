Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B641519605
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 05:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344324AbiEDDgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 23:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343717AbiEDDgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 23:36:36 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7D81C10B
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 20:33:01 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id r27so329486iot.1
        for <kvm@vger.kernel.org>; Tue, 03 May 2022 20:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MD7nPH76Zo4gzIjG6XroEYb+307Sv2T97DW30QPZNvQ=;
        b=GCl3tUY0CxUSs2045e7bW3K3OMlsoVKLkDorqwMDkmosI+DarqkAsVZ4JutaruMtaq
         VqOHlcJ06uzrO/wmARYsqy4RSsfaqwdhzD3Op9C9DJ5u3WeNoYMrxGWQJqnxWPKqFL+m
         QRzSecp35sYjpDFlnSHnjh/mzL55frzR8ayJsgdjMS8lI8QEEt6j4UwSDAa+YE+WH32M
         rV3TlIsrbFgDRyNTLm2bHTDSK86J1SDHWbQss+MyAldJlcz7OomuzVdYQ23f3ar+122V
         j7OlhJvOkCtMEdVkoOKHFBAlv4QIa6gkZRCnrkWY8IjFhbXMImgVlCcrzHCLhXwUXHth
         NoIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MD7nPH76Zo4gzIjG6XroEYb+307Sv2T97DW30QPZNvQ=;
        b=JtiHpUd91siXtWVG5ETTkqgTXAr10QzSX3dkrlfoYPjT1GaGy7hPku6EJuVbT3rLUy
         KxIDVlto81Tyob6vhq6cusIrkoJxcIV1TAcJUVDevMysK+RMUEJZcEA0Jh/y8rHbSzvT
         oA35A9hg0h3An43wSX93KSrjxBkz/G854tnjUMVj9yUc8JxW6uHln8XAm4zLXodHUkAk
         ZhWMJNfY7GP6xPxvnd2bUMtnXDK4U4bSrPjxiP9Sw+OuXbgzvGrs7OBwV9gK3KsODePN
         GrAA5ysS+0lmt86rNHAoq8sZPUfh/xnvWbeAlc/OMTRRmX4MfGKyBSReV9wj2AbRH40N
         wZtw==
X-Gm-Message-State: AOAM532bV9dzpLxXCzqhqsiRRtUu0bd+7QUv5T6oHfwPZO4sJmWrcLpo
        E1cX0FYu9BMnEergP7FuRG9Q+cZGpAv1sg==
X-Google-Smtp-Source: ABdhPJy7vKJ/E6XbgDQRiEIsUnMlj/99SQ3gJhSHQZ0B1pirVzABIhS85iAuFB/rJZ2xJyY7/WLvCg==
X-Received: by 2002:a6b:2b0b:0:b0:65a:4c08:7063 with SMTP id r11-20020a6b2b0b000000b0065a4c087063mr6885026ior.92.1651635180562;
        Tue, 03 May 2022 20:33:00 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id v18-20020a056e0213d200b002cbed258dcfsm3913760ilj.0.2022.05.03.20.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 20:32:59 -0700 (PDT)
Date:   Wed, 4 May 2022 03:32:56 +0000
From:   Oliver Upton <oupton@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kernel@android.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: vgic-v3: Consistently populate
 ID_AA64PFR0_EL1.GIC
Message-ID: <YnHz6Cw5ONR2e+KA@google.com>
References: <20220503211424.3375263-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503211424.3375263-1-maz@kernel.org>
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

On Tue, May 03, 2022 at 10:14:24PM +0100, Marc Zyngier wrote:
> When adding support for the slightly wonky Apple M1, we had to
> populate ID_AA64PFR0_EL1.GIC==1 to present something to the guest,
> as the HW itself doesn't advertise the feature.
> 
> However, we gated this on the in-kernel irqchip being created.
> This causes some trouble for QEMU, which snapshots the state of
> the registers before creating a virtual GIC, and then tries to
> restore these registers once the GIC has been created.  Obviously,
> between the two stages, ID_AA64PFR0_EL1.GIC has changed value,
> and the write fails.
> 
> The fix is to actually emulate the HW, and always populate the
> field if the HW is capable of it.
> 
> Fixes: 562e530fd770 ("KVM: arm64: Force ID_AA64PFR0_EL1.GIC=1 when exposing a virtual GICv3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Reported-by: Peter Maydell <peter.maydell@linaro.org>

Reviewed-by: Oliver Upton <oupton@google.com>
