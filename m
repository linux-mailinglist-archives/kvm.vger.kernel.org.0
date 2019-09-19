Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEF48B799D
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 14:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390367AbfISMhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Sep 2019 08:37:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39812 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388184AbfISMhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Sep 2019 08:37:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id r3so2923863wrj.6
        for <kvm@vger.kernel.org>; Thu, 19 Sep 2019 05:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=Vmayzz5+9ezfsk62AunM7OhcuY1qbK/2my5of3osq2Q=;
        b=CPHzlLRpy1PttVfVK/tH5zuY0rcu5yRxCiJbqcJKiYlnzZXjMsZi9zST57LCLED/D+
         RG6u7EiJSBX6YS2c+J2cfjL3+R9aiaw83XBaLMWlLITxRCATd2tPmtBUtirokGJfA+wh
         tLvC9ZVf5XtA5QU/GxpW4gUZMjUsH0SVrI2BfBO2W0AVE26CknDVIhQ3scsfUVZ6Vuqp
         i7whe6a8HxL52j44c5FBoUtntCnpvvAdRumpS8tg9uyKGR8k30X02mG2RBhMMXzLzj8j
         d2oyyoBmC813K/tvFhuvjcYzMwQImmdEm75oMVLYPpG2hTPqTYl0RfwgqRJrO4t37jQZ
         bhgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=Vmayzz5+9ezfsk62AunM7OhcuY1qbK/2my5of3osq2Q=;
        b=kU36cQcM7GDNH12GvGmBhy+eCfjHN9PEzs5l8RtAsE9ItL4ZvCG+EWGlxXOyMgykVu
         aa+2+pGU2fuPfMndTNSDtdEuq4uS/ctfRdBFpZfdGTWJTQaFZKPTVBvG7t2gV243Xgts
         5QUba7i6wns+K3qj+wkuN3bxbVsjZSY2n3UG/OBFkyBR/XQT6omNdf5Bs+jSDT5ugvI9
         Lswx4Cz86PPM1KwxMPOxLhIx30cK8Q8t4/lEkgkBf/OXNsEfvIr1XwRfoWqQtPpYT650
         Q4Opjpcl2V4mUyi3RojmrAYR5s//mkcrvUu+SLejvKIJNWOKtfk3BYW5tHRQ3W3In1w6
         aBhw==
X-Gm-Message-State: APjAAAU80daWB29z3uD6Bwd4FrtuZvE+1IY0b/UmuW9b+Bx/WLLkUHcO
        inuF5HgKyiOxqhlVr1T8A4SBOw==
X-Google-Smtp-Source: APXvYqy5AC/9imlDM23EMdY0qHqq/72VZqirSAcl6mbLggKWnGuZppcMG1fhJLwGcSfA4ItZqkmh2A==
X-Received: by 2002:a5d:4444:: with SMTP id x4mr7022305wrr.11.1568896657158;
        Thu, 19 Sep 2019 05:37:37 -0700 (PDT)
Received: from localhost ([109.190.253.11])
        by smtp.gmail.com with ESMTPSA id z3sm4117140wma.29.2019.09.19.05.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 05:37:36 -0700 (PDT)
Date:   Thu, 19 Sep 2019 05:37:34 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Anup Patel <Anup.Patel@wdc.com>
cc:     Palmer Dabbelt <palmer@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 01/21] KVM: RISC-V: Add KVM_REG_RISCV for ONE_REG
 interface
In-Reply-To: <20190904161245.111924-2-anup.patel@wdc.com>
Message-ID: <alpine.DEB.2.21.9999.1909190537250.12151@viisi.sifive.com>
References: <20190904161245.111924-1-anup.patel@wdc.com> <20190904161245.111924-2-anup.patel@wdc.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 4 Sep 2019, Anup Patel wrote:

> We will be using ONE_REG interface accessing VCPU registers from
> user-space hence we add KVM_REG_RISCV for RISC-V VCPU registers.
> 
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>

Thanks, queued for v5.4-rc.


- Paul
