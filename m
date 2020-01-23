Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33924146E23
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 17:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgAWQQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 11:16:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58270 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726605AbgAWQQT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 11:16:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579796178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EIV/YyjsNHKvzfLLRkCsSAhXa/8ugLsBC1Uq238ttpo=;
        b=A6bMa2qD/vGHYww9/fyrlYX/iwf9BmAAfxEH7fwpS+CXrdzGOn73z5DYe2t8t4F5bAFmzP
        Ne4tk2bDc9onkus8jOAa2wgATOymq6vKbc6Gvaju9NBTXU2xhrVmKgHact13vso5RG12bY
        oKTeRbClsLbTC/aHl7oepxq1DzuYCHc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-0eb6Y4ZZN7uOKF-ShASYbA-1; Thu, 23 Jan 2020 11:16:08 -0500
X-MC-Unique: 0eb6Y4ZZN7uOKF-ShASYbA-1
Received: by mail-wr1-f70.google.com with SMTP id j13so2008762wrr.20
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 08:16:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EIV/YyjsNHKvzfLLRkCsSAhXa/8ugLsBC1Uq238ttpo=;
        b=PoSwMvQ5uoKuXMo+lhwITzG8WH6VzuqBza1h0ur66JlwXvDzGxfNy7E/PNZppVBavk
         9LVZsOHE/Q5RTPkzywMZ+vm0Ti0ni4kS3f7OGMPlcUIOOfCsqat3EMQiOlQYQh0fYnip
         EtcGziuIQOb+ynYY7njonKWgfC0H5PMbVuzj6R0/VN/ves94Un4bRdWn8RFlmTooDJED
         wB+uLCr0gYN6n5BQ9NkYnl6qYsY3rZeO8/pnKPSXWh5SRA8kAtvKNhO7v+03qBgxCV70
         ooL++Cg6BQx2BJoT7+1Q9mZdIVSQhMLZsS+djOM4JKunb0k+qF00o96HvbK5Rf/H6Y1d
         rDHQ==
X-Gm-Message-State: APjAAAXiYghlN/U0lkjLGNGKCbVvXcKzvD0p5j39UiWyshPEE/FccqQu
        9E24zFsjKiokyYGhj4GR9VK2z2+Mowgvl2VjQLucKXwn1weASj3d+LzBmDxDdhDNpiX9T8YaeG7
        WL/gVzGzUh5dI
X-Received: by 2002:a7b:c3d8:: with SMTP id t24mr4902874wmj.175.1579796167373;
        Thu, 23 Jan 2020 08:16:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqzVie/mIIlbsyC2TD4OU1SdHGQkoaSGWQtEsx5eV8zH3zTTSAH+2bwHeH80HjHcBrDABuEkxw==
X-Received: by 2002:a7b:c3d8:: with SMTP id t24mr4902864wmj.175.1579796167187;
        Thu, 23 Jan 2020 08:16:07 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id w19sm3056765wmc.22.2020.01.23.08.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 08:16:06 -0800 (PST)
Subject: Re: [RESEND] Atomic switch of MSR_IA32_UMWAIT_CONTROL
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Tao Xu <tao3.xu@intel.com>, Jingqi Liu <jingqi.liu@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200123154526.GC13178@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c8371569-78f5-24bc-d4c0-2c7f8f3c1f14@redhat.com>
Date:   Thu, 23 Jan 2020 17:16:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200123154526.GC13178@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/20 16:45, Sean Christopherson wrote:
> cc'ing KVM and LKML this time...
> 
> Why does KVM use the atomic load/store lists to load MSR_IA32_UMWAIT_CONTROL
> on VM-Enter/VM-Exit?  Unless the host kernel is doing UWMAIT, which it
> really shouldn't and AFAICT doesn't, isn't it better to use the shared MSR
> mechanism to load the host value only when returning to userspace, and
> reload the guest value on demand?

Just laziness I guess.

Paolo

