Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0BBBD9CC
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 10:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634097AbfIYI0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 04:26:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59404 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390395AbfIYI0h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 04:26:37 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C710F63704
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 08:26:36 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id b6so1967452wrx.0
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 01:26:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=kdp2HK44+wXsmn1byX79nXIhx1QZosWrpcPRfuVl4VE=;
        b=GuLu5nESer56I4YsKu8fxhDwBjDaSrDIiaUYmvtipuevouhXKYcZJk2jpZgnoNVNo7
         Di2pB5p22FVXhw1z7jEAOubar7rEEdxvoH7KXoFqocZvvhscPOJj9lb1Z0CenqUj/CtZ
         7fZrKnVeD7b5GC5PkF5SeW10Jc1paX3eZFFviHQppYx7Ls/ipK8PpXKOp6VJpcTqvbt4
         p+BSA1yPZu958dcQQ3R4MIdLgCfruCLNuZms1/fDBGlEhR0pyblzDQ/FfsOmIKsVNqEm
         8ZMZ406Eng7f0f6VLD2bJHePq9j75mWZkZOvV8PiMPDs9EnOP2Xh88/xNST33SvmYNI4
         sBJw==
X-Gm-Message-State: APjAAAUksuzjUveiESyy9Jpq94QzZGPFI3MduQX8jz7/K5LAzLDk2XoX
        3+t8dYs1EAhd6NHx5vUCcUu6s0vZy7ynTA8hDBcUaaNmrHqrB+JN8WOlNlmO9CRN2c9m1fgvDO2
        jqfmBPmenEFfE
X-Received: by 2002:a5d:5384:: with SMTP id d4mr7574946wrv.255.1569399995298;
        Wed, 25 Sep 2019 01:26:35 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxt0NJ+/zWQ2hkmAlnPIduPMhGlmGSIRxYlETHvmC3yOWQVUoa/p3E0PmoTSTUwZbct1OuxrQ==
X-Received: by 2002:a5d:5384:: with SMTP id d4mr7574922wrv.255.1569399995039;
        Wed, 25 Sep 2019 01:26:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id h125sm3440454wmf.31.2019.09.25.01.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 01:26:34 -0700 (PDT)
Subject: Re: [PATCH v4 0/8] Introduce the microvm machine type
To:     Sergio Lopez <slp@redhat.com>, David Hildenbrand <david@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org,
        Pankaj Gupta <pagupta@redhat.com>
References: <20190924124433.96810-1-slp@redhat.com>
 <c689e275-1a05-7d08-756b-0be914ed24ca@redhat.com> <87h850ssnb.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b361be48-d490-ac6a-4b54-d977c20539c0@redhat.com>
Date:   Wed, 25 Sep 2019 10:26:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87h850ssnb.fsf@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="F2FwA6MWePplJqqD6t4ZbkIJfHLH21rUa"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--F2FwA6MWePplJqqD6t4ZbkIJfHLH21rUa
Content-Type: multipart/mixed; boundary="cBcTRQtO2qa6ms4Ydaw0MIaVu5vpj9lLR";
 protected-headers="v1"
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sergio Lopez <slp@redhat.com>, David Hildenbrand <david@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
 marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
 philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
 mtosatti@redhat.com, kvm@vger.kernel.org, Pankaj Gupta <pagupta@redhat.com>
Message-ID: <b361be48-d490-ac6a-4b54-d977c20539c0@redhat.com>
Subject: Re: [PATCH v4 0/8] Introduce the microvm machine type
References: <20190924124433.96810-1-slp@redhat.com>
 <c689e275-1a05-7d08-756b-0be914ed24ca@redhat.com> <87h850ssnb.fsf@redhat.com>
In-Reply-To: <87h850ssnb.fsf@redhat.com>

--cBcTRQtO2qa6ms4Ydaw0MIaVu5vpj9lLR
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 25/09/19 10:10, Sergio Lopez wrote:
> That would be great. I'm also looking forward for virtio-mem (and an
> hypothetical virtio-cpu) to eventually gain hotplug capabilities in
> microvm.

I disagree with this.  virtio is not a silver bullet (and in fact
perhaps it's just me but I've never understood the advantages of
virtio-mem over anything else).

If you want to add hotplug to microvm, you can reuse the existing code
for CPU and memory hotplug controllers, and write drivers for them in
Linux's drivers/platform.  The drivers would basically do what the ACPI
AML tells the interpreter to do.

There is no reason to add the complexity of virtio to something as
low-level and deadlock-prone as CPU hotplug.

Paolo


--cBcTRQtO2qa6ms4Ydaw0MIaVu5vpj9lLR--

--F2FwA6MWePplJqqD6t4ZbkIJfHLH21rUa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl2LJLgACgkQv/vSX3jH
roN4lgf9GWqNVZS1qNFejt/9p2cQeTMMkKEBjT0YpZzxE21zq+Jfx01+Hl5Ros9U
RqVaxBd0S2a3ijnF20NKLLtJig7faeJjx+RD9IO9iUfZeTN6sYx3x7C2rBIGHXqn
eRUN1W9n3PnZ4nSOR13oK7pILWYSHbmV3HpKCIfs0AkOGaOtNZF8o7o+pB3j47Mu
V5SASFrKqVtuGOq3W80cmVUwlj65Yir/4DYA43Z4U6FjLu7R51kgj8MSkuGlM+G7
7yM4iP6VWUNak1i0/RUoh4+2qCks5ileshZJIH5ZxwQBoL068Ky3ilW2DPhIE9RK
NC0g++t91EXj2TBkF/pAfOp7/ekIxg==
=/GvA
-----END PGP SIGNATURE-----

--F2FwA6MWePplJqqD6t4ZbkIJfHLH21rUa--
