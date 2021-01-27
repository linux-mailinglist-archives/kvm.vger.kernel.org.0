Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE63E30605C
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 16:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbhA0P6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 10:58:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236802AbhA0P4L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 10:56:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611762885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/YFjBOecleaWL0YFHr9tYDFtjlmTOwRACXieVIbl3ro=;
        b=h1tlVnC8v8Gn3OuRFPewgL4xwRJ0P9cEsmNhk49o+JEINhwQ43t6VQuC+fqp9T+a6WscB0
        EvRd1G55ZxzkC1PYXLn89q1SqOpTrkcJGqIYFPGUx0+g/psh7cEbeV302F4PFfcaoo5FAq
        wEctjg1Lr/lP+okJG0w6zWJbHGWjUeU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-Ged8ubZcP16FTFaEPlCebw-1; Wed, 27 Jan 2021 10:54:43 -0500
X-MC-Unique: Ged8ubZcP16FTFaEPlCebw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4807D107ACF7
        for <kvm@vger.kernel.org>; Wed, 27 Jan 2021 15:54:42 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-136.ams2.redhat.com [10.36.112.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0E075C1BB;
        Wed, 27 Jan 2021 15:54:41 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] x86: use -cpu max instead of -cpu host
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20210127095234.476291-1-pbonzini@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <06b67a9d-ed15-59e5-3849-c3b9f6665138@redhat.com>
Date:   Wed, 27 Jan 2021 16:54:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210127095234.476291-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/01/2021 10.52, Paolo Bonzini wrote:
> This allows the tests to run under TCG as well.  "-cpu max" is not available on
> CentOS 7, however that doesn't change much for our CI since we weren't testing
> the CentOS 7 + KVM combination anyway.

"-cpu max" has been added with QEMU v2.10 ... Wasn't there the possibility 
to install a qemu-kvm-ev package instead of the normal qemu-kvm package on 
CentOS 7 ? qemu-kvm-ev should likely be new enough already, I guess?

Anyway, for this patch:
Reviewed-by: Thomas Huth <thuth@redhat.com>

