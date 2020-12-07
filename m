Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465922D10F3
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 13:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgLGMuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 07:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgLGMuL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 07:50:11 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5639C0613D0
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 04:49:30 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id c1so687292wrq.6
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 04:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ff9dudwKzr9RKp54jL9aoNOKi5jGdTwCO9eItajzqEc=;
        b=IVnn0AIhYSHv9u87ESDdqrWomo8kk0nc3fiHqKd3Z2OYvGrnNORnRLycA+wMW3OxXU
         i6lHg/g70V4/Eh1GbmzzBu+eTDo7jWQzotzY7EauYa5GbqC3MzsIhhi7cuKQwVmksCmB
         SCFksi/MAgZsjMW3PNvykh23hQWI5O3JI2IunjSWwFZd7nZ25E/+KipY7naETB1ruucA
         ag4YHhUZaKjvx9yfLwOShMakGt6M4XRKTT/Wx8J3SvYzMPAmPBwoY76mfFykRdDirogi
         cItLxdSfduTJochct1rbUPWuXGXi587JGbyqkkyPJZ4skVxEo7Y4+7JVQ/YaQnL+8i0G
         SfZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ff9dudwKzr9RKp54jL9aoNOKi5jGdTwCO9eItajzqEc=;
        b=JdQHPKJBZU38JZ2zgIKcmJks7UhtrXSENCy+cmsILSh3Im6UcpwzHePXTKhES0BZCY
         6+dFbEP+vJg98jCPwY3XIBDsSH9DpIZGugpjqXIZPB+4+CSvcr0pG7u6Yasj5m8i4aMZ
         Y8RWu+jH7dT9QE2qxsAMq3E9hVJpKufj69YPK1vDCoPypyMZCwODR0zRI47yaOBBzjEp
         J+V40On+3vmA57And8sEbNBUkARGZaqU+H4UWlBXVJqcetkOZpEk5Vr/X1WIoBrWeAzt
         vjLZWZQb376pNhvuWJtgmDtsO/FdDFCMs41ay/5mxy113yYrF3tIgv9PmuiXMvU3qIU6
         p8SQ==
X-Gm-Message-State: AOAM533a0UvPsqxlqs+gWKGXAVbQfOSFxY2BBh9SU1FzqEopiL7ci/0v
        QUsiYm9EiPx0Vcw53iehOio=
X-Google-Smtp-Source: ABdhPJwlJ8CPD2Sept02Gb7oU5fhvYr05v1HXgF+3Qwi0gzpfCkIJhVHqwmIc3CsbfwKoxRa5ZdGEQ==
X-Received: by 2002:adf:8184:: with SMTP id 4mr16425617wra.63.1607345369527;
        Mon, 07 Dec 2020 04:49:29 -0800 (PST)
Received: from [192.168.1.36] (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id s13sm15034323wrt.80.2020.12.07.04.49.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 04:49:28 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [RFC PATCH 18/19] target/mips: Restrict some TCG specific
 CPUClass handlers
To:     Claudio Fontana <cfontana@suse.de>
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-19-f4bug@amsat.org>
 <88161f99-aae5-3b80-e8c6-a57d122a28c4@suse.de>
 <61618998-f854-a7df-301f-f860d9725f1d@suse.de>
 <3956df0d-a42e-f3af-d5e1-cf396ddcb795@suse.de>
 <5d11701b-31f8-cfcd-30f9-3eba62c3bab7@suse.de>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <92611fa6-b3bc-51d2-f90a-995b9cc99bf4@amsat.org>
Date:   Mon, 7 Dec 2020 13:49:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <5d11701b-31f8-cfcd-30f9-3eba62c3bab7@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/20 12:43 PM, Claudio Fontana wrote:
> I am adding to my cleanup series the following, so this is done for all targets:

Great! thank you Claudio :)

> 
> 
> Author: Claudio Fontana <cfontana@suse.de>
> Date:   Mon Dec 7 11:02:34 2020 +0100
> 
>     cpu: move do_unaligned_access to tcg_ops
>     
>     make it consistently SOFTMMU-only.
>     
>     Signed-off-by: Claudio Fontana <cfontana@suse.de>
> 
> commit 1ee8254b568a47453ab481aa206fb9fecc7c16f7
> Author: Claudio Fontana <cfontana@suse.de>
> Date:   Mon Dec 7 10:29:22 2020 +0100
> 
>     cpu: move cc->transaction_failed to tcg_ops
>     
>     Signed-off-by: Claudio Fontana <cfontana@suse.de>
> 
> commit 1a03124581841b5c473f879f5fd396dccde48667
> Author: Claudio Fontana <cfontana@suse.de>
> Date:   Mon Dec 7 10:02:07 2020 +0100
> 
>     cpu: move cc->do_interrupt to tcg_ops
>     
>     Signed-off-by: Claudio Fontana <cfontana@suse.de>
> 
> commit 6a35e8f4ee68923006bba404f1f2471038b1039c
> Author: Claudio Fontana <cfontana@suse.de>
> Date:   Mon Dec 7 09:31:14 2020 +0100
> 
>     target/arm: do not use cc->do_interrupt for KVM directly
>     
>     cc->do_interrupt is a TCG callback used in accel/tcg only,
>     call instead directly the arm_cpu_do_interrupt for the
>     injection of exeptions from KVM, so that
>     
>     do_interrupt can be exported to TCG-only operations in
>     the CPUClass.
>     
>     Signed-off-by: Claudio Fontana <cfontana@suse.de>
