Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349CB7D581E
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 18:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343853AbjJXQZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 12:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343557AbjJXQZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 12:25:25 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCEE111
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 09:25:23 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-4083f61322fso36956565e9.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 09:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698164721; x=1698769521; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UQsq2LWk3bVW9FNqtR4uLNXJWBJH5YdmWftR29dvZwY=;
        b=chEveNsa2As/c/ASQKCQ9h66ecgNpjnp9UpqqerbBT1yeuXYvui4DOGunOr7VlCcix
         HIWrOAU1oQnbL+WbD/LIjCVlxV1emwcaRL2VkkegGu8kYbfww1W+VXM5Mr0tEnD7mZnM
         ncJj43p8OvjOcrqLGuuZk7pduD98CeDH7Oi0K1aoDY6hmkH+XPWcKGrDm4wrF7F4+f3y
         SdWutzFb7r/5kfe1NXDtFX6HFoscf4mXruuSqiH/boCZ1zgsU7ng9dvCj5hDa9XP/bGD
         e6tMS4fTCWAkVhwAki6Subev94bPaOZaiArwUY2Vg5hWH7BmUZNn1eqZ/9Qco5sRr9vS
         TSZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698164721; x=1698769521;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQsq2LWk3bVW9FNqtR4uLNXJWBJH5YdmWftR29dvZwY=;
        b=NN8hjRzzKT0ALFq7t/GVYWspKh2y4qMKm1YB+5KQ06q74a9sJLfhryInGX9JEY+ZTY
         3zRePM86fryEjGNUyT9cpkETwgsfughZE9MIKvtPHiTgJmFzeTGRQ0Rj5SwLQ1/LYFpp
         uLeVqh/Bsw5gfl9a4SnTTFKjt6npE5mHyx3xerAiMshuoDMnREbY4LgaCmGHymPnQhei
         bdvHkVAP3+gNWI5ChMCYq2me0P7NIFGk4i/2HQGxQZNDO5GamX5GWO0C7b1r95LdbLEx
         Hp/eMd1YdhWnl7DPVc8E1/xseL8dvTszcYzSfR/SBNQbhphu+NbFbNGEOzl9WCkYw+yZ
         2+dA==
X-Gm-Message-State: AOJu0YzcZzoJ362ht+Z7pMHIki0BPI3MmA962VugR73lRzSOexrkbMjG
        rUh2hZJQufXxYTsV51gkl30=
X-Google-Smtp-Source: AGHT+IEyWeztiwQ8cM58Q3Udtb/rgzHp2VAypkAcc4XZaR7o8nmAoBYxpyNYOMgRGMHbHOA9ZtR7WQ==
X-Received: by 2002:a1c:790a:0:b0:406:5308:cfeb with SMTP id l10-20020a1c790a000000b004065308cfebmr9764626wme.11.1698164721279;
        Tue, 24 Oct 2023 09:25:21 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id p12-20020a05600c418c00b0040773c69fc0sm16842887wmh.11.2023.10.24.09.25.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 09:25:20 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <19fc2701-4cd8-4a14-9d45-bfaea37ed2d6@xen.org>
Date:   Tue, 24 Oct 2023 17:25:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 12/12] hw/xen: add support for Xen primary console in
 emulated mode
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org
References: <20231016151909.22133-1-dwmw2@infradead.org>
 <20231016151909.22133-13-dwmw2@infradead.org>
 <c18439ca-c9ae-4567-bbcf-dffe6f7b72e3@xen.org>
 <3acd078bba2d824f836b20a270c780dc2d031c43.camel@infradead.org>
 <3f22903b-30f0-40f2-8624-b681d9c7e05d@xen.org>
 <42b005d7c03d5b0d47a16c4e025d8c3ec7289e0f.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <42b005d7c03d5b0d47a16c4e025d8c3ec7289e0f.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2023 16:49, David Woodhouse wrote:
> On Tue, 2023-10-24 at 16:39 +0100, Paul Durrant wrote:
>> On 24/10/2023 16:37, David Woodhouse wrote:
>>> On Tue, 2023-10-24 at 15:20 +0100, Paul Durrant wrote:
>>>> On 16/10/2023 16:19, David Woodhouse wrote:
>>>>> From: David Woodhouse <dwmw@amazon.co.uk>
>>>>>
>>>>> The primary console is special because the toolstack maps a page at a
>>>>> fixed GFN and also allocates the guest-side event channel. Add support
>>>>> for that in emulated mode, so that we can have a primary console.
>>>>>
>>>>> Add a *very* rudimentary stub of foriegnmem ops for emulated mode, which
>>>>> supports literally nothing except a single-page mapping of the console
>>>>> page. This might as well have been a hack in the xen_console driver, but
>>>>> this way at least the special-casing is kept within the Xen emulation
>>>>> code, and it gives us a hook for a more complete implementation if/when
>>>>> we ever do need one.
>>>>>
>>>> Why can't you map the console page via the grant table like the xenstore
>>>> page?
>>>
>>> I suppose we could, but I didn't really want the generic xen-console
>>> device code having any more of a special case for 'Xen emulation' than
>>> it does already by having to call xen_primary_console_create().
>>>
>>
>> But doesn't is save you the whole foreignmem thing? You can use the
>> grant table for primary and secondary consoles.
> 
> Yes. And I could leave the existing foreignmem thing just for the case
> of primary console under true Xen. It's probably not that awful a
> special case, in the end.
> 
> Then again, I was surprised I didn't *already* have a foreignmem ops
> for the emulated case, and we're probably going to want to continue
> fleshing it out later, so I don't really mind adding it.
> 

True. We'll need it for some of the other more fun protocols like vkbd 
or fb. Still, I think it'd be nicer to align the xenstore and primary 
console code to look similar and punt the work until then :-)

   Paul
