Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC26D4EF8A8
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349535AbiDARJd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242995AbiDARJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:09:32 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128E836B5F
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:07:43 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id a16-20020a17090a6d9000b001c7d6c1bb13so3087565pjk.4
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jtEot92E1tB29snoZI4bxj37j8h8fzOPgNXWBl3sd1o=;
        b=srp5aSyzBqCFGgsTM9653BR8R/cCjRg5uEvYnKYG1U7R4R7CU4DF9T8VZdSsZH7PVH
         oVaiOLEH44dHGuCt7omnSC9gHFk6Hy+mBkb0nIMxm09/0s73kgJwoW1jU9NRFZygN69Q
         8gbc8DaMZzWirihOqTRxO5JXFzs/3A4sSsxWVcAYOBLAFLIAmmCSOccC2lEp9uVM2W5A
         oyiisH+Gufp0gkmwvzlEr+bdseazfCbJferl5JoAcqBmWbiCZv+/hQjtlJpQUtdgkdKR
         NGeN5lZgvutPsjRxkO9SBUO8zP09eZtUXaqqKwA15tBb2lZtvUbKQwhcqRKwtx61wxY4
         rRow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jtEot92E1tB29snoZI4bxj37j8h8fzOPgNXWBl3sd1o=;
        b=vhExCtVQGXjttu3i5yIDu0DiT08oT+90fsurJB32dNDCTp1JH7XPtDWTi8V3pwtQVo
         f6KC9MLsXighSbc4awusjJ4ClTTe/TBwyYqOcpIMPODzSISiY9dZVKg9DwqcYK5WOsDs
         ao9AmU2FO3sIQisKPa2P1cuqHqTIgnDYP1dRQl4LVgOdFKwPfi9XHma+9Mw+YDb5JSuf
         8xg1qChp2/MhES8wPFxRi8iTdOltuxS3kfF86GN4EwmzP0ttuqisI9JvmbAG0TB2HJMG
         IGPGyA2aTkwTnjIXNn1Bk5Xv8MBl5oHnqQqEQOHDhdQan0mAs5hM2nDPhsUVFaY6WFA/
         0Iug==
X-Gm-Message-State: AOAM531tgCeN45lFhIL6r5jnyCZHTvz7k1ibZ5wAucrWleBd/vbd1p3/
        prDTIDHBty0p9bsQ7wFo4oCja+sZvf4wODkG
X-Google-Smtp-Source: ABdhPJzZ+hsGY9FdceFKLN1LfHliorxPb2CTKJTjB/Qs06ibri0zwUxPCfJGWYORWkUYy1HpipvhCw==
X-Received: by 2002:a17:902:9043:b0:14f:aa08:8497 with SMTP id w3-20020a170902904300b0014faa088497mr11396034plz.109.1648832862452;
        Fri, 01 Apr 2022 10:07:42 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id w4-20020a056a0014c400b004fb0c7b3813sm3775518pfu.134.2022.04.01.10.07.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 10:07:42 -0700 (PDT)
Message-ID: <73ef2cba-706a-0b75-4b72-65fda595d1aa@linaro.org>
Date:   Fri, 1 Apr 2022 10:07:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 0/5] x86: uaccess CMPXCHG + KVM bug fixes
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
References: <20220401075311.707166-1-pbonzini@redhat.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20220401075311.707166-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/1/22 00:53, Paolo Bonzini wrote:
> Queued, thanks.
> 
Hi Paolo,
Where is that queued on? https://git.kernel.org/pub/scm/virt/kvm/kvm.git/ ?
I don't see it there.

-- 
Thanks,
Tadeusz
