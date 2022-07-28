Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D000C5846F3
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 22:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbiG1URl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 16:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbiG1URg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 16:17:36 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBF577561;
        Thu, 28 Jul 2022 13:17:35 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v17so3556751edc.1;
        Thu, 28 Jul 2022 13:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ak/yZTzpgIpJQtD3WljhsD5fouvH+uomdrADi70BHVM=;
        b=ixZyFAdcGtxnZpyaCmt9Oesw0zIva2L+SI9fpMV88n2PleVuncVjFahbO2RmDl2rqU
         vvwH9bl1seswMDFt9LREEvFykrv28/iYW3kXZHIOMRGwQ745SyQfeLVvvqmjIbNUt2lf
         JYVPKyifCOpaSqxGt3Mq9uLyDEc5NtI7kiMMFBp7s1t414ea26irotKawjyBC9o+udWg
         vugtMk1KbGMjLhmcQRtezpUvB/Mv1UGXW9DMNQu52hD20BK5pp3VJJIT+d6Zxcq1Rxsi
         0qfVWuFHddxsmbH+jcgD77xo38pROEoug1MJwEEJi8ukv5cu7duHJwLnm9VbWcGBLdnK
         C12A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ak/yZTzpgIpJQtD3WljhsD5fouvH+uomdrADi70BHVM=;
        b=TIF1tsbOcuTIUVL6q/UnHQ5Kh5Iptkz6bCqhXYLL2vAReVXpyr8a439Mro71KdMmdB
         mheK9IW6Dbeo9iA1ODSBocrPwSWlIcwe/rWEh6E4I7At0MblPlmLirKwHWJ+vG84F2cQ
         x2XEW/x+Ep8lnkGQWhabTXONbd8F2glSGGLwVS/zwZK2cFmF2vgf230c6egH8olpGhrJ
         7sa5PNgaWe9Kykj7HF71Vd3xVElVLEL6iOc8dWP+qAHpx+ieclI+Xv/4AarNV28x/LvH
         rOBXTjFxCkjscRXXZjY41CBo8AYkcNsv1roxk5TF31oYwYtFShVINTGYDrBRc9Nb2ju8
         LyLQ==
X-Gm-Message-State: AJIora8KK9kQgJWrXaEsY0viHMaY/28xvCVjim/xgBdWzaU50li50sSs
        NidD7NtXqdXi68KzwyN+JFPItbSlFRUGuw==
X-Google-Smtp-Source: AGRyM1tqe5zcrm8zLfAR8ilc9c99y9AKaTtFwV2/m2nTbzCaLqmQB3NSujcoq8v5zn3R7h/29xP9Cw==
X-Received: by 2002:aa7:ce94:0:b0:43b:bf79:e9c3 with SMTP id y20-20020aa7ce94000000b0043bbf79e9c3mr590238edv.57.1659039453783;
        Thu, 28 Jul 2022 13:17:33 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id v18-20020a170906293200b00726c0e63b94sm778289ejd.27.2022.07.28.13.17.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 13:17:33 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <08c9e2ed-29a2-14ea-c872-1a353a70d3e5@redhat.com>
Date:   Thu, 28 Jul 2022 22:17:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 0/6] KVM: x86: Apply NX mitigation more precisely
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220723012325.1715714-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/23/22 03:23, Sean Christopherson wrote:
> Patch 6 from Mingwei is the end goal of the series.  KVM incorrectly
> assumes that the NX huge page mitigation is the only scenario where KVM
> will create a non-leaf page instead of a huge page.   Precisely track
> (via kvm_mmu_page) if a non-huge page is being forced and use that info
> to avoid unnecessarily forcing smaller page sizes in
> disallowed_hugepage_adjust().
> 
> v2: Rebase, tweak a changelog accordingly.
> 
> v1:https://lore.kernel.org/all/20220409003847.819686-1-seanjc@google.com
> 
> Mingwei Zhang (1):
>    KVM: x86/mmu: explicitly check nx_hugepage in
>      disallowed_hugepage_adjust()
> 
> Sean Christopherson (5):
>    KVM: x86/mmu: Tag disallowed NX huge pages even if they're not tracked
>    KVM: x86/mmu: Properly account NX huge page workaround for nonpaging
>      MMUs
>    KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU before setting
>      SPTE
>    KVM: x86/mmu: Track the number of TDP MMU pages, but not the actual
>      pages
>    KVM: x86/mmu: Add helper to convert SPTE value to its shadow page

Some of the benefits are cool, such as not having to track the pages for 
the TDP MMU, and patch 2 is a borderline bugfix, but there's quite a lot 
of new non-obvious complexity here.

So the obligatory question is: is it worth a hundred lines of new code?

Paolo
