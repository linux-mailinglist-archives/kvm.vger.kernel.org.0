Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5EA141990
	for <lists+kvm@lfdr.de>; Sat, 18 Jan 2020 21:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgARUUC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 18 Jan 2020 15:20:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26272 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726846AbgARUUC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 18 Jan 2020 15:20:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579378801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G1i9PTd4XYhlFur0DN62XeTXztI9o6pVfaoSTN+IRyc=;
        b=EUytCEFAhLVa9Wa4snMRMjvYj4j3AJHvCFRBib4p8akhqraZFeM+BQC2OQOJ+KHPIfUu6j
        EnJg8l8UzHC/KXehQU4vIwLeH3GGroALLbDaF6mwL8RYP1tQLEUqsMVBB/jQbI7ouerH+e
        jZktp9ggSsnyF4EaEuY7g0PXSPwpzEQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-EZHxvkvSOKy0zqc512xrwg-1; Sat, 18 Jan 2020 15:19:59 -0500
X-MC-Unique: EZHxvkvSOKy0zqc512xrwg-1
Received: by mail-wm1-f69.google.com with SMTP id t4so2963076wmf.2
        for <kvm@vger.kernel.org>; Sat, 18 Jan 2020 12:19:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G1i9PTd4XYhlFur0DN62XeTXztI9o6pVfaoSTN+IRyc=;
        b=gB+AoRLkFWIMn9o3R8dcLpM/C85CtlYKhdd4TdqAOJKYxX/qGnbOlQaHO3Df+4HMh9
         wH3/S63hmtyWDK5Px8vgp1efXWFPx/2X2qt3Y77FcIVV9ya0BvVhlmDu+fzlOBdZz19k
         E1+aweP5hOH7OGIg1N0PBIElnXrBCo+/J+MW6lkO7hd0xZBfrO72wobYGoYfechQxc+S
         YG9n20b4wCgfU6vhDgv2Su06+T3sOYI40B6RCJd57aVuyUYpQJtBKO9V+3zspMCy8qq3
         XBAx5nxv3SiFHrdIGar9t1LfoU+wvXYhfWptoVOlbBYutaLh/rXgvSYauToFRLTUQ/3C
         TjmQ==
X-Gm-Message-State: APjAAAV4vtvF2RhTapHqaBYg6LHdjW1kD6I9PQV9H1IF4QfJ02fmsliT
        PWyhpy28ykcZZo/KdQ5wZ5mkewrwpUddHu6NYjzA3+AzM+NDACtJzrvECafGsBvlsnBIe6lV2VE
        EiVdZhrlDbWdw
X-Received: by 2002:a1c:7205:: with SMTP id n5mr11456215wmc.9.1579378798749;
        Sat, 18 Jan 2020 12:19:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqyX1dUK6hqvCuIrZTcr9szFlDS1cmMGBoBRngZVr8X7aZDqHlS29ojww0W8gwplggf86+90HQ==
X-Received: by 2002:a1c:7205:: with SMTP id n5mr11456209wmc.9.1579378798554;
        Sat, 18 Jan 2020 12:19:58 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e0d6:d2cd:810b:30a9? ([2001:b07:6468:f312:e0d6:d2cd:810b:30a9])
        by smtp.gmail.com with ESMTPSA id h2sm40870251wrv.66.2020.01.18.12.19.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 12:19:58 -0800 (PST)
Subject: Re: [PATCH] KVM: squelch uninitialized variable warning
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Barret Rhoden <brho@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200109195855.17353-1-brho@google.com>
 <20200109220401.GA2682@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ff6df7b3-e3ad-53f3-d71a-cafc3d091c6c@redhat.com>
Date:   Sat, 18 Jan 2020 21:19:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200109220401.GA2682@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/01/20 23:04, Sean Christopherson wrote:
> Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>

Thanks, I queued it so that at least it gets to stable.

Paolo

