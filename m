Return-Path: <kvm+bounces-4514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 550358134DD
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 16:35:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1089E281D05
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 15:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 372995D8E6;
	Thu, 14 Dec 2023 15:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tyrKwbbJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CCF9A
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 07:34:47 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-54f4f7d082cso9339041a12.0
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 07:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702568086; x=1703172886; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nv2TX1Ip2iaU3Gdt+lOUIp5X3QhzzFnX3LN7f4+v81w=;
        b=tyrKwbbJDIuHSi4IIlJwfNewNpDtDo1iPXhfslYXKRtpVDo1/zNfnMcMOipSXUaFll
         AQZ/Qed4M2PTxKgqtMoCMY50jhpFVHlakc22h5ANm/ph7Dd4Kqgdeku+q7vvZC+vVUtZ
         l60QTejFCeE9ICxoeCamk6zQvCn3SAfO4JOIwqYyypiGTRTHnKcOp3pf3kAcJCtvr9Xx
         PoSeEL2s9b+6n1QRRAM1MgJ9Cz4NV8REalcP1DZanqWLqGAnAH4h28/8QQMaRs7tFjBz
         uKazkBrMUduxzAIWyTywnWwaQLBLSKRXqNnJ72r+k7QEwN8KWEmTckr4i2IEJQVDEPJz
         PUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702568086; x=1703172886;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nv2TX1Ip2iaU3Gdt+lOUIp5X3QhzzFnX3LN7f4+v81w=;
        b=MGZEKQ8f13G8l7UsI4puzQXg6/3gYm+U/CrrijDTYIXWZNu2VCiwi4HrQAriq8p+Xl
         x8OOABcwSeMZHFGVhLCQ7TJXwRtKliO3VO2MY2Pb4zbv0khO8fJ4P6yPMPEcnh6ieezy
         DIV5loYCA0agULZrtPgUWzbofCYxFSu5GfWoq6H5gaX7p7MbHIHpdhHZFDiyw7meOh2F
         LUXfrqx+njnfDIkslK1KuXoVjAAmnEVExMDBrPHalh8jmgyHF5jIZjln8ulj3LQFxaui
         Q3uhItGC+0oAwA2bbIyZKZCZSF9rkyGN/e3/teJ0TB4B/Nn6GhNUGHx0SmPQx2VRiGbS
         R4oQ==
X-Gm-Message-State: AOJu0Yzdy0hckwjUvobNer5Ef0ot2ujavJaLSOmo4FK8c+PO7HQucvsH
	+U51vkbo2O3wN6Bi4mm0Ef14F9AIjzbPXhHQw8nTKQ==
X-Google-Smtp-Source: AGHT+IFcq6DemeL/YJ2XuTTh4jlsRgMuGMuDQEtXvj/bCvfTy5ls4pzl8QuwCb3aopkrNe2aCWakxkKBHdxMz7mxpTg=
X-Received: by 2002:a50:9514:0:b0:552:31c2:83b0 with SMTP id
 u20-20020a509514000000b0055231c283b0mr1088462eda.39.1702568086292; Thu, 14
 Dec 2023 07:34:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231123183518.64569-1-philmd@linaro.org> <CAFEAcA8S7Ug8uFpvDO9FarLpLhTr_236H8gOK=dEOWQZe-3zgg@mail.gmail.com>
 <e4443aa8-1b36-41fd-b1a8-6ed7ddb2f130@linaro.org>
In-Reply-To: <e4443aa8-1b36-41fd-b1a8-6ed7ddb2f130@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 14 Dec 2023 15:34:34 +0000
Message-ID: <CAFEAcA9v33h4EgfvFdH0EtVaf0jxtyAahUwEqoVDA39Z1izwTQ@mail.gmail.com>
Subject: Re: [PATCH-for-9.0 00/16] target/arm/kvm: Unify kvm_arm_FOO() API
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Dec 2023 at 09:42, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> On 11/12/23 15:36, Peter Maydell wrote:
> > On Thu, 23 Nov 2023 at 18:35, Philippe Mathieu-Daud=C3=A9 <philmd@linar=
o.org> wrote:
> >>
> >> Half of the API takes CPUState, the other ARMCPU...
> >>
> >> $ git grep -F 'CPUState *' target/arm/kvm_arm.h | wc -l
> >>        16
> >> $ git grep -F 'ARMCPU *' target/arm/kvm_arm.h | wc -l
> >>        14
> >>
> >> Since this is ARM specific, have it always take ARMCPU, and
> >> call the generic KVM API casting with the CPU() macro.
> >
> >
> >
> > Applied to target-arm.next for 9.0, thanks.
>
> Thanks Peter, the only change I added from Gavin review is
> on top of patch #3:

OK, I've squashed that in.

-- PMM

