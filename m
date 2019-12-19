Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB9B1126E30
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 20:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfLSTrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 14:47:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59745 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726897AbfLSTrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 14:47:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576784868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7s8aSCvp52Fcz2Wx/tS6wh/olyKy8a3YGMnOjn2uv8E=;
        b=KxYT5OwG6aazsdc6iH1JX2B+zsw1tJNHBss9X0G3QLQo+t8RYy/AuwVzSFfhDJiXfuW2v9
        +1hVX51fB3zj1kL9bkmX9mUvhlM0IMo6QJzwc1jq2iXk536f0xGIC6iNn2s8Dxc27UNvs3
        wUwbRa0iCiEIEkPv6YiSuisXAILwV0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198--uvnZKzHMz6b8tS9keq1SQ-1; Thu, 19 Dec 2019 14:47:46 -0500
X-MC-Unique: -uvnZKzHMz6b8tS9keq1SQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30A4C1856A60;
        Thu, 19 Dec 2019 19:47:44 +0000 (UTC)
Received: from gondolin (ovpn-117-134.ams2.redhat.com [10.36.117.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E3D610021B2;
        Thu, 19 Dec 2019 19:47:36 +0000 (UTC)
Date:   Thu, 19 Dec 2019 20:47:33 +0100
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
Subject: Re: [PATCH v2 26/45] KVM: s390: Invoke kvm_vcpu_init() before
 allocating sie_page
Message-ID: <20191219204733.791f7380.cohuck@redhat.com>
In-Reply-To: <20191218215530.2280-27-sean.j.christopherson@intel.com>
References: <20191218215530.2280-1-sean.j.christopherson@intel.com>
        <20191218215530.2280-27-sean.j.christopherson@intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Dec 2019 13:55:11 -0800
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> Now that s390's implementation of kvm_arch_vcpu_init() is empty, move
> the call to kvm_vcpu_init() above the allocation of the sie_page.  This
> paves the way for moving vcpu allocation and initialization into common
> KVM code without any associated functional change.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)

Seems to be fine.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

