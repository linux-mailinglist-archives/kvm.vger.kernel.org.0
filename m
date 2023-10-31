Return-Path: <kvm+bounces-263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94EE87DD960
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 00:52:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F8BC1F214E2
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 23:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF69D28E00;
	Tue, 31 Oct 2023 23:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I5MnARlB"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F37A1DFC9
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 23:52:32 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F7EDA
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:52:31 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc3ad55c75so24415405ad.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 16:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698796351; x=1699401151; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QJGVDo956lsRbHhZKnYMhq4TnDnKN6pAbpTw19FM6i8=;
        b=I5MnARlBx9KTT19JggHNI9kDe2sxMwT6OvMbCnxoVj3uJ3hhmGy3QprSlVXwjJ0L1e
         YLmSlek6faeGMgiXPgxeI06cod6FOH+rQUefbtJYCfKxqfre50OySJhMubxq4T0FPXLn
         qLtwWH4qWajS+wdwKWLUJdKIViomTKMcKZOPtDPV3GHAdwNR1eVkAiNs0tWEw2oQoGko
         AY37mUNJRDYJTtMbW34PrwfRZnHZVR8tYjFAaAWaPs2ojbsrHnTzAKuqsaxkb6RzZgZ6
         AkCQ82gXVr+TSWqxtuhaUL48dkReJqpDhsXQkOAoGxlwSIlzebx4xFTmsBqIG1mUXfdX
         Pzmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698796351; x=1699401151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QJGVDo956lsRbHhZKnYMhq4TnDnKN6pAbpTw19FM6i8=;
        b=EoQ1WsDcad9Pm357riu3Ny+TDBp8m3ecFTR5ybfXPqxDOdoKndWAMil0f4hUTMfX3b
         Zvz0EjwggLKI+KjiCpR425VY5jUYM544ZzFEWO9lJNWohTwbsxB/vT6mpWe+JkY8pxr/
         Z4MBlFSFkuJooQ4y+gSGYbUnBi5ku4Lmfw3ymk3+PjZ82aTmrzaDm0mVUYcROu9r700z
         yzT2CJfSl1ZVUrUVUEOWAsEadfkb1X1v3Qz/4+4Wt1O2NxpgzKxtGCwU80DsP6NeOVU+
         LrBejRCaPfAokmdi1HtsWskU52WA3aGximjbdQCmhfAWzCPBHLwm6f8j2gONNjVFNX2x
         5vbw==
X-Gm-Message-State: AOJu0YxkKwBTt8F1wuDnBC76uM0l+DUdRq9FdyFGsi6TiEmQ3Ai3NEup
	devUqHta4ws5K4hxuSUeO7yQruexrqQ=
X-Google-Smtp-Source: AGHT+IHcOfYzryqSt7FitiHZaz16AzszR9kQOx7pWzPPL2II9dBk3FFbIGHTRJcc4RLjWHHfnly2DK2AufE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:8695:b0:1cc:1137:2158 with SMTP id
 g21-20020a170902869500b001cc11372158mr229139plo.11.1698796350946; Tue, 31 Oct
 2023 16:52:30 -0700 (PDT)
Date: Tue, 31 Oct 2023 16:52:29 -0700
In-Reply-To: <20231002095740.1472907-7-paul@xen.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231002095740.1472907-1-paul@xen.org> <20231002095740.1472907-7-paul@xen.org>
Message-ID: <ZUGTPZLRcHRajtYB@google.com>
Subject: Re: [PATCH v7 06/11] KVM: xen: allow shared_info to be mapped by
 fixed HVA
From: Sean Christopherson <seanjc@google.com>
To: Paul Durrant <paul@xen.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>, 
	David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 02, 2023, Paul Durrant wrote:
> NOTE: The change of the kvm_xen_hvm_attr shared_info from struct to union
>       is technically an ABI change but it's entirely compatible with
>       existing users.

It's not an ABI change, is it?  Userspace that picks up the new header might generate
different code on a rebuild, but the actual ABI is unchanged, no?

> @@ -684,6 +692,14 @@ int kvm_xen_hvm_get_attr(struct kvm *kvm, struct kvm_xen_hvm_attr *data)
>  		r = 0;
>  		break;
>  
> +	case KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA:
> +		if (kvm->arch.xen.shinfo_cache.active)

As requested in previous patches, please explicitly check that the cache is in
the right "mode".

> +			data->u.shared_info.hva = kvm_gpc_hva(&kvm->arch.xen.shinfo_cache);
> +		else
> +			data->u.shared_info.hva = 0;
> +		r = 0;
> +		break;

