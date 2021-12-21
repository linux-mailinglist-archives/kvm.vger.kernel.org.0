Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7ADC47C2DC
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 16:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239371AbhLUPev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 10:34:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51384 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239376AbhLUPeu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Dec 2021 10:34:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640100890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VLiQ3KqxHj8McNXMPKcVRblNYX80dTIcLn8t7hvXc64=;
        b=IWr7OEP9zd2ZET1cy05o3aTueGT97go/7Brxc9U8IqZ2YErMYOFgPU3Q15gnRPCx6+kuyN
        PAZsPpzKZFdscyFp33ZKGoF8s+IjzCkZCy+6wEmaiAxRrpBJL/TaQH1ORzAbbSAkl4groE
        AwUEvDAN92yZRGJ4phr7FZ7PR+O6m+g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-g5neOgFgNB6GqRL8MNKWuQ-1; Tue, 21 Dec 2021 10:34:48 -0500
X-MC-Unique: g5neOgFgNB6GqRL8MNKWuQ-1
Received: by mail-wr1-f70.google.com with SMTP id a11-20020adffb8b000000b001a0b0f4afe9so4801728wrr.13
        for <kvm@vger.kernel.org>; Tue, 21 Dec 2021 07:34:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VLiQ3KqxHj8McNXMPKcVRblNYX80dTIcLn8t7hvXc64=;
        b=f1SikRHz1NF/czQnNWIaYje1m37MyjZEcQljlqOZ2yDcOXxZZ3d8AcJY6Tei8mqvbo
         7FbAqeHL68JMVS3mjXRTyPWSn/E1FrdTFCuy4xKfkgpg6F+WUljt+OkRpLzd91VXyeTb
         /NwhzGOQAFzFoDHy7Of3B0TeRDxgI2VfdhPdKzbWiKnUr7E5XJ+JObX50Ew4aNDLQvVu
         4p7Xr+lVfqxD8Bc+g3M3eWHb+oLQPvwqMErC3QxRY+dOgz4rm1KM5xfjSZYWpTVkpCCx
         vaiBBFuMrj/CGekxzcUvE2FpkIKniaRl9hQwLDB0X76XAvLOa8NXFr5l14QqPKsur/iF
         oBdQ==
X-Gm-Message-State: AOAM5332UTrZS11UgGAg1xD+trWjJm441a3owFnoFNCeIR7y76fTToi5
        eCgFlF5HDYB4bbxbwEn8sMZWPSXvfafTiqgrgK7qEYQJ3/YzFuOZYm1jsUwxDNOexL4ClHZzESE
        lVi5NzaOTt0l9
X-Received: by 2002:adf:ed82:: with SMTP id c2mr3112509wro.183.1640100887639;
        Tue, 21 Dec 2021 07:34:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxJqpw8uIY10QqnXbQKRyOqFEzE0cFhwUq+ORGFcE2RieR7pChtQQCtO0IR/u0f07CF0OUrxQ==
X-Received: by 2002:adf:ed82:: with SMTP id c2mr3112498wro.183.1640100887461;
        Tue, 21 Dec 2021 07:34:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id q8sm6576181wrx.59.2021.12.21.07.34.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 07:34:46 -0800 (PST)
Message-ID: <38678f18-80eb-414b-4e98-8ed266abb113@redhat.com>
Date:   Tue, 21 Dec 2021 16:34:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: The vcpu won't be wakened for a long time
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Huangzhichao <huangzhichao@huawei.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <73d46f3cc46a499c8e39fdf704b2deaf@huawei.com>
 <YbjWFTtNo9Ap7kDp@google.com> <9e5aef1ae0c141e49c2b1d19692b9295@huawei.com>
 <Ybtea42RxZ9aVzCh@google.com> <8a1a3ac75a6e4acf9bd1ce9779835e1c@huawei.com>
 <YcHyReHoF+qjIVTy@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YcHyReHoF+qjIVTy@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/21/21 16:27, Sean Christopherson wrote:
> 
> Paolo, can the changelog be amended to the below, and maybe even pull the commit
> into 5.16?

Yes, of course.

Paolo

