Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB98241C65A
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 16:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245716AbhI2OKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 10:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245305AbhI2OKf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 10:10:35 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0BCC06161C
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 07:08:54 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id x20so4482600wrg.10
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 07:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=svrRv0XyORDGMpmxqjDfblXW/06vbWjyctuzECFZxVc=;
        b=KEbI4PpdnAJAkEhASUh8fCyioDUJeeYjO22/5kk/gatLjuXW2OxtvD/AjI6uTjaFyN
         FjzjclyiiY9TMN16LTjgVhEuzB0kox5zR9JR4PvdEaHKdLTCb1t8PTMFxbLq78UDYv+w
         Elz9zkyuWecQ1uFDxDmKjqZObiRDqiZErBmfY0zosgnHetBVwM7WFz7Rt6Byi3qJ5qsg
         L8yZeaFNNEyrntxLtuG0REhcjG4W3n43/cQkP8psgG7eRDkVsnpE7/etHtGEwxN+5CAs
         wNJydd9qzUOtr3D9ZGPiARe1jJxbqYs05oJYOnaISQv99y7pGGnO39OmwzrDFF48ZzFv
         FIZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=svrRv0XyORDGMpmxqjDfblXW/06vbWjyctuzECFZxVc=;
        b=xvgqQMnhtUdfkuK2k7+N/Q2Q/BpEaeHOWMuUO/CseARRDejV537cJ0T3VEdQacZA/6
         oFARoEF4xlKufDZTfiYke9Wfe00IMZqCvFXdj5XflIPu+5vmL3DfayEKtCDBy3JkityN
         CWYZ7mLFA6/Qz/2sdZiw3SSV0lQd4NIGZ9et+Th0Sv+NPF6UqT9ErLdsCsfNKixEeT4u
         4+s8weWPn9QKwprO7+uRUgvreY4oaPU9Uv2rEBFji0jCTKUdj4tMWW2c6bfD1J10ElpM
         s+cchWs78KN3N4z/P4HvlI26S9YkvLdE0Fijg78n1lvqM/LaYrKOzJJc6f0XmSzG5I8k
         sqQg==
X-Gm-Message-State: AOAM532opJZ8oc9kRTzCcVbHS6fDi4sjpH08xcoXFUtOYXH7TpzTpVPX
        eq29KOv0RLxAYgS+8pDEATo=
X-Google-Smtp-Source: ABdhPJyUuoHPR12MezR6X6ntcJJfVDokKgmpmb7Urrbyc4KG85LZAUTxqECeJeX8e27uWsnNYbnByQ==
X-Received: by 2002:a05:6000:8e:: with SMTP id m14mr12308wrx.308.1632924533309;
        Wed, 29 Sep 2021 07:08:53 -0700 (PDT)
Received: from [192.168.1.36] (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id s2sm25097wru.3.2021.09.29.07.08.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 07:08:52 -0700 (PDT)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
Message-ID: <f3e89488-0d05-657a-34f7-060a7250517d@amsat.org>
Date:   Wed, 29 Sep 2021 16:08:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] target/i386: Include 'hw/i386/apic.h' locally
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org,
        QEMU Trivial <qemu-trivial@nongnu.org>
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Colin Xu <colin.xu@intel.com>, haxm-team@intel.com,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Wenchao Wang <wenchao.wang@intel.com>
References: <20210902152243.386118-1-f4bug@amsat.org>
 <a4cba848-e668-7cf1-fe93-b5da3a4ac6dc@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>
In-Reply-To: <a4cba848-e668-7cf1-fe93-b5da3a4ac6dc@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/16/21 00:05, Paolo Bonzini wrote:
> On 02/09/21 17:22, Philippe Mathieu-Daudé wrote:
>> Instead of including a sysemu-specific header in "cpu.h"
>> (which is shared with user-mode emulations), include it
>> locally when required.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
>> ---
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thank you, Cc'ing qemu-trivial@ :)
