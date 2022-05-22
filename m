Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C22B53029D
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 13:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244619AbiEVLTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 07:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235232AbiEVLTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 07:19:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BAA3D1E1
        for <kvm@vger.kernel.org>; Sun, 22 May 2022 04:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653218363; x=1684754363;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=RBvtOp331amrI+LJCcohOxzCxaubfml5IAhCas1dKJs=;
  b=HrgGZAFFOIdg92PnjfV+o7AOd2IFO49s5A1WTriaRJ080JypiDQB1Ibu
   II4NazsHlM8fhJbkr13Gi/Dg3/t1+pMyYpR68l1I6eCaUKbSt4a7meAQw
   lcWAL5On0RzDLseZkTzATdhlu4kld2VZq+I77TdE8rh9QtYL58WpwmaUK
   K7I4OrICd0qfvgkhtbJzLyROeMFwXrWEekwDP7ClObYuAYBtgISPakUwA
   RpFGtV8aGrqXoSekZ7bhBjrswW+bRkjL0Ma5njitJHR5boi++FdtiWgfA
   kD9FGTbQF2kzGGv5sPVhC8R729PhPXtOMuieIBd4BUzFM0rW2wMpedlM4
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10354"; a="272693844"
X-IronPort-AV: E=Sophos;i="5.91,244,1647327600"; 
   d="scan'208";a="272693844"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2022 04:19:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,244,1647327600"; 
   d="scan'208";a="576938949"
Received: from lkp-server01.sh.intel.com (HELO db63a1be7222) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 22 May 2022 04:19:21 -0700
Received: from kbuild by db63a1be7222 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nsjcG-0000KH-E6;
        Sun, 22 May 2022 11:19:20 +0000
Date:   Sun, 22 May 2022 19:19:10 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        Robert Hu <robert.hu@intel.com>,
        Farrah Chen <farrah.chen@intel.com>,
        Danmei Wei <danmei.wei@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:queue 10/60] arch/x86/kernel/kvm.c:240:2-7: WARNING: NULL check
 before some freeing functions is not needed.
Message-ID: <202205221909.sMshQw0j-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   3481c4e162be9b7af2323e64312b1c8542e8789b
commit: ddd7ed842627ea54084522fb9bb8531bea3004c9 [10/60] x86/kvm: Alloc dummy async #PF token outside of raw spinlock
config: x86_64-randconfig-c022 (https://download.01.org/0day-ci/archive/20220522/202205221909.sMshQw0j-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-1) 11.3.0

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>


cocci warnings: (new ones prefixed by >>)
>> arch/x86/kernel/kvm.c:240:2-7: WARNING: NULL check before some freeing functions is not needed.

Please review and possibly fold the followup patch.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
