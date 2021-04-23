Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B43368CA5
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 07:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbhDWF2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 01:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhDWF2e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 01:28:34 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032ABC061574
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 22:27:57 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id c6so35672540qtc.1
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 22:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:in-reply-to:references:mime-version
         :content-transfer-encoding:date:message-id;
        bh=Psm75Ah8drx+ipb6aw7Hoi8ygDQm5jw8TTPOq34YtRA=;
        b=ch8J5l8ATFb47jHL083H3oVYtOsCBOdVZqSqbXj0ZjP+3Hhj3BtFABs0keLKaX7VCD
         R6CGOg7xo9QpcwTqc6hpKBZXt7JzB0PycDNDmbEOrUWWnZsg0Hqd/g+/XZajphqLs7Hd
         dJd2tF73iuTD4kdJCqjjNGOPWSscfqtaYWCQbMai2Bm/LoEcN8Wx9uRy0doVoXNmR4Kz
         /4nHxV36kUN1vpRa30snk1hbGW5Feo1tygtDck+Zg3Q71dhMVLVbRQ9LKSMEk4tUwN9P
         9Mqbqdfhl+eCl5Ar4WNihmH+uyxTbhNbY4mntzajZan5SZFJu7D8Kb8TdhiHXImZpo4u
         dcLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :mime-version:content-transfer-encoding:date:message-id;
        bh=Psm75Ah8drx+ipb6aw7Hoi8ygDQm5jw8TTPOq34YtRA=;
        b=as7bPx7q6BvBfZlYopjcRADcpgzBfZoD8TTZ1467eRsYa4rwSvYFzYBBilUvfxOJEo
         eLqAEYOFO6laRiBJnFGxGlE+aZW6gKKaulfr82E5Knj3Pxy9mQxnyylaOlTjI+OVqjBg
         CVeknml/olQ7LaPX1SdkCfZ+/RGiYfqOFhL6X13x4VEBeyLyK8R2Eax7LipX7hVwPBc/
         1GFG5Ik0bpVCaOiWXBiY6etswZaS7YpPKm76bYJrEnbnNIsIU0qH72xjtTiZJnxWawfr
         GvaIHSfQfPZa948TNVlduMtihR2V9d9zQB0kc1tUTyc91kGosv4Gze+vAeoVJtd+TgU2
         HPHA==
X-Gm-Message-State: AOAM530VgrwwTFZ2OkWLsOc3M9/rqubXtbeVBQTsqc8Pr9xjBEXO75mE
        OO0gmhNEO6ZiPDaLCYeVORmr0w==
X-Google-Smtp-Source: ABdhPJxwB/HYDSnNJrPEV2masIGiuepY1p9nbiEuwC/R352xEFUtyhIqqHkplbk3RUeUCN5KOYyAYQ==
X-Received: by 2002:ac8:4a82:: with SMTP id l2mr2113741qtq.311.1619155677021;
        Thu, 22 Apr 2021 22:27:57 -0700 (PDT)
Received: from turing-police ([2601:5c0:c380:d61::359])
        by smtp.gmail.com with ESMTPSA id p66sm3664708qka.108.2021.04.22.22.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:27:56 -0700 (PDT)
Sender: Valdis Kletnieks <valdis@vt.edu>
From:   "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH] KVM: x86: Fix implicit enum conversion goof in scattered reverse CPUID code
In-Reply-To: <YIBcd+5NKJFnkTC1@archlinux-ax161>
References: <20210421010850.3009718-1-seanjc@google.com>
 <YIBcd+5NKJFnkTC1@archlinux-ax161>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1619155674_38983P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date:   Fri, 23 Apr 2021 01:27:54 -0400
Message-ID: <110961.1619155674@turing-police>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--==_Exmh_1619155674_38983P
Content-Type: text/plain; charset=us-ascii

On Wed, 21 Apr 2021 10:10:15 -0700, Nathan Chancellor said:

