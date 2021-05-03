Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE541371587
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 14:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbhECM4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 08:56:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48680 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234011AbhECM4P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 08:56:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620046522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3M9IHzDtGaZGOH9OPrtFDhJUweMyW5laZguaurueFVw=;
        b=UkaUSc5N29bfJF0UTjXjnJBait6jXSgONGuedQ2N7zvBi1tmERNH9H/4C4lo6vY2ZiA+ic
        SZElnjOat7Irf3c2dXq6R3a/upuW0s46CbcnmoJdsFzgM3VJIriloaRdW7d6FJXTgmQuRh
        wNpxTpgA45T7Pg/2whD+EvVs64Lf6Uc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-B2mtu50YNc27gV-p6sSv_Q-1; Mon, 03 May 2021 08:55:19 -0400
X-MC-Unique: B2mtu50YNc27gV-p6sSv_Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D818807341;
        Mon,  3 May 2021 12:55:18 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAB4C5C241;
        Mon,  3 May 2021 12:55:02 +0000 (UTC)
Date:   Mon, 3 May 2021 14:54:59 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH] s390x: Fix vector stfle checks
Message-ID: <20210503145459.42d73640.cohuck@redhat.com>
In-Reply-To: <20210503124713.68975-1-frankja@linux.ibm.com>
References: <20210503124713.68975-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 May 2021 12:47:13 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> 134 is for bcd
> 135 is for the vector enhancements
> 
> Not the other way around...
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> ---
>  s390x/vector.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

