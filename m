Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1A11A36A0
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 17:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgDIPKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 11:10:31 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37770 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbgDIPKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 11:10:30 -0400
Received: by mail-qk1-f194.google.com with SMTP id 130so4251975qke.4
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 08:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=DIocbXZ/GrySYJM2qjlB0aVfLDG/I+8RC+5beeuDqKQ=;
        b=rropwxWiFn2w4WZ/eqv8MdbJFi26bRLRbgBUG9wGB+0VCTjauS8nU81/N8kxvdyVnD
         R4UvF4evvwf2RWu7qI44owvQYpgghZYQE7g2936Uc0Wamem2nJTvqwbKYpWxXMfBN+Td
         ybZn1+3VDLyLj6y12q5q52UK0I+8kWOaMfyk1Y1+cZBFcK7KxU3yUcdtkJLu5puQIvp2
         UMSRjN0cbdDNmQBCpno7rcnePcplHvCOKqxA3OuMF0VHiHnJaB2h0aZwVYX4sqrUAlpl
         MD52i3KsjWHxtvJNSvCQrHlfU0D6H11iF7PJHSf3JJhA3QpS8Oq7MXAFkFIlltUtKJb6
         1bTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=DIocbXZ/GrySYJM2qjlB0aVfLDG/I+8RC+5beeuDqKQ=;
        b=p5P0Hn5DogbnpL8MWOtuWngg0bi2lpDv66nykLqT6ooJMQmVg/U/zu15uCf00Y6G/X
         NiG5HwUYOb/vaUm9xq4QPy/hIPaAUo+9YZqfS6/0GS7x2rujheks4Gze8A45SsvEvWyt
         lleXfWZDQWbzMrXbCxXV7NvLu8odH8S4vyVEzwRjLTEBhxWUp3LjY12MjyotKuojiVr1
         aO5Aa+q2Or/Qrvup1GAO7lZbxX9i7S7o+R36CjaWrvHRLIH60UBUIrGceb/rxc4qzta+
         ZKE8PU4mmqR7E+7RO33meN4viiafXzSDEneh7VfDBhSVwxamcnK5HjAPWU5e1+RWSIvg
         EmvA==
X-Gm-Message-State: AGi0PuZ/kj936vUL48VtHRQzQa5o7A5lm6H7txbDT1UaHYoN8GorKyes
        g9+kmjzrIylHvsxlR3pxiiXlMw==
X-Google-Smtp-Source: APiQypLqKqGGiP1/sf/taBiiQNFrD+V9RPMvEkZHZME7janiP8RehwEHD0O/256zPiMPw8/rVadCwg==
X-Received: by 2002:a05:620a:12fa:: with SMTP id f26mr282331qkl.374.1586445030295;
        Thu, 09 Apr 2020 08:10:30 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id y21sm21347011qka.37.2020.04.09.08.10.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Apr 2020 08:10:29 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: KCSAN + KVM = host reset
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <CANpmjNMiHNVh3BVxZUqNo4jW3DPjoQPrn-KEmAJRtSYORuryEA@mail.gmail.com>
Date:   Thu, 9 Apr 2020 11:10:28 -0400
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "paul E. McKenney" <paulmck@kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B7F7F73E-EE27-48F4-A5D0-EBB29292913E@lca.pw>
References: <E180B225-BF1E-4153-B399-1DBF8C577A82@lca.pw>
 <fb39d3d2-063e-b828-af1c-01f91d9be31c@redhat.com>
 <017E692B-4791-46AD-B9ED-25B887ECB56B@lca.pw>
 <CANpmjNMiHNVh3BVxZUqNo4jW3DPjoQPrn-KEmAJRtSYORuryEA@mail.gmail.com>
To:     Marco Elver <elver@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Apr 9, 2020, at 3:03 AM, Marco Elver <elver@google.com> wrote:
>=20
> On Wed, 8 Apr 2020 at 23:29, Qian Cai <cai@lca.pw> wrote:
>>=20
>>=20
>>=20
>>> On Apr 8, 2020, at 5:25 PM, Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>>>=20
>>> On 08/04/20 22:59, Qian Cai wrote:
>>>> Running a simple thing on this AMD host would trigger a reset right =
away.
>>>> Unselect KCSAN kconfig makes everything work fine (the host would =
also
>>>> reset If only "echo off > /sys/kernel/debug/kcsan=E2=80=9D before =
running qemu-kvm).
>>>=20
>>> Is this a regression or something you've just started to play with?  =
(If
>>> anything, the assembly language conversion of the AMD world switch =
that
>>> is in linux-next could have reduced the likelihood of such a =
failure,
>>> not increased it).
>>=20
>> I don=E2=80=99t remember I had tried this combination before, so =
don=E2=80=99t know if it is a
>> regression or not.
>=20
> What happens with KASAN? My guess is that, since it also happens with
> "off", something that should not be instrumented is being
> instrumented.

No, KASAN + KVM works fine.

>=20
> What happens if you put a 'KCSAN_SANITIZE :=3D n' into
> arch/x86/kvm/Makefile? Since it's hard for me to reproduce on this

Yes, that works, but this below alone does not work,

KCSAN_SANITIZE_kvm-amd.o :=3D n

I have been able to reproduce this on a few AMD hosts.

> exact system, I'd ask you to narrow it down by placing 'KCSAN_SANITIZE
> :=3D n' into suspect subsystems' Makefiles. Once you get it to work =
with
> that, we can refine the solution.
>=20
> Thanks,
> -- Marco

