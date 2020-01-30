Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2CFE14DB2E
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 14:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgA3NDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 08:03:12 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50786 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727262AbgA3NDL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 08:03:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580389390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TUw6nGsPLtP4tbZzFLzZKwLjlVq3/wPEstRdnOgaJpY=;
        b=bvKQ+jdFCd3oJVjD5rcsSxEw5t+Sxk0NxhGodFrDicap9gUwepDc/OLqNaOOLCpygfwFXG
        z6ETe+OVcO9mHV2KLw+pAXMjyqEB+UnApAgjmnF05b1g86xMCD3EBakT43c2NBhgNOaVlG
        0BAxW/SkjvpUmklaIcdIPsRDZUKsBEY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-JfCQTqh5MwGR0f7ItmWNbw-1; Thu, 30 Jan 2020 08:03:07 -0500
X-MC-Unique: JfCQTqh5MwGR0f7ItmWNbw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4B92DB61;
        Thu, 30 Jan 2020 13:03:05 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1B9977927;
        Thu, 30 Jan 2020 13:03:01 +0000 (UTC)
Date:   Thu, 30 Jan 2020 14:03:00 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH v9 4/6] selftests: KVM: Add fpu and one reg set/get
 library functions
Message-ID: <20200130140300.42fa74df.cohuck@redhat.com>
In-Reply-To: <20200130123434.68129-5-frankja@linux.ibm.com>
References: <20200130123434.68129-1-frankja@linux.ibm.com>
        <20200130123434.68129-5-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jan 2020 07:34:32 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Add library access to more registers.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  6 +++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 48 +++++++++++++++++++
>  2 files changed, 54 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

