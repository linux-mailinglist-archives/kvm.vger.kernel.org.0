Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57B1C11F0BE
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 08:33:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfLNHdC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Dec 2019 02:33:02 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:48660 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725372AbfLNHdC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 14 Dec 2019 02:33:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576308781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zj7JW2QIpBpCizh7r9qrQ1A/HQB1FTvhAyKQk+U6nHk=;
        b=PsDC6dsGGtmjmTRMZ0tI+sig4yLcxai4ZFgXcQKh7NrFpuR/e4Hm8ytpVUCZKf4wgMYCIh
        v4LikgomWZOzxVoLC6JCY03I+P0hl94oeBqJFoVgcQMN64LxDKu3tYu9Xuht9BeGrsEpca
        Xdp7SKCik9lLconAPBWAR733PfaE/oY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-ZuNuq0vKPy-amSWvDWD4oQ-1; Sat, 14 Dec 2019 02:32:57 -0500
X-MC-Unique: ZuNuq0vKPy-amSWvDWD4oQ-1
Received: by mail-wr1-f71.google.com with SMTP id f15so665017wrr.2
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 23:32:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zj7JW2QIpBpCizh7r9qrQ1A/HQB1FTvhAyKQk+U6nHk=;
        b=P1jX2bg62xOT+h+XsaFOUbDOwCfXqoZKxW236kGZIy3DHmmEMptJHRGpHw4l2RCMrO
         YdgWk0UhfpIyuVqv+4c4Vk5mV7BXX9Up+PZjlWH3dNWRuIdcenN0kGlmTaNy1+cBo77w
         EUehhGPA/NjD0LsN4LVIxgweRXYM5HZF12r/tyLV8kj806uJhpcSER4wLa6CdXXDZHZt
         NTdxNp7Vxf3fNuTP+uFItTCsayfNeo3WlO/mEKxQOCcUG85KZOIhaoaf3Bmk4HZy88mg
         DJIbUc6TtWr6GEbRnpW2sMNqDx14tOxj4iZ+j587JvPPQQEEiqk5o5tLHbJAm0wrRZKt
         HI3Q==
X-Gm-Message-State: APjAAAVP4xBfukDBl9uZrBwA4uJqqrXBN3M78wuWCf+iDpwsZAFHGL67
        RkucJ5n7Rs4oKf5YjmGFUdUWdI6TP4krQ/GFw6MfVK0tQ3MZH/BN1A3edssj9V8k9Khh4SnFoRU
        N4oxsOXjjUFEW
X-Received: by 2002:a1c:f316:: with SMTP id q22mr18505939wmq.103.1576308776023;
        Fri, 13 Dec 2019 23:32:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqwED/r+8L6UoU6C6motHGshUvPDMXdddCd1H/UQBbv2GRQWav12+0lIoX2qkzely0Xqo8NzCw==
X-Received: by 2002:a1c:f316:: with SMTP id q22mr18505922wmq.103.1576308775799;
        Fri, 13 Dec 2019 23:32:55 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:cde8:2463:95a9:1d81? ([2001:b07:6468:f312:cde8:2463:95a9:1d81])
        by smtp.gmail.com with ESMTPSA id q3sm12762778wmj.38.2019.12.13.23.32.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2019 23:32:55 -0800 (PST)
Subject: Re: [PATCH] kvm: x86: Add logical CPU to KVM_EXIT_FAIL_ENTRY info
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Cc:     Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>
References: <20191213231646.88015-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bf272e46-d8a6-f69a-6cd0-0a42c252b3fd@redhat.com>
Date:   Sat, 14 Dec 2019 08:32:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191213231646.88015-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/12/19 00:16, Jim Mattson wrote:
> More often than not, a failed VM-entry in a production environment is
> the result of a defective CPU (at least, insofar as Intel x86 is
> concerned).

It's conforting that someone else got to the same conclusion as we did...

Paolo

> To aid in identifying the bad hardware, add the logical
> CPU to the information provided to userspace on a KVM exit with reason
> KVM_EXIT_FAIL_ENTRY. The presence of this additional information is
> indicated by a new capability, KVM_CAP_FAILED_ENTRY_CPU.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>
> Reviewed-by: Oliver Upton <oupton@google.com>


