Return-Path: <kvm+bounces-240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E21A7DD5F7
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 19:23:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5E29B210B1
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 18:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F6F32230E;
	Tue, 31 Oct 2023 18:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3fk3zo8k"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C560222301
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 18:22:52 +0000 (UTC)
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811A5F3
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 11:22:49 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-507a085efa7so524e87.0
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 11:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698776568; x=1699381368; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yNbn0nmi0IqVQ4IpWpVaJD6qi4TEeoW4GIXp7b9ei9M=;
        b=3fk3zo8kUYXtJ8ChHhll6/VfrR6CSBgVBR4UsYsKZEql+oCl22c+aWmgr9hYS0kKUz
         7vrEhYnih9w2a062cQJOxHaqXYthboDuhVOQrCnhjT7X7XnQPJTQMkhadSTHbL7Q3Pf3
         m9tI5CLOPOoDB/ApPq6jAb+YDdqaT+cpGrYTIg3FWS48n0RGTmm2bNuvhOpRu9BikIWH
         zwnuetrRrJ2MT3UVXNMMntROIO+AlUkErLldhM+yu4RE7hfUZZUDMZzGaBTDgO61xnjO
         49rxbjzfxb5P4EmesiArNeGC8+1BhboKJPISuTM29YBSIzggjKHPYFw9qd3YM68aRrPq
         SDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698776568; x=1699381368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yNbn0nmi0IqVQ4IpWpVaJD6qi4TEeoW4GIXp7b9ei9M=;
        b=j66S1EDV8SW+CF9nL/fwugOrSF0+FvCVtyKeD7BpCOQd9KKjvK1rk167jAEFvZ3XxG
         1cISTknoMU+aCoCyZc9OdzC354w1ZADC6pjHxZFZZWI3FUcLqByPA//VD1ockW2+oCOR
         2DdcPDls3/Wj/JuY3d1Chy3sKd713Gl6ZiZUkD8DhrVAdV0ChsYR5vq38mzYCrtxQdM5
         HtPhiDQp2KAHhzix0PWwc+VEqXlkTn2RAHTZmKr6v95unJL1+lIIqa/xzcu+SeSe3hXh
         dewi9yTMotxjNYM1GkoCvzwHsf7CwBDKby6bN5cp/WXgO/NzjInLwBFEWEMVhCMQEbsI
         qTAg==
X-Gm-Message-State: AOJu0Yxq3wajU3ncTQjNW0S2SJSbRTgN9lD5bJycBd9ZjLwKLe3JON6e
	VAzOZR31oijPd0nw9Ue7QgDMiX7YjQw26mpQGK0NQA==
X-Google-Smtp-Source: AGHT+IGTXcJrR9gIpZ3pfibK0rEmUHff9yu1VdQGqVTRdXT8TAFS+Nsn3T3EY5iSL3a3rMGVUPH+DJbK+gEBSUwjVEk=
X-Received: by 2002:ac2:5e79:0:b0:505:6c73:ed08 with SMTP id
 a25-20020ac25e79000000b005056c73ed08mr74975lfr.3.1698776567507; Tue, 31 Oct
 2023 11:22:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231031090613.2872700-1-dapeng1.mi@linux.intel.com> <20231031090613.2872700-2-dapeng1.mi@linux.intel.com>
In-Reply-To: <20231031090613.2872700-2-dapeng1.mi@linux.intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 31 Oct 2023 11:22:31 -0700
Message-ID: <CALMp9eR_BFdNNTXhSpbuH66jXcRLVB8VvD8V+kY245NbusN2+g@mail.gmail.com>
Subject: Re: [Patch 1/2] KVM: x86/pmu: Add Intel CPUID-hinted TopDown slots event
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Zhang Xiong <xiong.y.zhang@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Like Xu <like.xu.linux@gmail.com>, Dapeng Mi <dapeng1.mi@intel.com>, 
	Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 31, 2023 at 1:58=E2=80=AFAM Dapeng Mi <dapeng1.mi@linux.intel.c=
om> wrote:
>
> This patch adds support for the architectural topdown slots event which
> is hinted by CPUID.0AH.EBX.

Can't a guest already program an event selector to count event select
0xa4, unit mask 1, unless the event is prohibited by
KVM_SET_PMU_EVENT_FILTER?

AFAICT, this change just enables event filtering based on
CPUID.0AH:EBX[bit 7] (though it's not clear to me why two independent
mechanisms are necessary for event filtering).

