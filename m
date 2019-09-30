Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B84C26EC
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 22:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbfI3UnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 16:43:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:52977 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726576AbfI3UnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 16:43:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 10:20:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,568,1559545200"; 
   d="scan'208";a="195387689"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 30 Sep 2019 10:20:38 -0700
Date:   Mon, 30 Sep 2019 10:20:38 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>, tao3.xu@intel.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: Remove proprietary handling of unexpected
 exit-reasons
Message-ID: <20190930172038.GE14693@linux.intel.com>
References: <20190929145018.120753-1-liran.alon@oracle.com>
 <874l0u5jb4.fsf@vitty.brq.redhat.com>
 <CALMp9eS7wF1b6yBJrj_VL+HMEYjuZrYhmMHiCqJq8-33d9QE6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eS7wF1b6yBJrj_VL+HMEYjuZrYhmMHiCqJq8-33d9QE6A@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 09:35:59AM -0700, Jim Mattson wrote:
> On Mon, Sep 30, 2019 at 12:34 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >
> > Liran Alon <liran.alon@oracle.com> writes:
> >
> > > Commit bf653b78f960 ("KVM: vmx: Introduce handle_unexpected_vmexit
> > > and handle WAITPKG vmexit") introduced proprietary handling of
> > > specific exit-reasons that should not be raised by CPU because
> > > KVM configures VMCS such that they should never be raised.
> > >
> > > However, since commit 7396d337cfad ("KVM: x86: Return to userspace
> > > with internal error on unexpected exit reason"), VMX & SVM
> > > exit handlers were modified to generically handle all unexpected
> > > exit-reasons by returning to userspace with internal error.
> > >
> > > Therefore, there is no need for proprietary handling of specific
> > > unexpected exit-reasons (This proprietary handling also introduced
> > > inconsistency for these exit-reasons to silently skip guest instruction
> > > instead of return to userspace on internal-error).
> > >
> > > Fixes: bf653b78f960 ("KVM: vmx: Introduce handle_unexpected_vmexit and handle WAITPKG vmexit")
> > >
> > > Signed-off-by: Liran Alon <liran.alon@oracle.com>
> >
> > (It's been awhile since in software world the word 'proprietary' became
> > an opposite of free/open-source to me so I have to admit your subject
> > line really got me interested :-)
> >
> > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> I agree that proprietary is an unusual word choice.

It's one way to get quick reviews though :-)
