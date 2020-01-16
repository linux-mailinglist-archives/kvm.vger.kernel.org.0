Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2873A13F9FF
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 20:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732675AbgAPTvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 14:51:44 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46273 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730733AbgAPTvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 14:51:44 -0500
Received: by mail-pl1-f195.google.com with SMTP id y8so8774262pll.13
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 11:51:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:subject:cc:to:in-reply-to:references:message-id
         :mime-version:content-transfer-encoding;
        bh=qf6k1mRWZ7KwTkkCFJAyQkfTj6/97JpvLDoqeNnev6c=;
        b=S4aGPwGPl1Rbla4m/WDMtD7CPBAk52j4NBXF8mSO7qPEkVuiI0APEsJWRwdpZnmFvv
         FCY3h8N9t50zhrlYIbe+N0/L/myieuVC0DH467yS5FX5vKsXyGF0L2KJeQJ1lHG3mz4g
         wacxlAUZp9mUQFwekpvkMn9QcBISPXYQ4u5oCkWQ78YaVSnKXhq/ckir7Ddk8U331v7g
         m0G/I2qvm07woki1TsltkSB+6gHPy1Hi2pUvj7XKsqF6EBPMudci3yUVv6vvKO54lpTF
         TxpkjaUZAlK7sk2gwE4hSCDOUr9KOVXLl4LwxD03sJK381pZbvoeTAcL/7XxyiZdbmkZ
         Wu+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:cc:to:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=qf6k1mRWZ7KwTkkCFJAyQkfTj6/97JpvLDoqeNnev6c=;
        b=fTZYmp0voz16dxiXOMQ5IVK/Tiw7WjlYG4qeNj8oJk/UO7B7KjIy4QfmOEK73ib7ME
         7Knso9dU8ub4pwHHRDSD8WXlSJllSMU9pQFG4Qaa0Nb8zvTyE3PmvaDFYsDnS3n+yYdo
         YnIegkuNjAxHSMmIBSGGMwL1FUk2raBW7KaOSZlR0jHEK4DUs30tLJ2TV4crjtyyt1RP
         gsN5DuQDGHzFcIIpIpN8fC6K/G37lwRPFM4XIrH0dEDY/w/U9lujAqkSijKnXGRzdWmY
         +Z4pVwOXJuCjRXvuYax9/jqfx9MkSS+5YZDt9VJiykGfC4eWMdaF4axcgNMZs5E1D9iH
         2ZJA==
X-Gm-Message-State: APjAAAWMx6eaBKm4JVqbMj0mFkj/dVBIX3EDAdAYhA0bppBnl5XKLuh5
        UnNqq8g1RJhNlAdqzaZR7Y6+Rg==
X-Google-Smtp-Source: APXvYqzjH+zz5db06WQAC40i42blwG3HjNY/9zFTM5H71SxsnhtPCDksK1oUk+JWxjIDfFySumwzwQ==
X-Received: by 2002:a17:902:12d:: with SMTP id 42mr33267260plb.246.1579204302780;
        Thu, 16 Jan 2020 11:51:42 -0800 (PST)
Received: from localhost ([2620:0:1000:2514:7f69:cd98:a2a2:a03d])
        by smtp.gmail.com with ESMTPSA id k21sm25398790pgt.22.2020.01.16.11.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 11:51:42 -0800 (PST)
Date:   Thu, 16 Jan 2020 11:51:42 -0800 (PST)
X-Google-Original-Date: Thu, 16 Jan 2020 10:59:03 PST (-0800)
From:   Palmer Dabbelt <palmerdabbelt@google.com>
X-Google-Original-From: Palmer Dabbelt <palmer@dabbelt.com>
Subject:     Re: [PATCH v10 03/19] RISC-V: Add hypervisor extension related CSR defines
CC:     Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
        pbonzini@redhat.com, rkrcmar@redhat.com, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>, anup@brainfault.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anup Patel <Anup.Patel@wdc.com>
To:     Anup Patel <Anup.Patel@wdc.com>
In-Reply-To: <20191223113443.68969-4-anup.patel@wdc.com>
References: <20191223113443.68969-4-anup.patel@wdc.com>
  <20191223113443.68969-1-anup.patel@wdc.com>
Message-ID: <mhng-1c0b8288-1b2b-4172-b224-5277a9d3fcaa@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Dec 2019 03:35:33 PST (-0800), Anup Patel wrote:
> This patch extends asm/csr.h by adding RISC-V hypervisor extension
> related defines.
>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Reviewed-by: Alexander Graf <graf@amazon.com>
> ---
>  arch/riscv/include/asm/csr.h | 78 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 75 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 0a62d2d68455..afb6733475c2 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -30,6 +30,8 @@
>  #define SR_XS_CLEAN	_AC(0x00010000, UL)
>  #define SR_XS_DIRTY	_AC(0x00018000, UL)
>  
> +#define SR_MXR		_AC(0x00080000, UL)
> +
>  #ifndef CONFIG_64BIT
>  #define SR_SD		_AC(0x80000000, UL) /* FS/XS dirty */
>  #else
> @@ -51,26 +53,74 @@
>  #define CAUSE_IRQ_FLAG		(_AC(1, UL) << (__riscv_xlen - 1))
>  
>  /* Interrupt causes (minus the high bit) */
> -#define IRQ_U_SOFT		0
>  #define IRQ_S_SOFT		1
> +#define IRQ_VS_SOFT		2

