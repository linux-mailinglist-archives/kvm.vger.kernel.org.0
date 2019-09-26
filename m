Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C53ABBEF78
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2019 12:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbfIZKVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 06:21:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfIZKVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 06:21:47 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A4E889AC5
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 10:21:46 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id t11so737359wro.10
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 03:21:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=smZP7Ak6TUdAStHczxY+TFyiyW4XCmuQsrVLOpFovYM=;
        b=lXgASIBhhheIrQCIQxDLPcjL1IgZAueQfDJB9WD5ZYi5ZCLr5pCqctXJztt+fk8IA4
         vQjM2DSIRm1/bENrZB6zLD5RCKuIVM+uL3NLYvLGp1lPjYIS9pbJszXVgnpckGLa8AO4
         QBlWc4XkdkaQBN9Znot+hYO35bwLqbUWHOgJaXXGOaxBiKUjEQuhBVi1fJ8pD/Jc4cfl
         eqyoOvUdL8Wu6s/3Nct5olmnho6V7gT8Pw0TmIVoIImZGoHpUqeYu2oyAWMR3E9LhdYl
         VdGFxlYCGDTsAQJEgUjL4ximF4c6EZe9sABwFtUSndDmv0eWWy/a5l4SIx77Lf4fdbxI
         XJDw==
X-Gm-Message-State: APjAAAUOY7QaybDEhrRGeSoj+ugJWls3yuoEoglHMrVrSLgZo6EIdnvv
        6gKhXv4IOKnCmNIHtXu+mvTjCD9QqS6Ds0uAriXNVXTdV/FrzWFFgY9Y8WrhVURfoy0Ynabf42/
        QfyLSR7PkD/+j
X-Received: by 2002:adf:e4c9:: with SMTP id v9mr2252013wrm.396.1569493304502;
        Thu, 26 Sep 2019 03:21:44 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzEM1fJqjAcO3LNo8fGTeDwLMKXZ7bAIxM/22o/XdAKAvgSAD+0JBY98xZxQ2RFhxoJt3IYgQ==
X-Received: by 2002:adf:e4c9:: with SMTP id v9mr2251984wrm.396.1569493304168;
        Thu, 26 Sep 2019 03:21:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id x6sm2565779wmf.35.2019.09.26.03.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 03:21:43 -0700 (PDT)
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine
 type
To:     Sergio Lopez <slp@redhat.com>
Cc:     qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
        marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
        philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
        mtosatti@redhat.com, kvm@vger.kernel.org
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-8-slp@redhat.com>
 <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87a7ass9ho.fsf@redhat.com>
 <d70d3812-fd84-b248-7965-cae15704e785@redhat.com> <87o8z737am.fsf@redhat.com>
 <92575de9-da44-cac4-5b3d-6b07a7a8ea34@redhat.com> <87k19v2whk.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b02ada95-9853-ff21-cc14-ca0acf48782a@redhat.com>
Date:   Thu, 26 Sep 2019 12:21:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87k19v2whk.fsf@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9YieZgL59Jn4Hc9ihwvFTlw1Wh8CxdCFs"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9YieZgL59Jn4Hc9ihwvFTlw1Wh8CxdCFs
Content-Type: multipart/mixed; boundary="Qm5zknIqrXaGsQ4AktEFQXxQ0ieqpoL6p";
 protected-headers="v1"
From: Paolo Bonzini <pbonzini@redhat.com>
To: Sergio Lopez <slp@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, imammedo@redhat.com,
 marcel.apfelbaum@gmail.com, rth@twiddle.net, ehabkost@redhat.com,
 philmd@redhat.com, lersek@redhat.com, kraxel@redhat.com,
 mtosatti@redhat.com, kvm@vger.kernel.org
Message-ID: <b02ada95-9853-ff21-cc14-ca0acf48782a@redhat.com>
Subject: Re: [PATCH v4 7/8] docs/microvm.txt: document the new microvm machine
 type
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-8-slp@redhat.com>
 <23a6e891-c3ba-3991-d627-433eb1fe156d@redhat.com> <87a7ass9ho.fsf@redhat.com>
 <d70d3812-fd84-b248-7965-cae15704e785@redhat.com> <87o8z737am.fsf@redhat.com>
 <92575de9-da44-cac4-5b3d-6b07a7a8ea34@redhat.com> <87k19v2whk.fsf@redhat.com>
In-Reply-To: <87k19v2whk.fsf@redhat.com>

--Qm5zknIqrXaGsQ4AktEFQXxQ0ieqpoL6p
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 26/09/19 12:16, Sergio Lopez wrote:
>> If KVM is in use, the
>> LAPIC timer frequency is known to be 1 GHz.
>>
>> arch/x86/kernel/kvm.c can just set
>>
>> 	lapic_timer_period =3D 1000000000 / HZ;
>>
>> and that should disabled LAPIC calibration if TSC deadline is absent.
> Given that they can only be omitted when an specific set of conditions
> is met, I think I'm going to make them optional but enabled by default.=


Please do introduce the infrastructure to make them OnOffAuto, and for
now make Auto the same as On.  We have time to review that since microvm
is not versioned.

Thanks,

Paolo

> I'll also point to this in the documentation.




--Qm5zknIqrXaGsQ4AktEFQXxQ0ieqpoL6p--

--9YieZgL59Jn4Hc9ihwvFTlw1Wh8CxdCFs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE8TM4V0tmI4mGbHaCv/vSX3jHroMFAl2MkTUACgkQv/vSX3jH
roMM2ggAnECT7ubOBQLjvDUBtboi+CrQQam36JptZSdfukZ+IOvo8HeLcvVLjNYa
wkCBraN7W92ZXp2tlJUUuADE6Jhaij+J1Vx0Bw8foVtpsDufNd97FhxIHhu9SeV9
VS3z3pyDQSWDunuAqRn+TvHkbYFrURiXPsxb7Lw03VxRSVC3sGdjt1pUuWzO26YW
zsKPPwqdD4TJ5zTSSJWXeOFN/x02sOlCMZWAq2ND0mej793VAYLOwIUVS13xaBCX
3Asa7f0sAqRvCW5wyHEfMJuC4fUxPq3pI9vuSlzKmO5Hx4v7lxi2MgZplje6L2V4
hFFTOvohRluh378NNk93f6Xc6LRcAw==
=COY9
-----END PGP SIGNATURE-----

--9YieZgL59Jn4Hc9ihwvFTlw1Wh8CxdCFs--
