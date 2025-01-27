Return-Path: <kvm+bounces-36639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 598D8A1D017
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 05:24:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 624D93A6847
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 04:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C3B1FC0F1;
	Mon, 27 Jan 2025 04:24:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768E51E89C;
	Mon, 27 Jan 2025 04:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=166.70.13.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737951855; cv=none; b=bmwkA5nfbZUAPgSNSOGpVpc3bI5nJFc+fl7Qh6h9YxZWsGrZSBHSWFJc1h3xFAm1JCyNBJzcL5cimr3NERrwNrhvjaTNdmNVJLEDskcDAqVJYBj6iBYiB66AdG/qvpbm0I11/MkVAqPfkdN/re92v189RZD/KsxETBTrAxmq7wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737951855; c=relaxed/simple;
	bh=TrM7tsP5DOb8Ch53yY/weUCcZbd8MAoCZxLASW8HYGE=;
	h=From:To:Cc:References:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type:Subject; b=vEIzY4gXVu7GSC15VfWUo9jC6ezuDpaMNv8yYfvDPB0YQbToqHsSKGKDVFpUp/Zn7HOi6CDCGI114vUnxpM5rs9tIhZvnamZME72J600skmuLXVvNLSlGcPsb/d8h4140faGNrBROx6Tw3ilveDcXvGc8Z6rMJn/p+9qWUX+3K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xmission.com; spf=pass smtp.mailfrom=xmission.com; arc=none smtp.client-ip=166.70.13.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xmission.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xmission.com
Received: from in01.mta.xmission.com ([166.70.13.51]:55756)
	by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1tcGE4-002SUh-Fh; Sun, 26 Jan 2025 20:55:52 -0700
Received: from ip72-198-198-28.om.om.cox.net ([72.198.198.28]:34446 helo=email.froward.int.ebiederm.org.xmission.com)
	by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1tcGE3-00EniN-Cg; Sun, 26 Jan 2025 20:55:52 -0700
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  "Michael S. Tsirkin"
 <mst@redhat.com>,  Christian Brauner <brauner@kernel.org>,  Oleg Nesterov
 <oleg@redhat.com>,  linux-kernel@vger.kernel.org,  kvm@vger.kernel.org
References: <20250124163741.101568-1-pbonzini@redhat.com>
	<CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
	<CAHk-=wj9fNzDy0dTJzKj3RiSp-puwNawxQ5+ULMvKKjMRV=eqw@mail.gmail.com>
Date: Sun, 26 Jan 2025 21:55:17 -0600
In-Reply-To: <CAHk-=wj9fNzDy0dTJzKj3RiSp-puwNawxQ5+ULMvKKjMRV=eqw@mail.gmail.com>
	(Linus Torvalds's message of "Sat, 25 Jan 2025 10:31:49 -0800")
Message-ID: <87plk8kj16.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1tcGE3-00EniN-Cg;;;mid=<87plk8kj16.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=72.198.198.28;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX19oIXGCSz4Ed/2nj6RLc9JRubozLLDUF7M=
X-Spam-Level: ***
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4966]
	*  1.0 XM_B_Investor BODY: Commonly used business phishing phrases
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 485 ms - load_scoreonly_sql: 0.07 (0.0%),
	signal_user_changed: 12 (2.4%), b_tie_ro: 10 (2.1%), parse: 1.31
	(0.3%), extract_message_metadata: 16 (3.4%), get_uri_detail_list: 2.7
	(0.5%), tests_pri_-2000: 15 (3.0%), tests_pri_-1000: 2.4 (0.5%),
	tests_pri_-950: 1.19 (0.2%), tests_pri_-900: 0.97 (0.2%),
	tests_pri_-90: 100 (20.5%), check_bayes: 98 (20.2%), b_tokenize: 10
	(2.0%), b_tok_get_all: 9 (1.8%), b_comp_prob: 3.7 (0.8%),
	b_tok_touch_all: 72 (14.8%), b_finish: 1.02 (0.2%), tests_pri_0: 315
	(64.9%), check_dkim_signature: 0.52 (0.1%), check_dkim_adsp: 3.7
	(0.8%), poll_dns_idle: 1.26 (0.3%), tests_pri_10: 2.8 (0.6%),
	tests_pri_500: 13 (2.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
X-SA-Exim-Connect-IP: 166.70.13.51
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, oleg@redhat.com, brauner@kernel.org, mst@redhat.com, pbonzini@redhat.com, torvalds@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on out01.mta.xmission.com); SAEximRunCond expanded to false

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sat, 25 Jan 2025 at 10:12, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Arguably the user space oddity is just strange and Paolo even calls it
>> a bug, but at the same time, I do think user space can and should
>> reasonably expect that it only has children that it created
>> explicitly [..]
>
> Note that I think that doing things like "io_uring" and getting IO
> helper threads that way would very much count as "explicit children",
> so I don't argue that all kernel helper threads would fall under this
> category.
>
> And I suspect that the normal vhost workers fall under that same kind
> of "it's like io_uring". If you use VHOST_NEW_WORKER to create a
> worker thread, then that's a pretty explicit "I have a child process".
>
> So it's really just that hugepage recovery thread that seems to be a
> bit "too" much of an implicit kernel helper thread that user space
> kind of gets accidentally and implicitly just because of a kernel
> implementation detail.
>
> I'm sure the kvm hack to just start it later (at KVM_RUN time?) is
> sufficient in practice, but it still feels conceptually iffy to me.

I don't think implicit vs explicit is right question.  Rather we should
be asking can userspace care?

If I read the context from the commit correctly what userspace
is asking is:  Am I single threaded so that I know nothing funny
will happen in the forked process.

The most common funny I am aware of for forked multi-threaded processes
is that if they fork with another thread holding a lock the forked
process might hang forever on the lock because the lock will never
be released.

The most interesting part of the hugepage reaper appears to be
kvm_mmu_commit_zap_page, where a page is freed after being flushed from
the tlb.

I would argue that if kvm_mmu_commit_zap_page and friends change the
page tables in a way that userspace can see after a fork, and in turn
could affect how the forked process will execute userspace is doing
something sensible in testing for it.

On the flip side if this isn't something userspace can observe in it's
own process I would argue that the proper solution is to user a regular
kthread.

In summary the conceptually clean approach is to only have threads that
when running can effect the process they are a part of in a userspace
visible way.  Assuming the hugepage reaper can effect the process it is
a part of, the only problem I see is the hugepage reaper existing when
it had nothing it could possibly do.

I don't think hiding threads is a useful solution because the threads
will effect they process they are a part of.  If the threads aren't
effecting the process they are a part of we have other solutions besides
threads.

Eric

