Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51F24CAB2F
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243653AbiCBRLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:11:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243649AbiCBRLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:11:09 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5B440936
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:10:24 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id j17so3897546wrc.0
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 09:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/A/Wf1LVWnIFg005LIj0+B/3iT8p8+uVVjrl/CBEcyY=;
        b=PAZI+7c7kmmiyT3XJwcRO3NMZ9oTNnehWyFoD6+Bt5H7Hl5i39z1hi5MYTDIDyI9wf
         7946oKEnme1wJziXZzu3FqKQwkS+Q/+i/I/6uU0qL8QjT/E8UAZ5IvwGYUEeMWLqI2e0
         SOxjKINJwdByr9Dz9p21rU1LCV0FFX5zbOnetWLk76T0lmEDUxpYtCDCdR75ScjlYK0P
         /fXBLPa5EMXxXNG0z2NyVWioFIyl2KOs3P9hEUoj6nkunntc8+64BtVTh2PuvbOrO8ev
         BH1Ds1wjVQmt4mFXZDlVum+D1Xu7CVSI8wjx75C0GxpFsKHxBnOvUjUXbLvTLeJlNiAf
         sLHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/A/Wf1LVWnIFg005LIj0+B/3iT8p8+uVVjrl/CBEcyY=;
        b=Q6oA+5SVSFPlizzwBPCIaKDuL8GByO5kus7BqlOPZ5gBOv4eS3xQIFcPPLPWsTdeB1
         LL8Iz1jMHvaCfjLgjC/bP3WylYAZS+NkdHGnPZNUIZ6RU2sZLWftiT3U2bN69d/pjQ62
         vXn+iuBRFPlbe9pS0nD+/UoNtYBiNKVzmDUdsMUe5+Wed+sx5SCP+NEfqMjTu7MFVNTX
         y9P3skdEcxE7suU4F16BDthTLwEud8WG/J4fFXmebKDcOJ5NwJxH+3JeVEFr7yHE//m0
         /ZS/cpqZpOtjij4kWF0hMfnCOzzjOMe7GZIYGJ0fjr4d1t269wUgrMDa+0T1qW6egdyh
         0y6A==
X-Gm-Message-State: AOAM5300dWjd115cM6NHepp2Yfa9ztAL7Kt1FwA93owa+w/lNZML2u/N
        B+WhadgIZYXrHi3mTRrfxmc=
X-Google-Smtp-Source: ABdhPJxHOez8UfUFF74TDZKGJNkXgRw+DkD5pcjsvwTevsgqS4RaCkwcuDHtzDeNCIDqvvslZPYOpA==
X-Received: by 2002:a05:6000:1548:b0:1f0:48bc:25de with SMTP id 8-20020a056000154800b001f048bc25demr1034142wry.17.1646241023334;
        Wed, 02 Mar 2022 09:10:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id g20-20020a05600c4ed400b003811fab7f3esm7666700wmq.30.2022.03.02.09.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 09:10:22 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <66b68bcc-8d7e-a5f7-5e6c-b2d20c26ab01@redhat.com>
Date:   Wed, 2 Mar 2022 18:10:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/2] Allow building vhost-user in BSD
Content-Language: en-US
To:     Sergio Lopez <slp@redhat.com>, qemu-devel@nongnu.org
Cc:     vgoyal@redhat.com, Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Thomas Huth <thuth@redhat.com>
References: <20220302113644.43717-1-slp@redhat.com>
 <20220302113644.43717-3-slp@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220302113644.43717-3-slp@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/2/22 12:36, Sergio Lopez wrote:
> With the possibility of using pipefd as a replacement on operating
> systems that doesn't support eventfd, vhost-user can also work on BSD
> systems.
> 
> This change allows enabling vhost-user on BSD platforms too and
> makes libvhost_user (which still depends on eventfd) a linux-only
> feature.
> 
> Signed-off-by: Sergio Lopez <slp@redhat.com>

I would just check for !windows.

Paolo

> ---
>   configure   | 5 +++--
>   meson.build | 2 +-
>   2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/configure b/configure
> index c56ed53ee3..93aa22e345 100755
> --- a/configure
> +++ b/configure
> @@ -1659,8 +1659,9 @@ fi
>   # vhost interdependencies and host support
>   
>   # vhost backends
> -if test "$vhost_user" = "yes" && test "$linux" != "yes"; then
> -  error_exit "vhost-user is only available on Linux"
> +if test "$vhost_user" = "yes" && \
> +    test "$linux" != "yes" && test "$bsd" != "yes" ; then
> +  error_exit "vhost-user is only available on Linux and BSD"
>   fi
>   test "$vhost_vdpa" = "" && vhost_vdpa=$linux
>   if test "$vhost_vdpa" = "yes" && test "$linux" != "yes"; then
> diff --git a/meson.build b/meson.build
> index 8df40bfac4..f2bc439c30 100644
> --- a/meson.build
> +++ b/meson.build
> @@ -2701,7 +2701,7 @@ if have_system or have_user
>   endif
>   
>   vhost_user = not_found
> -if 'CONFIG_VHOST_USER' in config_host
> +if targetos == 'linux' and 'CONFIG_VHOST_USER' in config_host
>     libvhost_user = subproject('libvhost-user')
>     vhost_user = libvhost_user.get_variable('vhost_user_dep')
>   endif

