Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0E7CC487
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 23:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbfJDVCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 17:02:23 -0400
Received: from mga07.intel.com ([134.134.136.100]:29034 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbfJDVCX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 17:02:23 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 14:02:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,257,1566889200"; 
   d="scan'208";a="186373614"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 04 Oct 2019 14:02:22 -0700
Date:   Fri, 4 Oct 2019 14:02:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        yu.c.zhang@intel.com, alazar@bitdefender.com
Subject: Re: [PATCH v5 2/9] vmx: spp: Add control flags for Sub-Page
 Protection(SPP)
Message-ID: <20191004210221.GB19503@linux.intel.com>
References: <20190917085304.16987-1-weijiang.yang@intel.com>
 <20190917085304.16987-3-weijiang.yang@intel.com>
 <CALMp9eSEkZiFq3RhTuJSUCx3WDJy4EfYHk7GDoN=MO9tRt4=hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSEkZiFq3RhTuJSUCx3WDJy4EfYHk7GDoN=MO9tRt4=hQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 04, 2019 at 01:48:34PM -0700, Jim Mattson wrote:
> On Tue, Sep 17, 2019 at 1:52 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> > @@ -7521,6 +7527,10 @@ static __init int hardware_setup(void)
> >         if (!cpu_has_vmx_flexpriority())
> >                 flexpriority_enabled = 0;
> >
> > +       if (cpu_has_vmx_ept_spp() && enable_ept &&
> > +           boot_cpu_has(X86_FEATURE_SPP))
> > +               spp_supported = 1;
> 
> Don't cpu_has_vmx_ept_spp() and boot_cpu_has(X86_FEATURE_SPP) test
> exactly the same thing?

More or less.  I'm about to hit 'send' on a series to eliminate the
synthetic VMX features flags.  If that goes through, the X86_FEATURE_SPP
flag can also go away.
