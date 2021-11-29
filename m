Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDB4461D66
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 19:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348991AbhK2SRb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 13:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243892AbhK2SPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 13:15:31 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88FBC03AA1D
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 06:44:29 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id t23so35027557oiw.3
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 06:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GKVLc/+rKV8jGy2xEcynwei/dkKPZddCEj3hjl6BCNw=;
        b=aiIF26m2Bx/DCiuLkyAb/6bPaGWkUC+/qHtiZZr4r1ZI0We3gymnzY6VY5Yje3Jqk6
         og5UCLprBp3lz/a5OwlxIpiMalLzKwh8V0h0UQsV/mP0tsXcpyJ5d1itENcGdIbvbrLW
         2LyP+ZQwels3Zb15KSnD5GYcUlmR3p1J8JoiGi273Rvgju8zD4AzKAe7PhP62qo7NGWv
         3ivOxuHPqEHir1F1txJw1Jprg0GzuiJxotlvltD5qA41671IZqNgyMpTW0Ig/nkT7Sem
         dGdYe+Rd+W5vavS6NTK8+RwxxPl+Fo5Irw0+c0hug3/d9RoMw5eyuJge7DgJVSWzw1mG
         h1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GKVLc/+rKV8jGy2xEcynwei/dkKPZddCEj3hjl6BCNw=;
        b=YqV3vcrEzFMTqpc5HNtFL20WQGyxlxGVdZZa9pAU+6WJXzyqSWAQSSufqmty+LgwkR
         sYP1LhKb049IVEXnyr19hKdL9jJcyjVhoxd7Ro6pVv0iyQM+qlNeylvgj9M0Ie7RZ61R
         z+DmvDROu8gvoRmTlq7HLlU1x+GwdIyImNjdN8L52af7JNja8xfVntzeJfNGlLI5HJH/
         kHECFLqLnzIwOnZAMjn0oiiohh+u/LWuKvWzcAkAOUUhlvw5QstGrOgK4NyJLlyXzSx+
         ZiNo/i9pNAEDqnXlTyewlO2gpkomYlNE0iZ5Bu7iUxZwlhhrRCKIj0uuvcVHkLpk/QZ2
         rppA==
X-Gm-Message-State: AOAM530IuywpcF/TVeM4hEwdzKANxU1IpfyHT9CC+7IE/6ooHVpAYu04
        qcQwdvvZJVAj2wNgqWJqoUuzdBWcHTK8gXjI2nueYA==
X-Google-Smtp-Source: ABdhPJwsv9m1Z+kTXlkk8ZggjP0sVUSHNaYvl1vSb8VjV9N76Rwea6ppsCKe1/KJmf8nf5sSFXHyppB/ueUCSeL+tfg=
X-Received: by 2002:a54:4515:: with SMTP id l21mr41384907oil.15.1638197068915;
 Mon, 29 Nov 2021 06:44:28 -0800 (PST)
MIME-Version: 1.0
References: <20211004204931.1537823-1-zxwang42@gmail.com> <4d3b7ca8-2484-e45c-9551-c4f67fc88da6@redhat.com>
 <81f95dad-b1e3-edfb-685f-8dafc92cd5db@suse.com>
In-Reply-To: <81f95dad-b1e3-edfb-685f-8dafc92cd5db@suse.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 29 Nov 2021 06:44:17 -0800
Message-ID: <CAA03e5FGj3FGeL-nfMBY_TA4UNFjaP73Hxkhkr1s2qGApHFCmQ@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v3 00/17] x86_64 UEFI and AMD SEV/SEV-ES support
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        drjones@redhat.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com, jroedel@suse.de,
        bp@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25, 2021 at 7:21 AM Varad Gautam <varad.gautam@suse.com> wrote:
>
> On 10/21/21 4:10 PM, Paolo Bonzini wrote:
> > On 04/10/21 22:49, Zixuan Wang wrote:
> >> Hello,
> >
> > WHOA IT WORKS! XD
> >
> > There are still a few rough edges around the build system (and in gener=
al, the test harness is starting to really show its limits), but this is aw=
esome work.  Thanks Drew, Varad and Zixuan (in alphabetic and temporal orde=
r) for the combined contribution!
> >
> > For now I've placed it at a 'uefi' branch on gitlab, while I'm waiting =
for some reviews of my GDT cleanup work.  Any future improvements can be do=
ne on top.
> >
>
> While doing the #VC handler support for test binaries [1], I realised I c=
an't seem
> to run any of the tests from the uefi branch [2] that write to cr3 via se=
tup_vm()
> on SEV-ES. These tests (eg., tscdeadline_latency) crash with SEV-ES, and =
work with
> uefi without SEV-ES (policy=3D0x0). I'm wondering if I am missing somethi=
ng, is
> setup_vm->setup_mmu->write_cr3() known to work on SEV-ES elsewhere?
>
> [1] https://lore.kernel.org/all/20211117134752.32662-1-varad.gautam@suse.=
com/
> [2] https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/tree/uefi

I've only been running amd_sev under SEV-ES up to now. I just tried
tscdeadline_latency on my setup, and can confirm that it does indeed
fail under SEV-ES.
