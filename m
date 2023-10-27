Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1A157D8F73
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 09:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345394AbjJ0HPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 03:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345388AbjJ0HPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 03:15:51 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10329116
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 00:15:49 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-40891d38e3fso13059175e9.1
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 00:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698390947; x=1698995747; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=r+vdINcmFGGjA6+x+iJDg46Mk3yJWEt8/WHgQwybeJI=;
        b=UTTFoGtmid86NBSkM5uN6DV4osDsFwNCPVhDHRV9QqTUxEZMFtU1OZB8YSQz4Fbj01
         9KiL6o8KWS3pI0Lk9IV2k6olmI8q9HYwJiz0UXnd/IlkJsNOAf7Tq8BSOH/pu20GD2O0
         2PxYuIeNQbVOCjeVriBwFtk8xUkn/lxbXvaffYXzNSiJnpCS5dyM088neJA53vGuK0B0
         2/LCJ82R4VplfNio3wrvpsPb5H65KICT9aF4ZIrB9QYAHSpQapZSeAOqxNkKSkX7zMIR
         zZsTBUicYjl3p+AmKiJwRSv/BkA9QWCL+vjpYnOXLAEhmsC9yIHnzekXXzlzaTdbYXeS
         hGig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698390947; x=1698995747;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r+vdINcmFGGjA6+x+iJDg46Mk3yJWEt8/WHgQwybeJI=;
        b=XAHR7f/j82n3oqxo0QqxHlMwnBzKxuG4uHjdoaqLVfhlu6P1+JCZf42NOFYQmIW9GW
         07fAd2El6zom8YUUtWuy8dc6ZV9GplCfgEf74myzNNLBdTSiWyZV1wAXhd6VaSaWSHSI
         v3RMDVmSLb4FhRiXwCO9FAJ76JhePxNXIKmdtpAQT4O+9/DOPZHpE2AC3DR+h5emR8Qd
         MxlX8w9NANx/hfPU6S8O6QoYcEyxJuMKkKgyzQf1rbA3A/VRMFkZC2OWX++PPXH3SjnF
         ImoLj/+C6ABH6REiclQH1YoHGWbUIdj5LxLBFtzdj3PivUsnAStp1jEp/nHs6CsEB+Fc
         +0Hg==
X-Gm-Message-State: AOJu0Yx9IyxLbLmrwcDAJjE32mTT9mBTI4BiZYfp9OYrZubmfkcZnZcY
        uk28RInkqiHoiLj9W7NiyWAtN+CKnC0PUw==
X-Google-Smtp-Source: AGHT+IFLvBaX+jKKJG5b7EuYxKD1+NY+YQPBw4JtamDZDEEoV5ML8tHynkORTdYmyuxI7EF3GYGUzw==
X-Received: by 2002:adf:efc4:0:b0:32d:a310:cc2e with SMTP id i4-20020adfefc4000000b0032da310cc2emr1551939wrp.34.1698390947261;
        Fri, 27 Oct 2023 00:15:47 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id t20-20020a0560001a5400b0032ddc3b88e9sm1145980wry.0.2023.10.27.00.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 00:15:46 -0700 (PDT)
Message-ID: <abb048fe-5c73-4d09-8998-e4e54afe47a3@gmail.com>
Date:   Fri, 27 Oct 2023 08:15:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 05/28] hw/xen: fix XenStore watch delivery to guest
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
References: <20231025145042.627381-1-dwmw2@infradead.org>
 <20231025145042.627381-6-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-6-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2023 15:50, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> When fire_watch_cb() found the response buffer empty, it would call
> deliver_watch() to generate the XS_WATCH_EVENT message in the response
> buffer and send an event channel notification to the guest… without
> actually *copying* the response buffer into the ring. So there was
> nothing for the guest to see. The pending response didn't actually get
> processed into the ring until the guest next triggered some activity
> from its side.
> 
> Add the missing call to put_rsp().
> 
> It might have been slightly nicer to call xen_xenstore_event() here,
> which would *almost* have worked. Except for the fact that it calls
> xen_be_evtchn_pending() to check that it really does have an event
> pending (and clear the eventfd for next time). And under Xen it's
> defined that setting that fd to O_NONBLOCK isn't guaranteed to work,
> so the emu implementation follows suit.
> 
> This fixes Xen device hot-unplug.
> 
> Fixes: 0254c4d19df ("hw/xen: Add xenstore wire implementation and implementation stubs")
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/i386/kvm/xen_xenstore.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

