Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11AC9BED4B
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 10:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfIZIWT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 04:22:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31749 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfIZIWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 04:22:19 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A9E8EC08C325
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 08:22:18 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id t11so609870wro.10
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 01:22:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=L5O1kmRhQ9uti81iZw7t4dCg2Fpyg6HhGNykAVE4yJo=;
        b=tiifgCiDonK7xbnJ/n1ono4f974sZ9rQskIZM2q3ayDJvid+N/nGkMCXZaFGVXeBeB
         0DXTPLA+Pjt5/HRnKX9yhSRcetzu2FhoFPOpiSgDzViu1NeAxyzor2sL0xPwJicDd1MI
         6Y/EXGH3yQrk3LABgwDSa7CSUu4Bi/A7wds04ZlSA5rnxvQhRvQB2NGZ9R+OpCdD9VHc
         oMXV/BBCLKYN9aROuv/ASctlGos4kwOZoVc2Z7W8NFdispDw8xL9OBrQ5UmFYxlztC92
         EogT1gtsPBftUJnBCWFAIwVPIYFjS7D/x0LfRCcWJ8R0girohf8ZHuIV7RZC8w5ulcj8
         WA/A==
X-Gm-Message-State: APjAAAUOlNprFCyHP2hqae18hvQmMLEnEbLz4qMtvO/N3P8ZDDeSnVDd
        WCwFwfzCCPm+0Z198wuYz8cOZelMORXCmnDV6swrOp1aKmt2yXxCpthsKUMTcwZGPkz6SVjBlZW
        HleCUrBc//ion
X-Received: by 2002:a1c:35c9:: with SMTP id c192mr1858612wma.91.1569486137140;
        Thu, 26 Sep 2019 01:22:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzw+wnsIl3jdbfN9r5xmn6DoNFfDXR6L8cbd3/67rab9sVawMNIdQ9m1uS1vBy/TPvRtO4/lQ==
X-Received: by 2002:a1c:35c9:: with SMTP id c192mr1858595wma.91.1569486136891;
        Thu, 26 Sep 2019 01:22:16 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id a13sm2174171wrf.73.2019.09.26.01.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 01:22:16 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <7d3b903a-e696-9960-a7f0-cb45101876c5@de.ibm.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, pbonzini@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, philmd@redhat.com, lersek@redhat.com,
        kraxel@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 0/8] Introduce the microvm machine type
In-reply-to: <7d3b903a-e696-9960-a7f0-cb45101876c5@de.ibm.com>
Date:   Thu, 26 Sep 2019 10:22:12 +0200
Message-ID: <87lfub31sb.fsf@redhat.com>
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


Christian Borntraeger <borntraeger@de.ibm.com> writes:

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
> Just out of curiosity.=20
> What is the reason for not going virtio-pci? Is the PCI bus really
> that expensive and complicated?

Well, expensive is a relative term. PCI does indeed require a
significant amount of code and cycles, but that's for a good reason, as
it provides an extensive bus logic allowing things like vector
configuration, hot-plug, chaining, etc...

On the other hand, MMIO lacks any kind of bus logic, as it basically
works by saying "hey, take a look at this address, there may be
something there" to the kernel, so of course is cheaper. This makes it
ideal for microvm's aim of supporting a VM with the smallest amount of
code, but bad for almost everything else.

I don't think this means PCI is expensive. That would be the case if
there were a bus providing similar functionality while requiring less
code and cycles. And this is definitely not the case of MMIO.

In other words, I think PCI cost is justified by its use case, while
MMIO simplicity makes it ideal for some specific purposes (like
microvm).

Cheers,
Sergio.

> FWIW, I do not complain. When people start using virtio-mmio more
> often this would also help virtio-ccw (which I am interested in)
> as this forces people to think beyond virtio-pci.


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2MdTQACgkQ9GknjS8M
AjVqdw//TuWD02WrtyIPcNp1ca4WEyqPbBD1NanxFWCrzgeXG36+x9ZFphoeKukS
y/92Sl1JhUjMLcsfUvh5TjkshNRyFAV3BRoPog0IP242chfVjTCFJRaqkViCFyGO
coHzEROioOjO+lGs6OnP/RNRuQCmGcFMY4EBMTPhM6gyCGyrDcuzp6o6RM0NZxLt
Dq4pSqneNyOFsqBakcqBAxy/c9nluJhdL/MvmeTuaXiaCKhgEecR2ZYMr61e1pSk
l98t2PXevnIUZb0LUAl4bVuYNnB1WJzd4UlcCo6ixL6zHVdYJgX+5M4E7lV9pnLr
tlv9D98FRV8yXulIDEX0Zu9AKPCDyk44qV22aslhis9ST8wEFs777RW04EeAyCfw
SjyhfVmWgUII0BmdLBSCEgxAohi1r8Q9J2OAF5l0in0WCBJyOiq3l5n1WHd0Txdg
TLYX3AJgj/+PFnvmI9rw2x00UhoV8mPgZ+sTzO2aHWVF02YLwFPyeSaAQa8VM7l3
qzXgB58PZjiiS8ToGeJdSMiZ8YDqMuT+mQ31kcs8W4YH3PrAqfC8mGPnzD25NZnq
zbWqxEw1ywZbSjqS6Sh/cJogDhciviBS2qsjQ5+a1fN0dCMHCLjnQ/VMToq3fveT
SmyVstcHXIU+Ysmq20CgD/d+Ep9ok2BhbF1Tha4CDK3bHAqi9qI=
=nexF
-----END PGP SIGNATURE-----
--=-=-=--
