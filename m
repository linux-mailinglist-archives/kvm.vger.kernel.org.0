Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B556E6A7274
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 19:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjCASAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Mar 2023 13:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjCASAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Mar 2023 13:00:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BBE36FC0
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 10:00:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBB56B810C5
        for <kvm@vger.kernel.org>; Wed,  1 Mar 2023 18:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE28C433EF;
        Wed,  1 Mar 2023 18:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677693603;
        bh=XsdWK/o8sVcrZ/ON/D4meAMg/40ljCG+Goz+CvS6/Gs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PjJhSBWEzvoH6OHaFUixr0zTxlM9f/ydaIrkZlxKb/GhHv3QeCEJ5s4mYG7DD0tg7
         uge2UVTUzK80TR/3KS/P+xteRLKbpZiZnVAXF1SrOoXEMzDSc8ZgikqeSsT8msY//n
         tIxOxIZIfZ2AgpnvqNQLErDbr6L005nh041zNeG3BxMDmP2BBSq5ZFtWLNpkkCk0el
         UnRii5yTgh1QQh29BIPRWRUr2V24qB9zTg2Epg+9ytI2M9G95rCN2tb79bQgMNpyYh
         HOppgzOzLf7TQC+HRZO2OBup1uvah+i5pzSBJq0i1663ewDn8/5UWclyPvAC/mrlXx
         pdqGDVERXtnpw==
Date:   Wed, 1 Mar 2023 11:00:00 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH -next v14 19/19] riscv: Enable Vector code to be built
Message-ID: <Y/+SoGfspjGwlH7g@dev-arch.thelio-3990X>
References: <20230224170118.16766-20-andy.chiu@sifive.com>
 <202302250924.ukv4ZxOc-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202302250924.ukv4ZxOc-lkp@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andy,

On Sat, Feb 25, 2023 at 09:33:30AM +0800, kernel test robot wrote:
> Hi Andy,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on next-20230224]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Andy-Chiu/riscv-Rename-__switch_to_aux-fpu/20230225-011059
> patch link:    https://lore.kernel.org/r/20230224170118.16766-20-andy.chiu%40sifive.com
> patch subject: [PATCH -next v14 19/19] riscv: Enable Vector code to be built
> config: riscv-randconfig-r014-20230222 (https://download.01.org/0day-ci/archive/20230225/202302250924.ukv4ZxOc-lkp@intel.com/config)
> compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project db89896bbbd2251fff457699635acbbedeead27f)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install riscv cross compiling tool for clang build
>         # apt-get install binutils-riscv64-linux-gnu
>         # https://github.com/intel-lab-lkp/linux/commit/cd0ad21a9ef9d63f1eef80fd3b09ae6e0d884ce3
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Andy-Chiu/riscv-Rename-__switch_to_aux-fpu/20230225-011059
>         git checkout cd0ad21a9ef9d63f1eef80fd3b09ae6e0d884ce3
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv olddefconfig
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash lib/zstd/
> 
> If you fix the issue, kindly add following tag where applicable
> | Reported-by: kernel test robot <lkp@intel.com>
> | Link: https://lore.kernel.org/oe-kbuild-all/202302250924.ukv4ZxOc-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> warning: Invalid size request on a scalable vector; Cannot implicitly convert a scalable size to a fixed-width size in `TypeSize::operator ScalarTy()`

Please consider adding the following diff to patch 19 to avoid this
issue (see the upstream bug report for more details):

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index eb691dd8ee4f..187cd6c1d8c9 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -423,6 +423,8 @@ config TOOLCHAIN_HAS_V
 	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64iv)
 	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32iv)
 	depends on LLD_VERSION >= 140000 || LD_VERSION >= 23800
+	# https://github.com/llvm/llvm-project/issues/61096
+	depends on !(CC_IS_CLANG && CLANG_VERSION >= 160000 && KASAN)
 
 config RISCV_ISA_V
 	bool "VECTOR extension support"
---

Additionally, with older versions of clang 15.x and older, I see:

  arch/riscv/kernel/vector.c:50:3: error: expected expression
                  u32 width = RVV_EXRACT_VL_VS_WIDTH(insn_buf);
                  ^
  arch/riscv/kernel/vector.c:52:7: error: use of undeclared identifier 'width'
                  if (width == RVV_VL_VS_WIDTH_8 || width == RVV_VL_VS_WIDTH_16 ||
                      ^
  arch/riscv/kernel/vector.c:52:37: error: use of undeclared identifier 'width'
                  if (width == RVV_VL_VS_WIDTH_8 || width == RVV_VL_VS_WIDTH_16 ||
                                                    ^
  arch/riscv/kernel/vector.c:53:7: error: use of undeclared identifier 'width'
                      width == RVV_VL_VS_WIDTH_32 || width == RVV_VL_VS_WIDTH_64)
                      ^
  arch/riscv/kernel/vector.c:53:38: error: use of undeclared identifier 'width'
                      width == RVV_VL_VS_WIDTH_32 || width == RVV_VL_VS_WIDTH_64)
                                                     ^
  arch/riscv/kernel/vector.c:57:3: error: expected expression
                  u32 csr = RVG_EXTRACT_SYSTEM_CSR(insn_buf);
                  ^
  arch/riscv/kernel/vector.c:59:8: error: use of undeclared identifier 'csr'
                  if ((csr >= CSR_VSTART && csr <= CSR_VCSR) ||
                       ^
  arch/riscv/kernel/vector.c:59:29: error: use of undeclared identifier 'csr'
                  if ((csr >= CSR_VSTART && csr <= CSR_VCSR) ||
                                            ^
  arch/riscv/kernel/vector.c:60:8: error: use of undeclared identifier 'csr'
                      (csr >= CSR_VL && csr <= CSR_VLENB))
                       ^
  arch/riscv/kernel/vector.c:60:25: error: use of undeclared identifier 'csr'
                      (csr >= CSR_VL && csr <= CSR_VLENB))
                                        ^
  10 errors generated.

which is fixed by:

diff --git a/arch/riscv/kernel/vector.c b/arch/riscv/kernel/vector.c
index 585e2c51b28e..8c98db9c0ae1 100644
--- a/arch/riscv/kernel/vector.c
+++ b/arch/riscv/kernel/vector.c
@@ -46,14 +46,15 @@ static bool insn_is_vector(u32 insn_buf)
 		is_vector = true;
 		break;
 	case RVV_OPCODE_VL:
-	case RVV_OPCODE_VS:
+	case RVV_OPCODE_VS: {
 		u32 width = RVV_EXRACT_VL_VS_WIDTH(insn_buf);
 
 		if (width == RVV_VL_VS_WIDTH_8 || width == RVV_VL_VS_WIDTH_16 ||
 		    width == RVV_VL_VS_WIDTH_32 || width == RVV_VL_VS_WIDTH_64)
 			is_vector = true;
 		break;
-	case RVG_OPCODE_SYSTEM:
+	}
+	case RVG_OPCODE_SYSTEM: {
 		u32 csr = RVG_EXTRACT_SYSTEM_CSR(insn_buf);
 
 		if ((csr >= CSR_VSTART && csr <= CSR_VCSR) ||
@@ -61,6 +62,7 @@ static bool insn_is_vector(u32 insn_buf)
 			is_vector = true;
 		break;
 	}
+	}
 	return is_vector;
 }
 
---

Cheers,
Nathan
