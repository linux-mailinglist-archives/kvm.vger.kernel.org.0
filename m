Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17E17D8FAA
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 09:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345333AbjJ0HXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 03:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjJ0HXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 03:23:09 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CCE194
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 00:23:07 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-32f70391608so178122f8f.2
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 00:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698391385; x=1698996185; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dSCOMydOnsCaHq17QXAhhoXbOK1DobHQBIwwTw48NnM=;
        b=NQC1g7ouSlhRQBxbKk3Qlzl6ehpJmf6rsb3V2pQM6OVaJ/8gAzsUFnhJmLleXLMMWv
         Mnq5dFU2kQCCSktgkzJL90RXhJqSPFT8uWsRO68bSXXEtFCjGQAPwsc2l0m5D2wKHHyf
         3I6FcgXfotthBLs02T5lBaRnmHKKFeRHftU4de8o6Gd0OSjcYqIjg2ngMZ4VryfvFGLN
         FRdHvfwFLPJNcq7kiG4yVdOE005S/Sv9LyiLoMsKWbVHZL3mipRoJzkmmio4iDe/vZMd
         wJE1G5HlW7xHNGr2DhPfOUJLhV1/I0SpRwlVNVog5yFlfsPqA6lJRmWy2HHt2l+M2ZPk
         HDnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698391385; x=1698996185;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dSCOMydOnsCaHq17QXAhhoXbOK1DobHQBIwwTw48NnM=;
        b=n8U5G2Ovj+BBfVAcg7FUJ8WVUwMUfx3h3bEsOr3SCHUXgupCbuZuL2Y4wRnRSAB1KU
         leAzB1yR8dNEhs7fjL68whfQbKdv5tOp4hOD8g/KbuHjnOIsT7hXcK0KiMLoPZYAYjp7
         ZqnO5sFukLlfgm6b7yDZvcX05Ov0/besdZhdjMKKSnEEG+zXQDBgWHRWzu7f6QT8DkSb
         +KgrLecL3pLBVG4Gd6IBXPyaHBN/JNMtCHuEzFgMjz9fssKTX8MTBOMHGNrvGeA4rYf6
         8BgVyMpoOSgVXiDg7BFinb5dwqxmZSa1+nWvF10O5FdSQIkuay9yeTNgRFVKp99ZIgT6
         ydbQ==
X-Gm-Message-State: AOJu0Yxq3FoEF7iJqHwR47y0VeT1CDbErdg2jy2ECuD6SHhDsGjAs136
        Xg/m2+7U93sEHuRQP/kz4sU=
X-Google-Smtp-Source: AGHT+IGcJqs+3Lj5Br/+siV+aN+YMItskE6Hk6MaX+RfvRLeEZhRqSD3XuVFCG4gSuppLBynhA6zLA==
X-Received: by 2002:adf:e992:0:b0:321:6a61:e45a with SMTP id h18-20020adfe992000000b003216a61e45amr1332680wrm.15.1698391385492;
        Fri, 27 Oct 2023 00:23:05 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id d16-20020adfef90000000b0032326908972sm1126352wro.17.2023.10.27.00.23.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 00:23:05 -0700 (PDT)
Message-ID: <65c0d093-e83c-4307-9edb-2b4f04cde607@gmail.com>
Date:   Fri, 27 Oct 2023 08:23:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 08/28] i386/xen: Ignore VCPU_SSHOTTMR_future flag in
 set_singleshot_timer()
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
 <20231025145042.627381-9-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-9-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/10/2023 15:50, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Upstream Xen now ignores this flag¹, since the only guest kernel ever to
> use it was buggy.
> 
> ¹ https://xenbits.xen.org/gitweb/?p=xen.git;a=commitdiff;h=19c6cbd909
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Reviewed-by: Paul Durrant <paul@xen.org>
> ---
>   target/i386/kvm/xen-emu.c | 20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

