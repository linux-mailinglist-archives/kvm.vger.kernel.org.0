Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B93C14DEF7
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 17:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727341AbgA3QXJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 11:23:09 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24911 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727158AbgA3QXJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 11:23:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580401388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sJSQD3AXl/EaZ99zNfwoAQo1e7uugD5rp6Es/BTAolQ=;
        b=CKuXHfBf1JNFuKL31nQkU4qUj7LCb4v3lz8Yu29qsew7i7Trnd4bXFT47xsVQbFxAlLHna
        3eLLEAc1ikliGze6kFp7+dtzQx5OArzaPiqxFKUku7paej5K+/xPLq0qzRzwZHWAaaR0EA
        vAr/mA4h7UjGvTvSd/so0fO3etJ1djE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-usqeU-CpOr2p3w_KRa8z-w-1; Thu, 30 Jan 2020 11:23:04 -0500
X-MC-Unique: usqeU-CpOr2p3w_KRa8z-w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2595800D41;
        Thu, 30 Jan 2020 16:23:03 +0000 (UTC)
Received: from gondolin (ovpn-117-199.ams2.redhat.com [10.36.117.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9733A77921;
        Thu, 30 Jan 2020 16:22:57 +0000 (UTC)
Date:   Thu, 30 Jan 2020 17:22:55 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        david@redhat.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH v9 5/6] selftests: KVM: s390x: Add reset tests
Message-ID: <20200130172255.4b38c058.cohuck@redhat.com>
In-Reply-To: <20200130123434.68129-6-frankja@linux.ibm.com>
References: <20200130123434.68129-1-frankja@linux.ibm.com>
        <20200130123434.68129-6-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 30 Jan 2020 07:34:33 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Test if the registers end up having the correct values after a normal,
> initial and clear reset.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  tools/testing/selftests/kvm/Makefile       |   1 +
>  tools/testing/selftests/kvm/s390x/resets.c | 157 +++++++++++++++++++++
>  2 files changed, 158 insertions(+)
>  create mode 100644 tools/testing/selftests/kvm/s390x/resets.c

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

