Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC8A319CC0
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 11:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhBLKjT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 05:39:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230436AbhBLKi2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Feb 2021 05:38:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613126222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3anbqLRVwdSsi7noecltuvLvDAAK+gsNiB36FEKOTdo=;
        b=Gyj9hUtV1SmTVoHPGjW4s5PcprnyP3RbygHbRLWDv0OkckR0lyW2CnfarZQ1bzNv54uK+r
        Q2HUmJQ7toeD+rnRovtvn5QUjgwRpgLem+Qayo2jkEc0XsGrXl72au6YsgzTJ6uE6UHQTi
        kxuwZ7EkWvHbgRfFfL2LMy3lZ7aFu80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-aKOg7bgdN3y7frWiTRVbmg-1; Fri, 12 Feb 2021 05:36:59 -0500
X-MC-Unique: aKOg7bgdN3y7frWiTRVbmg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7A1FD801965;
        Fri, 12 Feb 2021 10:36:58 +0000 (UTC)
Received: from gondolin (ovpn-113-189.ams2.redhat.com [10.36.113.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23D6D62693;
        Fri, 12 Feb 2021 10:36:53 +0000 (UTC)
Date:   Fri, 12 Feb 2021 11:36:51 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 2/5] s390x: css: simplifications of
 the tests
Message-ID: <20210212113651.38a372f9.cohuck@redhat.com>
In-Reply-To: <1612963214-30397-3-git-send-email-pmorel@linux.ibm.com>
References: <1612963214-30397-1-git-send-email-pmorel@linux.ibm.com>
        <1612963214-30397-3-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Feb 2021 14:20:11 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> In order to ease the writing of tests based on:
> - interrupt
> - enabling a subchannel
> - using multiple I/O on a channel without disabling it
> 
> We do the following simplifications:
> - the I/O interrupt handler is registered on CSS initialization
> - We do not enable again a subchannel in senseid if it is already
>   enabled
> - we add a css_enabled() function to test if a subchannel is enabled
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  1 +
>  lib/s390x/css_lib.c | 37 ++++++++++++++++++++++----------
>  s390x/css.c         | 51 ++++++++++++++++++++++++++-------------------
>  3 files changed, 56 insertions(+), 33 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

