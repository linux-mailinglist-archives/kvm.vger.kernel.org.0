Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAA1A79E53F
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 12:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbjIMKt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 06:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239735AbjIMKtR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 06:49:17 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0121726;
        Wed, 13 Sep 2023 03:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694602153; x=1726138153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l4rRB6q60nP3OBQRoA84gLJ739r9ruaKEWruVEincP8=;
  b=S+BY7U3PyN8FHkNajlO321/wEN9uBtVAj7n9PQ8w5qOc84E8vvcU0tUu
   MHiCYA1rOCmmsKYdudYl/gzgrJfU81O8uEwLp1cHnIaMHxDta5mSHSyW9
   wkY1yYmuFWpjFkYAMpGTDsKqokbgsFO1PoKSAxGtgjDHjlk/Utcodt84C
   FCvfJhSrlILuqZEvnnNFQ06BzW0bQqua/mwkIKQ7YuCikjddP30+WbGVM
   z/wNGmY5yIv+prQYuwIMLYdyF9s0J+Hv6tBnUh9dx/QEccuu1OUzhtUvy
   lsu8astOvEQp+sY0PJuefw93ZHAWFNL7IhKjgErRzVA3ZN/UBuK2MWDii
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="377537907"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="377537907"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 03:49:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="809635601"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="809635601"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 03:49:12 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Subject: [RFC PATCH 6/6] KVM: X86: Allow KVM gmem hwpoison test cases
Date:   Wed, 13 Sep 2023 03:48:55 -0700
Message-Id: <192a749b3842619e89bf91513e3c2715091ced61.1694599703.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1694599703.git.isaku.yamahata@intel.com>
References: <cover.1694599703.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Set HAVE_GENERIC_PRIVATE_MEM_HANDLE_ERROR and KVM_GENERIC_PRIVATE_MEM_BMAP
to allow test cases for KVM gmem.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 029c76bcd1a5..46fdedde9c0f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -82,6 +82,8 @@ config KVM_SW_PROTECTED_VM
 	depends on EXPERT
 	depends on X86_64
 	select KVM_GENERIC_PRIVATE_MEM
+	select HAVE_GENERIC_PRIVATE_MEM_HANDLE_ERROR
+	select KVM_GENERIC_PRIVATE_MEM_BMAP
 	help
 	  Enable support for KVM software-protected VMs.  Currently "protected"
 	  means the VM can be backed with memory provided by
-- 
2.25.1

