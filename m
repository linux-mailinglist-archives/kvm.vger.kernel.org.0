Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285B13E0B02
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 01:53:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbhHDXxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 19:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234005AbhHDXxy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 19:53:54 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E70AC061799
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 16:53:40 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso5981344pjo.1
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 16:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=PjDXQCFJQ1b1/TW55vbzjX1inuaNudqEamanHyRcrzw=;
        b=Xz1MC0yU7hbxCLBST7ioS/2z+mGi4178sVS6bpxkdvUJTP3mJH9g6PXPTVvBHdURxR
         4hz1IdaVs6AJc7PcJatSlUta/Hhi72UosBuLnHpuWPC0qFlieKFDPCJ6aAFQe5F1xbzb
         j930NnfEnPU2pqRTfAXFgahDZ25YLMrvdzfQdiCVMTkHCSmtpIFM5Nm5zDrG5kiy9QNu
         Vp7pBMMu0VLuuCSDGyUW365GfDx8dEQ4nAziagcWdhi9BfLO+AAj0vKxAElK8ZguASA4
         Co/w8aObrDHiR42SS0n/k9fnvc7Gk5eBVCss3EEkHTXOdmPy2kH2R1786wXNSHqKdYBS
         xd+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=PjDXQCFJQ1b1/TW55vbzjX1inuaNudqEamanHyRcrzw=;
        b=StxKdtlQxEe9sMIGgb89vdZAe3odN97Rqjzr5DLtUrQ3RchGxUoh95bnNpAaU2c4P7
         c55A+a8hqYfj52vnsdeLFuDLTBk92TL7XsTZ5HkfetdHDJ7jPeXg5R3/EQvKSotaaSyr
         BO5adTISRI1FFnr11FbwpaHyEnKDwldWHI8nIGl15AqEs/ixpiijXJ17/zXkMU+461BP
         6HMu7nCdsXa45kxnxV3/Xzr+cvrhSP5T3uut/eRky2B0be+RooQU4ufL8W10Qq0c/bDm
         QiWaVSUMpVGtiBO+7Z7/bm5DDjM8rHaJBIMyu05uBDFwQt9Q/tIIu/lRzmhnEiQtBOtl
         4tDA==
X-Gm-Message-State: AOAM532A1qiAOfR4MrQcSoA1x4PbKFbnIzWe3DL3m2N4JlxdXkJq1m2a
        7Y7zv2nUMdRrP6MZjkdN7vmcIA==
X-Google-Smtp-Source: ABdhPJy2LyRCOkEuJQooU7DbiO5x4Of4EE/mTkmyt0xCmPseJYdFtOccV9FLaz6IH5ym3qewhBVzUA==
X-Received: by 2002:aa7:93c5:0:b029:3b6:cb47:30a4 with SMTP id y5-20020aa793c50000b02903b6cb4730a4mr1821702pff.53.1628121219843;
        Wed, 04 Aug 2021 16:53:39 -0700 (PDT)
Received: from [192.168.10.153] (219-90-184-65.ip.adam.com.au. [219.90.184.65])
        by smtp.gmail.com with UTF8SMTPSA id p20sm7107277pju.48.2021.08.04.16.53.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Aug 2021 16:53:39 -0700 (PDT)
Message-ID: <f360885d-1f4e-a6e8-5a0b-dec31fd0075f@ozlabs.ru>
Date:   Thu, 5 Aug 2021 09:53:35 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:90.0) Gecko/20100101
 Thunderbird/90.0
Subject: Re: [PATCH] KVM: Do not leak memory for duplicate debugfs directories
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20210804093737.2536206-1-pbonzini@redhat.com>
 <05ade6a2-2eb4-89c2-7c6e-651c8c53c6f6@ozlabs.ru>
In-Reply-To: <05ade6a2-2eb4-89c2-7c6e-651c8c53c6f6@ozlabs.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/08/2021 09:32, Alexey Kardashevskiy wrote:
> 
> 
> On 04/08/2021 19:37, Paolo Bonzini wrote:
>> KVM creates a debugfs directory for each VM in order to store statistics
>> about the virtual machine.  The directory name is built from the process
>> pid and a VM fd.  While generally unique, it is possible to keep a
>> file descriptor alive in a way that causes duplicate directories, which
>> manifests as these messages:
>>
>>    [  471.846235] debugfs: Directory '20245-4' with parent 'kvm' 
>> already present!
>>
>> Even though this should not happen in practice, it is more or less
>> expected in the case of KVM for testcases that call KVM_CREATE_VM and
>> close the resulting file descriptor repeatedly and in parallel.
>>
>> When this happens, debugfs_create_dir() returns an error but
>> kvm_create_vm_debugfs() goes on to allocate stat data structs which are
>> later leaked. 
> 
> Rather the already allocated srructs leak, no?
> 
>> The slow memory leak was spotted by syzkaller, where it
>> caused OOM reports.
> 
> I gave it a try and almost replied with "tested-by" but after running it 
> over night I got 1 of these with followed OOM:
> 
> [ 1104.951394][  T544] debugfs: Directory '544-4' with parent 'kvm' 
> already present!
> [ 1104.951600][  T544] Failed to create 544-4
> 
> This is definitely an improvement as this used to happen a few times 
> every hour but still puzzling :-/


ah rats, I was running a wrong kernel, retrying now. sorry for the noise.


-- 
Alexey
