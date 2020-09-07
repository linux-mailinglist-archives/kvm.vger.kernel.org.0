Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E34C260404
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 20:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgIGSAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 14:00:09 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34734 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728809AbgIGSAE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Sep 2020 14:00:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599501604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GbkjdQK0mmmjpZiWW2k2n8oQlwSFXgGo8rfb0Iy0sW0=;
        b=ShcallQvVRfFggQGhlzjPh4ANVz8N9WSWNmUDYsrF9hBEiLaVUkwMv3cI6YPUvIiOU+RyH
        X0PaEPtbidCxIbkvoxNm+Mz+/lkuhSkByQg21/qAZYhEfaPHKJ2eBnUe5jkTwPMuceg4lB
        3gElRrINc9ULEbTV/NNuZVPV9PamwiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-_lTqGLhOOmmKFkkv1LVm0g-1; Mon, 07 Sep 2020 14:00:00 -0400
X-MC-Unique: _lTqGLhOOmmKFkkv1LVm0g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2446E18B9ED9;
        Mon,  7 Sep 2020 17:59:59 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-193.ams2.redhat.com [10.36.112.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D581A5C26B;
        Mon,  7 Sep 2020 17:59:53 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] s390x: uv: Add destroy page call
To:     Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     borntraeger@de.ibm.com, gor@linux.ibm.com, imbrenda@linux.ibm.com,
        kvm@vger.kernel.org, david@redhat.com, hca@linux.ibm.com
References: <20200907124700.10374-1-frankja@linux.ibm.com>
 <20200907124700.10374-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <76c62134-d672-b55f-dc24-14898e4fb2af@redhat.com>
Date:   Mon, 7 Sep 2020 19:59:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200907124700.10374-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/09/2020 14.46, Janosch Frank wrote:
> We don't need to export pages if we destroy the VM configuration
> afterwards anyway. Instead we can destroy the page which will zero it
> and then make it accessible to the host.
> 
> Destroying is about twice as fast as the export.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/include/asm/uv.h |  7 +++++++
>  arch/s390/kernel/uv.c      | 20 ++++++++++++++++++++
>  arch/s390/mm/gmap.c        |  2 +-
>  3 files changed, 28 insertions(+), 1 deletion(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

