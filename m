Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D36D4E8CB1
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 05:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237872AbiC1D4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Mar 2022 23:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiC1D4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Mar 2022 23:56:46 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09EF5220D8;
        Sun, 27 Mar 2022 20:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648439706; x=1679975706;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1IrgS1Xz4xDu9eaps5L0yXyUmT/Eaqj8UxN5lOp2JiA=;
  b=U3vuF2kBsyAx6Hih/UaZgUNuhyrEC9meVxDcrlvok1lFX2OgKjjDKhzA
   /UaD6np6Gd+oIuh2mOjV7ABjfGXUNeEpW/ETIG0G5GErqG2v3r82Zec8j
   +iZLemustXErmG/vxVdCGTMqzFuuzARIxm8vSaiDfrPmAeiuuEKMZ0S7h
   0JB5F8PK3Mw1+YwyYWAPSzbBU4wUhRLiRfu9PEPdW8Tf4LKR+Zlqc1We3
   smrhGY54PTs0fqoT0VA2MGGkSsQIVULILP9iwEsYeUuPNpzn3VPoDYhDh
   M3xBennDfLhL6bmuKHDr327exzECY1BuXNdrmQ0iiMNOYOdiGlXTO1KI8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10299"; a="239502536"
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="239502536"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2022 20:55:05 -0700
X-IronPort-AV: E=Sophos;i="5.90,216,1643702400"; 
   d="scan'208";a="638819456"
Received: from stung2-mobl.gar.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.94.73])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2022 20:55:03 -0700
Message-ID: <51982ec477e43c686c5c64731715fee528750d85.camel@intel.com>
Subject: Re: [PATCH v2 01/21] x86/virt/tdx: Detect SEAM
From:   Kai Huang <kai.huang@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>
Date:   Mon, 28 Mar 2022 16:55:01 +1300
In-Reply-To: <BN9PR11MB527657C2AA8B9ACD94C9D5468C189@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1647167475.git.kai.huang@intel.com>
         <a258224c26b6a08400d9a8678f5d88f749afe51e.1647167475.git.kai.huang@intel.com>
         <BN9PR11MB527657C2AA8B9ACD94C9D5468C189@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-03-23 at 16:21 +1300, Tian, Kevin wrote:
> > From: Kai Huang <kai.huang@intel.com>
> > Sent: Sunday, March 13, 2022 6:50 PM
> > 
> > @@ -715,6 +716,8 @@ static void init_intel(struct cpuinfo_x86 *c)
> >       if (cpu_has(c, X86_FEATURE_TME))
> >               detect_tme(c);
> > 
> > +     tdx_detect_cpu(c);
> > +
> 
> TDX is not reported as a x86 feature. and the majority of detection
> and initialization have been conducted on demand in this series
> (as explained in patch04). Why is SEAM (and latter keyid) so different
> to be detected at early boot phase?
> 
> Thanks
> Kevin

Hi Kevin,

Sorry for late reply.  I was out last week.

SEAMRR and TDX KeyIDs are configured by BIOS and they are static during
machine's runtime.  On the other hand, TDX module can be updated and
reinitialized at runtime (not supported in this series but will be supported in
the future).  Theoretically, even P-SEAMLDR can be updated at runtime (although
I think unlikely to be supported in Linux).  Therefore I think detecting SEAMRR
and TDX KeyIDs at boot fits better.

It is also more flexible from some other perspectives I think: 1) There was a
request to add X86_FEATURE_SEAM bit and expose it to /proc/cpuinfo. I didn't add
it because I didn't think the use case was solid.  But in case someone has some
use case in the future we can add it, and detecting SEAMRR during boot fits this
more. 2) There was a request to expose TDX KeyID info via sysfs so userspace can
know how many TDs can be created.  It's not done in this series but it will be
done at some time in the future. Detecting KeyIDs at boot allows this info being
able to be exposed via sysfs at early stage, providing more flexibility to
userspace. 

At last, currently in this series the patch to handle kexec checks whether
SEAMRR and TDX KeyIDs are enabled and then flush cache (of course this is open
to discussion).  Detecting them at boot fits better I think.

-- 
Thanks,
-Kai


