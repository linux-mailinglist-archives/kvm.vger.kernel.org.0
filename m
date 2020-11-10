Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7FC2AD53E
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 12:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729909AbgKJLbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 06:31:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20319 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbgKJLbR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Nov 2020 06:31:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605007876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7z3Hj13YgE5Bn629X+ahu88D0cdtW0ZmuX8wZJLEM8Y=;
        b=gY+dOJl0QDvk0gXC7plOQV4ak9h0MJQhFBxtY+FFs7cqmxDv12HK4Ftxf0c42Nr6BSRRNe
        8mJ/C85muMjpmOMzzPTerD8KBdz7X3NS8ZQZndvNipm0uZ5w8VFRHRADus6ZNzgwlFcYyl
        n7Gym4LSTHZUUMSh1FT0PucMxbPL3OI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-7dzuHxOaNkWM27hwYZaTiA-1; Tue, 10 Nov 2020 06:31:14 -0500
X-MC-Unique: 7dzuHxOaNkWM27hwYZaTiA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55E9F801FD4;
        Tue, 10 Nov 2020 11:31:13 +0000 (UTC)
Received: from gondolin (ovpn-112-243.ams2.redhat.com [10.36.112.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 606195B4A4;
        Tue, 10 Nov 2020 11:31:08 +0000 (UTC)
Date:   Tue, 10 Nov 2020 12:31:05 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com
Subject: Re: [PATCH] kvm: s390: pv: Mark mm as protected after the set
 secure parameters and improve cleanup
Message-ID: <20201110123105.4b7b1235.cohuck@redhat.com>
In-Reply-To: <20201030140141.106641-1-frankja@linux.ibm.com>
References: <20201030140141.106641-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 30 Oct 2020 10:01:41 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> We can only have protected guest pages after a successful set secure
> parameters call as only then the UV allows imports and unpacks.
> 
> By moving the test we can now also check for it in s390_reset_acc()
> and do an early return if it is 0.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 2 +-
>  arch/s390/kvm/pv.c       | 3 ++-
>  arch/s390/mm/gmap.c      | 2 ++
>  3 files changed, 5 insertions(+), 2 deletions(-)

Seems reasonable to me. I assume it has been given some coverage by now?

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

