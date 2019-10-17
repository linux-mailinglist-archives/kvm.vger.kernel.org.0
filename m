Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6C3DB135
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 17:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392815AbfJQPhH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 11:37:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390135AbfJQPhG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 11:37:06 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 56F367BDB2
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 15:37:06 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id h4so1136386wrx.15
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 08:37:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZoDnuvieE1vwdFJevEjTqU698vVlleevRIzQBYr+fco=;
        b=rBLQ9KANtuVPE6KHh2uhG1dYgguxjl+rqsNzjxD9VfKJ8aloggUOxGfNn3I2EEg+A2
         jWYs2UEunDsxXoQhNrFDhPvHFWR/v3/FL4V8Od63XGXcEVu20UtW76B2KBcwc/kFzajB
         AePipQimE+LHW3SKbIh6coMwB6hKFdiszUSORgdxQ6JSL/TEm+QTsr1VxTLS+/yeBvf/
         J09k0zOY3O5rKzDHLMvtHg/rMRjfHSLVjlzH4hyrlPyrAAZuLc1lRPkI6AoJgB0petlI
         5iNyoBUdQmzQKfowcsxAPbmvdoyk6B6IKxg+uG/YD7o5xTKs3iP2uzn6VQCzzXZ7Im3d
         QUnQ==
X-Gm-Message-State: APjAAAUYBk94uSskI/AsPwdAl3y5r08qYOFGBF8aN7jvUZRsaLeM6ABK
        7hv+IZrON3gVG0U3FuO7JWdk2NYGRmSn5p48fKTyux84wf2WQUvI6ooNJ3NJ+B0FbAZPiykid6s
        uFC7mdG7loKHz
X-Received: by 2002:a05:600c:2214:: with SMTP id z20mr3546233wml.10.1571326625047;
        Thu, 17 Oct 2019 08:37:05 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyFByCpFsOPI/D90wmVQpllY3A59GiUvIq918ytgRa2P+GX+b1/cFy2xEF+A9MVn2e0t84JKg==
X-Received: by 2002:a05:600c:2214:: with SMTP id z20mr3546210wml.10.1571326624845;
        Thu, 17 Oct 2019 08:37:04 -0700 (PDT)
Received: from [192.168.50.32] (243.red-88-26-246.staticip.rima-tde.net. [88.26.246.243])
        by smtp.gmail.com with ESMTPSA id c6sm2444560wrm.71.2019.10.17.08.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2019 08:37:04 -0700 (PDT)
Subject: Re: [PATCH 21/32] hw/i386/pc: Reduce gsi_handler scope
To:     Aleksandar Markovic <aleksandar.m.mail@gmail.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paul Durrant <paul@xen.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Herv=c3=a9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Markovic <amarkovic@wavecomp.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Richard Henderson <rth@twiddle.net>
References: <20191015162705.28087-1-philmd@redhat.com>
 <20191015162705.28087-22-philmd@redhat.com>
 <CAL1e-=hLUDDqFiV8W1f2PFGYJMomvmZUXmjA55X7WEEYMykjHQ@mail.gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
Message-ID: <8bcf9189-efbe-1575-7e57-fd7bdd202547@redhat.com>
Date:   Thu, 17 Oct 2019 17:37:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAL1e-=hLUDDqFiV8W1f2PFGYJMomvmZUXmjA55X7WEEYMykjHQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/17/19 5:16 PM, Aleksandar Markovic wrote:
> On Tuesday, October 15, 2019, Philippe Mathieu-Daudé <philmd@redhat.com 
> <mailto:philmd@redhat.com>> wrote:
> 
>     pc_gsi_create() is the single function that uses gsi_handler.
>     Make it a static variable.
> 
>     Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com
>     <mailto:philmd@redhat.com>>
>     ---
>       hw/i386/pc.c         | 2 +-
>       include/hw/i386/pc.h | 2 --
>       2 files changed, 1 insertion(+), 3 deletions(-)
> 
>     diff --git a/hw/i386/pc.c b/hw/i386/pc.c
>     index a7597c6c44..59de0c8a1f 100644
>     --- a/hw/i386/pc.c
>     +++ b/hw/i386/pc.c
>     @@ -346,7 +346,7 @@ GlobalProperty pc_compat_1_4[] = {
>       };
>       const size_t pc_compat_1_4_len = G_N_ELEMENTS(pc_compat_1_4);
> 
>     -void gsi_handler(void *opaque, int n, int level)
>     +static void gsi_handler(void *opaque, int n, int level)
>       {
>           GSIState *s = opaque;
> 
>     diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
>     index d0c6b9d469..75b44e156c 100644
>     --- a/include/hw/i386/pc.h
>     +++ b/include/hw/i386/pc.h
>     @@ -172,8 +172,6 @@ typedef struct GSIState {
>           qemu_irq ioapic_irq[IOAPIC_NUM_PINS];
>       } GSIState;
> 
>     -void gsi_handler(void *opaque, int n, int level);
>     -
>       GSIState *pc_gsi_create(qemu_irq **irqs, bool pci_enabled);
> 
> 
> Philippe, this 2-line deletion seems not to belong to this patch. If 
> true, please place it in another or a separate patch.

It does, this is the point of the change, make it static and remove its 
declaration :)
