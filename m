Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67D7E92605
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 16:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfHSOFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 10:05:14 -0400
Received: from mga18.intel.com ([134.134.136.126]:30454 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727696AbfHSOFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 10:05:12 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 07:05:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,405,1559545200"; 
   d="scan'208";a="261853858"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by orsmga001.jf.intel.com with ESMTP; 19 Aug 2019 07:05:09 -0700
Date:   Mon, 19 Aug 2019 22:06:41 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com, yu.c.zhang@intel.com, alazar@bitdefender.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Subject: Re: [PATCH RESEND v4 5/9] KVM: VMX: Add init/set/get functions for
 SPP
Message-ID: <20190819140641.GA32099@local-michael-cet-test.sh.intel.com>
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-6-weijiang.yang@intel.com>
 <87a7cbapdw.fsf@vitty.brq.redhat.com>
 <20190815134329.GA11449@local-michael-cet-test>
 <87o90q8r0s.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o90q8r0s.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 15, 2019 at 04:03:31PM +0200, Vitaly Kuznetsov wrote:
> Yang Weijiang <weijiang.yang@intel.com> writes:
> 
> > After looked into the issue and others, I feel to make SPP co-existing
> > with nested VM is not good, the major reason is, L1 pages protected by
> > SPP are transparent to L1 VM, if it launches L2 VM, probably the
> > pages would be allocated to L2 VM, and that will bother to L1 and L2.
> > Given the feature is new and I don't see nested VM can benefit
> > from it right now, I would like to make SPP and nested feature mutually
> > exclusive, i.e., detecting if the other part is active before activate one
> > feature,what do you think of it? 
> 
> I was mostly worried about creating a loophole (if I understand
> correctly) for guests to defeat SPP protection: just launching a nested
> guest and giving it a protected page. I don't see a problem if we limit
> SPP to non-nested guests as step 1: we, however, need to document this
> side-effect of the ioctl. Also, if you decide to do this enforecement,
> I'd suggest you forbid VMLAUCH/VMRESUME and not VMXON as kvm module
> loads in linux guests automatically when the hardware is suitable.
> 
> Thanks,
> 
> -- 
> Vitaly
OK, I'll follow your suggestion to add the exclusion, thanks!
