Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E767220A2
	for <lists+kvm@lfdr.de>; Sat, 18 May 2019 01:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfEQXDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 19:03:11 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38214 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfEQXDL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 May 2019 19:03:11 -0400
Received: by mail-pl1-f194.google.com with SMTP id f97so3989008plb.5
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 16:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=CMY6A6xbomkWbc6II6jtpoClG3eEjXIxyLPS1UaB20Q=;
        b=KGmVukymDkg58qGoCokAVl+/DUS3fxdNfgEH4U1+sbABbh/1heKkPkkP5kDnIg5sjZ
         ts2qC+nhIBPw97ixPSAAkiezjRNV+l/7/G6aY5IgmQpS+MI+kvG4tVgFl/ZXwc1/t9pT
         mZ3lbM+nUgYb9bGalwTYleyc48daP3bL6OIyJFm9LGw7RY+rFC8LA2vWP3xHrTINxBPA
         aJkEO1pK+t6cuNa1pKAPLyM0/1mcq5v0gtSPb/XTt34BTuByFHbjLIXOTkT1mIjMaSee
         r+KFVVuxf0A7Digx926FCqZpLQhVSIDtBHjrwm1kcR10FOGjGPqmQVgju5zI/MN+50nY
         i+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=CMY6A6xbomkWbc6II6jtpoClG3eEjXIxyLPS1UaB20Q=;
        b=OdnMr/71ZqK1P3aA5OrwdH2kFO961A7PRhY0YkVsBXR+nr71KAO30bOprvIkzudiw0
         Jr57ezFw6LyGcM7QYvle8VqksQOylulWPnTGXMZgdcnKwYgD23zFdU3eaYWgK+8IUnGm
         KASALQZpObgCnE6V1WCEA/ne9mdKAneHftGmkL0pkcG1bzZdpKyRpOXi6fILXVWFMXI9
         UD+CCRRN0aLNhAFWBCZxhgRz0VVNzS1EAS4C46WPwbzi6TtwbIfP8gkdJ95S4qNaki0q
         49S8VEruiT5QEWWX+Z7bO7Z2vaTKiOfAotA8r5mEFn0sBRXm2Au8iWLBHHgckmg2i4hL
         mp/A==
X-Gm-Message-State: APjAAAVBUGW7Ob6ErzYYz/MEMZ3qYKIArRwJB9xrZ39D8w0fcID5ipxR
        CRJ4VVmmScGHJyfijrrsbjC7tpX06uY=
X-Google-Smtp-Source: APXvYqyURRtAJof0qhJkiqcEZRy13qnCWVn8+C6cYaBswR1/x6UdXYi/7XTb8r5amp6NZYaVNEoL9w==
X-Received: by 2002:a17:902:f208:: with SMTP id gn8mr60450321plb.312.1558134190769;
        Fri, 17 May 2019 16:03:10 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id u11sm11186142pfh.130.2019.05.17.16.03.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 16:03:07 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [kvm-unit-tests PATCH] x86: nVMX: Dynamically calculate and check
 max VMCS field encoding index
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190515164536.GC5875@linux.intel.com>
Date:   Fri, 17 May 2019 16:03:06 -0700
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0A0EA9FB-922D-4AA2-B1A6-3157D580EE38@gmail.com>
References: <20190416013832.11697-1-sean.j.christopherson@intel.com>
 <04F148C8-5E44-4195-97E7-35A428E36983@gmail.com>
 <20190515164536.GC5875@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 15, 2019, at 9:45 AM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Mon, May 13, 2019 at 03:43:18PM -0700, Nadav Amit wrote:
>>> On Apr 15, 2019, at 6:38 PM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>>>=20
>>> Per Intel's SDM:
>>>=20
>>> IA32_VMX_VMCS_ENUM indicates to software the highest index value =
used
>>> in the encoding of any field supported by the processor:
>>>   - Bits 9:1 contain the highest index value used for any VMCS =
encoding.
>>>   - Bit 0 and bits 63:10 are reserved and are read as 0
>>>=20
>>> KVM correctly emulates this behavior, in no small part due to the =
VMX
>>> preemption timer being unconditionally emulated *and* having the =
highest
>>> index of any field supported in vmcs12.  Given that the maximum =
control
>>> field index is already above the VMX preemption timer (0x32 vs =
0x2E),
>>> odds are good that the max index supported in vmcs12 will change in =
the
>>> not-too-distant future.
>>>=20
>>> Unfortunately, the only unit test coverage for IA32_VMX_VMCS_ENUM is =
in
>>> test_vmx_caps(), which simply checks that the max index is >=3D =
0x2a, i.e.
>>> won't catch any future breakage of KVM's IA32_VMX_VMCS_ENUM =
emulation,
>>> especially if the max index depends on underlying hardware support.
>>>=20
>>> Instead of playing whack-a-mole with a hardcoded max index test,
>>> piggyback the exhaustive VMWRITE/VMREAD test and dynamically =
calculate
>>> the max index based on which fields can be VMREAD.  Leave the =
existing
>>> hardcoded check in place as it won't hurt anything and =
test_vmx_caps()
>>> is a better location for checking the reserved bits of the MSR.
>>=20
>> [ Yes, I know this patch was already accepted. ]
>>=20
>> This patch causes me problems.
>>=20
>> I think that probing using the known VMCS fields gives you a minimum =
for the
>> maximum index. There might be VMCS fields that the test does not know =
about.
>> Otherwise it would require to update kvm-unit-tests for every fields =
that is
>> added to kvm.
>>=20
>> One option is just to change the max index, as determined by the =
probing to
>> be required to smaller or equal to IA32_VMX_VMCS_ENUM.MAX_INDEX. A =
second
>> option is to run additional probing, using =
IA32_VMX_VMCS_ENUM.MAX_INDEX and
>> see if it is supported.
>>=20
>> What do you say?
>=20
> Argh, I thought the test I was piggybacking was exhaustively probing =
all
> theoretically possible fields, but that's the VMCS shadowing test.  =
That
> was my intent: probe all possible fields to find the max index and =
compare
> it against IA32_VMX_VMCS_ENUM.MAX_INDEX.
>=20
> To fix the immediate issue, going with the "smaller or equal" check =
makes
> sense.  To get the coverage I originally intended, I'll work on a test =
to
> find the max non-failing field and compare it against MAX_INDEX.

FYI: This test is really annoying since it fails on bare-metal due to =
the
erratum "IA32_VMX_VMCS_ENUM MSR (48AH) Does Not Properly Report The =
Highest
Index Value Used For VMCS Encoding=E2=80=9D.

