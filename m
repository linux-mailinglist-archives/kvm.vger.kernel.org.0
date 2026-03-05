Return-Path: <kvm+bounces-72771-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EGNJB/HbqGnGxwAAu9opvQ
	(envelope-from <kvm+bounces-72771-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 02:27:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 71B98209CD9
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 02:27:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A9693301C5B9
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 01:26:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1847E23EAA3;
	Thu,  5 Mar 2026 01:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eGv9Arrd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BA270818
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 01:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772674015; cv=none; b=nP/Pidu2QlJVktq1PC9UjnPzaTgkCxMwAAhVxB/D/f2H9pxp27gvspxPx2TeTDGatN3P0x5i7z5Ud8F8TgEDQrUGSuwwwgBLc2X6I8v8T0HeuPJlxRJ9AQjjaxG5BbYRs2QWqW8cBBvO4SvJFZT4n6tebH97bdRqiyshkESZMB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772674015; c=relaxed/simple;
	bh=/0qPIDgIv+m8wozZylnG8a0u9sAxt5bNJ60+VcdLP/M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ssG/LAaPFOeu5IJ8ORjSPuYBaEOWNDdgv2Q5+2vqirYcMXRck+NYoK2JfFc9u7ZGog97YmmDRGivKkmLeEDZEdCDR57l8JUnhTn27mfW6B2EUjGhgyUypz3gIdj2FIOD4PEYxU+BwwEszRY21FZJ0boWfZWji6ZhumewlkazjsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eGv9Arrd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354bc535546so6046255a91.3
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2026 17:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772674013; x=1773278813; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kytmVqKG3aY9yjemyVQ7Mf9IYhcgcMGkDg/Fji7VFk4=;
        b=eGv9Arrdb+nJG2OVr3Ixj3LJWSpuKDp5dEUAZ5v3yQ/ix5evh+KWB5tgE2xGHCyoRE
         DeAf+b4BUrRrQB8SYr1+zA55LXI00ddMRblDTAkgch1bgS1wHlK4cHEe/R05hmu7Xq6o
         3TOYLQvYiC77rRVO6qcR8m5m++JY8Vfct2lfrf07anCDcmKclSXrPt/rhGQYgijW44Ns
         tFMUk83/4m+5EeAno+ckAyWYTCuxoWK9ybzijHmUhLcfLE9VvyVqW4dkuBFA2PhktYtq
         0m8+/YbRSxLthwbfuFhHj1FLx1AFmNa8a+Q8dtEQtX1qz7SkbthqelpP/Ud4LMnlEgpt
         +Vag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772674013; x=1773278813;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kytmVqKG3aY9yjemyVQ7Mf9IYhcgcMGkDg/Fji7VFk4=;
        b=FlNVGw+9IPy9wN6RSkqLb00cgIwGD+Krf4xNrrgu/kV+0RvtE0FNX1PSQ8KVF8ZM+i
         PKTfPPw+r9DaCVXaCsfpLwEBC+xMm8MatojXUK9inDIW1Fn31+OGKXfAAuqp71XGAvM1
         mJeoUxeRL0JPUukL9TnrD84zBSJiHO66YCr0FAD8PiiRruh/vY1KCsRCuTkKJTGGKv1T
         uH6zsjP/ZTov1tZkVtnqXyy+bydgmKmaDPhEkaSkmMmMmn/22K1x8dVqPLJLVcDZDokx
         YBQ4x7nYZjfSlnIdJyEkGhj1LjadMJZSBdc9qtjJ7TeyDvDpR8C/EJpThMNlMVnnlAet
         3HVg==
X-Forwarded-Encrypted: i=1; AJvYcCUADzrv8RNWAIkxjUADbrQz151QeQ4RC2TbgE7yAH6qOnWuFVrexmdx5xwfxAv6NrK0VXM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY0gPThP40N0kceR//kFJna63dR5ooawx4/RBi5nYrATIozDms
	ixscn4ns+GN8qVuW6HkP9D6Z84x+aSmXZy31LqdvQX5GUjvyQ22KoFt/kVaK9ZK7U71upH51QxM
	3jH4w6g==
X-Received: from pjom4.prod.google.com ([2002:a17:90a:9204:b0:34a:bebf:c162])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ccf:b0:354:bd08:4802
 with SMTP id 98e67ed59e1d1-359a6a7c458mr3085504a91.35.1772674013259; Wed, 04
 Mar 2026 17:26:53 -0800 (PST)
Date: Wed, 4 Mar 2026 17:26:46 -0800
In-Reply-To: <20260302122826.2572-1-thanos.makatos@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aWakWRrEUeaIeVna@google.com> <20260302122826.2572-1-thanos.makatos@nutanix.com>
Message-ID: <aajb1r7Al7mxK5Zf@google.com>
Subject: Re: [PATCH] KVM: optionally post write on ioeventfd write
From: Sean Christopherson <seanjc@google.com>
To: Thanos Makatos <thanos.makatos@nutanix.com>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, John Levon <john.levon@nutanix.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 71B98209CD9
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72771-lists,kvm=lfdr.de];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Please don't send patches in-reply to the previous version(s), it tends to mess
up b4.

