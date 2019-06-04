Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0B1C33D6A
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 05:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfFDDM3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 23:12:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:23418 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbfFDDM3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 23:12:29 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 20:12:28 -0700
X-ExtLoop1: 1
Received: from richard.sh.intel.com (HELO localhost) ([10.239.159.54])
  by orsmga006.jf.intel.com with ESMTP; 03 Jun 2019 20:12:27 -0700
Date:   Tue, 4 Jun 2019 11:11:58 +0800
From:   Wei Yang <richardw.yang@linux.intel.com>
To:     Wei Yang <richardw.yang@linux.intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com
Subject: Re: [PATCH 1/3] kvm: x86: check kvm_apic_sw_enabled() is enough
Message-ID: <20190604031158.GB27794@richard>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
References: <20190401021723.5682-1-richardw.yang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190401021723.5682-1-richardw.yang@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ping...

On Mon, Apr 01, 2019 at 10:17:21AM +0800, Wei Yang wrote:
>On delivering irq to apic, we iterate on vcpu and do the check like
>this:
>
>    kvm_apic_present(vcpu)
>    kvm_lapic_enabled(vpu)
>        kvm_apic_present(vcpu) && kvm_apic_sw_enabled(vcpu->arch.apic)
>
>Since we have already checked kvm_apic_present(), it is reasonable to
>replace kvm_lapic_enabled() with kvm_apic_sw_enabled().
>
>Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
>---
> arch/x86/kvm/irq_comm.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
>index 3cc3b2d130a0..188beb301cc5 100644
>--- a/arch/x86/kvm/irq_comm.c
>+++ b/arch/x86/kvm/irq_comm.c
>@@ -86,7 +86,7 @@ int kvm_irq_delivery_to_apic(struct kvm *kvm, struct kvm_lapic *src,
> 			if (r < 0)
> 				r = 0;
> 			r += kvm_apic_set_irq(vcpu, irq, dest_map);
>-		} else if (kvm_lapic_enabled(vcpu)) {
>+		} else if (kvm_apic_sw_enabled(vcpu->arch.apic)) {
> 			if (!kvm_vector_hashing_enabled()) {
> 				if (!lowest)
> 					lowest = vcpu;
>-- 
>2.19.1

-- 
Wei Yang
Help you, Help me
