Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC536332CD5
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 18:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhCIRHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 12:07:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230449AbhCIRHi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 12:07:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615309658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=62Dh6fDhzxvpI/AB8usXsolyU5b8q0Cj8DjwhUUekiY=;
        b=VNaYZOz527MGPE3iXWJGTLV07xHDJzulDpCSc8Uj8J2eIKmo2U6c8GlzX2F2Snmg63z0rO
        I7q/ErnW9mB5A+zQJZ/U9gzBdU4Nm6PLTkheUI52PELMxyJIj/pBZtNHUtWak+a6yxzD67
        qIk1RJCqapEwSoqgSYR96oy1/MNKbos=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-Ukd3KAHoPQO1RFWQI3ALCw-1; Tue, 09 Mar 2021 12:07:35 -0500
X-MC-Unique: Ukd3KAHoPQO1RFWQI3ALCw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3E6410866A4;
        Tue,  9 Mar 2021 17:07:33 +0000 (UTC)
Received: from gondolin (ovpn-113-144.ams2.redhat.com [10.36.113.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7215B772E0;
        Tue,  9 Mar 2021 17:07:29 +0000 (UTC)
Date:   Tue, 9 Mar 2021 18:07:26 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v5 6/6] s390x: css: testing measurement
 block format 1
Message-ID: <20210309180726.29e4784e.cohuck@redhat.com>
In-Reply-To: <1615294277-7332-7-git-send-email-pmorel@linux.ibm.com>
References: <1615294277-7332-1-git-send-email-pmorel@linux.ibm.com>
        <1615294277-7332-7-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  9 Mar 2021 13:51:17 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> Measurement block format 1 is made available by the extended
> measurement block facility and is indicated in the SCHIB by
> the bit in the PMCW.
> 
> The MBO is specified in the SCHIB of each channel and the MBO
> defined by the SCHM instruction is ignored.
> 
> The test of the MB format 1 is just skipped if the feature is
> not available.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h     | 15 +++++++++
>  lib/s390x/css_lib.c |  2 +-
>  s390x/css.c         | 75 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 91 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

