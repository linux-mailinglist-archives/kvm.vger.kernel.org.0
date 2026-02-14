Return-Path: <kvm+bounces-71102-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OK3YN6PWkGkFdQEAu9opvQ
	(envelope-from <kvm+bounces-71102-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 21:10:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3732213D1B2
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 21:10:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2CFF630293F4
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 20:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2956430F54B;
	Sat, 14 Feb 2026 20:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c69O+6Wi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A53930F52C
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 20:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771099794; cv=pass; b=swsKP+tO/36Io38CwPC8xQXSFfWhv+yW9pFHQEdKAsBWtKkjB3CcrMvVCvR0OduU06DgcdYLPP3FYffF/fka86tTBTuUxmLmzEPIuYnAaw1180fv7O3dX0/mwBZRS47k2GuQq087AYmti3QvPSD50Mluj9l1J9rtMKKFRzHKptg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771099794; c=relaxed/simple;
	bh=FufzZ4uU/iS1q/sxK46E3rWJ6kguU0PcbAexdJqkwRY=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XweDygOKvDP9NxRqnSGeZ9mvhaiCVIvmw1PJ64UBl13n8YhD35aECS7cKmfP3g91C1g0Wm2Iyh5TEKjHOwA+njgOQWkovf/jv3M/MuLLpYoI78pr2PRkscZta+lePTzDZtvC+Yrmuj4C65izp7CvamLI+7e2asLddNfZINsXR8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c69O+6Wi; arc=pass smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-948ab1c79ebso579972241.1
        for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 12:09:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771099790; cv=none;
        d=google.com; s=arc-20240605;
        b=gs1ru/QM2zT62ZejLDtbTnpBSeHA0fVzjM789zrQ5Ii9ay1T5o3K2D0tH9BR+QUzDI
         SCAXXR4ReahhzWDbCpoNM33ORBbuKZM4VlZ0pm3pIqtiiaFru3UIwZC/4TiIvm7VKWLY
         9pAwvGh23RwdWvC6gDd6VYayDF/kLCFZ971664kGQH9kPYoM+NYhLoAIoGV7WBOH3/QS
         jt3C+LAUwGNLV0t4/DuivsYYKfOmUJjPdImRo20AD/X0itfGzrtsBRQDfbMMqi4z08CJ
         Fix5JDqi8eSYT3GEK3ZoX0YEiCc8RacUjZSs+++l1fhJFEJ3SaNU1SbZAgeZKnr1vlAe
         tNlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=1jQpoSMsRYyXQLWbsh+LVZl2/hfELtMQa6Z0sSC+Mns=;
        fh=QuGRZV+lwkLB3Ja08qWMJmOBQhdHSed+R2+HERPlsPk=;
        b=h1IG6hSp9J6TqI8DRX4tC2RyA1a9NgLGnTD9JBlV1GUQqrZ3gs74zSrkVpqPCwUF23
         TBTRer/Ka6LS/VIeXBhkacTGtqINJCKNlq3uU2mpuX4CymwB74Zk40MNeeuSjOxbzUhH
         QcTbXtCnnuc9ZjCAulSOuiEkNk8DsYblHcwF4040MNSxdYnKMFSP1Hxhiz78oSBy+GUh
         MoUUT9UlZoLCW7ZpjR1LvUs0BGswDekSdQtR+b/+mBH5ot1NtbvUMaW+0D41X4elpJcn
         ZmTpXc3TJv4NvlH2tdO19AABBP+uD0rxYQ4HTfjbDp5WyuH6QMaWbHuWfCkC1llEgXiL
         d0Iw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771099790; x=1771704590; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=1jQpoSMsRYyXQLWbsh+LVZl2/hfELtMQa6Z0sSC+Mns=;
        b=c69O+6WiC3D+oJAldcWVy75tWL6Mk44q+MqO47KVEoV5FFmTtNXa4HHKYQqvin5C0B
         YITY0Zl4Bb5dk1Gb9Kg9IItF5V2q+I3ljh6fFxT5z0WH9zR+vRHKKN3qQ5bVMIuFHFGb
         0TsCMeSIZFZo4sHTNKuukgp1yl8svj9AJOZL1+oHO9iz/hXfeBpRR6ZU1tyinaySe8Rm
         BSBo+26xTip+Prhs0Pk3m0K42AXyNb2CR0yAYWZ9XPOFpad36EKw8re+wODVR2/MYgri
         /stt/vgWae1KJydSMTz0LmxIfYnsmdcbtBnCjaNIh5TGSM3apBbwoTtbMQByIKvO1/LO
         Iz0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771099790; x=1771704590;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1jQpoSMsRYyXQLWbsh+LVZl2/hfELtMQa6Z0sSC+Mns=;
        b=XRrm1qyz/ln1vb7B1JpTLt1unWSz0Ezi2iuctzjXqcT9ATKrwyWK8sLxFh/zoMmWP/
         frqx6sbBywwmIIsp7w8hosY2X1nd9l9XycRRSnxEVxPqJo2nCa33VNYCoEmyvxL1yHgN
         3AG/msDfIl/Ld4xgBsu8QHsXWZQ3aKM9e0FC/9ersEHOZRoXWyCwphETnyS63cit/1dd
         Oe55W38YLPOcd+n8lmhGfSgVZiQbhGshZm8plXuA1LFnqqHunoO6HJ08faAcCXQSrnQR
         4eavhHVyHbZFQc5vF6vCRZUpKBigf5jFCI1ESxTDIM81DNnyaXQT853Rrb1v0qz6sYfD
         krIQ==
X-Gm-Message-State: AOJu0YxFClraagU3GjNK6LdsJW9VHaN9ohuHITX3YjtIJ0gkX8tokd0i
	WeEAD1AvQ4BLFlCgJZHmxl8IAPsSMt+xA/ou7jR1smL7YVopomt/38vGR71aZIGLVjN0N+fEbUA
	k1TRLnYjaSWYmKKEQIG7CG+IVtfIkKG+tuGRufkcnKo3bnri/l0Cy4pdPErTcpuxA
X-Gm-Gg: AZuq6aLQHPOyZ46ZCPOF7mgXRAlCu8EFLq/uNfbkZuo3ySmDpUH+6w94nrTxiKriUWn
	vSX9gqfgh3L40uyKJKdbLB390B1UA9O72yFsnz0W6objndREpxeTA6E1oE2yvnHDL4btpTAU5Qb
	8YtyZqD+sQJcwmJVyyh6PGsfvsPN3VUPxhSmCosLCtUm8wLRwNlMpI5w/kZS4SQCGOwPOUULN6K
	J9UwkjXXIltS6pK2XDRpIcMtZOSP9FOWGddRmgclCe401QvQoIlsU7Ag/RLreuQFWCvIe81jBVF
	4jBJNOI9OaqZtxpIoTz0TzoLlSllezpFCjcPnaPQhw==
X-Received: by 2002:a05:6102:358d:b0:5f1:4fc3:855d with SMTP id
 ada2fe7eead31-5fe16f7123cmr2125991137.38.1771099789089; Sat, 14 Feb 2026
 12:09:49 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 14 Feb 2026 12:09:48 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 14 Feb 2026 12:09:48 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <86ad28b767524e1e654b9c960e39ca8bfb24c114.1770071243.git.ackerleytng@google.com>
References: <cover.1770071243.git.ackerleytng@google.com> <86ad28b767524e1e654b9c960e39ca8bfb24c114.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 14 Feb 2026 12:09:48 -0800
X-Gm-Features: AaiRm50-4IHejrw9QDCNjWRongMJUvF1-Uwjne7RAjYwOg9FxNIKczofN5-jceI
Message-ID: <CAEvNRgFMNywpDRr+WeNsVj=MnsbhZp9H3j0QRDo_eOP+kGCNJw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 09/37] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_GT_50(0.00)[50];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_FROM(0.00)[bounces-71102-lists,kvm=lfdr.de];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Queue-Id: 3732213D1B2
X-Rspamd-Action: no action

