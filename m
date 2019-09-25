Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB355BD92A
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 09:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633982AbfIYHda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 03:33:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405164AbfIYHd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 03:33:29 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5D81850F4D
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 07:33:29 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id 32so1866032wrk.15
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 00:33:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=CuB2l1l2AW1aA9nML3ymWwi25AU3aMKPJA39BqfZBOA=;
        b=ZCKIuEEzL8louQRdK0UHxeHVFCw5YmrZemTqGkwZZUZN3nolLVW04Y1u9quUHUm+cj
         8/lUexvWuxoXq5orKZZRW2iT3kVhRT6uzEWiXZssVeHvGof8P4lX3qK4yc+U9pBKDq+Y
         SheN89t1vklptnO8GCsywwvzqBJhtrBwRpsexFHVb+BJmiAtJkRhBv3yoxAgn2b4C2Jg
         r8svBLvEuS8xHjIWGAaw4e9cUIZZNRFNrtHcsPrmSkm0bHvuSdPdtlAIe+n/gs41bf//
         PwvO0Wwmevu/xKS4q0C7HY5JwB0Ldv3h5nM3AAxLASHAoZCppbwPKkhuGX4nV6cr0+V9
         t/aQ==
X-Gm-Message-State: APjAAAUOx62NwTHY8HNpYikvB7OBsfFnatccUv7Wfa4cSHBmrdc4iSEM
        04XQcPHrSbOQEzTd8JWYdK5Qfin1UbDULnPwB573+OJhuZCa0x9z8hnkHBRVEmYLF003nF4DRDs
        MoEPui4tCHoi7
X-Received: by 2002:a5d:51d2:: with SMTP id n18mr7531920wrv.10.1569396807741;
        Wed, 25 Sep 2019 00:33:27 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx3TyvI/tukpUJDUD7w//YM87kZq+CXXLiEYXSPShzH6WwxctW/KKDXl2aWRIBMKFShb5sZDg==
X-Received: by 2002:a5d:51d2:: with SMTP id n18mr7531893wrv.10.1569396807538;
        Wed, 25 Sep 2019 00:33:27 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id z9sm5560762wrp.26.2019.09.25.00.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 00:33:26 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <20190924124433.96810-8-slp@redhat.com> <20190925050629.lg5w6vvikxtgddy6@sirius.home.kraxel.org>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, pbonzini@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, philmd@redhat.com, lersek@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine type
In-reply-to: <20190925050629.lg5w6vvikxtgddy6@sirius.home.kraxel.org>
Date:   Wed, 25 Sep 2019 09:33:12 +0200
Message-ID: <87impgsudj.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--=-=-=
Content-Type: text/plain


Gerd Hoffmann <kraxel@redhat.com> writes:

>   Hi,
>
>> +microvm.kernel-cmdline=bool (Set off to disable adding virtio-mmio devices to the kernel cmdline)
>
> Hmm, is that the long-term plan?  IMO the virtio-mmio devices should be
> discoverable somehow.  ACPI, or device-tree, or fw_cfg, or ...

I'd say that depends on the machine type. ARM's virt and vexpress do
support virtio-mmio devices, adding them to a generated DTB.

For microvm that's simply not worth it. Fiddling with the command line
achieves the same result without any significant drawbacks, with less
code and less consumed cycles on both sides.

>> +As no current FW is able to boot from a block device using virtio-mmio
>> +as its transport,
>
> To fix that the firmware must be able to find the virtio-mmio devices.

No FW supports modern virtio-mmio transports anyway. And, from microvm's
perspective, there's little incentive to change this situation, given
that it's main use cases (serverless computing and VM-isolated
containers) will run with an external kernel.

Thanks,
Sergio.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2LGDgACgkQ9GknjS8M
AjUGFA/9En3xpwaRRlk8noOWngoaHWQN83Ugk1tJ6/lQackkpCwakxv+Bhupj9C4
bdw0Fa7nwIKDfEWx5j/iQH8ig1pyw7qWAlJaZuo09XAW2qkBdIvacyTuIK9z/Xxz
C2IXRdIY1X90ovNqrZPCX48TtUlGBgCBB8CTMBMktKmA1aqcGahzzHYJE7B24iRo
onXEy5w3Hss6ln+voTgOvLHtrJ+qBAE92h+UjdICIa748gGWqGI8HjqEIDjMUZfb
VjxlzR+0U92kOGH6bQmc+inVENltSAlyEC5PuzKUZ8X24VGFae1EHY3nAB9wKtPI
uxGsqNYJIxliWSwMOEWJzde81b3H30l9dYhxbQKfZri4oOIfr/EG4pAARSKjsZBI
pZMe9C5eNeCWcfaHA59SHR7Sw4XBdgU+xekL8RR5lCgYz4DYPlVd+1ny6IKcUICV
aZdY0SYC0eOWVHaAsphjEHf6c+WTQ9CZkC/Wzha8UgGMsL3s0oU6nRcUhIe1LVL/
Gv75N19Ji+XW2fSRYLi7WMXL7hpgQxWzJ4H8G4ijb88tBtHlGttHlnxtj7g/PIvp
9w90y+xdK6JXzRYOTwGzN8TSMBmUeEkgUT2EiWCPZNCAZrze0WliEktUBN1g+rsQ
c74pQhEfC8cAPWMHpGgn1/vsz7K8YOi6KDuoPNpcVOEAkBNcjhs=
=McNV
-----END PGP SIGNATURE-----
--=-=-=--
