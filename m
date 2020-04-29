Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927721BD9B1
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 12:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgD2KfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 06:35:02 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22513 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726516AbgD2KfB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 06:35:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588156500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MvG6U9Dx9wY0k8COf5NQcI7j1f22+LOgfSM/YdEK4/U=;
        b=ZdQb9SMMHMG1hg4gPn4aTI1Sj5yksugbdSH1wGk0+Czi5ooRQ+/0SOOzJAUgamiPHFN19/
        M4aWLiJe9Aos0tNYsfVQTKDqWVYhuIhcs4zi3aAcb4KD1EjGdROmlVjCWQTKjFtqE7TTxE
        ANJyX1hO7M47uxWqZQw2Wxn8Lm+bH6k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-2ejoKgHzOJiibvJ0psaPWQ-1; Wed, 29 Apr 2020 06:34:54 -0400
X-MC-Unique: 2ejoKgHzOJiibvJ0psaPWQ-1
Received: by mail-wr1-f70.google.com with SMTP id x15so1530449wrn.0
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 03:34:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MvG6U9Dx9wY0k8COf5NQcI7j1f22+LOgfSM/YdEK4/U=;
        b=oPpXAXeCE/Pxt6zl87I23OW4YuSdup3iPsFP72lWLqMDdQeiB9XfF+8RR3su1yGbbA
         5C7q2VxH+x/gUXL7eVsgigCjXGdg4JsEd4+SBk7WHiYnzER2Dzu2tQXdebymZm3fxXdF
         FnxfnctNvbyLaeSbd0vPL4jX3K8gp/I3SLi37aH+lkhHfTBJiXvLeGO2HNbfcx7JXHxX
         ay8SD6OCV+vN0PberHhRg0FwVdXWb8HFYQ+hiHKUwstARn9BVdF+8o7wXTXWtzvWYkgO
         xw+VqBB+b7Hfdm7s0154onhIYNLxYD5ECE04DySs0GZ0jl1MbnzsxVM4xh4L95tzS5HN
         4Lbg==
X-Gm-Message-State: AGi0PubKKyUFJxgKp+aQdasgq35jbLeMlzVhKv+vW7vchxrMNGISQYsU
        tlgWogFapk9qjn0xJJ3yVZEF9O01tShZTdJOfsx6ySP4vx7LgzpySzpNfwf7vnqAE/5BpT6BhFg
        YRMi6Cpm92fxl
X-Received: by 2002:adf:ea44:: with SMTP id j4mr41471876wrn.38.1588156493398;
        Wed, 29 Apr 2020 03:34:53 -0700 (PDT)
X-Google-Smtp-Source: APiQypKsv04Kl2n9Ejnnl4yI4d1AM613mOCDgy0cvtYoIwAIk6yB89ianzTeiVeeOXFJb7+gpM/E8g==
X-Received: by 2002:adf:ea44:: with SMTP id j4mr41471860wrn.38.1588156493155;
        Wed, 29 Apr 2020 03:34:53 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id v7sm6952037wmg.3.2020.04.29.03.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 03:34:52 -0700 (PDT)
Subject: Re: [RFC PATCH 2/5] statsfs API: create, add and remove statsfs
 sources and values
To:     Randy Dunlap <rdunlap@infradead.org>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mst@redhat.com,
        borntraeger@de.ibm.com
References: <20200427141816.16703-1-eesposit@redhat.com>
 <20200427141816.16703-3-eesposit@redhat.com>
 <229d83bf-1272-587b-233a-d68ad2e11cde@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8c979c8b-be64-a18c-2223-2964cb96d52a@redhat.com>
Date:   Wed, 29 Apr 2020 12:34:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <229d83bf-1272-587b-233a-d68ad2e11cde@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/20 19:47, Randy Dunlap wrote:
>> +config STATS_FS
>> +	bool "Statistics Filesystem"
>> +	default y
> Not default y. We don't enable things that are not required.
> Unless you have a convincing argument otherwise.
> 

I think the best solution is to add stubs to include/linux/statsfs.h,
and use "imply STATS_FS" in KVM.  This would still "default y" when
a subsystem that uses the filesystem is in use, but not otherwise.

Paolo

