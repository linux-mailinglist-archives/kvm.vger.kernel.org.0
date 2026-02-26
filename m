Return-Path: <kvm+bounces-71937-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0NiqC78AoGlrfQQAu9opvQ
	(envelope-from <kvm+bounces-71937-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:13:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC2911A25C9
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 09:13:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6B6F9304B5EC
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D426393DDF;
	Thu, 26 Feb 2026 08:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="doEIrohB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FCE38E5C2
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 08:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772093542; cv=pass; b=aOTsdNq5Rg9fTEGd/nLdjQDc6sjE8mIMu4u0K6srzI0aBOBLHzfhv9O1xKlg2zQfPg8+j4BMboOYCD1ITX8ugcPJ2+0pbWhn0Bdsjg0CkdW/9xGju3jx8bNjCG35kf6DQ+PLrhDl6oB2ApK2OGTf9qlI5ulfvtwye/acqMmVj6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772093542; c=relaxed/simple;
	bh=0UoVqyWaL78Hzk+cUpwWOg65e9xmWC5hJ2EQE29LyNI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PzxKqR9wqDcCOm98hsWG6nSae5uXqXCyc/T8f1hopSCHQr4k8uskceG4+FgxjAHzv1Pc+HqPySkJbaTXPkcSH40tOXUQSBBjxNmBaY8NSi+7Xb9m5gPcKVxNy4A/10n6ceKcMvb9z40MBmJn75PE2/qrUzppETeQcsOiIiByr/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=doEIrohB; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-505d3baf1a7so356071cf.1
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 00:12:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772093540; cv=none;
        d=google.com; s=arc-20240605;
        b=AaNPbvrn2Bj6jMZlQSjncVy7kWJMMKZiN+e3FpNBGeJbZXqF9TfafaB6w92GP6P0wY
         Ez03Ya2r2mnpl858HsHJz+Br61kosYwx6/UYj/B847D5UT8qviEW7lkNldA4TctHgluN
         3JTzahYHo0nNLPOZWGo8sYJ1VTyqqwLhMb5+DMVfs6He+9qgH55TrdGmMbCRkQbVcwIU
         9fjVd7GoLPoeauPyn8JUxadYBzYwST5LU615ILHZKHIhiKYExQzBCDh3yNBcniHXlZgI
         iSig7Lu6e03DEI7IIP3AbFeO6rx5c/uXic6+mitIuPmHIfsmMg9W4UiocUa16VKy2FgQ
         OV4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wZfa1EIpB3IbPnBHrQupmb9pJPiByw+1vE5DawlK1HU=;
        fh=cgH2J4qMUFSDEBEMJ82QEUToduYCZ1EuMXfkPFhqlF8=;
        b=Lk310cYc1yI34TO7djDpwZuI0Ap95oYUSII5nSvGuXGuLGdL0EfzRikjNG2R0ZFnbU
         5+3POmPw6GsEx8FAi9TofX1zjV2/ezHcXiaxYSWV7nYLelvneQiTeuIlNO+w6iebcplc
         H0pzaIMNCBhAz350PA2ODNuzeJNZ8eloUNwxaEKxoaEMNNNRRQFgOfiDzPYtwAmzhlU1
         k8NU+/qPW00b44/bV3VOLvp7TKf1QUwXBVkSHRA+BP1kADexvsUPG5wy5mxawEZgTg/e
         SfQ0QJK+vpqmK3SYQTnX5bpPtIf8awy6/d6DX4Dgyht1PaI0ah/4G2sFc04aYWRNe5M2
         Blgg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772093540; x=1772698340; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wZfa1EIpB3IbPnBHrQupmb9pJPiByw+1vE5DawlK1HU=;
        b=doEIrohB0/g1GGm52JWnearamqtq3nZOG8usz5Mcm54WtiPthskVOj/t3iD6baTHzr
         s189aaGcV/p8NQBrZOFBfJlmGuuXOr7xCw3piOS8W1U/8dDMF8NiDB9osctFP21fJXjc
         hMIKZHK9yTuQwgRz2qr33fSckFHjm6roS3nmMrM2lcMJ5yjRpC/jWaliCKNzfFjFliWW
         2NOpjgNZb1VwEVlXDG2ANjD821SF8g2b0D0LoI/odLtaOTWoNHy1Cc5hf/9CxbIBGLaR
         H/LYReKaIsuYmzHFzNQ9WB/xTKVtpOR4hjh9eaNgpQK1z0766xsXzE0gEPB8thN6cQOO
         F+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772093540; x=1772698340;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wZfa1EIpB3IbPnBHrQupmb9pJPiByw+1vE5DawlK1HU=;
        b=BsFbsMXknJz0dSl3jyyPejFFYKCdfW2/xev+aKC/VYZy3C7AB6ULqDnog5mYnsgzws
         wBf/sjs6F19UGtWtiAg8iAPdIE++R3BgBRXhNYgMTyTKFspNW4Mc3xkEGV6GuJVjrGQT
         wgpKzjEQYNNrElwOWsLl+S0VCwWz92xMPkkQHqOC1LeTWo3lagUjbNARR1EdGkBS19lM
         eiBiQ2UBJeObpWJK4biaMCfz+W/vKdslT36Ng9vP2RgjwBDGZBjYtBLll0GPzCzKZIHt
         B/Sd7hSrW6I9f35eRY4LKUdU/RPUit2OYwvlUUpKqdTMCMztQpkYzDpg+03cRRpbie1v
         ExiA==
X-Gm-Message-State: AOJu0Yw4PI9z1qL6r3Ja+B1fvzjl8zxtofd69wp3qxN5h9wnAnBGL0nI
	HZOBZOHSsVmhYYTJr7vaO/3VeRd8MNrmMGTvvDhtVMDKtTvYq1bH9g9+AgkZFXWWkI9eQ2lVGJ1
	ORMVy534x9NZKC/eC5p9gVYW2Oq25fcz7huRnsw6e
X-Gm-Gg: ATEYQzxYmgYGWTO5oZcdEFozoPAmzAd8ozwEdvtybvNGMQ2SNifJP5Ww7oxed7bEjcn
	2TW8pV1JAFCbxg1M34M8BlbH2rpsOg/UhoS8BKM63uYjFEgPnGdaQW5YUgAKC7FSQOjSOnqWqaD
	mSHW87+dAS5WGPByQSPahdGK6UrsXYkg1zd/+kT6pgQwTLPl4USIoXohdkQpIkSFY4Dtk2YyHT+
	QsYegGFvPtZJR1HAh/+7+CSGv7aNIlE0osU/RHLDUw8SyfgcrNMh3S9V/ELpFNDCLuVrfbZYZSx
	NSWOOwpy
X-Received: by 2002:ac8:5852:0:b0:4f0:2e33:81aa with SMTP id
 d75a77b69052e-507454fce67mr6996261cf.11.1772093539300; Thu, 26 Feb 2026
 00:12:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1770071243.git.ackerleytng@google.com> <86ad28b767524e1e654b9c960e39ca8bfb24c114.1770071243.git.ackerleytng@google.com>
 <CAEvNRgFMNywpDRr+WeNsVj=MnsbhZp9H3j0QRDo_eOP+kGCNJw@mail.gmail.com>
 <CAEvNRgFBLgvYoR_XTH-LiN1Q00R9u1HGC5URbstLPxYtedS0MA@mail.gmail.com>
 <CA+EHjTxDSW=y=sPRwW70Bz9RVYM3kSCLSbWc_X4v9hz6zj=mcg@mail.gmail.com> <CAEvNRgGp598JjouayFhyVKRJnYitNYZ2Ftik0zGyS1HdYaJLKA@mail.gmail.com>
In-Reply-To: <CAEvNRgGp598JjouayFhyVKRJnYitNYZ2Ftik0zGyS1HdYaJLKA@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 26 Feb 2026 08:11:42 +0000
X-Gm-Features: AaiRm52UzPK3MeO4gmJeqwsYXzjGPz6SNTtp4C4DmuoBtkM1oMmsg2JDrPbKXtY
Message-ID: <CA+EHjTyHtjUBARXOUCQaBb-rXw0teM4vtuLzH_pXK+WMVp+8hw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 09/37] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
To: Ackerley Tng <ackerleytng@google.com>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org, aik@amd.com, 
	andrew.jones@linux.dev, binbin.wu@linux.intel.com, bp@alien8.de, 
	brauner@kernel.org, chao.p.peng@intel.com, chao.p.peng@linux.intel.com, 
	chenhuacai@kernel.org, corbet@lwn.net, dave.hansen@linux.intel.com, 
	david@kernel.org, hpa@zytor.com, ira.weiny@intel.com, jgg@nvidia.com, 
	jmattson@google.com, jroedel@suse.de, jthoughton@google.com, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tglx@linutronix.de, vannapurve@google.com, 
	vbabka@suse.cz, willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71937-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[50];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BC2911A25C9