Again: please don't mix up cleanups with the KVM port.  It's reasonable to
remove the N extension cruft as it's still in draft and we probably won't
implement it in Linux, but that shouldn't be mixed up with the KVM
implementation.

>  #define IRQ_M_SOFT		3
> -#define IRQ_U_TIMER		4
>  #define IRQ_S_TIMER		5
> +#define IRQ_VS_TIMER		6
>  #define IRQ_M_TIMER		7
> -#define IRQ_U_EXT		8
>  #define IRQ_S_EXT		9
> +#define IRQ_VS_EXT		10
>  #define IRQ_M_EXT		11
>  
>  /* Exception causes */
>  #define EXC_INST_MISALIGNED	0
>  #define EXC_INST_ACCESS		1
> +#define EXC_INST_ILLEGAL	2
>  #define EXC_BREAKPOINT		3
>  #define EXC_LOAD_ACCESS		5
>  #define EXC_STORE_ACCESS	7
>  #define EXC_SYSCALL		8
> +#define EXC_HYPERVISOR_SYSCALL	9
> +#define EXC_SUPERVISOR_SYSCALL	10
>  #define EXC_INST_PAGE_FAULT	12
>  #define EXC_LOAD_PAGE_FAULT	13
>  #define EXC_STORE_PAGE_FAULT	15
> +#define EXC_INST_GUEST_PAGE_FAULT	20
> +#define EXC_LOAD_GUEST_PAGE_FAULT	21
> +#define EXC_STORE_GUEST_PAGE_FAULT	23
> +
> +/* HSTATUS flags */
> +#define HSTATUS_VTSR		_AC(0x00400000, UL)
> +#define HSTATUS_VTVM		_AC(0x00100000, UL)
> +#define HSTATUS_SP2V		_AC(0x00000200, UL)
> +#define HSTATUS_SP2P		_AC(0x00000100, UL)
> +#define HSTATUS_SPV		_AC(0x00000080, UL)
> +#define HSTATUS_SPRV		_AC(0x00000001, UL)
> +
> +/* HGATP flags */
> +#define HGATP_MODE_OFF		_AC(0, UL)
> +#define HGATP_MODE_SV32X4	_AC(1, UL)
> +#define HGATP_MODE_SV39X4	_AC(8, UL)
> +#define HGATP_MODE_SV48X4	_AC(9, UL)
> +
> +#define HGATP32_MODE_SHIFT	31
> +#define HGATP32_VMID_SHIFT	22
> +#define HGATP32_VMID_MASK	_AC(0x1FC00000, UL)
> +#define HGATP32_PPN		_AC(0x003FFFFF, UL)
> +
> +#define HGATP64_MODE_SHIFT	60
> +#define HGATP64_VMID_SHIFT	44
> +#define HGATP64_VMID_MASK	_AC(0x03FFF00000000000, UL)
> +#define HGATP64_PPN		_AC(0x00000FFFFFFFFFFF, UL)
> +
> +#ifdef CONFIG_64BIT
> +#define HGATP_PPN		HGATP64_PPN
> +#define HGATP_VMID_SHIFT	HGATP64_VMID_SHIFT
> +#define HGATP_VMID_MASK		HGATP64_VMID_MASK
> +#define HGATP_MODE		(HGATP_MODE_SV39X4 << HGATP64_MODE_SHIFT)
> +#else
> +#define HGATP_PPN		HGATP32_PPN
> +#define HGATP_VMID_SHIFT	HGATP32_VMID_SHIFT
> +#define HGATP_VMID_MASK		HGATP32_VMID_MASK
> +#define HGATP_MODE		(HGATP_MODE_SV32X4 << HGATP32_MODE_SHIFT)
> +#endif
> +
> +/* VSIP & HIP relation */
> +#define VSIP_TO_HIP_SHIFT	(IRQ_VS_SOFT - IRQ_S_SOFT)
> +#define VSIP_VALID_MASK		((_AC(1, UL) << IRQ_S_SOFT) | \
> +				 (_AC(1, UL) << IRQ_S_TIMER) | \
> +				 (_AC(1, UL) << IRQ_S_EXT))
>  
>  /* symbolic CSR names: */
>  #define CSR_CYCLE		0xc00
> @@ -91,6 +141,28 @@
>  #define CSR_SIP			0x144
>  #define CSR_SATP		0x180
>  
> +#define CSR_VSSTATUS		0x200
> +#define CSR_VSIE		0x204
> +#define CSR_VSTVEC		0x205
> +#define CSR_VSSCRATCH		0x240
> +#define CSR_VSEPC		0x241
> +#define CSR_VSCAUSE		0x242
> +#define CSR_VSTVAL		0x243
> +#define CSR_VSIP		0x244
> +#define CSR_VSATP		0x280
> +
> +#define CSR_HSTATUS		0x600
> +#define CSR_HEDELEG		0x602
> +#define CSR_HIDELEG		0x603
> +#define CSR_HIE			0x604
> +#define CSR_HTIMEDELTA		0x605
> +#define CSR_HTIMEDELTAH		0x615
> +#define CSR_HCOUNTERNEN		0x606
> +#define CSR_HTVAL		0x643
> +#define CSR_HIP			0x644
> +#define CSR_HTINST		0x64a
> +#define CSR_HGATP		0x680
> +
>  #define CSR_MSTATUS		0x300
>  #define CSR_MISA		0x301
>  #define CSR_MIE			0x304
> -- 
> 2.17.1
