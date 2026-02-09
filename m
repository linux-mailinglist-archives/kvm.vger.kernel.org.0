Return-Path: <kvm+bounces-70567-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gO0VCc1XiWlQ7AQAu9opvQ
	(envelope-from <kvm+bounces-70567-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 04:43:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 98C9210B711
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 04:43:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 801F83015CB3
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 03:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2AEE2E9730;
	Mon,  9 Feb 2026 03:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LOBLeVuv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDFF221F15
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 03:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770608467; cv=pass; b=JNoNdrMer51cliHF/uJsy7VAMIEn6JiH0fiZ9tGsWZWr4aKQZT6dVMuRVsxxUY9SmgJ7euuR062rmHK66RoMMM8RSWNYCqUjegNGwcVXo99X3KGIzxqWy5KNf+wCG10LIKh6t6H6t+FQHGic4YRAShvdjuiPtpIr3IGDeMvh+GI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770608467; c=relaxed/simple;
	bh=WOJw0G+qRpBwZJldS41mQ53SZTV2egFH7Gvg/t3InPw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NATBhf6KdkffTbtKzVAoQY+RW0gLCGSrD8l0UcVUHIvBU2sCh0RFK+LppcLDTtF+zjBIqLVkn4/IawLOcUZ3xQges8hHcPioPYTH1fW30+9drD38d/0PqUCQqy+AS8SE2QvyzrWjidcjWLFJYvW+ZZyS9B55+XzL1a6o2Fd0RMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LOBLeVuv; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-649e97f1e1eso3056725d50.1
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 19:41:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770608466; cv=none;
        d=google.com; s=arc-20240605;
        b=MeHAMVX5srz4+sI0EE39wY+0Jag9vrBKkbdEj4H4XhKkbvp4Ul3xf3YKkm9KK3YyLY
         zptg4ZGgLQcmGxTlhvRHW2J3ZBvcLBtKhQQ7XY5ByWR3B+hyzr/qGJ63wrbPxlD1Jlmh
         Nm5JUK7w56HAUYeXv8dNS9saM7cEJ6Xax0exPUEDNqc4zDrAC5ldNgc6kN9jspSd7DhT
         /B708P1bcgu1zp4N3BBzKbGsZLZIdwMdKeeOKw9qDhQrOi38eqBXqiTogqVhaRgSzAje
         y5TsjqIAHUKlXpnXaAjDluSUpc8hhzgPWDsnZrHGQiNL5VFp8lTNM6i3Mmvg0ETfRcMT
         4nPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CqyPAneIm+akcX8sbXa7eHDwbxd8U8Ve4D5l0z44iD8=;
        fh=PPP8CDLLNnL4RQiOxKHqyUQ96k4cUlrYhMqk+Hrw+dc=;
        b=Inlh/0IK0xPevVq3AH2WUr4Q12s2JND8g0c7Nz62V43vzOS92rD08qfDxUJLiEiXb1
         KyczjnhcZIcytrBVA1/XrGm0sXb/03qtaktXBy5UND+ckQqvGeY49aE4X/MwvjpTOuxP
         S9o7W60h7ZzozMDwrocpQp8oZGgwIgJmL3Bg2+zycJyIPLwhsNtKGtqPdX2y1vow+QIq
         1TQxMtF1mKJslOWJR8jsxq182fDP+gMzt3vOEisiUMDdjwbQAyarO4kdEjTZvAlr1IMG
         R0M0ioK9gHAC9G8fhlW/xF8cEsqpyNsIaT+fnylzmchPcUvtixB3evPiyVodoiRV57rZ
         1CKw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770608466; x=1771213266; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CqyPAneIm+akcX8sbXa7eHDwbxd8U8Ve4D5l0z44iD8=;
        b=LOBLeVuvJ/ERs2Pk7aD7RB9hVHMycCmj5YZ0OKFVEPZgRVCpHimdqnksN21r2jqQfK
         NzjrbcGgdBsnPNYBAA2pTbsrUgb2F5qyMSprqfuxZQB3EpuUNKCP+YMi0oUoGvLd7RVs
         JSqHvtlNYLteIB/VmHDfLDgHN2JDlCS5k3B4uCUypwY3b6pFZGBRbGPWdJ+ASjbnfjgt
         RR1tbv+jubLqs9AbhjP5tVHDo8Kf+T/WsYCFFbN85eFs0vFdVCO5Z6hBLCqSEJrEXtfA
         q0kGoRKA9vymlCqKHg8aOkkejDB9iqB8uWEOH1Gdy2zZEvzHkR/skGfRaZDqqX0fJvsQ
         PdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770608466; x=1771213266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CqyPAneIm+akcX8sbXa7eHDwbxd8U8Ve4D5l0z44iD8=;
        b=cVV7Uyyq7ChfW1sY828g5QmBKYK0C6I67fknIiuADh9CO4AKQIo4p0hG5U0J1Lr+1n
         lz90L8hlbr7hk6C7lYNK9lfuCho0bzqfJl2OgBvTKc8zNb4UAZ8kXAWNDz86nuVzrHYZ
         mIXxu1x0ICJPBPfSeXQffA1JXFUuOsalGhXMY1Riiyxlv8q9pYeIbdfa20yHOjXTmiTn
         p5oxbi3oBtKjdMyusuvxZHV6cVHRAuYbHbt5XRazAWSktqqtggqb1l5pgmta+devbjYt
         mm/kcEZ61b+3xSVTvoC+I4Z6pBeq7u4gnivtotaK2guuJyu/SrT/LZt0vC4vCXM2Tpvq
         O3kw==
X-Forwarded-Encrypted: i=1; AJvYcCUe3NHqaFGt8mV7IB+f75dAisHbX2BvdjXh5pwSS/BM0ievwApIFKeRhVbEfHdjXRRkdcc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxpt6lVEBbQ7iJ7gZmdOMcGnctWc8x72HN9QS7Dzn5DYzFoSHbn
	H2jHmnOQcroUlOfA61SPV9TyHr7hTgIt3pcK8HUYX9yjExV4Ix8AX6EDfGTEuBnkpNSuy0isK6O
	pLWzmrn6/Cf5HMFoQS8LjFVH1QCp/Q6A=
X-Gm-Gg: AZuq6aJ+gyYOqpwCeZfkk5PoNTG1se7qop0WyfK7BWC0M5nWCmbVvH/a5GTuJRo5cVw
	I4ASnR14Q/yfGA93nmWz3bKSGMZvFH8s/3vgx3uxlcAvkZEiPO0n6DTEvNZGfpeuPhmD4Mc979U
	cHDsmfvsqmTMEYdx6crQa4xl185Ho7D/4eARauW7OKDgH5RPiiwI/+6Ny0ItbYBIYl3o2yyt1kv
	V4EtXB+s51uy2IHzyn4zW8BV2idEOB/7uW3pAMbjkB8g2hFrCLV03X8i8CWD88X1CmhGwerbhJh
	EKohuRwOs6E0mWTw6BvrcdGFq7eMRyW1D/TB+93b6qO8PepGwwqbXhFW2rk=
X-Received: by 2002:a05:690e:13cb:b0:64a:d67a:11d2 with SMTP id
 956f58d0204a3-64ad67a1c54mr5238690d50.29.1770608465815; Sun, 08 Feb 2026
 19:41:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <697d115a.050a0220.1d61ec.0004.GAE@google.com> <20260204170144.2904483-1-ackerleytng@google.com>
 <CAEvNRgF75EsHL8idLzFzbk0K9uhE70AMj5Vitp4cKNg_5WqQKw@mail.gmail.com>
 <aYO8DLCWw8FEQUAU@google.com> <16e5a36e-fff0-4a54-9c5c-a8e411659108@kernel.org>
 <CAEvNRgHX7MPSBX7pMeSWEtzc0-bJhAZ=pv+WF0VtOv9Tx0Jpxw@mail.gmail.com> <CAEvNRgEO3gB6Oee2C-+8Pu=+3KY0C98yrmesKO2SMVSvs3anfA@mail.gmail.com>
In-Reply-To: <CAEvNRgEO3gB6Oee2C-+8Pu=+3KY0C98yrmesKO2SMVSvs3anfA@mail.gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 9 Feb 2026 09:10:54 +0530
X-Gm-Features: AZwV_Qgy2x3SCU8kYSOqAIPYNv9g2F4CQcqk3DtGTGP2-WnFyRPflaqwyr9IV5I
Message-ID: <CADhLXY6-LwV+O9557w+J6N0yWcGm9PQGoZUyj5BZ+LPPDC+DDg@mail.gmail.com>
Subject: Re: [PATCH] KVM: guest_memfd: Disable VMA merging with VM_DONTEXPAND
To: Ackerley Tng <ackerleytng@google.com>
Cc: "David Hildenbrand (arm)" <david@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com, michael.roth@amd.com, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70567-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-0.969];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kartikey406@gmail.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[kvm,33a04338019ac7e43a44];
	RCPT_COUNT_SEVEN(0.00)[10];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 98C9210B711
