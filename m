Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EC227C07E
	for <lists+kvm@lfdr.de>; Tue, 29 Sep 2020 11:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgI2JGS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Sep 2020 05:06:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41256 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727755AbgI2JGR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 29 Sep 2020 05:06:17 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601370376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7VZXTY8b3ZdFPcHBYXEmDltOAxM7aE4eFQlRLkb/HNo=;
        b=RNNGsD1JxHDs01GWSM+UVLxA0DXtXONhWZd1hrN+tNijP6ue6Vtq6c5lSpgqEq93/DVZpY
        JSSHAzpnpJ52TaJM4mf4m1GLNMW7RSOOKzWvRIOdl5XRyYWGdm+sn3FMPDYXWD/lST9WKn
        oQBQoF8AwDAALjouZmfNMobShmuK3x0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-Dp3UBZB5PZm6YDWkaMcfEg-1; Tue, 29 Sep 2020 05:06:12 -0400
X-MC-Unique: Dp3UBZB5PZm6YDWkaMcfEg-1
Received: by mail-wm1-f71.google.com with SMTP id a7so1574194wmc.2
        for <kvm@vger.kernel.org>; Tue, 29 Sep 2020 02:06:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7VZXTY8b3ZdFPcHBYXEmDltOAxM7aE4eFQlRLkb/HNo=;
        b=KfQC+H71aCnMZe9MzQTso0qrLtmvSng8vfBAQb+Ue/v7dGNQLVjggk1hPRp39IZNZ2
         6j571EpTVbP5WZGok+B7vza6RkspGHHN+ASW/FtZOpEYBH5JIn2RHD0YCrDBKz0qW/vB
         YrPTubtNK5vy260ayGVkAlWTeXeWCxHaJ+VW9cGfKHJkaOiUK+ax5THScEi1UDyUsMty
         HyHB3/9o4flTlW25UrZ8xhnBIBXFQoDImlnD3QRJeIPQoxWWShlZgD4vYjzLT1eGBoox
         rXn+lbENoLgzMT8CbDzyr79Cy2nO4UXlvlmQJXEIWJYdQXI39yxeXQoU0qbTDlEBIopA
         nbsw==
X-Gm-Message-State: AOAM532i9x6VZ/OHpm3eXWQQzAhMxQmVoMsx8mO/7Sf2TjriwbMO/28X
        eZXYAV94ZDDyMIeCcdRwhOoSzp2Ff6J3I01iOVmGWJGaIf4ejNL95h6od1I1sAPdWuf0M6exT62
        trRilFwQ3dKek
X-Received: by 2002:a7b:c24b:: with SMTP id b11mr3601641wmj.134.1601370371249;
        Tue, 29 Sep 2020 02:06:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0y/WKLG/yRgOUq3fx5IMArx25yez0jLVmivINug6LHigN4Gux9DdeD0bBEs55V6u3jWxNqA==
X-Received: by 2002:a7b:c24b:: with SMTP id b11mr3601615wmj.134.1601370371053;
        Tue, 29 Sep 2020 02:06:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9dbe:2c91:3d1b:58c6? ([2001:b07:6468:f312:9dbe:2c91:3d1b:58c6])
        by smtp.gmail.com with ESMTPSA id 11sm4321588wmi.14.2020.09.29.02.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2020 02:06:10 -0700 (PDT)
Subject: Re: [kvm-unit-tests PULL 00/11] s390x and generic script updates
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
References: <20200928174958.26690-1-thuth@redhat.com>
 <fa187ed1-0e02-62e5-ba27-4f64782b3cfd@redhat.com>
 <b143b9d8-6c5f-b850-ba96-34b9bb337d22@linux.ibm.com>
 <7cc4071f-60da-7699-685e-b108c58dff79@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fb246fac-019e-407d-fe9f-d5ba016893f0@redhat.com>
Date:   Tue, 29 Sep 2020 11:06:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <7cc4071f-60da-7699-685e-b108c58dff79@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/09/20 10:58, Thomas Huth wrote:
>> Hrm, that would force everyone to use Gitlab and I see some value in
>> having pull request mails on the lists. You just opened the Pandora's
>> box of discussions :-)

That was the point. :)  It was more to see opinions and alternative
ideas than to seriously propose it.

>> If it's easier for you I'd be open to open a marge request and send out
>> pull mails at the same time so people can comment without login to Gitlab.
>
> ... or maybe the people who already have a gitlab account could simply
> include the URL to their CI run in their pull request cover letter...?

That's a good idea!

Paolo

