Return-Path: <kvm+bounces-3992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 706C180B8F3
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 06:16:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 068961F2107F
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 05:16:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 365E91FC9;
	Sun, 10 Dec 2023 05:16:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
X-Greylist: delayed 1325 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 09 Dec 2023 21:16:17 PST
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC441114
	for <kvm@vger.kernel.org>; Sat,  9 Dec 2023 21:16:17 -0800 (PST)
Received: from in02.mta.xmission.com ([166.70.13.52]:33540)
	by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1rCBpP-00B9T9-5N; Sat, 09 Dec 2023 21:54:07 -0700
Received: from ip68-227-168-167.om.om.cox.net ([68.227.168.167]:35840 helo=email.froward.int.ebiederm.org.xmission.com)
	by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.93)
	(envelope-from <ebiederm@xmission.com>)
	id 1rCBpN-00BEzy-T4; Sat, 09 Dec 2023 21:54:06 -0700
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "Gowans, James" <jgowans@amazon.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,  "Graf (AWS), Alexander"
 <graf@amazon.de>,  "seanjc@google.com" <seanjc@google.com>,  =?utf-8?Q?Sc?=
 =?utf-8?Q?h=C3=B6nherr=2C_Jan_H=2E?= <jschoenh@amazon.de>,
  "yuzenghui@huawei.com"
 <yuzenghui@huawei.com>,  "atishp@atishpatra.org" <atishp@atishpatra.org>,
  "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
  "james.morse@arm.com" <james.morse@arm.com>,  "suzuki.poulose@arm.com"
 <suzuki.poulose@arm.com>,  "oliver.upton@linux.dev"
 <oliver.upton@linux.dev>,  "chenhuacai@kernel.org"
 <chenhuacai@kernel.org>,  "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,  "kvmarm@lists.linux.dev"
 <kvmarm@lists.linux.dev>,  "maz@kernel.org" <maz@kernel.org>,
  "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
  "aleksandar.qemu.devel@gmail.com" <aleksandar.qemu.devel@gmail.com>,
  "anup@brainfault.org" <anup@brainfault.org>,  "kexec@lists.infradead.org"
 <kexec@lists.infradead.org>
References: <20230512233127.804012-1-seanjc@google.com>
	<20230512233127.804012-2-seanjc@google.com>
	<cfed942fc767fa7b2fabc68a3357a7b95bd6a589.camel@amazon.com>
Date: Sat, 09 Dec 2023 22:53:30 -0600
In-Reply-To: <cfed942fc767fa7b2fabc68a3357a7b95bd6a589.camel@amazon.com>
	(James Gowans's message of "Sat, 9 Dec 2023 07:26:36 +0000")
Message-ID: <871qbud5f9.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-XM-SPF: eid=1rCBpN-00BEzy-T4;;;mid=<871qbud5f9.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.168.167;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX1+JmH+hfPfL+HY3DU2+KTDcxM737ZP9cTs=
X-SA-Exim-Connect-IP: 68.227.168.167
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"Gowans, James" <jgowans@amazon.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 676 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 12 (1.8%), b_tie_ro: 11 (1.6%), parse: 1.39
	(0.2%), extract_message_metadata: 4.0 (0.6%), get_uri_detail_list:
	1.64 (0.2%), tests_pri_-2000: 3.1 (0.5%), tests_pri_-1000: 3.5 (0.5%),
	tests_pri_-950: 1.20 (0.2%), tests_pri_-900: 1.03 (0.2%),
	tests_pri_-90: 332 (49.0%), check_bayes: 330 (48.8%), b_tokenize: 8
	(1.2%), b_tok_get_all: 9 (1.4%), b_comp_prob: 2.4 (0.4%),
	b_tok_touch_all: 306 (45.3%), b_finish: 0.89 (0.1%), tests_pri_0: 295
	(43.7%), check_dkim_signature: 0.54 (0.1%), check_dkim_adsp: 3.4
	(0.5%), poll_dns_idle: 1.54 (0.2%), tests_pri_10: 3.2 (0.5%),
	tests_pri_500: 10 (1.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 1/2] KVM: Use syscore_ops instead of reboot_notifier
 to hook restart/shutdown
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

"Gowans, James" <jgowans@amazon.com> writes:

> Hi Sean,
>
> Blast from the past but I've just been bitten by this patch when
> rebasing across v6.4.
>
> On Fri, 2023-05-12 at 16:31 -0700, Sean Christopherson wrote:
>> Use syscore_ops.shutdown to disable hardware virtualization during a
>> reboot instead of using the dedicated reboot_notifier so that KVM disabl=
es
>> virtualization _after_ system_state has been updated.=C2=A0 This will al=
low
>> fixing a race in KVM's handling of a forced reboot where KVM can end up
>> enabling hardware virtualization between kernel_restart_prepare() and
>> machine_restart().
>
> The issue is that, AFAICT, the syscore_ops.shutdown are not called when
> doing a kexec. Reboot notifiers are called across kexec via:
>
> kernel_kexec
>   kernel_restart_prepare
>     blocking_notifier_call_chain
>       kvm_reboot
>
> So after this patch, KVM is not shutdown during kexec; if hardware virt
> mode is enabled then the kexec hangs in exactly the same manner as you
> describe with the reboot.

kernel_restart_prepare calls device_shutdown.  Which should call all
of the shutdown operations.  This has been the way the code has been
structured since December 2005.

> Some specific shutdown callbacks, for example IOMMU, HPET, IRQ, etc are
> called in native_machine_shutdown, but KVM is not one of these.
>
> Thoughts on possible ways to fix this:
> a) go back to reboot notifiers
> b) get kexec to call syscore_shutdown() to invoke all of these callbacks
> c) Add a KVM-specific callback to native_machine_shutdown(); we only
> need this for Intel x86, right?
>
> My slight preference is towards adding syscore_shutdown() to kexec, but
> I'm not sure that's feasible. Adding kexec maintainers for input.

Why isn't device_suthdown calling syscore_shutdown?

What problem are you running into with your rebase that worked with
reboot notifiers that is not working with syscore_shutdown?

Eric

