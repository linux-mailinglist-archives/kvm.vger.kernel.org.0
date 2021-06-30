Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939B03B7F79
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 11:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbhF3JCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 05:02:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22323 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232984AbhF3JC3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Jun 2021 05:02:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625043601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ziWybQF2fqZuC4qV8NogA9HcN/+gsuxkHXIQxW2aryY=;
        b=Ir9d53ZwZixh0oMvvsSvnKxkk2/LnF5k8umBLbje99zrSSdgYjMVwt0xUFEtBBSt23VARP
        w5VW5EgD2DGa6GaKv6CACpg5R6mY36HsOmQ1sAzdhITgZsw0uY3OoQi+/p3rXQOnqDsTW8
        SYEO978N+RWVgGmXCDOBXPqq50mZhng=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-2u1G9EDEOEOu5iX-wqADJA-1; Wed, 30 Jun 2021 04:59:50 -0400
X-MC-Unique: 2u1G9EDEOEOu5iX-wqADJA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3FD6A40C3;
        Wed, 30 Jun 2021 08:59:48 +0000 (UTC)
Received: from localhost (ovpn-112-48.ams2.redhat.com [10.36.112.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 113EE5D6AD;
        Wed, 30 Jun 2021 08:59:44 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 1/5] s390x: sie: Add missing includes
In-Reply-To: <20210629133322.19193-2-frankja@linux.ibm.com>
Organization: Red Hat GmbH
References: <20210629133322.19193-1-frankja@linux.ibm.com>
 <20210629133322.19193-2-frankja@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Wed, 30 Jun 2021 10:59:43 +0200
Message-ID: <87wnqblocg.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 29 2021, Janosch Frank <frankja@linux.ibm.com> wrote:

> arch_def.h is needed for struct psw.
> stdint.h is needed for the uint*_t types.
>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/sie.h | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

