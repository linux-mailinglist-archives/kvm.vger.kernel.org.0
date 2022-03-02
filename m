Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0394CAC3F
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240436AbiCBRjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:39:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238287AbiCBRi7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:38:59 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597B931235
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:38:15 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id e13so2188420plh.3
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 09:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WH0+qyWWHhV8of3aAofph+MQPHfJdu4kz/EMF0WIztU=;
        b=PulbCMbgEH+38j2aU0QpcfPYU0SWGN7ngqaEhoEo5kxg50T0PSDoRmsQUgBOjOld/F
         YxlyeRlpG7MJ0kEg2syixXQf9NfJuLU2Q1zOhr/jxtI85g0rTBu4qV6aXyKTbH2rhplI
         9oM6yqy84EZ6z1KyX3vRQxUjhlvtEJVqSfkx0UdUCbn20Yc3mutuWNmErlWiEqBxhWDG
         x7t/AzA4UbAo+SXThaaWMJXZeeFHs+Qqgp/9bQFgxk+VVWxhXzDphaBiSB7HoQ5l7NNs
         VohhbA+vhlCRLrJ9SL5+8CJ9aSnFeu43IJdTbtqHqgwolYA1ZWDd07HuzzhOM9RFkP02
         G/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WH0+qyWWHhV8of3aAofph+MQPHfJdu4kz/EMF0WIztU=;
        b=tOJk/RrmTDPADx3ZTOx2d1VTHKOGyE7Afrzt/CgJukC4nG1vb1IAHloJ41MGzpGWQm
         cmD0clcRfwjTWhzH2slNEgBmlrrMKKExxakHHrN8c7FAC7Lux9WmezaUyXWE+AXZ8D5z
         j3cWBURaxiPdYhwfLkcf4XO1abFXgycV+tAOwwv1M5T0D1QTqCpIhaqvqVVuAUYpNI22
         pWGhQLMbtJtzQnrnzWJELtapWIpLZPTZp3qjdvTOgonCvTy8RRtpzuMIrXJfgrrkUV++
         hMfEYwg393S5EsPVV+oz2sjyrFbJ3MaMhiS3YfT4Kiq0ov3AF1A4DJ0AL75CHVEKXZR+
         p5IQ==
X-Gm-Message-State: AOAM532IfHSa/MWKpdC0/ZWcAI4Qcg6zwHEb7kOSbT6xR1eg3YmTRMSu
        fAv47j5P2/eJHlLVkiFxjRY=
X-Google-Smtp-Source: ABdhPJx8K6gIn+cvPLthAImu2ZgCGqli+P0GJq859CmenB64iJaGRgs6Pw6TtxmdQDtyQMKV41EZ1g==
X-Received: by 2002:a17:90a:4e:b0:1bd:36ce:8150 with SMTP id 14-20020a17090a004e00b001bd36ce8150mr925058pjb.62.1646242694886;
        Wed, 02 Mar 2022 09:38:14 -0800 (PST)
Received: from [192.168.1.35] (71.red-83-50-68.dynamicip.rima-tde.net. [83.50.68.71])
        by smtp.gmail.com with ESMTPSA id y16-20020a056a00191000b004e155b2623bsm22513286pfi.178.2022.03.02.09.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 09:38:14 -0800 (PST)
Message-ID: <85ed0856-308a-7774-a751-b20588f3d9cd@gmail.com>
Date:   Wed, 2 Mar 2022 18:38:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 2/2] Allow building vhost-user in BSD
Content-Language: en-US
To:     Sergio Lopez <slp@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        vgoyal@redhat.com, Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
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
 <66b68bcc-8d7e-a5f7-5e6c-b2d20c26ab01@redhat.com>
 <8dfc9854-4d59-0759-88d0-d502ae7c552f@gmail.com>
 <20220302173009.26auqvy4t4rx74td@mhamilton>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>
In-Reply-To: <20220302173009.26auqvy4t4rx74td@mhamilton>
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

On 2/3/22 18:31, Sergio Lopez wrote:
> On Wed, Mar 02, 2022 at 06:18:59PM +0100, Philippe Mathieu-Daudé wrote:
>> On 2/3/22 18:10, Paolo Bonzini wrote:
>>> On 3/2/22 12:36, Sergio Lopez wrote:
>>>> With the possibility of using pipefd as a replacement on operating
>>>> systems that doesn't support eventfd, vhost-user can also work on BSD
>>>> systems.
>>>>
>>>> This change allows enabling vhost-user on BSD platforms too and
>>>> makes libvhost_user (which still depends on eventfd) a linux-only
>>>> feature.
>>>>
>>>> Signed-off-by: Sergio Lopez <slp@redhat.com>
>>>
>>> I would just check for !windows.
>>
>> What about Darwin / Haiku / Illumnos?
> 
> It should work on every system providing pipe() or pipe2(), so I guess
> Paolo's right, every platform except Windows. FWIW, I already tested
> it with Darwin.

Wow, nice.

So maybe simply check for pipe/pipe2 rather than !windows?
