Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8ED0BD7EE
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 07:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404408AbfIYFvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 01:51:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52764 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404959AbfIYFvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 01:51:23 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 25A898665A
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 05:51:23 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id m6so1306787wmf.2
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 22:51:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=OtEFV0m+GnWRM/tR47ubwOVlNUD3RY9PH6tuWisJOek=;
        b=j269OuqLbkmiTyyVd5dTTDWC4BiBW+wGByEVaPZuOojmzQIZgOxcPZY91zkPMuArDr
         HaR5ajo+Mr2HTHRCSEYrB7QLh/WuihXzSNKG8vbon43WBfU9fdRC/kfq8dBw35MJvPl7
         SMrWzGJ2Yc0b0bp/vl1E1cdwc0emog+hUZxjbEbOb6dy7kO3clu3KK44YBH1f0C9vZ+t
         QS/xNrThRCLzPZ9G0fEGx2gyVH6Zuf6UoKSxEWxb6TL2Z/vStYq57dd+GuZNxk0RljtU
         QM0IU5Sw9vzYZMqD5w5MfOdmx7PEqgv7+Tv7ifHZGjJi+giA3LfFFjBZ8E/o/wNJ7Nkt
         rEYw==
X-Gm-Message-State: APjAAAXyxmeOToKGhnyBAUf5yU6SO7AZTwfneL1PuL8eyqdNiSm2ZdUP
        rHbnC2aWzBZFk3qcTkCVtLvv1TNed+c1bIRdE2yi+MDarYoI376PI+DUW8LDCWK0puvMTOeXGHB
        1MTTtXUpg/5mw
X-Received: by 2002:a1c:1b14:: with SMTP id b20mr4953534wmb.122.1569390681857;
        Tue, 24 Sep 2019 22:51:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzk/XSA8hgHlQwseDF2U3WU+JlYJtl/FUQYAHCtiXsg3G1to2Dj4NGideZ8SXt2mfq3cTXgWQ==
X-Received: by 2002:a1c:1b14:: with SMTP id b20mr4953515wmb.122.1569390681711;
        Tue, 24 Sep 2019 22:51:21 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id s10sm3389670wmf.48.2019.09.24.22.51.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 22:51:21 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <CAFEAcA_2-achqUpTk1fDGWXcWPvTTLPvEtL+owNSWuZ5L3p=XA@mail.gmail.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>
Cc:     QEMU Developers <qemu-devel@nongnu.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH v4 0/8] Introduce the microvm machine type
In-reply-to: <CAFEAcA_2-achqUpTk1fDGWXcWPvTTLPvEtL+owNSWuZ5L3p=XA@mail.gmail.com>
Date:   Wed, 25 Sep 2019 07:51:18 +0200
Message-ID: <87pnjosz3d.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain


Peter Maydell <peter.maydell@linaro.org> writes:

> On Tue, 24 Sep 2019 at 14:25, Sergio Lopez <slp@redhat.com> wrote:
>>
>> Microvm is a machine type inspired by both NEMU and Firecracker, and
>> constructed after the machine model implemented by the latter.
>>
>> It's main purpose is providing users a minimalist machine type free
>> from the burden of legacy compatibility, serving as a stepping stone
>> for future projects aiming at improving boot times, reducing the
>> attack surface and slimming down QEMU's footprint.
>
>
>>  docs/microvm.txt                 |  78 +++
>
> I'm not sure how close to acceptance this patchset is at the
> moment, so not necessarily something you need to do now,
> but could new documentation in docs/ be in rst format, not
> plain text, please? (Ideally also they should be in the right
> manual subdirectory, but documentation of system emulation
> machines at the moment is still in texinfo format, so we
> don't have a subdir for it yet.)

Sure. What I didn't get is, should I put it in "docs/microvm.rst" or in
some other subdirectory?

Thanks,
Sergio.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2LAFYACgkQ9GknjS8M
AjUuNA/9HZkcHiAgWQjLv+hy9IJvlB94aSH8XhyJZ51P7tQtgJgxJMkWhUtLqm4x
J77G7mDacT/B3X96mhOCaS7UEeqGCeE1JE9LRo9DNN5ivN9kbetfb7he+EE3yQ7Z
5pQu2AhTm5e0BzFKDIpG9g0ybbRQERYpuPcqMNx1ZR1murW0XH+7yb7CCIuIozAm
LRNyKtlRzu8H+hU/0TuDB2zPA3dQvBrx9YCLivA06Ekyl1OFk2pHqmmPF/800G2C
tTHPTn2KqkeWjZmRoJS0cq5JloaMnfa59PWeGeCxB8b0JS69ZWXNCUpsYgN6Jzwc
oB+7YJT043vB0b2rdMPZEesa5PdaBbXR2WqOIO6li4rhZANKakGzJH450Sc8P17A
RC5aqCCse6ZXvsEAezoVR5C10w37YRxkZdMH8JB81jpcLZRRXYk0Gq/Gzar5eFBM
Vo1rlxgKbI+3X6doKWsVy01oxC0S4JayW08uPdZ6rletlJJuHvuR2Hn6NQdj/9Ew
5SUqZNo0j7/uOGBdDm/iWzLnh6prvl0LXl8OUvAwNM3PHxHSVHGY9mxUZSsHYiLO
bEyxj++CgkAEc+qYMmb3Ykzf1WQ45Uyl2DE9iPaUcKVyg1a8q2e0WklcWVgn/Q4x
u3j8gg6Yj/a8MfegbnQfP2+4u440reGFNDJGVlW9EJcTFlGK5L8=
=Y289
-----END PGP SIGNATURE-----
--=-=-=--
