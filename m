Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB53C86F9
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2019 13:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfJBLIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Oct 2019 07:08:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:60842 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725991AbfJBLIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Oct 2019 07:08:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570014525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=k4e75Gh2jQ67Fs0hO6kK7qNkv9aMDy+Rx2EXO0iCfos=;
        b=eenusA/GhMWqdnl8H9IJkUfCvmdyQsttNX9YmX4Tl3k5n7ctvRHMQ/aVbEeYU5rHSVXqNT
        jeMYeXlhSj/+lozFaLwMRQkXjOQTJDRgt1oja1Snb3pOw2oMs+lMIGDXeP+cy+QEwmy0BA
        9FxfKrTuKbm91d7bXczQhS2NPWSWUb4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-FLfpd2beMGeMaiTp-zggKQ-1; Wed, 02 Oct 2019 07:08:43 -0400
Received: by mail-wr1-f72.google.com with SMTP id b6so7375464wrx.0
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2019 04:08:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=70g/Ck0p6jhZWAvgA9ll9LQIBA2/iWGacFd81/4MQWA=;
        b=oNAcXE4bjbRE1ulJIhugqWMKT3H2xK+2hZW9+LE2Rf3nhUhMhy5WfL/3sEp5c4AhcO
         5C1YidSb6duKcG6GXnW20XeuUONoSm5/bT2MnZ9tISF7fXbindxEx4g8D0k25wNIdXPx
         tqIgMya9/IAikabxspjTiVtrLJ4kL9j6eSSOvM2AWuhdie9OP+rLTEXwlnPe3Yg6GxMV
         oPjK+xfrruaBZGQSymCO/UfY+RTAQVSW+fAugWFzUEDc/wTQrI53GHm5yirlhU6V2HN6
         ogWGFNWKWfdp3J2KglO3jh6K+iTIM924EJMkobHnsQcsxzbWEm4s+QiajxS/MsaGzVkj
         bJCw==
X-Gm-Message-State: APjAAAW3+N6U9LkFJIfLXbyLSKLTco3ns7ATB01Jw9iULOvb1Hu2AlYW
        umwMzfzYUpVtkmNYMzgwCa8vyc3KorLyRwepnVYpAot/PtxUzY/Po9oAPzhzrjZO4s5pgbogrLu
        6aEWqrFV2ltoz
X-Received: by 2002:a1c:7f86:: with SMTP id a128mr2520857wmd.104.1570014522202;
        Wed, 02 Oct 2019 04:08:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzXMT0J/K3/CgHdeV3FJxAjZahVRw8pyOQpbv2IPzJBmxQ0udKA/IghRA6G2o3ojTYpnjgKsw==
X-Received: by 2002:a1c:7f86:: with SMTP id a128mr2520840wmd.104.1570014521931;
        Wed, 02 Oct 2019 04:08:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:dd94:29a5:6c08:c3b5? ([2001:b07:6468:f312:dd94:29a5:6c08:c3b5])
        by smtp.gmail.com with ESMTPSA id r2sm24020786wrm.3.2019.10.02.04.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 04:08:41 -0700 (PDT)
Subject: Re: [PATCH] accel/kvm: ensure ret always set
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20191002102212.6100-1-alex.bennee@linaro.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <05d59eb3-1693-d5f4-0f6d-9642fd46c32a@redhat.com>
Date:   Wed, 2 Oct 2019 13:08:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191002102212.6100-1-alex.bennee@linaro.org>
Content-Language: en-US
X-MC-Unique: FLfpd2beMGeMaiTp-zggKQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/19 12:22, Alex Benn=C3=A9e wrote:
> Some of the cross compilers rightly complain there are cases where ret
> may not be set. 0 seems to be the reasonable default unless particular
> slot explicitly returns -1.
>=20
> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> ---
>  accel/kvm/kvm-all.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index aabe097c41..d2d96d73e8 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -712,11 +712,11 @@ static int kvm_physical_log_clear(KVMMemoryListener=
 *kml,
>      KVMState *s =3D kvm_state;
>      uint64_t start, size, offset, count;
>      KVMSlot *mem;
> -    int ret, i;
> +    int ret =3D 0, i;
> =20
>      if (!s->manual_dirty_log_protect) {
>          /* No need to do explicit clear */
> -        return 0;
> +        return ret;
>      }
> =20
>      start =3D section->offset_within_address_space;
> @@ -724,7 +724,7 @@ static int kvm_physical_log_clear(KVMMemoryListener *=
kml,
> =20
>      if (!size) {
>          /* Nothing more we can do... */
> -        return 0;
> +        return ret;
>      }
> =20
>      kvm_slots_lock(kml);
>=20

Queued, thanks.

Paolo

