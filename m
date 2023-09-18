Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B323B7A50D8
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjIRRVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjIRRVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:21:15 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E7CFB;
        Mon, 18 Sep 2023 10:21:08 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-99c3c8adb27so628135366b.1;
        Mon, 18 Sep 2023 10:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695057666; x=1695662466; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1mWBoR8cjvI28Qx4Es7Eis9ldLxd8cY4D2ygIGo/u3s=;
        b=nGP8wSxM/vdW7ZnlxqtvtC4FrTsmlbm0K5svF9PIBNAQhsJJ0QCIv97mGV0G71rvG8
         H2jIJEuR3oDuBxxlaEjxWX/szNALuxOmyMRatcnLLXhtRH4B2JtU2E7y7n+pQeyvW6XI
         306dl6lOJXfVVHQSH51TUOE/9MtFVOHerkVRPbYWO8zhx32rkRiEBTX9Ph5r1YYDCzFE
         EyG7x3phRHRhM0Jc+AVofZcYL1Vdgsghu0DzDa67Uh+TxhI6CpQb7VufFKWXTZJmwnvX
         svfi1gxu9z+1NCueEeJnNp+JYiAXQLf6qqXyaMEAHb9V1nNn+Agcmj/1IwPcNlnoIy7C
         hMqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695057666; x=1695662466;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1mWBoR8cjvI28Qx4Es7Eis9ldLxd8cY4D2ygIGo/u3s=;
        b=GfpSReb5YNoXSOPbFNyyBk7K2r8XP8iSJ7rNUOe/J8OaYNRc2ofuRGF569E9neFlLc
         1tAuegno9STqcyeKKnQLwds1PehSJGUo/GH4lBOmp6Io33tQylJhPqDuyROm053c0PVW
         veSrj/L68GuwSTYPJLY2lkbTN5D1SIugtheUytw1eelUegMEKimHTVd+zFWfZpbKY99Y
         r7IJ7/OXedUE8qCLtX6stUD3A0XdF6Mkr+rrEF3llTwSUcgjN+3hDR1LqcMR4g/+lqf6
         PhkaiogSkdHtalFjopwq2+wsYZ56g8AZqiHqBg7T/XiBKJNH2JzTtIlMdvPDwja/EPWi
         PV2Q==
X-Gm-Message-State: AOJu0YzNEtqgiJyDk7Dre16TrX2Fb9OJXN/KK35qAj3K6hZbXAVPKJqH
        sgnzc+dtP5PuBYdOvV6QODYeywqrRwdzNsht
X-Google-Smtp-Source: AGHT+IE+MgxWvuY/MatkBPDgOvaiawXCow9mDNPiq3/MNjOHjKkFFZSa3jadIZXNHMveQiM+8GJCKA==
X-Received: by 2002:adf:ed8f:0:b0:317:6e62:b124 with SMTP id c15-20020adfed8f000000b003176e62b124mr6834984wro.18.1695042051780;
        Mon, 18 Sep 2023 06:00:51 -0700 (PDT)
Received: from [192.168.7.59] (54-240-197-236.amazon.com. [54.240.197.236])
        by smtp.gmail.com with ESMTPSA id f2-20020a7bc8c2000000b003fed70fb09dsm12403002wml.26.2023.09.18.06.00.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 06:00:51 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <1b8d4928-fd39-6d8f-e254-bb5e72c740c1@xen.org>
Date:   Mon, 18 Sep 2023 14:00:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 05/12] KVM: pfncache: allow a cache to be activated
 with a fixed (userspace) HVA
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230918112148.28855-1-paul@xen.org>
 <20230918112148.28855-6-paul@xen.org>
 <e4ac95d3370b997c17ce6924425d693a7e856c7e.camel@infradead.org>
 <3cf7adca-aa69-4ac8-ca92-f10b1bd2e163@xen.org>
 <6ecf8daee684536ee2aa2b9b47f7926a05b5e664.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <6ecf8daee684536ee2aa2b9b47f7926a05b5e664.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/2023 13:59, David Woodhouse wrote:
> On Mon, 2023-09-18 at 13:11 +0100, Paul Durrant wrote:
>> On 18/09/2023 12:34, David Woodhouse wrote:
>>> On Mon, 2023-09-18 at 11:21 +0000, Paul Durrant wrote:
>>>> From: Paul Durrant <pdurrant@amazon.com>
>>>>
>>>> Some cached pages may actually be overlays on guest memory that have a
>>>> fixed HVA within the VMM. It's pointless to invalidate such cached
>>>> mappings if the overlay is moved so allow a cache to be activated directly
>>>> with the HVA to cater for such cases. A subsequent patch will make use
>>>> of this facility.
>>>>
>>>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
>>>
>>> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
>>>
>>> Btw, I think you have falsified some Reviewed-by: tags on the rest of
>>> the series. Remember, if they aren't literally cut and pasted, the
>>> magic gets lost. Just the same as Signed-off-by: tags. Never type them
>>> for someone else.
>>
>> Indeed. They were all copied and pasted.
> 
> I'm prepared to believe my fingers betrayed me and autocompleted
> @infradead.org for one or two of them when I meant to use the @amazon
> address, but surely not *all* of them that I reviewed last time round?
> 

Hmm. I guess I must have cut'n'pasted from the wrong place then. I'll be 
more careful.

   Paul

