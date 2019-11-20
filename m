Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142C61035C7
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 09:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfKTIEQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 03:04:16 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:34127 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727227AbfKTIEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 03:04:15 -0500
Received: by mail-io1-f67.google.com with SMTP id q83so26667542iod.1
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 00:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=BacJ7EBR9ytS2/6OwHcGzjIg710Zu5B5M5aCR72bJWA=;
        b=VO8JDuiYDFx9cSL5SqJK3STzGgAjyrHydkFR2rL2wLLXNbBFnDHTepn7fMtUJpbe4E
         obnzLYzJIX2DCUk7C9YHLXU+G/1wcpLygGrJzo4jNx1u9lQjIztdjytuGSy8eYhTw7xO
         FJAdNaw27IoeGn1j3JYhZNcTVl1HUxjR62WpPXz9x2KYxe+Wh7ujofcnk4UlKbm9EThJ
         4ltquqg9ml2N8qlVXt26KMAokZAyaFR0pjwaQmFfZC5vVWS5bnQ/9I+2WYKOL5KpV6vj
         L44Q1Om9Kbq0JPnB6E0RsIhuJOl9iQ+syl0zVUoU/MXq4vVI6t+72g1afJuZlmB060iZ
         a+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=BacJ7EBR9ytS2/6OwHcGzjIg710Zu5B5M5aCR72bJWA=;
        b=d2Xnc/RxQ6OtdFmHnHGgZb0cflPibbrmHyNrnxTB2Co1HeB08yPwDXV3hgZD8yHQ80
         QAUOJBuc4ZH8j7hXE7Flekz8Nm/e1RYd82FCmI08hb4BaQDZRvdP2431r32JIzZfh4jH
         Okb5jfgjCWDtbLHyqMOCRl9Z69lLS4cuEY2O5v6rXthtL4VuQo23qFLTKlrI8dXodVf8
         nZdEq3QkJRu8LB6mQc2c+wZtd4Sx6IXu93aUCUn+MLKYDG3uk/yFJ3Wk7y+NPIdAU4EY
         0A9yxU0xemfP5VFXZ8LBAzvBdJlCsF+kRj13K6BlQcsxUmrw0gs39u1LSN0xTUJoXI27
         bfPg==
X-Gm-Message-State: APjAAAWWr8YHcLJzsj0kdbMAIaiKp4ldVUvAaTJYQ8l0ajatJByHcye4
        HDlKIMcesJIiRsxSacQpWmWcPg==
X-Google-Smtp-Source: APXvYqy+717NLJlVd20jJMYLKR/1De7mJqNFF+/oYOiwoN3AGBAq1ytMXqic/gdugH11qYE0ztUcQg==
X-Received: by 2002:a5e:a70e:: with SMTP id b14mr1088130iod.166.1574237054759;
        Wed, 20 Nov 2019 00:04:14 -0800 (PST)
Received: from localhost (67-0-26-4.albq.qwest.net. [67.0.26.4])
        by smtp.gmail.com with ESMTPSA id a11sm6274182ilb.72.2019.11.20.00.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 00:04:14 -0800 (PST)
Date:   Wed, 20 Nov 2019 00:04:13 -0800 (PST)
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
Subject: Re: [PATCH v9 03/22] RISC-V: Add initial skeletal KVM support
In-Reply-To: <20191016160649.24622-4-anup.patel@wdc.com>
Message-ID: <alpine.DEB.2.21.9999.1911200002310.490@viisi.sifive.com>
References: <20191016160649.24622-1-anup.patel@wdc.com> <20191016160649.24622-4-anup.patel@wdc.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Wed, 16 Oct 2019, Anup Patel wrote:

> This patch adds initial skeletal KVM RISC-V support which has:
> 1. A simple implementation of arch specific VM functions
>    except kvm_vm_ioctl_get_dirty_log() which will implemeted
>    in-future as part of stage2 page loging.
> 2. Stubs of required arch specific VCPU functions except
>    kvm_arch_vcpu_ioctl_run() which is semi-complete and
>    extended by subsequent patches.
> 3. Stubs for required arch specific stage2 MMU functions.
> 
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>

Olof's autobuilder found an issue with this patch (below)

> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> new file mode 100644
> index 000000000000..9459709656be
> --- /dev/null
> +++ b/arch/riscv/include/asm/kvm_host.h
> @@ -0,0 +1,81 @@
> +/* SPDX-License-Identifier: GPL-2.0 */

This should be

/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */

to match the license used in the kvm.h files in other architectures.


- Paul
