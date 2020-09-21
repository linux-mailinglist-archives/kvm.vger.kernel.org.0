Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6394D2730CA
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 19:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgIURVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 13:21:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:47536 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbgIURVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 13:21:18 -0400
IronPort-SDR: Rpb66G1XP4cFtnOcTQKyfoQOQ5T6dMphRist8x4Ncr51tlYZjAHJKheGC9ODnMXVhQCj1TS8zm
 kQ3cqCoaHppA==
X-IronPort-AV: E=McAfee;i="6000,8403,9751"; a="160505400"
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="160505400"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 10:21:17 -0700
IronPort-SDR: VY7pyBgmT7sxVYCPzS3B8Hf7CmR/TndJJxV5G8TYir6MY8UbzeWwFmv0bs7O1+1ZIvP+hp6bJk
 lE3+0krGJxbA==
X-IronPort-AV: E=Sophos;i="5.77,287,1596524400"; 
   d="scan'208";a="510811785"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2020 10:21:16 -0700
Date:   Mon, 21 Sep 2020 10:21:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        linux-kernel@vger.kernel.org, Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH v2 0/3] KVM: x86: KVM_MEM_PCI_HOLE memory
Message-ID: <20200921172114.GA24289@linux.intel.com>
References: <87eenlwoaa.fsf@vitty.brq.redhat.com>
 <20200901200021.GB3053@xz-x1>
 <877dtcpn9z.fsf@vitty.brq.redhat.com>
 <20200904061210.GA22435@sjchrist-ice>
 <20200904072905.vbkiq3h762fyzds6@sirius.home.kraxel.org>
 <20200904160008.GA2206@sjchrist-ice>
 <874koanfsc.fsf@vitty.brq.redhat.com>
 <20200907072829-mutt-send-email-mst@kernel.org>
 <20200911170031.GD4344@sjchrist-ice>
 <20200918083134-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918083134-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 18, 2020 at 08:34:37AM -0400, Michael S. Tsirkin wrote:
> On Fri, Sep 11, 2020 at 10:00:31AM -0700, Sean Christopherson wrote:
> > On Mon, Sep 07, 2020 at 07:32:23AM -0400, Michael S. Tsirkin wrote:
> > > I suspect microvms will need pci eventually. I would much rather KVM
> > > had an exit-less discovery mechanism in place by then because
> > > learning from history if it doesn't they will do some kind of
> > > hack on the kernel command line, and everyone will be stuck
> > > supporting that for years ...
> > 
> > Is it not an option for the VMM to "accurately" enumerate the number of buses?
> > E.g. if the VMM has devices on only bus 0, then enumerate that there is one
> > bus so that the guest doesn't try and probe devices that can't possibly exist.
> > Or is that completely non-sensical and/or violate PCIe spec?
> 
> 
> There is some tension here, in that one way to make guest boot faster
> is to defer hotplug of devices until after it booted.

Sorry, I didn't follow that, probably because my PCI knowledge is lacking.
What does device hotplug have to do with the number of buses enumerated to
the guest?
