Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3521B3AEB76
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 16:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhFUOgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 10:36:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22058 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230363AbhFUOgu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 10:36:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624286074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r2IzcWriMhbCMjmWDwaupeM2bjpacjY5rwsJcIHZVPo=;
        b=SBh8Svh1womEAvsDjijxAAQqRUkOmmytZtOeit3/ZakZEjj5sK4GAqn/aHK8sHc6A7dZda
        mKRYhB4Iyga7EP9iGVlYk04LLeaAGXTVdv2+zd2Rv5/3WsinB8RbCZyNwkTJ9JDMoigkh/
        CAbd6HailMFYDI8Dyankjp27+leXprE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-VP3ZP_i2MD6mb8kqXM-z6w-1; Mon, 21 Jun 2021 10:34:33 -0400
X-MC-Unique: VP3ZP_i2MD6mb8kqXM-z6w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14A12802C80;
        Mon, 21 Jun 2021 14:34:32 +0000 (UTC)
Received: from localhost (ovpn-113-141.ams2.redhat.com [10.36.113.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7336E10013D6;
        Mon, 21 Jun 2021 14:34:28 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: get rid of register asm usage
In-Reply-To: <20210621140356.1210771-1-hca@linux.ibm.com>
Organization: Red Hat GmbH
References: <20210621140356.1210771-1-hca@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 21 Jun 2021 16:34:26 +0200
Message-ID: <87sg1bnv65.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

%On Mon, Jun 21 2021, Heiko Carstens <hca@linux.ibm.com> wrote:

> Using register asm statements has been proven to be very error prone,
> especially when using code instrumentation where gcc may add function
> calls, which clobbers register contents in an unexpected way.
>
> Therefore get rid of register asm statements in kvm code, even though
> there is currently nothing wrong with them. This way we know for sure
> that this bug class won't be introduced here.
>
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

