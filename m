Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016CC31EE7E
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhBRSkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:40:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60924 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232541AbhBRSd1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 13:33:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613673107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T/XKcfNrmAyb0aGeTCuX/ybH6dn2nas/WmZXQFz1FWQ=;
        b=DI7wj7Bkv/93dwXbHWjHuhyXI786xvNDjkuKMY5dgkG99xE9LizMpk5Mx6UCo6FX5g26nk
        r9QxCfcq7W2lzH2zhjoScWp7XfLYeVv7DatomisZ9RAJ5Q4N9sDCnL7au6X4rcN34+eUxC
        hgQ/vNhCQd/lUygRd0PVPLwceOXiztc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-nQaj2_DsPYy2WV36YQQTZQ-1; Thu, 18 Feb 2021 13:31:45 -0500
X-MC-Unique: nQaj2_DsPYy2WV36YQQTZQ-1
Received: by mail-wr1-f71.google.com with SMTP id c9so1307249wrq.18
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 10:31:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T/XKcfNrmAyb0aGeTCuX/ybH6dn2nas/WmZXQFz1FWQ=;
        b=Pqa4H950FWPKEoJJbVdyisqFs4aMQb8XKDhAk0sRg2r0GJxZalL1x2Ue0EVm81zgg/
         43mkXFLts8FWdqA+wrYCojPIOZSgJ9qbYx6fR/8uGKbAqQP9v9xD4BMwVPqoRWnYG83c
         oQWaEUN93yE1/FRMkeKxCO6KGQhJnkF9dmhMmeXvrxxRkvcP9TLXp6u9bpUayWZUIejT
         qrE+sv4U+GGOF5dxtCM2mBnU1KegF48yqVl1rKAJnZkfR7Pj9bDrFQe1u4SkU6XoOV3B
         pAmu6rfR6QEmtGy9qH86cI8w5P1KEkhi15iPxCeLdXMxySxJXrfInfhK6hLkn5Kr02nC
         Fr8g==
X-Gm-Message-State: AOAM530+rVHnc/9FT2xOV6RY2kS8Vnh6oI6bH40Fw04GkuGwZO11WQnP
        mkShB11a7377hMbsyc2szfvxUvg+Mjq/LZTpJcBQWjpq0N3iUI4ALijD9riN1YF3IvJJzVMlzBt
        OSErFfEUro4vqrzTvfoxbNGdQgyOOWgssBjaf8fmaBvn/4NlxXzt1EwDVQG/wYB+M
X-Received: by 2002:a7b:cbc1:: with SMTP id n1mr4907118wmi.30.1613673103516;
        Thu, 18 Feb 2021 10:31:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyKcRyXWXBIKO73/QBgSX4/tvEROMOCFxwkC1dMFH7HRRk6ndJnm/lCvKpMeXhec0+ZfR2CJg==
X-Received: by 2002:a7b:cbc1:: with SMTP id n1mr4907100wmi.30.1613673103325;
        Thu, 18 Feb 2021 10:31:43 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c62sm9123951wme.16.2021.02.18.10.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 10:31:42 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests] x86: clean up EFER definitions
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20210218132648.1397421-1-pbonzini@redhat.com>
 <YC6rsTdE1iqiYYYO@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3b33ecee-e123-1fae-db99-7acf8192b29d@redhat.com>
Date:   Thu, 18 Feb 2021 19:31:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YC6rsTdE1iqiYYYO@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/02/21 19:02, Sean Christopherson wrote:
> On Thu, Feb 18, 2021, Paolo Bonzini wrote:
>> The X86_EFER_LMA definition is wrong, while X86_IA32_EFER is unused.
>> There are also two useless WRMSRs that try to set EFER_LMA in
>> x86/pks.c and x86/pku.c.  Clean them all up.
> 
> For posterity: EFER_LMA is incorrectly defined as EFER_LME, and both PKS and PKU
> tests are 64-bit only, so the WRMSRs are guaranteed to be nops.

Added to the commit message and pushed, thanks.

Paolo

>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 

