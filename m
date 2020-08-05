Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8E823CC6C
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 18:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgHEQoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 12:44:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41099 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727946AbgHEQmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 12:42:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596645730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H65nkYxxHcXXk/lXbbowgvGI5MP7eM/h57JZNUz72sI=;
        b=VsBnhi0x/fvUnAuSrI51s5I1T83Hx4PRPPa/ZR+1DqL3JQ6RwVb5ux/vFTrlsnSD22mOnE
        pwPEjQTy/HyLPJtV0uqhTE0LSKdEYcuwaHz9UpEKKtUiz3/MK1EEzRkUMYo/RIqrWAxJAz
        ZI0P+J4qRnoVPsK0reEfVuyQgJhvHco=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-Qnmd5bDgNV66awADnKJrKA-1; Wed, 05 Aug 2020 07:06:45 -0400
X-MC-Unique: Qnmd5bDgNV66awADnKJrKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 601ED102C7E9;
        Wed,  5 Aug 2020 11:06:44 +0000 (UTC)
Received: from gondolin (ovpn-113-4.ams2.redhat.com [10.36.113.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD3BA88D7A;
        Wed,  5 Aug 2020 11:06:37 +0000 (UTC)
Date:   Wed, 5 Aug 2020 13:06:35 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Eric Auger <eric.auger@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1] vfio: platform: use platform_get_resource()
Message-ID: <20200805130635.373b0daf.cohuck@redhat.com>
In-Reply-To: <20200804135622.11952-1-andriy.shevchenko@linux.intel.com>
References: <20200804135622.11952-1-andriy.shevchenko@linux.intel.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  4 Aug 2020 16:56:22 +0300
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> Use platform_get_resource() to fetch the memory resource
> instead of open-coded variant.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/vfio/platform/vfio_platform.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

