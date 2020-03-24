Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 780A2190D5F
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 13:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgCXM0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 08:26:46 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:49827 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727529AbgCXM0q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 08:26:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585052805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5W7hqbIRqv6eQg87Ra13GjaPxhNfPshcsNbqbP00LOw=;
        b=MeWQFhIcQlMgI3+6TkvwuKKBUeWnyQeCaWST3P8riv1wH/32GRWeL8q7HR9iAbUhhb8oPu
        E+i5AJnVw2FrKR0q1UK9acgVauhdB7LZAIVbmx6wForSAQSGCTJLvQAf4V1aS8HI75sWCv
        fB+zGhC002iTyUUDvO3jUCe/+VY6uSI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-jeKWLt20MA2L3n7JR2N6vg-1; Tue, 24 Mar 2020 08:26:43 -0400
X-MC-Unique: jeKWLt20MA2L3n7JR2N6vg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C067910509A3;
        Tue, 24 Mar 2020 12:26:40 +0000 (UTC)
Received: from gondolin (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 324665D9E5;
        Tue, 24 Mar 2020 12:26:36 +0000 (UTC)
Date:   Tue, 24 Mar 2020 13:26:33 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com
Subject: Re: [kvm-unit-tests PATCH 07/10] s390x: smp: Use full PSW to
 bringup new cpu
Message-ID: <20200324132633.115f37ff.cohuck@redhat.com>
In-Reply-To: <20200324081251.28810-8-frankja@linux.ibm.com>
References: <20200324081251.28810-1-frankja@linux.ibm.com>
        <20200324081251.28810-8-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Mar 2020 04:12:48 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Up to now we ignored the psw mask and only used the psw address when
> bringing up a new cpu. For DAT we need to also load the mask, so let's
> do that.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/smp.c  | 2 ++
>  s390x/cstart64.S | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

