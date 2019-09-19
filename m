Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B99B700E
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 02:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387420AbfISAXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 20:23:38 -0400
Received: from ozlabs.org ([203.11.71.1]:35085 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730422AbfISAXf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 20:23:35 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46YcyX6FPFz9sNF; Thu, 19 Sep 2019 10:23:32 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1568852612; bh=cw3bVSIKyGLl8fd6W8ykuEcHQm9lvtEQ4ISh1Suv21A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R3NvO9RHRrBeHenKeGVQwRwaNzl90QJKU91Oh5UtKsnjPccYcuWsO/+sjMOyqwX7L
         qXGlMsp052mihy0ZJJ2eIVJLqlRGa9kQM/LgVKA7ED5dZy2xxDU0F7hWJ5Tp54i1Oj
         k55td7N92nS1j9aJa2rikaxwZ/Rett3ejrVCl2Y6XgJzt/d7qDn+ismHBncyRTAYV+
         hS8OCe+151b9IycINykjKDkPYC/8MG9vZUkPbnlESnKeZ09ZuP4shL0f/tklBl/8Uc
         RZALg8LGgjsbVJ+XmBlldREITO6j39TWleHK6T7JSCMg1LLpCOuW1Dvvlzw9Z/mO8v
         uxbb98hT109Jg==
Date:   Thu, 19 Sep 2019 10:23:28 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/13] KVM: PPC: Move memslot memory allocation into
 prepare_memory_region()
Message-ID: <20190919002328.GB19503@blackberry>
References: <20190911185038.24341-1-sean.j.christopherson@intel.com>
 <20190911185038.24341-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911185038.24341-3-sean.j.christopherson@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 11, 2019 at 11:50:27AM -0700, Sean Christopherson wrote:
> Allocate the rmap array during kvm_arch_prepare_memory_region() to pave
> the way for removing kvm_arch_create_memslot() altogether.  Moving PPC's
> memory allocation only changes the order of kernel memory allocations
> between PPC and common KVM code.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Seems OK.

Acked-by: Paul Mackerras <paulus@ozlabs.org>
