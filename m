Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 653747A704
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 13:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbfG3LdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 07:33:12 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54594 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728412AbfG3LdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 07:33:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id p74so56772967wme.4
        for <kvm@vger.kernel.org>; Tue, 30 Jul 2019 04:33:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UPB+O1cCb7Wq2RKCoVQnzfZBI5pS9MKq+7qoNAVhJ6s=;
        b=TCUIS6uEgJWSRJzmPEab8k5xwLdJNXMMGHT4KT3vxbbjC6bLaz7KDImB9PGBohx5zo
         YcLV2cjthlZKQcvJv9z1V1zJNU8Sj3phxOn7X5+Or7VnGCn1/ugtpdEMooyQAST5F3gi
         LL/0TiyG7rcpWaQ4AeoV599dF2zySXqVcf5TwxdaN0yCv4zs+ui1eUeLO4dF+bhTEVa+
         s0iNxaWR/23UNZTAvIqyHVo3R8AGgYyNvacOG/S57yFf/pRRzYcuZjvYT94Vx+sO9HAF
         wjOWJsFAAdPCZXKFiMkvvQ+auutnjEff29hzrhes4kS1+fbk/fZ4sRqb2qpmN/79BBqf
         rqqA==
X-Gm-Message-State: APjAAAWdgxaYUc0+4Z67BDq3KXBd4MNlcjPs0kpKTPdW3z9BhrgfzqQa
        4UnAwQjYGHlrZoRoY5Vc+RFjoA==
X-Google-Smtp-Source: APXvYqwZbQfaWi8ZX3vZiY1Jont5uSIg4Z3fLMXkr7rwafZ4q9S6fJyyXi6HPOxn4HmB3Yz8Zlp4bw==
X-Received: by 2002:a7b:c144:: with SMTP id z4mr109313020wmi.50.1564486390353;
        Tue, 30 Jul 2019 04:33:10 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id j10sm111237085wrd.26.2019.07.30.04.33.08
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 04:33:09 -0700 (PDT)
Subject: Re: [RFC PATCH 00/16] KVM RISC-V Support
To:     Anup Patel <anup@brainfault.org>
Cc:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190729115544.17895-1-anup.patel@wdc.com>
 <72e9f668-f496-3fca-a1a8-a3c3122a3fd9@redhat.com>
 <CAAhSdy3Z6d2phRGo20eNWfa4onFwFtsOUPM+OCD465y0tvQ5wg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <965cffdb-86e2-b422-9c23-345c7100fd88@redhat.com>
Date:   Tue, 30 Jul 2019 13:33:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhSdy3Z6d2phRGo20eNWfa4onFwFtsOUPM+OCD465y0tvQ5wg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/07/19 07:26, Anup Patel wrote:
> Here's a brief TODO list which we want to immediately work upon after this
> series:
> 1. Handle trap from unpriv access in SBI v0.1 emulation
> 2. In-kernel PLIC emulation
> 3. SBI v0.2 emulation in-kernel
> 4. SBI v0.2 hart hotplug emulation in-kernel
> 5. ..... and so on .....
> 
> We will include above TODO list in v2 series cover letter as well.

I guess I gave you a bunch of extra items in today's more thorough
review. :)

BTW, since IPIs are handled in the SBI I wouldn't bother with in-kernel
PLIC emulation unless you can demonstrate performance improvements (for
example due to irqfd).  In fact, it may be more interesting to add
plumbing for userspace handling of selected SBI calls (in addition to
get/putchar, sbi_system_reset and sbi_hart_down look like good
candidates in SBI v0.2).

> We were thinking to keep KVM RISC-V disabled by default (i.e. keep it
> experimental) until we have validated it on some FPGA or real HW. For now,
> users can explicitly enable it and play-around on QEMU emulation. I hope
> this is fine with most people ?

That's certainly okay with me.

Paolo
