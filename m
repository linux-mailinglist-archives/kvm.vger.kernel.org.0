Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27F069B12F
	for <lists+kvm@lfdr.de>; Fri, 17 Feb 2023 17:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjBQQl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Feb 2023 11:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjBQQl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Feb 2023 11:41:27 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E92F72E1E
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:41:05 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5365663d982so14895537b3.3
        for <kvm@vger.kernel.org>; Fri, 17 Feb 2023 08:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=26XswqPiBSGHP6s6nxsJN9EyGJs7UFJ3DdAuQxz9eTI=;
        b=QjVPkerEjWrxxjarxuiJc+xdZaWtTMwrrVkbMKx+zQ0sS+2ZceALbz7w3tw+V08q/h
         wZfHVB3xkCHpTjL88c17MyVIUYKcMEggb59H/DoG0w8KBqRLE9WJlC4+25UXq/SWtRhY
         rxuEtgMzJFQkPm+OQLT1oVlkhmWrILCyrgJLNHtCuyGjPMQ4ge94AoXcKmKShB7eLZAg
         mRuf3n4F4BErDTyzRdKmOFMm2TAV+/h6CpgcPfOHCAcV7pKhjb52pIVSr+2pxKDYHZ70
         VgpCTIoqrp09786WrH+nhLHXZyWPckazRDQMLnUelBF05IIhtS9cik+QlNNlyHfVooHg
         +DwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=26XswqPiBSGHP6s6nxsJN9EyGJs7UFJ3DdAuQxz9eTI=;
        b=YHxn/P4R1DrrBuezbSkXtkRmzAel5CRUi6zVhyHycsKrytwYC0ncRq8P7hdHGKpXe6
         huoTxtw/jc1gaHYbTIeZd3DclvhwYBg496VFKaT1af5FYtHeAGUtAybFnHu1uSuAJfp7
         LcWXKQw/XsJSCb0I1uh27W3eQBEVkrUARCRa1BapCp74BYaddJydQ/0aOY7Dyhc6jhWA
         uf2mGnlMNP7s1B71tcbIzBIS4bPA37qPRu3N6zYwTMhjaCdOIwQwpegsbSi9hvmQF5Mp
         Ug/K4r44nZYgqVPxFM0dIRqukP7qcRaMe3liaexILXKIVs2aVAY2HSsF1QTciMHJFMCg
         5Dvg==
X-Gm-Message-State: AO0yUKXI9lmXdGr3IcZIxavt81EtTOfvOffYOvofynTgBeD4XnoxoqoP
        OHRA0ZTj9I/LgQO8YPBZiRG4x/pAZcA=
X-Google-Smtp-Source: AK7set87ApVahS7blZenNrptYr3Ndt+wNPJw2gc7DMQ+lKkl6rWB22TCh2FKD8Zi8efKfBlmA8lkGKpHUiw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:64a:0:b0:965:fa76:ae7a with SMTP id
 o10-20020a5b064a000000b00965fa76ae7amr688504ybq.16.1676652064456; Fri, 17 Feb
 2023 08:41:04 -0800 (PST)
Date:   Fri, 17 Feb 2023 08:41:02 -0800
In-Reply-To: <f9423a6ee10d91bd6bad32beefd1b96cad4d28f1.1676620879.git.christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
References: <f9423a6ee10d91bd6bad32beefd1b96cad4d28f1.1676620879.git.christophe.jaillet@wanadoo.fr>
Message-ID: <Y++uHlQz7OEOzojb@google.com>
Subject: Re: [PATCH] KVM: Reorder fields in 'struct kvm_mmu_memory_cache'
From:   Sean Christopherson <seanjc@google.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, kvm@vger.kernel.org,
        Mathias Krause <minipli@grsecurity.net>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023, Christophe JAILLET wrote:
> Group some variables based on their sizes to reduce hole and avoid padding.
> On x86_64, this shrinks the size from 40 to 32 bytes.

Heh, a hair too late[*].  Unless I'm mistaken, Mathias will be sending a new
version in the not-too-distant future.

Thanks!

[*] https://lore.kernel.org/all/Y+puefrgtqf430fs@google.com
