Return-Path: <kvm+bounces-4118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DC0180DFB7
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 00:51:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E78E01F21C04
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 23:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35DA5677F;
	Mon, 11 Dec 2023 23:51:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E1B99B;
	Mon, 11 Dec 2023 15:51:00 -0800 (PST)
Received: from in02.mta.xmission.com ([166.70.13.52]:37898)
	by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1rCq36-00EVyC-FL; Mon, 11 Dec 2023 16:50:56 -0700
Received: from ip68-227-168-167.om.om.cox.net ([68.227.168.167]:49742 helo=email.froward.int.ebiederm.org.xmission.com)
	by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1rCq35-00F4Dc-Cg; Mon, 11 Dec 2023 16:50:56 -0700
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "Gowans, James" <jgowans@amazon.com>
Cc: "Graf (AWS), Alexander" <graf@amazon.de>,  "seanjc@google.com"
 <seanjc@google.com>,  =?utf-8?Q?Sch=C3=B6nherr=2C_Jan_H=2E?=
 <jschoenh@amazon.de>,
  "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
  "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
  "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
  "james.morse@arm.com" <james.morse@arm.com>,  "oliver.upton@linux.dev"
 <oliver.upton@linux.dev>,  "suzuki.poulose@arm.com"
 <suzuki.poulose@arm.com>,  "chenhuacai@kernel.org"
 <chenhuacai@kernel.org>,  "atishp@atishpatra.org" <atishp@atishpatra.org>,
  "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
  "maz@kernel.org" <maz@kernel.org>,  "pbonzini@redhat.com"
 <pbonzini@redhat.com>,  "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
  "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,  "anup@brainfault.org"
 <anup@brainfault.org>,  "aleksandar.qemu.devel@gmail.com"
 <aleksandar.qemu.devel@gmail.com>
References: <20230512233127.804012-1-seanjc@google.com>
	<20230512233127.804012-2-seanjc@google.com>
	<cfed942fc767fa7b2fabc68a3357a7b95bd6a589.camel@amazon.com>
	<871qbud5f9.fsf@email.froward.int.ebiederm.org>
	<a02b40d3d9ae5b3037b9a9d5921cfb0144ab5610.camel@amazon.com>
	<7e30cfc2359dfef39d038e3734f7e5e3d9e82d68.camel@amazon.com>
Date: Mon, 11 Dec 2023 17:50:33 -0600
In-Reply-To: <7e30cfc2359dfef39d038e3734f7e5e3d9e82d68.camel@amazon.com>
	(James Gowans's message of "Mon, 11 Dec 2023 10:27:15 +0000")
Message-ID: <87wmtk9u46.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1rCq35-00F4Dc-Cg;;;mid=<87wmtk9u46.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.168.167;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX183erp/ctJyjnDuDEXnwg8YrcYEg8oGrjc=
X-SA-Exim-Connect-IP: 68.227.168.167
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"Gowans, James" <jgowans@amazon.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 473 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 11 (2.3%), b_tie_ro: 9 (2.0%), parse: 0.99 (0.2%),
	 extract_message_metadata: 3.6 (0.8%), get_uri_detail_list: 1.61
	(0.3%), tests_pri_-2000: 3.4 (0.7%), tests_pri_-1000: 3.6 (0.8%),
	tests_pri_-950: 1.23 (0.3%), tests_pri_-900: 1.01 (0.2%),
	tests_pri_-90: 93 (19.6%), check_bayes: 91 (19.2%), b_tokenize: 9
	(1.9%), b_tok_get_all: 9 (1.8%), b_comp_prob: 2.6 (0.5%),
	b_tok_touch_all: 67 (14.1%), b_finish: 1.02 (0.2%), tests_pri_0: 329
	(69.5%), check_dkim_signature: 0.53 (0.1%), check_dkim_adsp: 2.9
	(0.6%), poll_dns_idle: 1.15 (0.2%), tests_pri_10: 3.3 (0.7%),
	tests_pri_500: 15 (3.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier
 to hook restart/shutdown
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

"Gowans, James" <jgowans@amazon.com> writes:

> On Mon, 2023-12-11 at 09:54 +0200, James Gowans wrote:
>> > 
>> > What problem are you running into with your rebase that worked with
>> > reboot notifiers that is not working with syscore_shutdown?
>> 
>> Prior to this commit [1] which changed KVM from reboot notifiers to
>> syscore_ops, KVM's reboot notifier shutdown callback was invoked on
>> kexec via kernel_restart_prepare.
>> 
>> After this commit, KVM is not being shut down because currently the
>> kexec flow does not call syscore_shutdown.
>
> I think I missed what you're asking here; you're asking for a reproducer
> for the specific failure? 
>
> 1. Launch a QEMU VM with -enable-kvm flag
>
> 2. Do an immediate (-f flag) kexec:
> kexec -f --reuse-cmdline ./bzImage 
>
> Somewhere after doing the RET to new kernel in the relocate_kernel asm
> function the new kernel starts triple faulting; I can't exactly figure
> out where but I think it has to do with the new kernel trying to modify
> CR3 while the VMXE bit is still set in CR4 causing the triple fault.
>
> If KVM has been shut down via the shutdown callback, or alternatively if
> the QEMU process has actually been killed first (by not doing a -f exec)
> then the VMXE bit is clear and the kexec goes smoothly.
>
> So, TL;DR: kexec -f use to work with a KVM VM active, now it goes into a
> triple fault crash.

You mentioned I rebase so I thought your were backporting kernel patches.
By rebase do you mean you porting your userspace to a newer kernel?


In any event I believe the bug with respect to kexec was introduced in
commit 6f389a8f1dd2 ("PM / reboot: call syscore_shutdown() after
disable_nonboot_cpus()").  That is where syscore_shutdown was removed
from kernel_restart_prepare().

At this point it looks like someone just needs to add the missing
syscore_shutdown call into kernel_kexec() right after
migrate_to_reboot_cpu() is called.

That said I am not seeing the reboot notifiers being called on the kexec
path either so your issue with kvm might be deeper.

Eric

