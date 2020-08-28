Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EAA2553E7
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 06:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgH1E4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 00:56:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59436 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgH1E4v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Aug 2020 00:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598590609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jncSHQoKRJQUl+Iue8NOYzNUrAMhEPrX7a7C+0ZDdRY=;
        b=bm/Co99dAfzfrzQQ1IlajXLHjBs/e7XYrR1FZQbXPJI3M5yPU0riCjDmFW6YMZaIb4UVJJ
        1BPLc3xf1p2Hck440ixXvheRscZalmhyvDqBOx0AvZ0ksEJgEnNsNxCNlh05vdnWayhcSI
        voiHs33LfilC2eOWSlklf25es6zZNp0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-iwf17U__OwaM-VxRKfYzeA-1; Fri, 28 Aug 2020 00:56:45 -0400
X-MC-Unique: iwf17U__OwaM-VxRKfYzeA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47F251005E5D;
        Fri, 28 Aug 2020 04:56:44 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-79.ams2.redhat.com [10.36.112.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDC9560BA7;
        Fri, 28 Aug 2020 04:56:42 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 4/7] lib: Bundle debugreg.h from the kernel
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Cameron Esfahani <dirty@apple.com>
References: <20200810130618.16066-1-r.bolshakov@yadro.com>
 <20200810130618.16066-5-r.bolshakov@yadro.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <af88d7ee-480b-7554-a1b5-137599abfee2@redhat.com>
Date:   Fri, 28 Aug 2020 06:56:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200810130618.16066-5-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/2020 15.06, Roman Bolshakov wrote:
> x86/vmx_tests.c depends on the kernel header and can't be compiled
> otherwise on x86_64-elf gcc on macOS.
> 
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Peter Shier <pshier@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Cameron Esfahani <dirty@apple.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  lib/x86/asm/debugreg.h | 81 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 81 insertions(+)
>  create mode 100644 lib/x86/asm/debugreg.h

Reviewed-by: Thomas Huth <thuth@redhat.com>

