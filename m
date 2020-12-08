Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A232D35DE
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 23:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgLHWGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Dec 2020 17:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731078AbgLHWGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Dec 2020 17:06:49 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED7DC0613D6
        for <kvm@vger.kernel.org>; Tue,  8 Dec 2020 14:06:08 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id x13so240441oto.8
        for <kvm@vger.kernel.org>; Tue, 08 Dec 2020 14:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MGDLM4skllCoDmoEk+etig/If787U2zDrg6DgpVHTno=;
        b=rCbe3+/XPmFCHDirAutZtQSLmnLl65wBbcvTbTFXLlZlFTp9AE2BNM6Ul60D08tvcD
         CNAx8B4GZtXOK1Oo0q+S9KlZqhuKlEp2U3uvf4Ml0sBI6TJi52q2d7yjPBio8ti7GUJK
         eAWbq4kY6Z8Nsi1gfv3EjB3b9B/jU+YjgQvqFmXWEasC1FbKZVkaxGGBMh9GQmQjz2jc
         1fzAdeIm5jrwlv7lWXzGfsxSdw2/OgooajyXd47RbE8fdhaB195pDmCQ5U0Crb3W6M0O
         syfgAMnoX12iNiy31MIJQjflGIs15eb9980yA+YquFtTjGFv+J1I3MQtDHGjYbcorMK4
         NzeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MGDLM4skllCoDmoEk+etig/If787U2zDrg6DgpVHTno=;
        b=lQghzJ2j1Xv3WaVDXnkD6tY37RqkFMJzoeHONt6YcXfAb6AblL9wACR+z8O+CNiLOx
         AZGb1UL+JMyDvVfrMhUhcio2XYSbR4e/UWo4nqWgk+C7LcvV734m/UXZKq+cmiq0RhYI
         QwZXe3xn3mIq8KkefdEzVqY7u/wJMw9C3neNhWtDpDVwSU3sXVsyqC2yIXg0lK05Zaxh
         +b55/EQmR9DAGXC+KGfcL6Ynf7AwU/7b2P7SblHwtb7jLeuf01xDsgTHqx+/cx/Hqagf
         i/60FsT2SlmLVZoldAeoUJ+x1UdriP2YkABiBa7FDEGp6OplQOQLqcBk0NKbableHE/Y
         I9Ww==
X-Gm-Message-State: AOAM531uVU9qRkDJA072tQVVd9shp8zNMcJAwFqkj3kRxATp7QxVb9RN
        lE1OMR5BSWL+p6QBPudh0GLsNQ==
X-Google-Smtp-Source: ABdhPJzGu1vkEQl9iHAF95ayPIF0SsoBWDvRps0GQgPBGBv+W0ifzemthuvGb0R/rvlhUEiyqT4DYQ==
X-Received: by 2002:a9d:19cf:: with SMTP id k73mr148076otk.360.1607465168294;
        Tue, 08 Dec 2020 14:06:08 -0800 (PST)
Received: from [10.10.121.52] (fixed-187-189-51-144.totalplay.net. [187.189.51.144])
        by smtp.gmail.com with ESMTPSA id l142sm25265oih.4.2020.12.08.14.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 14:06:07 -0800 (PST)
Subject: Re: [PATCH 11/19] target/mips: Extract common helpers from helper.c
 to common_helper.c
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20201206233949.3783184-1-f4bug@amsat.org>
 <20201206233949.3783184-12-f4bug@amsat.org>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <ac8afc12-2ab4-a2a3-81b5-b9d75314bf6f@linaro.org>
Date:   Tue, 8 Dec 2020 16:06:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201206233949.3783184-12-f4bug@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/6/20 5:39 PM, Philippe Mathieu-Daudé wrote:
> The rest of helper.c is TLB related. Extract the non TLB
> specific functions to a new file, so we can rename helper.c
> as tlb_helper.c in the next commit.
> 
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
> Any better name? xxx_helper.c are usually TCG helpers.

*shrug* perhaps cpu_common.c, no "helper" at all?
Perhaps just move these bits to cpu.c?


r~
