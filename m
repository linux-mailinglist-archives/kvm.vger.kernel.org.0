Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C1B2405B9
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 14:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgHJMVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 08:21:23 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20197 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726141AbgHJMVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 08:21:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597062082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y1hpAo8jOj/yDLKvC5VWu1jpmDePmTfuaoB+d+CeDGM=;
        b=HSsmQdtpNbl+EFxXIftqXazX30v68zPibllZ5jEjasMzZeuDXssY6MNIuNE4RM8A0fy0Uz
        OLa06Nu8DtBw1OzdA1l4R6z1wDjGNoMtVRy/g54ZSqiC1KCarFeJlBTwFceITa8cLOe5qE
        AF40OH6IC5XbzH3YFeaSTZVWMbjhVLU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-yccNOuLJMHKSJlMd3Y4YQw-1; Mon, 10 Aug 2020 08:21:18 -0400
X-MC-Unique: yccNOuLJMHKSJlMd3Y4YQw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2A319101C8A0;
        Mon, 10 Aug 2020 12:21:17 +0000 (UTC)
Received: from gondolin (ovpn-112-218.ams2.redhat.com [10.36.112.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B73005D9D7;
        Mon, 10 Aug 2020 12:21:12 +0000 (UTC)
Date:   Mon, 10 Aug 2020 14:21:09 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/3] s390x: Add custom pgm cleanup
 function
Message-ID: <20200810142109.77cac24c.cohuck@redhat.com>
In-Reply-To: <20200807111555.11169-2-frankja@linux.ibm.com>
References: <20200807111555.11169-1-frankja@linux.ibm.com>
        <20200807111555.11169-2-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Aug 2020 07:15:53 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Sometimes we need to do cleanup which we don't necessarily want to add
> to interrupt.c, so let's add a way to register a cleanup function.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/s390x/asm/interrupt.h |  1 +
>  lib/s390x/interrupt.c     | 12 +++++++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

