Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27CF72850DC
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 19:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgJFRdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 13:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgJFRdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 13:33:50 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABB5C061755
        for <kvm@vger.kernel.org>; Tue,  6 Oct 2020 10:33:50 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id p13so8504914edi.7
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 10:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Uei1rIJa7Or3V2E+URLP6jV3aRThIaXwhLFaZDG2lGw=;
        b=Lt1bkpc+rhGHysBVwec0VVK133WquFpCa/3cfTsATF7AGpCGUPg5cPrKJEDCpWR+5V
         jC5zwzf0wlyZV3d9bhBAwNx6Ok5ZhrjmF//CpWlAbsoXU8Xxw9ELR4IDivrLaO43WlNx
         lzOr/MSM2ZuBAPqxSQlJH9lC4XuNykOlCpNBR+C4dIf5wWiEUaPVdv6u2aQ/+MaGYBlh
         9oj0KO6DifXKjoosFirKO+qTex+x5hrmhU7dH4rooqkdBuFpdtL5KyQZCIpqvw6Ts81D
         KzQC0cWt8i81Nup5f5P4UsmOJZVmROpSLuhGiYyJwZLCHOOLPuphYTRnQ+ohtx9CL0O2
         FU5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Uei1rIJa7Or3V2E+URLP6jV3aRThIaXwhLFaZDG2lGw=;
        b=pOCLEAu/0pjGhLuLcUX1AgqQ6Ezz+7/XqcM0WnDfk2V0TyS1/w96wLinbO5meOvPHF
         carLowToOS5hHGrtZiWuUqyxjfzhJPYmR+mqiOIGWgEtkir5h5lzQsOfahF/vOB/hXHR
         iCPnJUmfKtUjHPIDA51DdkK7MSV/K9KULDPRu26ZpZfMUyc8FUVxjtCmYLVQQ37mfiq4
         uA15rejjM5h1LzSQBKuNaEkhVQsRKHx3nESi+hWvKegrDLKbtJ5IG52+wR4llBi4/hFz
         1sXZ+BKaXcQ7MZDOytWlJxMAt4gkBay/JtBTV7/hEmu4dDmUdChw5K7TEmXx1dLfa3Cw
         SOTA==
X-Gm-Message-State: AOAM531/HmZlyktbPsCRzpWgDu80xaFdAXNTkmwvmDmwiAf5x6psrZ/e
        4vk0oL17k2rYWJfn+BYmha07OX99zL31fg==
X-Google-Smtp-Source: ABdhPJwTOWAuR0525siZkYZB0oOxC76JU9cysVbx8fXbyXU2utNtSuuxhFQvhIkqNuVjF+CvDrD0xA==
X-Received: by 2002:a50:ccc6:: with SMTP id b6mr6612392edj.329.1602005628753;
        Tue, 06 Oct 2020 10:33:48 -0700 (PDT)
Received: from [192.168.175.34] ([185.81.136.21])
        by smtp.googlemail.com with ESMTPSA id k18sm2626367ejk.42.2020.10.06.10.33.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 10:33:47 -0700 (PDT)
Sender: Richard Henderson <rth7680@gmail.com>
Subject: Re: [PATCH v2 1/9] s390x/pci: Move header files to include/hw/s390x
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     thuth@redhat.com, pmorel@linux.ibm.com, schnelle@linux.ibm.com,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        qemu-s390x@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <1601669191-6731-1-git-send-email-mjrosato@linux.ibm.com>
 <1601669191-6731-2-git-send-email-mjrosato@linux.ibm.com>
 <20201006173259.1ec36597.cohuck@redhat.com>
 <e9f6c3e1-9341-b0d0-9fb2-b34ebd19bcba@linux.ibm.com>
