Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C86279200
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 22:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbgIYUVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 16:21:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728643AbgIYUTi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 16:19:38 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601065176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QOmicvb+v8XFJSVsTFBCH7ova0V2RHuqhzizzi3hBkc=;
        b=DQ5uPjCs9hRN80tacVZXiznZpAQAAOQdR6Agf4funw9TcCEIm3uUPZfiHZ+e9MNFwQ0QzZ
        xBabin3OQ9DrFF+oHKMunajio1u3RQ6yeJ1rnyAGbdlCbo/gY41tVfKht4zGPWg2DHdNg/
        qnvgC6GSOPPiHWJPxkbluUh+rXOoPVI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-JxpCExciOmqDvkkonQoFlA-1; Fri, 25 Sep 2020 16:19:35 -0400
X-MC-Unique: JxpCExciOmqDvkkonQoFlA-1
Received: by mail-wr1-f70.google.com with SMTP id s8so1498812wrb.15
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 13:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QOmicvb+v8XFJSVsTFBCH7ova0V2RHuqhzizzi3hBkc=;
        b=lU4nMWLe9j1F+s9f4pFGBTdGY/+1rHZigpnYW7Oo2xPiUPeh31UuKR02YBHGAsNaW0
         UNMiHjqW2XLlXah7NXlQxMecRviT95GE0pkMofztIuPhF4/WxqUVuPhfKz7RBpU+UCA8
         ChdNNiE2IiDv+cTZ1mPVF/ecbUlBTO6w8k5KJCt9O2Ns+eMala9nf9Y2H6pA3D1SPdio
         Y84891I+TAbTdkjnd1+lkymHso28gU/mwk1dQazPJPvcFUNpd5QlsOO3r/VqbztHoXsI
         ayxb0/zdmSlD+Z2rPJfQyPwuqgtAvl6w+oXyGK1QLzzMSLozz/AVrnNanRkGg+2qBqQC
         yiDQ==
X-Gm-Message-State: AOAM532gQQSh2L17e8bU+fKllrFx9yO7a/Q8USgAWpkZBS4zTPTmHCRl
        Hp/eqWfju6x7I7IDsUjbLCWhn3TohDbq2KVg4ebbkvRb1kzF6HVfLINBeNKJd6AKlcmb0SCwDSF
        9Lqz6XZCZ0KHd
X-Received: by 2002:a05:600c:21c4:: with SMTP id x4mr271967wmj.107.1601065173115;
        Fri, 25 Sep 2020 13:19:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPYpGzkNK39+BACyS8a4wYMnLnXsLxh7emPSJdwO8sV+w4DiZVzAsu8R4Fb7wQ9gZAgqymNQ==
X-Received: by 2002:a05:600c:21c4:: with SMTP id x4mr271957wmj.107.1601065172920;
        Fri, 25 Sep 2020 13:19:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id b188sm159838wmb.2.2020.09.25.13.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 13:19:32 -0700 (PDT)
Subject: Re: Which clocksource does KVM use?
To:     Arnabjyoti Kalita <akalita@cs.stonybrook.edu>, kvm@vger.kernel.org
References: <CAJGDS+FJ1nW8E7f6_4OpbbyNyx9m2pzQA-pRvh3pQgLvdgGbHg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <440273d7-2c10-a433-8250-032a21d5eaf2@redhat.com>
Date:   Fri, 25 Sep 2020 22:19:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAJGDS+FJ1nW8E7f6_4OpbbyNyx9m2pzQA-pRvh3pQgLvdgGbHg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/20 04:36, Arnabjyoti Kalita wrote:
> 
> Does KVM change the clocksource in any way? I expect the clocksource
> to be set at boot time,
> how and why did the clocksource change later? Does KVM not support the
> tsc clocksource ?

The TSC clocksource might fail, in which case Linux will fallback to
HPET.  Using kvmclock (which you have disabled) avoids the fallback.

Paolo

