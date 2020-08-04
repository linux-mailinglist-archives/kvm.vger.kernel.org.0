Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4051C23BC92
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 16:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbgHDOrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 10:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgHDOrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 10:47:12 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB174C061756
        for <kvm@vger.kernel.org>; Tue,  4 Aug 2020 07:47:11 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x5so2936243wmi.2
        for <kvm@vger.kernel.org>; Tue, 04 Aug 2020 07:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=r6kGfPE/KsV7nTfH/d4o6yMleyqMBQteeLYhE/uXEe8=;
        b=aVExCt4oLxLR9aFvpeWEL25FVcXyMBmA32sEnExxpKELRADyd/9R8grqfipU4KCnal
         xw/mDJ1vB99SSCGocIuUpjfn/n+6sq37uzwOBd9mLMKkVAI+lqriN5bX9rydaC5fOnbj
         0JtNaK5ZOpnv/jS7GrAf3KIXRvmO0w8y8UIlljMRS32B26TgTdXAdQygC7MBMHn5lvoP
         AxItZMMHNLnLZ4HD7gvVz87UAMtI4b+WfUKZPyuyAhPhQZn3H0V7TXQuP4XID2r4pBE8
         0WVBskw0itNLwIU1bhZ/+0X4da9muIyp02S9F8OzsA8dAJ6ZSM4dlKp55if4+eS/15qd
         3g0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=r6kGfPE/KsV7nTfH/d4o6yMleyqMBQteeLYhE/uXEe8=;
        b=e8DpY4GVTv1JpufDO2kZFKE2LiF9J6y4H60ucZ9KS9WBYjgYLkBzTen8T0myUybTgU
         mFjLfypPGq6Sm4jdnqRXxu/AHBzH19CadslIrnUnn+eMjcvgE5O5yIpktp0yqpuChtky
         M06BrxUSoKDvpG7byaMz1ytrKSGlUexOV4LXwM+meDkFBs0lAw8tABlx5U+jgTlJnRiq
         lyVZ6uxSUSZn0VrnAvxh+BK268/9vAxpjZziJAR+sIWwc8nf2XvoZSTLMl3QepYdIKnD
         vozEYTOAcy2LSw429u0pR01DtO3uwy3ahrsMrRLKgvVHOkVTu6sJJgJ9/O6uRNz8+mb2
         UeJw==
X-Gm-Message-State: AOAM532VjG0DCNNXKG2NIvQ7DKQEg3ltM1tQO8fnuBkWP4CrhAbuvYc/
        Y4zjbXxBx9BmK0VIXaGoVmp9NQ==
X-Google-Smtp-Source: ABdhPJygwsnCNO92emQNPWtLheZnx+hxAUxJL5JREQ4YEEZj8ftsQfnryzZlL6jATdGaMqcJvVKRKw==
X-Received: by 2002:a1c:f605:: with SMTP id w5mr4306747wmc.26.1596552430480;
        Tue, 04 Aug 2020 07:47:10 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id t25sm4403673wmj.18.2020.08.04.07.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 07:47:09 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 48B801FF7E;
        Tue,  4 Aug 2020 15:47:08 +0100 (BST)
References: <20200804124417.27102-1-alex.bennee@linaro.org>
 <CAMj1kXErSf7sQ4pPu-1em4AM=9JejA_-w3iwv4Wt=dgbQHxp-g@mail.gmail.com>
User-agent: mu4e 1.5.5; emacs 28.0.50
From:   Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvmarm <kvmarm@lists.cs.columbia.edu>
Subject: Re: [RFC PATCH v1 0/3] put arm64 kvm_config on a diet
In-reply-to: <CAMj1kXErSf7sQ4pPu-1em4AM=9JejA_-w3iwv4Wt=dgbQHxp-g@mail.gmail.com>
Date:   Tue, 04 Aug 2020 15:47:08 +0100
Message-ID: <87o8nqmpsj.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Ard Biesheuvel <ardb@kernel.org> writes:

> On Tue, 4 Aug 2020 at 14:45, Alex Benn=C3=A9e <alex.bennee@linaro.org> wr=
ote:
>>
>> Hi,
>>
>> When building guest kernels for virtualisation we were bringing in a
>> bunch of stuff from physical hardware which we don't need for our
>> idealised fixable virtual PCI devices. This series makes some Kconfig
>> changes to allow the ThunderX and XGene PCI drivers to be compiled
>> out. It also drops PCI_QUIRKS from the KVM guest build as a virtual
>> PCI device should be quirk free.
>>
>
> What about PCI passthrough?

That is a good point - how much of the host PCI controller is visible to
a pass-through guest?

AIUI in passthrough the driver only interacts with the particular cards
IO window. How many quirks are visible just at the device level (rather
than the bus itself)?

That said I think the last patch might get dropped as long as the user
has the option to slim down their kernel with the first two.

>
>> This is my first time hacking around Kconfig so I hope I've got the
>> balance between depends and selects right but please let be know if it
>> could be specified in a cleaner way.
>>
>> Alex Benn=C3=A9e (3):
>>   arm64: allow de-selection of ThunderX PCI controllers
>>   arm64: gate the whole of pci-xgene on CONFIG_PCI_XGENE
>>   kernel/configs: don't include PCI_QUIRKS in KVM guest configs
>>
>>  arch/arm64/Kconfig.platforms    | 2 ++
>>  arch/arm64/configs/defconfig    | 1 +
>>  drivers/pci/controller/Kconfig  | 7 +++++++
>>  drivers/pci/controller/Makefile | 8 +++-----
>>  kernel/configs/kvm_guest.config | 1 +
>>  5 files changed, 14 insertions(+), 5 deletions(-)
>>
>> --
>> 2.20.1
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


--=20
Alex Benn=C3=A9e
