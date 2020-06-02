Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088651EB3A7
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 05:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgFBDJB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 23:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgFBDJB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 23:09:01 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A9AC061A0E
        for <kvm@vger.kernel.org>; Mon,  1 Jun 2020 20:09:01 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b5so1537223pfp.9
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 20:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qZbs1BllaBBL3bnoChDxm8kx95yZyhFFyPL2Vif8b0A=;
        b=WpBSX7iigtBq+c+VsExmv+11JGFPrheA5EKc79brBG6tYeBX/lsoA0Dw1Kko7JF/CF
         pHgy3Q4cOt7HjjNzRiRbE6OO69TBVEExgij7c36X1vaGHQSuwzCxrFSvEY6FhgwisZSs
         WGUU+r9zKsQqU0XPWB+4mwupu418w4HH+hdI2UzOBML4Za6UMFG7L0/GdK/Bo3bQnrbI
         Z1hnl2ZXFbE5PSFGopAVI8DW0wl3po21aAPbb36kHIRyBZfhKhiD6LhS/FKOLiZfQV0K
         vzRC6uAomZ5+cJ9A8h+nM+McUa9vaAYLaTSvnrOQAyJHAWVJvKWgXU4RS8dy0KM/IpEg
         cX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qZbs1BllaBBL3bnoChDxm8kx95yZyhFFyPL2Vif8b0A=;
        b=cyjg/LzsAossd7kAFOzkwYzGW7lQxpfTFwz8HsTZBWlzh9PdvmttA+IJ1dDgNVq7UU
         ZkXPmcAg1XrIHRm2WtecTw3FJkVSFVJLm2uVj7rp1zsplbDg00VUUpNM/ZHHM6ju4d7r
         uWOARYyxOAW/7V21Q+7U1AANCUSxi5ZLbvsyuL71GYK/qEknEqauVExmACjvbPe2+KBM
         Ga2CxxzjMFj3bFeCKUairWkHEjupQQfoW9abHqqYDr4Gg+JUGP1LrVfEClejWXn//phL
         FiEINOwCpJqKNhvX8VknU8iGZ75+hIiS7EA6gaZ6/IvBuHeK6O2rIqiI8GSGNh+SqJmi
         BgbA==
X-Gm-Message-State: AOAM532yJT7qPVrfXt0XX/bzMZaQ8nFVP7Q3M/XlfXItWPgxFXbvvBit
        Eb3gvHkbK/C4cIO5b+U/YMUNGBfkrLA=
X-Google-Smtp-Source: ABdhPJxlkrrVC6n3zDSCXrEolx9lNwAGETXn7CgxWXKz9aWnRwIODQbdZ0GEyorNT0PUHtLswOHj2A==
X-Received: by 2002:aa7:9ae3:: with SMTP id y3mr8777804pfp.224.1591067340702;
        Mon, 01 Jun 2020 20:09:00 -0700 (PDT)
Received: from [192.168.1.11] (174-21-143-238.tukw.qwest.net. [174.21.143.238])
        by smtp.gmail.com with ESMTPSA id m2sm724135pjf.34.2020.06.01.20.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 20:09:00 -0700 (PDT)
Subject: Re: [RFC v2 05/18] target/i386: sev: Partial cleanup to sev_state
 global
To:     David Gibson <david@gibson.dropbear.id.au>, qemu-devel@nongnu.org,
        brijesh.singh@amd.com, frankja@linux.ibm.com, dgilbert@redhat.com,
        pair@us.ibm.com
Cc:     Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-6-david@gibson.dropbear.id.au>
From:   Richard Henderson <richard.henderson@linaro.org>
Message-ID: <5fb496aa-0b67-d287-c39f-cd5d2380986d@linaro.org>
Date:   Mon, 1 Jun 2020 20:08:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521034304.340040-6-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/20/20 8:42 PM, David Gibson wrote:
> The SEV code uses a pretty ugly global to access its internal state.  Now
> that SEVState is embedded in SevGuestState, we can avoid accessing it via
> the global in some cases.  In the remaining cases use a new global
> referencing the containing SevGuestState which will simplify some future
> transformations.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/i386/sev.c | 92 ++++++++++++++++++++++++-----------------------
>  1 file changed, 48 insertions(+), 44 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

