Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDD5569A9D
	for <lists+kvm@lfdr.de>; Thu,  7 Jul 2022 08:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbiGGGkD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jul 2022 02:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiGGGkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jul 2022 02:40:02 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1242A406
        for <kvm@vger.kernel.org>; Wed,  6 Jul 2022 23:40:00 -0700 (PDT)
Date:   Thu, 7 Jul 2022 08:39:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1657175998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1gBLIZvV+gDvafqhxIKbqt2xCNcdIDwr8ZOsL8htgQA=;
        b=J1nfV9ZQLgClWEZRgvgi6s1oubflxUnDJ+yJNsUBruN8s2bEVo7pk0xF3q3u4ON6yoVV/w
        0gicrshkBs5h7HLI8nkNaXXT4KGc3JUyNPAkL9+61YqqOcNLZ12p4o+kHxNQ0ki27aqhQG
        Ba8xJFVu9nZWeuxNLoe3CuwiK+lD3dc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, seanjc@google.com,
        vkuznets@redhat.com, thuth@redhat.com, maz@kernel.org,
        Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 4/4] KVM: selftests: Fix filename reporting in guest
 asserts
Message-ID: <20220707063957.kl25qgb3bwrobui2@kamzik>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-5-coltonlewis@google.com>
 <20220616124519.erxasor4b5t7zaks@gator>
 <2fc82066-f092-bc19-ae69-6852820f41ef@redhat.com>
 <YsWqWkl8ymLFqxgY@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YsWqWkl8ymLFqxgY@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022 at 03:29:30PM +0000, Colton Lewis wrote:
> On Mon, Jun 20, 2022 at 02:04:43PM +0200, Paolo Bonzini wrote:
> > On 6/16/22 14:45, Andrew Jones wrote:
> > > > +#define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {	\
> > > > +		if (!(_condition))					\
> > > > +			ucall(UCALL_ABORT, GUEST_ASSERT_BUILTIN_NARGS + _nargs,	\
> > > > +			      "Failed guest assert: " _condstr,		\
> > > > +			      __FILE__,					\
> > > > +			      __LINE__,					\
> > > > +			      ##_args);					\
> > > We don't need another level of indentation nor the ## operator on _args.
> > > 
> > 
> > The ## is needed to drop the comma if there are no _args.
> 
> I haven't heard anything more about part 4 of this patch in a while,
> so I'm checking in that I didn't miss something requiring action on my
> part.

Paolo set me straight on the ## usage, so besides the indentation nit and
the other comment I had about losing an assert string, then it looks fine
to me.

Thanks,
drew
