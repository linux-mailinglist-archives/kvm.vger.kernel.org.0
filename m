Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8E08B5ADF
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 07:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfIRFZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 01:25:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbfIRFZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 01:25:57 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 96E84C049D62
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 05:25:56 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id t11so1921467wrq.19
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 22:25:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=vevpk34rXm6JK5vv7gijD1iPBGu2RaEosfU/ZfCaERU=;
        b=JB051xNCjaumhXVv5qhdKy8MHYHfkM1lNsbZTV3VdswjtgYCIeHKnoh4LLX6ttY+A7
         +VNulSGfH4/eUGgDTCQtnwrn1UDF+Tw4d63d9N6cwKVLGENyqRif+uF9KEoM8i659AVQ
         lrGKEnxhbufg/VJao1Yt8rrKHykeVHgp+6HiI6FWJP8s3lQ7KnIFAUx1GRdr3qWBDQzm
         4zc7B/luWra/GF59kOIMQfdfeIGHWBrBOd2JiAq5rBuYDXR8dAPfMrCamiduA/fHoUF+
         dMeUQEl49sOVugRFHNz2CtpPPeBjJB8lFYhuUcjYWEhB+0WBLbCgpmKiTyeS1IqigQ1F
         hfMg==
X-Gm-Message-State: APjAAAWz7mK4bnGG5xcUlHyuGnRKW82UWVWPku1ZLSj9sJF3A/r+QPIg
        1FYXAwmrqfEM36sQ6DkL5nAw3SpuFQ3CApKSrrAA9MTn8KuPNGLLO/3WMh6x9F/nTP4Bqmbr32z
        irBHVcEitcz+/
X-Received: by 2002:a5d:6647:: with SMTP id f7mr1445361wrw.170.1568784355174;
        Tue, 17 Sep 2019 22:25:55 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwYL85ObLRUr9ngqs86URaXSkVjUzvDoZEQAUpTYL+WvaoBe/J9EwgNupa9A3PZ1EunB+rqfQ==
X-Received: by 2002:a5d:6647:: with SMTP id f7mr1445346wrw.170.1568784354935;
        Tue, 17 Sep 2019 22:25:54 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id s13sm1052056wmc.28.2019.09.17.22.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Sep 2019 22:25:54 -0700 (PDT)
References: <CAJSP0QVMjw_zm16MRo25Gq0J9w=9vrKDZtaH=WGwjSJiDAVm9Q@mail.gmail.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     libvir-list@redhat.com, kvm <kvm@vger.kernel.org>
Subject: Re: [Qemu-devel] Call for volunteers: LWN.net articles about KVM Forum talks
In-reply-to: <CAJSP0QVMjw_zm16MRo25Gq0J9w=9vrKDZtaH=WGwjSJiDAVm9Q@mail.gmail.com>
Date:   Wed, 18 Sep 2019 07:25:46 +0200
Message-ID: <87k1a6yy3p.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain


Stefan Hajnoczi <stefanha@gmail.com> writes:

> Hi,
> LWN.net is a popular open source news site that covers Linux and other
> open source communities (Python, GNOME, Debian, etc).  It has published
> a few KVM articles in the past too.
>
> Let's raise awareness of QEMU, KVM, and libvirt by submitting articles covering
> KVM Forum.
>
> I am looking for ~5 volunteers who are attending KVM Forum to write an article
> about a talk they find interesting.
>
> Please pick a talk you'd like to cover and reply to this email thread.
> I will then send an email to LWN with a heads-up so they can let us know
> if they are interested in publishing a KVM Forum special.  I will not
> ask LWN.net for money.
>
> KVM Forum schedule:
> https://events.linuxfoundation.org/events/kvm-forum-2019/program/schedule/
>
> LWN.net guidelines:
> https://lwn.net/op/AuthorGuide.lwn
> "Our general guideline is for articles to be around 1500 words in
> length, though somewhat longer or shorter can work too. The best
> articles cover a fairly narrow topic completely, without any big
> omissions or any extra padding."
>
> I volunteer to cover Michael Tsirkin's "VirtIO without the Virt -
> Towards Implementations in Hardware" talk.

I volunteer to cover Jun Nakajima's  "Enhancing KVM for Guest Protection
and Security"

Sergio.


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2Bv9oACgkQ9GknjS8M
AjXK7hAAnAk5MQVl8C7cK2i3gybVBP2D0o2A6JADUprU37pP+Uuhsy2M5Oh8K/Ra
4wG6GH/cQeQCRNfhMJ8mcAtkm0K7iF3EQrtklLceSBjS8VJLpNPmG52O5xtGJcnt
kioUPLe17zg5axrnAl/AhEtM8KHKYu3IdYSCGNiZbVVo+CfMBJOO/qk3IJOppVQ+
O5R5ukO2htiRsro7m4v+9lva2xp5mou6RAbA2U6QdDfVAFL9IUw24nRQ9Vtj7d5j
jeV/TDuoEzssmLVQ2I6oEybtdbyR9MQqXhi/FXXrrCGBStgfI+MzBBNG2UXco7FG
4eGbhQ6c5I2c63uh2yk8ZyNKy4aIuyUA11vw9ZGFmyOIn3VS9Ru4ZqGiEcnkXsjm
8SfFU+mTv1IQyIY2uWWOr988DdFTObpIs6bSHJFjoTow6+cCtdEiNB6iHQXYUJSE
2IFuOanzD+Yga9L8JEeVfQwgTXK/JUUMA3AEm9BXnw/dackiLz4JaqmnPVRrwnjd
epxjqo+vzzcHUeMwGalgpj3iH0N3QEUmIDAfJl06Is5X5x1/GK0RKfI7jq6/6xYv
J6OdHX97NZiIvqRL43mdDNOpfeyqrjebocoaqXc70qBA/XFDwO1cpcMxUmnxuOG/
Vk/b4kK75ZhBtUa85Pjim5HiR+P1gqzBLdO4DyW/pNW/hAbcKiA=
=lNS2
-----END PGP SIGNATURE-----
--=-=-=--
