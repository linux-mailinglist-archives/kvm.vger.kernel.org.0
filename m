Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6364B8674
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 12:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiBPLHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 06:07:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiBPLHv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 06:07:51 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DDE85665
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 03:07:39 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id f8so1834828pgc.8
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 03:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dr+mK0gB/C7qR/65uSuIEgdeMD41A0CvZfkOdwO/mlQ=;
        b=z6iIg0mfre2pK9L0Zt9FVFwMXJ8EVsqD9hHWeTv/xtbWSsyqq/sAfVObS9yKXxXhhW
         xiFwpfiwrL/032/EI/vJx8hQT0vvAlOPcudAjYpXh9yWIEbusnzwnHb8YWNUfOQrlM4u
         mEbD7g8ERwuwyZyZUDEC6P1BytumgBBUGoklTKVpk3NNgBfUw43zr9gAQ9mzThK1qxc4
         orqgKTkaKMI4WsbEvO69obnYLnzX0ZPQOoQsQ6SON6xbs6STl3+Xo+iTnIjHfiEBBWNJ
         FWCKPM7L8lhMMqVPfkvXFvYYH7OQ39e8frt+7RhXkHQencpArGrsAcb30zXMXZR3Fi9k
         rkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dr+mK0gB/C7qR/65uSuIEgdeMD41A0CvZfkOdwO/mlQ=;
        b=jO2hq9YvUWCI9TXUxR63j0O/53AJwMoCwrGPxMl9T08Jlwc0GYPrhdCYed25slCVHE
         H+vinbFU9NfUDvvOAk0ELMPCgf5uccBWpcwVnNsuhA1Y+JSC68g0OMiqerycKXt6Hxva
         /hxgnUnMKgLsdC0o/NSDlz0U+oR1GBD38OMQP5QRb3Wb4FJasty7/K3dZyYvJG04nSyS
         XzHuwjgRukNMWoJJw9E/ZZtIxp4Lkrm70/xfyUlc8stLUj1ifmuIiT7BwaevJDnm7TBb
         dDC5PFhhrUufWGfhU1EkydoRM3RtxBna8HpLFS2pEg8Jbe/7jtonsq/g+W0mUAZzP03u
         z62w==
X-Gm-Message-State: AOAM532zN9dwxn6x5Y++5MeB1UW02PjNzXqfIZHRIj04xtjZZjyyLZJR
        mKYAqbx4TwwuwterdVEcceiq2BI1K9C3SQ6c9RTNyw==
X-Google-Smtp-Source: ABdhPJwNLDiBSehq74dK4IGgxebzS7Riraxx+yNt5ZKrz4esY5pdw2MlYVOMk0LYD7pif5ANXEpd4wvPDrFrPx8fzmc=
X-Received: by 2002:a65:41c3:0:b0:363:5711:e234 with SMTP id
 b3-20020a6541c3000000b003635711e234mr1831683pgq.386.1645009658930; Wed, 16
 Feb 2022 03:07:38 -0800 (PST)
MIME-Version: 1.0
References: <20220216043834.39938-1-songmuchun@bytedance.com>
 <YgzZGDscKEh1uAS0@monolith.localdoman> <YgzZZvjOAEWwaoO8@monolith.localdoman>
In-Reply-To: <YgzZZvjOAEWwaoO8@monolith.localdoman>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Wed, 16 Feb 2022 19:07:00 +0800
Message-ID: <CAMZfGtXGAvNymGD+ZK1pzkdkOof8iYTu+my8DO9hO+JveYqqLA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH kvmtool 1/2] kvm tools: fix initialization
 of irq mptable
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 16, 2022 at 7:00 PM Alexandru Elisei
<alexandru.elisei@arm.com> wrote:
>
> Hi,
>
> Forgot to add, would you mind rewording the commit subject to:
>
> x86: Fix initialization of irq mptable
>

Will do. Thanks.
