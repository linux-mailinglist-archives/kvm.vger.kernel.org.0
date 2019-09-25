Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B6EBD99C
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 10:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634041AbfIYIKh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 04:10:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49228 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437449AbfIYIKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 04:10:37 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DD2313D955
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 08:10:36 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id q10so1918759wro.22
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 01:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=sSedf1PSQ4+XVQg27whbHXC5BsZOA0msBaOP6O2nXYA=;
        b=ER8Qzq+0fPGFnmDn2UrrKUMQ7cq7fuE0O+IjjW7s+h2GKKoL+XxvWkGp8TUGQJkHOe
         mrcWhr6f8Fsxib3VTBJ5IHPQqgWz4Mr4yva1GlhDOMN9a6qCEn5q1T+jp4UUXRv+pic3
         8ELDpXYoEXPB42hYNQ/WwPMSun0w5SC8vo8vfhQhDR6DwHlzAuZPIY0R+Lrd/TggHjng
         qFdR0nW0zGahQiXmbIz8QPBOuCUbf3LCrfTTItGScST8ZiQxCFkczD13C2xKrEmYhvQY
         v7haKnTOqXZSkx5KE6PmmEUJv35GqPx4Pw6bRW/qIH5pejBF+Sk7l4kGCYdIlKRRJUJe
         iodQ==
X-Gm-Message-State: APjAAAXoqEcPK251F00jOvtTseyXCBXE9+s0Drrl/uP17e9VxIX3fWoZ
        4sqtwU2FMhor6Xu4B5WBvBUOcUM7/bMEzq5iQ5toGVdndTtpLYx/vWzcGOlXeP2xqfptIIakMVP
        NJBnokndNO4Mj
X-Received: by 2002:a5d:4044:: with SMTP id w4mr8299095wrp.281.1569399035680;
        Wed, 25 Sep 2019 01:10:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyRVq+g1VfZMi0d6Wj/uqNnTxYdPTROhRi471HFmLSLWvA0bKAZQLSNyzFlC9+e4gKyKQ97bg==
X-Received: by 2002:a5d:4044:: with SMTP id w4mr8299057wrp.281.1569399035412;
        Wed, 25 Sep 2019 01:10:35 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id d10sm2181806wma.42.2019.09.25.01.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 01:10:34 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <c689e275-1a05-7d08-756b-0be914ed24ca@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, pbonzini@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, philmd@redhat.com, lersek@redhat.com,
        kraxel@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        Pankaj Gupta <pagupta@redhat.com>
Subject: Re: [PATCH v4 0/8] Introduce the microvm machine type
In-reply-to: <c689e275-1a05-7d08-756b-0be914ed24ca@redhat.com>
Date:   Wed, 25 Sep 2019 10:10:32 +0200
Message-ID: <87h850ssnb.fsf@redhat.com>
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


David Hildenbrand <david@redhat.com> writes:

> On 24.09.19 14:44, Sergio Lopez wrote:
>> Microvm is a machine type inspired by both NEMU and Firecracker, and
>> constructed after the machine model implemented by the latter.
>>=20
>> It's main purpose is providing users a minimalist machine type free
>> from the burden of legacy compatibility, serving as a stepping stone
>> for future projects aiming at improving boot times, reducing the
>> attack surface and slimming down QEMU's footprint.
>>=20
>> The microvm machine type supports the following devices:
>>=20
>>  - ISA bus
>>  - i8259 PIC
>>  - LAPIC (implicit if using KVM)
>>  - IOAPIC (defaults to kernel_irqchip_split =3D true)
>>  - i8254 PIT
>>  - MC146818 RTC (optional)
>>  - kvmclock (if using KVM)
>>  - fw_cfg
>>  - One ISA serial port (optional)
>>  - Up to eight virtio-mmio devices (configured by the user)
>
> So I assume also no ACPI (CPU/memory hotplug), correct?

Correct.

> @Pankaj, I think it would make sense to make virtio-pmem play with
> virtio-mmio/microvm.

That would be great. I'm also looking forward for virtio-mem (and an
hypothetical virtio-cpu) to eventually gain hotplug capabilities in
microvm.

Thanks,
Sergio.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2LIPgACgkQ9GknjS8M
AjWl+A/+PSvLIkJIXkisI+8HPInHsOhI7krvdkj88nvO3vWQbDvRZR4wjKpzJls+
QuB7L+5sZh4afO4t0zOOZ54AcN91lSMUL3ovOFbN2zsS3yWO3H1BIgroEdD3Ho2g
wePVPnB65l10c2X6zqvLZlE06amQ1rG2ooYHJmF6AHl7L6ouHjTqioFoe3itzfqc
5t3xdJx43IpXY5Zng6S8mNGji7q1PX/tKqYdoOSqafMxN9s9HqX6t9F6/kbUkH9j
Q+xKcSg5wSHAV000jokgfgJe21Z3/O329Zckb+Vdp8RqZZaR5p1tYThevyshqvLK
K2QKsT8hxflVPtyXe326UGaRQd/n+Uq9d9BFj4M+imvMsYu6EkV9hXDOq5U9PRtN
uwiCQj3OlHjzvad18+ZbnPnjfkPDFnYTzgdiQ8o99+a8AK1SbdVi8ePMmFy8tvBF
szKMv7fzfOGYNJnmd0At1nWMon+0qQKW7v/Ee4qMN+Xg5900ycDhsyf1fMdCj/52
DkQaFc5Bo94CjhDjQetZd/EHJKfqd4NKACCUNs7Hkubrlj7p+xkI+Oj8jtI96cWK
ytI43gzylvznVvlH16E0BTiEhAduBY5PGkGBOqpAkjk2wLUmGK7BsFAzpjtMDxdH
XSR81ecBqDHJXAA0JekepxcEK+S3ho6j2NJpJ2jvuXsKCl8UGiI=
=DOyt
-----END PGP SIGNATURE-----
--=-=-=--
