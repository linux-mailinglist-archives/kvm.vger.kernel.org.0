Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 574E3149E80
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 05:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgA0Egp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jan 2020 23:36:45 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37649 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgA0Egp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jan 2020 23:36:45 -0500
Received: by mail-pg1-f193.google.com with SMTP id q127so4510708pga.4
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2020 20:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hs4icqW9+CWif0uw7jJ56lx+lcBIZUJndIqpWnQjpW8=;
        b=mnTX65vZ1x+LYk5kfUU2SdrZM1XiNPn0DUTaZ5y5+vgi3xh7v1On2ixbot6Euv8CNQ
         v3uBpB0XxpUbTI5R3zVfOwn/23kPuqx7iCDvqxp0dC4XKvvTGm4tlAKX65YhRYZdyFd0
         hvc8gPVKxQsYDH+rLtREZOPa/w4VpMjX3YVRAYdXpZ5gE4YCdZPCOFLQw+UnD4HUcewg
         mk4Cg5FR3CamMS9orBXDbgH1I0vjSpGLtJg38TtPO6N3SVYIQ6MUHSptR8R4O22AQsJp
         0gpMr5N9ccAJZZBIkXASVnjexGXsCeNV2o8IHS0HJzV0kQfZSn6jZ3v7bcbT6k2Zxwat
         GaFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=hs4icqW9+CWif0uw7jJ56lx+lcBIZUJndIqpWnQjpW8=;
        b=cwh8uitCFRiuSRaIj5oSg2A8JZwCRZuxWJVeauO5+emC4o9Nsy0p0TkOUYIngrhQJ0
         wvrd92F0xH3QJRQaWN5aT/8pn4CmYD8Fuvb4nxzjZaGXRGzuhxAEPkrjhcAP9R0tkfTG
         EI9A39Vbf7r+1ACstEd0/uQ2r960wDFBIoGbo393XQdgJ8bvIyHEk/CODwssjuWkcx8B
         HGfgkiA/8jVOpuPbrL+g7vh9pUva4Nm/tLGt9L8ZN2PoVmUiAcCl0nqEA1BCAln6Jc60
         obLofgiM1dMs7Ts+H4axVkHagCzjUaA4WCLq6sMKe9ky1xyefiPhlSirGmRrQ6PQwMop
         JpLA==
X-Gm-Message-State: APjAAAXi3HgSElEBG99rVReldeFTD5m93vdCQ2T2AMeUYRVrAeOnATcs
        wzaVVzIitOK3GwCEVo4qsX8=
X-Google-Smtp-Source: APXvYqxqo3W/ZGlsAFCvuqFI6uEtwGTiVl4dOpuaG4YTGrPHOw2ov/2OyYC/S36UWWr8ZEnE78EqnA==
X-Received: by 2002:a63:ba45:: with SMTP id l5mr17306261pgu.380.1580099804037;
        Sun, 26 Jan 2020 20:36:44 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:a49d:e6a2:2049:7767? ([2601:647:4700:9b2:a49d:e6a2:2049:7767])
        by smtp.gmail.com with ESMTPSA id r145sm3411012pfr.5.2020.01.26.20.36.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 Jan 2020 20:36:43 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [kvm-unit-tests PATCH v3] x86: Add RDTSC test
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CALMp9eTXVhCA=-t1S-bVn-5ZVyh7UkR2Kqe26b8c5gfxW11F+Q@mail.gmail.com>
Date:   Sun, 26 Jan 2020 20:36:40 -0800
Cc:     Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <436117EB-5017-4FF0-A89B-16B206951804@gmail.com>
References: <20191202204356.250357-1-aaronlewis@google.com>
 <4EFDEFF2-D1CD-4AF3-9EF8-5F160A4D93CD@gmail.com>
 <20200124233835.GT2109@linux.intel.com>
 <1A882E15-4F22-463E-AD03-460FA9251489@gmail.com>
 <CALMp9eTXVhCA=-t1S-bVn-5ZVyh7UkR2Kqe26b8c5gfxW11F+Q@mail.gmail.com>
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jan 26, 2020, at 2:06 PM, Jim Mattson <jmattson@google.com> wrote:
>=20
> If I had to guess, you probably have SMM malware on your host. Remove
> the malware, and the test should pass.

Well, malware will always be an option, but I doubt this is the case.

Interestingly, in the last few times the failure did not reproduce. Yet,
thinking about it made me concerned about MTRRs configuration, and that
perhaps performance is affected by memory marked as UC after boot, since
kvm-unit-test does not reset MTRRs.

Reading the variable range MTRRs, I do see some ranges marked as UC =
(most of
the range 2GB-4GB, if I read the MTRRs correctly):

  MSR 0x200 =3D 0x80000000
  MSR 0x201 =3D 0x3fff80000800
  MSR 0x202 =3D 0xff000005
  MSR 0x203 =3D 0x3fffff000800
  MSR 0x204 =3D 0x38000000000
  MSR 0x205 =3D 0x3f8000000800

Do you think we should set the MTRRs somehow in KVM-unit-tests? If yes, =
can
you suggest a reasonable configuration?

Thanks,
Nadav


>=20
> On Fri, Jan 24, 2020 at 4:06 PM Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>> On Jan 24, 2020, at 3:38 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>>>=20
>>> On Fri, Jan 24, 2020 at 03:13:44PM -0800, Nadav Amit wrote:
>>>>> On Dec 2, 2019, at 12:43 PM, Aaron Lewis <aaronlewis@google.com> =
wrote:
>>>>>=20
>>>>> Verify that the difference between a guest RDTSC instruction and =
the
>>>>> IA32_TIME_STAMP_COUNTER MSR value stored in the VMCS12's VM-exit
>>>>> MSR-store list is less than 750 cycles, 99.9% of the time.
>>>>>=20
>>>>> 662f1d1d1931 ("KVM: nVMX: Add support for capturing highest =
observable L2 TSC=E2=80=9D)
>>>>>=20
>>>>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>>>>> Reviewed-by: Jim Mattson <jmattson@google.com>
>>>>=20
>>>> Running this test on bare-metal I get:
>>>>=20
>>>> Test suite: rdtsc_vmexit_diff_test
>>>> FAIL: RDTSC to VM-exit delta too high in 117 of 100000 iterations
>>>>=20
>>>> Any idea why? Should I just play with the 750 cycles magic number?
>>>=20
>>> Argh, this reminds me that I have a patch for this test to improve =
the
>>> error message to makes things easier to debug.  Give me a few =
minutes to
>>> get it sent out, might help a bit.
>>=20
>> Thanks for the quick response. With this patch I get on my bare-metal =
Skylake:
>>=20
>> FAIL: RDTSC to VM-exit delta too high in 100 of 49757 iterations, =
last =3D 1152
>> FAIL: Guest didn't run to completion.
>>=20
>> I=E2=80=99ll try to raise the delta and see what happens.
>>=20
>> Sorry for my laziness - it is just that like ~30% of the tests that =
are
>> added fail on bare-metal :(


