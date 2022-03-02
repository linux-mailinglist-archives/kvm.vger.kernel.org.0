Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C254CAB68
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243749AbiCBRT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243796AbiCBRTw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:19:52 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131F5C7E9E
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:19:09 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id i1so2142622plr.2
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 09:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=osi9O0VV1sOz8Hi7PeR3obUSFPu9+F2zWbPoIlHuOlU=;
        b=ZRKhXBAcKjsGbAdq1wmYgrE+k6hxDe3EZJu1mRhb8+JyAGF3ywfTNCafRZJp97UWL1
         6y++snXIzl86zSeQVHRMdKKtKoP/FYzYl5z38L8R+M8ALlximDMvi3h3HS0Hd76MdgEj
         TIEJ1PaaWSkizU6C8SjXfTECCvq024QgNdPIdVdQw+sZW+tNljlmOJ1wnTwy3Tl8reCX
         Xhwk3h32nJwkGUS27IpQfCJ7KNMvKSH1NP6Dy7pv0bjxJ9f/z+rPJpbde0wxw1Pq1+Oi
         Du9QH+ww3jX+CA4yrNX9FsI9OhmR1miUJr5KHIWOsZVy8V7OxowS95AOQUKNNLFAxKQ3
         1KRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=osi9O0VV1sOz8Hi7PeR3obUSFPu9+F2zWbPoIlHuOlU=;
        b=Iu3qZUhUlaaxsWfvYBlGdKCEq3KIfSsDRqrwxBYzNeS8MWykEEaEh9Msl7lHIX0M3n
         JBVUbGIgEPBJ8FjpttkGhsM70BrKWjLKADq3+PLQXOc8kk/auJt1NA2fKpMJN5QTSe7/
         SWUpvWS6Ij+FtPtRy4CNN4jw8V/KlWzGyvr5dCs76O3pNVHygwQk2zIQICiax5U12VZv
         kZeijRye6vEFFdQSbYb+xXkwm7nIh8JLodM6XaUlCjQJpxYIDxZVKlk3N5cnjv/0Io4Y
         bR7S+qZyUcJqwf7sAJY/whAVMp5OpA+ULW7mFA2d6TgVgO10Bf7drC0qkLkZMRexmvW6
         QjiQ==
X-Gm-Message-State: AOAM5333yg0kQMFdfpVqRBU2uUxTZmEDQji6+uvQCK1pktljpXWuO7QC
        YKc+BI/feTUd9/BJkCmFVh0=
X-Google-Smtp-Source: ABdhPJyB5MLRYKAl+2/w1OwwNzXz0ex2//9FEpEJe1Su5thGMrlaQQQNCGD7Ft8PtuTn7UhgorxRFw==
X-Received: by 2002:a17:902:c111:b0:14f:c841:66e2 with SMTP id 17-20020a170902c11100b0014fc84166e2mr31827638pli.92.1646241548513;
        Wed, 02 Mar 2022 09:19:08 -0800 (PST)
Received: from [192.168.1.35] (71.red-83-50-68.dynamicip.rima-tde.net. [83.50.68.71])
        by smtp.gmail.com with ESMTPSA id d17-20020a056a00245100b004c283dcbbccsm21324325pfj.176.2022.03.02.09.19.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 09:19:07 -0800 (PST)
Message-ID: <8dfc9854-4d59-0759-88d0-d502ae7c552f@gmail.com>
Date:   Wed, 2 Mar 2022 18:18:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH 2/2] Allow building vhost-user in BSD
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, Sergio Lopez <slp@redhat.com>,
        qemu-devel@nongnu.org
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
 <66b68bcc-8d7e-a5f7-5e6c-b2d20c26ab01@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>
In-Reply-To: <66b68bcc-8d7e-a5f7-5e6c-b2d20c26ab01@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/3/22 18:10, Paolo Bonzini wrote:
> On 3/2/22 12:36, Sergio Lopez wrote:
>> With the possibility of using pipefd as a replacement on operating
>> systems that doesn't support eventfd, vhost-user can also work on BSD
>> systems.
>>
>> This change allows enabling vhost-user on BSD platforms too and
>> makes libvhost_user (which still depends on eventfd) a linux-only
>> feature.
>>
>> Signed-off-by: Sergio Lopez <slp@redhat.com>
> 
> I would just check for !windows.

What about Darwin / Haiku / Illumnos?
