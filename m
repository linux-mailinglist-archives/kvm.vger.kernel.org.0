Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C3DBEDF4
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 10:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbfIZI7u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 04:59:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728506AbfIZI7u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 04:59:50 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CB4BD81F2F
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 08:59:49 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id 32so647715wrk.15
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 01:59:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=edpoGsqQ65H3Og8WvxTfFnznGLy9c4jNpqmavlqEW8I=;
        b=G9btuc3oBrSjoEloHw4tWSlpUyBk5u371YtbYUoJWgKo5E6rPgxf5W+9wS1TOwzG8a
         eVkZwu86uopkNg/k7OXiRh9JVPvLogKDP8IdeIBQwiIH5RDjCCgOABIlgtSSrIzV/F1/
         ZAdidN9jIm4gPO9BvrqQNgWC5yGk1zElm6DRcRplKAUJf9oSX0AMV2owho6tmkP4EKW/
         BNKghHDYSK3JwV+jJBh6MS4t/B83jB8SGO19wb86xafIJwiFqGq8vQxlKeqBkz2Tydub
         6Z0JaxFcpj/8kuFjXNbi5W+mPoaZgkhE2LUqCZdtPVDXl4KaFRrZUbtWmegh4d0FMC/v
         Petg==
X-Gm-Message-State: APjAAAXIry1oQ3MYyr9aZRNN9tyU10sFrbHevhD9+Ig69whiPICt0rYK
        SIDCfzuI9ymNdGn1QwOyoXbvtdTd4GPaaZ+35r9C4hQgo7ursstCSkFRxiknv6NvB/kysEoas1p
        /glccKlIcq0zs
X-Received: by 2002:a1c:a853:: with SMTP id r80mr1976697wme.140.1569488388136;
        Thu, 26 Sep 2019 01:59:48 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyAUmUjHA/DfTedbR1Linvyr8n0uou69CP7kzs/Vp8bLNQl7s5q41Y3O/WX+P+knoO7zLlXMw==
X-Received: by 2002:a1c:a853:: with SMTP id r80mr1976667wme.140.1569488387812;
        Thu, 26 Sep 2019 01:59:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id g4sm2290486wrw.9.2019.09.26.01.59.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 01:59:46 -0700 (PDT)
Subject: Re: [PATCH v4 8/8] hw/i386: Introduce the microvm machine type
To:     Sergio Lopez <slp@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        lersek@redhat.com, kraxel@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-9-slp@redhat.com>
 <061b720c-2ef2-b270-f18b-b0619573862d@redhat.com> <87muer36sd.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <95d0dc60-c418-4ad3-a0f7-dba0ff50515a@redhat.com>
Date:   Thu, 26 Sep 2019 10:59:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87muer36sd.fsf@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mBw58v5fqflKGijhL5FZIGYsU0C7MbX9K"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mBw58v5fqflKGijhL5FZIGYsU0C7MbX9K
Content-Type: multipart/mixed; boundary="EoJheJKDNp7fTYfkQWiKwoABRgq4OkHsM";
 protected-headers="v1"
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sergio Lopez <slp@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?=
 <philmd@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
 marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
 lersek@redhat.com, kraxel@redhat.com, mtosatti@redhat.com,
 kvm@vger.kernel.org
Message-ID: <95d0dc60-c418-4ad3-a0f7-dba0ff50515a@redhat.com>
Subject: Re: [PATCH v4 8/8] hw/i386: Introduce the microvm machine type
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-9-slp@redhat.com>
 <061b720c-2ef2-b270-f18b-b0619573862d@redhat.com> <87muer36sd.fsf@redhat.com>
In-Reply-To: <87muer36sd.fsf@redhat.com>

--EoJheJKDNp7fTYfkQWiKwoABRgq4OkHsM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 26/09/19 08:34, Sergio Lopez wrote:
>> Isn't this inherited from TYPE_X86_MACHINE?
> Good question. Should we assume all x86 based machines have NMI, or jus=
t
> leave it to each board?

NMI is hardcoded to exception 2 in the processor so it is there in all
x86 machines.

Paolo


--EoJheJKDNp7fTYfkQWiKwoABRgq4OkHsM--

--mBw58v5fqflKGijhL5FZIGYsU0C7MbX9K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl2MfgEACgkQv/vSX3jH
roPZEQf8CbicOml/CMfSZdGdwKF012b22PpkdV0y1zJok7WLvGoKWe5ul4k+liSH
9k7YH2KoP2bKMwxai0uO5S7AMRm8OR0GzDlSDHT1r9kzhL/ZjrQi2cHa5ssGy4aS
Y+q4svGEZ3DoGBY0xJ5DqJBm1WEHhuRY96xgt/FiHpmOOeHhuFyAp5LQYqhC5stb
WF4/tDJVo00Ajrtm0FjQaSBOzadZwEanShhlF3EOHCumcLhsATiQOnxV4/QfUkDN
zU7Pb6Y21L/oJqJe/rdBrrJj6deREGspRqT+C3YALHkT8LV44rtTKM0g231g5Acr
Dl98TIPRYiP11SRAiwOKzBvQwuP/4w==
=JDZc
-----END PGP SIGNATURE-----

--mBw58v5fqflKGijhL5FZIGYsU0C7MbX9K--
