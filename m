Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69152B7AF4
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 11:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgKRKJy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 05:09:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbgKRKJy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 05:09:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605694193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CpvPZQqwlLnUj1OEnW/xZQLDBq9wa14Y5z2C3rFfKSU=;
        b=PDeK7PHy2puZLL7SD0OpSqQ6q0UKtDHoepOXyfybCQ9Jw/Ipgvk1BPUTwFAn2RyXzwVChv
        8Gzm2ejWkIigoToKmxz3QNqGp/afoN+KFJsJ4Pyyj2S9BgNgJSOYvH8HLnfARyIkrwMnnR
        o0OJLgkfVLE+4espqL0ajqpKpiePhkk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-KMvzgoR6OLKJ1Hw59kye8w-1; Wed, 18 Nov 2020 05:09:50 -0500
X-MC-Unique: KMvzgoR6OLKJ1Hw59kye8w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B667107465F;
        Wed, 18 Nov 2020 10:09:49 +0000 (UTC)
Received: from gondolin (ovpn-113-132.ams2.redhat.com [10.36.113.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FC0A17B75;
        Wed, 18 Nov 2020 10:09:44 +0000 (UTC)
Date:   Wed, 18 Nov 2020 11:09:41 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 0/2] Fix and MAINTAINER update for 5.10
Message-ID: <20201118110941.14e12cf5.cohuck@redhat.com>
In-Reply-To: <20201118093942.457191-1-borntraeger@de.ibm.com>
References: <20201118093942.457191-1-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Nov 2020 10:39:40 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> Conny, David,
> 
> your chance for quick feedback. I plan to send a pull request for kvm
> master soon.
> 
> I have agreed with Heiko to carry this via the KVM tree as
> this is KVM s390 specific.
> 
> Christian Borntraeger (2):
>   s390/uv: handle destroy page legacy interface
>   MAINTAINERS: add uv.c also to KVM/s390
> 
>  MAINTAINERS           | 1 +
>  arch/s390/kernel/uv.c | 9 ++++++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 

For both:

Acked-by: Cornelia Huck <cohuck@redhat.com>

