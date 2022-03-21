Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BD64E2B32
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 15:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349603AbiCUOtt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 10:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349595AbiCUOtr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 10:49:47 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C82327
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 07:48:21 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so8502864wmp.5
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 07:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bFhU+rZgEfiv8O23GnLnrLSsuMnAwmtdAvy7cCR3e/k=;
        b=A2nDJHwSfnvFsdjaA2e7e/YwV6c2r9ZO1BeQiLHQmbRa8wSso3PKRHS6Gp4aG3ib5p
         1V3EtSSMJFktxRXaIh0o3qrzBDLoamKUx9KeQ7qfU+52va5kSXVojoxZh2ZWC0uVA49d
         KKkttWPplnOUaXPp157NvwnStY9QG8csnK5ag7p1Wzps7rE2Y2l2+h8CHFD4vgUTxvUx
         lttrGTCfdXDZdFtOqdybCKewH9p74W6NfL21Cr7gkeK15pb34S9ux/VsuJpql4Ogi+v+
         GQQDRugY0nf6Rk6PUvWm4BBeJzZ3qIeBiAhcpt/MsiDjmqI5636q+YSb5zvr3XuOCn0F
         OU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bFhU+rZgEfiv8O23GnLnrLSsuMnAwmtdAvy7cCR3e/k=;
        b=qw/9jTmPl1DBX1UuM+91mA7TsGrWgOtxARntdRCU7JvSKOiC0IheTi/jd1xugPk2Hh
         6jAUieEx7gqQcNaWolL15Y9zfAtBU2IqSTTtGYQbnfbldr+alThDl1JbhC7Mx5Z75Gyd
         5AGumF4KWUbRRDSghBahiBZ6pstSMgApYlV5X1h3iHVSMWeGh7dXSzXpu/rxdCuA2U5s
         MA07PVZ532ZHAjSxjzlTFgaIjhqvxfd9gY0XZd+PzoPDorvu8+kx7KWYo6ymdFi68NFV
         H3NXOrjb37C7cH7j6twpVkv6XxY6KD7obLK1RoSDxH6cQpqm19YnGKhpjb/gkJujuiIa
         NsAQ==
X-Gm-Message-State: AOAM530hY6zGp467o+gI+MDJa4KlStSTZRXAZD4PA6SciZPt4d3FhGsJ
        FSBCYG8tPfcvq4YXXprvnBHr2A==
X-Google-Smtp-Source: ABdhPJxB5iHvdAjrxu64jAX1z6vyH3waDtzEIBY7un4f+0PDKIQPgFYrfaWu7VD7Aihubxxz/1u45w==
X-Received: by 2002:a1c:7313:0:b0:38c:8690:1f30 with SMTP id d19-20020a1c7313000000b0038c86901f30mr16165668wmb.188.1647874099992;
        Mon, 21 Mar 2022 07:48:19 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id i35-20020adf90a6000000b00203e767a1d2sm11746467wri.103.2022.03.21.07.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 07:48:19 -0700 (PDT)
Date:   Mon, 21 Mar 2022 14:48:18 +0000
From:   Sebastian Ene <sebastianene@google.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvm@vger.kernel.org, qperret@google.com, will@kernel.org,
        julien.thierry.kdev@gmail.com, maz@kernel.org
Subject: Re: [PATCH kvmtool v11 0/3] aarch64: Add stolen time support
Message-ID: <YjiQMhbPF5oO0ZS8@google.com>
References: <20220313161949.3565171-1-sebastianene@google.com>
 <20220321140039.GA11036@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321140039.GA11036@willie-the-truck>
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

On Mon, Mar 21, 2022 at 02:00:39PM +0000, Will Deacon wrote:
> Hi Sebastian,
> 

Hello Will,

> On Sun, Mar 13, 2022 at 04:19:47PM +0000, Sebastian Ene wrote:
> > This series adds support for stolen time functionality.
> > 
> > Patch #1 moves the vCPU structure initialisation before the target->init()
> > call to allow early access to the kvm structure from the vCPU
> > during target->init().
> > 
> > Patch #2 modifies the memory layout in arm-common/kvm-arch.h and adds a
> > new MMIO device PVTIME after the RTC region. A new flag is added in
> > kvm-config.h that will be used to control [enable/disable] the pvtime
> > functionality. Stolen time is enabled by default when the host
> > supports KVM_CAP_STEAL_TIME.
> > 
> > Patch #3 adds a new command line argument to disable the stolen time
> > functionality(by default is enabled).
> > 
> > Changelog since v10:
> >  - set the return value to -errno on failed exit path from
> >    'kvm_cpu__setup_pvtime' 
> 
> Thanks. I've applied this, but I think it would be worth a patch on top
> to make the new '--no-pvtime' option part of the 'arch-specific' options
> rather than a generic option given that this is only implemented for
> arm64 at the moment.
> 
> Please could you send an extra patch to move the option? You can look at
> how we deal with the other arm64-specific options in
> arm/aarch64/include/kvm/kvm-config-arch.h for inspiration.
>

Thanks for the feedback, I will add it as an arm64-specific option.

> Cheers,
> 
> Will

Thanks,
Sebastian
