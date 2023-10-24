Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906397D57BE
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 18:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbjJXQPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 12:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343906AbjJXPjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 11:39:21 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9229B
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:39:19 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id 38308e7fff4ca-2c50cd16f3bso66351071fa.2
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 08:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698161957; x=1698766757; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tlEmeIXZ50wWPACQtQWY4ubCrlx8dw20cymk7ZBn6mM=;
        b=gCtYR5IyZw9hLdMIpGcvA+fo1SaCcmwxcDPJeZpyshPyfyyuG30i4Nkvd/yOYlyDZ5
         Ib1UuQFOnT2MlWwCAbfb8q8ArKknk5wSvgzg9KnpqkQg37rl6YnVTTHPQEo8fcs9PbLc
         xoa5muMPLpQtNT6T+lyTHVOHBAYAomrF4LDmfdMJAKSceRkcJisAJru55fry6956Op6d
         vMlouYBViJOCNsW0eBSHGjMBWYDR57ha1Or24P21lP6tvl885v2R3Y6oLvC5puihMPZ4
         xAxnsnGTdDJSZ45wadymE7e1IptZwLG7+VRYDFH6G6ScLuWlfxSpaEGbdWVljjjKfW4c
         6w/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698161957; x=1698766757;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tlEmeIXZ50wWPACQtQWY4ubCrlx8dw20cymk7ZBn6mM=;
        b=HeuSTcuynrlocuwxUxl2huGnAoOoUVm+XKGjgrQgvjJiekO+yW9bf9GC8tyj8ypGka
         vIdmQlsEE7olndrgMd0MZs12j4Mg+ccP9Abja/UlKHoGGldtP+6NHcLLLC3Vk4QdGYza
         a4NyMP08GT7Zhv7wqCnm+7ta+NHVVyilPqSzE7ZnmYiUzk5F4lz8PiRFbbvCIHqMsmOx
         coAjy7vGIKwsjuxj+onSApAzs5kXw6FQkarV8pLdqkocuFcATx2fFXL0/tRHeA72Vw/I
         Kl3UDHfhAW6l29yTdiRUfN86X8IQV1XmZIcE+NPRC1PbkUomFgVu2BNIb/I0yRrbipVK
         oVgw==
X-Gm-Message-State: AOJu0YzYLuFJWNDI5arTQUKsALylJxjzapgwgye4J4udQXRbwJWLZQbY
        XaBW1d80BB1s5dwcfjAAJ2M=
X-Google-Smtp-Source: AGHT+IF0q/RHR9QB8PZoYcnAqa6LCHwv1hACOYhfgQS8+0Un8TgpeFTwgjZUGx/iI4BFscPRP+CgPA==
X-Received: by 2002:a2e:ba9e:0:b0:2c5:1ad0:e306 with SMTP id a30-20020a2eba9e000000b002c51ad0e306mr7448511ljf.8.1698161957367;
        Tue, 24 Oct 2023 08:39:17 -0700 (PDT)
Received: from [192.168.6.66] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id d17-20020a5d6451000000b0032da022855fsm10102024wrw.111.2023.10.24.08.39.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 08:39:16 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <3f22903b-30f0-40f2-8624-b681d9c7e05d@xen.org>
Date:   Tue, 24 Oct 2023 16:39:15 +0100
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
Organization: Xen Project
In-Reply-To: <3acd078bba2d824f836b20a270c780dc2d031c43.camel@infradead.org>
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

On 24/10/2023 16:37, David Woodhouse wrote:
> On Tue, 2023-10-24 at 15:20 +0100, Paul Durrant wrote:
>> On 16/10/2023 16:19, David Woodhouse wrote:
>>> From: David Woodhouse <dwmw@amazon.co.uk>
>>>
>>> The primary console is special because the toolstack maps a page at a
>>> fixed GFN and also allocates the guest-side event channel. Add support
>>> for that in emulated mode, so that we can have a primary console.
>>>
>>> Add a *very* rudimentary stub of foriegnmem ops for emulated mode, which
>>> supports literally nothing except a single-page mapping of the console
>>> page. This might as well have been a hack in the xen_console driver, but
>>> this way at least the special-casing is kept within the Xen emulation
>>> code, and it gives us a hook for a more complete implementation if/when
>>> we ever do need one.
>>>
>> Why can't you map the console page via the grant table like the xenstore
>> page?
> 
> I suppose we could, but I didn't really want the generic xen-console
> device code having any more of a special case for 'Xen emulation' than
> it does already by having to call xen_primary_console_create().
> 

But doesn't is save you the whole foreignmem thing? You can use the 
grant table for primary and secondary consoles.

   Paul

