Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F393D4CD98F
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 17:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240857AbiCDQ5k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 11:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240837AbiCDQ5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 11:57:37 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E2B1C4B1C
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 08:56:48 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id q7-20020a7bce87000000b00382255f4ca9so7022441wmj.2
        for <kvm@vger.kernel.org>; Fri, 04 Mar 2022 08:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=OeG+ww/Pdl38zR6EndtrKnHOChw4NiKGrdOcb/INWpM=;
        b=UMOLRWI2FdlLVH6TCzeS4kpeBRdBi4juFCEroIm0oaa9CA6iyntAXKeauE+Ee6zFzp
         nR0XKPembJQcTFnlmU/ZEldn9+lU1O7YMLhV/S8e2JS0asxXKMOOoZ5DgugFAd9kw2S4
         RH+KAn8eayIRlvE31Y2XkjVCYMh/WJ4lHnAu5Ayb62Bur6cdhPtUbiLILVb44SzWPDOa
         2z2yIYRGlAc4lFtAc/bsdIfm3TN/EGUNGqqj+oegKaIjfnn0ntYyfiHPzy0lzHPRs1cA
         OPcdNm7C/IkHPbZA/XLaXlIwT+BWEKkSUCwIrcfrHsYUdJXqJPgTELJYugjTCstr94VH
         BzvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=OeG+ww/Pdl38zR6EndtrKnHOChw4NiKGrdOcb/INWpM=;
        b=jp8fV0IuBQbKPsVjqRu6hXE3WkFx7HovJK9TGno2HXMA/KrfDycNu74ES8aIDEyXlZ
         pRCP2tnVDXg6HlQiooh0APGTK7zBI2TRjKZlF9T9sJsgCNYhosW861Uu1eYRYTnqddLc
         XAV08BSrTdkQukZC9pV+SevX+aoZMuh0mgxQj7PDk7d4P3fYR3CCOhmekE4dD/oIKW3F
         PvvX30SPvQHf2eZEtMOl3SibERRodO5kr4ZJVCv6gwjUv2daShnuy86RRLl6GVEWlHS3
         cToQnlelljI5KJjeTpIDrpe0zdwq59aeobu/loKTX8HwMfOAS5q0mID18sHr+R8k1lT4
         vZ/w==
X-Gm-Message-State: AOAM53032K+fZ2FZYp/NUcWWdkTB8hN/f3GeDTzObOTQlt4/sfupCo/m
        FGIftD+5IxZS/RaTOrvob7M1Gw==
X-Google-Smtp-Source: ABdhPJyMtgycuIr7vOgYL0Dp0iSnVrXZOJULcr8VvGwrH6xblkcMJwOAVAoqNil1zst8+h6cfCcjWw==
X-Received: by 2002:a1c:e916:0:b0:37c:f44f:573 with SMTP id q22-20020a1ce916000000b0037cf44f0573mr8795252wmc.179.1646413007235;
        Fri, 04 Mar 2022 08:56:47 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id p3-20020a05600c358300b003897e440047sm2501809wmq.28.2022.03.04.08.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 08:56:46 -0800 (PST)
Date:   Fri, 4 Mar 2022 16:56:44 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <YiJEzLKlEY3NECKk@google.com>
References: <20220302075421.2131221-1-lee.jones@linaro.org>
 <20220304114718-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220304114718-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 04 Mar 2022, Michael S. Tsirkin wrote:

> On Wed, Mar 02, 2022 at 07:54:21AM +0000, Lee Jones wrote:
> > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > to vhost_get_vq_desc().  All we have to do is take the same lock
> > during virtqueue clean-up and we mitigate the reported issues.
> > 
> > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > 
> > Cc: <stable@vger.kernel.org>
> > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> OK so please post series with this and the warning
> cleaned up comments and commit logs explaining that
> this is just to make debugging easier in case
> we have issues in the future, it's not a bugfix.

No problem.

Just to clarify, drop Cc: Stable also?

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
