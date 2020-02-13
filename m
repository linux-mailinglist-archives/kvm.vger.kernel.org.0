Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8334A15CD68
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 22:41:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgBMVlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 16:41:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30844 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726282AbgBMVlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 16:41:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581630093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ozCvUDTVPNZ7QDljyHE6xSIMNJnN5yu3Ah+4BAbtOio=;
        b=ghCAiveQgjlKZF1ou2VzV0Ruo+ZGnfeCY6hT6z+cOI6BwB1yjfqIaM8qW6DAk4HCjeSerw
        t4RzuXDQqt7wWY0pbwg3a60txA3/PD9fDoT+0HXOznDvcDEYARRmA5vOS9VlAyxpuDS7F3
        31heCWtsEPBN4gTUZBgeuS97Dhzoopc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-z0oJUYwzPu-5rmNC9fIUFQ-1; Thu, 13 Feb 2020 16:41:31 -0500
X-MC-Unique: z0oJUYwzPu-5rmNC9fIUFQ-1
Received: by mail-wm1-f72.google.com with SMTP id a189so2535281wme.2
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 13:41:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ozCvUDTVPNZ7QDljyHE6xSIMNJnN5yu3Ah+4BAbtOio=;
        b=jdDPM6xRdXhmrgvApxhjDVMGenwcgNyzJPHV1JQekt6gL72mxDWPCIuydYeXFh+Vfx
         5FBppdL/QOHlg1Lm6/ORSPNrOfpzg45VWnp3TbZwa3gJfOqquEm5G9SR46rMsJJR33sV
         9sovC9jCkO6cBtbVxGCuqwPmJ+Q4fSjIOZ/y5GD8jYOMTBjBMS/AQbZKKb5PeqN28nI/
         6zfI5iMKKpnCM0hl6sKzMWmwRx9mDSCZlXYm32d5TRk6NMBo6xMt1vHE+h2xcZur5ELb
         SRWs1oK1veqluy/XGt6t5VLvf5c1GQJqeabWcAM5QmJa3yxFy7pkX+7nG9qR185IA804
         7jFw==
X-Gm-Message-State: APjAAAXLjDxZX0XsJUYIA37LkKdOxwDS/aKDjPMzkvoX6v7mhlZd9khs
        GB0L81uEochrL4DjZPuT2ZR4Kz4Jhvw0dAnNEFx6M7+XaQFHpVn4RmBl+FDMi9ZIYtTZWj5JCtp
        AvCKtF5PFkNZe
X-Received: by 2002:a1c:4c5:: with SMTP id 188mr102311wme.82.1581630090230;
        Thu, 13 Feb 2020 13:41:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqyoGaODEDjTgNSrF2Dl5MKA+8k86WkBbel//MguKGv7NqlvB5CQXk+9Te0+p5k/nahHMsXr3Q==
X-Received: by 2002:a1c:4c5:: with SMTP id 188mr102293wme.82.1581630089993;
        Thu, 13 Feb 2020 13:41:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8914:ecfc:1674:2d77? ([2001:b07:6468:f312:8914:ecfc:1674:2d77])
        by smtp.gmail.com with ESMTPSA id w7sm4211312wmi.9.2020.02.13.13.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 13:41:29 -0800 (PST)
Subject: Re: [RFC PATCH 0/3] KVM: x86: honor guest memory type
To:     Chia-I Wu <olvaffe@gmail.com>, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, gurchetansingh@chromium.org, kraxel@redhat.com,
        dri-devel@lists.freedesktop.org
References: <20200213213036.207625-1-olvaffe@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
Date:   Thu, 13 Feb 2020 22:41:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200213213036.207625-1-olvaffe@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/20 22:30, Chia-I Wu wrote:
> Hi,
> 
> Host GPU drivers like to give userspace WC mapping.  When the userspace makes
> the mapping available to a guest, it also tells the guest to create a WC
> mapping.  However, even when the guest kernel picks the correct memory type,
> it gets ignored because of VMX_EPT_IPAT_BIT on Intel.
> 
> This series adds a new flag to KVM_SET_USER_MEMORY_REGION, which tells the
> host kernel to honor the guest memory type for the memslot.  An alternative
> fix is for KVM to unconditionally honor the guest memory type (unless it is
> MMIO, to avoid MCEs on Intel).  I believe the alternative fix is how things
> are on ARM, and probably also how things are on AMD.
> 
> I am new to KVM and HW virtualization technologies.  This series is meant as
> an RFC.
> 

When we tried to do this in the past, we got machine checks everywhere
unfortunately due to the same address being mapped with different memory
types.  Unfortunately I cannot find the entry anymore in bugzilla, but
this was not fixed as far as I know.

Paolo

