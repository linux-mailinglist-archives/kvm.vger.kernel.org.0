Return-Path: <kvm+bounces-73173-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4KNaDQdVq2k4cQEAu9opvQ
	(envelope-from <kvm+bounces-73173-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:28:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D2F1B228529
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:28:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9CB2330584AD
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 22:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1FD42BD597;
	Fri,  6 Mar 2026 22:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YHx5ma/f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3FA3542CA
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 22:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772836051; cv=pass; b=GLjunVQS6GeNgbaI+WDWhNLm8nQ8Nfo+FSTtGKUwNlyds+UqDFdSDTKr/GLVTCulhBbT40ytgO46bva7CS7bVs6OS5GZyF2THS647Z+xNzR2BpTuMJgkF8ngBTTFoGmoIK2J5BMLam8CmvdcqqRWdfTzJM5Gk12O0nswe/bg+28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772836051; c=relaxed/simple;
	bh=v1X46Rq9nhcIKp+i8OxVZU8Ib6yU/iDgMj9GI4rBANo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CQ+B1HTwmxTtFQQOY3Y61f1WCtV5uY5DYytaD0SHPTgEB5JTePVvbwLidiPnibPIhtMT6LlFYXKN+zJOble5oA7z8TJSd5gZLaTSSRebsmYQ1VWMFz/B9cP+TmBxRsN8WeRe2L1dmh6XHIBEf2/oHIthxq87HT7+dAG119EO2Kw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YHx5ma/f; arc=pass smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-661169cd6d8so1417a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 14:27:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772836049; cv=none;
        d=google.com; s=arc-20240605;
        b=KvnJJy4XCU2HA1/gcAlWv67a7gakE4yRHMdvGhlXENzvJ9N755jXjuOXV0epnlZYIg
         PfuKST6RsI4kGsZZtsprxHeuqNR2gnq0gHfNn7gP/PkzsabJK9Sgo4+dnFp5Vzd8fp7K
         x+hzSX/+mX6LXBVEkccnSyZwFGu/n8Sh2hJ3U1jzUu2Ahy7GhxqkX06FhlCVbRHSLLl3
         FuJG0rRroYl3Ec5TM7Rau8n2ybuqRLY1ZRbi3Z5sP5BoAZieFxbsaB0zuDnDBHGBuwzU
         Ht6dbEpe/KMkS367a3aEUFg4je6FtUbr3HD5rMJXG7REM0tSVby73bKZmHrkm0W/9EI0
         EyNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZvmN7eM5pRciaWgz971bBDVDb1Pv7J3WCBCE+IIXjbA=;
        fh=iId6gKMtzvITBO2hpzi5sDOKIM5REbznkrcW0LPMWN8=;
        b=chP6L25bR00ysw5bxt3Q/5xkU+kpBD2v1KjHEdl/xdwnjCkk5uglSNEBEtvi+hrHdM
         jboMnvwbghAgfTpwOXlHgsb90Ne5PbU5+y8yWW9XJrJ51cxzk2g0YCTBEdSWUJs4KQqc
         Vr42BU+lBdou9NDKaUYkpGFq6G4thSO4smmrvaD5JkcyHiNV3fwn2ASgmg8rzEaenw5f
         CXlgCUt6yCr8U67ezx9BhZRfeG+uXG11/owaLBXLqIpvzCV2Jkk1Bod61ovEDuXdZCRt
         gXknyC2eOwilMkVz1lq69az/tUtil61ojMbU6MiT9MZNF9Z3EnnHFsu10jAhM4OF/6yN
         omIQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772836049; x=1773440849; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZvmN7eM5pRciaWgz971bBDVDb1Pv7J3WCBCE+IIXjbA=;
        b=YHx5ma/fcCXE2ieEZJwAgJSx3ibuceRsVjRefkYeFENWAa/pDhwW4KSIJFUleCrjXd
         09mo/vICDeG28JvgO5bEvV7aaBdSLJxQEr3aLBAJ4Qz3DU4OBm6C2CumStrqcnLazMNY
         jE+YPIaebMwrdbvnOyYn7CJ/Px3c0rtS+scTqNceykzPZnZaX8MY98i/1fr7qPOXM0fJ
         ZNPjchZsno5T+Uz4pvXAOekZv5oA2+U2G0/bFrJ9OY3SdmStE+pPCVdfv5mluL3+vweY
         Gqh0u6WxquWiHIVxfwgd/l6doJLgoMRXeMdpiAX1J1lsIethJzaKNIyBzobC3HEPoXCN
         9Zuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772836049; x=1773440849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZvmN7eM5pRciaWgz971bBDVDb1Pv7J3WCBCE+IIXjbA=;
        b=qmjwcasux3fLUgCRs1rKdc86+pm66C06Xn/pzc4LjWe93WRhQm5PgmPgUE79qitwtI
         d9HjtuHxkPDM++uT1KRnqb9CEhb6Wf/is21AjkNp7sW7FEv1wRf9LAojDoF64iCBv5zP
         /+P36HcdHNB1ejmiLndPmiVVJ+9yGNrW+L80DM+QISPM+9hQ4f5vS1SAPSx6AHnmP1BE
         QD+uFqxbemHizpeDygIAEEcqivQUSFunrETZOw9FEqRZ1nOp3Tki/E09p3m6hMoPssi9
         k6D7Wbxbh2w7Tv6vWMPcmYZQ5EhJyEFRAVI7TbYFVcOOk5R5UAMq0P/k6xBSJEuK8nYV
         k/Bw==
X-Forwarded-Encrypted: i=1; AJvYcCV9JPOlNfavKjMxrHPIVLBK7FQduHw3NZSPsyP9tryDeLcspki6crW1cESgszTtJTuMcOA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfwkW8yJOFJcrLfPo8YsColjprU5eZlZfsBFjtQpd89udLWe1O
	bI2N6PHSC8ED5F8XcrcEdg7N8/tjvT+NCgi4QV0eHXDr2nF1LEqFi1n9qjZaa5xP3kXQ08oADwi
	n/1tb+wgtGetmuayZAyNdpaQkzhcAryw4h3RH5HRleNhgooXEYkSb2kto
X-Gm-Gg: ATEYQzxTqzah0Bitli4ZAT/Ety95zHGo2d1dZjKifufS3ZBxij+tXOlS8V06+c6nLzF
	eHAt6IQWMCm7AMw8BT7+j1C6kRtUpY+EqOk9c597jfCakaDnch9cpjMSksJz4/sWMh0+TOe39GG
	+2sAyHuCmd0Ih7C7/sCvOMPqilwPyTsv+pM4RUc1vvC3mvC0cNgPXMkFReWmif3eFJKOierEW3K
	bCQe6yIIgjjS66VZ0u5er18/lhEadkI43i1lim96+uIbzhB8XnlQZtqhvzUIQ+gcBg6KAD9qseq
	Q2ov+oM=
X-Received: by 2002:a05:6402:3506:b0:661:1019:5388 with SMTP id
 4fb4d7f45d1cf-661e7d9e789mr15028a12.10.1772836048566; Fri, 06 Mar 2026
 14:27:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306210900.1933788-1-yosry@kernel.org> <20260306210900.1933788-2-yosry@kernel.org>
In-Reply-To: <20260306210900.1933788-2-yosry@kernel.org>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 6 Mar 2026 14:27:15 -0800
X-Gm-Features: AaiRm51CdHjxJqEzOmQhoqUqt-S7DKkT8xCWWsaHwdw6zLMLRCFlBux_CMttXyw
Message-ID: <CALMp9eRWwPwUSyQmizy8i2tF1CVO4iLY6x0vX1OoPUiRdCm4NQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: SVM: Use maxphyaddr in emulator RAX check for VMRUN/VMLOAD/VMSAVE
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D2F1B228529
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
	TAGGED_FROM(0.00)[bounces-73173-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.954];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 1:09=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrote=
:
>
> Architecturally, VMRUN/VMLOAD/VMSAVE should generate a #GP if the
> physical address in RAX is not supported. check_svme_pa() hardcodes this
> to checking that bits 63-48 are not set. This is incorrect on HW
> supporting 52 bits of physical address space, so use maxphyaddr instead.
>
> Note that the host's maxphyaddr is used, not the guest, because the
> emulator path for VMLOAD/VMSAVE is generally used when virtual
> VMLOAD/VMSAVE is enabled AND a #NPF is generated. If a #NPF is not
> generated, the CPU will inject a #GP based on the host's maxphyaddr.  So
> this keeps the behavior consistent.
>
> If KVM wants to consistently inject a #GP based on the guest's
> maxphyaddr, it would need to disabled virtual VMLOAD/VMSAVE and
> intercept all VMLOAD/VMSAVE instructions to do the check.
>
> Also, emulating a smaller maxphyaddr for the guest than the host
> generally doesn't work well, so it's not worth handling this.

If we're going to throw in the towel on allow_smaller_maxphyaddr, the
code should be removed.

In any case, the check should logically be against the guest's
maxphyaddr, because the VMLOAD/VMSAVE instruction executes in guest
context.

Note that virtual VMLOAD/VMSAVE cannot be used if the guest's
maxphyaddr doesn't match the host's maxphyaddr.

