Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 196AD11E93C
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 18:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbfLMRa5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 12:30:57 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:40774 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728445AbfLMRa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 12:30:57 -0500
Received: by mail-il1-f196.google.com with SMTP id b15so52016ila.7
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 09:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=urJrAIeTSe9aB/OJeeHEmbgJLkVn13QJ4pnH3GP6HpQ=;
        b=pWYsRZ/czAK/55/w03qg9qy9fVcp5fHulnTPXbxRevFLXspI6wGNz8chBiX5AQstmN
         3Esa8YeUmeMYT3qgCnaVWeag0ClOqCKoG0e2GloxMK4nA7J5mPuA5rL34irr+rHuvbTt
         A8mj0J+HQBcGEQ6TDe4NZm1QGUix+1uE/YOv4SMbxq8FLDG+wwP1m75Twl3OA/NTlfU3
         KZ3YrkJVi/8jB7MSuxSWjJcXaPkd+8Pt+Nm9dasN1sMLXT4SORqH6b/mLllqiZtMzD1V
         VY8MLsAoC7Fai+ssarCn4zD34eLQuJ9IE1pmZ6Br/arbFFg23K/2PQIXufB0srJJRbd3
         hMsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=urJrAIeTSe9aB/OJeeHEmbgJLkVn13QJ4pnH3GP6HpQ=;
        b=CyOplsjp4W5bQagLpW9VZMa6cgye/BQgpuWhV9sS06XOZIGqYk5SHOSo9yK4LCV2S/
         avcWU19ppd5Gw7SDDZeGvNSQMlwyJ9AcK5ctDw1kISjHeXMDucorOCgWMW/p0dsMSr08
         Fj2hwxOvam4yhbYILbqu+K2I4LWpbHGS3c8af98RrX6Q5E9l9RX0qxkLPVWewWhNDFdP
         7ym0ACgyyek+4ZdVjCrmZQw/mR6F2Dj+iZ1EUCX8zTurt0lkVCrfKqSqe4Yn6SFrhx89
         ooLouVhKoQuulzCBJuT2U35wR+sItTwlhBm7tJpqvEasM/SiZYr8ciPYe238bbMZEvax
         1sOw==
X-Gm-Message-State: APjAAAUBBg5gUQFrJtVYOKm3f2ap7SZQr8+/ttpmIIlmPRjo4CODfkqc
        F8Uq6xDCA4otVSH3MoiqV4Kg1JarJGPx+uoQxoFDRyqU33M=
X-Google-Smtp-Source: APXvYqwXe7rl2E2boWe1aSZXr33i4RQhI3367lCOTOLdDhV3VZ53igAzfvMM3T+bEkW680+e+pWvNDb8jnT1tj+j+qc=
X-Received: by 2002:a92:d30e:: with SMTP id x14mr469415ila.108.1576258256506;
 Fri, 13 Dec 2019 09:30:56 -0800 (PST)
MIME-Version: 1.0
References: <20190518163743.5396-1-nadav.amit@gmail.com> <CALMp9eQOKX6m0ih6bH5Oyqq5hFbSs7vn0MAZXka3RcOCrC+sUg@mail.gmail.com>
 <51BBC492-AD4F-4AA4-B9AD-8E0AAFFC276F@gmail.com>
In-Reply-To: <51BBC492-AD4F-4AA4-B9AD-8E0AAFFC276F@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 13 Dec 2019 09:30:45 -0800
Message-ID: <CALMp9eT+K7qwLeBb231OjNwqTaS4XE6Ci+-j_b+a=0JU__HEqg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Fix max VMCS field encoding index check
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It can't take that long. VMCS field encodings are only 15 bits, and
you can ignore the "high" part of 64-bit fields, so that leaves only
14 bits.

On Fri, Dec 13, 2019 at 1:13 AM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> > On Dec 13, 2019, at 12:59 AM, Jim Mattson <jmattson@google.com> wrote:
> >
> > On Sat, May 18, 2019 at 4:58 PM Nadav Amit <nadav.amit@gmail.com> wrote=
:
> >> The test that checks the maximum VMCS field encoding does not probe al=
l
> >> possible VMCS fields. As a result it might fail since the actual
> >> IA32_VMX_VMCS_ENUM.MAX_INDEX would be higher than the expected value.
> >>
> >> Change the test to check that the maximum of the supported probed
> >> VMCS fields is lower/equal than the actual reported
> >> IA32_VMX_VMCS_ENUM.MAX_INDEX.
> >
> > Wouldn't it be better to probe all possible VMCS fields and keep the
> > test for equality?
>
> It might take a while though=E2=80=A6
>
> How about probing VMREAD/VMWRITE to MAX_INDEX in addition to all the know=
n
> VMCS fields and then checking for equation?
>
