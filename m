Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17A7D7EEAE
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 10:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404055AbfHBIRr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 04:17:47 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36410 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727949AbfHBIRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 04:17:47 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so76303574wrs.3
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 01:17:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=APOXhup+sZGXS5d0UC7uGeTiWB/G8v81K64OFOYtTQY=;
        b=UBjBignOublgVPBWUC/zK3kpget1FBb+Asumf0hqAM5134bQUOFDAQ/gBP1MW5pdIc
         FK1RM1S3Bey08e37Z2Ngn0ZZdPLd3FmmJQJz8c0UFlD1wrlMve9taXs7E/KJpoubemrB
         evh1oWsffSGJEjOhs30DUS6+VtUjj11o73l15rOs/nG9R4ZPmAz0Yt3kqU+7U6CjPkUe
         B8V1GDxC6GfKRit8HE+u33VcVwlaQG7iU1501RluI4S2m56FsDu5SZXQPDunYCR/u/UV
         hk33oBr4TfkXiHIDFaFvRL2qYJGAOzWETXPoM1nAgF58quuG/XFvYKRBJx1K9Mn5+aBz
         AYUw==
X-Gm-Message-State: APjAAAU+pHocsRDSkjq8ZktV3ppgCazOV24AtkgaT6fcHAILLwWRNI10
        LMzH3ht5/xKktk5EmTKSsURXWQ==
X-Google-Smtp-Source: APXvYqxouFvTCxPN5ary3LSNHZng7Fu6r6547Mi/qZeNJXWg0W3zH8U/xLY5N3dAloNhdOrtFxV+kg==
X-Received: by 2002:a5d:4101:: with SMTP id l1mr7547509wrp.202.1564733864909;
        Fri, 02 Aug 2019 01:17:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id p18sm75207312wrm.16.2019.08.02.01.17.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 01:17:44 -0700 (PDT)
Subject: Re: [RFC PATCH v2 06/19] RISC-V: KVM: Implement VCPU interrupts and
 requests handling
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190802074620.115029-1-anup.patel@wdc.com>
 <20190802074620.115029-7-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <98eaa917-8270-ecdc-2420-491ed1c903d8@redhat.com>
Date:   Fri, 2 Aug 2019 10:17:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802074620.115029-7-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/19 09:47, Anup Patel wrote:
> +	/* VCPU interrupts */
> +	unsigned long irqs_pending;
> +	unsigned long irqs_pending_mask;
> +

This deserves a comment on the locking policy (none for producer,
vcpu_lock for consumers).

Paolo
