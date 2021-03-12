Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3831F339286
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 16:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhCLP4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 10:56:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44224 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232217AbhCLP4m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Mar 2021 10:56:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615564601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iNRqHcH9ezVvoDkXmsp5dMKADlIQxuqTBWArK12WKOY=;
        b=dvi8OgSsFGWvc22jn02QxNWA1GYMAmfptHQLAG0W5eq77XY3KhojhTXocdBgPSfCzQRrah
        YbIo9hEFzF/X/llVYEn9yaNylcB6UzJXQsM4Y9Ea1BwtkO5UbBc4KXzk9gOVE2L5qbKIJW
        KD/gLdHqwqiK+gbXIb2UODWmORb+Ios=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-533-AmwVcowHNL29SXiSWjhFBw-1; Fri, 12 Mar 2021 10:56:39 -0500
X-MC-Unique: AmwVcowHNL29SXiSWjhFBw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9ECD81015C84;
        Fri, 12 Mar 2021 15:56:38 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-83.ams2.redhat.com [10.36.112.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A47445C1D1;
        Fri, 12 Mar 2021 15:56:32 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: mvpg: add checks for
 op_acc_id
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, frankja@linux.ibm.com, cohuck@redhat.com,
        pmorel@linux.ibm.com
References: <20210312124700.142269-1-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <4dff44ab-f668-c405-cdaf-0ff01b33d23f@redhat.com>
Date:   Fri, 12 Mar 2021 16:56:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210312124700.142269-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/03/2021 13.47, Claudio Imbrenda wrote:
> Check the operand access identification when MVPG causes a page fault.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/mvpg.c | 28 ++++++++++++++++++++++++++--
>   1 file changed, 26 insertions(+), 2 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>

