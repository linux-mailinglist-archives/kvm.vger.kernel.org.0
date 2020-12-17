Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716522DCE9D
	for <lists+kvm@lfdr.de>; Thu, 17 Dec 2020 10:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgLQJnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 04:43:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33245 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726580AbgLQJnP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Dec 2020 04:43:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608198109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H2XVrk2AJJp4CJ8n06Zkzcq6Y9TW+1iPGv2KP9Jtymc=;
        b=FmXH2zNbwsRiTi9DgEfqZJ5fohlgOq8NYVvQ1/rA1JpXWKkqK7uS1XaNXbVI+3KzSB2RZW
        ns9nFIWdTQvA2c6RiVFJnM4nEuQKep4xK6LAhILTUwL79xLxwOQgAaIvpWXurgVJ+WgIsY
        q9f8rayw12r+M1bKgdOzHeNlQtFaUug=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-MKt3HST8OC-4NUmVZbTNMQ-1; Thu, 17 Dec 2020 04:41:47 -0500
X-MC-Unique: MKt3HST8OC-4NUmVZbTNMQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 481AE107ACE4;
        Thu, 17 Dec 2020 09:41:46 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-175.ams2.redhat.com [10.36.112.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A95B019CAC;
        Thu, 17 Dec 2020 09:41:41 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 6/8] s390x: sie: Add first SIE test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20201211100039.63597-1-frankja@linux.ibm.com>
 <20201211100039.63597-7-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <4581bb7d-145b-4ba4-9192-e29908975411@redhat.com>
Date:   Thu, 17 Dec 2020 10:41:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201211100039.63597-7-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/12/2020 11.00, Janosch Frank wrote:
> Let's check if we get the correct interception data on a few
> diags. This commit is more of an addition of boilerplate code than a
> real test.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile      |   1 +
>  s390x/sie.c         | 113 ++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |   3 ++
>  3 files changed, 117 insertions(+)
>  create mode 100644 s390x/sie.c

Reviewed-by: Thomas Huth <thuth@redhat.com>

