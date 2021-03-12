Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC963338B5D
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 12:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhCLLR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 06:17:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44425 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233643AbhCLLRk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 06:17:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615547860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ET77rzEcNEG7UVxYgAeSUgpISB3Zq/cp8HgJxaZGTsg=;
        b=VMkaxvXv0i7NPRVqqV3VqdQtY/rQ6VvdJutxrMk7nmXoozF0Z6O39y+AfzJVpOaKEVfNUl
        RAcxDK+cpOrbniUcTOPtNSyBTkVoFKkc+0c/dsZ6PpzbqdrLg4Ov8NzHo9NL4apK5UsnMu
        hPQKM6+aXUoIsoO0XUrFmmTxGtFNBZQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-KxTlWHfcNaiupfoWidaCIw-1; Fri, 12 Mar 2021 06:17:36 -0500
X-MC-Unique: KxTlWHfcNaiupfoWidaCIw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1AEE618460E0;
        Fri, 12 Mar 2021 11:17:35 +0000 (UTC)
Received: from gondolin (ovpn-113-3.ams2.redhat.com [10.36.113.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 151396A032;
        Fri, 12 Mar 2021 11:17:29 +0000 (UTC)
Date:   Fri, 12 Mar 2021 12:17:27 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v6 5/6] s390x: css: testing measurement
 block format 0
Message-ID: <20210312121727.0328f7ab.cohuck@redhat.com>
In-Reply-To: <1615545714-13747-6-git-send-email-pmorel@linux.ibm.com>
References: <1615545714-13747-1-git-send-email-pmorel@linux.ibm.com>
        <1615545714-13747-6-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Mar 2021 11:41:53 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We test the update of the measurement block format 0, the
> measurement block origin is calculated from the mbo argument
> used by the SCHM instruction and the offset calculated using
> the measurement block index of the SCHIB.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h | 12 +++++++
>  s390x/css.c     | 83 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 95 insertions(+)
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

