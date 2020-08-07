Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D2323ED2C
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 14:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbgHGMPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 08:15:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27577 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728390AbgHGMPL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 08:15:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596802494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=ecSO9kvnzL4/E7B1q9r5gEQVsX4NA+nYALAifDU8s/0=;
        b=DBhP9h0iyOf1sjFlp06Y3bz+rl4JWCYdye4QSECIYYmIJpE8UZoO5OEPunSwJfYvY0A9dQ
        CLTxyXZwOzgaRnE7Hq3fFwe7OfhdbearFSbzD0wvzVstp54Ukm8nnjNd2tWz7chS1BlLoF
        WSLurG7bwPlMUjTvfouRP7vUFse9AZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-g_5ADSzPPAWVwmJF3GROLQ-1; Fri, 07 Aug 2020 08:14:50 -0400
X-MC-Unique: g_5ADSzPPAWVwmJF3GROLQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6D8E8015F4;
        Fri,  7 Aug 2020 12:14:49 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-31.ams2.redhat.com [10.36.113.31])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9E76F5DA7B;
        Fri,  7 Aug 2020 12:14:44 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 3/3] s390x: Ultravisor guest API test
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, imbrenda@linux.ibm.com
References: <20200807111555.11169-1-frankja@linux.ibm.com>
 <20200807111555.11169-4-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <819966b7-a906-247c-a866-2adcaa541d9f@redhat.com>
Date:   Fri, 7 Aug 2020 14:14:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200807111555.11169-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/08/2020 13.15, Janosch Frank wrote:
> Test the error conditions of guest 2 Ultravisor calls, namely:
>      * Query Ultravisor information
>      * Set shared access
>      * Remove shared access
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/uv.h  |  74 ++++++++++++++++++++
>  s390x/Makefile      |   1 +
>  s390x/unittests.cfg |   3 +
>  s390x/uv-guest.c    | 162 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 240 insertions(+)
>  create mode 100644 lib/s390x/asm/uv.h
>  create mode 100644 s390x/uv-guest.
Acked-by: Thomas Huth <thuth@redhat.com>

