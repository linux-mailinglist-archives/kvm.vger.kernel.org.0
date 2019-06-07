Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 795A338EC5
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 17:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729368AbfFGPRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 11:17:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34270 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728486AbfFGPRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 11:17:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id e16so2581638wrn.1
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2019 08:17:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sX/pioxuVMxljt5xFEWz/xGKhecKIEm1tNEtt9DHln0=;
        b=evFqLuA866AC915LkHLAXY0iJsewHH8s7ufEFTo7s2OyJHCvrtaM/TYfWuMbenE5po
         MaiXHpag8q5obmHV+Q4XtDKaQiApLLXFinD/GJoDAKLYgxwmbfyVMw+0LmhBuOZklhTI
         eX3OqDmFWly1UMeMLrzdEgRAhg5eQ4fkEONmpHLdw8x4uKsHqhnojP5lGkXsLyjM88rB
         jTeCZSvTH3Zo4i9Bv+2IF5HQkKfAxXFSjbN2YuZRLHe7wsNkWUR2vUBEM6dR9bQm5G1H
         vBdOsurjuRS+6lyym9DJxEKUsonebyz3gMPuAXuXreMz67Dl86riYyGISrNiL+4Atq+o
         ZC1A==
X-Gm-Message-State: APjAAAU3GtTKtH7FYR0fDLtykXiSwSz39a8wm54zkeC+oWrZkFH6mA1K
        kVHKmh4DdK5LiUQqCQpTSPY7KTV7vgE=
X-Google-Smtp-Source: APXvYqzAXTGUk9Z0sa4D/SLHGUJd6uodo7ETHrJjF2Inh/QnYCsHcWJybb0atPguJ+rdSbEb6HG83Q==
X-Received: by 2002:a5d:4ac1:: with SMTP id y1mr5512703wrs.210.1559920630411;
        Fri, 07 Jun 2019 08:17:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id o185sm984015wmo.45.2019.06.07.08.17.09
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 08:17:09 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Rename prepare_vmcs02_*_full to
 prepare_vmcs02_*_extra
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <1559834652-105872-1-git-send-email-pbonzini@redhat.com>
 <20190606184117.GJ23169@linux.intel.com>
 <8382fd94-aed1-51b4-007e-7579a0f35ece@redhat.com>
 <20190607141847.GA9083@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5762005d-1504-bb41-9583-ec549e107ce5@redhat.com>
Date:   Fri, 7 Jun 2019 17:17:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190607141847.GA9083@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/19 16:18, Sean Christopherson wrote:
> On Fri, Jun 07, 2019 at 02:19:20PM +0200, Paolo Bonzini wrote:
>> On 06/06/19 20:41, Sean Christopherson wrote:
>>>> +static void prepare_vmcs02_early_extra(struct vcpu_vmx *vmx,
>>> Or maybe 'uncommon', 'rare' or 'ext'?  I don't I particularly love any of
>>> the names, but they're all better than 'full'.
>>
>> I thought 'ext' was short for 'extra'? :)
> 
> Ha, I (obviously) didn't make that connection.  ext == extended in my mind.

That's what came to mind first, but then "extended" had the same issue
as "full" (i.e. encompassing the "basic" set as well) so I decided you
knew better!

Paolo
