Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149FC91AF4
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 04:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfHSCHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Aug 2019 22:07:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:35771 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfHSCHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Aug 2019 22:07:00 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Aug 2019 19:06:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,403,1559545200"; 
   d="scan'208";a="180223199"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga003.jf.intel.com with ESMTP; 18 Aug 2019 19:06:57 -0700
Date:   Mon, 19 Aug 2019 10:08:29 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        yu.c.zhang@intel.com, alazar@bitdefender.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH RESEND v4 5/9] KVM: VMX: Add init/set/get functions for
 SPP
Message-ID: <20190819020829.GA27450@local-michael-cet-test>
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-6-weijiang.yang@intel.com>
 <87a7cbapdw.fsf@vitty.brq.redhat.com>
 <20190815134329.GA11449@local-michael-cet-test>
 <CALMp9eTGXDDfVspFwFyEhagg9sdnqZqzSQhDksT0bkKzVNGSqw@mail.gmail.com>
 <20190815163844.GD27076@linux.intel.com>
 <20190816133130.GA14380@local-michael-cet-test.sh.intel.com>
 <CALMp9eRDhbxkFNqY-+GOMtfg+guafdKcCNq1OJt9UgnyFVvSGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRDhbxkFNqY-+GOMtfg+guafdKcCNq1OJt9UgnyFVvSGw@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 16, 2019 at 11:19:46AM -0700, Jim Mattson wrote:
> On Fri, Aug 16, 2019 at 6:29 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
> 
> > Thanks Jim and Sean! Could we add a new flag in kvm to identify if nested VM is on
> > or off? That would make things easier. When VMLAUNCH is trapped,
> > set the flag, if VMXOFF is trapped, clear the flag.
> 
> KVM_GET_NESTED_STATE has the requested information. If
> data.vmx.vmxon_pa is anything other than -1, then the vCPU is in VMX
> operation. If (flags & KVM_STATE_NESTED_GUEST_MODE), then L2 is
> active.
Thanks Jim, I'll reference the code and make necessary change in next
SPP patch release.
