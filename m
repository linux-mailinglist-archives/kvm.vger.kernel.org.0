Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D81BBFB2
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 03:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503856AbfIXBYb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 21:24:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52710 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391923AbfIXBYa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 21:24:30 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 374F77BDA0
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 01:24:30 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id k9so113004wmb.0
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 18:24:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1Kh47YIewkbENbNlBISmf1v6nAO/ZKvNmZeXMUMYf0k=;
        b=LDjKsjz5zhcJzBbbH8RjpbD/0LhGJPLlLk7tXa3imdf1abGek+M/JgOCFE0TMJiAM6
         brO5BdNM2iAQP9+Lc5X0wTHwuL6G+1mpNxD6vzTHFpXsOiEnTxtykG2EPn4W3Q8EcQac
         sVlIl8jYOmlDZEy+vHXPgUAtL0P0zooFdBmBDPud9Mg+Ewif3MQsdKVwDdHPg+cof3WG
         H5Mh0L94R617tBwZr7y+qDk06FdZDOee5Nja9HmfPv8PLthuTdHLQvBylVgSc0dY+2U6
         OwAYC1H4d9Scegad9/vwLOh03d45eV9/h6d/pfaIYEtGEKzlKIV1werxwe9v0jA1v9Lp
         8jUA==
X-Gm-Message-State: APjAAAU93rOb4p/doynFDSs4I5mfFi8NCufgYPHabEuG7HBL1eEWhNhU
        QR8Nqd9Es7EShCEOznkTsgm9cD4OXHktMusxAigqtwy8iMCr+pyW29NJiIfhe/8DnTl88VG1JIE
        Cy839dnFrOO3U
X-Received: by 2002:adf:c58b:: with SMTP id m11mr138608wrg.252.1569288268894;
        Mon, 23 Sep 2019 18:24:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzRII0EJw95wZVOcvvmB/RtoZVMvjh+6kvorgSFu8xaDuTqYzxLieJS2EkMPfjHfVlYgiaP5A==
X-Received: by 2002:adf:c58b:: with SMTP id m11mr138594wrg.252.1569288268651;
        Mon, 23 Sep 2019 18:24:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id o12sm234071wrm.23.2019.09.23.18.24.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 18:24:28 -0700 (PDT)
Subject: Re: [PATCH 13/17] KVM: monolithic: x86: drop the kvm_pmu_ops
 structure
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-14-aarcange@redhat.com>
 <057fc5f2-7343-943f-ed86-59f1ad5122e5@redhat.com>
 <20190924005152.GA4658@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <aa31edbb-6082-1b95-4d65-059351ac4884@redhat.com>
Date:   Tue, 24 Sep 2019 03:24:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190924005152.GA4658@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/19 02:51, Andrea Arcangeli wrote:
> This was covered in the commit header of patch 2:

Oops, sorry.

> Lot more patches are needed to get rid of kvm_x86_ops entirely because
> there are lots of places checking the actual value of the method
> before making the indirect call. I tried to start that, but then it
> got into potentially heavily rejecting territory, so I thought it was
> simpler to start with what I had, considering from a performance
> standpoint it's optimal already as far as retpolines are concerned.

The performance may be good enough, but the maintainability is bad.
Let's make a list of function pointers that are checked, and function
pointers that are written at init time.

For the former, it should be possible to make them __weak symbols so
that they are NULL if undeclared.  For the latter, module parameters can
be made extern and then you can have checks like kvm_x86_has_...() in
inline functions in a header file.

Paolo
