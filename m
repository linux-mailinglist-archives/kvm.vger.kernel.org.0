Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52BC79AECD
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 14:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405222AbfHWMKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 08:10:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54684 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730989AbfHWMKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 08:10:53 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5FD972D0FC7
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 12:10:53 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id q18so2916082wmj.8
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 05:10:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YmpuoFAf1JV9E3g21xDaHXmAHG9KWMG9xyLy+0tzG68=;
        b=kB6cxXJtUFSK+UemeG2fcxq19j8GFmvLYkKZmnrQ6CthL5+Y4AofiLcWeL9CjWK7Ib
         KHF4myByZot5zaMDbimTiW/aKTAiRPmLRxH2RjdJiSWhWWTg981vuppOnOys81V2W9Y2
         Idjl7cKzXJy49LxLHhrRfD97OiiKqmOqqiprXGbS7sdhIyshZ0yFqWynektUjudKVKzp
         etMGMGCx+Vf0b0KmVECMSvY5znbBqFKYjqaxHpnmMIrc+ZdNay3dRndFA4BDnRta9an2
         F6vAgZFdyX8dNoKvjv4Fla717pXKZwT8MU46XXVfP/4Lf+lcVHRwfZ7kcTznGjWaMeoj
         kmvQ==
X-Gm-Message-State: APjAAAWPs0l/kuCBsT3aRHKhKsox9m6aYKeqL6l3yEZnT7d7PTYADHAA
        ui+1FRssVO3GM0iTkn0/SVqV3rLEGgIG56WJSYuGJ7GSfQG+ExQTICwSbycpYDJdoe8iSyzSoQx
        ZNk+KZ70oyH8v
X-Received: by 2002:a05:6000:1c8:: with SMTP id t8mr4657572wrx.296.1566562251952;
        Fri, 23 Aug 2019 05:10:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzyVxw1qUQIBTcRkSh95Cdl4gIPkdK+LHTRDd3Xtmfn2XR4EHjMMfyBhL3S7uHbsTcvuBxUtQ==
X-Received: by 2002:a05:6000:1c8:: with SMTP id t8mr4657537wrx.296.1566562251686;
        Fri, 23 Aug 2019 05:10:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4566:f1b0:32e7:463f? ([2001:b07:6468:f312:4566:f1b0:32e7:463f])
        by smtp.gmail.com with ESMTPSA id g197sm2205295wme.30.2019.08.23.05.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Aug 2019 05:10:51 -0700 (PDT)
Subject: Re: [PATCH v5 00/20] KVM RISC-V Support
To:     "Graf (AWS), Alexander" <graf@amazon.com>,
        Anup Patel <anup@brainfault.org>
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
References: <20190822084131.114764-1-anup.patel@wdc.com>
 <8a2a9ea6-5636-e79a-b041-580159e703b2@amazon.com>
 <CAAhSdy2RC6Gw708wZs+FM56UkkyURgbupwdeTak7VcyarY9irg@mail.gmail.com>
 <757C929B-D26C-46D9-98E8-1191E3B86F3C@amazon.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <fda67a5d-6984-c3ef-8125-7805d927f15b@redhat.com>
Date:   Fri, 23 Aug 2019 14:10:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <757C929B-D26C-46D9-98E8-1191E3B86F3C@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/08/19 13:44, Graf (AWS), Alexander wrote:
>> Overall, I'm quite happy with the code. It's a very clean implementation
>> of a KVM target.

Yup, I said the same even for v1 (I prefer recursive implementation of
page table walking but that's all I can say).

>> I will send v6 next week. I will try my best to implement unpriv
>> trap handling in v6 itself.
> Are you sure unpriv is the only exception that can hit there? What
> about NMIs? Do you have #MCs yet (ECC errors)? Do you have something
> like ARM's #SError which can asynchronously hit at any time because
> of external bus (PCI) errors?

As far as I know, all interrupts on RISC-V are disabled by
local_irq_disable()/local_irq_enable().

Paolo
