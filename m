Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B162C67DF
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 15:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731097AbgK0OZX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 09:25:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730855AbgK0OZX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 09:25:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606487122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nZelsoSXljdWyX7TEtcR+wbGEXApvQcCHmUtj4m+loY=;
        b=UpHOYP7a1Ja51f36mbQ0RNxBxZ14+KMEsm7Pv26ycDokv6SCzfjM5qlkY8okIMVdLHm1ZR
        r8X0RYZtA4e8xYe6xpR5TpbOzAQSKI1yVdLbrm3NXs/0Ier8CSfpflEuc0FfU0Sztyn9VC
        3PNNB01O4sN5JsFei8VVtBgInrW/1eA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-9jkZ315XOw-LA_Cy6830dg-1; Fri, 27 Nov 2020 09:25:19 -0500
X-MC-Unique: 9jkZ315XOw-LA_Cy6830dg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E3BF107ACF7;
        Fri, 27 Nov 2020 14:25:18 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-70.ams2.redhat.com [10.36.113.70])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E17A1A882;
        Fri, 27 Nov 2020 14:25:13 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 7/7] s390x: Fix sclp.h style issues
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201127130629.120469-1-frankja@linux.ibm.com>
 <20201127130629.120469-8-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <67be9c7c-6f5b-c9bf-b1f0-963710d9111c@redhat.com>
Date:   Fri, 27 Nov 2020 15:25:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201127130629.120469-8-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/11/2020 14.06, Janosch Frank wrote:
> Fix indentation
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/sclp.h | 172 +++++++++++++++++++++++------------------------
>  1 file changed, 86 insertions(+), 86 deletions(-)

Acked-by: Thomas Huth <thuth@redhat.com>

