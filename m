Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D276E03EC
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 03:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjDMB6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 21:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjDMB6c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 21:58:32 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF647EEF
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 18:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681351111; x=1712887111;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=YhYUQXRcQUwHOLP0vbX8J8GH1KZIF2FqJJ9fop4KWm0=;
  b=QcPwrhXCH5hpO32ilqOHQpv0EPSmg1IeDoqnrgYV1031junXJM7oWS9M
   UMeppJlK5fSDwTNMk6gPW2RkFWjlA9HapJOSBXVB8qnynPfBPGr+OpNJB
   tCwqGtdHuTUu7H+IsFW3IOlaqOl+cQSarGTaNfzFkMvCA3fXN5Mj8hUUZ
   7+IeuDyb63oZ9l99VfI+ukphfvyNF5Nx5WDlklxlGDTkDwrJ6hvvWAyh2
   2vr59MxK3crNle+9yaky/m2lyivP+v/lSTq/4AlSVPoZy/mjfsMaTAN1s
   8NVt8e9WSrQNFPYuWYSeF/H5w6ax4g6+o418lHBX8BIiHX/aEZ/18M+QA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="324423347"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="324423347"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 18:58:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="1018954193"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="1018954193"
Received: from dmi-pnp-i7.sh.intel.com (HELO localhost) ([10.239.159.155])
  by fmsmga005.fm.intel.com with ESMTP; 12 Apr 2023 18:58:30 -0700
Date:   Thu, 13 Apr 2023 10:05:30 +0800
From:   Dapeng Mi <dapeng1.mi@linux.intel.com>
To:     kvm@vger.kernel.org
Cc:     dapeng1.mi@intel.com`
Subject: application scenarios of vmware backdoor support in KVM
Message-ID: <ZDdjakqHbH335c/s@dmi-pnp-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I see there is vmware backdoor support in current KVM code. I'm
wondering what the application scenario is. I assume it should be some
vmware workloads in guest may needs it but not sure. Does someone know
this? Is it still used?

-- 
Thanks,
Dapeng Mi
