Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34C5EBC8F9
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 15:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbfIXNer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Sep 2019 09:34:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728300AbfIXNer (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Sep 2019 09:34:47 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ECF398E582
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 13:34:46 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id 4so17587wmj.6
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 06:34:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x8E8jJI8ppVYKUnDaKsY7fIXB00wM8h99RHCrtkZMJY=;
        b=oQ6p03zMrDBw4jnd8phqqaXCbfECXkrVCwN3P6PoGMBxUhLhA94j+xGYTPPR7J8uxJ
         Xe2sijktfMse77EIiyJ5J//XHWcCfsMyyKv0eL+9wRk3IHZyTn5oHY4G0YD2jJeR6ILP
         I+pNoGQK/YQO4r3ia9UFtMsQMHsYDP7XhWqBdMvlXLjkkIXu9OPgMBVQcttVHRUqBuhf
         24WEyqJEiJfD9Ny3TEHB6/piPaVipiMnXajgZl4U1InfkRQYbmeRhChtGL2u8sFGO1tM
         6sDY4mErl38OG+EjfMunq1R+Kc239BJ1/mFijzvqkymhlkCxlBA/cMnwYjRt1GOQNlY8
         9orA==
X-Gm-Message-State: APjAAAX3AxCN34bgGWO6XSr8Mo8OjuiQPTZbn4irHILeEpaoWkFb1WsI
        7ABqz76GPwSoZ67PZ7/X5H0WGKb4AxnOpKAZ5RzU2E5b6uiGtBhMSztN+ShXJOXHNB3ar+b1Pvj
        T2C6wYbj8AuUU
X-Received: by 2002:a05:6000:162e:: with SMTP id v14mr2417627wrb.112.1569332082362;
        Tue, 24 Sep 2019 06:34:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzDHK+EXK5B0OIXOAT49NMwdLfyjrS5AP66vchxyMwjBlNGDUVHtaDt/ilNGZexHYZQsn3H2A==
X-Received: by 2002:a05:6000:162e:: with SMTP id v14mr2417594wrb.112.1569332082028;
        Tue, 24 Sep 2019 06:34:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id t13sm5090317wra.70.2019.09.24.06.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Sep 2019 06:34:41 -0700 (PDT)
Subject: Re: [PATCH v4 8/8] hw/i386: Introduce the microvm machine type
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Sergio Lopez <slp@redhat.com>, qemu-devel@nongnu.org,
        imammedo@redhat.com, marcel.apfelbaum@gmail.com, rth@twiddle.net,
        ehabkost@redhat.com, philmd@redhat.com, lersek@redhat.com,
        kraxel@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org
References: <20190924124433.96810-1-slp@redhat.com>
 <20190924124433.96810-9-slp@redhat.com>
 <2cbd2570-d158-c9ce-2a38-08c28cd291ea@redhat.com>
 <20190924092222-mutt-send-email-mst@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ee2e7983-7d80-a518-efd5-b52f8640bf90@redhat.com>
Date:   Tue, 24 Sep 2019 15:34:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924092222-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/19 15:24, Michael S. Tsirkin wrote:
> On Tue, Sep 24, 2019 at 03:12:15PM +0200, Paolo Bonzini wrote:
>> On 24/09/19 14:44, Sergio Lopez wrote:
>>> microvm.option-roms=bool (Set off to disable loading option ROMs)
>>
>> Please make this x-option-roms
> 
> Why? We don't plan to support this going forward?

The option is only useful for SeaBIOS.  Since it doesn't have any effect
for the default firmware, I think it's fair to consider it experimental.

Paolo

>>> microvm.isa-serial=bool (Set off to disable the instantiation an ISA serial port)
>>> microvm.rtc=bool (Set off to disable the instantiation of an MC146818 RTC)
>>> microvm.kernel-cmdline=bool (Set off to disable adding virtio-mmio devices to the kernel cmdline)
>>
>> Perhaps auto-kernel-cmdline?
>>
>> Paolo

