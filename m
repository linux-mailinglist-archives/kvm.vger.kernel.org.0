Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A14BB2783B1
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 11:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgIYJNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 05:13:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727753AbgIYJNE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 05:13:04 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601025183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zLzJTr4bTW78Tt/ynchyVWuf2wzk5e1UGEU9ZqIQGPk=;
        b=A2ZbrM5c/FRJv+XeJ/wQbWjaZEL4A/dIeYQWhdmdHnZA6QqKm06+4TD+V0EFxW+e+Fbq9Q
        LaWlxlT+BscXSf283+aYM9iYibMiLPhBCdHzBfkcTN9qDMYQubXxiMa8WoLf+JOPmOqY/d
        yOo03R+sabFy/zvuW1sB7qLDEV/yixE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-m05HdVNEMOOdgXsHT1xQeQ-1; Fri, 25 Sep 2020 05:13:01 -0400
X-MC-Unique: m05HdVNEMOOdgXsHT1xQeQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1114C800E23;
        Fri, 25 Sep 2020 09:13:00 +0000 (UTC)
Received: from gondolin (ovpn-112-192.ams2.redhat.com [10.36.112.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67A6D5D9F1;
        Fri, 25 Sep 2020 09:12:52 +0000 (UTC)
Date:   Fri, 25 Sep 2020 11:12:49 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests v2 4/4] s390x: add Protected VM support
Message-ID: <20200925111249.4b9203c5.cohuck@redhat.com>
In-Reply-To: <20200923134758.19354-5-mhartmay@linux.ibm.com>
References: <20200923134758.19354-1-mhartmay@linux.ibm.com>
        <20200923134758.19354-5-mhartmay@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Sep 2020 15:47:58 +0200
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

> Add support for Protected Virtual Machine (PVM) tests. For starting a
> PVM guest we must be able to generate a PVM image by using the
> `genprotimg` tool from the s390-tools collection. This requires the
> ability to pass a machine-specific host-key document, so the option
> `--host-key-document` is added to the configure script.
> 
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  configure               |  9 +++++++++
>  s390x/Makefile          | 17 +++++++++++++++--
>  s390x/selftest.parmfile |  1 +
>  s390x/unittests.cfg     |  1 +
>  scripts/s390x/func.bash | 36 ++++++++++++++++++++++++++++++++++++
>  5 files changed, 62 insertions(+), 2 deletions(-)
>  create mode 100644 s390x/selftest.parmfile
>  create mode 100644 scripts/s390x/func.bash

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

