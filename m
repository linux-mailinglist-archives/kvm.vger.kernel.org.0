Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206102B8356
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 18:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgKRRqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 12:46:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726387AbgKRRqw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 12:46:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605721611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xF41vJfo74d8WDJTQmN39tXRb2uvhVOKQqu2jXTtZcY=;
        b=NYjYP2t3v1/Yj29dHU3ZR151ZbAy+N0LqqVr5xrfiSXCqd1+U2zAwR/j9qOneMOkC9vMeT
        1k7Htrzqow6MAnHgdWSUB33nOWmekGZSwG2/Pzt94OKkgVmPkh20YmMePPAkzdIVpw2ZW6
        hyZRkWowG/BEk8z1kVozfC7rEo2dB0c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-RlvSnz2FOa6myzzrI5UllA-1; Wed, 18 Nov 2020 12:46:48 -0500
X-MC-Unique: RlvSnz2FOa6myzzrI5UllA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58571190B2A1;
        Wed, 18 Nov 2020 17:46:47 +0000 (UTC)
Received: from gondolin (ovpn-113-132.ams2.redhat.com [10.36.113.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B1ACF19651;
        Wed, 18 Nov 2020 17:46:42 +0000 (UTC)
Date:   Wed, 18 Nov 2020 18:46:40 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 2/5] s390x: Consolidate sclp read info
Message-ID: <20201118184640.203438f6.cohuck@redhat.com>
In-Reply-To: <20201117154215.45855-3-frankja@linux.ibm.com>
References: <20201117154215.45855-1-frankja@linux.ibm.com>
        <20201117154215.45855-3-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Nov 2020 10:42:12 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's only read the information once and pass a pointer to it instead
> of calling sclp multiple times.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/io.c   |  1 +
>  lib/s390x/sclp.c | 29 +++++++++++++++++++++++------
>  lib/s390x/sclp.h |  3 +++
>  lib/s390x/smp.c  | 23 +++++++++--------------
>  4 files changed, 36 insertions(+), 20 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

