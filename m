Return-Path: <kvm+bounces-3035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D39C7FFFC6
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 00:58:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E4381C20CFB
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 23:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A35584C2;
	Thu, 30 Nov 2023 23:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ic6Dz9jZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DB810E4
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 15:57:55 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-54c52baaa59so508a12.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 15:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701388673; x=1701993473; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QS+i37UcwGBx82n3McWzPFFtU6IxiBbMiMBLppZu2kY=;
        b=Ic6Dz9jZfE6/ShcyS9VI6yS8/XexbAMApKWQvuPLd3vusNRU0uMwg8CmKgXLMiOgif
         Aqz5y81MVZ+xfNsgUgPneanmnzOpzc8mF3gUm5/wkeU5NKfhKmV3skBZEnrb3SHqlZRd
         bSnbyXCbfqKbk/o+6+cYrkpoZiiNMyBGmC9SoUFC9hZ0FPzI3YqCaZ0obPUaQ/BknDOa
         EbeonPvHvQBfdj8ZdnwlLRiWANO6o7a2IR5NChYC6sgK3stGe+OP/J9acbC4e+EtB0ka
         DhDScowlMZexBAirkg5dQjYkDRzyCoEMTbYRpEIn89QyCXHO0Il6T8wIJHrb+bg5ZL8g
         M7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701388673; x=1701993473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QS+i37UcwGBx82n3McWzPFFtU6IxiBbMiMBLppZu2kY=;
        b=O0VWlWTJccrnn9UrEYK7HWOqMtgDIDaC+AVMC+AebmzP9QtUUlgqjQcY9bgCYBr5K1
         nmx7nBhtfXDCensltR+RwPXPscRGhaY7jLS2PdYK2FYjbXzjr6/f0rE79wK1hbB0uyfn
         aqTxItHz+Bc3gx02ANJc0W8Vu3vSxK35pHM6qozcMHGkdYjyRNdsFas2k+tO3rbVnluQ
         ATj9TNHZJC9tRA5zx6Ezl1tf7o0nUAKvgJEd2lfWPSr7uhcsfCNnEeebx3BLtt3KT2Pr
         K/HBQ1jqzzco8AXpnkyzAwI9HsaA7EhxM7mfRojAyzdrqUcAav1pTEnm2y7Lfe/FmwP0
         T8UQ==
X-Gm-Message-State: AOJu0YzSw/awCqIoHZtuFLgQ02W9/So0YFduauvYCsKcNAyb/l6WuXIO
	NGo2ySdAigTcQpmtEWDqd0H55IF01JWYd0qJ1tMeKA==
X-Google-Smtp-Source: AGHT+IFUkxAQaLbevOaGiXUhKdK7+EP/riejmQgJRc5b0rDX5HNmOqxcvx5tGuqsp6Y7XMu+Kkypu6GSGnyboSO2hfw=
X-Received: by 2002:a50:d083:0:b0:54b:67da:b2f with SMTP id
 v3-20020a50d083000000b0054b67da0b2fmr6508edd.7.1701388673458; Thu, 30 Nov
 2023 15:57:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <c858817d3e3be246a1a2278e3b42d06284e615e5.1700766316.git.maciej.szmigiero@oracle.com>
 <ZWTQuRpwPkutHY-D@google.com> <9a8e3cb95f3e1a69092746668f9643a25723c522.camel@redhat.com>
 <b3aec42f-8aa7-4589-b984-a483a80e4a42@maciej.szmigiero.name>
In-Reply-To: <b3aec42f-8aa7-4589-b984-a483a80e4a42@maciej.szmigiero.name>
From: Jim Mattson <jmattson@google.com>
Date: Thu, 30 Nov 2023 15:57:38 -0800
Message-ID: <CALMp9eQvLpYdq=2cYyOBERBh2G+xubo6Mb0crWO=dugpie4BRg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Allow XSAVES on CPUs where host doesn't use it
 due to an errata
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 30, 2023 at 2:00=E2=80=AFPM Maciej S. Szmigiero
<mail@maciej.szmigiero.name> wrote:
> I think that if particular guest would work on bare metal it should
> work on "-cpu host" too - no tinkering should be required for such
> basic functionality as being able to successfully finish booting.

I disagree. Let's not focus on one particular erratum. If, for
whatever reason, the host kernel is booted with "noxsaves," I don't
think KVM should allow a guest to bypass that directive.

