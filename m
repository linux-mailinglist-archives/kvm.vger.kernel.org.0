Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF7C87328
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 09:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405899AbfHIHh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 03:37:26 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55802 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405892AbfHIHhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 03:37:24 -0400
Received: by mail-wm1-f68.google.com with SMTP id f72so4669482wmf.5
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2019 00:37:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uupbz8YTA+5+vl0Fvj16ZEysWFtXXYG59jnDaWr/XA8=;
        b=lnjGbIYw53dlDgSRi9hWImx4R18QWfhBWTwOTwQGkuqPdvByQUIldm7hFHZWkSSsHX
         eBtp18IRyPfVmYD3CAMrFCqog3mWpQz3qLs8hWQ1Y6GzAM63ZhCOD1gNPfuszbDMW8JS
         AwRZ3wUPqXit26DEC3m1PODrZAxeSSY9ZLNbYkYg/LEgXgaxDZqGwHXkC6DvH1oSx5TR
         j3M7wOo9RdQerrz+CpfwujXN5pvg53v7jBGYDOA6nMWv/HKbwIwcuaTvGSZabXPXK//s
         bs6CV3WLeTrpv15QthooKP7Eu7WvRoKh6WPMnM2qGVMJ1LKrgDC7hx5B2Ct5M2IeXT9H
         z4Tg==
X-Gm-Message-State: APjAAAW5ACXxbLPlGDENJpLdp8TVlEPes/gWMz6sOZwKIXW+i0NbzwSi
        4lbhwRKA7J2phIFOqrE8aK21q4ULyj0=
X-Google-Smtp-Source: APXvYqxpCCW54J3fN4T1bkdCwN0FL2+ouWimhzANbhGNXOTpOA9eMsxirOHRMFEtnyEluH/UmRwhLQ==
X-Received: by 2002:a1c:99c6:: with SMTP id b189mr9246872wme.57.1565336242632;
        Fri, 09 Aug 2019 00:37:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b42d:b492:69df:ed61? ([2001:b07:6468:f312:b42d:b492:69df:ed61])
        by smtp.gmail.com with ESMTPSA id 4sm227355416wro.78.2019.08.09.00.37.21
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 00:37:22 -0700 (PDT)
Subject: Re: [PATCH v4 00/20] KVM RISC-V Support
To:     Paul Walmsley <paul.walmsley@sifive.com>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190807122726.81544-1-anup.patel@wdc.com>
 <4a991aa3-154a-40b2-a37d-9ee4a4c7a2ca@redhat.com>
 <alpine.DEB.2.21.9999.1908071606560.13971@viisi.sifive.com>
 <df0638d9-e2f4-30f5-5400-9078bf9d1f99@redhat.com>
 <alpine.DEB.2.21.9999.1908081824500.21111@viisi.sifive.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2ea0c656-bd7e-ae79-1f8e-6b60374ccc6e@redhat.com>
Date:   Fri, 9 Aug 2019 09:37:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.9999.1908081824500.21111@viisi.sifive.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/19 03:35, Paul Walmsley wrote:
> On Thu, 8 Aug 2019, Paolo Bonzini wrote:
> 
>> However, for Linux releases after 5.4 I would rather get pull requests 
>> for arch/riscv/kvm from Anup and Atish without involving the RISC-V 
>> tree.  Of course, they or I will ask for your ack, or for a topic 
>> branch, on the occasion that something touches files outside their 
>> maintainership area.  This is how things are already being handled for 
>> ARM, POWER and s390 and it allows me to handle conflicts in common KVM 
>> files before they reach Linus; these are more common than conflicts in 
>> arch files. If you have further questions on git and maintenance 
>> workflows, just ask!
> 
> In principle, that's fine with me, as long as the arch/riscv maintainers 
> and mailing lists are kept in the loop.  We already do something similar 
> to this for the RISC-V BPF JIT.  However, I'd like this to be explicitly 
> documented in the MAINTAINERS file, as it is for BPF.  It looks like it 
> isn't for ARM, POWER, or S390, either looking at MAINTAINERS or 
> spot-checking scripts/get_maintainer.pl:
> 
> $ scripts/get_maintainer.pl -f arch/s390/kvm/interrupt.c 
> Christian Borntraeger <borntraeger@de.ibm.com> (supporter:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
> Janosch Frank <frankja@linux.ibm.com> (supporter:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
> David Hildenbrand <david@redhat.com> (reviewer:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
> Cornelia Huck <cohuck@redhat.com> (reviewer:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
> Heiko Carstens <heiko.carstens@de.ibm.com> (supporter:S390)
> Vasily Gorbik <gor@linux.ibm.com> (supporter:S390)
> linux-s390@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
> linux-kernel@vger.kernel.org (open list)
> $
> 
> Would you be willing to send a MAINTAINERS patch to formalize this 
> practice?

Ah, I see, in the MAINTAINERS entry

KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
M:	Anup Patel <anup.patel@wdc.com>
R:	Atish Patra <atish.patra@wdc.com>
L:	linux-riscv@lists.infradead.org
T:	git git://github.com/avpatel/linux.git
S:	Maintained
F:	arch/riscv/include/uapi/asm/kvm*
F:	arch/riscv/include/asm/kvm*
F:	arch/riscv/kvm/

the L here should be kvm@vger.kernel.org.  arch/riscv/kvm/ files would
still match RISC-V ARCHITECTURE and therefore
linux-riscv@lists.infradead.org would be CCed.

Unlike other subsystems, for KVM I ask the submaintainers to include the
patches in their pull requests, which is why you saw no kvm@vger entry
for KVM/s390.  However, it's probably a good idea to add it and do the
same for RISC-V.

Is that what you meant?

Paolo
