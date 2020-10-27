Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EF029B2E2
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 15:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764380AbgJ0Oqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 10:46:45 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41488 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764305AbgJ0Oqo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 10:46:44 -0400
Received: by mail-qk1-f193.google.com with SMTP id b69so1354388qkg.8
        for <kvm@vger.kernel.org>; Tue, 27 Oct 2020 07:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vt-edu.20150623.gappssmtp.com; s=20150623;
        h=sender:from:to:cc:subject:in-reply-to:references:mime-version
         :content-transfer-encoding:date:message-id;
        bh=17KDeIO5swYTU4SApS47iQ6ZcB9r1zqvXIcL0x19F3E=;
        b=UhaCu7WsJy2xAAbOMeh9CBXHKLj5/ilC6kA/dtYXoOVYx8bil6k0U6dBMs6Yv8FYZO
         G6vgik/+ENgTE9YIHispIdXThpZewssPoynr3VFinTqxOk86+6/GIVwgNYZ2O8fTmqin
         LKPq+kXKP+gMl6HhF8OXwDHxSkdHOtx8SvEADd9tzNebvSsL+HurpEWkoR6QkBPzPAKC
         hq0cUUVyrhL3IEgNYX6ATtWVAs/N+AIvnZQZiQQndJMFbdpn5YkS7IybwN251xZl5E+Q
         olUtlYpLlvMimLL5ToXuoQrl5hhHb45ED0535sCfqrYLdqAX0CulsO+XEmb7vAMDnUz1
         8z4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:in-reply-to:references
         :mime-version:content-transfer-encoding:date:message-id;
        bh=17KDeIO5swYTU4SApS47iQ6ZcB9r1zqvXIcL0x19F3E=;
        b=Pp6xh9/Y5co+85MN09Q/yVIzzSd8mkgbjO01cpdc33TaK2z9EgWgDitjY1j/g7jsDY
         19TvuswOVfGzesoy3Gk7fdk+gnkYWme+JJ037Eixe3v9h6FfOO81TuXIBwJ90KhQkoet
         xZBEsUZY5jIk4arhaC4HR/b7gLGAFz0Bf4swgLDagEaiHH2ZbGoRjzXI8mdopa/jS366
         qrd/yyyf430BKnPZ3KROBW8p1Th8xwpMF3kPxIz7FByGHO7H1FnLSFe23YQcvQJ5o9YF
         UaTu6oorgMHkMjSXzanj8wXPa6LBtSKNiFOeblsbJaPhYYAldODaMa11jcojQqdatFnE
         kOKw==
X-Gm-Message-State: AOAM531T8hMeDURvBZz/zFij2/+f81CiWZQvakbAM5AgFUZ0yohhgVkG
        W3W009eL/B2COrBGKebzxwgKLJ8/wfnseQ==
X-Google-Smtp-Source: ABdhPJzpwz3KlyAEwYFiW2J6dXvnLRkOHTg4Z4au1emHAH4krTreWAtknV78Kyyiuikik9cu7Vv6TQ==
X-Received: by 2002:a37:4b4f:: with SMTP id y76mr2525428qka.108.1603810002374;
        Tue, 27 Oct 2020 07:46:42 -0700 (PDT)
Received: from turing-police ([2601:5c0:c380:d61::359])
        by smtp.gmail.com with ESMTPSA id b191sm797057qkg.81.2020.10.27.07.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 07:46:39 -0700 (PDT)
Sender: Valdis Kletnieks <valdis@vt.edu>
From:   "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis Kl=?utf-8?Q?=c4=93?=tnieks" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bgardon@google.com
Subject: Re: [PATCH 04/22] KVM: mmu: extract spte.h and spte.c
In-Reply-To: <20201023163024.2765558-5-pbonzini@redhat.com>
References: <20201023163024.2765558-1-pbonzini@redhat.com>
 <20201023163024.2765558-5-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1603809997_107026P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date:   Tue, 27 Oct 2020 10:46:37 -0400
Message-ID: <120363.1603809997@turing-police>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--==_Exmh_1603809997_107026P
Content-Type: text/plain; charset=us-ascii

On Fri, 23 Oct 2020 12:30:06 -0400, Paolo Bonzini said:
> The SPTE format will be common to both the shadow and the TDP MMU.
>
> Extract code that implements the format to a separate module, as a
> first step towards adding the TDP MMU and putting mmu.c on a diet.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

This died a horrid death on my laptop when building with W=1.

  CC      arch/x86/kvm/mmu/tdp_iter.o
In file included from arch/x86/kvm/mmu/tdp_iter.c:5:
arch/x86/kvm/mmu/spte.h:120:18: error: 'shadow_nonpresent_or_rsvd_mask_len' defined but not used [-Werror=unused-const-variable=]
  120 | static const u64 shadow_nonpresent_or_rsvd_mask_len = 5;
      |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/x86/kvm/mmu/spte.h:115:18: error: 'shadow_acc_track_saved_bits_shift' defined but not used [-Werror=unused-const-variable=]
  115 | static const u64 shadow_acc_track_saved_bits_shift = PT64_SECOND_AVAIL_BITS_SHIFT;
      |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/x86/kvm/mmu/spte.h:113:18: error: 'shadow_acc_track_saved_bits_mask' defined but not used [-Werror=unused-const-variable=]
  113 | static const u64 shadow_acc_track_saved_bits_mask = PT64_EPT_READABLE_MASK |
      |                  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
make[2]: *** [scripts/Makefile.build:283: arch/x86/kvm/mmu/tdp_iter.o] Error 1
make[1]: *** [scripts/Makefile.build:500: arch/x86/kvm] Error 2
make: *** [Makefile:1799: arch/x86] Error 2

Do we really need to define 3 static variables in every .c file that includes
this .h file, directly or not?

--==_Exmh_1603809997_107026P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.9.0 11/07/2018

iQIVAwUBX5gyzAdmEQWDXROgAQKKOxAAgecta9kDMTJRYfcgBwga75WmzvPH922W
btTmDu9hUBIHglgCQ05j+d9wkHqw6P/7g3bzlzDmfbMAN1Pq1lDvIdJ1EtEUghWW
DettNFbotZKm1gjySq3PfuOHKfQBbE8VPyczEYKwsGlURkjRFmRh4ZTAQ+p+rPmg
rwPlxMX/NqHj6xyCT2jKM0XpeptBV3kW8xeMsL6DeLeYTVr1qt4pS1l8ndOs1WwP
PARYgkVXfDjqA4kXtMwMuNsvxR25tqkWmY+1puzzlCDLZuv+ynkXhI7bPSlUHQiD
8gr6JYqW76ioYI17QVtvbhrh8jlxtZWynp5xWeDkISakGuIENnHNCxDdPEu7u5kX
1lT9AqgM+NA2troIhOzqceswceR4K8w4AjpBSaQ25n9SsMCnogzFtbflpwF11InF
w7jd+lcjVXimIjxD8l7DGDIlkBxO/ziy+yX4I37qGRIMro2MLNP6UtGHx+2SzzdB
HAZCqPiNWT04hTiO3Vg8s9hHBGXAZad/S/B7OtlfCh7gzmlIbBoYvMl87BhwtYOj
Rk835URMRwts+YJwQO09LyClIAx436btajrNZd9vP3CU4q+Bv1ZTJpteX+GS94Dv
z/7R/z/oisBLOYjZjZJHmZhBnCvpGU6Garls00bFGdb+MX99Mcaq1y1+1ZseVk+p
jfbEvr4XX7g=
=Pi8U
-----END PGP SIGNATURE-----

--==_Exmh_1603809997_107026P--
