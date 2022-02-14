Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72BCA4B5200
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 14:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354549AbiBNNmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 08:42:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349004AbiBNNmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 08:42:36 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8D06B66
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 05:42:27 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id h6so26912732wrb.9
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 05:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version:content-transfer-encoding;
        bh=pnQHgkexYs4YcfYqLfNWqtHK/S9Aw9KOlNDzfmwnM7o=;
        b=ztfWeddK85MC+RcmRlDHTVeozBymz58K/e9i7O6tsPCZjGBdoPMMjwzfpVXT3XWDB8
         V5D3kNFfr2J/cGW+TFdNj5h5JDaZkMzOxTbAur+wCIWlwePrT3/64C5/fP/XqN+n8y+w
         OmyAX9pLsHNo13ffPFJ2hSvpiunVbfm3/7mdv8V3LX0iVbqugdvFubaDX2hBvBN2ekRs
         0MAoi1BKh73Y5mFchhbDxpaLV0sHEn5htV7w380DmCozI5poIdtiuTegNQUunqkn5TKq
         1B+k/vruTy7lTjqU3MgKsNRGRloxjWsKLNEUKrroDpp0G3kMETMvIBUcPRHTl3E8UMsT
         vdwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version:content-transfer-encoding;
        bh=pnQHgkexYs4YcfYqLfNWqtHK/S9Aw9KOlNDzfmwnM7o=;
        b=3Fbl7ff3Xc6QZAZdZwvv/LBsjcGmlihiOrD0/S2auI2js+LZic0KqRCZ5rtgFM5G/f
         h3/HYlhn662NrUyXtfgRNxwi2fOLv4aCzBHv6fOGgI0ZCIhuvun+x3saqn7rPInysxNK
         H2OxyZNHAToG7RbG7W/dM37ZVyxrIdM+PjNJWDRSCq8fIdUOrx5xalNpedvhBoXkhL4O
         6Y9rvN1BNSrj4mr8F2Qr0eXV5vJ4/ZMd26oOfu1fWyetXSTcNwTv6CHFd1u3o7cpMUVu
         3ZYrtcQVuLdj0ZPgKEK0COc8AdZS0UiwTnCHYTna9sq/fWeFdbxDQvzM3Wklg07aVFiD
         /oow==
X-Gm-Message-State: AOAM531X3tzSp+k9sLWiaIcSKYBcLYK80M2qq3A6a66GQ78klQEzgxx6
        aic971SNqK0Dyb1rWluPLFndYA==
X-Google-Smtp-Source: ABdhPJwUK+KknkkGx/YCKtD3Oo46jjY1c/E1ME6NWB+I1c8iEAayzVzlePJarG8lE9RSSL4GcBfuPQ==
X-Received: by 2002:adf:ce87:: with SMTP id r7mr10964358wrn.397.1644846146257;
        Mon, 14 Feb 2022 05:42:26 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id b2sm4376184wri.35.2022.02.14.05.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 05:42:25 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 5882620329;
        Mon, 14 Feb 2022 13:42:24 +0000 (GMT)
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
User-agent: mu4e 1.7.7; emacs 28.0.91
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        Rust-VMM Mailing List <rust-vmm@lists.opendev.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        John Snow <jsnow@redhat.com>, Sergio Lopez <slp@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Florescu, Andreea" <fandree@amazon.com>,
        Alex Agache <aagch@amazon.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
        hreitz@redhat.com
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
Date:   Mon, 14 Feb 2022 13:16:36 +0000
In-reply-to: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
Message-ID: <87zgmtd0ov.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Stefan Hajnoczi <stefanha@gmail.com> writes:

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
>
> I will review project ideas and keep you up-to-date on QEMU's
> acceptance into GSoC.
>
> Internship program details:
> - Paid, remote work open source internships
> - GSoC projects are 175 or 350 hours, Outreachy projects are 30
> hrs/week for 12 weeks
> - Mentored by volunteers from QEMU, KVM, and rust-vmm
> - Mentors typically spend at least 5 hours per week during the coding per=
iod
>
> Changes since last year: GSoC now has 175 or 350 hour project sizes
> instead of 12 week full-time projects. GSoC will accept applicants who
> are not students, before it was limited to students.

I'm certainly up for mentoring new devices for vhost-device (rust-vmm
vhost-user backends). Since we've become a code owner we're trying to
clear the backlog (virto-vsock and virtio-block) but there are plenty of
others that could be done. Of particular interest to me are:

  - virtio-rpmb (we have a working C implementation I wrote)
  - virtio-snd (in flight virtio spec)
  - virtio-video (again we have a working C version against v3)
=20=20
With my other hat on there are numerous TCG plugin projects that could
be done. Adding basic plugins is fairly straight forward but it would be
interesting to look at what is required to do a more involved plugin
like panda-re's taint analysis (following ptrs as they move through the
system). This will likely need some additional features exposed from the
plugin interface to achieve.

With that in mind there is also the idea of a central registry for
register values which is a prerequisite for expanding access to TCG
plugins but could also bring various quality of life improvements to
other areas. I've written that up on a page:

  https://wiki.qemu.org/Internships/ProjectIdeas/CentralRegisterRegistry

--=20
Alex Benn=C3=A9e
