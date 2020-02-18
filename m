Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF2C162A78
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 17:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgBRQ26 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 11:28:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48495 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726422AbgBRQ26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 11:28:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582043337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6jD6r5vsrK2inpyE/7zQ8fQY+x4uGHuexXAaQdSOZRs=;
        b=P9l3WkLH4jT/TtC9DH1aD7CzWCofhcQRqaGPWaebBwkJIr61OOpXsoN3LB6AG6gUMVkdZW
        jNjbj+++eGXEQSKjbuH2QklVMmolzyCRPAW28U1dJqxsP+ZJ80gnor/FvrnDPznjtTTF1m
        BZqaWUiuNr6B1tVBtG52u6GeaclpaRE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438-iAPQEykaN6aob5T1f60TJw-1; Tue, 18 Feb 2020 11:28:54 -0500
X-MC-Unique: iAPQEykaN6aob5T1f60TJw-1
Received: by mail-wm1-f72.google.com with SMTP id q125so272946wme.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 08:28:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6jD6r5vsrK2inpyE/7zQ8fQY+x4uGHuexXAaQdSOZRs=;
        b=k/TtPFspy/VXulH6BSs6yvbk+1i5SkqxbINidaT51hEsuUnxdm8QoxyOzvOuk7PRNm
         NLbbbpak1YtayYVZ4B6gCq5AH4YN7PnQnwzECrSMd3ZhwLclFBfpOlAkFH+uU+fvnzpb
         7Q7A7oPx0NZdmjnBgWOynXU+S0VPyM0dLDbipIC6LK+w9pG5fVeYkooOJgCDwSidusgr
         FewUqivP1UBFUnbC+Y7xavUcdClo4Csp8xBwTP8znkc7nzyuNN4e2gl0soU+tivKCWzs
         fdT4Jw8RtP+/5/ex1SPZmF6FqNYJYrTMsStoC760G6lmgEWatxT27dX3B5goC7HxyC27
         GBug==
X-Gm-Message-State: APjAAAX5gnrWWbpINrLhwtjyHsf0iz7ghcdDv4/37QbstbIubl8h2XxP
        Wq0ra4kbDdAnMhg4b6rTcHFbnJXCXYELLkzi4MEBE0hZ4k2efTXPJVpHWjc05ubAwSPw106pf9P
        YWOvAYQa0ePLt
X-Received: by 2002:adf:cd92:: with SMTP id q18mr29373115wrj.261.1582043333339;
        Tue, 18 Feb 2020 08:28:53 -0800 (PST)
X-Google-Smtp-Source: APXvYqxh1csn8D9Cr5lablaQwXqDBbOZ14tjlkRUptdOsuUNqh5YSNNequyVCeRecPRnZe+IBXn/+Q==
X-Received: by 2002:adf:cd92:: with SMTP id q18mr29373091wrj.261.1582043333075;
        Tue, 18 Feb 2020 08:28:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id o7sm4001400wmh.11.2020.02.18.08.28.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 08:28:52 -0800 (PST)
Subject: Re: [RFC PATCH 0/3] KVM: x86: honor guest memory type
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Chia-I Wu <olvaffe@gmail.com>, kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>
References: <20200213213036.207625-1-olvaffe@gmail.com>
 <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
 <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com>
 <20200214195229.GF20690@linux.intel.com>
 <CAPaKu7Q4gehyhEgG_Nw=tiZiTh+7A8-uuXq1w4he6knp6NWErQ@mail.gmail.com>
 <CALMp9eRwTxdqxAcobZ7sYbD=F8Kga=jR3kaz-OEYdA9fV0AoKQ@mail.gmail.com>
 <20200214220341.GJ20690@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d3a6fac6-3831-3b8e-09b6-bfff4592f235@redhat.com>
Date:   Tue, 18 Feb 2020 17:28:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200214220341.GJ20690@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/02/20 23:03, Sean Christopherson wrote:
>> On Fri, Feb 14, 2020 at 1:47 PM Chia-I Wu <olvaffe@gmail.com> wrote:
>>> AFAICT, it is currently allowed on ARM (verified) and AMD (not
>>> verified, but svm_get_mt_mask returns 0 which supposedly means the NPT
>>> does not restrict what the guest PAT can do).  This diff would do the
>>> trick for Intel without needing any uapi change:
>> I would be concerned about Intel CPU errata such as SKX40 and SKX59.
> The part KVM cares about, #MC, is already addressed by forcing UC for MMIO.
> The data corruption issue is on the guest kernel to correctly use WC
> and/or non-temporal writes.

What about coherency across live migration?  The userspace process would
use cached accesses, and also a WBINVD could potentially corrupt guest
memory.

Paolo

