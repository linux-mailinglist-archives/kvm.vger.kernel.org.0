Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717DC33CB55
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 03:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhCPCWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 22:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234598AbhCPCWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 22:22:14 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B300C06174A;
        Mon, 15 Mar 2021 19:22:14 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id f12so10669828qtq.4;
        Mon, 15 Mar 2021 19:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x9e1xfobrgux5JmgRy+7168jAO2JUpIpvIQcF6MG83w=;
        b=fjEXsStwnXKCurOKkJhtQkcTA24r1rdYzLOmvw1xvyNUJvtm0b9kg5enio6VXPGHUE
         NeMqy3J9wiHHmkHoTqZlg8I7iJ8StIPtyYL8JawjzLLmbqjI+hrWHfILqO0RxLbwrXLC
         jDWFObZ/zoE4IRnM9FQRyorroXQVsjphNLWMaDMpPHCRxgovQgs4vjPMMOm2o45NtdX/
         nDbk2QOo3c4OaemxRdSTaFDuqla+i33mWKdJznmikwFBiysdhSnwmgzniAXpM9JXIQla
         5KZ3WFUnLvoxEVwfPbWYKAVhnwTfUrDOtfhCPtfNSeuue6NnIU8ZUyDPx7cSZeSy2Yys
         QoHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=x9e1xfobrgux5JmgRy+7168jAO2JUpIpvIQcF6MG83w=;
        b=lDPdi1u0q9ZAJScz9tMMgPtZeDcDGKI2S0Q1C2cfHclROM7NeMEh4XLAYiJI6Oxtgm
         IRP0L+ign0Lh/9rrqxBxX8abGIIHfJ1Q6DKG9Z1y+myQaTCTOvLedhwfokZr3iLzpTki
         oCa8kNFDck4GAAAjKa+4lA06lEr/nE8xl2P2UEb+WQNmFExjrOhSi2ftFCokHBaL0Wiv
         XYDmbuEVV0vndZUNGnmPXNiPxLExwmyrStKHsbVnQH15BGzBIuud8/QBMYH/LrCWT4IP
         ODG1AjPQQ3zqE1X4JTHSP7v/poudXap6176i1p1MClkIPxTABh543Q4uBqwyvZ7+QrxF
         pCzg==
X-Gm-Message-State: AOAM531IIHuV5ntH7yqVE87BaEZAkboCOuoddFImHwnjrLnaDu2a319M
        zKloiQ72TfL+pZHYrvJUFvg=
X-Google-Smtp-Source: ABdhPJypiW/tANwk38POGxmJ+LQPrOrcn8PHYpIhP6vANCuOFNC24G9bMIqsJ6tcQiCBdmqOkqI3LA==
X-Received: by 2002:a05:622a:48d:: with SMTP id p13mr21363305qtx.21.1615861333631;
        Mon, 15 Mar 2021 19:22:13 -0700 (PDT)
Received: from localhost (2603-7000-9602-8233-06d4-c4ff-fe48-9d05.res6.spectrum.com. [2603:7000:9602:8233:6d4:c4ff:fe48:9d05])
        by smtp.gmail.com with ESMTPSA id d14sm13657503qkg.33.2021.03.15.19.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 19:22:13 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 15 Mar 2021 22:22:12 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Jacob Pan <jacob.jun.pan@intel.com>
Cc:     Vipin Sharma <vipinsh@google.com>, mkoutny@suse.com,
        rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>
Subject: Re: [RFC v2 2/2] cgroup: sev: Miscellaneous cgroup documentation.
Message-ID: <YFAWVJrM86FB17Lk@slm.duckdns.org>
References: <YEvZ4muXqiSScQ8i@google.com>
 <20210312145904.4071a9d6@jacob-builder>
 <YEyR9181Qgzt+Ps9@mtj.duckdns.org>
 <20210313085701.1fd16a39@jacob-builder>
 <YEz+8HbfkbGgG5Tm@mtj.duckdns.org>
 <20210315151155.383a7e6e@jacob-builder>
 <YE/ddx5+ToNsgUF0@slm.duckdns.org>
 <20210315164012.4adeabe8@jacob-builder>
 <YE/zvLkL1vM8/Cdm@slm.duckdns.org>
 <20210315183030.5b15aea3@jacob-builder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315183030.5b15aea3@jacob-builder>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 15, 2021 at 06:30:30PM -0700, Jacob Pan wrote:
> I don't know if this is required. I thought utilities such as cgclassify
> need to be supported.
> " cgclassify - move running task(s) to given cgroups "
> If no such use case, I am fine with dropping the migration support. Just
> enforce limit on allocations.

Yeah, that's what all other controllers do. Please read the in-tree cgroup2
doc.

Thanks.

-- 
tejun
