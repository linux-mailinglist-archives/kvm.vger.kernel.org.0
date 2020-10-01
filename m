Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1527C2801B1
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 16:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732391AbgJAOxe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 10:53:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:7821 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732020AbgJAOxe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 10:53:34 -0400
IronPort-SDR: FD/dd/jcG+nepEtymXc8/dk39CNrJswprpJGhOtXGzcxQTgd0spkEWSFgVkLRMYJ4KBK42x9On
 GWlYqbm3grbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="161985063"
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="161985063"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 07:53:31 -0700
IronPort-SDR: sm77nmWIcKWhYa194zaVfbujSF9k0+pPKiV3yFacMlXo6WBU7p2NgG2RijGfbT1R/76Xo7GCFX
 82TdapSxrA5A==
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="503960092"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 07:53:31 -0700
Date:   Thu, 1 Oct 2020 07:53:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] x86: Make Hyper-V tests x86_64 only
Message-ID: <20201001145330.GB7474@linux.intel.com>
References: <20200929164325.30605-1-sean.j.christopherson@intel.com>
 <a2003b45-f76e-1db3-046b-0be0fb4cdad1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2003b45-f76e-1db3-046b-0be0fb4cdad1@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 01, 2020 at 06:52:05AM +0200, Thomas Huth wrote:
> On 29/09/2020 18.43, Sean Christopherson wrote:
> > Skip the Hyper-V tests on i386, they explicitly run with kvm64 and crash
> > immediately when run in i386, i.e. waste 90 seconds waiting for the
> > timeout to fire.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  x86/unittests.cfg | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index 3a79151..0651778 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -314,18 +314,21 @@ arch = x86_64
> >  file = hyperv_synic.flat
> >  smp = 2
> >  extra_params = -cpu kvm64,hv_vpindex,hv_synic -device hyperv-testdev
> > +arch = x86_64
> >  groups = hyperv
> >  
> >  [hyperv_connections]
> >  file = hyperv_connections.flat
> >  smp = 2
> >  extra_params = -cpu kvm64,hv_vpindex,hv_synic -device hyperv-testdev
> > +arch = x86_64
> >  groups = hyperv
> >  
> >  [hyperv_stimer]
> >  file = hyperv_stimer.flat
> >  smp = 2
> >  extra_params = -cpu kvm64,hv_vpindex,hv_time,hv_synic,hv_stimer -device hyperv-testdev
> > +arch = x86_64
> >  groups = hyperv
> 
> Looks reasonable, but for some funny reason, this test seems to work on
> Travis in the 32-bit builds:
> 
> https://travis-ci.com/github/huth/kvm-unit-tests/jobs/392615222#L699
> 
> Any idea why it is still working there?

Hmm, looks like these crash on my end for 64-bit as well, so maybe they are
32-bit compatible and it's my setup that's busted.
