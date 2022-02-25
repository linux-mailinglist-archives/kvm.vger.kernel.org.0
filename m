Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247E04C44B4
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 13:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbiBYMju (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 07:39:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbiBYMju (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 07:39:50 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF1F1D97FA
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 04:39:18 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id ay5so1886443plb.1
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 04:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nn4VPSsQYQOMEMMN7BFTuP31EPiRMpkNtye61ZMxpro=;
        b=QdhreaU4spdu6fpoE4k1DOvYqxJH8++Fr9y2h824A1G7AnjHrU1MkJ9MQQnGqys6UE
         unZg9z+l3v8CAvhMj745rcPCcUnhW0ur26U0i61cLr025QA5qcO052OCwX8IEV0iXHjL
         O0EQT2ZqHCpR/kmLj6XSEGitTbHTW8kiHL1upF5CQ5b9n59CZ4gFbvNNO6iGj+tm67jT
         nbE+QexwSV1oKDqXjAAT2NaxcmfKqglf7B5VfcJqQUEaLf7IYvo/RK6tHMNXeA7DVfJn
         0zSS2hc/soMV87iM4pfjvKHtN7PTld10awXV3riLIsKdMxqQNm8b7L/pR4vJ00HTazk3
         3l3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nn4VPSsQYQOMEMMN7BFTuP31EPiRMpkNtye61ZMxpro=;
        b=io4kCw83Cnna+ryYqe5GcB6+7EFlNuX4m7nBqzFjmxtgiyB6O/xK+MAvYTd3HfJkFe
         YhpZM53WEYJlq1UXm1u6lXXdsstu09Ie+kdDHRecZFczIOjyYPWGkMQDcPytSbQJ8FI1
         fm85o0iAUD2BerUXb7W/OY8bOuhplHu40NVJXjK0djZC9ZL5omvRWAe7MFOc4xHWI7MW
         P541VZTcY1PL01bw1isthDcE8T47NPb0pkkNi2w06zKqvWHePxo8PUYbKA2dztiXbWeh
         RdzoNYEVrGbhQ2J9abINdSEH81spZDJDyPwZ1hcRWOEZp7jbejuYHqYBcRKGGW4ym8tA
         GUTA==
X-Gm-Message-State: AOAM5323Ap0jmLydK1XgP74BItsqERyXR4txPiaN0Xa4C0o88DtlSuDl
        2v3NBaxpm5gpLgXAh4B3+gvf27FFYpoNJ8ehTRI=
X-Google-Smtp-Source: ABdhPJySf8E24Qj66QVY/C18YHKkZ7fEJPmGgNBgO4s0OgZDn6WUB397GsP1VBOw3zrgS4XMEaqJc1c6cuNOhVMISyg=
X-Received: by 2002:a17:90a:d3d0:b0:1bb:f5b3:2fbf with SMTP id
 d16-20020a17090ad3d000b001bbf5b32fbfmr3009006pjw.87.1645792757974; Fri, 25
 Feb 2022 04:39:17 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <YhMtxWcFMjdQTioe@apples> <CAJSP0QVNRYTOGDsjCJJLOT=7yo1EB6D9LBwgQ4-CE539HdgHNQ@mail.gmail.com>
 <YhN+5wz3MXVm3vXU@apples> <CAJSP0QXz6kuwx6mycYz_xzxiVjdVR_AqHnpygwV4Ht-7B9pYmw@mail.gmail.com>
 <20220222150335.GA1497257@dhcp-10-100-145-180.wdc.com>
In-Reply-To: <20220222150335.GA1497257@dhcp-10-100-145-180.wdc.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Fri, 25 Feb 2022 12:39:06 +0000
Message-ID: <CAJSP0QXQr1UBX9S_0QzwO89wLcTyBe+rofTY6+dyUNHvvDyPzA@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Keith Busch <kbusch@kernel.org>
Cc:     Klaus Jensen <its@irrelevant.dk>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
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
        Stefano Garzarella <sgarzare@redhat.com>
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

On Tue, 22 Feb 2022 at 15:03, Keith Busch <kbusch@kernel.org> wrote:
>
> On Tue, Feb 22, 2022 at 09:48:06AM +0000, Stefan Hajnoczi wrote:
> > On Mon, 21 Feb 2022 at 12:00, Klaus Jensen <its@irrelevant.dk> wrote:
> > >
> > > Yes, I'll go ahead as mentor for this.
> > >
> > > @Keith, if you want to join in, let us know :)
>
> Thank you for setting this up, I would be happy assist with the cause!

Hi Keith,
I have added you as co-mentor. Thank you for participating!

Stefan
