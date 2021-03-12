Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271A43388DF
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 10:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhCLJnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 04:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbhCLJnZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 04:43:25 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50A5C061574
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 01:43:24 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id y16so4436544wrw.3
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 01:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8h8glkBqqtpkvy2AhsPWRlpRcgV8pFFmUg18MhJYKk0=;
        b=E58VM+sHTbocjWMCupuMUATvWSYmDs1bXTrkHLdYe7BRoXlqf6NRbW0NkEsInDugQf
         0i2G/RliYrZT+K3sDZ2G3/6k9exPYsqJNb0ZpzYT0+wZS9R+YgALoD8tuVWfWrpb2y01
         opCcf1mVXzWDfXQ86kRr92LaWWrwWaQGPZxax79reuXj7uELXCQQICstuCYdr5EyTMqZ
         hR3Rg9+NFStqFezf6HZAsY9Q5/s5lOEb/K7mHEflbNusH0sh9WwdzRr3+3sf3lfcRRGd
         a0OkMWYYlhaZNluIppkUCUMJVRoS32yRqEbSG7EwbvN274rKpC9nVeqwB7wbJQ7VNw3k
         9jTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8h8glkBqqtpkvy2AhsPWRlpRcgV8pFFmUg18MhJYKk0=;
        b=QWtWLa1g0yx407G365VcxTJ8naT+8gUip1WrXytW3sNkmMPJZ6rDNtuV4tcQMY7PvJ
         LN93a7rCS814C4XwWZl4QNRzSwNw7YL+4oFTvON3ML8qntR8bgrb3uM/x9p0syAwQwF6
         L+KJ7+pwz7ifkHd88h4vCnYv6dzr/GW3a+F6LruwRB+fbI/TJ2yHunw5MyNEHx89bsa4
         i1PrO8bbX9cYL7A9zQCndijC4tIBXttD+hvkQpmhkgDHzvQQmPLuGummErWLKxrz5UZx
         PxhUVN26GBBwJD2GciGPR8YrwPAqTsk06QhSPtxf2LLtJwbopueNayQLTUoFj8EaFGhf
         v9Vg==
X-Gm-Message-State: AOAM531Vcl5Cw1/Lr0DGac+Le6VUMvEzDIlJ9p5RDTjtRoZrvSPE3naf
        yQyjdqYkL2f3NVQ6QGFnLztQwgO3ogo=
X-Google-Smtp-Source: ABdhPJy3mo+qwWuc4FeGTvkAPy/8MSn0eNk+n9Yk4XiGMlX0g0BFbHQ31PE8+OCxYGIPwyM/xWuLHQ==
X-Received: by 2002:a5d:5047:: with SMTP id h7mr13548271wrt.111.1615542203282;
        Fri, 12 Mar 2021 01:43:23 -0800 (PST)
Received: from [192.168.1.36] (17.red-88-21-201.staticip.rima-tde.net. [88.21.201.17])
        by smtp.gmail.com with ESMTPSA id u20sm7793901wru.6.2021.03.12.01.43.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 01:43:22 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH] target/mips: Deprecate Trap-and-Emul KVM support
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>
Cc:     "reviewer:Incompatible changes" <libvir-list@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20210312010303.17027-1-jiaxun.yang@flygoat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
Message-ID: <6169a38a-884c-ed4c-141e-4d3974b6554b@amsat.org>
Date:   Fri, 12 Mar 2021 10:43:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210312010303.17027-1-jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Paolo/Thomas/KVM

On 3/12/21 2:03 AM, Jiaxun Yang wrote:
> Upstream kernel had removed both host[1] and guest[2] support.
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/mips/linux.git/commit/?id=45c7e8af4a5e3f0bea4ac209eea34118dd57ac64
> [2]: https://git.kernel.org/pub/scm/linux/kernel/git/mips/linux.git/commit/?id=a1515ec7204edca770c07929df8538fcdb03ad46
> 
> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> ---
>  docs/system/deprecated.rst | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/docs/system/deprecated.rst b/docs/system/deprecated.rst
> index cfabe69846..a409c65485 100644
> --- a/docs/system/deprecated.rst
> +++ b/docs/system/deprecated.rst
> @@ -496,3 +496,11 @@ nanoMIPS ISA
>  
>  The ``nanoMIPS`` ISA has never been upstreamed to any compiler toolchain.
>  As it is hard to generate binaries for it, declare it deprecated.
> +
> +KVM features
> +-------------------

"------------" else Sphinx complains.

> +
> +MIPS Trap-and-Emul KVM support

Missing "since which release" information.

> +
> +The MIPS ``Trap-and-Emul`` KVM host and guest support has been removed
> +from upstream kernel, declare it deprecated.
> 

What about adding an accelerator section and add this as a sub-section?

-- >8 --
diff --git a/docs/system/deprecated.rst b/docs/system/deprecated.rst
index a4515d8acd3..9c702a4ea7b 100644
--- a/docs/system/deprecated.rst
+++ b/docs/system/deprecated.rst
@@ -292,6 +292,15 @@ The ``acl_show``, ``acl_reset``, ``acl_policy``,
``acl_add``, and
 ``acl_remove`` commands are deprecated with no replacement. Authorization
 for VNC should be performed using the pluggable QAuthZ objects.

+System accelerators
+-------------------
+
+MIPS ``Trap-and-Emul`` KVM support (since 6.0)
+''''''''''''''''''''''''''''''''''''''''''''''
+
+The MIPS ``Trap-and-Emul`` KVM host and guest support has been removed
+from upstream kernel, declare it deprecated.
+
 System emulator CPUS
 --------------------

---
