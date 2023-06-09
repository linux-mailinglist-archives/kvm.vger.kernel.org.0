Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A997A729D2F
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 16:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241351AbjFIOpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jun 2023 10:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbjFIOpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jun 2023 10:45:08 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8B0E43
        for <kvm@vger.kernel.org>; Fri,  9 Jun 2023 07:45:06 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6513e7e5d44so1544141b3a.0
        for <kvm@vger.kernel.org>; Fri, 09 Jun 2023 07:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1686321905; x=1688913905;
        h=to:from:cc:content-transfer-encoding:mime-version:date:message-id
         :subject:references:in-reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TcBA5FIGp9MI+7Ji9YDXcRmXDhCs+5Q0MHSf56Zwu+A=;
        b=MV5QspRGH8Psh3E4xXnDNyfNHakaCiKm9bRLd+ZFNuLVrB0gEr+8ZEem+xJD5Ph4bc
         2hmiQEUc3bnBS5Pa8n2MwMLLYpcIt1+UttHiEWgqNw6tpRLjJW76hVkoiduvkDqJacdc
         fxe1Po2uko+3z+B9XlfLTkdA7YlmGXkibxU8mmT+oeHxM7ePZo0bgQ7hDBcblUBD4Heu
         mgmegmbP34e/EbpOxrYVXEnm3J4noBbamyw+X1JPTKX85ehRNWRnmA8gz6Iu6yo3zqKR
         YT85jW2G0s4MW3YpKHfUTs8CFYaf6daqpNq9VKCdJrlgbWMjDNBoCH54iJl2gzvwmIuy
         JOXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686321905; x=1688913905;
        h=to:from:cc:content-transfer-encoding:mime-version:date:message-id
         :subject:references:in-reply-to:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TcBA5FIGp9MI+7Ji9YDXcRmXDhCs+5Q0MHSf56Zwu+A=;
        b=S/2pn8iAmlks9yOSrgMI9TJfBWbVwislDoyiGu60bY/MthtVBgQnNUoLNm0xCaAe+p
         sANN6b/JxcbhBTlv1wRWiAeWtaraT6VuYjnFgvH5BQpRniLYsHo9+oCkCsoyc/WrDrVn
         vyHA+i8/gqyDAm2NFrLIuI1VfJUxcmKAP3U1FV1I4ww7imcNdCSE76+WtjZaUF8PAV4D
         0qQdhg2pdzGZdabaPtgtDOBfUv7DpHYugaVsFdSBnVcDXRhqUN9cbK55ekcPiGbJiJFA
         boo8eBSHyDRA/k5UZ72FNWJgLdqDycoETrT95QluyhWU/iKgWlO8BGuPIxBXqrHCVNoo
         z8ng==
X-Gm-Message-State: AC+VfDyNGanZ6B6LUPxUFJpvapeIdDOnZchH4Q7My3AFyuXMMvbos85f
        JCoc7ZhPhMQGMNHPYokKQKyLHw==
X-Google-Smtp-Source: ACHHUZ7kgx1TDVZTXASPbO0+eulse3EaOzpwrIoGD8RehZplpZ5JIJgzOjAmmE3ORQZq5N1++sBxsA==
X-Received: by 2002:a05:6a20:1443:b0:10d:d42:f6bc with SMTP id a3-20020a056a20144300b0010d0d42f6bcmr1409117pzi.41.1686321905617;
        Fri, 09 Jun 2023 07:45:05 -0700 (PDT)
Received: from localhost ([135.180.227.0])
        by smtp.gmail.com with ESMTPSA id m26-20020aa78a1a000000b0065c8c5b3a7dsm2888618pfa.13.2023.06.09.07.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 07:45:05 -0700 (PDT)
In-Reply-To: <20230605110724.21391-1-andy.chiu@sifive.com>
References: <20230605110724.21391-1-andy.chiu@sifive.com>
Subject: Re: [PATCH -next v21 00/27] riscv: Add vector ISA support
Message-Id: <168631921599.10550.825478104843856670.b4-ty@rivosinc.com>
Date:   Fri, 09 Jun 2023 07:00:15 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-901c5
Cc:     Vineet Gupta <vineetg@rivosinc.com>, greentime.hu@sifive.com,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Guo Ren <guoren@kernel.org>
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:     linux-riscv@lists.infradead.org,
        Palmer Dabbelt <palmer@dabbelt.com>, anup@brainfault.org,
        atishp@atishpatra.org, kvm-riscv@lists.infradead.org,
        kvm@vger.kernel.org, Andy Chiu <andy.chiu@sifive.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On Mon, 05 Jun 2023 11:06:57 +0000, Andy Chiu wrote:
