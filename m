Return-Path: <kvm+bounces-71919-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oNSaDkPJn2lwdwQAu9opvQ
	(envelope-from <kvm+bounces-71919-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 05:17:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B0A1A0CFE
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 05:17:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84F933057499
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 04:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0B238A28F;
	Thu, 26 Feb 2026 04:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v5VP2MJw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB30328B75
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 04:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772079401; cv=pass; b=arySggKs3nTgwPro1RF8OJ80POT4g+qEiDRbmdKDMD6hv47dDJHRAvWVyqZ13PX8ViUFXAvHUwqceMGbhVHQqd6IMGrN20e6VIhPU2lBLhGsVm1zUIgXL1q4gSsqFDHbHX6z//uFp4revS3prXiRCCyezY0584AI+PDILF1bsTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772079401; c=relaxed/simple;
	bh=PJZLZUnePvIF1G2wVkJ0n1BC25Ib9fyE1tf9iir8QX8=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=maG7nxCCRxeZhA2Tpvd9GWyvl7ha4NFoLRGEWwhUV9O2FiX00w5Dh+KfXaLAxx3uznWnHOvtQ2qah7Qyi3pco7Rc+dFxpn5k3l2rYF4F13PmG87mSh5wIOG7QKJzChFKZDJ35ovyDnl9kPo2Nf5Yb83o7ROoMd6nRNg4IbSVqnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v5VP2MJw; arc=pass smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-94dd687e040so78499241.3
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 20:16:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772079398; cv=none;
        d=google.com; s=arc-20240605;
        b=TmNxmyplEhVZvqSEJs5qLB2teytv2RZax2hW0+uAS9mVyp8rchfxMMn5R8lmhPjyAv
         epFup19Bta8VMtT7IcES4qf1sroMHCZws7k4winmJsYqpQ9DKfW3lZk/RWxy1+4P4pcN
         HUvy1CIPvmIE1ULj6htlO3Q0SXQ6kLwOCC7DlbFn7ju8I9Hlh/msegv6LfWumXVyoiSd
         1LVJxvzs8VBZXGLm34pqvbuaBEjZW281CY5LqMN2AiWa9iAWOx7jObCHe2ZxaPjRiG7u
         VJ90okfjsS6uBC1NMBekn7pnxyaYujFh9iKgEbdcCbxvvhDo7aLc9uggaAXIec7aMH8F
         DEuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=w3wWy011f6Qtbv9PNCHOJcKFSIhVOg6iWVVieJxCv1k=;
        fh=SpHJ/PX9uDNwKDyLE21Bu6WpU0eGc0F2BXYQ8R1rDME=;
        b=DOn066u89FWhEkrntNaBhW7XykEtl7S3IjYAyOaNUJ/4VqTFcA2PR3Cd1MBkWKxUh8
         0pGah5rQ+Rz361o9OM7+nMMy1xZA5rymLwCKFNJFZjivNQD8NLuWPwQe7dWvRDnJ/JLH
         HoPemQmZdcR27LTukhoB62eCuEo7Q1Fqwl4vqvmmDvMk6IJNnvzJzGzLusNBRe8okzGw
         O4166jPhzKXFV+AINdEKjpWWUXOWSDF0+DbxotrEAx8pebowtma+Sota9J3TFQiFFSEN
         8ZzkPxOifkSSUxOA7CrjKPRL7jdueTiq3XGslOU47IM6p7Ijau0NJ031RmryvG70NCLP
         vLrw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772079398; x=1772684198; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=w3wWy011f6Qtbv9PNCHOJcKFSIhVOg6iWVVieJxCv1k=;
        b=v5VP2MJwADk7k+OKsLad3e9dMEcQS7gB30x2noX5tsGEZ5FhSoxWQP6ywuNElkTFSL
         NpeLRWa47SeFhVn0fdmTo63s5ZIVNBpJKcfoJ6Ty/0frv5QULhwV3U8D2sX91j8X0BU9
         kKpYbE/EWohwSE2DBGOT3KoIqBqXkJiGEBWxzrN9rZC8newHjPiRSIFvIiW4yTdUrEmx
         H+8RtMbM7/+VH2TtZ1wWeV5FNBJZA+U2GabXNXgPydf42u1SLeoKJmEARlDM+jKS4hyC
         25Erks5/0hc9tbiCgqiIosFblOzbwv3Q//80rwGhjRrmbVtCvRZdBl48r44x8SMFqWzB
         pb+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772079398; x=1772684198;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w3wWy011f6Qtbv9PNCHOJcKFSIhVOg6iWVVieJxCv1k=;
        b=Zo+Em7JPWIR8RYVe06IKEyOX7EPjgvYFOPK0zUS0IC/tdPcdcuZ6rhXbLfsf+ROWSw
         2ABjvDmvgKDx3yKi/OZpf9SdGa8rNSETt2+hj1Rmtpmw8w9YgCmrUNfxfAlGO4YFQGxS
         BlpyxctnARDlAm8Sb2/k3G0LLHyIi4R2Oskyts4pKAdGL57J+Nsph/Rteo53ETY0+M4V
         qnEEQ34tel6B7Nznk2BFQHvlbDprQMnzfbLbUGCq6PRhyu+RHntUZF5QUjH9HMPAWbGC
         bjRnBtOYTfTz1MgMfZWZdoeRUACsJKzwAW3Xf1GpklieW0jKacH/gujcVJrmUhJawsve
         iJ9Q==
X-Gm-Message-State: AOJu0Yy/5jTXzpvE39V4Pi7FIuv9Lx6lk0CchznKcSGQTFt/y65mC2vO
	qVw8wtwuwPc5dWhTJUmB0yFkqRMewZK+TlYUjGo3QXHQkA45mUeBKDIYylRSNEmrlXLHBVoyZHt
	/EE07Mlp7HSxhZtzAhgB93c14xVIWSNE84LAlR8nU
X-Gm-Gg: ATEYQzxVCiYR6H3Nsd9XqBfxpWv02/5rvN6MtS79/JbfWemdBvHBiPUIYyYSRJcWoVE
	426K+5DdVgSWOmsenwA7qxZ/aleJirp25pUVQU8Q5fbxhOhllWo6hbH0Nkcge5UD0mPpmQatE/n
	MZI//WiWdFjl5hrhi+rMTYBUY+qarpKroZrDWAW0LDCpZu5xNZdTBmgYQdF7/2zgutkTBpM9Tzr
	IrlWxDoMPNNZhYlFv2al0cLjJJY3eOpZ8YQkGyw359rJFIWD1mzjl4QUzMipEaeBuvrL4uwsbbI
	RNoiDAW3vIquz2eFECYIMjP/wuXN6ZhhvsgVCRra0PgMgUQF4UNZEjGycCDzjB/NoXww0n4GpPZ
	k1uIP
X-Received: by 2002:a05:6102:32d1:b0:5f5:3d46:e5fb with SMTP id
 ada2fe7eead31-5feb2e58497mr6645208137.5.1772079397784; Wed, 25 Feb 2026
 20:16:37 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 25 Feb 2026 20:16:36 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 25 Feb 2026 20:16:36 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CA+EHjTxDSW=y=sPRwW70Bz9RVYM3kSCLSbWc_X4v9hz6zj=mcg@mail.gmail.com>
References: <cover.1770071243.git.ackerleytng@google.com> <86ad28b767524e1e654b9c960e39ca8bfb24c114.1770071243.git.ackerleytng@google.com>
 <CAEvNRgFMNywpDRr+WeNsVj=MnsbhZp9H3j0QRDo_eOP+kGCNJw@mail.gmail.com>
 <CAEvNRgFBLgvYoR_XTH-LiN1Q00R9u1HGC5URbstLPxYtedS0MA@mail.gmail.com> <CA+EHjTxDSW=y=sPRwW70Bz9RVYM3kSCLSbWc_X4v9hz6zj=mcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 25 Feb 2026 20:16:36 -0800
X-Gm-Features: AaiRm50U-5gCjd8d4vexak6il7qxXrrUihlkIadyW5OUwMyyjBZ1OgjuY1VDESk
Message-ID: <CAEvNRgGp598JjouayFhyVKRJnYitNYZ2Ftik0zGyS1HdYaJLKA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 09/37] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
To: Fuad Tabba <tabba@google.com>
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
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[google.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71919-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_GT_50(0.00)[50];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 92B0A1A0CFE
X-Rspamd-Action: no action

Fuad Tabba <tabba@google.com> writes:

> Hi Ackerley,
>
> Here are my thoughts, at least when it comes to pKVM.
>
>
> On Tue, 24 Feb 2026 at 10:14, Ackerley Tng <ackerleytng@google.com> wrote:
>>
>> Ackerley Tng <ackerleytng@google.com> writes:
>>
>> > Ackerley Tng <ackerleytng@google.com> writes:
>> >
>> >>
>> >> [...snip...]
>> >>
>> > Before this lands, Sean wants, at the very minimum, an in-principle
>> > agreement on guest_memfd behavior with respect to whether or not memory
>> > should be preserved on conversion.
>> >>
>> >> [...snip...]
>> >>
>>
>> Here's what I've come up with, following up from last guest_memfd
>> biweekly.
>>
>> Every KVM_SET_MEMORY_ATTRIBUTES2 request will be accompanied by an
>> enum set_memory_attributes_content_policy:
>>
>>     enum set_memory_attributes_content_policy {
>>         SET_MEMORY_ATTRIBUTES_CONTENT_ZERO,
>>         SET_MEMORY_ATTRIBUTES_CONTENT_READABLE,
>>         SET_MEMORY_ATTRIBUTES_CONTENT_ENCRYPTED,
>>     }
>>
>> Within guest_memfd's KVM_SET_MEMORY_ATTRIBUTES2 handler, guest_memfd
>> will make an arch call
>>
>>     kvm_gmem_arch_content_policy_supported(kvm, policy, gfn, nr_pages)
>>
>> where every arch will get to return some error if the requested policy
>> is not supported for the given range.
>
> This hook provides the validation mechanism pKVM requires.
>
>> ZERO is the simplest of the above, it means that after the conversion
>> the memory will be zeroed for the next reader.
>>
>> + TDX and SNP today will support ZERO since the firmware handles
>>   zeroing.
>> + pKVM and SW_PROTECTED_VM will apply software zeroing.
>> + Purpose: having this policy in the API allows userspace to be sure
>>   that the memory is zeroed after the conversion - there is no need to
>>   zero again in userspace (addresses concern that Sean pointed out)
>>
>> READABLE means that after the conversion, the memory is readable by
>> userspace (if converting to shared) or readable by the guest (if
>> converting to private).
>>
>> + TDX and SNP (today) can't support this, so return -EOPNOTSUPP
>> + SW_PROTECTED_VM will support this and do nothing extra on
>>   conversion, since there is no encryption anyway and all content
>>   remains readable.
>> + pKVM will make use of the arch function above.
>>
>> Here's where I need input: (David's questions during the call about
>> the full flow beginning with the guest prompted this).
>>
>> Since pKVM doesn't encrypt the memory contents, there must be some way
>> that pKVM can say no when userspace requests to convert and retain
>> READABLE contents? I think pKVM's arch function can be used to check
>> if the guest previously made a conversion request. Fuad, to check that
>> the guest made a conversion request, what's other parameters are
>> needed other than gfn and nr_pages?
>
> The gfn and nr_pages parameters are enough I think.
>
> To clarify how pKVM would use this hook: all memory sharing and
> unsharing must be initiated by the guest via a hypercall. When the
> guest issues this hypercall, the pKVM hypervisor (EL2) exits to the
> host kernel (EL1). The host kernel records the exit reason (share or
> unshare) along with the specific memory address in the kvm_run
> structure before exiting to userspace.
>
> We do not track this pending conversion state in the hypervisor. If a
> compromised host kernel wants to lie and corrupt the state, it can
> crash the system or the guest (which is an accepted DOS risk), but it
> cannot compromise guest confidentiality because EL2 still strictly
> enforces Stage-2 permissions. Our primary goal here is to prevent a
> malicious or buggy userspace VMM from crashing the system.
>

