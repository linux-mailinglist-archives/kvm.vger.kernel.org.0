Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D7074CAB2E
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 18:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243647AbiCBRKc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 12:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbiCBRKa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 12:10:30 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F2D43ED2
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 09:09:46 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id p9so3788222wra.12
        for <kvm@vger.kernel.org>; Wed, 02 Mar 2022 09:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QnhPHAEwKEep6fi2qjTPWjK7k2b0OUJeNp7TyqfWmlo=;
        b=cv3rLCKOI9yrY9jCCytYCSnWHCqjS82TZRdZcBNToTvc8qHjAihsufWLmRX+5midRV
         wYSIFsII/zB3kpii5CKY5ZgNApFNgtDsztw/TBDgUGOJe3ELIoEGNOJT5XDlVSEKp553
         WPOufDUeQTX12If1BQSTfmN1B0SGP1ZZFtUBArjjWI3NTvkAPOKHcyGrmS4gPwGeHuXP
         qSR4z+QDxdqLdiFeh87YGOk7Zj6L4eI9peSDSGqaX0qr4VIbFy20eycRjwmjdvRriRsS
         1r6G9fWrXPFX6W/+BxI8Q1HiFjBjXoh6HW4fTM5CUk5JatD0egaDZnrDyxbgQ9LyT6OC
         9c7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QnhPHAEwKEep6fi2qjTPWjK7k2b0OUJeNp7TyqfWmlo=;
        b=hdV98jfK3pZYtEIjKb/biUtyMmyU3OfKTvjyWQCwe0CnVzZPTuDk0uKgkCHswGo2d9
         WchK9VJjZny1k7HTt6jlTOqRywGIxQz2WysubDEzkfMVt/gVOqE0QasQpF4VwDPmh4ZM
         b/XzMPz2DugubRPmJxxB8+3DjGNAy9Y1Lt2zEjzm8L9rzl3Hdxt9pCrLABLijcLwfyI1
         NjTK2z2TUQU6A0iYlIa05NSWWB/I/jHbZY+bVlBLHCucwXd2ZzlXytRvMWd4X6kb0AwU
         RNcN0qmUcmPVYAWcag11Avrn9zUTGbNnRbUp7wfeg3EY0XV867hYRf/xy8laNK/UJPUF
         jhEA==
X-Gm-Message-State: AOAM531yxTH1YWb702xThn+IJODqLlBasq41yAQq/ZeroeZ0MXoYFboJ
        w934F+lUq7w2ueHeMRgOwTk=
X-Google-Smtp-Source: ABdhPJwwylKky8bpc1hAINxWZAxor2k/30WpWOvo+TxMMpNYaCQn0rmUzylWFa3jb9g7yAXjVEHgzw==
X-Received: by 2002:a05:6000:2a5:b0:1f0:2e57:82ab with SMTP id l5-20020a05600002a500b001f02e5782abmr3142605wry.515.1646240984956;
        Wed, 02 Mar 2022 09:09:44 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id c4-20020adfef44000000b001ef93c7bbb8sm12830070wrp.30.2022.03.02.09.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 09:09:44 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <d75f1eee-cf69-9783-1cde-14427e680360@redhat.com>
Date:   Wed, 2 Mar 2022 18:09:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 1/2] Allow returning EventNotifier's wfd
Content-Language: en-US
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Sergio Lopez <slp@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        qemu-devel@nongnu.org, vgoyal@redhat.com,
        Fam Zheng <fam@euphon.net>, kvm@vger.kernel.org,
        Jagannathan Raman <jag.raman@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, Matthew Rosato <mjrosato@linux.ibm.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Thomas Huth <thuth@redhat.com>
References: <20220302113644.43717-1-slp@redhat.com>
 <20220302113644.43717-2-slp@redhat.com>
 <20220302081234.2378ef33.alex.williamson@redhat.com>
 <20220302152342.3hlzw3ih2agqqu6c@mhamilton>
 <Yh+WESUBI9spkHvd@stefanha-x1.localdomain>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yh+WESUBI9spkHvd@stefanha-x1.localdomain>
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

On 3/2/22 17:06, Stefan Hajnoczi wrote:
>> I agree. In fact, that's what I implemented in the first place. I
>> changed to this version in which event_notifier_get_fd() is extended
>> because it feels more "correct". But yes, the pragmatic option would
>> be adding a new event_notifier_get_wfd().
>>
>> I'll wait for more reviews, and unless someone voices against it, I'll
>> respin the patches with that strategy (I already have it around here).
> I had the same thought looking through the patch before I read Alex's
> suggestion. A separate get_wfd() function makes sense to me.

And that's four with me. :)  It's not just pragmatic, I cannot imagine a 
case where the caller doesn't know exactly which of the two file 
descriptors they want.

Paolo
