Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F359D6D03
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 03:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfJOBu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 21:50:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:42639 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbfJOBu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 21:50:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 18:50:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,297,1566889200"; 
   d="scan'208";a="185666579"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by orsmga007.jf.intel.com with ESMTP; 14 Oct 2019 18:50:24 -0700
Date:   Tue, 15 Oct 2019 09:53:27 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        yu.c.zhang@intel.com, alazar@bitdefender.com
Subject: Re: [PATCH v5 2/9] vmx: spp: Add control flags for Sub-Page
 Protection(SPP)
Message-ID: <20191015015327.GA8343@local-michael-cet-test.sh.intel.com>
References: <20190917085304.16987-1-weijiang.yang@intel.com>
 <20190917085304.16987-3-weijiang.yang@intel.com>
 <CALMp9eSEkZiFq3RhTuJSUCx3WDJy4EfYHk7GDoN=MO9tRt4=hQ@mail.gmail.com>
 <20191004210221.GB19503@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004210221.GB19503@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 04, 2019 at 02:02:22PM -0700, Sean Christopherson wrote:
> On Fri, Oct 04, 2019 at 01:48:34PM -0700, Jim Mattson wrote:
> > On Tue, Sep 17, 2019 at 1:52 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> > > @@ -7521,6 +7527,10 @@ static __init int hardware_setup(void)
> > >         if (!cpu_has_vmx_flexpriority())
> > >                 flexpriority_enabled = 0;
> > >
> > > +       if (cpu_has_vmx_ept_spp() && enable_ept &&
> > > +           boot_cpu_has(X86_FEATURE_SPP))
> > > +               spp_supported = 1;
> > 
> > Don't cpu_has_vmx_ept_spp() and boot_cpu_has(X86_FEATURE_SPP) test
> > exactly the same thing?
> 
> More or less.  I'm about to hit 'send' on a series to eliminate the
> synthetic VMX features flags.  If that goes through, the X86_FEATURE_SPP
> flag can also go away.

Thank you, these two are synonyms. I'll remove one next time.
