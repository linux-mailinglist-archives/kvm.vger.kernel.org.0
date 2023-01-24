Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A736797D3
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbjAXMXo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:23:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbjAXMXn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:23:43 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D238939CE2
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:23:09 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id j17so11327547wms.0
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LYe9cnDkxny7Yt6JrjBoQmx21JnrnJY6Fj/n7XowdQ8=;
        b=v+eSKZOGBp7YoopifTAkwiF5BBaCWqtmUqnUSIP7sV39NJG/AoeVkYtvDBBV1uFtu6
         CM7IbbD4cKCPe+COU3aI5v3Q4O+M72yoRy/roOwR0QJheOmdVwmnH/fUe/lE29MYXL4W
         hQz4QCguaUZPnedEO26K9F3sPxdryHHM3XuYQxvw28jrbEM+xKn126NSd7ZKmdhn09M7
         bMs5iGTxnkB5RLasuXDsb3VP4e7nvWntxCgEd7oNEOhY4fKEut0CDMqUXst8de8zW9p7
         YdOBeSjJ74g6UMZgAUawwfJJDlkgINhb4klB8ElrsZiG/vFBT/bop586vYcdwfxbEnnS
         JMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LYe9cnDkxny7Yt6JrjBoQmx21JnrnJY6Fj/n7XowdQ8=;
        b=R1Dky+N19LQrTFE57gEXYXdA4NsYY/7tEEzGpiX2BRyasGY4G9bwWs+iDWw358Cd+F
         sDGHlRY7qIFNpRdlYSJpRnFBUaRULxHvS1YP9lB1g7X7rkaRzP9mfiTRJ9TCRPaQKWDJ
         ZcM6SC+myPoxVZ4qCH37l290hpt4ywhaek9KkdQbs7heYrONsd6JsQOtt2WvlqAEhpJT
         h4KrJwd03dDvw5VtQS4FYiaE0tXvrJOWSWWapljOEhlEqZdOopvIKNWfP+Cp4wxhmCBN
         FbYv/L6mv5tPnx7aSv6ffbd7WExBcR/R5fahcHhXJC2ykAnWZ/oTdnqeORbkyGK/D8Rx
         r3cA==
X-Gm-Message-State: AFqh2kqmPYbcfZQGNktmqeXHFx0JZyF1OSdSnlddFeCk+p5dJMWoh0MA
        HHWy2qeZJmtnye+y85iA640Ejw==
X-Google-Smtp-Source: AMrXdXsT3QMsgRM95qDXmQ6G3jTpBTPjl2DTTU0g+OFCZty82GhzQy6XRSL30GkGF2+25VI8caY6qQ==
X-Received: by 2002:a05:600c:a29f:b0:3d9:f42c:56c5 with SMTP id hu31-20020a05600ca29f00b003d9f42c56c5mr27658854wmb.4.1674562926099;
        Tue, 24 Jan 2023 04:22:06 -0800 (PST)
Received: from [192.168.37.175] (173.red-88-29-178.dynamicip.rima-tde.net. [88.29.178.173])
        by smtp.gmail.com with ESMTPSA id r8-20020a05600c424800b003daf672a616sm1830235wmm.22.2023.01.24.04.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 04:22:05 -0800 (PST)
Message-ID: <c5644956-0508-f6ba-4eb6-fbde1c6a1814@linaro.org>
Date:   Tue, 24 Jan 2023 13:22:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 08/32] trace: Move HMP commands from monitor/ to trace/
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
 <20230124121946.1139465-9-armbru@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230124121946.1139465-9-armbru@redhat.com>
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
> This moves these commands from MAINTAINERS sections "Human
> Monitor (HMP)" and "QMP" to "Tracing".
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   include/monitor/hmp.h  |   3 +
>   monitor/misc.c         | 119 ---------------------------------
>   trace/trace-hmp-cmds.c | 148 +++++++++++++++++++++++++++++++++++++++++
>   trace/meson.build      |   1 +
>   4 files changed, 152 insertions(+), 119 deletions(-)
>   create mode 100644 trace/trace-hmp-cmds.c

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

