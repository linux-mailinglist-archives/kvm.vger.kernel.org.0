Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAA58153323
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 15:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgBEOgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 09:36:53 -0500
Received: from mga18.intel.com ([134.134.136.126]:15504 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgBEOgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 09:36:53 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Feb 2020 06:36:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,405,1574150400"; 
   d="scan'208";a="225852442"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 05 Feb 2020 06:36:51 -0800
Date:   Wed, 5 Feb 2020 06:36:51 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Use "-cpu host" for PCID tests
Message-ID: <20200205143651.GB4877@linux.intel.com>
References: <20200204194809.2077-1-sean.j.christopherson@intel.com>
 <874kw5mfiw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kw5mfiw.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 05, 2020 at 12:37:11PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Use the host CPU model for the PCID tests to allow testing the various
> > combinations of PCID and INVPCID enabled/disabled without having to
> > manually change the kvm-unit-tests command line.  I.e. give users the
> > option of changing the command line *OR* running on a (virtual) CPU
> > with or without PCID and/or INVPCID.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  x86/unittests.cfg | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> > index aae1523..25f4535 100644
> > --- a/x86/unittests.cfg
> > +++ b/x86/unittests.cfg
> > @@ -228,7 +228,7 @@ extra_params = --append "10000000 `date +%s`"
> >  
> >  [pcid]
> >  file = pcid.flat
> > -extra_params = -cpu qemu64,+pcid
> > +extra_params = -cpu host
> >  arch = x86_64
> >  
> >  [rdpru]
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> Actually, is there any reason for *not* using '-cpu host' in any of the
> tests?

Emulation tests, e.g. for UMIP, will want "-cpu <base>,+<feature>", but I
can't think of any reason why <base> shouldn't be host.
