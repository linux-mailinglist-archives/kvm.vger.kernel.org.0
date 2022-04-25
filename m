Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95C2A50E514
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 18:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243121AbiDYQGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 12:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243195AbiDYQF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 12:05:59 -0400
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BC112611
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 09:02:54 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 1E67B3CF1E2;
        Mon, 25 Apr 2022 12:02:53 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id nUJgFl7voe_k; Mon, 25 Apr 2022 12:02:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 767C43CF469;
        Mon, 25 Apr 2022 12:02:52 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 767C43CF469
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1650902572;
        bh=j6y8wcrhdZ6ADgcS4e0rv9G8+EgKKSu6ZlEe9Iow5gw=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=QXNthuqaM9+A0nKFeD/CY0reoTyY2U2YUJ+N1dH+Hfk3yf5Xe6nVQG5ma3PxVIfUe
         4klXa2OqfaXZwHq0/y6oITHNrvsIiJgCWBpznrSWav5y4E5y0EsKYnQLE4uRSa3nOS
         EXGfl4IVKfEKs5+TcJSN6ssoS4Ce2qMbLe/p+h/eLZsg2tBsgHwdZEg11sHOmmLjgQ
         nwXe+K6WeZzjV3jE+DpBP+hLSVa3HAZGyr4CukPLm4r2pBWFe5+oujto1dKkmlJu1w
         pOuOr/aqvfdpHsJStkLWmJFy1DTIkRwqMfMzwFKwSTiMEYGTuUajRXGDTP3wXCMp+/
         dI/Bj8sr+odBg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id GlP_LFzoRsYa; Mon, 25 Apr 2022 12:02:52 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 684F43CF1DF;
        Mon, 25 Apr 2022 12:02:52 -0400 (EDT)
Date:   Mon, 25 Apr 2022 12:02:52 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        KVM list <kvm@vger.kernel.org>,
        lttng-dev <lttng-dev@lists.lttng.org>,
        Michael Jeanson <mjeanson@efficios.com>
Message-ID: <892959086.34940.1650902572304.JavaMail.zimbra@efficios.com>
In-Reply-To: <20220425100434.2f5d18bb@gandalf.local.home>
References: <1218866473.10909.1649432186473.JavaMail.zimbra@efficios.com> <3c11308e-006a-a7e9-8482-c6b341690530@redhat.com> <1622857974.11247.1649441213797.JavaMail.zimbra@efficios.com> <20220425100434.2f5d18bb@gandalf.local.home>
Subject: Re: Unexport of kvm_x86_ops vs tracer modules
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4257 (ZimbraWebClient - FF99 (Linux)/8.8.15_GA_4257)
Thread-Topic: Unexport of kvm_x86_ops vs tracer modules
Thread-Index: gjp2UP+GQzqompjQk+kWzrxYc4diFA==
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

----- On Apr 25, 2022, at 10:04 AM, Steven Rostedt rostedt@goodmis.org wrote:

> On Fri, 8 Apr 2022 14:06:53 -0400 (EDT)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>> 
>> Indeed, the fact that the TP_fast_assign snippets are embedded in the
>> trace_event_raw_event_* symbols is an issue for LTTng. This ties those
>> to ftrace.
> 
> Not just ftrace, perf does it too.
> 
> Now another solution is to make the fast assigns available to anyone, and
> to allow you to simply pass in a pointer and size to have the data written
> into it. That is, you get the results of the TRACE_EVENT and not have to
> depend on internal data from the tracepoint.

If the fast assign can then be used on a field-per-field basis, maybe this
could work, but AFAIK the fast-assign macro is open-coded C, which makes this
not straightforward.

If it's a all-or-nothing approach where the fast-assign needs to serialize all
fields, this would require that lttng copies the data into a temporary area,
which is something I want to avoid for filtering and event notification per-field
payload capture purposes.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
