Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C457448BD
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 13:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjGALen (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 07:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjGALem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 07:34:42 -0400
Received: from out-21.mta1.migadu.com (out-21.mta1.migadu.com [IPv6:2001:41d0:203:375::15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3743C07
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 04:34:40 -0700 (PDT)
Date:   Sat, 1 Jul 2023 13:34:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688211277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sAkEPGAHOd+sUh+6EAzAslP+llAV9Vu3KIROk97tZ24=;
        b=b6QWARnBfjKhkwwkn6US2V3PawgW6Vc5ttFr0Az8NGjBR6BEO2/VCK7i7LlCXqtYWI4Ip2
        Pi+oyrOC3MFEFN/8gODpRO8B0O1bNX3EMt/rsBT1bLWNew/fcGymZNMD90Qsmm0D1tFW7o
        vynD056LGCh9br71PIjuGRDwFpcs7LY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nadav Amit <namit@vmware.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 2/6] lib/stack: print base addresses on
 relocation setups
Message-ID: <20230701-d9eb38f32bb8f376336d9443@orel>
References: <20230628001356.2706-1-namit@vmware.com>
 <20230628001356.2706-4-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628001356.2706-4-namit@vmware.com>
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

On Wed, Jun 28, 2023 at 12:13:51AM +0000, Nadav Amit wrote:
...
> diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
> index 8ce0034..c2e976e 100644
> --- a/powerpc/Makefile.common
> +++ b/powerpc/Makefile.common
> @@ -24,6 +24,7 @@ CFLAGS += -ffreestanding
>  CFLAGS += -O2 -msoft-float -mno-altivec $(mabi_no_altivec)
>  CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/libfdt -I lib
>  CFLAGS += -Wa,-mregnames
> +CFLAGS += -DCONFIG_RELOC
>

I dropped this change. powerpc doesn't define _text and _etext.
I'll leave it to the ppc people to decide if they want this and
want to add _text and _etext to get it.

Thanks,
drew
