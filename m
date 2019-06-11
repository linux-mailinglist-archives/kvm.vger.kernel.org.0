Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE3713C115
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 03:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390664AbfFKBsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 21:48:19 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36628 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFKBsT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 21:48:19 -0400
Received: by mail-pg1-f194.google.com with SMTP id a3so5995607pgb.3;
        Mon, 10 Jun 2019 18:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=j+N/oz9ewSf1uzJtrwZj4fSW3UaedXAd0tvAVxxwGDQ=;
        b=TKKFa09YIMxRKoPIribOASB9kzjZArL2NWoHTraN60xpIXbpHyiEAyWwLbx8Kj4xoQ
         qYZIHAG+2gvyq9E6Q5KPrk8Dv/xAEkpoAhLr8aV1Ss6OjVeyq/y4v+VacT6y4Ie955ce
         vBQR2n1E/0ud36tnqNK3RVaqdfX2O58yYIo9HLv8j/Xj9fZoz3mBS5WvnKrrq9XZL5Y5
         jMA5DeSa3Fne1z8uVfqgiU9QuXZ2NRJQNHi1+aDule9ctnyJG0YyvTF3T7MCTS2WiXI/
         HjXmyV+A5I4w+pZbWRpkSay8bl+Xdf6UZ4qRP29t+579hp79bu6s9fAF0I/TEjiPiuni
         Wf+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=j+N/oz9ewSf1uzJtrwZj4fSW3UaedXAd0tvAVxxwGDQ=;
        b=LxQN9KfnZeERewAfVh5/bn+BQUSYFAE81OqtXsZ56QCohqzawTPRVg5bNbeHSlBzgM
         dTYbgxaRbRtjMq78Dh3SWzQymlZFvS2G96tbSOQNTmZlEcEfmUb35qOwEcK4iicRjDB2
         melxnZ6DU/Mgss0YZxkPSF2G9MepiqzW7MmpgowajRFjbd3dwnO2FeQXFI+1lX3WjVjT
         k0f9nnUEoTT+voXC5jgJsh7h2+ufetO9x5X8gqdnD55hPdKtmKg7dYCiOsUStlRpo5P3
         LcUPkfN8AhyPynDIffi/uJan41ySv3gAMAFIQ2xs1ZxfD34QK2vjIhekB/BETj09Rrs4
         X2aw==
X-Gm-Message-State: APjAAAU5T25Vvd+COVI5TiDwzNUdOGdqP2Qw7L3eK2t0q+Fe8zntWnap
        qXn70Y3mwBVWvFjFX0btSdA=
X-Google-Smtp-Source: APXvYqzyXO4RciUwJXuZZNwWj1WdybwXH77yRQGcRE/YdfxOTDjdUbWhVoj7iFc3COVOyguQapBhpw==
X-Received: by 2002:a62:e917:: with SMTP id j23mr71948692pfh.55.1560217698427;
        Mon, 10 Jun 2019 18:48:18 -0700 (PDT)
Received: from [10.2.189.129] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id e20sm11402106pfi.35.2019.06.10.18.48.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 18:48:17 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH v3 0/3] KVM: Yield to IPI target if necessary
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CANRm+Cwv5jqxBW=Ss5nkX7kZM3_Y-Ucs66yx5+wN09=W4pUdzA@mail.gmail.com>
Date:   Mon, 10 Jun 2019 18:48:15 -0700
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F136E492-5350-49EE-A856-FBAEDB12FF99@gmail.com>
References: <1559178307-6835-1-git-send-email-wanpengli@tencent.com>
 <20190610143420.GA6594@flask> <20190611011100.GB24835@linux.intel.com>
 <CANRm+Cwv5jqxBW=Ss5nkX7kZM3_Y-Ucs66yx5+wN09=W4pUdzA@mail.gmail.com>
To:     Wanpeng Li <kernellwp@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jun 10, 2019, at 6:45 PM, Wanpeng Li <kernellwp@gmail.com> wrote:
>=20
> On Tue, 11 Jun 2019 at 09:11, Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
>> On Mon, Jun 10, 2019 at 04:34:20PM +0200, Radim Kr=C4=8Dm=C3=A1=C5=99 =
wrote:
>>> 2019-05-30 09:05+0800, Wanpeng Li:
>>>> The idea is from Xen, when sending a call-function IPI-many to =
vCPUs,
>>>> yield if any of the IPI target vCPUs was preempted. 17% performance
>>>> increasement of ebizzy benchmark can be observed in an =
over-subscribe
>>>> environment. (w/ kvm-pv-tlb disabled, testing TLB flush =
call-function
>>>> IPI-many since call-function is not easy to be trigged by userspace
>>>> workload).
>>>=20
>>> Have you checked if we could gain performance by having the yield as =
an
>>> extension to our PV IPI call?
>>>=20
>>> It would allow us to skip the VM entry/exit overhead on the caller.
>>> (The benefit of that might be negligible and it also poses a
>>> complication when splitting the target mask into several PV IPI
>>> hypercalls.)
>>=20
>> Tangetially related to splitting PV IPI hypercalls, are there any =
major
>> hurdles to supporting shorthand?  Not having to generate the mask for
>> ->send_IPI_allbutself and ->kvm_send_ipi_all seems like an easy to =
way
>> shave cycles for affected flows.
>=20
> Not sure why shorthand is not used for native x2apic mode.

Why do you say so? native_send_call_func_ipi() checks if allbutself
shorthand should be used and does so (even though the check can be more
efficient - I=E2=80=99m looking at that code right now=E2=80=A6)=
