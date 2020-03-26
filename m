Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAD2193C6B
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 10:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgCZJ6w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 05:58:52 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:40994 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727780AbgCZJ6w (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Mar 2020 05:58:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585216730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mu5k/muTMFikZ1Us7/EnXaPhY0MlU2ypQjlH90iIurc=;
        b=Zs/upUzqPKCW7e6JWh5TjBtC5F9lRe0rW708sYOuwbdqmw3+FFwhEAKK4sATl54wo6BmdN
        ji/oOG1UoCkbWxKC6FjyWuiwpeaqevhnA9z7Km4qPlmimsA+sXTGeyrq6Bjx26I+OySVXg
        /ScUt0HeQ/chL6mC/wDmo73elpKdQLg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-Ehe0K5JmOburQvG0R3RbyQ-1; Thu, 26 Mar 2020 05:58:48 -0400
X-MC-Unique: Ehe0K5JmOburQvG0R3RbyQ-1
Received: by mail-wm1-f70.google.com with SMTP id y1so2244131wmj.3
        for <kvm@vger.kernel.org>; Thu, 26 Mar 2020 02:58:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mu5k/muTMFikZ1Us7/EnXaPhY0MlU2ypQjlH90iIurc=;
        b=nsBq7CtaJfZ/DV1ADC4yibOg044wHvz9K/fuiXHHiVIspzp5pbcyeEUadQn8kLtKyG
         NoEVnnT2sQ0MSekJJh8+nuN2Po65QeKpBKRJHQ+1U548pFvNOca+lbmVabKqFwGIEOTP
         BRuFQNUTD/jzixtwWckaMdUXKDTml4WdUC7peXr+IG6vU1osuliqBCS3ZyoUooTZ81OO
         oRZJaePXZVVj9xqVeLA/qF8gBOcOkaRAYY6eMNO3U3pBUrAJdG1cTO2NI8bXfO1zy769
         XbR+8E2rRZ1eS+kXYeDNX1gge5n8c9IkzkHooNc2X/eBs2vr+15qbIBIE+vOOdCrMIH0
         EIMQ==
X-Gm-Message-State: ANhLgQ3zT8n/st1/UmM1O4/1P4rW5wgsPbJo/dais3ZBvg3IjpBRrFUI
        unYHaQx6QZbgluPS71svoPkFNtlAUeMbmCHrCWfLhKI2mdlWUiMqpJoGWrwSIeZr13r7iLHTS5V
        ty3N+6kcxGC9Y
X-Received: by 2002:adf:f0c5:: with SMTP id x5mr8476845wro.415.1585216727618;
        Thu, 26 Mar 2020 02:58:47 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtUuqzsVOQscsCsoJwZd9JlTbWvDJQ9qZyiEHXOIIM9um2wuL1QZxJ2xekHIC4yr7TeXRS0lw==
X-Received: by 2002:adf:f0c5:: with SMTP id x5mr8476820wro.415.1585216727315;
        Thu, 26 Mar 2020 02:58:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e4f4:3c00:2b79:d6dc? ([2001:b07:6468:f312:e4f4:3c00:2b79:d6dc])
        by smtp.gmail.com with ESMTPSA id k126sm2891486wme.4.2020.03.26.02.58.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 02:58:46 -0700 (PDT)
Subject: Re: [GIT PULL 0/2] KVM: s390: changes for 5.7 part 2
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20200324125030.323689-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e6977ffb-e4e5-1f3d-3db2-55742bacaa1d@redhat.com>
Date:   Thu, 26 Mar 2020 10:58:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324125030.323689-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/03/20 13:50, Christian Borntraeger wrote:
> Paolo,
> 
> two more patches for 5.7.
> 
> The following changes since commit cc674ef252f4750bdcea1560ff491081bb960954:
> 
>   KVM: s390: introduce module parameter kvm.use_gisa (2020-02-27 19:47:13 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.7-2
> 
> for you to fetch changes up to f3dd18d444c757840920434e62809b6104081b06:
> 
>   KVM: s390: mark sie block as 512 byte aligned (2020-03-23 18:30:33 +0100)
> 
> ----------------------------------------------------------------
> KVM: s390: cleanups for 5.7
> 
> - mark sie control block as 512 byte aligned
> - use fallthrough;
> 
> ----------------------------------------------------------------
> Christian Borntraeger (1):
>       KVM: s390: mark sie block as 512 byte aligned
> 
> Joe Perches (1):
>       KVM: s390: Use fallthrough;
> 
>  arch/s390/include/asm/kvm_host.h |  2 +-
>  arch/s390/kvm/gaccess.c          | 23 +++++++++++++----------
>  arch/s390/kvm/interrupt.c        |  2 +-
>  arch/s390/kvm/kvm-s390.c         |  4 ++--
>  arch/s390/mm/gmap.c              |  6 +++---
>  5 files changed, 20 insertions(+), 17 deletions(-)
> 

Pulled, thanks.

Paolo

