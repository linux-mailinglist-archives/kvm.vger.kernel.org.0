Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003C623ED27
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 14:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgHGMNP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 08:13:15 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34955 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727992AbgHGMNM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Aug 2020 08:13:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596802390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=XmQ6IZfq3kqlI1RbLaJNYtlkDoamlG8j8Yisgp7CC7Y=;
        b=QupLAI4Y/ADFKaRjqEJMswgBOD/UrtuOuyea60gYG9Arf8Y91iFBetXoKnGs0xNy4+aGpc
        fv7K3o9Mb4a0zFkHO0IwQjY8sAij89tD1yAD3IBFRrhXsjVQ4OH8igKe0qG3nAmb8PDXI+
        /g4sHpszG5d4IGLggQpHR+BT0GogcX8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-tV7H4dXcOxS_Zk4h10wPOg-1; Fri, 07 Aug 2020 08:13:07 -0400
X-MC-Unique: tV7H4dXcOxS_Zk4h10wPOg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A64C01005504;
        Fri,  7 Aug 2020 12:13:06 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-31.ams2.redhat.com [10.36.113.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DDB6987A72;
        Fri,  7 Aug 2020 12:13:00 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 2/3] s390x: skrf: Add exception new skey
 test and add test to unittests.cfg
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <20200807111555.11169-1-frankja@linux.ibm.com>
 <20200807111555.11169-3-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <da95ddbb-0761-8319-3833-b5f506e87af7@redhat.com>
Date:   Fri, 7 Aug 2020 14:12:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200807111555.11169-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/08/2020 13.15, Janosch Frank wrote:
> When an exception new psw with a storage key in its mask is loaded
> from lowcore, a specification exception is raised. This differs from
> the behavior when trying to execute skey related instructions, which
> will result in special operation exceptions.
> 
> Also let's add the test to unittests.cfg so it is run more often.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  s390x/skrf.c        | 79 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  4 +++
>  2 files changed, 83 insertions(+)

It's hot here today, so my review skills might have melted a little bit,
but as far as I can see, it looks fine now:

Reviewed-by: Thomas Huth <thuth@redhat.com>

