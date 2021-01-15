Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8F42F7FC0
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 16:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbhAOPib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 10:38:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52654 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725910AbhAOPia (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 10:38:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610725023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BfcFWEUkq1XDvrKtOfvXgBhHwBlztowWw4UTv6iuSJY=;
        b=iDUWGMJ36bFEaOZ3JD6E9wZXd/fHCTY85PGaswM2etl5f+p7ktBOOe4Gl9dw7ZttcTpcg8
        fk/SZJzfPld+zFpWXJ/1yncR2q7BmUiPKLfAhhnesZ3bdCsV665Ztz878+kr/+tA95LQVf
        JzcUGt5IxkJQziG2DYaEF/UEKj6+nR0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-7_VsT0NsPqC4bV3TWIZRhg-1; Fri, 15 Jan 2021 10:37:02 -0500
X-MC-Unique: 7_VsT0NsPqC4bV3TWIZRhg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A667C80A5C0;
        Fri, 15 Jan 2021 15:36:59 +0000 (UTC)
Received: from gondolin (ovpn-114-124.ams2.redhat.com [10.36.114.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1405E5C3E9;
        Fri, 15 Jan 2021 15:36:48 +0000 (UTC)
Date:   Fri, 15 Jan 2021 16:36:46 +0100
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
Subject: Re: [PATCH v7 09/13] confidential guest support: Update
 documentation
Message-ID: <20210115163646.2ecdc329.cohuck@redhat.com>
In-Reply-To: <20210113235811.1909610-10-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
        <20210113235811.1909610-10-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 10:58:07 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> Now that we've implemented a generic machine option for configuring various
> confidential guest support mechanisms:
>   1. Update docs/amd-memory-encryption.txt to reference this rather than
>      the earlier SEV specific option
>   2. Add a docs/confidential-guest-support.txt to cover the generalities of
>      the confidential guest support scheme
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  docs/amd-memory-encryption.txt      |  2 +-
>  docs/confidential-guest-support.txt | 43 +++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+), 1 deletion(-)
>  create mode 100644 docs/confidential-guest-support.txt
> 
> diff --git a/docs/amd-memory-encryption.txt b/docs/amd-memory-encryption.txt
> index 80b8eb00e9..145896aec7 100644
> --- a/docs/amd-memory-encryption.txt
> +++ b/docs/amd-memory-encryption.txt
> @@ -73,7 +73,7 @@ complete flow chart.
>  To launch a SEV guest
>  
>  # ${QEMU} \
> -    -machine ...,memory-encryption=sev0 \
> +    -machine ...,confidential-guest-support=sev0 \
>      -object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=1
>  
>  Debugging
> diff --git a/docs/confidential-guest-support.txt b/docs/confidential-guest-support.txt
> new file mode 100644
> index 0000000000..2790425b38
> --- /dev/null
> +++ b/docs/confidential-guest-support.txt

Maybe make this a proper .rst from the start and hook this up into the
system guide? It is already almost there.

> @@ -0,0 +1,43 @@
> +Confidential Guest Support
> +==========================
> +
> +Traditionally, hypervisors such as qemu have complete access to a

s/qemu/QEMU/ ?

> +guest's memory and other state, meaning that a compromised hypervisor
> +can compromise any of its guests.  A number of platforms have added
> +mechanisms in hardware and/or firmware which give guests at least some
> +protection from a compromised hypervisor.  This is obviously
> +especially desirable for public cloud environments.
> +
> +These mechanisms have different names and different modes of
> +operation, but are often referred to as Secure Guests or Confidential
> +Guests.  We use the term "Confidential Guest Support" to distinguish
> +this from other aspects of guest security (such as security against
> +attacks from other guests, or from network sources).
> +
> +Running a Confidential Guest
> +----------------------------
> +
> +To run a confidential guest you need to add two command line parameters:
> +
> +1. Use "-object" to create a "confidential guest support" object.  The
> +   type and parameters will vary with the specific mechanism to be
> +   used
> +2. Set the "confidential-guest-support" machine parameter to the ID of
> +   the object from (1).
> +
> +Example (for AMD SEV)::
> +
> +    qemu-system-x86_64 \
> +        <other parameters> \
> +        -machine ...,confidential-guest-support=sev0 \
> +        -object sev-guest,id=sev0,cbitpos=47,reduced-phys-bits=1
> +
> +Supported mechanisms
> +--------------------
> +
> +Currently supported confidential guest mechanisms are:
> +
> +AMD Secure Encrypted Virtualization (SEV)
> +    docs/amd-memory-encryption.txt
> +
> +Other mechanisms may be supported in future.

LGTM.

