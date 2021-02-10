Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23AD03164A4
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 12:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhBJLIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 06:08:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231594AbhBJLGm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 06:06:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612955113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z3pAfZk6r3KZwOINV4f5Aj8wihUC0MavkIHBBzDY0Q0=;
        b=eKIBvYiE/BUF2EQYbUBe70FsZlDpthaxAexQhwAIC/ChAlXVQuHIqsu/KASmhGj5AYLsGv
        siIgsMdnDK87om4tavZw0jjsbRFwDIBFsk4Ba9ylrUTYh7jV2Gwy1f+f5NewGgoKCRZDnh
        +0BHNRW9Bb26S7LTDDJzPmMBTQdwS+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-e5DvYtAqNzy5917UfTfg5w-1; Wed, 10 Feb 2021 06:05:11 -0500
X-MC-Unique: e5DvYtAqNzy5917UfTfg5w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D045803F47;
        Wed, 10 Feb 2021 11:05:10 +0000 (UTC)
Received: from gondolin (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B234210074FC;
        Wed, 10 Feb 2021 11:05:03 +0000 (UTC)
Date:   Wed, 10 Feb 2021 12:05:01 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] Fix the length in the stsi check for the
 VM name
Message-ID: <20210210120501.0e492991.cohuck@redhat.com>
In-Reply-To: <20210209155705.67601-1-thuth@redhat.com>
References: <20210209155705.67601-1-thuth@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  9 Feb 2021 16:57:05 +0100
Thomas Huth <thuth@redhat.com> wrote:

> sizeof(somepointer) results in the size of the pointer, i.e. 8 on a
> 64-bit system, so the
> 
>  memcmp(data->ext_names[0], vm_name_ext, sizeof(vm_name_ext))
> 
> only compared the first 8 characters of the VM name here. Switch
> to a proper array to get the sizeof() right.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  s390x/stsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

