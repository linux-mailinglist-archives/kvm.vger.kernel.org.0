Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C72E8127915
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 11:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfLTKQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 05:16:38 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47848 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727129AbfLTKQi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 05:16:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576836997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+PzIuYiHMsqvNdlt2YJSoIUgUD4Ah16g2x1kpChg64c=;
        b=a2CSRPf7w1fav7Mi2gqayy8t90Ku2Z1vZnzrlSsjk9502iu9Crr6BjbS9cBBZ9PJvKoqNF
        q4q0D1pA9DlvcxL80OuQmlkx9NAV/67L/Oah2gTdfx8YrIP9CqvI3ishy0uhHS2AXh1zxV
        ip2DmReYeIGrONBfJu25nVGI1TeaEmA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-bGcYOmVjOo6uYa_m4PEfLQ-1; Fri, 20 Dec 2019 05:16:36 -0500
X-MC-Unique: bGcYOmVjOo6uYa_m4PEfLQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5909118FE860;
        Fri, 20 Dec 2019 10:16:33 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B61B383;
        Fri, 20 Dec 2019 10:16:27 +0000 (UTC)
Date:   Fri, 20 Dec 2019 11:16:24 +0100
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
Subject: Re: [PATCH v2 44/45] KVM: Move putting of vcpu->pid to
 kvm_vcpu_destroy()
Message-ID: <20191220111624.47e15479.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-45-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
        <20191218215530.2280-45-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Dec 2019 13:55:29 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Move the putting of vcpu->pid to kvm_vcpu_destroy().  vcpu->pid is
> guaranteed to be NULL when kvm_vcpu_uninit() is called in the error path
> of kvm_vm_ioctl_create_vcpu(), e.g. it is explicitly nullified by
> kvm_vcpu_init() and is only changed by KVM_RUN.
> 
> No functional change intended.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  virt/kvm/kvm_main.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

