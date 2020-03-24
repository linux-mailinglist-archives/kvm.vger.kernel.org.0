Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9BB9190344
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 02:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgCXBTA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 21:19:00 -0400
Received: from ozlabs.org ([203.11.71.1]:57285 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbgCXBS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 21:18:59 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 48mYL92hc1z9sSL; Tue, 24 Mar 2020 12:18:57 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1585012737; bh=fWyvQjgmoVE45UQb8yBNTXiPed69yDbrhs5hdq0egsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mauSiS7oX6+4B1f4axm7Ayy0Hc0K4hbGipg06Vcls1bvNoep91a4i3dcGDcZKVpTJ
         xQC/JEjuilfLaSd1tD8NcDipXJjAbo7uhRcrYKD9LE8of4vea9QfKCKUAAkkdF/Uz7
         Dm7c/6XLcWYDVEm/PsidIOCTDafYwb4ENnFnDtX0zf2M52X8TbyUepK8RCjm3hj5Lu
         u8f6BSKtFagIKKzXfDcwdZegidVRR/Rw5iEGwGP+42XDZ08MSFz0spgTcZk9vvMJUq
         WBwqbuf0TPBzwB0coc1LPf1cCR+z4iTVCk1La6TvnzTrCQ1Bv8TD6+qUuXAoP37xGr
         j9GwIDroxtTsA==
Date:   Tue, 24 Mar 2020 12:18:54 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/9] KVM: Pass kvm_init()'s opaque param to additional
 arch funcs
Message-ID: <20200324011854.GC5604@blackberry>
References: <20200321202603.19355-1-sean.j.christopherson@intel.com>
 <20200321202603.19355-2-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321202603.19355-2-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 21, 2020 at 01:25:55PM -0700, Sean Christopherson wrote:
> Pass @opaque to kvm_arch_hardware_setup() and
> kvm_arch_check_processor_compat() to allow architecture specific code to
> reference @opaque without having to stash it away in a temporary global
> variable.  This will enable x86 to separate its vendor specific callback
> ops, which are passed via @opaque, into "init" and "runtime" ops without
> having to stash away the "init" ops.
> 
> No functional change intended.
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Tested-by: Cornelia Huck <cohuck@redhat.com> #s390
> Acked-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Acked-by: Paul Mackerras <paulus@ozlabs.org>
