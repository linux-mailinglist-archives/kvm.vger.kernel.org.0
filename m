Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89F378BB20
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 00:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbjH1Woz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 18:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbjH1Woh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 18:44:37 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3B7115
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 15:44:34 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-31c5cac3ae2so3063212f8f.3
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 15:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693262673; x=1693867473;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OyyxGce5gmUfNa1tP64bKObZmxdcrbkh1N254wyjdj8=;
        b=k7WAhWeyRVjmbKXoFTMQVOt3rYKxukLD2PzsgVqfbQwXcrICdz3vwOQY6DI0J4dkB2
         C+dQUzNsTOGEJz0YMG+EF0hHw5FZ+U2YHLM98scz5D25xg5iVnE2OspOUk+NE7Pb9V66
         hLwOHjJ76uw6uEDCWrLn3i7MX2bVKryBySPdupmDM5W2qXb+UkKglyC4zvo1R2sZ5hG5
         1zi8jq6nsVTHAEZUUopx15qV+Y39S29UmCmlf+mLv7Dsl/bMkxf3k8SJ2wsV8rKsxh20
         F+0CqkPX4svCnHSKGaOHc4/TzIE3hordRSyYzsrCPwGb6sdcIxN2/hmFFFay9Gc0n7h/
         pf9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693262673; x=1693867473;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OyyxGce5gmUfNa1tP64bKObZmxdcrbkh1N254wyjdj8=;
        b=bdWgAILG29IviwFF5UblEQVewi33Lb4DLblaYxywwlLxei8UkDnFL/YshVdlKPAVTk
         eDuw3lLsNqtBM4p/8p+SygqoA+fCidF6y4OLMoSJ38EYmR8ByDHnP97gwRIUzR6LTRC2
         q5g2Qmga+gBx28bYOzGTuUYDSGPy0D/mgxA9bSaVBLYcwWiPhTX+IHKamBkPZC617Uhl
         kvT63cJqAQXFR70s8cjb/r4zPM0w5CdSAv4eDoufjtIHeAMrtc0mCCuWS8mf5NZOQg38
         hc1Qf5aBtJcFRAcfBDRi4Ru0s3r40f9SQsB2Rsaj6euwiRCaBzboMpX8axGBEG5Ks28j
         t9YA==
X-Gm-Message-State: AOJu0Yz5zaPbkAtDP+9jI80XNVPy2c9L/3YaXi4O20/YIaTbkp1d00RR
        ZZGSb8qyUj6H2EARBYALujfFUw==
X-Google-Smtp-Source: AGHT+IHfaSlIx9csx3MxeEpezV95gAFOz7PpYvKzI16bZvPWrAZsdeY5OaE3KOe303ksrNGWCZvLAg==
X-Received: by 2002:a5d:42c7:0:b0:31a:d31:dbf9 with SMTP id t7-20020a5d42c7000000b0031a0d31dbf9mr19067876wrr.49.1693262673038;
        Mon, 28 Aug 2023 15:44:33 -0700 (PDT)
Received: from [192.168.69.115] ([176.164.201.64])
        by smtp.gmail.com with ESMTPSA id f12-20020adff44c000000b00319779ee691sm11852050wrp.28.2023.08.28.15.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Aug 2023 15:44:32 -0700 (PDT)
Message-ID: <f7a42ba7-613b-bc85-35d4-83c5f08c0964@linaro.org>
Date:   Tue, 29 Aug 2023 00:44:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH v2 16/16] virtio-mem: Mark memslot alias memory regions
 unmergeable
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Michal Privoznik <mprivozn@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        kvm@vger.kernel.org
References: <20230825132149.366064-1-david@redhat.com>
 <20230825132149.366064-17-david@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230825132149.366064-17-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/8/23 15:21, David Hildenbrand wrote:
> Let's mark the memslot alias memory regions as unmergable, such that
> flatview and vhost won't merge adjacent memory region aliases and we can
> atomically map/unmap individual aliases without affecting adjacent
> alias memory regions.
> 
> This handles vhost and vfio in multiple-memslot mode correctly (which do
> not support atomic memslot updates) and avoids the temporary removal of
> large memslots, which can be an expensive operation. For example, vfio
> might have to unpin + repin a lot of memory, which is undesired.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   hw/virtio/virtio-mem.c | 6 ++++++
>   1 file changed, 6 insertions(+)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

