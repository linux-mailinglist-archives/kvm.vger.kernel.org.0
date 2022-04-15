Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBC5502131
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 06:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349370AbiDOETI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 00:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236647AbiDOES7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 00:18:59 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646BFADD78;
        Thu, 14 Apr 2022 21:16:32 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id w7so6442436pfu.11;
        Thu, 14 Apr 2022 21:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=WgqlC4B3qMG6ofKgt8g9QvaVfZI34ggXxyBl7VbhHLg=;
        b=P/IpudsYnejWS2lvqYoEgUnOKizBaXf77Gn5ZYBN1rqEVm5xHVioxZYzW3zHtxXOzo
         59V/VciqOu/8jlwqqmrpszQksBGO981A6+oO1HEXqzDUc7i6+CT3iFlBGgIUV9j1oya7
         KJmOdd3QzUYuOYmjnOQZQAFjjEALECy+UACbOwAGGhvtcrg79NYDKLkYOVdo7T8YDIYu
         71VkgG7wZPwlErDuyz/XasXIpLYZVpUlFhLyaxuzQFWvkvQp936Zp47DlZ/yx7PWAeSb
         YvtsaTIIoFz4DPNxiBkrCmdte8ItXFeYEqRE87svSISgdjz4VlCNbqIEIKg/g0uTWJi0
         3jbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=WgqlC4B3qMG6ofKgt8g9QvaVfZI34ggXxyBl7VbhHLg=;
        b=yHFPPGskwtKx1C9i0dW7FlhgWpA9NIIXLMUMi2tarj8PRwWj5jCZ3DnDi1yMq//QFm
         27ZPT/gPJVAZHryABBwszubIEs17O6rna4Ty6Bg4PkvLypebbTyHZiuCJRTymKt3Lsbe
         /fCO3bfrArCNDct6p4EnCO0w+XHmiTeaBQFu1dlBwA87dycNufw43OKZO/G6588MMquq
         0J5TCjoIJNzxfrAKeVZqPKAaKg8qsQ+YQBU45lDuc4yY+Zn1ylSv+dpfZ4zqGYXBqHiB
         oMKTG/wfYqiUDqP/fN68FUKZlO6Qrl5OA86dHgPduhkr+5lDoO9bVWYHl1MIq8rOolnz
         6epQ==
X-Gm-Message-State: AOAM532T5qhzvN99I2kizR4NQ+aMgYXRvUX6qlV6CFAVbGuYvb1BhJCY
        P1Jkj8A46byykrd/Z784A8HztrXNJXk=
X-Google-Smtp-Source: ABdhPJxxLUurtE78/45nmuvqeu+iiew/DF/lmVOe1GjZqC5ZelrZc6XlJ8DalKGlrN3davgP7s/LLA==
X-Received: by 2002:a05:6a00:124f:b0:4fb:2608:78de with SMTP id u15-20020a056a00124f00b004fb260878demr6962862pfi.27.1649996191771;
        Thu, 14 Apr 2022 21:16:31 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id r76-20020a632b4f000000b003820643e1c2sm3215535pgr.59.2022.04.14.21.16.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 21:16:31 -0700 (PDT)
Message-ID: <541c7185-b131-157e-4589-940a9dee60c8@gmail.com>
Date:   Fri, 15 Apr 2022 12:16:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
Subject: Re: [PATCH 07/22] KVM: x86/mmu: split cpu_role from mmu_role
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     seanjc@google.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
References: <20220414074000.31438-1-pbonzini@redhat.com>
 <20220414074000.31438-8-pbonzini@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20220414074000.31438-8-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/4/2022 3:39 pm, Paolo Bonzini wrote:
> +	union kvm_mmu_role mmu_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);;

WARNING: Statements terminations use 1 semicolon
