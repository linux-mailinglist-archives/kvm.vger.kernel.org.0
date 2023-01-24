Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D7F6797E0
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbjAXMZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:25:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbjAXMZA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:25:00 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6A9C67F
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:24:26 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d14so10017607wrr.9
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D4tXS0YY4OfV20lyQ82vMbgmPELSA08qkLjQr8OzI8E=;
        b=LjYW4fnvl4449bS74mYEA7zGB+5LYSm7/s3uHUKGTJUnTFk4dX4gzW6iwSgv87uPKH
         bWnxGzqAOj2zk4M//awmgB25pVMBrcFh8Q2fxSfffg7mk2sFgvR02HmVURbL/QCAfJTH
         kC1teX1dlb2BAzkz0cWZVt9/uvH7MjMHa/vl2bndISE04h3NjbPDGWVv27l5G9wqLtLg
         SzpvwAY8r5NmKWAlO/xzYhMuGWT8z3utNNHhRZS+sfPatT8YL7gQZBGsS7b1DVZ2uw8Z
         WfgX7AWm+/G3xQWKpOjeLBXBhOMyKxjtMMbATxSyGfM93qC5syR6jJzq249t3lOaa76s
         4HSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D4tXS0YY4OfV20lyQ82vMbgmPELSA08qkLjQr8OzI8E=;
        b=Gu0qDV3SSn/1j6gF6ao/qq/d9Y1KaSo1+R5qXep8c9RoRciqiYANVZKflZIc60V49A
         UcmchjGZLDeZoNKeZrGMq6rzjEXEXOqJ2RcsWwUsuGKLXVmKkHJ276gyj2UvbuNmNXHL
         qQF3bv6/+tBpWI12bdujLAlA4nMsRQeJdGaMI1XNDqgr3gMjF5iAL3R0WJ2RjGcvmpit
         nundl0O4eEvSSisvjdej6XgkRJBuETUy53Ps+B/J28sNkTzbHrmmJHMC0TjQCOFSg/8C
         afnGQAaTbKm3Qhhc8fqNsvOZZMwwDV1NAPusc5uA1pnMzd9yBJ/0HokI4R/g8mvk2tyF
         vRyg==
X-Gm-Message-State: AFqh2kpmy3dJ7J8crW5nOlBiGLXGCG8XkcOZwjPcldMex8f2RDGqMLN1
        s3KHw4mT+vZ0CrnHY+UREhK5IA==
X-Google-Smtp-Source: AMrXdXsSYvQwYJIqCNw+xUU8GF5FTE5Q7fGKYFAKCuccTP6lg1hg6K6mtRBR2vU17wVUZ37i385fxA==
X-Received: by 2002:adf:d084:0:b0:2ae:b451:a0f7 with SMTP id y4-20020adfd084000000b002aeb451a0f7mr24024283wrh.5.1674563063429;
        Tue, 24 Jan 2023 04:24:23 -0800 (PST)
Received: from [192.168.37.175] (173.red-88-29-178.dynamicip.rima-tde.net. [88.29.178.173])
        by smtp.gmail.com with ESMTPSA id q3-20020adff943000000b002bfae43109fsm1654372wrr.93.2023.01.24.04.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 04:24:23 -0800 (PST)
Message-ID: <cfc2472e-14c6-8737-976d-d7d912cb4096@linaro.org>
Date:   Tue, 24 Jan 2023 13:24:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 19/32] virtio: Move HMP commands from monitor/ to
 hw/virtio/
Content-Language: en-US
To:     Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, kraxel@redhat.com, kwolf@redhat.com,
        hreitz@redhat.com, marcandre.lureau@redhat.com,
        dgilbert@redhat.com, mst@redhat.com, imammedo@redhat.com,
        ani@anisinha.ca, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, jasowang@redhat.com, jiri@resnulli.us,
        berrange@redhat.com, thuth@redhat.com, quintela@redhat.com,
        stefanb@linux.vnet.ibm.com, stefanha@redhat.com,
        kvm@vger.kernel.org, qemu-block@nongnu.org
References: <20230124121946.1139465-1-armbru@redhat.com>
 <20230124121946.1139465-20-armbru@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230124121946.1139465-20-armbru@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/1/23 13:19, Markus Armbruster wrote:
> This moves these commands from MAINTAINERS section "Human
> Monitor (HMP)" to "virtio".
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   hw/virtio/virtio-hmp-cmds.c | 321 ++++++++++++++++++++++++++++++++++++
>   monitor/hmp-cmds.c          | 309 ----------------------------------
>   hw/virtio/meson.build       |   1 +
>   3 files changed, 322 insertions(+), 309 deletions(-)
>   create mode 100644 hw/virtio/virtio-hmp-cmds.c

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

