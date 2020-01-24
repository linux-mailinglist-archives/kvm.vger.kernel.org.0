Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD65E1479DF
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 09:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgAXI6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 03:58:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46533 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726294AbgAXI6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 03:58:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579856312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JWz6aqGdHx35tZOwvGlucXWByVJJ94BypUpYqdf0YTw=;
        b=duDiNRBf3n8ySGaO3KOap+FBRXDv8N2Y1/Bmg+ZIjjaHeAYseb04wVvjv0YVbj2f6YO2QW
        AA0vOefuRcopssDx6pVYuYHnLU8haOyxzgt9vE1sIhXXWlnO/8swux29JiDoJ213o1IlSs
        oWaFJK0ShqrA6XXPOoSwMQh+eZ6My4g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-NztReLbiPkKpgkRwl95pYA-1; Fri, 24 Jan 2020 03:58:30 -0500
X-MC-Unique: NztReLbiPkKpgkRwl95pYA-1
Received: by mail-wr1-f69.google.com with SMTP id i9so854020wru.1
        for <kvm@vger.kernel.org>; Fri, 24 Jan 2020 00:58:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JWz6aqGdHx35tZOwvGlucXWByVJJ94BypUpYqdf0YTw=;
        b=PXI48KxoCvQBiA+LULAoY3qQU6jcZZwpvMXmPf8ZXJVSfc8noV3q1dnXjfd4WGuO2f
         Sem5gGaHCJNdPmDFcJyC6H56aryRPdh+/BnvCs8CUBsdOriSIdI4XiW5MzO0Fq+J5WZk
         h2JmG3IQfbruLr0wRoN7dOgO+InRo098vNJ/2jSwGDqng+v/D4SrJEqV7L/ypMjGwvU2
         ZGlxllieklTdj0em4wr4taESTtqB6p6TsDRyHVtBn3xu5lVJNKwTnxRY9sWBItN+m88R
         4dI8tz/BQjytypDh2xd/kdlea5gvX2g3IQHghLr9sVvkkpPNPFW8dRa5fu6ibBP5j3wd
         4s0g==
X-Gm-Message-State: APjAAAX5e4JTvo47JwaD5wM56tVgRJE/vt360t1FZpvt/pL/3Ka1bKo8
        9Nw5ngQ01CkQ5+b7DQDCOEzO/dJm4sJTK2K64GKmmclzNnb06eooNHs9I3vfTZA/eq8iLVVjJAB
        BpYTlS9qIAVqw
X-Received: by 2002:a05:600c:2215:: with SMTP id z21mr2280688wml.55.1579856309503;
        Fri, 24 Jan 2020 00:58:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqwTG/Fx0cb6GxNxRaHqdTQSp/V/QSRYrq3Q3gtSptcEB3HrPrpH3UPGtIS+5Ympfmx+cp9+QA==
X-Received: by 2002:a05:600c:2215:: with SMTP id z21mr2280663wml.55.1579856309137;
        Fri, 24 Jan 2020 00:58:29 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b8fe:679e:87eb:c059? ([2001:b07:6468:f312:b8fe:679e:87eb:c059])
        by smtp.gmail.com with ESMTPSA id c5sm6219331wmb.9.2020.01.24.00.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2020 00:58:28 -0800 (PST)
Subject: Re: [PATCH v4 09/10] KVM: selftests: Stop memslot creation in KVM
 internal memslot region
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Cannon Matthews <cannonmatthews@google.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
References: <20200123180436.99487-1-bgardon@google.com>
 <20200123180436.99487-10-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <92042648-e43a-d996-dc38-aded106b976b@redhat.com>
Date:   Fri, 24 Jan 2020 09:58:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200123180436.99487-10-bgardon@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/01/20 19:04, Ben Gardon wrote:
> KVM creates internal memslots covering the region between 3G and 4G in
> the guest physical address space, when the first vCPU is created.
> Mapping this region before creation of the first vCPU causes vCPU
> creation to fail. Prohibit tests from creating such a memslot and fail
> with a helpful warning when they try to.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---

The internal memslots are much higher than this (0xfffbc000 and
0xfee00000).  I'm changing the patch to block 0xfe0000000 and above,
otherwise it breaks vmx_dirty_log_test.

Paolo

