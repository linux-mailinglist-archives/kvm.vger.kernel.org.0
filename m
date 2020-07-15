Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE2B2209A4
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 12:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbgGOKPf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 06:15:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55301 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725811AbgGOKPe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 06:15:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594808133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7IEFiod6Vjsr81HPMuPjVs9Lcs7lWGS9rUHpHAde6zk=;
        b=TDFYrZxRzqXqQj2rS179t275sg9yO00vnG2psSgar0jmPIfvdXJQSuVOKvVoqciqF86Jzw
        UnUU/XwqKTWJQNL7/w6spj676Z6y9E+Ve/QS92HJMGbLwqJpyuHQACcPSR00iLzI79PD83
        R606lmzL5jliSQjE9K/po5eIWoNzmOk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196--IzpXE1HPUyxwE65nqnK1g-1; Wed, 15 Jul 2020 06:15:31 -0400
X-MC-Unique: -IzpXE1HPUyxwE65nqnK1g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C5DF1800D42;
        Wed, 15 Jul 2020 10:15:30 +0000 (UTC)
Received: from gondolin (ovpn-112-242.ams2.redhat.com [10.36.112.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 084E9710BE;
        Wed, 15 Jul 2020 10:15:25 +0000 (UTC)
Date:   Wed, 15 Jul 2020 12:15:23 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        drjones@redhat.com
Subject: Re: [kvm-unit-tests PATCH v12 9/9] s390x: css: ssch/tsch with sense
 and interrupt
Message-ID: <20200715121523.1a4244fb.cohuck@redhat.com>
In-Reply-To: <1594725348-10034-10-git-send-email-pmorel@linux.ibm.com>
References: <1594725348-10034-1-git-send-email-pmorel@linux.ibm.com>
        <1594725348-10034-10-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jul 2020 13:15:48 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> After a channel is enabled we start a SENSE_ID command using
> the SSCH instruction to recognize the control unit and device.
> 
> This tests the success of SSCH, the I/O interruption and the TSCH
> instructions.
> 
> The SENSE_ID command response is tested to report 0xff inside
> its reserved field and to report the same control unit type
> as the cu_type kernel argument.
> 
> Without the cu_type kernel argument, the test expects a device
> with a default control unit type of 0x3832, a.k.a virtio-net-ccw.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h |   1 +
>  lib/s390x/css.h          |  35 ++++++++
>  lib/s390x/css_lib.c      | 180 +++++++++++++++++++++++++++++++++++++++
>  s390x/css.c              |  80 +++++++++++++++++
>  4 files changed, 296 insertions(+)

Other than the padding issue, looks good to me now.

