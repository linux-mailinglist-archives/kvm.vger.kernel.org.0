Return-Path: <kvm+bounces-69573-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +FRRG/GVe2nOGAIAu9opvQ
	(envelope-from <kvm+bounces-69573-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:16:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CCFDB2BA2
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 18:16:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 333E53034666
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 17:13:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A14346E4C;
	Thu, 29 Jan 2026 17:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="ydDEOhoM"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD3B3314C4;
	Thu, 29 Jan 2026 17:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769706811; cv=none; b=Nibjya41fgtLlS6g0olDvJWFWjAVczhkx+dkBhzKnS/Itwi0EVpxnbl17RmKd2dlvwP12kie/uqp7klKMdr6Brx5FH4/fvnM/LXm54fSS9DgmLT9CfnsL820J1a155ihk+0NmNRwKmKtyJTEZitoQqTendNQtEWqdxV9n344cd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769706811; c=relaxed/simple;
	bh=wfmd5TygDnWuNh7atnI1L66vLy96JcLCy+2CqYgZcYA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=BKi0Pkt+FB2La41v8R/nTvBS/uxYJq9bdPabBANubecForEmZnULK7tjQt9i4N4U4LpxR/VgzRyviqMkuSSSVaSCQ1IvQSNMUHE+arYz3FiIYVvV9ySBhXYc6YAB4YM61UuviwJQT3XApnKc9w1yJ65JfbWjyc7RiisfUp/YaEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=ydDEOhoM; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from smtpclient.apple ([192.19.161.250])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60THCITI760106
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Thu, 29 Jan 2026 09:12:18 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60THCITI760106
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1769706740;
	bh=QIyDvQ8ozjjtQ0qFg/hKPuh0+BnC9DM6EKOxMJUk0I4=;
	h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
	b=ydDEOhoM/sDFyXanc+Qgg70WtpoD0LI636/mI1iXstHVV1Vop223o8x9iKinqXrNu
	 gDlmn0Hhdm0Y3blqyD1p6Y053HBvmN2N4+rCg+Wvb7XcGJSVY1gTC6fmusLWcCGuTl
	 63Y529/DA9ww9IcA5POu4h8+Z50WBDZsmBZ5mVfzhWikEsGOPun/q+Eq4es2mUfjL4
	 +BI7jN3vZTnZq01HL8G3PWLBsZt1znF8AknTF02rJ4yYrlr2m8Ck/j41Fzb7Lcj3O5
	 tTh52vjIgoW/vWz8cyeMB6eXqK1TEzeOMGIpfW2hkRYf6tYGmGc7laewBcMCJdyKyh
	 YJE3qXzDHpp8A==
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v9 12/22] KVM: VMX: Virtualize FRED event_data
From: Xin Li <xin@zytor.com>
In-Reply-To: <aR04V4VVg+p4RsdT@intel.com>
Date: Thu, 29 Jan 2026 09:12:02 -0800
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        hch@infradead.org, sohil.mehta@intel.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <60C180BF-AD13-48EF-9BA8-CEACF57965EF@zytor.com>
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-13-xin@zytor.com> <aR04V4VVg+p4RsdT@intel.com>
To: Chao Gao <chao.gao@intel.com>
X-Mailer: Apple Mail (2.3864.300.41.1.7)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[zytor.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[zytor.com:s=2026012301];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69573-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[zytor.com:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xin@zytor.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[zytor.com:mid,zytor.com:dkim,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0CCFDB2BA2
X-Rspamd-Action: no action


> On Nov 18, 2025, at 7:24=E2=80=AFPM, Chao Gao <chao.gao@intel.com> =
wrote:
>=20
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 4a74c9f64f90..0b5d04c863a8 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -1860,6 +1860,9 @@ void vmx_inject_exception(struct kvm_vcpu =
*vcpu)
>>=20
>> vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
>>=20
>> + if (is_fred_enabled(vcpu))
>> + vmcs_write64(INJECTED_EVENT_DATA, ex->event_data);
>=20
> I think event_data should be reset to 0 in =
kvm_clear_exception_queue().
> Otherwise, ex->event_data may be stale here, i.e., the event_data from =
the
> previous event may be injected along with the next event.

It=E2=80=99s no harm to reset it, although it shouldn=E2=80=99t be stale =
when an event that
uses event data is being injected (otherwise it=E2=80=99s a bug).


>=20
>> +
>> vmx_clear_hlt(vcpu);
>> }
>>=20
>=20
>> /*
>> @@ -950,6 +963,7 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, =
unsigned int nr,
>> vcpu->arch.exception.error_code =3D error_code;
>> vcpu->arch.exception.has_payload =3D false;
>> vcpu->arch.exception.payload =3D 0;
>> + vcpu->arch.exception.event_data =3D event_data;
>=20
> If userspace saves guest events (via =
kvm_vcpu_ioctl_x86_get_vcpu_events())
> right after an event is requeued, event_data will be lost (as that =
uAPI only
> saves the payload and KVM doesn't convert the event_data back to a =
payload
> there). So this event will be delivered with incorrect event_data if =
the
> event is restored on another system after migration.

Nice catch!

Just to confirm, you are referring to requeueing an original event
via vmx_complete_interrupts(), right?

Regardless of whether FRED or IDT is in use, the event payload is =
delivered
into the appropriate guest state and then invalidated in
kvm_deliver_exception_payload():

        1) CR2 for #PF

        2) DR6 for #DB

        3) guest_fpu.xfd_err for #NM (in handle_nm_fault_irqoff())

We should be able to recover the FRED event data from there.

Alternatively, we could drop the original event and allow the hardware =
to
regenerate it upon resuming the guest.  However, this breaks #DB =
delivery,
as debug exceptions sometimes are triggered post-instruction.


Sean, does it make sense to recover the FRED event data from guest CPU =
state?



