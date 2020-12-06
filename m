Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EACFA2D02B0
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 11:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbgLFKTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 05:19:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727652AbgLFKTv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 05:19:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607249905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/WgJlDTyqqD0UA02NymSR8vLhTBhzQGimKmQPRsZt2A=;
        b=ghYjwbCDl2+AZL6Oqe7NirZ6DJx+SXIDZpDJ6au2U7u3PLu57h39ebbP+7k/u0JE/6jYY0
        TNwIaxXxnWaO95PeCc7mvXvoxa1Ihqvm3e+kmvpMBSA0KenOq6tjZGXKT3cicFgIFa/59v
        FF/3hoxWhMvog3BP3yVLdbNz3nIE/to=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-ZejAfKDTNzqtWASO5nNmSQ-1; Sun, 06 Dec 2020 05:18:23 -0500
X-MC-Unique: ZejAfKDTNzqtWASO5nNmSQ-1
Received: by mail-wr1-f70.google.com with SMTP id o4so478268wrw.19
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 02:18:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/WgJlDTyqqD0UA02NymSR8vLhTBhzQGimKmQPRsZt2A=;
        b=ZBGWEMbG/PMCqOdRh0oaNNa5iLYYUV+XXMx3G9EdDceGUijocAhIjnS66TtR6CLbop
         q2bwpv+yaJBJI7zPeUrNTYCnw3/GS2t3H5EgS5Ex0x9tNkc9VWD+niJCstHh4xoMhfM6
         ka1yW2MHJdqpCAqYJJPlqsRSIwzMTkQSjkIsxqpQXFl6jTmwQVM7t+XsqNl0Y8+6h0oc
         7eLnMVH69+ukT3IDpu4QfOsZFY2W82TJgaXtOnlQ8hcEIpDyb77xmbZ0dAcyyi3V/vJq
         l3daVmOdurtPxAu8cT3A59Q7HAorhH0Q4VXH7f5988Jb1bJqNh90N7BTx71HFdZl70iW
         VwPw==
X-Gm-Message-State: AOAM5317vrfzmXmGYM41fSoNsCb15vsZ9kGe75TmX0BammdqyVChgAxL
        LdmZBZUAXtzJle2uOC9Hk7MqlmyLPb0N6nACxSK0YsCJ3hhltIJXIrO/K74DQd9tQOM93xlz7Wi
        2augdk+br2cOf
X-Received: by 2002:a1c:b104:: with SMTP id a4mr12873864wmf.138.1607249902686;
        Sun, 06 Dec 2020 02:18:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwKL28b3RkwPomzNpWHRBxNztsP32mJ0efGXUhURZiiadlEdqgo0yjCDjLRc30KIdsJYk1tZA==
X-Received: by 2002:a1c:b104:: with SMTP id a4mr12873851wmf.138.1607249902507;
        Sun, 06 Dec 2020 02:18:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id y18sm10465741wrr.67.2020.12.06.02.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 02:18:21 -0800 (PST)
Subject: Re: [PATCH v8 18/18] KVM: SVM: Enable SEV live migration feature
 implicitly on Incoming VM(s).
To:     Ashish Kalra <ashish.kalra@amd.com>
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1588711355.git.ashish.kalra@amd.com>
 <a70e7ea40c47116339f968b7d2d2bf120f452c1e.1588711355.git.ashish.kalra@amd.com>
 <7a3e57c5-8a8c-30dc-4414-cd46b201eed3@redhat.com>
 <20201204214656.GC1424@ashkalra_ubuntu_server>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <17551007-bcc9-e772-5318-264287ee8ae9@redhat.com>
Date:   Sun, 6 Dec 2020 11:18:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201204214656.GC1424@ashkalra_ubuntu_server>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/12/20 22:46, Ashish Kalra wrote:
>> I would prefer that userspace does this using KVM_SET_MSR instead.
>
> Ok.
> 
> But, this is for a VM which has already been migrated based on feature
> support on host and guest and host negotation and enablement of the live
> migration support, so i am assuming that a VM which has already been
> migrated can have this support enabled implicitly for further migration.

It's just that it is a unexpected side effect of 
KVM_SET_PAGE_ENC_BITMAP.  I prefer to have it tied to the more obvious 
KVM_SET_MSR ioctl.

Paolo

