Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C542D33D9E7
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 17:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbhCPQzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 12:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbhCPQzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 12:55:24 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECF5C06174A
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 09:55:23 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id v15so10849310wrx.4
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 09:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iD5eKMA5qck02YJpK40L1u/BinpK4jz8TdIP1ofaw9s=;
        b=bOC4wbKHOthQ4nieE9WPOsV8RZd0pISDgKMXxKTjJTNwPV8xTg9IzKm5QWqUt2s6b3
         MC1WFhzJbnfH0qeJiZDLBzdmruN8sBsAhmv483m4FenXTkEiRKaEdCtEzdhE9IMP7w2c
         kuLPiaRJ6dNJ9Ff7qrEBlXnx/4ukVxjnk7h1TPBHFZIbKgLMjpDnoyT2bCSu9YwuSIkM
         lhvf7MhMcx+06+EH435h9J6T89dtauLkAMHeMvQI92d0piCsxNy/YBvosttEayqkpX8t
         /O2dt1mbs2h4YpxGJdXRGyNFsc+JUcyDu6KOw/ZuSUrgEDXT/F3euzH/N55ADwth1B5H
         5cbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:from:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iD5eKMA5qck02YJpK40L1u/BinpK4jz8TdIP1ofaw9s=;
        b=BE09QC3Kc0EVPSdNfWf1UxgZjdhLW/2XZU41A98fOSJQIe6zHo/CbL44+wsrNt7kld
         N1OR6WR/ioA/VHuKkRof/zd697l+ttwDTZnP9iI8VSZuQFDp/gevWBQlFz4IK7L7JYFJ
         jXpQ8fQoEvdvOs1Y6tqUe6jSj0cNuwcCayhe7f6nu5sOiX6tzQBYF6Q04NGPry7oIV1h
         hE/DEwolGW5NTkdQZdTixWoRvQFYWB6n61pJVMsLrTGH+I1udtP8WXyhvizu6oQQphGl
         UNbHSfOr49G+apU5RdVvzdGikK1P7x7+r7pQ2ASpLrczhb1VvqxGgVM3L1JwuumTPSDZ
         eaCA==
X-Gm-Message-State: AOAM532EeTbDz99nuCXBE/+DUk2K7RSr4e27t99c/PmsnIW7mlzPbxCm
        m3mteZrXMutMt6JQR+ik6Yo=
X-Google-Smtp-Source: ABdhPJy/lPLuRQTB0KeIVIo3TKpgn/NrXCj3f3LMdaOt8yLgDlcFtNtiPnwdQ98tE0iafhZZsaZkCQ==
X-Received: by 2002:adf:ec46:: with SMTP id w6mr5826179wrn.213.1615913722281;
        Tue, 16 Mar 2021 09:55:22 -0700 (PDT)
Received: from [192.168.1.36] (17.red-88-21-201.staticip.rima-tde.net. [88.21.201.17])
        by smtp.gmail.com with ESMTPSA id v189sm43110wme.39.2021.03.16.09.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Mar 2021 09:55:21 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH] target/mips: Deprecate Trap-and-Emul KVM support
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>
Cc:     "reviewer:Incompatible changes" <libvir-list@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20210312010303.17027-1-jiaxun.yang@flygoat.com>
 <6169a38a-884c-ed4c-141e-4d3974b6554b@amsat.org>
Message-ID: <ecdc800f-cbb3-5cc0-30f6-8db7bdefa2c2@amsat.org>
Date:   Tue, 16 Mar 2021 17:55:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <6169a38a-884c-ed4c-141e-4d3974b6554b@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jiaxun, ping for moving the section?

On 3/12/21 10:43 AM, Philippe Mathieu-Daudé wrote:
> +Paolo/Thomas/KVM
> 
> On 3/12/21 2:03 AM, Jiaxun Yang wrote:
>> Upstream kernel had removed both host[1] and guest[2] support.
>>
>> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/mips/linux.git/commit/?id=45c7e8af4a5e3f0bea4ac209eea34118dd57ac64
>> [2]: https://git.kernel.org/pub/scm/linux/kernel/git/mips/linux.git/commit/?id=a1515ec7204edca770c07929df8538fcdb03ad46
>>
>> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
>> ---
>>  docs/system/deprecated.rst | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/docs/system/deprecated.rst b/docs/system/deprecated.rst
>> index cfabe69846..a409c65485 100644
>> --- a/docs/system/deprecated.rst
>> +++ b/docs/system/deprecated.rst
>> @@ -496,3 +496,11 @@ nanoMIPS ISA
>>  
>>  The ``nanoMIPS`` ISA has never been upstreamed to any compiler toolchain.
>>  As it is hard to generate binaries for it, declare it deprecated.
>> +
>> +KVM features
>> +-------------------
> 
> "------------" else Sphinx complains.
> 
>> +
>> +MIPS Trap-and-Emul KVM support
> 
> Missing "since which release" information.
> 
>> +
>> +The MIPS ``Trap-and-Emul`` KVM host and guest support has been removed
>> +from upstream kernel, declare it deprecated.
>>
> 
> What about adding an accelerator section and add this as a sub-section?
> 
> -- >8 --
> diff --git a/docs/system/deprecated.rst b/docs/system/deprecated.rst
> index a4515d8acd3..9c702a4ea7b 100644
> --- a/docs/system/deprecated.rst
> +++ b/docs/system/deprecated.rst
> @@ -292,6 +292,15 @@ The ``acl_show``, ``acl_reset``, ``acl_policy``,
> ``acl_add``, and
>  ``acl_remove`` commands are deprecated with no replacement. Authorization
>  for VNC should be performed using the pluggable QAuthZ objects.
> 
> +System accelerators
> +-------------------
> +
> +MIPS ``Trap-and-Emul`` KVM support (since 6.0)
> +''''''''''''''''''''''''''''''''''''''''''''''
> +
> +The MIPS ``Trap-and-Emul`` KVM host and guest support has been removed
> +from upstream kernel, declare it deprecated.
> +
>  System emulator CPUS
>  --------------------
> 
> ---
> 
