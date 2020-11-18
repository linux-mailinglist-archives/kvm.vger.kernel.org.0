Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8342B8345
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 18:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgKRRn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 12:43:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35625 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727562AbgKRRn5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 12:43:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605721436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EdfdkF69jmcQr0I/uvLjX6oroVLBxx0WvpWlwVzZqv0=;
        b=Y4UfdpOCEIzwAvtsGkogC2VyxcwiZo4JgK3wS17vol3uXXfYgoxwwlDkDp55G6ajamDS3u
        yc7tO+k25yD/0AABg+hCHqiazURyau3A2nuW5Ch72gApol0k3He3u72EwSnxhhBuMLnnNE
        KKEWWs2hphiJ9D/+gO4k/qC6plX52uQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-b62tEaePOoO_5QxGzn2k8Q-1; Wed, 18 Nov 2020 12:43:54 -0500
X-MC-Unique: b62tEaePOoO_5QxGzn2k8Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30C789CC02;
        Wed, 18 Nov 2020 17:43:53 +0000 (UTC)
Received: from gondolin (ovpn-113-132.ams2.redhat.com [10.36.113.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84B7010016F5;
        Wed, 18 Nov 2020 17:43:48 +0000 (UTC)
Date:   Wed, 18 Nov 2020 18:43:45 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 1/5] s390x: Add test_bit to library
Message-ID: <20201118184345.30b7ba9d.cohuck@redhat.com>
In-Reply-To: <20201117154215.45855-2-frankja@linux.ibm.com>
References: <20201117154215.45855-1-frankja@linux.ibm.com>
        <20201117154215.45855-2-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Nov 2020 10:42:11 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Query/feature bits are commonly tested via MSB bit numbers on
> s390. Let's add test bit functions, so we don't need to copy code to
> test query bits.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/bitops.h   | 16 ++++++++++++++++
>  lib/s390x/asm/facility.h |  3 ++-
>  2 files changed, 18 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

