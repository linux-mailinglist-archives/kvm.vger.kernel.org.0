Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7659341971
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 11:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhCSKEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 06:04:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30994 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231156AbhCSKDi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 06:03:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616148217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qLdk4uruhwfagSeH6On/KYHvjrvsggdWvRrwgnemsdA=;
        b=Hm1ys/omus7U6NCNuAo5BT661f1n+iQXPSzrP1yXUoIq37WInOc/wC4T89ZkpiScT5cDby
        Gl0Bm4magtMtHHXwjXfpzVqyppSY1QZpM/pNeAsFSIye421wkUR0aX4uqWU0EwCVQ1mO0x
        UF7IrP4OEqX78sp3HGsy8hoXNpRmq7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-1j6Xg6PTP5KtCk5jXCmw8w-1; Fri, 19 Mar 2021 06:03:35 -0400
X-MC-Unique: 1j6Xg6PTP5KtCk5jXCmw8w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6811881624;
        Fri, 19 Mar 2021 10:03:34 +0000 (UTC)
Received: from gondolin (ovpn-112-229.ams2.redhat.com [10.36.112.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 094F310013C1;
        Fri, 19 Mar 2021 10:03:29 +0000 (UTC)
Date:   Fri, 19 Mar 2021 11:03:27 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/6] s390x: lib: css: disabling a
 subchannel
Message-ID: <20210319110327.48ca8f8a.cohuck@redhat.com>
In-Reply-To: <1616073988-10381-2-git-send-email-pmorel@linux.ibm.com>
References: <1616073988-10381-1-git-send-email-pmorel@linux.ibm.com>
        <1616073988-10381-2-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 18 Mar 2021 14:26:23 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Some tests require to disable a subchannel.
> Let's implement the css_disable() function.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     |  1 +
>  lib/s390x/css_lib.c | 69 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 70 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

