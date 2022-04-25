Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A6750E2A5
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 16:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbiDYOHy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 10:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242335AbiDYOHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 10:07:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEABB82C9
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 07:04:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1088A615EE
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 14:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0656C385A7;
        Mon, 25 Apr 2022 14:04:35 +0000 (UTC)
Date:   Mon, 25 Apr 2022 10:04:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        KVM list <kvm@vger.kernel.org>,
        lttng-dev <lttng-dev@lists.lttng.org>,
        Michael Jeanson <mjeanson@efficios.com>
Subject: Re: Unexport of kvm_x86_ops vs tracer modules
Message-ID: <20220425100434.2f5d18bb@gandalf.local.home>
In-Reply-To: <1622857974.11247.1649441213797.JavaMail.zimbra@efficios.com>
References: <1218866473.10909.1649432186473.JavaMail.zimbra@efficios.com>
        <3c11308e-006a-a7e9-8482-c6b341690530@redhat.com>
        <1622857974.11247.1649441213797.JavaMail.zimbra@efficios.com>
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

On Fri, 8 Apr 2022 14:06:53 -0400 (EDT)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
> Indeed, the fact that the TP_fast_assign snippets are embedded in the
> trace_event_raw_event_* symbols is an issue for LTTng. This ties those
> to ftrace.

Not just ftrace, perf does it too.

Now another solution is to make the fast assigns available to anyone, and
to allow you to simply pass in a pointer and size to have the data written
into it. That is, you get the results of the TRACE_EVENT and not have to
depend on internal data from the tracepoint.

-- Steve
