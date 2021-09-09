Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22464056FD
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 15:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355434AbhIIN1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 09:27:25 -0400
Received: from 8bytes.org ([81.169.241.247]:53378 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358084AbhIINYm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 09:24:42 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id A57C960F; Thu,  9 Sep 2021 15:23:26 +0200 (CEST)
Date:   Thu, 9 Sep 2021 15:22:51 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev,
        Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH v2 1/4] KVM: SVM: Get rid of *ghcb_msr_bits() functions
Message-ID: <YToKq31QIrXQFn7X@8bytes.org>
References: <20210722115245.16084-1-joro@8bytes.org>
 <20210722115245.16084-2-joro@8bytes.org>
 <YS/sqmgbS6ACRfSD@google.com>
 <YS/xSIvhS5GySXlQ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YS/xSIvhS5GySXlQ@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Wed, Sep 01, 2021 at 09:31:52PM +0000, Sean Christopherson wrote:
> On Wed, Sep 01, 2021, Sean Christopherson wrote:
> > 		control->ghcb_gpa = MAKE_GHCB_MSR_RESP(cpuid_reg, cpuid_value);

Made that change, but kept the set_ghcb_msr_cpuid_resp() and renamed it
to ghcb_msr_cpuid_resp(). It now returns the MSR value for the CPUID
response.

I like the keep the more complicated response setters as functions and
not macros for readability.


> 	case GHCB_MSR_SEV_INFO_REQ:
> 		control->ghcb_gpa = GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
> 						      GHCB_VERSION_MIN,
> 						      sev_enc_bit));
> 		break;
> 
> and drop set_ghcb_msr() altogether.

Makes sense, I replaced the set_ghcb_msr() calls with the above.

> Side topic, what about renaming control->ghcb_gpa => control->ghcb_msr so that
> the code for the MSR protocol is a bit more self-documenting?  The APM defines
> the field as "Guest physical address of GHCB", so it's not exactly prescribing a
> specific name.

No strong opinion here, I let this up to the AMD engineers to decide. If
we change the name I can add a separate patch for this.

Regards,

	Joerg
