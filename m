Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E142D13B139
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 18:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgANRoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 12:44:23 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36275 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726053AbgANRoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 12:44:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579023862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cCouyPJZFQqvwQCfI2uNbIw3Dg2LO+oMcqx713KwmdU=;
        b=FWxo0YlxlKODha+VxeOYfFUL9vrbwbFJtAH4dabhfvjmIudZ/g/GqaqzVsPLt6QM0ZXASd
        8S7qiD6tE1ggVH5iUcQNHx/xTg2q6Qp8CI5otwnuSjNcSymQPF9JIUxouzAfLXuH0vrbto
        xcHTGhhAn/M0DUzYWF8z3dTZVMmCnJc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-_9gYESG4O2uyBkJ8iOBoyg-1; Tue, 14 Jan 2020 12:44:19 -0500
X-MC-Unique: _9gYESG4O2uyBkJ8iOBoyg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA0E7109D3B1;
        Tue, 14 Jan 2020 17:44:17 +0000 (UTC)
Received: from gondolin (ovpn-117-161.ams2.redhat.com [10.36.117.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 258ED60BE0;
        Tue, 14 Jan 2020 17:44:13 +0000 (UTC)
Date:   Tue, 14 Jan 2020 18:44:11 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/4] s390x: smp: Only use smp_cpu_setup
 once
Message-ID: <20200114184411.24909aae.cohuck@redhat.com>
In-Reply-To: <20200114153054.77082-3-frankja@linux.ibm.com>
References: <20200114153054.77082-1-frankja@linux.ibm.com>
        <20200114153054.77082-3-frankja@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 Jan 2020 10:30:51 -0500
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's stop and start instead of using setup to run a function on a
> cpu.

Looking at the code, we only support active == operating state and
!active == stopped state anyway, right?

> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/smp.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

