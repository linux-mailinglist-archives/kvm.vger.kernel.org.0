Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE0E24D600
	for <lists+kvm@lfdr.de>; Fri, 21 Aug 2020 15:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728738AbgHUNQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 09:16:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44747 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728550AbgHUNQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 09:16:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598015795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dHVCACG273OZxdWhluWEhc4aa8ju3oh07qoCKAXK7ls=;
        b=RDWdaK4rLTEjqv2BCK2QqUQOWiEt6P2iQNDv44PzK9ROlH/LvPXi/GW4ZzKB7yUtJtHBWk
        O2SI+YQh7HRMhAzVDaR/3P8kYL3JGdroOG90ePVJjaB7Wccpg2N8oo+I710tBzRMm5J+2d
        KbY0iUQ5nixCUAupVnORzv+EdEO8VSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-llfIS6a8Mu2zbOeEjXwUZQ-1; Fri, 21 Aug 2020 09:16:27 -0400
X-MC-Unique: llfIS6a8Mu2zbOeEjXwUZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B49D185E52D;
        Fri, 21 Aug 2020 13:16:26 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 50F2A756D8;
        Fri, 21 Aug 2020 13:16:22 +0000 (UTC)
Date:   Fri, 21 Aug 2020 15:16:19 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] runtime.bash: remove outdated comment
Message-ID: <20200821131619.ta66u6gbmbz3vupk@kamzik.brq.redhat.com>
References: <20200821123744.33173-1-mhartmay@linux.ibm.com>
 <20200821123744.33173-2-mhartmay@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821123744.33173-2-mhartmay@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 21, 2020 at 02:37:43PM +0200, Marc Hartmayer wrote:
> Since commit 6e1d3752d7ca ("tap13: list testcases individually") the
> comment is no longer valid. Therefore let's remove it.
> 
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
> -- 
> 2.25.4
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

