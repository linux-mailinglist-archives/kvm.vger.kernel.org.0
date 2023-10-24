Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B667D5081
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 14:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234480AbjJXM7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 08:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbjJXM7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 08:59:13 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C4690
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:59:11 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-40842752c6eso35549335e9.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698152350; x=1698757150; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/Fv2AY0PfohaOR9XcU+8ZQ81rKPOWLOMFyddNbcLYLA=;
        b=NyLBibkdNYzDa6k9cqeHV7vyhTpy3gEU6vEKe7GF6lzPwBpvR5mYHOLBRHocnBlmGz
         1r5lLouhfoqXziNavEeqHwesLyowSmCJrQjvcTRRFz95QNMxwJNTk8GAeUGUrlhI7xyi
         YVmTST+Gv9vBUWmvpUQsHihF+JzB8dp+eMfLEfX16HEgOkbVb9dP6WyMwzCZd58TpZww
         sbS4vV0RJremx7kyPNvlw81uqpL19H6E2IS4mtmrWVWkEfFoLQ80dpOOXxCeykqgryZX
         GFth4nn22g4O3dAFqJPcjgki6JYRY8N9yNBEvHdfMGaG+OI030WciPs0xaRZX4oJDN1W
         B0Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698152350; x=1698757150;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Fv2AY0PfohaOR9XcU+8ZQ81rKPOWLOMFyddNbcLYLA=;
        b=LAglNHMxFB1/n/A5JVqnev5kXKoTxPOGV94g1LqL1u4zmiaqqZTGKBB+67mFhjYzBS
         tV2awFX1aMxkZeeQKEjGwg3rtE1QSTUp1iHGuecPGxgmeTnqb9SlecXgCsKlU/B6/jj+
         nVGVUgmN1DwswDBZE0QwxA9i2J9n4Z4skeaQ7SJsKfnmfC5N01rwa7r/v18CqXCp6Ju6
         OMQ8vtKJgAHNJdfR+Ea9BTGBNwAdSTG4JyiMT7BrePpVAwrqocdQ9+Kmz+BEoJZHAljQ
         nlvPwfNxCnkh7+78AmQ4+NtTouczHuHGbp0pUxoMj7+lpS8ZYXaeC+xVYCZKcdtM+liY
         F1Cw==
X-Gm-Message-State: AOJu0YzpaM7qumSd25QXwQ+KmwXYbkFkZdnmTzqzc8RphOW7xuG5gisA
        /7SCP8mq/KC2qj6eaGrY0YE=
X-Google-Smtp-Source: AGHT+IHO2khmsIcOqOzMGxdA5Ej9PMASd96m2EkszFQX+E0xL93HsityPlswigSIsmJsJG7LwrKmlw==
X-Received: by 2002:a05:600c:5252:b0:408:389d:c22e with SMTP id fc18-20020a05600c525200b00408389dc22emr9189363wmb.25.1698152350138;
        Tue, 24 Oct 2023 05:59:10 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-230.amazon.com. [54.240.197.230])
        by smtp.gmail.com with ESMTPSA id az20-20020a05600c601400b004054dcbf92asm11888555wmb.20.2023.10.24.05.59.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 05:59:08 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <55bb6967-9499-45ef-b4c8-00fbfaccef0d@xen.org>
Date:   Tue, 24 Oct 2023 13:59:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 06/12] hw/xen: add get_frontend_path() method to
 XenDeviceClass
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
References: <20231016151909.22133-1-dwmw2@infradead.org>
 <20231016151909.22133-7-dwmw2@infradead.org>
 <5ef43a7c-e535-496d-8a14-bccbadab3bc0@xen.org>
 <d43b900a6c7987c6832ceeede9b4c5ab65d5bacd.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <d43b900a6c7987c6832ceeede9b4c5ab65d5bacd.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2023 13:56, David Woodhouse wrote:
> On Tue, 2023-10-24 at 13:42 +0100, Paul Durrant wrote:
>>
>>> --- a/hw/xen/xen-bus.c
>>> +++ b/hw/xen/xen-bus.c
>>> @@ -711,8 +711,16 @@ static void xen_device_frontend_create(XenDevice *xendev, Error **errp)
>>>     {
>>>         ERRP_GUARD();
>>>         XenBus *xenbus = XEN_BUS(qdev_get_parent_bus(DEVICE(xendev)));
>>> +    XenDeviceClass *xendev_class = XEN_DEVICE_GET_CLASS(xendev);
>>>     
>>> -    xendev->frontend_path = xen_device_get_frontend_path(xendev);
>>> +    if (xendev_class->get_frontend_path) {
>>> +        xendev->frontend_path = xendev_class->get_frontend_path(xendev, errp);
>>> +        if (!xendev->frontend_path) {
>>> +            return;
>>
>> I think you need to update errp here to note that you are failing to
>> create the frontend.
> 
> If xendev_class->get_frontend_path returned NULL it will have filled in errp.
> 

Ok, but a prepend to say that a lack of path there means we skip 
frontend creation seems reasonable?

> As a general rule (I'll be doing a bombing run on xen-bus once I get my
> patch queue down into single digits) we should never check 'if (*errp)'
> to check if a function had an error. It should *also* return a success
> or failure indication, and we should cope with errp being NULL.
> 

I'm pretty sure someone told me the exact opposite a few years back.

   Paul
