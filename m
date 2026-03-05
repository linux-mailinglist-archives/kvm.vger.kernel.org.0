Return-Path: <kvm+bounces-72837-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KFHlHpO2qWlEDAEAu9opvQ
	(envelope-from <kvm+bounces-72837-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:00:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 800C2215C9D
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:00:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 576D8301DA40
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 16:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B40E3DEAC1;
	Thu,  5 Mar 2026 16:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nrFjNpCr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3373DBD54
	for <kvm@vger.kernel.org>; Thu,  5 Mar 2026 16:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772729782; cv=pass; b=Gn7u1YsIfR/VAj5yVQoLGIH+PWK+dWxOJ4ygTYVgvKEgQRla1N97ftK5iGN9g4OH8w+cbQkFZ4/ZFepb8YXy6hIigAWe06NjBKfqOCMGozm1uyunOmyKZqe6jDtYuwFMrRebpH+gvHDDfGiXMWqdMIahE+GGhazld8iMrvMFhBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772729782; c=relaxed/simple;
	bh=7+fZuvYjkTWPnYlnF0VNRGUh72MlyQ5Oi5QaZp9Vm1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FPFx3NADkucG6GLy95C9iSNZ0mZQXMy5u2KfAa3gJO2xMLybe5D7zTxOal1fQVoEiwQAG16EOgEGL0JDxKATGQebs8iOi+T7Xd7oKIdgo591lHZWlT5sLLMf+5qza5uex7makQk/+sFQys7Z1u83tDqnE2dW2CBASE20XrzT22E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nrFjNpCr; arc=pass smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-506a355aedfso632591cf.0
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 08:56:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772729780; cv=none;
        d=google.com; s=arc-20240605;
        b=gv78c4coHY2FyQITju8LW6hNmVnjyJecxBbl6xiQX7mKqwtSp9SBfmh1nMJTWe8X70
         wdT5/hirM3xYXJLpMmVury2m7Y6QMUhM8UMjOPyAInBTpwI2FeCLWulquX3Ti5FOd4+M
         IFw0P3xgJ1kstG1LT3AKF6/zxTHsLGM+/yIjUO+B6g2Cdo0TVMDCVjKfXVyHxepm9BbZ
         menR1lnRPTaRYGGSpML3I5LFfBrOo7AUJ4POBLMZj2IIphHvPN+pIatvfqkiguVNGC95
         /TZHa17M7aKDEyLHfR1X3blHK3P0uOV73NCcDf6UFIQmyNDRNM/q0IzXf4dfNFE3uOHu
         lTKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=w2b4o87Dv8Tqe0cDumD9I6Yls5fZWHSIMLvm+YwvHiU=;
        fh=1NnkoE44iydqwaKIvZldbbixCVVisB2zZR4hOif3g18=;
        b=bU4+bLqerOu7vecYDgFhA9agnlqoir1HET0VrkYlsn0Z8jnWJWhVg5u972cJrB1Mkf
         M/VCcc6bBw+cjcu83ePoGHlihxlv7YTlUKwmP+TahWRzrjCULyZ78ke8VwoUHCRsydji
         ybxtnuYZeSth+Z/l3mW5eWiJpmAlgRvPaPQGqjB7D091y+MgYi5ZlTGAPcaFO4GkGJcB
         47zz4kHTwHXhkShrhOEAqkGmvOoYPjyWXCv5XaMmttjoqJ8bQ17ICWJcXYcyJjk6vSCm
         cWDUhImHbQIoyiw7ehUVLmGTGAkChwQ/LuTIazRqWphhCZDIyrlsFfwWWOvZpOrpaRLv
         G83g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772729780; x=1773334580; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w2b4o87Dv8Tqe0cDumD9I6Yls5fZWHSIMLvm+YwvHiU=;
        b=nrFjNpCr50MpTJUBliW5Yko+XzoE2VAfFiUEQxJZHia0El3SgKWozfz7Jv8p0ZkCc/
         3ybMuUNpNeAv2AXxcneNyZmyxh6oBclhFwfsw7i7LXkicJ07HsCIMEWmnRxItAifd0fN
         q9X8QtM7UaMG2fUApZO//MGzvzUavF/rsZoizKg1MZS6rRO53LE/qOLwiIQOuQv8Ypx2
         UVYCnMhXLD0EhKq2hFdsGJ/+5GVhL0kq86PikGM2a4cBCDNPEnrBpS++xp7aTqsv1Lxb
         yOUpf609NW4y2ehdoQJkQR6mG0tzya2Lyjj9/Qx9yS8loSnGpxC/idvB7Kr9GUWX2Ayu
         Oh7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772729780; x=1773334580;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w2b4o87Dv8Tqe0cDumD9I6Yls5fZWHSIMLvm+YwvHiU=;
        b=ZPvdT9ty+wjOO8LBtOTw+sPTeN1e08iv848taDpDk/mrxgW2naQkSU5dLXtpsUsJ0c
         wB+ow3sS9Z0EcI0lmj+BZYxTLbd/5HJyWe/WzbMQQk4kO6RVG7WHGIBwLOs3KEZucaHX
         Aqqodi30MKM2Zckcnybk/gMo6tynKx7XHTzsld+MxBBtiNPVfryHTVwwihXufDenLihK
         nLIAO6F5c3qP6DDit4TbBite87ivvqyy1snJCn2tpdAFMtaV7G03fi0BpYBsrXMl2X2t
         rWBJcpJVfKk+MVwJKtVYvtBCnVsMXqf8qTaDuaPLBcXce2z/DbmpTsOQP7tFO0X2lDTf
         L10w==
X-Gm-Message-State: AOJu0Yy9JhhjANOugTvDTXh7m8YVf2v7u72dbA+Lbd45+EQ5L5AOd/Cy
	Gpwlr2rtEK4wHc3PHvySkuYtUBxxGSInECV3DRx8Q/O/mf9i7bJ9EoiEl0l3qXNHruksWufIaYZ
	iLBPqBWsp4DJWJgvSN0L0HazSQcGbOpGvNsVGQ6h6
X-Gm-Gg: ATEYQzzZhoC+ODPyJvwd4sXvKJbOs+bejBrlREK/JwQ8uJy4rutf8kaFifoAX7jRkPZ
	WQDOj3bbOOMRmMzwLSFyw0XLp8avcDuEZgmK7/2iAgHHq4LPWWHBlVTrdW/g0Kr1x9KmRQavQyu
	tk5jWtFXl7TI59qe/aON9tEmjNQ27AqlVc+jn0+dymWBDfX34P/fGV8eKwMZGSnZfmruCwyAnPB
	xXqkJAMMlXPGs7W3sQahsKwHJ/PTLpLYw5Nq2OqyEEHzZJLWYiYREKNb84RFpJhZXeFE5HJ1c8F
	qZMLma15
X-Received: by 2002:a05:622a:1908:b0:501:5180:3c90 with SMTP id
 d75a77b69052e-508e78bc5a4mr11348321cf.15.1772729779762; Thu, 05 Mar 2026
 08:56:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304162222.836152-1-tabba@google.com> <86jyvq6wyg.wl-maz@kernel.org>
In-Reply-To: <86jyvq6wyg.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 5 Mar 2026 16:55:43 +0000
X-Gm-Features: AaiRm51dhM8VzhZriEGSXSixZJNkbyhhRpWwsRm0Q6k3mF9vnEvNvcsMfRmqcbY
Message-ID: <CA+EHjTyUhBqUGG+TC83rz5W11RcymQuFAr+FhFpRsPZbf--vTw@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] KVM: arm64: Fix a couple of latent bugs in user_mem_abort()
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, yangyicong@hisilicon.com, 
	wangzhou1@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 800C2215C9D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72837-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid]
X-Rspamd-Action: no action

On Thu, 5 Mar 2026 at 16:51, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 04 Mar 2026 16:22:20 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Finding these issues just reinforces how fragile this 300-line function
> > has become. We really need to refactor it to make the state flow easier
> > to reason about. I'm currently putting together a series to do just that
> > (introducing a proper fault state object), so stay tuned for an RFC on
> > that front.
>
> If you have such patches, please post them sooner rather than later,
> even if the rework is incomplete. I'd be happy take small patches that
> start add infrastructure early and work out the full refactoring over
> time.

I'll try to have something for you by tomorrow in that case.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

