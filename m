Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 068511278CC
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 11:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfLTKGi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 05:06:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38249 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727298AbfLTKGf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 05:06:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576836394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TJRAO3L22Ih+Pz3y1jOIE97EY53hqHdNJLLu6DqeuvU=;
        b=DQ87E3uKlcmKSmYWWnszQbwsu7l7Jux6fhXJxrQ4J70EMxD5faikeocPsPB6gM2V883zS4
        usYAwEP7H2n3OoC+US/AqRz8SXdFdzVVArs+CLZlCJQyJFKJoNcVkxtwmhKspKT0sr8Aau
        QCgNCQ6a2gxjOcBmghbZtM0MLnYkMOI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-Q-jcCQ3WOJCPBNkNsbH44Q-1; Fri, 20 Dec 2019 05:06:30 -0500
X-MC-Unique: Q-jcCQ3WOJCPBNkNsbH44Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E665694D13;
        Fri, 20 Dec 2019 10:06:26 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B2431001B00;
        Fri, 20 Dec 2019 10:06:20 +0000 (UTC)
Date:   Fri, 20 Dec 2019 11:06:18 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kurz <groug@kaod.org>
Subject: Re: [PATCH v2 37/45] KVM: Drop kvm_arch_vcpu_setup()
Message-ID: <20191220110618.05b1dc86.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-38-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
        <20191218215530.2280-38-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Dec 2019 13:55:22 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Remove kvm_arch_vcpu_setup() now that all arch specific implementations
> are nops.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/arm/kvm/guest.c      | 5 -----
>  arch/arm64/kvm/guest.c    | 5 -----
>  arch/mips/kvm/mips.c      | 5 -----
>  arch/powerpc/kvm/book3s.c | 5 -----
>  arch/powerpc/kvm/booke.c  | 5 -----
>  arch/s390/kvm/kvm-s390.c  | 5 -----
>  arch/x86/kvm/x86.c        | 5 -----
>  include/linux/kvm_host.h  | 1 -
>  virt/kvm/kvm_main.c       | 5 -----
>  9 files changed, 41 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

