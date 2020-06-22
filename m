Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B95203E37
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 19:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbgFVRoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 13:44:20 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28287 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729811AbgFVRoS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 13:44:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592847857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3TIT5prEwmaCWuk8KLGQpPT8UK9CC3bPeWQCwZBbFMc=;
        b=gILbe73NmG/+jynAHK9BIDAOBgN8hPBC3XHJ5NEdB1r1NjjEIbpSeIQ7mzs/4xVmHp4Ws4
        1J67RzliCaqFpvyvWr50OhQ/0RlXgD0t+2DNOafuvceOkqZqF4yJa6RqE96g9vuvd8Y8kP
        QmxBl2KTd2quF8DkDN+mLQ+VGU6kblA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-4N6x6aWNO6SnMNipoUa96A-1; Mon, 22 Jun 2020 13:44:15 -0400
X-MC-Unique: 4N6x6aWNO6SnMNipoUa96A-1
Received: by mail-wr1-f69.google.com with SMTP id y16so7543881wrr.20
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 10:44:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3TIT5prEwmaCWuk8KLGQpPT8UK9CC3bPeWQCwZBbFMc=;
        b=Es/TT2Zj+lhv5NwcaogOZKBthpEteCYrlrrIYnTH/nw9n81QoUTuf4lw0uxpTuO0ax
         uy10q1eQuMeZiqSyAEICZvXoHLh1JP2RnvJM7dHUg1KGmigCcfTwhbTtxrGnqU7I2V4e
         3FByWLKwcjoz+53zpyfI0oZAV5bxz0WOhXvjKUIXSndMA07d07yloUFD6NoNLACkdORa
         /TJZH73wzBiXQ2zgW2LdZbhaS70Nft69Sdb8ZEMJfCpGXUsLSEgnXMx5RbG1/PKcTf1Q
         UWsm/Ie8xppVWbUpxLWIv3xKZsMUCwbFS/DT10yFLqxaenC2qKIy+vkznfN5MAuCC/2h
         VJUw==
X-Gm-Message-State: AOAM532oLG5zJ39otYzdmlYI6BrRR4iMBFLp5H1MR699eSBGVcgg3cTx
        UpLk+Bze8jXeJ3I1H2xcY1FEz8LvzCO72LmeQjeJz2gWkZGJ4rd5Qk0/g/uhTwwvuYEEMn1C/Ef
        H31KKnjqWl3/o
X-Received: by 2002:a5d:5490:: with SMTP id h16mr21746589wrv.394.1592847854723;
        Mon, 22 Jun 2020 10:44:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPrD6Ff1ilaZ+qwwEhsnn6mYnUJrvi16GSBdAZeRtJI+pOzC5If0f8NPf0g4z3Fa7SSYobFw==
X-Received: by 2002:a5d:5490:: with SMTP id h16mr21746567wrv.394.1592847854520;
        Mon, 22 Jun 2020 10:44:14 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id g3sm21095560wrb.46.2020.06.22.10.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 10:44:14 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 0/4] nVMX: 5-level nested EPT support
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
References: <20200207174244.6590-1-sean.j.christopherson@intel.com>
 <20200622174208.GF5150@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <589c310d-35ac-b926-bbf9-66a43aadc937@redhat.com>
Date:   Mon, 22 Jun 2020 19:44:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200622174208.GF5150@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/20 19:42, Sean Christopherson wrote:
> Ping.  These still apply cleanly on master and are required to get unit
> tests passing on systems with 5-level paging.
> 
> On Fri, Feb 07, 2020 at 09:42:40AM -0800, Sean Christopherson wrote:
>> Add support for 5-level nested EPT and clean up the test for
>> MSR_IA32_VMX_EPT_VPID_CAP in the process.
>>
>> Sean Christopherson (4):
>>   nVMX: Extend EPTP test to allow 5-level EPT
>>   nVMX: Refactor the EPT/VPID MSR cap check to make it readable
>>   nVMX: Mark bit 39 of MSR_IA32_VMX_EPT_VPID_CAP as reserved
>>   nVMX: Extend EPT cap MSR test to allow 5-level EPT
>>
>>  x86/vmx.c       | 21 ++++++++++++++++++++-
>>  x86/vmx.h       |  4 +++-
>>  x86/vmx_tests.c | 12 ++++++++----
>>  3 files changed, 31 insertions(+), 6 deletions(-)
>>
>> -- 
>> 2.24.1
>>
> 

Applied, thanks.

Paolo

