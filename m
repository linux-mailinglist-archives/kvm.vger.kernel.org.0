Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D19A127963
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 11:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfLTKbG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 05:31:06 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29582 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727180AbfLTKbG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Dec 2019 05:31:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576837865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hXRURjDIno09T/7uerhfWk5aEa64vSqR0QJi3eOkKRg=;
        b=TSszHccR7g0oCzCDbq75qFw7a5MPliVJf4rI8b+boVhOOKz5/nuQwDzFGU9Kydr4glXjzS
        J+KavhpEbdQQuAG7pLLfvjNxWweEC+Nyap6CcSw4bD/8yyK16JzXv9PGruBekzE+JEWIRN
        DuTrGA8OTBbc6sCpG9c29C9EwtRcP/k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-acyk5wgqMtGGRknL5kTE3g-1; Fri, 20 Dec 2019 05:30:58 -0500
X-MC-Unique: acyk5wgqMtGGRknL5kTE3g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21A67107ACC4;
        Fri, 20 Dec 2019 10:30:56 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA6FF26FC5;
        Fri, 20 Dec 2019 10:30:49 +0000 (UTC)
Date:   Fri, 20 Dec 2019 11:30:47 +0100
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
Subject: Re: [PATCH v2 45/45] KVM: Move vcpu->run page allocation out of
 kvm_vcpu_init()
Message-ID: <20191220113047.2865074a.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-46-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
        <20191218215530.2280-46-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Dec 2019 13:55:30 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Open code the allocation and freeing of the vcpu->run page in
> kvm_vm_ioctl_create_vcpu() and kvm_vcpu_destroy() respectively.  Doing
> so allows kvm_vcpu_init() to be a pure init function and eliminates
> kvm_vcpu_uninit() entirely.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  virt/kvm/kvm_main.c | 34 +++++++++++++---------------------
>  1 file changed, 13 insertions(+), 21 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

