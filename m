Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE96815D423
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 09:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728864AbgBNIyG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 03:54:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52218 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726004AbgBNIyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 03:54:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581670445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lRnaNkrQwUxMeKz5EJIhuvgUUtSlhXIlwWyva/AZZvc=;
        b=LH0Un+i5iBAO1JZhana4fd3XjZubgL0btOazWCh2Dovg8EQQvPFqkloj3o57ueJHJHe0SD
        xHqjwxzVd4N72wKYVvKd2egansp1nJWgMvDeUCDsNmvr1nyIlo0sheUJOCOgAcb0ryVbLs
        KTDuowxWK+eqSIzE5oRERzNCfQcMs4c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-ymzW-huHM3akZYa8vuo4_w-1; Fri, 14 Feb 2020 03:53:59 -0500
X-MC-Unique: ymzW-huHM3akZYa8vuo4_w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FCD71007273;
        Fri, 14 Feb 2020 08:53:58 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8843D5C134;
        Fri, 14 Feb 2020 08:53:54 +0000 (UTC)
Date:   Fri, 14 Feb 2020 09:53:52 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 34/37] KVM: s390: protvirt: Add UV debug trace
Message-ID: <20200214095352.269b259e.cohuck@redhat.com>
In-Reply-To: <0edf1540-475c-cdf5-2c2c-b7b592beaaad@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-35-borntraeger@de.ibm.com>
        <20200206104159.16130ccb.cohuck@redhat.com>
        <0edf1540-475c-cdf5-2c2c-b7b592beaaad@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Feb 2020 09:32:26 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 06.02.20 10:41, Cornelia Huck wrote:
> 
> > 
> > You often seem to log in pairs (into the per-vm dbf and into the new uv
> > dbf). Would it make sense to introduce a new helper for that, or is
> > that overkill?  
> 
> I think I had now a good idea.
> 
> I will let KVM_UV_EVENT always log into both logs (the per KVM and the global one).
> If it is important enough for the global one it really should also be in the 
> per kvm one. So I will split out all messages into the separate patches and
> move this infrastructure at the beginning of the patch series.
> Then we only need one line of code for each log. 
> 

I think that makes a lot of sense.

