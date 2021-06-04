Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE88F39BC1D
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 17:40:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhFDPm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 11:42:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34913 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231173AbhFDPm2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Jun 2021 11:42:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622821241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aDzH96dJVfpl3m5Uje4rnGEyfhG12oB1O5EB1V0U560=;
        b=ACq8eSq6nE2BrEckIns0/Pby6a+aAr6Wj0a5bSutIFmI6fcRhkMmRV775VBhGQNFFiaQyi
        b4v5SyD+0nz+gEwtKtKy0neDWPCAMi31CMyeUKxmdT6rD1bKVUXwTLNEmBqY+0n3EeUlDx
        PlbC7naWSEuX+GLKt2W4HU9oBQ5AVzk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-FpnbMZjbPyiePR9B2zV2UA-1; Fri, 04 Jun 2021 11:40:38 -0400
X-MC-Unique: FpnbMZjbPyiePR9B2zV2UA-1
Received: by mail-ed1-f71.google.com with SMTP id a16-20020aa7cf100000b0290391819a774aso3147518edy.8
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 08:40:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aDzH96dJVfpl3m5Uje4rnGEyfhG12oB1O5EB1V0U560=;
        b=KIFZVoMAwd18G8EY3fR5ZBZbU3wDWktwdCRbUSvSnaqRwaoUY0s4+K74QkIJOjew6/
         8zkUaoZaGT0C87d1/x8BsKRPk8dY/asA0mBjno27kXbYTLXmHIJwXttbpEncK92znH9k
         8zU6+e9orrovfVECuTDBUIzh6RL4ZXIpcBA6ZOtjv+v+VQXsCIYTSfOYJXhYgOU2lSCB
         fDBjO8DRbEFMLtsvDBp3EQQG2mrBpCIYdsPBbh8emz3vYHEkD02y7I98l9EG9MTX3mM5
         xyYgK26Mihn8FRvH6SGpvpQKOqXObLXR2QRT50I2OQwFbTF/7231aFxMfhuhsAnPZ+Sf
         8h+g==
X-Gm-Message-State: AOAM5335eVySHqg6a07+0agywRB0qHwrAs0esw09byaf8fzIl81C7WM2
        eAzdn9Fc7KMG7pjiAj52yyoSaRhShZHqt3yCA8OzfIJ6PVDN497Yil4GIL9slAKtAiZTYNy6Xvl
        ySjl4wPcwIqg4
X-Received: by 2002:a17:906:1311:: with SMTP id w17mr4887083ejb.182.1622821237120;
        Fri, 04 Jun 2021 08:40:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx6OCuqC7otvjEPCd4UoW7TVyEyfhe9GbhSP/JT/jCZOXKJpVdvegR5UaYYFwES/zgZcL7xYQ==
X-Received: by 2002:a17:906:1311:: with SMTP id w17mr4887058ejb.182.1622821236938;
        Fri, 04 Jun 2021 08:40:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m12sm3393422edc.40.2021.06.04.08.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 08:40:36 -0700 (PDT)
Subject: Re: [RFC] /dev/ioasid uAPI proposal
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
References: <20210602130053.615db578.alex.williamson@redhat.com>
 <20210602195404.GI1002214@nvidia.com>
 <20210602143734.72fb4fa4.alex.williamson@redhat.com>
 <20210602224536.GJ1002214@nvidia.com>
 <20210602205054.3505c9c3.alex.williamson@redhat.com>
 <20210603123401.GT1002214@nvidia.com>
 <20210603140146.5ce4f08a.alex.williamson@redhat.com>
 <20210603201018.GF1002214@nvidia.com>
 <20210603154407.6fe33880.alex.williamson@redhat.com>
 <MWHPR11MB1886469C0136C6523AB158B68C3B9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210604122830.GK1002214@nvidia.com>
 <20210604092620.16aaf5db.alex.williamson@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <815fd392-0870-f410-cbac-859070df1b83@redhat.com>
Date:   Fri, 4 Jun 2021 17:40:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210604092620.16aaf5db.alex.williamson@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/21 17:26, Alex Williamson wrote:
> Let's make sure the KVM folks are part of this decision; a re-cap for
> them, KVM currently automatically enables wbinvd emulation when
> potentially non-coherent devices are present which is determined solely
> based on the IOMMU's (or platform's, as exposed via the IOMMU) ability
> to essentially force no-snoop transactions from a device to be cache
> coherent.  This synchronization is triggered via the kvm-vfio device,
> where QEMU creates the device and adds/removes vfio group fd
> descriptors as an additionally layer to prevent the user from enabling
> wbinvd emulation on a whim.
> 
> IIRC, this latter association was considered a security/DoS issue to
> prevent a malicious guest/userspace from creating a disproportionate
> system load.
> 
> Where would KVM stand on allowing more direct userspace control of
> wbinvd behavior?  Would arbitrary control be acceptable or should we
> continue to require it only in association to a device requiring it for
> correct operation.

Extending the scenarios where WBINVD is not a nop is not a problem for 
me.  If possible I wouldn't mind keeping the existing kvm-vfio 
connection via the device, if only because then the decision remains in 
the VFIO camp (whose judgment I trust more than mine on this kind of issue).

For example, would it make sense if *VFIO* (not KVM) gets an API that 
says "I am going to do incoherent DMA"?  Then that API causes WBINVD to 
become not-a-nop even on otherwise coherent platforms.  (Would this make 
sense at all without a hypervisor that indirectly lets userspace execute 
WBINVD?  Perhaps VFIO would benefit from a WBINVD ioctl too).

Paolo

