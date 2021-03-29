Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3976634C7AE
	for <lists+kvm@lfdr.de>; Mon, 29 Mar 2021 10:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbhC2IR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Mar 2021 04:17:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55634 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233074AbhC2IPv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Mar 2021 04:15:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617005750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vKBEmRzQzlkki0ojrnt5D9T5aBRCS3aNrNDNB7NAJJc=;
        b=LlD1MFR5aZDKheHPOtyIDSGGV17zS52E2knBzaQRtPavYBhG+GEP+4wNBgvsbTgqPFJ/3G
        A11WV4wRpwhE/2t4OuGucQ/mX994QhZpjw+YqvxuRqQ9OFBq0wohtnmr0yOW4VMM9NiUVV
        6U0oEH0/BOkdmCY0XD4GJhhsguJvD/8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-xw2uUArlPK-FId8HXRIi5g-1; Mon, 29 Mar 2021 04:15:46 -0400
X-MC-Unique: xw2uUArlPK-FId8HXRIi5g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0631A1009E25;
        Mon, 29 Mar 2021 08:15:44 +0000 (UTC)
Received: from gondolin (ovpn-113-56.ams2.redhat.com [10.36.113.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B26B53E35;
        Mon, 29 Mar 2021 08:15:38 +0000 (UTC)
Date:   Mon, 29 Mar 2021 10:15:35 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, farman@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com, akrowiak@linux.ibm.com,
        pmorel@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        alex.williamson@redhat.com
Subject: Re: [PATCH] MAINTAINERS: add backups for s390 vfio drivers
Message-ID: <20210329101535.2062eecd.cohuck@redhat.com>
In-Reply-To: <1616679712-7139-1-git-send-email-mjrosato@linux.ibm.com>
References: <1616679712-7139-1-git-send-email-mjrosato@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Mar 2021 09:41:52 -0400
Matthew Rosato <mjrosato@linux.ibm.com> wrote:

> Add a backup for s390 vfio-pci, an additional backup for vfio-ccw
> and replace the backup for vfio-ap as Pierre is focusing on other
> areas.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>  MAINTAINERS | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Nice :)

Acked-by: Cornelia Huck <cohuck@redhat.com>

