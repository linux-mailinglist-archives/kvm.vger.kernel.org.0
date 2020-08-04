Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8500B23BD55
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 17:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgHDPkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 11:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgHDPkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 11:40:12 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C80C06174A
        for <kvm@vger.kernel.org>; Tue,  4 Aug 2020 08:40:11 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f1so37299303wro.2
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 08:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=+xqFoCQQoa6eAiMo50Uy9HC91LgUQEIMjIx3DBlCRwg=;
        b=UhxrF8BWf2l+4DIHmMKF00sQXo8svgIiLw4wfiT0UFAkEZGCKIqFtslV1c2kRtGlqQ
         nObO2HKC3Mj6IC+86y8xR8g+5888z59r/fHaEqxFhzK+3oWbidT5LallCb9JyDmgB9zS
         +ngxNEdKVlV3KMiZJ4ZMqrD8ew6SRgICco4g0fPoAYtGL4FxOZYROuRumhj1W7GqZckv
         7dmBPTMLO1R8Ei/Z8q55dDEP6OJc+R52TXXYErh7advHtW34287efJjtaZlKyTvm4TOY
         h5GmRLoCvngNzxR/BHnJxFbtL/yhw/IwGqibGjaIMr6h9rPOZTGy75dl3HwKRPYr2ijR
         eUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=+xqFoCQQoa6eAiMo50Uy9HC91LgUQEIMjIx3DBlCRwg=;
        b=Gu2g/m1fQzucy+bJFYdye/GyB7xxQ6pD8+XY2mqsiQpJVBd5qSFZEAAC37f2aejOEI
         wJNx13BbujtnHLhI2mndS4NIzbttbAubl1h9P7mKsA940xz9tqH4x0UPc87TBAkeLooH
         4vMuokMTvsEiOa9yx0JrIJE1lDeU9I/IyjaYyfG+0JEgQ6/KJasbwN5wUx0N4GQEA2Y3
         Y7gFuL+rsLArttbaR6HakUMlVpUJv0r8xNm+pAQu1aGvextfJmV1Dw8cKWAXLx2X+Q6y
         IekFrB9xCiTh0rLowttBytAje+tyntPUWVK0nF99TIfqItsdGykeQ+S8HyG46luxxLUz
         VzjQ==
X-Gm-Message-State: AOAM531pZUN+8tGEdUSqQIw7IPNlVDiBNaqBOW5NNavVxw3rU3msv5gd
        IVnGdamqShfkXLJJ659xeh8mVQ==
X-Google-Smtp-Source: ABdhPJzJKsRHYbdxphNd2Y+U/MaVHkKnNns4heTa05XV+GsGcSREvqMNGKYzebFV5HdOfY82dOrLMA==
X-Received: by 2002:a5d:51c3:: with SMTP id n3mr20350026wrv.104.1596555610319;
        Tue, 04 Aug 2020 08:40:10 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id a10sm30539397wrx.15.2020.08.04.08.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 08:40:08 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id A1FA31FF7E;
        Tue,  4 Aug 2020 16:40:07 +0100 (BST)
References: <20200804124417.27102-1-alex.bennee@linaro.org>
 <20200804124417.27102-4-alex.bennee@linaro.org>
 <f80cfa932a650d8f7e8fc02a1656b4c2@kernel.org> <87r1smmpw5.fsf@linaro.org>
 <b78f8715bbaec8fc728a85d614b00688@kernel.org>
User-agent: mu4e 1.5.5; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com
Subject: Re: [PATCH  v1 3/3] kernel/configs: don't include PCI_QUIRKS in KVM
 guest configs
In-reply-to: <b78f8715bbaec8fc728a85d614b00688@kernel.org>
Date:   Tue, 04 Aug 2020 16:40:07 +0100
Message-ID: <87lfiumnc8.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Marc Zyngier <maz@kernel.org> writes:

> On 2020-08-04 15:44, Alex Benn=C3=A9e wrote:
>> Marc Zyngier <maz@kernel.org> writes:
>>=20
>>> On 2020-08-04 13:44, Alex Benn=C3=A9e wrote:
>>>> The VIRTIO_PCI support is an idealised PCI bus, we don't need a bunch
>>>> of bloat for real world hardware for a VirtIO guest.
>>>=20
>>> Who says this guest will only have virtio devices?
>>=20
>> This is true - although what is the point of kvm_guest.config? We
>> certainly turn on a whole bunch of virt optimised pathways with=20
>> PARAVIRT
>> and HYPERVISOR_GUEST along with the rest of VirtIO.
>
> Most of which actually qualifies as bloat itself as far as KVM/arm64
> is concerned...

So here is the question - does the kernel care about having a blessed
config for a minimal viable guest? They are certainly used in the cloud
but I understand the kernel is trying to get away from having a zoo of
configs. What is the actual point of kvm_guest.config? Just an easy
enabling for developers?

>
>           M.


--=20
Alex Benn=C3=A9e
