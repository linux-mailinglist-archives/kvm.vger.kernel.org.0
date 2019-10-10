Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C139D1E01
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 03:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732454AbfJJB2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 21:28:39 -0400
Received: from mga17.intel.com ([192.55.52.151]:10466 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731553AbfJJB2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 21:28:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 18:28:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,278,1566889200"; 
   d="scan'208";a="205932962"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by orsmga002.jf.intel.com with ESMTP; 09 Oct 2019 18:28:31 -0700
Date:   Thu, 10 Oct 2019 09:30:27 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH v7 4/7] KVM: VMX: Load Guest CET via VMCS when CET is
 enabled in Guest
Message-ID: <20191010013027.GA1196@local-michael-cet-test.sh.intel.com>
References: <20190927021927.23057-1-weijiang.yang@intel.com>
 <20190927021927.23057-5-weijiang.yang@intel.com>
 <CALMp9eS1V2fRcwogcEkHonvVAgfc9dU=7A4V-D0Rcoc=v82VAw@mail.gmail.com>
 <20191009064339.GC27851@local-michael-cet-test>
 <CALMp9eS+_riWYK=Zvk330YST4G_q_GfN2LfGXWz85aVnyXmsOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eS+_riWYK=Zvk330YST4G_q_GfN2LfGXWz85aVnyXmsOg@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 09, 2019 at 04:08:50PM -0700, Jim Mattson wrote:
> On Tue, Oct 8, 2019 at 11:41 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
> >
> > On Wed, Oct 02, 2019 at 11:54:26AM -0700, Jim Mattson wrote:
> > > On Thu, Sep 26, 2019 at 7:17 PM Yang Weijiang <weijiang.yang@intel.com> wrote:
> > > > +       if (cet_on)
> > > > +               vmcs_set_bits(VM_ENTRY_CONTROLS,
> > > > +                             VM_ENTRY_LOAD_GUEST_CET_STATE);
> > >
> > > Have we ensured that this VM-entry control is supported on the platform?
> > >
> > If all the checks pass, is it enought to ensure the control bit supported?
> 
> I don't think so. The only way to check to see if a VM-entry control
> is supported is to check the relevant VMX capability MSR.
>
It's a bit odd, there's no relevant CET bit in VMX cap. MSR, so I have
to check like this.

> BTW, what about the corresponding VM-exit control?
The kernel supervisor mode CET is not implemented yet, so I don't load host CET
states on VM-exit, in future, I'll add it.
