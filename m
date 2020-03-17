Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912D2188CBB
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 19:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCQSBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 14:01:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:35726 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgCQSBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 14:01:49 -0400
IronPort-SDR: QS7pZbrx2b2Pmq3fRqmF/Myumwsxv8i+GFLz1TWn79SwnqgzmN3RnjConRNhIPQnjKCh06Q/oJ
 66IQsjuP9QmQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2020 11:01:49 -0700
IronPort-SDR: nOfsC76XQ1WDbFiy/0FAZfWWDTya/VZzhmHX8mQ4tRIWEKqILK6qQoJ4gGwk0DzR3nTiDJ5dOw
 Dngw68VPJkmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,565,1574150400"; 
   d="scan'208";a="443843092"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 17 Mar 2020 11:01:48 -0700
Date:   Tue, 17 Mar 2020 11:01:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 01/10] KVM: nVMX: Move reflection check into
 nested_vmx_reflect_vmexit()
Message-ID: <20200317180147.GB12959@linux.intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
 <20200312184521.24579-2-sean.j.christopherson@intel.com>
 <87k13opi6m.fsf@vitty.brq.redhat.com>
 <20200317053327.GR24267@linux.intel.com>
 <20200317161631.GD12526@linux.intel.com>
 <874kum533c.fsf@vitty.brq.redhat.com>
 <bd3fec03-c7c3-6c80-2dce-688340a1ae72@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd3fec03-c7c3-6c80-2dce-688340a1ae72@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 17, 2020 at 06:38:20PM +0100, Paolo Bonzini wrote:
> On 17/03/20 18:00, Vitaly Kuznetsov wrote:
> > 
> > On the other hand, I'm a great fan of splitting checkers ('pure'
> > functions) from actors (functions with 'side-effects') and
> > nested_vmx_exit_reflected() while looking like a checker does a lot of
> > 'acting': nested_mark_vmcs12_pages_dirty(), trace printk.
> 
> Good idea (trace_printk is not a big deal, but
> nested_mark_vmcs12_pages_dirty should be done outside).  I'll send a
> patch, just to show that I can still write KVM code. :)

LOL, don't jinx yourself.
