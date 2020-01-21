Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 143F314421C
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 17:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgAUQYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 11:24:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46978 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727817AbgAUQYx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 11:24:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579623892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=Vs2xW01jn/rAxr82yIlV0GWSW6shOeBQJmYsYCnvr3Y=;
        b=abtis0irudNyCaF3umXdinpn8EHVUW3wdLXM4Mt9x9ZA0p7UX3BeaSUavB8+Qut+b6IW+n
        ej2MQWyrkUkjwWv4K9nzshUVqfkka3RYKg5sp9wFT28N86WOHBz4aOJPSCaOgHwOzJ+Bgn
        XafL6hYdlsWlfxcGQiibN+hA6m683xg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-LlX_ADNNOqm3zZx0PnrPjw-1; Tue, 21 Jan 2020 11:24:50 -0500
X-MC-Unique: LlX_ADNNOqm3zZx0PnrPjw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28B4FDB23;
        Tue, 21 Jan 2020 16:24:49 +0000 (UTC)
Received: from thuth.remote.csb (unknown [10.36.118.148])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DABB10013A7;
        Tue, 21 Jan 2020 16:24:47 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] expect python3 in the path
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <1579623705-51801-1-git-send-email-pbonzini@redhat.com>
Cc:     Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5808bf6b-02f2-2c06-dd2c-3f29bf67fd24@redhat.com>
Date:   Tue, 21 Jan 2020 17:24:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1579623705-51801-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/2020 17.21, Paolo Bonzini wrote:
> Some systems that only have Python 3.x installed will not have
> a "python" binary in the path.  Since pretty_print_stacks.py
> is a Python 3 program, we can use an appropriate shebang.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  scripts/pretty_print_stacks.py | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/pretty_print_stacks.py b/scripts/pretty_print_stacks.py
> index a863c8e..1e59cde 100755
> --- a/scripts/pretty_print_stacks.py
> +++ b/scripts/pretty_print_stacks.py
> @@ -1,4 +1,4 @@
> -#!/usr/bin/env python
> +#!/usr/bin/env python3
>  
>  import re
>  import subprocess
> 

Acked-by: Thomas Huth <thuth@redhat.com>

