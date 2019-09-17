Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100F4B57F6
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 00:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfIQW2T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 18:28:19 -0400
Received: from mga17.intel.com ([192.55.52.151]:26639 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfIQW2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 18:28:19 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Sep 2019 15:28:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,518,1559545200"; 
   d="scan'208";a="386695694"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga005.fm.intel.com with ESMTP; 17 Sep 2019 15:28:18 -0700
Date:   Tue, 17 Sep 2019 15:28:18 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Marc Orr <marcorr@google.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/2] x86: nvmx: test max atomic switch
 MSRs
Message-ID: <20190917222818.GB10319@linux.intel.com>
References: <20190917185753.256039-1-marcorr@google.com>
 <20190917185753.256039-2-marcorr@google.com>
 <20190917194738.GD8804@linux.intel.com>
 <CAA03e5G94nbVj9vfOr5Gc7x89B6afh3HmxHnMMijtn8SzqgjTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA03e5G94nbVj9vfOr5Gc7x89B6afh3HmxHnMMijtn8SzqgjTA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 17, 2019 at 01:16:27PM -0700, Marc Orr wrote:
> > > +     /* Cleanup. */
> > > +     vmcs_write(ENT_MSR_LD_CNT, 0);
> > > +     vmcs_write(EXI_MSR_LD_CNT, 0);
> > > +     vmcs_write(EXI_MSR_ST_CNT, 0);
> > > +     for (i = 0; i < cleanup_count; i++) {
> > > +             enter_guest();
> > > +             skip_exit_vmcall();
> > > +     }
> >
> > I'm missing something, why do we need to reenter the guest after setting
> > the count to 0?
> 
> It's for the failure code path, which fails to get into the guest and
> skip the single vmcall(). I've refactored the code to make this clear.
> Let me know what you think.

Why is not entering the guest a problem?
