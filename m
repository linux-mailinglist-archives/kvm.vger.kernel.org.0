Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFDD6C34B7
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 15:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjCUOtc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 10:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbjCUOtb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 10:49:31 -0400
Received: from out-8.mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDB25252
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 07:49:26 -0700 (PDT)
Date:   Tue, 21 Mar 2023 15:49:22 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679410164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qbQfRBfczUJav6FHt3ZKMjH+csQpxkzMB8JxUvxdhEg=;
        b=hfMGnzoG6xzWlox+ufsQX1egceC/3JbHyhVSilkiaV+C05kj5/k/2jyb75UTOgfVe9SVO8
        Dv0iKHcJVeJyPZTUhDUpu/N3qpFLSn6BX4v4acfZSWDNG2UvylXHh1RokgUtIlbvvCkTkz
        NlbjZ3Xw03ajFpUmCbPcF375angm+zo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
        qemu-arm@nongnu.org
Subject: Re: [kvm-unit-tests PATCH v10 1/7] Makefile: add GNU global tags
 support
Message-ID: <20230321144922.kiptey3aiwnz7j65@orel>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
 <20230307112845.452053-2-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230307112845.452053-2-alex.bennee@linaro.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 07, 2023 at 11:28:39AM +0000, Alex Bennée wrote:
> If you have ctags you might as well offer gtags as a target.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Message-Id: <20211118184650.661575-4-alex.bennee@linaro.org>
> 
> ---
> v10
>   - update .gitignore
> ---
>  Makefile   | 5 ++++-
>  .gitignore | 3 +++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 6ed5deac..f22179de 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -145,6 +145,9 @@ cscope:
>  		-name '*.[chsS]' -exec realpath --relative-base=$(CURDIR) {} \; | sort -u > ./cscope.files
>  	cscope -bk
>  
> -.PHONY: tags
> +.PHONY: tags gtags
>  tags:
>  	ctags -R
> +
> +gtags:
> +	gtags
> diff --git a/.gitignore b/.gitignore
> index 33529b65..4d5f460f 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -12,6 +12,9 @@ tags
>  patches
>  .stgit-*
>  cscope.*
> +GPATH
> +GRTAGS
> +GTAGS
>  *.swp
>  /lib/asm
>  /lib/config.h
> -- 
> 2.39.2
>

Acked-by: Andrew Jones <andrew.jones@linux.dev>
