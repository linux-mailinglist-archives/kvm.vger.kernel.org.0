Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AEA2F498A
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 12:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbhAMLEc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 06:04:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726858AbhAMLEc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 06:04:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610535786;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DVnDDbW+AFRUXYsk6Cz1f+caTDRAObk/XjfhK3xvPBI=;
        b=PlM5Q5YdU2nrRmAFUf3ylOwpWYG3O0g8e5x80xrSXEb86VaExRskJg75DHL219NCy2VFMH
        M7SeIL+TobsQGbV0iDf1L+x5itaLrEGmezBaS/ldpimdPICjtDCtjoy4cHYU9sz4SrJnI/
        4wpRKK82KCInLaYcek0gTmL3AijKCH0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-TPIgihIEPLaWegGkWPt8GQ-1; Wed, 13 Jan 2021 06:03:04 -0500
X-MC-Unique: TPIgihIEPLaWegGkWPt8GQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13A031922960;
        Wed, 13 Jan 2021 11:03:03 +0000 (UTC)
Received: from gondolin (ovpn-114-8.ams2.redhat.com [10.36.114.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 786E4100760B;
        Wed, 13 Jan 2021 11:02:58 +0000 (UTC)
Date:   Wed, 13 Jan 2021 12:02:55 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 3/9] s390x: SCLP feature checking
Message-ID: <20210113120255.7bca1b02.cohuck@redhat.com>
In-Reply-To: <20210112132054.49756-4-frankja@linux.ibm.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
        <20210112132054.49756-4-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 12 Jan 2021 08:20:48 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Availability of SIE is announced via a feature bit in a SCLP info CPU
> entry. Let's add a framework that allows us to easily check for such
> facilities.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  lib/s390x/io.c   |  1 +
>  lib/s390x/sclp.c | 25 +++++++++++++++++++++++++
>  lib/s390x/sclp.h | 13 ++++++++++++-
>  3 files changed, 38 insertions(+), 1 deletion(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

