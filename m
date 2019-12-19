Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59059126E13
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 20:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfLSTji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 14:39:38 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42864 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727285AbfLSTji (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Dec 2019 14:39:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576784376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=prVadGfe425gEg8krjR8jjvWKpR2WFGHzNs5x3wZo7U=;
        b=iZqCbtysBzGyEUiLUn24bdfzkZpVaG2pNR0u88O83h4VMMktmQCs4BwR92SsIyIDRnUbcF
        ygbfxZpX+eTZr6u/krzjjUn2RhF4ePQy20ioCpN0K6vqjNDKwhQDS/cpVyK4zCPByPYZY+
        3QtxTl/opb4S07VTQ031ScFt2W36J5w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-jCat3nvKPdKu8c4bFYo-KA-1; Thu, 19 Dec 2019 14:39:32 -0500
X-MC-Unique: jCat3nvKPdKu8c4bFYo-KA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 944D8108594D;
        Thu, 19 Dec 2019 19:39:29 +0000 (UTC)
Received: from gondolin (ovpn-117-134.ams2.redhat.com [10.36.117.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74E355D9E2;
        Thu, 19 Dec 2019 19:39:20 +0000 (UTC)
Date:   Thu, 19 Dec 2019 20:39:17 +0100
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
Subject: Re: [PATCH v2 25/45] KVM: s390: Move guts of kvm_arch_vcpu_init()
 into kvm_arch_vcpu_create()
Message-ID: <20191219203917.79916aad.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-26-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
        <20191218215530.2280-26-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Dec 2019 13:55:10 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Move all of kvm_arch_vcpu_init(), which is invoked at the very end of
> kvm_vcpu_init(), into kvm_arch_vcpu_create() in preparation of moving
> the call to kvm_vcpu_init().  Moving kvm_vcpu_init() is itself a
> preparatory step for moving allocation and initialization to common KVM
> code.
> 
> No functional change inteded.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 62 ++++++++++++++++++++++------------------
>  1 file changed, 34 insertions(+), 28 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

