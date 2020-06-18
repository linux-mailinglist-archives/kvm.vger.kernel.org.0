Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BFC1FEBCF
	for <lists+kvm@lfdr.de>; Thu, 18 Jun 2020 08:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgFRG7Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jun 2020 02:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727055AbgFRG7P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jun 2020 02:59:15 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87615C06174E
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 23:59:15 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i4so2241482pjd.0
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 23:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RRb3SEPgwE9+d3AUs3WkB3zeBWXsniAzFBRNGXnO2Zo=;
        b=J4hQkWs6shQJssVgNa666DcxF0HicvkJiOaAcfsYKPSAo9mSvGPLEsA9xEEnPI0dji
         1fAkZOKl1kQ6Zhb73DEUcvCCL11SBcTCa90iTaAk9qZCKd1F8D2/3rVslYfiNk9/sWV2
         zv2SKB0uxVH9s02xNS9QPQtGhV+vh5a3eDG3omF0hWTb7q20GzHbCG2J9Tin98Xy/YyF
         bEcHq4vhRDszWYQ0YzlDeUkYArdFWsMbTeCDJbJphfcFzpzGuE/NI6+bAeON/2wnOEl3
         /F1/O3vvWBEJp0fn1226fDB0PxmU5GiSCoOKf/iShRDr9Ey5RGMcNRBKdT7wrDXujdjS
         Zw3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RRb3SEPgwE9+d3AUs3WkB3zeBWXsniAzFBRNGXnO2Zo=;
        b=SdbXt7D8ERtnnqcWRM/3nKmMwpbkipZTxuBEU8ENQJYiZ8DF6cQ85uArMKi1NvyclW
         ISu/yh1ezle5maMOwK8zniI/Pc2mW4246GX/lJv1KAJo/Pi2ito9ouqUDy1/0TWFlAvn
         Gu69DvFjK+pkeOEC6WTiH5hIv/fb/oZkxqOu8vhZqLT8iD3drJIGRcHcdi45ptCi0GUI
         0xiCqxq/pWww7e1Ac8BwsUQhLvjBHe/AWY82SeCmRgNcELZiKP8s2vGDaEuwBaCa5v0p
         wSqEakNjhC4IrNhPfHF72M2qmOja2UY66i74Y+ftvXyfyVGQErwXwaSAveu/IyFeBqZi
         /hoA==
X-Gm-Message-State: AOAM532IAdqNYUrmGTyoFRlZdEPR9o1reWt+CeKH/vplRjQdEyGugk5z
        IPOhepgJUNhN0+bD33qs2Go=
X-Google-Smtp-Source: ABdhPJwvBrZ7lux26GhYbq3Xge/k+w4GsLSS26rCvDmOg8z9eUhdmm7/C1a4JBGRy2G7s2GnBuWrpw==
X-Received: by 2002:a17:902:9309:: with SMTP id bc9mr2610438plb.232.1592463554870;
        Wed, 17 Jun 2020 23:59:14 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:1c36:bfc:73ae:1f3? ([2601:647:4700:9b2:1c36:bfc:73ae:1f3])
        by smtp.gmail.com with ESMTPSA id x77sm1885061pfc.4.2020.06.17.23.59.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jun 2020 23:59:13 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [kvm-unit-tests PATCH] x86: Add control register pinning tests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200618050834.GA23@0d4958db2004>
Date:   Wed, 17 Jun 2020 23:59:10 -0700
Cc:     corbet@lwn.net, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
        bp <bp@alien8.de>, hpa@zytor.com, shuah@kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        rick.p.edgecombe@intel.com, kvm <kvm@vger.kernel.org>,
        kernel-hardening@lists.openwall.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <FAFB5DA6-FA6F-4A1A-AB10-4B99F314B23D@gmail.com>
References: <20200617224606.27954-1-john.s.andersen@intel.com>
 <ACCCF382-0077-4B08-8CF1-73C561F930CD@gmail.com>
 <5D576A1A-AD52-4BB1-A514-1E6641982465@gmail.com>
 <20200618050834.GA23@0d4958db2004>
To:     "Andersen, John" <john.s.andersen@intel.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 17, 2020, at 10:08 PM, Andersen, John =
<john.s.andersen@intel.com> wrote:
>=20
> On Wed, Jun 17, 2020 at 08:18:39PM -0700, Nadav Amit wrote:
>>> On Jun 17, 2020, at 3:52 PM, Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>=20
>>>> On Jun 17, 2020, at 3:46 PM, John Andersen =
<john.s.andersen@intel.com> wrote:
>>>>=20
>>>> Paravirutalized control register pinning adds MSRs guests can use =
to
>>>> discover which bits in CR0/4 they may pin, and MSRs for activating
>>>> pinning for any of those bits.
>>>=20
>>> [ sni[
>>>=20
>>>> +static void vmx_cr_pin_test_guest(void)
>>>> +{
>>>> +	unsigned long i, cr0, cr4;
>>>> +
>>>> +	/* Step 1. Skip feature detection to skip handling VMX_CPUID */
>>>> +	/* nop */
>>>=20
>>> I do not quite get this comment. Why do you skip checking whether =
the
>>> feature is enabled? What happens if KVM/bare-metal/other-hypervisor =
that
>>> runs this test does not support this feature?
>>=20
>> My bad, I was confused between the nested checks and the non-nested =
ones.
>>=20
>> Nevertheless, can we avoid situations in which
>> rdmsr(MSR_KVM_CR0_PIN_ALLOWED) causes #GP when the feature is not
>> implemented? Is there some protocol for detection that this feature =
is
>> supported by the hypervisor, or do we need something like =
rdmsr_safe()?
>=20
> Ah, yes we can. By checking the CPUID for the feature bit. Thanks for =
pointing
> this out, I was confused about this. I was operating under the =
assumption that
> the unit tests assume the features in the latest kvm/next are present =
and
> available when the unit tests are being run.
>=20
> I'm happy to add the check, but I haven't see anywhere else where a
> KVM_FEATURE_ was checked for. Which is why it doesn't check in this =
patch. As
> soon as I get an answer from you or anyone else as to if the unit =
tests assume
> that the features in the latest kvm/next are present and available or =
not when
> the unit tests are being run I'll modify if necessary.

I would appreciate if you add a check of CPUID and not run the test if =
the=20
feature is not supported.

I run the tests on bare-metal (and other non-KVM environment) from time =
to
time. Doing so allows to find bugs in tests due to wrong assumptions of =
KVM
test developers. Liran runs the tests using QEMU/WHPX (non-KVM). So =
allowing
the tests to run on non-KVM environments is important, at least for some =
of
us, and benefits KVM as well.

While I can disable this specific test using the test parameters, I =
prefer
that the test will first check the environment they run on. Debugging =
test
failures on bare-metal is hard enough without the paravirt stuff noise.

