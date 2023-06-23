Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 427E373BA91
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 16:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbjFWOqh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 10:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjFWOqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 10:46:31 -0400
Received: from out-25.mta1.migadu.com (out-25.mta1.migadu.com [95.215.58.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5211BF0
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 07:46:28 -0700 (PDT)
Date:   Fri, 23 Jun 2023 16:46:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687531587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wHvvf/bDESVtRUHz9Yj9cOg9EwzScFCVrw08rHloHBY=;
        b=Vxj+7cSKO04fpdl6eqxWrE7iDKjWn2sWylHPJa2DN6YBsj9wQbNZcLhuL0tsbSuKBUs1re
        /YiTAKWGAO50nhu+EIyJLBofsa9V5htBaDHIA6AZJvd45tOJGfXPV+sbLem1G9OBV7pgYg
        qM82k6vx+F6Qlr2uiFv6J5WNoM2OWkE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Nico =?utf-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvmarm@lists.linux.dev,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 0/2] Rework LDFLAGS and link with
 noexecstack
Message-ID: <20230623-7e80827ee6c29678c4da2c3f@orel>
References: <20230623125416.481755-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230623125416.481755-1-thuth@redhat.com>
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

On Fri, Jun 23, 2023 at 02:54:14PM +0200, Thomas Huth wrote:
> I noticed that the latest version of ld (in Fedora rawhide) emits
> a warning on x86 and s390x, complaining about missing .note.GNU-stack
> section that implies an executable stack. It can be silenced by
> linking with "-z noexecstack".
> 
> While trying to add this switch globally to the kvm-unit-tests, I
> had to discover that the common LDFLAGS are hardly used anywhere,
> so the first patch cleans up that problem first before adding the
> new flag in the second patch.
> 
> Thomas Huth (2):
>   Rework the common LDFLAGS to become more useful again
>   Link with "-z noexecstack" to avoid warning from newer versions of ld
> 
>  Makefile                | 2 +-
>  arm/Makefile.common     | 2 +-
>  powerpc/Makefile.common | 2 +-
>  s390x/Makefile          | 2 +-
>  x86/Makefile.common     | 4 ++--
>  5 files changed, 6 insertions(+), 6 deletions(-)
> 
> -- 
> 2.39.3
>

For the series

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
