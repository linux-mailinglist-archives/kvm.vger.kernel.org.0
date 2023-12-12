Return-Path: <kvm+bounces-4120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94FAC80E123
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 02:59:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B5D71F21B91
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 01:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A99915BF;
	Tue, 12 Dec 2023 01:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SB6BeEZh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2E4D2
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 17:59:38 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-50bce78f145so5936361e87.0
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 17:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1702346377; x=1702951177; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uQ89ZIrgto37G/xlhKf3Jw+2Aq+MN68zNYm03Mdawcg=;
        b=SB6BeEZho+ukE1MNuiXfqDu/LnWvFVInOnYiZkWvmggYv5PDycuHUF3XPgkLQ/r7Vy
         ftm6JaAGba6uqN2T646YLRZwn1b3hajmKLLi+JNKHZrKNHC2uH1c2Hx8sRa9N4YXmfUQ
         L5xlAE417xWxRmEp+IvK4rVnLOBSWemlmGHwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702346377; x=1702951177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uQ89ZIrgto37G/xlhKf3Jw+2Aq+MN68zNYm03Mdawcg=;
        b=h6Ob3Zc5ijlHSV869BjSuuPu4d4ItXhvp6GHmCtKGFkmf7m05yNG+md9B2bckSwXsB
         CdcHkQCuv14rNf2c7yVqokseYBKUdb5SoRJCwBYYzhi2NdMd00fm6uihaXseO97tku85
         hyCE4xcxrfXNuf5Gd3sChAj6vgQO6G6gohjG/5V8SOzrl3Rx4NrPKqNSQ8E8xmD0M/8R
         9TnTt/70FHt70pjmQ+IxtTDik+D91KIVzdK9bq7/Nvv32ayp64vqgDMNtRGREaUww0tt
         vyK0XvygcRRbzuy/OWSeCODcFbbRNeCL9XRiPidOiP+AF3IwzN0wCnj5xa3XQaMEWbha
         1Obw==
X-Gm-Message-State: AOJu0YzDHYVATTskefdsoe8/UYcbcpaAtKZzj+f1G063X3L63JsWIdq9
	llDqsOQiIGzzGFsE9+3mmMdgApj+tlnzoQ6BJKArCQ9YVR5UBmzD
X-Google-Smtp-Source: AGHT+IFPkMwM+ODEL8jAac04JHQ1iWXAbY+dSF92QrVLp74yCwtnOhjG/2NaE3hAxNkItRtrSNp0Jef+ghFheIRqHhQ=
X-Received: by 2002:a05:6512:23a7:b0:50d:1a10:d27f with SMTP id
 c39-20020a05651223a700b0050d1a10d27fmr1444302lfv.201.1702346376180; Mon, 11
 Dec 2023 17:59:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com> <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
 <ZUEPn_nIoE-gLspp@google.com>
In-Reply-To: <ZUEPn_nIoE-gLspp@google.com>
From: David Stevens <stevensd@chromium.org>
Date: Tue, 12 Dec 2023 10:59:25 +0900
Message-ID: <CAD=HUj5g9BoziHT5SbbZ1oFKv75UuXoo32x8DC3TYgLGZ6G_Bw@mail.gmail.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023 at 11:30=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Tue, Oct 31, 2023, David Stevens wrote:
> > Sean, have you been waiting for a new patch series with responses to
> > Maxim's comments? I'm not really familiar with kernel contribution
> > etiquette, but I was hoping to get your feedback before spending the
> > time to put together another patch series.
>
> No, I'm working my way back toward it.  The guest_memfd series took prece=
dence
> over everything that I wasn't confident would land in 6.7, i.e. larger se=
ries
> effectively got put on the back burner.  Sorry :-(

Is this series something that may be able to make it into 6.8 or 6.9?

-David

