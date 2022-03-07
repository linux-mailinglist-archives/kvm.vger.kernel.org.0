Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547664CF6B9
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 10:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbiCGJnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 04:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241076AbiCGJlt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 04:41:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7769666CBF
        for <kvm@vger.kernel.org>; Mon,  7 Mar 2022 01:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646645998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y+zHzclCF+KBdFtlbiqIco229vrhyO4TQmz2ouHkG1A=;
        b=g+S1fZfF+0Ek4rjm3A6AZ7Gs8do51dtylyInzlofnP9qT93OeqgcBARPVpEi9S8YvDfTjz
        QC3MYPlJa5OKXBTyWvEEOJ37jvo9eG654sAurqvKRsjB9UOtUTf5kosQnqCRAmUdtsLqf5
        DN+zwIlVi5PcMMIwxhBDAJH4VQePgOk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-tj7c5UO3O_q4o7vHWHz_fA-1; Mon, 07 Mar 2022 04:39:57 -0500
X-MC-Unique: tj7c5UO3O_q4o7vHWHz_fA-1
Received: by mail-wm1-f70.google.com with SMTP id d8-20020a05600c34c800b0037e3cd6225eso5053816wmq.6
        for <kvm@vger.kernel.org>; Mon, 07 Mar 2022 01:39:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y+zHzclCF+KBdFtlbiqIco229vrhyO4TQmz2ouHkG1A=;
        b=YZCo4VQJWbPOYSf8td7pkqqRjp6wMdzDDz8Zj5IipjvX9Drs9aB1P3x8YvWvOrW3t8
         kAZzpPSyWnSP/K9BWeW5DP8UMYPtqh34TREOFmKd8X9GWsu1n14IaV/wgEBaq4G5WoKs
         LQMeXc2iLZOMfTLhhZjKsnXHsruORkDRFYs8LjIiNUkNUZVhDV0C/VIHS5iTnFSpfLiv
         G3tvhuW3EJa8f5SU4mFidVZ97hB24hvMPvtJTeqnxmkFut5PjHM5ViKoxx9E6f9BInYh
         apn/r7h0IqC9+fTyhF6vOtfSCrPtaeNDt24qeBzNXdUcoJXywfiiOW3R9agpBgrb/X/N
         iQSg==
X-Gm-Message-State: AOAM530XWLhrtpjhmBXzzZm8t3ZsJW8fd4JeV2fvOPOSbeVcjRzVe4lJ
        W+Q8/9bNPCsm9xxNfi8iY3AlzjgRVkn1CnUMc83q4cpVwBxt7NuwkfNhx+Fdniet3yOyZHEQQlX
        f0t2kKeDax4zZ
X-Received: by 2002:a5d:4f06:0:b0:1f0:2346:36d9 with SMTP id c6-20020a5d4f06000000b001f0234636d9mr7284498wru.144.1646645996461;
        Mon, 07 Mar 2022 01:39:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxdWpAGLHK/5fP86BoIoYjLNL7sdwsPbRxxYRa+1Ghc7dEKTUHcP/nBFh+CeoqgrHoc8P6MHg==
X-Received: by 2002:a5d:4f06:0:b0:1f0:2346:36d9 with SMTP id c6-20020a5d4f06000000b001f0234636d9mr7284466wru.144.1646645996257;
        Mon, 07 Mar 2022 01:39:56 -0800 (PST)
Received: from [10.33.192.183] (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id p18-20020adfba92000000b001e4ae791663sm11329312wrg.62.2022.03.07.01.39.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 01:39:55 -0800 (PST)
Message-ID: <17257e9d-1a2b-2c8d-954d-090d262ce079@redhat.com>
Date:   Mon, 7 Mar 2022 10:39:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v4 3/4] configure, meson: allow enabling vhost-user on all
 POSIX systems
Content-Language: en-US
To:     Sergio Lopez <slp@redhat.com>, qemu-devel@nongnu.org
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-block@nongnu.org,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-s390x@nongnu.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>, vgoyal@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>
References: <20220304100854.14829-1-slp@redhat.com>
 <20220304100854.14829-4-slp@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
In-Reply-To: <20220304100854.14829-4-slp@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/03/2022 11.08, Sergio Lopez wrote:
> With the possibility of using a pipe pair via qemu_pipe() as a
> replacement on operating systems that doesn't support eventfd,
> vhost-user can also work on all POSIX systems.
> 
> This change allows enabling vhost-user on all non-Windows platforms
> and makes libvhost_user (which still depends on eventfd) a linux-only
> feature.
> 
> Signed-off-by: Sergio Lopez <slp@redhat.com>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   configure   | 4 ++--
>   meson.build | 2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/configure b/configure
> index c56ed53ee3..daccf4be7c 100755
> --- a/configure
> +++ b/configure
> @@ -1659,8 +1659,8 @@ fi
>   # vhost interdependencies and host support
>   
>   # vhost backends
> -if test "$vhost_user" = "yes" && test "$linux" != "yes"; then
> -  error_exit "vhost-user is only available on Linux"
> +if test "$vhost_user" = "yes" && test "$mingw32" = "yes"; then
> +  error_exit "vhost-user is not available on Windows"
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

Reviewed-by: Thomas Huth <thuth@redhat.com>

