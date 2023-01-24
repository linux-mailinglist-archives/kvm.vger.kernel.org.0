Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58CB6797F3
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 13:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbjAXM0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 07:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbjAXMZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 07:25:57 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621ED30B02
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:25:36 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id fl11-20020a05600c0b8b00b003daf72fc844so12726168wmb.0
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 04:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HOR7H3/LLXjX7DwwcUt1Sxaz8oQgPrc+kjqBicZUl7Q=;
        b=dHS1Ak+M4dBaYd2oO/rnv29OksE6EZ47Hs6PkdO+IzRn/9hxeEJ79x80W6t9vU3cdo
         q9Wg34FbUSMCuIjRfTcWjmappghmskTm/E8qRAA2Kv40WwLQEjme6aCsv14mF2Ja/a1L
         v/mI8puDz/PsOJ8xkeQi/yaZy+UZ7JYSIe8zXNwAJrRNM93GzjUBqxkjqkM+xkqm+u5c
         I6rrjRTRhBp5n4IwPg4709vtW8nZtqNMZqH0E0hZP4MYqzWqrqp46gBfCUU4Ji7I3YvN
         qHgSRJ7I7o2/qvuNHDZL8bvXmRUBaOdzKRrPSTbCrU1dKBgZSIwfY8Te3qlNDU1tpKLC
         H5Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HOR7H3/LLXjX7DwwcUt1Sxaz8oQgPrc+kjqBicZUl7Q=;
        b=ev59qyR+zAaqUTTUcfXKWlhL5Exf/cBJ8A1ed4YXf8fZ9KpcTETNRMhC6/ImkIAbmK
         HbI0XuWTSgcpI9zQzdGkPL+jIcbdfgQ9rbePuNvFAuNZDql/WljYJuvAMH2KabBxWazy
         5rYPkdVQ0Eq/Aemhm4lEdhNneehkKxWAimuYv4NFYoUZklS9Amvu9qY/h275ljwS1OL7
         8L1C7uyssuJVrsFVfyoriDrP6dIqt2soBnGjKdI6vana0L3l0uR4bHNk3wsQbnkBIhHI
         PheLdFk5gAKLJonTVYFumogRLiVnUMFKvyXOD7pUeQUs8QClWYe2BzaN1aLcslin/ppj
         zYXQ==
X-Gm-Message-State: AFqh2kpy5tK7a0HqCa4MuQToKYW45maZw8YHiH90LAniQne5ujqaeVdi
        AMMAArCAJ6VfDda8G7EeyvJOLg==
X-Google-Smtp-Source: AMrXdXswzOrGdguMvcq5asIwnDi7E/WFIm7TkA+KrTAQrLo+T4xAmdanTOE5seP7qe3j5cbcXRMyuw==
X-Received: by 2002:a05:600c:1c83:b0:3da:fbd8:59a0 with SMTP id k3-20020a05600c1c8300b003dafbd859a0mr27996445wms.11.1674563134506;
        Tue, 24 Jan 2023 04:25:34 -0800 (PST)
Received: from [192.168.37.175] (173.red-88-29-178.dynamicip.rima-tde.net. [88.29.178.173])
        by smtp.gmail.com with ESMTPSA id j25-20020a05600c1c1900b003c71358a42dsm18568513wms.18.2023.01.24.04.25.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 04:25:34 -0800 (PST)
Message-ID: <b16b69fd-a138-d444-55d3-5fd1cef357a1@linaro.org>
Date:   Tue, 24 Jan 2023 13:25:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 24/32] acpi: Move the QMP command from monitor/ to
 hw/acpi/
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
 <20230124121946.1139465-25-armbru@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230124121946.1139465-25-armbru@redhat.com>
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
> This moves the command from MAINTAINERS section "QMP" to section
> "ACPI/SMBIOS)".
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>   hw/acpi/acpi-qmp-cmds.c | 30 ++++++++++++++++++++++++++++++
>   monitor/qmp-cmds.c      | 21 ---------------------
>   hw/acpi/meson.build     |  1 +
>   3 files changed, 31 insertions(+), 21 deletions(-)
>   create mode 100644 hw/acpi/acpi-qmp-cmds.c

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

