Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFDB35BD63C
	for <lists+kvm@lfdr.de>; Mon, 19 Sep 2022 23:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiISVTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Sep 2022 17:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiISVTP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Sep 2022 17:19:15 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B264BD3D;
        Mon, 19 Sep 2022 14:19:14 -0700 (PDT)
Date:   Mon, 19 Sep 2022 21:19:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1663622352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KOa7RfxYYgHiq7yCA5x6/8LBJiE9QBC8S2OyUS+ssZQ=;
        b=Qt9vt8/+rK6k9/Msyc/qYKFAzIvpE6FJI4zFWpI31/59Cnz+lQ/OVF8orhX42YvHW8e6g5
        Yn8n3QFaPHINo9W7YXvNghu0mFHFqNEExoL0MFFX5SAwDZTGwnLyFINsMSZITfG3j/HRlt
        AuvIwhe+msav6DtlSu+I1KRsyJQEm/M=
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
Subject: Re: [PATCH 3/5] KVM: selftests: Remove unnecessary register
 shuffling in fix_hypercall_test
Message-ID: <YyjczAkNtxVYJoyN@google.com>
References: <20220908233134.3523339-1-seanjc@google.com>
 <20220908233134.3523339-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908233134.3523339-4-seanjc@google.com>
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

On Thu, Sep 08, 2022 at 11:31:32PM +0000, Sean Christopherson wrote:
> Use input constraints to load RAX and RBX when testing that KVM correctly
> does/doesn't patch the "wrong" hypercall.  There's no need to manually
> load RAX and RBX, and no reason to clobber them either (KVM is not
> supposed to modify anything other than RAX).

Too much time on 'the other architecture' where we don't have input
constraints to load named registers per-se :)

> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
