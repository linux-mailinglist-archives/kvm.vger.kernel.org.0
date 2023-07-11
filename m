Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610F174F1D0
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbjGKOV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbjGKOVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:21:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E99441998
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689085226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NY9zvWPkMIRBdIzQwvp51bTldJwjnkTeVv0DGYO1saU=;
        b=Nc9q/cJRfKVXWpaEaPIa48SIUa1Z5y6jqib9gOND3LEDk64w0Inyk8buhZlZLwsVxobOjz
        UFN3gug+nOSFrqWTw/gbojVdopJLPe8+5N3DfboBJfxtauAxbbc7KT1+UBHTc5oNpL13RL
        qePUo+dIobEICRKPjW+TDaDgLPMJ3xw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-owKJyGXMPSOsyC8L1C253A-1; Tue, 11 Jul 2023 10:20:22 -0400
X-MC-Unique: owKJyGXMPSOsyC8L1C253A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 52C1B28040B2;
        Tue, 11 Jul 2023 14:16:56 +0000 (UTC)
Received: from [10.39.208.24] (unknown [10.39.208.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6434B40C2070;
        Tue, 11 Jul 2023 14:16:54 +0000 (UTC)
Message-ID: <3a8073d5-dab4-ed13-2c53-84ed5093bacb@redhat.com>
Date:   Tue, 11 Jul 2023 16:16:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Content-Language: en-US
To:     Cindy Lu <lulu@redhat.com>, jasowang@redhat.com, mst@redhat.com,
        xieyongji@bytedance.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20230628065919.54042-1-lulu@redhat.com>
 <20230628065919.54042-2-lulu@redhat.com>
From:   Maxime Coquelin <maxime.coquelin@redhat.com>
Subject: Re: [RFC 1/4] vduse: Add the struct to save the vq reconnect info
In-Reply-To: <20230628065919.54042-2-lulu@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Cindy,

On 6/28/23 08:59, Cindy Lu wrote:
> From: Your Name <you@example.com>
> 
> this struct is to save the reconnect info struct, in this
> struct saved the page info that alloc to save the
> reconnect info
> 
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>   drivers/vdpa/vdpa_user/vduse_dev.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
> index 26b7e29cb900..f845dc46b1db 100644
> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> @@ -72,6 +72,12 @@ struct vduse_umem {
>   	struct page **pages;
>   	struct mm_struct *mm;
>   };
> +struct vdpa_reconnect_info {
> +	u32 index;
> +	phys_addr_t addr;
> +	unsigned long vaddr;
> +	phys_addr_t size;
> +};
>   
>   struct vduse_dev {
>   	struct vduse_vdpa *vdev;
> @@ -106,6 +112,7 @@ struct vduse_dev {
>   	u32 vq_align;
>   	struct vduse_umem *umem;
>   	struct mutex mem_lock;
> +	struct vdpa_reconnect_info reconnect_info[64];

Why 64?
Shouldn't it be part of struct vduse_virtqueue instead?

>   };
>   
>   struct vduse_dev_msg {

