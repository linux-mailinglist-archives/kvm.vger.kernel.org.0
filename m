Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930941D73C5
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 11:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgERJTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 05:19:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38854 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726040AbgERJTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 05:19:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589793538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wUvuFHtpRP2kms7NhYOoam9/bRncTEMEMk1lIVn22aw=;
        b=Z6lCW/3tJuAsMF7dkkG/GcH0NH/UsY3Lgsgc76UeWRKNX+s/6osuHNZcEkDbCwxHhAH2tI
        oBesYTz5Fy12Dn1MZbIwjf3V1KiYPSbCLvt+sOrQQvqhuDYkqha1/GxNDlnfhypF5pf4Ss
        kv/IdoO2I+/erPnLOhSRUXPS31YBP8A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-bZZp0pY4MU60M829nM0VXg-1; Mon, 18 May 2020 05:18:57 -0400
X-MC-Unique: bZZp0pY4MU60M829nM0VXg-1
Received: by mail-wr1-f71.google.com with SMTP id r14so5366959wrw.8
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 02:18:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wUvuFHtpRP2kms7NhYOoam9/bRncTEMEMk1lIVn22aw=;
        b=ltxl3fltzrwbTbtM9J2whOppOQjjmergsa2BD0ZEhDndqt/4c2Koivi7//MZ87srGe
         1p4rhBliS7sNxDeY+LPwkSDBEunqX4MljKqNb1c5PB+1o+2562CkI0ggraCuvZrYBhYi
         WYiyvr9i+UnI6+LSc7ey76xGME/fElx2Fja1ErvaQZbKKCeggJPQnW2bDPtLgJWr9vrz
         KYAXiAcPAlxJWhsd/PpTfJPn+H1oVGqov8HYLPBRqK4B6ocC6PYsq2OVNxg5WsTdVeho
         WvtNixkZMBhlcem11djr6DA0SvEQhzFT2dMVMocYWmu6n/RwKOqG7yF1DfhKT6cX0mrG
         X6SA==
X-Gm-Message-State: AOAM5301Omk7O736Dkts0Olopa/wGb3vGlXi5B47XXMEV1HvgCEvFJw3
        BuZs35ctlAqmdP4qfLabQmYlEE7K2KgfCGsFH0KgwEJZ+yemQgFOAzbqcR023W7G5ghW2D8tU/1
        vPokaDE3KncWc
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr19179736wme.154.1589793535931;
        Mon, 18 May 2020 02:18:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwi7pOADLN/te5X0J+pmMiiuSIEST5v0Ejiqlgn996sQFmMXUsyHPVUkRkXSpo0mOyUHs5dug==
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr19179715wme.154.1589793535716;
        Mon, 18 May 2020 02:18:55 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z11sm15011531wrr.32.2020.05.18.02.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 02:18:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Anastassios Nanos <ananos@nubificus.co.uk>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] Expose KVM API to Linux Kernel
In-Reply-To: <CALRTab-mEYtRG4zQbSGoAri+jg8xNL-imODv=MWE330Hkt_t+Q@mail.gmail.com>
References: <cover.1589784221.git.ananos@nubificus.co.uk> <87y2ppy6q0.fsf@nanos.tec.linutronix.de> <CALRTab-mEYtRG4zQbSGoAri+jg8xNL-imODv=MWE330Hkt_t+Q@mail.gmail.com>
Date:   Mon, 18 May 2020 11:18:53 +0200
Message-ID: <87o8qlvbwi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Anastassios Nanos <ananos@nubificus.co.uk> writes:

> Moreover, it doesn't involve *any* mode switch at all while printing
> out the result of the  addition of these two registers -- which I
> guess for a simple use-case like this it isn't much.
> But if we were to scale this to a large number of exits (and their
> respective handling in user-space) that would incur significant
> overhead.

Eliminating frequent exits to userspace when the guest is already
running is absolutely fine but eliminating userspace completely, even
for creation of the guest, is something dubious. To create a simple
guest you need just a dozen of IOCTLs, you'll have to find a really,
really good showcase when it makes a difference. 

E.g. I can imagine the following use-case: you need to create a lot of
guests with the same (or almost the same) memory contents and allocating
and populating this memory in userspace takes time. But even in this
use-case, why do you need to terminate your userspace? Or would it be
possible to create guests from a shared memory? (we may not have
copy-on-write capabilities in KVM currently but this doesn't mean they
can't be added).

Alternatively, you may want to mangle vmexit handling somehow and
exiting to userspace seems slow. Fine, let's add eBPF attach points to
KVM and an API to attach eBPF code there.

I'm, however, just guessing. I understand you may not want to reveal
your original idea for some reason but without us understanding what's
really needed I don't see how the change can be reviewed.

-- 
Vitaly

