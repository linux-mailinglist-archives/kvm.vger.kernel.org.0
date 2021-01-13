Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2692F4AF6
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 13:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbhAMMGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 07:06:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbhAMMGK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 07:06:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610539484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MyOD2IO3QG3ZtzfasndTqDoePaXBuAYrdfGO2nBFrhY=;
        b=QNqlgtBcBBwQHuMH+9Cf7BsiKJ8sttgJWhGrBtyqwJP/nnyTWs0J+b6qnBQZf6+y73YMTt
        946DYb8hr+j6uJIu2HHmlb9uO5jkN7CHDETSmpJmPp+9Hlc2W6+pYDkqywTgSqttSbayNJ
        ynLoZoaZwIyXegsFB/LcBgjhexdkopA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-571-zt60VG1XPp2iHwjYKJFxNQ-1; Wed, 13 Jan 2021 07:04:42 -0500
X-MC-Unique: zt60VG1XPp2iHwjYKJFxNQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EDFC80DDE0;
        Wed, 13 Jan 2021 12:04:41 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-122.ams2.redhat.com [10.36.112.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A13EC18AAB;
        Wed, 13 Jan 2021 12:04:36 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v4 4/9] s390x: Split assembly into multiple
 files
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org
References: <20210112132054.49756-1-frankja@linux.ibm.com>
 <20210112132054.49756-5-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <c07280f6-f56c-ea6c-1255-28a36a2385c0@redhat.com>
Date:   Wed, 13 Jan 2021 13:04:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210112132054.49756-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/01/2021 14.20, Janosch Frank wrote:
> I've added too much to cstart64.S which is not start related
> already. Now that I want to add even more code it's time to split
> cstart64.S. lib.S has functions that are used in tests. macros.S
> contains macros which are used in cstart64.S and lib.S
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/Makefile   |   6 +--
>   s390x/cstart64.S | 119 ++---------------------------------------------
>   s390x/lib.S      |  65 ++++++++++++++++++++++++++

lib.S is a very generic name ... maybe rather use cpuasm.S or something similar?

Anway,
Acked-by: Thomas Huth <thuth@redhat.com>

