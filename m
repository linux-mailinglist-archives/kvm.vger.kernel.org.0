Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D754B428F
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 08:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241167AbiBNHLp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 02:11:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbiBNHLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 02:11:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04360583B9
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644822696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5//e4K4mgU3g8+NZl+6kzGrvE+Xni9sFEdvh5YsZSgI=;
        b=HB1Psy5lpwqII4ImGpaAsE0uZTOn098Pwi+6ftxDaVZBQjWcMU8WgFcWy668A9C5Bqz/ZK
        kOWMV8XvRV8iakrvyQBn9rzPkTkCs5S4OPPBSUdB9jHRiO3nX/7EDLkW0LJ5OdRKXASS1l
        HzyIZJcw35MlykH3siJeXY9qch6ZdZY=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-220-K7sUfy1gM1y_nDwxjdsXrQ-1; Mon, 14 Feb 2022 02:11:34 -0500
X-MC-Unique: K7sUfy1gM1y_nDwxjdsXrQ-1
Received: by mail-lj1-f197.google.com with SMTP id p10-20020a2ea4ca000000b0023c8545494fso5350571ljm.2
        for <kvm@vger.kernel.org>; Sun, 13 Feb 2022 23:11:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5//e4K4mgU3g8+NZl+6kzGrvE+Xni9sFEdvh5YsZSgI=;
        b=DU4c1dsAb0PmxxgWC6ZNgpw3pog7BeZNv/lKKN9komVyj5j6hZeBKy0oeW78HMxa5s
         cyk4ecepzEXEuDBD9gdhTXp/vx6QAUH6NDBD+CKnNBD+6FkRr2n0O5DDtwkFrwfovCJ9
         Y3vRqfpazp6RjbtLTpPt/4UPy1gJdyf9dwTyFjKlirtPsocUU9rf+iXP/x4S91pHTvb+
         as1lpG8aBWiRo/uuK+pJpqEnlC03p/bcNZOzmQCA1XOIU3ZP9UNIMz3ibrLgv9LRJ6wy
         21yJbEK6qeDwkG1A2IrT4/wVbSzas+Qtglpx4rriylmLi1UNsv2zb5tueSKR1vsbQ4+T
         NADg==
X-Gm-Message-State: AOAM532WFE3yyfvuEmADHUhLQDegNK5zU6Y9JnWGO2kMx0AnTh7UFFes
        UC7C7cyR0Hempskyl1qQa30tQiaZRgaid7eUDeo1uBODoeB1YH51gbtY7Tp08HmEm/wE86GVMWc
        maFU7KIJr7fYvtnVJm+q1yvDXS5cQ
X-Received: by 2002:a05:6512:2342:: with SMTP id p2mr6130986lfu.348.1644822692854;
        Sun, 13 Feb 2022 23:11:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwyYX4EV0IPlJLhqf1/sIinuK+GaIKxwcNo+DeQDQqzCQken0irQ++50m+rtF4hqOLZJVZB/oBw6230zP+VdFY=
X-Received: by 2002:a05:6512:2342:: with SMTP id p2mr6130966lfu.348.1644822692666;
 Sun, 13 Feb 2022 23:11:32 -0800 (PST)
MIME-Version: 1.0
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
In-Reply-To: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 14 Feb 2022 15:11:20 +0800
Message-ID: <CACGkMEvtENvpubmZY3UKptD-T=c9+JJV1kRm-ZPhP08xOJv2fQ@mail.gmail.com>
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        John Snow <jsnow@redhat.com>, Sergio Lopez <slp@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
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

On Fri, Jan 28, 2022 at 11:47 PM Stefan Hajnoczi <stefanha@gmail.com> wrote:
>
> Dear QEMU, KVM, and rust-vmm communities,
> QEMU will apply for Google Summer of Code 2022
> (https://summerofcode.withgoogle.com/) and has been accepted into
> Outreachy May-August 2022 (https://www.outreachy.org/). You can now
> submit internship project ideas for QEMU, KVM, and rust-vmm!
>
> If you have experience contributing to QEMU, KVM, or rust-vmm you can
> be a mentor. It's a great way to give back and you get to work with
> people who are just starting out in open source.
>
> Please reply to this email by February 21st with your project ideas.
>
> Good project ideas are suitable for remote work by a competent
> programmer who is not yet familiar with the codebase. In
> addition, they are:
> - Well-defined - the scope is clear
> - Self-contained - there are few dependencies
> - Uncontroversial - they are acceptable to the community
> - Incremental - they produce deliverables along the way
>
> Feel free to post ideas even if you are unable to mentor the project.
> It doesn't hurt to share the idea!

Implementing the VIRTIO_F_IN_ORDER feature for both Qemu and kernel
(vhost/virtio drivers) would be an interesting idea.

It satisfies all the points above since it's supported by virtio spec.

(Unfortunately, I won't have time in the mentoring)

Thanks

>
> I will review project ideas and keep you up-to-date on QEMU's
> acceptance into GSoC.
>
> Internship program details:
> - Paid, remote work open source internships
> - GSoC projects are 175 or 350 hours, Outreachy projects are 30
> hrs/week for 12 weeks
> - Mentored by volunteers from QEMU, KVM, and rust-vmm
> - Mentors typically spend at least 5 hours per week during the coding period
>
> Changes since last year: GSoC now has 175 or 350 hour project sizes
> instead of 12 week full-time projects. GSoC will accept applicants who
> are not students, before it was limited to students.
>
> For more background on QEMU internships, check out this video:
> https://www.youtube.com/watch?v=xNVCX7YMUL8
>
> Please let me know if you have any questions!
>
> Stefan
>

