Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEAF54D42F3
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 09:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240545AbiCJJAK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 04:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239986AbiCJJAJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 04:00:09 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D2DE3C7B
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 00:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646902748; x=1678438748;
  h=from:to:cc:subject:date:message-id;
  bh=cEQvWn6cKH//ZmRKF+kqgy60d5rxkvhGVp21E2JHYXc=;
  b=AtNPGIRBhIPAHosP4xNmL+xgGpAy1vOoo6VrAAYHJxeYBteYllJKAJ7b
   bIJ15YykcFHQnminyg7qSGPE2Fz6IGfVXc8kbQQbqTUD0VRfEz0P4Zi7U
   7EfHtU0/9GFt9+1CaUD2jxTYZMhq9awq1aggLYCtdLG5Ddl1t2ON/Jc5N
   hG8Z9QIszcoUHQ5m3J0IA/z/clXOFj5PLdxp0Hr5S0BnBpcfyQa/ysMWV
   M+zthgEiYHGL445au9HjdFGvFihxHTKLhq3+mBJaqeT4O6PzCs8TI2IUP
   Z/5o70oJvk+gplRUAUaA35Udtbrn58larxAJM6AgBmtrMtysv4onO0djm
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="235148759"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="235148759"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 00:59:08 -0800
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="644367169"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 00:59:06 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 0/2] Enable notify VM exit
Date:   Thu, 10 Mar 2022 17:02:03 +0800
Message-Id: <20220310090205.10645-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Notify VM exit is introduced to mitigate the potential DOS attach from
malicious VM. This series is the userspace part to enable this feature
through a new KVM capability KVM_CAP_X86_NOTIFY_VMEXIT. The
corresponding KVM patch series is available at

https://lore.kernel.org/lkml/20220310084001.10235-1-chenyi.qiang@intel.com/

Chenyi Qiang (2):
  linux-headers: Sync the linux headers
  i386: Add notify VM exit support

 hw/i386/x86.c               | 24 +++++++++++++++
 include/hw/i386/x86.h       |  3 ++
 linux-headers/asm-x86/kvm.h |  4 +++
 linux-headers/linux/kvm.h   | 29 +++++++++++++++----
 target/i386/kvm/kvm.c       | 58 ++++++++++++++++++++++++-------------
 5 files changed, 93 insertions(+), 25 deletions(-)

-- 
2.17.1

