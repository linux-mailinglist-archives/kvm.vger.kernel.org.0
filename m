Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDFCBE0C7
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 17:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731359AbfIYPEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 11:04:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfIYPEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 11:04:42 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ED628796ED
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 15:04:41 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id q10so2502372wro.22
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 08:04:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=pLATcdGpRsaJe0HMHluCJ9++bIY/2wR5B6HNVL8voTk=;
        b=IIvSTYr1TJ2UTi61id8WSHNiy98/MGhKDfV7G6OHZlidGk7f3mPIkcXDDmEC/sGmwx
         Rz/ZeWuOPQrR1Shrl7wKbJ30LpcinKUU2Vb7iGJvisByuvMT7t6f9vaA2AgmRvZnk/U7
         lCvjHG2e3yXuZ11oG/cvajwALi70hQkp6frRHw2eBb02TS+DqY57hUEMcUVaq8xnxMFe
         XrxmfZ9I2oHaJDcZbLU7BAM3MkhLXYMmeEDi+khowX1jXrbdMbdh4a6PRAvVZUO4LX/C
         4DfTEXiOsI7v49gGxRmXXryaLgkAR6ImKWPiFde2REpEUdv7vQ8xSuPeHTyNmZlEsI+m
         F1Hg==
X-Gm-Message-State: APjAAAWa2XuDMpihGSX9XDoHfJJq4kKlK9gG6rBXpo4HhIMjOzXloBht
        JDzSWqM3tgPT2ytTyIvM6MigYNaHRDoDNw0GrwbA1/j1h1boSy1hyj9Xjtl+kuIJY7/Cv6gTvVn
        cfI7jjXFm6FxV
X-Received: by 2002:a1c:658b:: with SMTP id z133mr8495189wmb.130.1569423880124;
        Wed, 25 Sep 2019 08:04:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwstO6O1CI8De4rqaohqlMbBBY47FrzUX4GAHLRSeSPlpVuyJ+L9+SDKUZQU+6rM5EaySPTNQ==
X-Received: by 2002:a1c:658b:: with SMTP id z133mr8495167wmb.130.1569423879921;
        Wed, 25 Sep 2019 08:04:39 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id c10sm8745245wrf.58.2019.09.25.08.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 08:04:38 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-8-slp@redhat.com> <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine type
In-reply-to: <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com>
Date:   Wed, 25 Sep 2019 17:04:19 +0200
Message-ID: <87a7ass9ho.fsf@redhat.com>
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
>> +Microvm is a machine type inspired by both NEMU and Firecracker, and
>> +constructed after the machine model implemented by the latter.
>
> I would say it's inspired by Firecracker only.  The NEMU virt machine
> had virtio-pci and ACPI.
>
>> +It's main purpose is providing users a minimalist machine type free
>> +from the burden of legacy compatibility,
>
> I think this is too strong, especially if you keep the PIC and PIT. :)
> Maybe just "It's a minimalist machine type without PCI support designed
> for short-lived guests".
>
>> +serving as a stepping stone
>> +for future projects aiming at improving boot times, reducing the
>> +attack surface and slimming down QEMU's footprint.
>
> "Microvm also establishes a baseline for benchmarking QEMU and operating
> systems, since it is optimized for both boot time and footprint".
>
>> +The microvm machine type supports the following devices:
>> +
>> + - ISA bus
>> + - i8259 PIC
>> + - LAPIC (implicit if using KVM)
>> + - IOAPIC (defaults to kernel_irqchip_split = true)
>> + - i8254 PIT
>
> Do we need the PIT?  And perhaps the PIC even?
>

I'm going back to this level of the thread, because after your
suggestion I took a deeper look at how things work around the PIC, and
discovered I was completely wrong about my assumptions.

For virtio-mmio devices, given that we don't have the ability to
configure vectors (as it's done in the PCI case) we're stuck with the
ones provided by the platform PIC, which in the x86 case is the i8259
(at least from Linux's perspective).

So we can get rid of the IOAPIC, but we need to keep the i8259 (we have
both a userspace and a kernel implementation too, so it should be fine).

As for the PIT, we can omit it if we're running with KVM acceleration,
as kvmclock will be used to calculate loops per jiffie and avoid the
calibration, leaving it enabled otherwise.

Thanks,
Sergio.




--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2LgfMACgkQ9GknjS8M
AjVOng/8D9mG+yeOmoGNjoqwhkfwuEOAeFQyZh577lA14fZmUL/2Ll1POHzG+VUR
JEtcR7MMYoF7vpZetsuuuvxUmxG9euzAxtpDEi7DcIeIpevAUQClLFpNk/YCk+UG
PoubELTebT4VLw8UoeCGnew8FzglDYpTvL/JJ+aGH4NROy6S7dzjIjCGkLGyHIE0
kqZx98/SI7yrByCP6GvND9dQAl2fHjQroYhrYUZH5sK+rCFdtMFY7eSjmWjezjLL
wY2k1yaRkmURkqflPZKUeudKG3bMltnZpv0kfadyJS6m5d0RMC7dMz/roDjHJfbQ
sKrjFTBKmV0bM2gKefDKt40Aui/7iBcXj2/Eieb9au7MWKSmsVwDl9O0W3kNRiXV
G5HD8RSE+vyQ1PVrNs3voRGTjr3q0GnScakWsmJ8NfV5LDP0ST3hYea0JqYb51Dx
snIjkR5foEIEnYJoGsstr8cpbipHJQ8xnPYF3cpMmO6B1xuJL+5gjbwUHxmbHy6G
WvP4srKnB1QaAKZ4lA0UDtEgw1Wt13Tt9uY1iGmiyTOF4kp7x/LomPIFsGz5Urde
gDXh1VCQ9AOFjDGNoTpSHoNFaiCoEeBBn0vYxNCjaInT8AeYZHQNCSGXmR7yZws6
n6Emm/n8cawrcopXAPPn0S/ks+PnOC+5aN5EFgsmWdSwy2o4nDM=
=zIjv
-----END PGP SIGNATURE-----
--=-=-=--
