Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580DF184C2A
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 17:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgCMQRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 12:17:11 -0400
Received: from mga03.intel.com ([134.134.136.65]:10933 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgCMQRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 12:17:11 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Mar 2020 09:17:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,549,1574150400"; 
   d="scan'208";a="416343823"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 13 Mar 2020 09:17:09 -0700
Date:   Fri, 13 Mar 2020 09:17:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 08/10] KVM: nVMX: Rename exit_reason to vm_exit_reason
 for nested VM-Exit
Message-ID: <20200313161709.GA5181@linux.intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
 <20200312184521.24579-9-sean.j.christopherson@intel.com>
 <87k13onyjw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k13onyjw.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 13, 2020 at 03:01:55PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Use "vm_exit_reason" when passing around the full exit reason for nested
> > VM-Exits to make it clear that it's not just the basic exit reason.  The
> > basic exit reason (bits 15:0 of vmcs.VM_EXIT_REASON) is colloquially
> > referred to as simply "exit reason", e.g. vmx_handle_vmexit() tracks the
> > basic exit reason in a local variable named "exit_reason".
> >
> 
> Would it make sense to stop using 'exit_reason' without a prefix (full,
> basic,...) completely?

I'd prefer to keep using exit_reason as a local variable.  Either that or
grab the whole union locally and use "exit_reason.basic".  

IMO, referring to the basic exit reason as simply "exit reason" is so
pervasive that it's reasonable to use exit_reason as a local variable.
