Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F67127860
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 10:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfLTJkJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 04:40:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28732 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727184AbfLTJkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 04:40:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576834808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f6gkvnmHOHnnQtY9YqOUolL8GxoaIgGs7cHhEOfuytM=;
        b=f58ZPAIOuw+HNTfx97vkvG9za3I3qtxcGrnL04fmiZLESgfdb9Dwvg4tzCJTptRmjW1y1q
        S5sopmQ7wVgRILpYdPYZaZ3sRh0CLcBt/MwDGxmvzaBXGXiZmkpviXXddQ7D3r/7IVHop2
        tL/+MEtdkLopqqFC/NbGa6K26r+NfaM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-AzxPIcihMEelTILQfEH-ag-1; Fri, 20 Dec 2019 04:40:03 -0500
X-MC-Unique: AzxPIcihMEelTILQfEH-ag-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1D5164A93;
        Fri, 20 Dec 2019 09:40:00 +0000 (UTC)
Received: from gondolin (dhcp-192-245.str.redhat.com [10.33.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3C785C1B2;
        Fri, 20 Dec 2019 09:39:54 +0000 (UTC)
Date:   Fri, 20 Dec 2019 10:39:52 +0100
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
Subject: Re: [PATCH v2 31/45] KVM: Unexport kvm_vcpu_cache and
 kvm_vcpu_{un}init()
Message-ID: <20191220103952.0a28c91d.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-32-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
        <20191218215530.2280-32-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Dec 2019 13:55:16 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Unexport kvm_vcpu_cache and kvm_vcpu_{un}init() and make them static
> now that they are referenced only in kvm_main.c.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  include/linux/kvm_host.h | 4 ----
>  virt/kvm/kvm_main.c      | 9 +++------
>  2 files changed, 3 insertions(+), 10 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

