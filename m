Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0812E5893B
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 19:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfF0RrF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 13:47:05 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39960 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727327AbfF0RrE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 13:47:04 -0400
Received: by mail-pf1-f194.google.com with SMTP id p184so1590445pfp.7
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 10:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=m0D3ByKjyUoPXDQmMuoSMyf7Dx4Y6Qlu0x8S5Z+3Ll0=;
        b=kZFQ+KEikgcimsVMfQWpwQcJdlpuFgMKe8aXgYC5TVy36K6Sg+xxp3TlJL+oDUwi9t
         uoviuhInrUQ//XZwJqbXGDLAoBHOsuWJmvlW2iHZ0qrcc3qtUQRMx0pHhC4j5/2rBQjd
         X0tShazV2NemTBaOVwVKPZZGkTW/fD5LzdkRpsCDBJzsc+6CinHBLIBl4KoUWS8KFZIa
         /33L+jNluGIHPb0wQW7oyvIzRkQ7EMO3YyKH0SxkkXtJeRhna49jYhv5ZsjETi/qWcIS
         R6FtGnDk4nxfn3R4c2odYea2+MkIluY1P3S3XZ9Tl94abjpu3r4c0wR1VKKUEkOchN//
         wRvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=m0D3ByKjyUoPXDQmMuoSMyf7Dx4Y6Qlu0x8S5Z+3Ll0=;
        b=CJ/ADuFyA6af4ZHLiQXMkyN74bX2Jj5bRS9Cqnr9c+nAFKthFL5DWiIyR1djALdzUr
         KM4xfqseRJ2emxlP385x76hzJd1PA209ZJzHHzMwbnigGThyk5n9uII90Gj/dDszk00e
         Z/E6iPuTd7DfsxYA/eBaetAH1GZ6uOIS7A/yTGufiw/c4XOHq1K8QE0g2eN0HlQWyLxg
         GdXZpqolaEHPJVaTpn+ZWNHX+gp59QGplFUj42HxcGkmGlES6CG8sogv4dxhewKMKTy6
         Ozv7JPtSBgTPfM/04DwHLa7TZ1YAYhv62pA8MSWgI86qqaeiDs8yvm5DrMrAY/OU9hPi
         hduw==
X-Gm-Message-State: APjAAAX8EtEXEINQEvu+KHVSsb0gpbPr/X28wfpKv+4VJGjRIT+7CfrG
        tMPv2/PwRTJEYvZbiccwAKo=
X-Google-Smtp-Source: APXvYqyZLCo3XXBQQrnxsEXxf8PmQoxkLXtnkuF77Iq20u2gorQEExHJxFtHxS3GwB+scEIdgSrWBw==
X-Received: by 2002:a65:5148:: with SMTP id g8mr4902413pgq.206.1561657623779;
        Thu, 27 Jun 2019 10:47:03 -0700 (PDT)
Received: from [10.33.114.148] ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id x6sm5433108pjp.18.2019.06.27.10.47.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:47:03 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH] x86: Reset lapic after boot
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <9df90756-003e-0c0f-984e-07293fdc2eb1@oracle.com>
Date:   Thu, 27 Jun 2019 10:47:02 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DE050F27-B554-4F02-8986-9EFF6B92EAD9@gmail.com>
References: <20190625121042.8957-1-nadav.amit@gmail.com>
 <9df90756-003e-0c0f-984e-07293fdc2eb1@oracle.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 26, 2019, at 5:26 PM, Krish Sadhukhan =
<krish.sadhukhan@oracle.com> wrote:
>=20
>=20
> On 6/25/19 5:10 AM, Nadav Amit wrote:
>> Do not assume that the local APIC is in a xAPIC mode after reset.
>> Instead reset it first, since it might be in x2APIC mode, from which =
a
>> transition in xAPIC is invalid.
>>=20
>> Note that we do not use the existing disable_apic() for the matter,
>> since it also re-initializes apic_ops.
>=20
>=20
> Is there any issue if apic_ops is reset ?

So I checked again, and actually the problem was different. Beforehand, =
I
used reset_apic(), which used apic_ops to write to SPIV. And the race =
with
setting x2apic caused it to occasionally use the x2APIC MSR interface to =
set
SPIV, which triggered an exception.

I=E2=80=99ll send v2 that changes reset_apic() not to use apic_ops.

Thanks.=
