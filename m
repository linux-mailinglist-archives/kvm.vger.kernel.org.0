Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF5F2783CF
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 11:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbgIYJSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 05:18:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727428AbgIYJSH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 05:18:07 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601025486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zdNyfj6okx2W0CrZGKgNIYWl+PLE9oMxshn2W1/Qz+k=;
        b=Q2vT9869rer+gbOLhliJeC0GXNuBPt2hSyb5c3k2omDDn/J3wnQjZrxtrGehtK18Be+UbH
        p+tP67Azow2WCdF5vUKxNo6k7EelzTA09kAbAleVaxZY6/Na3Ctc6fsRSNLWNTlGIMI1uF
        sNbmhCpYxB/cfEj9ThFS0s13SBcUOL0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-HqoZG-fBNeqlt1m3Ax7ZHg-1; Fri, 25 Sep 2020 05:18:02 -0400
X-MC-Unique: HqoZG-fBNeqlt1m3Ax7ZHg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54F131091068;
        Fri, 25 Sep 2020 09:18:00 +0000 (UTC)
Received: from gondolin (ovpn-112-192.ams2.redhat.com [10.36.112.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 083AD5D9F1;
        Fri, 25 Sep 2020 09:17:48 +0000 (UTC)
Date:   Fri, 25 Sep 2020 11:17:46 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH 3/7] s390x/pci: create a header dedicated to PCI CLP
Message-ID: <20200925111746.2e3bf28f.cohuck@redhat.com>
In-Reply-To: <1600529672-10243-4-git-send-email-mjrosato@linux.ibm.com>
References: <1600529672-10243-1-git-send-email-mjrosato@linux.ibm.com>
        <1600529672-10243-4-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 19 Sep 2020 11:34:28 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> From: Pierre Morel <pmorel@linux.ibm.com>
> 
> To have a clean separation between s390-pci-bus.h and s390-pci-inst.h
> headers we export the PCI CLP instructions in a dedicated header.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/s390x/s390-pci-bus.h  |   1 +
>  hw/s390x/s390-pci-clp.h  | 211 +++++++++++++++++++++++++++++++++++++++++++++++
>  hw/s390x/s390-pci-inst.h | 196 -------------------------------------------
>  3 files changed, 212 insertions(+), 196 deletions(-)
>  create mode 100644 hw/s390x/s390-pci-clp.h

Looks sane; but I wonder whether we should move the stuff under
include/hw/s390x/.

