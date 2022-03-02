Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421B04CAE8C
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 20:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbiCBTXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 14:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237740AbiCBTWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 14:22:53 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18D86D970
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 11:22:09 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id m22so2699481pja.0
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 11:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GowkojXAz1wkAT6+sYRVxmC+1jzWkyvWgoOaFe2GzAI=;
        b=TrbuYO86toBF9+xXdvV9SuFJYOCKaEChA5oo5DUCZZRpbgdJSFdUg6HSnusoANKepT
         YwAGDGoUZlK4MhOdjn4TW5IT/lFHPVqjfgxTXRKqIbYnYPJwF2Z0Nx2sbiy8/eZ29fSn
         KmkBPJ6ZgZDvUx7FB0egK26lxKvQNV1/WEAt0ynYVx9QxmlwR1Ajw0rTTLFnHVjC0wmt
         2tRk2SUClhg8oL2ZFsqJ6IOjs8ReGLyDWBzVk3KC0mYoXpXTCNkpqHEhbUUhn4ECrC8z
         hHSEHspUfrWUdQnE+X0KYwT2N/x+vmuoyCW9LjPPgT0FIjSQcGRpjyvTWsYjkBBV05HR
         7NoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GowkojXAz1wkAT6+sYRVxmC+1jzWkyvWgoOaFe2GzAI=;
        b=fsWsACuD6i7BL3pxhv3dO1xQOQbsbl5d59zENB3m4g2MXsTJfCI9R6iFmumgGhTrJA
         47MoMcPsYQXYJgbuhtPIhDOIRPTr/aBzJvX5Dght5NVkRX2csTZLfVaf7s6nNMvYF3X+
         U4YN6HpJ9lYAoBThXzP2XfkYBl7PC5Wdj3ouDnOv/7JiUeOMdouOemM8ixZR728i6hkM
         e7DHhY48rmhfy+n6IokbkkdXxXII075aAXzc+VaYdqdKDMA7ePa+pJTes+/0TWUzgn/A
         iSynRTJEewz5aYhB0fmoKBawE7r3wVuGJAtKU6PrSJF5Rzf2WXY7tvra7+DpKdSkT4Rz
         8LDw==
X-Gm-Message-State: AOAM5321nR7mVGgnSJTLQfkTg2lMd9LKSXr4UYUlbTz6cw0CWIHAD6S6
        4Qj8DbcAZKiUn5Ktj/WvDhY=
X-Google-Smtp-Source: ABdhPJxpQMG1YVjUuU1HVDKoxItlkxdQTlC7TRrzQY4Skr4NFwEQxm3vqKHErao0vcxCxFiHoC1p+g==
X-Received: by 2002:a17:90a:ba07:b0:1bc:a0fd:faf with SMTP id s7-20020a17090aba0700b001bca0fd0fafmr1357961pjr.194.1646248929362;
        Wed, 02 Mar 2022 11:22:09 -0800 (PST)
Received: from [192.168.1.35] (71.red-83-50-68.dynamicip.rima-tde.net. [83.50.68.71])
        by smtp.gmail.com with ESMTPSA id t5-20020a17090ae50500b001bc4ec15949sm5828982pjy.2.2022.03.02.11.22.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 11:22:08 -0800 (PST)
Message-ID: <62af5861-15da-da1a-8546-cf3b33806c38@gmail.com>
Date:   Wed, 2 Mar 2022 20:22:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 2/2] Allow building vhost-user in BSD
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>
Cc:     Sergio Lopez <slp@redhat.com>, Fam Zheng <fam@euphon.net>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-devel@nongnu.org,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, qemu-block@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        vgoyal@redhat.com, Eric Farman <farman@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20220302113644.43717-1-slp@redhat.com>
 <20220302113644.43717-3-slp@redhat.com>
 <66b68bcc-8d7e-a5f7-5e6c-b2d20c26ab01@redhat.com>
 <8dfc9854-4d59-0759-88d0-d502ae7c552f@gmail.com>
 <20220302173009.26auqvy4t4rx74td@mhamilton>
 <85ed0856-308a-7774-a751-b20588f3d9cd@gmail.com>
 <Yh+vniMOTFt2npIJ@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>
In-Reply-To: <Yh+vniMOTFt2npIJ@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/22 18:55, Daniel P. Berrangé wrote:
> On Wed, Mar 02, 2022 at 06:38:07PM +0100, Philippe Mathieu-Daudé wrote:
>> On 2/3/22 18:31, Sergio Lopez wrote:
>>> On Wed, Mar 02, 2022 at 06:18:59PM +0100, Philippe Mathieu-Daudé wrote:
>>>> On 2/3/22 18:10, Paolo Bonzini wrote:
>>>>> On 3/2/22 12:36, Sergio Lopez wrote:
>>>>>> With the possibility of using pipefd as a replacement on operating
>>>>>> systems that doesn't support eventfd, vhost-user can also work on BSD
>>>>>> systems.
>>>>>>
>>>>>> This change allows enabling vhost-user on BSD platforms too and
>>>>>> makes libvhost_user (which still depends on eventfd) a linux-only
>>>>>> feature.
>>>>>>
>>>>>> Signed-off-by: Sergio Lopez <slp@redhat.com>
>>>>>
>>>>> I would just check for !windows.
>>>>
>>>> What about Darwin / Haiku / Illumnos?
>>>
>>> It should work on every system providing pipe() or pipe2(), so I guess
>>> Paolo's right, every platform except Windows. FWIW, I already tested
>>> it with Darwin.
>>
>> Wow, nice.
>>
>> So maybe simply check for pipe/pipe2 rather than !windows?
> 
> NB that would make the check more fragile.
> 
> We already use pipe/pipe2 without checking for it, because its
> usage is confined to oslib-posix.c and we know all POSIX
> OS have it. There is no impl at all of qemu_pipe in oslib-win.c
> and the declaration is masked out too in the header file.
> 
> Thus if we check for pipe2 and windows did ever implement it,
> then we would actually break the windows build due to qemu_pipe
> not existing.
> 
> IOW, checking !windows matches our logic for picking oslib-posix.c
> in builds and so is better than checking for pipe directly.

OK I see, thanks.
