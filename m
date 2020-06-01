Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E18C1E9F37
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 09:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgFAH2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 03:28:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27583 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725972AbgFAH2M (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jun 2020 03:28:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590996491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rBGnBe9nAKzVkNp1oiiFdwiEMaoCXpO5GvmbNaHYZEA=;
        b=TPAb6mEogHV8+LfFHYuWbjNvmV9d4ksqqjyF1uNY6Vc+nYTCls6/ZxjkZrxTxca6Grc45h
        /D4ghTlq4i6YJTziyMKZX+yJ9t3hDXFST8D2MzGWBdLl7mBiCEAd3xL3Clmud5H7IGYpOa
        bsPAUxMqb+vg2RZydnu3zkZTrOIJAJA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-tvXL1-sSOhqxFpD14I1gjA-1; Mon, 01 Jun 2020 03:28:09 -0400
X-MC-Unique: tvXL1-sSOhqxFpD14I1gjA-1
Received: by mail-wm1-f71.google.com with SMTP id l26so2346616wmh.3
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 00:28:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rBGnBe9nAKzVkNp1oiiFdwiEMaoCXpO5GvmbNaHYZEA=;
        b=OGoNhX2SHl6FuXagivMtG7VmQLl9cCxp7NdW8P2T/Ckc7Ez+9gt7SzNdHYRdOb65jV
         ydQelbKkXlW9b5SU+i0fWyhv2JENgmA+1h5/mk49RbwBpeOSAFY4g4nugp4ohLoWlg4H
         jJCaTNNeIzNke4sOPDn7M8Ik30q6Eic4+hmneLuTnMYhFbaZt5JF0KJJM7P2F+RQqwd6
         co73FNV7s40T0JSImovBZba3SWWe6cWD/GokA67JycAXmhRG0uunYQSlsTLhT2DRO5IY
         /QRGoAcFa7nFcs2BX3OM4RRyzEAuOOZEKLPu5mkUQej0WKghwI7wi6dhrrDUGQazDWYz
         Pjpw==
X-Gm-Message-State: AOAM533abwKYF7SGA4OsL2uhnE64c4Z+7ntwQkg10F3QPpkQbNtGqO9E
        skXNYZOaFkg098UJntoVO8V3ETSgewgLfNx+e5YZyAp7rhCi0j/qPdlsSczQ+gVLnDqRmz4AmcC
        cWp6Qc/meKpq1
X-Received: by 2002:a05:600c:1:: with SMTP id g1mr19913784wmc.142.1590996488357;
        Mon, 01 Jun 2020 00:28:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxyQPU8guSVwXTyixwCAix1YqbDNU3KwWv/HjBxt0m9SQOj/RtfZn4b9HR9UnvFILpXKqx3og==
X-Received: by 2002:a05:600c:1:: with SMTP id g1mr19913773wmc.142.1590996488118;
        Mon, 01 Jun 2020 00:28:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e044:3d2:1991:920c? ([2001:b07:6468:f312:e044:3d2:1991:920c])
        by smtp.gmail.com with ESMTPSA id i74sm19645977wri.49.2020.06.01.00.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 00:28:07 -0700 (PDT)
Subject: Re: [PATCH 25/30] KVM: nSVM: leave guest mode when clearing EFER.SVME
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200529153934.11694-1-pbonzini@redhat.com>
 <20200529153934.11694-26-pbonzini@redhat.com>
 <da854e9e-b305-b938-68f6-995bcc80ffd1@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9319ccf9-c318-40e8-7d56-df0e32617430@redhat.com>
Date:   Mon, 1 Jun 2020 09:28:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <da854e9e-b305-b938-68f6-995bcc80ffd1@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/06/20 04:26, Krish Sadhukhan wrote:
> On 5/29/20 8:39 AM, Paolo Bonzini wrote:
>> According to the AMD manual, the effect of turning off EFER.SVME while a
>> guest is running is undefined.  We make it leave guest mode immediately,
>> similar to the effect of clearing the VMX bit in MSR_IA32_FEAT_CTL.
> 
> I see that svm_set_efer() is called in enter_svm_guest_mode() and
> nested_svm_vmexit(). In the VMRUN path, we have already checked
> EFER.SVME in nested_vmcb_checks(). So if it was not set, we wouldn't
> come to enter_svm_guest_mode(). Your fix is only for the #VMEXIT path
> then ?

No, it's for KVM_SET_MSR.

Paolo

