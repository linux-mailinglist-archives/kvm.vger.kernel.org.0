Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FCA78C7D2
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 16:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236948AbjH2Om6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 10:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236999AbjH2Omc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 10:42:32 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1F218D
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 07:42:17 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-400a087b0bfso41585135e9.2
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 07:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693320136; x=1693924936;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zCsRcU4gamP71uJM1oFyNFH7u3ozsV3ge3/YUq3jGNg=;
        b=jUYXjrGiTJD7B8FBzSpccyasQb5F6Rpwt4ZL6pMqkdatLTWXpsYf1ukPRefHEzricb
         hifjeDch/Jd0UNkWBc8c9DYYkUxI0qlfpKV3ksqldw4zR1gqImmr9wRjxmplI8I5VkRp
         4Joj+rOx1Mh3xZVzkHLZZVz+NqLNwjOikOepjUF0A2PwZooDmyhxvwW7//wAY1vgbS/K
         prSEFo5XsgsuQZ4OnksK7+qQogpl2Hg5qjRH+rHXzy7avkh6gpaazV/1xydAWtYcVV2E
         Tw2pzH+XZxSmdXOyo8sFlYVYPYgQs3/1xmSeXdkHQxXKEjXH1in2n/bYPIsIV6t3UFN5
         ZJUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693320136; x=1693924936;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zCsRcU4gamP71uJM1oFyNFH7u3ozsV3ge3/YUq3jGNg=;
        b=kTh2mK/NN5K1eKWRfpZItkhki3Lbajf157kPmgMl2JOioidnadzAw+AuTUsCA+t3xB
         HS/BOsDhYsN5qJPTVfzyPNznvXyanyqiNxhSIZMyLpG91oaaihymiQNTW5zjSkeMSzhi
         /a4r/NOUZ0z7P4DEZPKMANLewIC3Tt1VaUUxDMzznAzsXawNQZlytJyIV9rk9MMrFVEd
         dDGFPph5NVzyNhDnRm+/tSDDSZBOot+VEewF+KqdVJIWb3CYdZ+Qe5WiUBnkRAmXPA0U
         zND+O2B88gJNCGRPbJHfSQzR9xZGqDVtlKJLdM49ue3Txtn6ujCShszBtzDwVvtopSzB
         RpUg==
X-Gm-Message-State: AOJu0YzuJMfgD8Y1s3RMWODaMugsyIyChbgxofSRGeKfcpSt5r/71h6T
        9ncglbrZ8z56aI5Wg7IRkZ5KWQ==
X-Google-Smtp-Source: AGHT+IHSOWPCEK2FwOefP15TZzbwruJfPjs2r4cB3ufVZ31dQCxqaPACviBrv3kdlrCWig3ybUNiCw==
X-Received: by 2002:a7b:c34d:0:b0:3fe:2e0d:b715 with SMTP id l13-20020a7bc34d000000b003fe2e0db715mr22876289wmj.18.1693320136071;
        Tue, 29 Aug 2023 07:42:16 -0700 (PDT)
Received: from [192.168.69.115] (sml13-h01-176-184-15-56.dsl.sta.abo.bbox.fr. [176.184.15.56])
        by smtp.gmail.com with ESMTPSA id x16-20020a5d6510000000b003143c9beeaesm13965977wru.44.2023.08.29.07.42.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 07:42:15 -0700 (PDT)
Message-ID: <9c8195b6-e9ce-9be6-4fdc-5fe1347580fc@linaro.org>
Date:   Tue, 29 Aug 2023 16:42:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v2 04/58] target/i386: Introduce
 kvm_confidential_guest_init()
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
 <20230818095041.1973309-5-xiaoyao.li@intel.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230818095041.1973309-5-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/8/23 11:49, Xiaoyao Li wrote:
> Introduce a separate function kvm_confidential_guest_init() for SEV (and
> future TDX).
> 
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>   target/i386/kvm/kvm.c | 11 ++++++++++-
>   target/i386/sev.c     |  1 -
>   target/i386/sev.h     |  2 ++
>   3 files changed, 12 insertions(+), 2 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

