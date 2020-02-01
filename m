Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5091614FA0A
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbgBAS5s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:57:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58030 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727382AbgBAS5r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:57:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580583467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=Dqptp17Q1TMHfAflJJqyiSJur9U1DGtoboCV+hNjLeU=;
        b=BH4X3i5dGfvUaPG/G9HF0cQv3w+7g6hVjLNZFNBkr000F7gb85500NuLwsJ4Eq8t4lTOej
        98eYVieKMqqQT+XnB6XOp78gWZVmet5AooNz22PIXwvfBWvOOXZy1fGW08xBaWuRmbzog0
        fPWc0G6Gk4+zR5VTLnNlbZsDL0naPvI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-Lxxqt2N1P72qp721P17Wag-1; Sat, 01 Feb 2020 13:57:42 -0500
X-MC-Unique: Lxxqt2N1P72qp721P17Wag-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E56BC477;
        Sat,  1 Feb 2020 18:57:40 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-27.ams2.redhat.com [10.36.116.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 12ACB5DDAA;
        Sat,  1 Feb 2020 18:57:36 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 4/7] s390x: Add cpu id to interrupt
 error prints
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com
References: <20200201152851.82867-1-frankja@linux.ibm.com>
 <20200201152851.82867-5-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <09e0f324-aef3-b39a-1862-3a015635dc3f@redhat.com>
Date:   Sat, 1 Feb 2020 19:57:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200201152851.82867-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/2020 16.28, Janosch Frank wrote:
> It's good to know which cpu broke the test.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  lib/s390x/interrupt.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