From:   Richard Henderson <rth@twiddle.net>
Autocrypt: addr=rth@twiddle.net; prefer-encrypt=mutual; keydata=
 mQENBFGuLC8BCADcAoWcnW9lTsDMzbO3MBU+KbiGaj5JPatEUscRDkQYM2fyNjJp2tIWDK5a
 n4yngeXB3eX61WbYR3QraRK8mlYLGxyAdHMEQfPipbqf3TmN043fssT2bc82ApJcs1zvLYgI
 rhMht7Dck7A0wNC1jo+ZjVVFig5gDTN7gOzaAdBtV8tVNUddwkLzzaGpfihhSD6U46NdqKOG
 Wlnn6TrkMy0QGdQ5NaXHkRlUjnnUTSW/nKfoxD+EI+A9V4sYOd8mc/TL4aJh/i/AiU57eLbo
 n17uQI6/VTWDUWl8USiz4x9c8vmqlywLx00tAFxxoRWqk4KVJlj+Sh0up/D/sJ+vPpgBABEB
 AAG0I1JpY2hhcmQgSGVuZGVyc29uIDxydGhAdHdpZGRsZS5uZXQ+iQFYBBMBAgBCAhsDBgsJ
 CAcDAgYVCAIJCgsEFgIDAQIeAQIXgAIZARYhBJyxjdr46EmtKvwWpK0ScMxN0CebBQJdweUY
 BQkP1h/pAAoJEK0ScMxN0CebqDsH/0YyfnXk+Dc++H37VCEKgRet2i1ATFzxRnifkvmdxha0
 V+PVptQ2fwSe+w3KxoFecD8W75nysmUjrU/FicW9yU5YRlGONPZjruG02/KzmhA5PzWJdYO3
 i/t0qRayvWIcX2qA/flsXEbmb/BbAFM05LQIdcOu74eiBFe5CBCOWBDJeneE1urIE0hSYxoh
 nCcG60ULrNj13ohZ4zAEluoY32qIo7/OPWmtR88cPrEbZT8k+RqgZbsotzaPT1/RlL74fL8k
 ofYfTgKAFH7eEy6fF2nzDp2GThVn+3sA62xtpSXUf/X1m75B40KOcq1EQbHypNTmBc1wt13e
 ibhPNEVX2am5AQ0EUa4sLwEIALITHfH3gciRNfQIe7awDTDvn6H3C6gDyCAnv5LiuLTLZiyK
 NZp3lNO3rPowyKrGT2RIDlumlqPgdeHzqEEX91YK0yk2vdFvwU04rJ4D+qRgdUPoeICLD1zo
 PwOv2FaY6Tf8dKYas1RHF5QU5yQNey8j7IYYoE2yGPn2PtBmvtmK4iLataUEvx0U385Zr+jf
 HscqwTiToryeDC8Io/9BsMvAssE5Yf5URS2nJ7LFOvc4njsQJPF1i9egBXaIloqv7p2hVCKJ
 Hl5UWIxitQ9QQIl6iU4LCpz8mVYTXwv48IAVpbUf7+ak9V9Kk3jCeQnlxCJBUHjUhoIzinbS
 JHPHtkkAEQEAAYkBPAQYAQIAJgIbDBYhBJyxjdr46EmtKvwWpK0ScMxN0CebBQJdweVIBQkP
 1iAZAAoJEK0ScMxN0CebGHUH/RtouOlWl6To97tQsTJUq/2YwmRpFOsvV0/zCX4fKBGAbeZi
 VaELSt2+3UEErA+n8HwbQmjJ6IrdhA9GustOpOyCcbLVSMwql/OlAwBtDzCcC8dTU4zcuY2a
 rGG2A8i5krU85G9r1wowVcWZBsdmW7/dKiNoadLQiig4bHNiSaV4ograas5efyEjqTxiY+yG
 hzPw5DK2kbp2co8iDF1vW0LWPeLFBinCgItcI9LvgHWaB3rwjOfvNpMn5m64SoQYHB8wbnid
 erAjOzkBzmqnfS1tAUr8mtESStEwrEmNv0ZoA6S0Wt+c9pyTr+BpG4OFlhj7ZI+Eh7zOrr33
 q9OBIdA=
Message-ID: <1c118c1d-8c9b-9b7b-d1ec-2080aaa1c1a3@twiddle.net>
Date:   Tue, 6 Oct 2020 12:33:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e9f6c3e1-9341-b0d0-9fb2-b34ebd19bcba@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/20 11:43 AM, Matthew Rosato wrote:
>> Looks good, but...
>>
>> <meta>Is there any way to coax out a more reviewable version of this
>> via git mv?</meta>
>>
> 
> I tried git mv, but a diff between the old patch and the new patch looks the
> same (other than the fact that I squashed the MAINTAINERS hit in)

git format-patch --find-renames[=<pct>]

Though I'm surprised it's not doing that by default.

r~
