Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F234D922A
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 02:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344231AbiCOBTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 21:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344227AbiCOBTA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 21:19:00 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1845626D9;
        Mon, 14 Mar 2022 18:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647307070; x=1678843070;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DWo909LPMfp/xcTS2ZhK17ummZUcNpAQabmYluiBYfs=;
  b=B5lESyfSk3KSU+uK8URBBXyWxnvm91nsZImSXHR3J9cFP9w5x5QTN4EY
   8cB/4D90GHemEU0GhK6gXQEUFmrDbKwAfvCcMkPze1BnuXarWiqxgeco3
   xM5MIVjRL9P/gXgdO7aro/8q5zpP+zKPDQqCblWG/DVYuzLB42xNVtivF
   40JBfX7YdYPNC14CS5tkrk3KcxOGBmRtXO+T5wtcYzA32lzH+2OWd6q16
   l2ji/dnY+hOCpnjJhLtoZLyLTkmzVKhgUYmD5MR4RJ45mQd7lL/g6NKE8
   mL2OvbqKyEiLfQrwF1C7BaddsIFQNMTPZKt2Kx9OQ9lIouVEnoRPeEjm7
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="280951703"
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="280951703"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 18:17:49 -0700
X-IronPort-AV: E=Sophos;i="5.90,181,1643702400"; 
   d="scan'208";a="515673019"
Received: from aholley-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.24.246])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 18:17:44 -0700
Message-ID: <0ffa85dbb54ddeecdbfdef3a22c077156268001b.camel@intel.com>
Subject: Re: [RFC 0/3] Expose Confidential Computing capabilities on sysfs
From:   Kai Huang <kai.huang@intel.com>
To:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, kirill.shutemov@linux.intel.com,
        hpa@zytor.com, pbonzini@redhat.com, seanjc@google.com,
        srutherford@google.com, ashish.kalra@amd.com,
        darren.kenny@oracle.com, venu.busireddy@oracle.com,
        boris.ostrovsky@oracle.com, kvm@vger.kernel.org
Date:   Tue, 15 Mar 2022 14:17:42 +1300
In-Reply-To: <20220314224346.GA3426703@ls.amr.corp.intel.com>
References: <20220309220608.16844-1-alejandro.j.jimenez@oracle.com>
         <8498cff4-3c31-f596-04fe-62013b94d7a4@intel.com>
         <746497ff-992d-4659-aa32-a54c68ae83bf@oracle.com>
         <20220314224346.GA3426703@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> 
> More concretely
> - CPU feature (Secure Arbitration Mode: SEAM) as "seam" flag in /proc/cpuinfo

In my current patchset we don't have "seam" flag in /proc/cpuinfo.  

https://lore.kernel.org/kvm/cover.1647167475.git.kai.huang@intel.com/T/#m02542eb723394a81c35b9542b2763c783222d594

TDX architecture doesn't have a CPUID to report SEAM, so we will need a
synthetic flag if we want to add.  If userspace has requirement to use it, then
it makes sense to add it and expose to /proc/cpuinfo.  But so far I don't know
there's any.

Thanks
-Kai


