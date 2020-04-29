Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35581BD9B5
	for <lists+kvm@lfdr.de>; Wed, 29 Apr 2020 12:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgD2Kfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Apr 2020 06:35:47 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37553 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726355AbgD2Kfr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Apr 2020 06:35:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588156546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7I38cezud3jcFe2VilVY6KvrLd0TQyKG8EvGPUzd8WM=;
        b=QXY6iDIoHpG5KXl6d1lJUu09YpQ788Ucm79JSvHbUTxMMsz1PPIYkm/t/Dm9HUwjB6YLKl
        mPsinsVVmN6OGBm8IUTTU6bu0SIYd1ggS8xyxTYxW1rcbWDMfQGupaO9AfeCgJAeF5DTIj
        42SMWCrBAVppZ0JEBLolHh9UFf/plH0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-TMR0e_YrORuOGAGO9iNxvw-1; Wed, 29 Apr 2020 06:35:44 -0400
X-MC-Unique: TMR0e_YrORuOGAGO9iNxvw-1
Received: by mail-wr1-f69.google.com with SMTP id y10so1513499wrn.5
        for <kvm@vger.kernel.org>; Wed, 29 Apr 2020 03:35:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7I38cezud3jcFe2VilVY6KvrLd0TQyKG8EvGPUzd8WM=;
        b=E2vivw/w8R9fv+dnRKaPkbFlrLOBbshxuIPlI1Bm4xGbnEIOXKLghLvFz6OdUCteiX
         U42R3UboU/30nvsuuLpH1/mbDl0XGHfx0oVSPObW0UmVZobqwSV0jQKkOf2Zi2k4uE6m
         r1msKQhXut6r7jrLwawNRziWO10SgLsD+LJhPyxf4PDDIZyER7xaiPKISsqsL7j8r3Bb
         1tmk0r8/t6HlmrHwiDr++t60RcXfDYLLwVutcht8mJZTVwl7a1CACaF5CAKP3B9O2oKa
         RgVhRQNuAiyqSZjD/zwcENdblBZTBZyLnGAUCShcsnPeqT0SYH7yXuV5NeuvO/7ANAuu
         9xhQ==
X-Gm-Message-State: AGi0PuYFL8gjPhLM2ttmSbhVM4OnzGheT4AxfBSY7hhTHGB5OaPzuVXy
        2LayAfZxI/vrSWsgYKna77XLfqO5NtE8RQ6zMT7PHQcuUJ3iDK1+H/SgUwSlGfWd5mUKxwQ+BWT
        vtPXsTwvlYKJJ
X-Received: by 2002:a7b:c927:: with SMTP id h7mr2478542wml.122.1588156542618;
        Wed, 29 Apr 2020 03:35:42 -0700 (PDT)
X-Google-Smtp-Source: APiQypKhPa4YOpJ3QAu7oJS5CwDm4v5IZPmdcbPvhgtaB3/fsszG5m6vHj7DV+yRiljDbhI57Kjrrw==
X-Received: by 2002:a7b:c927:: with SMTP id h7mr2478525wml.122.1588156542422;
        Wed, 29 Apr 2020 03:35:42 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id h16sm32873454wrw.36.2020.04.29.03.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 03:35:41 -0700 (PDT)
Subject: Re: [RFC PATCH 5/5] kvm_main: replace debugfs with statsfs
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, kvm@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, mst@redhat.com,
        borntraeger@de.ibm.com
References: <20200427141816.16703-1-eesposit@redhat.com>
 <20200427141816.16703-6-eesposit@redhat.com>
 <2bb5bb1d-deb8-d6cd-498b-8948bae6d848@infradead.org>
 <48259504-7644-43cf-45a2-219981e59a49@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9b19a319-1f79-ef06-6aa3-968a6013835f@redhat.com>
Date:   Wed, 29 Apr 2020 12:35:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <48259504-7644-43cf-45a2-219981e59a49@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/20 12:34, Emanuele Giuseppe Esposito wrote:
>>
>>
>> You might want to select STATS_FS here (or depend on it if it is
>> required),
>> or you could provide stubs in <linux/statsfs.h> for the cases of STATS_FS
>> is not set/enabled.
> 
> Currently debugfs is not present in the kvm Kconfig, but implements
> empty stubs as you suggested. I guess it would be a good idea to do the
> same for statsfs.
> 
> Paolo, what do you think?
> 
> Regarding the other suggestions, you are right, I will apply them in v2.

I replied in v2 - basically "imply" STATS_FS here instead of "selecting" it.

Paolo