> This is the v21 patch series for adding Vector extension support in
> Linux. Please refer to [1] for the introduction of the patchset. The
> v21 patch series was aimed to solve build issues from v19, provide usage
> guideline for the prctl interface, and address review comments on v20.
> 
> Thank every one who has been reviewing, suggesting on the topic. Hope
> this get a step closer to the final merge.
> 
> [...]

Applied, thanks!

[01/27] riscv: Rename __switch_to_aux() -> fpu
        https://git.kernel.org/palmer/c/419d5d38ac5d
[02/27] riscv: Extending cpufeature.c to detect V-extension
        https://git.kernel.org/palmer/c/dc6667a4e7e3
[03/27] riscv: hwprobe: Add support for probing V in RISCV_HWPROBE_KEY_IMA_EXT_0
        https://git.kernel.org/palmer/c/162e4df137c1
[04/27] riscv: Add new csr defines related to vector extension
        https://git.kernel.org/palmer/c/b5665d2a9432
[05/27] riscv: Clear vector regfile on bootup
        https://git.kernel.org/palmer/c/6b533828726a
[06/27] riscv: Disable Vector Instructions for kernel itself
        https://git.kernel.org/palmer/c/74abe5a39d3a
[07/27] riscv: Introduce Vector enable/disable helpers
        https://git.kernel.org/palmer/c/0a3381a01dcc
[08/27] riscv: Introduce riscv_v_vsize to record size of Vector context
        https://git.kernel.org/palmer/c/7017858eb2d7
[09/27] riscv: Introduce struct/helpers to save/restore per-task Vector state
        https://git.kernel.org/palmer/c/03c3fcd9941a
[10/27] riscv: Add task switch support for vector
        https://git.kernel.org/palmer/c/3a2df6323def
[11/27] riscv: Allocate user's vector context in the first-use trap
        https://git.kernel.org/palmer/c/cd054837243b
[12/27] riscv: Add ptrace vector support
        https://git.kernel.org/palmer/c/0c59922c769a
[13/27] riscv: signal: check fp-reserved words unconditionally
        https://git.kernel.org/palmer/c/a45cedaa1ac0
[14/27] riscv: signal: Add sigcontext save/restore for vector
        https://git.kernel.org/palmer/c/8ee0b41898fa
[15/27] riscv: signal: Report signal frame size to userspace via auxv
        https://git.kernel.org/palmer/c/e92f469b0771
[16/27] riscv: signal: validate altstack to reflect Vector
        https://git.kernel.org/palmer/c/76e22fdc2c26
[17/27] riscv: prevent stack corruption by reserving task_pt_regs(p) early
        https://git.kernel.org/palmer/c/c7cdd96eca28
[18/27] riscv: kvm: Add V extension to KVM ISA
        https://git.kernel.org/palmer/c/bf78f1ea6e51
[19/27] riscv: KVM: Add vector lazy save/restore support
        https://git.kernel.org/palmer/c/0f4b82579716
[20/27] riscv: hwcap: change ELF_HWCAP to a function
        https://git.kernel.org/palmer/c/50724efcb370
[21/27] riscv: Add prctl controls for userspace vector management
        https://git.kernel.org/palmer/c/1fd96a3e9d5d
[22/27] riscv: Add sysctl to set the default vector rule for new processes
        https://git.kernel.org/palmer/c/7ca7a7b9b635
[23/27] riscv: detect assembler support for .option arch
        https://git.kernel.org/palmer/c/e4bb020f3dbb
[24/27] riscv: Enable Vector code to be built
        https://git.kernel.org/palmer/c/fa8e7cce55da
[25/27] riscv: Add documentation for Vector
        https://git.kernel.org/palmer/c/04a4722eeede
[26/27] selftests: Test RISC-V Vector prctl interface
        https://git.kernel.org/palmer/c/7cf6198ce22d
[27/27] selftests: add .gitignore file for RISC-V hwprobe
        https://git.kernel.org/palmer/c/1e72695137ef

Best regards,
-- 
Palmer Dabbelt <palmer@rivosinc.com>

