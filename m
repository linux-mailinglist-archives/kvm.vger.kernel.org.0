Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B514192E4
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbhI0LPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:15:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29997 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233968AbhI0LPJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Sep 2021 07:15:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632741211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7tSoUz2N0qF0zb0Et/cte83XJDDHfriVu1jQ2m+uNHw=;
        b=fDEsLsO0zu2ctxyqb9sCm5gayFwRKzKbbYQobo5n70hxJdmSyGaCKyiARk91Tdb7E3367v
        BxZA9h25uV6DynPxZ+3RDJop+xKTSqFUSIPuRRqf0yihKdytAvxQ5FOm85+C7urgDCNYvn
        1ofNZJKSFbc+QU00+QxY8ZVVCfmf4NI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-j5ByBRPDOamxDEex4ivo0A-1; Mon, 27 Sep 2021 07:13:30 -0400
X-MC-Unique: j5ByBRPDOamxDEex4ivo0A-1
Received: by mail-ed1-f72.google.com with SMTP id w24-20020a056402071800b003cfc05329f8so17404809edx.19
        for <kvm@vger.kernel.org>; Mon, 27 Sep 2021 04:13:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7tSoUz2N0qF0zb0Et/cte83XJDDHfriVu1jQ2m+uNHw=;
        b=NeRlGh+86qnXwCJDRhOI6HfpCoNUZheAqAEuLYWzcV5uh3QPFVPXWTLxs0LpqvLvy+
         k0po1rpBIel7pG6vFNeknVE43Tqbn447YEa/PRBUgAT94hWCKMDU0LCJmki5CPdVilWO
         E0R59HhwWZyBAZ9WEYdwHBYm1F1o5i5Ho6qXbgLZSsTlWyU6kb2289+JvpzIIIMab/h+
         QSUIVvCudyyYrNRdKd0eGNwtTF6dd5pRlPPLmiZ5LfiTW2ldjiBaDjd5xEnTATKlZ90o
         mdkXHHu0UOStJR4Sc5vBaP9wL9VusHsvQ2pcYTaxPtCPShlGDsPMTsMOQF7i9JemfSRy
         c1rQ==
X-Gm-Message-State: AOAM530QKLs4tyZcKz87Gqnm8zzqhJiWBGXNpPXlOJo57ZtBI9OIY9kQ
        W2iLXIM+Er0z/rSBqbnzPjhPMEoS6j4tx/FP9ISsf3tEShvQGJowpMwpPXPfdtApuwU7+519jgp
        PM5u+ePybWChQ
X-Received: by 2002:a05:6402:51d2:: with SMTP id r18mr22609365edd.108.1632741209105;
        Mon, 27 Sep 2021 04:13:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5RvtOHWYR+utbtWs3XCi1myI6/TvDCQG0lXgTUXxR6H4yPccUvoVamO+Lk19ceP7uPQfFIw==
X-Received: by 2002:a05:6402:51d2:: with SMTP id r18mr22609343edd.108.1632741208936;
        Mon, 27 Sep 2021 04:13:28 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u2sm10370698eda.32.2021.09.27.04.13.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 04:13:28 -0700 (PDT)
Message-ID: <fcbbdf83-128a-2519-13e8-1c5d5735a0d2@redhat.com>
Date:   Mon, 27 Sep 2021 13:13:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: x86: Expose Predictive Store Forwarding Disable
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>, Babu Moger <babu.moger@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        hpa@zytor.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tony.luck@intel.com, peterz@infradead.org,
        kyung.min.park@intel.com, wei.huang2@amd.com, jgross@suse.com,
        andrew.cooper3@citrix.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
 <YVGkDPbQmdwSw6Ff@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YVGkDPbQmdwSw6Ff@zn.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/21 12:59, Borislav Petkov wrote:
> On Thu, Sep 23, 2021 at 08:15:28PM -0500, Babu Moger wrote:
>> Linux kernel does not have the interface to enable/disable PSFD yet. Plan
>> here is to expose the PSFD technology to KVM so that the guest kernel can
>> make use of it if they wish to.
> 
> Why should the guest kernel expose it if we said that for now we want to
> disable it with the SSBD control?

Because the guest kernel needs to know which MSRs to write when you 
touch the SSBD prctl, so that PSFD is properly disabled *inside the guest*.

Paolo

