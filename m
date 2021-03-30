Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB7334E6DF
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 13:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhC3LuG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 07:50:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26393 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231852AbhC3Lto (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 07:49:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617104983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s/aUVtrGnv0w4jjv/62lCA8fjYd04Hwno2kUxRXx/ao=;
        b=MsfFsrfnzvKvko6ppnxQJGWLTLJFpRely2PA8R+Ngw9EYi6U4GAgFC1rgDxRj+9naje0yQ
        Ax5vdLbnqwSJA4IvXD6d0mqQ5I+SFjgwWfa+uA4dgcmoy7k7TsDAYzr+B3tDemKsI9Ndsi
        t5uf3wyJFN1XUqK+R7EjiUGFqVrxAYg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-LL5eYNmIM4O4tqw5aJdMBw-1; Tue, 30 Mar 2021 07:49:39 -0400
X-MC-Unique: LL5eYNmIM4O4tqw5aJdMBw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FF0B108BD0A;
        Tue, 30 Mar 2021 11:49:38 +0000 (UTC)
Received: from gondolin (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5A01505AB;
        Tue, 30 Mar 2021 11:49:33 +0000 (UTC)
Date:   Tue, 30 Mar 2021 13:49:31 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 2/8] s390x: lib: css: SCSW bit
 definitions
Message-ID: <20210330134931.169d071d.cohuck@redhat.com>
In-Reply-To: <1616665147-32084-3-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
        <1616665147-32084-3-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Mar 2021 10:39:01 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We need the SCSW definitions to test clear and halt subchannel.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css.h | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

