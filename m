Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01A3F150718
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgBCNXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:23:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27445 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726100AbgBCNXq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 08:23:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580736225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fcxRct6PFqF1LRvDoMImaGTPiJUXjZJbtuD0tiCHnRQ=;
        b=NfPVAA4/XeoeNc5G/b3t3DlaUXif5y9tfJmaaJwr3lawOZaJ0eqWuX7iJohblfMjoBROYS
        3t+Txx5vBwlnxABDHokrZ5vd+jGhJYrcEbhMME88r8O9ILc0jiPYje3D3eoss/+e2Kvf1e
        HWrOIjrmDhmka6nQj1womJYJMGfyYdg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-BroIh4_2Mz6VNzTEAS7RkQ-1; Mon, 03 Feb 2020 08:23:38 -0500
X-MC-Unique: BroIh4_2Mz6VNzTEAS7RkQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76294801E66;
        Mon,  3 Feb 2020 13:23:37 +0000 (UTC)
Received: from gondolin (ovpn-117-79.ams2.redhat.com [10.36.117.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1219990F47;
        Mon,  3 Feb 2020 13:23:31 +0000 (UTC)
Date:   Mon, 3 Feb 2020 14:23:29 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 00/37] KVM: s390: Add support for protected VMs
Message-ID: <20200203142329.5779068f.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:20 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Protected VMs (PVM) are KVM VMs, where KVM can't access the VM's state
> like guest memory and guest registers anymore. Instead the PVMs are
> mostly managed by a new entity called Ultravisor (UV), which provides
> an API, so KVM and the PV can request management actions.
> 
> PVMs are encrypted at rest and protected from hypervisor access while
> running. They switch from a normal operation into protected mode, so
> we can still use the standard boot process to load a encrypted blob
> and then move it into protected mode.
> 
> Rebooting is only possible by passing through the unprotected/normal
> mode and switching to protected again.
> 
> All patches are in the protvirtv2 branch of the korg s390 kvm git
> (on top of Janoschs reset rework).
> 
> Claudio presented the technology at his presentation at KVM Forum
> 2019.

Do you have a changelog from v1 somewhere?

> 
> This contains a "pretty small" common code memory management change that
> will allow paging, guest backing with files etc almost just like normal
> VMs. Please note that the memory management part will still see some
> changes to deal with a corner case for the adapter interrupt indicator
> pages. So please focus on the non-mm parts (which hopefully has
> everthing addressed in the next version). Claudio will work with Andrea
> regarding this.

