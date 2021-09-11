Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6359E407AAC
	for <lists+kvm@lfdr.de>; Sun, 12 Sep 2021 00:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhIKWcv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Sep 2021 18:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhIKWcu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Sep 2021 18:32:50 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E78C061574
        for <kvm@vger.kernel.org>; Sat, 11 Sep 2021 15:31:36 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id x6so8242579wrv.13
        for <kvm@vger.kernel.org>; Sat, 11 Sep 2021 15:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XT2R7gKOwJquO7Q7cTHp+dmuaUe/Pu9W6ODttpllYz4=;
        b=b2bJ2Px663Jyjjkb4rwi1aTGvhuL68k7L2E3bYKODogP2gfA7vnE94/Auh+BX5f7F7
         IxAnhUJZds4iYuJFkhOWmjPofJSvqsbY6WrkuCnbGGERgS7cEZpOTBt8aGtsMphs3VdL
         OX7vLhAYsbzT1EtpdVSRJ+DsVngeojmqXv8cuod8qKxMs0MSJEIaY+EzM+woIw6H4XEE
         lBGZfspthJ6BKFB8kK12vVadMcMIRo8lSQ57dn2P6T17nDCFuA+vhJwv2Mz6IUmkb0Tm
         QO8w2SRNdXbcd+NxpGfvtUBJsh+DJxXGgeo6OTlxBvI3gYTGhzuF6QLiOvSlqJK2+8mh
         HKEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:subject:from:to:cc:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XT2R7gKOwJquO7Q7cTHp+dmuaUe/Pu9W6ODttpllYz4=;
        b=cApwIbIyliAb2Fm8K96X2O7hqGw0YAjOmJQig6Ii0DFaHqRsir35erXh8bqbjYZjgl
         xIdLcMgl5lHKzmBWzv5XgMViJW1Iv74QlgEnB8NfoDBqp+MdlnzMegkmxwq0xcf2xEa4
         X5NCayx+MIAdri0ND5jP1pHA8w1zS4g+iyVHFQvALkGpq15487ZtLjYb1B3pNEgtVTBi
         6aG6YTE7A6c8bkNShZW7Y2XzCI4O49+bR43Mxj5dzMQmAztTHyQAaVlM5D+Yhhinsecr
         Q3X8123aP8f7ZbujxMkMQvE7lG6QaBX1ujcCi8W7kilPZd5hSXjTJU+DrLqJpQTqzvk6
         iPSg==
X-Gm-Message-State: AOAM530qm4DKInH+qRlXrKMbFwCfa60c3zmJTJDmWZqhPbmM8+DtYl+J
        UaMSPbwg+gQ55Zxh8f/zAGI=
X-Google-Smtp-Source: ABdhPJwCU/eok/l7PQWSv0uFfyt3OLV/3TdzjV/d32F7wAyFIbNaXVYENwr0FBRMDcjW3s4ZBOaI7w==
X-Received: by 2002:adf:916f:: with SMTP id j102mr4796451wrj.422.1631399495458;
        Sat, 11 Sep 2021 15:31:35 -0700 (PDT)
Received: from [192.168.1.36] (21.red-83-52-55.dynamicip.rima-tde.net. [83.52.55.21])
        by smtp.gmail.com with ESMTPSA id f1sm2689415wri.43.2021.09.11.15.31.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 15:31:34 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Subject: Re: [PATCH v3 21/30] target/ppc: Introduce
 PowerPCCPUClass::has_work()
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
To:     Richard Henderson <richard.henderson@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Chris Wulff <crwulff@gmail.com>, kvm@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Bin Meng <bin.meng@windriver.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-devel@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Taylor Simpson <tsimpson@quicinc.com>, haxm-team@intel.com,
        Colin Xu <colin.xu@intel.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marek Vasut <marex@denx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Paul Durrant <paul@xen.org>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Claudio Fontana <cfontana@suse.de>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        xen-devel@lists.xenproject.org,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Cameron Esfahani <dirty@apple.com>, qemu-s390x@nongnu.org,
        qemu-arm@nongnu.org, Michael Rolnik <mrolnik@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-ppc@nongnu.org,
        Stafford Horne <shorne@gmail.com>, qemu-riscv@nongnu.org,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Cornelia Huck <cohuck@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Aurelien Jarno <aurelien@aurel32.net>
References: <20210902161543.417092-1-f4bug@amsat.org>
 <20210902161543.417092-22-f4bug@amsat.org> <YTFxZb1Vg5pWVW9p@yekko>
 <fd383a02-fb9f-8641-937f-ebe1d8bb065f@linaro.org>
 <fc98e293-f2ba-8ca0-99c8-f07758b79d73@amsat.org>
Message-ID: <a49e0100-74d1-2974-990f-a05f9f796cc5@amsat.org>
Date:   Sun, 12 Sep 2021 00:31:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <fc98e293-f2ba-8ca0-99c8-f07758b79d73@amsat.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/21 11:11 PM, Philippe Mathieu-Daudé wrote:
> On 9/3/21 10:42 PM, Richard Henderson wrote:
>> On 9/3/21 2:50 AM, David Gibson wrote:
>>> On Thu, Sep 02, 2021 at 06:15:34PM +0200, Philippe Mathieu-Daudé wrote:
>>>> Each POWER cpu has its own has_work() implementation. Instead of
>>>> overloading CPUClass on each PowerPCCPUClass init, register the
>>>> generic ppc_cpu_has_work() handler, and have it call the POWER
>>>> specific has_work().
>>>
>>> I don't quite see the rationale for introducing a second layer of
>>> indirection here.  What's wrong with switching the base has_work for
>>> each cpu variant?
>>
>> We're moving the hook from CPUState to TCGCPUOps.
>> Phil was trying to avoid creating N versions of
>>
>> static const struct TCGCPUOps ppc_tcg_ops = {
>>     ...
>> };
> 
> Ah yes this is the reason! Too many context switching so
> I forgot about it.
> 
>> A plausible alternative is to remove the const from this struct and
>> modify it, just as we do for CPUState, on the assumption that we cannot
>> mix and match ppc cpu types in any one machine.
> 
> I thought about this case and remembered how it works on the ARM arch,
> i.e. ZynqMP machine uses both Cortex-R5F and Cortex-A53. Even if no
> similar PPC machine exists, IMHO we should try to generally allow to
> possibility to experiment machine with different CPUs. Restricting it
> on PPC goes the other way around. Thoughts?

I'm running out of ideas to do avoid the indirection and multiple
copies of TCGCPUOps. I'm not giving up, I suppose I'm simply not
seeing it... David, any suggestions?
