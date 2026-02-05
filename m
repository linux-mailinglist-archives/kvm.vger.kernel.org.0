Return-Path: <kvm+bounces-70294-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8GN6DjkbhGmyywMAu9opvQ
	(envelope-from <kvm+bounces-70294-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 05:23:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CCE10EE834
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 05:23:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2324A3023362
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 04:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9E692E92BA;
	Thu,  5 Feb 2026 04:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xe4cfo8O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9482E888C
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 04:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770265348; cv=pass; b=QSsAGpCnbJNu8jJB4RNUpRAHvExQBcPMs+fBtOKZcoCGwpdiSnDGHtt6DZAECCGvbfohVqrvq7RWNYFJIA+rn3lvQKpVbwgaEiTLw7db5BcfeslFkMfceoaiXH901Lv31kz04rW0RGYp1q823vabwPkIofRwJCd3wsakOiKoEV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770265348; c=relaxed/simple;
	bh=r2SS9/43EaA37y20B8C3LEdeG5IJ9XVHGw8qah7vts0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aybS8W/Xrg2Ai3TARisRq3VyMAST/RMqFwP9DKO9c72slc0wDy7+LJ/nPyoBC0WleTlAhmRY5mZlHTQ7RtcjZ1wELBcB/y8MSjO6WORI2gn12Nmlcj13UW+0AjzW9/+gBkmhp18rvHgNKljud6EMP6w56KJefahtcII62L3bXCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xe4cfo8O; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso3700a12.1
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 20:22:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770265346; cv=none;
        d=google.com; s=arc-20240605;
        b=A1HKRV6rkPMIPqEKdK3TIWM7Uldp7Cw2X2T/kKsuZeoey2DtmabKnLjlltH/y4gXNf
         4+hKoAjKyJi43oxiEsuYR9ome9FGW4Oi7Q5gDw2lUqMr06ruJbLaz3jVX4hj4dU5iWWR
         lNDNdstm3EHCCkmuF9qpF0x0Bdk9l7NB4w1K1bNtWXvcMHO8kqFIwVkxpo0pBkKUFsb4
         tZpf+g4nOXITWMlxbWDqjUYP6XWVqV1l/GczmMmLcZiuQe7krqY4eGKY3EKB9y46vWBF
         pFXxjVaj+V9KExSDpGS6O+a0eGdKw8ye/GU2FC2SAKxSvJraZXQ1IF0MP1ugpgpkfbvJ
         QZFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MG4FrxVbRbdBBHe5zYjnGOxR6NhE3COr+6i/7ZUC0pY=;
        fh=Hp7ECmf+fB4X5v41XuqyzRLKhdO1GNDSYfEMQnh/3o8=;
        b=kIKdvNLjN1t3sxxrC2YSaONbBbMg0xsPyrpKVFQ1KeqnIOuYIMXR6K0eyLgyqbKFV6
         TBhOrbatyB/mqpluKojEtoFIRp1e++xnjoyc6+3++pYh1nKKAaxpRhz+s/BQm0dEot9d
         UwhzzajnBRlh5p8LLiPJL1IgooYFwWHpQIBa8FElPtey3EaHp+nlJjWbo2Afhye7ns17
         RQb9+gG9KQu5OUiTWk7cVbfgZBwckSjRpogQvYJykTGak/oqTvuuuFefVzvjvLbzYCDz
         3YLb0YbUjDvVIDUhQF15alZBThnY/1swDWrnxU95t/xxmfjvCm6dgV6Xisbsrs1mYG3f
         5bYw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770265346; x=1770870146; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MG4FrxVbRbdBBHe5zYjnGOxR6NhE3COr+6i/7ZUC0pY=;
        b=Xe4cfo8OJBSROKAbFAhW2W1biNK569wBIgCIXkcFUKMIAPMc769wQ2dML6CwWC6XWm
         zGzY63q9znhkwzZWlxz/DVSn/sZJna+N3qwtxCXhrOZE9/D0PLQPZ8GKyU1AoNdBx6c4
         erRnuV9vxtqxOc+3lFGt2Qmff8/NKPC++pLMmJtJWZoakeuLITRrqU8pkiFUNy5jBJOQ
         wlgf+rDLjkQdF2kHCiuATvI3q3y9gLHOp7FLg2e7N+pCuBbiEwEuUPZx5DwyVR/DZr7T
         txPaUQiuND8C74qoXE6QsELsMtEE+U96FakO42IubWVjSnQ8El152DXOvjltLWIpVw+X
         1i3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770265346; x=1770870146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MG4FrxVbRbdBBHe5zYjnGOxR6NhE3COr+6i/7ZUC0pY=;
        b=XTrvxqz8E1RV7tN/5s1WRkJzHg1RPQh22k2oo8mHtZqfABh2om3tXBBA6tWQdY4OGV
         3pOM3pNScp9EkXiGWIyrdrnLpYXAIUUtRnV6nbEpfYf8DSc/qNVa51jAApWoxSak7RGZ
         etM1jCcCyiHow5J7u1uDw4/ONOJaai/RVE5yuK7jNBsc6mFOQ31UOtcAdZstFVK/9szm
         QosOebtPUTbLPPypYyyLodaq05aEFmvML2Hg7bM/ZcJmj/hKMLIxi87u2BDaDr7/idLc
         CB6d3OP9uxxWzdaJ2prYM8VxPeFE1OmlkJADtkyVbcJGoJscZ6Q1avK9xqlh5YKkaBuu
         9ImQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPS3u2r6nWRQ1Biyxa9NDBteIqSv60G8jykJE5jRcG1W5KIs5UXAaX4kelJEP9CLvmS98=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKSHyhK51zzYgstsrr3zpnyNr3/a/6bNZQdXTDcJsxWtc9NKdN
	VpoQDiQCSCXH3YLFET35Bke3TZU3gw/+ZsgcbvaRCLQw3VzSVbv+ePX38tyU4hr5EPkC24nJT8C
	+pd8JWDrkqddvcI21W0H3JVAOHiyhFJvpWpBCEA2k
X-Gm-Gg: AZuq6aJNroCUoF8tA31UDDICISqXiiiqJBXUSW4Dw6JdoKMLaAzt7CPQMdNIc/9rS8r
	Am/g4mc1vG1PuucdLiILSgvsY8o2hO+fQSR9eGHXPMDq7ITNIQi2dKkCHrr4iO/TQkDFwhDc9WQ
	SGDpGYUiUZ6eh03c5mOzHWjb0/+TetDWctFsn21rYrP77kZOKNev4qhevlcsYLhptUXus1zBESd
	+Qa15SdOwzzic2wbX4Yg+ehCbH2kFIqJykpYLiaSq632i4Nxz1wYUVT1B7WlH5nD2ehAUAPjCTs
	ld4h8A==
X-Received: by 2002:aa7:dad9:0:b0:659:43eb:efe with SMTP id
 4fb4d7f45d1cf-6596306dfa1mr22989a12.0.1770265345711; Wed, 04 Feb 2026
 20:22:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203190711.458413-1-seanjc@google.com> <20260203190711.458413-3-seanjc@google.com>
In-Reply-To: <20260203190711.458413-3-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 4 Feb 2026 20:22:13 -0800
X-Gm-Features: AZwV_QgIln0YDUY_WDMACnggfAdhUKWgcOBdiWCoV__Q-ax5W-P7IxoHQUNLjKQ
Message-ID: <CALMp9eSNwHdHXWdMYUeS8t4x-kiOSr8E_h5uPONGGh130AP_PQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Set/clear CR8 write interception when AVIC
 is (de)activated
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Naveen N Rao <naveen@kernel.org>, "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70294-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: CCE10EE834
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 11:07=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Explicitly set/clear CR8 write interception when AVIC is (de)activated to
> fix a bug where KVM leaves the interception enabled after AVIC is
> activated.  E.g. if KVM emulates INIT=3D>WFS while AVIC is deactivated, C=
R8
> will remain intercepted in perpetuity.
>
> On its own, the dangling CR8 intercept is "just" a performance issue, but
> combined with the TPR sync bug fixed by commit d02e48830e3f ("KVM: SVM:
> Sync TPR from LAPIC into VMCB::V_TPR even if AVIC is active"), the dangin=
g
> intercept is fatal to Windows guests as the TPR seen by hardware gets
> wildly out of sync with reality.
>
> Note, VMX isn't affected by the bug as TPR_THRESHOLD is explicitly ignore=
d
> when Virtual Interrupt Delivery is enabled, i.e. when APICv is active in
> KVM's world.  I.e. there's no need to trigger update_cr8_intercept(), thi=
s
> is firmly an SVM implementation flaw/detail.
>
> WARN if KVM gets a CR8 write #VMEXIT while AVIC is active, as KVM should
> never enter the guest with AVIC enabled and CR8 writes intercepted.
>
> Fixes: 3bbf3565f48c ("svm: Do not intercept CR8 when enable AVIC")
> Cc: stable@vger.kernel.org
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Naveen N Rao (AMD) <naveen@kernel.org>
> Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

