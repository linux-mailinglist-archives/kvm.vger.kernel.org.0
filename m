Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052DD76BF77
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 23:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjHAVqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 17:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjHAVqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 17:46:11 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB091FDA
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 14:46:10 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-31765aee31bso5495551f8f.1
        for <kvm@vger.kernel.org>; Tue, 01 Aug 2023 14:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690926369; x=1691531169;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QBJ9WpbYJ/9qOaI7YWlwMfT+OlnFuNzR3c7GpYDGEyY=;
        b=PTWbpTp5jpO9QVEY//FoVDp9MyVOi1s3eaWW2v9LHdseq8sUDKYDN2xvI6wmQqXe84
         Q2bHqmk9dlN2pdK+42rXWMUoGlm+UG5pY21oCFkeC34zJmirsqhfYHNPaZskY5UL/R8p
         oOjwoqzcMPZ3wp8Z0xmv5X23Rp/9ybrOoc56daS7XzZjcFFYQbIE2ZcLva45HK+GH+83
         aKlUuk/f3VZ498WxyA8+uqMsqf/kgrXvN/Q7+kGugeUID67K5s/5RLT27GXKTEjxXPSG
         wI52K7fvRNHJduX+pBRopySDrgerXFWO4UoHKL39Lab5UMAvKGwZBuG5zjyXiVYNwMDi
         0rVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690926369; x=1691531169;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QBJ9WpbYJ/9qOaI7YWlwMfT+OlnFuNzR3c7GpYDGEyY=;
        b=ZY2RaK7x/y45A1C/ioJjGHpZOkBgdDnQHwRHlqwl8A/A2aIkD4vMixeqGhWS4Mkvs7
         Nn8+EOkbtR0Q9ZfYDSKgiRLGlVUwIQz18qTI/ghmZL/TcW7Hlqhs+yji0cgdwXz4E/W0
         moikBwVNiCX3OXjsnPIePCYHULAsENTjbOl5h0/fpxVXwtOVh1v/0xgPp84/vWAt1qiI
         d0gByMxP0xBEC6cSRJ95+tCKjmWg9XMwotdfSPio+RkazEA80W0OS2u3CBEoaAbFnhXi
         uymWtYk3ihPl0/FaF2K3qUUg8Yj9dY0x5X8QsbFta//qj0Vwjnm50nB20auyoLthlCt+
         mzvA==
X-Gm-Message-State: ABy/qLZingiLtn0yHuV9aVMksybwasBR23SEiTRbZpMLjphvoBzC/YPa
        TCP08EVhrQt6/LLAVtYhoRgXkg==
X-Google-Smtp-Source: APBJJlGlOALsCc5aS8SVhmHPl504oepavvxMjaNckYhr1oXtbiuKXAOQdX6os7LZQQg73XZLcDPvzg==
X-Received: by 2002:adf:e88f:0:b0:314:35e2:e28d with SMTP id d15-20020adfe88f000000b0031435e2e28dmr3015966wrm.13.1690926369066;
        Tue, 01 Aug 2023 14:46:09 -0700 (PDT)
Received: from [192.168.69.115] ([176.176.174.59])
        by smtp.gmail.com with ESMTPSA id s6-20020a5d6a86000000b003143add4396sm17072761wru.22.2023.08.01.14.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Aug 2023 14:46:08 -0700 (PDT)
Message-ID: <07c4b978-4ad9-c9ff-38d1-d24f4c701dd6@linaro.org>
Date:   Tue, 1 Aug 2023 23:46:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH for-8.1] Misc Xen-on-KVM fixes
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Paul Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Anthony PERARD <anthony.perard@citrix.com>
References: <20230801175747.145906-1-dwmw2@infradead.org>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230801175747.145906-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/23 19:57, David Woodhouse wrote:
> A few minor fixes for the Xen emulation support. One was just merged, but
> there are three outstanding.
> 
> David Woodhouse (3):
>        hw/xen: fix off-by-one in xen_evtchn_set_gsi()
>        i386/xen: consistent locking around Xen singleshot timers
>        hw/xen: prevent guest from binding loopback event channel to itself
> 
>   hw/i386/kvm/xen_evtchn.c  | 15 +++++++++++----
>   target/i386/kvm/xen-emu.c | 36 ++++++++++++++++++++++++++----------
>   2 files changed, 37 insertions(+), 14 deletions(-)

Thanks, since the series is reviewed, I'm queuing via misc-fixes.

