Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32BF954531B
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 19:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245530AbiFIRit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 13:38:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234360AbiFIRis (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 13:38:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8913451E47
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 10:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654796324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k6TtggULp7/GiOA6VvEvNpW/MHPOaym0FBcYUcuSeZU=;
        b=IlLX1TYN3xV9vVXmklU+Vdn0/mk/OBIEpHMLjq81Wn3YMKTmaixquqWOLD5tWK3qLVODFG
        XqBBIqVCNQPKQPf0hA3yJzdQLghvb/lYUNVxdHTF3xJ0cgojH0oJ0VYvaVl1Gqs6A5dDgw
        A2pw7IlXlgF4H5ZSflJyg6fxLUkrFrQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-Di3d6a78MOyctsHMAAndnA-1; Thu, 09 Jun 2022 13:38:43 -0400
X-MC-Unique: Di3d6a78MOyctsHMAAndnA-1
Received: by mail-wm1-f72.google.com with SMTP id z13-20020a7bc7cd000000b0039c4a238eadso4168314wmk.9
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 10:38:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=k6TtggULp7/GiOA6VvEvNpW/MHPOaym0FBcYUcuSeZU=;
        b=aJR1IUKwyjYdMhCrDULT0PycFf+xPYzxdM2RYq66W1qC1ZEMnrC1PBUgulgV2K1l1w
         mI1En/aMkSMhdBbgQVqZe/9Rg28YVle8hC6nxiEkRh2v4L9lL8pTK3JlpRkW1407YTDr
         YHgDmbjDU8+lUufZF9JNfDrWUdqtjZ7ePmctedQPIWPjbavmoiHl9ViHgBgi8YOv0/9A
         g2TVlCFmeNbYPjw6iIxZkC3QdZwZPpGcvQQUbkBsuxFi9szRRuvlVu8D4WKrbEhx3M4E
         ZO/3184JTEmDs61OnjJCgNM6toMcieM/4x9fVwC9akQ0UlTyR9qNuVa+lJAYuSl83mPu
         hQSQ==
X-Gm-Message-State: AOAM531FM+zxvCHMNkjpsPSdvk5GXjhsYcr9+qSXx95vBGLkBTUgUSg+
        0SdmSAlpAn672eCVYHH6QQA4F2c4LWxsiLgJxTjIjFA8OorcIGgJYkPMFCoFVRoEf0TUHTcduG8
        VS8JU6KMv43Ul
X-Received: by 2002:a5d:6283:0:b0:213:b939:826d with SMTP id k3-20020a5d6283000000b00213b939826dmr35332036wru.543.1654796322050;
        Thu, 09 Jun 2022 10:38:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycbjbAoqYi/Z38MH7gotfLoia/Ifcg797dUpu4eGDAE74k+ABciK+rkA2pggXKQtSvmd1fZw==
X-Received: by 2002:a5d:6283:0:b0:213:b939:826d with SMTP id k3-20020a5d6283000000b00213b939826dmr35332021wru.543.1654796321841;
        Thu, 09 Jun 2022 10:38:41 -0700 (PDT)
Received: from [192.168.1.129] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id z2-20020adff1c2000000b0020c5253d8dcsm23897952wro.40.2022.06.09.10.38.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 10:38:41 -0700 (PDT)
Message-ID: <0bdbec1f-196b-b82e-9d64-06029e250983@redhat.com>
Date:   Thu, 9 Jun 2022 19:38:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Mark olpc_dcon BROKEN [Was: [PATCH v6 5/5] fbdev: Make
 registered_fb[] private to fbmem.c]
Content-Language: en-US
To:     Sam Ravnborg <sam@ravnborg.org>, Jerry Lin <wahahab11@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Thomas Zimmermann <tzimmermann@suse.de>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Laszlo Ersek <lersek@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        kernel test robot <lkp@intel.com>,
        Jens Frederich <jfrederich@gmail.com>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        linux-staging@lists.linux.dev,
        Daniel Vetter <daniel.vetter@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>, Helge Deller <deller@gmx.de>,
        Matthew Wilcox <willy@infradead.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        linux-fbdev@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
References: <20220607182338.344270-1-javierm@redhat.com>
 <20220607182338.344270-6-javierm@redhat.com>
 <3ebac271-1276-8132-6175-ca95a26cfcbb@suse.de>
 <69d8ad0e-efc6-f37d-9aa7-d06f8de16a6a@redhat.com>
 <YqIskEjUvJo4y4cb@ravnborg.org>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <YqIskEjUvJo4y4cb@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Sam,

On 6/9/22 19:23, Sam Ravnborg wrote:

[snip]

> 
> To repeat myself from irc.
> olpc_dcon is a staging driver and we should avoid inventing anything in
> core code for to make staging drivers works.
> Geert suggested EXPORT_SYMPBOL_NS_GPL() that could work and narrow it
> down to olpc_dcon.
> The better approach is to mark said driver BROKEN and then someone can
> fix it it there is anyone who cares.
> Last commit to olpc_dcon was in 2019: e40219d5e4b2177bfd4d885e7b64e3b236af40ac
> and maybe Jerry Lin cares enough to fix it.
> 
> Added Jerry and Greg to the mail.
> 
> 	Sam
> 

That does sound like the best approach indeed. And if the driver is kept
BROKEN for a few releases then it can just remove it from the kernel. If
someone still uses/cares about the driver, they can fix it as you said,
and it could even be ported to DRM if is something that's still useful.

-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat

