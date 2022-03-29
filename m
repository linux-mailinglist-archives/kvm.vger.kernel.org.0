Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC51C4EB4B7
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 22:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiC2Uby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 16:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiC2Ubx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 16:31:53 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C323207F
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 13:30:09 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id b15so16930412pfm.5
        for <kvm@vger.kernel.org>; Tue, 29 Mar 2022 13:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kl5DSwKqGC3U/bGYtmS8mb6P78mxyrAogm6NAxfi2Ko=;
        b=JXiVVP882Ymx8HWARqLEqO2fUJFthFgVmqtuUJWkV+UqBqJnvN+u0tcofmwZIzPgxn
         SI4dvK4fCDfnRXu+hEf/S9mbvfCX/AYrZNGk7bfoi7nEm9WDd3oNujboVVpj09oIhs1L
         YIiJ6CLX0iD/jGgs7Bn2KyaaZ0Ady8Rw4PNGWvR8gwy6fG254inOGQ1NAL9c2b3NUArp
         QyxoxkG8zroS43DnQiMyOc76zNv4VEii3KKGQBrntS2VYhf+W0S+GiHfSs6ETM5FfLwB
         5RWR1DpXaSq2jZWTPUWJw7q1qGuWRfwQ0S4iLl8wh7u7Z3ctpxryDCvOUAGlHlc4igzk
         iVOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kl5DSwKqGC3U/bGYtmS8mb6P78mxyrAogm6NAxfi2Ko=;
        b=f/5xt8MF3aCWGxBStQDfNPO/qwL0Ci0lPbc6lwQifKJmlZG9HgLTOSXGxbBbUZdh3t
         8i6FQ4VQ5xrvU9cn8bqqj/GaCyU9ZDXxxQg5evK3N0hriKi9VV57656vMT4ewxAAwkrK
         1D/9e7JDXc7MIphGV0UTEo7nQQA4PJYFZIGnLJD4EWPCIzdF1zsBoF3r/wuZJJYYVSG5
         vk39cAI/2txdASCNSngUoMBsolbK1KKpQFDv+KmU/AKw/dMYGReFlOLpgnvQj0FBfRn2
         NzpE6ZpdW1mFslCAsRollMhG5GRpl3WvcRboyMrI4LpUacIXdN8kBGEUesy2A/MrE6do
         rC7g==
X-Gm-Message-State: AOAM530suQm2747wuApxTMdRwrykUGx5FJtd9op3QlItUxBukyWdxutY
        Svr6oQoTL0ZjDoIjMvGRUWr9Sc9egIzZbTfktM0=
X-Google-Smtp-Source: ABdhPJyamOcRYfPqXQKZbO7vCaztK/sNspv617BPasRnOyCyXJUc+4gYqF/F7vzaFG7WqV14xC7zF4qjCUZ7q7Hb4p8=
X-Received: by 2002:a63:68c8:0:b0:380:3fbd:2ec9 with SMTP id
 d191-20020a6368c8000000b003803fbd2ec9mr3255952pgc.608.1648585809168; Tue, 29
 Mar 2022 13:30:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <244647ca-a247-cfc1-d0df-b8c74d434a77@amazon.com> <CAJSP0QVqvvN=sbm=XMT8mxHQNcSfNfTrnWJXXf-QgXwxAfzdcA@mail.gmail.com>
 <CAJSP0QUZS=vcruOixYwsC_Nwy2mvgeemuJimSqv98KsKr4BdSQ@mail.gmail.com> <da1dd6ee-6f3b-0470-cff3-9c2eb44d0ae6@amazon.com>
In-Reply-To: <da1dd6ee-6f3b-0470-cff3-9c2eb44d0ae6@amazon.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Tue, 29 Mar 2022 21:29:58 +0100
Message-ID: <CAJSP0QVrhzuso+=Wdt=mnkc04L332cnW4BmOL-OqA3e8cQCrnw@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Alexander Graf <graf@amazon.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Hannes Reinecke <hare@suse.de>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Alex Agache <aagch@amazon.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Snow <jsnow@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>, ohering@suse.de,
        "Eftime, Petre" <epetre@amazon.com>,
        Andra-Irina Paraschiv <andraprs@amazon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Mar 2022 at 13:36, Alexander Graf <graf@amazon.com> wrote:
> Petre literally pointed me to the fact that the project did not end up
> on the wiki page a few hours ago. I added it and augmented the bits
> above. Please let me know if you see anything else missing! :)

Thanks for posting it!

Stefan
