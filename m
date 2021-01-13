Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD9E2F4994
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 12:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbhAMLGe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 06:06:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55180 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726961AbhAMLGe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 06:06:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610535907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yNWjhFoRvo/g1y0OAC+keXak5UjeXnLrfFGbjN3FyCY=;
        b=N/Q8eXlGr0GVLK6W7SdKFfL6uMcie+5sNdXXjdijetSjcuYt4y85PL/vB4pRaO1QWNgB+Q
        YHPVJHZ1CD+87Is8ckHMMKF9oprsDPkyV30kQvTNsaxzpyoabZpB/bLHttxGU7ktJBqOaT
        NgnXJ4giczmKhSk7bibuprLxg04rddw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-_1Hx5_T7MO-R8R6TWqoN0w-1; Wed, 13 Jan 2021 06:05:06 -0500
X-MC-Unique: _1Hx5_T7MO-R8R6TWqoN0w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB507107ACF7;
        Wed, 13 Jan 2021 11:05:04 +0000 (UTC)
Received: from gondolin (ovpn-114-8.ams2.redhat.com [10.36.114.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32160779D9;
        Wed, 13 Jan 2021 11:05:00 +0000 (UTC)
Date:   Wed, 13 Jan 2021 12:04:57 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 4/9] s390x: Split assembly into
 multiple files
Message-ID: <20210113120457.3cb9680b.cohuck@redhat.com>
In-Reply-To: <20210112132054.49756-5-frankja@linux.ibm.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
        <20210112132054.49756-5-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Jan 2021 08:20:49 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> I've added too much to cstart64.S which is not start related
> already. Now that I want to add even more code it's time to split
> cstart64.S. lib.S has functions that are used in tests. macros.S
> contains macros which are used in cstart64.S and lib.S
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  s390x/Makefile   |   6 +--
>  s390x/cstart64.S | 119 ++---------------------------------------------
>  s390x/lib.S      |  65 ++++++++++++++++++++++++++
>  s390x/macros.S   |  77 ++++++++++++++++++++++++++++++
>  4 files changed, 149 insertions(+), 118 deletions(-)
>  create mode 100644 s390x/lib.S
>  create mode 100644 s390x/macros.S

Acked-by: Cornelia Huck <cohuck@redhat.com>

