Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDD4D01DA
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 22:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729854AbfJHUC0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 16:02:26 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35108 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729436AbfJHUC0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 16:02:26 -0400
Received: by mail-pg1-f194.google.com with SMTP id p30so8791724pgl.2
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 13:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fDTKn4xznmNVQrjrTKIwBwH5edKzKcBfrRMgd7XpCxg=;
        b=PpkUnYhY+UI2hGIE2lbsOTZRfXQl+DK7Bd2N6cECe0iJK7J4HjC7nobXdBpi1MjQ1j
         q9Kb7XlJzENkVivtkljCTVGVKvCtqqxu490YDmK1NGRfH6l1GpqvSvURoVCSAjp3mQAB
         AQ12+6MPMpeoy7C9FCRa4wGKmkeVCwzNr89rIZQCuQXKs3mOUhmgtwo6QomdR/fMT9cB
         NxwTs+/2HS3ss8ucvxt8NWlmQFzkK2nWa/YZcsI6ZlMy/i0myXWieW6IBdJBhpoDAqA6
         9SkYCIPaDj2Mm/ctnYsMNBjtJW//OGDylN2akU07HG2G0G70ze0alJmKy9m0hrZ/w6Bf
         gsCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=fDTKn4xznmNVQrjrTKIwBwH5edKzKcBfrRMgd7XpCxg=;
        b=QtHjhOWz6Y8HbE0kjS62BgIQQa8zHzJWKMHrqJFJR+ykRMIus0ryY6ixUvErW/hWgr
         KkcdFNyZSTVk7xG0UJUa3P2HQ/ownzs6Pxodv0LlUTtQDivaqzJ4EhVub44IAFEsnXre
         ND0iUE2DtB2IPVxz3Yt3W4N6Av/nIf2LeLXvE9LMwnJAu0Qd0eZ+nhtyDb3g7wK0Q3y5
         qwTNT//Uvsl0w02Z71eD4JUIXa2u0HtALrWw32MF0OdfJsqj9Qn7XJtVeFNB+KohiTSH
         RUDB5rdQE+0dNFtDL1l0MdV74ND0HLa98B2vQ/03WYVCgMjkXZXeelCP8s6Y14Fxzhxz
         Z/9g==
X-Gm-Message-State: APjAAAUvhcm5uOhzAHB5KlwGKFvw8hyHWeyNbZjI1QuuetZAi86l12UK
        yjxIpvxxLF9fgiWSKs7Z7wQN3HsxBMU=
X-Google-Smtp-Source: APXvYqxCj1LKy/aIMBeQkCV1oqYhpqCdpRWd44RCYQHCg/W/Ypp3UbzsYQIP3zlyRZc71aehi8EqZg==
X-Received: by 2002:a62:1402:: with SMTP id 2mr42065941pfu.226.1570564945032;
        Tue, 08 Oct 2019 13:02:25 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id u4sm18021380pfu.177.2019.10.08.13.02.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 13:02:24 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: KVM-unit-tests on AMD
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <912C44BF-308B-4F74-A145-04FF58F94046@gmail.com>
Date:   Tue, 8 Oct 2019 13:02:22 -0700
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        cavery@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <E01ED83B-53E8-4AEE-915C-3AE1DA1660E8@gmail.com>
References: <E15A5945-440C-4E59-A82A-B22B61769884@gmail.com>
 <875zkz1lbh.fsf@vitty.brq.redhat.com>
 <912C44BF-308B-4F74-A145-04FF58F94046@gmail.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Oct 8, 2019, at 9:30 AM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>> On Oct 8, 2019, at 5:19 AM, Vitaly Kuznetsov <vkuznets@redhat.com> =
wrote:
>>=20
>> Nadav Amit <nadav.amit@gmail.com> writes:
>>=20
>>> Is kvm-unit-test supposed to pass on AMD machines or AMD VMs?.
>>=20
>> It is supposed to but it doesn't :-) Actually, not only =
kvm-unit-tests
>> but the whole SVM would appreciate some love ...
>>=20
>>> Clearly, I ask since they do not pass on AMD on bare-metal.
>>=20
>> On my AMD EPYC 7401P 24-Core Processor bare metal I get the following
>> failures:
>>=20
>> FAIL vmware_backdoors (11 tests, 8 unexpected failures)
>>=20
>> (Why can't we just check
>> /sys/module/kvm/parameters/enable_vmware_backdoor btw???)
>>=20
>> FAIL svm (15 tests, 1 unexpected failures)
>>=20
>> There is a patch for that:
>>=20
>> =
https://lore.kernel.org/kvm/d3eeb3b5-13d7-34d2-4ce0-fdd534f2bcc3@redhat.co=
m/T/#t
>>=20
>> Inside a VM on this host I see the following:
>>=20
>> FAIL apic-split (timeout; duration=3D90s)
>> FAIL apic (timeout; duration=3D30)
>>=20
>> (I manually inreased the timeout but it didn't help - this is =
worrisome,
>> most likely this is a hang)
>>=20
>> FAIL vmware_backdoors (11 tests, 8 unexpected failures)
>>=20
>> - same as on bare metal
>>=20
>> FAIL port80 (timeout; duration=3D90s)
>>=20
>> - hang again?
>>=20
>> FAIL svm (timeout; duration=3D90s)
>>=20
>> - most likely a hang but this is 3-level nesting so oh well..
>>=20
>> FAIL kvmclock_test=20
>>=20
>> - bad but maybe something is wrong with TSC on the host? Need to
>> investigate ...
>>=20
>> FAIL hyperv_clock=20
>>=20
>> - this is expected as it doesn't work when the clocksource is not TSC
>> (e.g. kvm-clock)
>>=20
>> Are you seeing different failures?
>=20
> Thanks for your quick response.
>=20
> I only ran the =E2=80=9Capic=E2=80=9D tests so far and I got the =
following failures:
>=20
> FAIL: correct xapic id after reset
> =E2=80=A6
> x2apic not detected
> FAIL: enable unsupported x2apic
> FAIL: apicbase: relocate apic
>=20
> The test gets stuck after =E2=80=9Capicbase: reserved low bits=E2=80=9D.=

>=20
> Well, I understand it is not a bare-metal thing.

I ran the SVM test, and on bare-metal it does not pass.

I don=E2=80=99t have the AMD machine for long enough to fix the issues, =
but for the
record, here are test failures and crashes I encountered while running =
the
tests on bare-metal.

Failures:
- cr3 read intercept emulate
- npt_nx
- npt_rsvd
- npt_rsvd_pfwalk
- npt_rw_pfwalk
- npt_rw_l1mmio

Crashes:
- test_dr_intercept - Access to DR4 causes #UD
- tsc_adjust_prepare - MSR access causes #GP

