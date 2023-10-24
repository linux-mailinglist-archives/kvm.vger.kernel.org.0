Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAAF57D4FD0
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 14:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbjJXMc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 08:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbjJXMc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 08:32:56 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD03B10C0
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:32:53 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-40806e4106dso25624475e9.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 05:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698150772; x=1698755572; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Z8xi1P/dcTtFP7ePzE6x4tmvxxQQYlCJaujecDuFetg=;
        b=B2waC9FvOID0OY/5GQMI6ZX0D4vJVRdZ41TFd+UK3l6YMmeaxUhzgheQEAK38QBTKR
         nbZN1xHvuFjPloA933wqSbxgse6Sp9539rR351ZXL42GBddlwWhzipDVs/vjuSNQqm5I
         eCJXFgAALRzD2T3H/sJ2VmEkiJgLysaU4ookSzkfQiaNxysVU0EZCyyia0g2x+nDw+Y4
         fnnpvD8+w9z1tUKZQjKwDb5P6t015YOfeufORv1gRnCyxUUX4FtLWvHi/Yn6WrD3/2Fb
         zSsALaOdTiNv8n+RX/b7AwwuvuFXIfYuG67OIJPNHYqmfQ3mDGy2SsaFG2GWL1WbaHDX
         0pxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698150772; x=1698755572;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z8xi1P/dcTtFP7ePzE6x4tmvxxQQYlCJaujecDuFetg=;
        b=a77yk7H1K1Qkn6gXPOeYNMja9eB4VCsf/ijNPyJTtegsTfla8ShkGLQm3HGhO3G5VP
         PGFacJgObbExKhVdVt6k6sbBQlUdRfD5h7bDNds1OhQu1nthqSzUzjG2l9FE+PSBDXGx
         pnRGE5b4ek2TcCV06OReg6n1FcbSw+MHmvF3G8LzI+AGOO7UHxzIy47hkxToQpXRG4WA
         ibCU80WeP7f7IFDQQT1vLhEf8cAfY7oFTIM0fWkXbGISPt0hsZpbWjPuXBS7cD8gEIpn
         uAVY+cBlGatGSntz8rm211Kh0dwsaAdM1dXoK3VhvAIjJxBlQJsx1k7IlsnrvqyyAHNw
         5ZJQ==
X-Gm-Message-State: AOJu0YzY1cwB75WHGNC4pJebejN7JZAs3UmaGLX6hSKM4rW1tvwnMaYV
        9LTCW0TFN59hB1ajXuE7eTBASbJ14DYxrg==
X-Google-Smtp-Source: AGHT+IGLdFkCr04zokQorvoqlEejP4kWXqo5hK8lgihYOMmGeEBHFMEAE6OQhDXnhcyIoipg+gCexQ==
X-Received: by 2002:a7b:c8ce:0:b0:406:5a14:5c1e with SMTP id f14-20020a7bc8ce000000b004065a145c1emr14719463wml.1.1698150772070;
        Tue, 24 Oct 2023 05:32:52 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id k6-20020a05600c1c8600b003fe1c332810sm16779437wms.33.2023.10.24.05.32.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 05:32:51 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <2126ac82-3ec5-4535-b676-d4a745d6314e@xen.org>
Date:   Tue, 24 Oct 2023 13:32:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 04/12] i386/xen: advertise XEN_HVM_CPUID_UPCALL_VECTOR in
 CPUID
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
 <20231016151909.22133-5-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20231016151909.22133-5-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 16:19, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> This will allow Linux guests (since v6.0) to use the per-vCPU upcall
> vector delivered as MSI through the local APIC.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   target/i386/kvm/kvm.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

