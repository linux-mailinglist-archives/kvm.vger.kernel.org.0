Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C30886F64
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 03:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405423AbfHIBfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Aug 2019 21:35:40 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:44657 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbfHIBfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Aug 2019 21:35:40 -0400
Received: by mail-ot1-f68.google.com with SMTP id b7so76341245otl.11
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2019 18:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=oT9+0FRk0XTKJRYl2Q4sGfwT0uvjls0OapEyGavcfH0=;
        b=bTgJPRLs2KrCeHGbSsBv9KpIvMO4o+oQxiwzpIwFpWL81l/u3yEfGm+OY2bjOE74R0
         9yYJw3nQi+IWuSeNzJUo1TO+upgefj8sw6thmlg87ONcHJ3BejfoutIAglkH2W1wIIzm
         41roYeNsXFspvh63xyi/HLeMW1uplON18rcefr8C4qTXVAdZ4fVmBYwo7wcmbvU7vJ1N
         vp2AVdy+3DnZW7iP3rOXxmt/us1b4gnH40TgQVxUcai+W8og/9GcqaEgP48JE/ttGIst
         PBl1Nr3HEwTHZ++nPN65TvwKesqbXB1Bgw3u07ro5xdvOsdOgWIEOrkOGNsEP3Z63dR/
         OAEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=oT9+0FRk0XTKJRYl2Q4sGfwT0uvjls0OapEyGavcfH0=;
        b=lqYvMJVCvhVuF2FdNEs/ertfb4orGdLGxqWeONUleganVcyw+33CHZ4X6xup8ca5TR
         rxsfS7sDjp8iEOLcfNQU4z1hryaILnNoyItJtTAPGT9d24vCs9KNsZd2nomoMZtbpr9Q
         IbrdiM+WnYIXCklYBlsvgkqlcxVa/u/cpZ0DcxDviRAtcTznoM2J2UYlilcm4M+7qWrQ
         ADEh8xMLtA9WMstz+nCO4zzYVkQ84KW+/N8KnC8SyX+x/AXQfeWvC6c/rew7tWlRZDd0
         ABuXl59Zz4qzCSfIbmgIb7FlEumcS6ftPO7KoRX/YHFYpRIs09s+qHQxIswKhosonlXJ
         Pb5w==
X-Gm-Message-State: APjAAAXdFSZRvoMt5e6YDDbv3D+0uIknySuIQCWPhmf5Ox2PZItrJ9u+
        vEhBgQDba+n5XDJYySoEnbgl7Q==
X-Google-Smtp-Source: APXvYqz6ICJH3+/BdftjNoVT6B/6SpEFAG0akxiwAjeOkWh6cvUY64FsLO+6gp/jqLLJBXFNGB3+Kw==
X-Received: by 2002:a6b:641a:: with SMTP id t26mr18476138iog.3.1565314539454;
        Thu, 08 Aug 2019 18:35:39 -0700 (PDT)
Received: from localhost (c-73-95-159-87.hsd1.co.comcast.net. [73.95.159.87])
        by smtp.gmail.com with ESMTPSA id z6sm2274953ioi.8.2019.08.08.18.35.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 18:35:38 -0700 (PDT)
Date:   Thu, 8 Aug 2019 18:35:38 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Paolo Bonzini <pbonzini@redhat.com>
cc:     Anup Patel <Anup.Patel@wdc.com>,
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
Subject: Re: [PATCH v4 00/20] KVM RISC-V Support
In-Reply-To: <df0638d9-e2f4-30f5-5400-9078bf9d1f99@redhat.com>
Message-ID: <alpine.DEB.2.21.9999.1908081824500.21111@viisi.sifive.com>
References: <20190807122726.81544-1-anup.patel@wdc.com> <4a991aa3-154a-40b2-a37d-9ee4a4c7a2ca@redhat.com> <alpine.DEB.2.21.9999.1908071606560.13971@viisi.sifive.com> <df0638d9-e2f4-30f5-5400-9078bf9d1f99@redhat.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 8 Aug 2019, Paolo Bonzini wrote:

> However, for Linux releases after 5.4 I would rather get pull requests 
> for arch/riscv/kvm from Anup and Atish without involving the RISC-V 
> tree.  Of course, they or I will ask for your ack, or for a topic 
> branch, on the occasion that something touches files outside their 
> maintainership area.  This is how things are already being handled for 
> ARM, POWER and s390 and it allows me to handle conflicts in common KVM 
> files before they reach Linus; these are more common than conflicts in 
> arch files. If you have further questions on git and maintenance 
> workflows, just ask!

In principle, that's fine with me, as long as the arch/riscv maintainers 
and mailing lists are kept in the loop.  We already do something similar 
to this for the RISC-V BPF JIT.  However, I'd like this to be explicitly 
documented in the MAINTAINERS file, as it is for BPF.  It looks like it 
isn't for ARM, POWER, or S390, either looking at MAINTAINERS or 
spot-checking scripts/get_maintainer.pl:

$ scripts/get_maintainer.pl -f arch/s390/kvm/interrupt.c 
Christian Borntraeger <borntraeger@de.ibm.com> (supporter:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
Janosch Frank <frankja@linux.ibm.com> (supporter:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
David Hildenbrand <david@redhat.com> (reviewer:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
Cornelia Huck <cohuck@redhat.com> (reviewer:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
Heiko Carstens <heiko.carstens@de.ibm.com> (supporter:S390)
Vasily Gorbik <gor@linux.ibm.com> (supporter:S390)
linux-s390@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE for s390 (KVM/s390))
linux-kernel@vger.kernel.org (open list)
$

Would you be willing to send a MAINTAINERS patch to formalize this 
practice?


- Paul