Ackerley Tng <ackerleytng@google.com> writes:

>
> [...snip...]
>
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 23ec0b0c3e22..26e80745c8b4 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -117,7 +117,7 @@ description:
>        x86 includes both i386 and x86_64.
>
>    Type:
> -      system, vm, or vcpu.
> +      system, vm, vcpu or guest_memfd.
>
>    Parameters:
>        what parameters are accepted by the ioctl.
> @@ -6523,11 +6523,22 @@ the capability to be present.
>  ---------------------------------
>
>  :Capability: KVM_CAP_MEMORY_ATTRIBUTES2
> -:Architectures: x86
> -:Type: vm ioctl
> +:Architectures: all
> +:Type: vm, guest_memfd ioctl
>  :Parameters: struct kvm_memory_attributes2 (in/out)
>  :Returns: 0 on success, <0 on error
>
> +Errors:
> +
> +  ========== ===============================================================
> +  EINVAL     The specified `offset` or `size` were invalid (e.g. not
> +             page aligned, causes an overflow, or size is zero).
> +  EFAULT     The parameter address was invalid.
> +  EAGAIN     Some page within requested range had unexpected refcounts. The
> +             offset of the page will be returned in `error_offset`.
> +  ENOMEM     Ran out of memory trying to track private/shared state
> +  ========== ===============================================================
> +
>  KVM_SET_MEMORY_ATTRIBUTES2 is an extension to
>  KVM_SET_MEMORY_ATTRIBUTES that supports returning (writing) values to
>  userspace.  The original (pre-extension) fields are shared with
> @@ -6538,15 +6549,42 @@ Attribute values are shared with KVM_SET_MEMORY_ATTRIBUTES.
>  ::
>
>    struct kvm_memory_attributes2 {
> -	__u64 address;
> +	/* in */
> +	union {
> +		__u64 address;
> +		__u64 offset;
> +	};
>  	__u64 size;
>  	__u64 attributes;
>  	__u64 flags;
> -	__u64 reserved[12];
> +	/* out */
> +	__u64 error_offset;
> +	__u64 reserved[11];
>    };
>
>    #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
>
> +Set attributes for a range of offsets within a guest_memfd to
> +KVM_MEMORY_ATTRIBUTE_PRIVATE to limit the specified guest_memfd backed
> +memory range for guest_use. Even if KVM_CAP_GUEST_MEMFD_MMAP is
> +supported, after a successful call to set
> +KVM_MEMORY_ATTRIBUTE_PRIVATE, the requested range will not be mappable
> +into host userspace and will only be mappable by the guest.
> +
> +To allow the range to be mappable into host userspace again, call
> +KVM_SET_MEMORY_ATTRIBUTES2 on the guest_memfd again with
> +KVM_MEMORY_ATTRIBUTE_PRIVATE unset.
> +
> +If this ioctl returns -EAGAIN, the offset of the page with unexpected
> +refcounts will be returned in `error_offset`. This can occur if there
> +are transient refcounts on the pages, taken by other parts of the
> +kernel.
> +
> +Userspace is expected to figure out how to remove all known refcounts
> +on the shared pages, such as refcounts taken by get_user_pages(), and
> +try the ioctl again. A possible source of these long term refcounts is
> +if the guest_memfd memory was pinned in IOMMU page tables.
> +
>  See also: :ref: `KVM_SET_MEMORY_ATTRIBUTES`.
>

