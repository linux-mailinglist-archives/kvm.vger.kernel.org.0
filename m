Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144BB34E6F3
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 13:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbhC3L6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 07:58:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229633AbhC3L5r (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 07:57:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617105462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m93QwClR/QQ/X5ttq3tlNUz41kmgq8XL8fOvgWl28V0=;
        b=WhLxXk2W9755rt2m15OwQ0eVrJjCmtvw1bL83f/Sd96HR8UAegNsnfGcVjojkMDSuD8wo4
        pmea7Hb3lg9h6mKlVYnU8db+M5HRnw02kbJxw6gsupht5AkTgwV0jWnvkBodPxTgtvUUnY
        p3Ctl7ZA166u0w8pGkyg0RVVnyzvGS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-bgkqAdkVNY296efGuno-zw-1; Tue, 30 Mar 2021 07:57:40 -0400
X-MC-Unique: bgkqAdkVNY296efGuno-zw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76FBF1009E29;
        Tue, 30 Mar 2021 11:57:39 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E68C06085A;
        Tue, 30 Mar 2021 11:57:34 +0000 (UTC)
Date:   Tue, 30 Mar 2021 13:57:32 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 4/8] s390x: lib: css: separate wait
 for IRQ and check I/O completion
Message-ID: <20210330135732.0b367536.cohuck@redhat.com>
In-Reply-To: <1616665147-32084-5-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
        <1616665147-32084-5-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Mar 2021 10:39:03 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We will may want to check the result of an I/O without waiting
> for an interrupt.
> For example because we do not handle interrupt.

It's more because we may poll the subchannel state without enabling I/O
interrupts, no?

> Let's separate waiting for interrupt and the I/O complretion check.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  1 +
>  lib/s390x/css_lib.c | 13 ++++++++++---
>  2 files changed, 11 insertions(+), 3 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

