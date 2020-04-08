Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3525D1A2B10
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 23:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgDHVZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 17:25:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51730 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728158AbgDHVZw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Apr 2020 17:25:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586381151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UJBpmrLVUaj5bFLbNbY74eKb6lWRZxALhzam3N9grC8=;
        b=ZoXf2i3fP1ci9z4jzb2lv1oi33tvwPOImsAWKFa+622VF2T/VlywwTsHIxB+EmMaVDSFMI
        gCrf9r4qDK5xWoPVPEYED3mH4yI8dHVGag3fA1io2P0szhabBACPkkMVxXH4fm9jPs7lgD
        1IZXJHn4muj+aXtinRdyYGrKA4Rjocw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-L0aDgA1lOfCTwlljVonNpQ-1; Wed, 08 Apr 2020 17:25:49 -0400
X-MC-Unique: L0aDgA1lOfCTwlljVonNpQ-1
Received: by mail-wm1-f72.google.com with SMTP id p18so1072722wmk.9
        for <kvm@vger.kernel.org>; Wed, 08 Apr 2020 14:25:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UJBpmrLVUaj5bFLbNbY74eKb6lWRZxALhzam3N9grC8=;
        b=NHIBtE3umEmiK9XzmlTGwfbUo3Q1HpSpWWC6l7DRk2S9b0mBhFVdaNeZaOyn4JD6RC
         42BO873mpscG4w6otNRXuTHe1BgvzzYx4gc3r3PjdbaFl8l0Yr3LbmDiYGgSzWAnHYbh
         Xdvhv0zWlid1PCSDtpzOg1jMycJEdkIf3oBVk0Qml/jISyuZ7Zfpy7AW27GQizqqyrMH
         NZFkxxXTHoXYxIDq3+U38M0lcpdJMzm1HSw4GDQ1/Rb3V8smgBF8K143BsDYvhFnKPSC
         VEEMcQQre7pStU/wfOnEjBfvXQaNe4cF3HlfcdeQLU1ZDajBai7KRNmpuRpVUF1xADun
         O7Pw==
X-Gm-Message-State: AGi0PuZ68oy/cXcaPxQ3X94L1ULLBn222YQrCDrsHBePtFSnP5SGtntU
        TeQUcosZlFlNoBWk6oTFK93FJQ/JLnnorSCMKfxYHl5OBSlrdRr3qy8s7W4o9jAIZjhB3vci8zX
        IExTnm+AzL90P
X-Received: by 2002:a1c:2705:: with SMTP id n5mr6375970wmn.94.1586381148143;
        Wed, 08 Apr 2020 14:25:48 -0700 (PDT)
X-Google-Smtp-Source: APiQypIEypWtp8IszcU/gyunBrcO7Rg/owcCayhmUqap5hxAkVPpXeNBGcvzCuxiSUBSePrEqghURw==
X-Received: by 2002:a1c:2705:: with SMTP id n5mr6375955wmn.94.1586381147897;
        Wed, 08 Apr 2020 14:25:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9c71:ae6b:ee1c:2d9e? ([2001:b07:6468:f312:9c71:ae6b:ee1c:2d9e])
        by smtp.gmail.com with ESMTPSA id t17sm32671085wrv.53.2020.04.08.14.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 14:25:47 -0700 (PDT)
Subject: Re: KCSAN + KVM = host reset
To:     Qian Cai <cai@lca.pw>, Elver Marco <elver@google.com>
Cc:     "paul E. McKenney" <paulmck@kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
References: <E180B225-BF1E-4153-B399-1DBF8C577A82@lca.pw>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fb39d3d2-063e-b828-af1c-01f91d9be31c@redhat.com>
Date:   Wed, 8 Apr 2020 23:25:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <E180B225-BF1E-4153-B399-1DBF8C577A82@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/20 22:59, Qian Cai wrote:
> Running a simple thing on this AMD host would trigger a reset right away.
> Unselect KCSAN kconfig makes everything work fine (the host would also
> reset If only "echo off > /sys/kernel/debug/kcsan” before running qemu-kvm).

Is this a regression or something you've just started to play with?  (If
anything, the assembly language conversion of the AMD world switch that
is in linux-next could have reduced the likelihood of such a failure,
not increased it).

Paolo