Thinking through it again, there's actually no security (in terms of
CoCo confidentiality) risk here, since the conversion ioctl doesn't
actually tell the CoCo vendor/platform to encrypt/decrypt or flip
permissions, it just unmaps the pages as requested.

On TDX, if a rogue private to shared conversion request comes in, the
private pages would get unmapped from the guest, and on the next guest
access, the guest would access the page as private, so kvm's fault
handler would think there's a shared/private mismatch and exit with
KVM_EXIT_MEMORY_FAULT. Userspace now has a zeroed shared page, and the
guest needs to re-accept the page to continue using it (if it knows what
to do with a zeroed page). This would be userspace DOS-ing the guest,
which userspace can do anyway.

On pKVM, rephrasing what you said, even if there is a rogue private to
shared conversion, EL2 still thinks of the page as private. After the
conversion, the page can be faulted in by the host, but any access will
be stopped by EL2.

David, there's no missing piece in the flow!

> When the VMM subsequently issues the KVM_SET_MEMORY_ATTRIBUTES2 ioctl
> with the READABLE policy, we will use the
> kvm_gmem_arch_content_policy_supported() hook in EL1 to validate the
> ioctl. We will cross-reference the requested gfn and nr_pages against
> the pending exit reason stored in kvm_run.
>
> If the VMM attempts an unsolicited conversion (i.e., there is no
> matching exit request in kvm_run, or the addresses do not match), our

