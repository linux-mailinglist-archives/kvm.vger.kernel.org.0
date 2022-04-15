Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1708502B40
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 15:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346148AbiDONuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 09:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbiDONuT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 09:50:19 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FB565781;
        Fri, 15 Apr 2022 06:47:51 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso5063856wmz.4;
        Fri, 15 Apr 2022 06:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KXO/l3FSGWDrDqwa/0eH/dKJsxtplbG+tIXvun5zSGE=;
        b=qr1RBX5veH1GCCAYc2JmM4hx4rhhOOiNuYmU9MrEzWPm7JRbTDuqPKbTi2JDq6Tjx+
         5eCjAvoidj0hYWxIIVyNBRQhRmA8bVZk+mwylb7Nn+/VL+G2Bb6CeMxcB0xl2zMgmjMa
         ghIDkWIfGaauDdZZcInfvXjA13WoDC1y8pajxDTgMH9IX2iHOG8qkTGEkD+Drd7RV8pJ
         X9BA6W1FnwKCIdSmt8SJTe4xJtMbjpyxvipcGPvzrUQBThKVJRDpXuFO8JzxsRseJsLJ
         j/QE+E4aY2/KyjE51tkB6CqYhSiNZNP1vNeWN6SceZelZeHRDuLFLakg53rFMF8Y9f3u
         rWyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KXO/l3FSGWDrDqwa/0eH/dKJsxtplbG+tIXvun5zSGE=;
        b=oZkbZKYzOGhNPfB0pdgtuM1FRN7n7m9tn5PllsZHSP1DgT3YwhQLOiUT/AOkKSJcoB
         hwg4vgoELl/jXoTpftwx7ITll+Inat5JX5zxt/QjW685y8//dQNZC9RVRLIsZHd9bxz4
         y0IuMoX59qXGVad6SfkhUefxhhCT681CX2bbEx/shm7HrTiBMQvQVx1zZU8imxoZpuYl
         amdtihiLEFI8DUCu6qTUgjdgyZVja14/ca9q4w5Pdkqrb6vUdtpmFFX/l36kVnOrFOov
         17dU4UBT0Bf5XtgBz92z+s3gf0KFM/vkTGcSfanu5Z7T/9zDHqPkV5ORkkKZrD8IonoW
         PfZA==
X-Gm-Message-State: AOAM531KvsnLMRqh+y34On8DDwI2vgSQb7DbmuBqCjUBLVKrxUHsLUU6
        2MWEXvaTgTuymVV2VIPYtTE=
X-Google-Smtp-Source: ABdhPJzAKMJiWEFR3eJAclRq57YPGgqZpnUCP3Jbla8O5GCz6ljTaUyDg0Pt14Aqcd2Mu1KBPOCD7g==
X-Received: by 2002:a05:600c:1989:b0:38c:b8b3:8fa8 with SMTP id t9-20020a05600c198900b0038cb8b38fa8mr3520134wmq.18.1650030469660;
        Fri, 15 Apr 2022 06:47:49 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id v188-20020a1cacc5000000b0038e9c60f0e7sm4937499wme.28.2022.04.15.06.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 06:47:49 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8e20d9af-bbe3-ad57-e131-4107f4b16051@redhat.com>
Date:   Fri, 15 Apr 2022 15:47:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 024/104] KVM: TDX: create/destroy VM structure
Content-Language: en-US
To:     Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <36805b6b6b668669d5205183c338a4020df584dd.1646422845.git.isaku.yamahata@intel.com>
 <aa6afd32-8892-dc8d-3804-3d85dcb0b867@redhat.com>
 <20220408005116.GB2864606@ls.amr.corp.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220408005116.GB2864606@ls.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/8/22 02:51, Isaku Yamahata wrote:
>> Please rename the function to explain what it does, for example
>> tdx_mmu_release_hkid.
> In the patch 021/104,  you suggested flush_shadow_all_private().
> Which do you prefer? flush_shadow_all_private or tdx_mmu_release_hkid.

vt_mmu_prezap should become vt_flush_shadow_all_private.

tdx_mmu_prezap should be come tdx_mmu_release_hkid.

Paolo
