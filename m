Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 934DB19286F
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 13:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgCYMbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 08:31:16 -0400
Received: from 8bytes.org ([81.169.241.247]:55582 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgCYMbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 08:31:16 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 5BADC2CC; Wed, 25 Mar 2020 13:31:14 +0100 (CET)
Date:   Wed, 25 Mar 2020 13:31:12 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: SVM: Move and split up svm.c
Message-ID: <20200325123112.GB18178@8bytes.org>
References: <20200324094154.32352-1-joro@8bytes.org>
 <20200324183007.GA7798@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324183007.GA7798@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 24, 2020 at 11:30:07AM -0700, Sean Christopherson wrote:
> What are people's thoughts on using "arch/x86/kvm/{amd,intel}" instead of
> "arch/x86/kvm/{svm,vmx}"?  Maybe this won't be an issue for AMD/SVM, but on
> the Intel/VMX side, there is stuff in the pipeline that makes using "vmx"
> for the sub-directory quite awkward.  I wasn't planning on proposing the
> rename (from vmx->intel) until I could justify _why_, but perhaps it makes
> sense to bundle all the pain of a reorganizing code into a single kernel
> version?

I am fine either way, naming the directory amd/ or svm/ doesn't make a
big difference.

Regards,

	Joerg
