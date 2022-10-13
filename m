Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7825C5FDECE
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 19:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJMRTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 13:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiJMRTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 13:19:24 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25407D2CE5
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 10:19:23 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id p127so1786860oih.9
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 10:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j1qTz+oYugF8Lf770mKCIrdepvqmBbCEzwy+EaukMrM=;
        b=RwP93R0i/58OL7LRD+//xbsGSpXEvsNfrhi2GXL/rRnIR0fEBr1hhf0AxtH9ySaIuq
         fxnBUs5tBFF0nv+sS5fXPWTFdyDQIQyfW3oaIHCHCny57nHo+jkN3VT1oW56ATf0pSAn
         /cXKnAs4MWRb/mczWEGT2NYOdgosHqzbcK1Ec=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j1qTz+oYugF8Lf770mKCIrdepvqmBbCEzwy+EaukMrM=;
        b=bQo0nYgAZGY0kBT1ePFc1Ulj3yEQZQTqClAuflHvPpEcpUiN2zHO/JwPOy07oQGezD
         6FYpLXl9w2V140zUo/bm19kgiW7JoWiY8sMJKK7ivVh5p/nOx+icVVIud3cftfVpz/5V
         lD7AQyzW0E0qmaZFi1gzz6Zn8IaradVR+ArkHv8QuukOlzfqWcxcWA/E7BjrI5MSIOP8
         yqUlXPHF7C6KUuk23iG+TYgOIP+HvUcyFjYnRZ5kc6q9lNghH+KxyNEXuYLkjgBYZ3W2
         CrPsj7Xpk2+kREUU7lNcg/A2l/2zFfR7dU0eAyB7XqpRVdKodR5MOszBrdvDdTz4g7/F
         ozNg==
X-Gm-Message-State: ACrzQf3vnsz37Ygc0hhNwHvAqQtbKUtntSyF+m5grjBfOCvxtTrVE6GV
        Tf+PfaqI8iBOgjJ90XoH97XbiLwg+aSfgQ==
X-Google-Smtp-Source: AMsMyM4a29/M+mo8YWRObjG7G78zPmc2Poy/JJP/OMU82vpz0orQTrak/qgSbLxb7b81Alq2ziYJiQ==
X-Received: by 2002:a05:6808:3087:b0:354:badb:8238 with SMTP id bl7-20020a056808308700b00354badb8238mr462300oib.90.1665681561379;
        Thu, 13 Oct 2022 10:19:21 -0700 (PDT)
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com. [209.85.210.45])
        by smtp.gmail.com with ESMTPSA id er33-20020a056870c8a100b0011e37fb5493sm222822oab.30.2022.10.13.10.19.19
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 10:19:19 -0700 (PDT)
Received: by mail-ot1-f45.google.com with SMTP id d18-20020a05683025d200b00661c6f1b6a4so427619otu.1
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 10:19:19 -0700 (PDT)
X-Received: by 2002:a05:6830:4421:b0:661:8fdd:81e9 with SMTP id
 q33-20020a056830442100b006618fdd81e9mr528782otv.69.1665681558964; Thu, 13 Oct
 2022 10:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20221010132030-mutt-send-email-mst@kernel.org>
 <87r0zdmujf.fsf@mpe.ellerman.id.au> <20221012070532-mutt-send-email-mst@kernel.org>
 <87mta1marq.fsf@mpe.ellerman.id.au> <87edvdm7qg.fsf@mpe.ellerman.id.au>
 <20221012115023-mutt-send-email-mst@kernel.org> <CAHk-=wg2Pkb9kbfbstbB91AJA2SF6cySbsgHG-iQMq56j3VTcA@mail.gmail.com>
 <38893b2e-c7a1-4ad2-b691-7fbcbbeb310f@app.fastmail.com> <20221012180806-mutt-send-email-mst@kernel.org>
 <a35fd31b-0658-4ac1-8340-99cdf4c75bb7@app.fastmail.com>
In-Reply-To: <a35fd31b-0658-4ac1-8340-99cdf4c75bb7@app.fastmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 13 Oct 2022 10:19:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=whLv3MO0Tvc62zJ+=4yvSfKMK17C0wfpbXBwUJqSjKbYA@mail.gmail.com>
Message-ID: <CAHk-=whLv3MO0Tvc62zJ+=4yvSfKMK17C0wfpbXBwUJqSjKbYA@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: fixes, features
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, xiujianfeng@huawei.com,
        kvm@vger.kernel.org, alvaro.karsz@solid-run.com,
        Jason Wang <jasowang@redhat.com>, angus.chen@jaguarmicro.com,
        wangdeming@inspur.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, lingshan.zhu@intel.com,
        linuxppc-dev@lists.ozlabs.org, gavinl@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 12, 2022 at 11:29 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Thu, Oct 13, 2022, at 12:08 AM, Michael S. Tsirkin wrote:
> >
> > Do these two boxes even have pci?
>
> Footbridge/netwinder has PCI and PC-style ISA on-board devices
> (floppy, ps2 mouse/keyboard, parport, soundblaster, ...), RiscPC
> has neither.

It's worth noting that changing a driver that does

        if (dev->irq == NO_IRQ)
                return -ENODEV;

to use

        if (!dev->irq)
                return -ENODEV;

should be pretty much always fine.

Even *if* that driver is then compiled and used on an architecture
where NO_IRQ is one of the odd values, you end up having only two
cases

 (a) irq 0 was actually a valid irq after all

 (b) you just get the error later when actually trying to use the odd
NO_IRQ interrupt with request_irq() and friends

and here (a) basically never happens - certainly not for any PCI setup
- and (b) is harmless unless the driver was already terminally broken
anyway.

The one exception for (a) might be some platform irq code. On x86,
that would be the legacy timer interrupt, of course.

So if some odd platform actually has a "real" interrupt on irq0, that
platform should either just fix the irq number mapping, or should
consider that interrupt to be a platform-specific thing and handle it
very very specially.

On x86, for example, we do

        if (request_irq(0, timer_interrupt, flags, "timer", NULL))

early in boot, and that's basically what then makes sure that no
driver can get that irq. It's done through the platform "timer_init"
code at the "late_time_init()" call.

(And that "late_time_init()" - despite the name - isn't very late at
all. It's just later than the very early timekeeping init - after
interrupts have been enabled at all.

             Linus
