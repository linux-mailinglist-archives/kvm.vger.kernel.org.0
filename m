Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966057D652C
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 10:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbjJYIbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 04:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbjJYIbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 04:31:45 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8072913A
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 01:31:41 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-407da05f05aso39499225e9.3
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 01:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698222700; x=1698827500; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RHTZm3wQVOwUIgOFYUJgqhN1NlzjTWcU0CvB9E7/Q/Q=;
        b=lof+xCgQtCGT+eseUKaO1Tr2qHtBolPTtJ07O8BFKEVkbmdpLQc5053173bdWS0y4Q
         C2C6s1ytFsr9/sbKCbqvgy73wXoY7hhy7B71hbgczLYQdUHpYLDsJskiPZrin7UJClFE
         5UIUfrMrFqFWrGyMpgfaTQyz0lwvE89olLLdsbZ686J3aZ0A463HB3udIA2S28boymKb
         6ApBGzJqw+t9/QScmG4zVdr2Fs8raUr0X3BayqYljFxmIh1KKaTeidk8azI6SqA6n0v9
         iMLvDldekUp4owAqBXsYuEjZk0tiLfQw5k+N+Ka1CubCXSwLHHWqE+qEpDXg/dS0Y1bg
         k4ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698222700; x=1698827500;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RHTZm3wQVOwUIgOFYUJgqhN1NlzjTWcU0CvB9E7/Q/Q=;
        b=cPnZNVQPj2olulq4rEoOzkhRJW9iynXQPw5No44wpGCUyrVl1iay0f36/8aE4RIZnb
         mjJB6h+p6sfq3ikT1yFbtzXObHCP1NVATF0xFhO62/f8dzXtkHchSLhDeth77iKvs5a4
         1KxuS4ej81z2Hy+NKc8QsGgCOHdQMCvVo2SBNzzmt7fhH7pCDoPA7JYKg5kqZOrE6dT1
         XRtFNrc2DRArrkl3gXQkA2dberMyRgh68ya5Vu0jSDfrQRLg81Fi6fUOmiM2vglm0XKc
         F8buoz4zXak38LezT19cscK0FKudbhA8dZfMwq0oNelixa4fb4If2jRReV2VCJGAlYQP
         SjWA==
X-Gm-Message-State: AOJu0YylXbOEUcZj4gmxMtGcUNq6HigZ7kmJNJUxwvLme/PDFQERBBa+
        Cr8EYLQySeFO4vjrVNxytUQ=
X-Google-Smtp-Source: AGHT+IGAXvbeLVBCYEZe6F7VZMLsxtQMTPHkP81y9foV4MoWfIvrV+0OlYKHUvO1abu02c0w57sJTg==
X-Received: by 2002:a5d:456d:0:b0:32d:90f7:ce46 with SMTP id a13-20020a5d456d000000b0032d90f7ce46mr10513836wrc.16.1698222699603;
        Wed, 25 Oct 2023 01:31:39 -0700 (PDT)
Received: from [192.168.16.6] (54-240-197-232.amazon.com. [54.240.197.232])
        by smtp.gmail.com with ESMTPSA id l21-20020a056000023500b003198a9d758dsm11674037wrz.78.2023.10.25.01.31.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Oct 2023 01:31:39 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <684d378d-9c71-4a5f-8f0c-3ed6ffc20a70@xen.org>
Date:   Wed, 25 Oct 2023 09:31:37 +0100
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
 <19fc2701-4cd8-4a14-9d45-bfaea37ed2d6@xen.org>
 <efdefcc11e2bd8c0f7e6e914dc9c54ffd65fe733.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <efdefcc11e2bd8c0f7e6e914dc9c54ffd65fe733.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/10/2023 17:34, David Woodhouse wrote:
