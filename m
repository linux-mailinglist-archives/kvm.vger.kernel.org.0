Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA6F221F6E
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 11:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgGPJHe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jul 2020 05:07:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44988 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726782AbgGPJH3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jul 2020 05:07:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594890447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jQSzeGypPfKC8REuEDh9oIg7I8NHjZR/1SSWiYSFzJ0=;
        b=QCqdZ/gTr8DpMpBS7X1MDVzsJ5UPjGmzsB8nU6xFs8spUa8p6sofCozLMcomYLD8U9QILn
        fyidqcp/FLMgn3uiUX5cDP7tUth9JiqQSQTGCnVr2Bv0ROHVaYU5GfJEf0uXRXUiKw+1FE
        sEyUOehk+fsAhGaKTO4X11smdr+eFKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-ly3g8WMqPw2Cc4g0QqJUJw-1; Thu, 16 Jul 2020 05:07:25 -0400
X-MC-Unique: ly3g8WMqPw2Cc4g0QqJUJw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 60F9A100AA21;
        Thu, 16 Jul 2020 09:07:24 +0000 (UTC)
Received: from gondolin (ovpn-113-57.ams2.redhat.com [10.36.113.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3030519729;
        Thu, 16 Jul 2020 09:07:20 +0000 (UTC)
Date:   Thu, 16 Jul 2020 11:07:17 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, david@redhat.com, thuth@redhat.com,
        drjones@redhat.com
Subject: Re: [kvm-unit-tests PATCH v13 9/9] s390x: css: ssch/tsch with sense
 and interrupt
Message-ID: <20200716110717.4c399cd0.cohuck@redhat.com>
In-Reply-To: <1594887809-10521-10-git-send-email-pmorel@linux.ibm.com>
References: <1594887809-10521-1-git-send-email-pmorel@linux.ibm.com>
        <1594887809-10521-10-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Jul 2020 10:23:29 +0200
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

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

