Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA1C440D55
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 07:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhJaGdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 02:33:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229638AbhJaGdS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 02:33:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635661846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UuMUoN3DNgMNQuGO47M8OlVwO//v5SsV/9a4qP2ja2s=;
        b=JX4atSfMERD0soJ0XkR4S9hQ2KTHsl+gA55k96YrUsXGrVE9ROhIXST0dX9Nadc4x2Ph8z
        9EHlL+qxxyc1ZLOJEnb8fYxDHm9aK0j/yJwHrBji5PE6YUM4+idfDYEyOz69zQ7VznzDlZ
        fLsBXKI2BHI3VNCeZkAN85AcBiDubeU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-2os-t6_lNvuFhq8wkxCbOA-1; Sun, 31 Oct 2021 02:30:45 -0400
X-MC-Unique: 2os-t6_lNvuFhq8wkxCbOA-1
Received: by mail-ed1-f70.google.com with SMTP id y3-20020a056402358300b003dd490c775cso12730679edc.22
        for <kvm@vger.kernel.org>; Sat, 30 Oct 2021 23:30:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UuMUoN3DNgMNQuGO47M8OlVwO//v5SsV/9a4qP2ja2s=;
        b=cJZ6JLNTh/lzCngOMByTDVwHomVznKwN+n2+wC1dgTIDDu4jTMCreRRzjhVSUdI9Hv
         KP3Exb5VSArI7dRhI/gC8Y+5uhPzFZyWk4uFzj2xT4yhGPbsItvFh+TNYBy+LXSLh0Uw
         CZeoEIistdkPK5iz1aizZ90wz52ts4x/EXWhYHTWEkMxzFDxe9H9XVbhswpsnn2zqVqw
         mYK8WuQ3bmQrdigg8QOJgPOnwHWGB9CJGmcQIpQuROg6or17M6NVRXajtImc4AnRDHMA
         bG6D2mhaXcbsb9BjiIXsL9zNMkj4YDatqfqzOOdc6o6Ay/6/Wqzb8znDB141+QuZsYp3
         L47A==
X-Gm-Message-State: AOAM532G5HqXVqTHd+ADlPRz79juFb+xcPtWClwFRvyaSkSv/Mg2+1iw
        lkylOi/rZeWudUy+EYyHHSodIRcIIN6XN/VLFhGTjbh3ArGGaKLeuKMKaG1PAQRtDAhrQpFiaSA
        hi6r1RssGsZho
X-Received: by 2002:a17:907:9810:: with SMTP id ji16mr7345912ejc.373.1635661843956;
        Sat, 30 Oct 2021 23:30:43 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYR8/w3iMBcLwPHxc1ndn6etLor4iw6lD26BqfNQfkVxlJyFTmd+iZCakiFuTDetnIrtSR4w==
X-Received: by 2002:a17:907:9810:: with SMTP id ji16mr7345886ejc.373.1635661843735;
        Sat, 30 Oct 2021 23:30:43 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id s3sm5194685ejm.49.2021.10.30.23.30.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Oct 2021 23:30:42 -0700 (PDT)
Message-ID: <cfd722b9-7b18-232e-b2c7-65806b8d05ff@redhat.com>
Date:   Sun, 31 Oct 2021 07:30:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.16
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Scull <ascull@google.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Fuad Tabba <tabba@google.com>, Jia He <justin.he@arm.com>,
        Joey Gouly <joey.gouly@arm.com>,
        Oliver Upton <oupton@google.com>,
        Quentin Perret <qperret@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20211029093510.3682241-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211029093510.3682241-1-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/10/21 11:35, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-5.16

Pulled, thanks!

Paolo

