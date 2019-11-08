Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03B1AF4FD3
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 16:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfKHPfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 10:35:22 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33580 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfKHPfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 10:35:22 -0500
Received: by mail-wr1-f68.google.com with SMTP id w9so729095wrr.0;
        Fri, 08 Nov 2019 07:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:mime-version:subject:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SbkmlkN5jpTt12JqeB/zwlBhcAYrsOUAl/pPHvX37os=;
        b=cZe0vRFv74BSXfy+YmlelBisWBhoHdHIsRzofJ/60xsjCfGzOSJGOdoihAFEWBZ5cV
         0gAjbKi1Lnm3I0BRmGQu+TqTwAu6G5vQJvGkm2OCEQRhgSwKjgItxIEkdCe/rRdTypSD
         szZE6xmKIdbF/Kj6RXm2+EbzJCg0xTTUAQ/0UdCHsY9P5mhrCUTzbNPpJzqP5DY3+/HM
         zwonhQmkg43S7JWFzq3Lg3Hu6z2yj/Qo2u73cLspcSCjn6Tient2uoqeqQSQ9Rn/sx6t
         KJn1n5H5W6n6qLcDeSGap78EHn1Gh42uhvCzQjuH8QER6b0J2qcUKkog6FSTlRU0EKB0
         qfbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:mime-version:subject:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SbkmlkN5jpTt12JqeB/zwlBhcAYrsOUAl/pPHvX37os=;
        b=NRDe5mupqGdnZ21uoyZesAY/8u/Nl6kEDzuZIc5f2quG6HLRNi6wHQYpTpiOY4ebm3
         hatN+aomgA6bWUZWgvSUYISZCq0MEqPJ549ORinxGKRBtRRSgB8luivEgAV+OnTRnCxB
         8n9J6aL2V4A8x6dX2Jp+cMBFwuBm4SoYTUTagDoOgKfmBDnJzukq6CZSLhFqzbpwaAxO
         YdV7BN4Y+Pc2D6KQheRCVkg6l7w2TmTmD/iFht17667nC8xvypcxIePqe7vdop8mCjrQ
         YVzbWkmrN6OYkucfx5jYqIh9FMiEYFWVl0hz8HvakpGCTaq+DdIhpZxtAP8zFbJZy4YQ
         AhpQ==
X-Gm-Message-State: APjAAAWdHt97tkLO40mf3ZeEkm3fGGY3YV8aGm0VHa+2GRL/5Orbnlfl
        aFaI41ovJXAaUzjgAMVO3Bw=
X-Google-Smtp-Source: APXvYqy08vkw4vGMeVMWj79nMlE8UMHA+pqOgUq66G60KuccNsYzT86eTmZT3/7ucvd8axJI98HmVw==
X-Received: by 2002:a5d:448f:: with SMTP id j15mr8640350wrq.70.1573227320000;
        Fri, 08 Nov 2019 07:35:20 -0800 (PST)
Received: from ?IPv6:2a01:e35:8b6a:1220:2579:40b1:2c5b:78ec? ([2a01:e35:8b6a:1220:2579:40b1:2c5b:78ec])
        by smtp.gmail.com with ESMTPSA id f140sm7539457wme.21.2019.11.08.07.35.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 07:35:19 -0800 (PST)
From:   Christophe de Dinechin <christophe.de.dinechin@gmail.com>
X-Google-Original-From: Christophe de Dinechin <christophe@dinechin.org>
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
In-Reply-To: <713ECF67-6A6C-4956-8AC6-7F4C05961328@oracle.com>
Date:   Fri, 8 Nov 2019 16:35:17 +0100
Cc:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        KVM list <kvm@vger.kernel.org>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E392C60C-A596-49DD-B604-8B3C473ACAA2@dinechin.org>
References: <20191105161737.21395-1-vkuznets@redhat.com>
 <20191105193749.GA20225@linux.intel.com>
 <20191105232500.GA25887@linux.intel.com>
 <943488A8-2DD7-4471-B3C7-9F21A0B0BCF9@dinechin.org>
 <713ECF67-6A6C-4956-8AC6-7F4C05961328@oracle.com>
To:     Liran Alon <liran.alon@oracle.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 7 Nov 2019, at 16:02, Liran Alon <liran.alon@oracle.com> wrote:
>=20
>=20
>=20
>> On 7 Nov 2019, at 16:00, Christophe de Dinechin =
<christophe.de.dinechin@gmail.com> wrote:
>>=20
>=20
>>=20
>> I share that concern about the naming, although I do see some
>> value in exposing the cpu_smt_possible() result. I think it=E2=80=99s =
easier
>> to state that something does not work than to state something does
>> work.
>>=20
>> Also, with respect to mitigation, we may want to split the two cases
>> that Paolo outlined, i.e. have KVM_HINTS_REALTIME,
>> KVM_HINTS_CORES_CROSSTALK and
>> KVM_HINTS_CORES_LEAKING,
>> where CORES_CROSSTALKS indicates there may be some
>> cross-talk between what the guest thinks are isolated cores,
>> and CORES_LEAKING indicates that cores may leak data
>> to some other guest.
>>=20
>> The problem with my approach is that it is shouting =E2=80=9Cdon=E2=80=99=
t trust me=E2=80=9D
>> a bit too loudly.
>=20
> I don=E2=80=99t see a value in exposing CORES_LEAKING to guest. As =
guest have nothing to do with it.

The guest could display / expose the information to guest sysadmins
and admin tools (e.g. through /proc).

While the kernel cannot mitigate, a higher-level product could for =
example
have a policy about which workloads can be deployed on a system which
may leak data to other VMs.

Christophe
