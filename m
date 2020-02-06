Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4FBD154891
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 16:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgBFPyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 10:54:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28327 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727505AbgBFPyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 10:54:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581004477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ciQt4hN0wl1qHYzD18uw6MsOEFU9EprkzhmTJib+6UY=;
        b=azF9/fhCZuRLy1Ev6VN8YCgaQJBtvcw512zmn9w+TKREZ29h3knoYGVqGAh5QKmDjaduCU
        /fnmJsCn9KJlYWqACkApMXSEHvL4Tqen9wkMOY3nAsUeTmOw0pVPw+qyaHaTo6dMx8LjLl
        oKUhVXHiBmhBWZVHFXeef806aCJxWso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-YwsrgvhwPBeSmotAqWik-g-1; Thu, 06 Feb 2020 10:54:36 -0500
X-MC-Unique: YwsrgvhwPBeSmotAqWik-g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDD2B10CE783;
        Thu,  6 Feb 2020 15:54:34 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F33E1001B05;
        Thu,  6 Feb 2020 15:54:33 +0000 (UTC)
Date:   Thu, 6 Feb 2020 16:54:06 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 13/27] docs: kvm: convert devices/vcpu.txt to ReST
Message-ID: <20200206165406.701e43e9.cohuck@redhat.com>
In-Reply-To: <3c02c923c84af973f6a783c10d86d7312f16e6c5.1581000481.git.mchehab+huawei@kernel.org>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
        <3c02c923c84af973f6a783c10d86d7312f16e6c5.1581000481.git.mchehab+huawei@kernel.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Feb 2020 15:50:10 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

$SUBJECT: s/vcpu/vfio/

> - Use standard title markup;
> - adjust lists;
> - mark code blocks as such.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/virt/kvm/devices/index.rst      |  1 +
>  .../virt/kvm/devices/{vfio.txt => vfio.rst}   | 25 +++++++++++--------
>  2 files changed, 16 insertions(+), 10 deletions(-)
>  rename Documentation/virt/kvm/devices/{vfio.txt => vfio.rst} (72%)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

