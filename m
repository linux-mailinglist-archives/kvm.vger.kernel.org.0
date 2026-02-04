Return-Path: <kvm+bounces-70268-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EGoOIr6Zg2lnpwMAu9opvQ
	(envelope-from <kvm+bounces-70268-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 20:10:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F17A6EBF16
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 20:10:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6EC6F3012C81
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 19:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C9442849D;
	Wed,  4 Feb 2026 19:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u8Y0xbg6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E96431A551
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 19:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770232250; cv=pass; b=GMG/V/EqEEBV6R+CvXs6jJhLmt/zdW4TUZninKBMZnKp1S3OiMb4g8C9cESu/yM1M/1USOsN2/l73zYNhPoBR8wg8M10BfEBmPgmyEJ3Ov3S4f01aysCt97UU3tuwoaNxFi/B6tZqfcLs93Jq/kBsH6ibvvcn9gH2nfU4zNKKp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770232250; c=relaxed/simple;
	bh=lXWxYGyyhF9P6Wv7GmsgpSmu4ZHvbmD85h4KG4Mans8=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XQDV8NKyxjM7r9ehQwKS/QHiob5yTyvQUrz5excMbfXdSYprapApe0cP3oxvGX0CSE4Z07hyUnur5Mlwu8GBcJRuYWHeKhy6u1NlbK238Zw6NxmuhbSIqjLbWqh0dturJkNijMfOjaNNDNSGz+6UIRdYXYJ1e2GdOHTG/00VBn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u8Y0xbg6; arc=pass smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-948e7c39668so22619241.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 11:10:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770232249; cv=none;
        d=google.com; s=arc-20240605;
        b=GW5IE0GC9UM9pKHTE9Wn+ZiyIviIiRNssl7QaRFng120uaglx90/ORTY3GJQEtvn2U
         KbOmquA5QYBxMRu6pMRUsk1EdncNM73o6la/ZLoaeD3jrHca9t5rUtywdBJf/kk8nc7N
         OenIZOqRhZb3Q+5VonA1TSRq6AfPz/2yASbqaZ07+V0LSZsiwNpo9CPGUAYiWP1mnmaC
         CSiEwKvbugsLp0oe0VsQD95Mc/Q+nAPXR3XmVk5okGldzK0AJDwo3ORXgiBtKuUk66ub
         /7KNVQmSLWnLQz3GrvgGKttedQysVAL5MNbhdx8L4Yn3K+dDhK1o/Y0335KprBi2KNrz
         FIig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=XU+nHiW99yv3DcS5bVzWR/3CEep103RfiIzgG2VGh4A=;
        fh=fklkTIw7C4117hEW40Nn8beGOQoJr9w6jyLYKcRqgGc=;
        b=WiQMGGFtFwVvRksPmFN5oc/6UUSLYGUOluQEHiBUtgKWrlANedY9f4No+P8SzKoVIp
         2SZnIS9HMjanY/zetOG6srp/0xOQXw4P/rakBO8j9ACMFDhk4YU9NtI6k7SXQM3zduD5
         P35a+cnI7OYR0ZryptZTjccNbE7ZaW1dYRkF66mxgAFGkQlhToufQnWDLICBI3TCFAde
         nN17h/0IaHwQb85djeVUslJMJSXvwwg7/kF2F1HTskWTvsAq30ktmNFFfTLD8HNSWlea
         lUxap9/SYMLRjZ4wGkA1gJDwVcdJ03gMKDMtsNyjemLBR6tk+4N9QhHCE75X8uYfrXuV
         l5pA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770232249; x=1770837049; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=XU+nHiW99yv3DcS5bVzWR/3CEep103RfiIzgG2VGh4A=;
        b=u8Y0xbg6ebox+EepvO+ApfJxaCrpUbj84so8DloOT4OEeK455ynHufT6k4HWV5qZpL
         y1Zq7A8YHUluzjLMLWdlDZux/OxrziPjZGBXz5+LIfTBWMhef1Fn+S+M2BQKKka6Cro4
         F+vi7R2hQm2SRj8WQUhJE7jFMePIXWyGQnyx2VsuoA/examE0Y26oepIFGR5U+289PyK
         lUTygK9mJG5MkfGTsuQuIuegM0WiRbG4xvtQLDlc2IsBxzhymoQhpTg7cIxmaYMLnBvm
         9FxAHIA8QPOySieGua0ZyNfxNZie0wQHXNb3UNTXddeXvy4QYR/ok5Yw4nskSM+B/Cb+
         /Irg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770232249; x=1770837049;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XU+nHiW99yv3DcS5bVzWR/3CEep103RfiIzgG2VGh4A=;
        b=FogS/IBs867ecrsNQcTxYlCxfoR5r2L8NONgHuvicLHsmazJ2EQa0UQxKllyz/Qnbf
         Rkr7TPXZZpjGZbTLk8SoG7fFFGITorZOy5jmvBURVy/1sanX4/GAScWRH6zrMof4Fztt
         jsjWtJaUe6Y9nyVXdsgWBnqjeczs4GTDBdaQ7KYThbkvX2+5qWGHK+A5rAINC7BPqDK7
         O1dm/WuAidZVFZEzc9IfiFQzeZOtGeM1aKErqsYgXrHsFPcaBrGko/xmw7SqmlMBTlI6
         nmsB8DdxlsSF34KDI7Da9NG8pSO4Kfv0uVVKHQK9jBHIbdDKjPFxmpn5J9dGc3b9aWU3
         O78w==
X-Gm-Message-State: AOJu0YzYMwQ5hW8bpuRUe63P5pMtMitcsML+xfnXNA7kt+1X1EaIVys/
	v/61q1evuMf9yZrjIayAPBtpegvkIkB9bKiT2Z9pN9qwLNQW1QUiNjoeYLLRtwhvqEqL15xBUFN
	ZE2j5iHM92yqyGQe0JBbzeJdTvZ3Km1Dd50W5xwaw
X-Gm-Gg: AZuq6aKJGWlyLj1kTwDYzcM1ffFqIv7mv+XHSEFNpyf7fiUwGLC3qXLdTYWFmRdJJih
	87eWG2pxzVw1dQB2Ly2L4nG1oheyrweBR4DiFViFXcsMwk7faciP0yBD10RAYxam1tHSjMpJhlM
	15tkT9u0yKB/lOXIGb5FYQWLqS+T8r+WdMZQSpznzAfOlQ2YxNiKY5xSATS48HP652eC/x5Kmj1
	w+DtUZV+HKhCOpOQuYHwa5/GeGXC45sAlh8T6ghW7GgBWQEpyiqxcp+kp1yeUtoOG5d5/PZPBJe
	MSLRyxdliiwH7ObyoJ9o6GL3r5N8fXW/wFIE
X-Received: by 2002:a05:6102:610d:20b0:5f5:3719:19d8 with SMTP id
 ada2fe7eead31-5f9395e2783mr1099207137.31.1770232249053; Wed, 04 Feb 2026
 11:10:49 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Feb 2026 11:10:48 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Feb 2026 11:10:48 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260204170144.2904483-1-ackerleytng@google.com>
References: <697d115a.050a0220.1d61ec.0004.GAE@google.com> <20260204170144.2904483-1-ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 4 Feb 2026 11:10:48 -0800
X-Gm-Features: AZwV_QgcQx3vbfxBGP4uiM45fegTaR4Q23FMhVPxMByWK826Z6oIBpv2C8w_Ifs
Message-ID: <CAEvNRgF75EsHL8idLzFzbk0K9uhE70AMj5Vitp4cKNg_5WqQKw@mail.gmail.com>
Subject: Re: [PATCH] KVM: guest_memfd: Disable VMA merging with VM_DONTEXPAND
To: syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com, david@kernel.org, michael.roth@amd.com, 
	vannapurve@google.com, kartikey406@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70268-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[vger.kernel.org,redhat.com,googlegroups.com,kernel.org,amd.com,google.com,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm,33a04338019ac7e43a44];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: F17A6EBF16
X-Rspamd-Action: no action

Ackerley Tng <ackerleytng@google.com> writes:

> #syz test: git://git.kernel.org/pub/scm/virt/kvm/kvm.git next
>
> guest_memfd VMAs don't need to be merged, especially now, since guest_memfd
> only supports PAGE_SIZE folios.
>
> Set VM_DONTEXPAND on guest_memfd VMAs.
>

Local tests and syzbot agree that this fixes the issue identified. :)

