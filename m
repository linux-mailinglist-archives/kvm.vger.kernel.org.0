Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A2A316505
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 12:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhBJLUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 06:20:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32238 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231320AbhBJLR7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 06:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612955791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BzhOJ/LOF4gaPU6ByzTg8odM2NwbPPfDTYSs72fJxH8=;
        b=ceA+xZWT8pDI24i91/d4TvOzrmRaxHPeeZPOALMQPROzDXa3VMBY1jPP3RgDJZ0dVtLGyH
        1ai/CzAIV6VaEDyBj/vJcfo+L8ASkInf8NPMaafZNgwSRvSA6rWtq6RWpjQD5Qn2kFoohQ
        FrPOmUZHWc2//pDPcGqqFjoAE3PSF0w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-c_zfRGLoNmiXTg--Z0HUgw-1; Wed, 10 Feb 2021 06:16:29 -0500
X-MC-Unique: c_zfRGLoNmiXTg--Z0HUgw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 548DF192D785;
        Wed, 10 Feb 2021 11:16:28 +0000 (UTC)
Received: from gondolin (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A8BE719C66;
        Wed, 10 Feb 2021 11:16:23 +0000 (UTC)
Date:   Wed, 10 Feb 2021 12:16:21 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, pmorel@linux.ibm.com, borntraeger@de.ibm.com
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: introduce leave_pstate to
 leave userspace
Message-ID: <20210210121621.02b957df.cohuck@redhat.com>
In-Reply-To: <20210209185154.1037852-2-imbrenda@linux.ibm.com>
References: <20210209185154.1037852-1-imbrenda@linux.ibm.com>
        <20210209185154.1037852-2-imbrenda@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  9 Feb 2021 19:51:52 +0100
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> In most testcases, we enter problem state (userspace) just to test if a
> privileged instruction causes a fault. In some cases, though, we need
> to test if an instruction works properly in userspace. This means that
> we do not expect a fault, and we need an orderly way to leave problem
> state afterwards.
> 
> This patch introduces a simple system based on the SVC instruction.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h |  5 +++++
>  lib/s390x/interrupt.c    | 12 ++++++++++--
>  2 files changed, 15 insertions(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

