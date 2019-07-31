Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 612497C8B5
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 18:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbfGaQbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 12:31:33 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33825 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725209AbfGaQbd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 12:31:33 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so1666925wmd.1;
        Wed, 31 Jul 2019 09:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:reply-to:to:cc:date:in-reply-to:references
         :user-agent:mime-version;
        bh=aBeApz032cBY82NlaE/wZB1uRgdQ2+KunU+o8z0uyps=;
        b=SHr5KNNbtDdRhkUSWAXLI5qCbE2fDg9+y2YLSg0SLJV2b/baDdwhlUJOX75/cIIDaB
         V+8m9X4EuRZhg9Rs/Jt1vuLMNlVOT4kfr7isiAsrm4OcCnletrLtCFWQoF963CKgh19f
         kM+4IopiymIOiDPImMwV3aLVncVTbOu4GsFU9Mtttu5BNJkRdiVVKRGM3TnHtOlsN75F
         p7bGzhTrSv8YDZK+BPx9D6FgmWobqoVU4ILuZBURWFZr2TRfZRkTjyhISQt7pvXD5vqw
         8DZn3jE2BHv3DCRlN593hl8YdyMDuZi94QmnrzbEeQeFmvyIx4Su0DLAT0QKzK0tiZ5Q
         Y6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:user-agent:mime-version;
        bh=aBeApz032cBY82NlaE/wZB1uRgdQ2+KunU+o8z0uyps=;
        b=r/GTP0ydpARYS0Ii3ktDDOle1FnL32JGEjihJpvoz5/Yc+K/1DIEl76RWVnC5rkwv0
         gD44oSSm8wskLetmpR9xYlTXb5hJVfqQ5RNo5jQYldCA/IapSXEcEMcvO15J3UCOMzi7
         /J/+xspFEzd1HMYGUAK2Imsm0WA/rUMfvnxhAlAXWxXFId2KofbUAFHvpAmC3I2IySeP
         uGxKZ9fAwSXxzHbgl3oh42p0l7yOuLAooiWdPiTGFU0XE3HJxkyQknXMePTRJKP2Fh1q
         lIGXDU01eaWpO4QMSZS/ODBmjIatVheTeVay2BhY+WVrOt7Hs0EIlCklnpCbB1/5Cz9B
         QfCg==
X-Gm-Message-State: APjAAAV1LJ9MJW2DfxmRXy2wdyJVcCXh/4QZxBxLsobsFJr03ZUHbusT
        PSaObPwNnttDn/itoIoyXYY=
X-Google-Smtp-Source: APXvYqxh6Bv/HiQuIAWU9sMSLvgcowpXMA+p+yq7EJ4FVh9xqE/gY1bAzYLd1A4k9ca/3jrBlm1EVg==
X-Received: by 2002:a1c:7f93:: with SMTP id a141mr112184178wmd.131.1564590690106;
        Wed, 31 Jul 2019 09:31:30 -0700 (PDT)
Received: from [192.168.0.36] (87.78.186.89.cust.ip.kpnqwest.it. [89.186.78.87])
        by smtp.gmail.com with ESMTPSA id z1sm72239957wrp.51.2019.07.31.09.31.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 31 Jul 2019 09:31:28 -0700 (PDT)
Message-ID: <715155f37708852ea8075190aeb4f2ec9ab158fe.camel@gmail.com>
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
From:   Dario Faggioli <raistlin.df@gmail.com>
Reply-To: dario.faggioli@linux.it
To:     Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, Paul Turner <pjt@google.com>
Date:   Wed, 31 Jul 2019 18:31:26 +0200
In-Reply-To: <8b84ac05-f639-b708-0f7f-810935b323e8@oracle.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
         <20190712114458.GU3402@hirez.programming.kicks-ass.net>
         <1f97f1d9-d209-f2ab-406d-fac765006f91@oracle.com>
         <20190712123653.GO3419@hirez.programming.kicks-ass.net>
         <b1b7f85f-dac3-80a3-c05c-160f58716ce8@oracle.com>
         <20190712130720.GQ3419@hirez.programming.kicks-ass.net>
         <8b84ac05-f639-b708-0f7f-810935b323e8@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-fcfXGdMTNOfnauu1DZWy"
User-Agent: Evolution 3.32.3 
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--=-fcfXGdMTNOfnauu1DZWy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello all,

I know this is a bit of an old thread, so apologies for being late to
the party. :-)

I would have a question about this:

