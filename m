Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D7C4B64BC
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 08:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbiBOHtG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 02:49:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234974AbiBOHs7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 02:48:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C499190FD6
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 23:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644911328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qf0f3GqY7XJOGRvGn1MQtRPKB9lVAUr7eFd/kUGMfaw=;
        b=NGqvG+tjtldrRg6weIUDSTyVlD6cnlpfM4kA7hkZZ3yZN9RW7AnjAkKMd6VgfmoXZCDcpx
        Cu8gsyWWfvijswrciLSRglWLqFaXqK4SyKJruBcOYjtRcaDMEVxD5yLS4NXV6IdPbRuGg7
        CrV/Lg9gG68bhPExLuJc+p6eGFgxcbA=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-ajsb9iErO5eGu-MvB3qiLA-1; Tue, 15 Feb 2022 02:48:47 -0500
X-MC-Unique: ajsb9iErO5eGu-MvB3qiLA-1
Received: by mail-lj1-f199.google.com with SMTP id by12-20020a05651c1a0c00b00244bf726482so2181313ljb.0
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 23:48:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qf0f3GqY7XJOGRvGn1MQtRPKB9lVAUr7eFd/kUGMfaw=;
        b=Wf29oU+Nvf5o310nF3BCLlxaVJqyIUFiaRrNj4x+FlkwGC5m0W7mo/Lg6dWN/CDw+H
         TtvbCheKnJ7vodPZkt+E8tOnAGAehVrpB8MCZWIyg25h2pYYrZtil58+TZ10DXLF8v3M
         K32CwCpLSNFgtvv7w88Imw/1mH3P6U3NZIy+FxSKQUV6MKc3Fj/ULYmtSg2+ZGbGnuyz
         mfGoc/qyCNp0UwsXzKoAa61/niQ2KAOxrGqWElQTBpxQIcHqB0WeAzTWIVg9qFR6mit1
         6izv1ErTZ2bJxKaLPZ3uPDDYPw7CcyZfddlb0FZlOT68V4XhJvPWzYGJrHK1e6gOmf+m
         B77A==
X-Gm-Message-State: AOAM5317nyOY5esE7OYTSoYV0Zmil9EJ+ZG98Z9puue/VcsgT1+5Cgj5
        GUI6DBxeDehSO2CDkZR9+XCAyXSM6BCLBnzdaOG60niwrxK9lWGKjYkbvEB6VWOLwZ1xNl5hzY5
        oNIHNE812K/HmY3dpZ77g+grzEW3j
X-Received: by 2002:a2e:914c:: with SMTP id q12mr1701362ljg.420.1644911326007;
        Mon, 14 Feb 2022 23:48:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJypmK6UTHFl1ejOt9kDQsNxXoTtuMZRRFPEr4rUWc75hnD/F/KZVQzSNtRIDOFvz8w/q/0Eg42UbQsbRzx2v/8=
X-Received: by 2002:a2e:914c:: with SMTP id q12mr1701351ljg.420.1644911325842;
 Mon, 14 Feb 2022 23:48:45 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <CACGkMEvtENvpubmZY3UKptD-T=c9+JJV1kRm-ZPhP08xOJv2fQ@mail.gmail.com> <20220214114825.pi44m7mqyqvvtt52@step1g3>
In-Reply-To: <20220214114825.pi44m7mqyqvvtt52@step1g3>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 15 Feb 2022 15:48:34 +0800
Message-ID: <CACGkMEsqTRP18Sp5zAy9tUOcsMNx+MwrkeqnMXg=2sS58MrsUQ@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        John Snow <jsnow@redhat.com>, Sergio Lopez <slp@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Alex Agache <aagch@amazon.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 7:48 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Mon, Feb 14, 2022 at 03:11:20PM +0800, Jason Wang wrote:
> >On Fri, Jan 28, 2022 at 11:47 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
> >>
> >> Dear QEMU, KVM, and rust-vmm communities,
> >> QEMU will apply for Google Summer of Code 2022
> >> (https://summerofcode.withgoogle.com/) and has been accepted into
> >> Outreachy May-August 2022 (https://www.outreachy.org/). You can now
> >> submit internship project ideas for QEMU, KVM, and rust-vmm!
> >>
> >> If you have experience contributing to QEMU, KVM, or rust-vmm you can
> >> be a mentor. It's a great way to give back and you get to work with
> >> people who are just starting out in open source.
> >>
> >> Please reply to this email by February 21st with your project ideas.
> >>
> >> Good project ideas are suitable for remote work by a competent
> >> programmer who is not yet familiar with the codebase. In
> >> addition, they are:
> >> - Well-defined - the scope is clear
> >> - Self-contained - there are few dependencies
> >> - Uncontroversial - they are acceptable to the community
> >> - Incremental - they produce deliverables along the way
> >>
> >> Feel free to post ideas even if you are unable to mentor the project.
> >> It doesn't hurt to share the idea!
> >
> >Implementing the VIRTIO_F_IN_ORDER feature for both Qemu and kernel
> >(vhost/virtio drivers) would be an interesting idea.
> >
> >It satisfies all the points above since it's supported by virtio spec.
>
> Yep, I agree!
>
> >
> >(Unfortunately, I won't have time in the mentoring)
>
> I can offer my time to mentor this idea.

Great, thanks a lot.

>
> Thanks,
> Stefano
>

