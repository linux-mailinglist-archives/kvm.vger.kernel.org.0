Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D082EF7A7
	for <lists+kvm@lfdr.de>; Fri,  8 Jan 2021 19:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbhAHStT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jan 2021 13:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbhAHStT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jan 2021 13:49:19 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D71FC061380
        for <kvm@vger.kernel.org>; Fri,  8 Jan 2021 10:48:38 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id j13so6666052pjz.3
        for <kvm@vger.kernel.org>; Fri, 08 Jan 2021 10:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HC5S6uiz52SdHS4127LBAv50ulR12xwKquHmHvBIoYc=;
        b=qkVvn3PxYttJGstCfF5OrvnfLYmAwjWMnV2kTorVX17AJcHc0HmgBG/xd2cvv4UvLW
         qsZ3KT1kg0U8wUoaI/asS1NIF3zwO1qgULSuJFk6zrC/FtgmhLBgXSKMNLfly7CauAR4
         vMHyIdqKhJtghBcqTj3pRG+whY9N+tkFLMAg99AR49+d60BwjVHj/g2R1QgD0uiE8gbb
         TxxTaC4lw+L3v3Ja+b0zq3y96j6eYSh2UY47QyBO5xxSiBuD2JDPP025sRB+YqCFPcAu
         IlLrDbY55mqtUYozpTubfRJC6q4vbJ2TA2OsShypbLDkCJpXAtDErBVRVA93mvaOQi0H
         9iMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HC5S6uiz52SdHS4127LBAv50ulR12xwKquHmHvBIoYc=;
        b=F1jXN/vDjiufWmbboFjH4k3lYDb8UXSMfb+UBICtzJ4a6aOc8akI2cy5zRX43HApLG
         ONxbDj/NJcjJ2KeITBzw9MGGdYGGFuVKnZb1KjkupefNgrX4Slumg3B2k25GOZqPoCso
         CT2rfq447sWlW8uRCO3pz+EPG/fFeKQ5YHY9g+8xZgdWm4KnJg/Fj4oVrcyb9O+ZZf/T
         MVDKCHBkT8fTQERyp5WcL1wsrHGVQ67tRvMFdoPLeUDTPuyDLgERo9mWF+EdPv8Ui2sS
         KEAtZKXUAjuhICvS54PQPpQGVicMsGLQUYlgTG2xSzBCmc4JZdHwsdDviDzlfAtI9Ct0
         Aj1Q==
X-Gm-Message-State: AOAM532SznAlVFUTE9gPhPtbBh3KYgijrK4Wl0RmyrayotJRGlyrBIMQ
        zc8zjLSMlnxLN/itnHzTzYeK6A==
X-Google-Smtp-Source: ABdhPJwvxzSrqDVJ6/Kxg0c9EAy2XRNeftsg0G9A+00ngr+QY+Sua/D4qezhXXuEkYcBFhZOwRsJxA==
X-Received: by 2002:a17:902:9302:b029:da:f6b0:643a with SMTP id bc2-20020a1709029302b02900daf6b0643amr5150463plb.33.1610131717905;
        Fri, 08 Jan 2021 10:48:37 -0800 (PST)
Received: from [192.168.3.43] (rrcs-173-197-107-21.west.biz.rr.com. [173.197.107.21])
        by smtp.gmail.com with ESMTPSA id a18sm9845141pfg.107.2021.01.08.10.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 10:48:37 -0800 (PST)
Subject: Re: [PULL 00/66] MIPS patches for 2021-01-07
To:     luoyonggang@gmail.com,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Libvirt <libvir-list@redhat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20210107222253.20382-1-f4bug@amsat.org>
 <CAFEAcA-6SD7304G=tXUYWZMYekZ=+ZXaMc26faTNnHFxw9MWqg@mail.gmail.com>
 <CAAdtpL7CKT3gG8VCP4K1COjfqbG+pP_p_LG5Py8rmjUJH4foMg@mail.gmail.com>
 <CAE2XoE8YWYnvap+Ox7hWaKfpRjDS+vEKpP61F0w3NkkKse5_iA@mail.gmail.com>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <82897c46-5cf9-387a-1c08-0f1c219bd9e4@linaro.org>
Date:   Fri, 8 Jan 2021 08:48:32 -1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAE2XoE8YWYnvap+Ox7hWaKfpRjDS+vEKpP61F0w3NkkKse5_iA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/21 5:22 AM, 罗勇刚(Yonggang Luo) wrote:
>>> UnicodeDecodeError: 'ascii' codec can't decode byte 0xc3 in position
>>> 80: ordinal not in range(128)
> Can we always reading file in decodetree with utf8 encoding
> And convert all decodetree to utf8 encoding, and the problem should resolved.
> ```
>  scripts/decodetree.py | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/decodetree.py b/scripts/decodetree.py
> index 47aa9caf6d..8c9eb365ac 100644
> --- a/scripts/decodetree.py
> +++ b/scripts/decodetree.py
> @@ -1304,7 +1304,7 @@ def main():
>  
>      for filename in args:
>          input_file = filename
> -        f = open(filename, 'r')
> +        f = open(filename, 'r', encoding="utf8")
>          parse_file(f, toppat)
>          f.close()
>  
> ```

Thanks.  Would you like to send a formal patch?


r~
