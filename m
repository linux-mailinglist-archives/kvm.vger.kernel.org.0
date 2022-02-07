Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC0C4AC23B
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 16:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356063AbiBGO6D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 09:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382645AbiBGOf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 09:35:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8715EC0401C1
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 06:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644244527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xZZgqYvSXYR+oleAuOjKwJYuJo6PBzXou2noV4Zc2s8=;
        b=Q4/oK0S4XcWNJCpsSBl1DieXPDoxxxXTSzQjp8Y/qiPLckrnAiRLz81C4IxiOHHnxf6gNs
        741X1UcNUX5Vsk9yu+aTletstOrIqO0McXAp88mbyjJ1A/MztEnpBiicqHu8e+YPn7sSxW
        uI8ehACOmbUX0uI0YahF0oMQ0BkHpU8=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-pnPB2vyYMIOLnx_Q03ZRAQ-1; Mon, 07 Feb 2022 09:35:26 -0500
X-MC-Unique: pnPB2vyYMIOLnx_Q03ZRAQ-1
Received: by mail-ej1-f69.google.com with SMTP id la22-20020a170907781600b006a7884de505so4383688ejc.7
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 06:35:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=xZZgqYvSXYR+oleAuOjKwJYuJo6PBzXou2noV4Zc2s8=;
        b=36x3UO9R0rvG0CCA7kMpkvcCUpTDpw9mIPWTjffIuMQSOi2R3TmrNeiXr2zRWuiMsD
         GgdtLb1xdp6orjxc14kwlEcpsmQTkP5mSOiIGhz+ao+Y2kgQ1cjyIosePduxwMzxiLZy
         MC2gBzOZukwunUa7Uxt0arr92b41GCKSGXymcXbln1P9ded7dO5ILztL1MDvfhrfcBUS
         Qoio099xYgJAhpF/b/YkgPChzTA3S27xl/6aoZ+8blBLJKaN+azKi2VZDu4jlPwb5xkJ
         tvPV5Ed5JagR59NPhodmZG338CRBJahfJY/7u1IoX5aMfLdfG/Yz65U5oa+VsF3wjIIv
         ssuA==
X-Gm-Message-State: AOAM5313CyD2J6MpwaWKDwDvDLjwgK0Ik+tQI59WFNlsjG2Ms+CvFW7g
        ixs5w/kXg+G7y2MmJfasZ3VcKXE3d6vCTqB7ux0pAneDRLyPdMCjldPBBYFNHSNUAEyHtgkft/L
        CJ8anUNgc9oWL
X-Received: by 2002:a17:906:2a91:: with SMTP id l17mr14721eje.245.1644244524893;
        Mon, 07 Feb 2022 06:35:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjGBKL0CynVyEL8UISkpQlHq9yINJnfDANYwbL9GyFwYctn0c+PlkmeG7Ac0lR3oo+40ERWQ==
X-Received: by 2002:a17:906:2a91:: with SMTP id l17mr14711eje.245.1644244524735;
        Mon, 07 Feb 2022 06:35:24 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id k24sm3787142ejv.179.2022.02.07.06.35.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 06:35:24 -0800 (PST)
Message-ID: <9b9b7f7a-cfc6-1e56-aeb2-d3a7e445fe14@redhat.com>
Date:   Mon, 7 Feb 2022 15:35:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 06/23] KVM: MMU: load new PGD once nested two-dimensional
 paging is initialized
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, vkuznets@redhat.com
References: <20220204115718.14934-1-pbonzini@redhat.com>
 <20220204115718.14934-7-pbonzini@redhat.com> <Yf178LYEY4pFJcLc@google.com>
 <180d7f0f-8c58-2a52-02a7-bd014d81d7a3@redhat.com>
In-Reply-To: <180d7f0f-8c58-2a52-02a7-bd014d81d7a3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/7/22 14:50, Paolo Bonzini wrote:
>>>
>> Those checks are just for performance correct (to skip iterating through
>> the list of roots)?
>>
>> Either way, it's probably worth including a Fixes tag below.
> 
> There's no bug because __kvm_mmu_new_pgd is passed a correct new_role. 
> But it's unnecessarily complex as shown by patches 7 and 9.

root_level is not part of the role, but we're still safe because 
changing it requires to flip CR0.PG to 0 and back to 1.  This calls 
kvm_mmu_reset_context and unloads all roots, so it's not possible to 
have a cached PGD with the wrong root level.  On the first call the 
root_level might be incorrect, but then again there's no cached PGD.

(Also, shadow_root_level is either always or never >= PT64_ROOT_4LEVEL, 
so it's okay unless the guest_mmu was never set up and therefore no 
cached PGD exists).

Paolo

