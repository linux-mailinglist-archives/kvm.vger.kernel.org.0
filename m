Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2C927FEC0
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 14:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731961AbgJAMDw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 08:03:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58465 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731880AbgJAMDw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Oct 2020 08:03:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601553831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e+qZNeJMNbh3o4AxJ6j0YqAYfrz2e7WFW5gnwae2968=;
        b=Yh+qGvz4pf9W48zwRvNq4no1iLvcyBfzhqcK+Yqwh5UlgVZA5tPEm8CHLJAUhxLPBRIt7E
        sl2NLvtGoXYur8c0NyWZu+bEEJBYcCNa7naCdt7zu0m5DPeXrmRU1k3f3hm1GGTxI6b+zt
        S8kIQxGPrERVgx9QIOJ8Wi6oc26B/o0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-7fr8R7SAPEGoeNt9uLRL-Q-1; Thu, 01 Oct 2020 08:03:50 -0400
X-MC-Unique: 7fr8R7SAPEGoeNt9uLRL-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 251AB83DC20
        for <kvm@vger.kernel.org>; Thu,  1 Oct 2020 12:03:49 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-107.ams2.redhat.com [10.36.112.107])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BC6F19C78;
        Thu,  1 Oct 2020 12:03:48 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] MAINTAINERS: Fix [An]drew's name
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
References: <20201001120224.72090-1-drjones@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <293ead86-67af-8cd8-b88f-9c544d18f1df@redhat.com>
Date:   Thu, 1 Oct 2020 14:03:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20201001120224.72090-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/2020 14.02, Andrew Jones wrote:
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 52a3eb6f764e..54124f6f1a5e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -61,7 +61,7 @@ Architecture Specific Code:
>  ---------------------------
>  
>  ARM
> -M: Drew Jones <drjones@redhat.com>
> +M: Andrew Jones <drjones@redhat.com>
>  L: kvm@vger.kernel.org
>  L: kvmarm@lists.cs.columbia.edu
>  F: arm/*
> 

FWIW:

Reviewed-by: Thomas Huth <thuth@redhat.com>

:-)