Transferring/re-summarizing an internal comment from Sean upstream here!
We can also follow up on this topic at the next guest_memfd biweekly.


Before this lands, Sean wants, at the very minimum, an in-principle
agreement on guest_memfd behavior with respect to whether or not memory
should be preserved on conversion.

Sean is against deferring whether to preserve memory to the underlying
hardware because that is letting (effectively) micro-architectural
behavior to define KVM's ABI. KVM's uAPI cannot let behavior be
undefined, or be based on vendor, and maybe even on firmware version.

Sean says that all decisions that affect guest data must be made by
userspace. The architecture can restrict what is possible, e.g. neither
SNP nor TDX currently support "generic" in-place conversion, but whether
or not data is to be preserved must be an explicit request from
userspace. If preserving data is impossible, then KVM needs to reject
the request.

(Vendor specific ioctls are out-of-scope, SNP and TDX cases were brought
up purely to highlight that there's nothing that fundamentally prevents
preserving data on conversion.)

I suggested a few uAPI options for configuring content preservation on
conversion:

1. guest_memfd creation time flag like
   GUEST_MEMFD_FLAG_PRESERVE_CONTENTS. This can be valid only if the
   kernel and vendor support content preservation

This was rejected because we should not assume all current and future
use cases will want the same content preservation config for a given
guest_memfd.

2. KConfig: automatically select to preserve contents if the
   architecture supports content preservation

This was rejected because it's not a decision explicitly made by
userspace.

3. KVM module param to configure content preservation.

This was rejected because the configuration may not generalize across
all VMs on the same host.

4. guest_memfd ioctl flag
   SET_MEMORY_ATTRIBUTES2_FLAG_PRESERVE_CONTENTS. -EINVAL if kernel and
   vendor don't support content preservation

Specifying a flag to choose whether content should be preserved at
conversion-time is the current best suggestion.

What does the rest of the community think of a conversion ioctl flag to
choose whether to preserve memory contents on conversion?

Fuad, I think you also made a related comment on an earlier internal
version we were working on. What do you/pKVM think?

>
> [...snip...]
>

