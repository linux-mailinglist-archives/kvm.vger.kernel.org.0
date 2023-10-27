Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011367D941E
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 11:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345542AbjJ0JsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 05:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjJ0JsW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 05:48:22 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8EC9D
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:48:16 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-32dff08bbdbso1281816f8f.2
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698400095; x=1699004895; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=30VwI2HQrqCL5YyhF8qmfbeeHlzGfWBEtfc4fCXo8Fs=;
        b=hkt3sMRe7rR1d10W+KW1xktcblerzO9qoo0S2RVwjGHQhzvuR6lCcW+XJuYvbqDCOK
         TpXhh5+nh4ABCqrdAY3r/m++ji/OKmJi/vN4b2umg4ixok8YVwXanbcbcJ+b/KL+Ipjo
         dMLwONxKGQlmv2SaTsdfdWF610ukiuafyJasQttpkHdgabNT3i3n0Zp/QqhyoSKy8FdL
         ZNuOjOW5PgSKPDlDeWd3fMakE/YvdWE2Au0qwLaS/yspysc4lt4sEW2uMEMP1IU5KmlC
         ug9T9MkPjz3aCAVNtyDoPkgH+YElivJMvnoNKSrFGCcT9fDbQWw7jkMGKLs+81hwObgu
         HXPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698400095; x=1699004895;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=30VwI2HQrqCL5YyhF8qmfbeeHlzGfWBEtfc4fCXo8Fs=;
        b=SJVXudIOdF4m8zghDtAFvqxu4H41C7OjQKphRopdujXzdhO2NzAmK0UOtOGGMA7pr9
         shw62GYGNQBYq5vx0kscdMFs0DOSdlMtsuCZDoPmmujtj2FUCO7NwP8EU1SxBTNKb5LN
         TOiSklFItjMe/uWCY7P09Pn1GD2hpfhVlax6l034N2vZks+1yJbhWH+5N082HvwOZ7rv
         QA68wDxaPZvSX4/+M0kgyDsVT9Gm5fAMZjKIsb0mHrH9zxJ0t++ScQY2d7OS+kYeS2Tp
         0Lad/DShbRta2dpnWpuIK9yJcSqOHpJcJmernWkq+P+c7ZhfDrHfX1AiPuhG6os3XccO
         BLyQ==
X-Gm-Message-State: AOJu0Yy9Iv9cbRnWf7Jiq6GrXCrtxNvm2tHTQYjD8AnKCU4NDhfPo/br
        NGRLmvWxRb3rZCurwGMMoIM=
X-Google-Smtp-Source: AGHT+IE4PpSyRDRjuLCwnnRqMs4Ez7+O/3yvQMMGSADruwPllbL3a4A8idM4xcMnD9poi1dGJZ1Jjg==
X-Received: by 2002:a05:6000:1361:b0:32d:9b80:e2c6 with SMTP id q1-20020a056000136100b0032d9b80e2c6mr1636403wrz.26.1698400094647;
        Fri, 27 Oct 2023 02:48:14 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id e9-20020a5d5949000000b00326f5d0ce0asm1389222wri.21.2023.10.27.02.48.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 02:48:14 -0700 (PDT)
Message-ID: <322697f1-c4fe-40ab-88ce-f99f9d1fe4d6@gmail.com>
Date:   Fri, 27 Oct 2023 10:48:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 26/28] hw/i386/pc: use qemu_get_nic_info() and
 pci_init_nic_devices()
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
 <20231025145042.627381-27-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-27-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
> Eliminate direct access to nd_table[] and nb_nics by processing the the
> ISA NICs first and then calling pci_init_nic_devices() for the test.
> 
> It's important to do this *before* the subsequent patch which registers
> the Xen PV network devices, because the code being remove here didn't
> check whether nd->instantiated was already set before using each entry.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   hw/i386/pc.c                | 21 +++++++++++----------
>   include/hw/net/ne2000-isa.h |  2 --
>   2 files changed, 11 insertions(+), 12 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

