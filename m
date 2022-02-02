Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B674A741F
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 15:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345246AbiBBO6a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 09:58:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55009 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230292AbiBBO63 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 09:58:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643813908;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kbSx8+zVxuV1hAhVwdVFKdkNhwLaEFdsXyyAUcSyxCY=;
        b=HjZlUJSnAgfdLKNEzLGdWjO6CWNo728YXEvOq5IV7Yd61BztSmldsksYZcgGEXQOt4m+Wo
        V62ZAMT63W49Yi4cbbYl8PF3k4U6BRBUo/omLGuOBbnS4xzRw6M70Udq2ZQDkJjOSXmf6c
        zefhHnjgWy3VOUQr1koSu4JXqIyTFlw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-At25io1sNFi0x812iBMs2A-1; Wed, 02 Feb 2022 09:58:27 -0500
X-MC-Unique: At25io1sNFi0x812iBMs2A-1
Received: by mail-wm1-f72.google.com with SMTP id r132-20020a1c448a000000b00352cf8b74dcso355719wma.0
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 06:58:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kbSx8+zVxuV1hAhVwdVFKdkNhwLaEFdsXyyAUcSyxCY=;
        b=CuV3spk2g1ZsYyn4B++ApPzE5CZ7yIQbEoCngKufOBnmYKhUxBTo9X18nW+QYnqY1E
         nnGq3enY1aO7k1ycbBBCdW6fcAZEFZcHqxATzuOdYNh6TybSicLm1SSmcDTRU5f5lzos
         YlTHuNArVMCeBoRf/ev6CwWMKc5Q7g7eqU0Rk9JpPM3PsjLlSt/Yq30OTW5KBz9Je6FV
         DStaaH2ujDb3lKZqUOnsENmkO9eatK+3Nj1fUT1bXh+K64Wrn4z9WsbF2Aq8AiVzQtbl
         LyepNM/X/oWWyJwdN2aAitQcvloWBG4tpx8D4BXnI7BT8970/NMgvWlfJi1Rgta4PuPA
         dVPQ==
X-Gm-Message-State: AOAM533LJK5/TPMxHe8PWxus5nufdByaHuyOI7CvO9M7sOu7+zFy8GQf
        8dlGSlPM+/KR2uo4j+cOMj3cjD1Uo3RCPsKYzUpu64ROw4EfUMLcgBKcWMX/RhJj9DZWqJMzCy7
        whdiULcCFshAh
X-Received: by 2002:a05:600c:1f15:: with SMTP id bd21mr6396851wmb.145.1643813906589;
        Wed, 02 Feb 2022 06:58:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx8cZy8w/TMcQ5Vhk87Qx5L3Fx0MaMgEgqgmwamGzXUabY78Xey6QEmEwRTCrIrSx8/F2ftiQ==
X-Received: by 2002:a05:600c:1f15:: with SMTP id bd21mr6396834wmb.145.1643813906361;
        Wed, 02 Feb 2022 06:58:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id k12sm17536791wrd.98.2022.02.02.06.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 06:58:25 -0800 (PST)
Message-ID: <9b2dcb18-4f40-2f4f-421f-366d578c93dc@redhat.com>
Date:   Wed, 2 Feb 2022 15:58:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [GIT PULL] KVM/riscv fixes for 5.17, take #1
Content-Language: en-US
To:     Anup Patel <anup@brainfault.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Atish Patra <atishp@atishpatra.org>,
        KVM General <kvm@vger.kernel.org>,
        kvm-riscv@lists.infradead.org,
        linux-riscv <linux-riscv@lists.infradead.org>
References: <CAAhSdy0C_RMVShk=vv7FRgmVRspBkVQfiCLx-4B6pYtLU10vZA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAAhSdy0C_RMVShk=vv7FRgmVRspBkVQfiCLx-4B6pYtLU10vZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/22 15:55, Anup Patel wrote:
>    https://github.com/kvm-riscv/linux.git  tags/kvm-riscv-fixes-5.17-1

Pulled, thanks!

Paolo

