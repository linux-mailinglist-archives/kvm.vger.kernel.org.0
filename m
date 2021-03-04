Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867FB32D2D0
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 13:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240514AbhCDMZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 07:25:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240387AbhCDMYw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 07:24:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614860606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YXQ6T/kCoY/xq83HGnHtE5TYINF0iV5k/bZaLfBv74w=;
        b=a7yLuOC5OK3H82g0y8WkLmNF1KsMMj8Ha1vwwZqR9FpcjvajcjeuE7tal5qFyKyOomaB4G
        MI3XsfSHufNxS24sDVmqtJbKMrRD5+DjBn+25NRwBq6HHaWlm3IuveDVdqUC++SHQP7MHg
        YFqiJjpidk8ngUtvgwHERQSa2hb6Mnk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-433-MeHIx61FOoGoVHZOcyDghg-1; Thu, 04 Mar 2021 07:23:24 -0500
X-MC-Unique: MeHIx61FOoGoVHZOcyDghg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BE051940923;
        Thu,  4 Mar 2021 12:23:22 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-31.ams2.redhat.com [10.36.112.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E836608BA;
        Thu,  4 Mar 2021 12:23:15 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 4/7] s390x: Provide preliminary
 backtrace support
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210222085756.14396-1-frankja@linux.ibm.com>
 <20210222085756.14396-5-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <9ee0038e-8b74-381e-8ccb-6975397805e2@redhat.com>
Date:   Thu, 4 Mar 2021 13:23:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210222085756.14396-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/02/2021 09.57, Janosch Frank wrote:
> After the stack changes we can finally use -mbackchain and have a
> working backtrace.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>   lib/s390x/stack.c | 20 ++++++++++++++------
>   s390x/Makefile    |  1 +
>   s390x/macros.S    |  5 +++++
>   3 files changed, 20 insertions(+), 6 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

