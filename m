Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC312744D0
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 16:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgIVO4n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 10:56:43 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56815 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726640AbgIVO4m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 10:56:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600786601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7fQZ3CsVAakZ0XBmAEYMPM13fOqKXxB3YkpyUsuX4ts=;
        b=OkzWxXJBoHyTpaMHl8av9r8I0F5tL/IB4YxMOKNrwQfzCzkzM1MQ+vao74nVcN1AHdubaa
        G/2zMdgGdazF5cRmXLZfIxffNkeyRVp0VocRPVwaZiqP/jNSxH/vBHZ3MAnb7fCQW6QzXZ
        qHemEN9Rcp1KHldR0O+MsPTbCy74nm8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-LTR9aZcWNDepLdMHNL6lng-1; Tue, 22 Sep 2020 10:56:39 -0400
X-MC-Unique: LTR9aZcWNDepLdMHNL6lng-1
Received: by mail-wm1-f72.google.com with SMTP id l15so997765wmh.9
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 07:56:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7fQZ3CsVAakZ0XBmAEYMPM13fOqKXxB3YkpyUsuX4ts=;
        b=gayAiOqyjBMprKhZKnkjbDoYTy39OaFgmV3Jav+LXM+5B885yOdUEC6mbUSQrlfOhv
         fRBmC4DwUFop+LaDvsLu2a3eOXoKmBbuq4LGDSeMVRgnq34Gpkq/SV5yPQjMNMZ1Nf0N
         t2RyVDQMJAEPECPZwCMr0uVSrHt9X9UwHiebWfqtm0RjaU+C+S+PHTtblQUazq50GSP5
         tiZbq32/NGws1V0V+jW66T+xZ3Egc9mABI/4Cm/3HX6yd1qXGrycSpmNiRkwwNGad9PT
         t0hpbj1raMYq6iw+h/+DOdn/GaCJRqtzYI7nZHqoxc7kJs1SuaIia/Upu+XC+zKS0Il6
         MnmA==
X-Gm-Message-State: AOAM530tWUpXj53KlibJl/uIEaTVsBxf2+ve6NbgyhBjkX5259vavkn5
        T+jGVSuIqEnMq2bASqr23NDdv0rdeOYb83Vu6ADJgZPH4O7kkptwvj5ddUnUm006tm6qIkoYhVX
        EdrmteyDENJuB
X-Received: by 2002:adf:e4cc:: with SMTP id v12mr5749638wrm.216.1600786598704;
        Tue, 22 Sep 2020 07:56:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycHG/qyFPrbTWyMA6o+icN09XP4SKvKb2PRcjckpm9cJP8do2/gpvlR9PXbycQsdrOnpPkpg==
X-Received: by 2002:adf:e4cc:: with SMTP id v12mr5749626wrm.216.1600786598464;
        Tue, 22 Sep 2020 07:56:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id k4sm27735243wrx.51.2020.09.22.07.56.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 07:56:37 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Analyze is_guest_mode() in svm_vcpu_run()
To:     Haiwei Li <lihaiwei.kernel@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1600066548-4343-1-git-send-email-wanpengli@tencent.com>
 <b39b1599-9e1e-8ef6-1b97-a4910d9c3784@oracle.com>
 <91baab6a-3007-655a-5c59-6425473d2e33@redhat.com>
 <CAB5KdOaV81ro=F8BiuFfR_OWrY1+AJ4QngSOXOZt7vH_bXPR5A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <66a1479f-9603-5045-c307-804db1a62845@redhat.com>
Date:   Tue, 22 Sep 2020 16:56:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAB5KdOaV81ro=F8BiuFfR_OWrY1+AJ4QngSOXOZt7vH_bXPR5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/20 16:54, Haiwei Li wrote:
>> EXIT_FASTPATH_REENTER_GUEST handling up to vcpu_enter_guest)...
> Hi, Paolo
> 
> I have sent a patch to do this,
> 
> https://lore.kernel.org/kvm/20200915113033.61817-1-lihaiwei.kernel@gmail.com/

Cool, thanks.  I think I'll just squash it in Wanpeng's if you don't mind.

Paolo

