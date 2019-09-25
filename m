Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13B9CBDCF2
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 13:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391104AbfIYLUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 07:20:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391048AbfIYLUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 07:20:46 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3F40746671
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 11:20:46 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id t185so1839485wmg.4
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 04:20:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=TQLyUyTVyN5f3rMPgbSqGLlYWyI3EuIZKhqjMak1wlM=;
        b=lZoCVIT/zN8EJ3U6AcXiYFR/yRc+pGjRZyc+5qcz+faAfQ1dvjRuUoYfwRhF6LANOX
         gAoGPmDruMysCOfL7OWhOuPv37V2fdbMgFh/Sfa/kjW9QfF3svqEWsOPRrVY8K5N9nv3
         OUqXEQG4sq8bOi8UEn3BqkuZb185qwg1wGxSf5E/pB1zw3h+qrcS/lKSAaGq0hmVkZr9
         MpEND1U13jHhJ0nHNLVYBtwN9v68JuanSs8jaXIq4VA6hsS3HM9afNWH5QHgZ3t0xW0j
         a8RHU0mTpAtMHsc74ujik05xZzIFlDqbdceY28aXjvYleNHLlqvRYUIPhECRMT+1362n
         g+VQ==
X-Gm-Message-State: APjAAAVRd4ccjekOCtg/RBV+z2UrPD1rIqDHS9OMn7CaUM67TyXXTfUo
        DqjCQHAWbKXhnsJ9HApFYwYqJFhtmrIzS1wfDgJ6W6U+br9y4cUeugY5JgKCpPWli7epHps8WoY
        1fxM54S+FGRns
X-Received: by 2002:adf:dd41:: with SMTP id u1mr9171305wrm.49.1569410444617;
        Wed, 25 Sep 2019 04:20:44 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwihDEnuRrpvaKbtRepAH8BlQ/4mZbya0BuvikfMc9haI+Iq1pqnyC2H/pBV39VR8L7dIFSKA==
X-Received: by 2002:adf:dd41:: with SMTP id u1mr9171275wrm.49.1569410444363;
        Wed, 25 Sep 2019 04:20:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id l10sm7276798wrh.20.2019.09.25.04.20.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 04:20:43 -0700 (PDT)
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine
 type
To:     Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-8-slp@redhat.com>
 <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87r245rkld.fsf@redhat.com>
 <317e53b1-d658-4b6b-c782-4b2a0dd091b2@redhat.com> <87ftkksr9u.fsf@redhat.com>
 <3fb455f8-13ef-2930-a10d-9cecd6e5931e@redhat.com> <87blv8skkk.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5d8a164b-90b9-96cb-a1a5-fbc7694db960@redhat.com>
Date:   Wed, 25 Sep 2019 13:20:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87blv8skkk.fsf@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mJgue5CzEEEizQwnAbeTt45ne4WnQgG6K"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mJgue5CzEEEizQwnAbeTt45ne4WnQgG6K
Content-Type: multipart/mixed; boundary="iaDySfsMolRS3THVVUKm8AXJsRJPxSCbm";
 protected-headers="v1"
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sergio Lopez <slp@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
 marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
 philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
 mtosatti@redhat.com, kvm@vger.kernel.org
Message-ID: <5d8a164b-90b9-96cb-a1a5-fbc7694db960@redhat.com>
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine
 type
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-8-slp@redhat.com>
 <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87r245rkld.fsf@redhat.com>
 <317e53b1-d658-4b6b-c782-4b2a0dd091b2@redhat.com> <87ftkksr9u.fsf@redhat.com>
 <3fb455f8-13ef-2930-a10d-9cecd6e5931e@redhat.com> <87blv8skkk.fsf@redhat.com>
In-Reply-To: <87blv8skkk.fsf@redhat.com>

--iaDySfsMolRS3THVVUKm8AXJsRJPxSCbm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 25/09/19 13:04, Sergio Lopez wrote:
> Yes, that would do the trick. There's another use of it at
> hw/intc/ioapic.c:78, but we should be safe as, at least in the case of
> Linux, DM_EXTINT is only used in check_timer(), which is only called if=

> it detects a i8259 PIC.

Even there it is actually LVT0's DM_EXTINT, not the IOAPIC's.  I think
pic_read_irq would have returned 7 (spurious IRQ on master i8259) until
commit 29bb5317cb ("i8259: QOM cleanups", 2013-04-29), so we should fix i=
t.

Paolo

> We should probably add an assertion with an informative message, just i=
n
> case.



--iaDySfsMolRS3THVVUKm8AXJsRJPxSCbm--

--mJgue5CzEEEizQwnAbeTt45ne4WnQgG6K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl2LTYoACgkQv/vSX3jH
roPDUAf/ThYeKfKLT6O82x8MZrdERraTDob3kiyMe4MKWOsoyuKRCSwRRdzGFNti
rVuBPQqcocANVqFKCVLta0BEUxEVsV5e7FRHJqN+gYd7MWa0OsIBKdjSkTSWG271
GPr5YY7jGszB+Je/anQs3uxy3SdNjZ1pjlFysVDV+YTHgn9wg4GXTrpr6J7JGjld
mjXVEczFp99+mBCtqYxof6VL4BkRHGp1Yb+XiFXM399Lmnu2y9mPd7VLRZpPHrxz
PLDuMcohnn0tKmccZ7HtwttuJ4nCIFSgGgkGiItHIugTD2X9ldAe5+JwYPtgknMV
wejmdsaz98KDNYvX35FKj8+a6XBoKQ==
=VmG6
-----END PGP SIGNATURE-----

--mJgue5CzEEEizQwnAbeTt45ne4WnQgG6K--
