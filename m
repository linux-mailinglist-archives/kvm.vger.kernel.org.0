Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF6514EBEE
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 12:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgAaLrr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 06:47:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29452 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728408AbgAaLrq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jan 2020 06:47:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580471265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=R6Rt5/B9CnVWzD/y2yfe5Frqkxpb+qB2Xh0vRDea+6c=;
        b=fzu97AJe/1wK05v2DGEnoBtpU6QVVtx6FsjXaxTbkO3wlDDWK72M3mg7XDsEjvW7Ijhz2E
        Kaj85b/Xf57xNCKi11n3K1SJjAMTneLi/B5g026Tf9/aLYwbbnHwsETvv112ehZxup7LiM
        IxUN9D12bBqnsU7klED/TKucmyg51pQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-PXCR6itROBO0-owMW2gZZQ-1; Fri, 31 Jan 2020 06:47:41 -0500
X-MC-Unique: PXCR6itROBO0-owMW2gZZQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 622C9801FA0;
        Fri, 31 Jan 2020 11:47:40 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-176.ams2.redhat.com [10.36.116.176])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 84E9A89A7A;
        Fri, 31 Jan 2020 11:47:34 +0000 (UTC)
Subject: Re: [PATCH v10 6/6] selftests: KVM: testing the local IRQs resets
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
References: <20200131100205.74720-1-frankja@linux.ibm.com>
 <20200131100205.74720-7-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b72b4119-913b-9bed-069f-18c0eb4c910f@redhat.com>
Date:   Fri, 31 Jan 2020 12:47:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200131100205.74720-7-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/01/2020 11.02, Janosch Frank wrote:
> From: Pierre Morel <pmorel@linux.ibm.com>
> 
> Local IRQs are reset by a normal cpu reset.  The initial cpu reset and
> the clear cpu reset, as superset of the normal reset, both clear the
> IRQs too.
> 
> Let's inject an interrupt to a vCPU before calling a reset and see if
> it is gone after the reset.
> 
> We choose to inject only an emergency interrupt at this point and can
> extend the test to other types of IRQs later.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>[minor fixups]
> ---
>  tools/testing/selftests/kvm/s390x/resets.c | 42 ++++++++++++++++++++++
>  1 file changed, 42 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>

