Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61A138F6B0
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 02:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbhEYAEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 20:04:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229854AbhEYAER (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 May 2021 20:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621900967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6JwmMpBs7TpaCI3ZuipI6pwwy6y5d3sU9vlG1AsbdUE=;
        b=VTJMr5kGXrPAMo7H4AumdHWKzzj76f63C1fCGAH5oW/CatTiXoYS4dh4cDP0+BT+kJkvD/
        zKfqsngP7I+26cANXpaeJCHlTDaR9NaWNTGU0LzZJjGR+Q0z0okTdt72+GanpP1AUWPU3o
        FZUS8cfXDAs8bzNfURk5TlO5CTtdDL0=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-LazULh1nN7Og2qhrUXOXOw-1; Mon, 24 May 2021 20:02:45 -0400
X-MC-Unique: LazULh1nN7Og2qhrUXOXOw-1
Received: by mail-pf1-f197.google.com with SMTP id g144-20020a6252960000b029023d959faca6so19206014pfb.9
        for <kvm@vger.kernel.org>; Mon, 24 May 2021 17:02:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6JwmMpBs7TpaCI3ZuipI6pwwy6y5d3sU9vlG1AsbdUE=;
        b=k14ZZkU5so+3GwPGtagnra5tFvXQFTi02trfdjITtBXODMYPYWtTdQsuExCp3uA59E
         bLs8kMqSydUGbzD0R4klXB4xij9IXMSFJgB1F0m5rame9A3FUEsx6aC/m/3FMy4q7BMe
         RRGr75q/kvhpE6YpwSKfqxQMfXkoU4e/l2wL83ywO3ZWpe0FrXqvU+00yxLfZA47mvuV
         8z64eNm2OoQRuaPK2MwO0meUDXtWEaCtmkQv8gQ31HDeb92/x/YnKsqUlRLEAzKSszti
         0tH1y4wTQMCH/Hgs5drxu1yUUUGqIntMLFAJIhfQy8SLyeDt6JgBsrmswPt1xwfxlflc
         h38A==
X-Gm-Message-State: AOAM5336KVnRYPF97npltV3vJdFPjTVuhA9XUI6FQLpVIqsKCZKYUIwU
        4T9fVF7nknUKEIUIqRjgU302eRAVTjXnza/8gd1yZcY/Wfh3gJBGLcMadTWhlO4tUQXDp6zdyLj
        Hc6WUCOzdgVj6
X-Received: by 2002:aa7:828c:0:b029:2d2:3231:7ef8 with SMTP id s12-20020aa7828c0000b02902d232317ef8mr26847627pfm.80.1621900964803;
        Mon, 24 May 2021 17:02:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxbyrmCLUcE53s8m/jtPYUcLYHs6nAUzwHtcyLOuUAj4w+gEoX+N4uv8UIlnp35amw76TvK2w==
X-Received: by 2002:aa7:828c:0:b029:2d2:3231:7ef8 with SMTP id s12-20020aa7828c0000b02902d232317ef8mr26847606pfm.80.1621900964580;
        Mon, 24 May 2021 17:02:44 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c7sm12444120pga.4.2021.05.24.17.02.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 17:02:44 -0700 (PDT)
Subject: Re: [PATCH] vhost: Remove the repeated declaration
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>
References: <1621857884-19964-1-git-send-email-zhangshaokun@hisilicon.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c93bda5e-edd0-0d63-b8bd-0d73fc505d90@redhat.com>
Date:   Tue, 25 May 2021 08:02:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1621857884-19964-1-git-send-email-zhangshaokun@hisilicon.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


ÔÚ 2021/5/24 ÏÂÎç8:04, Shaokun Zhang Ð´µÀ:
> Function 'vhost_vring_ioctl' is declared twice, remove the repeated
> declaration.
>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
>   drivers/vhost/vhost.h | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index b063324c7669..374f4795cb5a 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -47,7 +47,6 @@ void vhost_poll_stop(struct vhost_poll *poll);
>   void vhost_poll_flush(struct vhost_poll *poll);
>   void vhost_poll_queue(struct vhost_poll *poll);
>   void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work);
> -long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp);
>   
>   struct vhost_log {
>   	u64 addr;


Acked-by: Jason Wang <jasowang@redhat.com>


