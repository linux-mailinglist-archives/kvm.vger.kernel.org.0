Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604621FAF73
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 13:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgFPLnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 07:43:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25644 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725775AbgFPLnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 07:43:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592307825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=M+8CvZDKz0wIORvL13CTv3SCi9eZNzb0Yh8dNmDQqiE=;
        b=SsAY3TNErXLcJUnn0XYWsj0VeSjYB1keU+NjkbxbGTQPIOjp63TFzNEUF5XebZrKmPprdm
        BAKF+zgXNPmlmuM1nTtbD+09ivAHa/UaP9rX0K1WYjmCRzgAcZ1M35bmpmE2BcGsxfY1Iy
        QwHBE7LzufHHBYtcogp6vtDSxKf16BY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-d7qouaOkOIq3SH-NWbusyg-1; Tue, 16 Jun 2020 07:43:41 -0400
X-MC-Unique: d7qouaOkOIq3SH-NWbusyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63B538035EC;
        Tue, 16 Jun 2020 11:43:40 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 149B619C71;
        Tue, 16 Jun 2020 11:43:35 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v9 11/12] s390x: css: msch, enable test
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-12-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <665f6c4c-6e72-5980-a3c8-d6ca31ff470c@redhat.com>
Date:   Tue, 16 Jun 2020 13:43:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1592213521-19390-12-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/2020 11.32, Pierre Morel wrote:
> A second step when testing the channel subsystem is to prepare a channel
> for use.
> This includes:
> - Get the current subchannel Information Block (SCHIB) using STSCH
> - Update it in memory to set the ENABLE bit
> - Tell the CSS that the SCHIB has been modified using MSCH
> - Get the SCHIB from the CSS again to verify that the subchannel is
>   enabled.
> - If the command succeeds but subchannel is not enabled retry a
>   predefined retries count.
> - If the command fails, report the failure and do not retry, even
>   if cc indicates a busy/status pending as we do not expect this.
> 
> This tests the MSCH instruction to enable a channel succesfuly.

s/succesfuly/successfully/

> This some retries are done and in case of error, and if the retries
> count is exceeded, a report is made.

That sentence needs some fixes, too ;-)

With the commit description fixed:

Acked-by: Thomas Huth <thuth@redhat.com>

