Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242887CF6ED
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 13:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345380AbjJSLeQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 07:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345355AbjJSLeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 07:34:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3D5134;
        Thu, 19 Oct 2023 04:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697715252; x=1729251252;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UZ2MRMETMkvC4Gm+iYt0qTrKR1exYOUbxk00Jvoitsk=;
  b=Gbt63Zht8PB/vTNXBWDl39ZHZDdQPhHtRzKyRdN1l0OvpBWs7tbx6RZ4
   k2XVjSaRNo+A+lty3OrH9oOP6SS7LBKcUb9phQrmTl/dEMEpAXujCgBg+
   s23zQBAvFspiBzax6KIHojVLSzNboH36FDCM6WmAdr/4KvycsCh/M++mo
   65TgNwxWq9QRkkbvY/2A07qztAQwNJivrSVMDwZh2B9/Ym0WVMldXebqz
   Fo9E6B+gMj78+863qrfD74XeKozRLzRYMV59zeZpLciA8zszjA8AzHOhG
   E6K7MjuL5wNuXsJjYzQt6c0XtBgTu30wzoRiWmEE2cqZS6u5ydkjmEi5n
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="7782520"
X-IronPort-AV: E=Sophos;i="6.03,237,1694761200"; 
   d="scan'208";a="7782520"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2023 04:34:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="1004198450"
X-IronPort-AV: E=Sophos;i="6.03,237,1694761200"; 
   d="scan'208";a="1004198450"
Received: from lkp-server01.sh.intel.com (HELO 8917679a5d3e) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 19 Oct 2023 04:34:09 -0700
Received: from kbuild by 8917679a5d3e with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qtRHy-00024T-22;
        Thu, 19 Oct 2023 11:34:06 +0000
Date:   Thu, 19 Oct 2023 19:33:32 +0800
From:   kernel test robot <lkp@intel.com>
To:     Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH v3 1/5] x86/paravirt: move some functions and defines to
 alternative
Message-ID: <202310191944.Z8sC9h8O-lkp@intel.com>
References: <20231019091520.14540-2-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019091520.14540-2-jgross@suse.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Juergen,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[cannot apply to tip/x86/core]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Juergen-Gross/x86-paravirt-move-some-functions-and-defines-to-alternative/20231019-171709
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20231019091520.14540-2-jgross%40suse.com
patch subject: [PATCH v3 1/5] x86/paravirt: move some functions and defines to alternative
reproduce: (https://download.01.org/0day-ci/archive/20231019/202310191944.Z8sC9h8O-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202310191944.Z8sC9h8O-lkp@intel.com/

# many are suggestions rather than must-fix

ERROR:COMPLEX_MACRO: Macros with complex values should be enclosed in parentheses
#32: FILE: arch/x86/include/asm/alternative.h:334:
+#define DEFINE_ASM_FUNC(func, instr, sec)		\
+	asm (".pushsection " #sec ", \"ax\"\n"		\
+	     ".global " #func "\n\t"			\
+	     ".type " #func ", @function\n\t"		\
+	     ASM_FUNC_ALIGN "\n"			\
+	     #func ":\n\t"				\
+	     ASM_ENDBR					\
+	     instr "\n\t"				\
+	     ASM_RET					\
+	     ".size " #func ", . - " #func "\n\t"	\
+	     ".popsection")

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
