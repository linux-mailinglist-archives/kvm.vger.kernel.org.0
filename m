Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C61167DBD
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 13:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbgBUMte (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 07:49:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40942 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727683AbgBUMte (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 07:49:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582289373;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yrgPaonqXcDUj6+FAtHnkVYt66A61SS4WTWm2lxHN64=;
        b=MiVxXmtWX5Nagjl6O2JhJuyH0mJo+DfzVRdX4gu8oLWxS4/L+jY7GSJSIezI0L3g6PXbYX
        0XGEeeuxICMUg/d2jV9K2BwV/G3+FJjfOJJNFG82CQ0nytVM9Wnd+vgouMCvuNRJuoxlVe
        pwjHgkWAuAzCcg4NmetIx8GHG8mkZnE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-KNLgH_guOOSB9UysM3SuLg-1; Fri, 21 Feb 2020 07:49:30 -0500
X-MC-Unique: KNLgH_guOOSB9UysM3SuLg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41F2B107ACC9;
        Fri, 21 Feb 2020 12:49:28 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B0FF5C1D8;
        Fri, 21 Feb 2020 12:49:23 +0000 (UTC)
Date:   Fri, 21 Feb 2020 13:49:21 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v3 11/37] KVM: s390: protvirt: Secure memory is not
 mergeable
Message-ID: <20200221134921.341466fc.cohuck@redhat.com>
In-Reply-To: <20200220104020.5343-12-borntraeger@de.ibm.com>
References: <20200220104020.5343-1-borntraeger@de.ibm.com>
        <20200220104020.5343-12-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Feb 2020 05:39:54 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Janosch Frank <frankja@linux.ibm.com>
> 
> KSM will not work on secure pages, because when the kernel reads a
> secure page, it will be encrypted and hence no two pages will look the
> same.
> 
> Let's mark the guest pages as unmergeable when we transition to secure
> mode.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> [borntraeger@de.ibm.com: patch merging, splitting, fixing]
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/include/asm/gmap.h |  1 +
>  arch/s390/kvm/kvm-s390.c     |  7 +++++++
>  arch/s390/mm/gmap.c          | 30 ++++++++++++++++++++----------
>  3 files changed, 28 insertions(+), 10 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

