Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A9364871C
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 17:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiLIQ6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 11:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiLIQ6H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 11:58:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5271E726
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 08:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670605026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kutSohfRuT0cPTr7xUVGydvOQR8mvu7/B/e5xyo3DzI=;
        b=eBWMJhM3vrGrhy//bdsu2z9RtFNRqzp3cqXBcrkhgKC6M2cX1UvUnJgGOCUGVfUY5bV3Bi
        xkB5I5TkctHgflji4SAdAqxfNcKtH6/4+OCs1RSGfpHrZs6iruTVbXBCFmYXtlnH/2Pqpx
        n7Wb6XH464Cf7LyyuIWIjL8QTgWHJXw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-202-2H2DpG4cNfiT63xardbwSA-1; Fri, 09 Dec 2022 11:57:05 -0500
X-MC-Unique: 2H2DpG4cNfiT63xardbwSA-1
Received: by mail-ed1-f71.google.com with SMTP id s13-20020a056402520d00b0046c78433b54so1720385edd.16
        for <kvm@vger.kernel.org>; Fri, 09 Dec 2022 08:57:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kutSohfRuT0cPTr7xUVGydvOQR8mvu7/B/e5xyo3DzI=;
        b=qi79O2RwlgQk5+NOYdUoILORNp01wGaZeSnwSVGiNNzPdDcQxMrkxP3DPFjCPWoSbx
         uMWzGCxar/h7Aj/X1jkeWp+LGdlcmPQsCADBdGGYAzCmLPnsV3buQ+WqGNntmDo0X498
         ZQz1HVy2kuxunuShE+YTokvBAsKj1149Hs3pBsKrujq+RUIan3+ILBOtI6qF81av/and
         4TG0B0DUw0H7emb4JVH5k8cztyDeelf/0JKB046aLgV7Q58hhX25F1rsF8biBtoGKqyh
         o3hwTUn1cWEJ5+NgAWaYDVKR2x/ksd0ghPgFFbXWXZ1cvzDYex7Hs/wg4m8UyDV+cdS4
         nT7w==
X-Gm-Message-State: ANoB5pkf9S+11qilXBCLVSJqNCesugBdXb6jPGhw1tSCt4aIfZAWYmY1
        e2ZuuzYDVc6OsXi535SZHSBV3smdUwCtjKHzBTkuGRd7EDpdWRNW+XEIbI6Yi/VdjgUt43Yg7wl
        YbMKfaRhLTbav
X-Received: by 2002:a05:6402:183:b0:461:56b2:943 with SMTP id r3-20020a056402018300b0046156b20943mr5551446edv.40.1670605024479;
        Fri, 09 Dec 2022 08:57:04 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5xY78xD8gU/6JmFuYoh837GurNRUBVaPbDjK9T5d+0vb14K3ITW6tzQi++uHMCwlogdk44yg==
X-Received: by 2002:a05:6402:183:b0:461:56b2:943 with SMTP id r3-20020a056402018300b0046156b20943mr5551438edv.40.1670605024259;
        Fri, 09 Dec 2022 08:57:04 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id i21-20020a170906a29500b007af0f0d2249sm129159ejz.52.2022.12.09.08.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Dec 2022 08:57:03 -0800 (PST)
Message-ID: <5e51cf73-5d51-835f-8748-7554a65d9111@redhat.com>
Date:   Fri, 9 Dec 2022 17:56:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
Content-Language: en-US
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>,
        Andrew Jones <andrew.jones@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        Ben Gardon <bgardon@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Fuad Tabba <tabba@google.com>, Gavin Shan <gshan@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morse <james.morse@arm.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Collingbourne <pcc@google.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Usama Arif <usama.arif@bytedance.com>,
        Vincent Donnefort <vdonnefort@google.com>,
        Will Deacon <will@kernel.org>,
        Zhiyuan Dai <daizhiyuan@phytium.com.cn>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org
References: <20221205155845.233018-1-maz@kernel.org>
 <3230b8bd-b763-9ad1-769b-68e6555e4100@redhat.com>
 <Y5EK5dDBhutOQTf6@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y5EK5dDBhutOQTf6@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/22 22:51, Oliver Upton wrote:
>>
>> I haven't pushed to kvm/next yet to give you time to check, so the
>> merge is currently in kvm/queue only.
> Have a look at this series, which gets things building and actually
> passing again:
> 
> https://lore.kernel.org/kvm/20221207214809.489070-1-oliver.upton@linux.dev/

Thank you!  Squashed 1-2 and applied 3-4.

Paolo

