Return-Path: <kvm+bounces-452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 012927DFB7F
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 21:26:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31C0F1C20FC3
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 20:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D08E21A15;
	Thu,  2 Nov 2023 20:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hBvv/Hg7"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A6E219FB
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 20:26:29 +0000 (UTC)
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B400182
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 13:26:28 -0700 (PDT)
Received: by mail-oo1-xc2a.google.com with SMTP id 006d021491bc7-581de3e691dso652013eaf.3
        for <kvm@vger.kernel.org>; Thu, 02 Nov 2023 13:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698956788; x=1699561588; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G1/c+9q5F6vJQGdeK3GAV6RYW5UxuwtB/kEmZPd/ZYM=;
        b=hBvv/Hg7kneFZZRYc1mgO5f9hhJo2Rjc1QedHndEGPENF7OVWu+XSE0WboyzfHXL9O
         u2PqnauvXuQWF/F/MNvh9bgIyQJ0D7NfOgEjdo19mD84/+Y8azm9Gmt/RsgzwfC8rK0E
         oUHyqvi2yQwSHu3TW4EMnP9JM4qtY+QO4yIxSidMU199El7OkVqBSFbXJJsw6Gg6CBoU
         VwsfaP0YjMGoWv0m8UssuY4t8C+VLUFvMqgJHEjvgNxtmuoHFWR5ZnJjuKxMtUe5vbrp
         6fWzil7JMJbC29VHCCY4aPdLNqr3ASBanwsCSDbGlgSiK3deUSEZJVL78hFruqE2WS/E
         MGaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698956788; x=1699561588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G1/c+9q5F6vJQGdeK3GAV6RYW5UxuwtB/kEmZPd/ZYM=;
        b=Blz2l9MruYiAPs33Cgp8w12UDj4YCkL9PYQQT/FT0fOpaBtgKQy3d6EuuobF6a/D1t
         5FGiBHGJs1LPsD1aSFSv5td2ncAGVaEDz2QcCaDuNYaKpSQd9LYTeywGzUOxA67tZvqP
         tzU0p7W4rYVzlwnKAvqHZSYhrJSi4S3p+e8pu32PzEXLs7wdL/PkkZEiLg7T/VGnPCgA
         I37mM1wCfIh/TuQzIb/lC4jJ/qfh+KCUTRdSDxMDfZe8eE6wd/4JIvAwRupYmLm9gik/
         NlIGENN0SLVxRjhQ24C5YvkuLFZuQ08doWyYW78YtEONP2qjK9I98civI32hJbZjuk3X
         EwSw==
X-Gm-Message-State: AOJu0YyxgBLxGrXpNLmCF2n/6R5HPfSM6BC2mGMEJuXNpljF1LY6n55N
	3sPa9Mcu0uVaqHz9WFjvBxjUWy6pW+T/iIqWb+Od+Q==
X-Google-Smtp-Source: AGHT+IGcJQISXG+9qweii6J9T8ORXystyQe8U0Ulfs0xdHraAqZIk9sNe6Gy6mhMMudgW60cCnOsGw5yUb8GwFD6DzE=
X-Received: by 2002:a4a:e28a:0:b0:581:ed9a:4fde with SMTP id
 k10-20020a4ae28a000000b00581ed9a4fdemr19465482oot.1.1698956787854; Thu, 02
 Nov 2023 13:26:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-11-amoorthy@google.com>
 <ZR4U_czGstnDrVxo@google.com> <CAF7b7mrka8ASjp2UWWunCORjYbjUaOzSyzy_p-0KZXdrfOBOHQ@mail.gmail.com>
 <CAF7b7mpzkjvBTybbaEUSp7iL3dVURVi+rDtkkojOcXAY=Bk9=g@mail.gmail.com>
In-Reply-To: <CAF7b7mpzkjvBTybbaEUSp7iL3dVURVi+rDtkkojOcXAY=Bk9=g@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 2 Nov 2023 13:25:51 -0700
Message-ID: <CAF7b7mow10g_T=vocu6jaXsUciEPyu79X2HuCWuSLgqBcFL2ZA@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] KVM: Implement KVM_CAP_USERFAULT_ON_MISSING by
 atomizing __gfn_to_pfn_memslot() calls
To: Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>
Cc: oliver.upton@linux.dev, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com, 
	jthoughton@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 2, 2023 at 12:14=E2=80=AFPM Anish Moorthy <amoorthy@google.com>=
 wrote:
>
> Proposed commit message for the squashed commit
>
> > KVM: Add KVM_CAP_EXIT_ON_MISSING which forbids page faults in stage-2 f=
ault handlers

Erm, I seem to have flubbed it already. IIRC this should be
"vcpu-context accesses," not "stage-2 fault handlers"