I would like to look into madvise(MADV_COLLAPSE) and uprobes triggering
mapping/folio collapsing before submitting a full patch series.

David, Michael, Vishal, what do you think of the choice of setting
VM_DONTEXPAND to disable khugepaged?

+ For 4K guest_memfd, there's really nothing to expand
+ For THP and HugeTLB guest_memfd (future), we actually don't want
expansion of the VMAs.

IIUC setting VM_DONTEXPAND doesn't affect mremap() as long as the
remapping does not involve expansion.

> In addition, this disables khugepaged from operating on guest_memfd folios,
> which may result in unintended merging of guest_memfd folios.
>
> Change-Id: I5867edcb66b075b54b25260afd22a198aee76df1
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  virt/kvm/guest_memfd.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fdaea3422c30..3d4ac461c28b 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -480,6 +480,12 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
>  		return -EINVAL;
>  	}
>
> +	/*
> +	 * Disable VMA merging - guest_memfd VMAs should be
> +	 * static. This also stops khugepaged from operating on
> +	 * guest_memfd VMAs and folios.
> +	 */
> +	vm_flags_set(vma, VM_DONTEXPAND);
>  	vma->vm_ops = &kvm_gmem_vm_ops;
>
>  	return 0;
> --
> 2.53.0.rc2.204.g2597b5adb4-goog

