Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEF65AA34E
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 00:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbiIAWrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 18:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234385AbiIAWrL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 18:47:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F66A6EF13
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 15:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662072430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zAeTJy5ubeDHnWShRqQvqVpSgwyCAkD2ph2sh9lD1WE=;
        b=GUfS1ue2IKtshQk8PfPjFGdlcV9Rr8aIE3LlHssh5iSpyY2mXiTKU+Bdoda5BjssH9FlBv
        LdDKDfqWN80xccBQSynAcO/tmUBij+tF9ItkMUbKzvFziGMjtSQRs2zlASYbTTAFqoICE0
        Gzrwkqoeo/HPVd3A6rPcywR3BCO3Afw=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-265-RQL64hg3MmaHCKdeDXPrlg-1; Thu, 01 Sep 2022 18:47:09 -0400
X-MC-Unique: RQL64hg3MmaHCKdeDXPrlg-1
Received: by mail-ej1-f69.google.com with SMTP id qw34-20020a1709066a2200b00730ca5a94bfso94153ejc.3
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 15:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=zAeTJy5ubeDHnWShRqQvqVpSgwyCAkD2ph2sh9lD1WE=;
        b=EIk9VPxNXfDshTV8H7BoaGdT74yftJHTQeox0Gi7PsjAVVMICUlqg0FEx8AsLf7bPs
         olwOvl5ypdL52iVP0qIJ9rgVXLOph0tGbetTnHWxiAhuDI09Bj4yleqbXUUZj/vNq8sa
         3oY97M2EeDvhFJOruUgDFC/CzSczP9jzQ7bMGpJ0WhjgtDm9SLZBDqlrAPxVp+Wpvjfj
         jZN79BXN7wiq41XvvBMQUY6nmAsnpsplEIVw44Lc1DZlOatbhrK5J6fmgPmMfcCdlRlN
         awDwpPxPcdhPuGYaVhBalC718jO4yua659dBNvJtC/HVJTlrg3TlzIBmrsOAfZ2np9iW
         iB0g==
X-Gm-Message-State: ACgBeo0FJN5ZNwOWxkIpEqNqtvwkZTeHPfO02sy7/YZD0MggJxH6P3VE
        YVWYHsHvZUv8FfehYSYcxA5fyd7Pda83kMEkg+8QE1aQV7AlQnbliT69jW4QQccU7Tf34pP/9gq
        S6dh+5gGEBk7K
X-Received: by 2002:a17:907:7252:b0:73f:c3e9:4197 with SMTP id ds18-20020a170907725200b0073fc3e94197mr21919936ejc.173.1662072427551;
        Thu, 01 Sep 2022 15:47:07 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4Az1+wY7j+OKvmai1ferq1yhW9uB3SEtzY5xblvhoKYlAjraIcuSn27cPH+tLNPonVYS5MFA==
X-Received: by 2002:a17:907:7252:b0:73f:c3e9:4197 with SMTP id ds18-20020a170907725200b0073fc3e94197mr21919929ejc.173.1662072427347;
        Thu, 01 Sep 2022 15:47:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id t1-20020a1709066bc100b007303fe58eb2sm249653ejs.154.2022.09.01.15.47.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 15:47:06 -0700 (PDT)
Message-ID: <5084cacf-c84d-65fe-45c5-efe73c38f314@redhat.com>
Date:   Fri, 2 Sep 2022 00:47:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [GIT PULL 0/1] KVM: s390: VFIO PCI build fix
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, pmorel@linux.ibm.com
References: <20220830083250.25720-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220830083250.25720-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/30/22 10:32, Janosch Frank wrote:
> Paolo,
> 
> here's a lone fix for a KVM/VFIO build problem.
> 
> A few PV fixes are currently still in development but fixing those
> issues will be harder.
> 
> The following changes since commit b90cb1053190353cc30f0fef0ef1f378ccc063c5:
> 
>    Linux 6.0-rc3 (2022-08-28 15:05:29 -0700)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-master-6.0-1

Pulled, thanks.

Paolo

> for you to fetch changes up to ca922fecda6caa5162409406dc3b663062d75089:
> 
>    KVM: s390: pci: Hook to access KVM lowlevel from VFIO (2022-08-29 13:29:28 +0200)
> 
> ----------------------------------------------------------------
> PCI interpretation compile fixes
> 
> ----------------------------------------------------------------
> 
> Pierre Morel (1):
>    KVM: s390: pci: Hook to access KVM lowlevel from VFIO
> 
>   arch/s390/include/asm/kvm_host.h | 17 ++++++-----------
>   arch/s390/kvm/pci.c              | 12 ++++++++----
>   arch/s390/pci/Makefile           |  2 +-
>   arch/s390/pci/pci_kvm_hook.c     | 11 +++++++++++
>   drivers/vfio/pci/vfio_pci_zdev.c |  8 ++++++--
>   5 files changed, 32 insertions(+), 18 deletions(-)
>   create mode 100644 arch/s390/pci/pci_kvm_hook.c
> 