> On Tue, 2023-10-24 at 17:25 +0100, Paul Durrant wrote:
>> On 24/10/2023 16:49, David Woodhouse wrote:
>>> On Tue, 2023-10-24 at 16:39 +0100, Paul Durrant wrote:
>>>> On 24/10/2023 16:37, David Woodhouse wrote:
>>>>> On Tue, 2023-10-24 at 15:20 +0100, Paul Durrant wrote:
>>>>>> On 16/10/2023 16:19, David Woodhouse wrote:
>>>>>>> From: David Woodhouse <dwmw@amazon.co.uk>
>>>>>>>
>>>>>>> The primary console is special because the toolstack maps a page at a
>>>>>>> fixed GFN and also allocates the guest-side event channel. Add support
>>>>>>> for that in emulated mode, so that we can have a primary console.
>>>>>>>
>>>>>>> Add a *very* rudimentary stub of foriegnmem ops for emulated mode, which
>>>>>>> supports literally nothing except a single-page mapping of the console
>>>>>>> page. This might as well have been a hack in the xen_console driver, but
>>>>>>> this way at least the special-casing is kept within the Xen emulation
>>>>>>> code, and it gives us a hook for a more complete implementation if/when
>>>>>>> we ever do need one.
>>>>>>>
>>>>>> Why can't you map the console page via the grant table like the xenstore
>>>>>> page?
>>>>>
>>>>> I suppose we could, but I didn't really want the generic xen-console
>>>>> device code having any more of a special case for 'Xen emulation' than
>>>>> it does already by having to call xen_primary_console_create().
>>>>>
>>>>
>>>> But doesn't is save you the whole foreignmem thing? You can use the
>>>> grant table for primary and secondary consoles.
>>>
>>> Yes. And I could leave the existing foreignmem thing just for the case
>>> of primary console under true Xen. It's probably not that awful a
>>> special case, in the end.
>>>
>>> Then again, I was surprised I didn't *already* have a foreignmem ops
>>> for the emulated case, and we're probably going to want to continue
>>> fleshing it out later, so I don't really mind adding it.
>>>
>>
>> True. We'll need it for some of the other more fun protocols like vkbd
>> or fb. Still, I think it'd be nicer to align the xenstore and primary
>> console code to look similar and punt the work until then :-)
> 
> I don't think it ends up looking like xenstore either way, does it?
> Xenstore is special because it gets to use the original pointer to its
> own page.
> 

Not sure what you mean there? A guest can query the PFN for either 
xenstore or console using HVM params, or it can find them in its own 
grant table entries 0 or 1.

> I don't think I want to hack the xen_console code to explicitly call a
> xen_console_give_me_your_page() function. If not foreignmem, I think
> you were suggesting that we actually call the grant mapping code to get
> a pointer to the underlying page, right?

I'm suggesting that the page be mapped in the same way that the xenstore 
backend does:

1462    /* 

1463     * We don't actually access the guest's page through the grant, 
because
1464     * this isn't real Xen, and we can just use the page we gave it 
in the
1465     * first place. Map the grant anyway, mostly for cosmetic 
purposes so
1466     * it *looks* like it's in use in the guest-visible grant table. 

1467     */
1468    s->gt = qemu_xen_gnttab_open();
1469    uint32_t xs_gntref = GNTTAB_RESERVED_XENSTORE;
1470    s->granted_xs = qemu_xen_gnttab_map_refs(s->gt, 1, xen_domid, 
&xs_gntref,
1471                                             PROT_READ | PROT_WRITE);


> 
> I could kind of live with that... except that Xen has this ugly
> convention that the "ring-ref" frontend node for the primary console
> actually has the *MFN* not a grant ref. Which I don't understand since
> the toolstack *does* populate the grant table for it (just as it does
> for the xenstore page). But we'd have to add a special case exception
> to that special case, so that in the emu case it's an actual grant ref
> again. I think I prefer just having a stub of foreignmem, TBH.
> 

You're worried about the guest changing the page it uses for the primary 
console and putting a new one in xenstore? I'd be amazed if that even 
works on Xen unless the guest is careful to write it into 
GNTTAB_RESERVED_CONSOLE.

> (I didn't yet manage to get Xen to actually create a primary console of
> type iomem, FWIW)
> 

No, that doesn't entirely surprise me.

   Paul

