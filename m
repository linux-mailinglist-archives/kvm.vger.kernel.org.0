Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFA441774A
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 17:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346999AbhIXPOp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 11:14:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44548 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346962AbhIXPOp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 11:14:45 -0400
Received: from in02.mta.xmission.com ([166.70.13.52]:58196)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mTmsw-006RNF-7i; Fri, 24 Sep 2021 09:13:10 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:44116 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mTmsu-009Kdu-3q; Fri, 24 Sep 2021 09:13:09 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
References: <20210923181252.44385-1-pbonzini@redhat.com>
        <CAHk-=wjp7psdNc8KpxVDmcVYaAAxDUvvFTgx21OwZJzkghktLg@mail.gmail.com>
Date:   Fri, 24 Sep 2021 10:13:00 -0500
In-Reply-To: <CAHk-=wjp7psdNc8KpxVDmcVYaAAxDUvvFTgx21OwZJzkghktLg@mail.gmail.com>
        (Linus Torvalds's message of "Thu, 23 Sep 2021 11:35:06 -0700")
Message-ID: <87r1deqa6b.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mTmsu-009Kdu-3q;;;mid=<87r1deqa6b.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+1c3ufRhzrTpnNjJCv5wkwlRCouBizLRc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.1 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,XMSubMetaSxObfu_03,XMSubMetaSx_00 autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4998]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  1.0 XMSubMetaSx_00 1+ Sexy Words
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1561 ms - load_scoreonly_sql: 0.08 (0.0%),
        signal_user_changed: 11 (0.7%), b_tie_ro: 10 (0.6%), parse: 1.01
        (0.1%), extract_message_metadata: 13 (0.8%), get_uri_detail_list: 2.1
        (0.1%), tests_pri_-1000: 5 (0.4%), tests_pri_-950: 1.42 (0.1%),
        tests_pri_-900: 1.42 (0.1%), tests_pri_-90: 70 (4.5%), check_bayes: 68
        (4.3%), b_tokenize: 15 (0.9%), b_tok_get_all: 10 (0.6%), b_comp_prob:
        3.0 (0.2%), b_tok_touch_all: 36 (2.3%), b_finish: 1.08 (0.1%),
        tests_pri_0: 1435 (91.9%), check_dkim_signature: 0.63 (0.0%),
        check_dkim_adsp: 2.8 (0.2%), poll_dns_idle: 0.57 (0.0%), tests_pri_10:
        3.5 (0.2%), tests_pri_500: 17 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [GIT PULL] KVM/rseq changes for Linux 5.15-rc3
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Sep 23, 2021 at 11:13 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> A fix for a bug with restartable sequences and KVM.  KVM's handling
>> of TIF_NOTIFY_RESUME, e.g. for task migration, clears the flag without
>> informing rseq and leads to stale data in userspace's rseq struct.
>
> Ok, patches look reasonable.
>
>> I'm sending this as a separate pull request since it's not code
>> that I usually touch.  In particular, patch 2 ("entry: rseq: Call
>> rseq_handle_notify_resume() in tracehook_notify_resume()") is just a
>> cleanup to try and make future bugs less likely.  If you prefer this to
>> be sent via Thomas and only in 5.16, please speak up.
>
> So I took the pull request this way, thanks for separating it like this.
>
> But I'm adding a few people to the cc for a completely different
> reason: the cleanup to move all the notify_resume stuff to
> tracehook_notify_resume() is good, but it does make me go - once again
> - "Hmm, that naming is really really bad".
>
> The <linux/tracehook.h> code was literally meant for tracing. It's
> where the name comes from, and it's the original intent: having a
> place that you can hook into for tracing that doesn't depend on how
> the core kernel code ends up changing.
>
> But that's not how it actually acts right now. That header file is now
> some very core functionality, and little of it is actually related to
> tracing any more. It's more core process state handling for the user
> space return path.

Yes.  The tracehook header was a precursor to merging utrace which
ultimately was replaced by uprobes.  Quite a few of the tracehooks hooks
have become regular ptrace hooks over the years, and left tracehook.h

It looks like that is the path that should happen with the rest of the
hooks as well.

It looks like: tracehook_report_syscall_entry, and
tracehook_report_syscall_exit should just become
ptrace_report_syscall_entry and ptrace_report_syscall_exit.

That tracehook_signal_handler should just be inlined into it's one
caller.

That leaves set_notify_resume, tracehook_notify_resume,
tracehook_notify_signal, and set_notify_signal.

I am still waiting to hear if we can just remove
tracehook_notify_signal now that io_uring has become an ordinary process
thing.

It looks like tracehook_notify_resume should be renamed and put
somewhere I just don't know where.

The config option HAVE_ARCH_TRACEHOOK appears to have nothing to do
with the header tracehook.h any more.  It looks to be just about
regsets, and task_current_syscall.  It looks like only alpha, h8300,
m68k, and microblaze need an implementation and then we can make all
of the code that depends upon HAVE_ARCH_TRACEHOOK unconditional.


> So I don't object to the patches, and they are merged, but I'm cc'ing people to
>
>  (a) let them know about this (see commit a68de80f61f6: "entry: rseq:
> Call rseq_handle_notify_resume() in tracehook_notify_resume()" in the
> current -git tree)
>
>  (b) possibly prod some people into perhaps moving/renaming some of
> that code to actual core kernel C files, instead of a misnamed header
> file..
>
> Hmm?

It is on my radar.  Does anyone have any idea what to call
tracehook_notify_resume so that it describes it's current usage?

Eric
