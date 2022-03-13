Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B82434D75A4
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 14:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbiCMOA0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 10:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbiCMOAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 10:00:25 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E22A65D21;
        Sun, 13 Mar 2022 06:59:17 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j26so20048632wrb.1;
        Sun, 13 Mar 2022 06:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DWky33K6Y0O/p/r90X4QDbMSJtEVyL9s0D85CPRNbbA=;
        b=N4d3F57lKKmPfzj+S63dPGAMxEx01afR+DYwfPymyFP/zYzYDjPeNKO2jXLPU3iDSg
         Jidx3CGlGcUHrolfxaoRIL3F4TWX1Fc+VWTz0hXHS5VN2NZfD6qTVLuXeoeCCkSjDReP
         eCBTA046yawebOLCcEcCZVEvDOneZAsSJxpCEbyi8uZceLgPQlpdKfwB9w68m0K5GfTB
         yDJBW/EDwhjmYeIFify2+HqkSr23cBNQZ404cb2Wu1g8Knwzx0ia6aSHVD9qSag4Sn1m
         6qAKmg9mZFL03dlv4pHXLRt/YN9T7FxEiX0tArtj+EHs+zpqY5xifNe+kvtXzgxaGUs2
         lZag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DWky33K6Y0O/p/r90X4QDbMSJtEVyL9s0D85CPRNbbA=;
        b=EqTL1Hcw7q3vDPqmES4nQgwkrnh0GdkSTChfW6KsGlxOqEueI6PmWSIrZUjQNlciKu
         6W9Z7VfGIxMctAPYmmWuv4xjIZDQnf6NXQENA8LULD4a08MhxzW8E2AaFt5r7Hk+8mI8
         f3cJ8ewQdI+KJFYFStO7EWb7VI2PfbjPvh921QD3f9NjhJZXVxOHnFYDjHjGjL3aUogw
         6u/f6R4H/bPCRnN5I8UWzGsjZswes5h0tNdmmBVHgm1Ul3R+jfLR6C6wDQPF78f67mCq
         wuRw7vdyEk7LhVTCk5fSmcDT1MJ1EbYVnFpnDu1NB0zYAaJeAq/l5pfRrre6QXhF4BBi
         gX7g==
X-Gm-Message-State: AOAM531FybM1rIUlBbOvusBlsMhJbyv1Fm9RdJwkJeW0IAxriZam6Lrn
        FNoB+5CZ4DCSBi4zRzUUg4s=
X-Google-Smtp-Source: ABdhPJxiMSxV+Umu0xmDCDzSp4wleNexD38VN2/DdEZw1zbYHwDuwRSD4GwLypJE6KbyB8MOQEBdQA==
X-Received: by 2002:adf:fe4c:0:b0:203:a939:4aaf with SMTP id m12-20020adffe4c000000b00203a9394aafmr3187694wrs.301.1647179956199;
        Sun, 13 Mar 2022 06:59:16 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id z2-20020a056000110200b001e7140ddb44sm10976434wrw.49.2022.03.13.06.59.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 06:59:15 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <989deb94-0046-7f13-aa62-eee0c5db79fc@redhat.com>
Date:   Sun, 13 Mar 2022 14:59:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v5 007/104] x86/virt/tdx: Add a helper function to
 return system wide info about TDX module
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <0a942626c76824cb225995fcb6499fea51113d43.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <0a942626c76824cb225995fcb6499fea51113d43.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> Signed-off-by: Isaku Yamahata<isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/tdx.h | 55 ++++++++++++++++++++++++++++++++++++++
>   arch/x86/virt/vmx/tdx.c    | 16 +++++++++--
>   arch/x86/virt/vmx/tdx.h    | 52 -----------------------------------
>   3 files changed, 69 insertions(+), 54 deletions(-)

Patch looks good, but place these definitions in 
arch/x86/include/asm/tdx.h already in Kai's series if possible.

Apart from that,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