> > > On 7/12/19 2:36 PM, Peter Zijlstra wrote:
> > > > On Fri, Jul 12, 2019 at 02:17:20PM +0200, Alexandre Chartre
> > > > wrote:
> > > > > On 7/12/19 1:44 PM, Peter Zijlstra wrote:
> > > > > > AFAIK3 this wants/needs to be combined with core-scheduling=20
> > > > > > to be
> > > > > > useful, but not a single mention of that is anywhere.
> > > > >=20
> > > > > No. This is actually an alternative to core-scheduling.
> > > > > Eventually, ASI
> > > > > will kick all sibling hyperthreads when exiting isolation and
> > > > > it needs to
> > > > > run with the full kernel page-table (note that's currently
> > > > > not in these
> > > > > patches).
>=20
I.e., about the fact that ASI is presented as an alternative to
core-scheduling or, at least, as it will only need integrate a small
subset of the logic (and of the code) from core-scheduling, as said
here:

> I haven't looked at details about what has been done so far.
> Hopefully, we
> can do something not too complex, or reuse a (small) part of co-
> scheduling.
>=20
Now, sticking to virtualization examples, if you don't have core-
scheduling, it means that you can have two vcpus, one from VM A and the
other from VM B, running on the same core, one on thread 0 and the
other one on thread 1, at the same time.

And if VM A's vcpu, running on thread 0, exits, then VM B's vcpu
running in guest more on thread 1 can read host memory, as it is
speculatively accessed (either "normally" or because of cache load
gadgets) and brought in L1D cache by thread 0. And Indeed I do see how
ASI protects us from this attack scenario.

However, when the two VMs' vcpus are both running in guest mode, each
one on a thread of the same core, VM B's vcpu running on thread 1 can
exploit L1TF to peek at and steal secrets that VM A's vcpu, running on
thread 0, is accessing, as they're brought into L1D cache... can't it?=20

How can, ASI *without* core-scheduling, prevent this other attack
scenario?

Because I may very well be missing something, but it looks to me that
it can't. In which case, I'm not sure we can call it "alternative" to
core-scheduling.... Or is the second attack scenario that I tried to
describe above, not considered interesting?

Thanks and Regards
--=20
Dario Faggioli, Ph.D
http://about.me/dario.faggioli
Virtualization Software Engineer
SUSE Labs, SUSE https://www.suse.com/
-------------------------------------------------------------------
<<This happens because _I_ choose it to happen!>> (Raistlin Majere)


--=-fcfXGdMTNOfnauu1DZWy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEES5ssOj3Vhr0WPnOLFkJ4iaW4c+4FAl1Bwl4ACgkQFkJ4iaW4
c+5NchAAhQESRHjvBVeSBTZJyh+kcr5QKViHEitkFTtOCRshdOs/4NPb5B75STZv
/sOxzEmdwENyJJ0aNuuLemobMIsvGbJmZYfXGPFoSH7YVT0kUNhi+6YjU28mqUXP
3Pr5KJHLzLpDn7SeATXL6fo44Y0AFcPZbF6yq9LcyqNIg3kBxE6+NW0a0P3oR7SW
KxuJwFLeWdzVdd+iwTV4La0+FBd3EUrJAOZ5yn0Oyhjw2+yzPSYc+2si0JffEF9V
xAP/axNUAHF7R4lbgwhnXDLxHUAGdOwPlH2h6QPkz3C3Ef0g0EobWsJ1qUSLjJJ4
N2h4Cb+FwjOta232LKbFT3u3Zusoe92jop66eoXl1ozrpInxSD+tmh9YLPUZxGRg
fRMhGwGmBSne87c1S7fAw9q11lT6u8D817PGvn3t00H1wnuCBQap1XvoupAMOH7G
XpRYPxsa9WmsABgx4WWbFyJbgpTZcwKj7S3OQSZRRtQa8qLnpD0/ot7LhqyP+x11
FzQQ0Pqc/2Ou2Oubi6wJGDaw+cXIKoEwG6w9lYVuTGCFkTybXz+VPvsMlAmgWAsA
raqSdvH3mu0nOzpVUgvLPygh/OKV5zICoCONGerEbDvr1TfvWGvK7+cDB4gQszhY
4Hvg9+wEqYNbe41b1e571d7sYBhXokahSiSeTH6a/TgPzJNCrSg=
=qx70
-----END PGP SIGNATURE-----

--=-fcfXGdMTNOfnauu1DZWy--

