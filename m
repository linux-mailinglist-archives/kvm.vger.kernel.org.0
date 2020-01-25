Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2586D149436
	for <lists+kvm@lfdr.de>; Sat, 25 Jan 2020 10:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgAYJmp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Jan 2020 04:42:45 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51404 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725710AbgAYJmp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 Jan 2020 04:42:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579945364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fUzyzLWmswe31Ykt6BiCbKwzjAX1cE7qoFYpjUmDjW0=;
        b=Jc8PDStPYVpom8HEBK7oSxrghubRBcQntbkCxU4x2QWda4YNwFoJp+x3o7DUBW09geLQYc
        k7vOwgOR42dEaGYRO7B1QAs2XioEQxU4mEb1iiolzxLEFaU5rURJXu3t6U8Y8O6pc28mik
        uvzWXXocHdkSFv4/ZDa64wa9R9m9Pjc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-sG9pwedaP8WGXMm6djzdig-1; Sat, 25 Jan 2020 04:42:42 -0500
X-MC-Unique: sG9pwedaP8WGXMm6djzdig-1
Received: by mail-wr1-f70.google.com with SMTP id j4so2755934wrs.13
        for <kvm@vger.kernel.org>; Sat, 25 Jan 2020 01:42:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fUzyzLWmswe31Ykt6BiCbKwzjAX1cE7qoFYpjUmDjW0=;
        b=UF8qZlw2bbW1IizR5U9r+wk4m+XfZe/Om72AFlfYCsuKu8msczopHxtAVw8wehDG2X
         PSlt86o6Sjd0PMXCWY517kHibDzkldAzTrRhPOMLs/dNmP4dscbNeaXYxAPr7Re1JeEb
         dIi4D+hRbxVllGj3MnB4vQtDVQTS/EVXQdVMRoknuJRzByZwR28ptZfoFzA7jbFjTdDs
         N4z9NhsuhBSJgTLiJ20VZsW1HGdM3nW6x31AILiMbOcbw+NpC089PO3fCWRNGzuo4vr9
         uDxfdNNmXXDlkIcxkLfk7iR9OaR2YAJWaTkqZRmzNte9ZDo6vXHuBBGvu1npuKuzdEXQ
         Lb4A==
X-Gm-Message-State: APjAAAWCMs7vHFIDy0AsmmoG4N6dXd/pRsursiHAcBmKee1h/U2hTY0t
        fjglmgpytmUqJ5J+BE2TkQL9HbHZ7zYGvrU+dYINpb2vAO2Ml5wDN4YJwXgZ2+kVJNoN698L3xh
        rdGWHXPSn+hwO
X-Received: by 2002:a7b:cb8e:: with SMTP id m14mr3738345wmi.66.1579945361431;
        Sat, 25 Jan 2020 01:42:41 -0800 (PST)
X-Google-Smtp-Source: APXvYqxK+bFtb0AJ82DbwTqZ22LzUBCTYuS2B0SEYnH8IKUBbUCVBTKPir4WhtW0jPi2whXCiVdUDg==
X-Received: by 2002:a7b:cb8e:: with SMTP id m14mr3738320wmi.66.1579945361118;
        Sat, 25 Jan 2020 01:42:41 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 205sm4860846wmd.42.2020.01.25.01.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 01:42:40 -0800 (PST)
Subject: Re: [PATCH 0/2] KVM: x86: do not mix raw and monotonic clocks in
 kvmclock
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1579702953-24184-1-git-send-email-pbonzini@redhat.com>
 <20200124203630.GA28074@fuller.cnet>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e89aec6e-977c-b362-d07c-c6be2d7de8a2@redhat.com>
Date:   Sat, 25 Jan 2020 10:42:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200124203630.GA28074@fuller.cnet>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/01/20 21:36, Marcelo Tosatti wrote:
> On Wed, Jan 22, 2020 at 03:22:31PM +0100, Paolo Bonzini wrote:
>> Commit 53fafdbb8b21f ("KVM: x86: switch KVMCLOCK base to monotonic raw
>> clock") changed kvmclock to use tkr_raw instead of tkr_mono.  However,
>> the default kvmclock_offset for the VM was still based on the monotonic
>> clock and, if the raw clock drifted enough from the monotonic clock,
>> this could cause a negative system_time to be written to the guest's
>> struct pvclock.  RHEL5 does not like it and (if it boots fast enough to
>> observe a negative time value) it hangs.
>>
>> This series fixes the issue by using the raw clock everywhere.
>>
>> (And this, ladies and gentlemen, is why I was not applying patches to
>> the KVM tree.  I saw this before Christmas and could only reproduce it
>> today, since it requires almost 2 weeks of uptime to reproduce on my
>> machine.  Of course, once you have the reproducer the fix is relatively
>> easy to come up with).
>>
>> Paolo
>>
>> Paolo Bonzini (2):
>>   KVM: x86: reorganize pvclock_gtod_data members
>>   KVM: x86: use raw clock values consistently
>>
>>  arch/x86/kvm/x86.c | 67 ++++++++++++++++++++++++++++--------------------------
>>  1 file changed, 35 insertions(+), 32 deletions(-)
>>
>> -- 
>> 1.8.3.1
> 
> Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> BTW, should switch both masterclock and non-masterclock cases
> to raw clock base. Do you see any problem with that? 

Indeed, that makes sense as a kind of unification of the code.  Together
with adding pvclock_gtod support for 32-bit, it should be easy.

Paolo


