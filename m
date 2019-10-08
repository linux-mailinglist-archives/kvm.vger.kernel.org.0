Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0938ECFEED
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 18:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfJHQaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 12:30:18 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36713 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfJHQaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 12:30:18 -0400
Received: by mail-pl1-f193.google.com with SMTP id j11so8692493plk.3
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 09:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=QcYazNM7Vi2H50GIaNRb8IgCikAhIpQZNsoD3GdE2vE=;
        b=gaPoBzoXxPS0jKWr1l3mVKEiSNKdl5+hOGdYP/kL5TSxwq2/LTtIUncBrjLEjR8iHK
         EkdISVCyKuZN8Ba8Q3H6sWIkSB67J/rkVliHi0n2JMDGL1iI9x6BSjJjF3rLsT0KFCb/
         Swaoc4rVXFA6cztc1N4vGG0R4uTRd9v31CHDHXQhmgQAqdZJvBaJfG4uOO8AZK5J4yKk
         PVv0/dUDuTUp2gzHaaP2xI3no9tUSZ5YsvLLs4Kh+wEpBRiigIzGiYYpu7kiEGmJniCL
         BH7QZ4+zuHYyKO5WLTJB2TGxJUz7AnmudBKKZUZCwPtx7BTLhNEWTO8cxI/FNTnQqZgk
         pKWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=QcYazNM7Vi2H50GIaNRb8IgCikAhIpQZNsoD3GdE2vE=;
        b=iPm/SIuNPHa0lQ+Z4Cv955UsSFs0AXd23OFDkRHpj8MUIIrCb5Ar0Goy+rW7Sn/z8+
         4ckdLEH2FqXMDRHCnEiG0jRXQUmgQVZAkQhjKLX+1ALDcxTg4EDsH8mdRuX+PrhWUctW
         arBKeB21Zp1lsZ3VyaOUiKJcKVHpX1rqpt1DObGTk1JT+6/5uVR9s80UswAEtl2um5ir
         8CLpJnInsJk4a/TxOZ8JL44nWqPh8TZm3jmRwU6+LLKllpUiEYTgXtsESKI+u6nIoGzV
         Wo8OWM6OMdU7Pp6NC9MIzZW7wVOw0XwATOTlFZnhzhx1uYLTE/XtgT/rtxS3xD428DBb
         Z0JQ==
X-Gm-Message-State: APjAAAVD2Jyf4Mau5e98B1pz3fM7Iz/M7x3rsHvf9h+mcSscbx/JWT/q
        ENxFEm/qD7nbf9h7/2kwE2JsRHPMQcc=
X-Google-Smtp-Source: APXvYqw6Bmr5k0A5IcLg3XUYdlbC51m0DE47PF0zKsJQCbUo/6ScFVW2LPtfSdbQ5cXQr9nZsxCDQg==
X-Received: by 2002:a17:902:6b45:: with SMTP id g5mr775077plt.190.1570552217267;
        Tue, 08 Oct 2019 09:30:17 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id q29sm22563725pgc.88.2019.10.08.09.30.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 09:30:16 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: KVM-unit-tests on AMD
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <875zkz1lbh.fsf@vitty.brq.redhat.com>
Date:   Tue, 8 Oct 2019 09:30:14 -0700
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        cavery@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <912C44BF-308B-4F74-A145-04FF58F94046@gmail.com>
References: <E15A5945-440C-4E59-A82A-B22B61769884@gmail.com>
 <875zkz1lbh.fsf@vitty.brq.redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 8, 2019, at 5:19 AM, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>=20
> Nadav Amit <nadav.amit@gmail.com> writes:
>=20
>> Is kvm-unit-test supposed to pass on AMD machines or AMD VMs?.
>=20
> It is supposed to but it doesn't :-) Actually, not only kvm-unit-tests
> but the whole SVM would appreciate some love ...
>=20
>> Clearly, I ask since they do not pass on AMD on bare-metal.
>=20
> On my AMD EPYC 7401P 24-Core Processor bare metal I get the following
> failures:
>=20
> FAIL vmware_backdoors (11 tests, 8 unexpected failures)
>=20
> (Why can't we just check
> /sys/module/kvm/parameters/enable_vmware_backdoor btw???)
>=20
> FAIL svm (15 tests, 1 unexpected failures)
>=20
> There is a patch for that:
>=20
> =
https://lore.kernel.org/kvm/d3eeb3b5-13d7-34d2-4ce0-fdd534f2bcc3@redhat.co=
m/T/#t
>=20
> Inside a VM on this host I see the following:
>=20
> FAIL apic-split (timeout; duration=3D90s)
> FAIL apic (timeout; duration=3D30)
>=20
> (I manually inreased the timeout but it didn't help - this is =
worrisome,
> most likely this is a hang)
>=20
> FAIL vmware_backdoors (11 tests, 8 unexpected failures)
>=20
> - same as on bare metal
>=20
> FAIL port80 (timeout; duration=3D90s)
>=20
> - hang again?
>=20
> FAIL svm (timeout; duration=3D90s)
>=20
> - most likely a hang but this is 3-level nesting so oh well..
>=20
> FAIL kvmclock_test=20
>=20
> - bad but maybe something is wrong with TSC on the host? Need to
>  investigate ...
>=20
> FAIL hyperv_clock=20
>=20
> - this is expected as it doesn't work when the clocksource is not TSC
>  (e.g. kvm-clock)
>=20
> Are you seeing different failures?

Thanks for your quick response.

I only ran the =E2=80=9Capic=E2=80=9D tests so far and I got the =
following failures:

FAIL: correct xapic id after reset
=E2=80=A6
x2apic not detected
FAIL: enable unsupported x2apic
FAIL: apicbase: relocate apic

The test gets stuck after =E2=80=9Capicbase: reserved low bits=E2=80=9D.

Well, I understand it is not a bare-metal thing.

