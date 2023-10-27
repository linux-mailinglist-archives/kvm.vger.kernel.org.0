Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13F657D9404
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 11:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345505AbjJ0Jmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 05:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbjJ0Jme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 05:42:34 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D589F9C
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:42:31 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-507adc3381cso2712842e87.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698399750; x=1699004550; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Kiz2KMdg7YL05gR8LgSt7smgQdVxoWMShyrXxPJfs9s=;
        b=RTRiqE4F/5JgK2k28dKZay2qP/QvhkH41W2Re6TrAE3C8utGO/rf/Zn8Jo1WsC0Mrs
         iSH5RlWN06y8qxrSyGhNG1nalY+PhB4grQDL3/MDd8WLajeDtZyMd//PIoJOWwIL6v++
         ale8r8pnve5d6AIWj85rk6HMSS0qzNke3vKFssaq/r8rOOZmxSiCMLCqUlBo/aeRftWS
         ufEUmyaawSAeaVaXhe7or0A4+jq8z7pa3LdBWt8Zso8Ghh3Y3ZyZTbrbrp3fvJhtyfrd
         hfU7s/mH5E205dobkJPP1dsKNdZSoe8jQsd7eMGrmAwyw7FrMjb3dQHiVxj21UvoQWC1
         xUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698399750; x=1699004550;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kiz2KMdg7YL05gR8LgSt7smgQdVxoWMShyrXxPJfs9s=;
        b=w0CZuNBNnwU9wtAULLWuXhYvAHeWfQJs0+1IbRWE4bRQj0fFtyfWJDWayZj/LrDZyw
         8MsJ90Wm/yXpEdVvZdaKLf7meMUZDHm8uok3mNQG2Kjs2McEEn2YRuBUUUZDYvAiOMOd
         J8DgCP37i4VKsCgM2mCgSB8Pf9xqKQZKSPPKFQatEcbmClF9/YGvC+MKGK/KdVlz+0Pv
         axe52BD5SYaqn61Tun8vtOssaukdLdHi7Z3Foqg+m5Z3EZkDi+GwAb4e4OWKjAblZ61i
         N6KKvrh1tQd7+c6Gu7RgB+xCJE6HxcCZ8VpZCsTOgCoc6tLYHxMjdV3DJuQQLVyd7enz
         jW8A==
X-Gm-Message-State: AOJu0YyXHgTu+uNcizm5UjaR2rFsdu4172XGkDOZ8gYZRGkB9kT0pPQz
        hptoY3Ut/LHg7FYSuNs3UfU=
X-Google-Smtp-Source: AGHT+IGhjfQTzfpSI0jSZ3Vaoz7HQMUUZYv6yz0Ojq0M+dEBGy0psEQV6EoLJB1bLce08/1kjOIo9w==
X-Received: by 2002:a05:6512:406:b0:508:1eb0:3d4a with SMTP id u6-20020a056512040600b005081eb03d4amr1422321lfk.22.1698399749812;
        Fri, 27 Oct 2023 02:42:29 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id du15-20020a05600c634f00b003fc16ee2864sm1170909wmb.48.2023.10.27.02.42.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 02:42:29 -0700 (PDT)
Message-ID: <1ac8c57c-d154-4176-802c-505e4d785a5e@gmail.com>
Date:   Fri, 27 Oct 2023 10:42:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 24/28] net: add qemu_create_nic_bus_devices()
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
 <20231025145042.627381-25-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-25-dwmw2@infradead.org>
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

On 25/10/2023 15:50, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> This will instantiate any NICs which live on a given bus type. Each bus
> is allowed *one* substitution (for PCI it's virtio → virtio-net-pci, for
> Xen it's xen → xen-net-device; no point in overengineering it unless we
> actually want more).
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   include/net/net.h |  3 +++
>   net/net.c         | 53 +++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 56 insertions(+)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

