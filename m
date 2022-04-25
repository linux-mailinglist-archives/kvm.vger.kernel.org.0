Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33B050E946
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 21:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbiDYTQs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 15:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231528AbiDYTQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 15:16:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62B92E0BA
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 12:13:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DE126172E
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 19:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CE2C385A4;
        Mon, 25 Apr 2022 19:13:38 +0000 (UTC)
Date:   Mon, 25 Apr 2022 15:13:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        KVM list <kvm@vger.kernel.org>,
        lttng-dev <lttng-dev@lists.lttng.org>,
        Michael Jeanson <mjeanson@efficios.com>
Subject: Re: Unexport of kvm_x86_ops vs tracer modules
Message-ID: <20220425151336.21e492b5@gandalf.local.home>
In-Reply-To: <892959086.34940.1650902572304.JavaMail.zimbra@efficios.com>
References: <1218866473.10909.1649432186473.JavaMail.zimbra@efficios.com>
        <3c11308e-006a-a7e9-8482-c6b341690530@redhat.com>
        <1622857974.11247.1649441213797.JavaMail.zimbra@efficios.com>
        <20220425100434.2f5d18bb@gandalf.local.home>
        <892959086.34940.1650902572304.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Apr 2022 12:02:52 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> If the fast assign can then be used on a field-per-field basis, maybe this
> could work, but AFAIK the fast-assign macro is open-coded C, which makes this
> not straightforward.

Yeah, that's not going to be feasible, without changing all 1000's of
events.

> 
> If it's a all-or-nothing approach where the fast-assign needs to serialize all
> fields, this would require that lttng copies the data into a temporary area,
> which is something I want to avoid for filtering and event notification per-field
> payload capture purposes.

Right. Not sure how to fix this then.

-- Steve
