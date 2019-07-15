Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07DB68862
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 13:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbfGOL4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 07:56:16 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36391 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729725AbfGOL4Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 07:56:16 -0400
Received: by mail-wm1-f67.google.com with SMTP id g67so10786496wme.1
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 04:56:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XFWpBNJB1XF7x1pi/vljYSJV0914VRIWwI4XKNBeu5o=;
        b=LA3h/fHH9I9UnBEeVmSwW9aRoCuegnOUabnHNvcJZK626+MuOFE55ILOf0EN012/24
         oGegHHM77KIW1O0uYEPjDpu7vKLMeaKU2rkVaaT56G1nDZBO9WYxCx9KAcqNJ89i21jF
         tCYP72Hn827jvcGYAqjXJk8Ce4d/jalDF9C7k3xPJFBF/imcvX28bf4XWfW7baGQEgCr
         iyI+75sxp4ftgUjLW4G7npXFVdzRr+G4Il+17OrTvIiH315uJzQAnIEaFlForvc1vxPz
         SHEWoAmhYZex+/eFGB7uOh+H+NIjJwXZ+rnnxPYFE7THwpLxZTXb5Jvp4s62z/vttN+J
         71YQ==
X-Gm-Message-State: APjAAAVD/UNRKimkBkbP/5nUiA3FIHOZZQweEEoQtMNvQXOgegpBhp24
        uqc65kYKQAVS79Yq3pIEsZpGtQyOG5I=
X-Google-Smtp-Source: APXvYqy1D5C+lU/rPQaQ0mt2Nc7LxZgHKSMsYB6lbGaMy/HCVyC7JOBHpiFmnFLHJFsnSURXW5Q/bQ==
X-Received: by 2002:a1c:b604:: with SMTP id g4mr24900964wmf.111.1563191774132;
        Mon, 15 Jul 2019 04:56:14 -0700 (PDT)
Received: from [192.168.178.40] ([151.20.129.151])
        by smtp.gmail.com with ESMTPSA id f2sm13153714wrq.48.2019.07.15.04.56.12
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 04:56:13 -0700 (PDT)
Subject: Re: [PATCH v1] KVM: x86: expose AVX512_BF16 feature to guest
To:     Jing Liu <jing2.liu@linux.intel.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <1562824197-13658-1-git-send-email-jing2.liu@linux.intel.com>
 <305e2a40-93a3-23ed-71a2-d3f2541e837a@redhat.com>
 <CANRm+CzOp6orH+7sqCQjLuxsYRccfq7H-o4QBcgxGfT-=RaJ-w@mail.gmail.com>
 <332e8951-e6bb-8394-490d-26c8154712b9@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <68d07943-c957-7caa-f77c-944cd0d726bf@redhat.com>
Date:   Mon, 15 Jul 2019 13:56:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <332e8951-e6bb-8394-490d-26c8154712b9@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/07/19 13:05, Jing Liu wrote:
>>
>>
> Thanks for the information.
> 
> This warning would be fixed by changing to
> entry->eax = min(entry->eax, (u32)1);
> 
> @Paolo, sorry for trouble. Would you mind if I re-send?

No need, I can fix it myself (I'd also use 1u instead of the cast).

Paolo
