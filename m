Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D179BBEF61
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 12:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbfIZKQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 06:16:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55572 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbfIZKQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 06:16:44 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0280AC04BD48
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 10:16:44 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id f63so826356wma.7
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 03:16:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=IBdWUvcQutLfTdj7XIJktgM69ZCC8tBDBOih2754DOc=;
        b=Rals1wKcHXdQopjtYgiMRk7XUNHIvlBZuH08lp8zkPtXCRDv2bMwubM0BfRKwHUgEF
         zhiH5BeMmMmV9C6VVjfsQsblkCxdX5OYeV/77f2DgqI5ccpv9anyzua3LAGZt0jZDVD7
         KXRVafjatN8qT6Fg1Ja7YRPCh06xEcZ6EwyaAopPSfbtt4TfV/TpJZFV6R+yRsC3b8oI
         feD/S5SZNMnsKNwIhNIx+J/jGNOx4FfaDJGf6PCv1FMXI4Vi5ZftecW3t3Se94TvDhQO
         K83BU533ac4wrMly34VkmaqdVVRzDOgaZc+6EXO/tahKvFdWhUOmiCorF3c9dAJ6MsQ/
         3riA==
X-Gm-Message-State: APjAAAUbznu+AHwgeVaR1Wev2olteUqgLnhM2SwufeJmied/87f33V7k
        81am2WNxF0gNcd9apvTrHTqqGQ/sNmuFqzwTwsfM8xvIMvHU5c05RZkfQONP1yAgskgo5BOLpD9
        ayaACrpnCi57D
X-Received: by 2002:a1c:23d7:: with SMTP id j206mr2276663wmj.57.1569493002439;
        Thu, 26 Sep 2019 03:16:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxNjQRHTszNojB7edoXk7xS7U86MXEMu/qGpIBGlRYk66f8dZYwpXS9eK2cj0djm21gul4Pgw==
X-Received: by 2002:a1c:23d7:: with SMTP id j206mr2276640wmj.57.1569493002233;
        Thu, 26 Sep 2019 03:16:42 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id r7sm624946wrx.87.2019.09.26.03.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 03:16:41 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-8-slp@redhat.com> <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87a7ass9ho.fsf@redhat.com> <d70d3812-fd84-b248-7965-cae15704e785@redhat.com> <87o8z737am.fsf@redhat.com> <92575de9-da44-cac4-5b3d-6b07a7a8ea34@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine type
In-reply-to: <92575de9-da44-cac4-5b3d-6b07a7a8ea34@redhat.com>
Date:   Thu, 26 Sep 2019 12:16:39 +0200
Message-ID: <87k19v2whk.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Paolo Bonzini <pbonzini@redhat.com> writes:

> On 26/09/19 08:23, Sergio Lopez wrote:
>>=20
>> There's still one problem. If the Guest doesn't have TSC_DEADLINE_TIME,
>> Linux hangs on APIC timer calibration. I'm looking for a way to work
>> around this. Worst case scenario, we can check for that feature and add
>> both PIC and PIT if is missing.
>>=20
>
> Huh, that's a silly thing that Linux is doing!  If KVM is in use, the
> LAPIC timer frequency is known to be 1 GHz.
>
> arch/x86/kernel/kvm.c can just set
>
> 	lapic_timer_period =3D 1000000000 / HZ;
>
> and that should disabled LAPIC calibration if TSC deadline is absent.

Given that they can only be omitted when an specific set of conditions
is met, I think I'm going to make them optional but enabled by default.

I'll also point to this in the documentation.

Thanks,
Sergio

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2MkAcACgkQ9GknjS8M
AjU+og/+Nbc2ZkpftrB6CqGZXaz1bwXwBrDuNX0AanuB7LdNVpiCKGCR913yKL44
qY9NnJ8A1J5QM6fai5BcMoDVn3Xm2AVf8OL/mg0xOdoGXDGK2ybpoiyv8AGrd3cc
lPQjWMVZ9XMBCzHoGeI+ogLkx24AXjfc9+82jGMbXSIgYXH0/KPtOa+P3U0P6GV0
0nnTouITT0OpWvp0C3Mi+oS5CJbcTRbinLbwP5mozXjMDdmiKpCrkBFN7TOBcceW
rwB0IQ9bjbK2xNBUjUVnzWAcgmczzQF1Q42JUTGEn3bD6X9AxhLUsVd4aWjCfmDj
93WlmcJwKKB+ADj7/9alsxJALRlwhGfutS2Lp4QfTZFMkWW5SZngQgES86a1gC/P
Qx8dy0h/4XBXb9f2BKW18TUVKyHKIfOVNeLeJBBYKUPY9ABBIzXBtnx7exnbMnOd
6yPViV4aJ8PDJtE5dXQLdU0A3qTSb6SXXiJOQmR7uVeF5iO25xOf7C+hple3Trhr
HGnwqZWni55h8S4aom8P3NZF7AmqsmU4AqlSvE/ZAkwfGKg8jKw8jt0jaXUP5Srn
9HjwvifpEp6zkSBzE2PbeD5lZp9uF+0Ug+mEpk/R4IxycDAcZ7Y9pQswCaMgojd0
EYWz1qEDZ2WbBSM06+FzmwsKPxWv1ug+Z1usbQKTrmYG1xWt2i8=
=7lIN
-----END PGP SIGNATURE-----
--=-=-=--
