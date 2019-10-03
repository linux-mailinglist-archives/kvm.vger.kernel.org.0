Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3DE8CA131
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 17:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbfJCPhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 11:37:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35432 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729752AbfJCPhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 11:37:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570117044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qrz8YJPOUTLl2wYuvy1P4bMW9shlmohZvrrGhpPkIRs=;
        b=KtFIyhWrCLLGKG2wtbF772zrUg/PsOhLQoHtmamc8jiE3coKlv378/n1YE09mmjekDcmzj
        FuPrx71ncJbrdW1AX+DnBNn8oE2O6S0hvcH9w1fQKl9/6fT3gvU+eQVfTMj5zxc1TmSAEq
        Bv+73Z/63RGEmV+H5eMottQgdTMCHvA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-ONUVShRTOpKc7E9a4LAoXQ-1; Thu, 03 Oct 2019 11:37:20 -0400
Received: by mail-wr1-f69.google.com with SMTP id t11so1278463wro.10
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 08:37:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mVVDjxqOVTW6Hr6MGw2wdGvPn8dr2/wzfFgapg8i2Zc=;
        b=LY8g7OClafq+qKRAWT4i3h6VqfsMEqZtJSnJkKTRG7I6KmDpMbgTwS3t3ZKvkDltKd
         FUOCJnhBbg6GrQ+G374nyDYuBaywN6N/5gnS4+PttejuExoNRt6ybF1svwAuc8fUx+u7
         WV0HiwJR0cSAv4byb97Xw0z0cqbUERaUJzX95uK0Jle5reg6btQJ1s8LBu2sjZ5oTmO3
         4qQIm2R2bjnLsTOZ1JTglIO3Ayi0fIjJgzpzO/xRXY6ZiKf58NSKe/Bv9jKzGU1oNPry
         CLmpeKaIvIjudihWdHZmcJVKrLUcF4uaZ8kPa8cG6gJVZQVCtzAxu07NrR05vjLrQQz/
         sPzQ==
X-Gm-Message-State: APjAAAUvKf2/G55WXXXKN7aB2RVCaC8O9nM3AYjmTXND1kDMQvNDVwvr
        uJmkJGYXJUy1b4Ipyf6IT0S70iUoB3J66CbhH29cyaLKx6QCtjl4tVQQUv/CZq7HjdkDpIPvRyy
        RNEck/8V6/EMc
X-Received: by 2002:a05:600c:22da:: with SMTP id 26mr7142089wmg.177.1570117039637;
        Thu, 03 Oct 2019 08:37:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyaEH0vrDdtTn03vNIjY6XC27eAPbcWStCVYNFQxWvlASlLZpHw/85jrbDXb7655AqkOZtGkQ==
X-Received: by 2002:a05:600c:22da:: with SMTP id 26mr7142073wmg.177.1570117039322;
        Thu, 03 Oct 2019 08:37:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b903:6d6f:a447:e464? ([2001:b07:6468:f312:b903:6d6f:a447:e464])
        by smtp.gmail.com with ESMTPSA id 143sm3117461wmb.33.2019.10.03.08.37.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 08:37:18 -0700 (PDT)
Subject: Re: A question about INVPCID without PCID
To:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
References: <CALMp9eRPgZygwsG+abEx96+dt6rKyAMQJQx0qoHVbaTKFh0CqA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6220e2b4-be59-736c-bc98-30573d506387@redhat.com>
Date:   Thu, 3 Oct 2019 17:37:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRPgZygwsG+abEx96+dt6rKyAMQJQx0qoHVbaTKFh0CqA@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: ONUVShRTOpKc7E9a4LAoXQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/10/19 21:48, Jim Mattson wrote:
> Does anyone know why kvm disallows enumerating INVPCID in the guest
> CPUID when PCID is not enumerated? There are many far more nonsensical
> CPUID combinations that kvm does allow, such as AVX512F without XSAVE,
> or even PCID without LM. Why is INVPCID without PCID of paramount
> concern?
>=20

I guess you're looking at this code:

                /* Exposing INVPCID only when PCID is exposed */
                bool invpcid_enabled =3D
                        guest_cpuid_has(vcpu, X86_FEATURE_INVPCID) &&
                        guest_cpuid_has(vcpu, X86_FEATURE_PCID);

The INVPCID instruction will be disabled if !PCID && INVPCID, but it
doesn't really disallow *enumerating* INVPCID.  There is no particular
reason for that, it was done like that originally ("KVM: VMX: Implement
PCID/INVPCID for guests with EPT") and kept this way.

With !PCID && INVPCID you could use PCID=3D0 operations as a fancy INVLPG,
I suppose, but it is probably uninteresting enough that no one bothered
changing it.

Paolo

