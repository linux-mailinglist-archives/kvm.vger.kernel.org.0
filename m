Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB6ACB4F0
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 09:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbfJDHWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 03:22:47 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29894 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729557AbfJDHWq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Oct 2019 03:22:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570173766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=ZZFTUGEUKAOtLqz6071gHP1dbpBLVQ8hfKF55tUq/KQ=;
        b=funJjRVyYRVsPeecPx+LteZLFikzB28LraD+uyKtq+0T9HtfwS9kZLW4dNLYFnuqu008Xs
        LWv6s5AaRrSnv2zsilC3XPlfspC8eXvTzcSgO3eSsGg6mloJFsrHcebE2S3q1PGgUUIt3z
        ou5dCl1eU72uj7z2jJbhDth5HRIfilk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-294--KGtfOQWPiKYK3lxrfEUig-1; Fri, 04 Oct 2019 03:22:44 -0400
Received: by mail-wr1-f70.google.com with SMTP id m14so2282108wru.17
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 00:22:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ILNTMth44lhyhVxp81yLHyMCFOzyjpLW4hR5n2e7NXY=;
        b=VhAOqVMeVBc9sub0xyvrUFfnTYNQK0AbKSriE95srCCNbbpVj4npoUch162YActHzR
         MbRpVrF++GO2uU3i7P2o5B314iVAeTrAfHPc9wedtEE9pOEZpSSmpRIVzdw3Ammygo5P
         9stwaRGrLttwHOzwKRhrETFqck3l+QHKyQmYnB/RJI2la7njok5z8rATYAm6JzTqGqwI
         lNB71noCylYbxZchdEFHSOyEyT0gxL2vQTcnlAjuXL4jlNhUOTEkMwfEKHbXw86KKC6P
         tqB+pYbWN1Z9BYaFBWiimJ3mvayYODLeKG8ZBUArY61qq6rg1s8jdecktzCq+vCWcVIi
         IEVg==
X-Gm-Message-State: APjAAAXmbsJPmL4PTGOi6XffpnhRW1BI2vJsCuWWq5YNvVpqcuYaSoyV
        68RO9kK72TDBJnwoWadV6/VobYBAx/+9pFY6sN7NrKKtGq0YP/50mONwcVc4wEBsf3nUJzRwC1V
        m9KxjmVfxw8mP
X-Received: by 2002:a5d:63ca:: with SMTP id c10mr10778930wrw.314.1570173763355;
        Fri, 04 Oct 2019 00:22:43 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwEDGvpXlmcBz9oOFWe0DyzE8bVjNOqBDdH/xvILz6ksCyS5v4csWDZufvLcv4gql6PnY37oA==
X-Received: by 2002:a5d:63ca:: with SMTP id c10mr10778904wrw.314.1570173763052;
        Fri, 04 Oct 2019 00:22:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e56d:fbdf:8b79:c79c? ([2001:b07:6468:f312:e56d:fbdf:8b79:c79c])
        by smtp.gmail.com with ESMTPSA id r20sm9288291wrg.61.2019.10.04.00.22.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 00:22:42 -0700 (PDT)
Subject: Re: [RFC PATCH 00/13] XOM for KVM guest userspace
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        luto@kernel.org, peterz@infradead.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <bc025a4f-2128-24ed-e5b7-76802f22cd53@redhat.com>
Date:   Fri, 4 Oct 2019 09:22:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
Content-Language: en-US
X-MC-Unique: -KGtfOQWPiKYK3lxrfEUig-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 23:23, Rick Edgecombe wrote:
> Since software would have previously received a #PF with the RSVD error c=
ode
> set, when the HW encountered any set bits in the region 51 to M, there wa=
s some
> internal discussion on whether this should have a virtual MSR for the OS =
to turn
> it on only if the OS knows it isn't relying on this behavior for bit M. T=
he
> argument against needing an MSR is this blurb from the Intel SDM about re=
served
> bits:
> "Bits reserved in the paging-structure entries are reserved for future
> functionality. Software developers should be aware that such bits may be =
used in
> the future and that a paging-structure entry that causes a page-fault exc=
eption
> on one processor might not do so in the future."
>=20
> So in the current patchset there is no MSR write required for the guest t=
o turn
> on this feature. It will have this behavior whenever qemu is run with
> "-cpu +xo".

I think the part of the manual that you quote is out of date.  Whenever
Intel has "unreserved" bits in the page tables they have done that only
if specific bits in CR4 or EFER or VMCS execution controls are set; this
is a good thing, and I'd really like it to be codified in the SDM.

The only bits for which this does not (and should not) apply are indeed
bits 51:MAXPHYADDR.  But the SDM makes it clear that bits 51:MAXPHYADDR
are reserved, hence "unreserving" bits based on just a QEMU command line
option would be against the specification.  So, please don't do this and
introduce an MSR that enables the feature.

Paolo

