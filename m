Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7421D1FAD03
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 11:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgFPJrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 05:47:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32826 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726606AbgFPJrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 05:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592300831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=fECsdLHJshowYO2rpHI6sAODPGlOgF0zj430s0JCJNA=;
        b=bGYMRIu7DR/RSnIBHWQdZms5ehV/W/04Qbo1zGxoqJk+k9BFqvx7rofaOOGJXB5YCIwQ5l
        7CCtBcv40thpzLwcYpIFIs8vJPVTFcvFuPPvkUJrxFg5yNX4BhjAhiLkXHl5YGs+2/PNVG
        9amV2XuduuYjBCg6xop2E2numCtiGOs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-jMwUbTKfONm04rt5Vj0pKQ-1; Tue, 16 Jun 2020 05:47:07 -0400
X-MC-Unique: jMwUbTKfONm04rt5Vj0pKQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 209F1100CCC6;
        Tue, 16 Jun 2020 09:47:06 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C428260BEC;
        Tue, 16 Jun 2020 09:47:01 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v9 08/12] s390x: retrieve decimal and
 hexadecimal kernel parameters
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-9-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a25fa4b1-da51-4dba-48c7-5d7154073d68@redhat.com>
Date:   Tue, 16 Jun 2020 11:47:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1592213521-19390-9-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/2020 11.31, Pierre Morel wrote:
> We often need to retrieve hexadecimal kernel parameters.
> Let's implement a shared utility to do it.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/kernel-args.c | 60 +++++++++++++++++++++++++++++++++++++++++
>  lib/s390x/kernel-args.h | 18 +++++++++++++
>  s390x/Makefile          |  1 +
>  3 files changed, 79 insertions(+)
>  create mode 100644 lib/s390x/kernel-args.c
>  create mode 100644 lib/s390x/kernel-args.h

Reviewed-by: Thomas Huth <thuth@redhat.com>

