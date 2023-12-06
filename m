Return-Path: <kvm+bounces-3747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 045C18077DE
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 19:45:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6BD11F2123D
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 18:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B46236F;
	Wed,  6 Dec 2023 18:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PRJHfTZI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5904D44
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 10:45:47 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-548ae9a5eeaso967a12.1
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 10:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701888346; x=1702493146; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=47YAkdkayM6J9ol4Fq0c4j+8eoetSWIWg4LqcP0jJzg=;
        b=PRJHfTZIczZsZYAn34J6/q3HE7+nI0wRfZVSngzDQQijt8dyIqYZZL/Z6jbZ8H0+pU
         keLGwGyOc2kolqAmjn9b3nYy3PSLA35KwLZjtR+MP0/rSlSvGWe+vZk8a7YLJztQwp61
         Ias+OCUjaLTYJUWJnqnF1zb0R3LrYvPQ/JEvo0YyA4zHSZtYccGfhhIJUqlp3MDhnQKH
         cLu5HDNs/CV18g8HEQKpcXX522lWs+sRAxXeDmcQZGiRi0MBGfB5dIX9akS3g+QGhU1U
         1G/oD1VFmjDEjf3hVt+Wo5jmKBD27Ja1SpR2n+w9ORMRWqUN9JO8YNFfAE79f0eXnV6b
         qLEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701888346; x=1702493146;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=47YAkdkayM6J9ol4Fq0c4j+8eoetSWIWg4LqcP0jJzg=;
        b=knscryDsmHcXJWgJhAhSofcaL1j8ZPARlxWHwuFLOlldMAfaMM2yezSYNi30pqy9WL
         nqbIZMsSG4ipQy/PMSFgoLokq5j8OW9uzZ6ytD0zdi6lUS2I/kcz7w6gZrrscK2gWxKq
         nwtsRXQdKiGayJ/fMy36dLTeNhqj+EkdIXMRXwpM8RXY0ZmRyoXca6j8ejjl9dHCghga
         gGqy80DAB/+YCBvgZS0sNUxHBSSQItYstuhyQtunMHLB9BRctFTHpBnAoDQDbdqyzjNS
         gMy41qkUcMDrNU6vHWz6FS49PzO6C55zPARWh/3R03llakiK5CVbVnxM6XYEMGyFBKYG
         f51w==
X-Gm-Message-State: AOJu0YyBUfVXlLQ5T1nhRoUvF/IWs32vbs9S/rugzu08+h5TSeSvl62x
	fbTwdsEYd2VfrxkZkiJdgO+GHXgjUrK1v0gFRasmiw==
X-Google-Smtp-Source: AGHT+IGZOreuXPIcmrKjukLTpQoCpsI5n2yTrCleugNY8KzuTUesi1Ys8axBY3GggxFOEafw5nNhGSdq9pVMiyinY4Y=
X-Received: by 2002:a50:d0cc:0:b0:54c:9996:7833 with SMTP id
 g12-20020a50d0cc000000b0054c99967833mr104496edf.7.1701888346145; Wed, 06 Dec
 2023 10:45:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231128125959.1810039-1-nikunj@amd.com> <20231128125959.1810039-13-nikunj@amd.com>
 <CAAH4kHYL9A4+F0cN1VT1EbaHACFjB6Crbsdzp3hwjz+GuK_CSg@mail.gmail.com> <dbffc58e-e720-42fc-8c8d-44cd3f0281e3@amd.com>
In-Reply-To: <dbffc58e-e720-42fc-8c8d-44cd3f0281e3@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Wed, 6 Dec 2023 10:45:31 -0800
Message-ID: <CAAH4kHZVdZtU3MGLTuuxMZyBF1xO=UzpdVhqSE6szCxMLkHFvQ@mail.gmail.com>
Subject: Re: [PATCH v6 12/16] x86/sev: Prevent RDTSC/RDTSCP interception for
 Secure TSC enabled guests
To: nikunj@amd.com
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org, 
	kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com, 
	pbonzini@redhat.com
Content-Type: text/plain; charset="UTF-8"

> >> +       if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
> >> +               return ES_VMM_ERROR;
> >
> > Is this not a cc_platform_has situation? I don't recall how the
> > conversation shook out for TDX's forcing X86_FEATURE_TSC_RELIABLE
> > versus having a cc_attr_secure_tsc
>
> For SNP, SecureTSC is an opt-in feature. AFAIU, for TDX the feature is
> turned on by default. So SNP guests need to check if the VMM has enabled
> the feature before moving forward with SecureTSC initializations.
>
> The idea was to have some generic name instead of AMD specific SecureTSC
> (cc_attr_secure_tsc), and I had sought comments from Kirill [1]. After
> that discussion I have added a synthetic flag for Secure TSC[2].
>

So with regards to [2], this sev_status flag check should be
cpu_has_feature(X86_FEATURE_SNP_SECURE_TSC)? I'm not sure if that's
available in early boot where this code is used, so if it isn't,
probably that's worth a comment.

-- 
-Dionna Glaze, PhD (she/her)

