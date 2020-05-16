Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA371D609D
	for <lists+kvm@lfdr.de>; Sat, 16 May 2020 13:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgEPLzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 May 2020 07:55:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37332 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726244AbgEPLza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 May 2020 07:55:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589630129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=erfjzqOuUiVfB794M6kP1tZ4CPJtvAiKcW2ogPScaak=;
        b=jTYHRMxFIq2yBoRO6FtoFww8h93Kl8HaIYX/0w1GSgnjmGhkgisQ63p7K3XBWNZvQMRKh5
        1zDZ7lbGWrI2lX3NAu/Y4ZDwdMbzY7eX3egTXx7mSUTiZ3hQtOthBqu+H+KU4Ls2ZS+N5p
        v2DtOo8PbUaGNYOFyzSCPyOcu588RG0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-gaMTHf4yNJqk8u74KM1q2Q-1; Sat, 16 May 2020 07:55:27 -0400
X-MC-Unique: gaMTHf4yNJqk8u74KM1q2Q-1
Received: by mail-wr1-f72.google.com with SMTP id i9so2618908wrx.0
        for <kvm@vger.kernel.org>; Sat, 16 May 2020 04:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=erfjzqOuUiVfB794M6kP1tZ4CPJtvAiKcW2ogPScaak=;
        b=WzkC6QmCggOTwb0lmqjqwiBgdlUhfJwUlifOiSShzZRaobbPEM3vQS0lRlXpKKXPPe
         G2/Ete9rMTcpDzizjCVNwfY30b6Q50u+CveK0NP7d4krSoRJ73DxMUxPwRe5YWAmnQGS
         KDf+Mmujkpun+WFxObqpuxu5SUnntgkAt7ujkMeU1vRGvEQVXgbKlNBvll8ySQIAQLJD
         XW5gm5BWhdzkY2OX2xPf6NVxF1NtSedTys4UvsbrWOgajHl0HF4e3AKFLP4o96fPWndr
         s3sAwBjZZzqH463DRbOatAl/n0mhGEatiBgGxqaQxboqRttsYKUeP6frbHCMmYePvl1d
         rywA==
X-Gm-Message-State: AOAM531zSy2ZoPO2ZIS78xcZFinF9fEO8ZLjx3J5NaN2BEcETli3f9L0
        qON6DrK0scATYTn+AaHNJJiOaIcLAicm7LnxXi8MqUZsXUNCFWHSvJuuMz4V646Qbz6zSq7AgKI
        rtOjK7LgXMv/0
X-Received: by 2002:a7b:c193:: with SMTP id y19mr8936344wmi.158.1589630125826;
        Sat, 16 May 2020 04:55:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyx0u3Wf3M+dvD4mI+q/+PzHBMijrTsiO0tpb+a082mvbkOA8Q+PkdCA/N1eOKSzvq67xudIw==
X-Received: by 2002:a7b:c193:: with SMTP id y19mr8936328wmi.158.1589630125560;
        Sat, 16 May 2020 04:55:25 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.248])
        by smtp.gmail.com with ESMTPSA id u65sm3097357wmg.8.2020.05.16.04.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 May 2020 04:55:24 -0700 (PDT)
Subject: Re: [PATCH V5 15/15] MAINTAINERS: Update KVM/MIPS maintainers
To:     Huacai Chen <chenhc@lemote.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        kvm <kvm@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        Fuxin Zhang <zhangfx@lemote.com>
References: <1589359366-1669-1-git-send-email-chenhc@lemote.com>
 <1589359366-1669-16-git-send-email-chenhc@lemote.com>
 <AC9338A0-F449-4DCA-A294-248C86D57877@flygoat.com>
 <CAAhV-H7OTeMy2Yp2PunD+2KVzzPDT+-xGGgbpRNzhb8C-p8-7g@mail.gmail.com>
 <20200515211353.GB22922@alpha.franken.de>
 <CAAhV-H58G7+se6VTBMo2R4joDXngF-c_W=fh8=zD8rVnono=gg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1a22adb0-0b7a-24a3-e762-7b9919a70a8e@redhat.com>
Date:   Sat, 16 May 2020 13:55:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H58G7+se6VTBMo2R4joDXngF-c_W=fh8=zD8rVnono=gg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/05/20 11:36, Huacai Chen wrote:
>> I'm happy to see you taking care of the KVM part. So how is your plan
>> to handle patches ? Do want to collect them and send pull requests to
>> me ? Or should I just pick them up with your Acked-by ?
> I think we can only use the second method, because both Aleksandar and
> me don't have a kernel tree in kernel.org now.

If you don't mind, I generally prefer to have MIPS changs submitted
through the KVM tree, because KVM patches rarely have intrusive changes
in generic arch files.  It's more common to have generic KVM patches
that require touching all architectures.

For 5.8 I don't have anything planned that could cause conflicts, so
this time it doesn't matter; but I can pick these up too if Thomas acks
patches 6, 12 and 14.

Thanks,

Paolo

