Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D17027CE6E
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 15:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbgI2NGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 09:06:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47047 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728253AbgI2NGj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 09:06:39 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601384798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7HUXcq0hh2Qg9Itla4sMICmUP55lKsTf/p+jqpUhVfU=;
        b=H/fLmBWlfdZr7kJbz+9SjlXt1/Mg15iY78OJD3OwosHARapowHhVmD65RtMojdZi50ReqB
        LIgUKmUyqSajeYBAioe9rkvQPulkv4nIlXYnIbpN2KXaYcNGwOa/7LY6MYYCMtT6c9V7f1
        PguowUqqcnzUH7eswUOpDVcpkPl+pBw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-7Y3s0qj7PH-l3FzLFv8Flw-1; Tue, 29 Sep 2020 09:06:36 -0400
X-MC-Unique: 7Y3s0qj7PH-l3FzLFv8Flw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86FD9186DD58
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 13:06:35 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.214])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A759355775;
        Tue, 29 Sep 2020 13:06:34 +0000 (UTC)
Date:   Tue, 29 Sep 2020 15:06:32 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests] runtime: SKIP if required sysfs file is
 missing
Message-ID: <20200929130632.zgml4aalq3o6qxfw@kamzik.brq.redhat.com>
References: <20200929122317.889256-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929122317.889256-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 29, 2020 at 08:23:17AM -0400, Paolo Bonzini wrote:
> This fixes the test once more, so that we correctly skip for
> example access-reduced-maxphyaddr on AMD processors.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  scripts/runtime.bash | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 3121c1f..f070e14 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -118,7 +118,7 @@ function run()
>      for check_param in "${check[@]}"; do
>          path=${check_param%%=*}
>          value=${check_param#*=}
> -        if [ -f "$path" ] && [ "$(cat $path)" != "$value" ]; then
> +        if ! [ -f "$path" ] || [ "$(cat $path)" != "$value" ]; then
>              print_result "SKIP" $testname "" "$path not equal to $value"
>              return 2
>          fi
> -- 
> 2.26.2
>
 
Reviewed-by: Andrew Jones <drjones@redhat.com>

