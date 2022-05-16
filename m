Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA5252820B
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 12:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242745AbiEPK2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 06:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242747AbiEPK2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 06:28:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8D74B12D0C
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 03:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652696878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jEKNjp1P7D9YxpTD7CYOS6MoXv5rSpuabq3cNsxhUao=;
        b=WopImHzHYjSCu/sED+aK/4/1/Mq6q79aXJFI/ajjXIV701TbKEJzbRFReyRIim0o9FYRt2
        S/V9qbtyjcn3rRLFiOEqzlJfpRxNWCeJm78SJli1JzLzFBEfnJJUJEwj5rmD+nOZYXsZPO
        Ho+4x4UhtztiQKtemxFRGIs51Qso3UQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-Dlggz11DP4eIOszFBV7D2Q-1; Mon, 16 May 2022 06:27:55 -0400
X-MC-Unique: Dlggz11DP4eIOszFBV7D2Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49E1329ABA10;
        Mon, 16 May 2022 10:27:55 +0000 (UTC)
Received: from localhost (unknown [10.39.193.113])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 03837401474;
        Mon, 16 May 2022 10:27:54 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/uapi/linux/vfio.h: Fix trivial typo - _IORW
 should be _IOWR instead
In-Reply-To: <20220516101202.88373-1-thuth@redhat.com>
Organization: Red Hat GmbH
References: <20220516101202.88373-1-thuth@redhat.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Mon, 16 May 2022 12:27:53 +0200
Message-ID: <87o7zxojpy.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16 2022, Thomas Huth <thuth@redhat.com> wrote:

> There is no macro called _IORW, so use _IOWR in the comment instead.
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  include/uapi/linux/vfio.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

