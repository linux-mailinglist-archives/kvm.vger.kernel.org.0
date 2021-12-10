Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926F6470566
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240377AbhLJQU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 11:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239849AbhLJQU1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 11:20:27 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA214C061746;
        Fri, 10 Dec 2021 08:16:51 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id r25so31082423edq.7;
        Fri, 10 Dec 2021 08:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CmOuJC666DmMObmY+3mC4cPCi4XYj5hX14CuPHNGOWk=;
        b=DmFpd883owiGCEjXdA/a796iwKnSAw/Ift0m8bPotr0rHbYD2/wWfsMB0/UXTPeUh0
         1GmeYoHVp5O0fPrJZM3P8R+vJv0rm5RLEtlHMprS3ant2nOi3WmeYUh5AgutBjtT5hwS
         ZzbO2IVt/jQbNMyoX1PGCF1YhBDM6J6Qe0jtpxxubdtUBiAOWEm54FCVGAgJUjYIHux1
         mAFn4DUcawLIVVzT647UY6BDBXSIqlDzPf2svCaoIUrOQY+NuhsChEtDVtrZMShnU/9m
         939WxpBySPwKANZ3DLa6+xzvLY1tQk1A0VVEJ7gdT/iXNURn2XGC4OuyLVsG6uo7s+0x
         yzag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CmOuJC666DmMObmY+3mC4cPCi4XYj5hX14CuPHNGOWk=;
        b=rrcFnTipbb2IIXrVU7uyDzMbRrQtGh3Nr4XhWLZ4xY1mbYoKW+po4RPG4GAJK7yeMi
         m/5Dp1kLu+AeAXZBODKlgHM0AxW+vwPAvBE2dBunWh+rEikKDj5B9Iwwfb2aHqfVnhZZ
         8jZRbUXBQawQV/7skZXz+KKwHMrZGWFl7ax2AaDMYut+P/sF2E5dSgcurMfRnXWJ4Ydl
         g9JrdmN8+zCJbA7BeXif1XC233Jo1vl0jezAVhLarA/yrZnJR8jHz0sSL3PiQrEO6JAF
         a1Cys+mwB4ERabHalAu3lnFOGHvpmaMm1uoNCm0UPwY9gmZq13svydY6Du6hnsvgI56O
         rjsw==
X-Gm-Message-State: AOAM532L8tDSgfO0SHOJxlivt9P5k8IJ1JD/tpGtGdpWKDwtiK9IHzB0
        QgfqRcvBI5KOeoLpvw7n8pc=
X-Google-Smtp-Source: ABdhPJxDYdCcJGdeuMkFvgooJHg5hm4B7kgjY1gv44j0V83I5FAkcBjzgRB17g64czlfMBxkt3jvFQ==
X-Received: by 2002:a17:907:e8e:: with SMTP id ho14mr25403828ejc.12.1639153009059;
        Fri, 10 Dec 2021 08:16:49 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id gt18sm1707326ejc.46.2021.12.10.08.16.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 08:16:48 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <a0bfd816-f4f9-6b98-22cc-8edd3c126041@redhat.com>
Date:   Fri, 10 Dec 2021 17:16:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 14/19] x86/fpu: Prepare for KVM XFD_ERR handling
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-15-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208000359.2853257-15-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 01:03, Yang Zhong wrote:
> 
> The guest XFD_ERR value is saved in fpu_guest::xfd_err. There is
> no need to save host XFD_ERR because it's always cleared to ZERO
> by the host #NM handler (which cannot be preempted by a vCPU
> thread to observe a non-zero value).
> 
> The lower two bits in fpu_guest::xfd_err is borrowed for special
> purposes. The state components (FP and SSE) covered by the two
> bits are not XSAVE-enabled feature, thus not XFD-enabled either.
> It's impossible to see hardware setting them in XFD_ERR:
> 
>    - XFD_ERR_GUEST_DISABLED (bit 0)
> 
>      Indicate that XFD extension is not exposed to the guest thus
>      no need to save/restore it.

Can this instead just check if xfeatures includes any dynamic-save features?

Paolo

>    - XFD_ERR_GUEST_SAVED (bit 1)
> 
>      Indicate fpu_guest::xfd_err already contains a saved value
>      thus no need for duplicated saving (e.g. when the vCPU thread
>      is preempted multiple times before re-enter the guest).

