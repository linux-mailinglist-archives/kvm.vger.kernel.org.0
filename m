Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2311B4F5F
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 15:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfIQNgD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 09:36:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34154 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfIQNgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 09:36:03 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3891736899
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 13:36:03 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id v18so1320171wro.16
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 06:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W8/duYKkoF7tT3Nwf9AqtegHE0FbH4LEARfe2FLFDi8=;
        b=DT2Zh2bBedKNJJzHWO/Gd4hjDKbxCAquyZSFeqPH2R01jXkSGSJtX+xDJ0lClKfx97
         tTNSVurXS/M8otQ2U0+0iJxHoTP4S+lP0A9bsJao6bo164eqcbm7vUlCpH8FdtEtC/As
         m9rhITJ0wsJ+NqULX3mTk6/yKgcNaeNhs/vgU/WC9S4MlAXel+67wIbZ3qhAgi5Yg9lb
         PiYp/5PaiY4hBKqp/xjshyl8EkEnJHd05Lsl3zVIZGE0ONFK9PDFYvJwAcXOzHd+gS0A
         HKwiBR3ef1c1OM7svtyzb/XUEnyNsGNYvGL1DwgnjliMb5y3UuBocSCm/nFba7fJVooU
         wVgA==
X-Gm-Message-State: APjAAAX59vp3xqYnX38CJkISLcZQN/aB/IJCRl23cIbrqfZXwU60q/7C
        hlGdkJLAIZCHySrrmE5xrSTnbisiW2bDEg1ortyIp0A8+Eds/qd/1ZUA2VnqVb5c1B1/fHqhzCP
        9Vnbxh4bAtoQI
X-Received: by 2002:a5d:4146:: with SMTP id c6mr3019463wrq.205.1568727361655;
        Tue, 17 Sep 2019 06:36:01 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxAN62VAgfipouZOhh7EnRx4LzxrTTVVjQHYUS1NGNN0rjyxGMA2eVU4wt32+/up1K+NniNdQ==
X-Received: by 2002:a5d:4146:: with SMTP id c6mr3019445wrq.205.1568727361422;
        Tue, 17 Sep 2019 06:36:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id n1sm3858364wrg.67.2019.09.17.06.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 06:36:00 -0700 (PDT)
Subject: Re: 5.2.11+ Regression: > nproc/2 lockups during initramfs
To:     James Harvey <jamespharvey20@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Alex Willamson <alex.williamson@redhat.com>,
        gregkh@linuxfoundation.org
References: <CA+X5Wn4CbU305tDeu4UM=rBEzVyVgf0+YLsx70RtUJMZCFhXXw@mail.gmail.com>
 <20190910183255.GB11151@linux.intel.com>
 <CA+X5Wn4ngf92GEU=9fuxL1FVfPtq9tJE5D5VMBq6gGp5pd4Nkw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f897f18b-9a98-abeb-9caf-cfdca7e66124@redhat.com>
Date:   Tue, 17 Sep 2019 15:36:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn4ngf92GEU=9fuxL1FVfPtq9tJE5D5VMBq6gGp5pd4Nkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/09/19 09:59, James Harvey wrote:
> Yes, confirmed reverting this commit (to restore the originally
> reverted commit) fixes the issue.
> 
> I'm really surprised to have not found similar reports, especially of
> Arch users which had 5.2.11 put into the repos on Aug 29.  Makes me
> wonder if it's reproducible on all hardware using host hyperthreading
> and giving a VM > nproc/2 virtual cpus.
> 
> In the meantime, what should go into distro decisions on whether to
> revert?  Since you mentioned: "Reverting the revert isn't a viable
> solution."

Hi James,

the fix (which turned out to be livelock) is now part of 5.3.  You
should expect it sometime soon in 5.2 stable kernels.

    commit 002c5f73c508f7df5681bda339831c27f3c1aef4
    KVM: x86/mmu: Reintroduce fast invalidate/zap for flushing memslot

Thanks,

Paolo
