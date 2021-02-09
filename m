Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA67314C80
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 11:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhBIKFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 05:05:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231327AbhBIKDH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 05:03:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612864899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k1i4kA2ikoqEIy73WvpsH9kR9GpwZKdO/NHE9o+wheQ=;
        b=FjKU0y4JGGEP0fy2WK2BS32WItnIEcNU7+hACOJz1uBuHTzLx/vfKgunl3xjN7CqIS+ey1
        HX3gmi3FEtOFBUDcXVenJB+BAEvPNuM1ntMxmBOlYe8ko8kgO+/f8iJIA/l0p8IEK8PH5Q
        g2gf4lA45I67NdmXZuFt5IPJbrcaETU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-Tqumv9jqPziTnDFgEMtDIA-1; Tue, 09 Feb 2021 05:01:37 -0500
X-MC-Unique: Tqumv9jqPziTnDFgEMtDIA-1
Received: by mail-wr1-f71.google.com with SMTP id u15so16524440wrn.3
        for <kvm@vger.kernel.org>; Tue, 09 Feb 2021 02:01:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k1i4kA2ikoqEIy73WvpsH9kR9GpwZKdO/NHE9o+wheQ=;
        b=V6R3Y7L9UGT8tsZFf5ha0AH846z7hcMHNcct/vhSetWZrNw34FjZy+W8vBXQGDGzFT
         yUvGRvUuuNHDxL6NmjhY+vzURYFAgStultOInS+7s5dNFyH95tlmUOnN2QJadsl5hn/z
         LVLP01Wu8WMYoRefEw6xnY/e0TtIk5Vu+7ulXgl+x/i/LQy6QsjWKA8ICgLRklUPphZZ
         2PQZvM8sNz3TRgaRsf0AVE24kqEtkW4whbxh74A3POMrO/jQ/DqrWdsj57MAALnhXXDh
         IRM7WBV8Tw2TwvT3iiJhlcck6jOFhdS+L2shpXOIRpE55dpWuXNhywYPkHfFE5SNOnTv
         Ky2g==
X-Gm-Message-State: AOAM533veyN+YmhgPxI5JN4k3n1bbet1Sqz4hh4FbJS87zsHun3ps/0A
        hs4Ow2kN1SdJ8cPBh6HaVM7I3Ua18FpXJOzMgvSkp4AYbJXwbS+v2FWYkaARixevUjjmHOm4GQM
        Na1lW463lE0lg
X-Received: by 2002:a1c:318a:: with SMTP id x132mr2667851wmx.6.1612864896732;
        Tue, 09 Feb 2021 02:01:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxpw6BIjnxiqkkeBjvrgae2D4o30y8fHuHqIVL3LcVSiw5rpDZgzP228TVvO4qazqkSUeeNQw==
X-Received: by 2002:a1c:318a:: with SMTP id x132mr2667839wmx.6.1612864896557;
        Tue, 09 Feb 2021 02:01:36 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b13sm13625804wrs.35.2021.02.09.02.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 02:01:35 -0800 (PST)
Subject: Re: linux-next: build warning after merge of the kvm tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>, KVM <kvm@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        David Woodhouse <dwmw@amazon.co.uk>
References: <20210209205950.7be889db@canb.auug.org.au>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <23ec3e79-1b6d-a116-ff52-3c5c1d0308d1@redhat.com>
Date:   Tue, 9 Feb 2021 11:01:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210209205950.7be889db@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/02/21 10:59, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the kvm tree, today's linux-next build (htmldocs) produced
> this warning:
> 
> Documentation/virt/kvm/api.rst:4927: WARNING: Title underline too short.
> 
> 4.130 KVM_XEN_VCPU_GET_ATTR
> --------------------------
> 
> Introduced by commit
> 
>    e1f68169a4f8 ("KVM: Add documentation for Xen hypercall and shared_info updates")
> 

Thanks, will fix.

Paolo

