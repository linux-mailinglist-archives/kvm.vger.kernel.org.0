Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3196C2F7C40
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 14:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732166AbhAONNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 08:13:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732120AbhAONNx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 08:13:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610716346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l9fXm6PPPytnm4X+drUEowhAwhc1PIGmNS4VUkDa6wg=;
        b=MFbkoPNCAb9qWEAkRBf+GWVfSAk7a9NMjZ1CV5LorjqxzIAMtymgZR6D2WF5MmBPYEAStR
        lXDlaNA/mf2EyqUcwaU8vNlCdMgh5K8z1VLFc/IW2oZOAwh2UfpkvmnTab6N3Oz0nL9rLw
        VL2kcmHY1xC62xWjsEq7UcxpJ6IRoz8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-c81pM68aPjCAqH9mEECO-A-1; Fri, 15 Jan 2021 08:12:25 -0500
X-MC-Unique: c81pM68aPjCAqH9mEECO-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 878C61015C83;
        Fri, 15 Jan 2021 13:12:22 +0000 (UTC)
Received: from gondolin (ovpn-114-124.ams2.redhat.com [10.36.114.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7D78D6F7E5;
        Fri, 15 Jan 2021 13:12:10 +0000 (UTC)
Date:   Fri, 15 Jan 2021 14:12:07 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        pasic@linux.ibm.com, qemu-devel@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Hildenbrand <david@redhat.com>, borntraeger@de.ibm.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, mst@redhat.com,
        jun.nakajima@intel.com, thuth@redhat.com,
        pragyansri.pathi@intel.com, kvm@vger.kernel.org,
        Eduardo Habkost <ehabkost@redhat.com>, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org, frankja@linux.ibm.com,
        Greg Kurz <groug@kaod.org>, mdroth@linux.vnet.ibm.com,
        berrange@redhat.com, andi.kleen@intel.com
Subject: Re: [PATCH v7 07/13] confidential guest support: Introduce cgs
 "ready" flag
Message-ID: <20210115141207.379997a9.cohuck@redhat.com>
In-Reply-To: <20210113235811.1909610-8-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
        <20210113235811.1909610-8-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 10:58:05 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> The platform specific details of mechanisms for implementing
> confidential guest support may require setup at various points during
> initialization.  Thus, it's not really feasible to have a single cgs
> initialization hook, but instead each mechanism needs its own
> initialization calls in arch or machine specific code.
> 
> However, to make it harder to have a bug where a mechanism isn't
> properly initialized under some circumstances, we want to have a
> common place, relatively late in boot, where we verify that cgs has
> been initialized if it was requested.
> 
> This patch introduces a ready flag to the ConfidentialGuestSupport
> base type to accomplish this, which we verify just before the machine
> specific initialization function.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  hw/core/machine.c                         | 8 ++++++++
>  include/exec/confidential-guest-support.h | 2 ++
>  target/i386/sev.c                         | 2 ++
>  3 files changed, 12 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

