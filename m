Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6AA4BD7F7
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 07:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411763AbfIYFxX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 01:53:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404361AbfIYFxX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 01:53:23 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6B1BB4E92A
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 05:53:22 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id j2so1736589wre.1
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 22:53:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=7woLVgJ+KVYVdpUNNP/OKdOYyHMYlJN3b6YJJgwv2Mg=;
        b=ejYjERRkLMuBmaZhKYrMwu3rSlAcvyZfIc3tMa5eAktQN7fVlul039G+nnqw9s/1vt
         fMd0tJ1RpHHwJZFQ41RubnhJ+TxSP/UG4p9FRt1bTu/udm0W6VR0YYGEimOy+SYM5Dun
         shsr7UXl2i2jUJbOgmjN271m+6q7chDBOP2u/Ush4dYYB/yKbY8D5166T+f1xZT/oOlI
         9QxMHOSZZM8OEjfyPXWmLbABVJvtCCgx3S6uSLY4uNXmxo3b6EZTavMdZHuDggUaXqpC
         /J/n9DxA7mww5nt2YLNKK9wnYPlH4A6xzPtMZUY2TSIMthaBVk1/HRDEUuh1OeQsrpZn
         OZXw==
X-Gm-Message-State: APjAAAVBP5Cw80jNtKcgQ3wU6ffMb6BWJJzsRXsd441VD154tAEEcA8k
        iYGk1uahuP5fEUpBhMhDkaDzH1ErOCq67bauv9pNvy5t/pJY18MtmVossoO4pCAN9LFd3RyuqQb
        VylFJyLhcRbAN
X-Received: by 2002:adf:f9ce:: with SMTP id w14mr7310626wrr.132.1569390800990;
        Tue, 24 Sep 2019 22:53:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxpOy6S9KG5JEGMS7+UMGl6cv6QPmCytFMF2tJor3GyybuL6Zygr8G2mNtKtbI+zvp6UGV9vg==
X-Received: by 2002:adf:f9ce:: with SMTP id w14mr7310602wrr.132.1569390800830;
        Tue, 24 Sep 2019 22:53:20 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id b184sm2316815wmg.47.2019.09.24.22.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 22:53:19 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-9-slp@redhat.com> <2cbd2570-d158-c9ce-2a38-08c28cd291ea@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 8/8] hw/i386: Introduce the microvm machine type
In-reply-to: <2cbd2570-d158-c9ce-2a38-08c28cd291ea@redhat.com>
Date:   Wed, 25 Sep 2019 07:53:17 +0200
Message-ID: <87o8z8sz02.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain


Paolo Bonzini <pbonzini@redhat.com> writes:

> On 24/09/19 14:44, Sergio Lopez wrote:
>> microvm.option-roms=bool (Set off to disable loading option ROMs)
>
> Please make this x-option-roms

OK.

>> microvm.isa-serial=bool (Set off to disable the instantiation an ISA serial port)
>> microvm.rtc=bool (Set off to disable the instantiation of an MC146818 RTC)
>> microvm.kernel-cmdline=bool (Set off to disable adding virtio-mmio devices to the kernel cmdline)
>
> Perhaps auto-kernel-cmdline?

Yeah, that sounds better.

Thanks,
Sergio.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2LAM0ACgkQ9GknjS8M
AjUg2w/+ISuBhSmncT32Fm1YTvxEh2PDdUF/lq3mxoIxKfl2KOfRnj/jlrz6JofU
L7M8lrc1+NXSf35Tbavcf/enK3Fs/gRF54h3J5NtlVNK6nbYb5+g7I3o8iUWbwJk
FbwHv7SmRnOzyzQFlzFoW5C2kHfieRn+biVoFCVScdkM9CSJSZg4+vJUJoHcg7tB
FItkCQfhm1R940qFmP7EmzrcY9pb0sUoJkOpoUhjr/2F32nJQexBCxn7dDDYvDPY
g6o5QKR0jzbwye/luxKofqhMHrhlblg6MT8ygIDxtNuOfBJj+O67hXaXx+0lY9w9
XxZ2mY9nHmRTXvP6c9CaN+bZUj20BhcpEU+hl6fDjx3aBw753I4pGCZJcNdOv682
Cop3r/7HyHDs2Wr7/pJEhBXnFMKOanjmak1uef8c1JYz5VuKt2878Kd4dHfef9Xr
IlNHmjjpiF5jjVtcBXw1i+xT5LQ2p53Hb2bUcu23W6qxSGji0rxA3W2F80qDk3m5
tUJjuZ9ltF6995/oijT5wTxOSp/ahH9aBtz4lg9OcesdlJolyPvFMXDggxZRI0Vq
fC27hF97dgK85qh/JgzhleMgwAzIzZRQwmzV0xiboonY+UnF1MaD1+WlNeLlo2pL
pYkja5qRd9I+BOfzCdjanDE/uDE54yW8xcgJGxVpLLMrWY7dDec=
=E2ve
-----END PGP SIGNATURE-----
--=-=-=--
