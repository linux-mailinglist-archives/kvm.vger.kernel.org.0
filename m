Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFDC1A378E
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 17:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbgDIPzV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 11:55:21 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54145 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727865AbgDIPzU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Apr 2020 11:55:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586447720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rQnewouRwapekPuxK4Rm6JUrIOsu44omLG0YmFWrrRw=;
        b=ONdBpA7l/KI+gCJ8OWCQm3VVj22g9IZjnUO8P9Smo9L1acqLhnUMSkW0GmqvLR6V7F6qkW
        dj8mp7Iu86h6X7unu/herQJ2vWv16Eh6+aMfnyXxT3Vf4CBSPizxlbIgZ9wArdgGuh90gP
        +LZgpT6cpxeSvWkFWND2tIKtBnUSTu4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-r4-_AgnKNVaZaVwHP6Uuqg-1; Thu, 09 Apr 2020 11:55:18 -0400
X-MC-Unique: r4-_AgnKNVaZaVwHP6Uuqg-1
Received: by mail-wr1-f71.google.com with SMTP id j22so3507647wrb.4
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 08:55:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rQnewouRwapekPuxK4Rm6JUrIOsu44omLG0YmFWrrRw=;
        b=leUk+V5nX0dXKFwE16Vq+y2xAc+Fg3AYQwoaVuteR3B8PGq2vVxW0QbTyDStJgbTK7
         Vx/sCKGuxabnZVy7Bgk3kS5tEEYzwoeCoulRjnvYVpcoYoEvbw2s3Z2cEHF6rS1zXjDW
         8IyZGmODAmvmIPdakpK/nnvBOxX31hYUUxD+JnTVPmw3V3QNyfnkEaaezbaCUbPVaact
         8BB9QTxH7gqOUW/Xd7cMIddnAXNBoXDeZDPVBqTuMBJLu3XrxDTbVP2NLkKJKH4TDa1Q
         GL2MkMLqRl6aFPq8nP/KLLslC0lfbYqZK3zXxPvs/9hGTIyrvXsSGsHFQG4JC7vyU2G/
         eaUQ==
X-Gm-Message-State: AGi0PuaraTraMjcAZFJrE0Uoz1vt1MBCMOcZkJrnr0BsL/d2Z1wTbDOv
        ZPqrZMnWpg46Lahi1gW3JekF4INz+HAGM8AoKAbt/cPkdX3ZM5k7Nb08ep1wFT1DJMdIOKWv5WV
        sFjlPiZeYWQjZ
X-Received: by 2002:adf:e403:: with SMTP id g3mr14788012wrm.295.1586447716856;
        Thu, 09 Apr 2020 08:55:16 -0700 (PDT)
X-Google-Smtp-Source: APiQypLXYHXaOORriuX8RnGR/0Gxy0L9EIa1Cq7XUGt2v5NGty7cdbeVuJU/Ma1YqO35uUUe9DpstQ==
X-Received: by 2002:adf:e403:: with SMTP id g3mr14787999wrm.295.1586447716689;
        Thu, 09 Apr 2020 08:55:16 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id w11sm4107408wmi.32.2020.04.09.08.55.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 08:55:16 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Fix __svm_vcpu_run declaration.
To:     like.xu@intel.com, Uros Bizjak <ubizjak@gmail.com>,
        kvm@vger.kernel.org
References: <20200409114926.1407442-1-ubizjak@gmail.com>
 <0ee54833-bbed-4263-7c7e-4091ab956168@intel.com>
 <21e04917-d651-b50b-5ecf-dfe27aec6f0a@redhat.com>
 <2a688724-f1da-627e-52cc-f0087d1aeba8@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6b042130-885b-6eb0-ffa0-86c4c6b3a899@redhat.com>
Date:   Thu, 9 Apr 2020 17:55:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <2a688724-f1da-627e-52cc-f0087d1aeba8@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/20 17:42, Xu, Like wrote:
>>
> Yes, I assume the svm->vmcb->control.exit_code is referred.
> 
> What makes me confused is
> why we need "vmx->exit_reason" and "vmx->fail"
> for the same general purpose, but svm does not.

Because VMLAUNCH/VMRESUME can also report vmFailValid and vmFailInvalid
via the carry and zero flags, there is no equivalent of that for AMD
virtualization extensions.

Paolo

