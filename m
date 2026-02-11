Return-Path: <kvm+bounces-70862-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mD+5I7ujjGlhrwAAu9opvQ
	(envelope-from <kvm+bounces-70862-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:43:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F2744125CBF
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 16:43:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 45EAC301E6CC
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 15:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7016830F7EA;
	Wed, 11 Feb 2026 15:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UYoMWtFw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9402430EF88
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 15:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770824626; cv=pass; b=bZcBXossnG3Q3RcU9BBb7pPOFQB22QtgBGqmoD2Q1fYYABSrIBp2AEm1368M7/+4j5wZIzMfvps9kHRQT7pp6YvnjBUMP1yG+gMPsX2ZMcegqPI1aDaJVSrKpH16eJXdUU/oDIF1hYak6gJ589DNe3Iw/4DW8L0lxB84cbBBDhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770824626; c=relaxed/simple;
	bh=SPvqBAtz64fVd5LeGOVthMVnAayvTVLJhC/f1e85Ey0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P7nt6ePbH/vIrZlKxEkP70JjYbfv88IprwLf0ZFYbLwkJOopVslE75zpJiRjpHZefpnivXRKLsenU6Fgy/RO0MDxa+3ohu1Yfz6keUnOI9bUC39h8fCmKNrvi9o3J2I8urMsVN1C9k/LCxRQDREg+6J21kgqWQED+6/hcLr19C8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UYoMWtFw; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-790b7b3e594so76217797b3.3
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 07:43:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770824624; cv=none;
        d=google.com; s=arc-20240605;
        b=bIa7upVettqwar12NYo3ePJe5ZCZJUogT38SC7P29sLW6YrCwxIxrs0iwcC6xPHFV/
         ugjgCvPuCeUowvX4uOTajxySj2MdYF1OoRJwEvuJvV/aE1lBYYGMFS7J3/QgfjNGKgm7
         UZtTL6qOeNBRBmK+q7bsw1mGzAHZtCUudS/h96ndm0DNtrqICzaobApOGXb6aCRyD9b8
         N0AaSHV448JuI73noI6uAoa8FwdbezOtSsTUTebQVyk9EIfhk/ZIIL6+M5mykXi5hBbp
         4WiodmowzZ7E+vu8WtaWgIJe1+S7FxTg8r11E7Y1zhNio8zseOKEA1aa0BNDr2BT7TbB
         sJow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Cwx4TMtV0+2MBlJylAWyBlGUsmVcRjrhOwzbBX1NFZs=;
        fh=0hAvlznPn6F0DPIsGC/h3rlnkINuV1rorzpwGtWDoew=;
        b=ImPRUt7U2F6mcAu7paQBHlmYB9w6RxGF5uc23EcezgIU3oSspT9riyR98R1HnXtAHE
         QHrK1Wm5HgHmfDnLHPMpP1Itcvue1ySaFiXquwgBSbC0IAE8Tw8h4X5jzPzYHu4SBqKT
         lYhhFXV9lg0XIxe7gygj3FvvWroznFfsTHPUA7H56JHjjMXET3OfxhRu5e7swT3dkGB9
         ACr6vVFnYtwD9dHx3Gll8c6gkZTnAG4TOGhiawyTGzSPI7bBMReU8OyWqQ7JtmsKinLG
         wSod/y3WqctN+ziiuRPhY95eY6leZWpdxLPDD0oIUjfrO12x8TSX13bdudUOqZcfwkKA
         KuJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770824624; x=1771429424; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Cwx4TMtV0+2MBlJylAWyBlGUsmVcRjrhOwzbBX1NFZs=;
        b=UYoMWtFwz/10BfS7HwP56l9GbMdKuDyOzkzoLYRL15w4Md4v8/X/LZRcZMyxbERcvn
         iabKg9xz9A1wQOpnF7sG7EDkD+6/ahPvKFANvvNWWd0f/sJprlXoTsdq85EfLNJv2vzT
         gk1W6ZfxxOiO3X/JBqeWGlwGyjicOpPRaRWJ1OTFh7RSIPQqsZY9llOVbIlSPyKpAKdm
         7w4wr84nKzLvCu94rQdN0jbM+5D7VGgh8UZOhGkn+VBdQSehXTZWDiOSSa1IDTUwuS5o
         Y1WevH/lYLL3taOhJ79Zi5KKbVLsZkWPuNGxCEVdLOfTSJU9VVf02BtfHqmBwCOI8r/j
         IyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770824624; x=1771429424;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cwx4TMtV0+2MBlJylAWyBlGUsmVcRjrhOwzbBX1NFZs=;
        b=MhRe21CicNq/mKsFJgh2oMfWafqmxzgsL1Fr8KCPETug5ZMDm3+5oTxnzU6VRSzdBW
         5WV1IrsbDG42K80lZaPnw01NPx8YF8tO8XiD6Nx/6wXpb/cwT8FqiDZ6W+Bj3WQO3Tah
         DzVynqplyBjEMquVko1Aof9yD3AoJikLzRsHAPC0rykAMVtLhnJl4LFEwgGQVL5aIjDn
         ESHH3WFb3Zh3nWJuY8DLgHpHgOG8D9zSxVDF44j72DuymmRXLDzoWZTjPOlfcKpQjpzc
         yKKe5cGRRKInea+kvE25Jga/DM7b4Rrs+BWnbHnBtAEGGRMDbVD5Xk4YB77GomCIXKZ9
         7+gw==
X-Forwarded-Encrypted: i=1; AJvYcCXSiEg5mPJ6wBvoXEoIKBtz1QnOhvS2kG1IztFITK4haeZSHR2879iNGlrOxuk3RGONIh8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTF+t0OUiKKhn+JpvzgXcWq0qgaChTVXgYZ0OjErkgdm38Kouo
	i/t4MmLqqm5Eb4OiKtrWogM2sN5/qWRy+FJEB03ItPVcCUdXxGO3Tan/pl/eNd9yYZfqRvoBwf3
	PkxIUQ9uaQz/ltG5gBKs9zSdwDXf8Ap/UxNPlNPKpyw==
X-Gm-Gg: AZuq6aJBY5Blw3h7w/yZ4lg7yRaqme1pzxrsGChGOChQcHEnv5SQ4IB8r9fUsV1cjDT
	tSYUfBDZIUJ0ulQ69k5169bD6gKiIe6ByJd0uBLy/ZnfsZeq/QDlp89+8hqurmC2biu2m57K6Uy
	JPA0AfbxfRwrH9oct/rcCV2Buf6wVRVF97jxJfb4r7mw+F37YA9ODb8DtBIK1m2tVLcgWZGWrHb
	gBROvExePra0qQO70+bJEL0N9eAZWXs8lw+3h1PQV2lwhz93fI+gVoV6mbHqp4UZV77U7s/A3eZ
	wuznFNg8JAY/3H6OWUlLLkNwMHmXG+AXNQB7p/AIHG90QzqhJ3CGZfxSPzwJkf6RTjA=
X-Received: by 2002:a05:690c:6006:b0:796:2ee6:3f87 with SMTP id
 00721157ae682-7965f08a3a8mr55352367b3.67.1770824624573; Wed, 11 Feb 2026
 07:43:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251202160853.22560-1-sebott@redhat.com> <20251202160853.22560-3-sebott@redhat.com>
 <CAFEAcA8oi1Xs2kv66dFV9NZore+Q2vHUsgMikveVdN1c+3SBJQ@mail.gmail.com> <9b04a20f-b708-208d-1e4e-466ec30b7bb9@redhat.com>
In-Reply-To: <9b04a20f-b708-208d-1e4e-466ec30b7bb9@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 11 Feb 2026 15:43:32 +0000
X-Gm-Features: AZwV_QhbMQtjgAAFsQMaNKMcmBgssEikN0rK-YFZ8G0l_cRA-hB9h8zVvJqu3SM
Message-ID: <CAFEAcA-A+zW=QFdCY7z==+Z=xXfhJvPeyHhbG_MpEmpkQfrmaw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] target/arm/kvm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, qemu-arm@nongnu.org, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peter.maydell@linaro.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-70862-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,linaro.org:dkim];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+]
X-Rspamd-Queue-Id: F2744125CBF
X-Rspamd-Action: no action

