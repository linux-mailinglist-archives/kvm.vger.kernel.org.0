Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFFC939C252
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 23:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhFDV0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 17:26:42 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:46020 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhFDV0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 17:26:42 -0400
Received: by mail-pf1-f175.google.com with SMTP id d16so8324612pfn.12
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 14:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9cuhrvDS6Oe5GMt/RbqcFA1uOEgOG8TedSRL9cEKj0s=;
        b=KYHKemfT5uXSGq2Bs5e0FsKHXbXy0Zi6BFBz/9YFv8qQzhc+quflSUgmlandV8qRGO
         v+x1WBCiYAMGZRdHleNn17i+JRspq4DAfXcJTlYsXnmtT8SBbbaycT+ZJfOJrvUACti0
         pNzB1/mrMsfrNFtw7zl63/bDz+P68RKFV97mAfTyK8XUvBuOOYxxjU5AyJf6YzOR7iEK
         EPZYrdFKSIUQWTK/vrQrvBpFMnMdZbgMP3n5gGKd+qyGkboUoIJElyVYqez660LG7Wei
         5o/JhKZIadSRrVNCzD/L0EtpaKNTMKdGYLGQr+Ny3pI+2RecR/YKPpGdQD0FwcRaiKI8
         nJoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9cuhrvDS6Oe5GMt/RbqcFA1uOEgOG8TedSRL9cEKj0s=;
        b=QSf9Yleu3/scCFFOuyAV1zU2heE2AqBjrSepsIH34TKaV9s1yLY+ejdXdfPjXW0aVQ
         uRfEztQhi1f+e4SNptKxnpL+xfAEdQ/uvHQ0eQWaNSoJLlSWS1kUcpuwP4Twt1C31zsN
         4qHgCuZiz3xbYaZ1Au7vSoIuSxJl+olmQbhsSAupYQoNpCvqs+yDFKTmDEWXV+quQzy8
         etZ2g3gMXX/F9yknVlKpRiwq2Mg8uIb6P41T3hSZhDA0q8b0VNQWS5rPz6B2BXXuh75f
         jah8Ph05r1dzpYPFbFPJtf5fSVO288n3ADP8tfEM3UaBNwmbiU7+i1vjkzCDJet4epeR
         osDw==
X-Gm-Message-State: AOAM532nFt+ci92PaUY2xN98qSJnbm5G3qlrTDZS3ieHsmjBGNoXNl5f
        pk0ohzN/L2HnbdJ+dd3P4fGNx8e5Y8jg4Q==
X-Google-Smtp-Source: ABdhPJw81vFVqevyqxlInxIsaWlqOCpKcznYnzdut0ki8lpzpvUPoqMu5anyNtvxgRr+gUB8TEzg0A==
X-Received: by 2002:a65:4948:: with SMTP id q8mr6843725pgs.375.1622841835185;
        Fri, 04 Jun 2021 14:23:55 -0700 (PDT)
Received: from [192.168.1.11] (174-21-70-228.tukw.qwest.net. [174.21.70.228])
        by smtp.gmail.com with ESMTPSA id n23sm2696786pgv.76.2021.06.04.14.23.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 14:23:54 -0700 (PDT)
Subject: Re: [PATCH v16 14/99] accel: add cpu_reset
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc:     qemu-arm@nongnu.org, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "open list:X86 KVM CPUs" <kvm@vger.kernel.org>
References: <20210604155312.15902-1-alex.bennee@linaro.org>
 <20210604155312.15902-15-alex.bennee@linaro.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <3dfdf0a7-8113-3162-fe00-f497f1191d48@linaro.org>
Date:   Fri, 4 Jun 2021 14:23:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210604155312.15902-15-alex.bennee@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/21 8:51 AM, Alex Bennée wrote:
> From: Claudio Fontana<cfontana@suse.de>
> 
> in cpu_reset(), implemented in the common cpu.c,
> add a call to a new accel_cpu_reset(), which ensures that the CPU accel
> interface is also reset when the CPU is reset.
> 
> Use this first for x86/kvm, simply moving the kvm_arch_reset_vcpu() call.
> 
> Signed-off-by: Claudio Fontana<cfontana@suse.de>
> Signed-off-by: Alex Bennée<alex.bennee@linaro.org>
> ---
>   include/hw/core/accel-cpu.h | 2 ++
>   include/qemu/accel.h        | 6 ++++++
>   accel/accel-common.c        | 9 +++++++++
>   hw/core/cpu-common.c        | 3 ++-
>   target/i386/cpu.c           | 4 ----
>   target/i386/kvm/kvm-cpu.c   | 6 ++++++
>   6 files changed, 25 insertions(+), 5 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~
