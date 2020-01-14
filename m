Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEDA213ADD0
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 16:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgANPkH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 10:40:07 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36803 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726265AbgANPkH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Jan 2020 10:40:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579016406;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=EF4Ge4HsEP+X3JAUjL6dSJNrSuw+NmMOzxTt1atfmnU=;
        b=cARTwvW5tyIeUZ2OyWXKeDXtHLM3y9DhSpFftdsko7XFk5Rj8868o5H7iq/3nes+lNgeha
        2vlp20ARojEQzI8n9HQ7yLqvO3JLgqgjH/Yjwsc7fiCmzhxFWnCjOnAGOSiUBjDOH8GHMN
        qE3LrwL+0BtVFU7KWhPXORQlN/KOMuc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-UsUnnsxwPCiyhy_zDDNtTw-1; Tue, 14 Jan 2020 10:40:05 -0500
X-MC-Unique: UsUnnsxwPCiyhy_zDDNtTw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07B3164A84;
        Tue, 14 Jan 2020 15:40:04 +0000 (UTC)
Received: from thuth.remote.csb (unknown [10.36.118.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E42C41081304;
        Tue, 14 Jan 2020 15:39:59 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 1/4] s390x: smp: Cleanup smp.c
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com
References: <20200114153054.77082-1-frankja@linux.ibm.com>
 <20200114153054.77082-2-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <92df9483-35a4-9276-603c-da4135bd31fe@redhat.com>
Date:   Tue, 14 Jan 2020 16:39:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200114153054.77082-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/2020 16.30, Janosch Frank wrote:
> Let's remove a lot of badly formatted code by introducing the
> wait_for_flag() function.
> 
> Also let's remove some stray spaces.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/smp.c | 41 +++++++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 18 deletions(-)

OMG, did I really merge that original code in that shape?

Reviewed-by: Thomas Huth <thuth@redhat.com>

