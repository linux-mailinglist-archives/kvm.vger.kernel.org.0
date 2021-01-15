Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69ED02F7B1A
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732544AbhAOM6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:58:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387406AbhAOM57 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 07:57:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610715392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NfzysKlTj5st1xcFMl1oLSiDESXibEg7nkCMhCh1EY4=;
        b=izoM86PY4pJbkBR/T3iEdQF0orj7tJ89dayqGCo083s/NBF//PZnqjh/CBE32l+ilsisvf
        zYqlw62A1Guqo0W4Y8iTXg47yujeAJqnjzc6xsI1sxdxRzvVoau9Wrk7O4XM/roGWJKRKp
        XdwtdX3gN2xX2c39iQv/avGMwAKsiHw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-i--ufkYEOuy-okm5AMtuvw-1; Fri, 15 Jan 2021 07:56:28 -0500
X-MC-Unique: i--ufkYEOuy-okm5AMtuvw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5763D100E437;
        Fri, 15 Jan 2021 12:56:26 +0000 (UTC)
Received: from gondolin (ovpn-114-124.ams2.redhat.com [10.36.114.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0057960C6F;
        Fri, 15 Jan 2021 12:56:10 +0000 (UTC)
Date:   Fri, 15 Jan 2021 13:56:07 +0100
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
Subject: Re: [PATCH v7 04/13] confidential guest support: Move side effect
 out of machine_set_memory_encryption()
Message-ID: <20210115135607.76003e1b.cohuck@redhat.com>
In-Reply-To: <20210113235811.1909610-5-david@gibson.dropbear.id.au>
References: <20210113235811.1909610-1-david@gibson.dropbear.id.au>
        <20210113235811.1909610-5-david@gibson.dropbear.id.au>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Jan 2021 10:58:02 +1100
David Gibson <david@gibson.dropbear.id.au> wrote:

> When the "memory-encryption" property is set, we also disable KSM
> merging for the guest, since it won't accomplish anything.
> 
> We want that, but doing it in the property set function itself is
> thereoretically incorrect, in the unlikely event of some configuration
> environment that set the property then cleared it again before
> constructing the guest.
> 
> More importantly, it makes some other cleanups we want more difficult.
> So, instead move this logic to machine_run_board_init() conditional on
> the final value of the property.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Greg Kurz <groug@kaod.org>
> ---
>  hw/core/machine.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

