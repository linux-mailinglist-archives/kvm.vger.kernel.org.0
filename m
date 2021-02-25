Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFE03257D4
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234234AbhBYUhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:37:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48567 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234109AbhBYUez (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 15:34:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614285194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qrF+Ni2Yvil2kIq/7VfKLEGp6/CXFjij6cAq88xAmxE=;
        b=fOLV0jvcXfr2ilU4CWZfdXDJqRJPaDuXFph5nK4Z6nKNN+wpn3NzfsMwWM5QOuUtuU/f6s
        YyeuLk2JYtia3WAo2GtOgmbB/gsXt+H36Ns005a/OVlNq18VYPJPqXDBjzwXKUliOgm5Jm
        kyulFCL5jyHjgA2i/N4WP/m8V5mxxYw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-S-hGoYDlMWyb0M8rGTofJg-1; Thu, 25 Feb 2021 15:33:12 -0500
X-MC-Unique: S-hGoYDlMWyb0M8rGTofJg-1
Received: by mail-wm1-f70.google.com with SMTP id b201so2701107wmb.9
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:33:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qrF+Ni2Yvil2kIq/7VfKLEGp6/CXFjij6cAq88xAmxE=;
        b=Rp3g5EOYxw5Xln+fspaXQTUgO2TldwY6r7JeZO3ZQCdU/6l4DRSrbP5iioRHIRziTp
         a3gq+98pVNKqQCENPqKhTmAPFbfJbP00v92xU9qTz19ETUgV8vdkUGK4tJ8qJqCNwioB
         57Pg2OMCRakZQ4y1bOTwHPJbg4mG23mhyQbRGzffkIuxXpM3jpgCx6iyve2iRqoJmLyz
         aV9pICOWIXe8132SN8uos4UjdMy2tloSrR4PGU/KWpeXn/HFhoGep3vLOeb7jCt9B9f5
         S9s7G1SkPvPSH5DERNrMfknDRJX/Cnu3qKGHiP6l6dJGx7yvjYWsgvPm2RCAnY+YabxT
         A2ug==
X-Gm-Message-State: AOAM532vF5+/lbPa5CrI3LlxJW5klS80ksWtVCXTEFEoTHMQwKVNn/ut
        A8M0ldrg6WI0btyFgJZDrPaHUAQ6sk1WrU+gEkT3/pI21k/2L0mHscxJGs3Q20iZecPAmv5nVhL
        sOswYS6F6DS3e
X-Received: by 2002:adf:c54a:: with SMTP id s10mr5332871wrf.58.1614285191799;
        Thu, 25 Feb 2021 12:33:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyiUc9+l4ySZeqyFxoKprpfooBMz8zXXybLQPxr5oMIikAdNnqwvHSl61IP+s6ufodA9vyIZQ==
X-Received: by 2002:adf:c54a:: with SMTP id s10mr5332864wrf.58.1614285191591;
        Thu, 25 Feb 2021 12:33:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k15sm8569395wmj.6.2021.02.25.12.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 12:33:10 -0800 (PST)
Subject: Re: [RFC] KVM: x86: Support KVM VMs sharing SEV context
To:     Ashish Kalra <ashish.kalra@amd.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     natet@google.com, brijesh.singh@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        seanjc@google.com, srutherford@google.com, thomas.lendacky@amd.com,
        x86@kernel.org, Tobin Feldman-Fitzthum <tobin@ibm.com>,
        DOV MURIK <Dov.Murik1@il.ibm.com>
References: <20210224085915.28751-1-natet@google.com>
 <7cb132ce522728f7689618832a65e31e37788201.camel@HansenPartnership.com>
 <20210225181812.GA5046@ashkalra_ubuntu_server>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b885c283-ceb3-b9bc-516b-c28771652a7c@redhat.com>
Date:   Thu, 25 Feb 2021 21:33:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210225181812.GA5046@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/02/21 19:18, Ashish Kalra wrote:
> I do believe that some of these alternative SEV live migration support
> or Migration helper (MH) solutions will still use SEV PSP migration for
> migrating the MH itself, therefore the SEV live migration patches
> (currently v10 posted upstream) still make sense and will be used.

I think that since the migration helper (at least for SEV, not -ES) is 
part of the attested firmware, it can be started on the destination 
before the rest of the VM.

Paolo

