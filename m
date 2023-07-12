Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75D9750F43
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 19:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbjGLRHB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 13:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbjGLRHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 13:07:00 -0400
Received: from out-19.mta0.migadu.com (out-19.mta0.migadu.com [IPv6:2001:41d0:1004:224b::13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17E51BEC
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 10:06:58 -0700 (PDT)
Date:   Wed, 12 Jul 2023 19:06:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689181617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v4x0AOAWsqEWxfK6feVw7HxnRkQ8O178v0UA6n3bx74=;
        b=c9WICqNoct7xSTxBVu5SDRnWds5QUPZnlHM+FMxWvyB6GikOAhupP4GAYFX6W+vGLJcmB1
        8vwWO1mMVIpAtewcOa5HJJ2BZ+0aLKZ74AEYsIP9VnPz2z47J8irXRnx8yx18cVsfKQgXe
        5dGPTYsZqOmqDJQO9u/78PoxcGDde9M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, thuth@redhat.com, pbonzini@redhat.com,
        renmm6@chinaunicom.cn
Subject: Re: [kvm-unit-tests PATCH v1 1/1] run_tests: fix verbose
Message-ID: <20230712-64f673f8144d5255d5c02495@orel>
References: <20230712150645.76746-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712150645.76746-1-imbrenda@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 05:06:45PM +0200, Claudio Imbrenda wrote:
> The "v" and "verbose" options in getopt grew an extra :, which breaks it.
> 
> $ ./run_tests.sh -v
> getopt: option requires an argument -- v
> $ ./run_tests.sh --verbose
> getopt: option --verbose requires an argument
> 
> Remove the unnecessary :
> 
> Fixes: 15e441c4 ("run_tests: add list tests name option on command line")
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  run_tests.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/run_tests.sh b/run_tests.sh
> index baf8e461..abb0ab77 100755
> --- a/run_tests.sh
> +++ b/run_tests.sh
> @@ -44,7 +44,7 @@ fi
>  
>  only_tests=""
>  list_tests=""
> -args=$(getopt -u -o ag:htj:v:l -l all,group:,help,tap13,parallel:,verbose:,list -- $*)
> +args=$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,verbose,list -- $*)
>  [ $? -ne 0 ] && exit 2;
>  set -- $args;
>  while [ $# -gt 0 ]; do
> -- 
> 2.41.0
>

Pushed, thanks!

drew
