Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A238F240ACE
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 17:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgHJPu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 11:50:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:35036 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725862AbgHJPu0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Aug 2020 11:50:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597074625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LGkjje4/7mzxzkOLf9l6R+tlJFFUpn/qiQxw8fwL3fY=;
        b=BYp5snELGOyG4Okom2Slb/qCNBu7cAvAj3Qdml0fqDvTxfIR0yQ/v+U/yyTHmYLihdxe3W
        AT8rdUGmcJfBc2ruNuuJkY+z3j6AuLvEckfaFECevVIqIGI5UCYZqbAGW19E4E5SUSYD2X
        G0/eF1RLayIVAQNgDLMwu0RuIKsn/3U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-HYlLGTndP3OhXoGCZWBexA-1; Mon, 10 Aug 2020 11:50:23 -0400
X-MC-Unique: HYlLGTndP3OhXoGCZWBexA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 312CB100CCCE;
        Mon, 10 Aug 2020 15:50:22 +0000 (UTC)
Received: from gondolin (ovpn-112-218.ams2.redhat.com [10.36.112.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD06C60BE2;
        Mon, 10 Aug 2020 15:50:17 +0000 (UTC)
Date:   Mon, 10 Aug 2020 17:50:15 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, linux-s390@vger.kernel.org,
        david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v3] s390x: Ultravisor guest API test
Message-ID: <20200810175015.23b7fcf7.cohuck@redhat.com>
In-Reply-To: <20200810154541.32974-1-frankja@linux.ibm.com>
References: <20200810173205.2daaaca1.cohuck@redhat.com>
        <20200810154541.32974-1-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 Aug 2020 11:45:41 -0400
Janosch Frank <frankja@linux.ibm.com> wrote:

> Test the error conditions of guest 2 Ultravisor calls, namely:
>      * Query Ultravisor information
>      * Set shared access
>      * Remove shared access
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/uv.h  |  74 ++++++++++++++++++++++
>  s390x/Makefile      |   1 +
>  s390x/unittests.cfg |   3 +
>  s390x/uv-guest.c    | 150 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 228 insertions(+)
>  create mode 100644 lib/s390x/asm/uv.h
>  create mode 100644 s390x/uv-guest.c

Acked-by: Cornelia Huck <cohuck@redhat.com>

