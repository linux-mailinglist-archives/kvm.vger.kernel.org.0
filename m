Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2FC1EBFEE
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 18:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgFBQ0i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 12:26:38 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:59212 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbgFBQ0b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Jun 2020 12:26:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591115190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lxwhO1exzutRwzeUtw6dZLYIa64l9wkIQ9KC8Et54ug=;
        b=V3x+dZb0nvkSqUSMn5AK6OHzVsGJL/uo8W8RivFjcTDnABxqcnEtIDUX6Kp2EkDiz1N863
        A230+5Q/O+2vugK3PyQIiINIBhoyHUGXv3zjUXiGO0DcAkSEWEI8tGTdgWA22mJOXYVhb4
        b+PKYi23GlOZR+NDquAStLaVd86ZgLI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-e8p6Orf1N6-EsHPOZjStlA-1; Tue, 02 Jun 2020 12:26:28 -0400
X-MC-Unique: e8p6Orf1N6-EsHPOZjStlA-1
Received: by mail-wr1-f70.google.com with SMTP id e1so1592753wrm.3
        for <kvm@vger.kernel.org>; Tue, 02 Jun 2020 09:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lxwhO1exzutRwzeUtw6dZLYIa64l9wkIQ9KC8Et54ug=;
        b=RHibc5wYx6etIyMBQALC0jCSQIVBd4JSc2mmvZ99UxjFQhrat/wBa/+X1LCthIOcVx
         ytfvurOW+ZCNAWIX8jX26Sf/RN/C5E92oon+GFBR1twqnH5hyK0JMaPoGXyhi0DLSxGu
         uUMz2L8dPvpGW67xaD2WlZQqdUx0kHdhWTr5qpLng0++KUGdTyMcfA4Uj5mJn3yYhlL2
         jXWC7PWpLwLDAumHntKdFOXr2ThPDGhvb54GJGsmWmGmlW/DO1AAzOVAj778WBg/uWEb
         VXe7C1+p+vJGsOa5NzatNuIbioHRpxg7aHdJ4eQ3Us4BGMbaHN+e7wTRbe5xTdPbGkuf
         ++jg==
X-Gm-Message-State: AOAM530qJKXtb/BS14itGMMgoGFbHkCgbhECeX2dLPnheBf9uFgsj+ic
        EyJk2a9V7sH1KINvk/1cHdrOZ3fCK8tg9BaEG2FoSK1zF/fy47O6OBKb0rFWSrF2oxJIFwKqFd0
        zXq9DD7Npaww+
X-Received: by 2002:adf:b355:: with SMTP id k21mr20202846wrd.76.1591115187449;
        Tue, 02 Jun 2020 09:26:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBnLBOPdE3PHIXiidRK8EYw7wGULW73adAiJNldsEPiDl9iHSw2WfwVqfSXm3HWkszF4QGhA==
X-Received: by 2002:adf:b355:: with SMTP id k21mr20202827wrd.76.1591115187131;
        Tue, 02 Jun 2020 09:26:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a973:d537:5f93:b58? ([2001:b07:6468:f312:a973:d537:5f93:b58])
        by smtp.gmail.com with ESMTPSA id u74sm361365wmu.13.2020.06.02.09.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 09:26:26 -0700 (PDT)
Subject: Re: linux-next: manual merge of the hyperv tree with the kvm tree
To:     Wei Liu <wei.liu@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jon Doron <arilou@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
References: <20200602171802.560d07bc@canb.auug.org.au>
 <20200602135618.5iw6zd2jqzqqcwxm@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <feb8e292-8dff-58ad-0bb2-5006bf475e6b@redhat.com>
Date:   Tue, 2 Jun 2020 18:26:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200602135618.5iw6zd2jqzqqcwxm@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/06/20 15:56, Wei Liu wrote:
>>
>> between commit:
>>
>>   22ad0026d097 ("x86/hyper-v: Add synthetic debugger definitions")
>>
> Paolo
> 
> As far as I can tell you merged that series a few days ago. Do you plan
> to submit it to Linus in this merge window? How do you want to proceed
> to fix the conflict?

Hi, Linus can fix this conflict.

Paolo

