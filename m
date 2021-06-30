Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449AF3B7F86
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 11:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233825AbhF3JDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 05:03:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233739AbhF3JDc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Jun 2021 05:03:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625043663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HezX/7K+dS2EcHM/D10t2Moh+eiJO/yE22g+T2XLUoA=;
        b=NU/ePWVPDRU0dR+OqEPuBmFz0ItX3cpTJ0ob+rHfiyLg3BpHlOOjxr3d5B/qGBY4VYd63E
        gAk76wRUrhsb+D7zmpYGL0+rNBo4X0vSs8/nYWtqFKhfsxu1uqOVcNcCaRqNpmzPCSEMeI
        8R9FcdingABVmvlLFED5rjiRcjv3EtI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-30-OUUVsBLQPc6rNYcx0thOhg-1; Wed, 30 Jun 2021 05:01:02 -0400
X-MC-Unique: OUUVsBLQPc6rNYcx0thOhg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2ADB19057A0;
        Wed, 30 Jun 2021 09:01:00 +0000 (UTC)
Received: from localhost (ovpn-112-48.ams2.redhat.com [10.36.112.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7444F60843;
        Wed, 30 Jun 2021 09:00:53 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/5] s390x: sie: Fix sie.h integer types
In-Reply-To: <20210629133322.19193-3-frankja@linux.ibm.com>
Organization: Red Hat GmbH
References: <20210629133322.19193-1-frankja@linux.ibm.com>
 <20210629133322.19193-3-frankja@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 30 Jun 2021 11:00:51 +0200
Message-ID: <87tulfloak.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 29 2021, Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's only use the uint*_t types.
>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/sie.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

