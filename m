Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D276349945
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 19:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhCYSOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 14:14:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43305 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229868AbhCYSNt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 14:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616696029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uiCdIYAQx4Egk1IFrgMr9yPXh2tXd1+ed+O6pyW2k4A=;
        b=agVN/JaHJRJA0flrRxJi7FabR2aSya1ENbE8d39HGTWUk4feM5Sqy+JIrVLauBHMVlM+KD
        5X4zFn1btbrmVCBV1Dmq6WUhHOkpXLeWSAQDb8eROzNAwq+V6McHNw9OErs0aDJmu75C+g
        k9nn88dwqFACYJmjvTMXfbNbC+DUY2w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-ax-wj2-oNiultgQMw3K_AQ-1; Thu, 25 Mar 2021 14:13:47 -0400
X-MC-Unique: ax-wj2-oNiultgQMw3K_AQ-1
Received: by mail-wm1-f72.google.com with SMTP id o9so126494wmq.9
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 11:13:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uiCdIYAQx4Egk1IFrgMr9yPXh2tXd1+ed+O6pyW2k4A=;
        b=PBKCXyBQ/HrGbX/NQzKAXhMkZpsF1zDYIm3gTKlzBlYkyDwCXxvjhVjBHyY/LOOYuq
         sV0hXWli4s8IoDOggWJkt+fJ8qGfGXQw/CWbRG0UaKfhUMVxVn3/ObXja5NnCLEOed2Y
         iOQHwnYVqgoiTaE7stLOnsYlUEeM5hAZS3lhfQuDGS1Zl5iYuAFv4pxjndgtw2ykhIXW
         /TU6XBNBo6F34/Kz3X8WvzyvHKqXSS2icYRf7OvOL9NOgUKwd32UORG5E7FcpbzbAs8O
         IsPQ3kiFG8WnUCfrW0fkFFLQFufDuQs3erdSq5pOQ5MVSSRfff4jydUMkst6WMlM+c3E
         tqhA==
X-Gm-Message-State: AOAM532hgK8pm7tAcOCXMKd7icM1hgsXIma+CDY+W1lzPp0+8+3Kdh0u
        WewskSmuh30Hg/xtIH4ex/us8wU4r9oAGOluozrHemJ5rDJmZIxiiFZ+TRcfAaM1FXLwWbxPM/o
        7g39UQFeRju5P
X-Received: by 2002:a1c:21c3:: with SMTP id h186mr9084937wmh.32.1616696025939;
        Thu, 25 Mar 2021 11:13:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyc+5BOjBmvH8N6msX4fL6crdronTklD4godiHBJIh10cFpPrRmQsfRyBQj+r2xEcYFcPe7w==
X-Received: by 2002:a1c:21c3:: with SMTP id h186mr9084918wmh.32.1616696025710;
        Thu, 25 Mar 2021 11:13:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o2sm7325281wmc.23.2021.03.25.11.13.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 11:13:45 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.12, take #3
To:     Marc Zyngier <maz@kernel.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
References: <20210325114430.940449-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <09d76225-c9ec-46a9-0ba7-5e22d1669c6b@redhat.com>
Date:   Thu, 25 Mar 2021 19:13:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210325114430.940449-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/03/21 12:44, Marc Zyngier wrote:
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.12-3

Pulled, thanks.

Paolo

