Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F17B19E6EE
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 19:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgDDRyy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 13:54:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40370 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726222AbgDDRyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 Apr 2020 13:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586022893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s59lacWOKBBamIyRJhEjADWK2GFT2S/VtR2CxS4xHRQ=;
        b=bIwOmrh4D+itp+uz7hqTwjSpaX5ROF9mKKeRcCQsV9eym3wiuA9CmLevAuEufYNqpwPlfZ
        w/rKJGX7GHokBVPCLuS04nmUJJ2lJP4MeOGs2ndLxFh6qONbCrem3lGNZGze6tSMfhDxsu
        o8RUgZeMYECE9wfWryMWGl2gHRcSSJY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-SytsQl5VP2mYOGHRk5TpEQ-1; Sat, 04 Apr 2020 13:54:51 -0400
X-MC-Unique: SytsQl5VP2mYOGHRk5TpEQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63367DB20;
        Sat,  4 Apr 2020 17:54:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 53BF55C557;
        Sat,  4 Apr 2020 17:54:42 +0000 (UTC)
Date:   Sat, 4 Apr 2020 19:54:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     lvivier@redhat.com, thuth@redhat.com, david@redhat.com,
        frankja@linux.ibm.com, pbonzini@redhat.com
Subject: Re: [PATCH kvm-unit-tests] arch-run: Add reserved variables to the
 default environ
Message-ID: <20200404175439.wexrtxxddwwvrioe@kamzik.brq.redhat.com>
References: <20200404172235.238065-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404172235.238065-1-drjones@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 04, 2020 at 07:22:35PM +0200, Andrew Jones wrote:
...
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index c1ecb7f99cdc..96158b015e78 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -36,7 +36,7 @@ generate_test ()
>  
>  	echo "#!/usr/bin/env bash"
>  	echo "export STANDALONE=yes"
> -	echo "export ENVIRON_DEFAULT=yes"
> +	echo "export ENVIRON_DEFAULT=$ENVIRON_DEFAULT"
>  	echo "export HOST=\$(uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/')"
>  	echo "export PRETTY_PRINT_STACKS=no"
>  
> @@ -59,7 +59,7 @@ generate_test ()
>  		echo 'export FIRMWARE'
>  	fi
>  
> -	if [ "$ERRATATXT" ]; then
> +	if [ "$ENVIRON_DEFAULT" = "yes" ] && [ "$ERRATATXT" ]; then
                                              ^ I should have added a -f here while touching it
						I'll send a v2 with it after reviewers have a chance to look

>  		temp_file ERRATATXT "$ERRATATXT"
>  		echo 'export ERRATATXT'
>  	fi
> -- 
> 2.25.1
> 

