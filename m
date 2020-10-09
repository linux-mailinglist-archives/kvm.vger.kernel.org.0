Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B8D288759
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 12:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731938AbgJIKyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 06:54:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34762 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725931AbgJIKyQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Oct 2020 06:54:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602240855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UfUFjLKWmN3RUQmEbSIjpCLVxhLYAyziDiVSdthP/tw=;
        b=azKuaQvR2cCdPfqCuSxohXHod1XqfjMmav0pqVAbAU+Bz9JdmrF9Mu5p4V6qaJJPbbePsl
        urZanzcwbmya5aChBtOt+IQHbo4x5Fk1/cZX/QHotUUZKnFHkomW6mkj2/ya7wmAE/bcUm
        6MAtwFMUKW3BRRC0/eAcOG0okqoC+jc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-TVqV_hQTORK67XsAG63rVA-1; Fri, 09 Oct 2020 06:54:13 -0400
X-MC-Unique: TVqV_hQTORK67XsAG63rVA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B66A78030C8;
        Fri,  9 Oct 2020 10:54:11 +0000 (UTC)
Received: from gondolin (ovpn-113-40.ams2.redhat.com [10.36.113.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A72815D9E8;
        Fri,  9 Oct 2020 10:54:00 +0000 (UTC)
Date:   Fri, 9 Oct 2020 12:53:57 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        rth@twiddle.net, david@redhat.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, pbonzini@redhat.com,
        alex.williamson@redhat.com, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 06/10] s390x/pci: use a PCI Group structure
Message-ID: <20201009125357.5da021cf.cohuck@redhat.com>
In-Reply-To: <1602097455-15658-7-git-send-email-mjrosato@linux.ibm.com>
References: <1602097455-15658-1-git-send-email-mjrosato@linux.ibm.com>
        <1602097455-15658-7-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed,  7 Oct 2020 15:04:11 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> From: Pierre Morel <pmorel@linux.ibm.com>
> 
> We use a S390PCIGroup structure to hold the information related to a
> zPCI Function group.
> 
> This allows us to be ready to support multiple groups and to retrieve
> the group information from the host.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  hw/s390x/s390-pci-bus.c         | 42 +++++++++++++++++++++++++++++++++++++++++
>  hw/s390x/s390-pci-inst.c        | 23 +++++++++++++---------
>  include/hw/s390x/s390-pci-bus.h | 10 ++++++++++
>  3 files changed, 66 insertions(+), 9 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

