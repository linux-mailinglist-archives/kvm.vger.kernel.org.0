Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A2025C4E3
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 17:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbgICPTz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 11:19:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45861 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbgICPTw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 11:19:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599146391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0nUS7mn/SPTBXpvLbMswq8yJTQxDvP1HAruXGRgXj6Y=;
        b=cUIyQYW06qeTK85X6dr4hCQtR09tpsZR9yYxnjJxVveAjB2o7AHE6f18oaD0/Kw3OD9Aeu
        Lbalz0ctehwzOgeazyhmaqY8iu6Tx6+a3tAf3NN3px6StNMQqKa5u8XaaFIeguKzqqlXrL
        t+i6JG2JzLYhFewGbnbclOPPxLWPoNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-yUpXDdhoO8yqmOv7_MrCtA-1; Thu, 03 Sep 2020 11:19:45 -0400
X-MC-Unique: yUpXDdhoO8yqmOv7_MrCtA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58D9A100CA88;
        Thu,  3 Sep 2020 15:19:43 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-10.ams2.redhat.com [10.36.114.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5168C60C0F;
        Thu,  3 Sep 2020 15:19:42 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 01/10] x86: Makefile: Allow division on
 x86_64-elf binutils
To:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Cameron Esfahani <dirty@apple.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-2-r.bolshakov@yadro.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <0dcf2213-9e1c-3978-5d75-4ccb3696e374@redhat.com>
Date:   Thu, 3 Sep 2020 17:19:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200901085056.33391-2-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/09/2020 10.50, Roman Bolshakov wrote:
> For compatibility with other SVR4 assemblers, '/' starts a comment on
> *-elf binutils target and thus division operator is not allowed [1][2].
> That breaks cstart64.S build:
> 
>   x86/cstart64.S: Assembler messages:
>   x86/cstart64.S:294: Error: unbalanced parenthesis in operand 1.
> 
> configure should detect if --divide needs to be passed to assembler by
> compiling a small snippet where division is used inside parentheses.
> 
> 1. https://sourceware.org/binutils/docs/as/i386_002dChars.html
> 2. https://sourceware.org/binutils/docs/as/i386_002dOptions.html#index-_002d_002ddivide-option_002c-i386
> 
> Cc: Cameron Esfahani <dirty@apple.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  configure           | 12 ++++++++++++
>  x86/Makefile.common |  3 +++
>  2 files changed, 15 insertions(+)

Reviewed-by: Thomas Huth <thuth@redhat.com>

