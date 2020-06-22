Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD473203892
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 15:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgFVN7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 09:59:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43322 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728293AbgFVN7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 09:59:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592834379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9BiD6ihmh7HVq7Tiy25cLlHRw95ssQel+yhdTLsTGnc=;
        b=JgdaPh72mxfOXt57t9TfnniRVvYpwcfvRZwSsY3YljtC8CQxKLZnDb2gi9/Ffra4LLo5xm
        SwMbYlfOOfIOLWz2k9lESJcWigZ21xo9F4cdgjFUHdfo2/Q1SZIAmFHLabGtRD8adSXEVr
        aZRnFQ+kiJ8hsGXIFTZnXovG6jxOczE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-_MJcsgpSMQaBoOupqbJK_w-1; Mon, 22 Jun 2020 09:59:35 -0400
X-MC-Unique: _MJcsgpSMQaBoOupqbJK_w-1
Received: by mail-wm1-f69.google.com with SMTP id h6so6830115wmb.7
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 06:59:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9BiD6ihmh7HVq7Tiy25cLlHRw95ssQel+yhdTLsTGnc=;
        b=YPM8M8wtwbIvN4RReFli5tQLH3C+pCQFNKL6vUWh922lyj1osBUrpZRFbZnHuG2Amn
         TO5pYeuCgVWTx6x7oj519K+Zyvc2OvP1cb/ctVKy57RTGQtOpyKheRc+feZlAYhyarej
         UFDSsiFMxZ1y5FWaaU59aaDRwsqkKyR41OHrAU69dUNFHLbEJ1wiIlDxIg9Ofn504e8O
         dmy+76DiwoHXNccHX7HoYjLBhGaTHN8cJx7WRXptrSKJUWw/2yfoOpaleWNkwiuQ3uAY
         q63qBbyGani4FwXlPG0XriAh6Qadbdix5+fgaN5bTDmZTyTNQCRukpm7/+G0AMgkJ1Uk
         0+Zw==
X-Gm-Message-State: AOAM5327mIbTH4Cm5Db5St7BWlWWy1xUzJ8cI7fVGdtUS1RQOyyLhhEu
        mLDl3EgL5JBbdWnvkYz/1k5H4e79g6GGI5vNaNiRTVQlGUw3WuXiuC9igDqxQZ1r7UWYQUlBIQu
        G+DE3GD9X0omB
X-Received: by 2002:a7b:c3d0:: with SMTP id t16mr17426971wmj.117.1592834374527;
        Mon, 22 Jun 2020 06:59:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwoHWAXVPnmQ2lx7J2D9yV+2Ef5HKSVoghEAvuK4wS3g6BluFTOcizo7KQ7ZvTw807VajZdlQ==
X-Received: by 2002:a7b:c3d0:: with SMTP id t16mr17426950wmj.117.1592834374293;
        Mon, 22 Jun 2020 06:59:34 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1? ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id p13sm7832535wrn.0.2020.06.22.06.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 06:59:33 -0700 (PDT)
Subject: Re: CFP: KVM Forum 2020 virtual experience
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm-forum-2020-pc@redhat.com
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        KVM list <kvm@vger.kernel.org>
References: <a1d960aa-c1a0-ff95-68a8-6e471028fe1e@redhat.com>
 <391a9edc-57e3-75a8-c762-d1606fefb4ae@redhat.com>
 <20200617190531.GL26818@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cb0b5cde-283a-e8b5-1879-170ed3f6ddb4@redhat.com>
Date:   Mon, 22 Jun 2020 15:59:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200617190531.GL26818@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/06/20 21:05, Sean Christopherson wrote:
> On Wed, Jun 17, 2020 at 05:09:31PM +0200, Paolo Bonzini wrote:
>> In order to allow everyone to present at KVM Forum, including people
>> who might not have been able to travel to Dublin, we are extending the
>> submission deadline for presentations for 6 more weeks!
>>
>> * CFP Closes: Sunday, August 2 at 11:59 PM PST
> 
> Blasting the lists as I'm guessing I'm not alone in having a topic whose
> status could change substantially in the next 6 weeks...
> 
> What is the recommended course of action for people that would like to edit
> an already-submitted proposal?  I don't see any way to edit or delete via
> the web interface.

You can contact the mailing list again (closer to the deadline, as we'd
forget otherwise :)).

Paolo

