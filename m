Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6CA566499
	for <lists+kvm@lfdr.de>; Tue,  5 Jul 2022 10:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbiGEHqi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jul 2022 03:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGEHqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jul 2022 03:46:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA24F12D06;
        Tue,  5 Jul 2022 00:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657007196; x=1688543196;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Wo/95XcUaTqgsG+21IM9rVz0ar2aeQ4fbnPHdy0zIgE=;
  b=inqXiyow5kZIUjkqnsJLZNoLBpbtsj6BsqaHS+Q09Z7GhTHMhv/Odhz2
   a+o70JU7G12w/Kz7JYAxoslSSv2mD6KTuNbQtqMqAuxE+xRxEmkuzIvML
   uIL0VWNZAO1JyoCl3BoGtCOTVM79Kk7S6oCJA4Un5auuIB3cdDn7Q4poq
   RVjXQUMll7+0DKX374EXJWK107VLgbJFGh9pq13SW0qq9tZIOOhk8PnNw
   Zmrhwox8fm5HX+QXHbdmr2PwBwlBlvjVsgKYHYK6pO6EXQF0167mQzWHb
   XFRxYCkY7ZOLIn2vH3ske6/ZHCQj52wGyGercv9v6ffxxvz8Ie8Oz7vS+
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="266307588"
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="266307588"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 00:46:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="625354457"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 05 Jul 2022 00:46:32 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o8dGS-000Iqx-7Z;
        Tue, 05 Jul 2022 07:46:32 +0000
Date:   Tue, 5 Jul 2022 15:46:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     kbuild-all@lists.01.org, jjherne@linux.ibm.com,
        freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: Re: [PATCH v20 19/20] s390/Docs: new doc describing lock usage by
 the vfio_ap device driver
Message-ID: <202207051551.Atn3pnAI-lkp@intel.com>
References: <20220621155134.1932383-20-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621155134.1932383-20-akrowiak@linux.ibm.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Tony,

I love your patch! Perhaps something to improve:

[auto build test WARNING on s390/features]
[also build test WARNING on mst-vhost/linux-next linus/master v5.19-rc5 next-20220704]
[cannot apply to kvms390/next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Tony-Krowiak/s390-vfio-ap-dynamic-configuration-support/20220621-235654
base:   https://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git features
reproduce: make htmldocs

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> Documentation/s390/vfio-ap-locking.rst: WARNING: document isn't included in any toctree

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
