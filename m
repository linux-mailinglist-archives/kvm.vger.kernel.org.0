Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4036614DFB4
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 18:17:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgA3RQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 12:16:57 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:35221 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbgA3RQ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 12:16:57 -0500
Received: by mail-pj1-f67.google.com with SMTP id q39so1624314pjc.0
        for <kvm@vger.kernel.org>; Thu, 30 Jan 2020 09:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=YMQtJsos2o5a2vGvBs3zHzY0eygzY9U697OHegfTvFc=;
        b=hBShpIRUTwGCaXYoFQeYK9qnnNLEeYM92PmRzUd57ii9Zy3Ta4U2KCs6AGkI+T4e5O
         14FiaV+fceomlbaUlZFgHMPTv7Lj37OYe9QY9WDQyq+YkL0tpA0laR5/a14J+vcQrRU1
         /X1Cub8NBxNTEFy04TtMySnqbXD3jcUlxyySjY66YtN+0Vd5evEoH0/NUpeqWEytLfH8
         AreO5PN1Fp0U0d6twdnzzAgEWMc0c4ps/AnpBBidMBwjVvFQofPKGQR28VyLXYbzI2R+
         cbm7h+cUqqI48iD/V/niVL7N2EXpzjqTez3ze3FexeSRUjAPCJLpBwKo8AR/h7YeMuKq
         Bk4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=YMQtJsos2o5a2vGvBs3zHzY0eygzY9U697OHegfTvFc=;
        b=Y51iToSNLyiEan4OtC1rIJCalC3TFPcbQO22Zs/lRckweZQJcxkyQ91s2fFSH7FrR8
         rdP4mFLQDU2RruFGMKWmDUPr6yDA1FgA2D6NaxwhDuknq9gf48v4oDztv8rT3moCd/b7
         u7pOzZDzToisqmnfljp6P6nMmvefUPKhvKfs+0U4dOml+cLllhqwU43NjfufCSyLJiQ7
         WN9UVKWcptq+pNHr7RHgiOfRmdnRrnrVTaGRFMTe3LnlClJuOLB3ajBYTg2xwnyeaQM0
         UhGT/Pu5a2wyIk84cnWM+iQNhIr35xaQmL0rhXObqiTvbvFRXBHlv2o9QIniyASPqkbP
         43Rw==
X-Gm-Message-State: APjAAAU6329+aOFbGBy4OD5T0tmUyzyKyrUYdWtOo82F+cAr24UPdNZ0
        NVS9lIs0IrmR7qL77Y+dKqdUNQ==
X-Google-Smtp-Source: APXvYqz/HanZumE0+gOaDZtoRCZJgLmyvi/x1M0d911Rrv0gRMWU2PPbezu3EhVerXEDMCBuRijzIw==
X-Received: by 2002:a17:90a:ead8:: with SMTP id ev24mr6958304pjb.91.1580404616562;
        Thu, 30 Jan 2020 09:16:56 -0800 (PST)
Received: from ?IPv6:2600:1010:b010:9631:69c2:3ecc:ab84:f45c? ([2600:1010:b010:9631:69c2:3ecc:ab84:f45c])
        by smtp.gmail.com with ESMTPSA id d3sm6838195pfn.113.2020.01.30.09.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 09:16:55 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 2/2] KVM: VMX: Extend VMX's #AC handding
Date:   Thu, 30 Jan 2020 09:16:54 -0800
Message-Id: <A2E4B0E3-EDDF-46FD-8CE9-62A2E2E4BF20@amacapital.net>
References: <cf79eeeb-e107-bdff-13a8-c52288d0d123@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <cf79eeeb-e107-bdff-13a8-c52288d0d123@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
X-Mailer: iPhone Mail (17C54)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jan 30, 2020, at 8:30 AM, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>=20
> =EF=BB=BFOn 1/30/2020 11:18 PM, Andy Lutomirski wrote:
>>>> On Jan 30, 2020, at 4:24 AM, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>>>=20
>>> =EF=BB=BFThere are two types of #AC can be generated in Intel CPUs:
>>> 1. legacy alignment check #AC;
>>> 2. split lock #AC;
>>>=20
>>> Legacy alignment check #AC can be injected to guest if guest has enabled=

>>> alignemnet check.
>>>=20
>>> When host enables split lock detection, i.e., split_lock_detect!=3Doff,
>>> guest will receive an unexpected #AC when there is a split_lock happens i=
n
>>> guest since KVM doesn't virtualize this feature to guest.
>>>=20
>>> Since the old guests lack split_lock #AC handler and may have split lock=

>>> buges. To make guest survive from split lock, applying the similar polic=
y
>>> as host's split lock detect configuration:
>>> - host split lock detect is sld_warn:
>>>   warning the split lock happened in guest, and disabling split lock
>>>   detect around VM-enter;
>>> - host split lock detect is sld_fatal:
>>>   forwarding #AC to userspace. (Usually userspace dump the #AC
>>>   exception and kill the guest).
>> A correct userspace implementation should, with a modern guest kernel, fo=
rward the exception. Otherwise you=E2=80=99re introducing a DoS into the gue=
st if the guest kernel is fine but guest userspace is buggy.
>=20
> To prevent DoS in guest, the better solution is virtualizing and advertisi=
ng this feature to guest, so guest can explicitly enable it by setting split=
_lock_detect=3Dfatal, if it's a latest linux guest.
>=20
> However, it's another topic, I'll send out the patches later.
>=20

Can we get a credible description of how this would work? I suggest:

Intel adds and documents a new CPUID bit or core capability bit that means =E2=
=80=9Csplit lock detection is forced on=E2=80=9D.  If this bit is set, the M=
SR bit controlling split lock detection is still writable, but split lock de=
tection is on regardless of the value.  Operating systems are expected to se=
t the bit to 1 to indicate to a hypervisor, if present, that they understand=
 that split lock detection is on.

This would be an SDM-only change, but it would also be a commitment to certa=
in behavior for future CPUs that don=E2=80=99t implement split locks.

Can one of you Intel folks ask the architecture team about this?=
