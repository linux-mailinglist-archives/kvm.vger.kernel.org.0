Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F4B275B7B
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 17:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgIWPT6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 11:19:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37018 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbgIWPTz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 11:19:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600874394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VP/uPxlVn+VO8OSs/cXXYD6CRLQQniKKhgRTFTtzIRU=;
        b=VKIB3DwV1U/21bPVwBpVJp1MHd4yJKSeYNBxnTCjfpoMCc4hNaCz7oq0tA3vjt/HnmOSyw
        eDVoLHEyyoJuv13fvViym2s5Gfi6nrpAaPzK368/EiJy4CKYPDlCnMu0m6fBjSAg97kcNG
        Ewr+8SQEgp3Xy5P//41gAfV5cLHfdKQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-mBGbGZs1Ojqf0Kh5FQAlWw-1; Wed, 23 Sep 2020 11:19:50 -0400
X-MC-Unique: mBGbGZs1Ojqf0Kh5FQAlWw-1
Received: by mail-wr1-f70.google.com with SMTP id f18so8961217wrv.19
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 08:19:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VP/uPxlVn+VO8OSs/cXXYD6CRLQQniKKhgRTFTtzIRU=;
        b=WuQ52zRoEdMEXmlfGBu4CkszFXAfKkWHnoGrF1U4Nz0QJfzMekLcwNdvg/geM8DZZV
         Uf7JtlqtLW0FhY9x39fcCNejKPzo2Qx3UuTFpeivv2BqCLDUfwxqVi+UckvX5Zb8koys
         IeHKa5ASd79kmZUY6hIhUCBLsV892+wIxgfXQylVCsErX0DttimKM5J4en2J47+XiXqU
         ihpLK/QkbAJhj34fEI5TOY4cMYm5Vekq0+16nk9yTYfYi2fgr2X720G3LREINbe1rl7J
         pDgEkAr/hlG5TCBaX0Oxzv3uBAVjZCMZhvqJn5Ka091884b3HFqB9Q4J1v8gPgG1j1uT
         aWrg==
X-Gm-Message-State: AOAM533aRyXa4zSunBnNz0j34GDJjnonaDYPeCPTv1NnoFYAGqIh/Q9f
        3gORi7iiAngoprIu7DeZueVTgDGkl2K891iJW7+k/IptVehI/cL5bU1LgFy5X8Wgscd+2XvXH3l
        YB3wi8t/Uh8p3
X-Received: by 2002:a05:600c:22d2:: with SMTP id 18mr25118wmg.145.1600874389035;
        Wed, 23 Sep 2020 08:19:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbgMoWwfq+neyAnsK0EaJ4ibs2pkKiG4LrxWCZ5IbM3u5TcuDmjgY1SOIQ3UTsK1K+EpMxkg==
X-Received: by 2002:a05:600c:22d2:: with SMTP id 18mr25098wmg.145.1600874388795;
        Wed, 23 Sep 2020 08:19:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id c4sm120226wme.27.2020.09.23.08.19.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 08:19:48 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address space
 support user-configurable
To:     Jim Mattson <jmattson@google.com>
Cc:     Mohammed Gamal <mgamal@redhat.com>, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com
References: <20200903141122.72908-1-mgamal@redhat.com>
 <8c7ce8ff-a212-a974-3829-c45eb5335651@redhat.com>
 <CALMp9eTHbhwfdq4Be=XcUG9z82KK8AapQeVmsdH=mGdQ_Yt2ug@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <79277092-a5b8-ebb0-8a9f-e41d094ed05b@redhat.com>
Date:   Wed, 23 Sep 2020 17:19:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTHbhwfdq4Be=XcUG9z82KK8AapQeVmsdH=mGdQ_Yt2ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 16:32, Jim Mattson wrote:
> You don’t buy my argument that this should be per-VM, then? I’d bet that
> we have very close to 0 customers who care about emulating the reserved
> bits properly for 46-but wide VMs, but there may be someone out there
> using shadow paging in a nested kvm. 
> 

I do buy it but I prefer not to have a released version of Linux where
this is enabled by default.  I procrastinated hoping to cobble something
together but I didn't have time.

Paolo

