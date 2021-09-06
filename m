Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14134019EA
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 12:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241958AbhIFKgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 06:36:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20032 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229913AbhIFKgx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Sep 2021 06:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630924549;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g68PpF6+mUXROjTFT/pPvYK23nXqxvx0vraJdLoo7FI=;
        b=BkKFCp6oV3oCBx21SoP/AZUYvBK+hv4G5hlFuxGbIND2e6zu6CooQLqrKgSHPweOJ9E7mO
        nt2Vh0mceHagtDqkybd9NSNHUL4xjsZGvwJ9aUUN/6NfJBzx2KoGCQ3/qVHOMs08eDv2Ut
        T23OkndCI52kGkEOXK2Ptzqp3MV5Yh0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-mg0dCykwNTyaoIq4E13h4w-1; Mon, 06 Sep 2021 06:35:48 -0400
X-MC-Unique: mg0dCykwNTyaoIq4E13h4w-1
Received: by mail-ed1-f72.google.com with SMTP id b8-20020a056402350800b003c5e3d4e2a7so3498421edd.2
        for <kvm@vger.kernel.org>; Mon, 06 Sep 2021 03:35:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g68PpF6+mUXROjTFT/pPvYK23nXqxvx0vraJdLoo7FI=;
        b=Hprtu+8zP1Eg62ahOMQZx4TtURK4s26bzxZiuoQRZGPCL2l2sTNMEzaaGD1t9tt2GI
         Gjxta4I4r32cpa0kAduUw0yizyRdvSKK0tWubuve6L2JnVUK9/bGKZSZia0gXFIz3y2a
         PFDMSCt0Xmdi3oe7HEQSt+m9ldQH1T4soylilW2OAoSP2loJhVPnOYwsilCN1cL4DELb
         1kgpmBPvkxXt2apOs336yC2niKNNkNmPKDhaIzpn25kMRmyjJ+E0On7bWXACoEAVm9aW
         +pEuKGDoWVkw6jikWIiw23tkGal7rTrupgLoTzM5N9bTR3n6xRnUBjW3CPa1Zo721tF9
         IpTQ==
X-Gm-Message-State: AOAM532KDvxiBEuc2paBzIYycIaLbWTSkQv6YHdRFW7GTHwNdszt7PBq
        dbMCcnySUPazKPBETuHiKWdC8NY1OH+UGEflim5OwQx8FSGGGWqZnmkVQ7Oj3f7rqICLK5C8me9
        +v+ysCxLHldgt
X-Received: by 2002:a17:906:d045:: with SMTP id bo5mr12803968ejb.461.1630924546938;
        Mon, 06 Sep 2021 03:35:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxZNrsZgDmccQd/BU46BG1MwpW2PfB4vsAom9LwPHgvfmCBrJ1P4pbixZweCnbZZISN13+LKw==
X-Received: by 2002:a17:906:d045:: with SMTP id bo5mr12803945ejb.461.1630924546767;
        Mon, 06 Sep 2021 03:35:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c7sm4327202ede.21.2021.09.06.03.35.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Sep 2021 03:35:46 -0700 (PDT)
Subject: Re: [GIT PULL 0/2] KVM: s390: Fix and feature for 5.15
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
References: <20210829060121.16702-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <70668bcd-b94d-36d1-dffa-af3315f0c60c@redhat.com>
Date:   Mon, 6 Sep 2021 12:35:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210829060121.16702-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/08/21 08:01, Christian Borntraeger wrote:
> Paolo,
> 
> sorry for being so late. One feature (enable hardware interpretion of
> specification exceptions) and one fix targeted for stable. Given the
> short runway to 5.14 I decided to let this go via next and not try to
> sneak it into 5.14.
> 
> The following changes since commit 1f703d2cf20464338c3d5279dddfb65ac79b8782:
> 
>    KVM: s390: allow facility 192 (vector-packed-decimal-enhancement facility 2) (2021-06-23 09:35:20 +0200)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.15-1
> 
> for you to fetch changes up to a3e03bc1368c1bc16e19b001fc96dc7430573cc8:
> 
>    KVM: s390: index kvm->arch.idle_mask by vcpu_idx (2021-08-27 18:35:41 +0200)
> 
> ----------------------------------------------------------------
> KVM: s390: Fix and feature for 5.15
> 
> - enable interpretion of specification exceptions
> - fix a vcpu_idx vs vcpu_id mixup
> 
> ----------------------------------------------------------------
> Halil Pasic (1):
>        KVM: s390: index kvm->arch.idle_mask by vcpu_idx
> 
> Janis Schoetterl-Glausch (1):
>        KVM: s390: Enable specification exception interpretation
> 
>   arch/s390/include/asm/kvm_host.h |  2 ++
>   arch/s390/kvm/interrupt.c        | 12 ++++++------
>   arch/s390/kvm/kvm-s390.c         |  4 +++-
>   arch/s390/kvm/kvm-s390.h         |  2 +-
>   arch/s390/kvm/vsie.c             |  2 ++
>   5 files changed, 14 insertions(+), 8 deletions(-)
> 

Pulled now, thanks!

Paolo

