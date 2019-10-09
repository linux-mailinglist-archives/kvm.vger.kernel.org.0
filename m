Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7364CD0741
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 08:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbfJIGcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 02:32:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20804 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729592AbfJIGcl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 02:32:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570602759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=h6Sly0UQcnVpJC8OIODwQn4hcQF/o08M/az76/Tsc/8=;
        b=TavA7cbQcMjYbeBfehzp9M/PXe4eXXwKpvCEggrsA+6UC9jzZu2Nh75qPMmcD6e5mQoqcH
        UElHh2erUubKi0eCFSqYBiM9C3UC1i+uA22R/boV1ghOfK/F8APNQKUUy6QhKygPW9xy1e
        /7WUKaVqtVDTpxHY2bMI60DAaVmXcIs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-XN5GzqzwMGGa9YBt02vB0g-1; Wed, 09 Oct 2019 02:32:38 -0400
Received: by mail-wr1-f70.google.com with SMTP id k2so629028wrn.7
        for <kvm@vger.kernel.org>; Tue, 08 Oct 2019 23:32:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rbx6Cg/PwmHq6fv44Clat3CQrNNax0HRF3SOrPED5sg=;
        b=EWeXViu7PKz/GzHGCCO3unUuVz/M3wl8sFePBZxNMvV+XYf52VNSQNeM7XEKV7nwXC
         yPZOTqtImbny9xsbtNX5VS16yrh8nwDiRqcWxUMBdU7apHo/78KAjiTp80Gi6yEmDMRa
         MCxuGsmgaZ06U4ncuMr2Xir52I/CEz8nt78JIOvwJ2oIGmbZz4sYv7cIJQTtNDp2/LKx
         j2d4oEqKRIN+41KMgAICSBxqeu8Zh311P+D/7qKYUZIABCpcpQjidZD/CSO/kbVR5hcV
         z23wCbVOsE7iJb49RB30pm9I2I3dtvB0LLv5iEIzYyRLIHhnzISTUTvLyTfCc8kvImaU
         V9mw==
X-Gm-Message-State: APjAAAXKFsc1BeX28kTypOjDyaCY5qqqU7/WomVSk5iF8B2yOU8z+r87
        2tIzVW9gzcvEoJAePHMdoiUTmMHgaI1bNH26PR9ShY85T/iq7ZzWNHnsKId9gb0clJZbyWQDrry
        1OWPS2Quv2BjQ
X-Received: by 2002:adf:8385:: with SMTP id 5mr1447764wre.267.1570602757124;
        Tue, 08 Oct 2019 23:32:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqztyT/FVlfLzFRo2CBKr8RR/At7apHVHI3SdmexZZYqT0y2OHnK2A5zCPwIpL6dY33IvviZ6Q==
X-Received: by 2002:adf:8385:: with SMTP id 5mr1447739wre.267.1570602756869;
        Tue, 08 Oct 2019 23:32:36 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 207sm1740501wme.17.2019.10.08.23.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 23:32:36 -0700 (PDT)
Subject: Re: [Patch 4/6] kvm: svm: Enumerate XSAVES in guest CPUID when it is
 available to the guest
To:     Yang Weijiang <weijiang.yang@intel.com>,
        Aaron Lewis <aaronlewis@google.com>
Cc:     Babu Moger <Babu.Moger@amd.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20191009004142.225377-1-aaronlewis@google.com>
 <20191009004142.225377-4-aaronlewis@google.com>
 <20191009014226.GA27134@local-michael-cet-test>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <0f94a5e3-49bc-be1a-8994-46124c02109e@redhat.com>
Date:   Wed, 9 Oct 2019 08:32:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191009014226.GA27134@local-michael-cet-test>
Content-Language: en-US
X-MC-Unique: XN5GzqzwMGGa9YBt02vB0g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/10/19 03:42, Yang Weijiang wrote:
> +=09if (guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> +=09    boot_cpu_has(X86_FEATURE_XSAVES))
> +=09=09guest_cpuid_set(vcpu, X86_FEATURE_XSAVES);
> +

This is incorrect, as it would cause a change in the guest ABI when
migrating from an XSAVES-enabled processor to one that doesn't have it.

As long as IA32_XSS is 0, XSAVES is indistinguishable from XSAVEC, so
it's okay if the guest "tries" to run it despite the bit being clear in
CPUID.

Paolo

