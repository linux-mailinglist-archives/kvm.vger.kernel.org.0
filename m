Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEC2388B82
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 12:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347645AbhESKSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 06:18:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26781 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345378AbhESKSo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 06:18:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621419444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Rse0CwX3v4EwPAMTiV55pGGDtknB0HxYbeox35/+go=;
        b=Ot2ugz7jPW5TEQ8Eaz6ko1aciC0sCrf+JbmKnI+auYUM2duBdpEYL6pyXLzaNUzU7bptzj
        ntccKkWJ2ur1z/J1ISECNKZl8G1lFsbp2bgd2B1Q/LRutHeNTqUJuPrwtuE6GMDMlLQATd
        nQhc7YcLNflFXaFIofDEat/ny/k9HIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-bwJiwAnmMzmy_EgBcjnpFg-1; Wed, 19 May 2021 06:17:21 -0400
X-MC-Unique: bwJiwAnmMzmy_EgBcjnpFg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3529E6D4EC;
        Wed, 19 May 2021 10:17:20 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-112-33.ams2.redhat.com [10.36.112.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 560BC50FBF;
        Wed, 19 May 2021 10:17:15 +0000 (UTC)
Date:   Wed, 19 May 2021 12:17:11 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/3] lib: s390x: sclp: Extend feature
 probing
Message-ID: <20210519121711.22ed02ba.cohuck@redhat.com>
In-Reply-To: <20210519082648.46803-3-frankja@linux.ibm.com>
References: <20210519082648.46803-1-frankja@linux.ibm.com>
        <20210519082648.46803-3-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 May 2021 08:26:47 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Lets grab more of the feature bits from SCLP read info so we can use

s/Lets/Let's/ :)

> them in the cpumodel tests.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/sclp.c | 20 ++++++++++++++++++++
>  lib/s390x/sclp.h | 38 +++++++++++++++++++++++++++++++++++---
>  2 files changed, 55 insertions(+), 3 deletions(-)

(...)

Maybe add

/* bit number within a certain byte */

> +#define SCLP_FEAT_85_BIT_GSLS		7
> +#define SCLP_FEAT_98_BIT_KSS		0
> +#define SCLP_FEAT_116_BIT_64BSCAO	7
> +#define SCLP_FEAT_116_BIT_CMMA		6
> +#define SCLP_FEAT_116_BIT_ESCA		3
> +#define SCLP_FEAT_117_BIT_PFMFI		6
> +#define SCLP_FEAT_117_BIT_IBS		5
> +
>  typedef struct ReadInfo {
>  	SCCBHeader h;
>  	uint16_t rnmax;

Acked-by: Cornelia Huck <cohuck@redhat.com>

