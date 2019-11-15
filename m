Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00F76FDABF
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 11:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbfKOKIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 05:08:09 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38132 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727333AbfKOKII (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 05:08:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573812487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UPDk8KT2AtW6wu0JQiQ/CljtgdMmAWJUdl6kv7f8bPE=;
        b=Unbp33RtbkYSTypu4fW4WMj0O2gIkNNPazVqbWjNz1Jys/3hVJ8itSluDt/hFxCLhH4hp2
        AXo6U8cRIeZDsngM9E/i7l6PnIaR9HK4wl6C0Do4gVqdzhz87i0wRWV9DcwZm1SY4TIbME
        zESbbrTH8OmekJ+DxWA3cBwzz1PbYJo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-tdGAnN0BMBqcdh6THQIieQ-1; Fri, 15 Nov 2019 05:08:01 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25E952F2A;
        Fri, 15 Nov 2019 10:07:59 +0000 (UTC)
Received: from localhost.localdomain (ovpn-117-14.ams2.redhat.com [10.36.117.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2266960556;
        Fri, 15 Nov 2019 10:07:53 +0000 (UTC)
Subject: Re: [RFC 32/37] KVM: s390: protvirt: UV calls diag308 0, 1
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com
References: <20191024114059.102802-1-frankja@linux.ibm.com>
 <20191024114059.102802-33-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <6fb6b03f-5a33-34ec-53e6-d960ac7bbae6@redhat.com>
Date:   Fri, 15 Nov 2019 11:07:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191024114059.102802-33-frankja@linux.ibm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: tdGAnN0BMBqcdh6THQIieQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2019 13.40, Janosch Frank wrote:
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/uv.h | 25 +++++++++++++++++++++++++
>  arch/s390/kvm/diag.c       |  1 +
>  arch/s390/kvm/kvm-s390.c   | 20 ++++++++++++++++++++
>  arch/s390/kvm/kvm-s390.h   |  2 ++
>  arch/s390/kvm/pv.c         | 19 +++++++++++++++++++
>  include/uapi/linux/kvm.h   |  2 ++
>  6 files changed, 69 insertions(+)

Add at least a short patch description what this patch is all about?

 Thomas

