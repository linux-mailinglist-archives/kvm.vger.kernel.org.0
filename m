Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126FD644E2E
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 22:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiLFVox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 16:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiLFVov (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 16:44:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F03721AB
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 13:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670363029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oHJEWJ+WSS46l6h0W3LMcSJJTcRn5AVH7TfKQIhjMnU=;
        b=PrAaCSd62VByTK8kFlC7Vg3nQTldJeuf+nyG6bW9xVy4g6dfL0yCUDi6zQWW6P01H8b74p
        wv6VaVlaqW0IZGD0eoD4MKI2KOEhqKCl2JxYckGPBvo+UonbR50ccXyGdpTi5Tr1abFUs6
        oo3DC4lwWnFfJxLdeZxHesmuSAoI0GU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-339-5ObYzcZROlu8F-PVQQ0xcg-1; Tue, 06 Dec 2022 16:43:47 -0500
X-MC-Unique: 5ObYzcZROlu8F-PVQQ0xcg-1
Received: by mail-ed1-f70.google.com with SMTP id y18-20020a056402359200b004635f8b1bfbso8788106edc.17
        for <kvm@vger.kernel.org>; Tue, 06 Dec 2022 13:43:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oHJEWJ+WSS46l6h0W3LMcSJJTcRn5AVH7TfKQIhjMnU=;
        b=AVwyN33sx0hMngsA4yGxtsxGouNFjO7CvOuQjK/CYeoCErebwzoKvxaeGgHufi2H9R
         YTt0hA19yaT8befq/xTV87xIWlpv9TsFjM4XN8yOXCome7AiGA3wNs6v50lXRUvQr3LL
         EvLXoiBxWtwOEN8/gO3mq3HevdtjCm2/rviSr/ty0Bu4Oh/lnnku/rNxTplQBZXt7K49
         VZytLagupMjzhgjGRunbiMm6a+tX5YgAcSJjCVPDzeNFT0vpbcDsbevKdKXdFccIo3Nw
         WLIZfbO+LXJm69GBl0UAKGEoElQbOeU5QiFZccbRSVeQxr5wGP2150r4KM01aQBfODCl
         3Ghg==
X-Gm-Message-State: ANoB5plchWzJvnojBXjZUEGa1/t9Zwn+/JAxuTBce24cpk2ucqMSMree
        lZmh9FMUZjDym3MVJL2VkDQaDGSChrMiwqt6a8r3H9wZ1VyiKYfbW1KJQrpa7yI8Z8btk1Iukdi
        JJ5urcPbtXo5M
X-Received: by 2002:a17:906:504:b0:7b5:2d9f:4019 with SMTP id j4-20020a170906050400b007b52d9f4019mr64703393eja.536.1670363026699;
        Tue, 06 Dec 2022 13:43:46 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7IVVqNkqhwDYPZmryDDbrQqHIHf09mWm2PR1kmcAht6bOcrhNU1Xv53JwT3gSmwfSoJHHbYg==
X-Received: by 2002:a17:906:504:b0:7b5:2d9f:4019 with SMTP id j4-20020a170906050400b007b52d9f4019mr64703352eja.536.1670363026398;
        Tue, 06 Dec 2022 13:43:46 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id l9-20020a1709063d2900b0073d71792c8dsm7755776ejf.180.2022.12.06.13.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 13:43:45 -0800 (PST)
Message-ID: <28e7f298-972b-2cb8-df80-951076724c73@redhat.com>
Date:   Tue, 6 Dec 2022 22:43:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 6.2
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>,
        Sean Christopherson <seanjc@google.com>
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
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Peter Collingbourne <pcc@google.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>,
        Quentin Perret <qperret@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
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
 <Y4+FmDM7E5WYP3zV@google.com> <Y4+H5Vwy/aLvjqbw@sirena.org.uk>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y4+H5Vwy/aLvjqbw@sirena.org.uk>
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

On 12/6/22 19:20, Mark Brown wrote:
>> I almost suggested doing that on multiple occasions this cycle, but ultimately
>> decided not to because it would effectively mean splitting series that touch KVM
>> and selftests into different trees, which would create a different kind of
>> dependency hell.  Or maybe a hybrid approach where series that only (or mostly?)
>> touch selftests go into a dedicated tree?
>
> Some other subsystems do have a separate branch for kselftests.  One
> fairly common occurrence is that the selftests branch ends up failing to
> build independently because someone adds new ABI together with a
> selftest but the patches adding the ABI don't end up on the same branch
> as the tests which try to use them.  That is of course resolvable but
> it's a common friction point.

Yeah, the right solution is simply to merge selftests changes separately 
from the rest and use topic branches.

We will have more friction of this kind if we succeed in making more KVM 
code multi-architecture, so let's just treat selftests as the more 
innocuous drill...

Paolo

