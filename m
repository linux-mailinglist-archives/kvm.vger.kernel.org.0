Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8419305DFE
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 15:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbhA0OOV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 09:14:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbhA0OLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jan 2021 09:11:38 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BBEC061573;
        Wed, 27 Jan 2021 06:10:58 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id n3so1062387qvf.11;
        Wed, 27 Jan 2021 06:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qR1ztsc0XnYzxWr2oOHJz7bbHSJoFk9Vyu/8scCawyE=;
        b=jJY9ENK+bqbfjVnSzWlZYt78e2AyQ93qnHJUAsPedn8NjOaifnpgzSqbPEFAAgDegm
         aVwn49VJjAb+XAg8nPBuvsacqBPpwmWLPQfOzCfdZ9aquybZ6GfsPMJpYK736rTeGfle
         EVSwSoDjQRYEB1CfMDDkQvZaF0iCMrL9aitm0aRi3JhYBbhSWVbLC+kXlkcubgpv8WrQ
         3ZnOYzC599R5uzlNpyf73COKLQ1ER6apTI9LmMlS9m+boODRHewKIXTiOZtoc7Z7OESH
         elr9ZJh3/xbXKiSoiZYURJzOR/zeq9jANT3nATxDJNm+8Q5EOCtS7lldhhmQT1uQuKW7
         SsbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=qR1ztsc0XnYzxWr2oOHJz7bbHSJoFk9Vyu/8scCawyE=;
        b=OhACjsBJaGU5Y2M1/AOkdZdszab51d+Z1TaH2vTU8GGcziQ14tuiH7b74nmKxdB/hh
         rMd5tbpyzmDKcidkh89NmKq9rYErG2qFdYJz1RR6bTs4gUflXtdOekh+0CfZN/Qwa5wY
         ksMyZtl+nDi1Nsg2NVs2xVGuF18nsAb7ejTC1yBsZ6X4n1UYJku8iZk13B0A6kf5N2cx
         BHVAA7T99uK62RQKWYDaUeDDMbHdAUTyffGx4s2W1yz/7JuVf37e+icm9eYEpJNsxCgf
         F7gLw/NHaYqH5SeBGkjLocbKmBUvH6CFMbHhX1Z/cL9PpYTO0uQKwOh0WAh+VXXX32iW
         2dwg==
X-Gm-Message-State: AOAM530DrUkWD9Ha8UmOySdA/r+Lzi23jrsE9w7HbDe//pO4fptsdwuF
        oXyg5EQTCIniFNTNIT1PkcM=
X-Google-Smtp-Source: ABdhPJx3gHolqCE6LTrL5K3np2KUdMEtHCKJ7u90oHH05uS7Mib+fXYu7McdvhYIQIIRqZM+8zYt/A==
X-Received: by 2002:a0c:b59a:: with SMTP id g26mr10350664qve.26.1611756657277;
        Wed, 27 Jan 2021 06:10:57 -0800 (PST)
Received: from localhost (dhcp-6c-ae-f6-dc-d8-61.cpe.echoes.net. [72.28.8.195])
        by smtp.gmail.com with ESMTPSA id t27sm1342291qtb.20.2021.01.27.06.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 06:10:54 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 27 Jan 2021 09:10:53 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Grimm, Jon" <jon.grimm@amd.com>,
        "Van Tassell, Eric" <eric.vantassell@amd.com>, pbonzini@redhat.com,
        lizefan@huawei.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, corbet@lwn.net, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch v4 1/2] cgroup: svm: Add Encryption ID controller
Message-ID: <YBF0bb7gGkF01VCR@slm.duckdns.org>
References: <YAb//EYCkZ7wnl6D@mtj.duckdns.org>
 <YAfYL7V6E4/P83Mg@google.com>
 <YAhc8khTUc2AFDcd@mtj.duckdns.org>
 <be699d89-1bd8-25ae-fc6f-1e356b768c75@amd.com>
 <YAmj4Q2J9htW2Fe8@mtj.duckdns.org>
 <d11e58ec-4a8f-5b31-063a-b6b45d4ccdc5@amd.com>
 <YAopkDN85GtWAj3a@google.com>
 <1744f6c-551b-8de8-263e-5dac291b7ef@google.com>
 <YBCRIPcJyB2J85XS@slm.duckdns.org>
 <YBC937MFGEEiI63o@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBC937MFGEEiI63o@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On Tue, Jan 26, 2021 at 05:11:59PM -0800, Vipin Sharma wrote:
> Sounds good, we can have a single top level stat file
> 
> misc.stat
>   Shows how many are supported on the host:
>   $ cat misc.stat
>   sev 500
>   sev_es 10
> 
> If total value of some resource is 0 then it will be considered inactive and
> won't show in misc.{stat, current, max}
> 
> We discussed earlier, instead of having "stat" file we should show
> "current" and "capacity" files in the root but I think we can just have stat
> at top showing total resources to keep it consistent with other cgroup
> files.

Let's do misc.capacity and show only the entries which have their resources
initialized.

Thanks.

-- 
tejun