On Mon, Mar 02, 2026, Thanos Makatos wrote:
> This patch is a slightly different take on the ioregionfd mechanism
> previously described here:
> https://lore.kernel.org/all/88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com/
> 
> The goal of this new mechanism is to speed up doorbell writes on NVMe
> controllers emulated outside of the VMM. Currently, a doorbell write to
> an NVMe SQ tail doorbell requires returning from ioctl(KVM_RUN) and the
> VMM communicating the event, along with the doorbell value, to the NVMe
> controller emulation task.  With the shadow ioeventfd, the NVMe
> emulation task is directly notified of the doorbell write and can find
> the doorbell value in a known location, without the interference of the
> VMM.

Please add a KVM selftest to verify this works, and to verify that KVM rejects
bad configurations.

> Signed-off-by: Thanos Makatos <thanos.makatos@nutanix.com>
> ---
>  include/uapi/linux/kvm.h       | 11 ++++++++++-
>  tools/include/uapi/linux/kvm.h |  2 ++
>  virt/kvm/eventfd.c             | 32 ++++++++++++++++++++++++++++++--
>  3 files changed, 42 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 65500f5db379..f3ff559de60d 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -639,6 +639,7 @@ enum {
>  	kvm_ioeventfd_flag_nr_deassign,
>  	kvm_ioeventfd_flag_nr_virtio_ccw_notify,
>  	kvm_ioeventfd_flag_nr_fast_mmio,
> +	kvm_ioevetnfd_flag_nr_post_write,
>  	kvm_ioeventfd_flag_nr_max,
>  };
>  
> @@ -648,6 +649,12 @@ enum {
>  #define KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY \
>  	(1 << kvm_ioeventfd_flag_nr_virtio_ccw_notify)
>  
> +/*
> + * KVM does not provide any guarantees regarding read-after-write ordering for
> + * such updates.

Please document this (and more) in Documentation/virt/kvm/api.rst, not here.

> + */
> +#define KVM_IOEVENTFD_FLAG_POST_WRITE (1 << kvm_ioevetnfd_flag_nr_post_write)
> +
>  #define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 << kvm_ioeventfd_flag_nr_max) - 1)
>  
>  struct kvm_ioeventfd {
> @@ -656,8 +663,10 @@ struct kvm_ioeventfd {
>  	__u32 len;         /* 1, 2, 4, or 8 bytes; or 0 to ignore length */
>  	__s32 fd;
>  	__u32 flags;
> -	__u8  pad[36];
> +	void __user *post_addr; /* address to write to if POST_WRITE is set */
> +	__u8  pad[24];
>  };
> +_Static_assert(sizeof(struct kvm_ioeventfd) == 1 << 6, "bad size");
>  
>  #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
>  #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
> index dddb781b0507..1fb481c90b57 100644
> --- a/tools/include/uapi/linux/kvm.h
> +++ b/tools/include/uapi/linux/kvm.h

Don't bother updating tools, the copy of uapi headers in tools is maintained by
the perf folks (perf-the-tool needs all of the headers, nothing else does).

> @@ -629,6 +629,7 @@ enum {
>  	kvm_ioeventfd_flag_nr_deassign,
>  	kvm_ioeventfd_flag_nr_virtio_ccw_notify,
>  	kvm_ioeventfd_flag_nr_fast_mmio,
> +	kvm_ioevetnfd_flag_nr_commit_write,

Then you won't have amusing mistakes like this :-)

>  	kvm_ioeventfd_flag_nr_max,
>  };
>  
> @@ -637,6 +638,7 @@ enum {
>  #define KVM_IOEVENTFD_FLAG_DEASSIGN  (1 << kvm_ioeventfd_flag_nr_deassign)
>  #define KVM_IOEVENTFD_FLAG_VIRTIO_CCW_NOTIFY \
>  	(1 << kvm_ioeventfd_flag_nr_virtio_ccw_notify)
> +#define KVM_IOEVENTFD_FLAG_COMMIT_WRITE (1 << kvm_ioevetnfd_flag_nr_commit_write)
>  
>  #define KVM_IOEVENTFD_VALID_FLAG_MASK  ((1 << kvm_ioeventfd_flag_nr_max) - 1)
>  
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 0e8b8a2c5b79..019cf3606aef 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -741,6 +741,7 @@ struct _ioeventfd {
>  	struct kvm_io_device dev;
>  	u8                   bus_idx;
>  	bool                 wildcard;
> +	void         __user *post_addr;
>  };
>  
>  static inline struct _ioeventfd *
> @@ -812,6 +813,9 @@ ioeventfd_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
>  	if (!ioeventfd_in_range(p, addr, len, val))
>  		return -EOPNOTSUPP;
>  
> +	if (p->post_addr && len > 0 && __copy_to_user(p->post_addr, val, len))
> +		return -EFAULT;
> +
>  	eventfd_signal(p->eventfd);
>  	return 0;
>  }
> @@ -879,6 +883,27 @@ static int kvm_assign_ioeventfd_idx(struct kvm *kvm,
>  		goto fail;
>  	}
>  
> +	if (args->flags & KVM_IOEVENTFD_FLAG_POST_WRITE) {
> +		/*
> +		 * Although a NULL pointer it technically valid for userspace, it's
> +		 * unlikely that any use case actually cares.

This is fine for a changelog, but for a code comment, simply state that KVM's ABI
is that NULL is disallowed.

> +		 */
> +		if (!args->len || !args->post_addr ||
> +			args->post_addr != untagged_addr(args->post_addr) ||
> +			!access_ok((void __user *)(unsigned long)args->post_addr, args->len)) {

Align indentation.  And use u64_to_user_ptr().

> +			ret = -EINVAL;
> +			goto free_fail;

This is rather silly.  Put the checks before allocating.  Then the post-alloc
code can simply be:

	if (args->flags & KVM_IOEVENTFD_FLAG_POST_WRITE)
		p->post_addr = args->post_addr; 

I.e. your burning more code to try and save code.  E.g.

	if ((args->flags & KVM_IOEVENTFD_FLAG_POST_WRITE) &&
	    (!args->len || !args->post_addr ||
	     args->post_addr != untagged_addr(args->post_addr) ||
	     !access_ok(u64_to_user_ptr(args->post_addr), args->len)))
		return -EINVAL;

	p = kzalloc(sizeof(*p), GFP_KERNEL_ACCOUNT);
	if (!p) {
		ret = -ENOMEM;
		goto fail;
	}

	INIT_LIST_HEAD(&p->list);
	p->addr    = args->addr;
	p->bus_idx = bus_idx;
	p->length  = args->len;
	p->eventfd = eventfd;

	/* The datamatch feature is optional, otherwise this is a wildcard */
	if (args->flags & KVM_IOEVENTFD_FLAG_DATAMATCH)
		p->datamatch = args->datamatch;
	else
		p->wildcard = true;

	if (args->flags & KVM_IOEVENTFD_FLAG_POST_WRITE)
		p->post_addr = args->post_addr;


> +		}
> +		p->post_addr = args->post_addr;
> +	} else if (!args->post_addr) {

This isn't a valid check.  KVM didn't/doesn't require args->pad to be zero, so
it would be entirely legal for existing userspace to pass in a non-zero value and
expect success.   If this added truly meaningful value, then maybe it would be
worth risking breakage, but in this case trying to help userspace is more likely
to do harm than good.

> +		/*
> +		 * Ensure that post_addr isn't set without POST_WRITE to avoid accidental

Wrap at 80 since the comment carries over to a new line anyways.  But as above,
it's moot.