> Unfortunately, gcc's -Wenum-conversion is behind -Wextra rather than
> -Wall like clang. If you explicitly enable it with
> KCFLAGS=-Wenum-conversion to your make invocation, it will warn in the
> exact same way as clang:
>
> arch/x86/kvm/cpuid.c: In function 'kvm_set_cpu_caps':
> arch/x86/kvm/cpuid.c:499:29: warning: implicit conversion from 'enum kvm_only_cpuid_leafs' to 'enum cpuid_leafs' [-Wenum-conversion]
>   499 |  kvm_cpu_cap_init_scattered(CPUID_12_EAX,
>       |                             ^~~~~~~~~~~~
> arch/x86/kvm/cpuid.c: In function '__do_cpuid_func':
> arch/x86/kvm/cpuid.c:837:31: warning: implicit conversion from 'enum kvm_only_cpuid_leafs' to 'enum cpuid_leafs' [-Wenum-conversion]
>   837 |   cpuid_entry_override(entry, CPUID_12_EAX);
>       |                               ^~~~~~~~~~~~
>
> clang's warning for comparison/posterity:
>
> arch/x86/kvm/cpuid.c:499:29: warning: implicit conversion from enumeration type 'enum kvm_only_cpuid_leafs' to different enumeration type 'enum cpuid_leafs'
 [-Wenum-conversion]
>         kvm_cpu_cap_init_scattered(CPUID_12_EAX,
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~ ^~~~~~~~~~~~
> arch/x86/kvm/cpuid.c:837:31: warning: implicit conversion from enumeration type 'enum kvm_only_cpuid_leafs' to different enumeration type 'enum cpuid_leafs'
 [-Wenum-conversion]
>                 cpuid_entry_override(entry, CPUID_12_EAX);
>                 ~~~~~~~~~~~~~~~~~~~~        ^~~~~~~~~~~~
> 2 warnings generated.

Note that this will kill the build if you have CONFIG_KVM_WERROR=y in effect
(which was a reasonable thing to do when KVM built just fine with it in effect).


--==_Exmh_1619155674_38983P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.9.0 11/07/2018

iQIVAwUBYIJa2gdmEQWDXROgAQJS8hAAuyGWZ26P+Q93qoKN9KAKX0+D8xuUU3K9
g8Ky+540JLnFCiR6/0WXN1XGISj8VeykmFC4DWTToniWxELf8H4Kby5A3UkWQTGY
rksStkTMhS0Pq9kEOwOPtvJLaTfWhvpPfuA1FADWHpUWYIInymbT+2y9Hda/Ntpz
Q+5nAVf/Q7QYfWtflo8VmxIztrX4winoUav0Scyy5Hc7vbsU7oQZbY9/oedFhv2w
JcZ33B2PoV8ziJl9kSzkXG8Yl5YmyzZek3aWG5gaVAQk+UjhlrTQrKpXZ+m4308a
5RGEENqL4jcR9Gg52MwQkGg4GJVhPHqmKyFPntb0fLkfs2z/bL7/A6ZOYc6hqRX5
mClB3rwRwTgE26Js/N0HL8QA9j2Bp0MiovulScUYOWw0YyC7klsHLIjjT/JRwdtK
/4fq2Ye5oGpN3sWbrO3egfmVBMS3nnkuvlQ7j2tZwQUFUc+QNuEnbBi2yzPcl5hq
CMmdCkbbkAnv01AsvJIl5hiTLWRa6YV6pVLl6n0jEUnmvUH9VDB+yZKB5AVn1MbU
iwF6iUqIcVEla0YAVi6nQudufnzydzkwhr9lzIKg0XuEBGtms51601HDax/fx8Qu
oTEPKnoTwgxqNOC7wyAPZGkMKdDXWhjyWEGt0Z8rJzyJFwVIqVdc+vir6u9/HHod
GHUC8hRYmu0=
=fsOf
-----END PGP SIGNATURE-----

--==_Exmh_1619155674_38983P--