X-Rspamd-Action: no action

Hi Ackerley,

On Thu, 26 Feb 2026 at 04:16, Ackerley Tng <ackerleytng@google.com> wrote:
>
> Fuad Tabba <tabba@google.com> writes:
>
> > Hi Ackerley,
> >
> > Here are my thoughts, at least when it comes to pKVM.
> >
> >
> > On Tue, 24 Feb 2026 at 10:14, Ackerley Tng <ackerleytng@google.com> wrote:
> >>
> >> Ackerley Tng <ackerleytng@google.com> writes:
> >>
> >> > Ackerley Tng <ackerleytng@google.com> writes:
> >> >
> >> >>
> >> >> [...snip...]
> >> >>
> >> > Before this lands, Sean wants, at the very minimum, an in-principle
> >> > agreement on guest_memfd behavior with respect to whether or not memory
> >> > should be preserved on conversion.
> >> >>
> >> >> [...snip...]
> >> >>
> >>
> >> Here's what I've come up with, following up from last guest_memfd
> >> biweekly.
> >>
> >> Every KVM_SET_MEMORY_ATTRIBUTES2 request will be accompanied by an
> >> enum set_memory_attributes_content_policy:
> >>
> >>     enum set_memory_attributes_content_policy {
> >>         SET_MEMORY_ATTRIBUTES_CONTENT_ZERO,
> >>         SET_MEMORY_ATTRIBUTES_CONTENT_READABLE,
> >>         SET_MEMORY_ATTRIBUTES_CONTENT_ENCRYPTED,
> >>     }
> >>
> >> Within guest_memfd's KVM_SET_MEMORY_ATTRIBUTES2 handler, guest_memfd
> >> will make an arch call
> >>
> >>     kvm_gmem_arch_content_policy_supported(kvm, policy, gfn, nr_pages)
> >>
> >> where every arch will get to return some error if the requested policy
> >> is not supported for the given range.
> >
> > This hook provides the validation mechanism pKVM requires.
> >
> >> ZERO is the simplest of the above, it means that after the conversion
> >> the memory will be zeroed for the next reader.
> >>
> >> + TDX and SNP today will support ZERO since the firmware handles
> >>   zeroing.
> >> + pKVM and SW_PROTECTED_VM will apply software zeroing.
> >> + Purpose: having this policy in the API allows userspace to be sure
> >>   that the memory is zeroed after the conversion - there is no need to
> >>   zero again in userspace (addresses concern that Sean pointed out)
> >>
> >> READABLE means that after the conversion, the memory is readable by
> >> userspace (if converting to shared) or readable by the guest (if
> >> converting to private).
> >>
> >> + TDX and SNP (today) can't support this, so return -EOPNOTSUPP
> >> + SW_PROTECTED_VM will support this and do nothing extra on
> >>   conversion, since there is no encryption anyway and all content
> >>   remains readable.
> >> + pKVM will make use of the arch function above.
> >>
> >> Here's where I need input: (David's questions during the call about
> >> the full flow beginning with the guest prompted this).
> >>
> >> Since pKVM doesn't encrypt the memory contents, there must be some way
> >> that pKVM can say no when userspace requests to convert and retain
> >> READABLE contents? I think pKVM's arch function can be used to check
> >> if the guest previously made a conversion request. Fuad, to check that
> >> the guest made a conversion request, what's other parameters are
> >> needed other than gfn and nr_pages?
> >
> > The gfn and nr_pages parameters are enough I think.
> >
> > To clarify how pKVM would use this hook: all memory sharing and
> > unsharing must be initiated by the guest via a hypercall. When the
> > guest issues this hypercall, the pKVM hypervisor (EL2) exits to the
> > host kernel (EL1). The host kernel records the exit reason (share or
> > unshare) along with the specific memory address in the kvm_run
> > structure before exiting to userspace.
> >
> > We do not track this pending conversion state in the hypervisor. If a
> > compromised host kernel wants to lie and corrupt the state, it can
> > crash the system or the guest (which is an accepted DOS risk), but it
> > cannot compromise guest confidentiality because EL2 still strictly
> > enforces Stage-2 permissions. Our primary goal here is to prevent a
> > malicious or buggy userspace VMM from crashing the system.
> >
>
> Thinking through it again, there's actually no security (in terms of
> CoCo confidentiality) risk here, since the conversion ioctl doesn't
> actually tell the CoCo vendor/platform to encrypt/decrypt or flip
> permissions, it just unmaps the pages as requested.
>
> On TDX, if a rogue private to shared conversion request comes in, the
> private pages would get unmapped from the guest, and on the next guest
> access, the guest would access the page as private, so kvm's fault
> handler would think there's a shared/private mismatch and exit with
> KVM_EXIT_MEMORY_FAULT. Userspace now has a zeroed shared page, and the
> guest needs to re-accept the page to continue using it (if it knows what
> to do with a zeroed page). This would be userspace DOS-ing the guest,
> which userspace can do anyway.
>
> On pKVM, rephrasing what you said, even if there is a rogue private to
> shared conversion, EL2 still thinks of the page as private. After the
> conversion, the page can be faulted in by the host, but any access will
> be stopped by EL2.
>
> David, there's no missing piece in the flow!
>
> > When the VMM subsequently issues the KVM_SET_MEMORY_ATTRIBUTES2 ioctl
> > with the READABLE policy, we will use the
> > kvm_gmem_arch_content_policy_supported() hook in EL1 to validate the
> > ioctl. We will cross-reference the requested gfn and nr_pages against
> > the pending exit reason stored in kvm_run.
> >
> > If the VMM attempts an unsolicited conversion (i.e., there is no
> > matching exit request in kvm_run, or the addresses do not match), our
>
> Ah I see, so struct kvm_run is not considered "in the hypervisor" since
> it is modifiable by host userspace. Would you be using struct
> memory_fault in struct kvm_run?
>
> Which vcpu's kvm_run struct would you look up from
> kvm_gmem_arch_content_policy_supported()?
>
> For this to land, do you still want the gfn and nr_pages parameters?
>
> Can pKVM just always accept the request, whether the guest requested it
> or not? Thinking about it again,
> kvm_gmem_arch_content_policy_supported() probably shouldn't be used to
> guard solicited vs unsolicited requests anyway (unless you think the
> function's name should be changed?)

You spotted a flaw in my proposed validation mechanic. As you said,
KVM_SET_MEMORY_ATTRIBUTES2 is a VM-scoped ioctl, meaning we lack the
vCPU context required to safely inspect a specific kvm_run structure.
Attempting to track this state VM-wide in struct kvm_arch would
require introducing a lock on a hot memory-transition path, which we
want to avoid.

Your assessment of the security implications and the TDX fallback
mechanism is correct and applies to pKVM. Because EL2 maintains the
ultimate source of truth regarding Stage-2 permissions, a rogue
conversion by the VMM cannot breach guest confidentiality.

Given this, it makes sense for pKVM will adopt the TDX approach. We
will drop the requirement to synchronously validate the guest's intent
during the ioctl. We will always accept the request in EL1. If the VMM
is lying and the guest never actually authorized the share, the
resulting attribute mismatch will trigger a KVM_EXIT_MEMORY_FAULT upon
the next guest access, or a SIGBUS/SIGSEGV if the host userspace
attempts to map and read the memory. This will DOS/crash the VMM
without endangering the host kernel.

Therefore, kvm_gmem_arch_content_policy_supported() should not be used
for dynamic state-machine validation. We will use it strictly as a
static capability check (e.g., verifying that the requested policy is
architecturally possible).

I think that we would still require gfn and nr_pages in the hook to
allow for potential range-based capability checks in the future, but
not use them to cross-reference pending conversion requests.

Cheers,
/fuad

> > current plan is to reject the request and return an error. In the
> > future, rather than outright rejecting an unsolicited conversion, we
> > might evolve this to treat it as a host-initiated destructive reclaim,
> > forcing an unshare and zeroing the memory. For the time being,
> > explicit rejection is the simplest and safest path.
> >
>
> >> ENCRYPTED means that after the conversion, the memory contents are
> >> retained as-is, with no decryption.
> >>
> >> + TDX and SNP (today) can't support this, so return -EOPNOTSUPP
> >> + pKVM and SW_PROTECTED_VM can do nothing, but doing nothing retains
> >>   READABLE content, not ENCRYPTED content, hence SW_PROTECTED_VM
> >>   should return -EOPNOTSUPP.
> >> + Michael, you mentioned during the call that SNP is planning to
> >>   introduce a policy that retains the ENCRYPTED version for a special
> >>   GHCB call. ENCRYPTED is meant for that use case. Does it work? I'm
> >>   assuming that SNP should only support this policy given some
> >>   conditions, so would the arch call as described above work?
> >> + If this policy is specified on conversion from shared to private,
> >>   always return -EOPNOTSUPP.
> >> + When this first lands, ENCRYPTED will not be a valid option, but I'm
> >>   listing it here so we have line of sight to having this support.
> >>
> >> READABLE and ENCRYPTED defines the state after conversion clearly
> >> (instead of DONT_CARE or similar).
> >>
> >> DESTROY could be another policy, which means that after the
> >> conversion, the memory is unreadable. This is the option to address
> >> what David brought up during the call, for cases where userspace knows
> >> it is going to free the memory already and doesn't care about the
> >> state as long as nobody gets to read it. This will not implemented
> >> when feature first lands, but is presented here just to show how this
> >> can be extended in future.
> >>
> >> Right now, I'm thinking that one of the above policies MUST be
> >> specified (not specifying a policy will result in -EINVAL).
> >>
> >> How does this sound?
> >
> > I don't think that returning -EINVAL is the right thing to do here. If
> > userspace omits the policy, the API should default to
> > SET_MEMORY_ATTRIBUTES_CONTENT_ZERO and proceed with the conversion. I
> > believe that, in Linux APIs in general, omitting an optional behavior
> > flag results in the safest, most standard default action.
> >
>
> Makes sense, I'll default to zeroing then. Thanks!
>
> > Also, returning -EINVAL when no policy is specified makes the policy
> > parameter strictly mandatory. This makes it difficult for userspace's
> > to seamlessly request clean-slate, destructive conversions. Software
> > zeroing ensures deterministic behavior across pKVM, TDX, and SNP,
> > isolating the KVM uAPI from micro-architectural data destruction
> > nuances.
> >
> > Cheers,
> > /fuad

