Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850CF688AEF
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 00:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbjBBXjm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 18:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbjBBXjb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 18:39:31 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8847B65F34
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 15:39:24 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so3342404pjb.5
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 15:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=to:from:cc:content-transfer-encoding:mime-version:date:message-id
         :subject:references:in-reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vesawjPB9AOcMrrmpD3ev47+uO/NqYyhZGhOCb5pWQw=;
        b=V3WpKttJoNgaLv9nu6Gk1aeQLF3+FvlkQ4QhupM3QzLNkvuC7XH4Z3b343ZSmfKmRH
         Z6F0owS6H2Ej3uu9ggM1xqr1CwjFrZ+1VjHMSZWDJk90LTpr0t6iJ23il4BP0ixtJ1IA
         8ZxXF7qcFGt91DZyWLi7/dXXut6M4vMrfCs/poLb4HDqn3LmW+wLxjvxiZyT2PedXMH+
         MSbTUmo24ar4Xa19xDvR5WMS3tXEs4I/4HGkf+XSgYldYfN3Vdwl9ze46qp1GAhGa5P4
         AElgm4BJgJCSUmXRZzyK37S+7ThWVWaMfRj7S9dhE0YAwsWulY5uSYizi1KJg5xo3jrB
         RWWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:cc:content-transfer-encoding:mime-version:date:message-id
         :subject:references:in-reply-to:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vesawjPB9AOcMrrmpD3ev47+uO/NqYyhZGhOCb5pWQw=;
        b=MZLRxzHpTZ7e5Px45NP+ZUPD1euCcUel7DEeqBawvy6nPlxBV7XI4doeZvKDxpAU0k
         Y7AX24DrSipRNschtkMsLRKVnjo0Bt8ebJwQ07jN783GpFpD31eH/tWZo0oTT77JjJ5S
         jOJMiieor/9NZAbHuZ2UnGnfy7TbaMvQRrUf2dtIEkXdV6EGVuizY7HrMJ0hIawa6E26
         8NM5gRb5++3hER5SVIG4FYFoxaNGWRJErUg278h6jQ4erHe1XBYEjJnWcdEwtWcnRrZc
         B7TGE09vB2lr/nYcJrLi+k7XS9pJOIDcpZ5BbHMl1qt7Jn85ovweJF8K6StcrTofwRX4
         DHbQ==
X-Gm-Message-State: AO0yUKXw7yc2VG9jgkbmAs13paXyrELb/s11ggFhzbUKW9FbTlQbP0bP
        36frczFykNCOuPE1eNR+uNZEGA==
X-Google-Smtp-Source: AK7set+qppWzyeAwtENJSI1sSfYNwgvgOm0IjkdrugKKP1o2J+2Gq0evSvAPlUC7nZUNmRLbxgHP5g==
X-Received: by 2002:a05:6a20:3d92:b0:bb:cf2f:3b09 with SMTP id s18-20020a056a203d9200b000bbcf2f3b09mr10417561pzi.51.1675381163978;
        Thu, 02 Feb 2023 15:39:23 -0800 (PST)
Received: from localhost ([135.180.226.51])
        by smtp.gmail.com with ESMTPSA id e4-20020a170902ed8400b00192a04bc620sm202452plj.295.2023.02.02.15.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 15:39:23 -0800 (PST)
In-Reply-To: <20230128172856.3814-1-jszhang@kernel.org>
References: <20230128172856.3814-1-jszhang@kernel.org>
Subject: Re: [PATCH v5 00/13] riscv: improve boot time isa extensions handling
Message-Id: <167538114995.11760.15499865647132420589.b4-ty@rivosinc.com>
Date:   Thu, 02 Feb 2023 15:39:09 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-e660e
Cc:     kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     Heiko Stuebner <heiko@sntech.de>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Anup Patel <anup@brainfault.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        Conor Dooley <conor.dooley@microchip.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 29 Jan 2023 01:28:43 +0800, Jisheng Zhang wrote:
> Generally, riscv ISA extensions are fixed for any specific hardware
> platform, so a hart's features won't change after booting, this
> chacteristic makes it straightforward to use a static branch to check
> a specific ISA extension is supported or not to optimize performance.
> 
> However, some ISA extensions such as SVPBMT and ZICBOM are handled
> via. the alternative sequences.
> 
> [...]

Applied, thanks!

[01/13] riscv: move riscv_noncoherent_supported() out of ZICBOM probe
        https://git.kernel.org/palmer/c/abcc445acdbe
[02/13] riscv: cpufeature: detect RISCV_ALTERNATIVES_EARLY_BOOT earlier
        https://git.kernel.org/palmer/c/191b27c7c0e8
[03/13] riscv: hwcap: make ISA extension ids can be used in asm
        https://git.kernel.org/palmer/c/d8a3d8a75206
[04/13] riscv: cpufeature: extend riscv_cpufeature_patch_func to all ISA extensions
        https://git.kernel.org/palmer/c/4bf8860760d9
[05/13] riscv: introduce riscv_has_extension_[un]likely()
        https://git.kernel.org/palmer/c/bdda5d554e43
[06/13] riscv: fpu: switch has_fpu() to riscv_has_extension_likely()
        https://git.kernel.org/palmer/c/702e64550b12
[07/13] riscv: module: move find_section to module.h
        https://git.kernel.org/palmer/c/e0c267e03b0c
[08/13] riscv: module: Add ADD16 and SUB16 rela types
        https://git.kernel.org/palmer/c/1bc400ffb52b
[09/13] riscv: switch to relative alternative entries
        https://git.kernel.org/palmer/c/8d23e94a4433
[10/13] riscv: alternative: patch alternatives in the vDSO
        https://git.kernel.org/palmer/c/cabfd146b371
[11/13] riscv: cpu_relax: switch to riscv_has_extension_likely()
        https://git.kernel.org/palmer/c/95bc69a47be2
[12/13] riscv: KVM: Switch has_svinval() to riscv_has_extension_unlikely()
        https://git.kernel.org/palmer/c/e8ad17d2b5f3
[13/13] riscv: remove riscv_isa_ext_keys[] array and related usage
        https://git.kernel.org/palmer/c/03966594e117

Best regards,
-- 
Palmer Dabbelt <palmer@rivosinc.com>
