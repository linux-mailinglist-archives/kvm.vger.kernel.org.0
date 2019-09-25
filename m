Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 883C2BDA0D
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 10:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442834AbfIYIm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 04:42:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406947AbfIYIm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 04:42:58 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 91367356C9
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 08:42:57 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id f63so1579778wma.7
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 01:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=DSLVV75qLw+0N8nWOMHDHQtfO/A+RcSSsvRG5jZ6FLE=;
        b=tgDFiaeJns3SA2sW/TZzSk2anAsQuo7EryyGfdQcqPhIzwtS+WxJvTVuk+C08LA9Fv
         Dic5LxwWbDeEPlqY4SSDuh28vKWuPXHkxNbIrF9HNzKG2FN43YOVw894LwEQ5tHEzm2k
         HcxI7PSRKEpFdIavyVvhNrjKdjQWnJsj8rMkMLmBgm9lLiXosL05emiACgodfAdvuT3X
         DNuFVXCj4fG9T+IPFoJQsA5rFnKDaHHaLW7DxuyiXPKyQ72hadEl/+XySIUbEtqI+gIV
         JvLRxnIbuASyxz7BxOKxTJowXgFsFI+VkH+CBhsrEoOuwwtWcbrgq0NtO67R3kiUcYZi
         ERmg==
X-Gm-Message-State: APjAAAWpKsoRxXmdjSEKSIU08q8MZeV+iMDw9pSk8Hx9HQnkWS56r+5I
        atnSYmYJHrgEzblq3neR8ueDtuWz0UTP6fo+rCeUGzNo2YvOxi8Ax2lq+xP84GH8nG1J8GjxzPh
        bBVLtODfqaZni
X-Received: by 2002:a5d:408c:: with SMTP id o12mr8297692wrp.312.1569400976333;
        Wed, 25 Sep 2019 01:42:56 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzny/fqoh9pLCUGBbConFyB9yzWPkbpAcxV4AFu5NCBiaU62CK8YJ+1ObNq5HuPImpCnplucw==
X-Received: by 2002:a5d:408c:: with SMTP id o12mr8297661wrp.312.1569400976138;
        Wed, 25 Sep 2019 01:42:56 -0700 (PDT)
Received: from dritchie.redhat.com (139.red-95-120-215.dynamicip.rima-tde.net. [95.120.215.139])
        by smtp.gmail.com with ESMTPSA id r20sm7242022wrg.61.2019.09.25.01.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 01:42:55 -0700 (PDT)
References: <20190924124433.96810-1-slp@redhat.com> <c689e275-1a05-7d08-756b-0be914ed24ca@redhat.com> <87h850ssnb.fsf@redhat.com> <b361be48-d490-ac6a-4b54-d977c20539c0@redhat.com>
User-agent: mu4e 1.2.0; emacs 26.2
From:   Sergio Lopez <slp@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org,
        mst@redhat.com, imammedo@redhat.com, marcel.apfelbaum@gmail.com,
        rth@twiddle.net, ehabkost@redhat.com, philmd@redhat.com,
        lersek@redhat.com, kraxel@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, Pankaj Gupta <pagupta@redhat.com>
Subject: Re: [PATCH v4 0/8] Introduce the microvm machine type
In-reply-to: <b361be48-d490-ac6a-4b54-d977c20539c0@redhat.com>
Date:   Wed, 25 Sep 2019 10:42:53 +0200
Message-ID: <87ef04sr5e.fsf@redhat.com>
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

> On 25/09/19 10:10, Sergio Lopez wrote:
>> That would be great. I'm also looking forward for virtio-mem (and an
>> hypothetical virtio-cpu) to eventually gain hotplug capabilities in
>> microvm.
>
> I disagree with this.  virtio is not a silver bullet (and in fact
> perhaps it's just me but I've never understood the advantages of
> virtio-mem over anything else).
>
> If you want to add hotplug to microvm, you can reuse the existing code
> for CPU and memory hotplug controllers, and write drivers for them in
> Linux's drivers/platform.  The drivers would basically do what the ACPI
> AML tells the interpreter to do.
>
> There is no reason to add the complexity of virtio to something as
> low-level and deadlock-prone as CPU hotplug.

TBH, I haven't put much thought into this yet. I'll keep this in mind
for the future.

Thanks,
Sergio.


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAl2LKI0ACgkQ9GknjS8M
AjUOcw//asDU7g+IT2n1QL1G8ghvi8LC72TH/OKWfz+/vM87Ew67KKFspC7j9M2m
YzudkTR2GElf077XpYnHyKyPNX49f8DntNAn6ujj28U+/Hxmn3cMC5g50/+n4NYF
pY6pRX60uNRD11PsM+jWy6az/NwZevef9SPiZ5W5BCJ4ewPid+3rwyhKLNijIZq0
0f9LjQHONB5uI4P5pZtEN3Dt7bLueh4Galn0KxrsD7lqLPVZAfqWI0d0lK59B3hQ
RP2WErMfdq118/Yv9PAaCLc7D3zEyqJt9PfWaeK4ceWxqWu9XyHmzZpWWdhgxCF3
3Yb2zsDhPka+TrpfVtGGRIjOi3R06+8jLjyVxdN2tVB3qjaNlW3fJYes9aY2ojBT
JSAw62meToMHTER7fT3CBor7clPJDWnxUP4X053CGjXIJvzyeuDTDwxPDx/5VSZN
6v5hhwapFsO08HNsD0UqurpoKhH5a2xsbqVL06HTyjk4hJpVPHTwUoeYjzJN5dm6
q52DScdxz78bXqfYKg/5Ej+W3aOKoBwedWEYt9JZpmlzXZVmGN9Cg/naL/9fKSS4
tVcIJ9rnn1/2HJAO1XHLb9iuiDCHYI7Nr6nlnpPrRF1MRj75J3kClrXW4w3T0EiB
BNPNeYqU4XJb8j5Z7SACRNhLz/aUSjvP+yhVBQC/GabJtWK/h/0=
=QDtu
-----END PGP SIGNATURE-----
--=-=-=--
