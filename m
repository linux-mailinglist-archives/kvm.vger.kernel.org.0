Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28670E570E
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2019 01:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfJYXbE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 19:31:04 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:35146 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfJYXbE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Oct 2019 19:31:04 -0400
Received: by mail-il1-f195.google.com with SMTP id p8so3277582ilp.2
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 16:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=lR5/5+r8bCmhCIY6LJthT487CIpdBcb0dtxi4yHzNfo=;
        b=U/8ANm9ZjTcvnGCy0ASTe45RLMWWXvVGkN/QrSOs+PzJIGkftolprsdRaRykpvpKFC
         5cfDoSA2aGycaGrQ5gyL/wmmkY41E0CLqZ/kN3aHzFGjv+/+pGuwkMcuPFyuQhHelbmt
         GvcjTVl0h3fSMQW57MfYY9SyrBWSz39avXHo4AYqVwcNPPcbkW4KgwyP8Qdws5HlIVNq
         cvZRcarlZOdTTH2YVIWluME8foAufixQH9SSG3WYEX/QD9pLjoO3ttCOY9pNcj1WbXZ5
         DFXRCbZFd0kqTDJsvNlurcq4uSy8Ui0T00ooqnrVxkTMN9sr3B5LilYfEu2cR13WZmog
         hxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=lR5/5+r8bCmhCIY6LJthT487CIpdBcb0dtxi4yHzNfo=;
        b=hXk2A4mtD5ZMGO5bu2D1HFIqGg7SUvD6r6mcWH7tOoNr6HttQdTilbcKATL1vhvdDR
         41XouZZjmH0Fr+Gk/rWUE0TBeaWcIkIbzWmnooYGvnlXxelfKoXWa/8beDrpUQ/l8+QI
         tWxk+zLXOa1GyArfWqLPnWQfGfmXvZtZKzoefXdpyD00lEI63G/xWcd+wUYAkI0HtOkC
         TDzD/IeIZJMFZriqR1jcCnS5GPx0xAZyxbvHA73jHF6shWct4jt1MqkWUM6gj59PNP6A
         pu5HPFlPmxs5LJ25bJjCwRI+3JAeWuUmGPANeEaBSREgNDjgS5/j29lY7BBZAEhKewXr
         k37g==
X-Gm-Message-State: APjAAAW/U5L7NYKbGzErYK3jZM8sfHklKPvpbAfVpZwsBGxHsaia4XPB
        Ina2DdpohZ7SaZayEey/CJeCAA==
X-Google-Smtp-Source: APXvYqxCRkC7bsr4R1MRLbbtPijuvmtcRENpyOsfBauaT1t9TfBCyyNa3dtelKHzUngB/GzRY3j/mA==
X-Received: by 2002:a92:c80b:: with SMTP id v11mr6695297iln.62.1572046262026;
        Fri, 25 Oct 2019 16:31:02 -0700 (PDT)
Received: from localhost ([64.62.168.194])
        by smtp.gmail.com with ESMTPSA id n3sm557223ilm.8.2019.10.25.16.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 16:31:01 -0700 (PDT)
Date:   Fri, 25 Oct 2019 16:30:59 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Anup Patel <anup@brainfault.org>
cc:     Palmer Dabbelt <palmer@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 01/22] RISC-V: Add bitmap reprensenting ISA features
 common across CPUs
In-Reply-To: <CAAhSdy3xV0UjDKUgHoKbyoeV5kaC9rVSy=qoBpF=XrrbT=W=-Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.9999.1910251629540.12828@viisi.sifive.com>
References: <20191016160649.24622-1-anup.patel@wdc.com> <20191016160649.24622-2-anup.patel@wdc.com> <CAAhSdy3xV0UjDKUgHoKbyoeV5kaC9rVSy=qoBpF=XrrbT=W=-Q@mail.gmail.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 17 Oct 2019, Anup Patel wrote:

> Can you consider this patch for Linux-5.4-rcX ??

Unless another user of the riscv_isa bitmap comes along, it seems best 
merged along with its user: the RISC-V KVM patches.


- Paul
