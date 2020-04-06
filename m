Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 990BA19F157
	for <lists+kvm@lfdr.de>; Mon,  6 Apr 2020 10:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgDFINH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Apr 2020 04:13:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42952 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgDFINH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Apr 2020 04:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586160785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ii26BGJpPDfR08ITd9Ut/Tbr0X9A7oSKJHxrZlNNO0k=;
        b=V9FBHzUDD46leEA+OZVip4GgbOEXtZ2Ybu7dpcyr3gEUiBXD7K/JHoYdN7LFwxqMPb+sUC
        NwTcEZQxD2gSHT5XIBYO9K5L0gXwVJQopRK9zo3LL+3hsm29x+O4F1JVWf+oyyHjpWP9Z2
        Zxffkady8mxdGRmsMhaA2JoTFur7+4s=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-khQiHPRKO9ChHVXkkvrkJw-1; Mon, 06 Apr 2020 04:13:04 -0400
X-MC-Unique: khQiHPRKO9ChHVXkkvrkJw-1
Received: by mail-wm1-f70.google.com with SMTP id p18so4599267wmk.9
        for <kvm@vger.kernel.org>; Mon, 06 Apr 2020 01:13:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ii26BGJpPDfR08ITd9Ut/Tbr0X9A7oSKJHxrZlNNO0k=;
        b=pmQEq7XUhSLB1WebdMSnX0JK0Xewp0TvDzty+kyu7576u6BXglwpEv6yTF/QT7UF5W
         Z6SoKAZqK1TPOz79k/zif97S4TL2sMEg+7NZVycVYWvxcQf0l4FBwy68lHHU4qiAyXbL
         oMt9rEiCngIeippJYuSDD2vrNpmZCNMsVr+CeHUe7NquIfOsMXp/5RMceWmhlYiJ8Kf/
         x/8jrO/o1c8l74x+OhrvJQs3/kWUpl5wi9cBjxpxJCY4NT4hteH1C2CdRa/e6UElz8Qj
         Je+AtONxDv9mH7amBB/VMj8LEpulf5M2KdLCLACotivH7IAZveNjOunv/Cq6eweTQqYT
         Kr2Q==
X-Gm-Message-State: AGi0Pub5VeA16FQ9Wb7fLT0WKXoODhYY5TFACaWj/3rpRCUKByzxvT05
        F0EkhPaIkl9ILq/Ck1u5VUPXpaAkwLZVBftAhHdD2hb2n+uu1HVtdghvJr3ZN5aTey0Zq69xy6k
        mkJRf7hBihmtM
X-Received: by 2002:a7b:c450:: with SMTP id l16mr5741885wmi.123.1586160782942;
        Mon, 06 Apr 2020 01:13:02 -0700 (PDT)
X-Google-Smtp-Source: APiQypKPBBB4LWKtb+olcVrK+i/vs3mSagwriQBtGODlhja7He2RQMneGMb/WFbmwZkety2M04lL2A==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr5741865wmi.123.1586160782633;
        Mon, 06 Apr 2020 01:13:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:80e8:806f:a5f9:88dc? ([2001:b07:6468:f312:80e8:806f:a5f9:88dc])
        by smtp.gmail.com with ESMTPSA id c17sm19979917wrp.28.2020.04.06.01.13.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 01:13:02 -0700 (PDT)
Subject: Re: ata driver loading hang on qemu/kvm intel
To:     Suresh Gumpula <suresh.gumpula@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <7C92AFF4-D479-4F80-8BED-6E9B226DFB72@nutanix.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <56486177-b629-081e-2785-b6e2ca626e88@redhat.com>
Date:   Mon, 6 Apr 2020 10:13:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <7C92AFF4-D479-4F80-8BED-6E9B226DFB72@nutanix.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/04/20 01:36, Suresh Gumpula wrote:
> Hi,
> 
> I am seeing this old problem with qemu 2.12/kernel 4.19.84(intel kvm
> with nesting enabled) and guest kernel 4.10
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1345964
> 
> Could you please advise me on this?  I am seeing the exact same problem
> where the ata driver load was stuck.
> 
> Really appreciate if you could give some pointers?
> 
> Is it a known issue with nesting? Or is this bug fixed in latest kvm module?

Hi, that bug was specific to running under Ravello, not on bare metal.
I have not received any other reports.

To clarify you have:

- QEMU 2.12 and kernel 4.19.x on the host

- kernel 4.10.x on the guest

What QEMU version is running in the guest and what kernel version in the
nested guest?

Paolo

