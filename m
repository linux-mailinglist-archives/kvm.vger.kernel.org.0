Return-Path: <kvm+bounces-71441-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iHL/AN0JmWn1PAMAu9opvQ
	(envelope-from <kvm+bounces-71441-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 02:26:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 82E9716BBEE
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 02:26:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C2500301C954
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A79B31B110;
	Sat, 21 Feb 2026 01:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="20v8q1GN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB3B6FC3
	for <kvm@vger.kernel.org>; Sat, 21 Feb 2026 01:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771637207; cv=pass; b=peLqb+aL68hQTn5mxij+en4dvg0LaoJHEOpo/GRXWzaSkdfL3xajN8556NflMOyXazX6TjGWYgIaxRgw+Zjkr0D7Y7v9mUiTxpEQawX7t0Kvb3tNToj4ORajXHxe134p6OPbZi7rfeOeebwzn3+uiR7z6SNSfTWvzsG00XPjhiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771637207; c=relaxed/simple;
	bh=5STbB+9jrAm7GRwtsFuE1bDTJIqaJAx3LQZhxa6dUXI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E0Ky6lMIRuq7TmwZrSNgq/bnMsVIyn4AOgmVu+oflNtUzE5Ke7T7PGLRtpiWWJxD59dNjl6UzzTi+8fVvYWD6RVJDMUL7NIeVYUkKVFtyXuHYj9fHnjmE/LghzmdjthMh1lU9JnGT1elqDICtRaHbhdAsv68GeDqB/AXua4dy1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=20v8q1GN; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65a38c42037so4133a12.0
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 17:26:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771637205; cv=none;
        d=google.com; s=arc-20240605;
        b=C3anBIXuUoi8JJ2puBVHH9VtcBc4XjF4ZTCt4q+j5J2lWb2CoOIUysKUz834ua1c7P
         NZqe/if1TcySYTKHa6oT2L8aYSWBYEjbhfBDA7u3wt2+0He+GnO7w6Fs3fexG3uAWch/
         QdSSiLAfd5WZvcwZX3piZsuYsrdYjDGf2n+2D2OKjqOgsDW86KB+vvCBDzgt3PfsjCcT
         bIHplslsGE4cDh74d4JQ57aIfGqyPNCnizwWNNRmf9PY4JDJ7U8YZ4+uOFtrSQPUFCqN
         QHnbTJC9QpO8aj1hQ8+CZi2+JL5njcSiTEmcpXTXZ601p1PqzCVLuCw5NjzlHFrK1xP1
         KEIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=poadtCsOT3quegj+rs/rmY8m195Yu4/fVK7Jcv5Z5jM=;
        fh=tWQpzA0wWOmbiUGHvbRDKBNluYsE8oVoD2BRr5F3IGo=;
        b=kCZYK5K1BBRr3v/bNQQ9jxuLH+FzH9b216Wpn6731Kdri3yT/EbY9OCHRDpFmIrcPd
         7/TikHUCwVX8G0xMQfXtkQS5BWnA8jgQZoVfJoIVIwAUqjmKFBilSnFpWvWAnRquNeC8
         7jvTR9RIlQe5IrpZkVX5dSgHYwwyx84/9oObcOxJxgN6JcrIWOIRQLhfgzKm/UAUH/D8
         1rvFMkakjLdc+B0UnXVyPHCFtAsS3VtNBL7KtrSpAPmDYMPaX7CRohN7CnrGwD7gHLXW
         CreQ003vNyXm36hAoi146CRd826LPqITU92RPgg9HqBgmyqaose0i+2vtEQwOEKGMKRs
         z0cw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771637205; x=1772242005; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=poadtCsOT3quegj+rs/rmY8m195Yu4/fVK7Jcv5Z5jM=;
        b=20v8q1GNtMCslXkTZHSAYjbd9CXxaGSF53TxH3b1hlxFv2UUBK1TPBPh5nJMv7rL2N
         ajpqIP98IM5AtBWmmx3/jpT3oXAVSI3cF/UjVYgy7SszdakWGkgd4DX8zmy6QC6JqM4G
         ySaDKJfZ89cO8IzX0CTZPMYusaJ7cI3wGfcePvy9dswNkCr81NueTZlabAEmMPCYcIxW
         NYiJDkGtG645JWG+XkRJnRYe7v6HD4n0aa+fYn5Ct7hGPqQvDkk5Sy7NEHz1/Erdputi
         Mq7wnZ1UqPJzP/bQMSirBFqzQdr48o59Lhi9okIXFNCJKiPDemsePzjTUHxQIn1CiLth
         oPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771637205; x=1772242005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=poadtCsOT3quegj+rs/rmY8m195Yu4/fVK7Jcv5Z5jM=;
        b=EWp2jqbQ+H9H50Q77WS7LALWMwAi5LGg77RQmRo4OT185TeHU9+58NKoSjPxz1n1iW
         RI2bpWIS/FdoBaKqnR0QLQh97EcRcqJim0TXdk1/UF5IfIsHFK+Tpkvf9ojzNYF9ezd8
         VHMmzeOOgm8+3k81zwt5sBO8AtsmdSn1bnwLPfrZ0m7L7bzNV0y2eFzsteyI1Tter66T
         O1O1/KycMwRCfrgVYfEowtM5wl7zs9GNRKcHfX7n2FCW02DXRbD5u/WiW1O48taRLAwV
         T2J01ly3Yjr+jYfImm16eMf9zem7vA/qyPRaiQLjanUm6leXwW8XnFTOmtGaHttTFzjc
         lKUA==
X-Forwarded-Encrypted: i=1; AJvYcCVK1F2yvVW9vL+WNsTTqlBAmu3JGadBNaaGTmnxZZFSc+DPfgArW3Rus+Hm6X4VBGvXdgU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRz4f3B4CealJUgX4HxfKerQHEa0dWx4CxbOqYTt/VcMFqIr1/
	b4M2dYET7DGI0n1+ufy3dgiGaYz7z+UQUzrLcAwSM9zx0dbAjsbzVxYrqaXbJ/oootqwUsOl0Kw
	zA6ENF5mXy8THJr2OkApB47JthCwEwYdNaN1/XTlG
X-Gm-Gg: AZuq6aLqKDmF1o6302tuuk5OJjJnxmOggwXsvnQsCdBKjahO0ziVECPvHMIAmBL3Bpr
	Hv6OIVCoWlZZTjQIXTojehxolTrASehsKEPtftib83vgcwEOTUnZtjtEvRZPe8q2zkFw9vEr9mj
	Qq6dlBBoL7gMrVmKe1YRzVDOP2/JakTA3p/Wj0kaMh4+aEo/ktcjB3yQZISdy4JBDrKDk5sAPds
	1qMD4GatWPZQVUABTP907XmJwHqtIwC8+K6DecMK+LcpITiwudmCqej96u0vg3mBsHHHE0MMqA4
	JwuxwOw=
X-Received: by 2002:aa7:d716:0:b0:658:102c:861c with SMTP id
 4fb4d7f45d1cf-65eb00f4318mr7913a12.15.1771637204581; Fri, 20 Feb 2026
 17:26:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206190851.860662-1-yosry.ahmed@linux.dev>
 <20260206190851.860662-10-yosry.ahmed@linux.dev> <aZkGlFwWeRx0ZGCV@google.com>
In-Reply-To: <aZkGlFwWeRx0ZGCV@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 20 Feb 2026 17:26:32 -0800
X-Gm-Features: AaiRm51XnQyqvDWVVss-ng4gy79dOi3ckmiTALNB8rBtcS3UhZ8J-F4t8-ZqhBU
Message-ID: <CALMp9eRRiwou+Ug99mjoy9JwQ9ND6Mrgv-jsBaWsL=r+CxhfWw@mail.gmail.com>
Subject: Re: [PATCH v5 09/26] KVM: nSVM: Call enter_guest_mode() before
 switching to VMCB02
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71441-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 82E9716BBEE
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 5:13=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> LOL, guess what!  Today end's in 'y', which means there's a nSVM bug!  It=
's a
> super minor one though, especially in the broader context, I just happene=
d to
> see it when looking at this patch.
>
> As per 3f6821aa147b ("KVM: x86: Forcibly leave nested if RSM to L2 hits s=
hutdown"),
> shutdown on RSM is suppose to hit L1, not L2.  But if enter_svm_guest_mod=
e() fails,
> svm_leave_smm() bails without leaving guest code.  Syzkaller probably has=
n't found
> the bug because nested_run_pending doesn't get set, but it's still techni=
cally
> wrong.

Whoever came up with CONFIG_KVM_SMM was an absolute genius!

