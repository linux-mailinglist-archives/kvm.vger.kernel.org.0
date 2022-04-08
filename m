Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871EF4F9C3C
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 20:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiDHSJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 14:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiDHSI7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 14:08:59 -0400
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D34A6566
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 11:06:55 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 649B43D7FE1;
        Fri,  8 Apr 2022 14:06:54 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id O5sFNEQfUXZh; Fri,  8 Apr 2022 14:06:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 08FDB3D7E63;
        Fri,  8 Apr 2022 14:06:54 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 08FDB3D7E63
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1649441214;
        bh=UgwCTk7/3GgldDuEtXfBf0PFUi8F3qGeDJ5PZgUa7n8=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=mykBob5g0R7SQaM3QqyGhavHYMWr0TzfAww6h3UrCFORYBeLX7UcFX1SoZL/wtlYQ
         avXOSRfdTioPUMLnceAvZT1TmmzldQbtbEQSdAUcXrVUawyzUdMz+1Fzv+HaLlmowS
         BUoymdpGtBgHuiv7bD6/xYFGtKjmP6STHVpxCOb15yjdw1zzkav7/hfZeI/E1WI7hT
         qlrYgu8pmj1GA6bnmcLeH/RvYg/qSyJQkDmSZWdIDUq6HQdKSqVM8q9lJyj0sl57JN
         YsPxOOt7Tw5iM8HaX9fr1MdAJDnkVUkylqPfphkoJVpHntKLgpUuowXCE+0/OuXpjo
         P8wzj66dEw4wg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CM4rLEGMgK7f; Fri,  8 Apr 2022 14:06:53 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id ECEAB3D8234;
        Fri,  8 Apr 2022 14:06:53 -0400 (EDT)
Date:   Fri, 8 Apr 2022 14:06:53 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        KVM list <kvm@vger.kernel.org>, rostedt <rostedt@goodmis.org>,
        lttng-dev <lttng-dev@lists.lttng.org>,
        Michael Jeanson <mjeanson@efficios.com>
Message-ID: <1622857974.11247.1649441213797.JavaMail.zimbra@efficios.com>
In-Reply-To: <3c11308e-006a-a7e9-8482-c6b341690530@redhat.com>
References: <1218866473.10909.1649432186473.JavaMail.zimbra@efficios.com> <3c11308e-006a-a7e9-8482-c6b341690530@redhat.com>
Subject: Re: Unexport of kvm_x86_ops vs tracer modules
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4257 (ZimbraWebClient - FF99 (Linux)/8.8.15_GA_4257)
Thread-Topic: Unexport of kvm_x86_ops vs tracer modules
Thread-Index: HRgc0Gw3F7w+0GLEUzyCTgfg1qIAWw==
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

----- On Apr 8, 2022, at 12:24 PM, Paolo Bonzini pbonzini@redhat.com wrote:

> On 4/8/22 17:36, Mathieu Desnoyers wrote:
>> LTTng is an out of tree kernel module, which currently relies on the export.
>> Indeed, arch/x86/kvm/x86.c exports a set of tracepoints to kernel modules, e.g.:
>> 
>> EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry)
>> 
>> But any probe implementation hooking on that tracepoint would need kvm_x86_ops
>> to translate the struct kvm_vcpu * into meaningful tracing data.
>> 
>> I could work-around this on my side in ugly ways, but I would like to discuss
>> how kernel module tracers are expected to implement kvm events probes without
>> the kvm_x86_ops symbol ?
> 
> The conversion is done in the TP_fast_assign snippets, which are part of
> kvm.ko and therefore do not need the export.  As I understand it, the
> issue is that LTTng cannot use the TP_fast_assign snippets, because they
> are embedded in the trace_event_raw_event_* symbols?

Indeed, the fact that the TP_fast_assign snippets are embedded in the
trace_event_raw_event_* symbols is an issue for LTTng. This ties those
to ftrace.

AFAIK, TP_fast_assign copies directly into ftrace ring buffers, and then
afterwards things like dynamic filters are applied, which then "uncommits" the
events if need be (and if possible). Also, TP_fast_assign is tied to the
ftrace ring buffer event layout. The fact that the TP_STRUCT__entry() (description)
and TP_fast_assign() (open-coded C) are separate fields really focuses on a
use-case where all data is serialized to a ring buffer.

In LTTng, the event fields are made available to a filter interpreter prior to
being copied into LTTng's ring buffer. This is made possible by implementing
our own LTTNG_TRACEPOINT_EVENT code generation headers. In addition, we have
recently released an event notification mechanism (lttng 2.13) which captures
specific event fields to send with an immediate notification (thus bypassing the
tracer buffering). We are also currently working on a LTTng trace hit counters
mechanism, which performs aggregation through per-cpu counters, which doesn't
even allocate a ring buffer.

For those reasons, LTTng reimplements its own tracepoint probe callbacks. All
those sit within LTTng kernel modules, which means we currently need the exported
kvm_x86_ops callbacks.

> We cannot do the extraction before calling trace_kvm_exit, because it's
> expensive.

I suspect that extracting relevant data prior to calling trace_kvm_exit
is too expensive because it cannot be skipped when the tracepoint is
disabled. This is because trace_kvm_exit() is a static inline function,
and the check to figure out if the event is enabled is within that function.
Unfortunately, even if the tracepoint is disabled, the side-effects of the
parameters passed to trace_kvm_exit() must happen.

I've solved this in LTTng-UST by implementing a lttng_ust_tracepoint()
macro, which basically "lifts" the tracepoint enabled check before the
evaluation of the arguments.

You could achieve something similar by using trace_kvm_exit_enabled() in the
kernel like so:

  if (trace_kvm_exit_enabled())
      trace_kvm_exit(....);

Which would skip evaluation of the argument side-effects when the tracepoint is
disabled.

By doing that, when multiple tracers are attached to a kvm tracepoint, the
translation from pointer-to-internal-structure to meaningful fields would only
need to be done once when a tracepoint is hit. And this would remove the need
for using kvm_x86_ops callbacks from tracer probe functions.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
