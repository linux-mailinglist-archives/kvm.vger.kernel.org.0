Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D48B4242EA
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 18:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhJFQoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 12:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhJFQoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Oct 2021 12:44:22 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDECC061746
        for <kvm@vger.kernel.org>; Wed,  6 Oct 2021 09:42:29 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id on6so2626827pjb.5
        for <kvm@vger.kernel.org>; Wed, 06 Oct 2021 09:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=6XDh7yWZOSqxph58yZ7yxsuGpqrzehlka27pGjt8ehg=;
        b=OOHOSQWNf8wMGc+y8ytJyhXUzAJbHJK07BJHvFfEwQDc/OplncP12q7x7fjy4t9KOj
         maK6QT92Aw44FZ7MOmwaC9yaQi51dClCBmhLfuPGNP1JZR1QtvfoksPmdIecZRpAht60
         DW9iY7ZFQKncjvLIOv8DMm44/c+H5hK0DEvK2KQbIKahl3i4p2lDLiWb9vGWV1QIjtwv
         jdWxY4ajWqguztQqo2hNQHcypPsXyJhAfKDC1F18pq2UYXGPutCxzjcw3XxPspsSgpje
         PScDXxvTz1CPBhYhGMaxVWavKtZY5+zTDO265lE+H7ZbRe7tMiMFF2KTOJnSLqb9azZe
         VrBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=6XDh7yWZOSqxph58yZ7yxsuGpqrzehlka27pGjt8ehg=;
        b=CDLt3FTpRUjksQOc0jJu7zi0rsbC3pSsOgj1/nubYekYS09UgZ6RYsfC9DLkT2CVqb
         5uIOvO3rdCP6tdUufMQUNwW3nweTB/LMZZjAouiW/Z/NZ77qjXPIEpa7T/UGD6LXKgHn
         jlXq7eZD4dhVsJ9vkB6l8P/oqw7BPuNy04EltkI32+SqWIBcKgebRGKru6vukktGNfeI
         TsOr1JEXzA8FjJy0BySpCL6i91peDo8dcwp+MecZi9MrFGw8C6d0jwdo2wtY2712yAik
         Z3jZFXoJA6mYWxuMiMjxS4NC7upB6lIcF5OItki3BkMo4ZEyVzrKXXKtsS6jOQvaa/WB
         FOUA==
X-Gm-Message-State: AOAM531T7TaULw8BCwNJGLIPsrrcJJ6fdS7AdnodoWOob719p53q63Fu
        /8C+qA/l/KShPSt84bGsk2rZkMhjZv1uAA==
X-Google-Smtp-Source: ABdhPJxmKjFnl8ryjupIwAwIO54j4F/2ixuTRTwSQLU519pIpe21f0fEGVSwKkQjEzNjY54Sdqs3dw==
X-Received: by 2002:a17:90a:6c97:: with SMTP id y23mr12010887pjj.117.1633538548992;
        Wed, 06 Oct 2021 09:42:28 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id nn14sm1870292pjb.27.2021.10.06.09.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 09:42:28 -0700 (PDT)
Date:   Wed, 06 Oct 2021 09:42:28 -0700 (PDT)
X-Google-Original-Date: Wed, 06 Oct 2021 09:42:06 PDT (-0700)
Subject:     Re: [GIT PULL] KVM/riscv for 5.16
In-Reply-To: <82568eff-1eff-5e63-4264-ef0c25f79fc3@redhat.com>
CC:     anup@brainfault.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     pbonzini@redhat.com
Message-ID: <mhng-03b25a51-3491-4bb7-9e17-1b32fc97b7ff@palmerdabbelt-glaptop>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 05 Oct 2021 01:25:41 PDT (-0700), pbonzini@redhat.com wrote:
> On 05/10/21 09:55, Anup Patel wrote:
>>    git://github.com/kvm-riscv/linux.git tags/kvm-riscv-5.16-1
>
> Pulled, thanks!

Thanks!

IIUC how this generally works is that you pull these KVM-specific patch 
sets and I don't, which means they'll get tested on my end as they loop 
back through linux-next.  I'm fine with however this usually works, just 
trying to make sure we're on the same page as this is my first time 
being this close to another tree.
