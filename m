Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19550189F5B
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 16:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgCRPMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 11:12:10 -0400
Received: from mga14.intel.com ([192.55.52.115]:46274 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726777AbgCRPMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Mar 2020 11:12:09 -0400
IronPort-SDR: 98TVkXbuPITyPcknKzj31qmxOr71rNu50oGAoRxYNsbpwAODBVbjUSLPR3c4Ns/iGfRSfZEFu2
 r+2zDccqonVQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 08:12:09 -0700
IronPort-SDR: aP+LbHe6UFErjWb8JUE459Li2g3YoZfVUAvOe08po7fjQFcsC6u3sjHOCv3AVoy+SzmR9Hce4f
 Gx7qCvyv/W1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,568,1574150400"; 
   d="scan'208";a="444196681"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga005.fm.intel.com with ESMTP; 18 Mar 2020 08:12:08 -0700
Date:   Wed, 18 Mar 2020 08:12:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: remove side effects from
 nested_vmx_exit_reflected
Message-ID: <20200318151207.GA24357@linux.intel.com>
References: <1584468059-3585-1-git-send-email-pbonzini@redhat.com>
 <87tv2m2av4.fsf@vitty.brq.redhat.com>
 <803177a8-c5ef-ac5e-087b-52b09398d78c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <803177a8-c5ef-ac5e-087b-52b09398d78c@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 18, 2020 at 11:59:13AM +0100, Paolo Bonzini wrote:
> On 18/03/20 11:52, Vitaly Kuznetsov wrote:
> > The only functional difference seems to be that we're now doing
> > nested_mark_vmcs12_pages_dirty() in vmx->fail case too and this seems
> > superfluous: we failed to enter L2 so 'special' pages should remain
> > intact (right?) but this should be an uncommon case.
> > 
> > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> I'm not entirely sure if the PID could be written before the processor
> decrees a vmfail.  It doesn't really hurt anyway as you say though.

I would expect that writing special pages on VM-Fail would be classified
as a CPU bug.
