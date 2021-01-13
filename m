Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2A22F49CA
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 12:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbhAMLNi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 06:13:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51798 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727744AbhAMLNi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 06:13:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610536332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oll8g1vmFOV5axq2EQdWBmlxRtNj0eliiIt8uSJZEmU=;
        b=Hv0ToBGs03pinycx/W2sQSjAfquTPB8S2AKl9wAZmA7UDP9LaZwb2273dXxUjqTwh3DlgH
        VKN0B0S3YOoE/Ikh++lWyjyZCvITU9MKWYjApmO+qOdIIgeQbOmk0sf2pRPYrLfvgxjApQ
        +bHp9WY6jUb2YXMoo/n3bYH5nGxFxsY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-xF8qjynWNTadDegKZ2YYOA-1; Wed, 13 Jan 2021 06:12:10 -0500
X-MC-Unique: xF8qjynWNTadDegKZ2YYOA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 215C680A5C0;
        Wed, 13 Jan 2021 11:12:09 +0000 (UTC)
Received: from gondolin (ovpn-114-8.ams2.redhat.com [10.36.114.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BEC166A908;
        Wed, 13 Jan 2021 11:12:04 +0000 (UTC)
Date:   Wed, 13 Jan 2021 12:12:02 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 7/9] s390x: Add diag318 intercept test
Message-ID: <20210113121202.3ca9b201.cohuck@redhat.com>
In-Reply-To: <20210112132054.49756-8-frankja@linux.ibm.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
        <20210112132054.49756-8-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Jan 2021 08:20:52 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Not much to test except for the privilege and specification
> exceptions.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/sclp.c  |  1 +
>  lib/s390x/sclp.h  |  6 +++++-
>  s390x/intercept.c | 19 +++++++++++++++++++
>  3 files changed, 25 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

