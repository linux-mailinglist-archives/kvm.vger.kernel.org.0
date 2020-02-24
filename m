Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4FD16A30F
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 10:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbgBXJuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 04:50:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25439 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726838AbgBXJuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 04:50:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582537821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oIY73AdUow5T4PwrQ+//VASALWK2Cthl89jHUG+QSqU=;
        b=VMsSsY0EOciFkTHLMlD1+qT2UxhFQVHBcl2ujnWKiKgmzO9QX5XAtCblzU1QNLR5P4Ke4J
        wyytERrvBECxhC2G7Xf8G8DFLgvO/k6g8ipWKC+eWs3qkdNUaLjvZAZsqj7HNc8eVFwfE1
        wxpVl0L22BcUJxOTbfbAiOzXACRDYSg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-G0j76qqYN16WQ-N4o2jimA-1; Mon, 24 Feb 2020 04:50:11 -0500
X-MC-Unique: G0j76qqYN16WQ-N4o2jimA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88977801FA0;
        Mon, 24 Feb 2020 09:50:10 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DC2E26FDD;
        Mon, 24 Feb 2020 09:50:09 +0000 (UTC)
Date:   Mon, 24 Feb 2020 10:50:06 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Fabrice Fontaine <fontaine.fabrice@gmail.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] Makefile: fix stack-protector tests
Message-ID: <20200224095006.7cyotgilqpf5hdl2@kamzik.brq.redhat.com>
References: <20200223231414.3178105-1-fontaine.fabrice@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223231414.3178105-1-fontaine.fabrice@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 24, 2020 at 12:14:14AM +0100, Fabrice Fontaine wrote:
> Rename fnostack_protector into fno_stack_protector and
> fnostack_protector_all into fnostack_protector_all otherwise build will
> fail if -fstack-protector is passed by the toolchain
> 
> Fixes:
>  - http://autobuild.buildroot.org/results/ad689b08173548af21dd1fb0e827fd561de6dfef
> 
> Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
> ---
>  Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 767b6c6..754ed65 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -55,8 +55,8 @@ COMMON_CFLAGS += -Wignored-qualifiers -Werror
>  
>  frame-pointer-flag=-f$(if $(KEEP_FRAME_POINTER),no-,)omit-frame-pointer
>  fomit_frame_pointer := $(call cc-option, $(frame-pointer-flag), "")
> -fnostack_protector := $(call cc-option, -fno-stack-protector, "")
> -fnostack_protector_all := $(call cc-option, -fno-stack-protector-all, "")
> +fno_stack_protector := $(call cc-option, -fno-stack-protector, "")
> +fno_stack_protector_all := $(call cc-option, -fno-stack-protector-all, "")
>  wno_frame_address := $(call cc-option, -Wno-frame-address, "")
>  fno_pic := $(call cc-option, -fno-pic, "")
>  no_pie := $(call cc-option, -no-pie, "")
> -- 
> 2.25.0
>

Thanks Fabrice, but the same change was posted by Alexandru and is in my
last PULL request to Paolo [*].

drew

[*] https://patchwork.kernel.org/patch/11368845/ 

