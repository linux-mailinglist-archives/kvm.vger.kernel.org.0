Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA852C834E
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 12:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgK3LcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 06:32:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726385AbgK3LcU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 06:32:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606735854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ztgW78hDbZG440TaygK/xcuYD+gvBMHcHSRtBLHRxgY=;
        b=Stdv9Ah07R9QPnLtB67IvAHsYvkxhzH7xD1JVil0g2wK65Qd713R6u11tlksUqpdd5Bnda
        Swar9soh5GU8IZBRuytQGonC720YSV3nqLjiTjf14s1oSjtihBvi1+ULC8aiE7F9jp4qPW
        xKG/eHJwsZU1XmO/BAS225tG856QraE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-406-lm6et4kuN3-OkM8ui5ku4A-1; Mon, 30 Nov 2020 06:30:50 -0500
X-MC-Unique: lm6et4kuN3-OkM8ui5ku4A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F31AC190D343;
        Mon, 30 Nov 2020 11:30:48 +0000 (UTC)
Received: from gondolin (ovpn-113-87.ams2.redhat.com [10.36.113.87])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 79A7B5D9C0;
        Mon, 30 Nov 2020 11:30:44 +0000 (UTC)
Date:   Mon, 30 Nov 2020 12:30:41 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 6/7] s390x: Add diag318 intercept test
Message-ID: <20201130123041.0b176afc.cohuck@redhat.com>
In-Reply-To: <20201127130629.120469-7-frankja@linux.ibm.com>
References: <20201127130629.120469-1-frankja@linux.ibm.com>
        <20201127130629.120469-7-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Nov 2020 08:06:28 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Not much to test except for the privilege and specification
> exceptions.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/sclp.c  |  2 ++
>  lib/s390x/sclp.h  |  6 +++++-
>  s390x/intercept.c | 19 +++++++++++++++++++
>  3 files changed, 26 insertions(+), 1 deletion(-)
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