Ah I see, so struct kvm_run is not considered "in the hypervisor" since
it is modifiable by host userspace. Would you be using struct
memory_fault in struct kvm_run?

Which vcpu's kvm_run struct would you look up from
kvm_gmem_arch_content_policy_supported()?

For this to land, do you still want the gfn and nr_pages parameters?

Can pKVM just always accept the request, whether the guest requested it
or not? Thinking about it again,
kvm_gmem_arch_content_policy_supported() probably shouldn't be used to
guard solicited vs unsolicited requests anyway (unless you think the
function's name should be changed?)

> current plan is to reject the request and return an error. In the
> future, rather than outright rejecting an unsolicited conversion, we
> might evolve this to treat it as a host-initiated destructive reclaim,
> forcing an unshare and zeroing the memory. For the time being,
> explicit rejection is the simplest and safest path.
>

>> ENCRYPTED means that after the conversion, the memory contents are
>> retained as-is, with no decryption.
>>
>> + TDX and SNP (today) can't support this, so return -EOPNOTSUPP
>> + pKVM and SW_PROTECTED_VM can do nothing, but doing nothing retains
>>   READABLE content, not ENCRYPTED content, hence SW_PROTECTED_VM
>>   should return -EOPNOTSUPP.
>> + Michael, you mentioned during the call that SNP is planning to
>>   introduce a policy that retains the ENCRYPTED version for a special
>>   GHCB call. ENCRYPTED is meant for that use case. Does it work? I'm
>>   assuming that SNP should only support this policy given some
>>   conditions, so would the arch call as described above work?
>> + If this policy is specified on conversion from shared to private,
>>   always return -EOPNOTSUPP.
>> + When this first lands, ENCRYPTED will not be a valid option, but I'm
>>   listing it here so we have line of sight to having this support.
>>
>> READABLE and ENCRYPTED defines the state after conversion clearly
>> (instead of DONT_CARE or similar).
>>
>> DESTROY could be another policy, which means that after the
>> conversion, the memory is unreadable. This is the option to address
>> what David brought up during the call, for cases where userspace knows
>> it is going to free the memory already and doesn't care about the
>> state as long as nobody gets to read it. This will not implemented
>> when feature first lands, but is presented here just to show how this
>> can be extended in future.
>>
>> Right now, I'm thinking that one of the above policies MUST be
>> specified (not specifying a policy will result in -EINVAL).
>>
>> How does this sound?
>
> I don't think that returning -EINVAL is the right thing to do here. If
> userspace omits the policy, the API should default to
> SET_MEMORY_ATTRIBUTES_CONTENT_ZERO and proceed with the conversion. I
> believe that, in Linux APIs in general, omitting an optional behavior
> flag results in the safest, most standard default action.
>

Makes sense, I'll default to zeroing then. Thanks!

> Also, returning -EINVAL when no policy is specified makes the policy
> parameter strictly mandatory. This makes it difficult for userspace's
> to seamlessly request clean-slate, destructive conversions. Software
> zeroing ensures deterministic behavior across pKVM, TDX, and SNP,
> isolating the KVM uAPI from micro-architectural data destruction
> nuances.
>
> Cheers,
> /fuad

