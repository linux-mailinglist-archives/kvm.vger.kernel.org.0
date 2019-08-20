Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B43A95E98
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2019 14:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbfHTMbe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Aug 2019 08:31:34 -0400
Received: from mga07.intel.com ([134.134.136.100]:40643 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728248AbfHTMbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Aug 2019 08:31:34 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 05:31:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,408,1559545200"; 
   d="scan'208";a="377765048"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by fmsmga005.fm.intel.com with ESMTP; 20 Aug 2019 05:31:31 -0700
Date:   Tue, 20 Aug 2019 20:33:02 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        yu.c.zhang@intel.com, alazar@bitdefender.com
Subject: Re: [PATCH RESEND v4 5/9] KVM: VMX: Add init/set/get functions for
 SPP
Message-ID: <20190820123301.GA4828@local-michael-cet-test.sh.intel.com>
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-6-weijiang.yang@intel.com>
 <87a7cbapdw.fsf@vitty.brq.redhat.com>
 <20190815134329.GA11449@local-michael-cet-test>
 <CALMp9eTGXDDfVspFwFyEhagg9sdnqZqzSQhDksT0bkKzVNGSqw@mail.gmail.com>
 <20190815163844.GD27076@linux.intel.com>
 <20190816133130.GA14380@local-michael-cet-test.sh.intel.com>
 <CALMp9eRDhbxkFNqY-+GOMtfg+guafdKcCNq1OJt9UgnyFVvSGw@mail.gmail.com>
 <20190819020829.GA27450@local-michael-cet-test>
 <e9a269d8-b410-2489-aaa3-24b487ffd1e2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9a269d8-b410-2489-aaa3-24b487ffd1e2@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 19, 2019 at 05:15:01PM +0200, Paolo Bonzini wrote:
> On 19/08/19 04:08, Yang Weijiang wrote:
> >> KVM_GET_NESTED_STATE has the requested information. If
> >> data.vmx.vmxon_pa is anything other than -1, then the vCPU is in VMX
> >> operation. If (flags & KVM_STATE_NESTED_GUEST_MODE), then L2 is
> >> active.
> > Thanks Jim, I'll reference the code and make necessary change in next
> > SPP patch release.
> 
> Since SPP will not be used very much in the beginning, it would be
> simplest to enable it only if nested==0.
> 
> Paolo
Thanks Paolo! Sure, will make the change and document it.
