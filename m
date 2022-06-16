Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0550454EC93
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 23:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378582AbiFPVbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 17:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbiFPVbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 17:31:15 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8CA61296;
        Thu, 16 Jun 2022 14:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655415075; x=1686951075;
  h=from:to:cc:subject:date:message-id;
  bh=/+AYwiPu7I6p1wniSCqIx6zbG2kzik2LX3FT34lcIs8=;
  b=QS/bIXdEgkB4ZzSzlcoRcgL4tkdsdNeDoA0KjwI20D32t1Oea+BQHqzy
   oHdHXtiVMRwo2uzugnivMufyoLREu5dP9RGErtjTQKKlsYfnCMbHRGrDh
   0INjtcXz+D9TYTvmy4iOGTkLBcqT78TAb+6jQNULlyd746fwVxgJFXhOd
   kzOQyY6HKQxQV2TrmDFD/yYxSQcQ5Nt0gXHRfK4F145zYAnPXNh2zVnNu
   P4VR2xQNcc+Rjh/6TufgMFdha+Vypz46vd0Q8H7GzxVB8XF5VTX1Jt1Ff
   eAusCnCy4HVeP236keP75C6YObZn2q1AichCtMsjref1RRoHISYc7l1lk
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="280389919"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="280389919"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 14:31:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="589824120"
Received: from chang-linux-3.sc.intel.com ([172.25.66.173])
  by fmsmga007.fm.intel.com with ESMTP; 16 Jun 2022 14:31:14 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     dave.hansen@intel.com, len.brown@intel.com, tony.luck@intel.com,
        rafael.j.wysocki@intel.com, reinette.chatre@intel.com,
        dan.j.williams@intel.com
Cc:     corbet@lwn.net, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com
Subject: [PATCH 0/2] Documentation/x86: Update the dynamic XSTATE doc
Date:   Thu, 16 Jun 2022 14:22:08 -0700
Message-Id: <20220616212210.3182-1-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.0 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

This series is intended to update the documentation only. It is not ready
yet for x86 maintainers. So more acknowledgment from Intel reviewers is
needed. Any preliminary review from the cc'ed folks will be much
appreciated. But it is possibly a waste of maintainers' time to review this
draft at this stage.

=== Cover Letter ===

With the AMX support in the mainline, I realize a couple of new
arch_prctl(2) options that were added for KVM have been missing in the doc.
And recently I heard some folks had hard time to understand the AMX
enabling process. A code example is expected to clarify the steps.

Thus, this patch set includes the following two updates:
(1) Patch 1 adds AMX enabling code example.
(2) Patch 2 explains the arch_prctl(2) options for guest:
    ARCH_{GET|REQ}_XCOMP_GUEST_PERM

The arch_prctl(2) manual page [1] is also missing the above and even other
options that are already included in the doc. Perhaps, the man-page update
follows up after this.

These changes can be found in the repo:
  git://github.com/intel/amx-linux.git doc

And the compiled preview is available here:
  https://htmlpreview.github.io/?https://github.com/intel/amx-linux/blob/doc-web/x86/xstate.html

Thanks,
Chang

[1] arch_prctl(2): https://man7.org/linux/man-pages/man2/arch_prctl.2.html

Chang S. Bae (2):
  Documentation/x86: Add the AMX enabling example
  Documentation/x86: Explain guest XSTATE permission control

 Documentation/x86/xstate.rst | 69 ++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)


base-commit: b13baccc3850ca8b8cccbf8ed9912dbaa0fdf7f3
-- 
2.17.1

