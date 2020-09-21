Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D11272AB3
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 17:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgIUPuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 11:50:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41913 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726810AbgIUPuG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 11:50:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600703405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CUf1Gg0Y+WlMrDlKmw0q+94Ta9Us++O5H2uXtIQPidc=;
        b=GKoh61h1kxMuZwqy+oNt2Wj/oDcMbAU4QzJ8xKx8y3B3luF8pIQeu9bUgY3aoPfr870Atr
        h03r5Z1NqWohH7kRrnyrchVQe7+lVsvY5DeZm6G5xE8bb/+Fb+F9k87hrlW5ozAFsDHtTZ
        k25N6YBF53PORCkCWX6UrQKpeaNdoGk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-_txek8QTMluRmPAeG7CPBw-1; Mon, 21 Sep 2020 11:50:01 -0400
X-MC-Unique: _txek8QTMluRmPAeG7CPBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BF311074647;
        Mon, 21 Sep 2020 15:49:59 +0000 (UTC)
Received: from gondolin (ovpn-115-117.ams2.redhat.com [10.36.115.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3666755765;
        Mon, 21 Sep 2020 15:49:54 +0000 (UTC)
Date:   Mon, 21 Sep 2020 17:49:51 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] s390/pci: stash version in the zpci_dev
Message-ID: <20200921174951.3b660003.cohuck@redhat.com>
In-Reply-To: <ea53b58a-74f0-2a10-3f08-dbcca512ef86@linux.ibm.com>
References: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
        <1600529318-8996-2-git-send-email-mjrosato@linux.ibm.com>
        <20200921170158.1080d872.cohuck@redhat.com>
        <ea53b58a-74f0-2a10-3f08-dbcca512ef86@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 21 Sep 2020 11:44:20 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> On 9/21/20 11:01 AM, Cornelia Huck wrote:
> > On Sat, 19 Sep 2020 11:28:35 -0400
> > Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> >   
> >> In preparation for passing the info on to vfio-pci devices, stash the
> >> supported PCI version for the target device in the zpci_dev.  
> > 
> > Hm, what kind of version is that? The version of the zPCI interface?
> > 
> > Inquiring minds want to know :)
> >   
> 
> Ha :) It's related to PCI-SIG spec versions and which one the zPCI 
> facility supports for this device.

Thanks for the info :)

> 
> >>
> >> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> >> ---
> >>   arch/s390/include/asm/pci.h | 1 +
> >>   arch/s390/pci/pci_clp.c     | 1 +
> >>   2 files changed, 2 insertions(+)  
> >   
> 

FWIW,

Acked-by: Cornelia Huck <cohuck@redhat.com>

