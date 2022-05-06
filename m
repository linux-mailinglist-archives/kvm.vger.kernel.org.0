Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C92F51DF9D
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 21:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385702AbiEFTWL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 15:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236285AbiEFTWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 15:22:09 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F206403E7
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 12:18:25 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id w1so14155444lfa.4
        for <kvm@vger.kernel.org>; Fri, 06 May 2022 12:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gq/gl/FI3wYJsrnbCzQm2bNyQ1Zxb9MLdkOQWzlXPQs=;
        b=W3zIs23sSWG8ORW1qlYtbDUPstZdw8G1+D8QTYT1TYtqO//vpXIcEcaPF2Nc3Lp38B
         gXSm/bWtZ8x2kxUzJDCyyk6ajyELFbkvOcbWKgyVckuBGH42VTsZbCpLntz/TzNupGcz
         dsui/cFSCapFC5YtMfQK/d92UVB0SQQKhzLuzI74PaSnlbOGPRDAEOEQVZc1ojfPlyAi
         h2WAFdv1J6CS4hqtchui+dlaPyW2dLDY4shPevrxJAp7dC6MwokbSp9Yj18deOv1auky
         Gan0xmQs+XCle+NxEUYT1UkIWKF4ZFJ2t8xu6PkU/5kP8qdPm9jFKjcckxkwwfkmcAIf
         xjbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gq/gl/FI3wYJsrnbCzQm2bNyQ1Zxb9MLdkOQWzlXPQs=;
        b=hL8VHQXHVgP5r1r3HL83c78ugIq1PwxtQ+e+KsY+/k+fKaVN1YnmYllfgwGFEjs70p
         wU9HmSCGkKZpP2p1iIkXGHMEQ4KtSohMIlw+sx4Z3qSSWwDfXQmS/PyH5DvuHXQ2xYFv
         8+QHsy6bxdwaO+uQ/oiIExdlNT7UHM/l8Ysk3PFDbxWpjWuyZgWuKeFIWrkR61FfaCV+
         Jvxji0kcGbkks7GPYl5o9cV8Qx6wjcJwvnp866PNcaECurKFeq3vgyYALGber7kLqgpp
         wW3PRkOhovxFoGjEr3fyQtAi15dlqKigIERqZdJEblXKV5iLf+uE09PK6sWNqDWmboWk
         65eg==
X-Gm-Message-State: AOAM533C8GIcFPaDxFKBBOWZ/Ntvk4diixBO3Q45a4pSjOAkE4thbnRN
        Ndnt4lCX5+oHawzZdc/uZg71YhDgnPA30sQrFr/PTw==
X-Google-Smtp-Source: ABdhPJyOL3mD8Xsc3l1JLJTNvCUhq8PVk6+DgYm/cn6njrwzIBFsD6kYOIC/2KdoP6kQKuXeQ9Er9jocaazqPLOT5AQ=
X-Received: by 2002:a05:6512:1287:b0:473:b904:b27c with SMTP id
 u7-20020a056512128700b00473b904b27cmr3473357lfs.361.1651864703455; Fri, 06
 May 2022 12:18:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com> <20220311175717.616958-1-oupton@google.com>
 <20220506130101.GC22892@willie-the-truck>
In-Reply-To: <20220506130101.GC22892@willie-the-truck>
From:   Oliver Upton <oupton@google.com>
Date:   Fri, 6 May 2022 12:18:12 -0700
Message-ID: <CAOQ_QshP8NH0WkyDmqbfRf--+wyWNepqSgtSq2F_AxyeB-EaHA@mail.gmail.com>
Subject: Re: [RFC PATCH kvmtool 0/5] ARM: Implement PSCI SYSTEM_SUSPEND
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
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

Hi Will,

On Fri, May 6, 2022 at 6:01 AM Will Deacon <will@kernel.org> wrote:
>
> Looks like the kernel-side changes are queued now, so please can you resend
> this series? I also think you can drop the AArch32 support, unless you see a
> compelling reason for it?

You bet. I was going to wait for 5.19-rc1 just for the dust to settle
and get a stable number for the UAPI bits. I think the ARM changes
have some light conflicts with SEV work in Paolo's tree.

All for dropping AArch32, means less work for me :-P

--
Thanks,
Oliver
