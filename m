Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0BC1553B4
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 09:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgBGI2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 03:28:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54556 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726130AbgBGI2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 03:28:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581064088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZGjVa5zDX/EV/wwl3qhrGlYcIwyaFbMCvHGqatHqroU=;
        b=OpCpdBAYZ+5vVH85XGD1cpIJ/5gzhd7hiMJjgVYfcPUcUdJxnTgHymM7wd7FBCJ8R9LibQ
        w4v9pTuulevlCTrHhKFBhHZzl3jROydwbprV/koo0LkLJf6PIbiacHOCUA6z6kivQ1Mxrp
        Ptwa7yegIIVXQ5DDvswMSnODAyr/c2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-m1vd_5_NOQCxoLhydiP4hw-1; Fri, 07 Feb 2020 03:28:07 -0500
X-MC-Unique: m1vd_5_NOQCxoLhydiP4hw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FF418018DE;
        Fri,  7 Feb 2020 08:28:05 +0000 (UTC)
Received: from gondolin (ovpn-117-112.ams2.redhat.com [10.36.117.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EDAA87B11;
        Fri,  7 Feb 2020 08:28:01 +0000 (UTC)
Date:   Fri, 7 Feb 2020 09:27:59 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 34/37] KVM: s390: protvirt: Add UV debug trace
Message-ID: <20200207092759.43450715.cohuck@redhat.com>
In-Reply-To: <8b5857ac-d557-96e7-8164-3da42edc5a42@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-35-borntraeger@de.ibm.com>
        <20200206104159.16130ccb.cohuck@redhat.com>
        <8b5857ac-d557-96e7-8164-3da42edc5a42@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 7 Feb 2020 09:05:27 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 06.02.20 10:41, Cornelia Huck wrote:
> > On Mon,  3 Feb 2020 08:19:54 -0500
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> From: Janosch Frank <frankja@linux.ibm.com>
> >>
> >> Let's have some debug traces which stay around for longer than the
> >> guest.
> >>
> >> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> >> ---
> >>  arch/s390/kvm/kvm-s390.c | 10 +++++++++-
> >>  arch/s390/kvm/kvm-s390.h |  9 +++++++++
> >>  arch/s390/kvm/pv.c       | 21 +++++++++++++++++++--
> >>  3 files changed, 37 insertions(+), 3 deletions(-)

> > You often seem to log in pairs (into the per-vm dbf and into the new uv
> > dbf). Would it make sense to introduce a new helper for that, or is
> > that overkill?  
> 
> I guess the logging will see several changes over time anyway. Let us start
> with an initial variant. 

Fair enough.

