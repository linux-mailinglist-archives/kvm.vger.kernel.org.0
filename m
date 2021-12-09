Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A24146F2AA
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 19:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242023AbhLISDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 13:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhLISDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 13:03:36 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55E4C061746;
        Thu,  9 Dec 2021 10:00:02 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r25so21635451edq.7;
        Thu, 09 Dec 2021 10:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Al9kg2F9KDqFvq3nxTcebEIzKXlYK2ZMwKvTrLWHJ6E=;
        b=AfxDwo47UvGMhAdm6Rw/BtUIa4RRpUznlxWNvCDi2EwKzRCRrPvpJmh+M2nKrIHif6
         RpHyhRpE97GWx32ojsr+vOQSd5ecRefy6O6Vid8OcOd0+D4p0Q2SoCBgR3rrAmmKahlA
         aUl3wft7sP5QEuN7iSZhH5rkRKaVK1peWM2Os+UDkvDQn533w9x1rcBKjnT9Nokfcqta
         Nef0h+w0lhpcQqN0kBurWFGd8S50Mwadf5HiHCGvZWYCzfgJ7NBAmJnNi6ZglYeTn5YH
         YVCRHEqPF2Ka7FDT6tHNM5M/dGc0icYZIyOfod4j1semrTFhGJ0HeqkSr+p8VomRXS/o
         2VaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Al9kg2F9KDqFvq3nxTcebEIzKXlYK2ZMwKvTrLWHJ6E=;
        b=5AB6sAbLikyoDLT8wE6RvQavy31tsCWKE0JQxK7lh7ApbK0ibQDhvKlw4+3xKiP/qG
         D7bVDuD0Ri80OSS5pHCkTByKHM8XMx7YHsaOH4VT0rp4bxD1wzUGGAUdvwV41928YFJH
         Tsr6E4NSOI62g/4j4u/oDzGLpWvMbu3y3F+ubf7kpIgi4mEcttHa5aNkk13OQn92Cst9
         VqeH7B8NqbyOhLQzQSuF5xteLKAuppggy0xllBKNuYvvCsKO2cOIqyZDOpFoPGyVZdXi
         NQVFRDTUQPW0ebVAGkUFVJGFt/1krmevcg3Ss22HvPLnxdK9Xq5Ahosbndx8l8qKOphL
         SENA==
X-Gm-Message-State: AOAM531fopJa3DSELYGcjDTKpUvsram+0fe/Zn23cKtwgDXzu8x136G6
        0wMZV2/CxfMzoLMXOZzLxRMaIqVhPS4=
X-Google-Smtp-Source: ABdhPJxaGNq1VOGmKW6I6GM+NsKqxWNzc1RuAQMRjvuCk3KwBPxNP9Ur2NQtkE54kPDyjrnXzFPGaA==
X-Received: by 2002:a17:906:7315:: with SMTP id di21mr14270348ejc.193.1639072703169;
        Thu, 09 Dec 2021 09:58:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id hs20sm259690ejc.26.2021.12.09.09.58.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 09:58:22 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <5549294a-b411-1279-dcd0-3977c19c928e@redhat.com>
Date:   Thu, 9 Dec 2021 18:58:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 03/12] KVM: s390: Use Makefile.kvm for common files
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "seanjc @ google . com" <seanjc@google.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anup Patel <anup.patel@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>
References: <20211121125451.9489-1-dwmw2@infradead.org>
 <20211121125451.9489-4-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211121125451.9489-4-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/21/21 13:54, David Woodhouse wrote:
>   
> -kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o sigp.o
> +kvm-objs := kvm-s390.o intercept.o interrupt.o priv.o sigp.o
>   kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o

"kvm-y +=" here (for both lines) would be nicer, it's consistent with 
x86 and avoids the question of what happens if you have both kvm-objs 
and kvm-y.

Paolo
