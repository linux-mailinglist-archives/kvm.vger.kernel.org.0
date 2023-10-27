Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BED17D9283
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 10:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345523AbjJ0IpL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 04:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345656AbjJ0Iom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 04:44:42 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 846671FE0
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 01:44:37 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-5082a874098so454134e87.3
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 01:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698396276; x=1699001076; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tNlTPL/h1q0gctttAApwRF+1wbJdOYFnWGSZhWSB3FY=;
        b=GBr/TbeeM6uOo6rXxZHldbb7uXQSPNhg2HPLT+KrqSR4+o9pKFd4RIBgIZDHt2XbJc
         ILFXQcDmQ9eO3H0rEp98o/umlorO4LHTFA3G87mBDMXNGi8rxZbynLgqfwIZ3RNfJ2ww
         SzAXwQfPsogE4pgkhIdWMUpVWRriVDNUERCO5Q96LPsT8wNGrXbDPh7d6EY76u3NLA5J
         Qo4avlEgtdDezn9FeiE54jECbnhgrqgHzDivUFJoVSjbR4CWtpd4Xh/foWI5TsQFaMEZ
         3VHhAYOiSgbGVjlFIZcs5Y8MhrB5vqMvzJ+oONdVwuQHGjmjQRYN6/iTp2lYglnE516l
         3Y9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698396276; x=1699001076;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tNlTPL/h1q0gctttAApwRF+1wbJdOYFnWGSZhWSB3FY=;
        b=dpjar22gjhroPUh429oRbekDcnQY2zQjdWKIsqi7E+62z84xNfnOtzNJtWN/TrHxnO
         dSSDejbWi6pYA4rAEegaEYEsVWWJ2euMF+vRVgi6bGDLiKVoVGZJsBR4xfx5E4WMEdKo
         1KFUp6qe/lDorY7jUaufGX3FkkXei/xi9Xt7TjKHG0t4JICx7SmcpctH5OFUqxYunymd
         OP8H5kfDR6pl42DJHb9TsnSkh6LC4oEgEd65J7S+lLV/+lnVI+Ebfp2pdwDPlSQH5UfX
         335oP4mHzYosRFK9fL1TbcWLAkmybMjDFkQeVmFVsBzLz6lJCHZxuupaY6XhE7s9NVW/
         nlxw==
X-Gm-Message-State: AOJu0Yzg3+51mXe1Ti5d8jPCA/0YpgsuxxOlSfCSO+roKYpl+orezj66
        UghCLe3nL9e5StRIwFM+gtU=
X-Google-Smtp-Source: AGHT+IGDgLtfXBaR32xR7jkwm7OjIsXKvGrggAwxMX3BfT7FEKsGbWVQFL/Ib+4ohIFSlDse9DRe/w==
X-Received: by 2002:a19:6d03:0:b0:507:c763:27a5 with SMTP id i3-20020a196d03000000b00507c76327a5mr1182175lfc.62.1698396275565;
        Fri, 27 Oct 2023 01:44:35 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id o4-20020a5d6704000000b0032dde679398sm1276365wru.8.2023.10.27.01.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 01:44:35 -0700 (PDT)
Message-ID: <db350375-9bb3-4ae7-bd2b-7bcce9974577@gmail.com>
Date:   Fri, 27 Oct 2023 09:44:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 20/28] net: do not delete nics in net_cleanup()
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
 <20231025145042.627381-21-dwmw2@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <20231025145042.627381-21-dwmw2@infradead.org>
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
> In net_cleanup() we only need to delete the netdevs, as those may have
> state which outlives Qemu when it exits, and thus may actually need to
> be cleaned up on exit.
> 
> The nics, on the other hand, are owned by the device which created them.
> Most devices don't bother to clean up on exit because they don't have
> any state which will outlive Qemu... but XenBus devices do need to clean
> up their nodes in XenStore, and do have an exit handler to delete them.
> 
> When the XenBus exit handler destroys the xen-net-device, it attempts
> to delete its nic after net_cleanup() had already done so. And crashes.
> 
> Fix this by only deleting netdevs as we walk the list. As the comment
> notes, we can't use QTAILQ_FOREACH_SAFE() as each deletion may remove
> *multiple* entries, including the "safely" saved 'next' pointer. But
> we can store the *previous* entry, since nics are safe.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   net/net.c | 28 ++++++++++++++++++++++------
>   1 file changed, 22 insertions(+), 6 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

