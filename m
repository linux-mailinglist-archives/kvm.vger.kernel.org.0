Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC965304737
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 19:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389976AbhAZRHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 12:07:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405924AbhAZQel (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 11:34:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611678795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ha4U7ceCG4iR97RxFf530wLIfNGvWAF4SbfMNImTvaE=;
        b=Kg78ZG9r2mZ9Rz66G+aMT47boRY9FSXHiF5+B74tZLh5r182Reu5zRWL8x3hlQJ84ujZay
        qkynQ/3tbb7asVnQpusOkL4UNc8/YTUp6wm+J5ws/u51ma5RpuGuh/CFM8whGK+GHaXQsg
        g2bTQE3iVUtdY6vqfu+k9PHcKBBv7M0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-3CFaEvKUMSSi4dqrC7Jjsw-1; Tue, 26 Jan 2021 11:33:12 -0500
X-MC-Unique: 3CFaEvKUMSSi4dqrC7Jjsw-1
Received: by mail-ed1-f71.google.com with SMTP id j12so9612209edq.10
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 08:33:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ha4U7ceCG4iR97RxFf530wLIfNGvWAF4SbfMNImTvaE=;
        b=O0f+Cb/537HmCUFzxgA56L7uXyf6GK1ARxLeiJHnaAJokVUKqcq38MxUN21eKcD498
         QP8qkKmptz2OTkN1qvYfVhc+fcK+q4cfdL97xQcX4y76FKugVPoT0+7rxGEvojjcGj5k
         wOrwCZIfc4pUQHXyKeTVzNE/o0kIuX+AKrAa+go50r1E9apmAz4WbWS2qcMYF3DUDivN
         cxutALsSYMbDBzXF37yfqDqNJQULigrWZq0S5sdF9Lhj/JTy1kINMlOu8ZEChirkZ4CC
         V1T1OIuPsqT0mCmNATC4g6RkR5tTMw/HluW98w8syXq7uts1ZZY7pMNj0CoBCji1yALH
         uakA==
X-Gm-Message-State: AOAM532/pRCV+MDHjWli6u1rvHIQ8ktBaUl915O86pq6mLz/Zk653j16
        MG5jLt+0913EEKY6RJpM+i2vTuegJOdVCKsOVSNG4soi1kL2CRexoT5ipYkxydd7R0IRcHJeQCc
        IqZt677ovP24E
X-Received: by 2002:a17:906:f144:: with SMTP id gw4mr4017982ejb.189.1611678791276;
        Tue, 26 Jan 2021 08:33:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxYxTqPIIM498wLg5agu1FCqlafY+yJQ8sBaBGPpRrIuslguN5AKilUcZJMZgnY2TjYm0Utog==
X-Received: by 2002:a17:906:f144:: with SMTP id gw4mr4017972ejb.189.1611678791138;
        Tue, 26 Jan 2021 08:33:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id w17sm10029141ejk.124.2021.01.26.08.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 08:33:10 -0800 (PST)
Subject: Re: [RESEND PATCH 2/2] KVM: X86: Expose bus lock debug exception to
 guest
To:     kernel test robot <lkp@intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kbuild-all@lists.01.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210108064924.1677-3-chenyi.qiang@intel.com>
 <202101090218.oqYcWXa4-lkp@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cfc345ea-980d-821d-f3a6-cea1f8e7ba03@redhat.com>
Date:   Tue, 26 Jan 2021 17:33:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <202101090218.oqYcWXa4-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01/21 19:16, kernel test robot wrote:
> Hi Chenyi,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on kvm/linux-next]
> [also build test ERROR on v5.11-rc2 next-20210108]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]

What is the status of the patch to introduce X86_FEATURE_BUS_LOCK_DETECT 
(I saw 
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg2389369.html)?

Paolo

