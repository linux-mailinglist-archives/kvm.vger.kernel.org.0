Return-Path: <kvm+bounces-150-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56B987DC55D
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 05:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1313281730
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 04:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55FD10797;
	Tue, 31 Oct 2023 04:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UlrKCvg4"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14570101FA
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 04:30:39 +0000 (UTC)
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1ADC9
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 21:30:34 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-507bd64814fso7236690e87.1
        for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 21:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1698726633; x=1699331433; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/zl+WazKFc5HhMN50LZss0tyvIWhNvX+UxT2FffeptI=;
        b=UlrKCvg4SNog7i3djl+bZ1M2KZy4D/I8e00XF90nlvN+nHWxNhH6apfSPD057gimTF
         9nKXZ01W5wMNftC9Wz8oS141j9O579wVML6bdsTC4xY3oN5w+FNTcT0Z+IXvMwnpQUYM
         GWGe+apHKlVO2MzmzaLBFqjZCasgYWx6XRwr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698726633; x=1699331433;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/zl+WazKFc5HhMN50LZss0tyvIWhNvX+UxT2FffeptI=;
        b=RDK1E40/cjVCbygz1Fk8ZwiZcddYxzqeysNBgple1pvLJ1tBlv0pKJLpy9D/PB4yHs
         78Ml2Mr1Wx5tcsABf//NtcIuoMK2+skpPYBwz3JDA3i94haAvYoXkX3ztzG7tuHXXivj
         YEkvSJrTucBINJcULxVxW7MVP+3uWhFuP0B13CJGcryiSbwCFeJDe5PNzL+L1SoiQEZt
         8oZV2BO/bsJybTbix6oqrzFFaw5EqcxPSOReNxfYrBTn/x0sXRhbkliTZdSLJyrjrgqf
         roKvyaO5HVJ/NnexB5m0yVhLa5Z+Nvji+LFDkWPmJevxen9SPIIbpidNGRLmidMvAJVr
         fqBw==
X-Gm-Message-State: AOJu0YxvgL2femYYTqi3BpF9GLzTgkf3UNV5xwl+SAYhQ/3jq6wckDUA
	t8FnvGsZXI+0t8WYpiLRGXIS7L23EBLyJpp5AP1ZjraZOb7Qz1xyc24=
X-Google-Smtp-Source: AGHT+IFkFMOcoKydhMu+wv2rhPuSAm4i0gRv+cc6pol6A8loPI1tW7TBI4rukvH4Ja1NFYXKJiMdHv7K9smM18sVk1M=
X-Received: by 2002:a05:6512:48c6:b0:507:9fa0:e247 with SMTP id
 er6-20020a05651248c600b005079fa0e247mr8045647lfb.32.1698726632783; Mon, 30
 Oct 2023 21:30:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230911021637.1941096-1-stevensd@google.com>
In-Reply-To: <20230911021637.1941096-1-stevensd@google.com>
From: David Stevens <stevensd@chromium.org>
Date: Tue, 31 Oct 2023 13:30:21 +0900
Message-ID: <CAD=HUj5733eL9momi=V53njm85BQv_QkVrX92xReiq0_9JhqxQ@mail.gmail.com>
Subject: Re: [PATCH v9 0/6] KVM: allow mapping non-refcounted pages
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Sean, have you been waiting for a new patch series with responses to
Maxim's comments? I'm not really familiar with kernel contribution
etiquette, but I was hoping to get your feedback before spending the
time to put together another patch series.

-David

