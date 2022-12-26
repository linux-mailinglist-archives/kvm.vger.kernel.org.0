Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E6E6564A8
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 19:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbiLZSlQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 13:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiLZSlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 13:41:15 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4E4BBF
        for <kvm@vger.kernel.org>; Mon, 26 Dec 2022 10:41:14 -0800 (PST)
Date:   Mon, 26 Dec 2022 19:41:12 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1672080073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GK1wlfneBKx/1y+grM7PObZo37/OgfH4wx0X7LSzWSA=;
        b=g54L9gGYnCDLdSqZRZii0mK/vaU3H9xsw11J47QJ2caSE06sX5Y3k7wEAnECcKZzWjvR0m
        qZuegGN/MgXkW9DjKC+stl1iILmpfNMUAP6k0d5CPbOQADw/NkrS02mGWWfiEvoPFY2TB3
        tQc8qClsRjfBQPLUtHpcevIw9FRr1Oo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        frankja@linux.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: fix make standalone
Message-ID: <20221226184112.ezyw2imr2ezffutr@orel>
References: <20221220175508.57180-1-imbrenda@linux.ibm.com>
 <167161061144.28055.8565976183630294954@t14-nrb.local>
 <167161409237.28055.17477704571322735500@t14-nrb.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167161409237.28055.17477704571322735500@t14-nrb.local>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 21, 2022 at 10:14:52AM +0100, Nico Boehr wrote:
> Quoting Nico Boehr (2022-12-21 09:16:51)
> > Quoting Claudio Imbrenda (2022-12-20 18:55:08)
> > > A recent patch broke make standalone. The function find_word is not
> > > available when running make standalone, replace it with a simple grep.
> > > 
> > > Reported-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > > Fixes: 743cacf7 ("s390x: don't run migration tests under PV")
> > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > 
> > I am confused why find_word would not be available in standalone, since run() in runtime.bash uses it quite a few times.
> > 
> > Not that I mind the grep, but I fear more might be broken in standalone?

standalone tests don't currently include scripts/$ARCH/func.bash, which
may be an issue for s390x. That could be fixed, though.

> > 
> > Anyways, to get this fixed ASAP:
> > 
> > Acked-by: Nico Boehr <nrb@linux.ibm.com>
> 
> OK, I get it now, find_word is not available during _build time_.

That could be changed, but it'd need to be moved to somewhere that
mkstandalone.sh wants to source, which could be common.bash, but
then we'd need to include common.bash in the standalone tests. So,
a new file for find_word() would be cleaner, but that sounds like
overkill.

Thanks,
drew

> 
> Please make this a:
> 
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
