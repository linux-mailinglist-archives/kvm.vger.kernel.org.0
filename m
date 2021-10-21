Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF4A43625D
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 15:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbhJUNKu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 09:10:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:16751 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhJUNKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 09:10:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10143"; a="215946240"
X-IronPort-AV: E=Sophos;i="5.87,169,1631602800"; 
   d="scan'208";a="215946240"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2021 06:08:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,169,1631602800"; 
   d="scan'208";a="719492575"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga006.fm.intel.com with ESMTP; 21 Oct 2021 06:08:25 -0700
Message-ID: <8887f54e9265c29c38b29d63c64dc029def07ecd.camel@linux.intel.com>
Subject: Re: [PATCH v1 2/5] KVM: x86: nVMX: Update VMCS12 fields existence
 when nVMX MSRs are set
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Cc:     kvm@vger.kernel.org, yu.c.zhang@linux.intel.com
Date:   Thu, 21 Oct 2021 21:08:23 +0800
In-Reply-To: <cbe5d411-ba9b-0600-2c69-1f73f1d941df@redhat.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
         <1629192673-9911-3-git-send-email-robert.hu@linux.intel.com>
         <cbe5d411-ba9b-0600-2c69-1f73f1d941df@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-10-20 at 17:11 +0200, Paolo Bonzini wrote:
> On 17/08/21 11:31, Robert Hoo wrote:
> > +		vmcs12_field_update_by_vmexit_ctrl(vmx-
> > >nested.msrs.entry_ctls_high,
> > +				*highp, data >> 32,
> > +				vmx-
> > >nested.vmcs12_field_existence_bitmap);
> > +		break;
> > +	case MSR_IA32_VMX_TRUE_ENTRY_CTLS:
> > +		vmcs12_field_update_by_vmentry_ctrl(vmx-
> > >nested.msrs.exit_ctls_high,
> > +				*highp, data >> 32,
> > +				vmx-
> > >nested.vmcs12_field_existence_bitmap);
> 
> These two functions maybe could be merged into just one, since there
> are 
> going to be duplicate checks.

Can I keep them? I think this is trivial, and separating them looks
more clear, from logical perspective.:-)

A summary question:
am I going to send v2? since I'm not sure about Sean and Jim's decision
on whether to implement the interaction with shadow VMCS (which will
have to consume 8KiB more memory for each vmx).
And, Jim mentioned they have some virtualizing shadow vmcs patches
which is going to be sent to community. Should I wait for their
patches?
> 
> Paolo
> 

