Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467D7251980
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 15:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbgHYNZe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 09:25:34 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31212 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726024AbgHYNZb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Aug 2020 09:25:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598361930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JuTgDJaLKyxfB/Zin1h3t6CxB9MPl+QVGUzCfRQcU30=;
        b=MTGQ9vtYbIPGUdiIiPF4NVeMTE+e+n9Ns8GtLqIuLJ048CsUwozXHnPRW3YRohJMNFdvA8
        1yC6dEEOK3s7ElZaVGfWUxlD3ZSagIO3C6JwjNO/BiA5F6J+j14P05ZM+q7XXwlYZh6kRE
        p5YarKk4JJ2cNREd65M4hQn60+llIn4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-z6qhuXG2NPyQQ8W8wFUfjg-1; Tue, 25 Aug 2020 09:25:26 -0400
X-MC-Unique: z6qhuXG2NPyQQ8W8wFUfjg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3F21AE400;
        Tue, 25 Aug 2020 13:25:25 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-152.ams2.redhat.com [10.36.112.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED21D5D9CA;
        Tue, 25 Aug 2020 13:25:17 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 1/2] runtime.bash: remove outdated
 comment
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200825102036.17232-1-mhartmay@linux.ibm.com>
 <20200825102036.17232-2-mhartmay@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <2ca7975d-e578-e450-5b77-78851a8ad9c1@redhat.com>
Date:   Tue, 25 Aug 2020 15:25:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200825102036.17232-2-mhartmay@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/08/2020 12.20, Marc Hartmayer wrote:
> Since commit 6e1d3752d7ca ("tap13: list testcases individually") the
> comment is no longer valid. Therefore let's remove it.
> 
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  scripts/runtime.bash | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index c88e246245a6..caa4c5ba18cc 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -53,9 +53,6 @@ skip_nodefault()
>  
>  function print_result()
>  {
> -    # output test results in a TAP format
> -    # https://testanything.org/tap-version-13-specification.html
> -
>      local status="$1"
>      local testname="$2"
>      local summary="$3"
> 

Reviewed-by: Thomas Huth <thuth@redhat.com>

