Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00E63E92E7
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 15:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhHKNoi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 09:44:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56522 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231783AbhHKNoe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 09:44:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628689450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hmopy3H4HvEde9n0nmsQQj/cbkeiJGdAmXdPWIvCP0I=;
        b=RNNvQdjeJbKq8BARft80Laxs7ZPaCck3ZCQEtBl9ZbRhzRkVAWLTUnRJ8QMCSP762iHwIb
        g412RqVbkLFrU1O4pFBAThuN9B2JB1zE/g112hiEyLMBru8ueskwTdBudf1L9kgUWtwy4q
        yVtOyo7cnnzEOGWK26JvWV02VIx+c3U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-QYElDUcLMhWqeEfKAo6P4A-1; Wed, 11 Aug 2021 09:44:09 -0400
X-MC-Unique: QYElDUcLMhWqeEfKAo6P4A-1
Received: by mail-wm1-f72.google.com with SMTP id y186-20020a1c32c30000b02902b5ac887cfcso2128132wmy.2
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 06:44:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hmopy3H4HvEde9n0nmsQQj/cbkeiJGdAmXdPWIvCP0I=;
        b=oMs719Q8sBXyeAgnIFUHqhYf80UeTFpczyOLuc1EmwqkOry7sQq+qjzG4qTJdKTkuJ
         g/1LXJP5M0WP9oKWTQEwt8SBIbrmYUbgONu8Bb/H+amYKV5Q3BxUqWfj+WlG6onqStnv
         g3iztQs86Vfe5cKOtnScCEIU/81bezlFUnk4AkEuE1z/yqBR7mkcjHwkIdjmSN+u2ENq
         3aOOTJb/iSzpI/Fb6y8ZX5SRuuRyJTy9R+M4W4AdNQR+1XCrjckWY+qNvoG9eGGih0mR
         EAI1/b066Tx2aB1pbdrtxHVKtk1xBt5rYvAeEkvqRZKfFoCa/ucWCI75Hw6hNFWDjioa
         arBA==
X-Gm-Message-State: AOAM530OCoUDmM1VijgPiZi1++/S4D96bpDGfPtNlNePerxEukkQkFET
        646tTCxX1gvoGtiIScNdVzZK1k+1vk+7Cs45nh/CdE+siZ4RpE4a/mYpA0epDJ1btTsBZm+0XYh
        ZyruL4+8vWDpb
X-Received: by 2002:a7b:c351:: with SMTP id l17mr27846566wmj.120.1628689448098;
        Wed, 11 Aug 2021 06:44:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjVf7dNam3Hv+bCxIXIfmKoWZ6b9ZeOA8O+47JJPxIz/oOX7tKz4j7KMqww6iXSoPKacYkAg==
X-Received: by 2002:a7b:c351:: with SMTP id l17mr27846551wmj.120.1628689447908;
        Wed, 11 Aug 2021 06:44:07 -0700 (PDT)
Received: from thuth.remote.csb (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id e3sm13307995wro.15.2021.08.11.06.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 06:44:07 -0700 (PDT)
Subject: Re: [PATCH v12] qapi: introduce 'query-x86-cpuid' QMP command.
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
References: <20210728125402.2496-1-valeriy.vdovin@virtuozzo.com>
 <87eeb59vwt.fsf@dusky.pond.sub.org>
 <20210810185644.iyqt3iao2qdqd5jk@habkost.net>
 <2191952f-6989-771a-1f0a-ece58262d141@redhat.com>
 <CAOpTY_qbsqh9Tf8LB3EOOi_gkREotdpUyuF3-d_sBFsof3-9KQ@mail.gmail.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <97ce9800-ff69-46cd-b6ab-c7645ee10d2c@redhat.com>
Date:   Wed, 11 Aug 2021 15:44:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAOpTY_qbsqh9Tf8LB3EOOi_gkREotdpUyuF3-d_sBFsof3-9KQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/08/2021 15.40, Eduardo Habkost wrote:
> On Wed, Aug 11, 2021 at 2:10 AM Thomas Huth <thuth@redhat.com> wrote:
>>
>> On 10/08/2021 20.56, Eduardo Habkost wrote:
>>> On Sat, Aug 07, 2021 at 04:22:42PM +0200, Markus Armbruster wrote:
>>>> Is this intended to be a stable interface?  Interfaces intended just for
>>>> debugging usually aren't.
>>>
>>> I don't think we need to make it a stable interface, but I won't
>>> mind if we declare it stable.
>>
>> If we don't feel 100% certain yet, it's maybe better to introduce this with
>> a "x-" prefix first, isn't it? I.e. "x-query-x86-cpuid" ... then it's clear
>> that this is only experimental/debugging/not-stable yet. Just my 0.02 €.
> 
> That would be my expectation. Is this a documented policy?
> 

According to docs/interop/qmp-spec.txt :

  Any command or member name beginning with "x-" is deemed
  experimental, and may be withdrawn or changed in an incompatible
  manner in a future release.

  Thomas

