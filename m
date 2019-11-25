Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 486D210930D
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 18:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfKYRp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 12:45:28 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:42388 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfKYRp2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 12:45:28 -0500
Received: by mail-il1-f193.google.com with SMTP id f6so10989995ilh.9
        for <kvm@vger.kernel.org>; Mon, 25 Nov 2019 09:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=coJyU+4qREBEXdozgDK+dfkrbikBToh6UYgtKlgIJ20=;
        b=ruKrcRmI5YPOA9c1g6SP1eCeoGcLBlBfEJQaFoNZkCm21QoF82NvIBNdRsZydVhApl
         RyxW0icHTw9SKup3a6TC2BZdO9eZp/utmq5NKGfWYZVwGDd+omfpFW/E3a1E4LFe4U2b
         bgKrILzenS7SnWHMIB8Tu7uVdKSmpvhqenHCh5/yjOgTtHYeKvMgaUHKJKeirVQm4QA4
         pWX+K0UxSl3uMK4K8bWtmgNGGZ5xe5C2NDiqtRCmv/nJi79QFP9a06oj4X8ptRogDi/m
         I3o4AXy3ARuwOFtyPNt1yDGyeKQJ2aJpCAhRuQl90NlW6ScEi5eqA9LDnbr8gV1wEMiW
         DCMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=coJyU+4qREBEXdozgDK+dfkrbikBToh6UYgtKlgIJ20=;
        b=dEF+yMA7TO4BoZJjW+w2/V/ykrQsLeZglBLREdNiYBKF9XHFuGAmvVWeLcDHazI6kL
         QFQi8iBJzEXvopT5pfSJDyDbDVSa+aVhtlxQhvwpARyReIgRJ7GDffRvu36zd1M1Z4QE
         1FO00npVnHRb4Fd5yfiO5bUuW4frP8v0tnwQzHu0oW9rWXsIh09x6TgDnn153NjqROEJ
         1uCLAyJphzNH/Ng0329k65b//Xp2TY1AdnTFy3rbbdp9wJ9l4Loe5GEU1INwoUkRTCJB
         re1kBj8SeIIff8LbLIYiXI0I2IvHp4k6jEEGec5ijmlTLlaHn2HSGWREcHtel6H8B+DR
         ZItQ==
X-Gm-Message-State: APjAAAV9Ly8Ol7BPWv1QytxmokMfaHzOMzlCy/AVWMwA7o2GsCOqURYO
        iRKJ0Rw4htvc5XD519EaqKV/oDUPOGQ9ukZglERqNg==
X-Google-Smtp-Source: APXvYqyVe7mhuyvMijN0B6XS5N09IEkfXUwA+n1acRP2mrsBkUeBS/g2eRfEcKr/KGMaZQeagwd/ZYURHWWDPEI4Fqg=
X-Received: by 2002:a92:ce0d:: with SMTP id b13mr34511794ilo.26.1574703927252;
 Mon, 25 Nov 2019 09:45:27 -0800 (PST)
MIME-Version: 1.0
References: <20191122234355.174998-1-jmattson@google.com> <97EE5F0F-3047-46BC-B569-D407B5800499@oracle.com>
 <CALMp9eTLQrFprNoYtXa2MCiAGnHuf4Rqxxh33cXD936boxMEwg@mail.gmail.com> <E5F51322-35EF-4EC1-AF3E-2233C6C37645@oracle.com>
In-Reply-To: <E5F51322-35EF-4EC1-AF3E-2233C6C37645@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 25 Nov 2019 09:45:16 -0800
Message-ID: <CALMp9eQ12F4OuJmvvUKLTXoKhF5UtdYBV22sTqrTffTUfj1WzQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: nVMX: Relax guest IA32_FEATURE_CONTROL constraints
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Haozhong Zhang <haozhong.zhang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 22, 2019 at 5:49 PM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 23 Nov 2019, at 2:22, Jim Mattson <jmattson@google.com> wrote:
> >
> > On Fri, Nov 22, 2019 at 3:57 PM Liran Alon <liran.alon@oracle.com> wrot=
e:
> >>
> >>
> >>> On 23 Nov 2019, at 1:43, Jim Mattson <jmattson@google.com> wrote:
> >>>
> >>> Commit 37e4c997dadf ("KVM: VMX: validate individual bits of guest
> >>> MSR_IA32_FEATURE_CONTROL") broke the KVM_SET_MSRS ABI by instituting
> >>> new constraints on the data values that kvm would accept for the gues=
t
> >>> MSR, IA32_FEATURE_CONTROL. Perhaps these constraints should have been
> >>> opt-in via a new KVM capability, but they were applied
> >>> indiscriminately, breaking at least one existing hypervisor.
> >>>
> >>> Relax the constraints to allow either or both of
> >>> FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX and
> >>> FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX to be set when nVMX is
> >>> enabled. This change is sufficient to fix the aforementioned breakage=
.
> >>>
> >>> Fixes: 37e4c997dadf ("KVM: VMX: validate individual bits of guest MSR=
_IA32_FEATURE_CONTROL")
> >>> Signed-off-by: Jim Mattson <jmattson@google.com>
> >>
> >> I suggest to also add a comment in code to clarify why we allow settin=
g
> >> FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX even though we expose a vCPU =
that doesn=E2=80=99t support Intel TXT.
> >> (I think the compatibility to existing workloads that sets this blindl=
y on boot is a legit reason. Just recommend documenting it.)
> >>
> >> In addition, if the nested hypervisor which relies on this is public, =
please also mention it in commit message for reference.
> >
> > It's not an L1 hypervisor that's the problem. It's Google's L0
> > hypervisor. We've been incorrectly reporting IA32_FEATURE_CONTROL as 7
> > to nested guests for years, and now we have thousands of running VMs
> > with the bogus value. I've thought about just changing it to 5 on the
> > fly (on real hardware, one could almost blame it on SMM, but the MSR
> > is *locked*, after all).
>
> If I understand correctly, you are talking about the case a VM is already=
 running and you will
> perform Live-Migration on it to a new host with a new kernel that it=E2=
=80=99s KVM don=E2=80=99t allow to
> set FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX.
>
> If we haven=E2=80=99t encountered yet some guest workload that blindly se=
ts this bit in IA32_FEATURE_CONTROL,
> then it should be sufficient for you to modify vmx_set_msr() to allow set=
ting this bit in case msr_info->host_initiated
> (i.e. During restore of VM state on destination) but disallow it when WRM=
SR is initiated from guest.
> The behaviour of whether vmx_set_msr() allows host to set this MSR to uns=
upported can even be gated by an opt-in KVM cap
> that will be set by Google=E2=80=99s userspace VMM.

I would call that an opt-out cap, rather than an opt-in cap. That is,
we'd like to opt-out from the ABI change. I was going to go ahead and
do it, but it looks like Paolo has accepted the change as it is.

Thanks, Paolo!

> That way, you won=E2=80=99t change change guest runtime semantics (it=E2=
=80=99s original locked MSR value will be preserved during Live-Migration),
> and you will disallow newly provisioned guests from setting IA32_FEATURE_=
CONTROL to an unsupported value.
>
> What do you think?
>
> -Liran
>
>
>
>
>
