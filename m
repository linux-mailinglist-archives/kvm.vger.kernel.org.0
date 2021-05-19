Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08692388937
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 10:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244670AbhESIRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 04:17:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240732AbhESIRa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 May 2021 04:17:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621412170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h5dhb9evcOZjvVUhntY3IpI+oiAKCg0ITWYWt/oMY8I=;
        b=anLaBaIssfzX7KHau1LWUOTFUB9gzRa+YWR9ppcnmzurU/m3B5ZBLUJz2aGbehtpdtwX2/
        pVOgkgvpTE4MT2ElJwjyDC0vw0n1swX7PGAQmnrqLEc+2prG8Uqrfo1J+Tt0nBwZiu/x+o
        XvhRoxRpxj76/Kth65k8ofDNtIrPqvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-0qJQ6Q3FO8SwmMLJeyvSFg-1; Wed, 19 May 2021 04:16:09 -0400
X-MC-Unique: 0qJQ6Q3FO8SwmMLJeyvSFg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6F1A8015C6;
        Wed, 19 May 2021 08:16:07 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-85.ams2.redhat.com [10.36.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A33F614F5;
        Wed, 19 May 2021 08:16:02 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 0/6] s390x: uv: Extend guest test and
 add host test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com
References: <20210519074022.7368-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <b36ae9db-6973-8b4b-36a8-5291edf823b1@redhat.com>
Date:   Wed, 19 May 2021 10:16:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210519074022.7368-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/2021 09.40, Janosch Frank wrote:
> My stack of patches is starting to lean, so lets try to put some of
> them upstream...
> 
> The first part is just additions to the UV guest test and a library
> that makes checking the installed UV calls easier. Additionally we now
> check for the proper UV share/unshare availability when allocating IO
> memory instead of only relying on stfle 158.
> 
> The second part adds a UV host test with a large number UV of return
> code checks.
> 
> v3:
> 	* Minor changes due to review
> 	* I'll pick this on Friday if there are no more remarks

 From a very quick look on the patches, this looks fine to me.

Series
Acked-by: Thomas Huth <thuth@redhat.com>

