Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7C522EA27
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 12:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgG0Kgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 06:36:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52269 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726278AbgG0Kgf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Jul 2020 06:36:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595846194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=q10Zn+5RNMik3uoxOw1KKyn1phkLl+GR3F/iF0Bl0mg=;
        b=c2X2K8VSSErzyNJqjypnIiEkhE6mHppArDjGPK3aYCwY0P32fgMQOGaFwTcihcGoKHJaj3
        aCoIHA1giVSLDR+mIP0zn+xLsbzubX7jin5eQffxjcFgwwpZhOJAcVi1pXtsPtjGZ9CQ9/
        9yxyVtqW2e5doz5Kdx+bGRUyPEfsokI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-VgKRTpM2ONeu7dwFHSioCA-1; Mon, 27 Jul 2020 06:36:32 -0400
X-MC-Unique: VgKRTpM2ONeu7dwFHSioCA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C1AB58;
        Mon, 27 Jul 2020 10:36:31 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-156.ams2.redhat.com [10.36.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F0491712C5;
        Mon, 27 Jul 2020 10:36:26 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: fix inline asm on gcc10
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        david@redhat.com
Cc:     frankja@linux.ibm.com, borntraeger@de.ibm.com
References: <20200727102643.15439-1-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <98937897-36f6-9d16-6872-c0f29e4d94ba@redhat.com>
Date:   Mon, 27 Jul 2020 12:36:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200727102643.15439-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/07/2020 12.26, Claudio Imbrenda wrote:
> Fix compilation issues on 390x with gcc 10.
> 
> Simply mark the inline functions that lead to a .insn with a variable
> opcode as __always_inline, to make gcc 10 happy.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/s390x/asm/cpacf.h |  5 +++--
>  s390x/emulator.c      | 25 +++++++++++++------------
>  2 files changed, 16 insertions(+), 14 deletions(-)

I wonder why they change the behavior there ... but ok, we're using "i"
as constraint here, so I guess that's only fair that inlining has to be
enforced here.

Reviewed-by: Thomas Huth <thuth@redhat.com>

