Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF4C3AC64A
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 10:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbhFRIjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 04:39:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231855AbhFRIjm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 04:39:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624005453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wzqa8rS1pmB4o6NDr4muJNg1165tCr6NUIhZ4XLKVno=;
        b=DmUkyx/3SwWQMaCfpCXL9x0hAwNZMEpWlMsp/wOFG15jYa1UAYr/Uq6Q4DlHqWS5ekhhld
        l1yAZkMEMFzEW3fbgOdF1F5EFn0nFychof812WcleUoHLcMzZ4ifphYUXoNzt2sJUxL1BB
        8jhpD7PkzM2xyYvqqxpQ+AiZaE9Whzk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-29LqVAhTMpS0YF9aKKJ1iA-1; Fri, 18 Jun 2021 04:37:32 -0400
X-MC-Unique: 29LqVAhTMpS0YF9aKKJ1iA-1
Received: by mail-ed1-f71.google.com with SMTP id x12-20020a05640226ccb0290393aaa6e811so3137229edd.19
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 01:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wzqa8rS1pmB4o6NDr4muJNg1165tCr6NUIhZ4XLKVno=;
        b=rfm95ComM89PN00pU/4FjHy4zVbEJLHfh0mLMq+0Y8I5Wag6ypC27P8m2tRR5J0ykQ
         S529FN1K9m0gqj6Itnn/DRgujwNUG4n0su6JaP83g7yo5CaoI9NJ9BwVTtEtxesIlki/
         FH/x7iRd1VnmguJ5b6XaYfsZc75Z0vHh7KseG9lRYeTA+JD+EsTt+pwVt+zeW+DL81vJ
         z11kzXUninwhc5INrUX+8OYCFzLwQUFqgRL43X3vezQIjRfSm3lb2vFj0mKwN4mOQsBk
         DoTW3x8jj7gTRDQtKoMheIpVngdiW0cDn2pv6X34uX3d559WrzvhSN1qbQRlDWcF8CRI
         JflQ==
X-Gm-Message-State: AOAM5303BMuD7oY4/79eblMqvpLC+wEyChhyaUfGaR0/G9nuYyQv1XMI
        LdShng/ROQ7y7Nwv+cybPANmqT83qCfrSG8BHECkxhlgps+u7ZEmCsMUDOAVmjm1XWtkjJCgReA
        WInxhUMBj0kDQ
X-Received: by 2002:a17:907:2135:: with SMTP id qo21mr10007154ejb.385.1624005450985;
        Fri, 18 Jun 2021 01:37:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGqTUCCnmlm2i4BwK6ow8EEW5K1lZq6PRO7ZAfVpPo/7FV7YEyqCjtEH5lpza698HypRTM1w==
X-Received: by 2002:a17:907:2135:: with SMTP id qo21mr10007135ejb.385.1624005450841;
        Fri, 18 Jun 2021 01:37:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id df20sm5460460edb.76.2021.06.18.01.37.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 01:37:30 -0700 (PDT)
Subject: Re: [PATCH v11 5/7] KVM: stats: Add documentation for binary
 statistics interface
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        LinuxMIPS <linux-mips@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        LinuxS390 <linux-s390@vger.kernel.org>,
        Linuxkselftest <linux-kselftest@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Fuad Tabba <tabba@google.com>
References: <20210618044819.3690166-1-jingzhangos@google.com>
 <20210618044819.3690166-6-jingzhangos@google.com>
 <YMxE8pUrbQkwlpbD@kroah.com>
 <0036c55a-72d6-7b5c-a6fd-3a285476e522@redhat.com>
 <YMxZ2Z9s5YRvhetZ@kroah.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c8f1fada-a7b7-0f41-c57f-7164a8211d68@redhat.com>
Date:   Fri, 18 Jun 2021 10:37:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMxZ2Z9s5YRvhetZ@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/21 10:31, Greg KH wrote:
> Ok, it's your maintenance burden, not mine, I was just suggesting a way
> to make it easier :)
> 
> I'll not complain about this anymore...

I wish there was a way to keep them in sync without either sacrificing 
the quality of the documentation or reading kvm.h 100 times, I would 
jump on it!

Paolo