X-Rspamd-Action: no action

On Sun, Feb 8, 2026 at 11:04=E2=80=AFPM Ackerley Tng <ackerleytng@google.co=
m> wrote:
>

> Since this also affects secretmem, I think thp_vma_allowable_order() is
> the best place to intercept the collapsing flow for both secretmem and
> guest_memfd.
>
> Let me know if you have any ideas!
>

Hi David, Ackerley,

I have been looking into this bug and I think the root cause is in
file_thp_enabled(). When CONFIG_READ_ONLY_THP_FOR_FS is enabled,
guest_memfd and secretmem inodes pass the S_ISREG() and
!inode_is_open_for_write() checks, so file_thp_enabled() incorrectly
returns true. This allows khugepaged and MADV_COLLAPSE to create large
folios in the page cache.

I sent a patch that fixes this at the source by explicitly rejecting
GUEST_MEMFD_MAGIC and SECRETMEM_MAGIC in file_thp_enabled():

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21..4f57c78b57dd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -93,6 +93,9 @@ static inline bool file_thp_enabled(struct
vm_area_struct *vma)
  return false;

  inode =3D file_inode(vma->vm_file);
+ if (inode->i_sb->s_magic =3D=3D GUEST_MEMFD_MAGIC ||
+     inode->i_sb->s_magic =3D=3D SECRETMEM_MAGIC)
+ return false;

  return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }

I have tested this and confirmed the warning no longer triggers. This
approach covers both guest_memfd and secretmem in one place without
needing separate VMA flag changes in each subsystem. I have sent the
patch.

Please have a look and let me know your thoughts.

Thanks,
Deepanshu

