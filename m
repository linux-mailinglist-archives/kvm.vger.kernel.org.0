Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5BCC5BD656
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 23:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiISV1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 17:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiISV1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 17:27:03 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494DE4D26B;
        Mon, 19 Sep 2022 14:27:03 -0700 (PDT)
Date:   Mon, 19 Sep 2022 21:26:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663622821;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PBVzOIeI60u1nyDyEYcoeZ2gp8FehbJxyHNEiayMQ8Y=;
        b=wpN9zcZ5dGnUniJ0rzWsbEBotJaeINsx4mnOT8eMmrIZaemS9xW1DsdMKpRNFaijBsUubr
        ZU6UoZxzGF2gHC7+1u4KlqZ7o8vaC4xYgUCDnZIURyKfxiA9IL50DxyR2UVgBNEsvyLdCn
        o4GZZOIhCDG0DodcHRryqWyULT4xvd8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [PATCH 5/5] KVM: selftests: Dedup subtests of fix_hypercall_test
Message-ID: <Yyjen95or6/iNC+Y@google.com>
References: <20220908233134.3523339-1-seanjc@google.com>
 <20220908233134.3523339-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908233134.3523339-6-seanjc@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 08, 2022 at 11:31:34PM +0000, Sean Christopherson wrote:
> Combine fix_hypercall_test's two subtests into a common routine, the only
> difference between the two is whether or not  disable the quirk.  Passing
> a boolean is a little gross, but using an enum to make it super obvious
> that the callers are enabling/disabling the quirk seems like overkill.
> 

Eh, good 'nuff.

> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
