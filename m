Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A9210FF00
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 14:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfLCNmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 08:42:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41453 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725939AbfLCNmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 08:42:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575380525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+xzap45JLjeZ78JLpvPgT+gvGDZN08qheFC1tLsQcmU=;
        b=iEtQ8PZey2BIbg2HrqMyqVfZo5/mv8v9cexEly2Xw8TYrc6DBsBnyrx9wZ+d3YNL2O8/DA
        yi6i3vsKsOLNuQFt7sPUCuQrAYxB9wr1qJ2g9f5nhyczfzRzNODTL2u9Rha1lHTy6Vbn40
        /MshvvTv/vmzB0whSqiI7Zptkmz4nK4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-NSxo6xg3OxGJdLEm3aCjIQ-1; Tue, 03 Dec 2019 08:42:02 -0500
Received: by mail-wr1-f71.google.com with SMTP id 90so1796293wrq.6
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 05:42:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+xzap45JLjeZ78JLpvPgT+gvGDZN08qheFC1tLsQcmU=;
        b=hER/hRXogXqp4Xu1ZRgtjJY8ElThH+/9A7T/vfxVKsJvU1zSc5ks7dvjI0ktcssBMU
         JnEdhBpJkMPWaGmSZK9OdBsAF4Rnx+eB+FHKiuv11cgqID0xOhzyCmLhcj3vM0FPxk1f
         cUyu1aJAhVOwJ0UfwngE7PHDAFjvUgmgKoQZAi0tQ334WxMSXjwnngrkUC4pOGqubsGG
         RQGu4rmQrAIEOTRoY4/2XzjH727satyP0erlNMft2jHWAbHg4s8MU5gfZed9M/dkbfxt
         /Vg1D/zqsAiySTy+SGsPMbU4LpSZ3Ssd5PeMx0VzYcamN9Us/zMQs/xbFPd8YMETnc/L
         yXYQ==
X-Gm-Message-State: APjAAAUtJhRuJOF/VTImsidEmh+QBSHpotTVVUIPUiMErRGAJYwCHl6Y
        IZFX02R67vR58Q/jx2FoiAfvF5tbMPw57/7UPBC0/ouVPnzxZj58r3P1mtvD6k/3RC5Zff3/2nj
        cJTfAxKjHXwGu
X-Received: by 2002:a5d:480f:: with SMTP id l15mr5233578wrq.305.1575380520889;
        Tue, 03 Dec 2019 05:42:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqxZGQ0X905/nMt28Wo/glM8NDen/TnIsTfqR7y4USxYbfGbNsMCOfB7UzNevd2TfRXI6WacQg==
X-Received: by 2002:a5d:480f:: with SMTP id l15mr5233557wrq.305.1575380520706;
        Tue, 03 Dec 2019 05:42:00 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a? ([2001:b07:6468:f312:8dc6:5dd5:2c0a:6a9a])
        by smtp.gmail.com with ESMTPSA id w12sm3057323wmi.17.2019.12.03.05.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2019 05:41:59 -0800 (PST)
Subject: Re: [PATCH RFC 03/15] KVM: Add build-time error check on kvm_run size
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-4-peterx@redhat.com>
 <20191202193027.GH4063@linux.intel.com> <20191202205315.GD31681@xz-x1>
 <20191202221949.GD8120@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ee107756-12d2-2de0-bb05-a23616346b6d@redhat.com>
Date:   Tue, 3 Dec 2019 14:41:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191202221949.GD8120@linux.intel.com>
Content-Language: en-US
X-MC-Unique: NSxo6xg3OxGJdLEm3aCjIQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/12/19 23:19, Sean Christopherson wrote:
>>> e.g. in a mostly hypothetical case where the allocation of vcpu->run
>>> were changed to something else.
>> And that's why I added BUILD_BUG_ON right beneath that allocation. :)

It's not exactly beneath it (it's out of the patch context at least).  I
think a comment is not strictly necessary, but a better commit message
is and, since you are at it, I would put the BUILD_BUG_ON *before* the
allocation.  That makes it more obvious that you are checking the
invariant before allocating.

Paolo

