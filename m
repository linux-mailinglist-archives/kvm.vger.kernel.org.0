Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C783D6A60
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 21:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728816AbfJNTw1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 15:52:27 -0400
Received: from mga12.intel.com ([192.55.52.136]:8445 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfJNTw1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 15:52:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 12:52:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="208032408"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 14 Oct 2019 12:52:27 -0700
Date:   Mon, 14 Oct 2019 12:52:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Liran Alon <liran.alon@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Cross <dcross@google.com>, Peter Shier <pshier@google.com>
Subject: Re: [PATCH v3] KVM: nVMX: Don't leak L1 MMIO regions to L2
Message-ID: <20191014195226.GJ22962@linux.intel.com>
References: <20191010232819.135894-1-jmattson@google.com>
 <20191014175936.GD22962@linux.intel.com>
 <CALMp9eS_fYjyTDG75316cdyCp6NRHAHmN2J+sTf9uxvUfiEsQA@mail.gmail.com>
 <20191014191522.GG22962@linux.intel.com>
 <CALMp9eS-xPS2DYK10L_QYkEufUUoTAJU0++rqMEQkSRgu-4KpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eS-xPS2DYK10L_QYkEufUUoTAJU0++rqMEQkSRgu-4KpA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 14, 2019 at 12:37:39PM -0700, Jim Mattson wrote:
> On Mon, Oct 14, 2019 at 12:15 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Mon, Oct 14, 2019 at 11:50:37AM -0700, Jim Mattson wrote:
> > > NESTED_VMX_ENTER_NON_ROOT_MODE_STATUS_KVM_INTERNAL_ERROR?
> >
> > I can't tell if you're making fun of me for being pedantic about "Enter VMX",
> > or if you really want to have a 57 character enum.  :-)
> >
> > NESTED_VMENTER_?
> 
> It's difficult to balance brevity and clarity. I have no problem with
> 57 character enums, but I understand that Linux line-wrapping
> conventions are designed for the VT100, so long enums present a
> challenge. :-)

Heh, the real problem is that I forgot what I was reading by the time I
got to "STATUS".

> How about:
> 
> NVMX_VMENTRY_SUCCESS
> NVMX_VMENTRY_VMFAIL
> NVMX_VMENTRY_VMEXIT
> NVMX_VMENTRY_INTERNAL_ERROR

Works for me.  Maybe NVMX_VMENTRY_KVM_INTERNAL_ERROR to be consistent?