On Wed, 11 Feb 2026 at 15:37, Sebastian Ott <sebott@redhat.com> wrote:
>
> Hi Peter,
>
> On Fri, 6 Feb 2026, Peter Maydell wrote:
> > On Tue, 2 Dec 2025 at 16:09, Sebastian Ott <sebott@redhat.com> wrote:

> >> +static char *kvm_get_psci_version(Object *obj, Error **errp)
> >> +{
> >> +    ARMCPU *cpu = ARM_CPU(obj);
> >> +    const struct psci_version *ver;
> >> +
> >> +    for (ver = psci_versions; ver->number != -1; ver++) {
> [...]
> >> +        if (ver->number == cpu->psci_version)
> >> +            return g_strdup(ver->str);
> >> +    }
> >> +
> >> +    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);
> >
> > Is this ever possible?
>
> Hm, not sure actually - what if there's a new kernel/qemu implementing
> psci version 1.4 and then you migrate to a qemu that doesn't know about
> 1.4?

Oh, I see -- we're reporting back cpu->psci_version here, which
indeed could be the value set by KVM. I misread and assumed
this was just reading back the field that the setter sets,
which is kvm_prop_psci_version (and which I think will only
be set via the setter and so isn't ever a value the setter
doesn't know about).

That does flag up a bug in this patch, though: if I set
a QOM property via the setter function and then read its
value via the getter function I ought to get back what
I just wrote.

thanks
-- PMM

